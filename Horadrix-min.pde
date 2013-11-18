/**
*/
public class ScreenSet{
  
  private ArrayList<IScreen> screens;
  public IScreen curr;
  
  public ScreenSet(){
    screens = new ArrayList<IScreen>();
    curr = null;
  }
  
  public void add(IScreen s){
    screens.add(s);
    if(curr == null){
      curr = s;
    }
  }
  
  public void setCurr(IScreen s){
    curr = s;
  }
  
  /**
      TODO: add awesome transition effect
  */
  public void transitionTo(String s){
    for(int i = 0; i < screens.size(); i++){
      if(s == screens.get(i).getName()){
        curr = screens.get(i);
        curr.OnTransitionTo();
        break;
      }
    }
  }
}
/*
*
*/
public class ScreenWin implements IScreen{

  Ticker ticker;
  
  RetroFont solarWindsFont;

  RetroLabel title;
  RetroLabel win;
  
  public ScreenWin(){
    ticker = new Ticker();
    
    // TODO: convert this to a singleton or factory.
    solarWindsFont = new RetroFont("data/fonts/solarwinds.png", 14, 16, 2);
    
    title = new RetroLabel(solarWindsFont);
    title.setText("YOU HAVE WON!");
    title.pixelsFromTop(0);
    
    win = new RetroLabel(solarWindsFont);
    win.setHorizontalTrimming(true);
    win.setText("You have won the game, yay!");
    win.pixelsFromCenter(0, 0);
  }
  
  public void OnTransitionTo(){
  }

  /**
  */
  public void draw(){
    background(0);
    
    title.draw();
    win.draw();
  }
  
  public void update(){
    ticker.tick();
  }
  
  public String getName(){
    return "win";
  }
  
  public void keyReleased(){}
  public void keyPressed(){}
  
  public void mousePressed(){}
  public void mouseReleased(){}
  public void mouseDragged(){}
  public void mouseMoved(){}
}
/*
*/
public class Stack<T>{
  
  private ArrayList<T> items;
  
  public Stack(){
    items = new ArrayList<T>();
  }
  
  public void pop(){
    items.remove(items.size() - 1);
  }
  
  public T top(){
    return items.get(items.size() - 1);
  }
  
  public void push(T item){
    items.add(item);
  }
  
  public boolean isEmpty(){
    return items.isEmpty();
  }
  
  public int size(){
    return items.size();
  }
  
  public void clear(){
    items.clear();
  }
}
/*  
*/
public class ScreenStory implements IScreen{
  
    public void OnTransitionTo(){
  }

  private int storyPointer = 0;
  
  RetroFont solarWindsFont;

  RetroLabel storyLabel;
  RetroLabel continueInstruction;
  
  public ScreenStory(){
   solarWindsFont = new RetroFont("data/fonts/solarwinds.png", 14, 16, 2);
   
   storyLabel = new RetroLabel(solarWindsFont);
   //storyLabel.setText(story[storyPointer]);
   storyLabel.pixelsFromCenter(0, 0);
   storyLabel.setDebug(false);
   
   continueInstruction = new RetroLabel(solarWindsFont);
   continueInstruction.setText("Click to continue");
   continueInstruction.pixelsFromCenter(0, 50);
 }
  
  public void draw(){
    background(0);
    storyLabel.draw();
    continueInstruction.draw();
  }
  
  public void update(){
    
  }
  
  // Mouse methods
  public void mousePressed(){}
  public void mouseReleased(){
    if(storyPointer < NUM_LEVELS){
      screens.transitionTo("gameplay");
    }
    else{
      screens.transitionTo("win");
    }
  }
  public void mouseDragged(){}
  public void mouseMoved(){}
  
  public void keyPressed(){}
  public void keyReleased(){}
  
  public String getName(){
    return "story";
  }
  
  public void nextLevel(){
    storyLabel.setText("MATCH " + gemsRequired[storyPointer] + " SPECIAL GEMS IN " + (int)timePermitted[storyPointer] + " MINUTES");
    storyPointer++;
  }
}
/*
  Not currently being used yet.
*/
public class Queue<T>{
  private ArrayList<T> items;
  
  public Queue(){
    items = new ArrayList<T>();
  }

  public void pushBack(T i){
    items.add(i);
  }
 
  public T popFront(){
    T item = items.get(0);
    items.remove(0);
    return item;
  }
  
  public boolean isEmpty(){
    return items.isEmpty();
  }
  
  public int size(){
    return items.size();
  }
  
  public T peekFront(){
    return items.get(0);
  }
  
  public void clear(){
    items.clear();
  }
}
/*
    Displays game name and credits
*/
public class ScreenGameOver implements IScreen{
  
  RetroFont solarWindsFont;

  RetroLabel gameOverLabel;
  RetroLabel retryLabel;
  
  public void OnTransitionTo(){
  }
  
  public ScreenGameOver(){
    
    // TODO: convert this to a singleton or factory.
    solarWindsFont = new RetroFont("data/fonts/solarwinds.png", 14, 16, 2);
    
    gameOverLabel = new RetroLabel(solarWindsFont);
    gameOverLabel.setText("G A M E  O V E R");
    gameOverLabel.pixelsFromCenter(0, 0);
    
    retryLabel = new RetroLabel(solarWindsFont);
    retryLabel.setText("<< Retry? >>");
    retryLabel.pixelsFromCenter(0, 50);
  }
  
  /**
  */
  public void draw(){
    background(0);
    gameOverLabel.draw();
    retryLabel.draw();
  }
  
  public void update(){
  }
  
  public String getName(){
    return "gameover";
  }

  public void keyReleased(){}
  public void keyPressed(){}
  
  public void mousePressed(){
    screens.setCurr(new ScreenGameplay());
  }
  
  public void mouseReleased(){}
  public void mouseDragged(){}
  public void mouseMoved(){}
}
/*
    Shows the score, level on top of the gameplay screen.
*/
public class HUDLayer implements LayerObserver{
  
  RetroPanel parent;
  boolean p = false;
  
  RetroLabel scoreLabel;
  RetroLabel levelLabel;
  RetroLabel timeLabel;
  RetroLabel gemsAcquired;
  RetroLabel FPS;
  RetroLabel pausedLabel;
  
  RetroFont solarWindsFont;
  ScreenGameplay screenGameplay;
  
  public HUDLayer(ScreenGameplay s){
    screenGameplay = s;
    
    // Add a bit of a border between the edge of the canvas for aesthetics
    parent = new RetroPanel(10, 10, width - 20, height - 20);
    parent.setDebug(false);
    
    solarWindsFont = new RetroFont("data/fonts/solarwinds.png", 7*2, 8*2, 1*2);
    
    // Position of panel isn't being set correctly.
    RetroPanel scorePanel = new RetroPanel(10, 10, 100, 20);
    scorePanel.pixelsFromTop(10);
    
    // Score
    scoreLabel = new RetroLabel(solarWindsFont);
    scoreLabel.setHorizontalTrimming(false);
    scoreLabel.setHorizontalSpacing(1);
    scoreLabel.pixelsFromTopRight(0, 0);
    scorePanel.addWidget(scoreLabel);
    parent.addWidget(scorePanel);
    
    // 
    pausedLabel = new RetroLabel(solarWindsFont);
    pausedLabel.setHorizontalTrimming(false);
    pausedLabel.setHorizontalSpacing(5);
    pausedLabel.setText("PAUSED");
    pausedLabel.pixelsFromCenter(0, 0);
    pausedLabel.setVisible(false);
    parent.addWidget(pausedLabel);
    
    // Gems
    gemsAcquired = new RetroLabel(solarWindsFont);
    gemsAcquired.setHorizontalTrimming(true);
    gemsAcquired.setHorizontalSpacing(2);
    gemsAcquired.pixelsFromRight(1);
    parent.addWidget(gemsAcquired);
    
    // Time
    timeLabel = new RetroLabel(solarWindsFont);
    timeLabel.setHorizontalTrimming(true);
    timeLabel.setHorizontalSpacing(2);
    timeLabel.pixelsFromTopLeft(75, 5);
    parent.addWidget(timeLabel);
    
    // Level
    levelLabel = new RetroLabel(solarWindsFont);
    levelLabel.setHorizontalTrimming(true);
    levelLabel.pixelsFromTopLeft(60, 5);
    parent.addWidget(levelLabel);
    
    // FPS
    FPS = new RetroLabel(solarWindsFont);
    FPS.pixelsFromBottomLeft(0, 0);
    FPS.setHorizontalTrimming(true);

    parent.addWidget(FPS);
  }
  
  public void draw(){
    pausedLabel.setVisible(p);
    
    if(p){
      pushStyle();
      rectMode(CORNERS);
      fill(128,128);
      rect(0, 0, width, height);
      popStyle();
    }
    
    parent.draw();
  }
  
  /*
  */
  public void notifyObserver(){
    String scoreStr = Utils.prependStringWithString("" + screenGameplay.getScore(), "0", 8);
    
    int min = Utils.floatToInt(screenGameplay.getLevelTimeLeft() / 60);
    int sec = screenGameplay.getLevelTimeLeft() % 60;
    
    if(DEBUG_ON){
      FPS.setText("FPS: " + (int)frameRate);
    }
    
    scoreLabel.setText("" + scoreStr);
    levelLabel.setText("Level:" + screenGameplay.getLevel());
    timeLabel.setText("TIME: " + min + ":" +  (sec < 10 ? "0" : "") + sec);
    gemsAcquired.setText("Gems: " + screenGameplay.getNumGems() + "/" + screenGameplay.getNumGemsForNextLevel());
    
    p = screenGameplay.Paused();
  }
  
  public void update(){
  }
  
  public void setZIndex(int zIndex){
  }
}

/*
    
*/
public interface IScreen{
  
  public void draw();
  public void update();
  
  // Mouse methods
  public void mousePressed();
  public void mouseReleased();
  public void mouseDragged();
  public void mouseMoved();
  
  public void keyPressed();
  public void keyReleased();
  public void OnTransitionTo();
  
  public String getName();
}
/*   
*/
public interface Subject{
  public void addObserver(LayerObserver o);
  public void removeObserver(LayerObserver o);
  public void notifyObservers();
}
/*
    A screen can have many layers associated with it. Layers are rendered
    from smaller indices to larger.
 */
public interface LayerObserver{
  public void draw();
  public void update();
 // public void setZIndex(int zIndex);
  
  //
  public void notifyObserver();
}
/*
TODO: add rotation



*/
public class SpriteSheetLoader{

  PImage test;
  HashMap map;
  
  public  void load(String texturePackerMetaFile){
    
    
    
    
    
   /* JSONObject json;
    
    json = loadJSONObject(texturePackerMetaFile);
    
    String imageFilename = json.getJSONObject("meta").getString("image");
   // print(imageFilename); 
    
    PImage texture = loadImage(imageFilename);
    
    JSONArray frames = json.getJSONArray("frames");
    
    map = new HashMap<String, PImage>(frames.size());    
    
    //println(frames.size());
    
    // Iterate over all the sprites in the json file
    for(int i = 0; i < frames.size(); i++){
      
      //
      JSONObject frame = frames.getJSONObject(i);
      
      
      // Regardless of whether the sprite is rotated or not, it's final dimensions
      // can be extracted from sourceSize.
      JSONObject sourceSize = frame.getJSONObject("sourceSize");
      int dstSpriteWidth  = sourceSize.getInt("w");
      int dstSpriteHeight = sourceSize.getInt("h");
      PImage img = createImage(dstSpriteWidth, dstSpriteHeight, ARGB);
      println("Created image: (" + dstSpriteWidth + "," + dstSpriteHeight + ")");
      
      // Pull the actual sprite from the sheet
      JSONObject dimensions = frame.getJSONObject("frame");
      int srcStartX = dimensions.getInt("x");
      int srcStartY = dimensions.getInt("y");
      int srcWidth = dimensions.getInt("w");
      int srcHeight = dimensions.getInt("h");
      
      // This is actually our destination, where we copy the pixels into the image.
      JSONObject spriteSourceSize = frame.getJSONObject("spriteSourceSize");
      int dstStartX = spriteSourceSize.getInt("x");
      int dstStartY = spriteSourceSize.getInt("y");
      int dw = spriteSourceSize.getInt("w");
      int dh = spriteSourceSize.getInt("h");
      
      //println("dw: " + dw);
      //println("dh: " + dh);
      
     // println("dstSpriteWidth: " + dstSpriteWidth);
      //println("dstSpriteHeight: " + dstSpriteHeight);
      
      // If the sprite isn't rotated, our logic is much simpler so we break up the cases.
      if(frame.getBoolean("rotated")){
        println("sprite is rotated");
        
        // Going to copy the pixels starting from the sprite in the sheet
        // upper left corner downwards moving left to right

        // inverted for src
        //int dstWidth = 400;
       // int dstHeight = 324;
        
        // We only need to copy the trimmed part
        int pixelsCopied = 0;
        int pixelsToCopy = srcWidth * srcHeight;
        
        int srcX = srcStartX;
        int srcY = srcStartY;
       
        int dstX = dstStartX;
        int dstY = dh - 1;
        
        //println(dw);
        int srcRotHeight = srcWidth;
        //println(srcRotHeight);

        
        for( ;pixelsCopied < pixelsToCopy; pixelsCopied++, dstX++, srcY++){

          //
         if(srcY == srcRotHeight + srcStartY){
           srcY = srcStartY;
           srcX++;
           
           dstX = dstStartX;
           dstY--;
         }
        // println(dstY*dw+dstX);
         
         color c = texture.pixels[srcY * texture.width + srcX];
           
          //
          img.pixels[dstY * dstSpriteWidth + dstX] = c;
        }
        
        img.updatePixels();
  
        map.put(frame.getString("filename"), img);
      }
      else{
        println("sprite is not rotated");
        // Copy from the sprite sheet to our individual sprite
        // potentially not touching the transparent pixels that border the sprite.
        img.copy(texture, srcStartX, srcStartY, srcWidth, srcHeight, dstStartX, dstStartY, dw, dh);
        map.put(frame.getString("filename"), img);
      }
    }*/
  }
  
  public PImage get(String sprite){
    return (PImage)map.get(sprite);
  }
}
/*
    This screen is the main gameplay screen.
*/
public class ScreenGameplay implements IScreen, Subject{
  
  // Tokens that have been remove from the board, but still need to be rendered for their
  // death animation.
  ArrayList<Token> dyingTokens;
  
  ArrayList<LayerObserver> layerObserver;

  PImage bk;
  PImage bk2;
  
  // These are used to specify the direction of checking
  // matches in numMatchesSideways and numMatches
  private final int LEFT = -1;
  private final int RIGHT = 1;
  private final int UP = -1;
  private final int DOWN = 1;
  
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
  private int numGemsAllowedAtOnce = 2;
  private int numGemsOnBoard = 0;
  
  // This is immediately incremented in the ctor by calling goToNextLevel().
  int currLevel = 0;
  
  // User can only be in the process of swapping two tokens
  // at any given time.
  Token swapToken1 = null;
  Token swapToken2 = null;
  
  // As the levels increase, more and more token types are added
  // This makes it a slightly harder to match tokens.
  int numTokenTypesOnBoard = 4;
  
  Token currToken1 = null;
  Token currToken2 = null;
  
  int score = 0;
  
  public void addObserver(LayerObserver o){
    layerObserver.add(o);
    // recalculate indices
  }
  
  public void removeObserver(LayerObserver o){
    // recalc?
  }
  
  public void notifyObservers(){
    for(int i = 0; i < layerObserver.size(); i++){
      layerObserver.get(i).notifyObserver();
    }
  }
  
  
  /**
  */
  ScreenGameplay(){
    timer = new Ticker();
    
    LayerObserver hudLayer = new HUDLayer(this);
    
    gemsRequiredForLevel = gemsRequired[currLevel];

    dyingTokens = new ArrayList<Token>();
    
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
    
    //debugTicker = new Ticker();
    debug = new Debugger();
   
    // lock P for pause
    Keyboard.lockKeys(new int[]{KEY_P});
    
    drawBoxUnderCursor = false;
    
    fillBoardWithRandomTokens();
    deselectCurrentTokens();
    
    // levelCountDownTimer is set in this method.
    goToNextLevel();
  }
  
  /*
  */
  public void draw(){

    background(0);
    
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
        
    drawBoard();
    
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
    
    // Draw a box around the grid, just for debugging.
    //noFill();
    //stroke(255);
    //strokeWeight(1);
    //rect(0, 350, TOKEN_SIZE, 320);
    
    popMatrix();
    
    // HACK: This line is here as a workaround a bug in Processing.js
    // If removed, the board would translate diagonally on the canvas.
    // when tokens are removed.
    resetMatrix();
    
    if(layerObserver != null){
      for(int i = 0; i < layerObserver.size(); i++){
        layerObserver.get(i).draw();
      }
    }
    
    debug.draw();
  }
  
  /**
   */
  public void update(){
    
    // TODO: fix
    // Need to notify that we are paused so the HUD can draw an overlay
    if(isPaused){
      notifyObservers();
      return;
    }
    
    // INSTANT DEATH - for some reason, can't set it to 1 second
    if(Keyboard.isKeyDown(KEY_I)){
      levelCountDownTimer.setTime(0, 3);
    }
    
    // NEW BOARD
    if(Keyboard.isKeyDown(KEY_N)){
      // Generating a new board while swapping is unlikely, but prevent it anyway, just in case.
      if(dyingTokens.size() == 0 && swapToken1 == null && swapToken2 == null){
        generateNewBoardWithDyingAnimation(true);
      }
    }
    
    // DROP TOKENS
    if(Keyboard.isKeyDown(KEY_D)){
      dropTokens();
    }
        
    timer.tick();
    float td = timer.getDeltaSec();
    
    // Once the player meets their quota...
    if(gemsWonByPlayer >= gemsRequiredForLevel){
      println("gemsWonByPlayer: " + gemsWonByPlayer);
      println("gemsRequiredForLevel: " + gemsRequiredForLevel);
      
      println("going to next level");
      goToNextLevel();    
    }
        
    debug.clear();
    
    levelCountDownTimer.tick();
    
    int numTokensArrivedAtDest = 0;
        
    // Now, update the two tokens that the user has swapped
    if(swapToken1 != null){
      swapToken1.update(td);
      swapToken2.update(td);
      
      if(swapToken1.arrivedAtDest() && swapToken1.isReturning() == false && swapToken1.isMoving()){
        //
        // Need to drop into the cells before check if it was indeed a valid swap
        swapToken1.dropIntoCell();
        swapToken2.dropIntoCell();
        
        int matches = getNumCosecutiveMatches(swapToken1, swapToken2);
        
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
                
          //soundManager.playFailSwapSound();
        }
        // Swap was valid
        else{
          swapToken1 = swapToken2 = null;
          markTokensForRemoval(false);
          removeMarkedTokens(true);
          dropTokens();
          deselectCurrentTokens();
          // !!!
          //soundManager.playSuccessSwapSound();
        } 
      }
      // 
      else if(swapToken1.arrivedAtDest() && swapToken1.isReturning()){
        swapToken1.dropIntoCell();
        swapToken2.dropIntoCell();
        swapToken1.setReturning(false);
        swapToken2.setReturning(false);
        
        swapToken1 = swapToken2 = null;
      }
    }
    
    // TODO: refactor?
    // Iterate over all the tokens that are dying and increase the score.
    for(int i = 0; i < dyingTokens.size(); i++){
      
      Token dyingToken = dyingTokens.get(i);
      
      dyingToken.update(td);
      
      if(dyingToken.isAlive() == false){
        
        if(dyingToken.hasGem()){
          gemsWonByPlayer++;
          numGemsOnBoard--;
        }
        
        addToScore(dyingToken.getScore());
        
        dyingTokens.remove(i);
        tokensDestroyed++;
      }
    }
    
    if(DEBUG_ON){
      debug.addString("dyingTokens: " + dyingTokens.size());
    }
    
    // Update all tokens on board. This includes the falling tokens
    for(int r = BOARD_ROWS - 1; r >= 0 ; r--){
      for(int c = 0; c < BOARD_COLS; c++){
        Token t = board[r][c]; 
        t.update(td);
        
        if(t.isFalling() && t.arrivedAtDest()){
          t.dropIntoCell();
          numTokensArrivedAtDest++;
          
          // If the top token arrived at its destination, it means we can safely fill up tokens above it.
          if(t.getFillCellMarker()){
            fillInvisibleSectionOfColumn(t.getColumn());
            setFillMarker(t.getColumn());
          }
        }
      }
    }
    
    // Probably the most logical place to ensure the number of gems on the board is right here
    // Doing it on level start is actually tricker, since the only tokens that exist are the ones at the top
    // that are faling down.
    if(tokensDestroyed > 0){
      addGemsToQueuedTokens();
    }

    //
    if(numTokensArrivedAtDest > 0){
      markTokensForRemoval(false);
      removeMarkedTokens(true);
      dropTokens();
    }

    resetMatrix();
    
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
  
  /**
   * Tokens that are considrered too far to swap include ones that
   * are across from each other diagonally or have 1 token between them.
   */
  public boolean isCloseEnoughForSwap(Token t1, Token t2){
    // !!!
    return abs(t1.getRow() - t2.getRow()) + abs(t1.getColumn() - t2.getColumn()) == 1;
  }
    
  public void mouseMoved(){}
  public void mouseReleased(){}
  
  /*
   *
   */
  public void mousePressed(){
    
    if(isPaused){
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
      currToken1 = board[r][c];
      
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
      
      currToken2 = board[r][c];
      
      // Same as a few lines above.
      if(currToken2.canBeSwapped() == false){
        currToken2 = null;
        return;
      }
      
      // User clicked on a token that's too far to swap with the one already selected
      // In that case, what they are probably doing is starting the 'swap process' over.
      if( isCloseEnoughForSwap(currToken1, currToken2) == false){
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
        currToken2 = board[r][c];
        
        // If they dragged to an empty cell, we have to back out.
        if(currToken2.canBeSwapped() == false){
          currToken2 = null;
          return;
        }
                
        if(isCloseEnoughForSwap(currToken1, currToken2) == false){
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
  
  /**
    Speed: O(n)
    Returns true as soon as it finds a valid swap/move.
    
    Checks to see if the user can make a valid match anywhere in the visible part of the board.
    In case there are no valid swap/moves left, the board needs to be reset.
  */
  private boolean validSwapExists(){
    
    // First check any potential matches in the horizontal
    for(int r = START_ROW_INDEX; r < BOARD_ROWS; r++){
      for(int c = 0; c < BOARD_COLS - 1; c++){
        
        Token t1 = board[r][c];
        Token t2 = board[r][c + 1];
        
        swapTokens(t1, t2);
        int matches = getNumCosecutiveMatches(t1, t2);
        swapTokens(t1, t2);
        
        if(matches >= 3){
          return true;
        }
      }
    }
    
    // Check any potential matches in the vertical
    for(int c = 0; c < BOARD_COLS; c++){  
      for(int r = START_ROW_INDEX; r < BOARD_ROWS - 1; r++){
        
        Token t1 = board[r][c];
        Token t2 = board[r + 1][c];
        
        swapTokens(t1, t2);
        int matches = getNumCosecutiveMatches(t1, t2);
        swapTokens(t1, t2);
        
        if(matches >= 3){
          return true;
        }
      }
    }
    return false;
  }
  
  /*
  */
  int getRandomTokenType(){
    return Utils.getRandomInt(0, numTokenTypesOnBoard-1);
  }
  
  /*
    Find any null tokens on the board and replace them with a random token.
    
    This is used at the start of the level when trying to generate a board
    that initially has no matches.
    
    @return {int} Num holes/cells filled.
  */
  private int fillHoles(boolean forTopPart){
    int numFilled = 0;
    
    int startRow = forTopPart ? 0 : START_ROW_INDEX;
    
    for(int r = startRow; r < startRow + (BOARD_ROWS/2); r++){
      for(int c = 0; c < BOARD_COLS; c++){
        if(board[r][c].getType() == TokenType.NULL){
          board[r][c].setType(getRandomTokenType());
          numFilled++;
        }
      }
    }
    return numFilled;
  }
  
  /**
      Several columns may be dropping down tokens, but once a column
      is finished dropping its gems, it should immediately fill up the holes.
      
      Note this does not change whether the token has a gem or not.
  */
  void fillInvisibleSectionOfColumn(int c){
    for(int r = 0; r < START_ROW_INDEX; r++){
      if(board[r][c].getType() == TokenType.NULL){
        Token t = new Token();
        t.setType(getRandomTokenType());
        t.setRowColumn(r, c);
        board[r][c] = t;
      }
    }
  }

  /**
      TODO: refactor 'ok'
      From bottom to top, search to find first gap
      After finding the first gap, set the marker
      Find first token, set dst to marker
      Increment marker by 1
      Find next token     
  */
  void dropTokens(){
    
    for(int c = 0; c < BOARD_COLS; c++){
      boolean ok = false;
      int dst = BOARD_ROWS;
      int src;
      
      while(dst >= 2){
        dst--;
        if(board[dst][c].getType() == TokenType.NULL || board[dst][c].isDying() ){
          ok = true;
          break;
        }
      }
      
      // Don't subtract 1 because we do that already in the next line
      src = dst;
      while(src >= 1){
        src--;
        if(board[src][c].getType() != TokenType.NULL || board[src][c].isDying() ){
          break;
        }
      }
      
      while(src >= 0){
        // move the first token
        if(ok){
          Token tokenToMove = board[src][c];
          tokenToMove.fallTo(dst, c);
        }
        do{
          src--;
        }while(src >= 1 && board[src][c].getType() == TokenType.NULL);
        
        dst--;
      }
    }
  }
  
  /**
    Find any 3 matches either going vertically or horizontally and
    remove them from the board. Replace the cells in the board will NULL tokens.
    
    @returns the number of tokens this method found that need to be removed.    
  */
  int markTokensForRemoval(boolean forTopPart){
    
    int numTokensMarked = 0;    
    
    int startRow = forTopPart ? 0 : START_ROW_INDEX;
    int endRow = forTopPart ? 7 : 15;
    
    // Mark the matched horizontal gems
    // TODO: Add extra column buffer at end of board to fix matches counter?
    for(int r = startRow; r <= endRow; r++){
      
      // start with the first token in the first column as the thing we want to match against.
      int tokenTypeToMatchAgainst = board[r][0].getType();
      
      // start of matched row
      int markerIndex = 0;
      int matches = 1;
      
      for(int c = 1; c < BOARD_COLS; c++){
        
        // Found a match, keep going...
        if(board[r][c].matchesWith(tokenTypeToMatchAgainst) && board[r][c].canBeMatched()){
          matches++;
        }
        // We bank on finding a different gem. Once that happens, we can see if
        // we found enough of the previous gems. Didn't find 3 matches, start over.
        else if( (board[r][c].matchesWith(tokenTypeToMatchAgainst) == false) && matches < 3){
          matches = 1;
          markerIndex = c;
          tokenTypeToMatchAgainst = board[r][c].getType();
        }
        // We need to also do it at the end of the board
        // Did we reach the end of the board?
        else if( (board[r][c].matchesWith(tokenTypeToMatchAgainst) == false && matches >= 3) || (c == BOARD_COLS - 1 && matches >= 3)){
          
          for(int gemC = markerIndex; gemC < markerIndex + matches; gemC++){
            board[r][gemC].kill();
            numTokensMarked++;
          }
          matches = 1;
          markerIndex = c;
          tokenTypeToMatchAgainst = board[r][c].getType();
        }
      }
      
      // TODO: fix
      if(matches >= 3){
        for(int gemC = markerIndex; gemC < markerIndex + matches; gemC++){
          board[r][gemC].kill();
          numTokensMarked++;
        }
      }
    }
    
    //
    // Now do the columns...
    //
    // Add extra column buffer at end of board to fix matches counter?
    for(int c = 0; c < BOARD_COLS; c++){
      int tokenTypeToMatchAgainst = board[startRow][c].getType();
      int markerIndex = startRow;
      int matches = 1;
      
      for(int r = startRow + 1; r <= endRow; r++){
        
        if(board[r][c].matchesWith(tokenTypeToMatchAgainst) && board[r][c].canBeMatched()){
          matches++;
        }
        // We bank on finding a different gem. Once that happens, we can see if
        // we found enough of the previous gems.
        else if(board[r][c].matchesWith(tokenTypeToMatchAgainst) == false && matches < 3){
          matches = 1;
          markerIndex = r;
          tokenTypeToMatchAgainst = board[r][c].getType();
        }
        // Either we found a non-match after at least finding a match 3, or the last match was at the end of the column.
         else if(  (board[r][c].matchesWith(tokenTypeToMatchAgainst) == false && matches >= 3) || (r == endRow && matches >= 3)){
          
          for(int gemR = markerIndex; gemR < markerIndex + matches; gemR++){
            board[gemR][c].kill();
            numTokensMarked++;
          }
          matches = 1;
          markerIndex = r;
          tokenTypeToMatchAgainst = board[r][c].getType();
        }
      }
      
      if(matches >= 3){
        for(int gemR = markerIndex; gemR < markerIndex + matches; gemR++){
            board[gemR][c].kill();
            numTokensMarked++;
        }
      }
    }
    
    if(numTokensMarked >= 3){
      //soundManager.playSuccessSwapSound();
    }

    return numTokensMarked;
  }
  
  /*
    A swap of two gems is only valid if it results in a row or column of 3 or more 
    gems of the same type getting lined up.
  */
  private int getNumCosecutiveMatches(Token t1, Token t2){
    // When the player selects a token on the other side of the board,
    // we still call wasValidSwap, which checks here if the tokens are too far apart to match.
    if(isCloseEnoughForSwap(t1, t2) == false){
      return 0;
    }
   
    int matches = numMatchesSideways(t1, LEFT) + numMatchesSideways(t1, RIGHT);
    if(matches >= 2){
      return matches + 1;
    }
    
    matches = numMatchesSideways(t2, LEFT) + numMatchesSideways(t2, RIGHT);
    if(matches >= 2){
      return matches + 1;
    }
    
    matches = numMatchesUpDown(t1, UP) + numMatchesUpDown(t1, DOWN);
    if(matches >= 2){
      return matches + 1;
    }
    
    matches = numMatchesUpDown(t2, UP) + numMatchesUpDown(t2, DOWN);
    return matches + 1;
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
   * Return how many tokens match this one on its left or right side
   * Does not include the count of the token itself.
   */
  public int numMatchesSideways(Token token, int direction){
    int currColumn = token.getColumn();
    int tokenRow = token.getRow();
    int matchesFound = 0;
    int type = token.getType();
    
    // Watch for going out of bounds
    while(currColumn >= 0 && currColumn < BOARD_COLS && board[tokenRow][currColumn].matchesWith(type)){
      matchesFound++;
      currColumn += direction;
    }

    // matchesFound included the token we started with to
    // keep the code in this funciton short, but we have to
    // only return the number of matched tokens excluding it.
    return matchesFound - 1;
  }
  
  /*
      We can only match up until the visible part of the board
      returns the number of matching types excluding this one.
  */
  public int numMatchesUpDown(Token token, int direction){
    int row = token.getRow();
    int matchesFound = 0;
    int type = token.getType();
    int tokenColumn = token.getColumn();
   
    while(row >= START_ROW_INDEX && row < BOARD_ROWS && board[row][tokenColumn].matchesWith(type)){
      matchesFound++;
      row += direction;
    }
    
    return matchesFound -1;
  }
  
  /**
  */
  public void swapTokens(Token token1, Token token2){
    
    int token1Row = token1.getRow();
    int token1Col = token1.getColumn();
  
    int token2Row = token2.getRow();
    int token2Col = token2.getColumn();
  
    // Swap on the board and in the tokens
    board[token1Row][token1Col] = token2;
    board[token2Row][token2Col] = token1;
    
    token2.swap(token1);
  }
  
  /*
      Fills the board with random tokens and makes sure
      there are no immediate matches (at least ones that are displayed)
  */
  void fillBoardWithRandomTokens(){
    
    // Stupidly just fill the board with random tokens first.
    for(int r = 0; r < BOARD_ROWS; r++){
      for(int c = 0; c < BOARD_COLS; c++){
        Token token = new Token();
        token.setType(getRandomTokenType());
        token.setRowColumn(r, c);
        board[r][c] = token;
      }
    }
    
    // Now start removing immediate matches where tokens are displayed.
    while(markTokensForRemoval(false) > 0){
      removeMarkedTokens(false);      
      fillHoles(false);
    }
    
    setFillMarkers();
        
    if(validSwapExists() == false){
      generateNewBoardWithDyingAnimation(true);
      println("**** no moves remaining ****");
    }
  }
  
  private void setFillMarker(int c){
    board[0][c].setFillCellMarker(true);
  }
  
  private void setFillMarkers(){
    for(int c = 0; c < BOARD_COLS; c++){
      board[0][c].setFillCellMarker(true);
    }
  }
  
  /*
   */
  void drawBoard(){
    
    pushStyle();
    noFill();
    stroke(255);
    strokeWeight(2);
    
    //rect(-TOKEN_SIZE/2, -TOKEN_SIZE/2, BOARD_COLS * TOKEN_SIZE, BOARD_ROWS * TOKEN_SIZE);
    
    // Draw lower part of the board
    //rect(-TOKEN_SIZE/2, -TOKEN_SIZE/2 + START_ROW_INDEX * TOKEN_SIZE, BOARD_COLS * TOKEN_SIZE, BOARD_ROWS * TOKEN_SIZE - 220);
    popStyle();

    // Part of the invisible board needs to be drawn because
    // the tokens coming into to the board need to be shown animating in.    
    for(int r = 0; r < START_ROW_INDEX; r++){
      for(int c = 0; c < BOARD_COLS; c++){
        if(DEBUG_ON){
          board[r][c].draw();
        }
        else{
          if(board[r][c].isMoving()){
            board[r][c].draw();
          }
        }
      }
    }
    
    int startRow = DEBUG_ON ? 0 : START_ROW_INDEX;
    
    // Draw the visible part to the player
    for(int r = startRow; r < BOARD_ROWS; r++){
      for(int c = 0; c < BOARD_COLS; c++){
        board[r][c].draw();
      }
    }
  }
  
  /**
        Select a random token in the invisible part of the board 
        and add a gem to it if it doesn't already have one.
        
        Used when the player clears a gem from board and we have to 'replace' it.
  */
  private void addGemsToQueuedTokens(){
    while(numGemsOnBoard < numGemsAllowedAtOnce){
      // We can only add the gem to the part of the board the user doesn't see.
      // Don't forget getRandom int is inclusive.
      int r = Utils.getRandomInt(0, START_ROW_INDEX - 1);
      int c = Utils.getRandomInt(0, BOARD_COLS - 1);
      Token token = board[r][c];
      
      if(token.hasGem() == false){
        token.setHasGem(true);
        numGemsOnBoard++;
      }
    }
  }
  
  /*
      Move the tokens that have been marked for deletion from
      the board to the dying tokens list.
      
      @returns {int} The number of tokens removed from the board.
   */
  private int removeMarkedTokens(boolean doDyingAnimation){
    int numRemoved = 0;
    
    // Now delete everything marked for deletion.
    for(int r = 0; r < BOARD_ROWS; r++){
      for(int c = 0; c < BOARD_COLS; c++){
        
        Token tokenToDestroy = board[r][c];
        
        // Don't need to check if already in the list because we're removing it from
        // the board, so it can never be placed from the board into the dying token list more than once.
        if(tokenToDestroy.isDying() ){//|| tokenToDestroy.isAlive() == false){
          //tokenToDestroy.kill();
          numRemoved++;
          // On setup we use this method, but we don't actually want to play the animation.
          if(doDyingAnimation){
            dyingTokens.add(tokenToDestroy);
          }
          
          // Replace the token we removed with a null Token
          createNullToken(r, c);
        }
        // !!! TODO: check
        board[r][c].setSelect(false);
      }
    }
    
    return numRemoved;
  }
  
  private void createNullToken(int r, int c){
    Token nullToken = new Token();
    nullToken.setType(TokenType.NULL);
    nullToken.setRowColumn(r, c);
    board[r][c] = nullToken;
  }
  
  void keyPressed(){
    Keyboard.setKeyDown(keyCode, true);
    
    // P key is locked
    isPaused = Keyboard.isKeyDown(KEY_P);
    if(isPaused){
      timer.pause();
      levelCountDownTimer.pause();
    }
    
    if(Keyboard.isKeyDown(KEY_L)){
      goToNextLevel();
    }
  }
  
  /**
  */
  void keyReleased(){
    Keyboard.setKeyDown(keyCode, false);
    
    //soundManager.setMute(!soundManager.isMuted());
    
    isPaused = Keyboard.isKeyDown(KEY_P);
    if(isPaused == false){
      timer.resume();
      levelCountDownTimer.resume();
    }
  }  

  public int getNumGems(){
    return gemsWonByPlayer;
  }
  
  public boolean Paused(){
    return isPaused;
  }
  
  public int getNumGemsForNextLevel(){
    //println(gemsRequiredForLevel);
    
    return gemsRequiredForLevel;
  }
  
  /**
      This can only be done if nothing is moving or animating to make
      sure they board stays in a proper state.
  */
  public void generateNewBoardWithDyingAnimation(boolean dieAnim){        
    
    fillBoardWithRandomTokens();
    
    // Kill all the tokens on the visible part of the board
    for(int c = 0; c < BOARD_COLS; c++){
      for(int r = START_ROW_INDEX; r < BOARD_ROWS; r++){
        // Set score to zero so once they die, the score total isn't changed.
        board[r][c].setScore(0);
        board[r][c].kill();
        if(dieAnim){
          dyingTokens.add(board[r][c]);
        }
        
        createNullToken(r,c);        
      }
    }
    
    // The invisible part of the board will drop down, so we need to 
    // remove all immediate matches so there are no matches as soon as it falls.
    while(markTokensForRemoval(true) > 0){
      removeMarkedTokens(false);
      fillHoles(true);
    }
    
    // We don't want any gems to appear on the board on init, just based on design
    removeAllGemsFromBoard();
    
    // TODO: comment !!!
    setFillMarkers();
    
    dropTokens();
  }
  
  /*
  */
  private void removeAllGemsFromBoard(){
    numGemsOnBoard = 0;
    for(int c = 0; c < BOARD_COLS; c++){
      for(int r = 0; r < BOARD_ROWS; r++){
        board[r][c].setHasGem(false);
      }
    }
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
    // prevent goToNextLeve from running as soon as the level loads
    //gemsWonByPlayer = 0;
    
    screenStory.nextLevel();
    screens.transitionTo("story");
      currLevel++;
   
  }
  
  /**
      Need to clear off all the crap that was happeneing in the last level
  */
  public void OnTransitionTo(){
    //println("On Transition To");
    tokensDestroyed = 0;
    dyingTokens.clear();
   // generateNewBoardWithDyingAnimation(false);
    
    
     // Should the score be reset?
    // score = 0;
    gemsWonByPlayer = 0;
    gemsRequiredForLevel = gemsRequired[currLevel];
    
    // Still playing around with this to make later levels challenging.
    levelCountDownTimer = new Ticker();
    levelCountDownTimer.setTime(timePermitted[currLevel]);
    levelCountDownTimer.setDirection(-1);
    
    if(currLevel == 4){
      numTokenTypesOnBoard++;
    }
    
    generateNewBoardWithDyingAnimation(false);
    //fillBoardWithRandomTokens();
  }
}
/*
    Displays game name and credits
*/
public class ScreenSplash implements IScreen{

  Ticker ticker;
  
  RetroFont solarWindsFont;

  RetroLabel creditsLabel;
  RetroLabel loadingLabel;
  RetroLabel mainTitleLabel;
  
    public void OnTransitionTo(){
  }


  public ScreenSplash(){
    ticker = new Ticker();
    
    // TODO: convert this to a singleton or factory.
    solarWindsFont = new RetroFont("data/fonts/solarwinds.png", 14, 16, 2);
    
    mainTitleLabel = new RetroLabel(solarWindsFont);
    mainTitleLabel.setText("H O R A D R I X");
    mainTitleLabel.pixelsFromCenter(0, 0);
    
    creditsLabel = new RetroLabel(solarWindsFont);
    creditsLabel.setText("Code & Art: Andor Salga");
    creditsLabel.setVerticalSpacing(0);
    creditsLabel.setHorizontalTrimming(true);
    creditsLabel.pixelsFromBottomLeft(0, 0);

    loadingLabel = new RetroLabel(solarWindsFont);
    loadingLabel.setHorizontalTrimming(true);
    loadingLabel.setText("Loading....");
    loadingLabel.pixelsFromCenter(0, 50);
  }
  
  /**
  */
  public void draw(){
    background(0);
    
    mainTitleLabel.draw();
    creditsLabel.draw();
    loadingLabel.draw();
  }
  
  public void update(){
    ticker.tick();
    if(ticker.getTotalTime() > 0.5f){
      //screens.transitionTo("gameplay");
      screens.transitionTo("story");
    }
  }
  
  public String getName(){
    return "splash";
  }
  
  public void keyReleased(){}
  public void keyPressed(){}
  
  public void mousePressed(){}
  public void mouseReleased(){}
  public void mouseDragged(){}
  public void mouseMoved(){}
}
/*
 * Prints text on top of everything for real-time object tracking.
 */
class Debugger{
  private ArrayList strings;
  private PFont font;
  private int fontSize;
  private boolean isOn;
  
  public Debugger(){
    isOn = true;
    strings = new ArrayList();
    fontSize = 15;
    font = createFont("Arial", fontSize);
  }
  
  public void addString(String s){
    if(isOn){
      strings.add(s);
    }
  }
  
  /*
   * Should be called after every frame
   */
  public void clear(){
    strings.clear();
  }
  
  /**
    If the debugger is off, it will ignore calls to addString and draw saving
    some processing time.
  */
  public void toggle(){
    isOn = !isOn;
  }
  
  public void draw(){
    if(isOn){
      int y = 20;
      fill(255);
      for(int i = 0; i < strings.size(); i++, y+=fontSize){
        textFont(font);
        text((String)strings.get(i),0,y);
      }
    }
  }
}
/*
*/
public class RetroFont{
  
  private PImage chars[];
  private PImage trimmedChars[];
  
  private int glyphWidth;
  private int glyphHeight;
  
  /*
      Removes the transparent pixels from the left and right sides of
      the glyph.
  */
  private PImage truncateImage(PImage glyph){
    
    int startX = 0;
    int endX = glyph.width - 1;
    int x, y;

    // Find the starting X coord of the image.
    for(x = glyph.width; x >= 0 ; x--){
      for(y = 0; y < glyph.height; y++){
        
        color testColor = glyph.get(x, y);
        if( alpha(testColor) > 0.0){
          startX = x;
        }
      }
    }

   // Find the ending coord
    for(x = 0; x < glyph.width; x++){
      for(y = 0; y < glyph.height; y++){
        
        color testColor = glyph.get(x,y);
        if( alpha(testColor) > 0.0){
          endX = x;
        }
      }
    }
    return glyph.get(startX, 0, endX - startX + 1, glyph.height);
  }
  
  
  // Do not instantiate directly
  public RetroFont(String imageFilename, int glyphWidth, int glyphHeight, int borderSize){
    this.glyphWidth = glyphWidth;
    this.glyphHeight = glyphHeight;
    
    PImage fontSheet = loadImage(imageFilename);
    
    chars = new PImage[96];
    trimmedChars = new PImage[96];
    
    int x = 0;
    int y = 0;
    
    //
    //
    for(int currChar = 0; currChar < 96; currChar++){  
      chars[currChar] = fontSheet.get(x, y, glyphWidth, glyphHeight);
      trimmedChars[currChar] = truncateImage(fontSheet.get(x, y, glyphWidth, glyphHeight));
      
      x += glyphWidth + borderSize;
      if(x >= fontSheet.width){
        x = 0;
        y += glyphHeight + borderSize;
      }
    }
    
    
    // For each character, truncate the x margin
    //for(int currChar = 0; currChar < 96; currChar++){
      //chars[currChar] = truncateImage( chars[currChar] );
    //}
  }
  
  //public static void create(String imageFilename, int charWidth, int charHeight, int borderSize){ 
  //PImage fontSheet = loadImage(imageFilename);
  public PImage getGlyph(char ch){
    int asciiCode = Utils.charCodeAt(ch);
    
    if(asciiCode-32 >= 96 || asciiCode-32 <= 0){
      return chars[0];
    }
 
    return chars[asciiCode-32];
  }
  
  public PImage getTrimmedGlyph(char ch){
    int asciiCode = Utils.charCodeAt(ch);
    return trimmedChars[asciiCode-32];
  }
  
  public int getGlyphWidth(){
    return glyphWidth;
  }
  
  public int getGlyphHeight(){
    return glyphHeight;
  }
}
/*
 * 
 */
public class RetroLabel extends RetroPanel{
  
  public static final int JUSTIFY_MANUAL = 0; 
  public static final int JUSTIFY_LEFT = 1;
  //public static final int JUSTIFY_RIGHT = 1;

  private final int NEWLINE = 10;

  private String text;
  private RetroFont font;
  
  //
  private int horizontalSpacing;
  private int verticalSpacing;
  private boolean horizontalTrimming;
  
  private int justification;
  
  public RetroLabel(RetroFont font){
    setFont(font);
    setVerticalSpacing(1);
    setHorizontalSpacing(1);
    //setJustification(JUSTIFY_LEFT);
    setHorizontalTrimming(false);
  }
  
  public void setHorizontalTrimming(boolean horizTrim){
    horizontalTrimming = horizTrim;
  }
  
  /**
  */
  public void setHorizontalSpacing(int spacing){
    horizontalSpacing = spacing;
    dirty = true;
  }
  
  public void setVerticalSpacing(int spacing){
    verticalSpacing = spacing;
    dirty = true;
  }
  
  /*
   * Will immediately calculate the width 
   */
  public void setText(String text){
    this.text = text;
    dirty = true;
    
    int newWidth = 0;
    int newHeight = font.getGlyphHeight();
    
    int longestLine = 0;
    
    for(int letter = 0; letter < text.length(); letter++){
    
      if((text.charAt(letter)) == 10){
        newHeight += font.getGlyphHeight();
      }
      else{
        PImage glyph = getGlyph(text.charAt(letter));
        
        if(glyph != null){
          newWidth += glyph.width + horizontalSpacing;
        }
      }
    }
    h = newHeight;
    w = newWidth;
  }
  
  public void setFont(RetroFont font){
    this.font = font;
    dirty = true;
    h = this.font.getGlyphHeight();
  }
  
  /**
  */
  private int getStringWidth(String str){
    return str.length() * font.getGlyphWidth() + (str.length() * horizontalSpacing );
  }
  
  //public void setJustification(int justify){
  //   justification = justify;
  //}
  
  /**
    Draws the text in the label depending on the
    justification of the panel is sits inside
  */
  public void draw(){
    
    super.draw();
    
    // Return if there is nothing to draw
    if(text == null || visible == false){
      return;
    }
    
    if(justification == JUSTIFY_MANUAL){
      int currX = x;
      int lineIndex = 0;
      
      for(int letter = 0; letter < text.length(); letter++){
        if((int)text.charAt(letter) == NEWLINE){
          lineIndex++;
          currX = x;
          continue;
        }
        PImage glyph = getGlyph(text.charAt(letter));
        
        if(glyph != null){
          image(glyph, currX, y + lineIndex * (font.getGlyphHeight() + verticalSpacing));

          currX += glyph.width + horizontalSpacing;
        }
      }
      currX += font.getGlyphWidth();
    }
    else{
    
      // iterate over each word and see if it would fit into the
      // panel. If not, add a line break
      String[] words = text.split(" ");
      int[] firstCharIndex = new int[words.length];
      
      // get indices of fist char of every word
      // for(int word = 0; word < words.length; word++){
      //  firstCharIndex[word] = 
      //}
       firstCharIndex[0] = 0;
      
       int iter = 1;
       for(int letter = 0; letter < text.length(); letter++){
         if(text.charAt(letter) == ' '){
           firstCharIndex[iter] = letter + 1;
           iter++;
         }
       }
       
       int[] wordWidths;
      
      // start drawing at the panel
      int currXPos = x;
      
      int lineIndex = 0;
      
      // Iterate over all the words
      for(int word = 0; word < words.length; word++){
        int wordWidth = getStringWidth(words[word]);
        
        if(justification == JUSTIFY_LEFT){
          if(word != 0 && currXPos + wordWidth + 0 >  getParent().getWidth() ){
            lineIndex++;
            currXPos = x;
          }
        }
        
        // Iterate over the letter of each word
        for(int letter = 0; letter < words[word].length(); letter++){
          
          int firstChar = firstCharIndex[word];
          
          //
          if((int)words[word].charAt(letter) == NEWLINE){
            lineIndex++;
            currXPos = x;
            continue;
          }
          
          PImage glyph = getGlyph(words[word].charAt(letter));
          
          if(glyph != null){
            image(glyph, currXPos, lineIndex * (font.getGlyphHeight() + verticalSpacing));
            currXPos += font.getGlyphWidth() + horizontalSpacing;
          }
        }
        currXPos += font.getGlyphWidth();
      }
    }
  }
   
  private PImage getGlyph(char ch){
    if(horizontalTrimming == true){
      return font.getTrimmedGlyph(ch );
    }
    return font.getGlyph( ch);
  }
}
/*
    A panel represents a generic container that can hold
    other widgets.
*/
public class RetroPanel extends RetroWidget{

  ArrayList<RetroWidget> children;
  protected boolean dirty;
  
  // Keep track of where the panel is pinned to its parent
  // If the panel becomes dirty, these values can be used to reposition
  // the panel to its proper placement.
  private int anchor;
  private int yPixels;
  private int xPixels;
  
  private static final int FROM_TOP = 0;
  private static final int FROM_CENTER = 1;
  private static final int FROM_BOTTOM = 2;
  private static final int FROM_LEFT = 3;
  private static final int FROM_RIGHT = 4;
  
  private static final int FROM_TOP_LEFT = 5;
  private static final int FROM_TOP_RIGHT = 6;

  private static final int FROM_BOTTOM_LEFT = 7;
  private static final int FROM_BOTTOM_RIGHT = 8;
  
  /*
  */
  public RetroPanel(){
    w = 0;
    h = 0;
    x = 0;
    y = 0;
    removeAllChildren();
    
    anchor = FROM_TOP;
    xPixels = yPixels = 0;
  }
  
  public void removeAllChildren(){
    children = new ArrayList<RetroWidget>();
  }

  public void addWidget(RetroWidget widget){
    widget.setParent(this);
    children.add(widget);
    
    widget.setDebug(debugDraw);
  }
  
  /*
    If the width changes, we'll need to tell all the children
    to readjust themselves.
  */
  public void setWidth(int w){
    this.w = w;
  }
  
  public int getX(){
    return x;
  }
  
  public int getY(){
    return y;
  }
  
  public int getWidth(){
    return w;
  }
  
  public RetroPanel(int x, int y, int w, int h){
    removeAllChildren();
    this.w = w;
    this.h = h;
    this.x = x;
    this.y = y;
  }
  
  /*
      Render widget from the top center relative to parent.
  */
  public void pixelsFromTop(int yPixels){
    RetroWidget p = getParent();
    
    anchor = FROM_TOP;
    this.yPixels = yPixels;

    x = (p.w/2) - (w/2);
    y = yPixels;
  }
  
  /*
  */
  public void pixelsFromTopLeft(int yPixels, int xPixels){
    RetroWidget p = getParent();
    
    anchor = FROM_TOP_LEFT;
    this.yPixels = yPixels;
    this.xPixels = xPixels;
    
    x = xPixels;
    y = yPixels;
  }
  
  /*
  */
  public void pixelsFromTopRight(int yPixels, int xPixels){
    RetroWidget p = getParent();
    
    anchor = FROM_TOP_RIGHT;
    this.yPixels = yPixels;
    this.xPixels = xPixels;

    x = p.w - w;
    y = yPixels;
  }
  
  
  
  /*
    TODO: needs debugging
  */
  public void pixelsFromBottomRight(int yPixels, int xPixels){
    RetroWidget p = getParent();
    
    anchor = FROM_BOTTOM_RIGHT;
    this.yPixels = yPixels;
    this.xPixels = xPixels;
    
    x = p.w - w + xPixels;
    y = p.h - yPixels - h;
  }
  
  /*
  */
  public void pixelsFromBottomLeft(int yPixels, int xPixels){
    RetroWidget p = getParent();
    
    anchor = FROM_BOTTOM_LEFT;
    this.yPixels = yPixels;
    this.xPixels = xPixels;
    
    x = xPixels;
    y = p.h - yPixels - h;
  }
    
  /**
   */
  public void pixelsFromCenter(int xPixels, int yPixels){
    RetroWidget p = getParent();
    
    anchor = FROM_CENTER;
    this.yPixels = yPixels;
    this.xPixels = xPixels;
    
    x = (p.w/2) - (w/2) + xPixels;
    y = (p.h/2) - (h/2) + yPixels;
  }
  
  /*
  */
  public void pixelsFromLeft(int xPixels){
    RetroWidget p = getParent();
    
    anchor = FROM_LEFT;
    this.xPixels = xPixels;
    
    x = xPixels;
    y = (p.h/2) - (h/2);
  }
  
  /*
  */
  public void pixelsFromRight(int xPixels){
    RetroWidget p = getParent();
    
    anchor = FROM_RIGHT;
    this.xPixels = xPixels;

    x = p.w - w - xPixels;
    y = (p.h/2) - (h/2);
  }
  
  
  public void updatePosition(){
    dirty = true;
  }
  
  /*
    If debugging is on, this widget along with all children will
    have a red outline around them.
  */
  public void setDebug(boolean debugOn){
    super.setDebug(debugOn);
    
    for(int i = 0; i < children.size(); i++){
      children.get(i).setDebug(debugOn);
    }
  }

  
  /*
  */
  public void draw(){
    
    // If the 
    if(dirty == true){
      dirty = false;
      
      if(DEBUG_CONSOLE_ON){
        println("No longer dirty");
      }
      
      switch(anchor){
        case FROM_TOP: pixelsFromTop(yPixels);break;
        case FROM_CENTER:pixelsFromCenter(xPixels, yPixels);break;
        case FROM_BOTTOM:break;
        
        
        case FROM_LEFT:   pixelsFromLeft(xPixels);break;
        case FROM_RIGHT:  pixelsFromRight(xPixels);break;
        
        case FROM_TOP_LEFT:   pixelsFromTopLeft(yPixels, xPixels);break;
        case FROM_TOP_RIGHT:  pixelsFromTopRight(yPixels, xPixels);break;
        
        case FROM_BOTTOM_LEFT:  pixelsFromBottomLeft(yPixels, xPixels);break;
        case FROM_BOTTOM_RIGHT: pixelsFromBottomRight(yPixels, xPixels);break;
      }
    }
    
    if(debugDraw){
      pushStyle();
      noFill();
      stroke(255, 0, 0, 255);
      strokeWeight(1);
      rect(x, y, w, h);
      popStyle();
    }
    
    if(visible == false || children.size() == 0){
      return;
    }
    
    pushMatrix();
    translate(x, y);
    for(int i = 0; i < children.size(); i++){
      children.get(i).draw();
    }
    popMatrix();
  }
}
/*

*/
public abstract class RetroWidget{

  // force access from getter so that the appropriate parent
  // can be returned.
  private RetroWidget parent;
  //protected RetroWidget defaultParent;
  protected int x, y, w, h;
  
  protected boolean visible = true;
  protected boolean debugDraw = false;
  
  public RetroWidget(){
    x = y = 0;
    w = h = 0;
    visible = true;
    parent = null;
    debugDraw = false;
  }
  
  public RetroWidget getParent(){
    if(parent != null){
      return parent;
    }
    return new RetroPanel(0, 0, width, height);
  }
  
  public void setVisible(boolean v){
    visible = v;
  }
  
  public boolean getVisible(){
    return visible;
  }
    
  public void setParent(RetroWidget widget){
    parent = widget;
    //defaultParent = null;
  }
  
  public int getWidth(){
    return w;
  }
  
  public int getHeight(){
    return h;
  }

  public void setPosition(int x, int y){
    this.x = x;
    this.y = y;
  }
  
  public void setDebug(boolean debugOn){
    debugDraw = debugOn;
  }
  
  public abstract void draw();
}
/*
 * Classes poll keyboard state to get state of keys.
 */
public static class Keyboard{
  
  private static final int NUM_KEYS = 128;
  
  // Locking keys are good for toggling things.
  // After locking a key, when a user presses and releases a key, it will register and
  // being 'down' (even though it has been released). Once the user presses it again,
  // it will register as 'up'.
  private static boolean[] lockableKeys = new boolean[NUM_KEYS];
  
  // Use char since we only need to store 2 states (0, 1)
  private static char[] lockedKeyPresses = new char[NUM_KEYS];
  
  // The key states, true if key is down, false if key is up.
  private static boolean[] keys = new boolean[NUM_KEYS];
  
  /*
   * The specified keys will stay down even after user releases the key.
   * Once they press that key again, only then will the key state be changed to up(false).
   */
  public static void lockKeys(int[] keys){
    for(int k : keys){
      if(isValidKey(k)){
        lockableKeys[k] = true;
      }
    }
  }
  
  /*
   * TODO: if the key was locked and is down, then we unlock it, it needs to 'pop' back up.
   */
  public static void unlockKeys(int[] keys){
    for(int k : keys){
      if(isValidKey(k)){
        lockableKeys[k] = false;
      }
    }
  }
  
  /*
   *
   */
  public static void reset(){
    
  }
  
  /* This is for the case when we want to start off the game
   * assuming a key is already down.
   */
  public static void setVirtualKeyDown(int key, boolean state){
    setKeyDown(key, true);
    setKeyDown(key, false);
  }
  
  /**
   */
  private static boolean isValidKey(int key){
    return (key > -1 && key < NUM_KEYS);
  }
  
  /*
   * Set the state of a key to either down (true) or up (false)
   */
  public static void setKeyDown(int key, boolean state){
    
    if(isValidKey(key)){
      
      // If the key is lockable, as soon as we tell the class the key is down, we lock it.
      if( lockableKeys[key] ){
          // First time pressed
          if(state == true && lockedKeyPresses[key] == 0){
            lockedKeyPresses[key]++;
            keys[key] = true;
          }
          // First time released
          else if(state == false && lockedKeyPresses[key] == 1){
            lockedKeyPresses[key]++;
          }
          // Second time pressed
          else if(state == true && lockedKeyPresses[key] == 2){
             lockedKeyPresses[key]++;
          }
          // Second time released
          else if (state == false && lockedKeyPresses[key] == 3){
            lockedKeyPresses[key] = 0;
            keys[key] = false;
          }
      }
      else{
        keys[key] = state;
      }
    }
  }
  
  /* 
   * Returns true if the specified key is down.
   */
  public static boolean isKeyDown(int key){
    return keys[key];
  }
}

// These are outside of keyboard simply because I don't want to keep
// typing Keyboard.KEY_* in the main Tetrissing.pde file
final int KEY_BACKSPACE = 8;
final int KEY_TAB       = 9;
final int KEY_ENTER     = 10;

final int KEY_SHIFT     = 16;
final int KEY_CTRL      = 17;
final int KEY_ALT       = 18;

final int KEY_CAPS      = 20;
final int KEY_ESC       = 27;

final int KEY_SPACE  = 32;
final int KEY_PGUP   = 33;
final int KEY_PGDN   = 34;
final int KEY_END    = 35;
final int KEY_HOME   = 36;

final int KEY_LEFT   = 37;
final int KEY_UP     = 38;
final int KEY_RIGHT  = 39;
final int KEY_DOWN   = 40;

final int KEY_0 = 48;
final int KEY_1 = 49;
final int KEY_2 = 50;
final int KEY_3 = 51;
final int KEY_4 = 52;
final int KEY_5 = 53;
final int KEY_6 = 54;
final int KEY_7 = 55;
final int KEY_8 = 56;
final int KEY_9 = 57;

final int KEY_A = 65;
final int KEY_B = 66;
final int KEY_C = 67;
final int KEY_D = 68;
final int KEY_E = 69;
final int KEY_F = 70;
final int KEY_G = 71;
final int KEY_H = 72;
final int KEY_I = 73;
final int KEY_J = 74;
final int KEY_K = 75;
final int KEY_L = 76;
final int KEY_M = 77;
final int KEY_N = 78;
final int KEY_O = 79;
final int KEY_P = 80;
final int KEY_Q = 81;
final int KEY_R = 82;
final int KEY_S = 83;
final int KEY_T = 84;
final int KEY_U = 85;
final int KEY_V = 86;
final int KEY_W = 87;
final int KEY_X = 88;
final int KEY_Y = 89;
final int KEY_Z = 90;

// Function keys
final int KEY_F1  = 112;
final int KEY_F2  = 113;
final int KEY_F3  = 114;
final int KEY_F4  = 115;
final int KEY_F5  = 116;
final int KEY_F6  = 117;
final int KEY_F7  = 118;
final int KEY_F8  = 119;
final int KEY_F9  = 120;
final int KEY_F10 = 121;
final int KEY_F12 = 122;

//final int KEY_INSERT = 155;

/**
  * A ticker class to manage animation timing.
  */
public class Ticker{

  private int lastTime;
  private float deltaTime;
  private boolean isPaused;
  private float totalTime;
  private boolean countingUp; 
  
  public Ticker(){
    reset();
  }
  
  public void setDirection(int d){
    countingUp = false;
  }
  
  public void reset(){
    deltaTime = 0f;
    lastTime = -1;
    isPaused = false;
    totalTime = 0f;
    countingUp = true;
  }
  
  //
  public void pause(){
    isPaused = true;
  }
  
  public void resume(){
    deltaTime = 0f;
    lastTime = -1;
    isPaused = false;
  }
  
  public void setTime(int min, int sec){    
    totalTime = min * 60 + sec;
  }
  
  /*
      Format: 5.5 = 5 minutes 30 seconds
  */
  public void setTime(float minutes){
    int int_min = (int)minutes;
    int sec = (int)((minutes - (float)int_min) * 60);
    setTime( int_min, sec);
  }
  
  //public void setMinutes(int min){
  //  totalTime = min * 60;
  //}
  
  public float getTotalTime(){
    return totalTime;
  }
  
  /*
  */
  public float getDeltaSec(){
    if(isPaused){
      return 0;
    }
    return deltaTime;
  }
  
  /*
  * Calculates how many seconds passed since the last call to this method.
  *
  */
  public void tick(){
    if(lastTime == -1){
      lastTime = millis();
    }
    
    int delta = millis() - lastTime;
    lastTime = millis();
    deltaTime = delta/1000f;
    
    if(countingUp){
      totalTime += deltaTime;
    }
    else{
      totalTime -= deltaTime;
    }
  }
}

public static class TokenType{
  
  //public static final int NULL = 0;
  public static final int RED = 0;
  public static final int GREEN = 1;
  public static final int BLUE = 2;
  public static final int WHITE = 3;
  public static final int YELLOW = 4;
  public static final int SKULL = 5;
  public static final int PURPLE = 6;
  
  public static final int RED_GEM = 7;
  public static final int GREEN_GEM = 8;
  public static final int BLUE_GEM = 9;
  public static final int WHITE_GEM = 10;
  public static final int YELLOW_GEM = 11;
  public static final int SKULL_GEM = 12;
  public static final int PURPLE_GEM = 13;
  
  public static final int NULL = 14;
  
  /*public static final int ORANGE = 4;
  public static final int BRONZE = 5;
  public static final int SILVER = 6;
  public static final int GOLD = 7;*/
}
/*
 @pjs preload="data/fonts/solarwinds.png,data/images/boards/board.png,data/images/boards/board_tightlypacked.png";
*/ 
 
/**
  Horadrix
  Andor Salga
  June 2013
*/

import ddf.minim.*;

final boolean DEBUG_CONSOLE_ON = false;
final boolean DEBUG_ON = false;
final boolean SHOW_ALL_TOKENS = true;

// This includes the entire board, including the 'queued' tokens not visible
// to the user, that sit above the token the user interacts with.
final int BOARD_COLS = 8;
final int BOARD_ROWS = 16;

// Only need y index
final int START_ROW_INDEX = 8;

final int TOKEN_SIZE = 32;

final int CANVAS_WIDTH = 620;
final int CANVAS_HEIGHT = DEBUG_ON ? 650 : 400;

// We define the board size in pixels and allow it to be any size
// and have the tokens center themselves inside those dimensions.
// This allows us to define a variable board size.
final int BOARD_W_IN_PX = TOKEN_SIZE * 8; //273;
final int BOARD_H_IN_PX = TOKEN_SIZE * 8; //273;

// 234 is the size of the diablo board.
// 28 is size of diablo token

// Where on the canvas the tokens start to be rendered.
int debugPosOffset = DEBUG_ON ? 150 : 0;
final int START_X = (int)(CANVAS_WIDTH/2.0f  - BOARD_W_IN_PX/2.0f);
final int START_Y = (int)(CANVAS_HEIGHT/2.0f - BOARD_H_IN_PX/2.0f) + debugPosOffset;

// Used by the AssetStore
PApplet globalApplet;

Token[][] board = new Token[BOARD_ROWS][BOARD_COLS];

ScreenSet screens = new ScreenSet();
ScreenStory screenStory;

SoundManager soundManager;

// Level progression stuff
final int NUM_LEVELS         = 4;
final int[] gemsRequired     = new int[]  {5, 10, 15, 20};
final float[] timePermitted  = new float[]{5,  8, 14, 20};

/*
  Wrap println so we can easily disable all console output on release
*/
void debugPrint(String str){
  if(DEBUG_CONSOLE_ON){
    println(str);
  }
}

void setup(){
  size(CANVAS_WIDTH, CANVAS_HEIGHT);
  
  // The style of the game is pixel art, so we don't want anti-aliasing
  noSmooth();
  
  globalApplet = this;
  
  // Start muted, because sound can be annoying.
  soundManager = new SoundManager(globalApplet);
  soundManager.init();
  soundManager.setMute(true);

  screenStory = new ScreenStory();

  screens.add(new ScreenSplash());
  screens.add(new ScreenGameplay());
  screens.add(new ScreenGameOver());
  screens.add(new ScreenWin());
  screens.add(screenStory);
  
  screens.transitionTo("splash");
}

void update(){
  screens.curr.update();
}

void draw(){
  update();
  screens.curr.draw();
}

public void mousePressed(){
  screens.curr.mousePressed();
}

public void mouseReleased(){
  screens.curr.mouseReleased();
}

public void mouseDragged(){
  screens.curr.mouseDragged();
}

public void mouseMoved(){
  screens.curr.mouseMoved();
}

public void keyPressed(){
  screens.curr.keyPressed();
}

public void keyReleased(){
  screens.curr.keyReleased();
}

/*
*
*/
function SoundManager(){

  var muted;

  var BASE_PATH = "data/audio/";

  var paths = [BASE_PATH + "fail_swap.ogg", BASE_PATH + "success_swap.ogg"];
  var sounds = [];

  var FAIL = 0;
  var SWAP = 1;

  /*
  */
  this.init = function(){
    var i;

    for(i = 0; i < paths.length; i++){
      sounds[i] = document.createElement('audio');
      sounds[i].setAttribute('src', paths[i]);
      sounds[i].preload = 'auto';
      sounds[i].load();
      sounds[i].volume = 0;
      sounds[i].setAttribute('autoplay', 'autoplay');
    }
  };

  /*
  *
  */
  this.setMute = function(mute){
    muted = mute;
  };

  /*
  */
  this.isMuted = function(){
    return muted;
  };

  /*
  */
  this.stop = function(){
    
  }

  /*
  */
  this.playSound = function(soundID){
    if(muted){
      return;
    }

    sounds[soundID].volume = 1.0;

    // Safari does not want to play sounds...??
    try{
      sounds[soundID].volume = 1.0;
      sounds[soundID].play();
      sounds[soundID].currentTime = 0;
    }catch(e){
      console.log("Could not play audio file.");
    }
  };

  this.playSuccessSwapSound = function(){
    this.playSound(SWAP);
  };

  this.playFailSwapSound = function(){
    this.playSound(FAIL);
  };
}
/*
    A token is an object the player moves in order to make matches.
    
    A token may have a gem within it. If the player destroys a token that
    has a gem inside it, we add that to the count in ScreenGameplay. After
    getting enough gems, the player can progress to the next level.
*/
public class Token{

  // States the token can be in
  private final int IDLE   = 0;
  private final int SWAPPING = 1;
  private final int FALLING = 2;
  private final int DYING  = 4;
  private final int DEAD   = 5;

  private final float MOVE_SPEED = TOKEN_SIZE * 2.25f; // token size per second
  private final float DROP_SPEED = 65;

  private int id;  
  private int state;

  // TODO: find better way of doing this?
  // When the token is falling, we need it to be a float
  // so just define it as a float to begin with.
  private int row;
  private int column;

  // When swapping or falling, a token is given a cell to go to.
  private int rowToMoveTo;
  private int colToMoveTo;

  private boolean hasArrivedAtDest;
  private PVector detachedPos;

  // Set this and decrement until we reach zero.
  private float distanceToMove;
  
  // !!! We can refactor this
  private int moveDirection;
  
  float test;
  
  private boolean isFillCellMarker;
  
  private int type;
  private boolean doesHaveGem;
  
  private boolean returning;
  
  private float scaleSize;

  // Use can select up to 2 tokens before they get swapped.
  private boolean isSelected;
  
  private int score;
    
  /*
  */
  public Token(){
    setType(TokenType.NULL);
    id = Utils.nextID();
    
    isSelected = false;
    test = 1.25f;//random(1, 2);
    
    row = 0;
    column = 0;
    
    doesHaveGem = false;
    scaleSize = 1.0f;
    
    // TODO: need to really need to set these?
    rowToMoveTo = -1;
    colToMoveTo = 0;
    moveDirection = 0;
    detachedPos = new PVector();
    
    returning = false;
    hasArrivedAtDest = false;
    state = IDLE;
    
    score = 100;
  }
  
  public void setScore(int s){
    if(s >= 0){
      score = s;
    }
  }
  
  public int getScore(){
    return score;
  }
  
  /**
  
  */
  public void setRowColumn(int row, int column){
    this.row = row;
    this.column = column;
  }
  
  public int getRow(){
    return row;
  }
  
  public int getColumn(){
    return column;
  }
  
  public int getType(){
    return type;
  }
  
  /**
      TODO: add check?
  */
  public void setType(int t){
    type = t;
  }
    
  public void setFillCellMarker(boolean b){
    isFillCellMarker = b;
  }
  
  public boolean getFillCellMarker(){
    return isFillCellMarker;
  }
  
  /*
    Used for debugging
  */
  public int getID(){
    return id;
  }
  
  /*
    When a token is selected, it is somehow outlined to show the user
    it is the 'current' token.
  */
  public void setSelect(boolean select){
    isSelected = select;
  }
  
  /**
    Immediately swap the position (row, column) of this token with another.
    Used to help testing if swapping will result in a match 3.
   */
  public void swap(Token other){
    int tempRow = row;
    int tempCol = column;
    
    this.setRowColumn(other.row, other.column);
    other.setRowColumn(tempRow, tempCol);    
  }
  
  public boolean isIdle(){
    return state == IDLE;
  }
  
  /**
    Gameplay doesn't keep track if it has already killed a token, so we have
    to keep track of it ourselves to make sure the ticker doesn't get reset.
    
    It only makes sense that falling or swapping tokens cannot be killed.
  */
  public void kill(){ 
    if(state == IDLE){
      state = DYING;
    }
  }
  
  /**
      If the token is dying it is in the process of animating its
      death, which might take a second or so. Once the death animation
      is finished, the token is considered dead.
  */
  public boolean isDying(){
    return state == DYING;
  }
  
  public boolean isFalling(){
    return state == FALLING;
  }
  
  public boolean isReturning(){
    return returning;
  }
  
  public void setReturning(boolean r){
    returning = r;
  }
  
  public boolean arrivedAtDest(){
    return hasArrivedAtDest;
  }
  
  /**
      
  */
  public boolean isMoving(){
    return moveDirection != 0;
  }
  
  /**
    TODO: fix this
  */
  public void dropIntoCell(){    
    int rTemp = row;
    int cTemp = column;
    
    row = rowToMoveTo;
    column = colToMoveTo;
    
    board[rowToMoveTo][colToMoveTo] = this;
    
    // could be swapping
    if(state == FALLING){
      // If the token hasn't been overwritten yet
      if(board[rTemp][cTemp] == this){
        Token nullToken = new Token();
        nullToken.setType(TokenType.NULL);
        nullToken.setRowColumn(rTemp, cTemp);
        board[rTemp][cTemp] = nullToken;
      }
    }
    
    hasArrivedAtDest = false;
    
    distanceToMove = 0;
    moveDirection = 0;
    
    state = IDLE;
  }
    
  /*
  */
  public void update(float td){
    
    if(state == FALLING || state == SWAPPING){
      float amtToMove = td * DROP_SPEED * moveDirection;
      
      if(row == rowToMoveTo){
        detachedPos.x += amtToMove;
      }
      else{
        detachedPos.y += amtToMove;
      }
      
      distanceToMove -= abs(amtToMove);
      
      // Don't set the state yet,
      if(distanceToMove <= 0){
        hasArrivedAtDest = true;
      }
    }
    else if(state == DYING){
      // Shrink the token if it is dying.
      scaleSize -= td * test;
      
      if(scaleSize <= 0){
        //scaleSize = 0.0f;
        state = DEAD;
      }
    }
  }
  
  /*
     Don't use isAlive for variable name because Processing.js gets confused
     with method and variable names that share the same name.
     
     Once the sprite completes its death animation, its state gets set to dead.
   */
  public boolean isAlive(){
    return state != DEAD;
  }
  
  public void setHasGem(boolean hasGem){
    doesHaveGem = hasGem;
  }
    
  /*
      Once the token is destroyed, the game screen will increment
      the number of gems the player has if this token had a gem.
  */
  public boolean hasGem(){
    return doesHaveGem;
  }
  
  /*
      Token needs to be valid and idle for it to be swapped.
  */
  public boolean canBeSwapped(){
    if(type == TokenType.NULL || state != IDLE || row < START_ROW_INDEX){
      return false;
    }
    return true;
  }
  
  /*
  *  The token can only be matched if its just sitting there. If it is dying/moving
  *  then we can't have that token get matched.
  */
  public boolean canBeMatched(){
    if(state != IDLE || type == TokenType.NULL){
      return false;
    }
    return true;
  }
  
  public void swapTo(int r, int c){
    state = SWAPPING;
    animateTo(r, c);
  }
  
  public void fallTo(int r, int c){
    state = FALLING;
    animateTo(r, c);
  }
  
  /*
      When the tokens fall, they are given new locations
      If they are already falling, they can fall to a new 'lower' location.
  */
  private void animateTo(int r, int c){    
    // If the token was already moving to another destination,
    // we need to assign it a new place to go to.
    
    // If we call animateTo, but the token is already falling, it means
    // the player made a match below this falling token. We are given the new
    // row and column, but need to recalculate the distance it needs to travel.
    if(state == FALLING && distanceToMove > 0){
      int oldRowToMoveTo = rowToMoveTo;
      int newRowToMoveTo = r;
      
      int distBetweenDsts = (newRowToMoveTo - oldRowToMoveTo) * TOKEN_SIZE;
      
      // Find the distance between the src and dst in the original movement
      float dst = (oldRowToMoveTo - r) * TOKEN_SIZE;

      rowToMoveTo = r;
      
      distanceToMove = distBetweenDsts + distanceToMove;
    }
    else{
      // column row swapped here!
      // TODO: fix !!! why are we dividing by 2? literal 8?
      int detachedX = (int)(column  * (BOARD_W_IN_PX / 8.0f) + ((BOARD_W_IN_PX / 8.0f)/2.0f ));
      int detachedY = (int)((row-8) * (BOARD_H_IN_PX / 8.0f) + ((BOARD_H_IN_PX / 8.0f)/2.0f ));
      detachedPos = new PVector(detachedX, detachedY);

      rowToMoveTo = r;
      colToMoveTo = c;
      
      // Either we are moving the token vertically or horizontally
      if(c == column){
        int rowDiff = rowToMoveTo - row;
        distanceToMove = abs(rowDiff) * TOKEN_SIZE;
        moveDirection = rowDiff / abs(rowDiff);
      }
      else if(r == row){
        int columnDiff = colToMoveTo - column;
        distanceToMove = abs(columnDiff) * TOKEN_SIZE;
        moveDirection = columnDiff / abs(columnDiff);
      }
    }
  }
  
  /*
    Calculates the air speed velocity of an unladen swallow.
  */
  public void draw(){
    int x = 0; 
    int y = 0;
    
    if(state == FALLING || state == SWAPPING){
      x = (int)detachedPos.x;
      y = (int)detachedPos.y;
    }
    else{
      x = (int)(column * (BOARD_W_IN_PX / 8.0f) + ((BOARD_W_IN_PX / 8.0f)/2.0 ));
      
      // 8 here is the number of visible rows. We need to essentially move the visible tokens up
      // where the invisible ones would be drawn.
      y = (int)((row-8) * (BOARD_H_IN_PX / 8.0f) + ((BOARD_H_IN_PX / 8.0f)/2.0 ));
    }
    
    // Draw a rectangle around the selected tokens
    if(isSelected){
      pushStyle();
      fill(33, 66, 99);
      rectMode(CENTER);
      fill(255, 0, 0, 255);
      strokeWeight(2);
      stroke(255);
      rect(x, y, TOKEN_SIZE, TOKEN_SIZE);
      popStyle();
    }
    
    /*if(canBeMatched()){
      pushStyle();
      fill(99, 66, 33,33);
      rectMode(CENTER);
      //fill(255, 0, 0, 255);
      strokeWeight(0);
      stroke(255);
      rect(x, y, TOKEN_SIZE, TOKEN_SIZE);
      popStyle();
    }*/

    // pjs giving issues here
    pushMatrix();
    resetMatrix();
    
    translate(START_X, START_Y);
    translate(x, y);
    
    rectMode(CENTER);
    
    // draw a grey box to easily identify dead or null tokens
    if(DEBUG_ON && (state == DEAD || state == DYING || type == TokenType.NULL)){
      pushStyle();
      fill(128,128);
      rect(0, 0, TOKEN_SIZE, TOKEN_SIZE);
      popStyle();
    }

    // Draws an outline around all tokens
    if(DEBUG_ON){
      pushStyle();
      noFill();
      stroke(255,64);
      rect(0, 0, TOKEN_SIZE, TOKEN_SIZE);
      popStyle();
    }
    
    /*if(row < START_ROW_INDEX && DEBUG_ON){
      pushStyle();
      rectMode(CENTER);
      fill(255, 255, 255, 32);
      rect(0, 0, TOKEN_SIZE, TOKEN_SIZE);
      popStyle();
    }*/
    
    // We need to somehow distinguish tokens that have gems.
    if(hasGem() && state != DYING){
      pushStyle();
      
      fill(255 * sin(frameCount/10.0), 60, 90, 128);
      //rect(0, 0, TOKEN_SIZE, TOKEN_SIZE);
      ellipseMode(CENTER);
      ellipse(0,0, TOKEN_SIZE, TOKEN_SIZE);
      popStyle();
    }
    
    // 
    if(state == DYING){
      scale(scaleSize >= 0 ? scaleSize : 0);
    }
    
    if(state != DEAD && type != TokenType.NULL){
      AssetStore store = AssetStore.Instance(globalApplet);
      pushStyle();
      imageMode(CENTER);
      image(store.get(type), 0, 0);
      popStyle();
    }
    
    popMatrix();
  }

  /*
      Instead of directly checking the type between tokens, we
      have a method that just asks if it can match with whatever. This 
      allows us to later on match tokens with wildcards.
  */
  public boolean matchesWith(int other){
    if(type == TokenType.NULL){
      return false;
    }
    return type == other;
  }  
}
public class Tuple{
  private Object first, second;
  
  public Tuple(){
    first = second = null;
  }
  
  public void swap(){
    Object temp = first;
    first = second;
    second = temp;
  }
  
  public Object getFirst(){
    return first;
  }
  
  public Object getSecond(){
    return second;
  }
 
  public void setFirst(Object first){
    this.first = first;
  }
  
  public void setSecond(Object second){
    this.second = second;
  }
  
  public int numObjects(){
    if(isEmpty()){
      return 0;
    }
    if(isFull()){
      return 2;
    }
    return 2;
  }
  
  public boolean isFull(){
    return first != null && second != null;
  }
  
  public boolean isEmpty(){
    return first == null && second == null;
  } 
}
import processing.core.*;

/*
 *  Single location that stores only 1 copy of the assets we require.
 */
public class AssetStore{
    
  private static PApplet app;
  private static AssetStore instance;
  
  private String BASE_IMG_PATH = "data/images/gems/diablo/";
  private PImage[] images;
  private String[] imageNames = {  "A.png","B.png", "C.png", "D.png", "E.png", "F.png", "G.png"};
  
  /*  
   */
  public PImage get(int asset){
    return images[asset];
  }
  
  /* As soon as this is contructed, load all the assets
   */
  private AssetStore(){    
    images = new PImage[imageNames.length];
    
    for(int i = 0; i < imageNames.length; i++){
      images[i] = app.loadImage(BASE_IMG_PATH + imageNames[i]);
    }
  }
  
  /* Not an ideal way of getting an instance, but not much
   * we can do about it.
   */
  public static AssetStore Instance(PApplet applet){
    if(instance == null){
      app = applet;
      instance = new AssetStore();
    }
    return instance;
  }
}
/*
    
*/
public interface IScreen{
  
  public void draw();
  public void update();
  
  // Mouse methods
  public void mousePressed();
  public void mouseReleased();
  public void mouseDragged();
  public void mouseMoved();
  
  public void keyPressed();
  public void keyReleased();
  public void OnTransitionTo();
  
  public String getName();
}
/*
    Displays game name and credits
*/
public class ScreenSplash implements IScreen{

  Ticker ticker;
  
  RetroFont solarWindsFont;

  RetroLabel creditsLabel;
  RetroLabel loadingLabel;
  RetroLabel mainTitleLabel;
  
    public void OnTransitionTo(){
  }


  public ScreenSplash(){
    ticker = new Ticker();
    
    // TODO: convert this to a singleton or factory.
    solarWindsFont = new RetroFont("data/fonts/solarwinds.png", 14, 16, 2);
    
    mainTitleLabel = new RetroLabel(solarWindsFont);
    mainTitleLabel.setText("H O R A D R I X");
    mainTitleLabel.pixelsFromCenter(0, 0);
    
    creditsLabel = new RetroLabel(solarWindsFont);
    creditsLabel.setText("Code & Art: Andor Salga");
    creditsLabel.setVerticalSpacing(0);
    creditsLabel.setHorizontalTrimming(true);
    creditsLabel.pixelsFromBottomLeft(0, 0);

    loadingLabel = new RetroLabel(solarWindsFont);
    loadingLabel.setHorizontalTrimming(true);
    loadingLabel.setText("Loading....");
    loadingLabel.pixelsFromCenter(0, 50);
  }
  
  /**
  */
  public void draw(){
    background(0);
    
    mainTitleLabel.draw();
    creditsLabel.draw();
    loadingLabel.draw();
  }
  
  public void update(){
    ticker.tick();
    if(ticker.getTotalTime() > 0.5f){
      //screens.transitionTo("gameplay");
      screens.transitionTo("story");
    }
  }
  
  public String getName(){
    return "splash";
  }
  
  public void keyReleased(){}
  public void keyPressed(){}
  
  public void mousePressed(){}
  public void mouseReleased(){}
  public void mouseDragged(){}
  public void mouseMoved(){}
}
/*
 * JS Utilities interface
 */
var Utils = {

  /*
    Used to identify tokens.
  */
  nextID: function(){
    var inc = 
      (function(){
         var id = -1;
         return function(){
           id++;
         }
       })();
    return inc();
  },

  /*   
   */
  charCodeAt: function(ch){
    return ch.charCodeAt(0);
  },

  /*
   * 
   */
  getRandomInt: function(minVal, maxVal){
    var scale = Math.random();
    return minVal + Math.floor(scale * (maxVal - minVal + 1));
  },
  
  Lerp: function(a, b, p){
  	return a * (1-p) + (b * p);
  },
  
  floatToInt:function(f){
    return Math.floor(f);
  },
  
  /*
  */
  prependStringWithString: function(baseString, prefix, newStrLength){
    var zerosToAdd, i;

    if(newStrLength <= baseString.length()){
      return baseString;
    }
    
    zerosToAdd = newStrLength - baseString.length();
    
    for(i = 0; i < zerosToAdd; i++){
      baseString = prefix + baseString;
    }
    
    return baseString;
  }
}

/*
    This screen is the main gameplay screen.
*/
public class ScreenGameplay implements IScreen, Subject{
  
  // Tokens that have been remove from the board, but still need to be rendered for their
  // death animation.
  ArrayList<Token> dyingTokens;
  
  ArrayList<LayerObserver> layerObserver;

  PImage bk;
  PImage bk2;
  
  // These are used to specify the direction of checking
  // matches in numMatchesSideways and numMatches
  private final int LEFT = -1;
  private final int RIGHT = 1;
  private final int UP = -1;
  private final int DOWN = 1;
  
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
  private int numGemsAllowedAtOnce = 2;
  private int numGemsOnBoard = 0;
  
  // This is immediately incremented in the ctor by calling goToNextLevel().
  int currLevel = 0;
  
  // User can only be in the process of swapping two tokens
  // at any given time.
  Token swapToken1 = null;
  Token swapToken2 = null;
  
  // As the levels increase, more and more token types are added
  // This makes it a slightly harder to match tokens.
  int numTokenTypesOnBoard = 4;
  
  Token currToken1 = null;
  Token currToken2 = null;
  
  int score = 0;
  
  public void addObserver(LayerObserver o){
    layerObserver.add(o);
    // recalculate indices
  }
  
  public void removeObserver(LayerObserver o){
    // recalc?
  }
  
  public void notifyObservers(){
    for(int i = 0; i < layerObserver.size(); i++){
      layerObserver.get(i).notifyObserver();
    }
  }
  
  
  /**
  */
  ScreenGameplay(){
    timer = new Ticker();
    
    LayerObserver hudLayer = new HUDLayer(this);
    
    gemsRequiredForLevel = gemsRequired[currLevel];

    dyingTokens = new ArrayList<Token>();
    
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
    
    //debugTicker = new Ticker();
    debug = new Debugger();
   
    // lock P for pause
    Keyboard.lockKeys(new int[]{KEY_P});
    
    drawBoxUnderCursor = false;
    
    fillBoardWithRandomTokens();
    deselectCurrentTokens();
    
    // levelCountDownTimer is set in this method.
    goToNextLevel();
  }
  
  /*
  */
  public void draw(){

    background(0);
    
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
        
    drawBoard();
    
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
    
    // Draw a box around the grid, just for debugging.
    //noFill();
    //stroke(255);
    //strokeWeight(1);
    //rect(0, 350, TOKEN_SIZE, 320);
    
    popMatrix();
    
    // HACK: This line is here as a workaround a bug in Processing.js
    // If removed, the board would translate diagonally on the canvas.
    // when tokens are removed.
    resetMatrix();
    
    if(layerObserver != null){
      for(int i = 0; i < layerObserver.size(); i++){
        layerObserver.get(i).draw();
      }
    }
    
    debug.draw();
  }
  
  /**
   */
  public void update(){
    
    // TODO: fix
    // Need to notify that we are paused so the HUD can draw an overlay
    if(isPaused){
      notifyObservers();
      return;
    }
    
    // INSTANT DEATH - for some reason, can't set it to 1 second
    if(Keyboard.isKeyDown(KEY_I)){
      levelCountDownTimer.setTime(0, 3);
    }
    
    // NEW BOARD
    if(Keyboard.isKeyDown(KEY_N)){
      // Generating a new board while swapping is unlikely, but prevent it anyway, just in case.
      if(dyingTokens.size() == 0 && swapToken1 == null && swapToken2 == null){
        generateNewBoardWithDyingAnimation(true);
      }
    }
    
    // DROP TOKENS
    if(Keyboard.isKeyDown(KEY_D)){
      dropTokens();
    }
        
    timer.tick();
    float td = timer.getDeltaSec();
    
    // Once the player meets their quota...
    if(gemsWonByPlayer >= gemsRequiredForLevel){
      println("gemsWonByPlayer: " + gemsWonByPlayer);
      println("gemsRequiredForLevel: " + gemsRequiredForLevel);
      
      println("going to next level");
      goToNextLevel();    
    }
        
    debug.clear();
    
    levelCountDownTimer.tick();
    
    int numTokensArrivedAtDest = 0;
        
    // Now, update the two tokens that the user has swapped
    if(swapToken1 != null){
      swapToken1.update(td);
      swapToken2.update(td);
      
      if(swapToken1.arrivedAtDest() && swapToken1.isReturning() == false && swapToken1.isMoving()){
        //
        // Need to drop into the cells before check if it was indeed a valid swap
        swapToken1.dropIntoCell();
        swapToken2.dropIntoCell();
        
        int matches = getNumCosecutiveMatches(swapToken1, swapToken2);
        
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
                
          //soundManager.playFailSwapSound();
        }
        // Swap was valid
        else{
          swapToken1 = swapToken2 = null;
          markTokensForRemoval(false);
          removeMarkedTokens(true);
          dropTokens();
          deselectCurrentTokens();
          // !!!
          //soundManager.playSuccessSwapSound();
        } 
      }
      // 
      else if(swapToken1.arrivedAtDest() && swapToken1.isReturning()){
        swapToken1.dropIntoCell();
        swapToken2.dropIntoCell();
        swapToken1.setReturning(false);
        swapToken2.setReturning(false);
        
        swapToken1 = swapToken2 = null;
      }
    }
    
    // TODO: refactor?
    // Iterate over all the tokens that are dying and increase the score.
    for(int i = 0; i < dyingTokens.size(); i++){
      
      Token dyingToken = dyingTokens.get(i);
      
      dyingToken.update(td);
      
      if(dyingToken.isAlive() == false){
        
        if(dyingToken.hasGem()){
          gemsWonByPlayer++;
          numGemsOnBoard--;
        }
        
        addToScore(dyingToken.getScore());
        
        dyingTokens.remove(i);
        tokensDestroyed++;
      }
    }
    
    if(DEBUG_ON){
      debug.addString("dyingTokens: " + dyingTokens.size());
    }
    
    // Update all tokens on board. This includes the falling tokens
    for(int r = BOARD_ROWS - 1; r >= 0 ; r--){
      for(int c = 0; c < BOARD_COLS; c++){
        Token t = board[r][c]; 
        t.update(td);
        
        if(t.isFalling() && t.arrivedAtDest()){
          t.dropIntoCell();
          numTokensArrivedAtDest++;
          
          // If the top token arrived at its destination, it means we can safely fill up tokens above it.
          if(t.getFillCellMarker()){
            fillInvisibleSectionOfColumn(t.getColumn());
            setFillMarker(t.getColumn());
          }
        }
      }
    }
    
    // Probably the most logical place to ensure the number of gems on the board is right here
    // Doing it on level start is actually tricker, since the only tokens that exist are the ones at the top
    // that are faling down.
    if(tokensDestroyed > 0){
      addGemsToQueuedTokens();
    }

    //
    if(numTokensArrivedAtDest > 0){
      markTokensForRemoval(false);
      removeMarkedTokens(true);
      dropTokens();
    }

    resetMatrix();
    
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
  
  /**
   * Tokens that are considrered too far to swap include ones that
   * are across from each other diagonally or have 1 token between them.
   */
  public boolean isCloseEnoughForSwap(Token t1, Token t2){
    // !!!
    return abs(t1.getRow() - t2.getRow()) + abs(t1.getColumn() - t2.getColumn()) == 1;
  }
    
  public void mouseMoved(){}
  public void mouseReleased(){}
  
  /*
   *
   */
  public void mousePressed(){
    
    if(isPaused){
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
      currToken1 = board[r][c];
      
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
      
      currToken2 = board[r][c];
      
      // Same as a few lines above.
      if(currToken2.canBeSwapped() == false){
        currToken2 = null;
        return;
      }
      
      // User clicked on a token that's too far to swap with the one already selected
      // In that case, what they are probably doing is starting the 'swap process' over.
      if( isCloseEnoughForSwap(currToken1, currToken2) == false){
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
        currToken2 = board[r][c];
        
        // If they dragged to an empty cell, we have to back out.
        if(currToken2.canBeSwapped() == false){
          currToken2 = null;
          return;
        }
                
        if(isCloseEnoughForSwap(currToken1, currToken2) == false){
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
  
  /**
    Speed: O(n)
    Returns true as soon as it finds a valid swap/move.
    
    Checks to see if the user can make a valid match anywhere in the visible part of the board.
    In case there are no valid swap/moves left, the board needs to be reset.
  */
  private boolean validSwapExists(){
    
    // First check any potential matches in the horizontal
    for(int r = START_ROW_INDEX; r < BOARD_ROWS; r++){
      for(int c = 0; c < BOARD_COLS - 1; c++){
        
        Token t1 = board[r][c];
        Token t2 = board[r][c + 1];
        
        swapTokens(t1, t2);
        int matches = getNumCosecutiveMatches(t1, t2);
        swapTokens(t1, t2);
        
        if(matches >= 3){
          return true;
        }
      }
    }
    
    // Check any potential matches in the vertical
    for(int c = 0; c < BOARD_COLS; c++){  
      for(int r = START_ROW_INDEX; r < BOARD_ROWS - 1; r++){
        
        Token t1 = board[r][c];
        Token t2 = board[r + 1][c];
        
        swapTokens(t1, t2);
        int matches = getNumCosecutiveMatches(t1, t2);
        swapTokens(t1, t2);
        
        if(matches >= 3){
          return true;
        }
      }
    }
    return false;
  }
  
  /*
  */
  int getRandomTokenType(){
    return Utils.getRandomInt(0, numTokenTypesOnBoard-1);
  }
  
  /*
    Find any null tokens on the board and replace them with a random token.
    
    This is used at the start of the level when trying to generate a board
    that initially has no matches.
    
    @return {int} Num holes/cells filled.
  */
  private int fillHoles(boolean forTopPart){
    int numFilled = 0;
    
    int startRow = forTopPart ? 0 : START_ROW_INDEX;
    
    for(int r = startRow; r < startRow + (BOARD_ROWS/2); r++){
      for(int c = 0; c < BOARD_COLS; c++){
        if(board[r][c].getType() == TokenType.NULL){
          board[r][c].setType(getRandomTokenType());
          numFilled++;
        }
      }
    }
    return numFilled;
  }
  
  /**
      Several columns may be dropping down tokens, but once a column
      is finished dropping its gems, it should immediately fill up the holes.
      
      Note this does not change whether the token has a gem or not.
  */
  void fillInvisibleSectionOfColumn(int c){
    for(int r = 0; r < START_ROW_INDEX; r++){
      if(board[r][c].getType() == TokenType.NULL){
        Token t = new Token();
        t.setType(getRandomTokenType());
        t.setRowColumn(r, c);
        board[r][c] = t;
      }
    }
  }

  /**
      TODO: refactor 'ok'
      From bottom to top, search to find first gap
      After finding the first gap, set the marker
      Find first token, set dst to marker
      Increment marker by 1
      Find next token     
  */
  void dropTokens(){
    
    for(int c = 0; c < BOARD_COLS; c++){
      boolean ok = false;
      int dst = BOARD_ROWS;
      int src;
      
      while(dst >= 2){
        dst--;
        if(board[dst][c].getType() == TokenType.NULL || board[dst][c].isDying() ){
          ok = true;
          break;
        }
      }
      
      // Don't subtract 1 because we do that already in the next line
      src = dst;
      while(src >= 1){
        src--;
        if(board[src][c].getType() != TokenType.NULL || board[src][c].isDying() ){
          break;
        }
      }
      
      while(src >= 0){
        // move the first token
        if(ok){
          Token tokenToMove = board[src][c];
          tokenToMove.fallTo(dst, c);
        }
        do{
          src--;
        }while(src >= 1 && board[src][c].getType() == TokenType.NULL);
        
        dst--;
      }
    }
  }
  
  /**
    Find any 3 matches either going vertically or horizontally and
    remove them from the board. Replace the cells in the board will NULL tokens.
    
    @returns the number of tokens this method found that need to be removed.    
  */
  int markTokensForRemoval(boolean forTopPart){
    
    int numTokensMarked = 0;    
    
    int startRow = forTopPart ? 0 : START_ROW_INDEX;
    int endRow = forTopPart ? 7 : 15;
    
    // Mark the matched horizontal gems
    // TODO: Add extra column buffer at end of board to fix matches counter?
    for(int r = startRow; r <= endRow; r++){
      
      // start with the first token in the first column as the thing we want to match against.
      int tokenTypeToMatchAgainst = board[r][0].getType();
      
      // start of matched row
      int markerIndex = 0;
      int matches = 1;
      
      for(int c = 1; c < BOARD_COLS; c++){
        
        // Found a match, keep going...
        if(board[r][c].matchesWith(tokenTypeToMatchAgainst) && board[r][c].canBeMatched()){
          matches++;
        }
        // We bank on finding a different gem. Once that happens, we can see if
        // we found enough of the previous gems. Didn't find 3 matches, start over.
        else if( (board[r][c].matchesWith(tokenTypeToMatchAgainst) == false) && matches < 3){
          matches = 1;
          markerIndex = c;
          tokenTypeToMatchAgainst = board[r][c].getType();
        }
        // We need to also do it at the end of the board
        // Did we reach the end of the board?
        else if( (board[r][c].matchesWith(tokenTypeToMatchAgainst) == false && matches >= 3) || (c == BOARD_COLS - 1 && matches >= 3)){
          
          for(int gemC = markerIndex; gemC < markerIndex + matches; gemC++){
            board[r][gemC].kill();
            numTokensMarked++;
          }
          matches = 1;
          markerIndex = c;
          tokenTypeToMatchAgainst = board[r][c].getType();
        }
      }
      
      // TODO: fix
      if(matches >= 3){
        for(int gemC = markerIndex; gemC < markerIndex + matches; gemC++){
          board[r][gemC].kill();
          numTokensMarked++;
        }
      }
    }
    
    //
    // Now do the columns...
    //
    // Add extra column buffer at end of board to fix matches counter?
    for(int c = 0; c < BOARD_COLS; c++){
      int tokenTypeToMatchAgainst = board[startRow][c].getType();
      int markerIndex = startRow;
      int matches = 1;
      
      for(int r = startRow + 1; r <= endRow; r++){
        
        if(board[r][c].matchesWith(tokenTypeToMatchAgainst) && board[r][c].canBeMatched()){
          matches++;
        }
        // We bank on finding a different gem. Once that happens, we can see if
        // we found enough of the previous gems.
        else if(board[r][c].matchesWith(tokenTypeToMatchAgainst) == false && matches < 3){
          matches = 1;
          markerIndex = r;
          tokenTypeToMatchAgainst = board[r][c].getType();
        }
        // Either we found a non-match after at least finding a match 3, or the last match was at the end of the column.
         else if(  (board[r][c].matchesWith(tokenTypeToMatchAgainst) == false && matches >= 3) || (r == endRow && matches >= 3)){
          
          for(int gemR = markerIndex; gemR < markerIndex + matches; gemR++){
            board[gemR][c].kill();
            numTokensMarked++;
          }
          matches = 1;
          markerIndex = r;
          tokenTypeToMatchAgainst = board[r][c].getType();
        }
      }
      
      if(matches >= 3){
        for(int gemR = markerIndex; gemR < markerIndex + matches; gemR++){
            board[gemR][c].kill();
            numTokensMarked++;
        }
      }
    }
    
    if(numTokensMarked >= 3){
      //soundManager.playSuccessSwapSound();
    }

    return numTokensMarked;
  }
  
  /*
    A swap of two gems is only valid if it results in a row or column of 3 or more 
    gems of the same type getting lined up.
  */
  private int getNumCosecutiveMatches(Token t1, Token t2){
    // When the player selects a token on the other side of the board,
    // we still call wasValidSwap, which checks here if the tokens are too far apart to match.
    if(isCloseEnoughForSwap(t1, t2) == false){
      return 0;
    }
   
    int matches = numMatchesSideways(t1, LEFT) + numMatchesSideways(t1, RIGHT);
    if(matches >= 2){
      return matches + 1;
    }
    
    matches = numMatchesSideways(t2, LEFT) + numMatchesSideways(t2, RIGHT);
    if(matches >= 2){
      return matches + 1;
    }
    
    matches = numMatchesUpDown(t1, UP) + numMatchesUpDown(t1, DOWN);
    if(matches >= 2){
      return matches + 1;
    }
    
    matches = numMatchesUpDown(t2, UP) + numMatchesUpDown(t2, DOWN);
    return matches + 1;
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
   * Return how many tokens match this one on its left or right side
   * Does not include the count of the token itself.
   */
  public int numMatchesSideways(Token token, int direction){
    int currColumn = token.getColumn();
    int tokenRow = token.getRow();
    int matchesFound = 0;
    int type = token.getType();
    
    // Watch for going out of bounds
    while(currColumn >= 0 && currColumn < BOARD_COLS && board[tokenRow][currColumn].matchesWith(type)){
      matchesFound++;
      currColumn += direction;
    }

    // matchesFound included the token we started with to
    // keep the code in this funciton short, but we have to
    // only return the number of matched tokens excluding it.
    return matchesFound - 1;
  }
  
  /*
      We can only match up until the visible part of the board
      returns the number of matching types excluding this one.
  */
  public int numMatchesUpDown(Token token, int direction){
    int row = token.getRow();
    int matchesFound = 0;
    int type = token.getType();
    int tokenColumn = token.getColumn();
   
    while(row >= START_ROW_INDEX && row < BOARD_ROWS && board[row][tokenColumn].matchesWith(type)){
      matchesFound++;
      row += direction;
    }
    
    return matchesFound -1;
  }
  
  /**
  */
  public void swapTokens(Token token1, Token token2){
    
    int token1Row = token1.getRow();
    int token1Col = token1.getColumn();
  
    int token2Row = token2.getRow();
    int token2Col = token2.getColumn();
  
    // Swap on the board and in the tokens
    board[token1Row][token1Col] = token2;
    board[token2Row][token2Col] = token1;
    
    token2.swap(token1);
  }
  
  /*
      Fills the board with random tokens and makes sure
      there are no immediate matches (at least ones that are displayed)
  */
  void fillBoardWithRandomTokens(){
    
    // Stupidly just fill the board with random tokens first.
    for(int r = 0; r < BOARD_ROWS; r++){
      for(int c = 0; c < BOARD_COLS; c++){
        Token token = new Token();
        token.setType(getRandomTokenType());
        token.setRowColumn(r, c);
        board[r][c] = token;
      }
    }
    
    // Now start removing immediate matches where tokens are displayed.
    while(markTokensForRemoval(false) > 0){
      removeMarkedTokens(false);      
      fillHoles(false);
    }
    
    setFillMarkers();
        
    if(validSwapExists() == false){
      generateNewBoardWithDyingAnimation(true);
      println("**** no moves remaining ****");
    }
  }
  
  private void setFillMarker(int c){
    board[0][c].setFillCellMarker(true);
  }
  
  private void setFillMarkers(){
    for(int c = 0; c < BOARD_COLS; c++){
      board[0][c].setFillCellMarker(true);
    }
  }
  
  /*
   */
  void drawBoard(){
    
    pushStyle();
    noFill();
    stroke(255);
    strokeWeight(2);
    
    //rect(-TOKEN_SIZE/2, -TOKEN_SIZE/2, BOARD_COLS * TOKEN_SIZE, BOARD_ROWS * TOKEN_SIZE);
    
    // Draw lower part of the board
    //rect(-TOKEN_SIZE/2, -TOKEN_SIZE/2 + START_ROW_INDEX * TOKEN_SIZE, BOARD_COLS * TOKEN_SIZE, BOARD_ROWS * TOKEN_SIZE - 220);
    popStyle();

    // Part of the invisible board needs to be drawn because
    // the tokens coming into to the board need to be shown animating in.    
    for(int r = 0; r < START_ROW_INDEX; r++){
      for(int c = 0; c < BOARD_COLS; c++){
        if(DEBUG_ON){
          board[r][c].draw();
        }
        else{
          if(board[r][c].isMoving()){
            board[r][c].draw();
          }
        }
      }
    }
    
    int startRow = DEBUG_ON ? 0 : START_ROW_INDEX;
    
    // Draw the visible part to the player
    for(int r = startRow; r < BOARD_ROWS; r++){
      for(int c = 0; c < BOARD_COLS; c++){
        board[r][c].draw();
      }
    }
  }
  
  /**
        Select a random token in the invisible part of the board 
        and add a gem to it if it doesn't already have one.
        
        Used when the player clears a gem from board and we have to 'replace' it.
  */
  private void addGemsToQueuedTokens(){
    while(numGemsOnBoard < numGemsAllowedAtOnce){
      // We can only add the gem to the part of the board the user doesn't see.
      // Don't forget getRandom int is inclusive.
      int r = Utils.getRandomInt(0, START_ROW_INDEX - 1);
      int c = Utils.getRandomInt(0, BOARD_COLS - 1);
      Token token = board[r][c];
      
      if(token.hasGem() == false){
        token.setHasGem(true);
        numGemsOnBoard++;
      }
    }
  }
  
  /*
      Move the tokens that have been marked for deletion from
      the board to the dying tokens list.
      
      @returns {int} The number of tokens removed from the board.
   */
  private int removeMarkedTokens(boolean doDyingAnimation){
    int numRemoved = 0;
    
    // Now delete everything marked for deletion.
    for(int r = 0; r < BOARD_ROWS; r++){
      for(int c = 0; c < BOARD_COLS; c++){
        
        Token tokenToDestroy = board[r][c];
        
        // Don't need to check if already in the list because we're removing it from
        // the board, so it can never be placed from the board into the dying token list more than once.
        if(tokenToDestroy.isDying() ){//|| tokenToDestroy.isAlive() == false){
          //tokenToDestroy.kill();
          numRemoved++;
          // On setup we use this method, but we don't actually want to play the animation.
          if(doDyingAnimation){
            dyingTokens.add(tokenToDestroy);
          }
          
          // Replace the token we removed with a null Token
          createNullToken(r, c);
        }
        // !!! TODO: check
        board[r][c].setSelect(false);
      }
    }
    
    return numRemoved;
  }
  
  private void createNullToken(int r, int c){
    Token nullToken = new Token();
    nullToken.setType(TokenType.NULL);
    nullToken.setRowColumn(r, c);
    board[r][c] = nullToken;
  }
  
  void keyPressed(){
    Keyboard.setKeyDown(keyCode, true);
    
    // P key is locked
    isPaused = Keyboard.isKeyDown(KEY_P);
    if(isPaused){
      timer.pause();
      levelCountDownTimer.pause();
    }
    
    if(Keyboard.isKeyDown(KEY_L)){
      goToNextLevel();
    }
  }
  
  /**
  */
  void keyReleased(){
    Keyboard.setKeyDown(keyCode, false);
    
    //soundManager.setMute(!soundManager.isMuted());
    
    isPaused = Keyboard.isKeyDown(KEY_P);
    if(isPaused == false){
      timer.resume();
      levelCountDownTimer.resume();
    }
  }  

  public int getNumGems(){
    return gemsWonByPlayer;
  }
  
  public boolean Paused(){
    return isPaused;
  }
  
  public int getNumGemsForNextLevel(){
    //println(gemsRequiredForLevel);
    
    return gemsRequiredForLevel;
  }
  
  /**
      This can only be done if nothing is moving or animating to make
      sure they board stays in a proper state.
  */
  public void generateNewBoardWithDyingAnimation(boolean dieAnim){        
    
    fillBoardWithRandomTokens();
    
    // Kill all the tokens on the visible part of the board
    for(int c = 0; c < BOARD_COLS; c++){
      for(int r = START_ROW_INDEX; r < BOARD_ROWS; r++){
        // Set score to zero so once they die, the score total isn't changed.
        board[r][c].setScore(0);
        board[r][c].kill();
        if(dieAnim){
          dyingTokens.add(board[r][c]);
        }
        
        createNullToken(r,c);        
      }
    }
    
    // The invisible part of the board will drop down, so we need to 
    // remove all immediate matches so there are no matches as soon as it falls.
    while(markTokensForRemoval(true) > 0){
      removeMarkedTokens(false);
      fillHoles(true);
    }
    
    // We don't want any gems to appear on the board on init, just based on design
    removeAllGemsFromBoard();
    
    // TODO: comment !!!
    setFillMarkers();
    
    dropTokens();
  }
  
  /*
  */
  private void removeAllGemsFromBoard(){
    numGemsOnBoard = 0;
    for(int c = 0; c < BOARD_COLS; c++){
      for(int r = 0; r < BOARD_ROWS; r++){
        board[r][c].setHasGem(false);
      }
    }
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
    // prevent goToNextLeve from running as soon as the level loads
    //gemsWonByPlayer = 0;
    
    screenStory.nextLevel();
    screens.transitionTo("story");
      currLevel++;
   
  }
  
  /**
      Need to clear off all the crap that was happeneing in the last level
  */
  public void OnTransitionTo(){
    //println("On Transition To");
    tokensDestroyed = 0;
    dyingTokens.clear();
   // generateNewBoardWithDyingAnimation(false);
    
    
     // Should the score be reset?
    // score = 0;
    gemsWonByPlayer = 0;
    gemsRequiredForLevel = gemsRequired[currLevel];
    
    // Still playing around with this to make later levels challenging.
    levelCountDownTimer = new Ticker();
    levelCountDownTimer.setTime(timePermitted[currLevel]);
    levelCountDownTimer.setDirection(-1);
    
    if(currLevel == 4){
      numTokenTypesOnBoard++;
    }
    
    generateNewBoardWithDyingAnimation(false);
    //fillBoardWithRandomTokens();
  }
}
