-- 08_course_cohort_ranking.sql
-- purpose: rank every course/cohort combination that has run in the program 
-- by attendance rate, alongside its completion rate, to spot with specific 
-- offerings are underperforming and whether any course repeats near the bottom across mutiple cohorts.

WITH att AS (
	SELECT
		e.course_id,
        e.cohort_id,
        ROUND(100.0 * SUM(a.status IN ('present', 'Late'))
			/ COUNT(*), 1) AS attendance_rate
		FROM enrolments e 
        JOIN attendance a ON a.enrolment_id = e.enrolment_id
        WHERE a.status != 'NOT Recorded'
        GROUP BY e.course_id, e.cohort_id
        
),
comp AS (
	SELECT
    course_id,
    cohort_id,
    ROUND(100.0 * SUM(status = 'completed')
		/COUNT(*),1) AS completion_rate,
        COUNT(*) AS enrolled
	FROM enrolments 
    GROUP BY course_id, cohort_id
)
SELECT
	c.course_name,
    att.attendance_rate,
    comp.completion_rate,
    comp.enrolled
FROM att
JOIN comp
	ON att.course_id = comp.course_id
    AND att.cohort_id = comp.cohort_id
ORDER BY att.attendance_rate ASC;
