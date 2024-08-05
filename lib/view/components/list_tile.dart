import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maismaisbolso/model/money.dart';

import '../configs/colors_config.dart';

class ListTileSaveAndLoss extends StatelessWidget {
  final Money currentMoney;
  final int firstOfMonth;

  ListTileSaveAndLoss(
      {super.key, required this.currentMoney, required this.firstOfMonth});

  final NumberFormat _numberFormat = NumberFormat.currency(locale: 'pt-br', symbol: '', decimalDigits: 2);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: firstOfMonth == 0
          ? const EdgeInsets.only(top: 10)
          : const EdgeInsets.only(top: 15),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            if (currentMoney.situationOfMoney == "save")
              const Icon(
                Icons.call_received,
                color: ColorsConfig.colorSaveMoney,
              )
            else
              const Icon(
                Icons.call_made,
                color: ColorsConfig.colorLossMoney,
              ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      textAlign: TextAlign.left,
                      currentMoney.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      textAlign: TextAlign.left,
                      currentMoney.situationOfMoney == "save"
                          ? "Você guardou R\$ ${_numberFormat.format(currentMoney.value)}"
                          : "Você gastou R\$ ${_numberFormat.format(currentMoney.value)}",
                      style: const TextStyle(fontSize: 10),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
