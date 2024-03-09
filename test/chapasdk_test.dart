import 'package:chapasdk/constants/strings.dart';
import 'package:chapasdk/constants/url.dart';
import 'package:chapasdk/service/web_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chapasdk/chapasdk.dart';
import 'package:http/testing.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
class MockClient extends Mock implements http.Client {}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  group('Chapa', () {
    late BuildContext context;
    late String publicKey;
    late String amount;
    late String currency;
    late String email;
    late String firstName;
    late String lastName;
    late String txRef;
    late String title;
    late String desc;
    late String namedRouteFallBack;

    setUp(() {
      context = MockBuildContext();
      publicKey = 'your_public_key';
      amount = '10.0';
      currency = 'USD';
      email = 'test@example.com';
      firstName = 'John';
      lastName = 'Doe';
      txRef = '1234567890';
      title = 'Payment';
      desc = 'Payment description';
      namedRouteFallBack = '/fallback';
    });

    test('paymentParameters - valid keys', () {
      final chapa = Chapa.paymentParameters(
        context: context,
        publicKey: publicKey,
        currency: currency,
        amount: amount,
        email: email,
        firstName: firstName,
        lastName: lastName,
        companyName: txRef,
        title: title,
        desc: desc,
        namedRouteFallBack: namedRouteFallBack,
      );

      expect(chapa, isNotNull);
      expect(chapa.validateKeys(), isTrue);
    });

    test('paymentParameters - invalid public key', () {
      final invalidPublicKey = '';
      final chapa = Chapa.paymentParameters(
        context: context,
        publicKey: invalidPublicKey,
        currency: currency,
        amount: amount,
        email: email,
        firstName: firstName,
        lastName: lastName,
        companyName: txRef,
        title: title,
        desc: desc,
        namedRouteFallBack: namedRouteFallBack,
      );

      expect(chapa, isNotNull);
      expect(chapa.validateKeys(), isFalse);
      expect(showErrorToastCalled, isFalse);
      expect(showErrorToastMessage, equals(''));
    });


  });

}
class MockBuildContext extends Mock implements BuildContext {

}

bool showErrorToastCalled = false;
String showErrorToastMessage = '';

void showErrorToast(String message) {
  showErrorToastCalled = true;
  showErrorToastMessage = message;
}
void showToast(dynamic message) {}
