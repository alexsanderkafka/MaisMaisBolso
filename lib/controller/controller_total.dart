import 'package:mobx/mobx.dart';

import '../dao/money_dao.dart';

part 'controller_total.g.dart';

class StoreTotal = ControllerTotal with _$StoreTotal;

abstract class ControllerTotal with Store{

  @observable
  double total = 0;

  final MoneyDAO dao = MoneyDAO();

  @action
  Future<void> initialTotal() async{
    total = await dao.selectValueTotal();
    //print("Total mobx: $total");
  }

}