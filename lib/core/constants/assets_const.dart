class AssetsConst {
  static Images get images => Images();
  static Videos get videos => Videos();
  static Icons get icons => Icons();
}

class Images {
  static const String _base = 'assets/images';
  static const String _base1 = 'assets/icons';

  //Images
  final  String azloLogoImage = "$_base/app_logo.png";
  static const String background = '$_base/img4.png';
  static const String cookie1 = '$_base/img3.jpg';
  static const String cookie2 = '$_base/image2.jpg';
  static const String cookie3 = '$_base/image1.jpg';
  static const String discount = '$_base/discount.png';
  static const String profile1 = '$_base/profile.jpg';
  static const String food = '$_base/food.png';

  //Icons
  static const String search = '$_base1/search.svg';
  static const String cart = '$_base1/cart.svg';
  static const String home = '$_base1/home.svg';
  static const String order = '$_base1/order.svg';
  static const String chat = '$_base1/chat.svg';
  static const String profile = '$_base1/profile.svg';
  static const String favorite = '$_base1/heart.svg';
  static const String orders = '$_base1/orders.svg';
  static const String settings = '$_base1/settings.svg';
  static const String logout = '$_base1/logout.svg';
  static const String arrow = '$_base1/Icon.svg';
  static const String address = '$_base1/address.svg';
  static const String phone = '$_base1/phone.svg';
  static const String delivery = '$_base1/delivery.svg';
}

class Videos {
  static const String _base = 'assets/videos';
  final String awd = _base;
}

class Icons {
  static const String _base = 'assets/icons';
  final String awd = _base;
}
