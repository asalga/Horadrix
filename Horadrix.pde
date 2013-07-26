/*
 @pjs preload="data/fonts/solarwinds.png";
*/ 
 
/**
  Horadrix
  Andor Salga
  June 2013
*/

import ddf.minim.*;

// The amount of rows that are visible
final int BOARD_COLS = 8;
final int BOARD_ROWS = 16;

// Only need y index
final int START_ROW_INDEX = 8;
// Where on the canvas the tokens start to be rendered.
final int START_X = 100;//200;
final int START_Y = 0;//-20; // 20 - -220
final int TOKEN_SIZE = 28;
final int TOKEN_SPACING = 3;

// For the AssetStore
PApplet globalApplet;

Token[][] board = new Token[BOARD_ROWS][BOARD_COLS];
// When a match is created, the matched tokens are removed from the board array
// and 'float' above the board and drop down until they arrive where they need to go.
// We do this because as they fall, we can't give them a integer position, but need to
// use a float.
ArrayList<Token> floatingTokens;

// Tokens that have been remove from the board, but still need to be rendered for their
// death animation.
ArrayList<Token> dyingTokens;

//ArrayList<Token> dyingTokensOnBoard

  
IScreen currScreen;
  
void setup(){
  size(START_X + TOKEN_SIZE * BOARD_COLS, START_Y + TOKEN_SIZE * BOARD_ROWS);
  globalApplet = this;
  
  currScreen = new ScreenSplash();
}

void update(){
  currScreen.update();
  
  if(currScreen.getName() == "splash" && currScreen.isAlive() == false){
    currScreen = new ScreenGameplay();
  }
}

void draw(){
  update();
  currScreen.draw();
}

public void mousePressed(){
  currScreen.mousePressed();
}

public void mouseReleased(){
  currScreen.mouseReleased();
}

public void mouseDragged(){
  currScreen.mouseDragged();
}

public void mouseMoved(){
  currScreen.mouseMoved();
}

public void keyPressed(){
  currScreen.keyPressed();
}

public void keyReleased(){
  currScreen.keyReleased();
}

