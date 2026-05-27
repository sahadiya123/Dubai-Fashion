import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/address_model.dart';
import '../models/card_model.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;
  String _name = '';
  List<AddressModel> _addresses = [];
  List<CardModel> _cards = [];
  bool _isLoading = false;

  User? get user => _user;
  String get name => _name;
  List<AddressModel> get addresses => _addresses;
  List<CardModel> get cards => _cards;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      if (user != null) {
        loadUserData();
      } else {
        _name = '';
        _addresses = [];
        _cards = [];
        notifyListeners();
      }
    });
  }

  Future<void> loadUserData() async {
    if (_user == null) return;
    try {
      final doc = await _firestore.collection('users').doc(_user!.uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        _name = data['name'] as String? ?? '';
        
        final addrList = data['addresses'] as List<dynamic>? ?? [];
        _addresses = addrList
            .map((item) => AddressModel.fromMap(Map<String, dynamic>.from(item as Map)))
            .toList();

        final cardList = data['cards'] as List<dynamic>? ?? [];
        _cards = cardList
            .map((item) => CardModel.fromMap(Map<String, dynamic>.from(item as Map)))
            .toList();
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading user data: $e');
    }
  }

  Future<String?> signUpWithEmail(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      final creds = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (creds.user != null) {
        await _firestore.collection('users').doc(creds.user!.uid).set({
          'uid': creds.user!.uid,
          'name': name,
          'email': email,
          'addresses': [],
          'cards': [],
        });
        _name = name;
        _addresses = [];
        _cards = [];
      }
      _isLoading = false;
      notifyListeners();
      return null; // success
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      return e.message ?? 'An error occurred during sign up.';
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return e.toString();
    }
  }

  Future<String?> signInWithEmail(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _isLoading = false;
      notifyListeners();
      return null; // success
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      return e.message ?? 'An error occurred during sign in.';
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return e.toString();
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> addAddress(AddressModel address) async {
    if (_user == null) return;
    
    AddressModel addressWithId = address;
    if (address.id.isEmpty) {
      addressWithId = address.copyWith(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
      );
    }

    List<AddressModel> updatedAddresses = List.from(_addresses);
    
    // If setting to default, clear defaults from other addresses
    if (addressWithId.isDefault) {
      updatedAddresses = updatedAddresses.map((a) => a.copyWith(isDefault: false)).toList();
    }

    final index = updatedAddresses.indexWhere((a) => a.id == addressWithId.id);
    if (index >= 0) {
      updatedAddresses[index] = addressWithId;
    } else {
      // If it is the first address, make it default automatically
      if (updatedAddresses.isEmpty) {
        addressWithId = addressWithId.copyWith(isDefault: true);
      }
      updatedAddresses.add(addressWithId);
    }

    try {
      await _firestore.collection('users').doc(_user!.uid).update({
        'addresses': updatedAddresses.map((a) => a.toMap()).toList(),
      });
      _addresses = updatedAddresses;
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving address: $e');
    }
  }

  Future<void> deleteAddress(String addressId) async {
    if (_user == null) return;
    
    final updatedAddresses = _addresses.where((a) => a.id != addressId).toList();
    
    // If we deleted the default address, make another one default if possible
    if (_addresses.any((a) => a.id == addressId && a.isDefault) && updatedAddresses.isNotEmpty) {
      updatedAddresses[0] = updatedAddresses[0].copyWith(isDefault: true);
    }

    try {
      await _firestore.collection('users').doc(_user!.uid).update({
        'addresses': updatedAddresses.map((a) => a.toMap()).toList(),
      });
      _addresses = updatedAddresses;
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting address: $e');
    }
  }

  Future<void> addCard(CardModel card) async {
    if (_user == null) return;

    CardModel cardWithId = card;
    if (card.id.isEmpty) {
      cardWithId = CardModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        cardHolderName: card.cardHolderName,
        cardNumber: card.cardNumber,
        expiryDate: card.expiryDate,
        cvv: card.cvv,
      );
    }

    final updatedCards = List<CardModel>.from(_cards);
    final index = updatedCards.indexWhere((c) => c.id == cardWithId.id);
    if (index >= 0) {
      updatedCards[index] = cardWithId;
    } else {
      updatedCards.add(cardWithId);
    }

    try {
      await _firestore.collection('users').doc(_user!.uid).update({
        'cards': updatedCards.map((c) => c.toMap()).toList(),
      });
      _cards = updatedCards;
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving card: $e');
    }
  }

  Future<void> deleteCard(String cardId) async {
    if (_user == null) return;
    
    final updatedCards = _cards.where((c) => c.id != cardId).toList();

    try {
      await _firestore.collection('users').doc(_user!.uid).update({
        'cards': updatedCards.map((c) => c.toMap()).toList(),
      });
      _cards = updatedCards;
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting card: $e');
    }
  }
}
