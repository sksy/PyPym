with iv as
 (select b.BillID,b.CalculationID,b.CalcInsuranceID,b.ReceiptNo,
   case when substring(b.ReceiptNo,2,1) = 'I' then 'IPD' else 'OPD' end as OI,
   b.CreateDateTime,ci.InsuranceName,
   case when LEFT(b.ReceiptNo,1) = 'U' then '7.)UC'
        when LEFT(b.ReceiptNo,1) = 'S' then '6.)ปกส.'
        when LEFT(b.ReceiptNo,1) = 'B' then '1.)เงินสด'
        when ci.InsuranceTypeCodeID = 2 then '2.)พ.ร.บ.'
        when ci.InsuranceTypeCodeID = 3 then '5.)กองทุน'
        when ci.InsuranceTypeCodeID = 4 then '3.)ประกัน'
        when ci.InsuranceTypeCodeID = 5 then '4.)คู่สัญญา'
    else '6.)ปกส.'
   end as flagInsurance,
    inc.I1,inc.I2,inc.I3,inc.I4,inc.I5,inc.I6,inc.I7,inc.I8,inc.I9,inc.I10,
    inc.I11,inc.I12,inc.I13,inc.I14,inc.I15,inc.I16,inc.I17,inc.I18,inc.I19,inc.I20,
    inc.I21,inc.Amount,inc.Discount,inc.NetAmount,inc.costDrug,inc.coststaff,
    inc.costlab,inc.costxray,inc.costphysical
   from CALC.dbo.Bills b
         inner join (select ci.CalcInsuranceID,ci.InsuranceTypeCodeID,ci.InsuranceName
                      from CALC.dbo.CalcInsurances ci
                       where ci.IsDelete = 0) ci
                        on ci.CalcInsuranceID = b.CalcInsuranceID
         inner join CALC.dbo.Calculations c
          on c.CalculationID = b.CalculationID
           and c.IsDelete = 0
         inner join (select b.BillID,
                      sum(case when bg.Itemgroup = 1 and isnull(co.o,0) = 0
                       then isnull(cc.Coverage,bd.Account) else 0 end) as I1,
                      sum(case when bg.Itemgroup = 2 and isnull(co.o,0) = 0
                       then isnull(cc.Coverage,bd.Account) else 0 end) as I2,
                      sum(case when bg.Itemgroup = 3 and isnull(co.o,0) = 0
                       then isnull(cc.Coverage,bd.Account) else 0 end) as I3,
                      sum(case when bg.Itemgroup = 4 and isnull(co.o,0) = 0
                       then isnull(cc.Coverage,bd.Account) else 0 end) as I4,
                      sum(case when bg.Itemgroup = 5 and isnull(co.o,0) = 0
                       then isnull(cc.Coverage,bd.Account) else 0 end) as I5,
                      sum(case when bg.Itemgroup = 6 and isnull(co.o,0) = 0
                       then isnull(cc.Coverage,bd.Account) else 0 end) as I6,
                      sum(case when bg.Itemgroup = 7 and isnull(co.o,0) = 0
                       then isnull(cc.Coverage,bd.Account) else 0 end) as I7,
                      sum(case when bg.Itemgroup = 8 and isnull(co.o,0) = 0
                       then isnull(cc.Coverage,bd.Account) else 0 end) as I8,
                      sum(case when isnull(co.o,0) = 1
                       then isnull(cc.Coverage,bd.Account) else 0 end) as I9,
                      sum(case when bg.Itemgroup = 10 and isnull(co.o,0) = 0
                       then isnull(cc.Coverage,bd.Account) else 0 end) as I10,
                      sum(case when bg.Itemgroup = 11 and isnull(co.o,0) = 0
                       then isnull(cc.Coverage,bd.Account) else 0 end) as I11,
                      sum(case when bg.Itemgroup = 12 and isnull(co.o,0) = 0
                       then isnull(cc.Coverage,bd.Account) else 0 end) as I12,
                      sum(case when bg.Itemgroup = 13 and isnull(co.o,0) = 0
                       then isnull(cc.Coverage,bd.Account) else 0 end) as I13,
                      sum(case when bg.Itemgroup = 14 and isnull(co.o,0) = 0
                       then isnull(cc.Coverage,bd.Account) else 0 end) as I14,
                      sum(case when bg.Itemgroup = 15 and isnull(co.o,0) = 0
                       then isnull(cc.Coverage,bd.Account) else 0 end) as I15,
                      sum(case when bg.Itemgroup = 16 and isnull(co.o,0) = 0
                       then isnull(cc.Coverage,bd.Account) else 0 end) as I16,
                      sum(case when bg.Itemgroup = 17 and isnull(co.o,0) = 0
                       then isnull(cc.Coverage,bd.Account) else 0 end) as I17,
                      sum(case when bg.Itemgroup = 18 and isnull(co.o,0) = 0
                       then isnull(cc.Coverage,bd.Account) else 0 end) as I18,
                      sum(case when bg.Itemgroup = 19 and isnull(co.o,0) = 0
                       then isnull(cc.Coverage,bd.Account) else 0 end) as I19,
                      sum(case when bg.Itemgroup = 20 and isnull(co.o,0) = 0
                       then isnull(cc.Coverage,bd.Account) else 0 end) as I20,
                      sum(case when isnull(bg.Itemgroup,0) = 0
                       then isnull(cc.Coverage,bd.Account) else 0 end) as I21,
                      SUM(isnull(cc.Coverage,bd.Account))as Amount,
                      SUM(isnull(cc.Discount,0))as Discount,
                      SUM(isnull(cc.Coverage,bd.Account) - isnull(cc.Discount,0))as NetAmount,
                      sum(case when co.OrderCategoryCodeId = 1
                       then co.cost else 0 end) as costDrug,
                      sum(case when co.OrderCategoryCodeId = 3
                       then co.cost else 0 end) as costStaff,
                      sum(case when co.OrderCategoryCodeId = 4
                       then co.cost else 0 end) as costLab,
                      sum(case when co.OrderCategoryCodeId = 5
                       then co.cost else 0 end) as costXray,
                      sum(case when co.OrderCategoryCodeId = 6
                       then co.cost else 0 end) as costPhysical
                from CALC.dbo.Bills b
                      inner join CALC.dbo.BillDetails bd on bd.BillID = b.BillID
                      left join CALC.dbo.BillDetailOrders bdo
                       on bdo.BillDetailID = bd.BillDetailID
                      left join (select co.CalcOrderID,
                                  case when co.OrderID IN (329,330,793,823,824,7194,
                                                           7195,7196,7197,7198,10794,
                                                           10795,10796)
                                   then 1 else 0 end as o,
                                  o.OrderCategoryCodeId,co.Quantity * isnull(cs.Cost,0)as cost
                                 from CALC.dbo.CalcOrders co
                                  inner join MAIN.dbo.Orders o on o.OrderId = co.OrderID
                                  left join PYM_REPORTS.dbo.MROrderCost cs
                                   on cs.OrderCode = o.OrderCode
                                    and cs.OrderCategoryCodeId = o.OrderCategoryCodeId
                                 where co.IsDelete = 0) co
                                   on co.CalcOrderID = bdo.CalcOrderID
                                  left join CALC.dbo.CalcInsuranceCoverages cc
                                    on cc.CalcInsuranceID = b.CalcInsuranceID
                                     and cc.CalcOrderID = co.CalcOrderID
                                  left join PYM_REPORTS.dbo.BillDetailItemGroup bg
                                   on bg.ItemID = bd.ItemID
                group by b.BillID) inc
                 on inc.BillID = b.BillID
      where year(b.CreateDateTime) = @YR
       and MONTH(b.CreateDateTime) = @MT
       and b.ReceiptTypeCodeID in(1,2)
       and b.IsDelete = 0
       and b.IsCancel = 0
       and b.IsRefund = 0)
select v.flagInsurance,v.OI,sum(v.I1) as room,sum(v.I2) as food,
 sum(v.I3) as drgIpd,sum(v.I4) as drgOpd,sum(v.I5) as HomeMed,
 sum(v.I6) as Staff,sum(v.I7) as Lab,sum(v.I8) as Xray,
 sum(v.I20) as Blood,sum(v.I9) as Oxygen,sum(v.I10) as HardDoctor,
 sum(v.I11) as HospitalCharge,sum(v.I12) as NuseService,sum(v.I13) as Den,
 sum(V.I14) as Phy,sum(v.I15) as Acu,sum(v.I16) as ORroom,sum(v.I17) as DF,
 sum(v.I19) as Anaes,sum(v.I18) as OtherService,sum(v.I21) as Other,
 sum(v.Amount) as Price,sum(v.Discount)as Discount,sum(v.NetAmount) as NetAmount,
 sum(v.costDrug)as costDrug,sum(v.coststaff)as coststaff,sum(v.costlab)as costlab,
 sum(v.costxray)as costxray,sum(v.costphysical)as costphysical
from iv v
 group by v.flagInsurance,v.OI
  order by v.flagInsurance,v.OI

----
  -- Drug use in UC with tablet category
----------------------------------------------
with orderDrg as(
select dg.RegistrationID,dg.MRMainID,dg.PatientID,
       dg.VN,dg.RegistrationDateTime,dg.DepartmentName,dg.DoctorName,
       pdg.OrderCode,pdg.OrderName,pdg.OneTimeDose,pdg.TimesADay,
       pdg.DayDose,pdg.Qty,CEILING(pdg.Qty / NULLIF(pdg.DayDose,0))as sumDay,
       pdg.Unit,
       case when CEILING(pdg.Qty / NULLIF(pdg.DayDose,0)) between 0 and 30 then 1
            when CEILING(pdg.Qty / NULLIF(pdg.DayDose,0)) between 31 and 60 then 2
            when CEILING(pdg.Qty / NULLIF(pdg.DayDose,0)) between 61 and 90 then 3
       else 4 end as DrugM
 from
  (select r.RegistrationID,r.PatientID,m.MRMainID,r.VN,r.RegistrationDateTime,
          ms.DepartmentName,ms.DoctorName
    from MAIN.dbo.Registrations r
          inner join MAIN.dbo.MRMain m
             on m.RegistrationID = r.RegistrationID
             and m.IsDelete = 0 and r.IsDelete = 0 and m.IsOutPatient = 1
            inner join MAIN.dbo.RegistrationInsurances rgi
             on rgi.RegistrationID = r.RegistrationID and r.IsDelete = 0
inner join MAIN.dbo.RegistrationInsuranceSocialSecurity rss on rss.RegistrationID = r.RegistrationID
inner join MAIN.dbo.SSInsuranceTypeCodes stc on stc.SSinsuranceTypeCodeID = rss.SSInsuranceTypeCodeID
inner join
(select ms.MRMainID,d.DepartmentName,u.UserName as DoctorName
from MAIN.dbo.MRs ms
inner join MAIN.dbo.Departments d on d.DepartmentID = ms.DepartmentID
inner join MAIN.dbo.UserInfos u on u.UserInfoID = ms.DoctorUserInfoID
where ms.IsDelete = 0
)ms on ms.MRMainID = m.MRMainID
where r.RegistrationDateTime between @dat1 and @dat2 + ' 23:59:59.997'
and stc.SSinsuranceTypeID in (2) and rgi.InsuranceTypeCodeID = 1)as dg
inner join
(
select pd.MRMainID
,o.OrderCode,o.OrderName
,case when pd.OneTimeDose = 0 then 1 else pd.OneTimeDose end as OneTimeDose,pd.TimesADay
,case when pd.OneTimeDose = 0 then pd.TimesADay else (pd.OneTimeDose * pd.TimesADay) end as DayDose,pd.Consumption as Qty
,o.Unit
from MAIN.dbo.PharmacyDispensationOrders pd
inner join MAIN.dbo.Orders o on o.OrderId = pd.OrderID
where pd.PharmacyDispensationResultCodeID IN (1, 3, 4)
and pd.PharmacyDispensationSatusCodeID IN (2, 3)
and o.OrderCategoryCodeId = 1 and o.OrderCode like 'DT%'
)pdg on pdg.MRMainID = dg.MRMainID
)
select od.RegistrationID
,od.RegistrationDateTime,od.VN,p.PN,p.Prefix + p.FullName as FullName
,dbo.GetRegistrationInsuranceName(od.RegistrationID) as InsuranceName
,od.DepartmentName,od.DoctorName
,icd.diag1,icd.diag2,icd.diag3,icd.diag4
,od.OrderCode
,od.OrderName
,od.OneTimeDose,od.TimesADay,od.DayDose,od.Qty,od.sumDay
,od.Unit
from orderDrg od
inner join MAIN.dbo.Patients p on p.PatientID = od.PatientID
left join
(
SELECT MRMainID
 ,[1] as diag1 , [2] as diag2 , [3] as diag3 , [4] as diag4 , [5] as diag5
 ,[6] as diag6 , [7] as diag7 , [8] as diag8 , [9] as diag9 , [10] as diag10

FROM
(select
m.MRMainID,md.DiseaseStandardCode
,ROW_NUMBER() OVER(PARTITION BY m.MRMainID ORDER BY md.MRDiseaseID) AS LineNumber
from MAIN.dbo.MRDiseases md
inner join MAIN.dbo.MRs ms on ms.MRID = md.MRID and ms.IsDelete = 0
inner join MAIN.dbo.MRMain m on m.MRMainID = ms.MRMainID and m.IsDelete = 0
where md.IsDelete = 0) AS SourceTable
Pivot (max(DiseaseStandardCode) for LineNumber In ([1], [2], [3],[4],[5],[6],[7],[8],[9],[10])) As pvt
)icd on icd.MRMainID = od.MRMainID
where od.DrugM = @DrugM
order by od.RegistrationID

-- UC Services Used
with gp as(
select
r.RegistrationDateTime,r.RegistrationID,m.PatientID,ms.DepartmentID,d.DepartmentName,
case when r.SymptomsMemo is null OR r.SymptomsMemo = '' then '' else SUBSTRING(r.SymptomsMemo,1,charindex('[',r.SymptomsMemo)-1) end as Memo,
case when app1.RegisterDate is null then 0 else 1 end as statAppointment,appM.CountApp
from MAIN.dbo.MRMain m
inner join MAIN.dbo.Registrations r on r.RegistrationID = m.RegistrationID
inner join MAIN.dbo.MRs ms on ms.MRMainID = m.MRMainID and ms.IsDelete = 0
inner join MAIN.dbo.Departments d on d.DepartmentID = ms.DepartmentID
left join
(
select
pa.PatientId,cast(a.RegisterDate as Date) as RegisterDate
from VW_PatientApps pa
inner join Appointments a on a.AppId = pa.AppId
group by pa.PatientId,cast(a.RegisterDate as Date)
)app1 on app1.PatientId = r.PatientID and cast(app1.RegisterDate as Date) = cast(r.RegistrationDateTime as Date)

left join
(select pa.DepartmentId,cast(a.Start as Date)as DateApp,COUNT(a.AppId)as CountApp
from VW_PatientApps pa inner join Appointments a on a.AppId = pa.AppId
where pa.DepartmentId in(131,155,161,170,171,172,173,175,176,177,178,179,180,184,185,196,197,200,201,202,203,204)
group by pa.DepartmentId,cast(a.Start as Date)
)appM on appM.DepartmentId = ms.DepartmentID and appM.DateApp = cast(r.RegistrationDateTime as Date)

where m.IsDelete = 0
and m.IsOutPatient = 1
and m.IsExtraRegistration = 0
and YEAR(m.CreateDateTime)= @YR and MONTH(m.CreateDateTime)=  @MT
and ms.DepartmentID in(131,155,161,170,171,172,173,175,176,177,178,179,180,184,185,196,197,200,201,202,203,204)
)
select
g.DepartmentID,g.DepartmentName
----1----
,(select CountApp from gp where DepartmentID = g.DepartmentID and DAY(RegistrationDateTime) = 1 group by CountApp) as SumApp1
,sum(case when DAY(g.RegistrationDateTime)= 1 then 1 else 0 end) as visit1
,sum(case when DAY(g.RegistrationDateTime) = 1 and g.statAppointment = 1 then 1 else 0 end) as TrueApp1
,sum(case when DAY(g.RegistrationDateTime) = 1 and g.statAppointment = 0 and g.Memo like '%นัด%' then 1 else 0 end) as FalseApp1
,sum(case when DAY(g.RegistrationDateTime) = 1 and g.statAppointment = 0 and g.Memo not like '%นัด%' then 1 else 0 end) as WalkIn1
----2----
,(select CountApp from gp where DepartmentID = g.DepartmentID and DAY(RegistrationDateTime) = 2 group by CountApp) as SumApp2
,sum(case when DAY(g.RegistrationDateTime)= 2 then 1 else 0 end) as visit2
,sum(case when DAY(g.RegistrationDateTime) = 2 and g.statAppointment = 1 then 1 else 0 end) as TrueApp2
,sum(case when DAY(g.RegistrationDateTime) = 2 and g.statAppointment = 0 and g.Memo like '%นัด%' then 1 else 0 end) as FalseApp2
,sum(case when DAY(g.RegistrationDateTime) = 2 and g.statAppointment = 0 and g.Memo not like '%นัด%' then 1 else 0 end) as WalkIn2
----3----
,(select CountApp from gp where DepartmentID = g.DepartmentID and DAY(RegistrationDateTime) = 3 group by CountApp) as SumApp3
,sum(case when DAY(g.RegistrationDateTime)= 3 then 1 else 0 end) as visit3
,sum(case when DAY(g.RegistrationDateTime) = 3 and g.statAppointment = 1 then 1 else 0 end) as TrueApp3
,sum(case when DAY(g.RegistrationDateTime) = 3 and g.statAppointment = 0 and g.Memo like '%นัด%' then 1 else 0 end) as FalseApp3
,sum(case when DAY(g.RegistrationDateTime) = 3 and g.statAppointment = 0 and g.Memo not like '%นัด%' then 1 else 0 end) as WalkIn3
----4----
,(select CountApp from gp where DepartmentID = g.DepartmentID and DAY(RegistrationDateTime) = 4 group by CountApp) as SumApp4
,sum(case when DAY(g.RegistrationDateTime)= 4 then 1 else 0 end) as visit4
,sum(case when DAY(g.RegistrationDateTime) = 4 and g.statAppointment = 1 then 1 else 0 end) as TrueApp4
,sum(case when DAY(g.RegistrationDateTime) = 4 and g.statAppointment = 0 and g.Memo like '%นัด%' then 1 else 0 end) as FalseApp4
,sum(case when DAY(g.RegistrationDateTime) = 4 and g.statAppointment = 0 and g.Memo not like '%นัด%' then 1 else 0 end) as WalkIn4
----5----
,(select CountApp from gp where DepartmentID = g.DepartmentID and DAY(RegistrationDateTime) = 5 group by CountApp) as SumApp5
,sum(case when DAY(g.RegistrationDateTime)= 5 then 1 else 0 end) as visit5
,sum(case when DAY(g.RegistrationDateTime) = 5 and g.statAppointment = 1 then 1 else 0 end) as TrueApp5
,sum(case when DAY(g.RegistrationDateTime) = 5 and g.statAppointment = 0 and g.Memo like '%นัด%' then 1 else 0 end) as FalseApp5
,sum(case when DAY(g.RegistrationDateTime) = 5 and g.statAppointment = 0 and g.Memo not like '%นัด%' then 1 else 0 end) as WalkIn5
------------------------------------------------------------------------------------------------------------------------------------------
----6----
,(select CountApp from gp where DepartmentID = g.DepartmentID and DAY(RegistrationDateTime) = 6 group by CountApp) as SumApp6
,sum(case when DAY(g.RegistrationDateTime)= 6 then 1 else 0 end) as visit6
,sum(case when DAY(g.RegistrationDateTime) = 6 and g.statAppointment = 1 then 1 else 0 end) as TrueApp6
,sum(case when DAY(g.RegistrationDateTime) = 6 and g.statAppointment = 0 and g.Memo like '%นัด%' then 1 else 0 end) as FalseApp6
,sum(case when DAY(g.RegistrationDateTime) = 6 and g.statAppointment = 0 and g.Memo not like '%นัด%' then 1 else 0 end) as WalkIn6
----7----
,(select CountApp from gp where DepartmentID = g.DepartmentID and DAY(RegistrationDateTime) = 7 group by CountApp) as SumApp7
,sum(case when DAY(g.RegistrationDateTime)= 7 then 1 else 0 end) as visit7
,sum(case when DAY(g.RegistrationDateTime) = 7 and g.statAppointment = 1 then 1 else 0 end) as TrueApp7
,sum(case when DAY(g.RegistrationDateTime) = 7 and g.statAppointment = 0 and g.Memo like '%นัด%' then 1 else 0 end) as FalseApp7
,sum(case when DAY(g.RegistrationDateTime) = 7 and g.statAppointment = 0 and g.Memo not like '%นัด%' then 1 else 0 end) as WalkIn7
----8----
,(select CountApp from gp where DepartmentID = g.DepartmentID and DAY(RegistrationDateTime) = 8 group by CountApp) as SumApp8
,sum(case when DAY(g.RegistrationDateTime)= 8 then 1 else 0 end) as visit8
,sum(case when DAY(g.RegistrationDateTime) = 8 and g.statAppointment = 1 then 1 else 0 end) as TrueApp8
,sum(case when DAY(g.RegistrationDateTime) = 8 and g.statAppointment = 0 and g.Memo like '%นัด%' then 1 else 0 end) as FalseApp8
,sum(case when DAY(g.RegistrationDateTime) = 8 and g.statAppointment = 0 and g.Memo not like '%นัด%' then 1 else 0 end) as WalkIn8
----9----
,(select CountApp from gp where DepartmentID = g.DepartmentID and DAY(RegistrationDateTime) = 9 group by CountApp) as SumApp9
,sum(case when DAY(g.RegistrationDateTime)= 9 then 1 else 0 end) as visit9
,sum(case when DAY(g.RegistrationDateTime) = 9 and g.statAppointment = 1 then 1 else 0 end) as TrueApp9
,sum(case when DAY(g.RegistrationDateTime) = 9 and g.statAppointment = 0 and g.Memo like '%นัด%' then 1 else 0 end) as FalseApp9
,sum(case when DAY(g.RegistrationDateTime) = 9 and g.statAppointment = 0 and g.Memo not like '%นัด%' then 1 else 0 end) as WalkIn9
----10----
,(select CountApp from gp where DepartmentID = g.DepartmentID and DAY(RegistrationDateTime) = 10 group by CountApp) as SumApp10
,sum(case when DAY(g.RegistrationDateTime)= 10 then 1 else 0 end) as visit10
,sum(case when DAY(g.RegistrationDateTime) = 10 and g.statAppointment = 1 then 1 else 0 end) as TrueApp10
,sum(case when DAY(g.RegistrationDateTime) = 10 and g.statAppointment = 0 and g.Memo like '%นัด%' then 1 else 0 end) as FalseApp10
,sum(case when DAY(g.RegistrationDateTime) = 10 and g.statAppointment = 0 and g.Memo not like '%นัด%' then 1 else 0 end) as WalkIn10
--------------------------------------------------------------------------------------------------------------------------------------
----11----
,(select CountApp from gp where DepartmentID = g.DepartmentID and DAY(RegistrationDateTime) = 11 group by CountApp) as SumApp11
,sum(case when DAY(g.RegistrationDateTime)= 11 then 1 else 0 end) as visit11
,sum(case when DAY(g.RegistrationDateTime) = 11 and g.statAppointment = 1 then 1 else 0 end) as TrueApp11
,sum(case when DAY(g.RegistrationDateTime) = 11 and g.statAppointment = 0 and g.Memo like '%นัด%' then 1 else 0 end) as FalseApp11
,sum(case when DAY(g.RegistrationDateTime) = 11 and g.statAppointment = 0 and g.Memo not like '%นัด%' then 1 else 0 end) as WalkIn11
----12----
,(select CountApp from gp where DepartmentID = g.DepartmentID and DAY(RegistrationDateTime) = 12 group by CountApp) as SumApp12
,sum(case when DAY(g.RegistrationDateTime)= 12 then 1 else 0 end) as visit12
,sum(case when DAY(g.RegistrationDateTime) = 12 and g.statAppointment = 1 then 1 else 0 end) as TrueApp12
,sum(case when DAY(g.RegistrationDateTime) = 12 and g.statAppointment = 0 and g.Memo like '%นัด%' then 1 else 0 end) as FalseApp12
,sum(case when DAY(g.RegistrationDateTime) = 12 and g.statAppointment = 0 and g.Memo not like '%นัด%' then 1 else 0 end) as WalkIn12
----13----
,(select CountApp from gp where DepartmentID = g.DepartmentID and DAY(RegistrationDateTime) = 13 group by CountApp) as SumApp13
,sum(case when DAY(g.RegistrationDateTime)= 13 then 1 else 0 end) as visit13
,sum(case when DAY(g.RegistrationDateTime) = 13 and g.statAppointment = 1 then 1 else 0 end) as TrueApp13
,sum(case when DAY(g.RegistrationDateTime) = 13 and g.statAppointment = 0 and g.Memo like '%นัด%' then 1 else 0 end) as FalseApp13
,sum(case when DAY(g.RegistrationDateTime) = 13 and g.statAppointment = 0 and g.Memo not like '%นัด%' then 1 else 0 end) as WalkIn13
----14----
,(select CountApp from gp where DepartmentID = g.DepartmentID and DAY(RegistrationDateTime) = 14 group by CountApp) as SumApp14
,sum(case when DAY(g.RegistrationDateTime)= 14 then 1 else 0 end) as visit14
,sum(case when DAY(g.RegistrationDateTime) = 14 and g.statAppointment = 1 then 1 else 0 end) as TrueApp14
,sum(case when DAY(g.RegistrationDateTime) = 14 and g.statAppointment = 0 and g.Memo like '%นัด%' then 1 else 0 end) as FalseApp14
,sum(case when DAY(g.RegistrationDateTime) = 14 and g.statAppointment = 0 and g.Memo not like '%นัด%' then 1 else 0 end) as WalkIn14
----15----
,(select CountApp from gp where DepartmentID = g.DepartmentID and DAY(RegistrationDateTime) = 15 group by CountApp) as SumApp15
,sum(case when DAY(g.RegistrationDateTime)= 15 then 1 else 0 end) as visit15
,sum(case when DAY(g.RegistrationDateTime) = 15 and g.statAppointment = 1 then 1 else 0 end) as TrueApp15
,sum(case when DAY(g.RegistrationDateTime) = 15 and g.statAppointment = 0 and g.Memo like '%นัด%' then 1 else 0 end) as FalseApp15
,sum(case when DAY(g.RegistrationDateTime) = 15 and g.statAppointment = 0 and g.Memo not like '%นัด%' then 1 else 0 end) as WalkIn15
----------------------------------------------------------------------------------------------------------------------------------------
----16----
,(select CountApp from gp where DepartmentID = g.DepartmentID and DAY(RegistrationDateTime) = 16 group by CountApp) as SumApp16
,sum(case when DAY(g.RegistrationDateTime)= 16 then 1 else 0 end) as visit16
,sum(case when DAY(g.RegistrationDateTime) = 16 and g.statAppointment = 1 then 1 else 0 end) as TrueApp16
,sum(case when DAY(g.RegistrationDateTime) = 16 and g.statAppointment = 0 and g.Memo like '%นัด%' then 1 else 0 end) as FalseApp16
,sum(case when DAY(g.RegistrationDateTime) = 16 and g.statAppointment = 0 and g.Memo not like '%นัด%' then 1 else 0 end) as WalkIn16
----17----
,(select CountApp from gp where DepartmentID = g.DepartmentID and DAY(RegistrationDateTime) = 17 group by CountApp) as SumApp17
,sum(case when DAY(g.RegistrationDateTime)= 17 then 1 else 0 end) as visit17
,sum(case when DAY(g.RegistrationDateTime) = 17 and g.statAppointment = 1 then 1 else 0 end) as TrueApp17
,sum(case when DAY(g.RegistrationDateTime) = 17 and g.statAppointment = 0 and g.Memo like '%นัด%' then 1 else 0 end) as FalseApp17
,sum(case when DAY(g.RegistrationDateTime) = 17 and g.statAppointment = 0 and g.Memo not like '%นัด%' then 1 else 0 end) as WalkIn17
----18----
,(select CountApp from gp where DepartmentID = g.DepartmentID and DAY(RegistrationDateTime) = 18 group by CountApp) as SumApp18
,sum(case when DAY(g.RegistrationDateTime)= 18 then 1 else 0 end) as visit18
,sum(case when DAY(g.RegistrationDateTime) = 18 and g.statAppointment = 1 then 1 else 0 end) as TrueApp18
,sum(case when DAY(g.RegistrationDateTime) = 18 and g.statAppointment = 0 and g.Memo like '%นัด%' then 1 else 0 end) as FalseApp18
,sum(case when DAY(g.RegistrationDateTime) = 18 and g.statAppointment = 0 and g.Memo not like '%นัด%' then 1 else 0 end) as WalkIn18
----19----
,(select CountApp from gp where DepartmentID = g.DepartmentID and DAY(RegistrationDateTime) = 19 group by CountApp) as SumApp19
,sum(case when DAY(g.RegistrationDateTime)= 19 then 1 else 0 end) as visit19
,sum(case when DAY(g.RegistrationDateTime) = 19 and g.statAppointment = 1 then 1 else 0 end) as TrueApp19
,sum(case when DAY(g.RegistrationDateTime) = 19 and g.statAppointment = 0 and g.Memo like '%นัด%' then 1 else 0 end) as FalseApp19
,sum(case when DAY(g.RegistrationDateTime) = 19 and g.statAppointment = 0 and g.Memo not like '%นัด%' then 1 else 0 end) as WalkIn19
----20----
,(select CountApp from gp where DepartmentID = g.DepartmentID and DAY(RegistrationDateTime) = 20 group by CountApp) as SumApp20
,sum(case when DAY(g.RegistrationDateTime)= 20 then 1 else 0 end) as visit20
,sum(case when DAY(g.RegistrationDateTime) = 20 and g.statAppointment = 1 then 1 else 0 end) as TrueApp20
,sum(case when DAY(g.RegistrationDateTime) = 20 and g.statAppointment = 0 and g.Memo like '%นัด%' then 1 else 0 end) as FalseApp20
,sum(case when DAY(g.RegistrationDateTime) = 20 and g.statAppointment = 0 and g.Memo not like '%นัด%' then 1 else 0 end) as WalkIn20
----------------------------------------------------------------------------------------------------------------------------------------
----21----
,(select CountApp from gp where DepartmentID = g.DepartmentID and DAY(RegistrationDateTime) = 21 group by CountApp) as SumApp21
,sum(case when DAY(g.RegistrationDateTime)= 21 then 1 else 0 end) as visit21
,sum(case when DAY(g.RegistrationDateTime) = 21 and g.statAppointment = 1 then 1 else 0 end) as TrueApp21
,sum(case when DAY(g.RegistrationDateTime) = 21 and g.statAppointment = 0 and g.Memo like '%นัด%' then 1 else 0 end) as FalseApp21
,sum(case when DAY(g.RegistrationDateTime) = 21 and g.statAppointment = 0 and g.Memo not like '%นัด%' then 1 else 0 end) as WalkIn21
----22----
,(select CountApp from gp where DepartmentID = g.DepartmentID and DAY(RegistrationDateTime) = 22 group by CountApp) as SumApp22
,sum(case when DAY(g.RegistrationDateTime)= 22 then 1 else 0 end) as visit22
,sum(case when DAY(g.RegistrationDateTime) = 22 and g.statAppointment = 1 then 1 else 0 end) as TrueApp22
,sum(case when DAY(g.RegistrationDateTime) = 22 and g.statAppointment = 0 and g.Memo like '%นัด%' then 1 else 0 end) as FalseApp22
,sum(case when DAY(g.RegistrationDateTime) = 22 and g.statAppointment = 0 and g.Memo not like '%นัด%' then 1 else 0 end) as WalkIn22
----23----
,(select CountApp from gp where DepartmentID = g.DepartmentID and DAY(RegistrationDateTime) = 23 group by CountApp) as SumApp23
,sum(case when DAY(g.RegistrationDateTime)= 23 then 1 else 0 end) as visit23
,sum(case when DAY(g.RegistrationDateTime) = 23 and g.statAppointment = 1 then 1 else 0 end) as TrueApp23
,sum(case when DAY(g.RegistrationDateTime) = 23 and g.statAppointment = 0 and g.Memo like '%นัด%' then 1 else 0 end) as FalseApp23
,sum(case when DAY(g.RegistrationDateTime) = 23 and g.statAppointment = 0 and g.Memo not like '%นัด%' then 1 else 0 end) as WalkIn23
----24----
,(select CountApp from gp where DepartmentID = g.DepartmentID and DAY(RegistrationDateTime) = 24 group by CountApp) as SumApp24
,sum(case when DAY(g.RegistrationDateTime)= 24 then 1 else 0 end) as visit24
,sum(case when DAY(g.RegistrationDateTime) = 24 and g.statAppointment = 1 then 1 else 0 end) as TrueApp24
,sum(case when DAY(g.RegistrationDateTime) = 24 and g.statAppointment = 0 and g.Memo like '%นัด%' then 1 else 0 end) as FalseApp24
,sum(case when DAY(g.RegistrationDateTime) = 24 and g.statAppointment = 0 and g.Memo not like '%นัด%' then 1 else 0 end) as WalkIn24
----25----
,(select CountApp from gp where DepartmentID = g.DepartmentID and DAY(RegistrationDateTime) = 25 group by CountApp) as SumApp25
,sum(case when DAY(g.RegistrationDateTime)= 25 then 1 else 0 end) as visit25
,sum(case when DAY(g.RegistrationDateTime) = 25 and g.statAppointment = 1 then 1 else 0 end) as TrueApp25
,sum(case when DAY(g.RegistrationDateTime) = 25 and g.statAppointment = 0 and g.Memo like '%นัด%' then 1 else 0 end) as FalseApp25
,sum(case when DAY(g.RegistrationDateTime) = 25 and g.statAppointment = 0 and g.Memo not like '%นัด%' then 1 else 0 end) as WalkIn25
-----------------------------------------------------------------------------------------------------------------------------------------
----26----
,(select CountApp from gp where DepartmentID = g.DepartmentID and DAY(RegistrationDateTime) = 26 group by CountApp) as SumApp26
,sum(case when DAY(g.RegistrationDateTime)= 26 then 1 else 0 end) as visit26
,sum(case when DAY(g.RegistrationDateTime) = 26 and g.statAppointment = 1 then 1 else 0 end) as TrueApp26
,sum(case when DAY(g.RegistrationDateTime) = 26 and g.statAppointment = 0 and g.Memo like '%นัด%' then 1 else 0 end) as FalseApp26
,sum(case when DAY(g.RegistrationDateTime) = 26 and g.statAppointment = 0 and g.Memo not like '%นัด%' then 1 else 0 end) as WalkIn26
----27----
,(select CountApp from gp where DepartmentID = g.DepartmentID and DAY(RegistrationDateTime) = 27 group by CountApp) as SumApp27
,sum(case when DAY(g.RegistrationDateTime)= 27 then 1 else 0 end) as visit27
,sum(case when DAY(g.RegistrationDateTime) = 27 and g.statAppointment = 1 then 1 else 0 end) as TrueApp27
,sum(case when DAY(g.RegistrationDateTime) = 27 and g.statAppointment = 0 and g.Memo like '%นัด%' then 1 else 0 end) as FalseApp27
,sum(case when DAY(g.RegistrationDateTime) = 27 and g.statAppointment = 0 and g.Memo not like '%นัด%' then 1 else 0 end) as WalkIn27
----28----
,(select CountApp from gp where DepartmentID = g.DepartmentID and DAY(RegistrationDateTime) = 28 group by CountApp) as SumApp28
,sum(case when DAY(g.RegistrationDateTime)= 28 then 1 else 0 end) as visit28
,sum(case when DAY(g.RegistrationDateTime) = 28 and g.statAppointment = 1 then 1 else 0 end) as TrueApp28
,sum(case when DAY(g.RegistrationDateTime) = 28 and g.statAppointment = 0 and g.Memo like '%นัด%' then 1 else 0 end) as FalseApp28
,sum(case when DAY(g.RegistrationDateTime) = 28 and g.statAppointment = 0 and g.Memo not like '%นัด%' then 1 else 0 end) as WalkIn28
----29----
,(select CountApp from gp where DepartmentID = g.DepartmentID and DAY(RegistrationDateTime) = 29 group by CountApp) as SumApp29
,sum(case when DAY(g.RegistrationDateTime)= 29 then 1 else 0 end) as visit29
,sum(case when DAY(g.RegistrationDateTime) = 29 and g.statAppointment = 1 then 1 else 0 end) as TrueApp29
,sum(case when DAY(g.RegistrationDateTime) = 29 and g.statAppointment = 0 and g.Memo like '%นัด%' then 1 else 0 end) as FalseApp29
,sum(case when DAY(g.RegistrationDateTime) = 29 and g.statAppointment = 0 and g.Memo not like '%นัด%' then 1 else 0 end) as WalkIn29
----30----
,(select CountApp from gp where DepartmentID = g.DepartmentID and DAY(RegistrationDateTime) = 30 group by CountApp) as SumApp30
,sum(case when DAY(g.RegistrationDateTime)= 30 then 1 else 0 end) as visit30
,sum(case when DAY(g.RegistrationDateTime) = 30 and g.statAppointment = 1 then 1 else 0 end) as TrueApp30
,sum(case when DAY(g.RegistrationDateTime) = 30 and g.statAppointment = 0 and g.Memo like '%นัด%' then 1 else 0 end) as FalseApp30
,sum(case when DAY(g.RegistrationDateTime) = 30 and g.statAppointment = 0 and g.Memo not like '%นัด%' then 1 else 0 end) as WalkIn30
------------------------------------------------------------------------------------------------------------------------------------------
----31----
,(select CountApp from gp where DepartmentID = g.DepartmentID and DAY(RegistrationDateTime) = 31 group by CountApp) as SumApp31
,sum(case when DAY(g.RegistrationDateTime)= 31 then 1 else 0 end) as visit31
,sum(case when DAY(g.RegistrationDateTime) = 31 and g.statAppointment = 1 then 1 else 0 end) as TrueApp31
,sum(case when DAY(g.RegistrationDateTime) = 31 and g.statAppointment = 0 and g.Memo like '%นัด%' then 1 else 0 end) as FalseApp31
,sum(case when DAY(g.RegistrationDateTime) = 31 and g.statAppointment = 0 and g.Memo not like '%นัด%' then 1 else 0 end) as WalkIn31
from gp g
group by g.DepartmentID,g.DepartmentName
order by g.DepartmentName