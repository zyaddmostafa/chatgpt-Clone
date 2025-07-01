# 🤖 ChatGPT Flutter App

<div align="center">
  <img src="assets/images/app_logo.png" alt="ChatGPT App Logo" width="120" height="120">
  <h3>A powerful AI-powered chat application built with Flutter</h3>
  
  ![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
  ![Firebase](https://img.shields.io/badge/Firebase-039BE5?style=for-the-badge&logo=Firebase&logoColor=white)
  ![Google Gemini](https://img.shields.io/badge/Google%20Gemini-4285F4?style=for-the-badge&logo=google&logoColor=white)
  ![BLoC](https://img.shields.io/badge/BLoC-3178C6?style=for-the-badge&logo=dart&logoColor=white)

</div>

## 📱 Features

### 🔐 **Authentication System**

- **Firebase Authentication** with multiple sign-in methods
- **Google Sign-In** integration
- **Phone Number Verification** with OTP
- **User Profile Management** with Firebase Firestore
- **Secure Session Management** with automatic login detection

### 💬 **AI Chat Features**

- **Google Gemini AI Integration** for intelligent conversations
- **Real-time Chat** with message history
- **Image Analysis** - Upload images and get AI-powered analysis
- **Speech-to-Text** functionality for voice input
- **Chat History** management with Firebase Cloud Firestore
- **Multiple Chat Sessions** support

### 🎨 **User Interface**

- **Modern Material Design** with custom theming
- **Responsive Design** using ScreenUtil
- **Dark/Light Mode** support
- **Custom Animations** and smooth transitions
- **Intuitive Navigation** with drawer menu
- **Cross-platform** compatibility (Android, iOS, Web, Desktop)

### 🔧 **Technical Features**

- **Clean Architecture** with separation of concerns
- **BLoC State Management** for reactive programming
- **Dependency Injection** using GetIt
- **Error Handling** with user-friendly messages
- **Offline Support** with local data caching
- **Permission Management** for camera, microphone, and storage

## 🏗️ Project Structure

```
lib/
├── 📁 core/                          # Core utilities and shared components
│   ├── 📁 di/                        # Dependency injection setup
│   │   └── dependency_injection.dart  # GetIt configuration
│   ├── 📁 routing/                   # App navigation
│   │   ├── app_routes.dart           # Route definitions
│   │   └── routes.dart               # Route constants
│   ├── 📁 services/                  # External services
│   │   ├── firebase_auth_service.dart # Firebase authentication
│   │   └── firebase_store_service.dart # Firestore operations
│   ├── 📁 theme/                     # App theming
│   │   ├── app_color.dart            # Color definitions
│   │   └── app_textstyles.dart       # Text style definitions
│   ├── 📁 utils/                     # Utility functions
│   │   ├── permission_helper.dart     # Permission management
│   │   ├── assets.dart               # Asset path definitions
│   │   ├── extention.dart            # Dart extensions
│   │   └── app_regex.dart            # Validation patterns
│   └── 📁 widgets/                   # Reusable UI components
│       ├── custom_app_button.dart    # Custom button widget
│       ├── custom_text_form_field.dart # Custom input field
│       └── error_message.dart        # Error display widget
│
├── 📁 feature/                       # Feature-based modules
│   ├── 📁 auth/                      # Authentication feature
│   │   ├── 📁 data/                  # Data layer
│   │   │   ├── 📁 models/            # Data models
│   │   │   │   ├── country_model.dart
│   │   │   │   ├── login_request_body.dart
│   │   │   │   └── sign_up_request_body.dart
│   │   │   └── 📁 repos/             # Repository implementations
│   │   │       ├── login_repo_impl.dart
│   │   │       └── sign_up_repo_impl.dart
│   │   └── 📁 presentation/          # Presentation layer
│   │       ├── 📁 cubits/            # BLoC state management
│   │       │   ├── 📁 login_cubit/   # Login state management
│   │       │   └── 📁 signup_cubit/  # Sign-up state management
│   │       └── 📁 screens/           # UI screens
│   │           ├── welcome_screen.dart
│   │           ├── login_screen.dart
│   │           ├── sign_up_screen.dart
│   │           ├── phone_number_verification.dart
│   │           └── 📁 widgets/       # Feature-specific widgets
│   │               ├── auth_header.dart
│   │               ├── login_form.dart
│   │               ├── sign_up_form.dart
│   │               └── social_media_auth.dart
│   │
│   └── 📁 home/                      # Main chat feature
│       ├── 📁 data/                  # Data layer
│       │   ├── 📁 apis/              # External API services
│       │   │   ├── gemeni_service.dart      # Google Gemini integration
│       │   │   └── speech_to_text_service.dart # Speech recognition
│       │   ├── 📁 models/            # Data models
│       │   │   ├── chat_model.dart           # Chat session model
│       │   │   └── chat_message_model.dart   # Message model
│       │   └── 📁 repos/             # Repository implementations
│       │       ├── chat_repository.dart
│       │       └── home_repo_impl.dart
│       └── 📁 presentation/          # Presentation layer
│           ├── 📁 cubits/            # State management
│           │   ├── 📁 home/          # Main coordinator cubit
│           │   ├── 📁 chat/          # Chat session management
│           │   ├── 📁 message/       # Message handling
│           │   ├── 📁 image/         # Image processing
│           │   └── 📁 speech/        # Speech recognition
│           └── 📁 screens/           # UI screens
│               ├── home_screen.dart   # Main chat interface
│               └── 📁 widgets/       # Home feature widgets
│                   ├── chat_message.dart
│                   ├── voice_recording_dialog.dart
│                   ├── show_picked_image.dart
│                   ├── drawer_menu.dart
│                   └── home_fuctionality_bottom_bar.dart
│
├── firebase_options.dart             # Firebase configuration
├── main.dart                        # App entry point
└── app_bloc_observer.dart           # BLoC debugging
```
