SELECT * 
FROM page_visits
LIMIT 10;

SELECT COUNT(DISTINCT utm_campaign) AS 'Number of Campaigns'
FROM page_visits;

SELECT COUNT(DISTINCT utm_source) AS 'Number of Sources'
FROM page_visits;

SELECT  DISTINCT utm_campaign AS 'Campaign',utm_source AS 'Source'
FROM page_visits 
ORDER BY 2;

SELECT DISTINCT page_name
FROM page_visits;

WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id)
SELECT DISTINCT pv.utm_source,
        pv.utm_campaign,
        COUNT(*)
FROM first_touch ft
JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
    GROUP BY 2
    ORDER BY 3 DESC;
   
WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    GROUP BY user_id)
SELECT pv.utm_source,
        pv.utm_campaign,
        COUNT(*)
FROM last_touch lt
JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
    GROUP BY 2
    ORDER BY 3 DESC;

SELECT COUNT(*) AS 'Purchases'
FROM page_visits
WHERE page_name = '4 - purchase';

WITH last_touch AS (
	SELECT user_id,
        MAX(timestamp) AS last_touch_at
  	FROM page_visits
  	WHERE page_name = '4 - purchase'
  	GROUP BY user_id)
SELECT pv.utm_source,
		pv.utm_campaign,
    COUNT(*)
FROM last_touch lt
JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
    GROUP BY 2
    ORDER BY 3 DESC;

WITH fpv AS (
	SELECT page_name,
  		utm_campaign,
		COUNT(*) AS 'total_pv'
	FROM page_visits
	WHERE page_name like '1%'
  	GROUP BY 2),
spv AS (
	SELECT page_name,
  		utm_campaign,
		COUNT(*) AS 'total_pv'
	FROM page_visits
	WHERE page_name like '2%'	
	GROUP BY 2),
tpv AS (
	SELECT page_name,
        utm_campaign,
		COUNT(*) AS 'total_pv'
	FROM page_visits
	WHERE page_name like '3%'
	GROUP BY 2),
fopv AS (
    SELECT page_name,
        utm_campaign,
        COUNT(*) AS 'total_pv'
	FROM page_visits
	WHERE page_name like '4%'
	GROUP BY 2)
SELECT page_name,
    utm_campaign,
    MAX(total_pv)
FROM fpv
UNION
SELECT page_name,
	utm_campaign,
	MAX(total_pv)
FROM spv
UNION
SELECT page_name,
	utm_campaign,
	MAX(total_pv)
FROM tpv
UNION
SELECT page_name,
	utm_campaign,
	MAX(total_pv)
FROM fopv;