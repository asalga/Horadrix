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
