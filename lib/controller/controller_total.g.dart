// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'controller_total.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$StoreTotal on ControllerTotal, Store {
  late final _$totalAtom =
      Atom(name: 'ControllerTotal.total', context: context);

  @override
  double get total {
    _$totalAtom.reportRead();
    return super.total;
  }

  @override
  set total(double value) {
    _$totalAtom.reportWrite(value, super.total, () {
      super.total = value;
    });
  }

  late final _$initialTotalAsyncAction =
      AsyncAction('ControllerTotal.initialTotal', context: context);

  @override
  Future<void> initialTotal() {
    return _$initialTotalAsyncAction.run(() => super.initialTotal());
  }

  @override
  String toString() {
    return '''
total: ${total}
    ''';
  }
}
