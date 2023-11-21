WITH
  recency_and_frequency AS (
  SELECT
    Item_Name,
    SUM(Quantity_Sold__kilo_*Unit_Selling_Price__RMB_kg_) AS monetary,
    DATE_DIFF(CURRENT_DATE(), MAX(date), day) AS recency,
    COUNT(s.Item_Code) AS frequency
  FROM
    `redi-da-fall-2023.supermarket_redi.sales` s
  JOIN
    `redi-da-fall-2023.supermarket_redi.item_categories` ic
  ON
    s.Item_Code = ic.Item_Code
  GROUP BY
    1 ),
  rfm AS (
  SELECT
    APPROX_QUANTILES(recency, 100)[OFFSET(25)] AS percentile_25_recency,
    APPROX_QUANTILES(recency, 100)[OFFSET (50)] AS percentile_50_recency,
    APPROX_QUANTILES(recency, 100)[OFFSET(75)] AS percentile_75_recency,
    APPROX_QUANTILES(frequency, 100)[OFFSET(25)] AS percentile_25_frequency,
    APPROX_QUANTILES(frequency, 100)[OFFSET(50)] AS percentile_50_frequency,
    APPROX_QUANTILES(frequency, 100)[OFFSET(75)] AS percentile_75_frequency,
    APPROX_QUANTILES(monetary, 100)[OFFSET(25)] AS percentile_25_monetary,
    APPROX_QUANTILES(monetary, 100)[OFFSET(50)] AS percentile_50_monetary,
    APPROX_QUANTILES(monetary, 100)[OFFSET(75)] AS percentile_75_monetary
  FROM
    recency_and_frequency )
SELECT
  item_name,
  monetary,
  CASE
    WHEN monetary <= percentile_25_monetary THEN 'group 1'
    WHEN monetary <= percentile_50_monetary THEN 'group 2'
    WHEN monetary <= percentile_75_monetary THEN 'group 3'
  ELSE
  'group 4'
END
  AS M,
  percentile_25_monetary,
  percentile_50_monetary,
  percentile_75_monetary
FROM
  recency_and_frequency
CROSS JOIN
  rfm