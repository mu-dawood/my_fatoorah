part of my_fatoorah;

class CustomerAddress {
  /// Block number or area name that contains the delivery address
  String block;

  /// Delivery address street name
  String street;

  /// House / Building number
  String houseBuildingNo;

  ///Full address details
  String address;

  ///Additional instructions for the delivery address, landmark or directions
  String addressInstructions;

  CustomerAddress({
    required this.block,
    required this.street,
    required this.houseBuildingNo,
    required this.address,
    required this.addressInstructions,
  });

  Map<String, dynamic> toJson() {
    return {
      "Block": block,
      "Street": street,
      "HouseBuildingNo": houseBuildingNo,
      "Address": address,
      "AddressInstructions": addressInstructions,
    };
  }
}
