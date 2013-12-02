/*
    Displays game name and credits
*/
public class ScreenSplash implements IScreen{

  Ticker ticker;
  
  RetroFont solarWindsFont;

  RetroLabel creditsLabel;
  RetroLabel loadingLabel;
  RetroLabel mainTitleLabel;
  
    public void OnTransitionTo(){
  }


  public ScreenSplash(){
    ticker = new Ticker();
    
    // TODO: convert this to a singleton or factory.
    solarWindsFont = new RetroFont("data/fonts/solarwinds.png", 14, 16, 2);
    
    mainTitleLabel = new RetroLabel(solarWindsFont);
    mainTitleLabel.setText("H O R A D R I X");
    mainTitleLabel.pixelsFromCenter(0, 0);
    
    creditsLabel = new RetroLabel(solarWindsFont);
    creditsLabel.setText("Code & Art: Andor Salga");
    creditsLabel.setVerticalSpacing(0);
    creditsLabel.setHorizontalTrimming(true);
    creditsLabel.pixelsFromBottomLeft(0, 0);

    loadingLabel = new RetroLabel(solarWindsFont);
    loadingLabel.setHorizontalTrimming(true);
    loadingLabel.setText("Loading....");
    loadingLabel.pixelsFromCenter(0, 50);
  }
  
  /**
  */
  public void draw(){
    background(0);
    
    mainTitleLabel.draw();
    creditsLabel.draw();
    loadingLabel.draw();
  }
  
  public void update(){
    ticker.tick();
    if(ticker.getTotalTime() > 0.01f){
      //screens.transitionTo("gameplay");
      screens.transitionTo("story");
    }
  }
  
  public String getName(){
    return "splash";
  }
  
  public void keyReleased(){}
  public void keyPressed(){}
  
  public void mousePressed(){}
  public void mouseReleased(){}
  public void mouseDragged(){}
  public void mouseMoved(){}
}
