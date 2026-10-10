-- ============================================================
-- SCHEMA: Rental Property Management Base
-- Base ID: YOUR_AIRTABLE_BASE_ID
-- Generated: 2026-10-03
-- ============================================================

-- ------------------------------------------------------------
-- TABLE: properties
-- ------------------------------------------------------------
CREATE TABLE properties (
    property_id         VARCHAR(50)     PRIMARY KEY,
    property_name       VARCHAR(255)    NOT NULL,
    location            VARCHAR(255),
    capacity            INTEGER,
    base_nightly_price  DECIMAL(10,2),
    min_price           DECIMAL(10,2),
    max_price           DECIMAL(10,2),
    current_price       DECIMAL(10,2),
    house_rules         TEXT,
    active_inactive     VARCHAR(20)     CHECK (active_inactive IN ('Active', 'Inactive')),
    notes               TEXT,
    date_added          TIMESTAMPTZ     DEFAULT NOW(),
    last_price_change   TIMESTAMPTZ,
    local_events        TEXT,
    competitor_market_url TEXT
);

-- ------------------------------------------------------------
-- TABLE: bookings
-- ------------------------------------------------------------
CREATE TABLE bookings (
    booking_id          SERIAL          PRIMARY KEY,
    guest_name          VARCHAR(255),
    guest_email         VARCHAR(255),
    rental_purpose      VARCHAR(255),
    guest_count         INTEGER,
    check_in            DATE,
    check_out           DATE,
    nights_count        INTEGER         GENERATED ALWAYS AS (check_out - check_in) STORED,
    risk_score          DECIMAL(5,2),
    risk_level          VARCHAR(20)     CHECK (risk_level IN ('Low', 'Medium', 'High', 'Critical')),
    risk_signals        TEXT,
    ai_reasoning        TEXT,
    booking_status      VARCHAR(30)     CHECK (booking_status IN ('Pending', 'Approved', 'Rejected', 'Cancelled', 'Expired')),
    submission_time     TIMESTAMPTZ     DEFAULT NOW(),
    review_deadline     TIMESTAMPTZ,
    is_expired          BOOLEAN         DEFAULT FALSE,
    property_id         VARCHAR(50)     REFERENCES properties(property_id)
);

-- ------------------------------------------------------------
-- TABLE: owner_escalations
-- ------------------------------------------------------------
CREATE TABLE owner_escalations (
    escalation_id       SERIAL          PRIMARY KEY,
    owner_action        VARCHAR(50)     CHECK (owner_action IN ('Approve', 'Reject', 'Request More Info', 'Escalate')),
    action_timestamp    TIMESTAMPTZ,
    response_time_sec   INTEGER,
    booking_id          INTEGER         REFERENCES bookings(booking_id)
);

-- ------------------------------------------------------------
-- TABLE: pricing_records
-- ------------------------------------------------------------
CREATE TABLE pricing_records (
    pricing_id          SERIAL          PRIMARY KEY,
    event_impact        VARCHAR(20)     CHECK (event_impact IN ('None', 'Low', 'Medium', 'High')),
    demand_level        VARCHAR(20)     CHECK (demand_level IN ('Low', 'Medium', 'High')),
    is_weekend          VARCHAR(10)     CHECK (is_weekend IN ('Yes', 'No')),
    recommended_price   DECIMAL(10,2),
    applied_price       DECIMAL(10,2),
    evaluated_at        TIMESTAMPTZ     DEFAULT NOW(),
    competitor_average  DECIMAL(10,2),
    property_id         VARCHAR(50)     REFERENCES properties(property_id)
);

-- ------------------------------------------------------------
-- TABLE: competitor_market_feeds
-- ------------------------------------------------------------
CREATE TABLE competitor_market_feeds (
    feed_id             SERIAL          PRIMARY KEY,
    competitor_name     VARCHAR(255),
    observed_nightly_rate DECIMAL(10,2),
    last_scraped_at     TIMESTAMPTZ,
    status              VARCHAR(20)     CHECK (status IN ('Active', 'Inactive', 'Error')),
    property_id         VARCHAR(50)     REFERENCES properties(property_id)
);

-- ------------------------------------------------------------
-- TABLE: local_events
-- ------------------------------------------------------------
CREATE TABLE local_events (
    event_id            SERIAL          PRIMARY KEY,
    location_zone       VARCHAR(255),
    impact_level        VARCHAR(20)     CHECK (impact_level IN ('Low', 'Medium', 'High')),
    notes               TEXT
);

-- Junction table: properties <-> local_events
CREATE TABLE property_local_events (
    property_id         VARCHAR(50)     REFERENCES properties(property_id),
    event_id            INTEGER         REFERENCES local_events(event_id),
    PRIMARY KEY (property_id, event_id)
);

-- ------------------------------------------------------------
-- TABLE: system_logs
-- ------------------------------------------------------------
CREATE TABLE system_logs (
    log_id              SERIAL          PRIMARY KEY,
    timestamp           TIMESTAMPTZ     DEFAULT NOW(),
    workflow_name       VARCHAR(255),
    failure_mode        VARCHAR(255),
    error_payload       TEXT,
    resolution_action   TEXT,
    is_resolved         VARCHAR(10)     CHECK (is_resolved IN ('Yes', 'No', 'In Progress')),
    error_severity_ai   TEXT,
    booking_id          INTEGER         REFERENCES bookings(booking_id)
);

-- ------------------------------------------------------------
-- INDEXES
-- ------------------------------------------------------------
CREATE INDEX idx_bookings_property         ON bookings(property_id);
CREATE INDEX idx_bookings_status           ON bookings(booking_status);
CREATE INDEX idx_bookings_risk_level       ON bookings(risk_level);
CREATE INDEX idx_pricing_records_property  ON pricing_records(property_id);
CREATE INDEX idx_competitor_feeds_property ON competitor_market_feeds(property_id);
CREATE INDEX idx_system_logs_booking       ON system_logs(booking_id);
CREATE INDEX idx_escalations_booking       ON owner_escalations(booking_id);