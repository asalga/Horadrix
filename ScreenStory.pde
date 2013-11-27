/*  
*/
public class ScreenStory implements IScreen{

  private int storyPointer = 0;
  
  private RetroFont solarWindsFont;

  private RetroLabel storyLabel;
  private RetroLabel continueInstruction;

  private float textPos = 0;
  private float easing = 0.08;
  private boolean clicked = false;
  
  private float target;

  public ScreenStory(){
   solarWindsFont = new RetroFont("data/fonts/solarwinds.png", 14, 16, 2);
   
   storyLabel = new RetroLabel(solarWindsFont);
   //storyLabel.setText(story[storyPointer]);
   
   storyLabel.setDebug(false);
   
   //continueInstruction = new RetroLabel(solarWindsFont);
   //continueInstruction.setText("Click to continue");
 }
  
  public void draw(){
    background(0);
    storyLabel.draw();
    //continueInstruction.draw();
  }
  
  public void update(){

    if(clicked == false){
      textPos += (target - textPos) * easing;
    }
    else{
      textPos += textPos * easing;
    }

    storyLabel.pixelsFromCenter(0, (int)textPos);

    if(storyLabel.getY() > height + 30){
     screens.transitionTo("gameplay");
    }
  }

  public void OnTransitionTo(){
    textPos = -(height/2) + 20;// bit of fudge
    target =  0;// bit of fudge
    clicked = false;
  }
  
  // Mouse methods
  public void mousePressed(){}
  public void mouseReleased(){

    // Can only reset the target position once.
    if(clicked == true){
      return;
    }

    clicked = true;
    target = 300;
    textPos = 0.1;
  }
  public void mouseDragged(){}
  public void mouseMoved(){}
  
  public void keyPressed(){}
  public void keyReleased(){}
  
  public String getName(){
    return "story";
  }
  
  public void nextLevel(){
    storyLabel.setText("MATCH " + gemsRequired[storyPointer] + " SPECIAL GEMS IN " + (int)timePermitted[storyPointer] + " MINUTES");
    storyPointer++;
  }
}
