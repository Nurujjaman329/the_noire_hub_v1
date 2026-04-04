# The Noire Hub

A multi-role beauty services marketplace application connecting **Customers**, **Vendors** (product sellers), and **Beauticians** (service providers) in a single platform.

---

## 📱 Overview

The Noire Hub is a comprehensive Flutter-based mobile application that transforms the beauty and wellness industry by providing a unified platform where customers can discover and book beauty services, vendors can sell products, and beauticians can manage their service offerings and bookings.

---

## ✨ Key Features

### 👤 Customer Features
- **Product Marketplace**: Browse, search, and filter beauty products with advanced filters (category, subcategory, distance, rating, price range, offers)
- **Service Discovery**: Explore beauty services with location-based recommendations
- **Service Booking**: Book appointments with beauticians, confirm bookings, and manage reservations
- **Shopping Cart**: Multi-vendor cart with checkout flow and order management
- **Favorites**: Save preferred products and services for quick access
- **Deals & Promos**: Browse active promotions and apply promo codes
- **Reviews & Ratings**: Rate products and services after purchase/booking
- **Order History**: Track past and current product orders
- **Booking History**: View all service bookings and their status
- **Location-Based Services**: Discover nearby vendors and beauticians using geolocation

### 🏪 Vendor Features
- **Store Management**: Complete store setup wizard with customization
- **Product Management**: Add, edit, and manage product listings with variants
- **Order Fulfillment**: Manage incoming orders, update status, and track fulfillment
- **Billing & Payments**: Stripe integration for payment processing
- **Business Verification**: Upload business documents and manage verification status
- **Earnings Dashboard**: Track revenue, withdrawals, and financial analytics
- **Deals & Promotions**: Create promotional offers for products

### 💇 Beautician Features
- **Service Management**: Add, edit, and manage service offerings with variants
- **Booking Management**: View and manage incoming service bookings
- **Availability Setup**: Set working hours and availability schedules
- **Business Verification**: Submit business documents for verification
- **Earnings Tracking**: Monitor income, process withdrawals, manage bank accounts
- **Service Variants**: Offer multiple pricing tiers for services

### 🔐 Authentication & Security
- Multi-role registration (Customer, Vendor, Beautician)
- OTP verification for phone numbers
- Email verification
- Password reset and change password functionality
- Secure token-based authentication with Bearer tokens

### 💰 Wallet & Financial Features
- **Wallet Balance**: Real-time wallet balance tracking
- **Withdrawals**: Request withdrawals to linked bank accounts
- **Bank Account Management**: Add and manage bank account details
- **Earnings Analytics**: Visual charts and calendar-based earnings view

### 🌐 Common Features
- **Role-Based Navigation**: Dynamic UI adaptation based on user role
- **Profile Management**: Edit personal information, update profile images
- **Business Documents**: Upload and manage business verification documents
- **About Us & Terms**: Access platform information and terms of service
- **Help & Feedback**: Submit feedback and access help resources
- **Invite Friends**: Referral system for user acquisition
- **Push Notifications**: Real-time updates on bookings, orders, and promotions
- **Responsive Design**: Optimized for all screen sizes using ScreenUtil

---

## 🏗️ Architecture

### Design Pattern
**Feature-First Layered Architecture** with **MVVM-like pattern** using GetX

```
lib/
├── core/                    # Core utilities, services, and shared components
│   ├── api/                 # API client, interceptors, exception handling
│   ├── bindings/            # Global dependency injection bindings
│   ├── constants/           # App-wide constants (API, colors, assets, routes, strings)
│   ├── extensions/          # Dart extension utilities
│   ├── routes/              # Centralized routing configuration
│   ├── services/            # Core services (cache, connectivity)
│   ├── theme/               # Light/dark theme definitions
│   ├── utils/               # Utility functions and mixins
│   └── widgets/             # Reusable UI components
│
├── features/                # Feature modules
│   ├── authentication/      # Login, registration, OTP, password reset
│   ├── customer/            # Customer-specific features
│   ├── vendor/              # Vendor-specific features
│   ├── beautician/          # Beautician-specific features
│   └── common/              # Shared features (splash, profile, dashboard, etc.)
│
├── main.dart                # Application entry point
└── app.dart                 # GetMaterialApp root configuration
```

### State Management
**GetX** (`get: ^4.7.3`) for:
- Reactive state management with `.obs` observables
- Dependency injection with `Get.put()`, `Get.lazyPut()`
- Navigation with named routes
- Snackbar and dialog management

### Networking Layer
- **HTTP Client**: Dio (`dio: ^5.9.0`)
- **Singleton ApiClient** with GET, POST, PUT, PATCH, DELETE support
- **Auto-interceptor** for Bearer token attachment
- **FormData** support for file uploads
- **Custom exception hierarchy** for comprehensive error handling:
  - ServerException, NoInternetException, TimeoutException
  - ParsingException, CacheException, NotFoundException, UnknownException

### Caching
- **SharedPreferences** for persistent local storage
- Stores: auth token, user ID, role, profile data, location, business info

---

## 🎨 UI/UX Design

### Design System
- **Responsive Layout**: ScreenUtil (375x812 base design size)
- **Typography**: Outfit font family (Google Fonts)
- **Color Palette**:
  - Primary: Deep Olive Green (`#3B502B`)
  - Accent: Cream (`#CADA9F`)
  - Comprehensive color system in `app_colors.dart`

### Reusable Components
Extensive custom widget library including:
- Custom AppBar, Buttons, Text Fields, Dropdowns
- Network Image with shimmer placeholders
- Pin Code Field for OTP
- Loading indicators and error views
- Dialog helpers and snackbars
- Payment webview integration

---

## 📦 Tech Stack

| Category | Technology |
|----------|-----------|
| **Framework** | Flutter (SDK ^3.10.4) |
| **State Management** | GetX ^4.7.3 |
| **Networking** | Dio ^5.9.0 |
| **Image Handling** | Cached Network Image ^3.4.1, Image Picker ^1.2.1 |
| **Local Storage** | Shared Preferences ^2.5.4 |
| **UI/UX** | ScreenUtil ^5.9.3, Google Fonts, Shimmer, SpinKit |
| **Maps & Location** | Google Maps Flutter ^2.14.0, Geolocator ^14.0.2 |
| **Charts & Calendar** | FL Chart ^1.1.1, Table Calendar ^3.2.0 |
| **Payments** | WebView Flutter ^4.13.1 (Stripe) |
| **File Handling** | File Picker ^10.3.10, Path Provider ^2.1.5 |
| **Connectivity** | Connectivity Plus ^7.0.0 |
| **Utilities** | Intl ^0.20.2, Share Plus, URL Launcher |
| **Icons** | Flutter SVG ^2.2.3 |

---

## 🗂️ Project Structure

### Core Modules
- **API Layer**: Centralized API client with interceptors and error handling
- **Cache Service**: SharedPreferences wrapper for local data persistence
- **Route Management**: 60+ named routes with role-based navigation
- **Theme System**: Light/dark mode support with consistent styling
- **Custom Widgets**: 15+ reusable UI components

### Feature Modules
- **Authentication**: Login, registration (customer/vendor), OTP, email verification, password management
- **Customer**: Products, services, booking, cart, checkout, orders, favorites, deals, reviews
- **Vendor**: Store setup, product CRUD, order management, billing, variants
- **Beautician**: Service management, bookings, availability, earnings
- **Common**: Splash, dashboard, profile, wallet, earnings, business documents, categories, reviews

---

## 🔑 API Configuration

- **Base URL**: `BaseUrl`
- **Authentication**: Bearer token (auto-attached via interceptor)
- **Endpoints**: Centralized in `api_constants.dart`
- **Error Handling**: User-friendly error messages with retry functionality

---

## 📱 Platform Support

### Android
- Package: `the_noire_place`
- Permissions: Internet, Location (Fine/Coarse)
- Google Maps API integration
- Portrait orientation only

### iOS
- Configured with matching feature set
- Launch icons generated via `flutter_launcher_icons`

---

## 🎯 User Flow

### Customer Journey
1. Register/Login → OTP/Email Verification
2. Browse products/services or discover nearby vendors
3. Add to cart/favorites → Checkout → Order confirmation
4. Book services → View booking history → Rate services

### Vendor Journey
1. Register as Vendor → Business Verification
2. Store Setup → Add Products with Variants
3. Manage Orders → Process Fulfillment
4. Track Earnings → Withdraw Funds

### Beautician Journey
1. Register as Beautician → Business Verification
2. Add Services with Variants → Set Availability
3. Manage Bookings → Update Service Status
4. Track Earnings → Withdraw Funds

---

## 🛡️ Security Features

- Token-based authentication with automatic refresh
- Secure local storage of sensitive data
- Bearer token auto-attachment via interceptor
- Role-based access control
- Business document verification system

---

## 📊 State Management Pattern

```
Screen (View) → GetX Controller (ViewModel) → Service (Data) → API
      ↑                                              ↓
      └─────────── Observable (.obs) ←────────────────┘
```

- **Reactive**: `.obs` observables with `Obx()` widgets
- **Dependency Injection**: Feature-level bindings with lazy loading
- **Memory Efficient**: `fenix: true` for auto-recreation of controllers

---

## 🎨 Asset Structure

```
assets/
├── icons/
│   ├── apple.svg, google.svg, fb.svg
│   └── home.svg, profile.svg, book.svg
└── images/
    ├── app_icon.jpeg, app_logo.png, splash_screen.png
    ├── log_in_man.png, registration.png, selection.png
    ├── vendors.png, beauticians.png, vendor_*.png
    └── star.png, sub_cat.png, empty.png
```

---

## 📝 Development Standards

- **Consistent Structure**: Every feature follows data/presentation layer pattern
- **Centralized Constants**: All strings, colors, assets, routes in core/constants
- **Reusable Widgets**: Extensive custom widget library for UI consistency
- **Error Handling**: Comprehensive exception hierarchy with user-friendly messages
- **Debug Logging**: Extensive logging for API request/response tracing
- **Code Organization**: Feature-first approach for scalability

---

## 🚀 App Version

- **Version**: 1.0.0
- **Build**: 1

---

## 📄 License

This project is proprietary software. All rights reserved.

---

## 👥 Support

For support, feedback, or bug reports, please use the in-app **Help & Feedback** feature or contact the development team.

---

**Built with ❤️ using Flutter & GetX**
