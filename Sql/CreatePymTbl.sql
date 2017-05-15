-- Customer Database
CREATE TABLE pt      ( seq varchar(50),pn varchar(100) PRIMARY KEY,
                        id varchar(50), fnme varchar(100),
                        nme varchar(255), snme varchar(255),
                        sex varchar(50), bth_dte varchar(255),
                        tel varchar(50), addr varchar(255),
                        c_addr varchar(255), fv_dte varchar(50)
                      );

-- IP Invoices
CREATE TABLE ip_inv ( seq varchar(50), no varchar(50) PRIMARY KEY,
                     dte varchar(100), adm varchar(100),
                     dcg varchar(100), flg varchar(50),
                     an varchar(50), pn varchar(50),
                     nme varchar(255), flgI varchar(50),
                     i_com varchar(255), t1 varchar(50),
                     t2 varchar(50), t3 varchar(50), t4 varchar(50),
                     t5 varchar(50), t6 varchar(50), t7 varchar(50),
                     diag1 varchar(50), diag2 varchar(50),
                     diag3 varchar(50), diag4 varchar(50),
                     diag5 varchar(50), diag6 varchar(50),
                     diag7 varchar(50), diag8 varchar(50),
                     room varchar(50), food varchar(50),
                     dg_ip varchar(50), dg_op varchar(50),
                     dg_hme varchar(50), dg_cst varchar(50),
                     stf varchar(50), stf_cst varchar(50),
                     lab varchar(50), lab_cst varchar(50),
                     xry varchar(50), xry_cst varchar(50),
                     blood varchar(50), o2 varchar(50),
                     df_prc varchar(50), hsp_chg varchar(50),
                     srv_nur varchar(50), dent varchar(50),
                     phy varchar(50), icu varchar(50),
                     room_or varchar(50), df varchar(50),
                     df_anaes varchar(50), srv_oth varchar(50),
                     oths varchar(50), prc varchar(50),
                     dsc varchar(50), net varchar(50)
                    );

-- CHAD Cashier std file details
create table chad (hn varchar(15), dateserve date, seq text,
	               clinic varchar(15), itemtype varchar(15),
	               	itemcode varchar(15), itemsrc varchar(15),
	               	qty varchar(15), amount varchar(15),
	               	amount_ext varchar(15), provider varchar(255));

-- cha
create table  cha (hn varchar(15), dateopd date,
	               chrgitem,amount, amount_extDATEOPD	CHRGITEM	AMOUNT	AMOUNT_EXT	PERSON_ID	SEQ