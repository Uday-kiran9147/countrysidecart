// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, unnecessary_null_comparison

import 'package:countrysidecart/database/auth.dart';
import 'package:countrysidecart/screens/Auth/login.dart';
import 'package:countrysidecart/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _contactsController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  bool waitingforlocation = false;
  Position? _currentPosition;
  String? address;
  String? fulladdress;
  bool isloading = false;

  // Function gets the List of addresses from the latitude and longitude
  Future<List<Placemark>> getaddressfromlatlong(Position position) async {
    /* 
    Sample Placemark object
     {"name":"5VFJ+PQ3","street":"5VFJ+PQ3","isoCountryCode":"IN","country":"India","postalCode":"501501","administrativeArea":"Telangana","subAdministrativeArea":"","locality":"Pargi","subLocality":"Teacher's Colony","thoroughfare":"","subThoroughfare":""}
   */
    List<Placemark>? placelist;

    // Below function Returns a list of Approximate placemarks from the latitude and longitude
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      // Assigns the first placemark to place variable
      Placemark place = placemarks[0];
      placelist = placemarks;
      setState(() {
        address = """${place.locality}""";
        fulladdress =
            """${place.locality}, ${place.subLocality}, ${place.administrativeArea}, ${place.country}""";
      });
      setState(() {
        waitingforlocation = false;
      });
      return placelist;
      // ignore: body_might_complete_normally_catch_error
    }).catchError((e) {
      Fluttertoast.showToast(
          msg: e.toString(), backgroundColor: Colors.redAccent);
    });
    return placelist!;
  }

  // Function Gets the current Position of Device
  Future getCurrentPosition() async {
    final haspermission = await handleLocationPermission();
    if (!haspermission) return;
    setState(() {
      waitingforlocation =
          true; // Loads the progress indicator while waiting for location
    });
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        _currentPosition =
            position; // Assigns the current position to _currentPosition variable
        getaddressfromlatlong(_currentPosition!);
        waitingforlocation = false;
      });
    });
  }

  // Function Requests for location permission
  Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission
        permission; // permission Represents the possible Location Permission states

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    // Check if location services are enabled
    if (!serviceEnabled) {
      Fluttertoast.showToast(
          msg: 'Location services are disabled. Please enable the services',
          backgroundColor: const Color.fromARGB(255, 202, 122, 0));
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator
          .requestPermission(); // Request for location permissions In Application
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }

    // If permissions are denied forever, we cannot request permissions.
    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
          msg:
              'Location permissions are permanently denied, we cannot request permissions.',
          backgroundColor: const Color.fromARGB(255, 202, 122, 0));
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Form(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      waitingforlocation
                          ? const LinearProgressIndicator()
                          : Container(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Username',
                            hintText: 'Enter your username',
                            icon: Icon(Icons
                                .person), // Optional: Icon to represent the field
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _contactsController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                      
                            labelText: 'contact',
                            hintText: 'Enter your contact info',
                            icon: Icon(Icons
                                .call), // Optional: Icon to represent the field
                          ),
                        ),
                      ),
                      SizedBox(height: 16), // Add some spacing between fields
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType
                              .emailAddress, // Set keyboard type for email
                          decoration: InputDecoration(
                            border: InputBorder.none,
                      
                            labelText: 'Email',
                            hintText: 'Enter your email address',
                            icon: Icon(Icons
                                .email), // Optional: Icon to represent the field
                          ),
                        ),
                      ),
                      SizedBox(height: 16), // Add some spacing between fields
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _passwordController,obscureText: true,
                      
                          // keyboardType:
                          //     TextInputType.emailAddress, // Set keyboard type for email
                          decoration: InputDecoration(
                            border: InputBorder.none,
                      
                            labelText: 'password',
                            hintText: 'Enter your password',
                            icon: Icon(Icons
                                .password_rounded), // Optional: Icon to represent the field
                          ),
                        ),
                      ),
                      SizedBox(height: 16), // Add some spacing between fields
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _locationController,
                          keyboardType: TextInputType
                              .emailAddress, // Set keyboard type for email
                          decoration: InputDecoration(
                            border: InputBorder.none,
                      
                            labelText: 'Location',
                            hintText: 'Enter your location',
                            icon: Icon(Icons
                                .location_on_outlined), // Optional: Icon to represent the field
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: Colors.orange,
                          ),
                          TextButton(
                              onPressed: () async {
                                await getCurrentPosition().whenComplete(() {
                                  setState(() {
                                    _locationController.text = fulladdress!;
                                  });
                                });
                              },
                              child: const Text("get current location")),
                        ],
                      ),
                      TextButton(
                        onPressed: () async {
                          await registerWithEmailAndPassword(
                                  _emailController.text,
                                  _passwordController.text,
                                  _usernameController.text,
                                  _locationController.text,
                                  _contactsController.text)
                              .then((value) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Home()));
                          });
                        },
                        child: Text("Register"),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ));
                          },
                          child: Text('Login'))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
