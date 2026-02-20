# SSID App - UML Diagrams

## 📊 System Design Documentation

---

## 1. Use Case Diagram

```mermaid
graph TB
    subgraph "SSID Platform"
        UC1["🔐 Login/Register"]
        UC2["📤 Upload Video"]
        UC3["🤖 Analyze Suturing"]
        UC4["📊 View Results"]
        UC5["🔔 View Notifications"]
        UC6["👤 View Profile"]
        UC7["📝 Create Assignment"]
        UC8["👥 View Student Submissions"]
        UC9["📈 View Statistics"]
    end

    Student["👨‍🎓 Student"]
    Instructor["👩‍🏫 Instructor"]
    AI["🤖 AI System"]

    Student --> UC1
    Student --> UC2
    Student --> UC4
    Student --> UC5
    Student --> UC6
    
    Instructor --> UC1
    Instructor --> UC7
    Instructor --> UC8
    Instructor --> UC9
    Instructor --> UC5
    Instructor --> UC6
    
    UC2 --> UC3
    UC3 --> UC4
    AI --> UC3
```

### Use Case Descriptions

| Use Case | Actor | Description |
|----------|-------|-------------|
| Login/Register | Student, Instructor | ผู้ใช้สามารถเข้าสู่ระบบด้วย Email/Password และเลือก Role |
| Upload Video | Student | อัปโหลดวิดีโอการฝึกเย็บแผลจาก Gallery หรือ Camera |
| Analyze Suturing | AI System | ระบบ AI วิเคราะห์เทคนิคการเย็บแผลจากวิดีโอ |
| View Results | Student | ดูผลการวิเคราะห์ ได้แก่ คะแนน, กราฟ, และ Feedback |
| View Notifications | Student, Instructor | ดูการแจ้งเตือนต่างๆ เช่น ผลวิเคราะห์, งานใหม่ |
| View Profile | Student, Instructor | ดูและแก้ไขข้อมูลโปรไฟล์ |
| Create Assignment | Instructor | สร้างงานมอบหมายให้นักศึกษา |
| View Student Submissions | Instructor | ดูงานที่นักศึกษาส่งมาและผลการวิเคราะห์ |
| View Statistics | Instructor | ดูสถิติภาพรวมของนักศึกษาทั้งหมด |

---

## 2. Class Diagram

```mermaid
classDiagram
    class User {
        +int id
        +String email
        +String name
        +String role
        +DateTime createdAt
        +login()
        +logout()
        +register()
    }

    class Student {
        +List~Session~ sessions
        +uploadVideo()
        +viewResults()
        +viewHistory()
    }

    class Instructor {
        +List~Assignment~ assignments
        +List~Student~ students
        +createAssignment()
        +viewSubmissions()
        +viewStatistics()
    }

    class Session {
        +int id
        +int userId
        +String videoPath
        +double overallScore
        +double suturingScore
        +double handMovementScore
        +double toolHandlingScore
        +double timeEfficiencyScore
        +String feedback
        +DateTime analyzedAt
        +List~StepAnalysis~ steps
    }

    class StepAnalysis {
        +String stepName
        +double score
        +String feedback
        +bool isPassed
    }

    class Notification {
        +int id
        +int userId
        +String title
        +String message
        +String type
        +bool isRead
        +DateTime createdAt
        +markAsRead()
        +delete()
    }

    class Assignment {
        +int id
        +int instructorId
        +String title
        +String description
        +DateTime dueDate
        +DateTime createdAt
    }

    class MockAIService {
        +analyzeVideo(videoPath) AnalysisResult
        +getConfidenceLevel() double
    }

    class DatabaseHelper {
        +createUser()
        +getUserByEmail()
        +createSession()
        +getSessionsByUserId()
        +createNotification()
        +markNotificationAsRead()
    }

    class FirestoreService {
        +createUser()
        +getUserByEmail()
        +createSession()
        +getSessionsByUserId()
        +syncData()
    }

    User <|-- Student
    User <|-- Instructor
    Student "1" --> "*" Session : has
    Session "1" --> "*" StepAnalysis : contains
    User "1" --> "*" Notification : receives
    Instructor "1" --> "*" Assignment : creates
    MockAIService --> Session : creates
    DatabaseHelper --> User : manages
    DatabaseHelper --> Session : manages
    DatabaseHelper --> Notification : manages
    FirestoreService --> User : syncs
    FirestoreService --> Session : syncs
```

### Class Descriptions

| Class | Responsibility |
|-------|---------------|
| **User** | Base class สำหรับผู้ใช้งาน มี email, name, role |
| **Student** | สืบทอดจาก User, สามารถอัปโหลดวิดีโอและดูผลวิเคราะห์ |
| **Instructor** | สืบทอดจาก User, สามารถสร้างงานและดูผลงานนักศึกษา |
| **Session** | เก็บข้อมูลผลการวิเคราะห์แต่ละครั้ง |
| **StepAnalysis** | เก็บข้อมูลการวิเคราะห์แต่ละขั้นตอน |
| **Notification** | เก็บข้อมูลการแจ้งเตือน |
| **Assignment** | เก็บข้อมูลงานที่มอบหมาย |
| **MockAIService** | จำลองการวิเคราะห์ด้วย AI |
| **DatabaseHelper** | จัดการ SQLite database |
| **FirestoreService** | จัดการ Firebase Firestore |

---

## 3. Activity Diagram - Video Analysis Flow

```mermaid
flowchart TD
    A[🚀 Start] --> B[📱 Open App]
    B --> C{🔐 Logged In?}
    C -->|No| D[📝 Login Screen]
    D --> E[✅ Enter Credentials]
    E --> F{Valid?}
    F -->|No| D
    F -->|Yes| G[🏠 Home Screen]
    C -->|Yes| G
    
    G --> H{👤 Role?}
    H -->|Student| I[📤 Tap Upload]
    H -->|Instructor| J[👩‍🏫 Instructor Dashboard]
    
    I --> K[📂 Select Video Source]
    K --> L{Camera or Gallery?}
    L -->|Camera| M[🎥 Record Video]
    L -->|Gallery| N[📁 Pick Video]
    M --> O[📹 Video Selected]
    N --> O
    
    O --> P{✅ Validate File}
    P -->|Invalid Type| Q[⚠️ Show Error]
    Q --> K
    P -->|Too Large| Q
    P -->|Valid| R[📤 Preview Video]
    
    R --> S[🔘 Tap Analyze]
    S --> T[⏳ Processing Dialog]
    T --> U[🤖 AI Analysis]
    U --> V[💾 Save to SQLite]
    V --> W[☁️ Sync to Firebase]
    W --> X[🔔 Create Notification]
    X --> Y[📊 Results Screen]
    
    Y --> Z{👆 User Action}
    Z -->|View Details| AA[📈 Detailed Metrics]
    Z -->|Analyze Another| I
    Z -->|Go Home| G
    Z -->|Logout| D
    
    AA --> Y
```

### Activity Flow Description

| Step | Screen | Action | Next |
|------|--------|--------|------|
| 1 | Splash | แสดง Logo 3 วินาที | Login/Home |
| 2 | Login | กรอก Email/Password + เลือก Role | Home |
| 3 | Home | ดู Dashboard + กดปุ่ม Upload | Upload |
| 4 | Upload | เลือก Camera หรือ Gallery | Select Video |
| 5 | Upload | Validate file type + size | Preview/Error |
| 6 | Upload | กดปุ่ม Analyze | Processing |
| 7 | Processing | แสดง Loading + AI ทำงาน 3-5 วินาที | Results |
| 8 | Results | แสดงคะแนน + กราฟ + Feedback | Home/Upload |

---

## 4. Sequence Diagram - Login Process

```mermaid
sequenceDiagram
    actor User
    participant LoginScreen
    participant Validators
    participant AuthProvider
    participant DatabaseHelper
    participant FirestoreService
    participant HomeScreen

    User->>LoginScreen: Enter Email & Password
    LoginScreen->>Validators: validateEmail(email)
    Validators-->>LoginScreen: null (valid) or error message
    
    alt Email Invalid
        LoginScreen-->>User: Show error message
    else Email Valid
        LoginScreen->>Validators: validatePassword(password)
        Validators-->>LoginScreen: null (valid) or error message
        
        alt Password Invalid
            LoginScreen-->>User: Show error message
        else Password Valid
            User->>LoginScreen: Select Role (Student/Instructor)
            User->>LoginScreen: Tap Login Button
            LoginScreen->>AuthProvider: login(email, name, role)
            AuthProvider->>DatabaseHelper: getUserByEmail(email)
            
            alt User Not Exists
                DatabaseHelper->>DatabaseHelper: createUser(userData)
            end
            
            DatabaseHelper-->>AuthProvider: User data
            AuthProvider->>FirestoreService: syncUserData()
            FirestoreService-->>AuthProvider: Sync complete
            AuthProvider-->>LoginScreen: Login successful
            LoginScreen->>HomeScreen: Navigate (with role check)
            
            alt Role is Student
                HomeScreen-->>User: Show Student Dashboard
            else Role is Instructor
                HomeScreen-->>User: Show Instructor Dashboard
            end
        end
    end
```

---

## 5. State Diagram - Session States

```mermaid
stateDiagram-v2
    [*] --> Idle: App Started
    
    Idle --> VideoSelected: User selects video
    VideoSelected --> Validating: Start validation
    
    Validating --> Invalid: Validation failed
    Invalid --> Idle: User acknowledges
    
    Validating --> Ready: Validation passed
    Ready --> Processing: User taps Analyze
    
    Processing --> Analyzing: AI processing
    Analyzing --> SavingLocal: Analysis complete
    SavingLocal --> SyncingCloud: Saved to SQLite
    SyncingCloud --> NotificationSent: Synced to Firebase
    NotificationSent --> Complete: Notification created
    
    Complete --> ViewingResults: Navigate to results
    ViewingResults --> Idle: User goes home
    ViewingResults --> VideoSelected: Analyze another
    
    Processing --> Error: Analysis failed
    Error --> Idle: User acknowledges
```

### State Descriptions

| State | Description |
|-------|-------------|
| Idle | ผู้ใช้อยู่ที่หน้า Home พร้อมเริ่มกระบวนการใหม่ |
| VideoSelected | เลือกวิดีโอแล้ว พร้อม validate |
| Validating | กำลังตรวจสอบ file type และ size |
| Invalid | Validation ไม่ผ่าน ต้องเลือกไฟล์ใหม่ |
| Ready | พร้อมส่งวิเคราะห์ |
| Processing | กำลังประมวลผลวิดีโอ |
| Analyzing | AI กำลังวิเคราะห์ |
| SavingLocal | บันทึกลง SQLite |
| SyncingCloud | Sync ขึ้น Firebase |
| NotificationSent | สร้างการแจ้งเตือนเสร็จสิ้น |
| Complete | กระบวนการเสร็จสิ้น |
| ViewingResults | ผู้ใช้กำลังดูผลลัพธ์ |
| Error | เกิดข้อผิดพลาด |

---

## Summary

เอกสารนี้ประกอบด้วย UML Diagrams ทั้ง 5 ประเภท:

1. **Use Case Diagram** - แสดง actors และ use cases ของระบบ
2. **Class Diagram** - แสดงโครงสร้าง classes และความสัมพันธ์
3. **Activity Diagram** - แสดง flow การทำงานของการอัปโหลดและวิเคราะห์วิดีโอ
4. **Sequence Diagram** - แสดงลำดับการทำงานของ Login process
5. **State Diagram** - แสดง states ต่างๆ ของ Session

ไฟล์นี้ตอบโจทย์ข้อกำหนด:
> "มี Design ที่เป็น User Case / Class / Activity / sequence / state อย่างน้อย 3 ไดอะแกรม"
