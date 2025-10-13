import 'package:attendance/core/utils/util_functions.dart';
import 'package:attendance/core/widgets/protected_route_wrapper.dart';
import 'package:attendance/src/add_new_user_form/presentation/add_new_users.dart';
import 'package:attendance/src/ai_agent_chat/presentation/views/ai_chat_view.dart';
import 'package:attendance/src/attendance_locations/presentation/view/attendance_location_map.dart';
import 'package:attendance/src/attendance_locations/presentation/view/users_locations_attendance.dart';
import 'package:attendance/src/auth/presentation/view/forgot_password_view.dart';
import 'package:attendance/src/auth/presentation/view/login_view.dart';
import 'package:attendance/src/auth/presentation/view/otp_view.dart';
import 'package:attendance/src/auth/presentation/view/reset_password_view.dart';
import 'package:attendance/src/auth/presentation/view/signup_view.dart';
import 'package:attendance/src/check_in/presentation/app/page_providers/face_overlay_position_provider.dart';
import 'package:attendance/src/check_in/presentation/view/check_in_view.dart';
import 'package:attendance/src/check_in/presentation/view/manual_checkin_form.dart';
import 'package:attendance/src/check_in/presentation/view/submit_picture_view.dart';
import 'package:attendance/src/deraprtment_group/domain/entity/department_entity.dart';
import 'package:attendance/src/deraprtment_group/presentation/app/cubit/update_department_cubit.dart';
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
import 'package:attendance/src/profile/presentation/view/profile_view.dart';
import 'package:attendance/src/settings/presentation/view/settings_view.dart';
import 'package:attendance/src/splash/presentation/view/splash_view.dart';
import 'package:attendance/src/subscription/presentation/view/subscriptions_view.dart';
import 'package:attendance/src/supervisors_employees/domain/entity/employee.dart';
import 'package:attendance/src/supervisors_employees/presentation/view/employee_profile.dart';
import 'package:attendance/src/supervisors_employees/presentation/view/supervisors_employees_view.dart';
import 'package:attendance/src/temp/presentation/view/location_map.dart';
import 'package:attendance/src/temp/presentation/view/temp_view.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../src/attendance_history/presentation/view/attendance_history_view.dart';
import '../../src/check_in/presentation/app/page_providers/camera_provider.dart';
import '../../src/check_in/presentation/app/page_providers/location_provider.dart';
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
          builder: (context, state) => const OtpView(),
          routes: [
            GoRoute(
              path: ResetPasswordView.name,
              name: ResetPasswordView.name,
              builder: (context, state) => const ResetPasswordView(),
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
                    final String id = state.extra as String;
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
      routes: [
        GoRoute(
          path: UsersAttendanceLocationView.name,
          name: UsersAttendanceLocationView.name,
          builder: (context, state) {
            final int id = state.extra as int;
            return UsersAttendanceLocationView(locationId: id);
          },
        ),
      ],
    ),

    GoRoute(
      path: SettingsView.path,
      name: SettingsView.name,
      parentNavigatorKey: _rootNavigatorKey, // full screen
      builder: (context, state) =>
          const ProtectedRouteWrapper(child: SettingsView()),
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

        ///here because we dont need it.
        return BlocProvider(
          create: (context) => UpdateDepartmentCubit(department),
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
      path: FaceScannerScreen.name,
      name: FaceScannerScreen.name,
      builder: (context, state) {
        final cameras = state.extra as List<CameraDescription>;

        final FaceOverlayPositionProvider faceOverlayPositionProvider =
            FaceOverlayPositionProvider();
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => faceOverlayPositionProvider),
            ChangeNotifierProvider(
              create: (_) => CameraProvider(
                faceOverlayPositionProvider: faceOverlayPositionProvider,
              ),
            ),
            ChangeNotifierProvider(create: (_) => LocationProvider()),
          ],
          child: FaceScannerScreen(cameras: cameras),
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
              facesDetected:
                  params[SubmitPictureView.facesDetectedParam] as int,
              location: params[SubmitPictureView.locationParam] as String,
              timestamp: params[SubmitPictureView.timestampParam] as DateTime,
              startCameraStreamFunction:
                  params[SubmitPictureView.startCameraStreamFunctionParam],
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
      path: SupervisorsEmployeesView.path,
      name: SupervisorsEmployeesView.path,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SupervisorsEmployeesView(),
      routes: [
        GoRoute(
          path: EmployeeProfileView.name,
          name: EmployeeProfileView.name,
          parentNavigatorKey: _rootNavigatorKey,

          builder: (context, state) {
            final id = state.extra as String;
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

            final bool isAdmin =
                extra[AddNewUserFormView.isAdminExtraParam] as bool;
            final Employee? employee =
                extra[AddNewUserFormView.employeeExtraParam] as Employee?;
            // final Employee employee =
            //     params[EmployeeProfileView.employeeParam] as Employee;
            return AddNewUserFormView(isAdmin: isAdmin, employee: employee);
          },
        ),
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
