import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:ebuzz/components/drower.dart';
import 'package:ebuzz/components/maps/animation/components.dart';
import 'package:ebuzz/components/maps/animation/ui_helper.dart';
import 'package:ebuzz/components/maps/directions.dart';
import 'package:ebuzz/components/maps/directions_repository.dart';
import 'package:ebuzz/components/maps/get_places.dart';
import 'package:ebuzz/components/maps/place_search.dart';
import 'package:ebuzz/components/warning_popup.dart';
import 'package:ebuzz/constants/constant.dart';
import 'package:ebuzz/models/user_model.dart';
import 'package:ebuzz/providers/user.dart';
import 'package:ebuzz/providers/users.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location_package;
import 'package:provider/provider.dart';
import 'package:flutter_animarker/flutter_map_marker_animation.dart';

class MapScreen extends StatefulWidget {
  static const String routeName = 'map0-screen';
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  AnimationController animationControllerExplore;
  AnimationController animationControllerSearch;
  AnimationController animationControllerMenu;
  CurvedAnimation curve;
  Animation<double> animation;
  Animation<double> animationW;
  Animation<double> animationR;

  CameraPosition initialLocation;
  GoogleMapController _googleMapController;
  final controller = Completer<GoogleMapController>();
  Marker _origin;
  Marker _destination;
  Directions _info;
  Timer timer;
  String placeType;
  List<Marker> markers = [];
  List<PlaceSearch> autocompletePlaces = [];
  var _isLoading = false;

  /// get currentOffset percent
  get currentExplorePercent =>
      max(0.0, min(1.0, offsetExplore / (760.0 - 122.0)));
  get currentSearchPercent => max(0.0, min(1.0, offsetSearch / (347 - 68.0)));
  get currentMenuPercent => max(0.0, min(1.0, offsetMenu / 358));
  var offsetExplore = 0.0;
  var offsetSearch = 0.0;
  var offsetMenu = 0.0;
  bool isExploreOpen = false;
  bool isSearchOpen = false;
  bool isMenuOpen = false;

  /// search drag callback
  void onSearchHorizontalDragUpdate(details) {
    offsetSearch -= details.delta.dx;
    if (offsetSearch < 0) {
      offsetSearch = 0;
    } else if (offsetSearch > (347 - 68.0)) {
      offsetSearch = 347 - 68.0;
    }
    setState(() {});
  }

  /// explore drag callback
  void onExploreVerticalUpdate(details) {
    offsetExplore -= details.delta.dy;
    if (offsetExplore > 644) {
      offsetExplore = 644;
    } else if (offsetExplore < 0) {
      offsetExplore = 0;
    }
    setState(() {});
  }

  /// animate Explore
  ///
  /// if [open] is true , make Explore open
  /// else make Explore close
  void animateExplore(bool open) {
    animationControllerExplore = AnimationController(
        duration: Duration(
            milliseconds: 1 +
                (800 *
                        (isExploreOpen
                            ? currentExplorePercent
                            : (1 - currentExplorePercent)))
                    .toInt()),
        vsync: this);
    curve =
        CurvedAnimation(parent: animationControllerExplore, curve: Curves.ease);
    animation = Tween(begin: offsetExplore, end: open ? 760.0 - 122 : 0.0)
        .animate(curve)
          ..addListener(() {
            setState(() {
              offsetExplore = animation.value;
            });
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              isExploreOpen = open;
            }
          });
    animationControllerExplore.forward();
  }

  void animateSearch(bool open) {
    animationControllerSearch = AnimationController(
        duration: Duration(
            milliseconds: 1 +
                (800 *
                        (isSearchOpen
                            ? currentSearchPercent
                            : (1 - currentSearchPercent)))
                    .toInt()),
        vsync: this);
    curve =
        CurvedAnimation(parent: animationControllerSearch, curve: Curves.ease);
    animation = Tween(begin: offsetSearch, end: open ? 347.0 - 68.0 : 0.0)
        .animate(curve)
          ..addListener(() {
            setState(() {
              offsetSearch = animation.value;
            });
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              isSearchOpen = open;
            }
          });
    animationControllerSearch.forward();
  }

  void animateMenu(bool open) {
    animationControllerMenu =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    curve =
        CurvedAnimation(parent: animationControllerMenu, curve: Curves.ease);
    animation =
        Tween(begin: open ? 0.0 : 358.0, end: open ? 358.0 : 0.0).animate(curve)
          ..addListener(() {
            setState(() {
              offsetMenu = animation.value;
            });
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              isMenuOpen = open;
            }
          });
    animationControllerMenu.forward();
  }

  togglePlaceType(String value, bool selected) async {
    if (selected) {
      placeType = value;
    } else {
      placeType = null;
    }

    final locData = await location_package.Location().getLocation();
    if (placeType != null) {
      var places = await GetPlaces()
          .getPlaces(locData.latitude, locData.longitude, placeType);
      markers = [];
      if (places.length > 0) {
        places.forEach((place) {
          setState(() {
            markers.add(_origin);
            _getUsersLocation();
            markers.add(
              RippleMarker(
                  markerId: MarkerId(place['place_id']),
                  infoWindow: InfoWindow(title: place['name']),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueGreen),
                  position: LatLng(
                    place['geometry']['location']['lat'],
                    place['geometry']['location']['lng'],
                  ),
                  ripple: true, //Ripple state
                  onTap: () async {
                    _destination = RippleMarker(
                      markerId: MarkerId(place['place_id']),
                      infoWindow: InfoWindow(title: place['name']),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueGreen),
                      position: LatLng(
                        place['geometry']['location']['lat'],
                        place['geometry']['location']['lng'],
                      ),
                    );
                  }),
            );
          });
        });
      }
    }
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    timer?.cancel();
    animationControllerExplore?.dispose();
    animationControllerSearch?.dispose();
    animationControllerMenu?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    timer = Timer.periodic(Duration(seconds: 60), (Timer t) {
      _getCurrentUserLocation();
      _getUsersLocation();
    });
    _getCurrentUserLocation();
    _getUsersLocation();
    super.initState();
  }

  Future<void> _getCurrentUserLocation() async {
    final locData = await location_package.Location().getLocation();
    final user = Provider.of<User>(context, listen: false);

    setState(() {
      initialLocation = CameraPosition(
        zoom: 11.5,
        target: LatLng(locData.latitude, locData.longitude),
      );
      _origin = RippleMarker(
        markerId: MarkerId('${user.userData.id}'),
        ripple: true, //Ripple state
        infoWindow: InfoWindow(
            title: '${user.userData.firstName} ${user.userData.lastName}'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
        position: LatLng(locData.latitude, locData.longitude),
      );
      markers.add(_origin);
    });
  }

  Future<void> autocompletefn(String value) async {
    setState(() {
      _isLoading = true;
    });
    var results = await GetPlaces().getPlacesAutocomplete(value);
    setState(() {
      autocompletePlaces = results;
      _isLoading = false;
    });
  }

  Future<void> _getUsersLocation() async {
    try {
      await Provider.of<Users>(context, listen: false).viewUsers();
      List<UserModel> myData = Provider.of<Users>(context, listen: false).items;
      setState(() {
        if (myData.length > 0) {
          myData.forEach((user) async {
            if (user.latitude != null && user.longitude != null) {
              // final int targetWidth = 80;
              // var iconurl = user.photo;
              // var request = await http.get(Uri.parse(iconurl));
              // var bytes = request.bodyBytes;

              // final Codec markerImageCodec = await instantiateImageCodec(
              //   bytes,
              //   targetWidth: targetWidth,
              // );

              // final FrameInfo frameInfo = await markerImageCodec.getNextFrame();
              // final ByteData byteData = await frameInfo.image.toByteData(
              //   format: ImageByteFormat.png,
              // );

              // final Uint8List resizedMarkerImageBytes =
              //     byteData.buffer.asUint8List();
              markers.add(
                Marker(
                  markerId: MarkerId('${user.id}'),
                  infoWindow:
                      InfoWindow(title: '${user.firstName} ${user.lastName}'),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueViolet),
                  position: LatLng(user.latitude, user.longitude),
                  onTap: () async {
                    setState(() {
                      _destination = RippleMarker(
                        markerId: MarkerId('${user.id}'),
                        infoWindow: InfoWindow(
                            title: '${user.firstName} ${user.lastName}'),
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueViolet),
                        position: LatLng(user.latitude, user.longitude),
                        ripple: true, //Ripple state
                      );
                      markers.add(_destination);
                    });
                  },
                ),
              );
            }
          });
        }
      });
    } catch (error) {
      print(error);
      WarningPopup.showWarningDialog(
          context, false, 'SomeThing Went Wrong!@!..', () {});
      return;
    }
  }

  Future<void> _goToPlace(String placeId) async {
    var results = await GetPlaces().getPlaceDetails(placeId);
    animateSearch(false);
    final GoogleMapController tmpcontroller = await controller.future;
    tmpcontroller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(results['lat'], results['lng']),
          zoom: 14.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context).settings.arguments as Map<String, double>;
    initialLocation = CameraPosition(
      zoom: 11.5,
      target: LatLng(args['latitude'], args['longitude']),
    );
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      drawer: Drawer(
        child: MyDrawer(),
      ),
      body: SizedBox(
        width: screenWidth,
        height: screenHeight,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Animarker(
              curve: Curves.bounceInOut,
              rippleRadius: 0.2,
              useRotation: true,
              duration: Duration(milliseconds: 2300),
              mapId: controller.future.then<int>((value) => value.mapId),
              child: GoogleMap(
                myLocationEnabled: false,
                zoomControlsEnabled: false,
                compassEnabled: true,
                initialCameraPosition: initialLocation,
                onMapCreated: (gController) {
                  _googleMapController = gController;
                  controller.complete(gController);
                },
                polylines: {
                  if (_info != null)
                    Polyline(
                      polylineId: const PolylineId('overview_polyline'),
                      color: Colors.red,
                      width: 5,
                      points: _info.polylinePoints
                          .map((e) => LatLng(e.latitude, e.longitude))
                          .toList(),
                    )
                },
                markers: Set<Marker>.of(markers),
                onTap: (pos) async {
                  setState(() {
                    _destination = RippleMarker(
                      markerId: MarkerId('destination'),
                      infoWindow: InfoWindow(title: ('Destination')),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueRed),
                      position: pos,
                      ripple: true, //Ripple state
                    );
                    markers.add(_destination);
                  });
                },
              ),
            ),
            if (_info != null)
              Positioned(
                top: 20.0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6.0,
                    horizontal: 12.0,
                  ),
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: const [
                      BoxShadow(
                        color: white,
                        offset: Offset(0, 2),
                        blurRadius: 6.0,
                      )
                    ],
                  ),
                  child: Text(
                    '${_info.totalDistance}, ${_info.totalDuration}',
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: white,
                    ),
                  ),
                ),
              ),
            //explore
            ExploreWidget(
              currentExplorePercent: currentExplorePercent,
              currentSearchPercent: currentSearchPercent,
              animateExplore: animateExplore,
              isExploreOpen: isExploreOpen,
              onVerticalDragUpdate: onExploreVerticalUpdate,
              onPanDown: () => animationControllerExplore?.stop(),
            ),
            //blur
            offsetSearch != 0
                ? BackdropFilter(
                    filter: ImageFilter.blur(
                        sigmaX: 10 * currentSearchPercent,
                        sigmaY: 10 * currentSearchPercent),
                    child: Container(
                      color:
                          Colors.white.withOpacity(0.1 * currentSearchPercent),
                      width: screenWidth,
                      height: screenHeight,
                    ),
                  )
                : const Padding(
                    padding: const EdgeInsets.all(0),
                  ),
            //explore content
            ExploreContentWidget(
              currentExplorePercent: currentExplorePercent,
              isExploreOpen: isExploreOpen,
              animateExplore: animateExplore,
              togglePlaceType: togglePlaceType,
            ),
            //recent search
            _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Positioned(
                    top: realH(-(75.0 + 494.0) +
                        (75 + 75.0 + 494.0) * currentSearchPercent),
                    left: realW((standardWidth - 320) / 2),
                    width: realW(320),
                    height: realH(494),
                    child: Opacity(
                      opacity: currentSearchPercent,
                      child: Container(
                        width: double.infinity,
                        child: ListView.builder(
                            itemCount: autocompletePlaces.length,
                            itemBuilder: (ctx, index) {
                              return InkWell(
                                onTap: () {
                                  _goToPlace(autocompletePlaces[index].placeId);
                                },
                                child:
                                    Text(autocompletePlaces[index].description),
                              );
                            }),
                      ),
                    ),
                  ),
            //search button
            SearchWidget(
              currentSearchPercent: currentSearchPercent,
              currentExplorePercent: currentExplorePercent,
              isSearchOpen: isSearchOpen,
              animateSearch: animateSearch,
              onHorizontalDragUpdate: onSearchHorizontalDragUpdate,
              onPanDown: () => animationControllerSearch?.stop(),
            ),
            //search back
            SearchBackWidget(
              currentSearchPercent: currentSearchPercent,
              animateSearch: animateSearch,
              searchfn: autocompletefn,
            ),
            //zoom button
            MapButton(
              onpress: () => _googleMapController.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: _origin.position,
                    zoom: 15.5,
                    tilt: 50.5,
                  ),
                ),
              ),
              currentExplorePercent: currentExplorePercent,
              currentSearchPercent: currentSearchPercent,
              bottom: 243,
              offsetX: -71,
              width: 71,
              height: 71,
              isRight: false,
              icon: Icons.center_focus_strong,
            ),
            //directions button
            MapButton(
              onpress: () async {
                if (_origin != null && _destination != null) {
                  final directions = await DirectionsRepository().getDirections(
                    origin: _origin.position,
                    destination: _destination.position,
                  );
                  setState(() => _info = directions);
                }
              },
              currentSearchPercent: currentSearchPercent,
              currentExplorePercent: currentExplorePercent,
              bottom: 243,
              offsetX: -68,
              width: 68,
              height: 71,
              icon: Icons.directions,
              iconColor: Colors.white,
              gradient: const LinearGradient(colors: [
                Color(0xFFe5383b),
                Color(0xFFba181b),
                Color(0xFF660708),
              ]),
            ),
            //my_location button
            MapButton(
              onpress: () => _googleMapController.animateCamera(
                _info != null
                    ? CameraUpdate.newLatLngBounds(_info.bounds, 100.0)
                    : CameraUpdate.newCameraPosition(initialLocation),
              ),
              currentSearchPercent: currentSearchPercent,
              currentExplorePercent: currentExplorePercent,
              bottom: 148,
              offsetX: -68,
              width: 68,
              height: 71,
              icon: Icons.my_location,
              iconColor: primary,
            ),
          ],
        ),
      ),
    );
  }
}
