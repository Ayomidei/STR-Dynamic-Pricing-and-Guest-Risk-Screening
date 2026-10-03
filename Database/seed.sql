-- ============================================================
-- SEED DATA: Rental Property Management Base
-- Generated: 2026-10-03
-- ============================================================

-- ------------------------------------------------------------
-- PROPERTIES
-- ------------------------------------------------------------
INSERT INTO properties (property_id, property_name, location, capacity, base_nightly_price, min_price, max_price, current_price, house_rules, active_inactive, notes, competitor_market_url) VALUES
('P-1001', 'Seaside Escape',   'Malibu, CA',       8,  850.00, 700.00,  1200.00, 935.00,  'No parties. No pets. Quiet hours after 10pm.',  'Active',   'Oceanfront, includes pool access.',  'https://www.airbnb.com/s/Malibu--California--United-States/homes'),
('P-1002', 'Urban Loft',       'Brooklyn, NY',     4,  300.00, 250.00,   400.00, 330.00,  'No smoking. No loud music.',                    'Active',   'Close to subway, modern decor.',     'https://www.airbnb.com/s/Brooklyn--New-York--United-States/homes'),
('P-1003', 'Mountain Retreat', 'Aspen, CO',       10, 1200.00,1000.00,  1800.00,1320.00,  'No pets. No outdoor fires.',                    'Active',   'Ski-in/ski-out, hot tub included.',  'https://www.airbnb.com/s/Aspen--Colorado--United-States/homes'),
('P-1004', 'Desert Villa',     'Scottsdale, AZ',   6,  600.00, 500.00,   900.00, 660.00,  'No glass by the pool. No smoking.',             'Inactive', 'Recently renovated kitchen.',        'https://www.airbnb.com/s/Scottsdale--Arizona--United-States/homes'),
('P-1005', 'Lakeview Cabin',   'Lake Tahoe, NV',   5,  400.00, 350.00,   600.00, 400.00,  'No parties. No outside guests.',               'Active',   'Private dock, canoe available.',     'https://www.airbnb.com/s/Lake-Tahoe/homes');

-- ------------------------------------------------------------
-- LOCAL EVENTS
-- ------------------------------------------------------------
INSERT INTO local_events (location_zone, impact_level, notes) VALUES
('Malibu, CA',      'High',   'Summer beach festival drawing large crowds to the area.'),
('Brooklyn, NY',    'Medium', 'Annual food and culture street fair in Williamsburg.'),
('Aspen, CO',       'High',   'Winter ski season peak — major influx of tourists.'),
('Scottsdale, AZ',  'Medium', 'Spring training baseball season; hotels fill up fast.'),
('Lake Tahoe, NV',  'Low',    'Off-season; moderate visitor traffic expected.');

INSERT INTO property_local_events (property_id, event_id) VALUES
('P-1001', 1), ('P-1002', 2), ('P-1003', 3), ('P-1004', 4), ('P-1005', 5);

-- ------------------------------------------------------------
-- COMPETITOR MARKET FEEDS
-- ------------------------------------------------------------
INSERT INTO competitor_market_feeds (competitor_name, observed_nightly_rate, last_scraped_at, status, property_id) VALUES
('Airbnb Malibu Comp A',      920.00, '2026-10-03 08:00:00+00', 'Active',   'P-1001'),
('Airbnb Malibu Comp B',      870.00, '2026-10-03 08:00:00+00', 'Active',   'P-1001'),
('Airbnb Brooklyn Comp A',    310.00, '2026-10-03 08:05:00+00', 'Active',   'P-1002'),
('Airbnb Brooklyn Comp B',    290.00, '2026-10-03 08:05:00+00', 'Active',   'P-1002'),
('Airbnb Aspen Comp A',      1350.00, '2026-10-03 08:10:00+00', 'Active',   'P-1003'),
('Airbnb Aspen Comp B',      1280.00, '2026-10-03 08:10:00+00', 'Active',   'P-1003'),
('Airbnb Scottsdale Comp A',  640.00, '2026-10-03 08:15:00+00', 'Active',   'P-1004'),
('Airbnb Scottsdale Comp B',  580.00, '2026-10-03 08:15:00+00', 'Inactive', 'P-1004'),
('Airbnb Tahoe Comp A',       390.00, '2026-10-03 08:20:00+00', 'Active',   'P-1005'),
('Airbnb Tahoe Comp B',       410.00, '2026-10-03 08:20:00+00', 'Active',   'P-1005');

-- ------------------------------------------------------------
-- PRICING RECORDS
-- ------------------------------------------------------------
INSERT INTO pricing_records (event_impact, demand_level, is_weekend, recommended_price, applied_price, competitor_average, property_id) VALUES
('High',   'High',   'Yes',  980.00,  935.00,  895.00,  'P-1001'),
('Low',    'Medium', 'No',   870.00,  850.00,  870.00,  'P-1001'),
('Medium', 'Medium', 'Yes',  340.00,  330.00,  300.00,  'P-1002'),
('None',   'Low',    'No',   270.00,  250.00,  290.00,  'P-1002'),
('High',   'High',   'Yes', 1400.00, 1320.00, 1315.00,  'P-1003'),
('Medium', 'Medium', 'No',  1100.00, 1050.00, 1280.00,  'P-1003'),
('Low',    'Medium', 'Yes',  680.00,  660.00,  610.00,  'P-1004'),
('None',   'Low',    'No',   530.00,  500.00,  580.00,  'P-1004'),
('Low',    'Low',    'Yes',  420.00,  400.00,  400.00,  'P-1005'),
('None',   'Low',    'No',   370.00,  350.00,  390.00,  'P-1005');

-- ------------------------------------------------------------
-- BOOKINGS
-- ------------------------------------------------------------
INSERT INTO bookings (guest_name, guest_email, rental_purpose, guest_count, check_in, check_out, risk_score, risk_level, risk_signals, ai_reasoning, booking_status, property_id) VALUES
('James Carter',  'james.carter@email.com',  'Family vacation',     8, '2026-11-01', '2026-11-08', 12, 'Low',      'No signals detected.',                           'Guest profile consistent with family travelers. Low risk.',          'Approved', 'P-1001'),
('Priya Nair',    'priya.nair@email.com',    'Business retreat',    4, '2026-11-15', '2026-11-18', 35, 'Medium',   'Unusual check-in time. Short notice booking.',   'Some flags raised; recommend owner review.',                         'Pending',  'P-1002'),
('Derek Owens',   'derek.owens@email.com',   'Birthday party',     10, '2026-12-20', '2026-12-27', 78, 'High',     'Party declared. Large group. Last-minute.',      'High-risk booking flagged for immediate owner escalation.',          'Pending',  'P-1003'),
('Sofia Reyes',   'sofia.reyes@email.com',   'Couples getaway',     2, '2026-10-10', '2026-10-14',  8, 'Low',      'No signals detected.',                           'Straightforward low-risk booking.',                                 'Approved', 'P-1004'),
('Marcus Webb',   'marcus.webb@email.com',   'Fishing trip',        5, '2026-10-20', '2026-10-25', 20, 'Low',      'Minor: no prior booking history.',               'New guest but purpose is benign. Approve with note.',               'Approved', 'P-1005'),
('Anika Singh',   'anika.singh@email.com',   'Corporate offsite',   6, '2026-11-05', '2026-11-07', 45, 'Medium',   'Corporate; guest count near capacity.',           'Moderate risk. Owner should confirm corporate use policy.',          'Pending',  'P-1001'),
('Tom Bradley',   'tom.bradley@email.com',   'Weekend getaway',     3, '2026-10-24', '2026-10-26',  5, 'Low',      'No signals detected.',                           'Clean profile and straightforward request.',                        'Approved', 'P-1002'),
('Layla Hassan',  'layla.hassan@email.com',  'Bachelorette party',  8, '2026-11-28', '2026-11-30', 82, 'Critical', 'Party declared. Alcohol mention. Max capacity.', 'Critical risk. Recommend rejection or strict deposit requirement.',  'Rejected', 'P-1003'),
('Noah Kim',      'noah.kim@email.com',      'Ski vacation',        4, '2026-12-15', '2026-12-22', 15, 'Low',      'No signals detected.',                           'Typical ski season booking. Approve.',                              'Approved', 'P-1003'),
('Elena Torres',  'elena.torres@email.com',  'Remote work retreat', 2, '2026-10-08', '2026-10-15', 10, 'Low',      'No signals detected.',                           'Solo/couple remote work stay. Very low risk.',                      'Approved', 'P-1005');

-- ------------------------------------------------------------
-- OWNER ESCALATIONS
-- ------------------------------------------------------------
INSERT INTO owner_escalations (owner_action, action_timestamp, response_time_sec, booking_id) VALUES
('Reject',            '2026-10-03 10:15:00+00', 3240, 8),
('Request More Info', '2026-10-03 09:45:00+00', 1800, 3),
('Approve',           '2026-10-03 11:00:00+00', 2700, 2),
('Approve',           '2026-10-03 12:30:00+00', 5400, 6);

-- ------------------------------------------------------------
-- SYSTEM LOGS
-- ------------------------------------------------------------
INSERT INTO system_logs (workflow_name, failure_mode, error_payload, resolution_action, is_resolved, error_severity_ai, booking_id) VALUES
('Risk Score Automation',  NULL,                     NULL,                                               NULL,                                'Yes',         'N/A - No error',                    1),
('Risk Score Automation',  'API Timeout',            '{"error":"upstream_timeout","retry":true}',        'Retried after 30s. Resolved.',      'Yes',         'Low - transient network issue',     3),
('Price Sync Workflow',    'Invalid Field Mapping',  '{"field":"applied_price","error":"null_value"}',   'Mapping corrected in automation.',  'Yes',         'Medium - data integrity risk',      NULL),
('Escalation Notifier',    'Email Delivery Failure', '{"smtp_error":"550 recipient rejected"}',          'Updated owner email on file.',      'Yes',         'Medium - notification gap',         8),
('Booking Expiry Check',   NULL,                     NULL,                                               NULL,                                'Yes',         'N/A - No error',                    NULL),
('Competitor Feed Scrape', 'Rate Limit Hit',         '{"provider":"airbnb","retry_after":3600}',         'Scheduled retry queued for 1hr.',   'In Progress', 'Low - expected rate limit behavior',NULL);