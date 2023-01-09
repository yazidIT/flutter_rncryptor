class RNCryptorSettings {

  int pbkdf2Iterations;

  RNCryptorSettings({this.pbkdf2Iterations = 1000});

  static final saltLength = 8;
  static final ivLength = 16;
  static final keyLength = 32;
  static final hmacLength = 32;
  static final version = 3;
}
