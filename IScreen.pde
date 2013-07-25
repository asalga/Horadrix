public interface IScreen{
  
  public void draw();
  public void update();
  
  // Mouse methods
  public void mousePressed();
  public void mouseReleased();
  public void mouseDragged();
  public void mouseMoved();
  
  public String getName();
  
  public boolean isAlive();
}
