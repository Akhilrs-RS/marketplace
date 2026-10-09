import 'package:flutter/material.dart';
import 'core/services/api_service.dart';
import 'main.dart';

/// Standalone entry point for the Marketplace Hub Admin Application.
///
/// This application runs independently with direct access to Marketplace Hub
/// and connects to the shared MySQL database backend.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final apiService = ApiService();
  runApp(GalletrixMarketplaceApp(
    apiService: apiService,
    startAsAdmin: true,
  ));
}
