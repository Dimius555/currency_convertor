import 'package:currency_convertor/config/app_colors.dart';
import 'package:currency_convertor/cubits/convertor/convertor_cubit.dart';
import 'package:currency_convertor/widgets/currency_button.dart';
import 'package:flutter/material.dart';

class CurrenciesBottomSheet extends StatefulWidget {
  final String? selectedAlpha3;
  final Function(String currency, String alpha3) onChanged;

  const CurrenciesBottomSheet({
    super.key,
    required this.selectedAlpha3,
    required this.onChanged,
  });

  @override
  State<CurrenciesBottomSheet> createState() => _CurrenciesBottomSheetState();
}

class _CurrenciesBottomSheetState extends State<CurrenciesBottomSheet> {
  String _selectedAlpha3 = '';
  String _searchText = '';
  late final TextEditingController _countryController;

  void _updateSearchText(String newText) {
    setState(() {
      _searchText = newText;
    });
  }

  @override
  void initState() {
    _selectedAlpha3 = widget.selectedAlpha3 ?? '';
    _countryController = TextEditingController(text: _searchText);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ConvertorCubit.watchState(context);
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.notchColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(3),
                ),
              ),
              height: 6,
              width: 33,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: _updateSearchText,
              decoration: const InputDecoration(hintText: 'Input currency'),
              controller: _countryController,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: state.currencies.length,
              itemBuilder: (context, index) {
                final currency = state.currencies[index];
                // Фильтруем валюты по поисковому запросу
                if (_searchText.isNotEmpty &&
                    !currency.alpha3.toLowerCase().contains(_searchText.toLowerCase()) &&
                    !currency.name.toLowerCase().contains(_searchText.toLowerCase())) {
                  // Прячем элементы, которые не соответствуют поиску
                  return const SizedBox.shrink();
                }
                return CurrencyButton(
                  currency: currency.name,
                  onPressed: () {
                    widget.onChanged(currency.name, currency.alpha3);
                  },
                  alpha3: currency.alpha3,
                  selectedAlpha3: _selectedAlpha3,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
