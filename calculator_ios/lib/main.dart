import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      title: '',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Builder(
          builder: (context) {
            return const Calculator();
          },
        ),
      ),
    ),
  );
}

class CalculatorButton extends StatelessWidget {
  const CalculatorButton({
    required this.buttonConfig,
    required this.highlight,
    super.key,
  });

  final ButtonConfig buttonConfig;
  final String highlight;

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor;
    final Color textColor;

    switch (buttonConfig.text) {
      case 'AC':
      case '+/-':
      case '%':
        backgroundColor = CupertinoColors.systemGrey3;
        textColor = CupertinoColors.black;
        break;
      case '÷':
      case 'x':
      case '-':
      case '+':
      case '=':
        if (buttonConfig.text == highlight) {
          backgroundColor = CupertinoColors.white;
          textColor = CupertinoColors.systemOrange;
        } else {
          backgroundColor = CupertinoColors.systemOrange;
          textColor = CupertinoColors.white;
        }
        break;
      default:
        backgroundColor = const Color(0xff333333);
        textColor = CupertinoColors.white;
    }

    return Padding(
      padding: const EdgeInsets.all(6.5),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: CupertinoColors.separator,
            width: 0.5,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50.0),
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            pressedOpacity: 0.8,
            onPressed: () => buttonConfig.action.call(),
            color: backgroundColor,
            child: Text(
              buttonConfig.text,
              style: TextStyle(
                fontSize: 36.0,
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String result = '0';
  String leftOperand = '';
  String rightOperand = '';
  double Function(double, double)? operation;
  String highlightOperator = '';

  late List<ButtonConfig> _buttons;

  void reset() {
    setState(() {
      result = '0';
      leftOperand = '';
      rightOperand = '';
      operation = null;
    });
  }

  void compute() {
    setState(() {
      result = operation!
          .call(
            double.parse(leftOperand.replaceAll(',', '.')),
            double.parse(rightOperand.replaceAll(',', '.')),
          )
          .toStringAsFixed(2);
      leftOperand = result;
      rightOperand = '';
      operation = null;
    });
  }

  void addOperand(double Function(double, double) operation) {
    if (leftOperand.isEmpty) {
      return;
    }
    if (rightOperand.isNotEmpty) {
      compute();
    }
    setState(() {
      this.operation = operation;
    });
  }

  void addNumber(String input) {
    highlightOperator = '';
    if (operation == null) {
      setState(() {
        leftOperand += input;
        result = leftOperand;
      });
    } else {
      setState(() {
        rightOperand += input;
        result = rightOperand;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _buttons = [
      ButtonConfig(text: 'AC', action: () => reset()),
      ButtonConfig(text: '+/-', action: () {}),
      ButtonConfig(text: '%', action: () {}),
      ButtonConfig(
        text: '÷',
        action: () {
          addOperand((p0, p1) => p0 / p1);
          setState(() => highlightOperator = '÷');
        },
      ),
      ButtonConfig(text: '7', action: () => addNumber('7')),
      ButtonConfig(text: '8', action: () => addNumber('8')),
      ButtonConfig(text: '9', action: () => addNumber('9')),
      ButtonConfig(
        text: 'x',
        action: () {
          addOperand((p0, p1) => p0 * p1);
          setState(() => highlightOperator = 'x');
        },
      ),
      ButtonConfig(text: '4', action: () => addNumber('4')),
      ButtonConfig(text: '5', action: () => addNumber('5')),
      ButtonConfig(text: '6', action: () => addNumber('6')),
      ButtonConfig(
        text: '-',
        action: () {
          addOperand((p0, p1) => p0 - p1);
          setState(() => highlightOperator = '-');
        },
      ),
      ButtonConfig(text: '1', action: () => addNumber('1')),
      ButtonConfig(text: '2', action: () => addNumber('2')),
      ButtonConfig(text: '3', action: () => addNumber('3')),
      ButtonConfig(
        text: '+',
        action: () {
          addOperand((p0, p1) => p0 + p1);
          setState(() => highlightOperator = '+');
        },
      ),
      ButtonConfig(text: '0', action: () => addNumber('0')),
      ButtonConfig(text: ',', action: () => addNumber(',')),
      ButtonConfig(
        text: '=',
        action: () => compute(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final int width = constraints.biggest.width.toInt();
        final int height = constraints.biggest.height.toInt();
        return Column(
          children: [
            Expanded(
              flex: height - (width * 1.25).toInt(),
              child: Container(
                padding: const EdgeInsets.all(24.0),
                alignment: Alignment.bottomRight,
                child: Text(
                  result,
                  style: const TextStyle(
                    fontSize: 90.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: (width * 1.25).toInt(),
              child: Column(
                children: [
                  Expanded(
                    flex: width.toInt(),
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: GridView.builder(
                        itemCount: _buttons.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                        ),
                        itemBuilder: (context, index) {
                          return CalculatorButton(
                            buttonConfig: _buttons[index],
                            highlight: highlightOperator,
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: (width * 0.25).toInt(),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: 2,
                          child: CalculatorButton(
                            buttonConfig: _buttons[_buttons.length - 3],
                            highlight: highlightOperator,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: CalculatorButton(
                            buttonConfig: _buttons[_buttons.length - 2],
                            highlight: highlightOperator,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: CalculatorButton(
                            buttonConfig: _buttons[_buttons.length - 1],
                            highlight: highlightOperator,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}

class ButtonConfig {
  const ButtonConfig({
    required this.text,
    required this.action,
  });

  final String text;
  final VoidCallback action;
}
