# คู่มือการเชื่อมต่อ Firebase (ทีละขั้นตอน)

คู่มือนี้จะอธิบายขั้นตอนการเชื่อมต่อโปรเจกต์ Firebase ของคุณเข้ากับแอปพลิเคชัน Flutter `ssid_app_v2` อย่างละเอียด

## ขั้นตอนที่ 1: ตั้งค่าใน Firebase Console

1. ไปที่ [Firebase Console](https://console.firebase.google.com/)
2. คลิก **Add project** และทำตามขั้นตอนเพื่อให้ได้โปรเจกต์ใหม่ (เช่น "SID-App")
3. เมื่อสร้างโปรเจกต์เสร็จแล้ว ให้คลิกที่ไอคอน **Android** เพื่อเพิ่มแอป Android เข้าไปในโปรเจกต์

## ขั้นตอนที่ 2: ลงทะเบียนแอป Android

1. **Android package name**: ใส่ชื่อ `com.example.ssid_app_v2`
2. **App nickname**: ใส่ชื่อ `ssid_app_v2`
3. **Debug signing certificate SHA-1** (ไม่บังคับ แต่แนะนำ):
   - รันคำสั่ง `./gradlew signingReport` ในโฟลเดอร์ `android` เพื่อหาค่า SHA-1
4. คลิก **Register app**

## ขั้นตอนที่ 3: ดาวน์โหลดและวางไฟล์ `google-services.json`

1. ดาวน์โหลดไฟล์ `google-services.json` ที่ Firebase เตรียมไว้ให้
2. ย้ายไฟล์นี้ไปวางในโฟลเดอร์โปรเจกต์ที่:
   `d:\react\React page1-3\ssid_app_v2\android\app\google-services.json`
   > [!IMPORTANT]
   > แอปจะไม่สามารถ Build ได้หากไม่มีไฟล์นี้ในโฟลเดอร์ `android/app`

## ขั้นตอนที่ 4: สร้าง Firestore Database

1. กลับไปที่ [Firebase Console](https://console.firebase.google.com/)
2. เลือกโปรเจกต์ **SSID-App** ของคุณ
3. ในเมนูด้านซ้าย คลิก **Build** → **Firestore Database**
4. คลิกปุ่ม **Create database**
5. เลือกโหมดเริ่มต้น:
   - **Production mode**: สำหรับแอปที่จะเผยแพร่ (ต้องตั้งค่า Rules)
   - **Test mode**: สำหรับการพัฒนา (อนุญาตให้อ่าน/เขียนได้ 30 วัน) ← **แนะนำสำหรับตอนนี้**
6. เลือก **Test mode** แล้วคลิก **Next**
7. เลือก **Cloud Firestore location**:
   - แนะนำ: `asia-southeast1` (Singapore) หรือ `asia-southeast2` (Jakarta)
8. คลิก **Enable** และรอสักครู่

> [!TIP]
> หลังจากสร้าง Database แล้ว คุณจะเห็นหน้า Firestore Console ที่สามารถเพิ่ม Collection และ Document ได้

### ตั้งค่า Firestore Rules (สำหรับการพัฒนา)

หากต้องการให้แอปสามารถอ่าน/เขียนข้อมูลได้ ให้ไปที่แถบ **Rules** และใส่:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true; // อนุญาตทุกคนในช่วงพัฒนา
    }
  }
}
```

> [!WARNING]
> กฎนี้อนุญาตให้ทุกคนอ่าน/เขียนได้ ใช้เฉพาะตอนพัฒนาเท่านั้น! ก่อน Deploy จริงต้องเปลี่ยนเป็นกฎที่เข้มงวดกว่านี้

## ขั้นตอนที่ 5: ตรวจสอบการตั้งค่า Gradle

ผมได้ทำการตั้งค่าไฟล์ Gradle ให้คุณเรียบร้อยแล้ว แต่อ้างอิงข้อมูลที่แก้ไขไปดังนี้:

### ไฟล์ `settings.gradle.kts` (ระดับโปรเจกต์)

เพิ่ม Google Services plugin เวอร์ชันล่าสุด:

```kotlin
plugins {
    // ... plugin อื่นๆ
    id("com.google.gms.google-services") version "4.4.4" apply false
}
```

### ไฟล์ `build.gradle.kts` (ระดับแอป - โฟลเดอร์ app)

เรียกใช้งาน Google Services plugin และเพิ่ม Firebase BoM:

```kotlin
plugins {
    // ...
    id("com.google.gms.google-services")
}

dependencies {
    // Import Firebase BoM เพื่อให้ version ของ Firebase libraries ทั้งหมดเข้ากัน
    implementation(platform("com.google.firebase:firebase-bom:34.8.0"))
    
    // Firebase products (ไม่ต้องระบุเวอร์ชัน เพราะ BoM จัดการให้)
    implementation("com.google.firebase:firebase-analytics")
    implementation("com.google.firebase:firebase-firestore")
    implementation("com.google.firebase:firebase-auth")
}
```

## ขั้นตอนที่ 6: เริ่มต้นระบบ Firebase ใน Flutter (Initialization)

ในไฟล์ `lib/main.dart` ผมได้เพิ่มโค้ดสำหรับเริ่มต้นระบบไว้แล้ว:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // <--- บรรทัดนี้คือการเชื่อมต่อแอปเข้ากับ Firebase
  runApp(const MyApp());
}
```

## ขั้นตอนที่ 7: ตรวจสอบการเชื่อมต่อ

1. รันแอปบน Emulator
2. ตรวจสอบใน Debug Console ว่ามีข้อความ "Firebase initialized" หรือไม่
3. ลองสร้างงาน (Assignment) ในแอป และตรวจสอบในแถบ **Firestore Database** ที่ Firebase Console ว่ามีข้อมูลขึ้นหรือไม่

---

> [!TIP]
> หากเจอข้อความ "Permission denied" ใน Firestore ให้ไปที่เมนู **Firestore Rules** ยอมรับเงื่อนไขการใช้งาน และตั้งค่ากฎให้ยอมรับการอ่าน/เขียน (Allow read, write) ในช่วงการพัฒนา
