import 'package:countrysidecart/database/auth.dart';
import 'package:countrysidecart/models/bussiness.dart';
import 'package:countrysidecart/screens/Auth/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final uid = FirebaseAuth.instance.currentUser!.uid;

  TextEditingController searchQuery = TextEditingController();
  String search = '';
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
        getaddressfromlatlong(_currentPosition!)
            .whenComplete(() => waitingforlocation = false);
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
      appBar: AppBar(
        titleSpacing: 8,
        title: TextButton(
            onPressed: () async {
              await getCurrentPosition().whenComplete(() {
                FocusScope.of(context).requestFocus(_locationFocusNode);
                search = address!;

                setState(() {
                  searchQuery.text = address!;

                  // get focusnode
                });
              });
            },
            child: Text(
              'From my location',
              style: TextStyle(color: Colors.orange),
            )),
        leading: Center(
          child: Text.rich(TextSpan(children: [
            TextSpan(
                text: 'Community\n',
                style: TextStyle(color: Colors.white, fontSize: 22)),
            TextSpan(text: 'Home', style: TextStyle(color: Colors.green))
          ])),
        ),
        leadingWidth: 150,
        actions: [
          IconButton(
              onPressed: () async {
                await signOut().then((value) {
                  // SHP.saveUserLoggedinStatusSP(false);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ));
                });
              },
              icon: Icon(Icons.logout_rounded))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            waitingforlocation
                ? Center(
                    child: LinearProgressIndicator(),
                  )
                : Container(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                onChanged: (val) {
                  setState(() {
                    search = val;
                  });
                },
                controller: searchQuery,
                focusNode: _locationFocusNode,
                decoration: InputDecoration(
                  hintText: "Search location...",
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey.shade600,
                    size: 20,
                  ),
                  filled: true,
                  // fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.all(8),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.grey.shade100)),
                ),
              ),
            ),
            StreamBuilder(
                stream: bussinessCollection.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('error occured');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.data!.docs.length <= 0) {
                    return Center(
                      child: Text('No Bussiness Found'),
                    );
                  }

                  List searchlist = snapshot.data!.docs
                      .where((element) => element['location']
                          .toString()
                          .toLowerCase()
                          .contains(search.toLowerCase()))
                      .toList();
                  return searchlist.length > 0
                      ? ListView(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          shrinkWrap: true,
                          children: searchlist.map((e) {
                            Business bussiness1 = Business.fromMap(e);
                            return Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1,
                                        color:
                                            Theme.of(context).primaryColorDark),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      title: Text(bussiness1.businessName),
                                      subtitle: Text(
                                          'Location: ' + bussiness1.location,
                                          style: TextStyle(
                                            color: Colors.orange,
                                          )),
                                      trailing: Icon(
                                        Icons.location_on,
                                        color: Colors.red,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 15,
                                          bottom: 8.0),
                                      child: Text("Contact: " +
                                          " " +
                                          bussiness1
                                              .contactInformation.phoneNumber),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }).toList())
                      : Center(
                          child: Text('No Bussiness Found'),
                        );
                }),
          ],
        ),
      ),
    );
  }
}
