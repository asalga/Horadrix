/*
    see processing.js wrapper
*/
public class SoundManager{
  boolean muted = false;
  Minim minim;
  
  AudioPlayer failSwap;
  AudioPlayer successSwap;
  
  
  public void init(){
  }
  
  public SoundManager(PApplet applet){
    minim = new Minim(applet);
  
    failSwap = minim.loadFile("audio/fail_swap.wav");
    successSwap = minim.loadFile("audio/success_swap.wav");
  }
  
  public void setMute(boolean isMuted){
    muted = isMuted;
  }
  
  /*
    
  */
  private void play(AudioPlayer player){
    if(muted || player.isPlaying()){
      return;
    }
    
    player.play();
    player.rewind();
  }
  
  public void playSuccessSwapSound(){
    play(successSwap);
  }
  
  public void playFailSwapSound(){
    play(failSwap);
  }
  
  public void stop(){
    // dropPiece.close();
    // minim.stop();
    // super.stop();
  }
}
