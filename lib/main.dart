import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      builder: (context, child){
        return Scaffold(
          body: GestureDetector(
            onTap: (){
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

  TextEditingController _controller = TextEditingController();
  int numOfSmallPackages = 0;
  int numOfBigPackages = 0;
  double priceOfSmallPackages = 0.0;
  double priceOfBigPackages = 0.0;

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
              Image.asset('logo/logo-small.png', height: 200, width: 200,),
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
                    onPressed: (){
                      num lines = '\n'.allMatches(_controller.text.trim()).length + 1;
                      List<String> packages = _controller.text.split("\n").where((element) => element != "").toList();
                      Map<String, double> map = calcBigAndSmallPackages(packages);
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
                    onPressed: (){

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
              Text("Number Of Small Packages:\n$numOfSmallPackages", textAlign: TextAlign.center,),
              SizedBox(
                height: 20,
              ),
              Text("Number Of Big Packages:\n$numOfBigPackages", textAlign: TextAlign.center,),
              SizedBox(
                height: 20,
              ),
              Text("Total Packages:\n${numOfBigPackages + numOfSmallPackages}", textAlign: TextAlign.center,),
              SizedBox(
                height: 20,
              ),
              Text("The Total Price Of Small Packages:\n${priceOfSmallPackages.toStringAsFixed(3)} OMR", textAlign: TextAlign.center,),
              SizedBox(
                height: 20,
              ),
              Text("The Total Price Of Big Packages:\n${priceOfBigPackages.toStringAsFixed(3)} OMR", textAlign: TextAlign.center,),
              SizedBox(
                height: 20,
              ),
              Text("The Total Price Of Packages:\n${(priceOfSmallPackages + priceOfBigPackages).toStringAsFixed(3)} OMR", textAlign: TextAlign.center,),
            ],
          ),
        ),
      ),
    );
  }

  Map<String, double> calcBigAndSmallPackages(List<String> packages){

    double smallPack = 0;
    double bigPack = 0;

    packages.forEach((value) {
      int indexOfSlash = value.indexOf("/");
      int numOfPackages = int.parse(value.substring(0, indexOfSlash));
      if(numOfPackages > 1){
        bigPack += 1;
      }else{
        smallPack += 1;
      }
    });

    return {
      "small packages" : smallPack,
      "small packages price" : (smallPack * 0.050),
      "big packages" : bigPack,
      "big packages price" : (bigPack * 0.150),
    };
  }
}
