import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kasir_mobile/pages/auth/login_page.dart';
import 'package:kasir_mobile/pages/auth/register_page.dart';
import 'package:kasir_mobile/pages/home/home_app.dart';
import 'package:kasir_mobile/pages/home/splash.dart';
import 'package:kasir_mobile/pages/management/add_category.dart';
import 'package:kasir_mobile/pages/management/product_category.dart';
import 'package:kasir_mobile/pages/transaction/add_product_page.dart';
import 'package:kasir_mobile/pages/transaction/barcode_scanner_result_page.dart';
import 'package:kasir_mobile/pages/transaction/cart_page.dart';
import 'package:kasir_mobile/pages/transaction/payment_page.dart';
import 'package:kasir_mobile/pages/transaction/payment_done_page.dart';
import 'package:kasir_mobile/pages/transaction/transaction_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/.env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: Splash(
          key: key,
        ),
      ),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/login':
            return MaterialPageRoute(builder: (context) => const LoginPage());
          case '/register':
            return MaterialPageRoute(
                builder: (context) => const RegisterPage());
          case '/home':
            return MaterialPageRoute(builder: (context) => const HomeApp());
          case '/form-add-product':
            return MaterialPageRoute(
                builder: (context) => const AddProoductPage());
          case '/form-add-category':
            return MaterialPageRoute(builder: (context) => const AddCategory());
          case '/categories':
            return MaterialPageRoute(builder: (context) => const ProductCategory());
          case '/transaction':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
                builder: (context) => TransactionPage(
                      typeTransaction: args["typeTransaction"],
                    ));
          case '/barcode-scanner-result':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
                builder: (context) => BarcodeScannerResult(
                      product: args["product"],
                      typeTransaction: args["typeTransaction"],
                    ));
          case '/cart':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) => CartPage(
                typeTransaction: args['typeTransaction'],
                subTotalPrice: args['totalPrice'],
                listTransaction: args['listTransaction'],
              ),
            );
          case '/payment':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) => PaymentPage(
                totalPrice: args['totalPrice'],
                listTransaction: args['listTransaction'],
              ),
            );
          case '/payment-done':
            var args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) => PaymentDone(
                  typeTransaction: args['typeTransaction'],
                  noTransaction: args['noTransaction'],
                  change: args['change']),
            );
          default:
            return null;
        }
      },
    );
  }
}
