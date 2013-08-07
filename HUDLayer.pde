/*
    Shows the score, level on top of the gameplay screen.
*/
public class HUDLayer implements LayerObserver{
  
  RetroLabel scoreLabel;
  RetroLabel timeLabel;
  RetroLabel levelLabel;
  
  RetroFont solarWindsFont;
  ScreenGameplay screenGameplay;
  
  public HUDLayer(ScreenGameplay s){
    screenGameplay = s;
    
    solarWindsFont = new RetroFont("data/fonts/solarwinds.png", 7, 8, 1);
    
    scoreLabel = new RetroLabel(solarWindsFont);
    scoreLabel.setText("0000000");
  //  scoreLabel.setHorizontalTrimming(true);
    scoreLabel.pixelsFromTopRight(0, -50);
    
    timeLabel = new RetroLabel(solarWindsFont);
    timeLabel.setHorizontalTrimming(true);
    timeLabel.setHorizontalSpacing(2);
    //timeLabel.setText("");
    timeLabel.pixelsFromTopLeft(30, 5);
    
    levelLabel = new RetroLabel(solarWindsFont);
    levelLabel.setHorizontalTrimming(true);
    levelLabel.pixelsFromTopLeft(20, 5);
  }
  
  public void draw(){
   // pushMatrix();
    //scale(1);
    scoreLabel.draw();
    timeLabel.draw();
    levelLabel.draw();
   // popMatrix();
  }
  
  //
  public void notifyObserver(){
    String scoreStr = Utils.prependStringWithString("" + screenGameplay.getScore(), "0", 8);
    scoreLabel.setText("Score:" + scoreStr);
    
    int min = screenGameplay.getLevelTimeLeft() / 60;
    int sec = screenGameplay.getLevelTimeLeft() % 60;
    
    timeLabel.setText(min + ":" + sec);
    
    levelLabel.setText("Level:" + screenGameplay.getLevel());
  }
  
  public void update(){
  }
  
  public void setZIndex(int zIndex){
  }
}

