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
  double cardWidth = 140;

  InputDecoration inputDecoration(text) {
    return InputDecoration(
        filled: true,
        fillColor: const Color(0xFFD2F4F6),
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        hintText: text,
        hintStyle: const TextStyle(color: Colors.black));
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
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: const Color(0xFF7EC2FF),
      ),
      height: cardHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Buy Price',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 12,
            ),
          ),
          SizedBox(
            width: cardWidth,
            height: 60,
            child: TextField(
              controller: buyPrice,
              onChanged: (text) {
                numberChanged();
              },
              keyboardType: TextInputType.number,
              decoration: inputDecoration('Buy Price'),
            ),
          ),
          const Text(
            'Quantity',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 12,
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
          const Text(
            'Sell Price',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 12,
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
