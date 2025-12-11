# Flutter Clean Architecture Example

**Author:** [Your Development Team Name]  
**التاريخ:** 11 ديسمبر 2025  
**المصدر:** Flutter Community Best Practices  

---

## 🏗️ Clean Architecture Implementation

```dart
// lib/core/error/failures.dart
abstract class Failure extends Equatable {
  const Failure();
}

class ServerFailure extends Failure {
  @override
  List<Object> get props => [];
}

class CacheFailure extends Failure {
  @override
  List<Object> get props => [];
}

class NetworkFailure extends Failure {
  @override
  List<Object> get props => [];
}

// lib/core/usecases/usecase.dart
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}

// lib/features/user/domain/entities/user.dart
class User extends Equatable {

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
  });
  final String id;
  final String name;
  final String email;
  final DateTime createdAt;

  @override
  List<Object> get props => [id, name, email, createdAt];
}

// lib/features/user/domain/repositories/user_repository.dart
abstract class UserRepository {
  Future<Either<Failure, User>> getUser(String id);
  Future<Either<Failure, List<User>>> getUsers();
  Future<Either<Failure, User>> createUser(User user);
  Future<Either<Failure, User>> updateUser(User user);
  Future<Either<Failure, void>> deleteUser(String id);
}

// lib/features/user/domain/usecases/get_user.dart
class GetUser implements UseCase<User, GetUserParams> {

  GetUser(this.repository);
  final UserRepository repository;

  @override
  Future<Either<Failure, User>> call(GetUserParams params) async => repository.getUser(params.id);
}

class GetUserParams extends Equatable {

  const GetUserParams({required this.id});
  final String id;

  @override
  List<Object> get props => [id];
}

// lib/features/user/data/models/user_model.dart
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      createdAt: DateTime.parse(json['created_at']),
    );

  Map<String, dynamic> toJson() => {
      'id': id,
      'name': name,
      'email': email,
      'created_at': createdAt.toIso8601String(),
    };
}

// lib/features/user/data/datasources/user_remote_data_source.dart
abstract class UserRemoteDataSource {
  Future<UserModel> getUser(String id);
  Future<List<UserModel>> getUsers();
  Future<UserModel> createUser(UserModel user);
  Future<UserModel> updateUser(UserModel user);
  Future<void> deleteUser(String id);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {

  UserRemoteDataSourceImpl({required this.client});
  final http.Client client;

  @override
  Future<UserModel> getUser(String id) async {
    final response = await client.get(
      Uri.parse('$baseUrl/users/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<UserModel>> getUsers() async {
    final response = await client.get(
      Uri.parse('$baseUrl/users'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => UserModel.fromJson(json)).toList();
    } else {
      throw ServerException();
    }
  }

  // ... other methods
}

// lib/features/user/data/repositories/user_repository_impl.dart
class UserRepositoryImpl implements UserRepository {

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, User>> getUser(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteUser = await remoteDataSource.getUser(id);
        localDataSource.cacheUser(remoteUser);
        return Right(remoteUser);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localUser = await localDataSource.getLastUser(id);
        return Right(localUser);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  // ... other methods
}

// lib/features/user/presentation/bloc/user_bloc.dart
class UserBloc extends Bloc<UserEvent, UserState> {

  UserBloc({
    required this.getUser,
    required this.getUsers,
    required this.createUser,
    required this.updateUser,
    required this.deleteUser,
  }) : super(UserInitial()) {
    on<GetUserEvent>(_onGetUser);
    on<GetUsersEvent>(_onGetUsers);
    on<CreateUserEvent>(_onCreateUser);
    on<UpdateUserEvent>(_onUpdateUser);
    on<DeleteUserEvent>(_onDeleteUser);
  }
  final GetUser getUser;
  final GetUsers getUsers;
  final CreateUser createUser;
  final UpdateUser updateUser;
  final DeleteUser deleteUser;

  Future<void> _onGetUser(
    GetUserEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    
    final failureOrUser = await getUser(GetUserParams(id: event.id));
    
    failureOrUser.fold(
      (failure) => emit(UserError(message: _mapFailureToMessage(failure))),
      (user) => emit(UserLoaded(user: user)),
    );
  }

  Future<void> _onGetUsers(
    GetUsersEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UsersLoading());
    
    final failureOrUsers = await getUsers(NoParams());
    
    failureOrUsers.fold(
      (failure) => emit(UserError(message: _mapFailureToMessage(failure))),
      (users) => emit(UsersLoaded(users: users)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server Failure';
      case CacheFailure:
        return 'Cache Failure';
      case NetworkFailure:
        return 'Network Failure';
      default:
        return 'Unexpected Error';
    }
  }
}

// lib/features/user/presentation/pages/user_page.dart
class UserPage extends StatelessWidget {

  const UserPage({required this.userId, Key? key}) : super(key: key);
  final String userId;

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
      ),
      body: BlocProvider(
        create: (context) => sl<UserBloc>()..add(GetUserEvent(id: userId)),
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserInitial) {
              return const Center(child: Text('Welcome'));
            } else if (state is UserLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserLoaded) {
              return UserDisplay(user: state.user);
            } else if (state is UserError) {
              return MessageDisplay(message: state.message);
            }
            return Container();
          },
        ),
      ),
    );
}

// lib/features/user/presentation/widgets/user_display.dart
class UserDisplay extends StatelessWidget {

  const UserDisplay({required this.user, Key? key}) : super(key: key);
  final User user;

  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            user.name,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            user.email,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Created: ${DateFormat.yMMMd().format(user.createdAt)}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
}

// lib/injection_container.dart
final sl = GetIt.instance;

Future<void> init() async {
  //! Features - User
  // Bloc
  sl.registerFactory(
    () => UserBloc(
      getUser: sl(),
      getUsers: sl(),
      createUser: sl(),
      updateUser: sl(),
      deleteUser: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetUser(sl()));
  sl.registerLazySingleton(() => GetUsers(sl()));
  sl.registerLazySingleton(() => CreateUser(sl()));
  sl.registerLazySingleton(() => UpdateUser(sl()));
  sl.registerLazySingleton(() => DeleteUser(sl()));

  // Repository
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(sharedPreferences: sl()),
  );

  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(http.Client);
  sl.registerLazySingleton(DataConnectionChecker);
}
```

## 🧪 Testing Examples

```dart
// test/features/user/domain/usecases/get_user_test.dart
void main() {
  late GetUser usecase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = GetUser(mockUserRepository);
  });

  const tUserId = '1';
  const tUser = User(
    id: '1',
    name: 'Test User',
    email: 'test@example.com',
    createdAt: '2023-01-01T00:00:00.000Z',
  );

  test(
    'should get user from the repository',
    () async {
      // arrange
      when(mockUserRepository.getUser(any))
          .thenAnswer((_) async => const Right(tUser));

      // act
      final result = await usecase(const GetUserParams(id: tUserId));

      // assert
      expect(result, const Right(tUser));
      verify(mockUserRepository.getUser(tUserId));
      verifyNoMoreInteractions(mockUserRepository);
    },
  );
}

// test/features/user/presentation/bloc/user_bloc_test.dart
void main() {
  late UserBloc bloc;
  late MockGetUser mockGetUser;
  late MockGetUsers mockGetUsers;

  setUp(() {
    mockGetUser = MockGetUser();
    mockGetUsers = MockGetUsers();
    bloc = UserBloc(
      getUser: mockGetUser,
      getUsers: mockGetUsers,
      createUser: mockCreateUser,
      updateUser: mockUpdateUser,
      deleteUser: mockDeleteUser,
    );
  });

  test('initialState should be UserInitial', () {
    // assert
    expect(bloc.state, equals(UserInitial()));
  });

  group('GetUser', () {
    const tUserId = '1';
    const tUser = User(
      id: '1',
      name: 'Test User',
      email: 'test@example.com',
      createdAt: '2023-01-01T00:00:00.000Z',
    );

    test(
      'should emit [UserLoading, UserLoaded] when data is gotten successfully',
      () async {
        // arrange
        when(mockGetUser(any))
            .thenAnswer((_) async => const Right(tUser));

        // assert later
        final expected = [
          UserLoading(),
          const UserLoaded(user: tUser),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(const GetUserEvent(id: tUserId));
      },
    );

    test(
      'should emit [UserLoading, UserError] when getting data fails',
      () async {
        // arrange
        when(mockGetUser(any))
            .thenAnswer((_) async => Left(ServerFailure()));

        // assert later
        final expected = [
          UserLoading(),
          const UserError(message: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(const GetUserEvent(id: tUserId));
      },
    );
  });
}
```

## 📱 Widget Testing

```dart
// test/features/user/presentation/widgets/user_display_test.dart
void main() {
  const tUser = User(
    id: '1',
    name: 'Test User',
    email: 'test@example.com',
    createdAt: '2023-01-01T00:00:00.000Z',
  );

  testWidgets(
    'should display user information correctly',
    (WidgetTester tester) async {
      // arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: const UserDisplay(user: tUser),
          ),
        ),
      );

      // assert
      expect(find.text('Test User'), findsOneWidget);
      expect(find.text('test@example.com'), findsOneWidget);
      expect(find.textContaining('Created:'), findsOneWidget);
    },
  );
}
```

---

**Created by:** [Your Development Team Name]  
**المصدر:** Flutter Community Best Practices  
**آخر تحديث:** 11 ديسمبر 2025