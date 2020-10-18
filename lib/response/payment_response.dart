part of my_fatoorah;

class PaymentResponse {
  final PaymentStatus status;
  final String paymentId;
  final String url;

  PaymentResponse(this.status, {this.url, this.paymentId});
  @override
  String toString() {
    return "Status: $status     PaymentId: $paymentId";
  }
}
