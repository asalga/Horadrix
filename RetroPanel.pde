/*
    A panel represents a generic container that can hold
    other widgets
*/
public class RetroPanel extends RetroWidget{

  ArrayList<RetroWidget> children;
  protected boolean dirty;
  private int anchor;
    
  public RetroPanel(){
    w = 0;
    h = 0;
    x = 0;
    y = 0;
    removeAllChildren();
    anchor = 0;
  }
  
  public void removeAllChildren(){
    children = new ArrayList<RetroWidget>();
  }

  public void addWidget(RetroWidget widget){
    widget.setParent(this);
    children.add(widget);
  }
  
  /*
    If the width changes, we'll need to tell all the children
    to readjust themselves.
  */
  public void setWidth(int w){
    this.w = w;
  }
  
  public int getX(){
    return x;
  }
  
  public int getWidth(){
    return w;
  }
  
  public RetroPanel(int x, int y, int w, int h){
    removeAllChildren();
    this.w = w;
    this.h = h;
    this.x = x;
    this.y = y;
  }
  
  /*
      Render widget from the top center relative to parent.
  */
  public void pixelsFromTop(int yPixels){
    println("pixels from top()");
    RetroWidget p = getParent();
    x = (p.w/2) - (w/2);
    y = yPixels;
    anchor = 1;
  }
  
  /*
    
  */
  public void pixelsFromTopLeft(int yPixels, int xPixels){
    RetroWidget p = getParent();
    x = p.x + xPixels;
    y = p.y + yPixels;
    anchor = 2;
  }
  
  /*
  */
  public void pixelsFromTopRight(int yPixels, int xPixels){
    RetroWidget p = getParent();
    println(w);
    x = p.x + p.w - w + xPixels;
    y = p.y + yPixels;
    anchor = 3;
  }
  
  public void pixelsFromBottomLeft(int bottomPixels, int leftPixels){
    RetroWidget p = getParent();
    y = p.y + p.h - h + bottomPixels;
    x = p.x + leftPixels;
    anchor = 4;
  }
  
  public void updatePosition(){
    dirty = true;
  }
  
  /**
   */
  public void pixelsFromCenter(int xPixels, int yPixels){
    RetroWidget p = getParent();
    x = (p.w/2) - (w/2) + xPixels;
    y = (p.h/2) - (h/2) + yPixels;
    anchor = 5;
  }
  
  /*
  */
  public void draw(){
    
    if(dirty == true){
      dirty = false;
      println("No longer dirty");
      if(anchor == 1)
      pixelsFromTop(10);
    }
    
    if(debugDraw){
    pushStyle();
    noFill();
    stroke(255, 0, 0, 255);
    strokeWeight(1);
    rect(x, y, w, h);
    popStyle();
    }
    
    if(visible == false || children.size() == 0){
      return;
    }
    
    pushMatrix();
    translate(x, y);
    for(int i = 0; i < children.size(); i++){
      children.get(i).draw();
    }
    popMatrix();
  }
}
