import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'In-App Payments'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController ampuntController = TextEditingController();

  int totalAmt = 0;
  //1.  Create instance of Razorpay
  Razorpay _razorpay= Razorpay();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //2. initialise razorpay object
     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentFailure);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

  }


//3. Make sure the dispose the razorpay object

@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _razorpay.clear();
  }


  //TODO: 4. The payment goes here:

  void openChekcout() async{
    var option = {
      'key': 'rzp_test_teMpvcdufa06Lz',
      'amount': totalAmt*100,
      'name': 'iHrish',
      'description': 'Test Payment',
      'prefill': {'contact': '', 'email':''},
      'external':{
        'wallets':['paytm']
      }

    };
    try{
      _razorpay.open(option);

    }catch(e){
      debugPrint(e);
    }
  }



  void _handlePaymentSuccess(PaymentSuccessResponse successResponse){
    Fluttertoast.showToast(msg: "SUCCESS" + successResponse.paymentId);
  }


  void _handlePaymentFailure(PaymentFailureResponse response){
    Navigator.pop(context);
    Fluttertoast.showToast(msg: "FAILED" + response.code.toString()+ ' ---' + response.message);
  }



  void _handleExternalWallet(ExternalWalletResponse response){
    Fluttertoast.showToast(msg: "ExternalWallet" + response.walletName);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LimitedBox(
              maxWidth: 150,
              child: TextField(
                controller: ampuntController,
                keyboardType: TextInputType.numberWithOptions(signed: false),
                decoration: InputDecoration(
                  hintText: "Please enter the amount to pay!"
                ),
                onChanged: (val){
                  setState(() {
                    totalAmt = num.parse(val);
                  });
                },
                ),
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              child: Text('Proveed To Pay!'),
              color: Colors.blueAccent,
              elevation: 10,
              onPressed: () {
                openChekcout();
              },
            )
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
