// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_transaction.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MyTransaction on ListTransaction, Store {
  late final _$listTransactionsAtom =
      Atom(name: 'ListTransaction.listTransactions', context: context);

  @override
  Future<List<dynamic>>? get listTransactions {
    _$listTransactionsAtom.reportRead();
    return super.listTransactions;
  }

  @override
  set listTransactions(Future<List<dynamic>>? value) {
    _$listTransactionsAtom.reportWrite(value, super.listTransactions, () {
      super.listTransactions = value;
    });
  }

  late final _$ListTransactionActionController =
      ActionController(name: 'ListTransaction', context: context);

  @override
  void initialList() {
    final _$actionInfo = _$ListTransactionActionController.startAction(
        name: 'ListTransaction.initialList');
    try {
      return super.initialList();
    } finally {
      _$ListTransactionActionController.endAction(_$actionInfo);
    }
  }

  @override
  void add(Money money) {
    final _$actionInfo = _$ListTransactionActionController.startAction(
        name: 'ListTransaction.add');
    try {
      return super.add(money);
    } finally {
      _$ListTransactionActionController.endAction(_$actionInfo);
    }
  }

  @override
  void alterList() {
    final _$actionInfo = _$ListTransactionActionController.startAction(
        name: 'ListTransaction.alterList');
    try {
      return super.alterList();
    } finally {
      _$ListTransactionActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
listTransactions: ${listTransactions}
    ''';
  }
}
