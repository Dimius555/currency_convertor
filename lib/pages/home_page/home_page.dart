import 'package:currency_convertor/config/app_colors.dart';
import 'package:currency_convertor/config/app_strings.dart';
import 'package:currency_convertor/config/app_text_styles.dart';
import 'package:currency_convertor/cubits/convertor/convertor_cubit.dart';
import 'package:currency_convertor/widgets/bottom_sheets/currencies_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController _fromController;
  late TextEditingController _toController;

  String _fromCurrency = 'Currency From';
  String _toCurrency = 'Currency To';

  @override
  void initState() {
    _fromController = TextEditingController();
    _toController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.accentColor,
        title: const Text(
          AppStrings.appBarTitle,
          style: AppTextStyles.appBarTextStyle,
        ),
        centerTitle: false,
      ),
      body: BlocConsumer<ConvertorCubit, ConvertorState>(
        listener: (context, state) {
          if (state.status is SuccessfulStatus) {
            final status = state.status as SuccessfulStatus;
            if (status.isOperationFrom) {
              _toController.text = status.operationResultTo == 0 ? '' : status.operationResultTo.toStringAsFixed(2);
            } else {
              _fromController.text = status.operationResultTo == 0 ? '' : status.operationResultTo.toStringAsFixed(2);
            }
          } else if (state.status is ErrorStatus) {
            final status = state.status as ErrorStatus;
            SnackBar snackBar = SnackBar(content: Text(status.message));
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        builder: (context, state) {
          if (state.status is ErrorStatus && (state.status as ErrorStatus).showShowEmptyState) {
            final message = (state.status as ErrorStatus).message;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      ConvertorCubit.read(context).initData();
                    },
                    child: const Text('Update'))
              ],
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 100.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('You send ${_fromCurrency.length > 3 ? '' : _fromCurrency}'),
                    TextField(
                      controller: _fromController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        hintText: 'Input amount ${_fromCurrency.length > 3 ? '' : 'of $_fromCurrency'} here',
                      ),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                      ], //
                      onChanged: (value) {
                        ConvertorCubit.read(context).calculateFrom(value, _fromCurrency, _toCurrency);
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (cntxt) {
                                return CurrenciesBottomSheet(
                                  onChanged: ((currency, alpha3) {
                                    setState(() {
                                      _fromCurrency = alpha3;
                                    });
                                    Navigator.pop(cntxt);
                                  }),
                                  selectedAlpha3: _fromCurrency,
                                );
                              });
                        },
                        child: Text(_fromCurrency)),
                    const Icon(
                      Icons.compare_arrows_outlined,
                      size: 32,
                      color: AppColors.accentColor,
                    ),
                    TextButton(
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (cntxt) {
                                return CurrenciesBottomSheet(
                                  onChanged: ((currency, alpha3) {
                                    setState(() {
                                      _toCurrency = alpha3;
                                    });
                                    Navigator.pop(cntxt);
                                  }),
                                  selectedAlpha3: _toCurrency,
                                );
                              });
                        },
                        child: Text(_toCurrency)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('They got ${_toCurrency.length > 3 ? '' : _toCurrency}'),
                    TextField(
                      controller: _toController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        hintText: 'Input amount ${_toCurrency.length > 3 ? '' : 'of $_toCurrency'} here',
                      ),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                      ],
                      onChanged: (value) {
                        ConvertorCubit.read(context).calculateTo(value, _fromCurrency, _toCurrency);
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
