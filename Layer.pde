/*
    A screen can have many layers associated with it. Layers are rendered
    from smaller indices to larger.
 */
public interface Layer{
  public void draw();
  public void update();
  public void setZIndex(int zIndex);
}
