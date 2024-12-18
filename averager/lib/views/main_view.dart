import 'dart:convert' as convert;

import 'package:averager/custom_widgets/conversion_card.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

final formatCurrency = new NumberFormat.simpleCurrency();

class MainView extends StatefulWidget {
  const MainView({super.key, required this.title});

  final String title;

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  Color textColor = const Color(0xFFFFFFFF);

  int denomination = 3; //number of digits after decimal point

  String debugVariable = "debug";
  String card1Profit = "0";
  String card2Profit = "0";

  bool quantityFieldSelected = true;

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
    quantityFieldSelected = true;
    print("Tapped into quantity");
  }

  (String, String) updateCards(
      {required TextEditingController buyPriceController1,
      required TextEditingController sellPriceController1,
      required TextEditingController investPriceController1,
      required String realProfit1,
      required TextEditingController buyPriceController2,
      required TextEditingController sellPriceController2,
      required TextEditingController investPriceController2,
      required String realProfit2,
      required TextEditingController quantityController,
      required double conversionRate}) {
    print("____________");
    print("Number changed");

    //convert text into doubles for calculation
    double buyPrice1 = buyPriceController1.text.isNotEmpty
        ? double.parse(buyPriceController1.text)
        : 0.0;
    double sellPrice1 = sellPriceController1.text.isNotEmpty
        ? double.parse(sellPriceController1.text)
        : 0.0;
    double quantity;
    double investPrice1;

    if (quantityFieldSelected) {
      //calculate quantity from investment price and buy price
      if (quantityController.text.isNotEmpty) {
        var tryQuantity = double.tryParse(quantityController.text);
        quantity = tryQuantity ?? 0.0;
        if (quantity.isInfinite || quantity.isNaN) {
          quantity = 0.0;
        }
      } else {
        quantity = 0.0;
      }
      if (buyPrice1 != 0.0) {
        investPrice1 = buyPrice1 * quantity;
      } else {
        investPrice1 = 0.0;
      }
      investPrice1 = buyPrice1 * quantity;
      print("CHANGE IN QUANTITY FIELD");
    } else {
      //calculate starting investment price in BHD
      investPrice1 = double.parse(investPriceController1.text);
      quantity = investPrice1 / buyPrice1;
      print("CHANGE IN PRICE FIELD");
    }

    //calculate profit in BHD
    double profit1 = (sellPrice1 - buyPrice1) * quantity;
    //2.65957
    //convert all fields to USD
    double profit2 = profit1 * conversionRate;
    double buyPrice2 = buyPrice1 * conversionRate;
    double sellPrice2 = sellPrice1 * conversionRate;
    double investPrice2 = investPrice1 * conversionRate;

    //convert all fields back into strings and set them to the controllers
    buyPriceController2.text = buyPrice2.toStringAsFixed(denomination);
    sellPriceController2.text = sellPrice2.toStringAsFixed(denomination);
    investPriceController2.text = investPrice2.toStringAsFixed(denomination);
    if (quantityFieldSelected) {
      investPriceController1.text = investPrice1.toStringAsFixed(denomination);
    } else {
      quantityController.text = quantity.toStringAsFixed(denomination);
    }

    //return profits in both currencies

    realProfit1 = profit1.toStringAsFixed(denomination);
    realProfit2 = profit2.toStringAsFixed(denomination);
    debugVariable = profit1.toStringAsFixed(denomination);
    return (realProfit1, realProfit2);
  }

  void getRates(List<String> arguments) async {
    // This example uses the Google Books API to search for books about http.
    // https://developers.google.com/books/docs/overview
    var url = Uri.http(
      'api.exchangeratesapi.io',
      '/v1/latest',
      {'access_key': '06289703e4e5058f94f343ce3d445ae2'},
    );
    //USD EUR HKD BHD SAR AED GBP
    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      var itemCount = jsonResponse;
      print(itemCount['rates']['BHD']);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getRates(['arguments']);
        },
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF20004f),
      body: Column(
        children: [
          const SizedBox(
            height: 150,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Column(
                children: [
                  Text(
                    "USD",
                    style: TextStyle(color: textColor),
                  ),
                  const SizedBox(height: 20),
                  ConversionCard(
                    buyPriceController: _buyPriceUSDController,
                    sellPriceController: _sellPriceUSDController,
                    qtyController: _quantityController,
                    numberChanged: () {
                      var (profit1, profit2) = updateCards(
                          buyPriceController1: _buyPriceUSDController,
                          buyPriceController2: _buyPriceBHDController,
                          sellPriceController1: _sellPriceUSDController,
                          sellPriceController2: _sellPriceBHDController,
                          investPriceController1: _investPriceUSDController,
                          investPriceController2: _investPriceBHDController,
                          realProfit1: card1Profit,
                          realProfit2: card2Profit,
                          quantityController: _quantityController,
                          conversionRate: 0.38);
                      setState(() {
                        card1Profit = profit1;
                        card2Profit = profit2;
                      });
                    },
                    profit: card1Profit,
                    onQuantitySelected: _quantitySelected,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Initial investment",
                    style: TextStyle(fontSize: 12, color: textColor),
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    width: 140,
                    height: 60,
                    child: TextField(
                      controller: _investPriceUSDController,
                      onTap: () {
                        quantityFieldSelected = false;
                      },
                      onChanged: (text) {
                        var (profit1, profit2) = updateCards(
                            buyPriceController1: _buyPriceUSDController,
                            sellPriceController1: _sellPriceUSDController,
                            investPriceController1: _investPriceUSDController,
                            realProfit1: card1Profit,
                            buyPriceController2: _buyPriceBHDController,
                            sellPriceController2: _sellPriceBHDController,
                            investPriceController2: _investPriceBHDController,
                            realProfit2: card2Profit,
                            quantityController: _quantityController,
                            conversionRate: 0.38);
                        setState(() {
                          card1Profit = profit1;
                          card2Profit = profit2;
                        });
                      },
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        hintText: 'Initial investment',
                      ),
                      style: TextStyle(color: textColor),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                children: [
                  Text(
                    "BHD",
                    style: TextStyle(color: textColor),
                  ),
                  const SizedBox(height: 20),
                  ConversionCard(
                    buyPriceController: _buyPriceBHDController,
                    sellPriceController: _sellPriceBHDController,
                    qtyController: _quantityController,
                    numberChanged: () {
                      var (profit1, profit2) = updateCards(
                          buyPriceController1: _buyPriceBHDController,
                          sellPriceController1: _sellPriceBHDController,
                          investPriceController1: _investPriceBHDController,
                          realProfit1: card2Profit,
                          buyPriceController2: _buyPriceUSDController,
                          sellPriceController2: _sellPriceUSDController,
                          investPriceController2: _investPriceUSDController,
                          realProfit2: card1Profit,
                          quantityController: _quantityController,
                          conversionRate: 2.65957);
                      setState(() {
                        card1Profit = profit2;
                        card2Profit = profit1;
                      });
                    },
                    profit: card2Profit,
                    onQuantitySelected: _quantitySelected,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Initial investment",
                    style: TextStyle(fontSize: 12, color: textColor),
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    width: 140,
                    height: 60,
                    child: TextField(
                      controller: _investPriceBHDController,
                      onTap: () {
                        quantityFieldSelected = false;
                      },
                      onChanged: (text) {
                        var (profit1, profit2) = updateCards(
                            buyPriceController1: _buyPriceBHDController,
                            sellPriceController1: _sellPriceBHDController,
                            investPriceController1: _investPriceBHDController,
                            realProfit1: card2Profit,
                            buyPriceController2: _buyPriceUSDController,
                            sellPriceController2: _sellPriceUSDController,
                            investPriceController2: _investPriceUSDController,
                            realProfit2: card1Profit,
                            quantityController: _quantityController,
                            conversionRate: 2.65957);
                        setState(() {
                          card1Profit = profit2;
                          card2Profit = profit1;
                        });
                      },
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Initial investment',
                      ),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: textColor),
                    ),
                  )
                ],
              ),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}
