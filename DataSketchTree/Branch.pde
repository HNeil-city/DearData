// One fork: the segments (up to MAX_CHILDREN) that sprout from the same point.
public class Branch {
  private ArrayList<Segment> segments = new ArrayList<Segment>();

  public void createSegment(float x1, float y1, float x2, float y2, int id, float hue, int weight) {
    Segment s = new Segment(x1, y1, x2, y2, id, hue);
    s.setStrokeWeight(weight);
    segments.add(s);
  }

  public int size() {
    return segments.size();
  }

  public void drawThisBranch() {
    for (Segment s : segments) s.drawThisSegment();
  }

  public void drawLabels() {
    for (Segment s : segments) s.drawLabel();
  }
}
