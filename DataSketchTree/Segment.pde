// One feature: a line from where its dependency ended to its own end point.
public class Segment {
  private float x1, y1, x2, y2;
  private int id;               // feature id from the CSV
  private float hue;            // colour from the feature's group
  private int strokeWeight = 1;

  public Segment(float x1, float y1, float x2, float y2, int id, float hue) {
    this.x1 = x1;
    this.y1 = y1;
    this.x2 = x2;
    this.y2 = y2;
    this.id = id;
    this.hue = hue;
  }

  public void setStrokeWeight(int strokeWeight) {
    this.strokeWeight = strokeWeight;
  }

  // True when the mouse is within the line's thickness
  private boolean isHovered() {
    float dx = x2 - x1, dy = y2 - y1;
    float lenSq = dx * dx + dy * dy;

    // Position of the mouse along the line, clamped to the segment
    float t = (lenSq == 0) ? 0 : constrain(((mouseX - x1) * dx + (mouseY - y1) * dy) / lenSq, 0, 1);
    float tol = strokeWeight;
    return dist(mouseX, mouseY, x1 + t * dx, y1 + t * dy) <= tol;
  }

  public void drawThisSegment() {
    strokeWeight(strokeWeight);
    if (isHovered()) stroke(0, 0, 1);   // white highlight
    else stroke(hue, 1, 1);
    line(x1, y1, x2, y2);
  }

  // Feature id next to the mouse while hovering
  public void drawLabel() {
    if (!isHovered()) return;
    fill(0, 0, 1);
    noStroke();
    text("#" + id, mouseX + 10, mouseY - 10);
  }
}
