import 'package:flutter/foundation.dart';

class InvoiceItem {
  ///Invoice item name that will be displayed in the invoice
  String itemName;

  ///Item quantity
  int quantity;

  ///Item unit price
  int unitPrice;

  InvoiceItem({
    @required this.itemName,
    @required this.quantity,
    @required this.unitPrice,
  });

  Map<String, dynamic> toJson() {
    return {
      "ItemName": itemName,
      "Quantity": quantity,
      "UnitPrice": unitPrice,
    };
  }
}
