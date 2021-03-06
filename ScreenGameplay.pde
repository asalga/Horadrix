/*
    This screen is the main gameplay screen.
*/
public class ScreenGameplay extends IScreen implements Subject{
  
  ArrayList<LayerObserver> layerObserver;

  PImage bk;
  PImage bk2;

  PImage shaderTexture;
  PShader backgroundShader;
  
  // time it takes for the tokens above the ones that were destroyed to start falling down.
  private float DELAY_PAUSE = 2.5f; //0.035f; 
  
  // Only for debugging to see which token would be selected
  // by the player.
  public boolean drawBoxUnderCursor;
  
  Debugger debug;
  
  Ticker levelCountDownTimer;
  Ticker timer;
  
  private int tokensDestroyed = 0;
  
  private boolean isPaused = false;
  
  private int gemsWonByPlayer = 0;
  private int gemsRequiredForLevel;

  private boolean allowInputWhenTokensFalling;
  
  private BoardModel boardModel;
  
  // This is immediately incremented in the ctor by calling goToNextLevel().
  int currLevel = 0;
  
  // User can only be in the process of swapping two tokens
  // at any given time.
  Token swapToken1 = null;
  Token swapToken2 = null;
  
  Token currToken1 = null;
  Token currToken2 = null;
  
  int score = 0;
  
  private float opacity = 0.0;

  /**
  */
  public void addObserver(LayerObserver o){
    layerObserver.add(o);
    // recalculate indices
  }
  
  /*
  */
  public void removeObserver(LayerObserver o){
    // recalc?
  }
  
  /*
  */
  public void notifyObservers(){
    for(int i = 0; i < layerObserver.size(); i++){
      layerObserver.get(i).notifyObserver();
    }
  }

  /*
  */
  public void setAllowInputWhenTokensFalling(boolean b){
    allowInputWhenTokensFalling = b;
  }

  /*
  */
  ScreenGameplay(){
    timer = new Ticker();

    allowInputWhenTokensFalling = true;
    
    LayerObserver hudLayer = new HUDLayer(this);
    
    gemsRequiredForLevel = gemsRequired[0];
    
    //PImage tex1 = loadImage("../ref/arch.png");
    shaderTexture = loadImage("data/images/background/space1.png");
    backgroundShader = loadShader("data/shaders/plane_deformation.frag","data/shaders/plane_deformation.vert");

    bk =  loadImage("data/images/boards/board.png");
    //bk2 = loadImage("data/images/background/background.png");
    bk2 = loadImage("data/images/boards/board_tightlypacked.png");
    
    //
    layerObserver = new ArrayList<LayerObserver>();
    addObserver(hudLayer);
    
    /*Layer bkLayer = new BackgroundLayer();
    layers.add(bkLayer);
    
    Layer hudLayer = new HUDLayer();
    observers.add(hudLayer);*/

    Keyboard.lockKeys(new int[]{KEY_M});

    boardModel = new BoardModel();
    boardModel.setNumGemsAllowedAtOnce(2);
    
    debug = new Debugger();
   
    // lock P for pause
    Keyboard.lockKeys(new int[]{KEY_P});
    
    drawBoxUnderCursor = false;
    
    deselectCurrentTokens();
    
    // levelCountDownTimer is set in this method.
    goToNextLevel();
  }
  
  /*
  */
  public void draw(){

    background(0);

    // 
    if(using3DMode){
      shader(backgroundShader);

      backgroundShader.set("width", (float)CANVAS_WIDTH);
      backgroundShader.set("height", (float)CANVAS_HEIGHT);
      
      backgroundShader.set("iChannel0", shaderTexture);
      backgroundShader.set("time", frameCount/100.0);

      //textureMode(NORMAL);
      //noStroke();
      beginShape();
      vertex(0, 0);
      vertex(width, 0);
      vertex(width, height);
      vertex(0, height);
      endShape();

      resetShader();
    }

    // Breaks HUD
    /*tint(opacity);
    opacity += 1.0f;
    if(opacity > 255){
      opacity = 255;
    }*/
    
    pushMatrix();
    translate(START_X, START_Y);
    
    //rect(0,0, BOARD_W_IN_PX, BOARD_H_IN_PX);
    
    // Draw the board background image
    pushStyle();
    imageMode(CORNER);
    // Offset the image slighly so that it lines up with the grid of tokens.
    //image(bk, -13, -16);//for diablo board
    
    image(bk2, 0, 0);
    popStyle();
    
    // Draw the debug board with gridlines
    //pushMatrix();
    //translate(0, 300);
    //fill(33,66,99,100);
    //strokeWeight(1);
    //rect(START_X, START_Y, BOARD_W_IN_PX, BOARD_H_IN_PX);
    //rect(0, 0, BOARD_W_IN_PX, BOARD_H_IN_PX);
    //popMatrix();
    
    ArrayList<Token> dyingTokens = boardModel.getDyingTokens();
    // The dying tokens shrink and the falling tokens get rendered on top of them.
    for(int i = 0; i < dyingTokens.size(); i++){
      dyingTokens.get(i).draw();
    }
    
    if(swapToken1 != null){
      swapToken1.draw();
    }
    if(swapToken2 != null){
      swapToken2.draw();
    }

    BoardModel.Iterator iter = boardModel.getIterator();
    while(iter.next()){
      iter.item().draw();
    }
    
    // In some cases it is necessary to see the non-visible tokens
    // above the visible board. Other cases, I want that part covered.
    // for example, when tokens are falling.
    if(DEBUG_ON == false){
      pushStyle();
      rectMode(CORNER);
      fill(0);
      noStroke();
      rect(0, -100, 260, 100);
      //rect(START_X-150, -237, 250, 222);
      popStyle();
    }
    
    popMatrix();
    
    // HACK: This line is here as a workaround a bug in Processing.js
    // If removed, the board would translate diagonally on the canvas.
    // when tokens are removed.
    if(usingPjs){
      resetMatrix();
    }
    
    if(layerObserver != null){
      for(int i = 0; i < layerObserver.size(); i++){
        layerObserver.get(i).draw();
      }
    }

    //debug.addString("FPS: " + frameRate);
    
    debug.draw();
  }
  
  /**
   */
  public void update(){
    //}
    //public void fuckyou(){
    // TODO: fix
    // Need to notify that we are paused so the HUD can draw an overlay
    if(isPaused){
      notifyObservers();
      return;
    }
    
    // INSTANT DEATH - for some reason, can't set it to 1 second
    if(Keyboard.isKeyDown(KEY_I)){
      //levelCountDownTimer.setTime(0, 3);
      //gemsWonByPlayer = 50;
    }
    
    // NEW BOARD
    if(Keyboard.isKeyDown(KEY_N)){
      // Generating a new board while swapping is unlikely, but prevent it anyway, just in case.
      if(boardModel.getDyingTokens().size() == 0 && swapToken1 == null && swapToken2 == null){
        boardModel.generateNewBoardWithDyingAnimation(true);
      }
    }
        
    timer.tick();
    float td = timer.getDeltaSec();
    
    // Once the player meets their quota...
    if(gemsWonByPlayer >= gemsRequiredForLevel && boardModel.hasMovement() == false){
      gemsWonByPlayer = 0;
      
      if(currLevel < NUM_LEVELS){
        goToNextLevel();
      }
      else{
        screens.transitionTo("win");
      }
    }
        
    debug.clear();
    
    if(levelCountDownTimer != null){
      levelCountDownTimer.tick();
    }
        
    // Now, update the two tokens that the user has swapped
    if(swapToken1 != null){
      swapToken1.update(td);
      swapToken2.update(td);
      
      if(swapToken1.arrivedAtDest() && swapToken1.isReturning() == false && swapToken1.isMoving()){
        //
        // Need to drop into the cells before check if it was indeed a valid swap
        swapToken1.dropIntoCell();
        boardModel.setToken(swapToken1.getRow(), swapToken1.getColumn(), swapToken1);

        swapToken2.dropIntoCell();
        boardModel.setToken(swapToken2.getRow(), swapToken2.getColumn(), swapToken2);
        
        int matches = boardModel.getNumCosecutiveMatches(swapToken1, swapToken2);
        
        // If it was not a valid swap, animate it back from where it came.
        if(matches < 3){          
          int r1 = swapToken1.getRow();
          int c1 = swapToken1.getColumn();
          
          int r2 = swapToken2.getRow();
          int c2 = swapToken2.getColumn();
          
          swapToken1.swapTo(r2, c2);
          swapToken2.swapTo(r1, c1);
          
          swapToken1.setReturning(true);
          swapToken2.setReturning(true);
          
          soundManager.playFailSwapSound();
        }
        // Swap was valid
        else{
          swapToken1 = swapToken2 = null;

          int test = boardModel.markTokensForRemoval(8, 15);
          
          boardModel.removeMarkedTokens(true);
          soundManager.playMatchSound();

          boardModel.dropTokens();
          deselectCurrentTokens();
          
          //soundManager.playSuccessSwapSound();
        } 
      }
      // 
      else if(swapToken1.arrivedAtDest() && swapToken1.isReturning()){
        
        swapToken1.dropIntoCell();
        boardModel.setToken(swapToken1.getRow(), swapToken1.getColumn(), swapToken1);

        swapToken2.dropIntoCell();
        boardModel.setToken(swapToken2.getRow(), swapToken2.getColumn(), swapToken2);

        swapToken1.setReturning(false);
        swapToken2.setReturning(false);
        
        swapToken1 = swapToken2 = null;
      }
    }
    

    ArrayList<Token> dyingTokens = boardModel.getDyingTokens();
    // TODO: refactor?
    // Iterate over all the tokens that are dying and increase the score.
    for(int i = 0; i < dyingTokens.size(); i++){
      
      Token dyingToken = dyingTokens.get(i);
      
      dyingToken.update(td);
      
      if(dyingToken.isAlive() == false){
        
        if(dyingToken.hasGem()){
          gemsWonByPlayer++;
          boardModel.reduceGemCount(1);
        }
        
        addToScore(dyingToken.getScore());
        
        dyingTokens.remove(i);
        tokensDestroyed++;
      }
    }
    
    boardModel.update(td);
    
    // Probably the most logical place to ensure the number of gems on the board is right here
    // Doing it on level start is actually tricker, since the only tokens that exist are the ones at the top
    // that are faling down.
    if(tokensDestroyed > 0){
      //addGemsToQueuedTokens();
      boardModel.ensureGemCount();
    }

    if(usingPjs){
      resetMatrix();
    }
    
    // Add a leading zero if seconds is a single digit
    String secStr = "";
    
    int seconds = (int)levelCountDownTimer.getTotalTime() % 60;
    
    // 
    if((int)levelCountDownTimer.getTotalTime() == 0){
      screens.transitionTo("gameover");
    }
    
    if(seconds <= 9){
      secStr  = Utils.prependStringWithString( "" + seconds, "0", 2);
    }
    else{
      secStr = "" + seconds;
    }
    
    notifyObservers();
  }
  
  public String getName(){
    return "gameplay";
  }
  
  public int getRowIndex(){
    return (int)map(mouseY, START_Y, START_Y + BOARD_H_IN_PX, START_ROW_INDEX, BOARD_ROWS);
  }
  
  public int getColumnIndex(){
    return (int)map(mouseX, START_X, START_X + BOARD_W_IN_PX, 0, BOARD_COLS);
  }
    
  /*
   *
   */
  public void mousePressed(){
    
    if(isPaused){
      return;
    }

    // 
    if(allowInputWhenTokensFalling == false && boardModel.hasMovement()){
      return;
    }
  
    // convert the mouse coords to grid coordinates
    int r = getRowIndex();
    int c = getColumnIndex();
    
    // We can get some wacky values when clicking outside of the
    // board. If the player does that, just ignore the click.
    if( r >= BOARD_ROWS || c >= BOARD_COLS || r < 0 || c < 0){
      return;
    }
    
    // Prevent the user from trying to swap with anything else until
    // the last swap animation is done. This prevents the user from
    // trying to swap with a token that's already being swapped.
    if(swapToken1 != null && swapToken2 != null){
      return;
    }
    
    // Player hasn't selected the first token yet.
    if(currToken1 == null){
      currToken1 = boardModel.getToken(r, c);
      
      // If the token the player selected is actually null (an empty cell) or is 
      // actually falling down, then back out.
      if(currToken1.canBeSwapped() == false){
        currToken1 = null;
        return;
      }
      
      currToken1.setSelect(true);
      return;
    }
        
    // The real work is done once we know what to swap with.
    if(currToken2 == null){
      
      currToken2 = boardModel.getToken(r, c);
      
      // Same as a few lines above.
      if(currToken2.canBeSwapped() == false){
        currToken2 = null;
        return;
      }
      
      // User clicked on a token that's too far to swap with the one already selected
      // In that case, what they are probably doing is starting the 'swap process' over.
      if( boardModel.isCloseEnoughForSwap(currToken1, currToken2) == false){
        currToken1.setSelect(false);
        currToken1 = currToken2;
        currToken1.setSelect(true);  
        currToken2 = null;
      }
      else{
        animateSwapTokens(currToken1, currToken2);
      }
    }
  }
  
  /**
   * To swap tokens, players will click/tap a token then drag to the token
   * they want to swap with.
   */
  public void mouseDragged(){
    
    // convert the mouse coords to grid coordinates
    int r = getRowIndex();
    int c = getColumnIndex();
    
    if( r >= BOARD_ROWS || c >= BOARD_COLS || r < 0 || c < 0){
      return;
    }
    
    // Player have had to select the first token before dragging.
    if(currToken1 != null && currToken2 == null){
  
      //    
      if(c != currToken1.getColumn() || r != currToken1.getRow()){
        currToken2 = boardModel.getToken(r, c);
        
        // If they dragged to an empty cell, we have to back out.
        if(currToken2.canBeSwapped() == false){
          currToken2 = null;
          return;
        }
                
        if(boardModel.isCloseEnoughForSwap(currToken1, currToken2) == false){
           currToken2 = null;
        }
        else{
          animateSwapTokens(currToken1, currToken2);
        }
      }
    }
  }
  
  public int getScore(){
    return score;
  }
  
  public int getLevelTimeLeft(){
    return (int)levelCountDownTimer.getTotalTime();
  }
  
  public int getLevel(){
    return currLevel;
  }
  
  /*
    As soon as a token is removed, we add to the score.
  */
  public void addToScore(int offset){
    score += offset;
    notifyObservers();
  }
  
  /*
   * 
   */
  void animateSwapTokens(Token t1, Token t2){
    int t1Row = t1.getRow();
    int t1Col = t1.getColumn();
    
    int t2Row = t2.getRow();
    int t2Col = t2.getColumn();
    
    swapToken1 = t1;
    swapToken2 = t2;
    
    swapToken1.swapTo(t2Row, t2Col);
    swapToken2.swapTo(t1Row, t1Col);
    
    deselectCurrentTokens();
  }
  
  /*
    
  */
  public void deselectCurrentTokens(){
    if(currToken1 != null) currToken1.setSelect(false);
    if(currToken2 != null) currToken2.setSelect(false);
    currToken1 = null;
    currToken2 = null;
  }
  
  /*
  */
  void keyPressed(){
    Keyboard.setKeyDown(keyCode, true);
    
    // P key is locked
    isPaused = Keyboard.isKeyDown(KEY_P);
    if(isPaused){
      timer.pause();
      levelCountDownTimer.pause();
    }
    
    if(Keyboard.isKeyDown(KEY_L)){
      //gemsWonByPlayer = 50;
      soundManager.playMatchSound();
      //goToNextLevel();
    }

    if(Keyboard.isKeyDown(KEY_M)){
      soundManager.setMute(!soundManager.isMuted());
    }

    if(Keyboard.isKeyDown(KEY_S)){
      //if(currToken1 != null){
      //  currToken1.setHasGem(true);
        //setType(6);
      //}
      soundManager.playFailSwapSound();
    }
  }
  
  /**
  */
  void keyReleased(){
    Keyboard.setKeyDown(keyCode, false);

    isPaused = Keyboard.isKeyDown(KEY_P);
    if(isPaused == false){
      timer.resume();
      levelCountDownTimer.resume();
    }
  }

  public int getNumGems(){
    return gemsWonByPlayer;
  }

  /**
  */
  public boolean Paused(){
    return isPaused;
  }

  /**
  */
  public int getNumGemsForNextLevel(){
    return gemsRequiredForLevel;
  }
  
  /*
      The user can only go to the next level if they have
      destroyed the number stored in gemsRequiredForLevel.
      
      When the player goes to the next level, the user is given:
      - A bit more time than the previous level
      - Greater number of gems on board at a given time
      - Sometimes the number of gem types increase
  */
  void goToNextLevel(){    
    screenStory.nextLevel();
    screens.transitionTo("story");
  }
  
  /*
      Need to clear off all the crap that was happeneing in the last level.
  */
  public void OnTransitionTo(){
    currLevel++;
    tokensDestroyed = 0;
    
    //dyingTokens.clear();
    
    // Should the score be reset?
    // score = 0;
    gemsWonByPlayer = 0;
    gemsRequiredForLevel = gemsRequired[currLevel-1];
    
    // Still playing around with this to make later levels challenging.
    levelCountDownTimer = new Ticker();
    levelCountDownTimer.setTime(timePermitted[currLevel-1]);
    levelCountDownTimer.setDirection(-1);
    
    timer = new Ticker();

    if(currLevel == 4){
      numTokenTypesOnBoard++;
    }

    // Easy way to clear the dying tokens which we don't want animating in the next level.
    boardModel = new BoardModel();
    boardModel.setNumGemsAllowedAtOnce(2);
    
    boardModel.generateNewBoardWithDyingAnimation(false);
  }
}