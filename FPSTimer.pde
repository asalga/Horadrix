/*
*/
public static class FPSTimer{

  private static float resolution;
  private static int fps;
  
  //private static Ticker ticker = new Horadrix.Ticker();
  
  public void setResolution(float res){
    if(res >= 0){
      resolution = res;
    }
  }
  
  /*
  */
  public int getFPS(){
    return 42;//globalApplet.frameRate;
  }
}
