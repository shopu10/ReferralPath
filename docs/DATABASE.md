# Database design

ReferralPath uses a MySQL 8 database named `referralpath` with **18 tables**, **12 views** and **7 stored procedures**. The Streamlit app reads through views and writes only through stored procedures.

See [ERD.md](ERD.md) for the entity-relationship diagram.

## Design highlights

- **Referential integrity:** 31 foreign keys. All use `ON DELETE RESTRICT` except `appointment.rescheduled_from_id` (`SET NULL`); `referral_check.referral_id` (`CASCADE`).
- **Data validation in the database:** 6 `CHECK` constraints (e.g. slot end time after start time, non-negative daily limits, valid assignment and credential date ranges).
- **Constrained value sets (ENUM columns):** `appointment.status`, `attendance_punch.event_type`, `attendance_punch.validation_status`, `daily_queue.status`, `doctor.status`, `health_facility.facility_level`, `health_facility.facility_type`, `patient.gender`, `patient.blood_group`, `referral_check.doctor_availability`, `referral_check.capacity_status`, `referral_check.attendance_freshness`, `referral_request.status`.
- **Uniqueness rules:** e.g. one queue number per department per day (`daily_queue`), one capacity row per department per date, unique doctor registration numbers, staff IDs and card UIDs.
- **Referral hierarchy:** facilities are tagged `UNION`, `UPAZILA` or `DISTRICT`, and referral options expose a hierarchy priority.

## Views

| View | Built from | Used by (app pages) | Depends on current date/time |
|---|---|---|---|
| `v_admin_dashboard` | `department`, `health_facility`, `v_department_live_status`, `v_facility_attendance` | Overview, Admin | yes |
| `v_appointment_dashboard` | `appointment`, `daily_queue`, `department`, `department_slot`, `doctor`, `health_facility`, `patient` | Overview, Appointments | no |
| `v_department_live_status` | `appointment`, `department`, `department_capacity`, `doctor`, `doctor_assignment`, `health_facility`, `v_doctor_attendance` | Appointments | yes |
| `v_doctor_attendance` | `attendance_punch`, `attendance_source`, `doctor`, `doctor_credential`, `health_facility` | Appointments, Attendance | yes |
| `v_facility_attendance` | `attendance_punch`, `attendance_source`, `health_facility` | supporting view (not queried directly) | yes |
| `v_facility_dashboard` | `v_facility_reliability`, `v_referral_facility_status` | Admin | yes |
| `v_facility_reliability` | `attendance_punch`, `attendance_source`, `health_facility` | supporting view (not queried directly) | yes |
| `v_patient_dashboard` | `appointment`, `daily_queue`, `department`, `department_slot`, `doctor`, `health_facility`, `patient`, `referral_request`, `specialty` | Patient | no |
| `v_patient_referral_history` | `health_facility`, `patient`, `referral_request`, `specialty` | Patient, Referrals | no |
| `v_referral_candidate_status` | `department`, `health_facility`, `specialty`, `upazila`, `v_department_live_status`, `v_facility_attendance` | supporting view (not queried directly) | yes |
| `v_referral_facility_status` | `v_referral_candidate_status` | supporting view (not queried directly) | yes |
| `v_today_queue` | `appointment`, `daily_queue`, `department`, `doctor`, `health_facility`, `patient` | Overview, Queue | yes |

Views that depend on the current date/time show live operational status, so they only look populated when the data covers today.

## Stored procedures

All data changes made by the app go through these procedures. Their definitions are in `database/referral_path.sql`.

| Procedure | Arguments (as called by the app) | Called from |
|---|---|---|
| `sp_book_appointment` | patient_id, department_id, slot_id, doctor_id (or NULL), appointment_date, reason | Appointments |
| `sp_find_referral_options` | patient_id, specialty_id | Referrals |
| `sp_route_referral` | patient_id, specialty_id, origin_facility_id, reason | Referrals |
| `sp_call_next_patient` | department_id, date | Queue |
| `sp_start_queue_service` | queue_id | Queue |
| `sp_complete_queue_visit` | queue_id | Queue |
| `sp_record_attendance_punch` | credential_id, source_id, event_type | Attendance |

## Tables

### Geography

#### `district`

Top-level administrative area.

| Column | Type | Notes |
|---|---|---|
| `district_id` | `int unsigned` | PK, auto-increment |
| `name` | `varchar(100)` | unique |

#### `upazila`

Sub-district; belongs to a district.

| Column | Type | Notes |
|---|---|---|
| `upazila_id` | `int unsigned` | PK, auto-increment |
| `district_id` | `int unsigned` | FK to `district.district_id` |
| `name` | `varchar(100)` |  |

**Constraints:** unique (district_id, name)

#### `administrative_union`

Smallest administrative unit; belongs to an upazila.

| Column | Type | Notes |
|---|---|---|
| `union_id` | `int unsigned` | PK, auto-increment |
| `upazila_id` | `int unsigned` | FK to `upazila.upazila_id` |
| `name` | `varchar(100)` |  |

**Constraints:** unique (upazila_id, name)

### Facilities and departments

#### `health_facility`

Health facilities at UNION, UPAZILA and DISTRICT level, with type and coordinates.

| Column | Type | Notes |
|---|---|---|
| `facility_id` | `int unsigned` | PK, auto-increment |
| `name` | `varchar(150)` |  |
| `facility_level` | `enum('UNION','UPAZILA','DISTRICT')` |  |
| `facility_type` | `enum('UNION_FACILITY','UPAZILA_HEALTH_COMPLEX','DISTRICT_GOVERNMENT_HOSPITAL','MEDICAL_COLLEGE_HOSPITAL')` |  |
| `upazila_id` | `int unsigned` | FK to `upazila.upazila_id` |
| `union_id` | `int unsigned` | FK to `administrative_union.union_id`, nullable |
| `address` | `varchar(255)` |  |
| `phone` | `varchar(30)` | nullable |
| `latitude` | `decimal(9,6)` | nullable |
| `longitude` | `decimal(9,6)` | nullable |
| `is_active` | `tinyint(1)` | default 1 |

**Constraints:** unique (upazila_id, name)

#### `specialty`

Catalogue of medical specialties.

| Column | Type | Notes |
|---|---|---|
| `specialty_id` | `int unsigned` | PK, auto-increment |
| `name` | `varchar(100)` | unique |

#### `department`

A specialty-specific department inside a facility.

| Column | Type | Notes |
|---|---|---|
| `department_id` | `int unsigned` | PK, auto-increment |
| `facility_id` | `int unsigned` | FK to `health_facility.facility_id` |
| `specialty_id` | `int unsigned` | FK to `specialty.specialty_id` |
| `name` | `varchar(120)` |  |
| `is_active` | `tinyint(1)` | default 1 |

**Constraints:** unique (facility_id, name)

#### `department_slot`

Appointment time slots offered by a department.

| Column | Type | Notes |
|---|---|---|
| `slot_id` | `int unsigned` | PK, auto-increment |
| `department_id` | `int unsigned` | FK to `department.department_id` |
| `slot_name` | `varchar(50)` |  |
| `start_time` | `time` |  |
| `end_time` | `time` |  |
| `is_active` | `tinyint(1)` | default 1 |

**Constraints:** unique (department_id, slot_name); check: end_time > start_time

#### `department_capacity`

Daily appointment limit per department and date.

| Column | Type | Notes |
|---|---|---|
| `capacity_id` | `bigint unsigned` | PK, auto-increment |
| `department_id` | `int unsigned` | FK to `department.department_id` |
| `capacity_date` | `date` |  |
| `daily_limit` | `int unsigned` |  |

**Constraints:** unique (department_id, capacity_date); check: daily_limit >= 0

### Doctors and attendance

#### `doctor`

Doctor registry (registration number and status).

| Column | Type | Notes |
|---|---|---|
| `doctor_id` | `int unsigned` | PK, auto-increment |
| `registration_no` | `varchar(50)` | unique |
| `full_name` | `varchar(150)` |  |
| `phone` | `varchar(30)` | nullable |
| `email` | `varchar(150)` | nullable |
| `status` | `enum('ACTIVE','INACTIVE','SUSPENDED')` | default ACTIVE |

#### `doctor_assignment`

Assignment of a doctor to a department over a date range.

| Column | Type | Notes |
|---|---|---|
| `assignment_id` | `int unsigned` | PK, auto-increment |
| `doctor_id` | `int unsigned` | FK to `doctor.doctor_id` |
| `department_id` | `int unsigned` | FK to `department.department_id` |
| `start_date` | `date` |  |
| `end_date` | `date` | nullable |
| `is_primary` | `tinyint(1)` | default 0 |

**Constraints:** check: (end_date is null) or (end_date >= start_date)

#### `doctor_credential`

Staff ID and card UID a doctor uses at a facility, with a validity window.

| Column | Type | Notes |
|---|---|---|
| `credential_id` | `int unsigned` | PK, auto-increment |
| `doctor_id` | `int unsigned` | FK to `doctor.doctor_id` |
| `facility_id` | `int unsigned` | FK to `health_facility.facility_id` |
| `staff_id` | `varchar(50)` | unique |
| `card_uid` | `varchar(100)` | unique |
| `active_from` | `datetime` |  |
| `active_to` | `datetime` | nullable |

**Constraints:** check: (active_to is null) or (active_to >= active_from)

#### `attendance_source`

Attendance data source per facility, with staleness threshold (minutes) and reliability window (days).

| Column | Type | Notes |
|---|---|---|
| `source_id` | `int unsigned` | PK, auto-increment |
| `facility_id` | `int unsigned` | FK to `health_facility.facility_id` |
| `source_name` | `varchar(100)` |  |
| `stale_after_minutes` | `int unsigned` | default 120 |
| `reliability_window_days` | `int unsigned` | default 30 |
| `is_active` | `tinyint(1)` | default 1 |

**Constraints:** unique (facility_id, source_name); check: reliability_window_days > 0; check: stale_after_minutes > 0

#### `attendance_punch`

PUNCH_IN / PUNCH_OUT events with a validation status.

| Column | Type | Notes |
|---|---|---|
| `punch_event_id` | `bigint unsigned` | PK, auto-increment |
| `credential_id` | `int unsigned` | FK to `doctor_credential.credential_id` |
| `source_id` | `int unsigned` | FK to `attendance_source.source_id` |
| `event_type` | `enum('PUNCH_IN','PUNCH_OUT')` |  |
| `punched_at` | `datetime` |  |
| `recorded_at` | `datetime` | default CURRENT_TIMESTAMP |
| `validation_status` | `enum('VALID','INVALID','PENDING')` | default PENDING |
| `validation_reason` | `varchar(255)` | nullable |

### Patients, appointments and queue

#### `patient`

Patient demographics and home union.

| Column | Type | Notes |
|---|---|---|
| `patient_id` | `bigint unsigned` | PK, auto-increment |
| `full_name` | `varchar(150)` |  |
| `phone` | `varchar(30)` |  |
| `email` | `varchar(150)` | nullable |
| `date_of_birth` | `date` | nullable |
| `gender` | `enum('MALE','FEMALE','OTHER','UNSPECIFIED')` | default UNSPECIFIED |
| `blood_group` | `enum('A_POS','A_NEG','B_POS','B_NEG','AB_POS','AB_NEG','O_POS','O_NEG','UNKNOWN')` | default UNKNOWN |
| `address` | `varchar(255)` | nullable |
| `union_id` | `int unsigned` | FK to `administrative_union.union_id` |
| `created_at` | `timestamp` | default CURRENT_TIMESTAMP |

#### `appointment`

Appointment bookings; supports rescheduling through a self-reference.

| Column | Type | Notes |
|---|---|---|
| `appointment_id` | `bigint unsigned` | PK, auto-increment |
| `patient_id` | `bigint unsigned` | FK to `patient.patient_id` |
| `department_id` | `int unsigned` | FK to `department.department_id` |
| `slot_id` | `int unsigned` | FK to `department_slot.slot_id` |
| `doctor_id` | `int unsigned` | FK to `doctor.doctor_id`, nullable |
| `appointment_date` | `date` |  |
| `status` | `enum('BOOKED','CANCELLED','RESCHEDULED','COMPLETED','NO_SHOW')` | default BOOKED |
| `reason` | `varchar(255)` | nullable |
| `rescheduled_from_id` | `bigint unsigned` | FK to `appointment.appointment_id`, nullable |
| `created_at` | `timestamp` | default CURRENT_TIMESTAMP |
| `updated_at` | `timestamp` | default CURRENT_TIMESTAMP |

#### `daily_queue`

Per-department daily queue with unique queue numbers per day.

| Column | Type | Notes |
|---|---|---|
| `queue_id` | `bigint unsigned` | PK, auto-increment |
| `patient_id` | `bigint unsigned` | FK to `patient.patient_id` |
| `appointment_id` | `bigint unsigned` | FK to `appointment.appointment_id`, nullable |
| `department_id` | `int unsigned` | FK to `department.department_id` |
| `queue_number` | `int unsigned` |  |
| `queue_date` | `date` |  |
| `status` | `enum('WAITING','CALLED','IN_SERVICE','COMPLETED','CANCELLED','NO_SHOW')` | default WAITING |
| `issued_at` | `datetime` | default CURRENT_TIMESTAMP |
| `called_at` | `datetime` | nullable |
| `completed_at` | `datetime` | nullable |

**Constraints:** unique (department_id, queue_date, queue_number)

### Referrals

#### `referral_request`

A referral for a patient and specialty, from an origin facility to a destination facility.

| Column | Type | Notes |
|---|---|---|
| `referral_id` | `bigint unsigned` | PK, auto-increment |
| `patient_id` | `bigint unsigned` | FK to `patient.patient_id` |
| `requested_union_id` | `int unsigned` | FK to `administrative_union.union_id` |
| `specialty_id` | `int unsigned` | FK to `specialty.specialty_id` |
| `origin_facility_id` | `int unsigned` | FK to `health_facility.facility_id` |
| `destination_facility_id` | `int unsigned` | FK to `health_facility.facility_id`, nullable |
| `requested_at` | `timestamp` | default CURRENT_TIMESTAMP |
| `reason` | `varchar(255)` |  |
| `status` | `enum('REQUESTED','ROUTED','ACCEPTED','COMPLETED','CANCELLED')` | default REQUESTED |

#### `referral_check`

Audit trail of each candidate facility evaluated for a referral.

| Column | Type | Notes |
|---|---|---|
| `check_id` | `bigint unsigned` | PK, auto-increment |
| `referral_id` | `bigint unsigned` | FK to `referral_request.referral_id` |
| `facility_id` | `int unsigned` | FK to `health_facility.facility_id` |
| `sequence_no` | `int unsigned` |  |
| `checked_at` | `timestamp` | default CURRENT_TIMESTAMP |
| `doctor_availability` | `enum('AVAILABLE','UNAVAILABLE','STALE','NO_DATA')` |  |
| `capacity_status` | `enum('AVAILABLE','LIMITED','FULL','NO_DATA')` |  |
| `attendance_freshness` | `enum('FRESH','STALE','NO_DATA')` |  |
| `reason` | `varchar(255)` |  |
| `is_selected` | `tinyint(1)` | default 0 |

**Constraints:** unique (referral_id, sequence_no); unique (referral_id, facility_id)
