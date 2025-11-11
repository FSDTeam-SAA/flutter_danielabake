class AssetsConst {
  static Images get images => Images();
  static Videos get videos => Videos();
  static Icons get icons => Icons();
}

class Images {
  static const String _base = 'assets/images';

  final String azloLogoImage = "$_base/app_logo.png";
}

class Videos {
  static const String _base = 'assets/videos';
  final String awd = _base;
}

class Icons {
  static const String _base = 'assets/icons';
  final String awd = _base;
}
