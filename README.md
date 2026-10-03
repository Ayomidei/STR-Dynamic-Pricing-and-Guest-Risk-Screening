## 🚀 Local Setup & Environment Configuration

 **Clone the repository:**
   ```bash
   git clone [https://github.com/Ayomide/STR-Dynamic-Pricing-and-Guest-Risk-Screening.git](https://github.com/your-username/STR-Dynamic-Pricing-and-Guest-Risk-Screening.git)
   cd STR-Dynamic-Pricing-and-Guest-Risk-Screening

## Multi-Property Short-Term Rental Dynamic Pricing & Guest-Risk Screening Engine

An end-to-end backend ecosystem and property management suite built on **n8n**, **Airtable**, **AI Risk Engine (AI Agent Node)**, **Google Gemini AI**, and **Telegram Bot API**. The system automates market pricing ingestion, dynamic rate updates using bounded algorithm logic, unified code-driven guest risk evaluation, interactive owner escalations, and administrative dashboard management.


## Technical Stack

* **Database:** Airtable Base (Relational architecture across 7 core tables)
* **Automation Workflow:** n8n Engine (Modular and unified workflow execution)
* **Risk Screening Engine:** AI Agent Node (Deterministic rule evaluator & risk scoring engine)
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
│ • Firecrawl Web   │            │ • Multiplier     │            │ • AI Agent    │
│   Scraping        │            │   Logic (Comp,   │            │   Risk Node │
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



Key Features
Dynamic Booking Ingestion: Captures booking requests instantly via HTTP webhooks with automated schema normalization.

Context-Aware AI Screening: Utilizes a LangChain AI Agent paired with Google Gemini PaLM API to evaluate guest details, guest counts vs. property capacity, and rental purpose against house rules.

Stateful Session Memory: Incorporates a Simple Memory Buffer linked to the Property ID to preserve contextual state across evaluations.

Strict JSON Enforcement: Leverages a Structured Output Parser to guarantee deterministic output fields (risk_score, risk_level, risk_signals, ai_reasoning, recommendation).

Interactive Escalation & Wait Loops: Routes high-risk bookings through Telegram interactive inline cards (Send Message and Wait), pausing execution for up to 1 hour for manual owner review.

Automated Lifecycle Communications: Handles full guest communication lifecycle via Gmail templates for Instant Approval, Host Acceptance, Host Decline, and Request Expiration.

Auditable System Logs: Synchronizes state directly with an Airtable relational base (Properties, Bookings, and Owner Escalations).



Setup & Deployment
Prerequisites
n8n Instance: Self-hosted (Docker) or n8n Cloud.

Airtable Account: Personal Access Token (PAT) with read/write access to the project base.

API Credentials: Firecrawl API, SerpAPI, Google Gemini API, Telegram Bot Token.

Quick Start
Airtable: Create the 7 core tables and verify field names (Risk Score, Risk Level, Risk Signals, AI Reasoning).

n8n Workflows: Import the workflow JSON file into n8n. Verify the JavaScript Risk Analysis Engine Code Node outputs risk_level and risk_score.

Frontend Apps: Point your Guest Booking Portal POST request to the n8n /booking-request Webhook URL