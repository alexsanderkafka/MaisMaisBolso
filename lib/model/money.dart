class Money{
  int? id;
  String _date;
  String _title;
  double _value;
  String _situationOfMoney;

  Money(this._date, this._title, this._value, this._situationOfMoney);

  Money.id(this.id, this._date, this._title, this._value, this._situationOfMoney);


  String get title => _title;

  set title(String value) {
    _title = value;
  }

  String get date => _date;

  set date(String value) {
    _date = value;
  }

  double get value => _value;

  String get situationOfMoney => _situationOfMoney;
}

abstract class MoneyDAOInterface{
  void save();
  List<dynamic> select();
  List<dynamic> selectWithMonth();
  List<dynamic> selectWithYear();
}