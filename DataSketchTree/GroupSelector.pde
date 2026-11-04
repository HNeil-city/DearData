public class GroupSelector {
  private float hue, x, y, size;
  
  public GroupSelector(float hue){
    this.hue = hue;
    this.x = 10;
    this.y = 10;
    this.size = 10;
  }
  
  public void setDimensions(float x, float y , float size){
    this.x = x;
    this.y = y;
    this.size = size;
  }
  
  public void drawThisSelector() {
    stroke(0, 0, 1);
    fill(hue, 1, 1);
    square(x, y, size);
  }
  
  public boolean isHovering(float lastX, float lastY) {
    return lastX > x && lastX < x + size && lastY > y && lastY < y + size;
  }
  
  float lastPressX, lastPressY;
  
  void setLastPressed(){
    println("Mouse Pressed");
    lastPressX = mouseX;
    lastPressY = mouseY;
  }
  
  public boolean isSelected() {
    if (isHovering(lastPressX, lastPressY)) return true;
    return false;
  }
}
