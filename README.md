<div align="center">

# 🎪 Eventtoria

### Event Management & Vendor Coordination Platform

<p>
  <img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white" />
  <img src="https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white" />
  <img src="https://img.shields.io/badge/Firebase-Backend-FFCA28?style=for-the-badge&logo=firebase&logoColor=black" />
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS-lightgrey?style=for-the-badge&logo=android&logoColor=white" />
</p>

<p>
  <img src="https://img.shields.io/badge/Auth-Firebase%20Auth-orange?style=flat-square&logo=firebase" />
  <img src="https://img.shields.io/badge/Database-Firestore-yellow?style=flat-square&logo=google-cloud" />
  <img src="https://img.shields.io/badge/Storage-Firebase%20Storage-red?style=flat-square&logo=firebase" />
  <img src="https://img.shields.io/badge/State-Provider-7C3AED?style=flat-square" />
  <img src="https://img.shields.io/badge/License-MIT-22c55e?style=flat-square" />
  <img src="https://img.shields.io/badge/Status-In%20Development-f59e0b?style=flat-square" />
</p>

<br/>

> **Discover events. Book instantly. Coordinate effortlessly.**  
> A role-based Flutter app connecting attendees, organizers, and vendors on one platform.

<br/>
</div>

---

## 📌 Overview

**Eventtoria** is a Flutter + Firebase mobile app that brings event discovery and vendor coordination into a single, role-based platform. Users can browse and book events; organizers can create and manage listings; admins can oversee the platform.

Built as a portfolio project — the focus was on clean architecture, real Firebase integration, and practical multi-role UX design.

---

## ✨ What It Does

<table>
<tr>
<td width="33%">

**👤 For Attendees**
- Browse & discover events
- View full event details
- Book / register for events
- Manage profile & bookings

</td>
<td width="33%">

**🧑‍💼 For Organizers**
- Create & publish events
- Upload banners via Gallery/Camera
- Edit or remove listings
- Track bookings in real time

</td>
<td width="33%">

**🛡️ For Admins**
- Moderate all listings
- Oversee platform bookings
- Manage user accounts

</td>
</tr>
</table>

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter · Dart |
| Auth | Firebase Authentication · Google Sign-In |
| Database | Cloud Firestore |
| Storage | Firebase Storage |
| State | Provider (`ChangeNotifier`) |
| Local Cache | Shared Preferences |
| Images | Image Picker · Cached Network Image |
| Utils | Intl · UUID · Fluttertoast |

<details>
<summary><b>📦 pubspec.yaml — Key Dependencies</b></summary>

```yaml
dependencies:
  # Firebase
  firebase_core: ^2.x.x
  firebase_auth: ^4.x.x
  cloud_firestore: ^4.x.x
  firebase_storage: ^11.x.x
  google_sign_in: ^6.x.x

  # State & Storage
  provider: ^6.x.x
  shared_preferences: ^2.x.x

  # UI & Media
  image_picker: ^1.x.x
  cached_network_image: ^3.x.x
  fluttertoast: ^8.x.x

  # Utilities
  intl: ^0.18.x
  uuid: ^4.x.x
```
</details>

---

## 🏗️ Architecture

```
UI Layer  (Screens & Widgets)
    ↓
Provider  (State Management)
    ↓
Services  (AuthService · EventService · BookingService)
    ↓
Firebase  (Auth · Firestore · Storage)
```

Follows a **layered architecture**: UI never talks to Firebase directly. All data flows through service classes consumed by Provider, keeping screens clean and logic testable.

---

## 🗃️ Firestore Data Model

```
/users/{uid}         → name, email, role, profileImageUrl
/events/{eventId}    → title, description, date, time, location, price, imageUrl, organizerId
/bookings/{id}       → userId, eventId, bookedAt, status
/vendors/{id}        → businessName, contactEmail, servicesOffered
```

---

## 📁 Folder Structure

```
lib/
├── main.dart
├── models/          # User, Event, Booking models
├── providers/       # Auth, Event, Booking providers
├── services/        # Firebase service classes
├── screens/
│   ├── auth/        # Login, Register
│   ├── home/        # Home feed
│   ├── events/      # Event list, Event detail
│   ├── booking/     # Booking screen
│   ├── profile/     # User profile
│   ├── organizer/   # Dashboard, Create event
│   └── admin/       # Admin panel
├── widgets/         # Reusable components
└── utils/           # Constants, validators, formatters
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK `3.x+`
- A Firebase project with Auth, Firestore & Storage enabled

### Setup

```bash
# 1. Clone
git clone https://github.com/your-username/eventtoria.git
cd eventtoria

# 2. Install packages
flutter pub get

# 3. Configure Firebase (recommended)
dart pub global activate flutterfire_cli
flutterfire configure

# 4. Run
flutter run
```

> **Manual Firebase setup:** Download `google-services.json` → `android/app/` and `GoogleService-Info.plist` → `ios/Runner/`

<details>
<summary><b>⚙️ Firestore Rules (Development)</b></summary>

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```
⚠️ Tighten these rules with role-based access before going live.
</details>

---

## 📱 Screens

| Screen | Description |
|---|---|
| Login / Register | Email + Google Sign-In |
| Home | Event feed with categories |
| Event Detail | Date, venue, price, images, booking CTA |
| Booking | Confirm registration |
| Profile | User info + booking history |
| Organizer Dashboard | Manage listings and view registrations |
| Create / Edit Event | Form with image upload |
| Admin Panel | Platform-wide moderation |

> 📸 *Add your screenshots here — recommended: side-by-side 3-column layout*

---

## 🔭 Roadmap

- [ ] Push notifications via FCM
- [ ] In-app payments (Razorpay)
- [ ] QR code ticket generation
- [ ] Google Maps venue display
- [ ] Event search with filters
- [ ] Reviews & ratings
- [ ] Dark mode

---

## 🧠 Challenges & Learnings

**Challenges**
- Designing Firestore rules that enforce role separation (user / organizer / admin) cleanly
- Keeping multi-screen state in sync with Firestore streams via Provider without excessive rebuilds
- Building a smooth image upload flow: pick → compress → upload to Storage → save URL to Firestore

**What I Learned**
- Structuring a Flutter app with a proper service/repository layer
- Real-world Firebase Auth with OAuth (Google Sign-In)
- NoSQL data modeling for a multi-role, relational-style use case
- Async state management patterns with `ChangeNotifier` and `StreamBuilder`

---

## 🤝 Contributing

```bash
# Fork → Branch → Commit → PR
git checkout -b feat/your-feature
git commit -m "feat: describe your change"
git push origin feat/your-feature
```

All PRs welcome. Please follow the existing structure and test before submitting.

---

## 👤 Author

**Your Name**
&nbsp;·&nbsp; [GitHub](https://github.com/harishgangurde)
&nbsp;·&nbsp; [LinkedIn](https://linkedin.com/in/harishgangurde)
&nbsp;·&nbsp; `harishgangurde1539@gmail.com`

---

## 📄 License

MIT © [Your Name](https://github.com/your-username) — see [LICENSE](./LICENSE) for details.

---

<div align="center">
<sub>Built with Flutter · Powered by Firebase</sub>
</div>
