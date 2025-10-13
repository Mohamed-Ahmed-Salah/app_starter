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
  await MyFirebaseMessagingService.initNotifications();
  final String organizationId = await sl<CacheService>().getOrganizationId();
  await FirebaseAnalyticsEngineService.to.init();
  await sl<FirebaseRemoteConfigService>().initialize(
    organizationId: organizationId,
  );

  await Future.wait([
    _controllersInit(),
    sl<ThemeConfigService>().initialize(),
    _employeesInit(),
    _profileInit(),
    _authInit(),
    _employeesAttendanceHistoryInit(),
  ]);

  UtilFunctions.appLog("✅ All Services initialized");
}

Future<void> _authInit() async {
  sl
    ..registerLazySingleton(() => RegisterUsecases(sl()))
    ..registerLazySingleton(() => LoginUsecases(sl()))
    ..registerLazySingleton<AuthRepo>(() => AuthRepoImpl(sl()))
    ..registerLazySingleton<AuthRemoteDataSrc>(
      () => AuthRemoteDataSrcImpl(sl()),
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
    ..registerLazySingleton(() => GetAllEmployeesUsecase(sl()))
    ..registerLazySingleton(() => SearchEmployeesUsecase(sl()))
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
    ..registerLazySingleton(() => GetProfileUsecase(sl()))
    ..registerLazySingleton<ProfileRepo>(() => ProfileRepoImpl(sl()))
    ..registerLazySingleton<ProfileRemoteDataSrc>(
      () => ProfileRemoteDataSrcImpl(sl()),
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

Future<void> _cacheInit() async {
  final prefs = await SharedPreferences.getInstance();

  sl
    ..registerLazySingleton(() => CacheService(sl()))
    ..registerLazySingleton<SharedPreferences>(() => prefs);
}
