# Flutter Clean Architecture Guidelines for AI Assistants

## 📋 Overview
This document provides comprehensive guidelines for creating new features, screens, and functionality in this Flutter application. Follow these rules strictly to maintain consistency and architectural integrity.

---

## 🏗️ Architecture Pattern

This project follows **Clean Architecture** with the following layers:

```
lib/src/[feature_name]/
├── data/
│   ├── datasource/
│   │   └── [feature]_remote_datasource.dart
│   ├── models/
│   │   └── [model_name]_model.dart
│   └── repo/
│       └── [feature]_repo_impl.dart
├── domain/
│   ├── entity/
│   │   └── [entity_name].dart
│   ├── repo/
│   │   └── [feature]_repo.dart
│   └── usecases/
│       └── [action]_usecase.dart
└── presentation/
    ├── app/
    │   └── [feature]_cubit/
    │       ├── [feature]_cubit.dart
    │       ├── [feature]_cubit.freezed.dart
    │       └── [feature]_state.dart
    ├── view/
    │   └── [feature]_view.dart
    └── widgets/
        └── [widget_name].dart
```

---

## 🎯 Core Principles

### 1. **Dependency Rule**
- Data layer depends on Domain
- Presentation layer depends on Domain
- Domain layer is independent (no dependencies on other layers)
- Dependencies flow inward toward Domain

### 2. **Single Responsibility**
- Each class/file has one clear responsibility
- Entities contain business logic
- Models handle data transformation
- UseCases encapsulate single actions
- Cubits manage UI state

### 3. **Separation of Concerns**
- UI logic in Presentation layer
- Business logic in Domain layer
- Data handling in Data layer

---

## 📁 Layer-by-Layer Guidelines

### **DOMAIN LAYER** (Core Business Logic)

#### **Entities** (`domain/entity/`)
- Pure Dart classes representing business objects
- No dependencies on Flutter or external packages (except dart:ui for Color)
- Include business logic methods (e.g., calculated properties, validation)
- Use `copyWith` method for immutability
- Add extension methods for display logic

**Example:**
```dart
// domain/entity/leave_request.dart
class LeaveRequest {
  final String id;
  final String employeeName;
  final DateTime leaveFrom;
  final DateTime leaveTo;
  final RequestStatus status;

  LeaveRequest({
    required this.id,
    required this.employeeName,
    required this.leaveFrom,
    required this.leaveTo,
    required this.status,
  });

  // Business logic
  int get totalDays => leaveTo.difference(leaveFrom).inDays + 1;

  // Immutability
  LeaveRequest copyWith({
    String? id,
    String? employeeName,
    DateTime? leaveFrom,
    DateTime? leaveTo,
    RequestStatus? status,
  }) {
    return LeaveRequest(
      id: id ?? this.id,
      employeeName: employeeName ?? this.employeeName,
      leaveFrom: leaveFrom ?? this.leaveFrom,
      leaveTo: leaveTo ?? this.leaveTo,
      status: status ?? this.status,
    );
  }
}
```

#### **Repositories** (`domain/repo/`)
- Abstract classes defining contracts
- Use `ResultFuture<T>` return type (from `core/config/typedefs.dart`)
- Method names should be clear and action-oriented

**Example:**
```dart
// domain/repo/leave_request_repo.dart
import 'package:attendance/core/config/typedefs.dart';
import '../entity/leave_request.dart';

abstract class LeaveRepository {
  ResultFuture<List<LeaveRequest>> getLeaveRequests(String status);
  ResultFuture<LeaveRequest> createLeaveRequest(NewLeaveRequest request);
  ResultFuture<void> updateLeaveStatus(String id, String status);
}
```

**Note:** `ResultFuture<T>` = `Future<Either<Failure, T>>` (using dartz package)

#### **UseCases** (`domain/usecases/`)
- One UseCase per action
- Encapsulate single business operations
- Depend on repository abstractions
- Named as verbs (e.g., `GetLeaveRequestsUsecase`, `UpdateLeaveStatusUsecase`)

**Example:**
```dart
// domain/usecases/get_leave_request.dart
import 'package:attendance/core/config/typedefs.dart';
import '../entity/leave_request.dart';
import '../repo/leave_request_repo.dart';

class GetLeaveRequestsUsecase {
  final LeaveRepository _repository;

  GetLeaveRequestsUsecase(this._repository);

  ResultFuture<List<LeaveRequest>> call(String status) {
    return _repository.getLeaveRequests(status);
  }
}
```

---

### **DATA LAYER** (External Data Handling)

#### **Models** (`data/models/`)
- Extend or implement corresponding entities
- Handle JSON serialization/deserialization
- Include `fromJson` and `toJson` methods
- Transform API data to domain entities

**Example:**
```dart
// data/models/leave_request_model.dart
import '../../domain/entity/leave_request.dart';

class LeaveRequestModel extends LeaveRequest {
  LeaveRequestModel({
    required super.id,
    required super.employeeName,
    required super.leaveFrom,
    required super.leaveTo,
    required super.status,
  });

  factory LeaveRequestModel.fromJson(Map<String, dynamic> json) {
    return LeaveRequestModel(
      id: json['id'],
      employeeName: json['employee_name'],
      leaveFrom: DateTime.parse(json['leave_from']),
      leaveTo: DateTime.parse(json['leave_to']),
      status: RequestStatus.values.byName(json['status']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employee_name': employeeName,
      'leave_from': leaveFrom.toIso8601String(),
      'leave_to': leaveTo.toIso8601String(),
      'status': status.name,
    };
  }
}
```

#### **Data Sources** (`data/datasource/`)
- Define abstract class first, then implementation
- Implementation class uses mixins: `with NetworkCallHandler`
- Use Dio for HTTP requests
- Handle API calls using `handleNetworkCall<T>` helper
- Get headers using `NetworkConstants.getHeadersWithAuth()` or `NetworkConstants.getHeaders()`
- API base URL: `NetworkConstants.url`

**Example:**
```dart
// data/datasource/leave_remote_datasource.dart
import 'package:attendance/core/config/mixins/network_handler.dart';
import 'package:attendance/core/constants/network_constants.dart';
import 'package:dio/dio.dart';
import '../../domain/entity/leave_request.dart';

class LeaveRemoteDataSrcImpl
    with NetworkCallHandler
    implements LeaveRemoteDataSrc {
  const LeaveRemoteDataSrcImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<LeaveRequest>> getLeaveRequests(String status) async {
    final header = await NetworkConstants.getHeadersWithAuth();

    return handleNetworkCall<List<LeaveRequest>>(
      call: () => _dio.get(
        '${NetworkConstants.url}/leave/requests?status=$status',
        options: Options(headers: header),
      ),
      onSuccess: (response) {
        // Parse response data
        final List data = response.data[NetworkConstants.dataParam];
        return data.map((json) => LeaveRequestModel.fromJson(json)).toList();
      },
    );
  }
}

abstract class LeaveRemoteDataSrc {
  const LeaveRemoteDataSrc();
  Future<List<LeaveRequest>> getLeaveRequests(String status);
}
```

#### **Repository Implementation** (`data/repo/`)
- Implement domain repository interface
- Use mixin: `with ErrorHandler`
- Delegate to data sources
- Wrap calls with `handleRepoCall`

**Example:**
```dart
// data/repo/leaves_repo_impl.dart
import 'package:attendance/core/config/mixins/error_handler.dart';
import 'package:attendance/core/config/typedefs.dart';
import '../../domain/repo/leave_request_repo.dart';
import '../datasource/leaves_remote_datasource.dart';

class LeaveRepoImpl with ErrorHandler implements LeaveRepository {
  const LeaveRepoImpl(this._remoteDataSource);

  final LeaveRemoteDataSrc _remoteDataSource;

  @override
  ResultFuture<List<LeaveRequest>> getLeaveRequests(String status) {
    return handleRepoCall(() => _remoteDataSource.getLeaveRequests(status));
  }
}
```

---

### **PRESENTATION LAYER** (UI & State Management)

#### **State Management with Cubit + Freezed**

##### **State Class** (`presentation/app/[feature]_cubit/[feature]_state.dart`)
- Use `@freezed` annotation
- Define as `sealed class`
- Use `part of` directive to link to cubit file
- Common states: `loading`, `success`, `failed`, `empty`, `initial`

**Example:**
```dart
// presentation/app/pending_leaves_cubit/pending_leave_state.dart
part of 'pending_leaves_cubit.dart';

@freezed
sealed class PendingLeaveState with _$PendingLeaveState {
  const factory PendingLeaveState.loading() = _loadingState;
  const factory PendingLeaveState.failed(String message) = _failedState;
  const factory PendingLeaveState.success({required List<LeaveRequest> request}) = _successState;
  const factory PendingLeaveState.empty() = _emptyState;
}
```

##### **Cubit Class** (`presentation/app/[feature]_cubit/[feature]_cubit.dart`)
- Extend `Cubit<YourState>`
- Inject use cases via constructor
- Use `part` directives for state and freezed files
- Emit states based on business logic
- Use `UtilFunctions.appLog()` for logging

**Example:**
```dart
// presentation/app/pending_leaves_cubit/pending_leaves_cubit.dart
import 'package:attendance/core/utils/util_functions.dart';
import 'package:attendance/src/leave_requests/domain/entity/leave_request.dart';
import 'package:attendance/src/leave_requests/domain/usecases/get_leave_request.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pending_leave_state.dart';
part 'pending_leaves_cubit.freezed.dart';

class PendingLeavesCubit extends Cubit<PendingLeaveState> {
  final GetLeaveRequestsUsecase _getLeaveRequestsUsecase;

  PendingLeavesCubit({required GetLeaveRequestsUsecase getLeaveRequestsUsecase})
      : _getLeaveRequestsUsecase = getLeaveRequestsUsecase,
        super(PendingLeaveState.loading());

  void loadLeaveRequests() async {
    UtilFunctions.appLog("loadLeaveRequests - Pending");
    emit(PendingLeaveState.loading());

    final result = await _getLeaveRequestsUsecase('pending');

    result.fold(
      (failure) => emit(PendingLeaveState.failed(failure.message)),
      (requests) {
        if (requests.isEmpty) {
          emit(PendingLeaveState.empty());
        } else {
          emit(PendingLeaveState.success(request: requests));
        }
      },
    );
  }

  Future<void> refreshLeaveRequests() async {
    UtilFunctions.appLog("refreshLeaveRequests - Pending");
    final result = await _getLeaveRequestsUsecase('pending');

    result.fold(
      (failure) => emit(PendingLeaveState.failed(failure.message)),
      (requests) {
        if (requests.isEmpty) {
          emit(PendingLeaveState.empty());
        } else {
          emit(PendingLeaveState.success(request: requests));
        }
      },
    );
  }
}
```

#### **Views** (`presentation/view/`)
- StatefulWidget or StatelessWidget based on need
- Define static `path` constant for routing
- Use `BlocBuilder` for state-dependent UI
- Use `BlocListener` for side effects (navigation, snackbars)
- Get localization: `AppLocalizations.of(context)`
- Get theme: `Theme.of(context)`
- Call cubit methods via `context.read<YourCubit>().method()`
- Watch state via `context.watch<YourCubit>().state`

**Example:**
```dart
// presentation/view/leave_request_view.dart
import 'package:attendance/l10n/app_localizations.dart';
import 'package:attendance/src/leave_requests/presentation/app/pending_leaves_cubit/pending_leaves_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LeaveRequestView extends StatefulWidget {
  static const path = "/leave-requests";

  const LeaveRequestView({super.key});

  @override
  State<LeaveRequestView> createState() => _LeaveRequestViewState();
}

class _LeaveRequestViewState extends State<LeaveRequestView> {
  @override
  void initState() {
    super.initState();
    context.read<PendingLeavesCubit>().loadLeaveRequests();
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("${text?.leaveRequest}"),
      ),
      body: BlocBuilder<PendingLeavesCubit, PendingLeaveState>(
        builder: (context, state) {
          return state.when(
            loading: () => Center(child: CircularProgressIndicator()),
            failed: (message) => ErrorWidget(message: message),
            success: (requests) => ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                return LeaveCard(leave: requests[index]);
              },
            ),
            empty: () => EmptyStateWidget(),
          );
        },
      ),
    );
  }
}
```

#### **Widgets** (`presentation/widgets/`)
- Reusable UI components
- Accept data via constructor parameters
- Keep them stateless when possible
- Use meaningful names

---

## 🔧 Dependency Injection

All dependencies are registered in `lib/core/services/injection_container.dart` using GetIt.

### Registration Pattern:
```dart
// Data Sources
sl.registerLazySingleton<LeaveRemoteDataSrc>(
  () => LeaveRemoteDataSrcImpl(sl()),
);

// Repositories
sl.registerLazySingleton<LeaveRepository>(
  () => LeaveRepoImpl(sl()),
);

// Use Cases
sl.registerLazySingleton(() => GetLeaveRequestsUsecase(sl()));

// Cubits (as factories, not singletons)
sl.registerFactory(() => PendingLeavesCubit(
  getLeaveRequestsUsecase: sl(),
));
```

### Important Rules:
- **Data Sources & Repositories**: Use `registerLazySingleton`
- **Use Cases**: Use `registerLazySingleton`
- **Cubits**: Use `registerFactory` (creates new instance each time)
- Order matters: Register dependencies before dependents
- Use `sl()` to inject dependencies (sl = Service Locator)

---

## 🌐 Localization

### Using Translations:
```dart
final text = AppLocalizations.of(context);
Text("${text?.leaveRequest}")
```

### Adding New Translations:
1. Add keys to `lib/l10n/app_en.arb`:
```json
{
  "leaveRequest": "Leave Request",
  "@leaveRequest": {
    "description": "Leave request page title"
  }
}
```

2. Add Arabic translation to `lib/l10n/app_ar.arb`:
```json
{
  "leaveRequest": "طلب إجازة"
}
```

3. Run code generation:
```bash
flutter gen-l10n
```

---

## 🎨 Theming & Styling

### Using Theme:
```dart
final theme = Theme.of(context);

Text(
  "Title",
  style: theme.textTheme.titleLarge?.copyWith(
    fontWeight: FontWeight.w600,
  ),
)
```

### Using Colors:
```dart
import 'package:attendance/core/res/styles/colours.dart';

Container(
  color: Colours.primaryColor,
  child: Text(
    "Text",
    style: TextStyle(color: Colours.textBlackColor),
  ),
)
```

### Common Colors:
- `Colours.primaryColor`
- `Colours.textBlackColor`
- `Colours.textHighlightColor`
- `Colours.onTimeGreen`
- `Colours.lateRed`
- `Colours.tooEarlyOrange`
- `Colours.notAvailableGrey`

---

## 🧭 Routing

Routes are defined in `lib/core/services/router.dart`.

### Adding a New Route:
```dart
GoRoute(
  path: LeaveRequestView.path,
  name: LeaveRequestView.path,
  builder: (context, state) => const LeaveRequestView(),
),
```

### Navigation:
```dart
// Navigate to route
context.go(LeaveRequestView.path);

// Navigate with parameters
context.go('${LeaveRequestView.path}?id=123');

// Go back
context.pop();
```

---

## 📦 Common Enums

Located in `lib/core/config/enums.dart`:

```dart
enum RequestStatus { pending, approved, rejected }
enum LeaveType { annual, sick, emergency, maternity, paternity, unpaid }
enum AttendanceTimeType { early, late, onTime, na }
```

---

## 🛠️ Utility Functions

Located in `lib/core/utils/util_functions.dart`:

### Logging:
```dart
UtilFunctions.appLog("Message to log");
```

### Snackbars:
```dart
UtilFunctions.showSnackBar(
  context: context,
  message: "Success message",
);
```

---

## ✅ Code Generation

After creating Freezed classes or updating localizations:

```bash
# Generate freezed files
flutter pub run build_runner build --delete-conflicting-outputs

# Generate localization files
flutter gen-l10n
```

---

## 📋 Checklist for Creating a New Feature

When AI is asked to create a new feature called `[feature_name]`:

### 1. **Domain Layer**
- [ ] Create `lib/src/[feature_name]/domain/entity/` with entities
- [ ] Create `lib/src/[feature_name]/domain/repo/[feature]_repo.dart` (abstract)
- [ ] Create `lib/src/[feature_name]/domain/usecases/` with use case classes

### 2. **Data Layer**
- [ ] Create `lib/src/[feature_name]/data/models/` with model classes
- [ ] Create `lib/src/[feature_name]/data/datasource/[feature]_remote_datasource.dart`
- [ ] Create `lib/src/[feature_name]/data/repo/[feature]_repo_impl.dart`

### 3. **Presentation Layer**
- [ ] Create `lib/src/[feature_name]/presentation/app/[feature]_cubit/`
  - [ ] `[feature]_cubit.dart`
  - [ ] `[feature]_state.dart`
- [ ] Create `lib/src/[feature_name]/presentation/view/[feature]_view.dart`
- [ ] Create `lib/src/[feature_name]/presentation/widgets/` (if needed)

### 4. **Dependency Injection**
- [ ] Register data source in `injection_container.dart`
- [ ] Register repository in `injection_container.dart`
- [ ] Register use cases in `injection_container.dart`
- [ ] Register cubit(s) in `injection_container.dart`

### 5. **Routing**
- [ ] Add route in `lib/core/services/router.dart`

### 6. **Localization**
- [ ] Add keys to `lib/l10n/app_en.arb`
- [ ] Add translations to `lib/l10n/app_ar.arb`
- [ ] Run `flutter gen-l10n`

### 7. **Code Generation**
- [ ] Run `flutter pub run build_runner build --delete-conflicting-outputs`

---

## 🚨 Common Mistakes to Avoid

1. ❌ **Don't** use Flutter/UI packages in Domain layer
2. ❌ **Don't** create tight coupling between layers
3. ❌ **Don't** put business logic in Cubits (belongs in Entities/UseCases)
4. ❌ **Don't** use concrete implementations in constructors (use abstractions)
5. ❌ **Don't** forget to register dependencies in injection_container.dart
6. ❌ **Don't** hardcode strings (use localization)
7. ❌ **Don't** use `registerLazySingleton` for Cubits (use `registerFactory`)
8. ❌ **Don't** forget to run code generation after creating Freezed classes

---

## 💡 Best Practices

1. ✅ Always use `ResultFuture<T>` for repository methods
2. ✅ Use `handleNetworkCall` for API calls in data sources
3. ✅ Use `handleRepoCall` in repository implementations
4. ✅ Use Freezed for immutable state classes
5. ✅ Log important actions with `UtilFunctions.appLog()`
6. ✅ Handle all possible states (loading, success, failed, empty)
7. ✅ Use `?.` for nullable localization strings
8. ✅ Keep widgets small and focused
9. ✅ Extract reusable widgets to separate files
10. ✅ Use meaningful variable and class names

---

## 🎯 Example: Creating a Complete Feature

**Task**: Create a "Notifications" feature

### Step-by-step:

1. **Create folder structure:**
```
lib/src/notifications/
├── data/
│   ├── datasource/
│   ├── models/
│   └── repo/
├── domain/
│   ├── entity/
│   ├── repo/
│   └── usecases/
└── presentation/
    ├── app/
    ├── view/
    └── widgets/
```

2. **Domain Layer:**
```dart
// domain/entity/notification.dart
class Notification {
  final String id;
  final String title;
  final String message;
  final DateTime createdAt;
  final bool isRead;

  Notification({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    required this.isRead,
  });
}

// domain/repo/notification_repo.dart
abstract class NotificationRepository {
  ResultFuture<List<Notification>> getNotifications();
  ResultFuture<void> markAsRead(String id);
}

// domain/usecases/get_notifications_usecase.dart
class GetNotificationsUsecase {
  final NotificationRepository _repository;
  GetNotificationsUsecase(this._repository);

  ResultFuture<List<Notification>> call() {
    return _repository.getNotifications();
  }
}
```

3. **Data Layer:**
```dart
// data/models/notification_model.dart
class NotificationModel extends Notification {
  NotificationModel({
    required super.id,
    required super.title,
    required super.message,
    required super.createdAt,
    required super.isRead,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      createdAt: DateTime.parse(json['created_at']),
      isRead: json['is_read'],
    );
  }
}

// data/datasource/notification_remote_datasource.dart
class NotificationRemoteDataSrcImpl
    with NetworkCallHandler
    implements NotificationRemoteDataSrc {
  const NotificationRemoteDataSrcImpl(this._dio);
  final Dio _dio;

  @override
  Future<List<Notification>> getNotifications() async {
    final header = await NetworkConstants.getHeadersWithAuth();
    return handleNetworkCall<List<Notification>>(
      call: () => _dio.get(
        '${NetworkConstants.url}/notifications',
        options: Options(headers: header),
      ),
      onSuccess: (response) {
        final List data = response.data[NetworkConstants.dataParam];
        return data.map((json) => NotificationModel.fromJson(json)).toList();
      },
    );
  }
}

abstract class NotificationRemoteDataSrc {
  Future<List<Notification>> getNotifications();
}

// data/repo/notification_repo_impl.dart
class NotificationRepoImpl with ErrorHandler implements NotificationRepository {
  const NotificationRepoImpl(this._remoteDataSource);
  final NotificationRemoteDataSrc _remoteDataSource;

  @override
  ResultFuture<List<Notification>> getNotifications() {
    return handleRepoCall(() => _remoteDataSource.getNotifications());
  }

  @override
  ResultFuture<void> markAsRead(String id) {
    return handleRepoCall(() => _remoteDataSource.markAsRead(id));
  }
}
```

4. **Presentation Layer:**
```dart
// presentation/app/notifications_cubit/notifications_state.dart
part of 'notifications_cubit.dart';

@freezed
sealed class NotificationsState with _$NotificationsState {
  const factory NotificationsState.loading() = _loadingState;
  const factory NotificationsState.failed(String message) = _failedState;
  const factory NotificationsState.success({required List<Notification> notifications}) = _successState;
  const factory NotificationsState.empty() = _emptyState;
}

// presentation/app/notifications_cubit/notifications_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notifications_state.dart';
part 'notifications_cubit.freezed.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final GetNotificationsUsecase _getNotificationsUsecase;

  NotificationsCubit({required GetNotificationsUsecase getNotificationsUsecase})
      : _getNotificationsUsecase = getNotificationsUsecase,
        super(NotificationsState.loading());

  void loadNotifications() async {
    emit(NotificationsState.loading());
    final result = await _getNotificationsUsecase();

    result.fold(
      (failure) => emit(NotificationsState.failed(failure.message)),
      (notifications) {
        if (notifications.isEmpty) {
          emit(NotificationsState.empty());
        } else {
          emit(NotificationsState.success(notifications: notifications));
        }
      },
    );
  }
}

// presentation/view/notifications_view.dart
class NotificationsView extends StatefulWidget {
  static const path = "/notifications";
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationsCubit>().loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text("${text?.notifications}")),
      body: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          return state.when(
            loading: () => Center(child: CircularProgressIndicator()),
            failed: (message) => ErrorWidget(message: message),
            success: (notifications) => ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return NotificationCard(notification: notifications[index]);
              },
            ),
            empty: () => Center(child: Text("${text?.noNotifications}")),
          );
        },
      ),
    );
  }
}
```

5. **Register in injection_container.dart:**
```dart
// Data Sources
sl.registerLazySingleton<NotificationRemoteDataSrc>(
  () => NotificationRemoteDataSrcImpl(sl()),
);

// Repositories
sl.registerLazySingleton<NotificationRepository>(
  () => NotificationRepoImpl(sl()),
);

// Use Cases
sl.registerLazySingleton(() => GetNotificationsUsecase(sl()));

// Cubits
sl.registerFactory(() => NotificationsCubit(
  getNotificationsUsecase: sl(),
));
```

6. **Add route in router.dart:**
```dart
GoRoute(
  path: NotificationsView.path,
  name: NotificationsView.path,
  builder: (context, state) => const NotificationsView(),
),
```

7. **Add localizations:**
```json
// app_en.arb
{
  "notifications": "Notifications",
  "noNotifications": "No notifications"
}

// app_ar.arb
{
  "notifications": "الإشعارات",
  "noNotifications": "لا توجد إشعارات"
}
```

8. **Run code generation:**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
flutter gen-l10n
```

---

## 📝 Summary

When creating new features:
1. Start with **Domain** (entities, repos, use cases)
2. Implement **Data** layer (models, data sources, repo implementations)
3. Build **Presentation** layer (cubits, views, widgets)
4. Register everything in **Dependency Injection**
5. Add **Routing**
6. Add **Localization**
7. Run **Code Generation**

Always follow the dependency rule: Data → Domain ← Presentation

---

**Version**: 1.0
**Last Updated**: October 2024
**Maintained by**: Development Team
