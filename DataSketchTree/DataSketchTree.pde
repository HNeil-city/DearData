// Tree of features built purely from list order: each segment can sprout up to MAX_CHILDREN more.
// Angle = actual/estimated hours, length = actual hours, colour = group. Reshuffles itself every SHUFFLE_EVERY frames.

final float ANGLE_RANGE = QUARTER_PI; // max lean away from straight up
final float SIBLING_SPREAD = 0.4; // radians between siblings so they don't overlap (0 = off)
final float LEN_SCALE = 25;
final int MAX_CHILDREN = 2; // most segments that can sprout from one segment
final int TRUNK_WEIGHT = 6; 
final String DATA_FILE = "../feature_data_tree.csv";

final int SHUFFLE_EVERY = 5; // frames between shuffles (60 frames = 1 second)

// One entry per CSV row (same index in every array, shuffled together)
int rowCount;
int[] ids;
String[] groups;
float[] ratios, hours;    // NaN when the feature has no actual hours yet

ArrayList<String> groupNames = new ArrayList<String>();
ArrayList<Branch> branches = new ArrayList<Branch>();
float originX, originY;

void setup() {
  size(800, 800);
  colorMode(HSB, 360, 1, 1);
  originX = width / 2;
  originY = height - 60;   // low origin so the tree grows upward into the window
  loadData();
  buildTree(true);
}

void draw() {
  if (frameCount % SHUFFLE_EVERY == 0) {
    shuffleData();
    buildTree(false);
  }
  background(0);
  for (Branch b : branches) b.drawThisBranch();
  for (Branch b : branches) b.drawLabels();   // labels last so nothing covers them
}

// re-read the csv
void keyPressed() {
  if (key == 'r' || key == 'R') {
    loadData();
    buildTree(true);
  }
}

// shuffle applied to every data array together
void shuffleData() {
  for (int i = rowCount - 1; i > 0; i--) {
    swapRows(i, int(random(i + 1)));
  }
}

void swapRows(int a, int b) {
  int tId = ids[a]; ids[a] = ids[b]; ids[b] = tId;
  String tGroup = groups[a]; groups[a] = groups[b]; groups[b] = tGroup;
  float tRatio = ratios[a];  ratios[a] = ratios[b]; ratios[b] = tRatio;
  float tHours = hours[a];   hours[a] = hours[b];   hours[b] = tHours;
}

// get data 
void loadData() {
  Table table = loadTable(sketchPath(DATA_FILE), "header");
  rowCount = table.getRowCount();
  ids = new int[rowCount];
  groups = new String[rowCount];
  ratios = new float[rowCount];
  hours = new float[rowCount];
  groupNames.clear();

  for (int i = 0; i < rowCount; i++) {
    TableRow row = table.getRow(i);
    ids[i] = row.getInt("id");
    groups[i] = row.getString("group");

    // Skip features with no usable estimate or actual
    float est = parseHours(row.getString("estimated_hours"));
    float act = parseHours(row.getString("actual_hours"));
    boolean done = !Float.isNaN(est) && !Float.isNaN(act) && est > 0 && act > 0;
    ratios[i] = done ? act / est : Float.NaN;
    hours[i] = done ? act : Float.NaN;

    if (!groupNames.contains(groups[i])) groupNames.add(groups[i]);
  }
}

// parse sheet cell to float
float parseHours(String cell) {
  if (cell == null) return Float.NaN;
  cell = cell.trim().replace(',', '.');
  if (cell.length() == 0) return Float.NaN;
  try {
    return Float.parseFloat(cell);
  }
  catch (NumberFormatException e) {
    return Float.NaN;
  }
}

//helper functions
float calculateAngle(float ratio) {
  float lean = constrain(-log(ratio) / log(2), -1, 1);   // over budget leans right
  return HALF_PI + lean * ANGLE_RANGE;
}

float calculateLength(float actualHours) {
  return actualHours * LEN_SCALE;
}

float[] endPointFinder(float sx, float sy, float len, float angle) {
  return new float[] { sx + len * cos(angle), sy - len * sin(angle) };
}

// Hue comes from the group's fixed position in groupNames, so shuffling never recolours
float hueOf(String group) {
  return groupNames.indexOf(group) * (360.0 / groupNames.size());
}

// tree stuff
// parameter is used to prevent logging data on every build (shuffle) as log only needed once
void buildTree(boolean log) {
  branches.clear();

  // Only rows with hours are drawn, in their current order
  ArrayList<Integer> order = new ArrayList<Integer>();
  for (int i = 0; i < rowCount; i++) {
    if (!Float.isNaN(ratios[i])) order.add(i);
  }
  int n = order.size();

  float[][] endPoints = new float[n][];
  int[] depth = new int[n];
  Branch[] fan = new Branch[n];   // fan[p] holds the segments sprouting from segment p
  int deepest = 0;

  for (int k = 0; k < n; k++) {
    int r = order.get(k);
    float sx = originX, sy = originY;
    float spread = 0;
    Branch branch;

    if (k == 0) {
      // First segment is the trunk
      branch = new Branch();
      branches.add(branch);
    } else {
      int p = (k - 1) / MAX_CHILDREN;
      sx = endPoints[p][0];
      sy = endPoints[p][1];
      depth[k] = depth[p] + 1;

      // Siblings fan out evenly around the centre
      spread = ((k - 1) % MAX_CHILDREN - (MAX_CHILDREN - 1) / 2.0) * SIBLING_SPREAD;

      if (fan[p] == null) {
        fan[p] = new Branch();
        branches.add(fan[p]);
      }
      branch = fan[p];
    }

    float angle = calculateAngle(ratios[r]) + spread;
    float[] end = endPointFinder(sx, sy, calculateLength(hours[r]), angle);
    branch.createSegment(sx, sy, end[0], end[1], ids[r], hueOf(groups[r]), max(1, TRUNK_WEIGHT - depth[k]));

    endPoints[k] = end;
    deepest = max(deepest, depth[k]);
  }

  if (log) println("Rows: " + rowCount + ", drawn: " + n + ", branches: " + branches.size() + ", levels: " + (n > 0 ? deepest + 1 : 0));
}
