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


def num_bill(curs, tbl, typ=''):

    # typ is compose of BI PI UI SI default is blank for all bill.
    sql = "SELECT COUNT(*) FROM " + tbl + " WHERE no LIKE " + "'" + typ + "%'"
    curs.execute(sql)
    return curs.fetchone()


def pt_days(curs, tbl, typ):

    # patient days calculation by group
    sql = "SELECT SUM(ptdays) from " + tbl
    sql += " WHERE typ = " + "'" + typ + "'"
    sql += " group by typ"

    curs.execute(sql)
    return curs.fetchone()


def pt_no(curs, tbl, typ):

    # patient numbers calculation by group
    sql = "SELECT COUNT(an) from " + tbl
    sql += " WHERE typ = " + "'" + typ + "'"

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

    # Check type of bill

    # all bill
    tbl = 'ip_inv'
    bi_bill = num_bill(cur, tbl, 'BI')
    pi_bill = num_bill(cur, tbl, 'PI')
    ui_bill = num_bill(cur, tbl, 'UI')
    si_bill = num_bill(cur, tbl, 'SI')
    print("\n")
    print("Total BI        Bills are %8.0f" % bi_bill, "bills")
    print("Total PI        Bills are %8.0f" % pi_bill, "bills")
    print("Total UI        Bills are %8.0f" % ui_bill, "bills")
    print("Total SI        Bills are %8.0f" % si_bill, "bills")
    print("ALL             Bills are %8.0f" % (float(bi_bill[0])+
                                               float(pi_bill[0])+
                                               float(ui_bill[0])+
                                               float(si_bill[0])), "bills")

    # Details of BI Bill

    # Patient Days By Group
    tbl = 'ip'
    bi_days = pt_days(cur, tbl, 'BI')
    pi_days = pt_days(cur, tbl, 'PI')
    si_days = pt_days(cur, tbl, 'SI')
    ui_days = pt_days(cur, tbl, 'UI')
    print("\n")
    print("Total BI        Ptdays are %8.0f" % bi_days, "days")
    print("Total PI        Ptdays are %8.0f" % pi_days, "days")
    print("Total UI        Ptdays are %8.0f" % ui_days, "days")
    print("Total SI        Ptdays are %8.0f" % si_days, "days")
    print("ALL             Ptdays are %8.0f" % (float(bi_days[0]) +
                                               float(pi_days[0]) +
                                               float(ui_days[0]) +
                                               float(si_days[0])), "days")

    # Patient Number By Group
    tbl = 'ip'
    bi_no = pt_no(cur, tbl, 'BI')
    pi_no = pt_no(cur, tbl, 'PI')
    si_no = pt_no(cur, tbl, 'SI')
    ui_no = pt_no(cur, tbl, 'UI')
    print("\n")
    print("Total BI        Numbers are %8.0f" % bi_no, "persons")
    print("Total PI        Numbers are %8.0f" % pi_no, "persons")
    print("Total UI        Numbers are %8.0f" % ui_no, "persons")
    print("Total SI        Numbers are %8.0f" % si_no, "persons")
    print("ALL             Numbers are %8.0f" % (float(bi_no[0]) +
                                                float(pi_no[0]) +
                                                float(ui_no[0]) +
                                                float(si_no[0])), "persons")

    bi_alos = bi_days[0]/bi_no[0]
    pi_alos = pi_days[0]/pi_no[0]
    si_alos = si_days[0]/si_no[0]
    ui_alos = ui_days[0]/ui_no[0]
    print("\n")
    print("ALOS BI        are %8.0f" % bi_alos, "days")
    print("ALOS PI        are %8.0f" % pi_alos, "days")
    print("ALOS UI        are %8.0f" % ui_alos, "days")
    print("ALOS SI        are %8.0f" % si_alos, "days")

    con.close()

if __name__ == '__main__':
    main()


