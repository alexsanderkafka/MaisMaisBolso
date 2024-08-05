import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:maismaisbolso/dao/money_dao.dart';
import 'package:maismaisbolso/model/graph.dart';
import 'package:maismaisbolso/model/money.dart';
import 'package:maismaisbolso/view/components/list_tile.dart';
import 'package:maismaisbolso/view/components/text_field.dart';
import 'package:maismaisbolso/view/components/toggle_button.dart';
import 'package:maismaisbolso/view/configs/colors_config.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

import '../controller/controller_total.dart';
import '../controller/list_transaction.dart';

class ViewHome extends StatefulWidget {
  const ViewHome({super.key});

  @override
  State<ViewHome> createState() => _ViewHomeState();
}

enum OptionsOfMoney { save, loss }

class _ViewHomeState extends State<ViewHome> {
  bool initialPosition = true;
  int _toggleValue = 0;
  bool _openForm = false;
  MoneyDAO moneyDAO = MoneyDAO();
  OptionsOfMoney? _option = OptionsOfMoney.save;
  bool _validate = false;
  late double _total;
  late String _actualDate;
  final NumberFormat _numberFormat = NumberFormat.currency(locale: 'pt-br', symbol: '', decimalDigits: 2);

  final TextEditingController _textEditingControllerTitle =
      TextEditingController();
  final TextEditingController _textEditingControllerValue =
      TextEditingController();
  final MyTransaction controllerList = MyTransaction();
  final StoreTotal controllerTotal = StoreTotal();

  late Future<List<dynamic>> listToGraphMonth;

  @override
  void initState() {
    super.initState();
    controllerList.initialList();
    controllerTotal.initialTotal();

    DateFormat formatter = DateFormat('yyyy');
    _actualDate = formatter.format(DateTime.now()).toString();

    //moneyDAO.data();
  }

  Future<void> _saveMoney() async {
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    String title = _textEditingControllerTitle.text.toString();
    double value = double.parse(
        _textEditingControllerValue.text.toString().isNotEmpty
            ? _textEditingControllerValue.text.toString()
            : '0');
    String situation = _option.toString().split('.')[1].toString();
    String date = formatter.format(DateTime.now()).toString();

    Money money = Money(date, title, value, situation);

    if (title.isNotEmpty && value != 0.0) {
      controllerList.add(money);
      controllerTotal.initialTotal();
      _openForm = false;
    } else {
      _validate = true;
    }
    cleanFields();
  }

  void cleanFields() {
    _textEditingControllerValue.text = "";
    _textEditingControllerTitle.text = "";
  }

  Future<List<Graph>> _fillGraph() async {
    if(_toggleValue == 0) {
      List<Graph> data = await moneyDAO.selectToGraphMonth(_actualDate);

      for (Graph item in data) {
        int month = DateTime
            .parse(item.date)
            .month;

        List<String> monthNames = [
          "Jan",
          "Fev",
          "Mar",
          "Abr",
          "Mai",
          "Jun",
          "Jul",
          "Ago",
          "Set",
          "Out",
          "Nov",
          "Dez"
        ];

        item.date = monthNames[month - 1];
      }

      return data;
    }else{
      List<Graph> data = await moneyDAO.selectToGraphYear();

      for (Graph item in data) {
        var year = DateTime
            .parse(item.date)
            .year;

        item.date = year.toString();
        String value = _numberFormat.format(item.total);
        //item.total = value;

        //item.value = double.parse();
      }

      return data;
    }
  }

  String _fomatterDate(String date){
    DateFormat formatter = DateFormat('dd-MM-yyyy');
    String actualDateFomatted = formatter.format(DateTime.parse(date));

    return actualDateFomatted;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          resizeToAvoidBottomInset: false,
          body: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 330,
                decoration: const BoxDecoration(
                  color: ColorsConfig.yellowOne,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 100.0),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: Offset(0, 1),
                    )
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 218,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: Colors.white,
                          ),
                          margin: const EdgeInsets.only(
                            left: 14,
                            right: 14,
                            top: 71,
                            bottom: 40,
                          ),
                          child: FutureBuilder(
                            future: _fillGraph(),
                            builder: (context, snapshot) {
                              return SfCartesianChart(
                                title: ChartTitle(
                                  text: "Total: ${_numberFormat.format(controllerTotal.total)}",
                                  textStyle: TextStyle(
                                    color: controllerTotal.total >= 0 ? ColorsConfig.colorSaveMoney : ColorsConfig.colorLossMoney
                                  ),
                                ),
                                zoomPanBehavior: ZoomPanBehavior(
                                  enablePinching: true,
                                  zoomMode: ZoomMode.x,
                                  enablePanning: true,
                                  enableDoubleTapZooming: true,
                                ),
                                primaryXAxis: const CategoryAxis(
                                  autoScrollingDelta: 5,
                                  autoScrollingMode: AutoScrollingMode.start,
                                ),
                                series: [
                                  LineSeries<Graph, String>(
                                    dataSource: snapshot.data,
                                    xValueMapper: (Graph sales, _) =>
                                        sales.date,
                                    yValueMapper: (Graph sales, _) =>
                                        sales.total,
                                    dataLabelSettings: const DataLabelSettings(
                                      isVisible: true,
                                    ),
                                    dataLabelMapper: (Graph sales, _) => _numberFormat.format(sales.total),
                                    color: Colors.black,
                                  )
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              AnimatedToggle(
                values: const ["Mês", "Ano"],
                onToggleCallback: (value) {
                  setState(() {
                    _toggleValue = value;
                    if (value == 1) {
                      controllerList.alterList();
                    } else {
                      controllerList.initialList();
                    }
                  });
                },
                buttonColor: ColorsConfig.yellowOne,
                backgroundColor: ColorsConfig.yellowFive,
                textColor: const Color(0xFFFFFFFF),
              ),
              Flexible(
                child: FutureBuilder(
                  future: controllerList.listTransactions,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        padding: const EdgeInsets.only(left: 30, right: 30),
                        shrinkWrap: true,
                        itemCount: snapshot.data?.length,
                        itemBuilder: (BuildContext context, int index) {
                          var currentList = snapshot.data![index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 25, top: 25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _fomatterDate(snapshot.data![index][0].date),
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontFamily: "Roboto",
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (_toggleValue == 0)
                                  for (var currentMoney in currentList)
                                    ListTileSaveAndLoss(
                                      currentMoney: currentMoney,
                                      firstOfMonth: index,
                                    )
                                else
                                  for (var currentMoney in currentList)
                                    ListTileSaveAndLoss(
                                      currentMoney: currentMoney,
                                      firstOfMonth: index,
                                    )
                              ],
                            ),
                          );
                        },
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: ColorsConfig.yellowOne,
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: ColorsConfig.yellowOne,
            onPressed: () {
              setState(() {
                _openForm = true;
              });
            },
            child: const Icon(
              Icons.wallet,
              color: Colors.white,
            ),
          ),
        ),
        if (_openForm)
          Material(
            color: ColorsConfig.transparent,
            child: Container(
              margin: const EdgeInsets.only(
                  top: 150, bottom: 150, left: 20, right: 20),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 14, right: 14),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          color: Colors.black,
                          onPressed: () {
                            setState(
                              () {
                                _openForm = false;
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                          ),
                        ),
                        const Text(
                          "Título",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        MyTextField(
                          hintText: "Título",
                          controller: _textEditingControllerTitle,
                          inputType: TextInputType.text,
                          validate: _validate,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          "Valor",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        MyTextField(
                          hintText: "Valor",
                          controller: _textEditingControllerValue,
                          inputType: TextInputType.number,
                          validate: _validate,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Radio<OptionsOfMoney>(
                              value: OptionsOfMoney.save,
                              groupValue: _option,
                              fillColor: WidgetStateProperty.resolveWith<Color>(
                                (Set<WidgetState> states) {
                                  return ColorsConfig.yellowOne;
                                },
                              ),
                              onChanged: (OptionsOfMoney? value) {
                                setState(
                                  () {
                                    _option = value;
                                  },
                                );
                              },
                            ),
                            const Text(
                              "Guardou",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Radio<OptionsOfMoney>(
                              value: OptionsOfMoney.loss,
                              groupValue: _option,
                              fillColor: WidgetStateProperty.resolveWith<Color>(
                                (Set<WidgetState> states) {
                                  return ColorsConfig.yellowOne;
                                },
                              ),
                              activeColor: Colors.white,
                              onChanged: (OptionsOfMoney? value) {
                                setState(
                                  () {
                                    _option = value;
                                  },
                                );
                              },
                            ),
                            const Text(
                              "Gastou",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: SizedBox(
                            width: 300,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(
                                  () {
                                    _saveMoney();
                                  },
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorsConfig.yellowOne,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              child: const Text(
                                "Salvar",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
      ],
    );
  }
}
