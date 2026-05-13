# Clinic Automation App Audit

## Product Goal

Build a clinic automation platform with two main experiences:

- Doctor/admin dashboard for patient records, appointments, treatment tracking, and post-surgery plans.
- Patient dashboard for viewing bookings, rescheduling visits, and following recovery/medicine plans.

## What Already Exists

The current Flutter app already has a few useful building blocks:

- Firebase is initialized in `lib/main.dart`.
- Authentication flow exists with sign in and sign up screens in `lib/widgets/auth.dart`.
- Firestore is already used for storing appointments in `lib/widgets/app_form.dart`.
- Appointment listing exists in `lib/widgets/appt.dart`.
- A home screen, search UI, location access, and treatment-oriented pages already exist in `lib/home_page.dart`.

## What Is Working But Needs Improvement

### 1. Product scope and UI are not aligned yet

The app currently feels like a dental appointment discovery app, not a clinic operating system.

Examples:

- The home screen is centered on dental treatments and specialist browsing.
- Messaging like "Trusted Dental Clinic" and treatment cards is marketing-oriented.
- There is no clear doctor dashboard vs patient dashboard split.

### 2. Data model is too small for the product vision

Right now the Firestore usage only covers a simple appointment record:

- `doctorName`
- `patientName`
- `description`
- `date`
- `userId`

For your real use case, you will need structured records for:

- clinics
- doctors
- patients
- appointments
- medical reports
- prescriptions
- surgery cases
- post-op plans
- medications
- notifications

### 3. File structure is still widget-first instead of feature-first

Current folders like `widgets/` and `pages/` are okay for an early prototype, but they will become hard to manage as the app grows.

A better long-term structure is:

```text
lib/
  app/
  core/
  features/
    auth/
    dashboard/
    appointments/
    patients/
    reports/
    treatment_plans/
    prescriptions/
    profile/
```

### 4. Roles and permissions are missing

Your app needs role-based access at minimum:

- head doctor
- staff/receptionist
- patient

Without role separation, patient data and booking flows will become messy and risky.

### 5. Medical workflow objects are missing

Your vision includes post-surgery medicine plans and ongoing patient tracking, but there is no current data shape or screen flow for:

- diagnosis timeline
- uploaded reports
- surgery summary
- medicine schedule
- follow-up milestones
- recovery notes

## Recommended Architecture

### Frontend

- Flutter for mobile and web is a good choice if you want a single codebase.
- Create separate navigation experiences for doctor/admin users and patient users.
- Move from generic widgets to feature modules.

### Backend

Firebase is a reasonable starting point for an MVP if you want speed.

Use:

- Firebase Auth for login and role-linked users
- Cloud Firestore for operational records
- Firebase Storage for reports, scans, and files
- Cloud Functions later for reminders, notifications, and automation

### Suggested Firestore Collections

```text
users/
clinics/
doctors/
patients/
appointments/
medical_reports/
prescriptions/
surgery_plans/
post_op_plans/
notifications/
```

### Example Core Entities

`users`

- uid
- role (`head_doctor`, `staff`, `patient`)
- clinicId
- displayName
- email
- phone

`patients`

- patientId
- clinicId
- linkedUserId
- fullName
- age
- gender
- phone
- address
- bloodGroup
- allergies
- chronicConditions
- emergencyContact

`appointments`

- appointmentId
- clinicId
- doctorId
- patientId
- scheduledAt
- status (`booked`, `rescheduled`, `completed`, `cancelled`)
- visitType
- notes

`medical_reports`

- reportId
- patientId
- doctorId
- title
- summary
- attachmentUrl
- createdAt

`post_op_plans`

- planId
- patientId
- surgeryName
- doctorId
- medications
- careInstructions
- warningSigns
- nextFollowUpDate
- progressStatus

## Suggested App Modules

### Doctor/admin side

- Dashboard overview
- Patient directory
- Patient detail page
- Appointment calendar
- Create/reschedule/cancel appointment
- Report upload and review
- Prescription management
- Surgery and post-op plan creator

### Patient side

- My appointments
- Reschedule request
- My reports
- Prescription view
- Post-surgery medicine plan
- Recovery checklist

## Priority To-Do List

### Phase 1: Stabilize the foundation

- Rename and reorganize the current folder structure into features.
- Define app roles and a `users` collection.
- Replace demo dental-first copy with clinic workflow language.
- Create route guards so doctor and patient land on different dashboards.

### Phase 2: Fix data modeling

- Create Dart models for `UserProfile`, `Patient`, `Appointment`, `MedicalReport`, and `PostOpPlan`.
- Stop writing loose Firestore maps directly from UI widgets.
- Add repository/service layers between UI and Firestore.

### Phase 3: Build doctor workflow

- Add doctor dashboard home.
- Add patient list and patient profile screens.
- Add appointment creation, reschedule, and status management.
- Add report history per patient.

### Phase 4: Build patient workflow

- Add patient dashboard.
- Show upcoming and past appointments.
- Allow reschedule request or cancellation flow.
- Show prescriptions and post-op plans.

### Phase 5: Add clinic automation features

- Reminder notifications
- File uploads for reports and scans
- Search and filtering
- Audit trail for changes
- Better validation and error handling

## What Can Be Kept From Current Code

- Firebase setup
- Basic auth flow
- Firestore connection
- Appointment booking concept
- Some reusable UI pieces after cleanup

## What Should Probably Be Reworked

- `lib/home_page.dart` should become a real dashboard, not a marketing landing page.
- `lib/widgets/app_form.dart` should become an appointment feature screen with proper models and status fields.
- `lib/widgets/appt.dart` should filter appointments by role and current user or clinic.
- `lib/widgets/` is too broad and should be split into feature folders.
- Naming should be cleaned up, for example `App_form` and `Appt`.

## Immediate Next Steps

1. Freeze the product scope for MVP.
2. Decide the three user roles for version 1.
3. Redesign the Firestore schema before adding more screens.
4. Refactor the `lib/` folder into feature modules.
5. Build doctor dashboard and patient dashboard separately.
