import 'package:attendance/core/services/injection_container.dart';
import 'package:attendance/core/utils/util_functions.dart';
import 'package:attendance/core/widgets/protected_route_wrapper.dart';
import 'package:attendance/src/add_new_user_form/presentation/add_new_users.dart';
import 'package:attendance/src/ai_agent_chat/presentation/views/ai_chat_view.dart';
import 'package:attendance/src/attendance_locations/presentation/view/attendance_location_map.dart';
import 'package:attendance/src/auth/domain/entity/forgot_password_response.dart';
import 'package:attendance/src/auth/presentation/view/forgot_password_view.dart';
import 'package:attendance/src/auth/presentation/view/login_view.dart';
import 'package:attendance/src/auth/presentation/view/otp_view.dart';
import 'package:attendance/src/auth/presentation/view/reset_password_view.dart';
import 'package:attendance/src/auth/presentation/view/signup_view.dart';
import 'package:attendance/src/check_in_out/presentation/app/page_providers/face_overlay_position_provider.dart';
import 'package:attendance/src/check_in_out/presentation/view/check_in_out_view.dart';
import 'package:attendance/src/check_in_out/presentation/view/manual_checkin_form.dart';
import 'package:attendance/src/check_in_out/presentation/view/submit_picture_view.dart';
import 'package:attendance/src/employee_profile/presnetation/view/employee_profile.dart';
import 'package:attendance/src/clients_company_employees/presentation/view/clients_employees_view.dart';
import 'package:attendance/src/deraprtment_group/domain/entity/department_entity.dart';
import 'package:attendance/src/deraprtment_group/presentation/app/update_department_cubit/update_department_cubit.dart';
import 'package:attendance/src/deraprtment_group/presentation/views/departments_view.dart';
import 'package:attendance/src/deraprtment_group/presentation/views/new_department_form.dart';
import 'package:attendance/src/deraprtment_group/presentation/views/update_department_view.dart';
import 'package:attendance/src/employees_attendance/presentation/view/employees_attendance_view.dart';
import 'package:attendance/src/force_update/presentation/view/force_update_view.dart';
import 'package:attendance/src/home/presentation/view/bottom_navigation.dart';
import 'package:attendance/src/home/presentation/view/home_view.dart';
import 'package:attendance/src/home/presentation/view/overview_full_details.dart';
import 'package:attendance/src/justification_form/presentation/view/justification_form_view.dart';
import 'package:attendance/src/justifications_history/presentation/view/justification_history_view.dart';
import 'package:attendance/src/language/presentation/view/language_view.dart';
import 'package:attendance/src/leave_requests/presentation/view/leave_request_view.dart';
import 'package:attendance/src/new_request/presentation/view/new_request_view.dart';
import 'package:attendance/src/onboarding/presentation/view/onboarding_view.dart';
import 'package:attendance/src/payment_view/presentation/views/payment_view.dart';
import 'package:attendance/src/profile/domain/entity/user_profile_response.dart';
import 'package:attendance/src/profile/presentation/view/profile_view.dart';
import 'package:attendance/src/settings/presentation/view/settings_view.dart';
import 'package:attendance/src/splash/presentation/view/splash_view.dart';
import 'package:attendance/src/subscription/presentation/view/subscriptions_view.dart';
import 'package:attendance/src/supervirosrs_employees/presentation/view/supervisors_employees_view.dart';
import 'package:attendance/src/temp/presentation/view/location_map.dart';
import 'package:attendance/src/temp/presentation/view/temp_view.dart';
import 'package:attendance/src/update_profile/presentation/views/create_profile_view.dart';
import 'package:attendance/src/users_leaves_requests_history/presentation/view/UserLeavesHistory.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import '../../src/attendance_history/presentation/view/attendance_history_view.dart';
import '../../src/check_in_out/presentation/app/check_in_permission_cubit/check_in_permission_cubit.dart';
import '../../src/check_in_out/presentation/app/page_providers/camera_provider.dart';
import '../../src/check_in_out/presentation/app/page_providers/location_provider.dart';
import '../../src/employees_attendance/presentation/view/filter_employees_view.dart';
import '../../src/manual_attendance_request_history/presentation/view/manual_attendance_request_history_view.dart';

/// For routes that should NOT have the bottom nav bar
final _rootNavigatorKey = GlobalKey<NavigatorState>();

final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

GlobalKey<ScaffoldMessengerState> get scaffoldKey => _scaffoldKey;

final _shellNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  debugLogDiagnostics: true,
  navigatorKey: _rootNavigatorKey,
  initialLocation: SplashView.path,
  observers: [MyGoRouterObserver()],
  routes: [
    GoRoute(
      path: SplashView.path,
      name: SplashView.name,
      builder: (context, state) => const SplashView(),
    ),
    GoRoute(
      path: AppLanguageView.path,
      name: AppLanguageView.path,
      builder: (context, state) => const AppLanguageView(),
    ),

    GoRoute(
      path: OnBoardingView.path,
      name: OnBoardingView.name,
      builder: (context, state) => const OnBoardingView(),
    ),
    GoRoute(
      path: ForceUpdateView.path,
      name: ForceUpdateView.name,
      builder: (context, state) => const ForceUpdateView(),
    ),
    GoRoute(
      path: LoginView.path,
      name: LoginView.name,
      builder: (context, state) => const LoginView(),
    ),
    GoRoute(
      path: ForgotPasswordView.path,
      name: ForgotPasswordView.name,
      builder: (context, state) => const ForgotPasswordView(),
      routes: [
        GoRoute(
          path: OtpView.name,
          name: OtpView.name,
          builder: (context, state) => OtpView(
            forgotPasswordResponse: state.extra as ForgotPasswordResponse,
          ),
          routes: [
            GoRoute(
              path: ResetPasswordView.name,
              name: ResetPasswordView.name,
              builder: (context, state) =>
                  ResetPasswordView(resetToken: state.extra as String),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: SignupView.path,
      name: SignupView.name,
      builder: (context, state) => const SignupView(),
    ),
    GoRoute(
      path: TempView.path,
      name: TempView.name,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const TempView(),
      routes: [
        GoRoute(
          path: LocationPageView.name,
          name: LocationPageView.name,
          builder: (context, state) => const LocationPageView(),
        ),
      ],
    ),

    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainNavView(navigationShell: navigationShell);
      },
      branches: [
        // Home branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: HomeView.path,
              name: HomeView.name,
              builder: (context, state) => const HomeView(),
              routes: [
                GoRoute(
                  parentNavigatorKey: _rootNavigatorKey, // full screen
                  path: OverviewFullDetails.name,
                  name: OverviewFullDetails.name,
                  builder: (context, state) => const OverviewFullDetails(),
                ),
              ],
            ),
          ],
        ),

        // Supervisors Employees List
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: EmployeesAttendanceView.path,
              builder: (context, state) => const EmployeesAttendanceView(),
              routes: [
                GoRoute(
                  path: FilterEmployeesView.name,
                  name: FilterEmployeesView.name,
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const FilterEmployeesView(),
                ),
              ],
            ),
          ],
        ),

        // Leave Request branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: LeaveRequestView.path,
              name: LeaveRequestView.path,
              builder: (context, state) => const LeaveRequestView(),
            ),
          ],
        ),

        // Profile branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: ProfileView.path,
              name: ProfileView.name,
              builder: (context, state) => const ProfileView(),
              routes: [
                GoRoute(
                  path: AttendanceHistoryView.name,
                  name: AttendanceHistoryView.name,
                  parentNavigatorKey: _rootNavigatorKey, // full screen
                  builder: (context, state) {
                    final int id = state.extra as int;
                    return ProtectedRouteWrapper(
                      child: AttendanceHistoryView(id: id),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    ),

    GoRoute(
      path: AttendanceLocationMapView.name,
      name: AttendanceLocationMapView.name,
      builder: (context, state) => const AttendanceLocationMapView(),
    ),
    GoRoute(
      path: UserLeaveHistoryView.path,
      name: UserLeaveHistoryView.path,
      builder: (context, state) {
        final id = state.extra as int;
        return UserLeaveHistoryView(id: id);
      },
    ),

    GoRoute(
      path: SettingsView.path,
      name: SettingsView.name,
      parentNavigatorKey: _rootNavigatorKey, // full screen
      builder: (context, state) =>
          const ProtectedRouteWrapper(child: SettingsView()),
    ),

    GoRoute(
      path: UpdateProfileView.path,
      name: UpdateProfileView.name,
      parentNavigatorKey: _rootNavigatorKey, // full screen
      builder: (context, state) {
        UserProfileResponse profile = state.extra as UserProfileResponse;
        return UpdateProfileView(profile: profile);
      },
    ),

    GoRoute(
      path: NewRequestView.path,
      name: NewRequestView.name,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const NewRequestView(),
    ),
    GoRoute(
      path: SubscriptionPaymentView.path,
      name: SubscriptionPaymentView.path,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SubscriptionPaymentView(),
    ),
    GoRoute(
      path: CreateDepartmentPage.path,
      name: CreateDepartmentPage.path,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const CreateDepartmentPage(),
    ),
    GoRoute(
      path: UpdateDepartmentPage.path,
      name: UpdateDepartmentPage.path,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final department = state.extra as Department;

        ///here because we dont need it anywhere else.
        return BlocProvider(
          create: (context) => UpdateDepartmentCubit(
            department: department,
            updateDepartmentUsecase: sl(),
          ),
          child: UpdateDepartmentPage(department: department),
        );
      },
    ),
    GoRoute(
      path: DepartmentsListPage.path,
      name: DepartmentsListPage.path,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const DepartmentsListPage(),
    ),
    GoRoute(
      path: SubscriptionsView.path,
      name: SubscriptionsView.path,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SubscriptionsView(),
    ),

    GoRoute(
      path: CheckInOutView.name,
      name: CheckInOutView.name,
      builder: (context, state) {
        final cameras = state.extra as List<CameraDescription>;

        final FaceOverlayPositionProvider faceOverlayPositionProvider =
            FaceOverlayPositionProvider();
        final cameraProvider = CameraProvider(
          faceOverlayPositionProvider: faceOverlayPositionProvider,
        );
        final locationProvider = LocationProvider();

        ///used this way so when leaving the page its disposed.
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => faceOverlayPositionProvider),
            ChangeNotifierProvider(create: (_) => cameraProvider),
            ChangeNotifierProvider(create: (_) => locationProvider),
            BlocProvider(
              create: (_) => CheckInPermissionCubit(
                cameraProvider: cameraProvider,
                locationProvider: locationProvider,
              ),
            ),
          ],
          child: CheckInOutView(cameras: cameras),
        );
      },
      routes: [
        GoRoute(
          path: SubmitPictureView.name,
          name: SubmitPictureView.name,
          builder: (context, state) {
            final params = state.extra as Map<String, dynamic>;
            return SubmitPictureView(
              picturePath: params[SubmitPictureView.pictureParam] as String,
              currentLocation:
                  params[SubmitPictureView.currentLocationParam]
                      as LocationData,
              facesDetected:
                  params[SubmitPictureView.facesDetectedParam] as int,
              location: params[SubmitPictureView.locationParam] as String,
              timestamp: params[SubmitPictureView.timestampParam] as DateTime,
              isMocked: params[SubmitPictureView.isMockedParam] as bool,
              isAlreadyCheckedIn:
                  params[SubmitPictureView.isAlreadyCheckedInParam] as bool,
            );
          },
        ),
      ],
    ),

    GoRoute(
      path: JustificationFormView.path,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const JustificationFormView(),
    ),
    GoRoute(
      path: ChatScreen.path,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ChatScreen(),
    ),
    GoRoute(
      path: ManualCheckInFormView.path,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ManualCheckInFormView(),
    ),
    GoRoute(
      path: JustificationHistoryView.path,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const JustificationHistoryView(),
    ),
    GoRoute(
      path: ManualAttendanceRequestHistoryView.path,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ManualAttendanceRequestHistoryView(),
    ),
    GoRoute(
      path: ClientsEmployeesView.path,
      name: ClientsEmployeesView.path,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ClientsEmployeesView(),
      routes: [
        GoRoute(
          path: EmployeeProfileView.clientName,
          name: EmployeeProfileView.clientName,
          parentNavigatorKey: _rootNavigatorKey,

          builder: (context, state) {
            final id = state.extra as int;
            // final Employee employee =
            //     params[EmployeeProfileView.employeeParam] as Employee;
            return EmployeeProfileView(id: id);
          },
        ),
        GoRoute(
          path: AddNewUserFormView.name,
          name: AddNewUserFormView.name,
          parentNavigatorKey: _rootNavigatorKey,

          builder: (context, state) {
            final Map<String, dynamic> extra =
                state.extra as Map<String, dynamic>;

            return AddNewUserFormView();
          },
        ),
      ],
    ),
    GoRoute(
      path: SupervisorsEmployeesView.path,
      name: SupervisorsEmployeesView.path,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final int departmentId = state.extra as int;
        return SupervisorsEmployeesView(departmentId: departmentId);
      },
      routes: [
        // GoRoute(
        //   path: EmployeeProfileView.supervisorsName,
        //   name: EmployeeProfileView.supervisorsName,
        //   parentNavigatorKey: _rootNavigatorKey,
        //
        //   builder: (context, state) {
        //     final id = state.extra as int;
        //     return EmployeeProfileView(id: id);
        //   },
        // ),
      ],
    ),
  ],
);

class MyGoRouterObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    UtilFunctions.appLog('PUSHED route: ${route.settings.name}');
    UtilFunctions.appLog('Previous route: ${previousRoute?.settings.name}');
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    UtilFunctions.appLog('POPPED route: ${route.settings.name}');
    UtilFunctions.appLog('Back to route: ${previousRoute?.settings.name}');
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
    UtilFunctions.appLog('REMOVED route: ${route.settings.name}');
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    UtilFunctions.appLog(
      'REPLACED ${oldRoute?.settings.name} with ${newRoute?.settings.name}',
    );
  }
}
