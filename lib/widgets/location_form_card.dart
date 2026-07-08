import 'package:flutter/material.dart';

import '../data/tokyo_places.dart';
import '../models/place.dart';
import 'app_card.dart';

class LocationFormCard extends StatelessWidget {
  const LocationFormCard({
    super.key,
    required this.pickup,
    required this.dropoff,
    required this.passengers,
    required this.departureTime,
    required this.onPickupChanged,
    required this.onDropoffChanged,
    required this.onPassengersChanged,
    required this.onDepartureTimeChanged,
  });

  final Place pickup;
  final Place dropoff;
  final int passengers;
  final String departureTime;
  final ValueChanged<Place?> onPickupChanged;
  final ValueChanged<Place?> onDropoffChanged;
  final ValueChanged<int?> onPassengersChanged;
  final ValueChanged<String?> onDepartureTimeChanged;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          DropdownButtonFormField<Place>(
            initialValue: pickup,
            decoration: const InputDecoration(
              labelText: '乗車地',
              prefixIcon: Icon(Icons.trip_origin),
            ),
            items: tokyoPlaces
                .map(
                  (place) => DropdownMenuItem(
                    value: place,
                    child: Text(place.name),
                  ),
                )
                .toList(),
            onChanged: onPickupChanged,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<Place>(
            initialValue: dropoff,
            decoration: const InputDecoration(
              labelText: '目的地',
              prefixIcon: Icon(Icons.place),
            ),
            items: tokyoPlaces
                .map(
                  (place) => DropdownMenuItem(
                    value: place,
                    child: Text(place.name),
                  ),
                )
                .toList(),
            onChanged: onDropoffChanged,
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 520;
              if (wide) {
                return Row(
                  children: [
                    Expanded(
                      child: _PassengerField(
                        passengers: passengers,
                        onChanged: onPassengersChanged,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _DepartureTimeField(
                        departureTime: departureTime,
                        onChanged: onDepartureTimeChanged,
                      ),
                    ),
                  ],
                );
              }

              return Column(
                children: [
                  _PassengerField(
                    passengers: passengers,
                    onChanged: onPassengersChanged,
                  ),
                  const SizedBox(height: 12),
                  _DepartureTimeField(
                    departureTime: departureTime,
                    onChanged: onDepartureTimeChanged,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PassengerField extends StatelessWidget {
  const _PassengerField({
    required this.passengers,
    required this.onChanged,
  });

  final int passengers;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      initialValue: passengers,
      decoration: const InputDecoration(
        labelText: '乗車人数',
        prefixIcon: Icon(Icons.group),
      ),
      items: [1, 2, 3, 4]
          .map(
            (count) => DropdownMenuItem(
              value: count,
              child: Text('$count'),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}

class _DepartureTimeField extends StatelessWidget {
  const _DepartureTimeField({
    required this.departureTime,
    required this.onChanged,
  });

  final String departureTime;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: departureTime,
      decoration: const InputDecoration(
        labelText: '希望時刻',
        prefixIcon: Icon(Icons.schedule),
      ),
      items: departureTimes
          .map(
            (time) => DropdownMenuItem(
              value: time,
              child: Text(time),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}
