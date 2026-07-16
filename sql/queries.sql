-- Swiggy Instamart — Delivery Time Analysis
-- Run these in your SQL client after loading the CSV into a table.
-- Table assumed: instamart_orders

-- ── 1. Overall average delivery time (baseline vs. current) ──────────────────
SELECT
    store_type,
    COUNT(*)                                               AS total_orders,
    ROUND(AVG(
        EXTRACT(EPOCH FROM (delivered_ts - pick_start_ts)) / 60
    ), 2)                                                  AS avg_total_min,
    ROUND(AVG(
        EXTRACT(EPOCH FROM (pack_end_ts - pick_start_ts)) / 60
    ), 2)                                                  AS avg_pick_min,
    ROUND(AVG(
        EXTRACT(EPOCH FROM (dispatch_ts - pack_end_ts)) / 60
    ), 2)                                                  AS avg_pack_min,
    ROUND(AVG(
        EXTRACT(EPOCH FROM (delivered_ts - dispatch_ts)) / 60
    ), 2)                                                  AS avg_lastmile_min
FROM instamart_orders
GROUP BY store_type
ORDER BY store_type;

-- ── 2. Breakdown by city and store type ─────────────────────────────────────
SELECT
    city,
    store_type,
    COUNT(*)                                               AS orders,
    ROUND(AVG(
        EXTRACT(EPOCH FROM (delivered_ts - pick_start_ts)) / 60
    ), 2)                                                  AS avg_total_min
FROM instamart_orders
GROUP BY city, store_type
ORDER BY city, store_type;

-- ── 3. Which phase regressed the most? (new vs. existing, all cities) ────────
SELECT
    store_type,
    ROUND(AVG(EXTRACT(EPOCH FROM (pack_end_ts  - pick_start_ts)) / 60), 2) AS pick_min,
    ROUND(AVG(EXTRACT(EPOCH FROM (dispatch_ts  - pack_end_ts))   / 60), 2) AS pack_min,
    ROUND(AVG(EXTRACT(EPOCH FROM (delivered_ts - dispatch_ts))   / 60), 2) AS lastmile_min
FROM instamart_orders
GROUP BY store_type;

-- ── 4. Rider efficiency — average deliveries per rider by store type ─────────
SELECT
    store_type,
    rider_id,
    COUNT(*)                                               AS deliveries,
    ROUND(AVG(
        EXTRACT(EPOCH FROM (delivered_ts - dispatch_ts)) / 60
    ), 2)                                                  AS avg_lastmile_min
FROM instamart_orders
GROUP BY store_type, rider_id
ORDER BY avg_lastmile_min DESC
LIMIT 20;

-- ── 5. Distance vs. last-mile time correlation ───────────────────────────────
SELECT
    ROUND(distance_km::numeric, 0)                         AS distance_bucket_km,
    COUNT(*)                                               AS orders,
    ROUND(AVG(
        EXTRACT(EPOCH FROM (delivered_ts - dispatch_ts)) / 60
    ), 2)                                                  AS avg_lastmile_min
FROM instamart_orders
GROUP BY distance_bucket_km
ORDER BY distance_bucket_km;
