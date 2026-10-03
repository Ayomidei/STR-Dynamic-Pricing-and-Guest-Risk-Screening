## 🚀 Local Setup & Environment Configuration

 **Clone the repository:**
   ```bash
   git clone [https://github.com/Ayomide/STR-Dynamic-Pricing-and-Guest-Risk-Screening.git](https://github.com/your-username/STR-Dynamic-Pricing-and-Guest-Risk-Screening.git)
   cd STR-Dynamic-Pricing-and-Guest-Risk-Screening

## Multi-Property Short-Term Rental Dynamic Pricing & Guest-Risk Screening Engine

An end-to-end backend ecosystem and property management suite built on **n8n**, **Airtable**, **JavaScript Risk Engine (Code Node)**, **Google Gemini AI**, and **Telegram Bot API**. The system automates market pricing ingestion, dynamic rate updates using bounded algorithm logic, unified code-driven guest risk evaluation, interactive owner escalations, and administrative dashboard management.


## Technical Stack

* **Database:** Airtable Base (Relational architecture across 7 core tables)
* **Automation Workflow:** n8n Engine (Modular and unified workflow execution)
* **Risk Screening Engine:** Custom JavaScript Code Node (Deterministic rule evaluator & risk scoring engine)
* **AI Integration:** Google Gemini AI (`gemini-flash-lite-latest` for event classification)
* **Notifications & Escalations:** Telegram Bot API (Interactive inline callbacks)
* **Web Interfaces:** HTML5 / Tailwind CSS / Vanilla JavaScript (Guest Booking Portal & Owner Management Dashboard)

---

## Architecture & System Overview

                    ┌────────────────────────────────────────┐
                    │             Airtable Base              │
                    │ (Properties, Feeds, Events, Bookings)  │
                    └───────────────────┬────────────────────┘
                                        │
    ┌───────────────────────────────────┼───────────────────────────────────┐
    │                                   │                                   │
    ▼                                   ▼                                   ▼
┌──────────────────────┐        ┌──────────────────────┐        ┌──────────────────────┐
│  Engine 1: Market    │        │  Engine 2: Dynamic   │        │  Engine 3: JS Risk   │
│  Feeds Ingestion     │        │  Pricing Engine      │        │  Engine & Escalation │
│  (12h Cron Trigger)  │        │  (24h Cron Trigger)  │        │  (Webhook Trigger)   │
└──────────┬───────────┘        └──────────┬───────────┘        └──────────┬───────────┘
│                               │                               │
┌─────────┴─────────┐            ┌────────┴─────────┐            ┌────────┴─────────┐
│ • Firecrawl Web   │            │ • Multiplier     │            │ • JavaScript     │
│   Scraping        │            │   Logic (Comp,   │            │   Risk Code Node │
│ • SerpAPI Google  │            │   Events, Weekend│            │ • Auto-Approve   │
│   Events          │            │ • Safety Bounds  │            │   or Escalation  │
│ • Gemini Impact   │            │   (Min/Max Floor)│            │ • Telegram       │
│   Classification  │            │ • Airtable Sync  │            │   Approval UI    │
└───────────────────┘            └──────────────────┘            └──────────────────┘

## Core System Components

### 1. Database Schema (Airtable)
The relational database layer stores operational data across 7 tables:
1. **Properties:** Stores listing details (`Base Nightly Price`, `Min Price`, `Max Price`, `Current Price`, `Capacity`, `House Rules`).
2. **Bookings:** Tracks guest submissions (`Risk Score`, `Risk Level`, `Risk Signals`, `AI Reasoning`, `Booking Status`, `Submission Time`).
3. **Pricing Records:** Stores output logs from the dynamic pricing algorithm.
4. **Competitor Market Feeds:** Holds scraped rate feeds (`Observed Nightly Rate`, `Status`).
5. **Local Events & Demand Signals:** Stores local events and Gemini AI-classified `Impact Level` (`HIGH`, `MEDIUM`, `NONE`).
6. **System Logs & Error Triggers:** Centralized log for system outages and workflow failures.
7. **Owner Escalations:** Audit logs of interactive owner decisions via Telegram or Dashboard overrides.

### 2. JavaScript Risk Engine & Automation Workflows (n8n)
* **Competitor Feeds & Event Ingestion:** Runs every 12 hours. Scrapes market rates using Firecrawl API, fetches local events via SerpAPI, and classifies demand impact using Gemini AI.
* **Dynamic Pricing Engine:** Runs every 24 hours. Calculates new property rates using base rates, competitor deltas, event impact multipliers, and weekend surges, bounded by hard floor (`Min Price`) and ceiling (`Max Price`) constraints.
* **JavaScript Risk Analysis Engine (Code Node):** Triggered via Webhook (`POST /booking-request`). Executes code-level risk scoring in a single unified step:
  * **Hard Check 1 (Capacity Overload):** Adds `+90` points if `guest_count` > `property_capacity`.
  * **Hard Check 2 (Restricted Purpose Keywords):** Adds `+85` points if purpose contains terms like *"party"*, *"birthday"*, *"wedding"*, *"rave"*, or *"bachelor"*.
  * **Soft Check 3 (High Utilization):** Adds `+25` points if party size exceeds 90% of capacity.
  * **Soft Check 4 (Vague Purpose):** Adds `+20` points if rental description is brief (< 5 chars).
  * **Decision & Routing:**
    * **Low Risk (`risk_score < 50`):** Sets `risk_level: "LOW"`, auto-approves (`ACCEPTED`), and sends guest confirmation.
    * **High Risk (`risk_score >= 50`):** Sets `risk_level: "HIGH"`, marks `PENDING_REVIEW`, and routes to Telegram owner escalation card with a 15-minute countdown window.
* **Telegram Callback & Escalation Listener:** Parses inline Telegram button clicks (`ACCEPT` / `DECLINE`), updates Airtable status, and logs response latency.

---

## Code Node Risk Engine Snippet

```javascript
// n8n Code Node: JavaScript Risk Engine Sample Logic
const item = $input.item.json;
const guestCount = Number(item.guest_count || 0);
const propertyCapacity = Number(item.property_capacity || 0);
const rentalPurpose = (item.rental_purpose || '').toLowerCase();
const restrictedKeywords = ["party", "birthday", "wedding", "rave", "bachelor", "event"];

let riskScore = 0;
let riskSignals = [];

if (guestCount > propertyCapacity) {
  riskSignals.push("GUEST_COUNT_EXCEEDS_CAPACITY");
  riskScore += 90;
}

const foundKeywords = restrictedKeywords.filter(k => rentalPurpose.includes(k));
if (foundKeywords.length > 0) {
  riskSignals.push("PROHIBITED_PURPOSE_KEYWORD");
  riskScore += 85;
}

const finalRiskScore = Math.min(Math.max(riskScore, 0), 100);
const riskLevel = finalRiskScore >= 50 ? "HIGH" : "LOW";

return {
  json: {
    ...item,
    risk_score: finalRiskScore,
    risk_level: riskLevel,
    risk_signals: riskSignals.join(", ") || "NONE",
    is_high_risk: riskLevel === "HIGH"
  }
};

Setup & Deployment
Prerequisites
n8n Instance: Self-hosted (Docker) or n8n Cloud.

Airtable Account: Personal Access Token (PAT) with read/write access to the project base.

API Credentials: Firecrawl API, SerpAPI, Google Gemini API, Telegram Bot Token.

Quick Start
Airtable: Create the 7 core tables and verify field names (Risk Score, Risk Level, Risk Signals, AI Reasoning).

n8n Workflows: Import the workflow JSON file into n8n. Verify the JavaScript Risk Analysis Engine Code Node outputs risk_level and risk_score.

Frontend Apps: Point your Guest Booking Portal POST request to the n8n /booking-request Webhook URL