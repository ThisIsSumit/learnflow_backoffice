# LearnFlow Backoffice

LearnFlow Backoffice is a Flutter administration app used by internal teams to monitor and manage platform data.

It connects to the LearnFlow API, authenticates managers, and provides editable data tables for operational workflows.

## Core Functionality

### 1) Authentication
- Manager login with email/password.
- JWT token is stored securely using `flutter_secure_storage`.
- Automatic session restore on app startup.
- Logout flow with confirmation dialog.

### 2) Data Management (Current active module)
The **Management** section provides tabular management screens powered by `PlutoGrid`:

- **Students**
	- List students.
	- Inline edit student fields.
	- Delete selected student.

- **Teachers**
	- List teachers.
	- Inline edit teacher fields (including validation status).
	- Delete selected teacher.

- **Bookings**
	- List bookings.
	- Inline edit booking fields.
	- Delete selected booking.

### 3) API Integration
- Uses `Dio` + `Retrofit` for typed HTTP clients.
- Uses generated models (`json_serializable` / `freezed`).
- Includes service definitions for additional entities (reports, payments, chats, etc.) that can be exposed in future UI modules.

## Tech Stack

- Flutter + Dart
- Riverpod / Hooks Riverpod (state management)
- Dio + Retrofit (API layer)
- PlutoGrid (admin data tables)
- Envied (environment variables)
- Flutter Secure Storage (JWT persistence)

## Project Structure

```text
lib/
	main.dart                     # App bootstrap + auth gate
	screens/
		login/                      # Login UI
		home/                       # Shell + navigation rail
		management/                 # Admin data tables (students/teachers/bookings)
		dashboard/                  # Placeholder dashboard UI
		settings/                   # Placeholder settings UI
	services/
		api/                        # Retrofit API contracts
		authentication/             # Secure token storage
		env/                        # Environment access with Envied
	models/                       # Domain models
	dto/                          # Auth and JWT DTOs
```

## Getting Started

### Prerequisites
- Flutter SDK (matching project Dart constraints)
- A running LearnFlow backend API

### 1) Configure environment
Create a `.env.dev` file at project root:

```env
API_BASE_URL="http://localhost:3000"
```

### 2) Install dependencies
```bash
flutter pub get
```

### 3) Generate code
Run once:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Or keep generation in watch mode during development:

```bash
dart run build_runner watch --delete-conflicting-outputs
```

### 4) Run the app
```bash
flutter run
```

## Development Notes

- If `.env.dev` is missing or invalid, API calls will fail.
- Any change to Retrofit interfaces, DTOs, `@freezed` or `@JsonSerializable` models requires code regeneration.
- Dashboard and Settings screens exist but are currently placeholders.

## Useful Commands

```bash
flutter analyze
flutter test
```
