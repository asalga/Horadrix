/*
    see processing.js wrapper
*/
public class SoundManager{
  boolean muted = false;
  Minim minim;
  
  PlayerQueue matchPlayer;
  PlayerQueue successSwapPlayer;
  PlayerQueue failSwapPlayer;

  /*
      Handles the issue where we want to play multiple audio streams from the same clip.
  */
  private class PlayerQueue{
    private ArrayList <AudioPlayer> players;
    private String path;

    public PlayerQueue(String audioPath){
      path = audioPath;
      players = new ArrayList<AudioPlayer>();
      appendPlayer();
    }

    public void close(){
      for(int i = 0; i < players.size(); i++){
        players.get(i).close();
      }
    }

    public void play(){
      int freePlayerIndex = -1;
      for(int i = 0; i < players.size(); i++){
        if(players.get(i).isPlaying() == false){
          freePlayerIndex = i;
          break;
        }
      }

      if(freePlayerIndex == -1){
        appendPlayer();
        freePlayerIndex = players.size()-1;
      }

      players.get(freePlayerIndex).play();
      players.get(freePlayerIndex).rewind();
    }

    private void appendPlayer(){
      AudioPlayer player = minim.loadFile(path);
      players.add(player);
    }
  }
  
  public void init(){
  }
  
  public SoundManager(PApplet applet){
    minim = new Minim(applet);
  
    successSwapPlayer = new PlayerQueue("audio/success_swap.wav");
    failSwapPlayer = new PlayerQueue("audio/fail_swap.wav");
    matchPlayer = new PlayerQueue("audio/peg.wav");
  }
  
  public void setMute(boolean isMuted){
    muted = isMuted;
  }
  
  public boolean isMuted(){
    return muted;
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
    successSwapPlayer.play();
  }

  public void playMatchSound(){
    matchPlayer.play();
  }
  
  public void playFailSwapSound(){
    failSwapPlayer.play();
  }
  
  public void stop(){
    failSwapPlayer.close();
    successSwapPlayer.close();
    matchPlayer.close();
    minim.stop();
    
    // super.stop();
  }
}
