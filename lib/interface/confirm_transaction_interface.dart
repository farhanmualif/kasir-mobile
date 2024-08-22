import 'package:kasir_mobile/interface/transaction_interface.dart';

class ConfirmTransactionInterface extends TransactionData {
  ConfirmTransactionInterface.set(
      {required super.id,
      required super.name,
      required super.price,
      required super.uuid,
      required super.barcode,
      required super.remaining,
      required super.image,
      required super.purcahsePrice,
      })
      : super.set();
}
