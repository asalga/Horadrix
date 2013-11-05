import processing.core.*;

/*
 *  Single location that stores only 1 copy of the assets we require.
 */
public class AssetStore{
    
  private static PApplet app;
  private static AssetStore instance;
  
  private String BASE_IMG_PATH = "data/images/gems/diablo/";
  private PImage[] images;
  private String[] imageNames = {  "A.png","B.png", "C.png", "D.png", "E.png", "F.png", "G.png"};
                                   //"red_gem.gif", "green_gem.gif", "blue_gem.gif", "yellow_gem.gif", "white_gem.gif", "skull_gem.gif", "purple_gem.gif"};
                                   //"red_normal.gif", "green_normal.gif", "blue_normal.gif", "yellow_normal.gif", "white_normal.gif", "skull_normal.gif", "purple_normal.gif"};
  
  /*  
   */
  public PImage get(int asset){
    return images[asset];
  }
  
  //public PImage get(String asset){}
  
  /* As soon as this is contructed, load all the assets
   */
  private AssetStore(){    
    images = new PImage[imageNames.length];
    
    for(int i = 0; i < imageNames.length; i++){
      images[i] = app.loadImage(BASE_IMG_PATH + imageNames[i]);
    }
  }
  
  /* Not an ideal way of getting an instance, but not much
   * we can do about it.
   */
  public static AssetStore Instance(PApplet applet){
    if(instance == null){
      app = applet;
      instance = new AssetStore();
    }
    return instance;
  }
}
