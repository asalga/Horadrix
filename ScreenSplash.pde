/**
 */
public class ScreenSplash implements IScreen{

  RetroPanel mainTitlePanel;
  RetroLabel mainTitleLabel;

  Ticker ticker;
  boolean alive;
  
  RetroFont solarWindsFont;
  
  RetroPanel panel;  
  RetroLabel versionLbl;
  
  public ScreenSplash(){
    ticker = new Ticker();
    alive = true;
    solarWindsFont = new RetroFont("data/fonts/solarwinds.png", 7, 8, 1);
    
    mainTitlePanel = new RetroPanel(0, 0, width, height);
    mainTitleLabel = new RetroLabel(solarWindsFont);
    mainTitleLabel.setText("---- H O R A D R I X ----");
    mainTitlePanel.addWidget(mainTitleLabel);
    
    mainTitleLabel.pixelsFromCenter(0,0);
    
    
    panel = new RetroPanel(0, 0, width, height);
    versionLbl = new RetroLabel(solarWindsFont);
    versionLbl.setText("Code & Art: Andor Salga");  
  
    panel.addWidget(versionLbl);
    
    //versionLbl.setJustification(RetroLabel.JUSTIFY_MANUAL);
    versionLbl.setVerticalSpacing(3);
  
    versionLbl.setHorizontalTrimming(true);
    
    //versionLbl.pixelsFromBottomLeft(0, 0);
    
    
    // textSprite = new TextSprite("SOLAR WINDS");
    // textSprite.setKerning(TextSprite.MONOSPACED);
    // textSprite.setKerning(TextSprite.????);
    
    versionLbl.pixelsFromBottomLeft(0, 0);
    //versionLbl.setHorizontalSpacing(0);
    // panel.add(textSprite);
    noSmooth();
  }
  
  /**
  */
  public void draw(){
    background(0);
    panel.draw();
    mainTitlePanel.draw();
  }
  
  public void update(){
    ticker.tick();
    if(ticker.getTotalTime() > 0.01f){
      alive = false;
    }
  }
  
  public String getName(){
    return "splash";
  }

  public boolean isAlive(){
    return alive;
  }
  
  public void keyReleased(){}
  public void keyPressed(){}
  
  public void mousePressed(){}
  public void mouseReleased(){}
  public void mouseDragged(){}
  public void mouseMoved(){}
}
