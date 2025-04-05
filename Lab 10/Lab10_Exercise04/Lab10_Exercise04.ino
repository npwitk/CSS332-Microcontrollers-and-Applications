void setup() {
  Serial.begin(9600); // Start Serial communication
  showMenu();         // Show the menu initially
}

void loop() {
  if (Serial.available() > 0) {
    char input = Serial.read(); // Read the first character entered
    
    // Clear the rest of the input buffer (like newline or extra characters)
    while (Serial.available() > 0) {
      Serial.read();
    }

    switch (input) {
      case '1':
        Serial.println("I chose Coke");
        showMenu();
        break;
      case '2':
        Serial.println("I chose Pepsi");
        showMenu();
        break;
      case '3':
        Serial.println("I chose Tea");
        showMenu();
        break;
      case '4':
        Serial.println("I chose Coffee");
        showMenu();
        break;
      default:
        Serial.println("Not in the list. Please select again: ");
        break;
    }
  }
}

void showMenu() {
  Serial.println("\n==== Vending Machine Menu ====");
  Serial.println("1. Coke");
  Serial.println("2. Pepsi");
  Serial.println("3. Tea");
  Serial.println("4. Coffee");
  Serial.print("Please select the preferred item: ");
}