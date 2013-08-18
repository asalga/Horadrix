/*
*/
public class Stack<T>{
  
  private ArrayList<T> items;
  
  public Stack(){
    items = new ArrayList<T>();
  }
  
  public void pop(){
    items.remove(items.size() - 1);
  }
  
  public T top(){
    return items.get(items.size() - 1);
  }
  
  public void push(T item){
    items.add(item);
  }
  
  public boolean isEmpty(){
    return items.isEmpty();
  }
  
  public int size(){
    return items.size();
  }
  
  public void clear(){
    items.clear();
  }
}
