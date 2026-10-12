import 'package:journal_app/features/auth_screen/data/repositories/auth_repository_impl.dart';
import 'package:journal_app/features/auth_screen/domain/use_cases/authenticate_use_case.dart';
import 'package:journal_app/features/auth_screen/domain/use_cases/authorize_use_case.dart';
import 'package:journal_app/features/auth_screen/domain/use_cases/register_use_case.dart';
import 'package:journal_app/features/calendar_screen/data/repositories/event_repository_impl.dart';
import 'package:journal_app/features/calendar_screen/domain/use_cases/event_use_case.dart';
import 'package:journal_app/features/main_screen/data/repositories/category_repository_impl.dart';
import 'package:journal_app/features/main_screen/data/repositories/event_repository_impl.dart';
import 'package:journal_app/features/main_screen/domain/use_cases/category_use_case.dart';
import 'package:journal_app/features/main_screen/domain/use_cases/event_use_case.dart';
import 'package:journal_app/features/profile_screen/data/repositories/profile_category_repository_impl.dart';
import 'package:journal_app/features/profile_screen/data/repositories/user_data_repository_impl.dart';
import 'package:journal_app/features/profile_screen/domain/use_cases/profile_category_use_case.dart';
import 'package:journal_app/features/profile_screen/domain/use_cases/user_data_use_case.dart';

RegisterUseCase createRegisterUseCase() {
  return RegisterUseCase(repository: AuthRepositoryImpl());
}

AuthorizeUseCase createAuthorizeUseCase() {
  return AuthorizeUseCase(repository: AuthRepositoryImpl());
}

AuthenticateUseCase createAuthenticateUseCase() {
  return AuthenticateUseCase(repository: AuthRepositoryImpl());
}

CategoryUseCase createCategoryUseCase() {
  return CategoryUseCase(repository: CategoryRepositoryImpl());
}

ProfileCategoryUseCase createProfileCategoryUseCase() {
  return ProfileCategoryUseCase(repository: ProfileCategoryUseCaseImpl());
}

MainScreenEventUseCase createMainScreenEventUseCase() {
  return MainScreenEventUseCase(repository: MainScreenEventRepositoryImpl());
}

CalendarScreenEventUseCase createCalendarScreenEventUseCase() {
  return CalendarScreenEventUseCase(repository: CalendarScreenEventRepositoryImpl());
}

UserDataUseCase createUserDataUseCase() {
  return UserDataUseCase(repository: UserDataRepositoryImpl());
}
