/**
  Horadrix
  Andor Salga
  June 2013
*/

import ddf.minim.*;

// For the AssetStore
PApplet globalApplet;

Debugger debug;
int R=0,C=0;

Ticker debugTicker;
Ticker delayTicker;
Ticker gemRemovalTicker;
Ticker levelTimeLeft;

int tokensDestroyed = 0;

boolean isPaused = false;

// The amount of rows that are visible
final int BOARD_COLS = 8;
final int BOARD_ROWS = 16;

// Only need y index
final int START_ROW_INDEX = 8;

// When a match is created, the matched tokens are removed from the board array
// and 'float' above the board and drop down until they arrive where they need to go.
// We do this because as they fall, we can't give them a integer position, but need to
// use a float.
ArrayList<Token> floatingTokens;

// Tokens that have been remove from the board, but still need to be rendered for their
// death animation.
ArrayList<Token> dyingTokens;

//ArrayList<Token> dyingTokensOnBoard


int gemCounter = 0;
int gemsRequiredForLevel = 0;
int currLevel = 1;

boolean waitingForTokensToFall = false;

// User can only be in the process of swapping two tokens
// at any given time.
Token swapToken1 = null;
Token swapToken2 = null;

// As the levels increase, more and more token types are added
// This makes it a slightly harder to match tokens.
int numTokenTypesOnBoard = 5;

// Where on the canvas the tokens start to be rendered.
final int START_X = 100;//200;
final int START_Y = 0;//-20; // 20 - -220
final int TOKEN_SIZE = 28;
final int TOKEN_SPACING = 3;

//Tuple gems = new Tuple();

// TODO: fix
// Keep track of the number of gems removed from the board.
int[] numMatchedGems = new int[100+numTokenTypesOnBoard + 1];

Token currToken1 = null;
Token currToken2 = null;

Token[][] board = new Token[BOARD_ROWS][BOARD_COLS];

int score = 0;

void setup(){
  size(START_X + TOKEN_SIZE * BOARD_COLS, START_Y + TOKEN_SIZE * BOARD_ROWS);
  randomSeed(1);
  

  gemsRequiredForLevel = currLevel * 5;
  
  globalApplet = this;

  floatingTokens = new ArrayList<Token>();
  dyingTokens = new ArrayList<Token>();

  debugTicker = new Ticker();
  debug = new Debugger();
 
  // lock P for pause
  Keyboard.lockKeys(new int[]{KEY_P});
  
  
  levelTimeLeft = new Ticker();
  levelTimeLeft.setMinutes(5);
  levelTimeLeft.setDirection(-1);
  
  
  resetBoard();
  deselectTokens();
  resetGemMatchCount();
}

/*
 */
void resetGemMatchCount(){
  for(int i = 0; i < numTokenTypesOnBoard + 1; i++){
    numMatchedGems[i] = 0;
  }
}

/*
 */
void resetBoard(){
  for(int r = 0; r < BOARD_ROWS; r++){
    for(int c = 0; c < BOARD_COLS; c++){
      Token token = new Token();
      
      token.setType(getRandomToken());
      
      int chance = Utils.getRandomInt(0,5);
      if(chance == 0){
        token.addGem();
      }
      
      token.setRowColumn(r, c);
      board[r][c] = token;
    }
  }

  int safeCounter = 0;
  
  // Ugly way of making sure there are no immediate matches, but it works for now.
  /*do{
    markTokensForRemoval();
    removeMarkedTokens();
    fillHoles();
    safeCounter++;
  }while(markTokensForRemoval() == true && safeCounter < 20 );*/
  
  
  if(false == validSwapExists()){
    //println("**** no moves remaining ****");
  }
}
  
/*
 */
void drawBoard(){
  
  pushStyle();
  noFill();
  stroke(255);
  strokeWeight(2);
  rect(-TOKEN_SIZE/2, -TOKEN_SIZE/2, BOARD_COLS * TOKEN_SIZE, BOARD_ROWS * TOKEN_SIZE);
  
  rect(-TOKEN_SIZE/2, -TOKEN_SIZE/2 + START_ROW_INDEX * TOKEN_SIZE, BOARD_COLS * TOKEN_SIZE, BOARD_ROWS * TOKEN_SIZE);
  popStyle();
  
  // Draw the invisible part, for debugging
  for(int r = 0; r < START_ROW_INDEX; r++){
    for(int c = 0; c < BOARD_COLS; c++){
      
      if(board[r][c].isMoving() == false){
       // board[r][c].draw();
      }
    }
  }
  
  //image(boardImage, -30, 190);
  
  // Draw the visible part to the player
  for(int r = START_ROW_INDEX; r < BOARD_ROWS; r++){
    for(int c = 0; c < BOARD_COLS; c++){
      board[r][c].draw();
    }
  }
}

/*
 */
void removeMarkedTokens(){
  // Now delete everything marked for deletion
  for(int r = 0; r < BOARD_ROWS; r++){
    for(int c = 0; c < BOARD_COLS; c++){
      
      Token tokenToDestroy = board[r][c];
      
      if(tokenToDestroy.isDying()){//.isMarkedForDeletion()){
        //println("marked for delection...");
        //
        tokenToDestroy.destroy();
        dyingTokens.add(tokenToDestroy);
        
        // Replace the token we removed with a null Token
        Token nullToken = new Token();
        nullToken.setType(TokenType.NULL);
        nullToken.setRowColumn(r, c);
        board[r][c] = nullToken;
        
        delayTicker = new Ticker();
        //removedAtLeastOneMatch = true;
      }
      board[r][c].setSelect(false);
    }
  }
}

void keyPressed(){
  Keyboard.setKeyDown(keyCode, true);
}

void keyReleased(){
  Keyboard.setKeyDown(keyCode, false);
}


void goToNextLevel(){
  resetBoard();
  
  gemsRequiredForLevel += 5;
  gemCounter = 0;
  levelTimeLeft.setMinutes(5);
}

void update(){
  
  // Once the player meets their quota...
  if(gemCounter >= gemsRequiredForLevel){
    goToNextLevel();    
  }
  
  
  if(waitingForTokensToFall && floatingTokens.size() == 0){
    waitingForTokensToFall = false;
    fillHoles();
  }
  
  isPaused = Keyboard.isKeyDown(KEY_P);
  
  if(isPaused){
    return;
  }
  
  debug.clear();
  
  debugTicker.tick();
  levelTimeLeft.tick();
  
  // Update all the tokens that are falling down
  for(int i = 0; i < floatingTokens.size(); i++){
    Token token = floatingTokens.get(i);
    token.update();
    if(token.arrivedAtDest()){
      token.dropIntoCell();
      markTokensForRemoval();
      delayTicker = new Ticker();
      //removeMarkedTokens();
      gemRemovalTicker = new Ticker();
    }
    waitingForTokensToFall = true;
  }


  // Now, update the two tokens that the user has swapped
  if(swapToken1 != null){
    
    swapToken1.update();
    swapToken2.update();
    
    if(swapToken1.arrivedAtDest() && swapToken1.isReturning() == false && swapToken1.isMoving()){
      //
      // Need to drop into the cells before check if it was indeed a valid swap
      swapToken1.dropIntoCell();
      swapToken2.dropIntoCell();
      
      // If it was not a valid swap, animate it back from where it came.
      if(isValidSwap(swapToken1, swapToken2) == false){
        //println("not a valid swap");
        
        int r1 = swapToken1.getRow();
        int c1 = swapToken1.getColumn();
        
        int r2 = swapToken2.getRow();
        int c2 = swapToken2.getColumn();
        
        swapToken1.animateTo(r2, c2);
        swapToken2.animateTo(r1, c1);
        
        swapToken1.setReturning(true);
        swapToken2.setReturning(true);
      }
      
      // Swap was valid, so get rid of 
      else{
        swapToken1 = swapToken2 = null;
        
       // gemRemovalTicker = new Ticker();
        markTokensForRemoval();
        removeMarkedTokens();
        //deselectTokens();
      }
      
      // Was it valid?
      // if( false == isValidSwap(token1, token2)){
        // token1.animateTo( .. );
        // token2.animateTo( ...);
        // token1.setReturning(true);
        // token2.setRetruning(true);
      
      // if it was valid ....
      
    }
    else if(swapToken1.arrivedAtDest() && swapToken1.isReturning()){
      //println("returned");
      swapToken1.dropIntoCell();
      swapToken2.dropIntoCell();
      swapToken1.setReturning(false);
      swapToken2.setReturning(false);
      
      swapToken1 = swapToken2 = null;
    }
  }
  

  // Update the tokens that may need to be GC'ed.
  for(int i = 0; i < dyingTokens.size(); i++){
    dyingTokens.get(i).update();
    if(dyingTokens.get(i).isAlive() == false){
      
      if(dyingTokens.get(i).hasGem()){
        gemCounter++;
      }
      
      dyingTokens.remove(i);
      tokensDestroyed++;
    }
  }
  
  for(int r = 0; r < BOARD_ROWS; r++){
    for(int c = 0; c < BOARD_COLS; c++){
      board[r][c].update();
    }
  }
  
  if(gemRemovalTicker != null){
    gemRemovalTicker.tick();
  }
  
  if(delayTicker != null){
    delayTicker.tick();
  }
  
  if(gemRemovalTicker != null && gemRemovalTicker.getTotalTime() > 0.5f){
    gemRemovalTicker = null;
    removeMarkedTokens();
    delayTicker = new Ticker();
  }
  
  if(delayTicker != null && delayTicker.getTotalTime() > 0.35f){
    dropTokens();
    
    if(validSwapExists() == false){
      //println("no more moves available!");
    }
    
    //if(markTokensForRemoval()){
    //  gemRemovalTicker = new Ticker();
    //}
    
    delayTicker = null;
  }
  
  //pushMatrix();
  resetMatrix();
  //debug.addString("debug time: " + debugTicker.getTotalTime());
  debug.addString("score: " + score);
  debug.addString("Level: " + currLevel);
  debug.addString("destroyed: " + tokensDestroyed);
  //debug.addString("FPS: " + frameRate);
  debug.addString(gemCounter + "/" + gemsRequiredForLevel);
  debug.addString( "" + (int)(levelTimeLeft.getTotalTime()/60) + ":" +  (int)levelTimeLeft.getTotalTime() % 60 );
  
  for(int i = 0; i < numTokenTypesOnBoard; i++){
    //debug.addString("color: " + numMatchedGems[i]);
  }
  //popMatrix();
}

public int getRowIndex(){
  return (int)map(mouseY,  START_Y , START_Y + BOARD_ROWS * TOKEN_SIZE, 0, BOARD_ROWS);
}

public int getColumnIndex(){
  return (int)map(mouseX,  START_X, START_X + BOARD_COLS * TOKEN_SIZE, 0, BOARD_COLS);
}


/**
 * Tokens that are considrered too far to swap include ones that
 * are across from each other diagonally or have 1 token between them.
 */
public boolean isCloseEnoughForSwap(Token t1, Token t2){
  //
  return abs(t1.getRow() - t2.getRow()) + abs(t1.getColumn() - t2.getColumn()) == 1;
}

//if((abs(t2.getRow() - t1.getRow()) == 1 && (t1.getColumn() == t2.getColumn()) ) ||
  //   (abs(t2.getColumn() - t1.getColumn()) == 1 && (t1.getRow() == t2.getRow()))  ){
  

public void mouseMoved(){
  R = getRowIndex();
  C = getColumnIndex();
}

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
  
  if( r >= BOARD_ROWS || c >= BOARD_COLS || r < 0 || c < 0){
    return;
  }
  
  
  if(currToken1 == null){
    currToken1 = board[r][c];
    currToken1.setSelect(true);
  }
  
  else if(currToken2 == null){
    
    currToken2 = board[r][c];
    // User clicked on a token that's too far to swap with the one already selected
    // In that case, what they are probably doing is starting the 'swap process' over.
    if( isCloseEnoughForSwap(currToken1, currToken2) == false){
    //tooFarToSwap(currToken1,currToken2)){
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
 * To swap tokens, players will clic/tap a token then drag to the token
 * they want to swap with.
 */
public void mouseDragged(){
  
  // convert the mouse coords to grid coordinates
  int r = getRowIndex();
  int c = getColumnIndex();
  
  if( r >= BOARD_ROWS || c >= BOARD_COLS || r < 0 || c < 0){
    return;
  }
  
  
  if(currToken1 != null && currToken2 == null){

    //    
    if(c != currToken1.getColumn() || r != currToken1.getRow()){
      currToken2 = board[r][c];
      
      if(isCloseEnoughForSwap(currToken1, currToken2) == false){
         currToken2 = null;
      }
      else{
        animateSwapTokens(currToken1, currToken2);
      }
    }
  }
}

/*
 * 
 */
void animateSwapTokens(Token t1, Token t2){
  
  // We need to cache these so we get get the wrong
  // values when calling animateTo.
  int t1Row = t1.getRow();
  int t1Col = t1.getColumn();
  
  int t2Row = t2.getRow();
  int t2Col = t2.getColumn();
  
  swapToken1 = t1;
  swapToken2 = t2;
  
  // Animate will detach the tokens from the board
  swapToken1.animateTo(t2Row, t2Col);
  swapToken2.animateTo(t1Row, t1Col);
  
  deselectTokens();
}

/**
  Speed: O(n)
  Returns true as soon as it finds a valid swap/move.

  There may be a case in which there are no valid swap/moves left
  in that case the board needs to be reset.
  
*/
boolean validSwapExists(){
  
  // First check any potential matches in the horizontal
  for(int r = START_ROW_INDEX; r < BOARD_ROWS; r++){
    for(int c = 0; c < BOARD_COLS - 1; c++){
      
      Token gem1 = board[r][c];
      Token gem2 = board[r][c + 1];
      
      swapTokens(gem1, gem2);
      
      if(isValidSwap(gem1, gem2)){
        swapTokens(gem1, gem2);
        return true;
      }
      // Swap them back
      else{
        swapTokens(gem1, gem2);
      }
    }
  }
  
  // Check any potential matches in the vertical
  for(int c = 0; c < BOARD_COLS; c++){  
    for(int r = START_ROW_INDEX; r < BOARD_ROWS - 1; r++){
      
      Token gem1 = board[r][c];
      Token gem2 = board[r + 1][c];
      swapTokens(gem1, gem2);
      
      if(isValidSwap(gem1, gem2)){
        swapTokens(gem1, gem2);
        return true;
      }
      else{
        swapTokens(gem1, gem2);
      }
    }
  }
  
  return false;
}

/*
  In rare cases, there may not be any valid moves the user can make.
  we need to detect these cases and reset the board.
*/
boolean noMovesLeft(){
  return false;
}

int getRandomToken(){
  return Utils.getRandomInt(0, numTokenTypesOnBoard-1);
}

void fillHoles(){
  for(int r = 0; r < BOARD_ROWS; r++){
    for(int c = 0; c < BOARD_COLS; c++){
      if(board[r][c].getType() == TokenType.NULL){
        board[r][c].setType(getRandomToken());
        //println("fill hole");
       // board[r][c].setSelect(true);
      }
    }
  }
}

  /**
   1) From bottom to top, search to find first gap
    ) After finding the first gap, set the marker
    ) Find first token, set dst to marker
    ) Increment marker by 1
    ) Find next token
    ) 
    ) For all the tokens above that gap, until very top
     a) detach tokens from board
     b) give them appropriate positions
     c) give them a velocity
     d) give them destination positions
     e)
     f) place tokens in special floating tokens array to keep track of them.
     g) update tokens and allow them to add themselves back in
  */
void dropTokens(){
  
  // From bottom to top, search to find first gap
  // Start at the bottom of the grid, so we can properly iterate to the top
  // copying down the gems
  for(int c = 0; c < BOARD_COLS; c++){
    for(int r = BOARD_ROWS - 1; r >= 0; r--){
      
      // After finding the first gap, set the marker. Once we find a 
      // token, we will tell it to move to this marker position.
      if(board[r][c].getType() == TokenType.NULL){
        int firstEmptyCellIndex = r;
        
        // Find first non-empty cell. We can start immediately above the 
        // empty cell.
        for(int row = firstEmptyCellIndex - 1; row >= 0; row--){
          
          // Found non-empty cell, move 
          if(board[row][c].getType() != TokenType.NULL){
            //println("found non empty cell at: " + row);
            //println("move to: " + firstEmptyCellIndex);
            
            // We need to remove the token from the board because each frame
            // the board is rendered, all the tokens in it get rendered also.
            // And if the tokens are floating down, they shouldn't appear in the board.
            
            //tokenToMove.setRowColumn(firstEmptyCellIndex, c);
            // tokenToMove.moveToRow(firstEmptyCellIndex);
            
            Token tokenToMove = board[row][c];
            tokenToMove.animateTo(firstEmptyCellIndex, c);
            
            floatingTokens.add(tokenToMove);
            waitingForTokensToFall = true;

            // Since that token has just been removed, we'll need to
            // place a 'hole' where it used to be.
            Token nullToken = new Token();
            nullToken.setType(TokenType.NULL);
            nullToken.setRowColumn(row, c);
            board[row][c] = nullToken;
            
            //
            break;
            
            //Gem g = board[row][c];
            //g.moveTo(board[rowMarker][c]);
          }
        }
      }      
    }
  }
  
  /*

  for(int c = BOARD_COLS-1; c >= 0; c--){
    for(int r = BOARD_ROWS-1; r >= 0; r--){
      
      if(board[r][c].getType() == 0){
        
        // Keep moving up until we either find a ball we can copy downwards or
        // we hit the top, in which case we need to generate a random number.
        for(int rr = r - 0; rr >= 0; rr--){
          
          if(rr < 0){
           // board[0][c].setType(Utils.getRandomInt(1, NUM_GEM_TYPES));
            break;
          }
          
          if(rr == 0 && board[rr][c].getType() == 0){
            board[r][c].setType(Utils.getRandomInt(1, numTokenTypesOnBoard));
          }
          
          else if(board[rr][c].getType() != 0){
            swapTokens(board[rr][c], board[r][c]);
            break;
          }
        }
      }
    }
  }*/
}

/**
  Find any 3 matches either going vertically or horizontally and
  remove them from the board.
*/
boolean markTokensForRemoval(){
  
  //
  boolean markedAtLeast3Gems = false;
  
  // Iterate over the entire board, mark gems for removal
  // Once complete, remove all gems
  
  // Mark the matched horizontal gems
  // Add extra column buffer at end of board to fix matches counter?
  for(int r = START_ROW_INDEX; r < BOARD_ROWS; r++){
    
    // use the first column as the thing we want to match against.
    int type = board[r][0].getType();
    
    // start of matched row
    int markerIndex = 0;
    int matches = 1;
      
    for(int c = 1; c < BOARD_COLS; c++){
      
      if(board[r][c].matchesWith(type)){
      //if(board[r][c].getType() == type){
      
        matches++;
      }
      // We bank on finding a different gem. Once that happens, we can see if
      // we found enough of the previous gems.
      //
      else if( (board[r][c].matchesWith(type) == false) && matches < 3){
        //else if( (board[r][c].getType() != type) && matches < 3){
        matches = 1;
        markerIndex = c;
        type = board[r][c].getType();
      }
      // We need to also do it at the end of the board 
      else if( (board[r][c].matchesWith(type) == false && matches >= 3) || (c == BOARD_ROWS - 1 && matches >= 3)){
       // else if( (board[r][c].getType() != type && matches >= 3) || (c == BOARD_ROWS - 1 && matches >= 3)){
        markedAtLeast3Gems = true;
                  
        for(int gemC = markerIndex; gemC < markerIndex + matches; gemC++){
          board[r][gemC].kill();//.markForDeletion();
          numMatchedGems[board[r][gemC].getType()]++;
        }
        matches = 1;
        markerIndex = c;
        type = board[r][c].getType();
      }
    }
    
    // TODO: comment
    if(matches >= 3){
      markedAtLeast3Gems = true;
      
      for(int gemC = markerIndex; gemC < markerIndex + matches; gemC++){
        board[r][gemC].kill();//markForDeletion();
        numMatchedGems[board[r][gemC].getType()]++;
      }
    }
  }
  
  
  // Add extra column buffer at end of board to fix matches counter?
  for(int c = 0; c < BOARD_COLS; c++){
    int type = board[START_ROW_INDEX][c].getType();
    int markerIndex = START_ROW_INDEX;
    int matches = 1;
      
    for(int r = START_ROW_INDEX + 1; r < BOARD_ROWS; r++){
      
      if(board[r][c].matchesWith(type)){
      //if(board[r][c].getType() == type){
        matches++;
      }
      // We bank on finding a different gem. Once that happens, we can see if
      // we found enough of the previous gems.
      else if(board[r][c].matchesWith(type) == false && matches < 3){
      //else if(board[r][c].getType() != type && matches < 3){
        matches = 1;
        markerIndex = r;
        type = board[r][c].getType();
      }
      // We need to also do it at the end of the board 
      else if( (board[r][c].matchesWith(type) == false && matches >= 3)){// || (c == BOARD_COLS - 1 && matches > 2)){
      //else if( (board[r][c].getType() != type && matches >= 3)){// || (c == BOARD_COLS - 1 && matches > 2)){
        markedAtLeast3Gems = true;
         //sprintln("marker index: " +markerIndex );
        
        for(int gemR = markerIndex; gemR < markerIndex + matches; gemR++){
          board[gemR][c].kill();//markForDeletion();
          
          // TODO: fix AOOB
          // Num format exception
           numMatchedGems[board[gemR][c].getType()]++;
        }
        matches = 1;
        markerIndex = r;
        type = board[r][c].getType();
      }
    }
    
    if(matches >= 3){
      markedAtLeast3Gems = true;
              
      for(int gemR = markerIndex; gemR < markerIndex + matches; gemR++){
        board[gemR][c].kill();//markForDeletion();
        numMatchedGems[board[gemR][c].getType()]++;
      }
    }
  }

  return markedAtLeast3Gems;
}

/*
  A swap of two gems is only valid if it results in a row or column of 3 or more 
  gems of the same type getting lined up.

  We call this just after the player has swapped gems. We check to see if the swap was valid and if it isn't we swap the gems back.
  
  This is also called when we are trying to determine if there are actually any valid swaps left on the board. If not, the board
  needs to get reset.
*/
public boolean isValidSwap(Token t1, Token t2){
  
  if(isCloseEnoughForSwap(t1, t2)){
          
    if( matchesLeft(t1) + matchesRight(t1) >= 2){
      return true;
    }

    if( matchesLeft(t2) + matchesRight(t2) >= 2){
      return true;
    }
    
    if( matchesDown(t1) + matchesUp(t1) >= 2){
      return true;
    }

    if( matchesDown(t2) + matchesUp(t2) >= 2){
      return true;
    }
  }
  return false;
}

/*
*/
public void deselectTokens(){
  if(currToken1 != null) currToken1.setSelect(false);
  if(currToken2 != null) currToken2.setSelect(false);
  currToken1 = null;
  currToken2 = null;
}

/**
  We can only match up until the visible part of the board
  returns the number of matching types excluding this one.
*/
public int matchesUp(Token token){
  int r = token.getRow();
  int matchesFound = 0;
  int type = token.getType();
  int tokenColumn = token.getColumn();
 
  while(r >= START_ROW_INDEX && board[r][tokenColumn].matchesWith(type)){
  //  while(r >= START_ROW_INDEX && board[r][tokenColumn].getType() == type){
    matchesFound++;
    r--;
  }
  
  return matchesFound == 0 ? 0 : matchesFound -1;  
}

/**
 */
public int matchesRight(Token token){
  int col = token.getColumn();
  int matchesFound = 0;
  int type = token.getType();
  int currRow = token.getRow();
  
  while(col < BOARD_COLS && board[currRow][col].matchesWith(type)){
  //  while(col < BOARD_COLS && board[currRow][col].getType() == type){
    matchesFound++;
    col++;
  }
  
  return matchesFound-1;
}

/*
 * Return how many tokens match this one on its left side
 * Does not include the count of the token itself.
 */
public int matchesLeft(Token token){
  int col = token.getColumn();
  int matchesFound = 0;
  int type = token.getType();
  int tokenRow = token.getRow();
  
  // Watch for going out of bounds
  while(col >= 0 && board[tokenRow][col].matchesWith(type)){
  //  while(col >= 0 && board[tokenRow][col].getType() == type){
    matchesFound++;
    col--;
  }
  
  // matchesFound included the token we started with to
  // keep the code in this funciton short, but we have to
  // only return the number of matched tokens excluding it.
  return matchesFound - 1;
}

/**
*/
public int matchesDown(Token token){
  int row = token.getRow();
  int matchesFound = 0;
  int type = token.getType();
  int tokenColumn = token.getColumn();
  
  while(row < BOARD_ROWS && board[row][tokenColumn].matchesWith(type)){
  //  while(row < BOARD_ROWS && board[row][tokenColumn].getType() == (type)){
    matchesFound++;
    row++;
  }
  
  return matchesFound - 1;
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


void draw(){
  update();
  background(103);
  
  // This line is only here to workaround a bug in Processing.js
  // If removed, the board would translate diagonally the canvas.
  resetMatrix();
  
  pushMatrix();
  translate(START_X, START_Y);
  translate(TOKEN_SIZE/2, TOKEN_SIZE/2);
  
  for(int i = 0; i < floatingTokens.size(); i++){
    floatingTokens.get(i).draw();
  }

  if(swapToken1 != null){
    swapToken1.draw();
  }
  if(swapToken2 != null){
    swapToken2.draw();
  }
  
  // For demo purposes
  pushStyle();
  fill(103);
  noStroke();
  rect(-TOKEN_SIZE/2, -TOKEN_SIZE/2, 222, 222);
  popStyle();
  
  pushStyle();
  noFill();
  stroke(255, 0, 0);
  rect(C * TOKEN_SIZE - TOKEN_SIZE/2, R * TOKEN_SIZE - TOKEN_SIZE/2, TOKEN_SIZE, TOKEN_SIZE);
  popStyle();
  
  drawBoard();
  
  // Draw the Dying tokens above the board as if they are coming out of it.
  // So when the tokens above fall down, those falling tokens render BEHIND these ones.
  for(int i = 0; i < dyingTokens.size(); i++){
    dyingTokens.get(i).draw();
  }
  
  popMatrix();
  
  debug.draw();
}
