part of my_fatoorah;

class Supplier {
  ///The supplier code you need to associate the invoice with, please refer to Multiple Suppliers feature.
  int supplierCode;

  ///the amount that the supplier will get after paying the invoice.
  double? proposedShare;

  ///Amount specified for this supplier from the total invoice value.
  double invoiceShare;

  Supplier({
    required this.supplierCode,
    required this.proposedShare,
    required this.invoiceShare,
  });

  Map<String, dynamic> toJson() {
    return {
      "SupplierCode": supplierCode,
      "ProposedShare": proposedShare,
      "InvoiceShare": invoiceShare,
    };
  }
}
