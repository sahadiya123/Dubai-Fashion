class CardModel {
  final String id;
  final String cardHolderName;
  final String cardNumber;
  final String expiryDate;
  final String cvv;

  CardModel({
    required this.id,
    required this.cardHolderName,
    required this.cardNumber,
    required this.expiryDate,
    required this.cvv,
  });

  factory CardModel.fromMap(Map<String, dynamic> map) {
    return CardModel(
      id: map['id'] as String? ?? '',
      cardHolderName: map['cardHolderName'] as String? ?? '',
      cardNumber: map['cardNumber'] as String? ?? '',
      expiryDate: map['expiryDate'] as String? ?? '',
      cvv: map['cvv'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cardHolderName': cardHolderName,
      'cardNumber': cardNumber,
      'expiryDate': expiryDate,
      'cvv': cvv,
    };
  }

  String get maskedNumber {
    if (cardNumber.length < 4) return cardNumber;
    return '**** **** **** ${cardNumber.substring(cardNumber.length - 4)}';
  }
}
