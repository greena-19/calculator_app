
import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator State Lab',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
        useMaterial3: true,
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() =>
      _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _input = '0';
  double? _accumulator;
  String? _operator;
  bool _awaitingOperand = false;
  bool _justEvaluated = false;
  String? _error;

  final List<String> _history = [];
  final List<double> _historyResults = [];

  String get _display => _error ?? _input;

  String _format(double value) {
    if (!value.isFinite) return 'Error';
    if (value == 0) return '0';

    String text = value.toString();

    if (text.endsWith('.0')) {
      text = text.substring(0, text.length - 2);
    }

    return text;
  }

  void _resetCalculation() {
    _input = '0';
    _accumulator = null;
    _operator = null;
    _awaitingOperand = false;
    _justEvaluated = false;
    _error = null;
  }

  void _clear() {
    setState(_resetCalculation);
  }

  void _setError(String message) {
    _error = message;
    _input = '0';
    _accumulator = null;
    _operator = null;
    _awaitingOperand = false;
    _justEvaluated = false;
  }

  void _enterDigit(String digit) {
    setState(() {
      if (_error != null || _justEvaluated) {
        _resetCalculation();
      }

      if (_awaitingOperand) {
        _input = digit;
        _awaitingOperand = false;
      } else if (_input == '0') {
        _input = digit;
      } else if (_input == '-0') {
        _input = '-$digit';
      } else {
        _input += digit;
      }
    });
  }

  void _enterDecimal() {
    setState(() {
      if (_error != null || _justEvaluated) {
        _resetCalculation();
      }

      if (_awaitingOperand) {
        _input = '0.';
        _awaitingOperand = false;
      } else if (!_input.contains('.')) {
        _input += '.';
      }
    });
  }

  double? _calculate(
    double first,
    double second,
    String operation,
  ) {
    double result;

    switch (operation) {
      case '+':
        result = first + second;
        break;
      case '−':
        result = first - second;
        break;
      case '×':
        result = first * second;
        break;
      case '÷':
        if (second == 0) {
          _setError('Cannot divide by zero');
          return null;
        }
        result = first / second;
        break;
      default:
        return null;
    }

    if (!result.isFinite) {
      _setError('Number overflow');
      return null;
    }

    return result;
  }

  void _chooseOperator(String nextOperator) {
    setState(() {
      if (_error != null) return;

      final current = double.tryParse(_input);

      if (current == null) {
        _setError('Invalid number');
        return;
      }

      if (_operator != null && !_awaitingOperand) {
        final result = _calculate(
          _accumulator!,
          current,
          _operator!,
        );

        if (result == null) return;

        _accumulator = result;
        _input = _format(result);
      } else if (_accumulator == null || _justEvaluated) {
        _accumulator = current;
      }

      _operator = nextOperator;
      _awaitingOperand = true;
      _justEvaluated = false;
    });
  }

  void _equals() {
    setState(() {
      if (_error != null) return;

      // Equals without a new operand is ignored.
      if (_operator == null || _awaitingOperand) {
        return;
      }

      final second = double.tryParse(_input);

      if (second == null || _accumulator == null) {
        _setError('Incomplete calculation');
        return;
      }

      final first = _accumulator!;
      final operation = _operator!;

      final result = _calculate(
        first,
        second,
        operation,
      );

      if (result == null) return;

      final expression =
          '${_format(first)} $operation ${_format(second)}'
          ' = ${_format(result)}';

      _history.insert(0, expression);
      _historyResults.insert(0, result);

      _input = _format(result);
      _accumulator = null;
      _operator = null;
      _awaitingOperand = false;
      _justEvaluated = true;
    });
  }

  void _backspace() {
    setState(() {
      if (_error != null) {
        _resetCalculation();
        return;
      }

      if (_awaitingOperand) {
        // Cancel the pending operator.
        _operator = null;
        _accumulator = null;
        _awaitingOperand = false;
        return;
      }

      if (_justEvaluated) {
        _justEvaluated = false;
        _accumulator = null;
        _operator = null;
      }

      if (_input.length <= 1 ||
          (_input.length == 2 && _input.startsWith('-'))) {
        _input = '0';
      } else {
        _input = _input.substring(0, _input.length - 1);
      }

      if (_input == '-' || _input.isEmpty) {
        _input = '0';
      }
    });
  }

  void _clearHistory() {
    setState(() {
      _history.clear();
      _historyResults.clear();
    });
  }

  void _reuseHistory(int index) {
    setState(() {
      _resetCalculation();
      _input = _format(_historyResults[index]);
      _justEvaluated = true;
    });
  }

  void _handleButton(String value) {
    if (RegExp(r'^[0-9]$').hasMatch(value)) {
      _enterDigit(value);
    } else if (value == '.') {
      _enterDecimal();
    } else if (['+', '−', '×', '÷'].contains(value)) {
      _chooseOperator(value);
    } else if (value == '=') {
      _equals();
    } else if (value == 'AC') {
      _clear();
    } else if (value == '⌫') {
      _backspace();
    }
  }

  Widget _buildButton(String label) {
    final isOperator =
        ['+', '−', '×', '÷', '='].contains(label);

    final isAction = label == 'AC' || label == '⌫';

    Color background;

    if (label == '=') {
      background = Colors.indigo;
    } else if (isOperator) {
      background = Colors.indigo.shade100;
    } else if (isAction) {
      background = Colors.orange.shade100;
    } else {
      background = Colors.grey.shade200;
    }

    return Padding(
      padding: const EdgeInsets.all(3),
      child: Material(
        color: background,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => _handleButton(label),
          onLongPress: label == '⌫' ? _clear : null,
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                color: label == '='
                    ? Colors.white
                    : Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const buttons = [
      'AC', '⌫', '÷', '×',
      '7', '8', '9', '−',
      '4', '5', '6', '+',
      '1', '2', '3', '=',
      '0', '.', 
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator State Lab'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final narrow = constraints.maxWidth < 380;

            return Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _operator == null
                            ? 'READY'
                            : 'Pending: $_operator',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Semantics(
                        liveRegion: true,
                        label: 'Calculator display: $_display',
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: Text(
                            _display,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: narrow ? 38 : 48,
                              fontWeight: FontWeight.bold,
                              color: _error == null
                                  ? Colors.black87
                                  : Colors.red,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Left-to-right calculation mode',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
                    child: Column(
                      children: [
                        for (int row = 0; row < 4; row++)
                          Expanded(
                            child: Row(
                              children: [
                                for (int col = 0; col < 4; col++)
                                  Expanded(
                                    child: _buildButton(
                                      buttons[row * 4 + col],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: _buildButton('0'),
                              ),
                              Expanded(
                                child: _buildButton('.'),
                              ),
                              const Expanded(
                                child: SizedBox(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(),
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Calculation History',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: _clearHistory,
                              child: const Text('Clear History'),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: _history.isEmpty
                            ? const Center(
                                child: Text(
                                  'No calculations yet',
                                ),
                              )
                            : ListView.builder(
                                itemCount: _history.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(_history[index]),
                                    trailing: const Icon(
                                      Icons.history,
                                    ),
                                    onTap: () =>
                                        _reuseHistory(index),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
