
# 📑 Kiosqueeing System — Complete Kiosk Module Development Guide

## ✅ Overview

This documentation describes how to build the **Kiosk Module** in Flutter using the existing Laravel API. It includes:
- System architecture
- Clean DioService
- SharedPreferenceManager
- KioskController logic
- Middleware
- Screens structure
- Expected UI behavior

This is for Flutter developers to follow step-by-step.

---

## ✅ Architecture

| Layer | Purpose |
|-------|---------|
| **API** | Laravel REST API at `/api/kiosk/*` |
| **DioService** | Singleton to make safe requests with `fpdart` Either |
| **SharedPreferenceManager** | Stores branch code & branch model locally |
| **KioskController** | Controls local + remote state |
| **Middleware** | Redirects routes based on branch code presence |
| **Screens** | Self-service UI: BranchCode, Services, Print |

---

## ✅ API Endpoints (Ready)

- `POST /api/kiosk/check-branch` → validate branch code
- `GET /api/kiosk/branch` → get branch info
- `GET /api/kiosk/services` → get list of services
- `POST /api/kiosk/queue` → create new queue ticket

---

## ✅ DioService

**File:** `lib/core/dio/dio_service.dart`

- Uses singleton pattern.
- Uses `Either<Failure, Response>`.
- Pretty logging for debugging.
- Handles all HTTP errors with user-friendly messages.

Usage:
```dart
final dioService = DioService();
final result = await dioService.request(path: '/check-branch', method: 'POST', data: {...});
```

---

## ✅ SharedPreferenceManager

**File:** `lib/core/shared_preferences/shared_preference_manager.dart`

Stores:
- `branch_code` (String)
- `branch_model` (JSON)

Usage:
```dart
// Save
await saveBranchCode(code);
await saveBranchModel(branch.toMap());

// Get
final code = await getBranchCode();
final map = await getBranchModel();
final branch = Branch.fromMap(map);

// Clear
await removeBranchCode();
await removeBranchModel();
```

---

## ✅ KioskController

**File:** `lib/controllers/kiosk_controller.dart`

- Loads branch code & model on startup.
- Checks branch code with API.
- Stores data locally.
- Used in middleware + screens.

Key methods:
```dart
Future<void> loadBranchCode();
Future<bool> checkBranch(String inputCode);
Future<void> saveBranchCodeAndModel(String code, Branch branchModel);
Future<void> clearBranchData();
```

---

## ✅ Middleware

| Middleware | What it does |
|------------|---------------|
| **BranchMiddleware** | Blocks routes if no branch code. Redirects to `/branch-code`. |
| **NoBranchMiddleware** | Blocks `/branch-code` if branch code is already set. Redirects to `/services`. |

---

## ✅ Screens & Expected UI

### 1️⃣ BranchCodeScreen

- **Purpose:** Staff sets kiosk branch once.
- **UI:**  
  - One `TextField` for branch code.
  - One `Verify` button.
  - If code valid: save to local + navigate to `/services`.
  - If invalid: show `Modal.error`.

### 2️⃣ ServicesScreen

- **Purpose:** Customer sees all services for this branch.
- **UI:**
  - Grid/List of services.
  - Tapping a service calls `/queue` to get a ticket.
  - Shows confirmation + prints ticket.

### 3️⃣ PrintScreen

- **Purpose:** After getting a ticket, show big ticket number.
- **UI:**
  - Big ticket number.
  - Service name.
  - Auto print via `SunmiPrinterController`.

---

## ✅ Expected Flow

1. Kiosk boots → `KioskController.loadBranchCode()`.
2. If no branch → shows `BranchCodeScreen` → verify & save.
3. If valid → shows `ServicesScreen`.
4. Customer taps a service → gets ticket → shows `PrintScreen` → prints.
5. After printing → auto-redirect back to `ServicesScreen`.

---

## ✅ Notes for Flutter Developer

- Use **GetX** for state, routing, modal dialogs.
- Use **fpdart** Either for Dio responses.
- Use **SharedPreferences** to persist branch info.
- Use **Lottie** for success/error modals.
- Use **SunmiPrinterController** for printing ticket.

---

## ✅ Project Folders

```
lib/
 ├── controllers/
 │   ├── kiosk_controller.dart
 │   ├── sunmi_printer_controller.dart
 ├── core/
 │   ├── dio/
 │   │   ├── dio_service.dart
 │   ├── shared_preferences/
 │   │   ├── shared_preference_manager.dart
 ├── middleware/
 │   ├── branch_middleware.dart
 │   ├── no_branch_middleware.dart
 ├── models/
 │   ├── branch.dart
 │   ├── service.dart
 │   ├── queue.dart
 │   ├── setting.dart
 ├── screens/
 │   ├── branch_code_screen.dart
 │   ├── services_screen.dart
 │   ├── print_screen.dart
 ├── widgets/
 │   ├── modal.dart
 ├── main.dart
```

---

## ✅ Final Notes

This guide covers:
- How to build the kiosk core flow.
- Which files do what.
- What the UI should look like.
- How it connects to the backend.

Follow this to keep everything consistent with the Laravel backend and actual kiosk hardware!

---

**Version:** Kiosqueeing Kiosk Module v1.0 — Updated June 20, 2025

**End of Documentation**
