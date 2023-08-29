import 'package:currency_convertor/config/app_colors.dart';
import 'package:flutter/material.dart';

class CurrencyButton extends StatelessWidget {
  const CurrencyButton({
    super.key,
    required this.currency,
    required this.onPressed,
    required this.alpha3,
    required this.selectedAlpha3,
  });

  final String currency;
  final Function onPressed;
  final String alpha3;
  final String selectedAlpha3;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onPressed.call();
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 14, bottom: 14, left: 1),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: Radio(
                        activeColor: AppColors.accentColor,
                        value: alpha3,
                        groupValue: selectedAlpha3,
                        onChanged: (v) {
                          onPressed.call();
                        }),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    currency,
                  ),
                  const Spacer(),
                  Text(
                    alpha3,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            const Divider(height: 3)
          ],
        ),
      ),
    );
  }
}
