import 'package:currency_convertor/cubits/convertor/convertor_cubit.dart';
import 'package:currency_convertor/pages/home_page/home_page.dart';
import 'package:currency_convertor/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  // Убедимся, что все необходимые подсистемы
  // будут настроены и готовы к работе до того, как приложение начнет выполнение.
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализируем зависимости для дальнейших инъекций
  initServiceLocator();

  // Дождемся и убедимся, что все зависимости проинициализорованы
  await sl.allReady();

  // Запускаем приложение с инициализации глобальных кубитов
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ConvertorCubit(currencyRepository: sl())
            ..fetchRates()
            ..fetchCurrencies(),
        ),
      ],
      child: const MaterialApp(
        home: HomePage(),
      ),
    );
  }
}
