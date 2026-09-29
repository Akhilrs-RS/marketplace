# Galletrix Marketplace (Full-Stack Dart & Flutter)

A modern full-stack mobile marketplace application built entirely in **Dart**:
- **Mobile Frontend (`apps/mobile_app`)**: Built with **Flutter 3.44+**, **Flutter Bloc (Cubit)**, and **Material 3**. Supports iOS, Android, and Web with dark/light themes, product browsing, dynamic filtering, interactive cart, orders tracking, and user profile management.
- **Backend API (`apps/backend_api`)**: Built with **Dart Frog (1.2.14)**. Provides RESTful endpoints for categories, products, search, cart synchronization, orders, and authentication with CORS & error handling middleware.
- **Shared Domain Package (`packages/shared_models`)**: Shared Dart models (User, Product, Category, CartItem, Order, ApiResponse) shared between frontend and backend without code duplication.

---

## 📁 Repository Structure

```
Marketplace/
├── apps/
│   ├── mobile_app/                          # 📱 Flutter Mobile App (iOS / Android / Web)
│   │   ├── lib/
│   │   │   ├── main.dart                    # App bootstrap & navigation tabs
│   │   │   ├── core/
│   │   │   │   ├── services/api_service.dart # HTTP client connecting to backend
│   │   │   │   └── theme/app_theme.dart     # Material 3 dark/light themes & colors
│   │   │   └── features/
│   │   │       ├── home/                    # Discovery, search, promo banners, grid
│   │   │       ├── products/                # Product details, image gallery, specs
│   │   │       ├── cart/                    # Cart state, item increments, checkout
│   │   │       ├── orders/                  # Live order status & delivery tracking
│   │   │       └── profile/                 # VIP account, addresses, preferences
│   │   └── test/widget_test.dart            # Flutter widget automated tests
│   │
│   └── backend_api/                         # 🚀 Dart Frog Backend API
│       ├── routes/
│       │   ├── _middleware.dart             # Global CORS & request logging
│       │   └── api/
│       │       ├── categories/index.dart    # GET /api/categories
│       │       ├── products/
│       │       │   ├── index.dart           # GET /api/products (filter & search)
│       │       │   └── [id].dart            # GET /api/products/:id
│       │       ├── cart/index.dart          # GET, POST, DELETE /api/cart
│       │       └── orders/index.dart        # GET, POST /api/orders
│       ├── lib/src/data/mock_database.dart  # In-memory mock database & seed items
│       └── test/routes/                     # Route integration tests
│
└── packages/
    └── shared_models/                       # 📦 Shared Dart Models & Contracts
        ├── lib/
        │   ├── shared_models.dart           # Barrel exports
        │   └── src/                         # User, Product, Category, Cart, Order, ApiResponse
        └── pubspec.yaml
```

---

## 🚀 Getting Started

### 1. Run the Backend API Server
```bash
cd apps/backend_api
dart_frog dev
```
The API server will start on `http://localhost:8080`.
- Health check: `http://localhost:8080`
- Products API: `http://localhost:8080/api/products`
- Categories API: `http://localhost:8080/api/categories`

### 2. Run the Flutter Mobile App
In another terminal:
```bash
cd apps/mobile_app
flutter run
```
You can select iOS Simulator, Android Emulator, macOS Desktop, or Chrome browser.

### 3. Run Automated Tests
- Mobile app tests:
  ```bash
  cd apps/mobile_app && flutter test
  ```
- Backend API tests:
  ```bash
  cd apps/backend_api && dart test
  ```
