part of my_fatoorah;

class RecurringModel {
  ///It defines the interval time of charging the customer again with the same amount. Possible values are: Custom, Daily, Weekly, and Monthly.
  String? recurringType;

  ///It is valid for the "custom" value of the RecurringType parameter. It is between 1 and 180 days
  int? intervalDays;

  ///It determines how many times that you will charge the customer for your services.

  int? iteration;

  RecurringModel({
    required this.recurringType,
    required this.intervalDays,
    required this.iteration,
  });

  Map<String, dynamic> toJson() {
    return {
      "RecurringType": recurringType,
      "IntervalDays": intervalDays,
      "Iteration": iteration,
    };
  }
}
