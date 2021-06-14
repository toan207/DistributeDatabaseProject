
select * into BookManagement.dbo.BOOKSTOCK_HanoiNoMoreThan60000 from [ROOT].BookManagement.dbo.BOOKSTOCK where BranchID = 'B0' and UnitPrice <= 60000

select * into BookManagement.dbo.ORDERS_HCMLater2021 from [ROOT].BookManagement.dbo.ORDERS where BranchID = 'B1' and OrderDate >= '1-1-2021'
select * from BookManagement.dbo.ORDERS_HCMLater2021