const float pi = 3.14;

void setup() {
  float area;
  Serial.begin(9600);
  for (int r = 0; r <= 50; r = r + 5) {
    Serial.print("The area of a circle with radius of ");
    Serial.print(r);
    Serial.print(" is ");
    area = circleArea(r);
    Serial.println(area);
  }
}

void loop() { }

float circleArea(int radius) {
  float result = pi * radius * radius;
  return result;
}
