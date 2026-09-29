import 'dart:io';
import 'package:backend_api/src/data/mock_database.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:shared_models/shared_models.dart';

Response onRequest(RequestContext context) {
  if (context.request.method != HttpMethod.get) {
    return Response.json(
      statusCode: HttpStatus.methodNotAllowed,
      body: ApiResponse<dynamic>.error(error: 'Method not allowed').toJson((_) => null),
    );
  }

  final params = context.request.uri.queryParameters;
  final categoryFilter = params['category'];
  final searchQuery = params['q']?.toLowerCase();
  final featuredOnly = params['featured'] == 'true';

  var products = MockDatabase.products;

  if (categoryFilter != null && categoryFilter.isNotEmpty && categoryFilter != 'all') {
    products = products.where((p) => p.categoryId == categoryFilter || p.category?.slug == categoryFilter).toList();
  }

  if (searchQuery != null && searchQuery.isNotEmpty) {
    products = products.where((p) =>
      p.title.toLowerCase().contains(searchQuery) ||
      p.description.toLowerCase().contains(searchQuery) ||
      p.vendorName.toLowerCase().contains(searchQuery)
    ).toList();
  }

  if (featuredOnly) {
    products = products.where((p) => p.isFeatured).toList();
  }

  final response = ApiResponse<List<dynamic>>.success(
    data: products.map((p) => p.toJson()).toList(),
    meta: {
      'total': products.length,
      'filtered_by': {
        if (categoryFilter != null) 'category': categoryFilter,
        if (searchQuery != null) 'query': searchQuery,
        if (featuredOnly) 'featured': true,
      },
    },
    message: 'Products fetched successfully',
  );

  return Response.json(body: response.toJson((data) => data));
}
