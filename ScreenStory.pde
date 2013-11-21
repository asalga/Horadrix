/*  
*/
public class ScreenStory implements IScreen{
  
    public void OnTransitionTo(){
  }

  private int storyPointer = 0;
  
  RetroFont solarWindsFont;

  RetroLabel storyLabel;
  RetroLabel continueInstruction;
  
  public ScreenStory(){
   solarWindsFont = new RetroFont("data/fonts/solarwinds.png", 14, 16, 2);
   
   storyLabel = new RetroLabel(solarWindsFont);
   //storyLabel.setText(story[storyPointer]);
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
   // if(storyPointer <= NUM_LEVELS){
      screens.transitionTo("gameplay");
   // }
  }
  public void mouseDragged(){}
  public void mouseMoved(){}
  
  public void keyPressed(){}
  public void keyReleased(){}
  
  public String getName(){
    return "story";
  }
  
  public void nextLevel(){
    println("story pointer: " + storyPointer);
    storyLabel.setText("MATCH " + gemsRequired[storyPointer] + " SPECIAL GEMS IN " + (int)timePermitted[storyPointer] + " MINUTES");
    storyPointer++;
  }
}
