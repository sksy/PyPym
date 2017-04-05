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


def c_newpt_2017(cnt, cursor):

    try:
        cursor.execute("CREATE TABLE NewPt2017( NO varchar(50), \
                            PN varchar(50) PRIMARY KEY, ID varchar(50), \
                            Fname varchar(100), Name varchar(255), \
                            Sname varchar(255), sex varchar(50), \
                            BthDte varchar(255), TelNo varchar(50), \
                            Address varchar(255), Cadd varchar(255), \
                            FV varchar(50) )")
        cnt.commit()
    except psycopg2.DatabaseError as e:
        print('Error', e)
        if cnt:
            cnt.rollback()
        sys.exit(1)


def import_data(src, tgt, cnt, curs):

    try:
        curs.execute("COPY " + tgt + " FROM '/Volumes/Macintosh HD/Users/sksy/git/PyPym/Data/" \
                     + src + ".csv'" + " DELIMITER ',' CSV HEADER")
        cnt.commit()
    except psycopg2.DatabaseError as e:
        print('Error', e)
        if cnt:
            cnt.rollback()
        sys.exit(1)


def m_sex_ratio(curs, tbl):

    fn = 0.0
    n = 0.0
    ans = 0.0

    curs.execute("SELECT COUNT(*) FROM " + tbl + " GROUP BY sex")
    fn = curs.fetchone()

    curs.execute("SELECT COUNT(*) FROM " + tbl)
    n = curs.fetchone()

    ans = int(fn[0]/n[0]*100)
    return ans

def int_db(cnt, curs):

     # create and import data from csv file
     c_newpt_2017(cnt, curs)
     import_data('NewPt-2017', 'newpt2017', cnt, curs)

def gender_ratio(curs, x='f'):

    # Find the ratio of girl and boy
    if x == 'f':
        return m_sex_ratio(curs, 'newpt2017')
    else:
        return 100 - m_sex_ratio(curs, 'newpt2017')


def no_by_age_group(curs, i):
    """ Group customer by age group
    # 0 - 15(2017 - 2002)  = 1
    # 16 - 30(2001 - 1987) = 2
    # 31 - 60(1986 - 1957) = 3
    # 61 + 1956            = 4
    """

    sql = "select count(pn) from newpt2017 where right(bthdte, 4)::int between "

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

    # Initialize data
    # int_db()

    # find the ratio of gender's customer percentage.
    pct_fmale = gender_ratio(cur)
    pct_male = gender_ratio(cur, 'm')

    # find number of customer by age group.
    i = 0
    age_grp = [1,2,3,4]

    for i in range(4):
        age_grp[i] = no_by_age_group(cur,i+1)
        print(age_grp[i])

    # TODO Group the address and caddress by province, district, road
    # TODO find the number of first visit group by month.
    con.close()

if __name__ == '__main__':
    main()


