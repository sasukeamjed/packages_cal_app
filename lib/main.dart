import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfWidgets;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      builder: (context, child) {
        return Scaffold(
          body: GestureDetector(
            onTap: () {
              hideKeyboard(context);
            },
            child: child,
          ),
        );
      },
      home: MyHomePage(),
    );
  }

  void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus.unfocus();
    }
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final pdf = pdfWidgets.Document();

  writeOnPdf() {
    pdf.addPage(
      pdfWidgets.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pdfWidgets.EdgeInsets.all(32),
        build: (pdfWidgets.Context context){
          return <pdfWidgets.Widget>  [
            pdfWidgets.Header(
              level: 0,
              child: pdfWidgets.Text("Easy Approach Document"),
            ),
            pdfWidgets.Paragraph(
              text: "A paragraph is a series of related sentences developing a central idea, called the topic. Try to think about paragraphs in terms of thematic unity: a paragraph is a sentence or a group of sentences that supports one central, unified idea. Paragraphs add one idea at a time to your broader argument.",
            ),
            pdfWidgets.Paragraph(
              text: "A paragraph is a series of related sentences developing a central idea, called the topic. Try to think about paragraphs in terms of thematic unity: a paragraph is a sentence or a group of sentences that supports one central, unified idea. Paragraphs add one idea at a time to your broader argument.",
            ),
            pdfWidgets.Header(
              level: 1,
              child: pdfWidgets.Text("Second Heading"),
            ),
            pdfWidgets.Paragraph(
              text: "A paragraph is a series of related sentences developing a central idea, called the topic. Try to think about paragraphs in terms of thematic unity: a paragraph is a sentence or a group of sentences that supports one central, unified idea. Paragraphs add one idea at a time to your broader argument.",
            ),
            pdfWidgets.Paragraph(
              text: "A paragraph is a series of related sentences developing a central idea, called the topic. Try to think about paragraphs in terms of thematic unity: a paragraph is a sentence or a group of sentences that supports one central, unified idea. Paragraphs add one idea at a time to your broader argument.",
            ),
          ];
        },
        
      ),
    );
  }

  Future savePdf() async{
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    String documentPath = documentDirectory.path;

    File file = File("$documentPath/example.pdf");

    file.writeAsBytesSync(pdf.save());
  }

  TextEditingController _controller = TextEditingController();
  int numOfSmallPackages = 0;
  int numOfBigPackages = 0;
  double priceOfSmallPackages = 0.0;
  double priceOfBigPackages = 0.0;
  double bonusPrice = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Packages Calculator App"),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'logo/logo-small.png',
                height: 200,
                width: 200,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Enter the number of the product with packages:',
              ),
              TextField(
                controller: _controller,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: "x/xxxxxxx",
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    child: Text("Calculate"),
                    onPressed: () {
                      num lines =
                          '\n'.allMatches(_controller.text.trim()).length + 1;
                      List<String> packages = _controller.text
                          .split("\n")
                          .where((element) => element != "")
                          .toList();
                      Map<String, double> map =
                          calcBigAndSmallPackages(packages);
                      setState(() {
                        numOfSmallPackages = map["small packages"].toInt();
                        priceOfSmallPackages = map["small packages price"];
                        numOfBigPackages = map["big packages"].toInt();
                        priceOfBigPackages = map["big packages price"];
                      });
                      print(lines);
                      print(packages);
                      print(map["small packages"]);
                      print(map["small packages price"]);
                      print(map["big packages"]);
                      print(map["big packages price"]);
                    },
                  ),
                  ElevatedButton(
                    child: Text("Clear"),
                    onPressed: () {
                      setState(() {
                        _controller.clear();
                        numOfSmallPackages = 0;
                        priceOfSmallPackages = 0;
                        numOfBigPackages = 0;
                        priceOfBigPackages = 0;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              //To do next round number to 3 decemal places
              Text(
                "Number Of Small Packages:\n$numOfSmallPackages",
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Number Of Big Packages:\n$numOfBigPackages",
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Total Packages:\n${numOfBigPackages + numOfSmallPackages}",
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "The Total Price Of Small Packages:\n${priceOfSmallPackages.toStringAsFixed(3)} OMR",
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "The Total Price Of Big Packages:\n${priceOfBigPackages.toStringAsFixed(3)} OMR",
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "The Bonus Price:\n${bonusPrice.toStringAsFixed(3)} OMR",
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "The Total Price Of Packages:\n${(priceOfSmallPackages + priceOfBigPackages).toStringAsFixed(3)} OMR",
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Map<String, double> calcBigAndSmallPackages(List<String> packages) {
    double smallPack = 0;
    double bigPack = 0;
    double bigPackagesPrice = 0;

    packages.asMap().forEach((index, value) {
      print(value);
      if (value.contains("/")) {
        int indexOfSlash = value.indexOf("/");
        int numOfPackages = int.parse(value.substring(0, indexOfSlash));
        print(index);
        if (numOfPackages > 1) {
          bigPackagesPrice =
              bigPackagesPrice + calculateBigPackagePrices(numOfPackages);
          bigPack += 1;
        } else {
          smallPack += 1;
        }
      } else if (value.contains("\\")) {
        int indexOfSlash = value.indexOf("\\");
        int numOfPackages = int.parse(value.substring(0, indexOfSlash));
        print(index);
        if (numOfPackages > 1) {
          bigPackagesPrice =
              bigPackagesPrice + calculateBigPackagePrices(numOfPackages);
          bigPack += 1;
        } else {
          smallPack += 1;
        }
      } else {
        print("There is error on line $index with vlaue is $value");
      }
    });

    return {
      "small packages": smallPack,
      "small packages price": (smallPack * 0.050),
      "big packages": bigPack,
      "big packages price": bigPackagesPrice,
    };
  }

  double calculateBigPackagePrices(int numOfPackages) {
    if (numOfPackages < 5) {
      return numOfPackages * 0.150;
    } else {
      int extraPackages = numOfPackages - 4;
      double bonus = (0.025 * extraPackages);
      bonusPrice = bonusPrice + bonus;
      return 0.150 + bonus;
    }
  }
}
