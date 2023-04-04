class PasswordValidator{
  static List<String> _upperChars = List.generate(26, (index) => String.fromCharCode(index+65));
  static List<String> _lowerChars =  List.generate(26, (index) => String.fromCharCode(index+65).toLowerCase());
  static bool _containsUpperChar(String password){
    bool result = false;
    _upperChars.forEach((char) {
      if(password.contains(char)){
        result = true;

      }
    });
    return result;
  }
  static bool _containsLowerChar(String password){
    bool result = false;
    _lowerChars.forEach((char) {
      if(password.contains(char)){
        result = true;

      }
    });
    return result;
  }
  static bool validate(String password){
    return password.length >= 6 && _containsUpperChar(password) && _containsLowerChar(password);
  }
}