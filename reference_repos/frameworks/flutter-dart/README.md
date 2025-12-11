# Flutter & Dart Development References

**Author:** [Your Development Team Name]  
**التاريخ:** 11 ديسمبر 2025  
**المصدر:** Flutter Community & Dart Team  
**الحالة:** ✅ **مراجع شاملة للتطوير**

---

## 🎯 نظرة عامة

هذا المجلد يحتوي على مراجع شاملة لتطوير تطبيقات Flutter باستخدام Dart، مع التركيز على أفضل الممارسات والأنماط المتقدمة.

---

## 🚀 Flutter Best Practices

### 1. **Architecture Patterns**

#### Clean Architecture

```dart
// lib/core/architecture/
// Domain Layer
abstract class Repository {
  Future<Either<Failure, Success>> execute();
}

// Data Layer
class RepositoryImpl implements Repository {
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;

  RepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, Success>> execute() async {
    try {
      final result = await remoteDataSource.getData();
      await localDataSource.cacheData(result);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}

// Presentation Layer
class FeatureBloc extends Bloc<FeatureEvent, FeatureState> {
  final Repository repository;

  FeatureBloc({required this.repository}) : super(FeatureInitial()) {
    on<LoadDataEvent>(_onLoadData);
  }

  Future<void> _onLoadData(
    LoadDataEvent event,
    Emitter<FeatureState> emit,
  ) async {
    emit(FeatureLoading());

    final result = await repository.execute();

    result.fold(
      (failure) => emit(FeatureError(failure.message)),
      (data) => emit(FeatureLoaded(data)),
    );
  }
}
```

#### Feature-First Organization

```
lib/
├── core/                    # Core functionality
│   ├── constants/          # App constants
│   ├── errors/             # Error handling
│   ├── network/            # Network layer
│   ├── storage/            # Local storage
│   └── utils/              # Utilities
├── features/               # Feature modules
│   ├── authentication/     # Auth feature
│   │   ├── data/          # Data layer
│   │   ├── domain/        # Domain layer
│   │   └── presentation/  # UI layer
│   ├── dashboard/         # Dashboard feature
│   └── profile/           # Profile feature
├── shared/                 # Shared components
│   ├── widgets/           # Reusable widgets
│   ├── themes/            # App themes
│   └── extensions/        # Dart extensions
└── main.dart              # App entry point
```

### 2. **State Management with Riverpod**

```dart
// providers/auth_provider.dart
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.read(authRemoteDataSourceProvider),
    localDataSource: ref.read(authLocalDataSourceProvider),
  );
});

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    authRepository: ref.read(authRepositoryProvider),
  );
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  AuthNotifier({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const AuthState.initial());

  Future<void> signIn(String email, String password) async {
    state = const AuthState.loading();

    final result = await _authRepository.signIn(email, password);

    result.fold(
      (failure) => state = AuthState.error(failure.message),
      (user) => state = AuthState.authenticated(user),
    );
  }
}

// UI Usage
class LoginScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      body: authState.when(
        initial: () => const LoginForm(),
        loading: () => const CircularProgressIndicator(),
        authenticated: (user) => const DashboardScreen(),
        error: (message) => ErrorWidget(message),
      ),
    );
  }
}
```

### 3. **Local Database with Isar**

```dart
// models/user.dart
@collection
class User {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String email;

  late String name;

  @Index()
  late DateTime createdAt;

  List<String> tags = [];
}

// services/database_service.dart
class DatabaseService {
  static late Isar _isar;

  static Future<void> initialize() async {
    _isar = await Isar.open([UserSchema]);
  }

  static Isar get instance => _isar;
}

// repositories/user_repository.dart
class UserRepository {
  final Isar _isar = DatabaseService.instance;

  Future<void> createUser(User user) async {
    await _isar.writeTxn(() async {
      await _isar.users.put(user);
    });
  }

  Future<List<User>> getAllUsers() async {
    return await _isar.users.where().findAll();
  }

  Future<User?> getUserByEmail(String email) async {
    return await _isar.users.filter().emailEqualTo(email).findFirst();
  }

  Stream<List<User>> watchUsers() {
    return _isar.users.where().watch(fireImmediately: true);
  }
}
```

---

## 🎨 UI/UX Best Practices

### 1. **Responsive Design**

```dart
// utils/responsive.dart
class Responsive {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 650;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < 1100 &&
      MediaQuery.of(context).size.width >= 650;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1100;
}

// widgets/responsive_widget.dart
class ResponsiveWidget extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const ResponsiveWidget({
    Key? key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1100) {
          return desktop;
        } else if (constraints.maxWidth >= 650) {
          return tablet ?? mobile;
        } else {
          return mobile;
        }
      },
    );
  }
}
```

### 2. **Theme Management**

```dart
// themes/app_theme.dart
class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF6750A4),
      brightness: Brightness.light,
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF6750A4),
      brightness: Brightness.dark,
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
    ),
  );
}

// providers/theme_provider.dart
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.system);

  void setTheme(ThemeMode themeMode) {
    state = themeMode;
  }

  void toggleTheme() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
}
```

### 3. **Custom Widgets**

```dart
// widgets/custom_button.dart
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final ButtonType type;

  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.type = ButtonType.primary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: _getButtonStyle(context),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(text),
      ),
    );
  }

  ButtonStyle _getButtonStyle(BuildContext context) {
    switch (type) {
      case ButtonType.primary:
        return ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
        );
      case ButtonType.secondary:
        return ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          foregroundColor: Theme.of(context).colorScheme.onSecondary,
        );
      case ButtonType.outline:
        return OutlinedButton.styleFrom(
          side: BorderSide(
            color: Theme.of(context).colorScheme.primary,
          ),
        );
    }
  }
}

enum ButtonType { primary, secondary, outline }
```

---

## 🔧 Performance Optimization

### 1. **Widget Optimization**

```dart
// Efficient ListView with const constructors
class OptimizedListView extends StatelessWidget {
  final List<Item> items;

  const OptimizedListView({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ItemTile(
          key: ValueKey(items[index].id),
          item: items[index],
        );
      },
    );
  }
}

class ItemTile extends StatelessWidget {
  final Item item;

  const ItemTile({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: CachedNetworkImageProvider(item.imageUrl),
      ),
      title: Text(item.title),
      subtitle: Text(item.subtitle),
      onTap: () => _onItemTap(context),
    );
  }

  void _onItemTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemDetailScreen(item: item),
      ),
    );
  }
}
```

### 2. **Image Optimization**

```dart
// utils/image_utils.dart
class ImageUtils {
  static Widget optimizedNetworkImage(
    String url, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
  }) {
    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => const ShimmerPlaceholder(),
      errorWidget: (context, url, error) => const Icon(Icons.error),
      memCacheWidth: width?.toInt(),
      memCacheHeight: height?.toInt(),
    );
  }

  static Widget optimizedAssetImage(
    String assetPath, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
  }) {
    return Image.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      cacheWidth: width?.toInt(),
      cacheHeight: height?.toInt(),
    );
  }
}

// widgets/shimmer_placeholder.dart
class ShimmerPlaceholder extends StatelessWidget {
  final double? width;
  final double? height;

  const ShimmerPlaceholder({Key? key, this.width, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
```

---

## 🧪 Testing Strategies

### 1. **Unit Testing**

```dart
// test/repositories/user_repository_test.dart
void main() {
  group('UserRepository', () {
    late UserRepository userRepository;
    late MockRemoteDataSource mockRemoteDataSource;
    late MockLocalDataSource mockLocalDataSource;

    setUp(() {
      mockRemoteDataSource = MockRemoteDataSource();
      mockLocalDataSource = MockLocalDataSource();
      userRepository = UserRepositoryImpl(
        remoteDataSource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
      );
    });

    group('getUser', () {
      const tUserId = '1';
      const tUser = User(id: tUserId, name: 'Test User');

      test('should return user when remote data source succeeds', () async {
        // arrange
        when(mockRemoteDataSource.getUser(tUserId))
            .thenAnswer((_) async => tUser);
        when(mockLocalDataSource.cacheUser(tUser))
            .thenAnswer((_) async => unit);

        // act
        final result = await userRepository.getUser(tUserId);

        // assert
        expect(result, equals(const Right(tUser)));
        verify(mockRemoteDataSource.getUser(tUserId));
        verify(mockLocalDataSource.cacheUser(tUser));
      });

      test('should return failure when remote data source fails', () async {
        // arrange
        when(mockRemoteDataSource.getUser(tUserId))
            .thenThrow(ServerException());

        // act
        final result = await userRepository.getUser(tUserId);

        // assert
        expect(result, equals(const Left(ServerFailure())));
        verify(mockRemoteDataSource.getUser(tUserId));
        verifyNever(mockLocalDataSource.cacheUser(any));
      });
    });
  });
}
```

### 2. **Widget Testing**

```dart
// test/widgets/custom_button_test.dart
void main() {
  group('CustomButton', () {
    testWidgets('should display text correctly', (tester) async {
      // arrange
      const buttonText = 'Test Button';

      // act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: buttonText,
              onPressed: () {},
            ),
          ),
        ),
      );

      // assert
      expect(find.text(buttonText), findsOneWidget);
    });

    testWidgets('should show loading indicator when isLoading is true', (tester) async {
      // act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Test',
              isLoading: true,
            ),
          ),
        ),
      );

      // assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Test'), findsNothing);
    });

    testWidgets('should call onPressed when tapped', (tester) async {
      // arrange
      bool wasPressed = false;

      // act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Test',
              onPressed: () => wasPressed = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(CustomButton));

      // assert
      expect(wasPressed, isTrue);
    });
  });
}
```

### 3. **Integration Testing**

```dart
// integration_test/app_test.dart
void main() {
  group('App Integration Tests', () {
    testWidgets('complete user flow', (tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Verify login screen is displayed
      expect(find.text('تسجيل الدخول'), findsOneWidget);

      // Enter credentials
      await tester.enterText(find.byKey(const Key('email_field')), 'test@example.com');
      await tester.enterText(find.byKey(const Key('password_field')), 'password123');

      // Tap login button
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle();

      // Verify dashboard is displayed
      expect(find.text('لوحة التحكم'), findsOneWidget);

      // Navigate to profile
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle();

      // Verify profile screen
      expect(find.text('الملف الشخصي'), findsOneWidget);
    });
  });
}
```

---

## 📱 Platform-Specific Features

### 1. **iOS Integration**

```dart
// services/ios_service.dart
class IOSService {
  static const platform = MethodChannel('com.example.app/ios');

  static Future<void> requestNotificationPermission() async {
    if (Platform.isIOS) {
      try {
        await platform.invokeMethod('requestNotificationPermission');
      } on PlatformException catch (e) {
        print('Failed to request notification permission: ${e.message}');
      }
    }
  }

  static Future<void> setAppBadge(int count) async {
    if (Platform.isIOS) {
      try {
        await platform.invokeMethod('setAppBadge', {'count': count});
      } on PlatformException catch (e) {
        print('Failed to set app badge: ${e.message}');
      }
    }
  }
}
```

### 2. **Android Integration**

```dart
// services/android_service.dart
class AndroidService {
  static const platform = MethodChannel('com.example.app/android');

  static Future<void> createNotificationChannel() async {
    if (Platform.isAndroid) {
      try {
        await platform.invokeMethod('createNotificationChannel');
      } on PlatformException catch (e) {
        print('Failed to create notification channel: ${e.message}');
      }
    }
  }

  static Future<void> requestBatteryOptimization() async {
    if (Platform.isAndroid) {
      try {
        await platform.invokeMethod('requestBatteryOptimization');
      } on PlatformException catch (e) {
        print('Failed to request battery optimization: ${e.message}');
      }
    }
  }
}
```

---

## 🔒 Security Best Practices

### 1. **Secure Storage**

```dart
// services/secure_storage_service.dart
class SecureStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: IOSAccessibility.first_unlock_this_device,
    ),
  );

  static Future<void> storeToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: 'auth_token');
  }

  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
```

### 2. **Network Security**

```dart
// services/network_service.dart
class NetworkService {
  static Dio createDio() {
    final dio = Dio();

    // Add certificate pinning
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
      client.badCertificateCallback = (cert, host, port) {
        // Implement certificate validation
        return _validateCertificate(cert, host);
      };
      return client;
    };

    // Add interceptors
    dio.interceptors.addAll([
      AuthInterceptor(),
      LoggingInterceptor(),
      ErrorInterceptor(),
    ]);

    return dio;
  }

  static bool _validateCertificate(X509Certificate cert, String host) {
    // Implement your certificate validation logic
    return true;
  }
}

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await SecureStorageService.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
```

---

## 📚 مراجع إضافية

### الوثائق الرسمية

- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Flutter Cookbook](https://docs.flutter.dev/cookbook)

### أفضل الممارسات

- [Flutter Best Practices](https://github.com/flutter/flutter/wiki/Style-guide-for-Flutter-repo)
- [Effective Dart](https://dart.dev/guides/language/effective-dart)
- [Flutter Performance Best Practices](https://docs.flutter.dev/perf/best-practices)

### المجتمع والمساهمات

- [Flutter Community](https://flutter.dev/community)
- [Dart Packages](https://pub.dev/)
- [Flutter Samples](https://github.com/flutter/samples)

---

## 🎉 الخلاصة

هذه المراجع تقدم دليلاً شاملاً لتطوير تطبيقات Flutter عالية الجودة باستخدام أفضل الممارسات والأنماط المتقدمة. من خلال اتباع هذه الإرشادات، يمكن للمطورين بناء تطبيقات قابلة للصيانة وقابلة للتوسع وآمنة.

**الفوائد الرئيسية:**
✅ بنية نظيفة وقابلة للصيانة  
✅ أداء محسن وتجربة مستخدم ممتازة  
✅ أمان متقدم وحماية البيانات  
✅ اختبارات شاملة وموثوقية عالية  
✅ دعم متعدد المنصات مع ميزات خاصة

---

**Created by:** [Your Development Team Name]  
**المصدر:** Flutter Community & Dart Team  
**آخر تحديث:** 11 ديسمبر 2025
