-- Import data to pt
COPY pt FROM '/Volumes/Macintosh HD/Users/sksy/git/PyPym/Data/pt60.csv'
 DELIMITER ',' CSV HEADER;

-- Import Data to IP Invoices

COPY ip_inv FROM '/Volumes/Macintosh HD/Users/sksy/git/PyPym/Data/IPinv.csv'
 DELIMITER ',' CSV HEADER;

COPY ip_inv FROM '/Volumes/Macintosh HD/Users/sksy/git/PyPym/Data/IP_INV-02-2017.csv'
 DELIMITER ',' CSV HEADER;

﻿-----------------------------------------------
-- Methodology in patient days calculation
-- 1. List customer AN by type of bills and group by bill type
-- 2. Cut BI customer that duplicate with PI, SI and UI
-- 3. Cut PI customer that duplicate with SI, UI
-- 4. Calculate patient days by type of patients
-----------------------------------------------
DROP TABLE IF EXISTS ip;

-- 1. List customer AN by type of bills group by bill type.
create table ip as
 select substring(no,1,2) as typ, an,sum(to_date(dcg, 'DD/MM/YYYY HH24:MI') -
                                        to_date(adm, 'DD/MM/YYYY HH24:MI')) as ptdays
  from ip_inv
   where extract(month from to_date(dte, 'DD/MM/YYYY HH24:MI')) = 1
    group by typ, an
     order by an;

-- 2. Cut BI customer that duplicate with PI, SI and UI
delete from ip
 where an in (select i1.an
               from ip i1
                inner join ip i2 on i1.an = i2.an
               where i1.typ = 'BI' and i2.typ in ('PI', 'SI', 'UI'))
   and typ = 'BI';

-- 3. Cut PI customer that duplicate with SI, UI
delete from ip
 where an in (select i1.an
               from ip i1
                inner join ip i2 on i1.an = i2.an
               where i1.typ = 'PI' and i2.typ in ('SI', 'UI'))
   and typ = 'PI';