--Query 1
SELECT public.total_month.month,
    public.e_month."Ensembles/month",
    public.gl_month."Group lessons/month",
    public.il_month."Individual lessons/month",
    public.total_month.total
   FROM public.total_month
     FULL JOIN public.il_month ON public.il_month.month = public.total_month.month
     FULL JOIN public.gl_month ON public.gl_month.month = public.total_month.month
     FULL JOIN public.e_month ON public.e_month.month = public.total_month.month
  WHERE EXTRACT(year FROM public.total_month.month) = 2023::numeric;

  --Query 2
   SELECT public.number_of_siblings.siblings AS "Number of siblings",
    count(public.number_of_siblings.siblings) AS count
   FROM public.number_of_siblings
  GROUP BY public.number_of_siblings.siblings
  ORDER BY public.number_of_siblings.siblings;

  --Query 3
   SELECT count(public.instructor_lesson_month.month) AS lessons
   FROM public.instructor_lesson_month
  WHERE public.instructor_lesson_month.month = EXTRACT(month FROM CURRENT_DATE)
  GROUP BY public.instructor_lesson_month.person_id
 HAVING count(public.instructor_lesson_month.month) > 5
  ORDER BY (count(public.instructor_lesson_month.month));

  --Query 4
   SELECT public.next_week_ensembles.id,
    public.next_week_ensembles.genre,
    public.next_week_ensembles.weekday,
        CASE
            WHEN (( SELECT public.seat_count.count
               FROM public.seat_count
              WHERE public.seat_count.id = public.next_week_ensembles.id)) < public.next_week_ensembles.max_students THEN public.next_week_ensembles.max_students - (( SELECT public.seat_count.count
               FROM public.seat_count
              WHERE public.seat_count.id = public.next_week_ensembles.id))
            ELSE 0::bigint
        END AS "seats available"
   FROM public.next_week_ensembles
  ORDER BY public.next_week_ensembles.genre, public.next_week_ensembles.weekday;