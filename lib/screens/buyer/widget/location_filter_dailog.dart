import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationFilterDialog extends StatefulWidget {
  final Position? initialLocation;
  final double initialRadius;

  const LocationFilterDialog({
    super.key,
    this.initialLocation,
    required this.initialRadius,
  });

  @override
  State<LocationFilterDialog> createState() => _LocationFilterDialogState();
}

class _LocationFilterDialogState extends State<LocationFilterDialog> {
  Position? _selectedLocation;
  double _radius = 5.0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLocation;
    _radius = widget.initialRadius;
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoading = true);
    try {
      final Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _selectedLocation = position;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not get current location')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Filter Shops by Location',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (_selectedLocation != null) ...[
              Text(
                'Selected Location: ${_selectedLocation!.latitude.toStringAsFixed(4)}, ${_selectedLocation!.longitude.toStringAsFixed(4)}',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8),
            ],
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _getCurrentLocation,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.my_location),
              label: Text(
                  _isLoading ? 'Getting Location...' : 'Use Current Location'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text('Radius: ${_radius.toStringAsFixed(1)} km'),
            Slider(
              value: _radius,
              min: 1,
              max: 20,
              divisions: 19,
              label: '${_radius.toStringAsFixed(1)} km',
              onChanged: (value) => setState(() => _radius = value),
              activeColor: const Color(0xFF4CAF50),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => Navigator.pop(
                    context,
                    {
                      'location': _selectedLocation,
                      'radius': _radius,
                    },
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Apply Filter'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
