/*
    Displays game name and credits
*/
public class ScreenGameOver implements IScreen{

  boolean screenAlive;
  
  RetroFont solarWindsFont;

  RetroLabel gameOverLabel;
  RetroLabel retryLabel;
  
  public ScreenGameOver(){
    screenAlive = true;
    
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
  
  /**
      TODO: clean
  */
  public void mousePressed(){
    ScreenGameplay gameplay = new ScreenGameplay();
    LayerObserver hudLayer = new HUDLayer(gameplay);
    gameplay.addObserver(hudLayer);
        
    screenStack.push(gameplay);
  }
  
  public void mouseReleased(){}
  public void mouseDragged(){}
  public void mouseMoved(){}
}
