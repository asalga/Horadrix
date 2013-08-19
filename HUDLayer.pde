/*
    Shows the score, level on top of the gameplay screen.
*/
public class HUDLayer implements LayerObserver{
  
  RetroPanel parent;
  
  RetroLabel scoreLabel;
  RetroLabel levelLabel;
  RetroLabel timeLabel;
  RetroLabel gemsAcquired;
  RetroLabel FPS;
  
  RetroFont solarWindsFont;
  ScreenGameplay screenGameplay;
  
  public HUDLayer(ScreenGameplay s){
    screenGameplay = s;
    
    // Add a bit of a border between the edge of the canvas for aesthetics
    parent = new RetroPanel(10, 10, width - 20, height - 20);
    parent.setDebug(false);
    
    solarWindsFont = new RetroFont("data/fonts/solarwinds.png", 7*2, 8*2, 1*2);
    
    // Position of panel isn't being set correctly.
    RetroPanel scorePanel = new RetroPanel(10, 10, 100, 20);
    scorePanel.pixelsFromTop(10);
    
    // Score
    scoreLabel = new RetroLabel(solarWindsFont);
    scoreLabel.setHorizontalTrimming(false);
    scoreLabel.setHorizontalSpacing(1);   
    scoreLabel.pixelsFromTopRight(0, 0);
    scorePanel.addWidget(scoreLabel);
    parent.addWidget(scorePanel);
    
    // Gems
    gemsAcquired = new RetroLabel(solarWindsFont);
    gemsAcquired.setHorizontalTrimming(true);
    gemsAcquired.setHorizontalSpacing(2);
    gemsAcquired.pixelsFromTopLeft(105, 5);
    parent.addWidget(gemsAcquired);
    
    // Time
    timeLabel = new RetroLabel(solarWindsFont);
    timeLabel.setHorizontalTrimming(true);
    timeLabel.setHorizontalSpacing(2);
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
    FPS.setHorizontalTrimming(true);

    parent.addWidget(FPS);
  }
  
  public void draw(){
    parent.draw();
  }
  
  /*
  */
  public void notifyObserver(){
    String scoreStr = Utils.prependStringWithString("" + screenGameplay.getScore(), "0", 8);
    
    int min = Utils.floatToInt(screenGameplay.getLevelTimeLeft() / 60);
    int sec = screenGameplay.getLevelTimeLeft() % 60;
    
    FPS.setText("FPS: " + (int)frameRate);
    scoreLabel.setText("" + scoreStr);
    levelLabel.setText("Level:" + screenGameplay.getLevel());
    timeLabel.setText("TIME: " + min + ":" +  (sec < 10 ? "0" : "") + sec);
    gemsAcquired.setText("Gems: " + screenGameplay.getNumGems() + "/" + screenGameplay.getNumGemsForNextLevel());
  }
  
  public void update(){
  }
  
  public void setZIndex(int zIndex){
  }
}

