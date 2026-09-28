-- 02_attendance_by_day_of_week
-- purpose: find which day of the week has the weakest
-- attendance, across every course and cohort in the program 

SELECT 
	DAYNAME(session_date) day_of_week,
    100*SUM(status IN ('present', 'Late'))/ COUNT(*) attendance_rate
FROM attendance
WHERE status != 'Not recorded'
GROUP BY DAYNAME(session_date)
ORDER BY attendance_rate;

-- Results: friday is weakest at 53.5%, monday strongestat 63.2%

-- attendance by Day_of_weak in each cohort
WITH cohort_attendance AS(
	SELECT 
		DAYNAME(a.session_date) Day_of_weak,
		c.cohort_label,
		100 * SUM(a.status IN ('present', 'Late'))/ COUNT(*) attendance_rate
		
	FROM attendance a 
	JOIN enrolments e ON a.enrolment_id = e.enrolment_id
	JOIN cohorts c ON e.cohort_id = c.cohort_id
	WHERE a.status != 'Not recorded'
	GROUP BY c.cohort_label, DAYNAME(a.session_date)
)

SELECT cohort_label, Day_of_weak, attendance_rate,
	RANK() OVER(PARTITION BY cohort_label ORDER BY attendance_rate) AS rank_
FROM cohort_attendance;

