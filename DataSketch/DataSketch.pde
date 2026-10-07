void setup() {
  size(600, 600);
  pixelDensity(2);
}

FloatList relativeSaturationCalc(FloatList vals) {
  float max = vals.max();
  FloatList relativeList = new FloatList();
  for (float f : vals) {
    relativeList.append(f/max);
  }
  return relativeList;
}

void draw() {
  rect(20, 20, 20, 20);
}
