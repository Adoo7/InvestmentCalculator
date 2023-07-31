import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConversionCard extends StatefulWidget {
  ConversionCard(
      {super.key,
      required this.buyPriceController,
      required this.sellPriceController,
      required this.qtyController,
      required this.numberChanged,
      required this.profit,
      required this.onQuantitySelected});

  final TextEditingController buyPriceController;
  final TextEditingController sellPriceController;
  final TextEditingController qtyController;
  final String profit;
  final VoidCallback numberChanged;
  final VoidCallback onQuantitySelected;

  @override
  State<ConversionCard> createState() => _ConversionCardState();
}

class _ConversionCardState extends State<ConversionCard> {
  double cardHeight = 300;
  double cardWidth = double.infinity;

  InputDecoration inputDecoration(text) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.cyanAccent,
      border: InputBorder.none,
      hintText: text,
    );
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController buyPrice = widget.buyPriceController;
    TextEditingController sellPrice = widget.sellPriceController;
    TextEditingController QTY = widget.qtyController;
    VoidCallback numberChanged = widget.numberChanged;
    VoidCallback quantitySelected = widget.onQuantitySelected;
    String profit = widget.profit;
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 60),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: CupertinoColors.systemCyan,
      ),
      height: cardHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          SizedBox(
            width: cardWidth,
            height: 60,
            child: TextField(
              cursorColor: Colors.cyanAccent,
              controller: buyPrice,
              onChanged: (text) {
                numberChanged();
              },
              keyboardType: TextInputType.number,
              decoration: inputDecoration('Buy Price'),
            ),
          ),
          SizedBox(
            width: cardWidth,
            height: 60,
            child: TextField(
              onTap: () {
                quantitySelected();
              },
              onChanged: (text) {
                numberChanged();
              },
              controller: QTY,
              keyboardType: TextInputType.number,
              decoration: inputDecoration('Quantity'),
            ),
          ),
          SizedBox(
            width: cardWidth,
            height: 60,
            child: TextField(
              onChanged: (text) {
                numberChanged();
              },
              controller: sellPrice,
              keyboardType: TextInputType.number,
              decoration: inputDecoration('Sell Price'),
            ),
          ),
          SizedBox(
            width: cardWidth,
            height: 30,
            child: Center(
              child: Text(
                profit,
                style: const TextStyle(fontSize: 22),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
