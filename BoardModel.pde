/*
	This class is responsible for keeping the integrity of the board data intact.
*/
public class BoardModel{

	// Quality with MATCH_ to avoid conflicts with P5 constants
	private final int MATCH_LEFT = -1;
	private final int MATCH_RIGHT = 1;
	private final int MATCH_UP = -1;
	private final int MATCH_DOWN = 1;

	private Token[][] board;

	/*
	*/
	public BoardModel(){
		board = new Token[BOARD_ROWS][BOARD_COLS];
	}

  /*
      We are dropping the tokens, so we need to start from the bottom and work out way
      up to fill in all the gaps.

      First we find a destination for a token to move to. Any cell with an empty cell or that
      has a dying token will serve as a destination for another token to move to.

      The source token must be above the destination, so we can begin counting above the dest.      
  */
  private void dropTokens(){
    
    for(int c = 0; c < BOARD_COLS; c++){
      boolean needsDrop = false;
      int dst = BOARD_ROWS;
      int src;
      
      while(dst >= 2){
        dst--;
        if(board[dst][c].getType() == Token.TYPE_NULL || board[dst][c].isDying() ){
          needsDrop = true;
          break;
        }
      }
      
      // Don't subtract 1 because we do that already in the next line
      src = dst;
      while(src >= 1){
        src--;
        if(board[src][c].getType() != Token.TYPE_NULL || board[src][c].isDying() ){
          break;
        }
      }
      
      while(src >= 0){
        // move the first token
        if(needsDrop){
          Token tokenToMove = board[src][c];
          tokenToMove.fallTo(dst, c);
        }
        do{
          src--;
        }while(src >= 1 && board[src][c].getType() == Token.TYPE_NULL);
        
        dst--;
      }
    }
  }

  /*
      Several columns may be dropping down tokens, but once a column
      is finished dropping its gems, it should immediately fill up the holes.
      
      Note this does not change whether the token has a gem or not.
  */
  private void fillInvisibleSectionOfColumn(int c){
    for(int r = 0; r < START_ROW_INDEX; r++){
      if(board[r][c].getType() == Token.TYPE_NULL){
        Token t = new Token();
        t.setType(getRandomTokenType());
        t.setRowColumn(r, c);
        board[r][c] = t;
      }
    }
  }

  /*
    Get a reference to a token at a particular cell  
  */
  public Token getToken(int r, int c){
  	assertTest(r > -1 && r < BOARD_ROWS, "OOB error in getToken");
  	assertTest(c > -1 && c < BOARD_COLS, "OOB error in getToken");
  	return board[r][c];
  }

	/*
    
	*/
	public void setToken(int r, int c, Token t){
		board[r][c] = t;
	}

  /*
   * Find any 3 matches either going vertically or horizontally and
   * remove them from the board. Replace the cells in the board will NULL tokens.
   * 
   * @param {startIndex}
   * @param {endIndex}
   * @returns the number of tokens this method found that need to be removed.      
  */
  int markTokensForRemoval(int startIndex, int endIndex){
    
    int numTokensMarked = 0;    
    
    int startRow = startIndex;
    int endRow = endIndex;
    
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
         else if( (board[r][c].matchesWith(tokenTypeToMatchAgainst) == false && matches >= 3) || (r == endRow && matches >= 3)){
          
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
    Speed: O(n)
    Returns true as soon as it finds a valid swap/move.
    
    Checks to see if the user can make a valid match anywhere in the visible part of the board.
    In case there are no valid swap/moves left, the board needs to be reset.
  */
  /*private boolean validSwapExists(){
    
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
  }*/

   /*
  */
  /*public void swapTokens(Token token1, Token token2){
    
    int token1Row = token1.getRow();
    int token1Col = token1.getColumn();
  
    int token2Row = token2.getRow();
    int token2Col = token2.getColumn();
  
    // Swap on the board and in the tokens
    board[token1Row][token1Col] = token2;
    board[token2Row][token2Col] = token1;
    
    token2.swap(token1);
  }*/

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

  /*

  */
  public boolean hasMovement(){
    for(int r = 0; r < BOARD_ROWS; r++){
      for(int c = 0; c < BOARD_COLS; c++){
        if(board[r][c].isMoving()){
          return true;
        }
      }
    }
    return false;
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

  /**
   * Tokens that are considrered too far to swap include ones that
   * are across from each other diagonally or have 1 token between them.
   */
  public boolean isCloseEnoughForSwap(Token t1, Token t2){
    // !!!
    return abs(t1.getRow() - t2.getRow()) + abs(t1.getColumn() - t2.getColumn()) == 1;
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
   
    int matches = numMatchesSideways(t1, MATCH_LEFT) + numMatchesSideways(t1, MATCH_RIGHT);
    if(matches >= 2){
      return matches + 1;
    }
    
    matches = numMatchesSideways(t2, MATCH_LEFT) + numMatchesSideways(t2, MATCH_RIGHT);
    if(matches >= 2){
      return matches + 1;
    }
    
    matches = numMatchesUpDown(t1, MATCH_UP) + numMatchesUpDown(t1, MATCH_DOWN);
    if(matches >= 2){
      return matches + 1;
    }
    
    matches = numMatchesUpDown(t2, MATCH_UP) + numMatchesUpDown(t2, MATCH_DOWN);
    return matches + 1;
  }

  /*
  */
  public void update(float td){
    int numTokensArrivedAtDest = 0;

    // Update all tokens on board. This includes the falling tokens
    for(int r = BOARD_ROWS - 1; r >= 0 ; r--){
      for(int c = 0; c < BOARD_COLS; c++){
        Token t = board[r][c]; 
        t.update(td);
        
        if(t.isFalling() && t.arrivedAtDest()){
          t.dropIntoCell();
          
          setToken(t.getRow(), t.getColumn(), t);

          // If the token was actually falling and not swapping, we need to
          // put a null token in its OLD location
          // If the token hasn't been overwritten yet
          // if(getToken(r, c) == this){
          createNullToken(r, c);

          numTokensArrivedAtDest++;
          
          // If the top token arrived at its destination, it means we can safely fill up tokens above it.
          if(t.getFillCellMarker()){
            fillInvisibleSectionOfColumn(t.getColumn());
            setFillMarker(t.getColumn());
          }
        }
      }
    }

    if(numTokensArrivedAtDest > 0){
      markTokensForRemoval(8, 15);
      removeMarkedTokens(true);
      dropTokens();
    }
  }


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
          Token token = board[r][c];

          if(DEBUG_ON){
            token.draw();
          }
          else{
            if(token.isMoving()){
              token.draw();
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



  /*
    Find any null tokens on the board and replace them with a random token.
    
    This is used whenever we need to create a board that has no matches. A board
    is generated, matches are removed, then empty cells are replaced by calling this method.
        
    @return {int} Num holes/cells filled.
  */
  private int fillHolesForRows(int startIndex, int endIndex){
    int numFilled = 0;

    for(int r = startIndex; r < endIndex; r++){
      for(int c = 0; c < BOARD_COLS; c++){
        if(board[r][c].getType() == Token.TYPE_NULL){
          board[r][c].setType(getRandomTokenType());
          numFilled++;
        }
      }
    }
    return numFilled;
  }

  /*
  	Don't start with 0, since that's null
  */
  public int getRandomTokenType(){
    return Utils.getRandomInt(1, numTokenTypesOnBoard);
  }

  /*
    Stupidly fill the board with random tokens first.
  */
  private void fillBoardWithRandomTokens(){
    for(int r = 0; r < BOARD_ROWS; r++){
      for(int c = 0; c < BOARD_COLS; c++){
        Token token = new Token();
        token.setType(getRandomTokenType());
        token.setRowColumn(r, c);
        board[r][c] = token;
      }
    }
  }

  /*
      This can only be done if nothing is moving or animating to make
      sure the board stays in a proper state.
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
    while(markTokensForRemoval(0, 7) > 0){
      removeMarkedTokens(false);
      fillHolesForRows(0, BOARD_ROWS/2);
    }
    
    // We don't want any gems to appear on the board on init, just based on design
    removeAllGemsFromBoard();
    
    // TODO: comment !!!
    setFillMarkers();
    
    dropTokens();
  }

  /**
  */
  private void setFillMarker(int c){
    board[0][c].setFillCellMarker(true);
  }
  
  /**
  */
  private void setFillMarkers(){
    for(int c = 0; c < BOARD_COLS; c++){
      board[0][c].setFillCellMarker(true);
    }
  }
  
  /*
      Move the tokens that have been marked for deletion from
      the board to the dying tokens list.
    
      @param {doDyingAnimation}
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
  
  /**
  */
  private void createNullToken(int r, int c){
    Token nullToken = new Token();
    nullToken.setType(Token.TYPE_NULL);
    nullToken.setRowColumn(r, c);
    board[r][c] = nullToken;
  }

  /*
    In some cases (like the start of a level) we need to make sure
    there are no gems on the visible part of the board.
  */
  private void removeAllGemsFromBoard(){
    numGemsOnBoard = 0;
    for(int c = 0; c < BOARD_COLS; c++){
      for(int r = 0; r < BOARD_ROWS; r++){
        board[r][c].setHasGem(false);
      }
    }
  }

}