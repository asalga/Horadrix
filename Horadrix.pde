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

