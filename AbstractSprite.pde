public abstract class AbstractSprite implements Sprite {
  private float xpos,ypos,w,h;
  private float speed = 0;
  private float angle = 0;
  
  
   public boolean colision(Sprite sprite) {
       //https://glossar.hs-augsburg.de/Axposis_Aligned_Bounding_Boxpos
       return this.getLeft() <=sprite.getRight() && sprite.getLeft() <= this.getRight() && 
              this.getTop() <= sprite.getBottom() && sprite.getBottom() <= this.getBottom();
   }
   
  float getLeft() {
    return xpos - w/2;
  }
  
  float getRight() {
    return xpos + w/2; 
  };
  
  float getTop() {
     return ypos - h/2; 
  }
  
  float getBottom() {
     return ypos + h/2; 
  }
  
  public void draw () {
    //Everthing for the GLIDER
    // nonlineare Bewegung des Bildes zur Maus
    xpos = (sin(radians(angle)) * speed + xpos) % width;
    ypos = (-cos(radians(angle)) * speed + ypos) % height;
  
    if (xpos<0) {
      xpos = width;
    } 
  
    if (ypos<0) {
      ypos = height; 
    }
  

    // Koordinatensyposstem in Richtung
    // der Maus verschieben
    pushMatrix();
    translate (xpos, ypos);
    
    // Koordinatensyposstem rotieren
    rotate (radians(angle));
    translate(- 16, - 16);
    image(img, 0, 0, 32, 32); 
    popMatrix(); 
    
  }
  
   
}
