public class HUDLayer implements Layer{
  
  RetroLabel scoreLabel;
  RetroFont solarWindsFont;
  int score;
   
  public HUDLayer(){
    score = 0;
    
    solarWindsFont = new RetroFont("data/fonts/solarwinds.png", 7, 8, 1);
    
    scoreLabel = new RetroLabel(solarWindsFont);
    scoreLabel.setText("Score: 0000000");
    scoreLabel.setVerticalSpacing(0);
    scoreLabel.setHorizontalTrimming(true);
    scoreLabel.pixelsFromTopLeft(5, 5);
    
  }
  
  public void draw(){
    scoreLabel.draw();
  }
  
  public void update(){
    score += frameCount/150;
    
    scoreLabel.setText("Score: " + score);
  }
  
  public void setZIndex(int zIndex){
  }
}

