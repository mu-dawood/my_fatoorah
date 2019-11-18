class PaymentResult {
  String _comments;
  String _createdDate;
  String _customerMobile;
  String _customerName;
  String _expiryDate;
  String _invoiceDisplayValue;
  int _invoiceId;
  List<InvoiceItem> _invoiceItems;
  String _invoiceReference;
  String _invoiceStatus;
  List<InvoiceTransactions> _invoiceTransactions;
  int _invoiceValue;

  String get comments => _comments;
  String get createdDate => _createdDate;

  String get customerMobile => _customerMobile;

  String get customerName => _customerName;

  String get expiryDate => _expiryDate;

  String get invoiceDisplayValue => _invoiceDisplayValue;

  int get invoiceId => _invoiceId;

  List<Null> get invoiceItems => _invoiceItems;

  String get invoiceReference => _invoiceReference;

  String get invoiceStatus => _invoiceStatus;

  List<InvoiceTransactions> get invoiceTransactions => _invoiceTransactions;

  int get invoiceValue => _invoiceValue;

  PaymentResult.fromJson(Map<String, dynamic> json) {
    _comments = json['Comments'];
    _createdDate = json['CreatedDate'];
    _customerMobile = json['CustomerMobile'];
    _customerName = json['CustomerName'];
    _expiryDate = json['ExpiryDate'];
    _invoiceDisplayValue = json['InvoiceDisplayValue'];
    _invoiceId = json['InvoiceId'];
    if (json['InvoiceItems'] != null) {
      _invoiceItems = new List<InvoiceItem>();
      json['InvoiceItems'].forEach((v) {
        _invoiceItems.add(InvoiceItem.fromJson(v));
      });
    }
    _invoiceReference = json['InvoiceReference'];
    _invoiceStatus = json['InvoiceStatus'];
    if (json['InvoiceTransactions'] != null) {
      _invoiceTransactions = new List<InvoiceTransactions>();
      json['InvoiceTransactions'].forEach((v) {
        _invoiceTransactions.add(new InvoiceTransactions.fromJson(v));
      });
    }
    _invoiceValue = json['InvoiceValue'];
  }
}

class InvoiceTransactions {
  String _authorizationId;
  String _currency;
  String _customerServiceCharge;
  String _dueValue;
  String _paidCurrency;
  String _paidCurrencyValue;
  String _paymentGateway;
  String _paymentId;
  String _referenceId;
  String _trackId;
  String _transactionDate;
  String _transactionId;
  String _transactionStatus;
  String _transationValue;

  String get authorizationId => _authorizationId;

  String get currency => _currency;

  String get customerServiceCharge => _customerServiceCharge;

  String get dueValue => _dueValue;

  String get paidCurrency => _paidCurrency;

  String get paidCurrencyValue => _paidCurrencyValue;

  String get paymentGateway => _paymentGateway;

  String get paymentId => _paymentId;

  String get referenceId => _referenceId;

  String get trackId => _trackId;

  String get transactionDate => _transactionDate;

  String get transactionId => _transactionId;

  String get transactionStatus => _transactionStatus;

  String get transationValue => _transationValue;

  InvoiceTransactions.fromJson(Map<String, dynamic> json) {
    _authorizationId = json['AuthorizationId'];
    _currency = json['Currency'];
    _customerServiceCharge = json['CustomerServiceCharge'];
    _dueValue = json['DueValue'];
    _paidCurrency = json['PaidCurrency'];
    _paidCurrencyValue = json['PaidCurrencyValue'];
    _paymentGateway = json['PaymentGateway'];
    _paymentId = json['PaymentId'];
    _referenceId = json['ReferenceId'];
    _trackId = json['TrackId'];
    _transactionDate = json['TransactionDate'];
    _transactionId = json['TransactionId'];
    _transactionStatus = json['TransactionStatus'];
    _transationValue = json['TransationValue'];
  }
}

class InvoiceItem {
  String _itemName;
  int _quantity;
  int _unitPrice;

  InvoiceItem({String itemName, int quantity, int unitPrice}) {
    this._itemName = itemName;
    this._quantity = quantity;
    this._unitPrice = unitPrice;
  }

  String get itemName => _itemName;
  int get quantity => _quantity;
  int get unitPrice => _unitPrice;

  InvoiceItem.fromJson(Map<String, dynamic> json) {
    _itemName = json['ItemName'];
    _quantity = json['Quantity'];
    _unitPrice = json['UnitPrice'];
  }
}
