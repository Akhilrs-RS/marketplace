import 'dart:io';
import 'package:backend_api/src/data/mock_database.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:shared_models/shared_models.dart';

Future<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return _getProfile();
    case HttpMethod.patch:
      return _updateProfile(context);
    default:
      return Response.json(
        statusCode: HttpStatus.methodNotAllowed,
        body: ApiResponse<dynamic>.error(error: 'Method not allowed').toJson((_) => null),
      );
  }
}

Response _getProfile() {
  final profile = MockDatabase.userProfile;
  final response = ApiResponse<Map<String, dynamic>>.success(
    data: profile.toJson(),
    message: 'Profile retrieved successfully',
  );
  return Response.json(body: response.toJson((data) => data));
}

Future<Response> _updateProfile(RequestContext context) async {
  try {
    final body = await context.request.json() as Map<String, dynamic>;
    final existing = MockDatabase.userProfile;

    final updated = UserProfile(
      id: existing.id,
      name: body['name'] as String? ?? existing.name,
      phone: body['phone'] as String? ?? existing.phone,
      email: body['email'] as String? ?? existing.email,
      address: body['address'] as String? ?? existing.address,
      avatarUrl: body['avatar_url'] as String? ?? existing.avatarUrl,
      favoritesCount: existing.favoritesCount,
      savedSearchesCount: existing.savedSearchesCount,
      recentlyViewedCount: existing.recentlyViewedCount,
      activeEnquiriesCount: existing.activeEnquiriesCount,
    );

    MockDatabase.userProfile = updated;

    final response = ApiResponse<Map<String, dynamic>>.success(
      data: updated.toJson(),
      message: 'Profile updated successfully',
    );
    return Response.json(body: response.toJson((data) => data));
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: ApiResponse<dynamic>.error(error: 'Failed to update profile: $e').toJson((_) => null),
    );
  }
}
