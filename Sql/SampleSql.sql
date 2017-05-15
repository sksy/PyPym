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