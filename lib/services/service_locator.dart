import 'package:currency_convertor/data/api/api.dart';
import 'package:currency_convertor/repositories/currency_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

void initServiceLocator() {
  sl.registerSingletonAsync(() async => await SharedPreferences.getInstance());

  // APIs
  sl.registerLazySingleton<API>(() => API.instance);

  // Repositories
  sl.registerLazySingleton<CurrencyRepository>(() => CurrencyRepositoryImpl(api: sl()));
}
