import 'dart:io';
import 'package:backend_api/src/data/mock_database.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:shared_models/shared_models.dart';

Response onRequest(RequestContext context, String id) {
  if (context.request.method != HttpMethod.get) {
    return Response.json(
      statusCode: HttpStatus.methodNotAllowed,
      body: ApiResponse<dynamic>.error(error: 'Method not allowed').toJson((_) => null),
    );
  }

  // Look for exact vehicle detail spec or fallback to listing data
  var detail = MockDatabase.vehicleDetails[id];
  if (detail == null) {
    try {
      final listing = MockDatabase.listings.firstWhere(
        (l) => l.id == id || l.category == 'Vehicles' || l.title.contains('Creta'),
      );
      detail = VehicleDetail(
        listingId: listing.id,
        title: listing.title,
        price: listing.formattedPrice,
        imagePath: listing.imagePath,
        location: listing.location,
        totalCapacity: (listing.specifications['total_capacity'] as String?) ?? '6 Seats',
        highestSpeed: (listing.specifications['highest_speed'] as String?) ?? '200 KM/H',
        engineOutput: (listing.specifications['engine_output'] as String?) ?? '500 HP',
        fuelType: (listing.specifications['fuel_type'] as String?) ?? 'Petrol',
        transmission: (listing.specifications['transmission'] as String?) ?? 'Automatic',
        owner: (listing.specifications['owner'] as String?) ?? '1st Owner • Verified',
        description: listing.description,
        highlights: const [
          'Panoramic Sunroof',
          'Bose 8-Speaker Audio',
          'Wireless Phone Charger',
        ],
      );
    } catch (_) {
      detail = MockDatabase.vehicleDetails['list_creta_2022'];
    }
  }

  final response = ApiResponse<Map<String, dynamic>>.success(
    data: detail!.toJson(),
    message: 'Vehicle details retrieved successfully',
  );

  return Response.json(body: response.toJson((data) => data));
}
