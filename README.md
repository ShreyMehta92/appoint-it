# 🏥 Smart Appointment Scheduling & Queue Management

A production-ready, offline-first Flutter application designed for clinics, offices, and service centers to manage appointments and live queues efficiently.

## 🚀 Key Features

### 📅 Appointment Booking
- Simple and intuitive booking form for patients.
- Select service types, dates, and time slots.
- Instant token generation upon booking.

### 👥 Live Queue Tracking
- Real-time queue status updates.
- Dynamic wait time estimation based on current serving status.
- "Now Serving" dashboard for quick reference.

### 🔐 Advanced Authentication & Roles
- **Separate Portals**: Dedicated login flows for Patients and Admins.
- **Role-Based Security**: Admins have exclusive access to queue management tools.
- **Firebase Auth**: Secure email/password authentication.

### 🛠 Admin Management
- Interactive dashboard to manage the live queue.
- One-tap actions to move tokens to "Serving" or "Completed" status.
- Real-time impact on wait times for all waiting patients.

### 📶 Offline-First Architecture
- **Hive Local Storage**: All data is saved locally first, ensuring the app works perfectly without internet.
- **Background Sync**: Automatic synchronization with **Firebase Firestore** once connectivity is restored.
- **Conflict Detection**: Built-in logic to handle data syncing across multiple sessions.

## 🏗 Tech Stack

- **Framework**: [Flutter](https://flutter.dev/)
- **State Management**: [Riverpod](https://riverpod.dev/)
- **Local Database**: [Hive](https://docs.hivedb.dev/)
- **Backend**: [Firebase](https://firebase.google.com/) (Auth, Firestore)
- **Navigation**: [GoRouter](https://pub.dev/packages/go_router)
- **Networking**: [Connectivity Plus](https://pub.dev/packages/connectivity_plus)

## 🏁 Getting Started

### Prerequisites
- Flutter SDK (latest stable)
- Firebase Account
- Google Chrome (for web testing) or an Emulator

### Setup Instructions

1.  **Clone the Repository**
    ```bash
    git clone https://github.com/your-repo/appoint-it.git
    cd appoint-it
    ```

2.  **Install Dependencies**
    ```bash
    flutter pub get
    ```

3.  **Firebase Configuration**
    - Run the FlutterFire CLI to configure your project:
      ```bash
      dart pub global run flutterfire_cli:flutterfire configure
      ```
    - Ensure **Email/Password Auth** and **Cloud Firestore** are enabled in your Firebase Console.

4.  **Run Code Generation**
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```

5.  **Run the App**
    ```bash
    flutter run -d chrome
    ```

## 📝 Firestore Security Rules
To enable synchronization, ensure your Firestore rules allow writes for authenticated users. For testing:
```javascript
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true; // ⚠️ Use secure rules for production!
    }
  }
}
```

## 🛡 License
This project is licensed under the MIT License - see the LICENSE file for details.
