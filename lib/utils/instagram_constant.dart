class InstagramConstant {
  static InstagramConstant? _instance;

  static InstagramConstant get instance {
    _instance ??= InstagramConstant._init();
    return _instance!;
  }

  InstagramConstant._init();

  static const String clientID = '749483436869266';
  static const String appSecret = 'cf0b2e50d04d0bc52b76b36cbf2526ed';
  static const String redirectUri = 'https://bondiomeet.com/coming-soon';
  static const String scope = 'user_profile,user_media';
  static const String responseType = 'code';
  final String url =
      'https://api.instagram.com/oauth/authorize?client_id=$clientID&redirect_uri=$redirectUri&scope=user_profile,user_media&response_type=$responseType';
}
