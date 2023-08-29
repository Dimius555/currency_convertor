import 'package:currency_convertor/data/api/api.dart';
import 'package:currency_convertor/data/db/data_base.dart';
import 'package:currency_convertor/repositories/currency_repository.dart';
import 'package:currency_convertor/services/data_base_service.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

void initServiceLocator() {
  sl.registerSingletonAsync(() async => await SharedPreferences.getInstance());
  sl.registerSingletonAsync<DataStore>(() async => await DataStore(databaseService: DatabaseService()).initDB());

  // APIs
  sl.registerLazySingleton<API>(() => API.instance);

  // Repositories
  sl.registerLazySingleton<CurrencyRepository>(() => CurrencyRepositoryImpl(api: sl(), dataStore: sl()));
}
