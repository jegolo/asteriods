public interface Sprite {
 
  void draw();
  
  boolean colision(Sprite sprite);
  
  float getLeft();
  float getRight();
  float getTop();
  float getBottom();
  
}
