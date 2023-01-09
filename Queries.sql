--Query 1
SELECT total_month.month,
    e_month."Ensembles/month",
    gl_month."Group lessons/month",
    il_month."Individual lessons/month",
    total_month.total
   FROM total_month
     FULL JOIN il_month ON il_month.month = total_month.month
     FULL JOIN gl_month ON gl_month.month = total_month.month
     FULL JOIN e_month ON e_month.month = total_month.month
  WHERE EXTRACT(year FROM total_month.month) = 2023::numeric;

  --Query 2
   SELECT number_of_siblings.siblings AS "Number of siblings",
    count(number_of_siblings.siblings) AS count
   FROM number_of_siblings
  GROUP BY number_of_siblings.siblings
  ORDER BY number_of_siblings.siblings;

  --Query 3
   SELECT count(instructor_lesson_month.month) AS lessons
   FROM instructor_lesson_month
  WHERE instructor_lesson_month.month = EXTRACT(month FROM CURRENT_DATE)
  GROUP BY instructor_lesson_month.person_id
 HAVING count(instructor_lesson_month.month) > 5
  ORDER BY (count(instructor_lesson_month.month));

  --Query 4
   SELECT next_week_ensembles.id,
    next_week_ensembles.genre,
    next_week_ensembles.weekday,
        CASE
            WHEN (( SELECT seat_count.count
               FROM seat_count
              WHERE seat_count.id = next_week_ensembles.id)) < next_week_ensembles.max_students THEN next_week_ensembles.max_students - (( SELECT seat_count.count
               FROM seat_count
              WHERE seat_count.id = next_week_ensembles.id))
            ELSE 0::bigint
        END AS "seats available"
   FROM next_week_ensembles
  ORDER BY next_week_ensembles.genre, next_week_ensembles.weekday;