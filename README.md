# 🏥 SSID Platform — AI-Powered Surgical Training App

> **Mobile Application Development Project**  
> Flutter app for AI-based suturing skill assessment for medical students

[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Firestore-orange?logo=firebase)](https://firebase.google.com)
[![SQLite](https://img.shields.io/badge/SQLite-Local_DB-green?logo=sqlite)](https://www.sqlite.org)

---

## 📖 Project Description

SSID Platform is a mobile application that helps **medical students** improve their suturing skills by uploading practice videos and receiving **instant AI-powered feedback**. The app supports both **Student** and **Instructor** roles with a dual-storage architecture (SQLite + Firebase).

### Key Innovation: Dual Storage Architecture

```
App → SQLite (Local, Offline-first) ↔ Auto-Sync ↔ Firebase Firestore (Cloud)
```

---

## ✨ Features

| Feature | Description | Status |
|---|---|---|
| 🔐 Authentication | Role-based login (Student / Instructor) | ✅ Done |
| 🏠 Student Dashboard | Training stats, session history | ✅ Done |
| 📹 Video Upload & AI Analysis | Upload video → Get 4-dimension score | ✅ Done |
| 📊 Analysis Results | Visual charts, feedback, total score | ✅ Done |
| 🔔 Notification System | Analysis complete alerts, mark as read | ✅ Done |
| 👨‍🏫 Instructor Dashboard | View all students, scores overview | ✅ Done |
| 🗄️ Dual Storage | SQLite (offline) + Firebase (cloud sync) | ✅ Done |
| 🌱 Mock Data Seeder | Demo data for testing | ✅ Done |

### AI Analysis Dimensions

- **Suturing Technique** — เทคนิคการเย็บ
- **Hand Movement** — การเคลื่อนไหวมือ
- **Tool Handling** — การจับเครื่องมือ
- **Time Efficiency** — ประสิทธิภาพด้านเวลา

---

## 🛠️ Tech Stack

- **Framework:** Flutter (Dart)
- **Local Database:** SQLite (`sqflite`)
- **Cloud Database:** Firebase Firestore
- **State Management:** Provider
- **Storage:** `path_provider`, `image_picker`

---

## 🚀 Installation & Setup

### Prerequisites

- Flutter SDK 3.x or higher
- Android Studio / VS Code
- Firebase project configured

### Steps

```bash
# 1. Clone the repository
git clone https://github.com/YOUR_USERNAME/ssid_app_v2.git
cd ssid_app_v2

# 2. Install dependencies
flutter pub get

# 3. Run the app
flutter run
```

### Test Accounts

| Role | Email |
|------|-------|
| Student | <student@ssid.com> |
| Instructor | <instructor@ssid.com> |

---

## 📁 Project Structure

```
ssid_app_v2/
├── lib/
│   ├── screens/        # 8 UI screens (Login, Home, Upload, etc.)
│   ├── providers/      # State management (Auth, Notification)
│   ├── services/       # DatabaseHelper, FirestoreService, MockAI
│   └── utils/          # MockDataSeeder
├── docs/
│   ├── group_work_assignment.md  # Team task assignment
│   ├── gantt_scrum.md            # Gantt Scrum Chart
│   ├── uml_diagrams.md           # UML diagrams
│   └── Final_Project_Report.md   # Final report
├── README.md
└── pubspec.yaml
```

---

## 👥 Team Members

| Student ID | Name | Role |
|------------|------|------|
| 66112772 | นายอภินันท์ อายุยงค์ | Backend & Database (System Architect) |
| 66126467 | นางสาวฟ้าใส ขวัญปาน | Frontend & UI/UX (Designer + Developer) |
| 66120361 | นางสาวตรีฤทัย แคยิหวา | QA, AI Mock & Documentation (Scrum Master) |

---

## 📅 Scrum Summary

| Sprint | Period | Focus | Status |
|--------|--------|-------|--------|
| Sprint 1 | Week 1–2 | UI Design, Login, Navigation | ✅ Done |
| Sprint 2 | Week 3–4 | SQLite, Mock AI, Upload Feature | ✅ Done |
| Sprint 3 | Week 5–6 | Firebase Sync, Notifications, Testing | ✅ Done |
| Sprint 4 | Week 7 | Report, Presentation, GitHub | 🔄 In Progress |

See [Gantt Scrum Chart](docs/gantt_scrum.md) for full timeline.

---

## 🔮 Future Work

- Integrate real AI model via Python API
- Real-time video streaming analysis
- Multi-language support (EN/TH)

---

## 📄 License

This project is developed for academic purposes — Mobile Application Development Course.
