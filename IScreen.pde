/*
    
*/
public interface IScreen{
  
  public void draw();
  public void update();
  
  // Mouse methods
  public void mousePressed();
  public void mouseReleased();
  public void mouseDragged();
  public void mouseMoved();
  
  public void keyPressed();
  public void keyReleased();
  
  public String getName();
}
