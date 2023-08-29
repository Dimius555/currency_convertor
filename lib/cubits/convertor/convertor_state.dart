part of 'convertor_cubit.dart';

class ConvertorState {
  final List<CurrencyModel> currencies;
  final Rates rates;
  final ConvertorStatus status;

  ConvertorState({
    required this.status,
    required this.currencies,
    required this.rates,
  });

  ConvertorState copyWith({
    Rates? rates,
    List<CurrencyModel>? currencies,
    ConvertorStatus? status,
  }) {
    return ConvertorState(
      currencies: currencies ?? this.currencies,
      rates: rates ?? this.rates,
      status: status ?? this.status,
    );
  }
}

abstract interface class ConvertorStatus {}

class InitialStatus extends ConvertorStatus {}

class LoadingDataStatus extends ConvertorStatus {}

class SuccessfulStatus extends ConvertorStatus {
  final double operationResultFrom;
  final double operationResultTo;
  final bool isOperationFrom;

  SuccessfulStatus({
    required this.operationResultFrom,
    required this.operationResultTo,
    required this.isOperationFrom,
  });

  SuccessfulStatus copyWith(
      {Rates? rates,
      List<CurrencyModel>? currencies,
      double? operationResultFrom,
      double? operationResultTo,
      bool? isOperationFrom}) {
    return SuccessfulStatus(
      operationResultFrom: operationResultFrom ?? this.operationResultFrom,
      operationResultTo: operationResultTo ?? this.operationResultTo,
      isOperationFrom: isOperationFrom ?? this.isOperationFrom,
    );
  }
}

class ErrorStatus extends ConvertorStatus {
  final String message;
  final bool showShowEmptyState;

  ErrorStatus({required this.message, this.showShowEmptyState = false});
}
