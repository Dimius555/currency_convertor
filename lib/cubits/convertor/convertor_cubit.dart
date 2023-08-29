import 'package:currency_convertor/data/models/currency_model.dart';
import 'package:currency_convertor/data/models/custom_exception.dart';
import 'package:currency_convertor/data/models/rates.dart';
import 'package:currency_convertor/repositories/currency_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'convertor_state.dart';

class ConvertorCubit extends Cubit<ConvertorState> {
  // Статические методы для прослушивания и получения кубита
  static ConvertorState watchState(BuildContext context) => context.watch<ConvertorCubit>().state;
  static ConvertorCubit read(BuildContext context) => context.read<ConvertorCubit>();

  ConvertorCubit({required CurrencyRepository currencyRepository})
      : _currencyRepo = currencyRepository,
        super(ConvertorState(
          currencies: [],
          rates: Rates.empty(),
          status: InitialStatus(),
        ));

  final CurrencyRepository _currencyRepo;

  void initData() {
    fetchCurrencies();
    fetchRates();
    emit(state.copyWith(status: SuccessfulStatus(operationResultFrom: 0, operationResultTo: 0, isOperationFrom: true)));
  }

  void fetchCurrencies() async {
    try {
      final list = await _currencyRepo.fetchListOfCurencies();
      emit(state.copyWith(currencies: list));
    } catch (e) {
      emit(state.copyWith(
          status: ErrorStatus(
              message: 'Couldn\'t fetch data from server, please connect to the internet and press Update button!',
              showShowEmptyState: true)));
    }
  }

  void fetchRates() async {
    try {
      final rates = await _currencyRepo.fetchListOfRates();
      emit(state.copyWith(rates: rates));
    } catch (e) {
      emit(state.copyWith(
          status: ErrorStatus(
              message: 'Couldn\'t fetch data from server, please connect to the internet and press Update button!',
              showShowEmptyState: true)));
    }
  }

  void calculateFrom(String amount, String fromAlpha3, String toAlpha3) {
    // Так как мы ограничены в возможностях АПИ,
    // то решено проводить конвертацию через Евро
    bool areValuesCorrected = _areCorrectedInputCurrencies(fromAlpha3, toAlpha3);

    double sum = _checkInputAmout(amount);

    if (areValuesCorrected) {
      final toEuroRate = state.rates.rates.firstWhere((element) => element.currency == fromAlpha3).rate;
      final inEuro = sum / toEuroRate;
      final fromEuroRate = state.rates.rates.firstWhere((element) => element.currency == toAlpha3).rate;
      final fromEuroToCurrency = inEuro * fromEuroRate;
      emit(state.copyWith(
          status: SuccessfulStatus(
        operationResultFrom: sum,
        operationResultTo: fromEuroToCurrency,
        isOperationFrom: true,
      )));
    }
  }

  void calculateTo(String amount, String fromAlpha3, String toAlpha3) {
    // Так как мы ограничены в возможностях АПИ,
    // то решено проводить конвертацию через Евро
    bool areValuesCorrected = _areCorrectedInputCurrencies(fromAlpha3, toAlpha3);
    double sum = _checkInputAmout(amount);

    if (areValuesCorrected) {
      final toEuroRate = state.rates.rates.firstWhere((element) => element.currency == toAlpha3).rate;
      final inEuro = sum * toEuroRate;
      final fromEuroRate = state.rates.rates.firstWhere((element) => element.currency == fromAlpha3).rate;
      final fromEuroToCurrency = inEuro * fromEuroRate;

      emit(state.copyWith(
          status: SuccessfulStatus(
        operationResultFrom: sum,
        operationResultTo: fromEuroToCurrency,
        isOperationFrom: false,
      )));
    }
  }

  double _checkInputAmout(String amount) {
    if (amount != '') {
      try {
        final sum = double.tryParse(amount);
        if (sum == null) {
          emit(state.copyWith(status: ErrorStatus(message: 'You have input wrong value!')));
          throw CustomException(reason: 'Wrong value', text: 'user put wrong value');
        } else {
          return sum;
        }
      } catch (e) {
        emit(state.copyWith(status: ErrorStatus(message: 'You have input wrong value!')));
        rethrow;
      }
    } else {
      return 0;
    }
  }

  bool _areCorrectedInputCurrencies(String fromAlpha3, String toAlpha3) {
    if (fromAlpha3.length != 3 && toAlpha3.length != 3) {
      emit(state.copyWith(status: ErrorStatus(message: 'Select both curencies!')));
      return false;
    }
    return true;
  }
}
