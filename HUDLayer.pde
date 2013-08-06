/*
    Shows the score, level on top of the gameplay screen.
*/
public class HUDLayer implements LayerObserver{
  
  RetroLabel scoreLabel;
  RetroFont solarWindsFont;
  ScreenGameplay screenGameplay;
  
  public HUDLayer(ScreenGameplay s){
    screenGameplay = s;
    
    solarWindsFont = new RetroFont("data/fonts/solarwinds.png", 7, 8, 1);
    
    scoreLabel = new RetroLabel(solarWindsFont);
    scoreLabel.setText("Score: 0000000");
    scoreLabel.setVerticalSpacing(0);
    scoreLabel.setHorizontalTrimming(true);
    scoreLabel.pixelsFromTopLeft(5, 5);
  }
  
  public void draw(){
    pushMatrix();
    scale(3);
    scoreLabel.draw();
    popMatrix();
  }
  
  //
  public void notifyObserver(){
    String scoreStr = Utils.prependStringWithString("" + screenGameplay.getScore(), "0", 8);
    scoreLabel.setText("Score:" + scoreStr);
  }
  
  public void update(){
  }
  
  public void setZIndex(int zIndex){
  }
}

