/**
*/
public class RetroPanel extends RetroWidget{

  ArrayList<RetroWidget> children;
  
  public RetroPanel(){
    w = 0;
    h = 0;
    x = 0;
    y = 0;
    removeAllChildren();
  }
  
  public void removeAllChildren(){
    children = new ArrayList<RetroWidget>();
  }

  public void addWidget(RetroWidget widget){
    widget.setParent(this);
    children.add(widget);
  }
  
  public void setWidth(int w){
    this.w = w;
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
  
  public void pixelsFromTop(int pixels){
    x = width/2 - 60/2;
    //startY = 0;
  }
  
  public void pixelsFromBottomLeft(int bottomPixels, int leftPixels){
    y = parent.y + parent.h - h + bottomPixels;
    x = parent.x + leftPixels;
  }
  
  /**
   */
  public void pixelsFromCenter(int xPixels, int yPixels){
    x = (parent.w/2) - (w/2) + xPixels;
    y = (parent.h/2) - (h/2) + yPixels;
  }
  
  
  public void draw(){
    
    pushStyle();
    noFill();
    stroke(255, 0, 0,32);
    rect(x, y, w, h);
    popStyle();
    
    if(visible == false || children.size() == 0){
      return;
    }
    
    pushMatrix();
    translate(x,y);
    for(int i = 0; i < children.size(); i++){
      children.get(i).draw();
    }
    popMatrix();
  }
}
