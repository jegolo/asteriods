class Explosion {
  
  private PImage explosion;
  private int count = 0;
  private int x;
  private int y;
  
  public Explosion(PImage image, int x, int y) {
     this.explosion = image;
     this.x = x;
     this.y = y;
  }
  
  public void draw() {
    if (isActive()) {
      pushMatrix();
      translate(x, y);
      translate(-16, -16);
      image(explosion.get((count % 5) * 64, (count / 5) * 64 , 64, 64), 0,0,64,64);
      popMatrix();
      count++;
    }
  }
  
  public boolean isActive() {
    return count<32;
  } 
  
}
