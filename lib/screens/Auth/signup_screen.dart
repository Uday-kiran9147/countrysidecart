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

  late FocusNode _locationFocusNode;

  @override
  void initState() {
    super.initState();
    _locationFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _locationFocusNode.dispose();
    super.dispose();
  }

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
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Card(
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (waitingforlocation) LinearProgressIndicator(),
                    _buildTextField(
                      controller: _usernameController,
                      labelText: 'Username',
                      hintText: 'Enter your username',
                      icon: Icons.person,
                    ),
                    _buildTextField(
                      controller: _contactsController,
                      labelText: 'Contact',
                      hintText: 'Enter your contact info',
                      icon: Icons.call,
                    ),
                    _buildTextField(
                      controller: _emailController,
                      labelText: 'Email',
                      hintText: 'Enter your email address',
                      icon: Icons.email,
                    ),
                    _buildTextField(
                      controller: _passwordController,
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      icon: Icons.lock,
                      obscureText: true,
                    ),
                    _buildTextField(
                      controller: _locationController,
                      labelText: 'Location',
                      hintText: 'Enter your location',
                      icon: Icons.location_on_outlined,
                      // enabled: false,
                      suffixIcon: IconButton(
                        icon: Icon(Icons.location_searching),
                        onPressed: () async {
                          await getCurrentPosition().whenComplete(() {
                            FocusScope.of(context)
                                .requestFocus(_locationFocusNode);
                            setState(() {
                              _locationController.text = fulladdress!;
                              // get focusnode
                            });
                          });
                        },
                      ),
                    ),
                    _buildButton(
                      onPressed: () async {
                        await registerWithEmailAndPassword(
                          _emailController.text,
                          _passwordController.text,
                          _usernameController.text,
                          _locationController.text,
                          _contactsController.text,
                        ).then((value) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Home()),
                          );
                        });
                      },
                      label: 'Register',
                      color: Colors.blue,
                    ),
                    _buildButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      label: 'Login',
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    bool enabled = true,
    Widget? suffixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          prefixIcon: Icon(icon),
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
    );
  }

  Widget _buildButton({
    required VoidCallback onPressed,
    required String label,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(label),
        style: ElevatedButton.styleFrom(
          primary: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
    );
  }
}
