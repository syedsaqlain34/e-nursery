import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class AlternativeMapScreen extends StatefulWidget {
  final LatLng? initialLocation;
  const AlternativeMapScreen({super.key, this.initialLocation});

  @override
  State<AlternativeMapScreen> createState() => _AlternativeMapScreenState();
}

class _AlternativeMapScreenState extends State<AlternativeMapScreen>
    with SingleTickerProviderStateMixin {
  static const String apiKey = 'AIzaSyBk2DwzAdLpFvZG-h0iGZgNS6xi8GyrOMo';

  // Map related variables
  CameraPosition? initialCameraPosition;
  bool servicesEnabled = false;
  late Position position;
  LatLng? currentSelectedPosition;
  Set<Marker> markersList = {};
  double? getLat, getLng;
  late GoogleMapController googleMapController;

  // Search related variables
  final searchController = TextEditingController();
  bool isSearchFocused = false;
  List<dynamic> searchPredictions = [];
  bool isLoading = false;
  Timer? _debounce;
  String placeName = "";
  bool isDecodingAddress = false;

  // Animation controller for search suggestions
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    getPosition();
    _setupAnimations();
  }

  Future<void> getPosition() async {
    try {
      position = await _determinePosition();
      currentSelectedPosition = LatLng(position.latitude, position.longitude);
      initialCameraPosition = CameraPosition(
        target: currentSelectedPosition!,
        zoom: 18,
      );
      markersList.add(
        Marker(
          markerId: const MarkerId("1"),
          position: currentSelectedPosition!,
        ),
      );
      setState(() {
        servicesEnabled = true;
      });
      await convertPointsToAddress();
    } catch (e) {
      print('Error getting position: $e');
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    return await Geolocator.getCurrentPosition();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  Future<void> _onSearchChanged(String query) async {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        // Only search if query is not empty
        _handlePlaceSelection();
      }
    });
  }

  Future<void> _handlePlaceSelection() async {
    if (searchController.text.isEmpty) {
      setState(() {
        searchPredictions = [];
        isLoading = false;
      });
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await http.get(
        Uri.parse(
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?'
          'input=${Uri.encodeComponent(searchController.text)}' // Encode the search text
          '&key=$apiKey'
          '&components=country:us|country:pk'
          '&types=geocode|establishment',
        ),
      );

      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        setState(() {
          searchPredictions = data['predictions'];
          isLoading = false;
        });
        if (!_animationController.isAnimating) {
          _animationController.forward();
        }
      } else {
        setState(() {
          searchPredictions = [];
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
      print('Error searching places: $e');
    }
  }

  // Add a new method to handle suggestion selection:
  void _onSuggestionSelected(dynamic prediction) {
    _getPlaceDetails(prediction['place_id']);
    _animationController.reverse();
    setState(() => isSearchFocused = false);
    FocusScope.of(context).unfocus();
  }

  Widget _buildSearchSuggestions() {
    return FadeTransition(
      opacity: _animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -0.1),
          end: Offset.zero,
        ).animate(_animation),
        child: Container(
          margin: const EdgeInsets.only(top: 65),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (isLoading)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (searchPredictions.isEmpty &&
                      searchController.text.isNotEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('No results found'),
                    )
                  else
                    ...searchPredictions.map((prediction) => InkWell(
                          onTap: () => _onSuggestionSelected(prediction),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey.withOpacity(0.2),
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.location_on_outlined),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        prediction['structured_formatting']
                                            ['main_text'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        prediction['structured_formatting']
                                                ['secondary_text'] ??
                                            '',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 12,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _getPlaceDetails(String placeId) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey&fields=formatted_address,name,geometry'),
      );

      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        final result = data['result'];
        final location = result['geometry']['location'];
        final latLng = LatLng(location['lat'], location['lng']);

        googleMapController.animateCamera(
          CameraUpdate.newLatLngZoom(latLng, 14.0),
        );

        markersList.clear();
        markersList.add(
          Marker(
            markerId: const MarkerId("1"),
            position: latLng,
            infoWindow: InfoWindow(title: result['name']),
          ),
        );

        setState(() {
          currentSelectedPosition = latLng;
          getLat = latLng.latitude;
          getLng = latLng.longitude;
          placeName = result['formatted_address'];
          searchController.text = result['name'];
        });
      }
    } catch (e) {
      print('Error getting place details: $e');
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await _determinePosition();
      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 14,
          ),
        ),
      );

      markersList.clear();
      markersList.add(
        Marker(
          markerId: const MarkerId('1'),
          position: LatLng(position.latitude, position.longitude),
        ),
      );

      setState(() {
        getLat = position.latitude;
        getLng = position.longitude;
        currentSelectedPosition = LatLng(position.latitude, position.longitude);
      });

      await convertPointsToAddress();
    } catch (e) {
      print('Error getting current location: $e');
    }
  }

  Future<void> convertPointsToAddress() async {
    if (currentSelectedPosition == null) return;

    setState(() => isDecodingAddress = true);

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        currentSelectedPosition!.latitude,
        currentSelectedPosition!.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        setState(() {
          placeName =
              "${place.thoroughfare ?? ''}, ${place.subLocality ?? ''}, ${place.locality ?? ''}"
                  .replaceAll(RegExp(r', ,'), ',')
                  .replaceAll(RegExp(r'^,\s*|\s*,$'), '');
          getLat = currentSelectedPosition!.latitude;
          getLng = currentSelectedPosition!.longitude;
        });
      }
    } catch (e) {
      print('Error converting coordinates to address: $e');
    } finally {
      setState(() => isDecodingAddress = false);
    }
  }

  void _updateMarkerPosition(LatLng latLng) {
    markersList.clear();
    markersList.add(
      Marker(
        markerId: const MarkerId("1"),
        position: latLng,
      ),
    );

    setState(() => currentSelectedPosition = latLng);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !servicesEnabled
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: initialCameraPosition!,
                  markers: markersList,
                  mapType: MapType.normal,
                  zoomControlsEnabled: false,
                  myLocationEnabled: false,
                  onMapCreated: (GoogleMapController controller) {
                    googleMapController = controller;
                  },
                  onCameraMove: (position) {
                    currentSelectedPosition = position.target;
                    _updateMarkerPosition(position.target);
                  },
                  onCameraIdle: () {
                    convertPointsToAddress();
                  },
                  onTap: (_) {
                    if (isSearchFocused) {
                      FocusScope.of(context).unfocus();
                      _animationController.reverse();
                    }
                  },
                ),
                // Search Bar with Animation

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              if (currentSelectedPosition != null &&
                                  placeName.isNotEmpty) {
                                // Return both position and address
                                Navigator.pop(context, {
                                  'position': currentSelectedPosition,
                                  'address': placeName,
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              "Confirm Location",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: _getCurrentLocation,
                        child: Container(
                          margin: const EdgeInsets.all(12),
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.location_searching,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 55),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(6.r),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            color: Colors.blue.withAlpha(255),
                          ),
                          child: isDecodingAddress
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  placeName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                        ),
                        SizedBox(height: 3.h),
                        SvgPicture.asset(
                          'assets/static_assets/map-marker.svg',
                          color: Colors.blue.withOpacity(.3),
                          height: 50.h,
                          width: 100.w,
                        ),
                      ],
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: isSearchFocused ? 45 : 45,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: Icon(
                              isSearchFocused
                                  ? Icons.arrow_back
                                  : Icons.arrow_back,
                              color: Colors.black87,
                            ),
                            onPressed: () {
                              if (isSearchFocused) {
                                setState(() {
                                  isSearchFocused = false;
                                  searchController.clear();
                                  searchPredictions = [];
                                });
                                _animationController.reverse();
                                FocusScope.of(context).unfocus();
                              } else {
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            height: 45,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: searchController,
                              autofocus:
                                  false, // Set to true if you want keyboard to open automatically
                              textInputAction: TextInputAction.search,
                              decoration: InputDecoration(
                                hintText: 'Search location',
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                suffixIcon: isLoading
                                    ? const Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: SizedBox(
                                          width: 10,
                                          height: 10,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      )
                                    : IconButton(
                                        icon: const Icon(Icons.search),
                                        onPressed: () {
                                          if (searchController
                                              .text.isNotEmpty) {
                                            _handlePlaceSelection();
                                          }
                                        },
                                      ),
                              ),
                              onChanged: (value) {
                                setState(() => isSearchFocused = true);
                                _onSearchChanged(value);
                              },
                              onTap: () {
                                setState(() {
                                  isSearchFocused = true;
                                  // Show suggestions if there's existing text
                                  if (searchController.text.isNotEmpty) {
                                    _handlePlaceSelection();
                                  }
                                });
                              },
                              onSubmitted: (value) {
                                if (value.isNotEmpty) {
                                  _handlePlaceSelection();
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (isSearchFocused) _buildSearchSuggestions(),

                // Location Display and Bottom Buttons remain the same
                // ... (Your existing UI components)
              ],
            ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}
