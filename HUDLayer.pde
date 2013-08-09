/*
    Shows the score, level on top of the gameplay screen.
*/
public class HUDLayer implements LayerObserver{
  
  RetroPanel parent;
  
  RetroLabel scoreLabel;
  RetroLabel timeLabel;
  RetroLabel levelLabel;
  
  RetroFont solarWindsFont;
  ScreenGameplay screenGameplay;
  
  public HUDLayer(ScreenGameplay s){
    screenGameplay = s;
    parent = new RetroPanel(10, 10, width - 20, 350);
    
    solarWindsFont = new RetroFont("data/fonts/solarwinds.png", 7*2, 8*2, 1*2);
    
    
    scoreLabel = new RetroLabel(solarWindsFont);
   
    //scoreLabel.setText("-------------");
    //scoreLabel.setHorizontalTrimming(true);
    scoreLabel.setHorizontalSpacing(0);   
    scoreLabel.pixelsFromTop(20);
     parent.addWidget(scoreLabel);
    
    timeLabel = new RetroLabel(solarWindsFont);
    timeLabel.setHorizontalTrimming(true);
    timeLabel.setHorizontalSpacing(2);
    //timeLabel.setText("");
    timeLabel.pixelsFromTopLeft(30, 5);
    parent.addWidget(timeLabel);
    
    levelLabel = new RetroLabel(solarWindsFont);
    levelLabel.setHorizontalTrimming(true);
    levelLabel.pixelsFromTopLeft(60, 5);
    parent.addWidget(levelLabel);
  }
  
  public void draw(){
    pushMatrix();
    scale(1);
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
    
    timeLabel.setText(min + ":" +  (sec < 10 ? "0" : "") + sec);
    
    levelLabel.setText("Level:" + screenGameplay.getLevel());
  }
  
  public void update(){
  }
  
  public void setZIndex(int zIndex){
  }
}

