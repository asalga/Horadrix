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
  
  // When a match is created, the matched tokens are removed from the board array
  // and 'float' above the board and drop down until they arrive where they need to go.
  // We do this because as they fall, we can't give them a integer position, but need to
  // use a float.
  //ArrayList<Token> floatingTokens;

  // These are used to specify the direction of checking
  // matches in numMatchesSideways and numMatches
  private final int LEFT = -1;
  private final int RIGHT = 1;
  private final int UP = -1;
  private final int DOWN = 1;
  
  private final int TOKEN_SCORE = 100;
  
  // time it takes for the tokens above the ones that were destroyed to start falling down.
  private float DELAY_PAUSE = 2.5f; 
  //0.035f; 
  
  // Only for debugging to see which token would be selected
  // by the player.
  public boolean drawBoxUnderCursor;
  
  Debugger debug;
  
  Ticker levelCountDownTimer;
  Ticker timer;
  
  int tokensDestroyed = 0;
  
  boolean isPaused = false;
  
  int gemCounter = 0;
  int gemsRequiredForLevel = 0;
  
  // This is immediately incremented in the ctor by calling goToNextLevel().
  int currLevel = 0;
  
  // User can only be in the process of swapping two tokens
  // at any given time.
  Token swapToken1 = null;
  Token swapToken2 = null;
  
  // As the levels increase, more and more token types are added
  // This makes it a slightly harder to match tokens.
  int numTokenTypesOnBoard = 4;
  
  // 
  int numGemsOnBoard = 2;
  
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
    
    gemsRequiredForLevel = currLevel * 5;
  
    //floatingTokens = new ArrayList<Token>();
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
    //println("dying tokens: " + dyingTokens.size());
    
    //for(int i = 0; i < floatingTokens.size(); i++){
    //  floatingTokens.get(i).draw();
    // }
    
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
    /*if(DEBUG_ON == false){
      pushStyle();
      fill(0);
      noStroke();
      //stroke(128, 0,0);
      rect(0, -100, 260, 100);
      //rect(START_X-150, -237, 250, 222);
      popStyle();
    }*/
    
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
      generateNewBoard();
    }
    
    // DROP TOKENS
    if(Keyboard.isKeyDown(KEY_D)){
      dropTokens();
    } 
    
    timer.tick();
    float td = timer.getDeltaSec();
    
    // Once the player meets their quota...
    if(gemCounter >= gemsRequiredForLevel){
      goToNextLevel();    
    }
        
    debug.clear();
    
    levelCountDownTimer.tick();
    
    int numTokensArrivedAtDest = 0;
    
    ArrayList<Token> toRemove = new ArrayList<Token>();
    
    // If at least one token arrived at their destination, we'll need to 
    // iterate over the board and find any tokens that need to be marked for removal.
    if(numTokensArrivedAtDest > 0){
        markTokensForRemoval(false);
        removeMarkedTokens(true);
        //dropTokens();
        //fillHoles(false);
    }
    
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
          
          swapToken1.animateTo(r2, c2);
          swapToken2.animateTo(r1, c1);
          
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
    
    // Iterate over all the tokens that are dying and increase the score.
    for(int i = 0; i < dyingTokens.size(); i++){
      
      Token dyingToken = dyingTokens.get(i);
      
      dyingToken.update(td);
      
      if(dyingToken.isAlive() == false){
        
        if(dyingToken.hasGem()){
          gemCounter++;
          addGemToQueuedToken();
        }
        
        addToScore(dyingToken.getScore());
        
        dyingTokens.remove(i);
        tokensDestroyed++;
      }
    }
    
    // Update all tokens on board along with falling tokens
    for(int r = BOARD_ROWS-1; r >= 0 ; r--){
      for(int c = 0; c < BOARD_COLS; c++){
        board[r][c].update(td);
        
        if(board[r][c].fallingDown && board[r][c].arrivedAtDest()  ){
          board[r][c].dropIntoCell();
          numTokensArrivedAtDest++;
        
          // If the top token arrived at its destination, it means we can safely
          // fill up tokens above it.
          if(board[r][c].getFillCellMarker()){
          //  board[r][c].setFillCellMarker(false);
            fillInvisibleSectionOfColumn(board[r][c].getColumn());
            setFillMarkers(board[r][c].getColumn());
          }
        }
      }
    }
    
    if(numTokensArrivedAtDest > 0){
      //removeMarkedTokens(true);
    //  dropTokens();
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
    
    // Haven't selected the first token yet.
    if(currToken1 == null){
      currToken1 = board[r][c];
      
      // If the token the player selected is actually null (an empty cell), then back out.
      if(currToken1.getType() == TokenType.NULL){
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
      if(currToken2.getType() == TokenType.NULL){
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
    
    // They are about to 'drag to' their second selection.
    if(currToken1 != null && currToken2 == null){
  
      //    
      if(c != currToken1.getColumn() || r != currToken1.getRow()){
        currToken2 = board[r][c];
        
        // If they dragged to an empty cell, we have to back out.
        if(currToken2.getType() == TokenType.NULL){
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
    
    // Animate will detach the tokens from the board
    swapToken1.animateTo(t2Row, t2Col);
    swapToken2.animateTo(t1Row, t1Col);
    
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
      Token t = new Token();
      t.setType(getRandomTokenType());
      t.setRowColumn(r, c);
      board[r][c] = t;
    }
  }

  /**
      From bottom to top, search to find first gap
      After finding the first gap, set the marker
      Find first token, set dst to marker
      Increment marker by 1
      Find next token
     
     For all the tokens above that gap, until very top
     a) detach tokens from board
     b) give them appropriate positions
     c) give them a velocity
     d) give them destination positions
     e) place tokens in special floating tokens array to keep track of them.
     f) update tokens and allow them to add themselves back in
  */
  void dropTokens(){
    
    for(int c = 0; c < BOARD_COLS; c++){
      boolean ok = false;
      int dst = BOARD_ROWS;
      int src;
      
      while(dst >= 2){
        dst--;
        if(board[dst][c].getType() == TokenType.NULL){
          ok = true;
          break;
        }
      }
      
      // Don't subtract 1 because we do that already in the next line
      src = dst;
      while(src >= 1){
        src--;
        if(board[src][c].getType() != TokenType.NULL){
          break;
        }
      }
      
      while(src >= 0){
        // move the first token
        if(ok){
          Token tokenToMove = board[src][c];
          tokenToMove.fallingDown = true;
          tokenToMove.animateTo(dst, c);
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
        if(board[r][c].matchesWith(tokenTypeToMatchAgainst)){
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
        
        if(board[r][c].matchesWith(tokenTypeToMatchAgainst)){
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
        
    // Add the appropriate number of gems the tokens
    for(int i = 0; i < numGemsOnBoard; i++){
      addGemToQueuedToken();
    }  
    
    if(validSwapExists() == false){
      generateNewBoard();
      println("**** no moves remaining ****");
    }
  }
  
  private void setFillMarkers(int c){
    Token t = board[0][c];
    t.setFillCellMarker();
  }
  
  private void setFillMarkers(){
    for(int c = 0; c < BOARD_COLS; c++){
      Token t = board[0][c];
      t.setFillCellMarker();
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
        Select a random token and add a gem to it if it doesn't already have one.
        
        Used when the user clears a gem from board, and we have to 'replace' it.
    */
    private void addGemToQueuedToken(){
      
      boolean added = false;
      
      while(added == false){
        // We can only add the gem to the part of the board the user doesn't see.
        // Don't forget getRandom int is inclusive.
        int r = Utils.getRandomInt(0, START_ROW_INDEX - 1);
        int c = Utils.getRandomInt(0, BOARD_COLS - 1);
        Token token = board[r][c];
        
        if(token.hasGem() == false){
          token.addGem();
          added = true;
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
    
    println("null token at " + r + ", " + c);
  }
  
  void keyPressed(){
    Keyboard.setKeyDown(keyCode, true);
    
    // P key is locked
    isPaused = Keyboard.isKeyDown(KEY_P);
    if(isPaused){
      timer.pause();
      levelCountDownTimer.pause();
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
    return gemCounter;
  }
  
  public boolean Paused(){
    return isPaused;
  }
  
  public int getNumGemsForNextLevel(){
    return gemsRequiredForLevel;
  }
  
  /**
      This can only be done if nothing is moving or animating to make
      sure they board stays in a proper state.
  */
  public void generateNewBoard(){
    
    // If anything is falling, we can't have the new board fall on top of those already falling tokens
    // Generating a new board while swapping is unlikely, but prevent it anyway, just in case.
    //if(floatingTokens.size() > 0 || swapToken1 != null || swapToken2 !=null){
      
      // !!! Make sure everything has stopped
    if(swapToken1 != null || swapToken2 !=null){
      return;
    }
    
    // Kill all the tokens on the visible part of the board
    for(int c = 0; c < BOARD_COLS; c++){
      for(int r = START_ROW_INDEX; r < BOARD_ROWS; r++){
        // Set score to zero so once they die, the score total isn't changed.
        board[r][c].setScore(0);
        board[r][c].kill();
        dyingTokens.add(board[r][c]);
        
        createNullToken(r,c);        
      }
    }
    
    // The invisible part of the board will come down, so we need to 
    // remove all immediate matches so there are no matches as soon as it falls.
    while(markTokensForRemoval(true) > 0){
      removeMarkedTokens(false);
      fillHoles(true);
    }
    
    // !!!
    setFillMarkers();
    
    dropTokens();
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
    
    // Should the score be reset?
    // score = 0;
    gemCounter = 0;
    
    currLevel++;
    gemsRequiredForLevel += 5;
    
    // Still playing around with this to make later levels challenging.
    levelCountDownTimer = new Ticker();
    levelCountDownTimer.setTime(2 + (gemsRequiredForLevel/2) , 11);
    levelCountDownTimer.setDirection(-1);
  
    if(currLevel == 4){
      numTokenTypesOnBoard++;
    }
    
    numGemsOnBoard = currLevel + 1;
    
    fillBoardWithRandomTokens();
  }
}
