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
//final boolean SHOW_ALL_TOKENS = true;

// This includes the entire board, including the 'queued' tokens not visible
// to the user, that sit above the token the user interacts with.
final int BOARD_COLS = 8;
final int BOARD_ROWS = 16;

// Only need y index
final int START_ROW_INDEX = 8;

final int TOKEN_SIZE = 32;

final int CANVAS_WIDTH = 620;
final int CANVAS_HEIGHT = 400;//650;

// We define the board size in pixels and allow it to be any size
// and have the tokens center themselves inside those dimensions.
// This allows us to define a variable board size.
final int BOARD_W_IN_PX = TOKEN_SIZE * 8; //273;
final int BOARD_H_IN_PX = TOKEN_SIZE * 8; //273;

// 234 is the size of the diablo board.
// 28 is size of diablo token

// Where on the canvas the tokens start to be rendered.
final int START_X = (int)(CANVAS_WIDTH/2.0f  - BOARD_W_IN_PX/2.0f);
final int START_Y = (int)(CANVAS_HEIGHT/2.0f - BOARD_H_IN_PX/2.0f);// + 150;


// Used by the AssetStore
PApplet globalApplet;

Token[][] board = new Token[BOARD_ROWS][BOARD_COLS];

Stack<IScreen> screenStack = new Stack<IScreen>();

SoundManager soundManager;

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

  screenStack.push(new ScreenSplash());
}

void update(){
  IScreen currScreen = screenStack.top();
  
  currScreen.update();
  
  // Once the splash screen is dead, move on to the gameplay screen.
  if(currScreen.getName() == "splash" && currScreen.isAlive() == false){
    screenStack.pop();
    
    ScreenGameplay gameplay = new ScreenGameplay();
    
    LayerObserver hudLayer = new HUDLayer(gameplay);
    gameplay.addObserver(hudLayer);
    
    screenStack.push(gameplay);
  }
  
  // Gameplay screen only dies if the player loses.
  if(currScreen.getName() == "gameplay" && currScreen.isAlive() == false){
    screenStack.pop();
    
    screenStack.push(new ScreenGameOver());
  }
}

void draw(){
  update();
  screenStack.top().draw();
}

public void mousePressed(){
  screenStack.top().mousePressed();
}

public void mouseReleased(){
  screenStack.top().mouseReleased();
}

public void mouseDragged(){
  screenStack.top().mouseDragged();
}

public void mouseMoved(){
  screenStack.top().mouseMoved();
}

public void keyPressed(){
  screenStack.top().keyPressed();
}

public void keyReleased(){
  screenStack.top().keyReleased();
}

