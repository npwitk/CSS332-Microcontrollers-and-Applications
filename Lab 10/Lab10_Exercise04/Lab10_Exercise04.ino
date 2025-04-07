char input = 0; // Global to keep state across loops

void setup() {
  Serial.begin(9600);
  showMenu();
}

void loop() {
  if (Serial.available() > 0) {
    // Read characters until we get a valid (non-newline) one
    while (Serial.available() > 0) {
      char c = Serial.read();

      // Skip newline and carriage return
      if (c == '\n' || c == '\r') {
        continue;
      }

      // Found a valid character
      input = c;

      // Clear rest of the buffer (if any)
      while (Serial.available() > 0) {
        Serial.read();
      }

      // Now handle only if input is set
      if (input == '1') {
        Serial.println("I chose Coke");
        showMenu();
      } else if (input == '2') {
        Serial.println("I chose Pepsi");
        showMenu();
      } else if (input == '3') {
        Serial.println("I chose Tea");
        showMenu();
      } else if (input == '4') {
        Serial.println("I chose Coffee");
        showMenu();
      } else {
        Serial.println("Not in the list. Please select again: ");
        showMenu();
      }

      // Reset input after handling
      input = 0;
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
