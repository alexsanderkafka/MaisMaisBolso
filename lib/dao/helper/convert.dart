import '../../model/graph.dart';
import '../../model/money.dart';

abstract class Convert{
  static Money mapToMoney(Map<String, dynamic> data){
    int id = data['id'];
    String title = data['title'];
    String date = data['date_money'];
    double value = data['value'];
    String situation = data['situation_of_money'];

    Money actualMoney = Money.id(id, date, title, value, situation);

    return actualMoney;
  }

  static Graph mapToGraph(Map<String, dynamic> data){
    String date = data["date_money"];
    double total = data["total"];

    Graph graph = Graph(date, total);

    return graph;
  }

}