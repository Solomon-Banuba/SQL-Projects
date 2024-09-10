 -- Platform Booking Analysis Using SQL
/*
Background: SB Service is a company that provides a platform for people seeking handymen services.

Purpose: The management wants to understand the performance of booking behavior of customers over time. 

DOD: Provide analysis of the respective business questions and visualize results where necessary. 

*/

-------------------------------------------------------------------------------------------------------------------

-- TASK #1: What is the number of registered users by country?

SELECT
      u.country_code,
      Count(u.user_id) registered_users
FROM users u
GROUP BY u.country_code
ORDER BY 2 DESC;

-------------------------------------------------------------------------------------------------------------------

-- TASK #2: What is the percentage of users who made their first payment 3 days after registration by country?

SELECT
     uu.country_code,
     Count(DISTINCT uu.user_id) registered_users,
     Count(DISTINCT x.user_id) first_3_days_payment,
     (Cast(Count(DISTINCT x.user_id)  AS REAL)  / Count(DISTINCT uu.user_id)) * 100  percentage
FROM users uu
LEFT JOIN
     (SELECT
            u.user_id,
            Julianday(u.joined_at) joined_at,
            Julianday(p.created_at) created_at,
            Rank() OVER (partition BY u.user_id ORDER BY Julianday(p.created_at) ASC) AS payment_rank
FROM users u
    JOIN payments p ON u.user_id = p.user_id
    WHERE Julianday(p.created_at) >= Julianday(u.joined_at)
)x
  ON uu.user_id = x.user_id AND x.created_at - x.joined_at  <= 3 AND payment_rank = 1
GROUP BY uu.country_code;

-------------------------------------------------------------------------------------------------------------------


 -- TASK #3: What is the percentage of users who made more than 1 executed booking?

 SELECT
 	Count(u.user_id) registered_users,
 	Count(x.user_id) users_with_executed_bookings,
      Round(Cast(Count(x.user_id) AS REAL) / Count(u.user_id) * 100, 1) percentage_of_users
FROM
 users u
LEFT JOIN
 (SELECT
 b.user_id,
    Count(b.id) executed_bookings
FROM
 bookings b
WHERE b.status = "executed"
GROUP BY b.user_id
HAVING executed_bookings > 1
 )x
    ON x.user_id = u.user_id;

-------------------------------------------------------------------------------------------------------------------

-- Task #4: What is the Weekly Cancellation Rate?

SELECT
    Strftime('%Y-%W', a.starttime) year_week,
    Count(a.id) all_bookings,
    Count(b.id) cancelled_bookings,
    Round((Cast(Count(b.id) AS REAL) / Count(a.id)) * 100, 1) cancellation_rate
FROM bookings a
LEFT JOIN bookings b ON b.id = a.id AND b.status = "cancelled"
GROUP BY year_week
ORDER BY 1 ASC;

-------------------------------------------------------------------------------------------------------------------

-- Task #5: Describe booking Behaviour per year (any trends?)

SELECT
      b.status,
      COUNT(status) AS count_of_status,
      strftime('%Y', starttime) AS Year_
FROM bookings b
GROUP BY status, Year_
ORDER BY 3 ASC;

------------------------------------------------------------------------------------------------------------------------------

/*
See here: https://medium.com/@solomonbanuba/sql-use-case-in-business-intelligence-data-analysis-be9f74815519
For detailed explanation of project, query and Power BI visualizations 
*/
