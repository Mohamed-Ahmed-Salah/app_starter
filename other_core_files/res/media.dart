import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

abstract class Media {
  static const _baseImage = 'assets/img';
  static const _baseSvg = 'assets/svg';
  static const _baseLottie = 'assets/lottie';

  static const logo = '$_baseImage/logo.png';

  static const locationLottie = '$_baseLottie/location_maps.json';
  static const notificationLottie = '$_baseLottie/notification.json';
  static const translateLottie = '$_baseLottie/translate2.json';
  static const selfieLottie = '$_baseLottie/selfie.json';
  static const calenderLoaderLottie = '$_baseLottie/calender_loader.json';
  static const aiLogoLottie = '$_baseLottie/ai_logo.json';

  static const docSvg = '$_baseSvg/doc.svg';
  static const pdfSvg = '$_baseSvg/pdf.svg';
  static const excelSvg = '$_baseSvg/excel.svg';
  static const pngSvg = '$_baseSvg/png.svg';

  static const visibleIcon = Icons.visibility;
  static const visibleOffIcon = Icons.visibility_off;
  static const lockIcon = Icons.lock;
  static const emailIcon = Icons.alternate_email;
  static const profileIcon = Icons.account_circle_sharp;
  static const personOutlineIcon = Icons.person_outline;
  static const circleSuccessIcon = Icons.check_circle;
  static const circleFailedIcon = Icons.cancel;
  static const scanQrIcon = Icons.qr_code_scanner;
  static const folderIcon = CupertinoIcons.folder_open;
  static const downloadIcon = Icons.file_download_outlined;
  static const saveIcon = Icons.save;
  static const deleteIcon = Icons.delete;
  static const checkInIcon = Icons.login;
  static const checkOutIcon = Icons.logout;

  // static const breakIcon=Icons.coffee;
  static const breakIcon = Icons.coffee;

  // static const notificationsIcon=Icons.notifications;
  static const faceIcon = Icons.face;
  static const locationIcon = Icons.location_on;
  static const locationOutlineIcon = Icons.location_on_outlined;
  static const myLocationIcon = Icons.my_location;
  static const navigateToLocationIcon = Icons.north_west;
  static const clockIcon = Icons.access_time;
  static const calendarIcon = Icons.calendar_today_outlined;
  static const calendarEventIcon = Icons.event_outlined;
  static const calendarTodayIcon = Icons.today_outlined;
  static const backIcon = Icons.arrow_back_ios_rounded;

  // static const back2Icon = Icons.arrow_back_ios_sharp;
  static const forwardIcon = Icons.arrow_forward_ios;
  static const moneyIcon = Icons.attach_money;
  static const arrowDownIcon = Icons.keyboard_arrow_down;
  static const documentIcon = Icons.description_outlined;
  static const settingsIcon = Icons.settings;
  static const categoryIcon = Icons.category_outlined;
  static const chatIcon = Icons.comment_outlined;
  static const addIcon = Icons.add;
  static const closeIcon = Icons.close;
  static const checkIcon = Icons.check;
  static const checkCircleIcon = Icons.check_circle;

  static const closeCircleIcon = Icons.cancel;

  ///sick attendance color
  static const heartPulseIcon = FontAwesomeIcons.heartPulse;

  // Profile Icons
  static const IconData personIcon = Icons.person;
  static const IconData editIcon = Icons.edit_outlined;

  // Account & Security Icons
  static const IconData faceIdIcon = Icons.fingerprint;

  // static const IconData faceScanIcon = FontAwesomeIcons.usersViewfinder;

  // App Preferences Icons
  static const IconData languageIcon = Icons.translate_rounded;
  static const IconData notificationIcon = Icons.notifications_none_rounded;
  static const IconData cameraIcon = Icons.camera_alt_outlined;

  // Support & About Icons
  static const IconData helpIcon = Icons.help_outline;
  static const IconData supportIcon = Icons.support_agent;
  static const IconData infoIcon = Icons.info_outline;
  static const IconData errorWarningIcon = Icons.warning_amber_rounded;

  // Action Icons
  static const IconData logoutIcon = Icons.logout;
  static const IconData phoneIcon = Icons.phone_outlined;

  ///to recheck
  static const IconData searchIcon = Icons.search;
  static const IconData emptyStateIcon = Icons.people_outline;
  static const IconData usersGroupIcon = Icons.people;
  static const IconData supervisorsIcon = Icons.supervisor_account;
  static const IconData employeeIcon = Icons.assignment_ind_outlined;

  static const IconData attendanceIcon = Icons.checklist_outlined;
  static const IconData leaveRequestIcon = Icons.time_to_leave_outlined;
  static const IconData menuIcon = Icons.menu;
  static const IconData sunIcon = Icons.wb_sunny;
  static const IconData attachFileIcon = Icons.attach_file;
  static const IconData filterIcon = Icons.filter_list_rounded;
  static const IconData trendingUpIcon = Icons.trending_up;
  static const IconData trendingDownIcon = Icons.trending_down;
  static const IconData sendIcon = CupertinoIcons.paperplane;
  static const IconData aiIcon = Icons.auto_awesome;
  static const IconData copyIcon = Icons.copy;
  static const IconData refreshIcon = Icons.refresh;
  static const IconData subscribeIcon = Icons.rocket_launch_outlined;
  static const IconData departmentIcon = Icons.business;

  // Add these to your existing assets
  static const String aliceImage =
      'https://i.pinimg.com/736x/f6/61/ea/f661ea61616909838a9fbfeda0d2ea14.jpg';
  static const String bobImage =
      'https://i.pinimg.com/736x/97/00/19/9700195ee1212e3be61c0294fdc80a0a.jpg';
  static const String charlieImage =
      'https://i.pinimg.com/736x/d1/81/e4/d181e44cf0a7d5f9190bc96939da4164.jpg';
  static const String dianaImage =
      'https://i.pinimg.com/736x/0e/bd/b9/0ebdb9f8cb628dc5224bd2f84a2ff9e2.jpg';
}
