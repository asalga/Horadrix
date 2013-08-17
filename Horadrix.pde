/*
 @pjs preload="data/fonts/solarwinds.png";
*/ 
 
/**
  Horadrix
  Andor Salga
  June 2013
*/

import ddf.minim.*;

final boolean DEBUG_CONSOLE_ON = false;

// This includes the entire board, including the 'queued' tokens not visible
// to the user, that sit above the token the user interacts with.
final int BOARD_COLS = 8;
final int BOARD_ROWS = 16;

// Only need y index
final int START_ROW_INDEX = 8;

// Where on the canvas the tokens start to be rendered.
final int START_X = 140;//200;


final int START_Y =  20 - 200;


final int TOKEN_SIZE = 28;
final int TOKEN_SPACING = 3;

// Used by the AssetStore
PApplet globalApplet;

Token[][] board = new Token[BOARD_ROWS][BOARD_COLS];
  
IScreen currScreen;

// Wrap println so we can easily disable all console output on release
void debugPrint(String str){
  if(DEBUG_CONSOLE_ON){
    println(str);
  }
}

void setup(){
  size(START_X + TOKEN_SIZE * BOARD_COLS, START_Y + TOKEN_SIZE * BOARD_ROWS + 40);
  
  // The style of the game is pixel art, so we don't want anti-aliasing
  noSmooth();
  
  globalApplet = this;
  currScreen = new ScreenSplash();
}

void update(){
  currScreen.update();
  
  if(currScreen.getName() == "splash" && currScreen.isAlive() == false){
    ScreenGameplay gameplay = new ScreenGameplay();
    
    currScreen = gameplay;
    
    LayerObserver hudLayer = new HUDLayer(gameplay);
    gameplay.addObserver(hudLayer);
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

