import 'package:maismaisbolso/controller/controller_total.dart';
import 'package:maismaisbolso/dao/money_dao.dart';
import 'package:maismaisbolso/model/money.dart';
import 'package:mobx/mobx.dart';

part 'list_transaction.g.dart';

class MyTransaction = ListTransaction with _$MyTransaction;

abstract class ListTransaction with Store{
  @observable
  Future<List<dynamic>>? listTransactions;

  final MoneyDAO dao = MoneyDAO();
  final StoreTotal controllerTotal = StoreTotal();


  @action
  void initialList(){
    listTransactions = dao.selectMoneyMonth();
  }

  @action
  void add(Money money){
    dao.save(money);
    initialList();
  }

  @action
  void alterList(){
    listTransactions = dao.selectMoneyYear();
  }

}