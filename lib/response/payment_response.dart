part of my_fatoorah;

class PaymentResponse {
  final PaymentStatus status;
  final String paymentId;

  PaymentResponse(this.status, [this.paymentId]);
  @override
  String toString() {
    return "Status: $status     PaymentId: $paymentId";
  }
}
