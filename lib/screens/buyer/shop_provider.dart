import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShopFilterProvider extends ChangeNotifier {
  String _searchQuery = '';
  LatLng? _selectedLocation;
  double _radius = 10.0; // Default 50km radius
  String? _selectedAddress;

  String get searchQuery => _searchQuery;
  LatLng? get selectedLocation => _selectedLocation;
  double get radius => _radius;
  String? get selectedAddress => _selectedAddress;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setLocationFilter(LatLng? location, String? address) {
    _selectedLocation = location;
    _selectedAddress = address;
    notifyListeners();
  }

  void setRadius(double value) {
    _radius = value;
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedLocation = null;
    _selectedAddress = null;
    _radius = 50.0;
    notifyListeners();
  }

  bool shopMatchesFilters(String shopName, double shopLat, double shopLng) {
    if (shopLat == 0 && shopLng == 0) {
      print('Invalid shop coordinates for $shopName');
      return false;
    }

    // First check if shop name matches search query
    if (searchQuery.isNotEmpty &&
        !shopName.toLowerCase().contains(searchQuery.toLowerCase())) {
      return false;
    }

    // If no location filter is set, return true
    if (selectedLocation == null) {
      return true;
    }

    // Calculate distance between selected location and shop
    final distance = Geolocator.distanceBetween(
      selectedLocation!.latitude,
      selectedLocation!.longitude,
      shopLat,
      shopLng,
    );

    print('Shop: $shopName');
    print('Shop coordinates: $shopLat, $shopLng');
    print(
        'Selected location: ${selectedLocation!.latitude}, ${selectedLocation!.longitude}');
    print('Distance: ${distance / 1000}km');
    print('Within radius? ${distance <= radius * 1000}');

    // Convert radius to meters (since distanceBetween returns meters)
    return distance <= radius * 1000;
  }
}
