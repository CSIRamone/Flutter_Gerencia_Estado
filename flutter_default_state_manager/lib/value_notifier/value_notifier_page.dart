import 'dart:math';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_default_state_manager/widgets/imc_gauge.dart';
import 'package:intl/intl.dart';

class ValueNotifierPage extends StatefulWidget {
  const ValueNotifierPage({Key? key}) : super(key: key);

  @override
  State<ValueNotifierPage> createState() => _ValueNotifierPage();
}

class _ValueNotifierPage extends State<ValueNotifierPage> {
  final pesoEC = TextEditingController();
  final alturaEC = TextEditingController();
  final formKey = GlobalKey<FormState>();

  var imc = ValueNotifier(0.0);

  Future<void> _calcularImc(
      {required double peso, required double altura}) async {
    imc.value = 0.0;

    await Future.delayed(const Duration(seconds: 1));

    imc.value = peso / pow(altura, 2);
  }

  @override
  void dispose() {
    pesoEC.dispose();
    alturaEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Value Notifier'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              ValueListenableBuilder<double>(
                valueListenable: imc,
                builder: (_, imcValue, __) {
                  return ImcGauge(imc: imcValue);
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: pesoEC,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Peso'),
                inputFormatters: [
                  CurrencyTextInputFormatter.currency(
                    locale: 'pt_BR',
                    symbol: '',
                    turnOffGrouping: true,
                    decimalDigits: 2,
                  )
                ],
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Peso Obrigatório';
                  }
                },
              ),
              TextFormField(
                  controller: alturaEC,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Altura'),
                  inputFormatters: [
                    CurrencyTextInputFormatter.currency(
                      locale: 'pt_BR',
                      symbol: '',
                      turnOffGrouping: true,
                      decimalDigits: 2,
                    )
                  ],
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Altura Obrigatório';
                    }
                  }),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    var formValid = formKey.currentState?.validate() ?? false;

                    if (formValid) {
                      var formatter = NumberFormat.simpleCurrency(
                        locale: 'pt_BR',
                        decimalDigits: 2,
                      );
                      double peso = formatter.parse(pesoEC.text) as double;
                      double altura = formatter.parse(alturaEC.text) as double;

                      _calcularImc(peso: peso, altura: altura);
                    }
                  },
                  child: const Text('Calcular IMC'))
            ],
          ),
        ),
      ),
    );
  }
}
