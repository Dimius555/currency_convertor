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
        super(ConvertorState());

  final CurrencyRepository _currencyRepo;

  test() {
    _currencyRepo.test();
  }
}
