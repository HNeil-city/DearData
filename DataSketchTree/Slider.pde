public class Slider {
  private float w, h, x, y;
  private boolean isHoz;

  private float slidePer;

  public Slider(float w, float h, float x, float y, boolean isHoz) {
    this.w = w;
    this.h = h;
    this.x = x;
    this.y = y;
    this.isHoz = isHoz;
    this.slidePer = 0;
    this.knobR = min(w+10, h+10);
  }

  float knobX, knobY, knobR;

  void drawSlider() {
    stroke(0, 0, 1);
    fill(0, 0, 0.2);
    rect(x, y, w, h);

    //clamp slidePer
    slidePer = constrain(slidePer, 0, 1);
    //constain correct axis
    if (isHoz) {
      knobY = y + h/2;
      knobX = x + slidePer * w;
    } else {
      knobX = x + w/2;
      knobY = y + slidePer * h;
    }

    if (overKnob()) fill(0, 0, 0.4);

    circle(knobX, knobY, knobR);

    //handle moving it
    if (mousePressed && overKnob()) {
      if (isHoz) slidePer = (mouseX-x) / w;
      else slidePer = (mouseY - y) / h;
    }
    else if (overKnob()){
      drawToolTip();
    }
  }
  
  void drawToolTip(){
    stroke(0, 0, 1);
    fill (0, 0, 1);
    textAlign(LEFT, CENTER);
    textSize(14);
    text("WASD or mouse to control\nUse \'e\' to set to 0\nControls Shuffle freq", mouseX + 20, mouseY);
    
  }

  public void moveWithKey() {
    if (key == 'a' && isHoz) slidePer -= 0.02; 
    else if (key == 'd' && isHoz) slidePer += 0.02;
    else if (key == 'w' && !isHoz) slidePer -= 0.02;
    else if (key == 's' && !isHoz) slidePer += 0.02;
    else if (key == 'e') slidePer = 0;
  }

  public float getSlidePer() {
    return slidePer;
  }

  boolean overKnob () {
    float dist = dist(mouseX, mouseY, knobX, knobY);
    return dist < knobR;
  }
}
