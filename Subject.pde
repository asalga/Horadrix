/*   
*/
public interface Subject{
  public void addObserver(LayerObserver o);
  public void removeObserver(LayerObserver o);
  public void notifyObservers();
}
