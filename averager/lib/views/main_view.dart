import 'package:flutter/material.dart';
import 'package:averager/custom_widgets/conversion_card.dart';

class MainView extends StatefulWidget {
  const MainView({super.key, required this.title});

  final String title;

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int denomination = 3; //number of digits after decimal point

  String debugVariable = "debug";
  String _profitUSD = "0";
  String _profitBHD = "0";

  bool quantityFieldSelected = false;

  //USD Card Controllers
  final TextEditingController _buyPriceUSDController = TextEditingController();
  final TextEditingController _sellPriceUSDController = TextEditingController();
  final TextEditingController _investPriceUSDController =
      TextEditingController();

  //BHD Card Controllers
  final TextEditingController _buyPriceBHDController = TextEditingController();
  final TextEditingController _sellPriceBHDController = TextEditingController();
  final TextEditingController _investPriceBHDController =
      TextEditingController();

  //Quantity controller
  final TextEditingController _quantityController = TextEditingController();

  _quantitySelected() {
    quantityFieldSelected = false;
    print("Tapped into quantity");
  }

  void _numberChangedUSD() {
    //convert text into doubles for calculation
    double num1 = double.parse(_buyPriceUSDController.text);
    double num2 = double.parse(_sellPriceUSDController.text);
    double num3 = double.parse(_quantityController.text);

    //calculate profit in USD
    double profitUSD = (num2 - num1) * num3;

    //calculate starting investment price in USD
    double investPriceUSD = num1 * num3;

    //convert all fields to BHD
    double priceinBHD = profitUSD * 0.376;
    double buyPriceBHD = num1 * 0.376;
    double sellPriceBHD = num2 * 0.376;
    double investPriceBHD = investPriceUSD * 0.376;

    //convert all fields back into strings and set them to the controllers
    _investPriceUSDController.text =
        investPriceUSD.toStringAsFixed(denomination);
    _investPriceBHDController.text =
        investPriceBHD.toStringAsFixed(denomination);
    _buyPriceBHDController.text = buyPriceBHD.toStringAsFixed(denomination);
    _sellPriceBHDController.text = sellPriceBHD.toStringAsFixed(denomination);

    //change the Text widget that shows profit to the profit calculated both in BHD and USD
    setState(() {
      _profitUSD = profitUSD.toStringAsFixed(denomination);
      _profitBHD = priceinBHD.toStringAsFixed(denomination);
    });
  }

  void _numberChangedBHD() {
    print("____________");
    print("Number changed");

    //convert text into doubles for calculation
    double buyPriceBHD = double.parse(_buyPriceBHDController.text);
    double sellPriceBHD = double.parse(_sellPriceBHDController.text);
    double quantity;
    double investPriceBHD;

    if (!quantityFieldSelected) {
      //calculate quantity from investment price and buy price
      quantity = double.parse(_quantityController.text);
      investPriceBHD = buyPriceBHD * quantity;
      print("CHANGE IN QUANTITY FIELD");
    } else {
      //calculate starting investment price in BHD
      investPriceBHD = double.parse(_investPriceBHDController.text);
      quantity = buyPriceBHD * investPriceBHD;
      print("CHANGE IN PRICE FIELD");
    }

    //calculate profit in BHD
    double profitBHD = (sellPriceBHD - buyPriceBHD) * quantity;

    //convert all fields to USD
    double profitUSD = profitBHD * 2.65957;
    double buyPriceUSD = buyPriceBHD * 2.65957;
    double sellPriceUSD = sellPriceBHD * 2.65957;
    double investPriceUSD = investPriceBHD * 2.65957;

    //convert all fields back into strings and set them to the controllers
    _buyPriceUSDController.text = buyPriceUSD.toStringAsFixed(denomination);
    _sellPriceUSDController.text = sellPriceUSD.toStringAsFixed(denomination);
    _investPriceUSDController.text =
        investPriceUSD.toStringAsFixed(denomination);
    if (!quantityFieldSelected) {
      _investPriceBHDController.text =
          investPriceBHD.toStringAsFixed(denomination);
    } else {
      _quantityController.text = quantity.toStringAsFixed(denomination);
    }

    //change the Text widget that shows profit to the profit calculated both in BHD and USD
    setState(() {
      _profitUSD = profitUSD.toStringAsFixed(denomination);
      _profitBHD = profitBHD.toStringAsFixed(denomination);
      debugVariable = quantity.toStringAsFixed(denomination);
    });
  }

  @override
  void dispose() {
    _buyPriceUSDController.dispose();
    _sellPriceUSDController.dispose();
    _buyPriceBHDController.dispose();
    _sellPriceBHDController.dispose();
    _investPriceUSDController.dispose();
    _investPriceBHDController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          const Text("USD"),
          ConversionCard(
            buyPriceController: _buyPriceUSDController,
            sellPriceController: _sellPriceUSDController,
            qtyController: _quantityController,
            numberChanged: _numberChangedUSD,
            profit: _profitUSD,
            onQuantitySelected: _quantitySelected,
          ),
          SizedBox(
            width: 100,
            height: 60,
            child: TextField(
              controller: _investPriceUSDController,
              onTap: () {
                quantityFieldSelected = true;
              },
              onChanged: (text) {
                _numberChangedUSD();
              },
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                hintText: 'Investment Price',
              ),
            ),
          ),
          const Spacer(),
          const Text("BHD"),
          ConversionCard(
            buyPriceController: _buyPriceBHDController,
            sellPriceController: _sellPriceBHDController,
            qtyController: _quantityController,
            numberChanged: _numberChangedBHD,
            profit: _profitBHD,
            onQuantitySelected: _quantitySelected,
          ),
          SizedBox(
            width: 100,
            height: 60,
            child: TextField(
              controller: _investPriceBHDController,
              onTap: () {
                quantityFieldSelected = true;
              },
              onChanged: (text) {
                _numberChangedBHD();
              },
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                hintText: 'Investment Price',
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
