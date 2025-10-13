class SizeConstants{
  SizeConstants._internal();

  static final SizeConstants _instance = SizeConstants._internal();

  factory SizeConstants() {
    return _instance;
  }
  ///main radius
  static const double fullBorderRadius=100;
  static const double outerBorderRadius=14;
  static const double innerBorderRadius=10;
  static const double smallBorderRadius=6;
  //used inside conatiners
  static const double smallInnerPadding=8;
  static const double meduimInnerPadding=12;
  static const double innerContainerPadding=16;


  ///used with .w or .h for spacing
  static const double baseHorizontalPadding=4;
  static const double baseVerticalPadding=4;

  static const double pageHorizontalPadding=16;

  static const double padding=20;
  static const double smallHorizontalPadding=5;

  ///between items of same section
  static const double verticalPadding=10;
  ///between two section
  static const double verticalPaddingTwenty=20;


  static const Duration mainDuration=Duration(seconds: 1);
  static const Duration slideDuration=Duration(milliseconds: 600);

  static const Duration mainDelayDuration=Duration(milliseconds: 400);
  static const Duration secondaryDuration=Duration(milliseconds: 400);
  static const Duration maxDelayDuration=Duration(milliseconds: 600);

  // width: 11.w,
  // height: 11.w,
  ///this is used with .w for height and width of image.
  static const int containerProfilePicture =13;

  static const int bigIconSize =19;
  static const int iconContainerBox =8;

}