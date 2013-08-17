/*
    Shows the score, level on top of the gameplay screen.
*/
public class HUDLayer implements LayerObserver{
  
  RetroPanel parent;
  
  RetroLabel scoreLabel;
  RetroLabel timeLabel;
  RetroLabel levelLabel;
  RetroLabel FPS;
  
  RetroFont solarWindsFont;
  ScreenGameplay screenGameplay;
  
  public HUDLayer(ScreenGameplay s){
    screenGameplay = s;
    
    parent = new RetroPanel(10, 10, width - 20, height - 20);
    parent.setDebug(false);
    
    solarWindsFont = new RetroFont("data/fonts/solarwinds.png", 7*2, 8*2, 1*2);
    
    scoreLabel = new RetroLabel(solarWindsFont);
   
    
    scoreLabel.setHorizontalTrimming(true);
    scoreLabel.setHorizontalSpacing(5);   
    scoreLabel.pixelsFromTop(5);
    parent.addWidget(scoreLabel);
    
    // Time
    timeLabel = new RetroLabel(solarWindsFont);
    timeLabel.setHorizontalTrimming(true);
    timeLabel.setHorizontalSpacing(2);
    //timeLabel.setText("");
    timeLabel.pixelsFromTopLeft(75, 5);
    parent.addWidget(timeLabel);
    
    // Level
    levelLabel = new RetroLabel(solarWindsFont);
    levelLabel.setHorizontalTrimming(true);
    levelLabel.pixelsFromTopLeft(60, 5);
    parent.addWidget(levelLabel);
    
    // FPS
    FPS = new RetroLabel(solarWindsFont);
    FPS.pixelsFromBottomLeft(0, 0);
    FPS.setText("FPS: 0");
    //FPS.setHorizontalTrimming(true);

    parent.addWidget(FPS);
  }
  
  public void draw(){
    pushMatrix();
    
    scale(1);
    
    FPS.setText("FPS: " + (int)frameRate);
    parent.draw();
    
    // parent.pixelsFromTopLeft(mouseY, mouseX);
    // parent.setWidth ( mouseX);
    
    /*scoreLabel.draw();
    timeLabel.draw();
    levelLabel.draw();*/
    popMatrix();
  }
  
  //
  public void notifyObserver(){
    String scoreStr = Utils.prependStringWithString("" + screenGameplay.getScore(), "0", 8);
    
    /*String blah = "";
    
    for(int c = 0; c < (frameCount/40)%15; c++){
      blah += "0";
    }*/
    
    scoreLabel.setText("" + scoreStr);
    scoreLabel.updatePosition();
    
    int min = Utils.floatToInt(screenGameplay.getLevelTimeLeft() / 60);
    int sec = screenGameplay.getLevelTimeLeft() % 60;
    
    timeLabel.setText("TIME: " + min + ":" +  (sec < 10 ? "0" : "") + sec);
    
    levelLabel.setText("Level:" + screenGameplay.getLevel());
  }
  
  public void update(){
  }
  
  public void setZIndex(int zIndex){
  }
}

