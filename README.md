# ChatGPT Flutter App

A robust, modular, and scalable Flutter application featuring authentication, chat, and home functionalities, leveraging Firebase and modern state management. This project is organized for maintainability and extensibility, following best practices in folder structure and code separation.

---

## Features

- **Authentication**: Sign up, login, phone verification, and social media authentication.
- **Chat**: Real-time chat interface, chat history, and message management.
- **Home**: Main app dashboard, voice recording, image picking, and more.
- **Firebase Integration**: Auth and Firestore services.
- **State Management**: Cubit-based architecture for clear separation of business logic.

---

## Project Structure

```
lib/
│
├── main.dart
├── app_bloc_observer.dart
├── firebase_options.dart
│
├── core/
│   ├── di/
│   │   └── dependency_injection.dart
│   ├── routing/
│   │   ├── app_routes.dart
│   │   └── routes.dart
│   ├── services/
│   │   ├── firebase_auth_service.dart
│   │   └── firebase_store_service.dart
│   ├── theme/
│   │   ├── app_color.dart
│   │   └── app_textstyles.dart
│   ├── utils/
│   │   ├── api_constatns.dart
│   │   ├── app_regex.dart
│   │   ├── assets.dart
│   │   ├── extention.dart
│   │   ├── screen_size.dart
│   │   ├── snack_bar.dart
│   │   └── spacing.dart
│   └── widgets/
│       ├── custom_app_button.dart
│       ├── custom_divider.dart
│       ├── custom_text_form_field.dart
│       └── error_message.dart
│
├── feature/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── country_model.dart
│   │   │   │   ├── login_request_body.dart
│   │   │   │   ├── sign_up_request_body.dart
│   │   │   │   └── sign_up_request_body.g.dart
│   │   │   └── repos/
│   │   │       ├── login_repo_impl.dart
│   │   │       └── sign_up_repo_impl.dart
│   │   └── presentation/
│   │       ├── cubits/
│   │       │   ├── login_cubit/
│   │       │   │   ├── login_cubit.dart
│   │       │   │   └── login_state.dart
│   │       │   └── signup_cubit/
│   │       │       ├── sign_up_cubit.dart
│   │       │       └── sign_up_state.dart
│   │       └── screens/
│   │           ├── enter_code_screen.dart
│   │           ├── enter_name_screen.dart
│   │           ├── login_loading_screen.dart
│   │           ├── login_screen.dart
│   │           ├── phone_number_verification.dart
│   │           ├── sign_up_loading_screen.dart
│   │           ├── sign_up_screen.dart
│   │           ├── welcome_screen.dart
│   │           └── widgets/
│   │               ├── already_have_an_account.dart
│   │               ├── auth_header.dart
│   │               ├── enter_code_form.dart
│   │               ├── enter_name_form.dart
│   │               ├── login_button_bloc_consumer.dart
│   │               ├── login_form.dart
│   │               ├── phone_verification_form.dart
│   │               ├── sign_up_form.dart
│   │               └── social_media_auth.dart
│   │
│   └── home/
│       ├── data/
│       │   ├── apis/
│       │   │   ├── constants.dart
│       │   │   ├── gemeni_service.dart
│       │   │   └── speech_to_text_service.dart
│       │   ├── models/
│       │   │   ├── chat_message_model.dart
│       │   │   ├── chat_message_model.g.dart
│       │   │   ├── chat_model.dart
│       │   │   └── chat_model.g.dart
│       │   └── repos/
│       │       ├── chat_repository.dart
│       │       └── home_repo_impl.dart
│       └── presentation/
│           ├── cubits/
│           │   ├── chat/
│           │   │   ├── chat_cubit.dart
│           │   │   └── chat_state.dart
│           │   ├── home/
│           │   │   ├── home_cubit.dart
│           │   │   └── home_state.dart
│           │   ├── image/
│           │   │   ├── image_cubit.dart
│           │   │   └── image_state.dart
│           │   ├── message/
│           │   │   ├── message_cubit.dart
│           │   │   └── message_state.dart
│           │   └── speech/
│           │       ├── speech_cubit.dart
│           │       └── speech_state.dart
│           └── screens/
│               ├── home_screen.dart
│               └── widgets/
│                   ├── chat_history_widget.dart
│                   ├── chat_message.dart
│                   ├── drawer_content.dart
│                   ├── drawer_menu.dart
│                   ├── home_fuctionality_bottom_bar.dart
│                   ├── show_picked_image.dart
│                   └── voice_recording_dialog.dart
```

---
