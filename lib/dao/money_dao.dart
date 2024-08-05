import 'dart:async';

import 'package:maismaisbolso/dao/helper/convert.dart';
import 'package:maismaisbolso/dao/helper/db.dart';
import 'package:maismaisbolso/model/graph.dart';
import 'package:sqflite/sqflite.dart';

import '../model/money.dart';
import 'package:intl/intl.dart';

class MoneyDAO{

  late Database db;

  void save(Money money) async{
    db = await DB.instance.database;
    db.insert("money", {
      "title": money.title,
      "date_money": money.date,
      "value": money.value,
      "situation_of_money": money.situationOfMoney
    }
    );
  }

  Future<List<dynamic>> selectMoneyMonth() async{
    db = await DB.instance.database;
    List<Money> money = [];

    String query = '''
        SELECT *
          FROM money
          ORDER BY id DESC
    ''';

    var listResponse = await db.rawQuery(query);

    for(var response in listResponse){
      Money moneyResponse = Convert.mapToMoney(response);
      money.add(moneyResponse);
    }

    Map<String, List<Money>> mapOfMoney = {};

    for (var value in money) {
      if(mapOfMoney.containsKey(value.date.toString())){
        mapOfMoney[value.date.toString()]?.add(value);
      }
      else{
        mapOfMoney[value.date.toString()] = [value];
      }
    }

    var listFinal = [];

    mapOfMoney.forEach((k, v){
      listFinal.add(v);
    });

    return listFinal;
  }

  Future<List<dynamic>> selectMoneyYear() async{
    db = await DB.instance.database;
    List<Money> money = [];

    String query = '''
        SELECT *
          FROM money
          ORDER BY id DESC
    ''';

    var listResponse = await db.rawQuery(query);

    for(var response in listResponse){
      Money moneyResponse = Convert.mapToMoney(response);
      money.add(moneyResponse);
    }

    Map<String, List<Money>> mapOfMoney = {};

    for (var value in money) {
      DateFormat formatter = DateFormat('yyyy-MM-dd');
      String date = formatter.format(DateTime.parse(value.date));
      DateTime actualDate = DateTime.parse(date);

      String key = actualDate.year.toString();

      if(mapOfMoney.containsKey(key)){
        mapOfMoney[key]?.add(value);
      }
      else{
        mapOfMoney[key] = [value];
      }
    }

    var listFinal = [];

    mapOfMoney.forEach((k, v){
      listFinal.add(v);
    });

    return listFinal;
  }

  Future<List<Graph>> selectToGraphMonth(String date) async{
    db = await DB.instance.database;

    print("Data: $date");

    String query = '''
         SELECT 
            date_money,
            SUM(CASE
                WHEN situation_of_money = 'save' THEN value
                WHEN situation_of_money = 'loss' THEN -value
                ELSE 0
            END) AS total
         FROM
            money
         WHERE
            strftime('%Y', date_money) = strftime('%Y', 'now')
         GROUP BY
             strftime('%m', date_money)
    ''';

    var listResponse = await db.rawQuery(query);
    List<Graph> graphs = [];

    for(var item in listResponse){
      graphs.add(Convert.mapToGraph(item));
    }

    return graphs;
  }

  Future<List<Graph>> selectToGraphYear() async{
    db = await DB.instance.database;

    String query = '''
         SELECT 
            date_money,
            SUM(CASE
                WHEN situation_of_money = 'save' THEN value
                WHEN situation_of_money = 'loss' THEN -value
                ELSE 0
            END) AS total
         FROM
            money
         GROUP BY
             strftime('%Y', date_money)
    ''';

    var listResponse = await db.rawQuery(query);
    List<Graph> graphs = [];

    for(var item in listResponse){
      graphs.add(Convert.mapToGraph(item));
    }

    return graphs;
  }

  Future<double> selectValueTotal() async{
    db = await DB.instance.database;

    String query = '''
         SELECT 
          SUM(CASE 
            WHEN situation_of_money = 'save' THEN value
            WHEN situation_of_money = 'loss' THEN -value
            ELSE 0
          END) AS total
          FROM 
            money
    ''';

    var listResponse = await db.rawQuery(query);

    String result = listResponse[0]['total'].toString();

    return double.parse(result);
  }


  data() async {
    db = await DB.instance.database;

    String query = '''
    INSERT INTO money (title, date_money, value, situation_of_money) VALUES
        ('Compra', '2023-01-15', 500.00, 'save'),
        ('Venda', '2023-01-20', 50.00, 'loss'),
        ('Dinheiro Extra', '2023-02-15', 700.00, 'save'),
        ('Investimento', '2023-02-20', 1000.00, 'loss'),
        ('Salário', '2023-03-15', 900.00, 'save'),
        ('Freelance', '2023-03-20', 100.00, 'loss'),
        ('Prêmio', '2023-04-15', 1100.00, 'save'),
        ('Bônus', '2023-04-20', 400, 'loss'),
        ('Reembolso', '2023-05-15', 1300.00, 'save'),
        ('Presente', '2023-05-20', 1400.00, 'loss'),
        ('Aluguel', '2023-06-15', 1500.00, 'save'),
        ('Dividendos', '2023-06-20', 100, 'loss'),
        ('Compra', '2023-07-15', 1000.00, 'save'),
        ('Venda', '2023-07-20', 1800.00, 'loss'),
        ('Dinheiro Extra', '2023-08-15', 100.00, 'save'),
        ('Investimento', '2023-08-20', 1000.00, 'loss'),
        ('Salário', '2023-09-15', 2100.00, 'save'),
        ('Freelance', '2023-09-20', 2200.00, 'loss'),
        ('Prêmio', '2023-10-15', 2300.00, 'save'),
        ('Bônus', '2023-10-20', 2400.00, 'loss'),
        ('Reembolso', '2023-11-15', 2500.00, 'save'),
        ('Presente', '2023-11-20', 2600.00, 'loss'),
        ('Aluguel', '2023-12-15', 2700.00, 'save'),
        ('Dividendos', '2023-12-20', 2800.00, 'loss')
    ''';

    db.rawQuery(query);
  }
}