-- Group customer by age group
-- 0 - 15 ( 2017 - 2002)
select count(pn) from pt
 where right(bth_dte,4)::int between 2002 and 2017;
-- 16 - 30 ( 2001 - 1987 )
select count(pn) from pt
 where right(bth_dte, 4)::int between 1987 AND 2001;
 - 31 - 60 ( 1986 - 1957 )
select count(pn) from pt
 where right(bth_dte, 4)::int between 1957 AND 1986;
 - 61+ 1956
select count(pn) from pt
 where right(bth_dte, 4)::int between 1915 AND 1956;

select count(*) from pt where sex::text like 'หญิง%';
