# 📋 ใบงานกลุ่ม: SSID Platform (ssid_app_v2)

**วิชา:** Mobile Application Development
**กลุ่ม:** 66112772 นายอภินันท์ อายุยงค์ | 66126467 นางสาวฟ้าใส ขวัญปาน | 66120361 นางสาวตรีฤทัย แคยิหวา
**วันที่:** 18 กุมภาพันธ์ 2026

---

## 🗂️ สิ่งที่แอป ssid_app_v2 ทำไปแล้ว (Feature List)

### 1. 🔐 ระบบ Authentication (Login/Logout)

- **ทำอะไร:** หน้า Login แยก Role ระหว่าง Student และ Instructor
- **ความต้องการ:** ผู้ใช้ต้องกรอก Email เพื่อเข้าสู่ระบบ ระบบจะตรวจสอบ Role แล้วนำทางไปหน้าที่เหมาะสม
- **ไฟล์:** `login_screen.dart`, `auth_provider.dart`

### 2. 🏠 หน้า Home Dashboard (Student)

- **ทำอะไร:** แสดงสถิติการฝึก (จำนวน Sessions, คะแนนเฉลี่ย, คะแนนสูงสุด) และประวัติการวิเคราะห์ล่าสุด
- **ความต้องการ:** โหลดข้อมูลจาก SQLite แบบ Real-time ไม่ต้องรอ Internet
- **ไฟล์:** `home_screen.dart`

### 3. 📹 ระบบ Upload Video & AI Analysis

- **ทำอะไร:** นักศึกษาเลือกวิดีโอจาก Gallery แล้วระบบจำลองการวิเคราะห์ AI ให้คะแนน 4 ด้าน:
  - Suturing Technique (เทคนิคการเย็บ)
  - Hand Movement (การเคลื่อนไหวมือ)
  - Tool Handling (การจับเครื่องมือ)
  - Time Efficiency (ประสิทธิภาพด้านเวลา)
- **ความต้องการ:** บันทึกผลลง SQLite ทันที และ Sync ไป Firebase อัตโนมัติ
- **ไฟล์:** `upload_screen.dart`

### 4. 📊 หน้าผลการวิเคราะห์ (Analysis Result)

- **ทำอะไร:** แสดงคะแนนรายด้านแบบ Visual (Progress Bar/Chart), Feedback ข้อความ, และคะแนนรวม
- **ความต้องการ:** แสดงผลทันทีหลังวิเคราะห์เสร็จ พร้อม Feedback ที่เป็นประโยชน์
- **ไฟล์:** `analysis_result_screen.dart`

### 5. 🔔 ระบบ Notification

- **ทำอะไร:** แจ้งเตือนเมื่อผลการวิเคราะห์เสร็จ รองรับ Mark as Read และ Delete
- **ความต้องการ:** สถานะ isRead และการลบต้อง Sync ระหว่าง SQLite และ Firebase ทั้งคู่
- **ไฟล์:** `notification_screen.dart`, `notification_provider.dart`

### 6. 👨‍🏫 หน้า Instructor Dashboard

- **ทำอะไร:** อาจารย์ดูภาพรวมนักศึกษาทั้งหมด, รายการ Sessions, และสถิติรวม
- **ความต้องการ:** ดึงข้อมูลนักศึกษาทั้งหมดจากระบบ แสดงเป็น List พร้อมคะแนน
- **ไฟล์:** `instructor_home_screen.dart`

### 7. 👤 หน้า Instructor Profile

- **ทำอะไร:** แสดงข้อมูลโปรไฟล์อาจารย์ และสรุปสถิตินักศึกษาในความดูแล
- **ความต้องการ:** แสดงข้อมูลที่ดึงจากฐานข้อมูล
- **ไฟล์:** `instructor_profile_screen.dart`

### 8. 🗄️ ระบบ Dual Storage (SQLite + Firebase)

- **ทำอะไร:** เก็บข้อมูลทั้ง Local (SQLite) และ Cloud (Firebase Firestore) พร้อมกัน
- **ความต้องการ:** ทุก CRUD operation ต้อง Sync อัตโนมัติ รองรับ Offline Mode
- **ไฟล์:** `database_helper.dart`, `firestore_service.dart`

### 9. 🌱 Mock Data Seeder

- **ทำอะไร:** สร้างข้อมูลตัวอย่าง (Users, Sessions, Notifications) ตอนแอปเริ่มทำงาน
- **ความต้องการ:** ใช้สำหรับ Demo และทดสอบระบบ
- **ไฟล์:** `mock_data_seeder.dart`

---

## 👥 การแบ่งงาน 3 คน

---

### 🔵 66112772 นายอภินันท์ อายุยงค์ — Backend & Database (System Architect)

**หน้าที่หลัก:** รับผิดชอบระบบหลังบ้าน ฐานข้อมูล และ Logic การทำงาน

**งานที่ทำไปแล้ว:**

- [X] ออกแบบ SQLite Schema (4 ตาราง: users, sessions, notifications, assignments)
- [X] เขียน `DatabaseHelper` (CRUD operations ทั้งหมด)
- [X] ตั้งค่า Firebase Firestore และ `FirestoreService`
- [X] พัฒนาระบบ Sync Logic (Auto-sync ทุก operation)
- [X] แก้ไข `AuthProvider` ให้บันทึก User ลง SQLite เมื่อ Login
- [X] แก้ไข Notification Sync (isRead, Delete)

**งานที่ต้องทำเพิ่ม:**

- [ ] เขียน Unit Test สำหรับ Database operations
- [ ] ทำ Architecture Diagram สำหรับรายงาน
- [ ] เขียน README ส่วน Installation & Setup

**ส่งมอบ (Deliverables):**

- `database_helper.dart` ✅
- `firestore_service.dart` ✅
- Architecture Diagram (ER Diagram + System Flow)
- README.md (Setup Guide)

---

### 🟢 66126467 นางสาวฟ้าใส ขวัญปาน — Frontend & UI/UX (Designer + Developer)

**หน้าที่หลัก:** รับผิดชอบหน้าตาแอป ประสบการณ์ผู้ใช้ และการแสดงผลข้อมูล

**งานที่ทำไปแล้ว:**

- [X] ออกแบบ App Theme (Colors, Typography, Icons)
- [X] พัฒนาหน้า Login Screen
- [X] พัฒนาหน้า Home Dashboard (Student)
- [X] พัฒนาหน้า Upload Screen
- [X] พัฒนาหน้า Analysis Result Screen
- [X] พัฒนาหน้า Notification Screen
- [X] พัฒนาหน้า Instructor Home & Profile

**งานที่ต้องทำเพิ่ม:**

- [ ] อัดวิดีโอ Demo สำหรับ Presentation
- [ ] จัดทำ Screenshots ทุกหน้าจอสำหรับรายงาน
- [ ] ตรวจสอบ UI บน Device ขนาดต่างๆ

**ส่งมอบ (Deliverables):**

- หน้าจอทั้งหมด 8 หน้า ✅
- `app_theme.dart` ✅
- Screenshots ทุกหน้าจอ
- วิดีโอ Demo (3-5 นาที)

---

### 🟡 66120361 นางสาวตรีฤทัย แคยิหวา — QA, AI Mock & Documentation (Scrum Master + Doc)

**หน้าที่หลัก:** รับผิดชอบการทดสอบ, จำลอง AI, เอกสาร และ Presentation

**งานที่ทำไปแล้ว:**

- [X] เขียน `MockAIService` (จำลองผลการวิเคราะห์ AI)
- [X] เขียน `MockDataSeeder` (สร้างข้อมูลตัวอย่าง)
- [X] ทดสอบระบบ Sync (Create, Read, Update, Delete)
- [X] เขียน Testing Guide (firebase_sqlite_testing.md)

**งานที่ต้องทำเพิ่ม:**

- [ ] จัดทำรายงานฉบับสมบูรณ์ (Final Report)
- [ ] เตรียม Slide Presentation (ภาษาอังกฤษ 10 นาที)
- [ ] เขียน GitHub README.md
- [ ] สรุป Scrum Report (Backlog + Sprint)

**ส่งมอบ (Deliverables):**

- `mock_ai_service.dart` ✅
- `mock_data_seeder.dart` ✅
- Final Report (.md)
- Presentation Slides (10 mins)
- GitHub README.md

---

## 📅 Scrum Plan

### Product Backlog (สิ่งที่ต้องทำทั้งหมด)

| #  | Feature               | Priority | Status  | ผู้รับผิดชอบ      |
| -- | --------------------- | -------- | ------- | ----------------------------- |
| 1  | Authentication System | High     | ✅ Done | อภินันท์              |
| 2  | SQLite Database       | High     | ✅ Done | อภินันท์              |
| 3  | Firebase Integration  | High     | ✅ Done | อภินันท์              |
| 4  | Sync Logic            | High     | ✅ Done | อภินันท์              |
| 5  | Home Dashboard UI     | High     | ✅ Done | ฟ้าใส                    |
| 6  | Upload & Analysis UI  | High     | ✅ Done | ฟ้าใส                    |
| 7  | Notification System   | Medium   | ✅ Done | อภินันท์ + ฟ้าใส |
| 8  | Instructor Dashboard  | Medium   | ✅ Done | ฟ้าใส                    |
| 9  | Mock AI Service       | Medium   | ✅ Done | ตรีฤทัย                |
| 10 | Mock Data Seeder      | Low      | ✅ Done | ตรีฤทัย                |
| 11 | Unit Tests            | Medium   | ⬜ Todo | อภินันท์              |
| 12 | Final Report          | High     | ⬜ Todo | ตรีฤทัย                |
| 13 | Presentation Slides   | High     | ⬜ Todo | ตรีฤทัย                |
| 14 | GitHub README         | Medium   | ⬜ Todo | ตรีฤทัย                |
| 15 | Demo Video            | Medium   | ⬜ Todo | ฟ้าใส                    |

### Sprint Summary

| Sprint             | ช่วงเวลา   | งานหลัก                        | สถานะ        |
| ------------------ | ------------------ | ------------------------------------- | ----------------- |
| **Sprint 1** | สัปดาห์ 1-2 | UI Design, Login, Navigation          | ✅ เสร็จ     |
| **Sprint 2** | สัปดาห์ 3-4 | SQLite, Mock AI, Upload Feature       | ✅ เสร็จ     |
| **Sprint 3** | สัปดาห์ 5-6 | Firebase Sync, Notifications, Testing | ✅ เสร็จ     |
| **Sprint 4** | สัปดาห์ 7   | Report, Presentation, GitHub          | 🔄 กำลังทำ |

---

## 🎤 Presentation Outline (English - 10 Minutes)

### Part 1: Introduction (2 mins) — ตรีฤทัย

> **"Good [morning/afternoon], today we present SSID Platform — an AI-powered mobile application designed to help medical students improve their suturing skills through instant video analysis and feedback."**

- Problem: No immediate feedback in suturing practice
- Solution: Upload video → Get AI score in seconds
- Key benefit: Works offline, syncs to cloud automatically

### Part 2: Technical Architecture (3 mins) — อภินันท์

> **"Our key innovation is the Dual Storage Architecture."**

- **SQLite (Local):** Fast, offline-capable, primary storage
- **Firebase (Cloud):** Backup, real-time sync, instructor access
- **Auto-Sync:** Every Create/Update/Delete syncs both databases
- Show diagram: App → SQLite ↔ Sync ↔ Firebase

### Part 3: Live Demo (4 mins) — ฟ้าใส

> **"Let me show you how it works."**

1. Login as Student
2. Upload Video → Show Analysis Result (4 scores)
3. Check Dashboard (data from SQLite)
4. Show Notification → Mark as Read → Verify Firebase sync
5. Login as Instructor → View student data

### Part 4: Conclusion (1 min) — ตรีฤทัย

> **"To summarize: SSID Platform delivers fast, reliable, offline-first AI feedback for medical training."**

- ✅ Dual Storage working
- ✅ All CRUD operations synced
- 🔮 Future: Real AI model via Python API
- Q&A

---

## 📂 Document + GitHub Checklist

### GitHub Repository Structure

```
ssid_app_v2/
├── lib/
│   ├── screens/        # 8 หน้าจอ
│   ├── providers/      # State Management
│   ├── services/       # Database & Firebase
│   └── utils/          # Mock Data & AI
├── docs/
│   ├── group_work_assignment.md  ← ไฟล์นี้
│   ├── Final_Project_Report.md
│   └── firebase_setup_guide.md
├── README.md           ← ต้องเขียน
└── pubspec.yaml
```

### README.md ต้องมี

- [ ] Project Description (ภาษาอังกฤษ)
- [ ] Tech Stack (Flutter, SQLite, Firebase)
- [ ] Features List
- [ ] Installation Steps (`flutter pub get`, `flutter run`)
- [ ] Screenshots (ทุกหน้าจอ)
- [ ] Team Members

### รายงานฉบับสมบูรณ์ต้องมี

- [ ] บทนำ + ที่มาของปัญหา
- [ ] System Architecture Diagram
- [ ] Database Schema (ER Diagram)
- [ ] Scrum Report (Backlog + Sprint)
- [ ] ผลการทดสอบ (Testing Results Table)
- [ ] Screenshots ทุกหน้าจอ
- [ ] สรุปผลและข้อเสนอแนะ

---

## ✅ สรุปงานที่ต้องทำก่อนส่ง

| งาน                     | ผู้รับผิดชอบ | Deadline |
| -------------------------- | ------------------------ | -------- |
| Unit Tests                 | อภินันท์         | -        |
| Architecture Diagram       | อภินันท์         | -        |
| Screenshots ทุกหน้า | ฟ้าใส               | -        |
| Demo Video (3-5 นาที)  | ฟ้าใส               | -        |
| Final Report (.md)         | ตรีฤทัย           | -        |
| Presentation Slides        | ตรีฤทัย           | -        |
| GitHub README.md           | ตรีฤทัย           | -        |
