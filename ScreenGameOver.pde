/*
    Displays game name and credits
*/
public class ScreenGameOver implements IScreen{
  
  RetroFont solarWindsFont;

  RetroLabel gameOverLabel;
  RetroLabel retryLabel;
  
  public void OnTransitionTo(){
  }
  
  public ScreenGameOver(){
    
    // TODO: convert this to a singleton or factory.
    solarWindsFont = new RetroFont("data/fonts/solarwinds.png", 14, 16, 2);
    
    gameOverLabel = new RetroLabel(solarWindsFont);
    gameOverLabel.setText("G A M E  O V E R");
    gameOverLabel.pixelsFromCenter(0, 0);
    
    retryLabel = new RetroLabel(solarWindsFont);
    retryLabel.setText("<< Retry? >>");
    retryLabel.pixelsFromCenter(0, 50);
  }
  
  /**
  */
  public void draw(){
    background(0);
    gameOverLabel.draw();
    retryLabel.draw();
  }
  
  public void update(){
  }
  
  public String getName(){
    return "gameover";
  }

  public void keyReleased(){}
  public void keyPressed(){}
  
  public void mousePressed(){
    screens.setCurr(new ScreenGameplay());
  }
  
  public void mouseReleased(){}
  public void mouseDragged(){}
  public void mouseMoved(){}
}
