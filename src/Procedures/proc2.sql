use BookManagement
go
create proc insert_author @AuthorID varchar(2), @AuthorName nvarchar(30), @Genre nvarchar(60), @Sex nvarchar(20), @Nationality nvarchar(20), @DOB date
as
begin
	if (exists (select AuthorID from [AUTHOR_No_Genre] where AuthorID = @AuthorID))  
	begin
		print 'Khong the them vao AuthorID da co'
	end
	else
		begin
		insert into AUTHOR_No_Genre(AuthorID, AuthorName, Sex, Nationality, DOB)
		values(@AuthorID, @AuthorName, @Sex, @Nationality, @DOB)
		insert into [DESKTOP-84SCD87\SITE3].BookManagement.dbo.AUTHOR_Genre(AuthorID, Genre)
		values(@AuthorID, @Genre)
		end
end
go

create proc insert_customers @CustomerID varchar(2), @CustomerName nvarchar(30), @Address nvarchar(60), @City nvarchar(20), @FAX nvarchar(20), @Phone nvarchar(15)
as
begin
	if (exists (select CustomerID from CUSTOMERS_No_Address where CustomerID = @CustomerID))  
	begin
		print 'Khong the them vao CustomerID da co'
	end
	else
		begin
		insert into CUSTOMERS_No_Address(CustomerID, CustomerName, City, FAX, Phone)
		values(@CustomerID, @CustomerName, @City, @FAX, @Phone)
		insert into [DESKTOP-84SCD87\SITE3].BookManagement.dbo.CUSTOMERS_Address(CustomerID, Address)
		values(@CustomerID, @Address)
		end
end
go

create proc insert_bookstock @BookID varchar(2), @BookName nvarchar(30), @UnitPrice money, @UnitsInStock smallint,
							 @UnitsOnOrder smallint, @AuthorID varchar(2), @PublCompanyID varchar(2), @CategoryID varchar(2), @BranchID varchar(2)
as
begin
	if (exists (select BookID from [DESKTOP-84SCD87\SITE1].BookManagement.dbo.BOOKSTOCK_HanoiMoreThan60000 where BookID = @BookID) 
	   or exists (select BookID from [DESKTOP-84SCD87\SITE1].BookManagement.dbo.BOOKSTOCK_HCMMoreThan60000 where BookID = @BookID) 
	   or exists (select BookID from BookManagement.dbo.BOOKSTOCK_HanoiNoMoreThan60000 where BookID = @BookID)
	   or exists (select BookID from [DESKTOP-84SCD87\SITE3].BookManagement.dbo.BOOKSTOCK_HCMNoMoreThan60000 where BookID = @BookID)
	   or not exists (select PublCompanyID from PUBLISHINGCOMPANY where PublCompanyID = @PublCompanyID)
	   or not exists (select CategoryID from CATEGORIES where CategoryID = @CategoryID)
	   or not exists (select BranchID from BRANCH where BranchID = @BranchID)
	   or not exists (select AuthorID from AUTHOR_No_Genre where AuthorID = @AuthorID)
	   or (@BranchID != 'B1' and @BranchID != 'B0')) 
	begin
		print 'Khong the them vao BookID da co, hoac branchID khac B0-Hanoi, B1-HCM, hoac chua co NXB, tac gia hoac loai sach nay'
	end
	else
		begin
			if (@BranchID = 'B0' AND @UnitPrice > 60000) 
				begin
					insert into [DESKTOP-84SCD87\SITE1].BookManagement.dbo.BOOKSTOCK_HanoiMoreThan60000(BookID, BookName, UnitPrice, UnitsInStock, UnitsOnOrder, AuthorID, PublCompanyID, CategoryID, BranchID)
					values (@BookID, @BookName, @UnitPrice, @UnitsInStock, @UnitsOnOrder, @AuthorID, @PublCompanyID, @CategoryID, @BranchID)	
				end
			else if (@BranchID = 'B1' AND @UnitPrice > 60000)
				begin
					insert into [DESKTOP-84SCD87\SITE1].BookManagement.dbo.BOOKSTOCK_HCMMoreThan60000(BookID, BookName, UnitPrice, UnitsInStock, UnitsOnOrder, AuthorID, PublCompanyID, CategoryID, BranchID)
					values (@BookID, @BookName, @UnitPrice, @UnitsInStock, @UnitsOnOrder, @AuthorID, @PublCompanyID, @CategoryID, @BranchID)	
				end
			else if (@BranchID = 'B0' AND @UnitPrice <= 60000)
				begin
					insert into [DESKTOP-84SCD87\SITE2].BookManagement.dbo.BOOKSTOCK_HanoiNoMoreThan60000(BookID, BookName, UnitPrice, UnitsInStock, UnitsOnOrder, AuthorID, PublCompanyID, CategoryID, BranchID)
					values (@BookID, @BookName, @UnitPrice, @UnitsInStock, @UnitsOnOrder, @AuthorID, @PublCompanyID, @CategoryID, @BranchID)
				end
			else if (@BranchID = 'B1' AND @UnitPrice <= 60000)
				begin
					insert into [DESKTOP-84SCD87\SITE3].BookManagement.dbo.BOOKSTOCK_HCMNoMoreThan60000(BookID, BookName, UnitPrice, UnitsInStock, UnitsOnOrder, AuthorID, PublCompanyID, CategoryID, BranchID)
					values (@BookID, @BookName, @UnitPrice, @UnitsInStock, @UnitsOnOrder, @AuthorID, @PublCompanyID, @CategoryID, @BranchID)
				end
		end
end
go
exec insert_bookstock '14', 'Truyen', 20000, 20, 7, '03', '02', '01', 'B0'
select * from [DESKTOP-84SCD87\SITE1].BookManagement.dbo.BOOKSTOCK_HanoiMoreThan60000
select * from [DESKTOP-84SCD87\SITE1].BookManagement.dbo.BOOKSTOCK_HCMMoreThan60000
select * from [DESKTOP-84SCD87\SITE3].BookManagement.dbo.BOOKSTOCK_HCMNoMoreThan60000
select * from [DESKTOP-84SCD87\SITE2].BookManagement.dbo.BOOKSTOCK_HanoiNoMoreThan60000

go
-- delete
-- tao thu tuc insert cho bang ORDERS
create proc insert_order @OrderID varchar(2), @OrderDate datetime, @RequiredDate datetime, @BookID varchar(2), @CustomerID varchar(2), @BranchID varchar(2)
as
begin
	if (exists (select OrderID from [DESKTOP-84SCD87\SITE1].BookManagement.dbo.ORDERS_HanoiLater2021 where OrderID = @OrderID) 
	   or exists (select OrderID from [DESKTOP-84SCD87\SITE2].BookManagement.dbo.ORDERS_HCMLater2021 where OrderID = @OrderID)
	   or exists (select OrderID from [DESKTOP-84SCD87\SITE3].BookManagement.dbo.ORDERS_HanoiBefore2021 where OrderID = @OrderID)
	   or exists (select OrderID from [DESKTOP-84SCD87\SITE3].BookManagement.dbo.ORDERS_HCMBefore2021 where OrderID = @OrderID)
	   or not exists (select CustomerID from CUSTOMERS_No_Address where CustomerID = @CustomerID)
	   or (@BranchID != 'B1' and @BranchID != 'B0'))
	begin
		print 'Khong the them vao OrderID da co, hoac branchID khac B0-Hanoi, B1-HCM hoac khong co khach hang nay'
	end
	else 
		begin
			if (@BranchID = 'B0' AND @OrderDate >= '1-1-2021')
			begin
				insert into [DESKTOP-84SCD87\SITE1].BookManagement.dbo.ORDERS_HanoiLater2021(OrderID, OrderDate, RequiredDate, BookID, CustomerID, BranchID)
				values (@OrderID, @OrderDate, @RequiredDate, @BookID, @CustomerID, @BranchID)
			end
			else if (@BranchID = 'B1' AND @OrderDate >= '1-1-2021')
			begin
				insert into [DESKTOP-84SCD87\SITE2].BookManagement.dbo.ORDERS_HCMLater2021(OrderID, OrderDate, RequiredDate, BookID, CustomerID, BranchID)
				values (@OrderID, @OrderDate, @RequiredDate, @BookID, @CustomerID, @BranchID)
			end
			else if (@BranchID = 'B0' AND @OrderDate < '1-1-2021')
			begin
				insert into [DESKTOP-84SCD87\SITE3].BookManagement.dbo.ORDERS_HanoiBefore2021(OrderID, OrderDate, RequiredDate, BookID, CustomerID, BranchID)
				values (@OrderID, @OrderDate, @RequiredDate, @BookID, @CustomerID, @BranchID)
			end
			else if (@BranchID = 'B1' AND @OrderDate < '1-1-2021')
			begin
				insert into [DESKTOP-84SCD87\SITE3].BookManagement.dbo.ORDERS_HCMBefore2021(OrderID, OrderDate, RequiredDate, BookID, CustomerID, BranchID)
				values (@OrderID, @OrderDate, @RequiredDate, @BookID, @CustomerID, @BranchID)
			end
		end
end
go

-- tao thu tuc delete cho bang AUTHOR
create proc delete_author @AuthorID varchar(2)
as
begin
	if (exists (select AuthorID from [AUTHOR_No_Genre] where AuthorID = @AuthorID))
	begin
		delete from AUTHOR_No_Genre
		where AuthorID = @AuthorID
		delete from [DESKTOP-84SCD87\SITE3].BookManagement.dbo.AUTHOR_Genre
		where AuthorID = @AuthorID
	end
	else
		begin
			print 'Khong the xoa AuthorID khong co'
		end
end
go

exec delete_author '06'
GO
-- tao thu tuc delete cho bang CUSTOMERS
create proc delete_customers @CustomerID varchar(2)
as
begin
	if (exists (select CustomerID from [CUSTOMERS_No_Address] where CustomerID = @CustomerID))
	begin
		delete from CUSTOMERS_No_Address
		where CustomerID = @CustomerID
		delete from [DESKTOP-84SCD87\SITE3].BookManagement.dbo.CUSTOMERS_Address
		where CustomerID = @CustomerID
	end
	else
		begin
			print 'Khong the xoa CustomerID khong co'
		end
end
go
-- tao thu tuc delete cho bang BOOKSTOCK
create proc delete_bookstock @BookID varchar(2)
as
begin
	if (exists (select BookID from [DESKTOP-84SCD87\SITE1].BookManagement.dbo.BOOKSTOCK_HanoiMoreThan60000 where BookID = @BookID) 
	   or exists (select BookID from [DESKTOP-84SCD87\SITE1].BookManagement.dbo.BOOKSTOCK_HCMMoreThan60000 where BookID = @BookID) 
	   or exists (select BookID from [DESKTOP-84SCD87\SITE2].BookManagement.dbo.BOOKSTOCK_HanoiNoMoreThan60000 where BookID = @BookID)
	   or exists (select BookID from [DESKTOP-84SCD87\SITE3].BookManagement.dbo.BOOKSTOCK_HCMNoMoreThan60000 where BookID = @BookID))
	begin
		delete from [DESKTOP-84SCD87\SITE1].BookManagement.dbo.BOOKSTOCK_HanoiMoreThan60000
		where BookID = @BookID
		delete from [DESKTOP-84SCD87\SITE1].BookManagement.dbo.BOOKSTOCK_HCMMoreThan60000
		where BookID = @BookID
		delete from [DESKTOP-84SCD87\SITE2].BookManagement.dbo.BOOKSTOCK_HanoiNoMoreThan60000
		where BookID = @BookID
		delete from [DESKTOP-84SCD87\SITE3].BookManagement.dbo.BOOKSTOCK_HCMNoMoreThan60000
		where BookID = @BookID
	end
	else
		begin
			print 'Khong the xoa BookID khong co'
		end
end
exec delete_bookstock '14'
go
-- tao thu tuc delete cho bang ORDERS
create proc delete_orders @OrderID varchar(2)
as
begin
	if (exists (select OrderID from [DESKTOP-84SCD87\SITE1].BookManagement.dbo.ORDERS_HanoiLater2021 where OrderID = @OrderID) 
		   or exists (select OrderID from [DESKTOP-84SCD87\SITE2].BookManagement.dbo.ORDERS_HCMLater2021 where OrderID = @OrderID)
		   or exists (select OrderID from [DESKTOP-84SCD87\SITE3].BookManagement.dbo.ORDERS_HanoiBefore2021 where OrderID = @OrderID)
		   or exists (select OrderID from [DESKTOP-84SCD87\SITE3].BookManagement.dbo.ORDERS_HCMBefore2021 where OrderID = @OrderID))
	begin
		delete from [DESKTOP-84SCD87\SITE1].BookManagement.dbo.ORDERS_HanoiLater2021
		where OrderID = @OrderID
		delete from [DESKTOP-84SCD87\SITE2].BookManagement.dbo.ORDERS_HCMLater2021
		where OrderID = @OrderID
		delete from [DESKTOP-84SCD87\SITE3].BookManagement.dbo.ORDERS_HanoiBefore2021
		where OrderID = @OrderID
		delete from [DESKTOP-84SCD87\SITE3].BookManagement.dbo.ORDERS_HCMBefore2021
		where OrderID = @OrderID
	end
	else
		begin
			print 'Khong the xoa BookID khong co'
		end
end
go
-- edit author proc
create proc edit_author @AuthorID varchar(2), @AuthorName nvarchar(30)
as
begin
	if (exists (select AuthorID from [AUTHOR_No_Genre] where AuthorID = @AuthorID))  
		update AUTHOR_No_Genre set AuthorName = @AuthorName where AuthorID = @AuthorID
	else
		print 'Khong co AuthorID nay'
end
go
-- edit customer proc
create proc edit_customer @CustomerID varchar(2), @CustomerName nvarchar(30)
as
begin
	if (exists (select CustomerID from CUSTOMERS_No_Address where CustomerID = @CustomerID))
		update CUSTOMERS_No_Address set CustomerName = @CustomerName where CustomerID = @CustomerID
	else
		print 'Khong co CustomerID nay'
end
go