a = arduino('/dev/tty.usbmodem1411','uno');

RELAY1 = 7;
RELAY2 = 6;
RELAY3 = 5;
RELAY4 = 4;
RELAY5 = 3;
RELAY6 = 2;
RELAY7 = 8;
RELAY8 = 9;

      writeDigitalPin(a, RELAY8, 0);
      pause(2);
