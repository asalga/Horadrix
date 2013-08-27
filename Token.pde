/*
    A token is an object the player moves in order to make matches.
    
    A token may have a gem within it. If the player destroys a token that
    has a gem inside it, we add that to the count in ScreenGameplay. After
    getting enough gems, the player can progress to the next level.
*/
public class Token{
  
  private Ticker animTicker;
  private Ticker ticker;
  private Ticker deathTicker;
  
  // Used for debugging
  private int id;
  
  // TODO: find better way of doing this?
  // When the token is falling, we need it to be a float
  // so just define it as a float to begin with.
  private int row;
  private int column;
  
  private boolean dying;
  private boolean isLiving;
  
  private boolean colored;
  private int type;
  private boolean doesHaveGem;
  
  private int rowToMoveTo;
  private int colToMoveTo;
  
  private boolean returning;
  private boolean hasArrivedAtDest;
  
  private boolean detached;
  private PVector detachedPos;
  
  // Set this and decrement until we reach zero.
  private float distanceToMove;
  
  private float scaleSize;
  
  private int moveDirection;
  private final float MOVE_SPEED = TOKEN_SIZE * 5.0f; // token size per second
  private final float DROP_SPEED = 10;
  
  // Use can select up to 2 tokens before they get swapped.
  private boolean isSelected;
  
  public Token(){
    setType(TokenType.NULL);
    
    id = Utils.nextID();
    
    isSelected = false;
    isLiving = true;
    ticker = new Ticker();
    
    row = 0;
    column = 0;
    
    doesHaveGem = false;
    
    detached = false;
    
    //markedForRemoval = false;
    dying = false;
    colored = true;
    
    detachedPos = new PVector();
    
    // TODO: need to really need to set these?
    rowToMoveTo = 0;
    colToMoveTo = 0;
    moveDirection = 0;
    
    scaleSize = 1.0f;
    
    returning = false;
    hasArrivedAtDest = false;
  }
  
  /**
  */
  //public void moveToRow(int rowToMoveTo){
  //  this.rowToMoveTo = rowToMoveTo;
  //  detached = true;
  //}
  
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
  
  public int getID(){
    return id;
  }
  
  /*public void unMark(){
    //markedForRemoval = false;
    dying = false;
    animTicker = null;
    colored = true;
  }*/
  
  public void setSelect(boolean select){
    isSelected = select;
  }
  
  /**
   */
  public void swap(Token other){
    int tempRow = row;
    int tempCol = column;
    
    this.setRowColumn(other.row, other.column);
    other.setRowColumn(tempRow, tempCol);    
  }
  
  public void kill(){//markForDeletion(){
    dying = true;
    animTicker = new Ticker();
    //deathTicker = new Ticker();
  }
  
  public boolean isDying(){
    return dying;
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
  
  public boolean isMoving(){
    return moveDirection != 0;
  }
  
  //
  public void dropIntoCell(){
    row = rowToMoveTo;
    column = colToMoveTo;
    
    board[rowToMoveTo][colToMoveTo] = this;
    
    hasArrivedAtDest = false;
    
    distanceToMove = 0;
    
    moveDirection = 0;
  }
  
  /*
   */
  public void update(){
    
    if(Keyboard.isKeyDown(KEY_P)){
      return;
    }
    
    ticker.tick();
    
    if(animTicker != null){
      animTicker.tick();
    }
    
    if(detached){
      float amtToMove = MOVE_SPEED * moveDirection * ticker.getDeltaSec();
      
      if(row == rowToMoveTo){
        detachedPos.x += amtToMove;
      }
      else{
        detachedPos.y += amtToMove;
      }
      
      distanceToMove -= abs(amtToMove);
      
      if(distanceToMove <= 0){
        detached = false;
        hasArrivedAtDest = true;
        //floatingTokens.remove(this);
      }
    }
    
    if(deathTicker != null){
      deathTicker.tick();
      if(deathTicker.getTotalTime() >= 1.0f){
        isLiving = false;
      }
    }
  }
  
  /* Don't use isAlive for variable name because Processing.js gets confused
     with method and variable names that share the same name.
   */
  public boolean isAlive(){
    return isLiving;
  }
  
  public void destroy(){
    deathTicker = new Ticker();
    //animTicker = new Ticker();
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
    // TODO: fix, it really isn't detached
    detached = true;
    
    // TODO: fix, why -1??
    // column row swapped here.
    //detachedPos = new PVector((column-1) * TOKEN_SIZE + (TOKEN_SIZE/2.0f), (row-1) * TOKEN_SIZE + (TOKEN_SIZE/2.0f));
    
    int detachedX = (int)(column  * (BOARD_W_IN_PX / 8.0f) + ((BOARD_W_IN_PX / 8.0f)/2.0 ));
    int detachedY = (int)((row-8) * (BOARD_H_IN_PX / 8.0f) + ((BOARD_H_IN_PX / 8.0f)/2.0 ));
    detachedPos = new PVector(detachedX, detachedY);//new PVector((column-1) * TOKEN_SIZE + (TOKEN_SIZE/2.0f), (row-1) * TOKEN_SIZE + (TOKEN_SIZE/2.0f));
    
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
   *
   */
  public void draw(){
    
    if(Keyboard.isKeyDown(KEY_P) || type == TokenType.NULL){
      return;
    }
    
    int x = 0; 
    int y = 0;
    
    // 
    if(detached){
      x = (int)detachedPos.x;// * TOKEN_SIZE - (TOKEN_SIZE/2);
      y = (int)detachedPos.y;// * TOKEN_SIZE - (TOKEN_SIZE/2);
    }
    else{
      // x = column * TOKEN_SIZE;// - (TOKEN_SIZE/2);// + (column);
      // y = row * TOKEN_SIZE;// - (TOKEN_SIZE/2);// + (row);
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
      fill(255,0,0,255);
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
    
    // Shrink the token if it is dying
    if(animTicker != null){
      scaleSize -= animTicker.getDeltaSec() * 1.0f;
      scale(scaleSize >= 0 ? scaleSize : 0);      
    }
    
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
