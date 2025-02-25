import 'dart:ffi';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_default_state_manager/bloc_pattern/bloc_pattern_controller.dart';
import 'package:flutter_default_state_manager/bloc_pattern/imc_state.dart';
import 'package:flutter_default_state_manager/widgets/imc_gauge.dart';
import 'package:intl/intl.dart';

class BlocPatternPage extends StatefulWidget {
  const BlocPatternPage({Key? key}) : super(key: key);

  @override
  State<BlocPatternPage> createState() => _BlocPatternPageState();
}

class _BlocPatternPageState extends State<BlocPatternPage> {
  final controller = BlocPatternController();
  final formKey = GlobalKey<FormState>();
  final pesoEC = TextEditingController();
  final alturaEC = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    pesoEC.dispose();
    alturaEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IMC Bloc Pattern (Stream)'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              StreamBuilder<ImcState>(
                stream: controller.imcOut,
                builder: (context, snapshot) {
                  var imc = 0.0;
                  if (snapshot.hasData) {
                    imc = snapshot.data?.imc ?? 0.0;
                  }
                  return ImcGauge(imc: imc);
                },
              ),
              const SizedBox(
                height: 20,
              ),
              StreamBuilder(
                  stream: controller.imcOut,
                  builder: (context, snapshot) {
                    final dataValue = snapshot.data;

                    if (dataValue is ImcStateLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (dataValue is ImcStateError) {
                      return Text(dataValue.message);
                    }

                    return const SizedBox.shrink();
                  }),
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

                      controller.calcularImc(peso: peso, altura: altura);
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
