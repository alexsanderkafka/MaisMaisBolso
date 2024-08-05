class Graph{
  String _date;
  double _total;

  Graph(this._date, this._total);

  double get total => _total;

  set total(double value) {
    _total = value;
  }

  String get date => _date;

  set date(String value) {
    _date = value;
  }
}