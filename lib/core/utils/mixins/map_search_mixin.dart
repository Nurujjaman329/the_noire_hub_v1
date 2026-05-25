import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:dio/dio.dart' as dio_instance;

mixin MapSearchMixin on GetxController {
  final searchController = TextEditingController();
  final String googleApiKey = "AIzaSyDi6UV_eBl9BZgd7MZNYGJV2jjLd1o9I4I";

  // static const String _googleApiKey = String.fromEnvironment(
  //     'GOOGLE_MAPS_API_KEY',
  //     defaultValue: 'KEY_NOT_FOUND'
  // );
  //
  //
  // final String googleApiKey = _googleApiKey;

  GoogleMapController? mapController;
  var selectedLatLng = const LatLng(23.8311, 90.4243).obs;
  var currentAddressString = ''.obs;
  var selectedCity = 'Dhaka'.obs;
  var selectedCountry = 'Bangladesh'.obs;
  var placePredictions = <Map<String, dynamic>>[].obs;
  Timer? _debounce;

// ===================== DISTANCE & DURATION =====================


  var distanceInMeters = 0.obs;
  var durationInSeconds = 0.obs;
  var distanceText = ''.obs;
  var durationText = ''.obs;
  LatLng? sourceLatLng;

  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () => getSuggestions(query));
  }

  Future<void> getSuggestions(String query) async {
    if (query.isEmpty) {
      placePredictions.clear();
      return;
    }
    try {
      final url = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$googleApiKey";
      final response = await dio_instance.Dio().get(url);
      if (response.statusCode == 200) {
        final List predictions = response.data['predictions'];
        placePredictions.assignAll(predictions.cast<Map<String, dynamic>>());
      }
    } catch (e) {
      debugPrint("Autocomplete Error: $e");
    }
  }

  Future<void> selectPrediction(Map<String, dynamic> prediction) async {
    String placeId = prediction['place_id'];
    searchController.text = prediction['description'] ?? "";
    placePredictions.clear();
    try {
      final detailUrl = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$googleApiKey";
      final response = await dio_instance.Dio().get(detailUrl);
      if (response.statusCode == 200) {
        final result = response.data['result'] as Map<String, dynamic>? ?? {};
        final location = result['geometry']?['location'] as Map<String, dynamic>?;
        if (location == null) return;

        final latLng = LatLng(location['lat'], location['lng']);

        // Prefer authoritative address components from Place Details.
        final components = (result['address_components'] as List<dynamic>? ?? [])
            .whereType<Map<String, dynamic>>()
            .toList();

        String? cityFromComponents;
        String? countryFromComponents;

        for (final component in components) {
          final types = (component['types'] as List<dynamic>? ?? []).map((e) => e.toString()).toList();
          if (countryFromComponents == null && types.contains('country')) {
            countryFromComponents = (component['long_name'] ?? '').toString();
          }
          if (cityFromComponents == null &&
              (types.contains('locality') ||
                  types.contains('postal_town') ||
                  types.contains('administrative_area_level_2') ||
                  types.contains('administrative_area_level_1'))) {
            cityFromComponents = (component['long_name'] ?? '').toString();
          }
        }

        if ((cityFromComponents ?? '').isNotEmpty) {
          selectedCity.value = cityFromComponents!;
        }
        if ((countryFromComponents ?? '').isNotEmpty) {
          selectedCountry.value = countryFromComponents!;
        }

        final formattedAddress = (result['formatted_address'] ?? prediction['description'] ?? '').toString();
        if (formattedAddress.isNotEmpty) {
          currentAddressString.value = formattedAddress;
        }

        // Keep marker movement + reverse geocoding as secondary sync.
        await updateLocation(latLng);
        FocusManager.instance.primaryFocus?.unfocus();
      }
    } catch (e) {
      debugPrint("Place Details Error: $e");
    }
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    Position position = await Geolocator.getCurrentPosition();
    updateLocation(LatLng(position.latitude, position.longitude));
  }

  Future<void> updateLocation(LatLng latLng) async {
    selectedLatLng.value = latLng;
    mapController?.animateCamera(CameraUpdate.newLatLng(latLng));
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        final resolvedCity = (place.locality?.trim().isNotEmpty == true)
            ? place.locality!
            : (place.subAdministrativeArea?.trim().isNotEmpty == true)
                ? place.subAdministrativeArea!
                : (place.administrativeArea ?? '');
        final resolvedCountry = place.country ?? '';

        if (resolvedCity.trim().isNotEmpty) {
          selectedCity.value = resolvedCity;
        }
        if (resolvedCountry.trim().isNotEmpty) {
          selectedCountry.value = resolvedCountry;
        }
        currentAddressString.value = "${place.street}, ${place.locality}, ${place.country}";
      }
    } catch (e) {
      debugPrint("Reverse Geocoding Error: $e");
    }
  }

  void onMapCreated(GoogleMapController controller) => mapController = controller;


  Future<void> calculateDistance({
    required LatLng origin,
    required LatLng destination,
    String mode = 'driving', // driving | walking | bicycling
  }) async {
    try {
      final url =
          'https://maps.googleapis.com/maps/api/directions/json'
          '?origin=${origin.latitude},${origin.longitude}'
          '&destination=${destination.latitude},${destination.longitude}'
          '&mode=$mode'
          '&key=$googleApiKey';

      final response = await dio_instance.Dio().get(url);

      if (response.statusCode == 200 &&
          response.data['routes'].isNotEmpty) {
        final leg = response.data['routes'][0]['legs'][0];

        distanceInMeters.value = leg['distance']['value'];
        durationInSeconds.value = leg['duration']['value'];
        distanceText.value = leg['distance']['text'];
        durationText.value = leg['duration']['text'];
      }
    } catch (e) {
      debugPrint("Distance calculation error: $e");
    }
  }


  void disposeMapMixin() {
    searchController.dispose();
    _debounce?.cancel();
  }
}