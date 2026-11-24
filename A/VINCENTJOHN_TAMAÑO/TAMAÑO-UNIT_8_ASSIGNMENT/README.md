# CICT Org Fair 2026

**Live Web App URL:** https://vincenttamano.github.io/tamano-orgfair/  
**GitHub Repository:** https://github.com/vincenttamano/tamano-orgfair  

**Student Name:** Vincent John A. Tamaño  
**Year & Section:** BSIT 3A CBS  
**Subject:** CC 207B - Application Development  
**Institution:** West Visayas State University - College of Information and Communications Technology  

---

## Overview

The CICT Org Fair app is a multi-platform Flutter application providing attendees and students with information on college organizations, officer directories, schedules, and live event updates powered by **Contentful Headless CMS**.

In **Unit 8**, the application is prepared for production release across the Web and Android platforms, featuring automated continuous integration and deployment (CI/CD) pipelines via GitHub Actions.

---

## Release Configuration

- **Version:** `1.1.0+2` (Version 1.1.0, Build 2)
- **Application Name:** CICT Org Fair
- **Permissions:** `<uses-permission android:name="android.permission.INTERNET"/>`
- **CMS Integration:** Contentful Headless CMS (`a9iyylcfbwl9`)
- **Web App:** Configured PWA (`web/manifest.json`, `web/index.html`)
- **Android Signing:** Signed release configuration with JKS upload keystore via `android/key.properties`

---

## How to Build & Run

### 1. Web Release Build:
```bash
flutter build web --release --dart-define-from-file=cms.json
```

### 2. Android APK Release Build:
```bash
flutter build apk --release --dart-define-from-file=cms.json
```

### 3. Run Tests:
```bash
flutter test
```
*(All 31 unit, widget, and release tests passing)*

