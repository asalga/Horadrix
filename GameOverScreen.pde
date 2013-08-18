/*
    Displays game name and credits
*/
public class GameOverScreen implements IScreen{

  boolean screenAlive;
  
  RetroFont solarWindsFont;

  RetroLabel gameOverLabel;
  
  public GameOverScreen(){
    screenAlive = true;
    
    // TODO: convert this to a singleton or factory.
    solarWindsFont = new RetroFont("data/fonts/solarwinds.png", 14, 16, 2);
    
    gameOverLabel = new RetroLabel(solarWindsFont);
    gameOverLabel.setText("G A M E  O V E R");
    gameOverLabel.pixelsFromCenter(0, 0);
  }
  
  /**
  */
  public void draw(){
    background(0);
    gameOverLabel.draw();
  }
  
  public void update(){
/*    ticker.tick();
    if(ticker.getTotalTime() > 0.5f){
      screenAlive = false;
      debugPrint("Splash screen closed.");
    }*/
  }
  
  public String getName(){
    return "game over";
  }

  public boolean isAlive(){
    return screenAlive;
  }
  
  public void keyReleased(){}
  public void keyPressed(){}
  
  public void mousePressed(){}
  public void mouseReleased(){}
  public void mouseDragged(){}
  public void mouseMoved(){}
}
