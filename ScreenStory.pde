/*  
*/
public class ScreenStory implements IScreen{
  
    public void OnTransitionTo(){
  }

  private int storyPointer = 0;
  
  RetroFont solarWindsFont;

  RetroLabel storyLabel;
  RetroLabel continueInstruction;
  
  private String[] story = new String[]{
    //There once were some dino 
    "MATCH 5 GEMS IN 5 MINUTES",
    "Match 10 gems in 8 minutes",
    "Match 15 gems in 13 minutes",
    "Match 20 gems in 15 minutes"
  };
  
  public ScreenStory(){
   solarWindsFont = new RetroFont("data/fonts/solarwinds.png", 14, 16, 2);
   
   storyLabel = new RetroLabel(solarWindsFont);
   storyLabel.setText(story[storyPointer]);
   storyLabel.pixelsFromCenter(0, 0);
   storyLabel.setDebug(false);
   
   continueInstruction = new RetroLabel(solarWindsFont);
   continueInstruction.setText("Click to continue");
   continueInstruction.pixelsFromCenter(0, 50);
 }
  
  public void draw(){
    background(0);
    storyLabel.draw();
    continueInstruction.draw();
  }
  
  public void update(){
    
  }
  
  // Mouse methods
  public void mousePressed(){}
  public void mouseReleased(){
    println("going to gameplay");
    screens.transitionTo("gameplay");
  }
  public void mouseDragged(){}
  public void mouseMoved(){}
  
  public void keyPressed(){}
  public void keyReleased(){}
  
  public String getName(){
    return "story";
  }
  
  public void nextLevel(){
    screens.transitionTo("gameplay");
    storyLabel.setText("MATCH " + gemsRequired[storyPointer] + " GEMS IN " + (int)timePermitted[storyPointer] + " MINUTES");
    storyPointer++;
  }
}
