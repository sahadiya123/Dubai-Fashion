class AddressModel {
  final String id;
  final String fullName;
  final String addressLine;
  final String city;
  final String phone;
  final bool isDefault;

  AddressModel({
    required this.id,
    required this.fullName,
    required this.addressLine,
    required this.city,
    required this.phone,
    this.isDefault = false,
  });

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      id: map['id'] as String? ?? '',
      fullName: map['fullName'] as String? ?? '',
      addressLine: map['addressLine'] as String? ?? '',
      city: map['city'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      isDefault: map['isDefault'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'addressLine': addressLine,
      'city': city,
      'phone': phone,
      'isDefault': isDefault,
    };
  }

  AddressModel copyWith({
    String? id,
    String? fullName,
    String? addressLine,
    String? city,
    String? phone,
    bool? isDefault,
  }) {
    return AddressModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      addressLine: addressLine ?? this.addressLine,
      city: city ?? this.city,
      phone: phone ?? this.phone,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
