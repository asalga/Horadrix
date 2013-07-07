public class Tuple{
  private Object first, second;
  
  public Tuple(){
    first = second = null;
  }
  
  public void swap(){
    Object temp = first;
    first = second;
    second = temp;
  }
  
  public Object getFirst(){
    return first;
  }
  
  public Object getSecond(){
    return second;
  }
 
  public void setFirst(Object first){
    this.first = first;
  }
  
  public void setSecond(Object second){
    this.second = second;
  }
  
  public int numObjects(){
    if(isEmpty()){
      return 0;
    }
    if(isFull()){
      return 2;
    }
    return 2;
  }
  
  public boolean isFull(){
    return first != null && second != null;
  }
  
  public boolean isEmpty(){
    return first == null && second == null;
  } 
}
