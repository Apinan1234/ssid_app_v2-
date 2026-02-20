# 📅 Gantt Scrum Chart — SSID Platform (ssid_app_v2)

**วิชา:** Mobile Application Development  
**กลุ่ม:** 66112772 อภินันท์ | 66126467 ฟ้าใส | 66120361 ตรีฤทัย  
**ช่วงเวลา:** 7 สัปดาห์ (4 Sprints)

---

## 🗓️ Gantt Chart (Mermaid)

```mermaid
gantt
    title SSID Platform — Scrum Gantt Chart
    dateFormat  YYYY-MM-DD
    axisFormat  Week %W

    section 🔵 Sprint 1 — UI Foundation (Week 1-2)
    App Theme Design           :done,    s1_1, 2026-01-26, 3d
    Login Screen               :done,    s1_2, 2026-01-26, 4d
    Navigation Setup           :done,    s1_3, 2026-01-28, 3d
    Home Dashboard (Student)   :done,    s1_4, 2026-01-29, 4d

    section 🟢 Sprint 2 — Core Features (Week 3-4)
    SQLite Schema & CRUD       :done,    s2_1, 2026-02-02, 4d
    AuthProvider + SQLite Save :done,    s2_2, 2026-02-03, 3d
    Upload Screen UI           :done,    s2_3, 2026-02-04, 4d
    Mock AI Service            :done,    s2_4, 2026-02-04, 3d
    Mock Data Seeder           :done,    s2_5, 2026-02-06, 2d
    Analysis Result Screen     :done,    s2_6, 2026-02-07, 3d

    section 🟡 Sprint 3 — Sync & Integration (Week 5-6)
    Firebase Firestore Setup   :done,    s3_1, 2026-02-09, 3d
    Auto-Sync Logic            :done,    s3_2, 2026-02-10, 4d
    Notification System        :done,    s3_3, 2026-02-11, 3d
    Notification Sync Fix      :done,    s3_4, 2026-02-13, 2d
    Instructor Dashboard       :done,    s3_5, 2026-02-12, 3d
    Instructor Profile Screen  :done,    s3_6, 2026-02-14, 2d
    Sync Testing (CRUD Test)   :done,    s3_7, 2026-02-15, 2d
    Testing Guide (md)         :done,    s3_8, 2026-02-15, 1d

    section 🔴 Sprint 4 — Finalization (Week 7)
    Unit Tests (Database)      :active,  s4_1, 2026-02-17, 2d
    Architecture Diagram       :active,  s4_2, 2026-02-18, 2d
    Screenshots (All Screens)  :active,  s4_3, 2026-02-18, 2d
    Demo Video (3-5 min)       :         s4_4, 2026-02-19, 2d
    Final Report (.md)         :         s4_5, 2026-02-19, 3d
    Presentation Slides        :         s4_6, 2026-02-20, 3d
    GitHub README.md           :done,    s4_7, 2026-02-20, 1d
    GitHub Push                :done,    s4_8, 2026-02-20, 1d
```

---

## 📊 Sprint Breakdown Table

| Sprint | ช่วงเวลา | งานหลัก | สถานะ |
|--------|----------|---------|-------|
| **Sprint 1** | สัปดาห์ 1–2 | UI Design, Login, Navigation | ✅ เสร็จสมบูรณ์ |
| **Sprint 2** | สัปดาห์ 3–4 | SQLite, Mock AI, Upload Feature | ✅ เสร็จสมบูรณ์ |
| **Sprint 3** | สัปดาห์ 5–6 | Firebase Sync, Notifications, Testing | ✅ เสร็จสมบูรณ์ |
| **Sprint 4** | สัปดาห์ 7 | Report, Presentation, GitHub | 🔄 กำลังดำเนินการ |

---

## 👥 Task Assignment by Member

### 🔵 66112772 นายอภินันท์ อายุยงค์ — Backend & Database

| Task | Sprint | Status |
|------|--------|--------|
| SQLite Schema (4 tables) | Sprint 2 | ✅ Done |
| DatabaseHelper (CRUD) | Sprint 2 | ✅ Done |
| Firebase Firestore Setup | Sprint 3 | ✅ Done |
| Auto-Sync Logic | Sprint 3 | ✅ Done |
| AuthProvider + SQLite Save | Sprint 2 | ✅ Done |
| Notification Sync Fix | Sprint 3 | ✅ Done |
| Unit Tests (Database) | Sprint 4 | ⬜ Todo |
| Architecture Diagram | Sprint 4 | ⬜ Todo |
| README Installation Guide | Sprint 4 | ✅ Done |

### 🟢 66126467 นางสาวฟ้าใส ขวัญปาน — Frontend & UI/UX

| Task | Sprint | Status |
|------|--------|--------|
| App Theme Design | Sprint 1 | ✅ Done |
| Login Screen | Sprint 1 | ✅ Done |
| Home Dashboard (Student) | Sprint 1 | ✅ Done |
| Upload Screen | Sprint 2 | ✅ Done |
| Analysis Result Screen | Sprint 2 | ✅ Done |
| Notification Screen | Sprint 3 | ✅ Done |
| Instructor Dashboard | Sprint 3 | ✅ Done |
| Instructor Profile Screen | Sprint 3 | ✅ Done |
| Screenshots (All Screens) | Sprint 4 | ⬜ Todo |
| Demo Video (3–5 min) | Sprint 4 | ⬜ Todo |

### 🟡 66120361 นางสาวตรีฤทัย แคยิหวา — QA, AI Mock & Documentation

| Task | Sprint | Status |
|------|--------|--------|
| Mock AI Service | Sprint 2 | ✅ Done |
| Mock Data Seeder | Sprint 2 | ✅ Done |
| Sync Testing (CRUD) | Sprint 3 | ✅ Done |
| Testing Guide (md) | Sprint 3 | ✅ Done |
| Final Report (.md) | Sprint 4 | ⬜ Todo |
| Presentation Slides | Sprint 4 | ⬜ Todo |
| GitHub README.md | Sprint 4 | ✅ Done |
| Scrum Report Summary | Sprint 4 | ✅ Done |

---

## 📈 Progress Overview

```
Sprint 1:  ████████████████████  100% ✅
Sprint 2:  ████████████████████  100% ✅
Sprint 3:  ████████████████████  100% ✅
Sprint 4:  ████████░░░░░░░░░░░░   40% 🔄
```

**Total Backlog:** 15 items  
**Completed:** 10 items ✅  
**In Progress / Todo:** 5 items ⬜
