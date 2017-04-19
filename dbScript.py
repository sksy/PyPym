# /usr/bin/python3
# Date first created: 2017-04-04
# Create By Sk
# dbScript.py

import psycopg2
import sys


def connect(db, usr, pwd):

    try:
        con = psycopg2.connect(database=db, user=usr, password=pwd)
        return con
    except psycopg2.DatabaseError as e:
            print('Error', e)
            sys.exit(1)


def female_ratio(curs, tbl):

    fn = 0.0
    n = 0.0
    ans = 0.0

    curs.execute("SELECT COUNT(*) FROM " + tbl + " WHERE sex LIKE 'หญิง%' ")
    fn = curs.fetchone()

    curs.execute("SELECT COUNT(*) FROM " + tbl)
    n = curs.fetchone()

    ans = int(fn[0]/n[0]*100)
    return ans


def no_by_age_group(curs, i, tbl):
    """ Group customer by age group
    # 0 - 15(2017 - 2002)  = 1
    # 16 - 30(2001 - 1987) = 2
    # 31 - 60(1986 - 1957) = 3
    # 61 + 1956            = 4
    """

    sql = "select count(pn) from " + tbl + " where right(bth_dte, 4)::int between "

    if i == 1:
        sql += '2002 AND 2017'
    elif i == 2:
        sql += '1987 AND 2001'
    elif i == 3:
        sql += '1957  AND 1986'
    elif i == 4:
        sql += '1915 AND 1956'

    curs.execute(sql)
    return curs.fetchone()


def main():

    con = connect('piyamin', 'postgres', 'postgres')
    cur = con.cursor()

    # Calculate Part

    # find the ratio of gender's customer percentage.
    pct_fmale = female_ratio(cur, 'pt')
    pct_male = 100 - pct_fmale

    # find number of customer by age group.
    i = 0
    age_grp = [1,2,3,4]

    # Print Result

    for i in range(4):
        age_grp[i] = no_by_age_group(cur,i+1, 'pt')

    #
    # Patient Characteristics
    #

    print("Female Percentage is   %8.0f" % pct_fmale, "%")
    print("So Male Percentage is  %8.0f" % pct_male, "%")
    print("Age between  0-15 years is     %8.0f" % age_grp[0], " persons")
    print("Age between 16-30 years is     %8.0f" % age_grp[1], " persons")
    print("Age between 31-60 years is     %8.0f" % age_grp[2], " persons")
    print("Age between   61+ years is     %8.0f"  % age_grp[3], "persons")
    # TODO Group the address and caddress by province, district, road
    # TODO find the number of first visit group by month.
    # TODO Services used statistics

    con.close()

if __name__ == '__main__':
    main()


