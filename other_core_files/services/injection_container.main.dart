part of 'injection_container.dart';

final sl = GetIt.instance;

///todo seperate app start init and other services in splash.
Future<void> init() async {
  UtilFunctions.appLog("🚀 Starting of something great!");

  ///here we inject services and initialise our app...
  ///we need to inject cache first because its used and will give error if we inject with other services
  await Future.wait([_cacheInit(), initializeFirebaseApp()]);

  await Future.wait([_getMinVersionInit(), _coreServicesInit()]);
  UtilFunctions.appLog("✅ All Main Services initialized");
}

Future<void> splashInit() async {
  // await MyFirebaseMessagingService.initNotifications();
  final String organizationId = await sl<CacheService>().getOrganizationId();
  // await FirebaseAnalyticsEngineService.to.init();
  // await sl<FirebaseRemoteConfigService>().initialize(
  //   organizationId: organizationId,
  // );

  await Future.wait([
    MyFirebaseMessagingService.initNotifications(),
    FirebaseAnalyticsEngineService.to.init(),
    sl<FirebaseRemoteConfigService>().initialize(
      organizationId: organizationId,
    ),
  ]);
  await Future.wait([
    _controllersInit(),
    sl<ThemeConfigService>().initialize(),
    _employeesInit(),
    _profileInit(),
    _authInit(),
    _leavesInit(),
    _aiChatInit(),
    _attendanceLocationsInit(),
    _departmentsInit(),
    _roleManagementInit(),
    _userManagementInit(),
    _justificationInit(),
    _employeesAttendanceHistoryInit(),
    _attendanceHistoryInit(),
    _checkInInit(),
    _activityInit(),
  ]);

  UtilFunctions.appLog("✅ All Services initialized");
}

Future<void> _authInit() async {
  sl
    // Auth Event Handler Service (requires CacheService)
    ..registerLazySingleton<AuthEventHandlerService>(
      () => AuthEventHandlerService(cacheService: sl()),
    )
    // Use Cases
    ..registerLazySingleton(() => SetNewPasswordUsecase(sl()))
    ..registerLazySingleton(() => VerifyOtpUsecase(sl()))
    ..registerLazySingleton(() => ForgetPasswordUsecase(sl()))
    ..registerLazySingleton(() => RegisterUsecases(sl()))
    ..registerLazySingleton(() => LoginUsecases(sl()))
    // Repository
    ..registerLazySingleton<AuthRepo>(() => AuthRepoImpl(sl()))
    // Data Source
    ..registerLazySingleton<AuthRemoteDataSrc>(
      () => AuthRemoteDataSrcImpl(sl()),
    );

  // Initialize singleton instance for global access
  AuthEventHandlerService.instance = sl<AuthEventHandlerService>();
}

Future<void> _aiChatInit() async {
  sl
    ..registerLazySingleton(() => SendMessageUsecases(sl()))
    ..registerLazySingleton<ChatRepo>(() => ChatRepoImpl(sl()))
    ..registerLazySingleton<ChatRemoteDataSrc>(
      () => ChatRemoteDataSrcImpl(sl()),
    );
}

Future<void> _getMinVersionInit() async {
  sl
    ..registerLazySingleton(() => GetMinVersionUsecases(sl()))
    ..registerLazySingleton<MinVersionRepo>(() => MinVersionRepoImpl(sl()))
    ..registerLazySingleton<MinVersionRemoteDataSrc>(
      () => MinVersionRemoteDataSrcImpl(sl()),
    )
    ..registerSingleton(Dio());
}

Future<void> _coreServicesInit() async {
  sl
    ..registerLazySingleton(() => FirebaseRemoteConfigService())
    ..registerLazySingleton(() => HiveDataService())
    ..registerLazySingleton(
      () => ThemeConfigService(hiveDataService: sl(), cacheService: sl()),
    );
  await sl<HiveDataService>().initialize();
}

Future<void> _controllersInit() async {
  sl
    ..registerSingleton<BiometricAuthController>(BiometricAuthController())
    ..registerSingleton<SecurityHandlerController>(
      SecurityHandlerController(sl()),
    );
}

Future<void> _employeesInit() async {
  sl
    ..registerLazySingleton(() => GetEmployeeDocumentsUsecase(sl()))
    ..registerLazySingleton(() => GetAllEmployeesUsecase(sl()))
    // ..registerLazySingleton(() => SearchEmployeesUsecase(sl()))
    ..registerLazySingleton(() => GetAllEmployeeByDepartmentIdsUsecase(sl()))
    // ..registerLazySingleton(() => SearchEmployeesInDepartmentUsecase(sl()))
    ..registerLazySingleton(() => GetEmployeeByIdUsecase(sl()))
    ..registerLazySingleton<EmployeeRepository>(
      () => EmployeeRepositoryImpl(sl()),
    )
    ..registerLazySingleton<EmployeeRemoteDataSrc>(
      () => EmployeeRemoteDataSrcImpl(sl()),
    );
}

Future<void> _profileInit() async {
  sl
    ..registerLazySingleton<ProfileCubit>(
      () => ProfileCubit(
        getProfileUsecase: sl(),
        getProfileDocumentsUsecase: sl(),
      ),
    )
    ..registerLazySingleton(() => GetProfileDocumentsUsecase(sl()))
    ..registerLazySingleton(() => CreateProfileUsecase(sl()))
    ..registerLazySingleton(() => UpdateAvatarUsecase(sl()))
    ..registerLazySingleton(() => GetProfileUsecase(sl()))
    ..registerLazySingleton(() => GetUserMeUsecase(sl()))
    ..registerLazySingleton<ProfileRepo>(() => ProfileRepoImpl(sl()))
    ..registerLazySingleton<ProfileRemoteDataSrc>(
      () => ProfileRemoteDataSrcImpl(sl()),
    );
}

Future<void> _leavesInit() async {
  sl
    ..registerLazySingleton(() => GetLeaveTypesUsecase(sl()))
    ..registerLazySingleton(() => NewLeaveRequestUsecase(sl()))
    ..registerLazySingleton(() => UpdateLeaveStatusUsecase(sl()))
    ..registerLazySingleton(() => GetLeaveRequestsUsecase(sl()))
    ..registerLazySingleton(() => GetLeaveRequestsByUserIdUsecase(sl()))
    ..registerLazySingleton(() => GetLeaveByIdUsecase(sl()))
    ..registerLazySingleton(() => GetLeaveBalancesUsecase(sl()))
    ..registerLazySingleton<LeaveRepository>(() => LeaveRepoImpl(sl()))
    ..registerLazySingleton<LeaveRemoteDataSrc>(
      () => LeaveRemoteDataSrcImpl(sl()),
    );
}

Future<void> _employeesAttendanceHistoryInit() async {
  sl
    ..registerLazySingleton(() => GetEmployeesAttendanceUsecase(sl()))
    ..registerLazySingleton<EmployeesAttendanceRepo>(
      () => EmployeesAttendanceRepoImpl(sl()),
    )
    ..registerLazySingleton(() => EmployeeFiltersCubit())
    ..registerLazySingleton<EmployeesAttendanceRemoteDataSrc>(
      () => EmployeesAttendanceRemoteDataSrcImpl(sl()),
    );
}

Future<void> _attendanceHistoryInit() async {
  sl
    // Use Cases
    ..registerLazySingleton(() => GetAllAttendanceHistoryUsecase(sl()))
    ..registerLazySingleton(() => GetUserAttendanceHistoryUsecase(sl()))
    // Repository
    ..registerLazySingleton<AttendanceHistoryRepo>(
      () => AttendanceHistoryRepoImpl(sl()),
    )
    // Data Source
    ..registerLazySingleton<AttendanceHistoryRemoteDataSrc>(
      () => AttendanceHistoryRemoteDataSrcImpl(sl()),
    );
}

Future<void> _attendanceLocationsInit() async {
  sl
    ..registerLazySingleton(
      () => GetAllLocationsCubit(getAllLocationsUsecase: sl()),
    )
    ..registerLazySingleton(
      () => CreateLocationCubit(createLocationUsecase: sl()),
    )
    ..registerLazySingleton(
      () => DeleteLocationCubit(deleteLocationUsecase: sl()),
    )
    ..registerLazySingleton(
      () => UpdateLocationCubit(updateLocationUsecase: sl()),
    )
    ..registerLazySingleton(() => GetAllLocationsUsecase(sl()))
    ..registerLazySingleton(() => GetAllLocationsForDropdownUsecase(sl()))
    ..registerLazySingleton(() => CreateLocationUsecase(sl()))
    ..registerLazySingleton(() => UpdateLocationUsecase(sl()))
    ..registerLazySingleton(() => DeleteLocationUsecase(sl()))
    ..registerLazySingleton<AttendanceLocationRepo>(
      () => AttendanceLocationRepoImpl(sl()),
    )
    ..registerLazySingleton<AttendanceLocationRemoteDataSrc>(
      () => AttendanceLocationRemoteDataSrcImpl(sl()),
    );
}

Future<void> _departmentsInit() async {
  sl
    // Use Cases
    ..registerLazySingleton(() => GetAllDepartmentsUsecase(sl()))
    ..registerLazySingleton(() => GetAllDepartmentsForDropdownUsecase(sl()))
    ..registerLazySingleton(() => CreateDepartmentUsecase(sl()))
    ..registerLazySingleton(() => UpdateDepartmentUsecase(sl()))
    ..registerLazySingleton(() => DeleteDepartmentUsecase(sl()))
    // Repository
    ..registerLazySingleton<DepartmentRepo>(() => DepartmentRepoImpl(sl()))
    // Data Source
    ..registerLazySingleton<DepartmentRemoteDataSrc>(
      () => DepartmentRemoteDataSrcImpl(sl()),
    );
}

Future<void> _justificationInit() async {
  sl
    // Use Case
    ..registerLazySingleton(() => SubmitJustificationUsecase(sl()))
    // Repository
    ..registerLazySingleton<JustificationRepo>(
      () => JustificationRepoImpl(sl()),
    )
    // Data Source
    ..registerLazySingleton<JustificationRemoteDataSrc>(
      () => JustificationRemoteDataSrcImpl(sl()),
    );
}

Future<void> _checkInInit() async {
  sl
    // Use Cases
    ..registerLazySingleton(() => CheckInUsecase(sl()))
    ..registerLazySingleton(() => CheckOutUsecase(sl()))
    ..registerLazySingleton(() => GetTodayStatusUsecase(sl()))
    ..registerLazySingleton(() => BreakStartUsecase(sl()))
    ..registerLazySingleton(() => BreakEndUsecase(sl()))
    // Repository
    ..registerLazySingleton<CheckInRepo>(() => CheckInRepoImpl(sl()))
    // Data Source
    ..registerLazySingleton<CheckInRemoteDataSrc>(
      () => CheckInRemoteDataSrcImpl(sl()),
    );
}

Future<void> _roleManagementInit() async {
  sl
    // Use Cases
    ..registerLazySingleton(() => GetAllRolesForDropdownUsecase(sl()))
    // Repository
    ..registerLazySingleton<RoleRepo>(() => RoleRepoImpl(sl()))
    // Data Source
    ..registerLazySingleton<RoleRemoteDataSrc>(
      () => RoleRemoteDataSrcImpl(sl()),
    );
}

Future<void> _userManagementInit() async {
  sl
    // Use Cases
    ..registerLazySingleton(() => CreateUserUsecase(sl()))
    // Repository
    ..registerLazySingleton<UserManagementRepo>(
      () => UserManagementRepoImpl(sl()),
    )
    // Data Source
    ..registerLazySingleton<UserManagementRemoteDataSrc>(
      () => UserManagementRemoteDataSrcImpl(sl()),
    );
}

Future<void> _activityInit() async {
  sl
    // Use Cases
    ..registerLazySingleton(() => GetAttendanceHistoryUsecase(sl()))
    // Repository
    ..registerLazySingleton<ActivityRepo>(() => ActivityRepoImpl(sl()))
    // Data Source
    ..registerLazySingleton<ActivityRemoteDataSrc>(
      () => ActivityRemoteDataSrcImpl(sl()),
    );
}

Future<void> _cacheInit() async {
  final prefs = await SharedPreferences.getInstance();

  sl
    ..registerLazySingleton(() => CacheService(sl()))
    ..registerLazySingleton<SharedPreferences>(() => prefs);
}
