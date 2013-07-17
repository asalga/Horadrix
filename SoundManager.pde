
public class SoundManager{
  boolean muted = false;
  Minim minim;
  
  
  AudioPlayer failSwap;
  
  public void init(){
  }
  
  public SoundManager(PApplet applet){
    minim = new Minim(applet);
  
    failSwap = minim.loadFile("audio/failSwap.wav");
  }
  
  public void setMute(boolean isMuted){
    muted = isMuted;
  }
  
  public void playFailSwapSound(){
    if(muted){
      return;
    }
    failSwap.play();
    failSwap.rewind();
  }
    
  public void stop(){
    // dropPiece.close();
    // minim.stop();
    // super.stop();
  }
}
