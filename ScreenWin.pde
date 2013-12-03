/*
*
*/
public class ScreenWin extends IScreen{

  Ticker ticker;
  
  RetroFont solarWindsFont;

  RetroLabel title;
  RetroLabel win;
  
  public ScreenWin(){
    ticker = new Ticker();
    
    // TODO: convert this to a singleton or factory.
    solarWindsFont = new RetroFont("data/fonts/solarwinds.png", 14, 16, 2);
    
    title = new RetroLabel(solarWindsFont);
    title.setText("YOU HAVE WON!");
    title.pixelsFromTop(0);
    
    win = new RetroLabel(solarWindsFont);
    win.setHorizontalTrimming(true);
    win.setText("You have won the game, yay!");
    win.pixelsFromCenter(0, 0);
  }
  
  public void OnTransitionTo(){
  }

  /**
  */
  public void draw(){
    background(0);
    title.draw();
    win.draw();
  }
  
  public void update(){
    ticker.tick();
  }
  
  public String getName(){
    return "win";
  }
}