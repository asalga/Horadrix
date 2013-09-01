/*
    A token is an object the player moves in order to make matches.
    
    A token may have a gem within it. If the player destroys a token that
    has a gem inside it, we add that to the count in ScreenGameplay. After
    getting enough gems, the player can progress to the next level.
*/
public class Token{
  
  private int state;
  
  private final int IDLE   = 0;
  private final int MOVING = 1;// falling/swapping/detached.
  private final int DYING  = 2;
  private final int DEAD   = 3;
  
  private final float MOVE_SPEED = TOKEN_SIZE * 5.0f; // token size per second
  private final float DROP_SPEED = 10;
  
  // Ticker is reset for each state to keep us from having too many tickers.
  private Ticker ticker;
  
  // Used for debugging
  private int id;
  
  // TODO: find better way of doing this?
  // When the token is falling, we need it to be a float
  // so just define it as a float to begin with.
  private int row;
  private int column;
  
  private int type;
  private boolean doesHaveGem;
  
  private int rowToMoveTo;
  private int colToMoveTo;
  
  private boolean returning;
  private boolean hasArrivedAtDest;
  
  private PVector detachedPos;
  
  // Set this and decrement until we reach zero.
  private float distanceToMove;
  private float scaleSize;
  
  private int moveDirection;
  
  // Use can select up to 2 tokens before they get swapped.
  private boolean isSelected;
  
  private boolean isPaused;
  
  /*
  */
  public Token(){
    setType(TokenType.NULL);
    id = Utils.nextID();
    
    isSelected = false;
    
    ticker = new Ticker();
    isPaused = false;
    
    row = 0;
    column = 0;
    
    doesHaveGem = false;
    scaleSize = 1.0f;
    
    // TODO: need to really need to set these?
    rowToMoveTo = 0;
    colToMoveTo = 0;
    moveDirection = 0;
    detachedPos = new PVector();
    
    returning = false;
    hasArrivedAtDest = false;
    state = IDLE;
  }
    
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
  
  public void setType(int t){
    type = t;
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
  
  /**
    Gameplay doesn't keep track if it has already killed a token, so we have
    to keep track of it ourselves to make sure the ticker doesn't get reset.
  */
  public void kill(){
    // We can only kill the token if its idle.
    if(state != IDLE){
      return;
    }
    
    state = DYING;
  }
  
  public boolean isDying(){
    return state == DYING;
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
    Rename this.
  */
  public boolean isMoving(){
    return moveDirection != 0;
  }
  
  /**
    TODO: fix this
    If you think of a moving token as floating above the board, once it reaches
    the destination, it drops into its cell.
  */
  public void dropIntoCell(){
    
    state = IDLE;
    
    row = rowToMoveTo;
    column = colToMoveTo;
    
    board[rowToMoveTo][colToMoveTo] = this;
    
    hasArrivedAtDest = false;
    
    distanceToMove = 0;
    
    moveDirection = 0;
  }
  
  /**
    When paused, animation, movement etc. no longer do anything.
  */
  public void setPaused(boolean isPaused){
    this.isPaused = isPaused;

    if(isPaused){
      ticker.pause();
    }
    else{
      ticker.resume();
    }
  }
  
  /*
  */
  public void update(){
    
    if(isPaused){
      return;
    }

    ticker.tick();
    
    //
    if(state == MOVING){
      float amtToMove = ticker.getDeltaSec() * MOVE_SPEED * moveDirection;
      
      if(row == rowToMoveTo){
        detachedPos.x += amtToMove;
      }
      else{
        detachedPos.y += amtToMove;
      }
      
      distanceToMove -= abs(amtToMove);
      
      if(distanceToMove <= 0){
        state = IDLE;
        hasArrivedAtDest = true;
      }
    }
    else if(state == DYING){
      // Shrink the token if it is dying.
      scaleSize -= ticker.getDeltaSec() * 2.5f;
      
      if(scaleSize <= 0){
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
  
  public void addGem(){
    doesHaveGem = true;
  }
  
  /*
      Once the token is destroyed, the game screen will increment
      the number of gems the player has if this token had a gem.
  */
  public boolean hasGem(){
    return doesHaveGem;
  }
  
  /**
   */
  public void animateTo(int r, int c){

    // We can really only animate a token if it is idle.
    if(state != IDLE){
      return;
    }
    
    // TODO: fix, it really isn't detached
    state = MOVING;
    
    // column row swapped here!    
    int detachedX = (int)(column  * (BOARD_W_IN_PX / 8.0f) + ((BOARD_W_IN_PX / 8.0f)/2.0f ));
    int detachedY = (int)((row-8) * (BOARD_H_IN_PX / 8.0f) + ((BOARD_H_IN_PX / 8.0f)/2.0f ));
    detachedPos = new PVector(detachedX, detachedY);
    
    rowToMoveTo = r;
    colToMoveTo = c;
    
    //
    if(c == column){
      int rowDiff = rowToMoveTo - row;
      distanceToMove = abs(rowDiff) * TOKEN_SIZE;
      moveDirection = rowDiff / abs(rowDiff);
    }else{
      int columnDiff = colToMoveTo - column;
      distanceToMove = abs(columnDiff) * TOKEN_SIZE;
      moveDirection = columnDiff / abs(columnDiff);
    }
  }
  
  /*
    Calculates the air speed velocity of an unladen swallow.
  */
  public void draw(){
    
    if(isPaused || type == TokenType.NULL){
      return;
    }
    
    int x = 0; 
    int y = 0;
    
    // 
    if(state == MOVING){
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

    // TODO: comment
    pushMatrix();
    resetMatrix();
    
    translate(START_X, START_Y);
    translate(x, y);
    
    // Draws an outline around all tokens
    if(DEBUG_ON){
      pushStyle();
      rectMode(CENTER);
      noFill();
      stroke(0, 100, 50);
      rect(0, 0, TOKEN_SIZE, TOKEN_SIZE);
      popStyle();
    }
    
    // We need to somehow distinguish tokens that have gems.
    if(hasGem()){
      pushStyle();
      rectMode(CENTER);
      fill(33, 60, 90, 128);
      rect(0, 0, TOKEN_SIZE, TOKEN_SIZE);
      popStyle();
    }
    
    // 
    if(state == DYING){
      scale(scaleSize >= 0 ? scaleSize : 0);
    }
    
    AssetStore store = AssetStore.Instance(globalApplet);
    
    pushStyle();
    imageMode(CENTER);
    image(store.get(type), 0, 0);
    popStyle();
    
    popMatrix();
  }

  /*
      Instead of directly checking the type between tokens, we
      have a method that just asks if it can match with whatever. This 
      allows us to later on match tokens with wildcards.
  */
  public boolean matchesWith(int other){
    return type == other;
  }  
}
