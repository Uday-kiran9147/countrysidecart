import 'package:countrysidecart/firebase_options.dart';
import 'package:countrysidecart/screens/Auth/login.dart';
import 'package:countrysidecart/screens/Auth/signup_screen.dart';
import 'package:countrysidecart/screens/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:countrysidecart/database/auth.dart';
import 'package:mockito/mockito.dart';
// import 'package:countrysidecart/screens/Auth/login_screen.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  testWidgets('LoginScreen UI Test', (WidgetTester tester) async {

    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));

    // Verify that Email and Password text fields are present.
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);

    // Verify that the login button is present.
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);

    // Verify that the signup button is present.
    expect(find.byType(TextButton), findsOneWidget);
    expect(find.text('signup'), findsOneWidget);
  });

  testWidgets('LoginScreen Functionality Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));

    // Mock sign-in function
    bool mockSignInFunction(String email, String password) {
      // Implement your mock sign-in logic here
      // For testing purposes, return true if the email and password are not empty
      return email.isNotEmpty && password.isNotEmpty;
    }

    // Mock sign-in success scenario
    when(signInWithEmailAndPassword('test@example.com', 'password123')).thenAnswer((_) async => true);

    // Enter email and password
    await tester.enterText(find.byType(TextField).first, 'udaykiran9147@gmail.com');
    await tester.enterText(find.byType(TextField).last, '12345678');

    // Tap the login button
    await tester.tap(find.text('Login'));
    await tester.pump();

    // Wait for navigation
    await tester.pumpAndSettle();

    // Verify that the navigation occurred to the Home screen
    expect(find.byType(Home), findsOneWidget);

    // Mock sign-in failure scenario
    when(signInWithEmailAndPassword('test@example.com', 'password123')).thenAnswer((_) async => false);

    // Tap the login button again
    await tester.tap(find.text('Login'));
    await tester.pump();

    // Wait for the error to be shown
    await tester.pumpAndSettle();

    // Verify that an error message is displayed (modify this based on your actual error handling)
    expect(find.text('Invalid email or password'), findsOneWidget);

    // Verify that the navigation did not occur
    expect(find.byType(Home), findsNothing);

    // Tap the signup button
    await tester.tap(find.text('signup'));
    await tester.pump();

    // Verify that navigation occurred to the SignUp screen
    expect(find.byType(SignUpScreen), findsOneWidget);
  });
}
