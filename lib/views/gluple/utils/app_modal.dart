
class AppModel{


  static bool isLogin=false;
  static String token='';


  static bool setLoginToken(bool value)
  {
    isLogin=value;
    return isLogin;
  }
  static String setTokenValue(String value)
  {
    token=value;
    return token;
  }


}
