import 'dart:async';
import 'dart:math';

import 'package:flutter_default_state_manager/bloc_pattern/imc_state.dart';

class BlocPatternController {
  final _imcStreamController = StreamController<ImcState>.broadcast()
    ..add(ImcState(imc: 0.0));

  Stream<ImcState> get imcOut => _imcStreamController.stream;

  Future<void> calcularImc(
      {required double peso, required double altura}) async {
    try {
      _imcStreamController.add(ImcStateLoading());
      await Future.delayed(const Duration(seconds: 1));
      final imc = peso / pow(altura, 2);
      _imcStreamController.add(ImcState(imc: imc));
    } on Exception catch (e) {
      _imcStreamController.add(ImcStateError(message: 'Erro ao Calcular IMC '));
    }
  }

  void dispose() {
    _imcStreamController.close();
  }
}
