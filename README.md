# Flutter Blog App
## Description
The Blog App is an hybrid blogging application developer using flutter. This application contains all the necessary functionality required in blogging application.

## Tech Stack
- Flutter Version 2.5.1
- Firebase
  - Firebase Authentication
  - Firebase Storage
  - Firestore
  - Firebase Push Notification

## State Management
- Provider State Management
- GetX

## Key Point To Measure Strength Of This Application
- Api Wrapper Class - A Singleton class which is responsible for all type of api related task with various options i.e show loader, show toast..etc.
  - Declared in lib/service/api_service.dart
- Model Object Helper Class - A mixin class which is responsible for providing provider model's object.
  - Declared in lib/utils/model_object_helper.dart
- Cache Manager Class - A Singleton class which is responsible for managing cache with shared preference.
  - Declared in lib/service/cache_manager_service.dart
- A Singleton classes were used for different firebase related task i.e Firebase Authentication,Firebase Storage, Firebase Storage
- Responsive UI with Media Query Class
- Minimum and highly optimised code rebuild with Streams and Stream Builders
- Clean Architecture
- Reusable code for almost every task
