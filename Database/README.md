# Rental Property Management Base

**Airtable Base ID:** `apppjeUadHRQGGv7O`  
**Generated:** 2026-10-03

---

## Overview

This base powers an end-to-end **rental property management system** with dynamic pricing, guest risk assessment, competitor monitoring, and system observability.

---

## Tables

### 1. `Properties` — `tblcyXwv9oaVWci57`
| Field | Type | Description |
|---|---|---|
| Property ID | Single line text (PK) | Unique identifier e.g. `P-1001` |
| Property Name | Single line text | Display name |
| Location | Single line text | City/state |
| Capacity | Number | Max guests |
| Base Nightly Price | Currency | Default rate |
| Min Price | Currency | Floor for dynamic pricing |
| Max Price | Currency | Ceiling for dynamic pricing |
| Current Price | Currency | Live active price |
| House Rules | Long text | Guest-facing rules |
| Active/Inactive | Single select | Listing status |
| Notes | Long text | Internal notes |
| Date Added | Created time | Auto-set |
| Last Price Change | Last modified time | Auto-updated |
| Bookings | Linked records | → Bookings |
| Pricing Records | Linked records | → Pricing Records |
| Competitor Market Feeds | Linked records | → Competitor Market Feeds |
| Local Events 2 | Linked records | → Local Events |
| Competitor market url | URL | Airbnb search link |
| Observed nightly rate | Lookup | From Competitor Market Feeds |
| Summary / Title (AI) | AI text | AI-generated from URL |

### 2. `Bookings` — `tblYWO05mhtP6JjQa`
| Field | Type | Description |
|---|---|---|
| Booking ID | Auto number (PK) | |
| Guest Name | Single line text | |
| Guest Email | Email | |
| Rental Purpose | Single line text | Guest-declared reason |
| Guest Count | Number | |
| Check-in / Check-out | Date | Reservation dates |
| Nights Count | Formula | check_out − check_in |
| Risk Score | Number | 0–100 |
| Risk Level | Single select | Low / Medium / High / Critical |
| Risk Signals | Long text | Detected risk factors |
| AI Reasoning | Long text | LLM explanation |
| Booking Status | Single select | Pending / Approved / Rejected / Cancelled / Expired |
| Submission Time | Created time | Auto-set |
| Review Deadline | Formula | Submission + 24h |
| Is Expired? | Formula | TRUE if past deadline & still Pending |
| Property | Linked records | → Properties |
| Owner Escalations | Linked records | → Owner Escalations |
| System Logs | Linked records | → System Logs |

### 3. `Owner Escalations` — `tblvLxf9fjSrBI01b`
| Field | Type | Description |
|---|---|---|
| Escalation ID | Auto number (PK) | |
| Owner Action | Single select | Approve / Reject / Request More Info / Escalate |
| Action Timestamp | Date/time | When owner responded |
| Response Time Sec | Formula | Seconds from submission to action |
| Booking | Linked records | → Bookings |

### 4. `Pricing Records` — `tbl1iLW5Aeq97SbG5`
| Field | Type | Description |
|---|---|---|
| Pricing ID | Auto number (PK) | |
| Event Impact | Single select | None / Low / Medium / High |
| Demand Level | Single select | Low / Medium / High |
| Is Weekend | Single select | Yes / No |
| Recommended Price | Currency | Algorithm output |
| Applied Price | Currency | Price actually set |
| Evaluated At | Created time | When this run was logged |
| Competitor Average | Currency | Avg of linked feeds at evaluation time |
| Property | Linked records | → Properties |

### 5. `Competitor Market Feeds` — `tblAGB3QoH2mN4WaB`
| Field | Type | Description |
|---|---|---|
| Feed ID | Auto number (PK) | |
| Competitor Name | Single line text | |
| Observed Nightly Rate | Currency | Most recent rate |
| Last Scraped At | Date/time | Last data pull |
| Status | Single select | Active / Inactive / Error |
| Property | Linked records | → Properties |

### 6. `Local Events` — `tblZXmbKtsYRvw6pD`
| Field | Type | Description |
|---|---|---|
| Event ID | Auto number (PK) | |
| Location Zone | Single line text | Area affected |
| Impact Level | Single select | Low / Medium / High |
| Notes | Long text | Event description |
| Related properties | Linked records | → Properties |

### 7. `System Logs` — `tblWYo5bmb0t5Gptj`
| Field | Type | Description |
|---|---|---|
| Log ID | Auto number (PK) | |
| Timestamp | Created time | Auto-set |
| Workflow Name | Single line text | Triggering automation |
| Failure Mode | Single line text | Error type label |
| Error Payload | Long text | Raw error JSON |
| Resolution Action | Long text | Steps taken |
| Is Resolved? | Single select | Yes / No / In Progress |
| Error Severity (AI) | AI text | AI-generated severity |
| Related Booking | Linked records | → Bookings |

---

## Entity Relationships

```
Properties
  ├── has many → Bookings
  ├── has many → Pricing Records
  ├── has many → Competitor Market Feeds
  └── has many ↔ Local Events (many-to-many)

Bookings
  ├── belongs to → Properties
  ├── has many  → Owner Escalations
  └── has many  → System Logs

Owner Escalations  → belongs to Bookings
Pricing Records    → belongs to Properties
Competitor Feeds   → belongs to Properties
System Logs        → belongs to Bookings (optional)
```

---

## Key Automations

| Automation | Trigger | Action |
|---|---|---|
| Risk Scorer | New booking submitted | AI scores risk; writes Risk Score, Level, Signals, Reasoning |
| Escalation Creator | Risk Level = High or Critical | Creates Owner Escalation + notifies owner |
| Expiry Checker | Scheduled hourly | Marks Pending bookings as Expired past Review Deadline |
| Price Sync | Pricing Record updated | Updates Current Price on linked Property |
| Competitor Scraper | Scheduled daily | Refreshes Observed Nightly Rate feeds |

---

## File Reference

| File | Purpose |
|---|---|
| `schema.sql` | PostgreSQL DDL — tables, constraints, indexes |
| `seed.sql` | Sample INSERT statements matching live base data |
| `README.md` | This documentation file |

> SQL targets **PostgreSQL**. Minor adjustments needed for MySQL or SQLite.