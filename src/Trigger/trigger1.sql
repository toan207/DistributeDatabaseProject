-- insert Branch trigger
create trigger insertBranch on BRANCH after insert as
begin
	declare @count int;
	select @count = count(BranchID) from BRANCH where BranchID in (select BranchID from inserted)
	if (@count > 1)
	begin
		raiserror ('Da co BranchID nay',16,1)
		rollback
	end
end
go
insert into BRANCH(BranchID, BranchName) values('B1','a')
select * from BRANCH
delete from BRANCH where BranchName = 'a'

go
-- insert Categories trigger
create trigger insertCategories on CATEGORIES after insert as
begin
	declare @count int;
	select @count = count(CategoryID) from CATEGORIES where CategoryID in (select CategoryID from inserted)
	if (@count > 1)
	begin
		raiserror ('Da co CategoryID nay',16,1)
		rollback
	end
end
INSERT INTO CATEGORIES(CategoryID, CategoryName, Description) VALUES ('06', 'Truyen tranh', '');
select * from CATEGORIES
exec delete_categories '06'
go
-- insert Categories trigger
create trigger insertPC on PUBLISHINGCOMPANY after insert as
begin
	declare @count int;
	select @count = count(PublCompanyID) from PUBLISHINGCOMPANY where PublCompanyID in (select PublCompanyID from inserted)
	if (@count > 1)
	begin
		raiserror ('Da co PublCompanyID nay',16,1)
		rollback
	end
end
go
insert into PUBLISHINGCOMPANY(PublCompanyID, PublCompanyName, Address, City, FAX, Phone, PostalCode) values('06','NXB Dai hoc Quoc gia Ha Noi','16 Hang Chuoi, Pham Đinh Ho, Hai Ba Trung, Ha Noi', 'Ha Noi','0439729436','02439714896','100000')
exec delete_publCom '06'
go

create trigger insertAuthor on AUTHOR_No_Genre after insert as
begin
	declare @count int;
	select @count = count(AuthorID) from AUTHOR_No_Genre where AuthorID IN (select AuthorID from inserted)
	if (@count > 1)
	begin
		raiserror ('Da co AuthorID nay',16,1)
		rollback
	end
end

go

create trigger insertCustomer on CUSTOMERS_No_Address after insert as
begin
	declare @count int;
	select @count = count(CustomerID) from CUSTOMERS_No_Address where CustomerID IN (select CustomerID from inserted)
	if (@count > 1)
	begin
		raiserror ('Da co CustomerID nay',16,1)
		rollback
	end
end

go

create trigger insertOrder on ORDERS_HanoiLater2021 after insert as
begin
	declare @countS1 int, @countS2 int, @countS3 int, @countS3_2 int;
	select @countS1 = count(OrderID) from [DESKTOP-84SCD87\SITE1].BookManagement.dbo.ORDERS_HanoiLater2021 where OrderID in (select OrderID from inserted)
	select @countS2 = count(OrderID) from [DESKTOP-84SCD87\SITE2].BookManagement.dbo.ORDERS_HCMLater2021 where OrderID in (select OrderID from inserted)
	select @countS3 = count(OrderID) from [DESKTOP-84SCD87\SITE3].BookManagement.dbo.ORDERS_HanoiBefore2021 where OrderID in (select OrderID from inserted)
	select @countS3_2 = count(OrderID) from [DESKTOP-84SCD87\SITE3].BookManagement.dbo.ORDERS_HCMBefore2021 where OrderID in (select OrderID from inserted)
	if (@countS1 + @countS2 + @countS3 + @countS3_2 > 1)
	begin
		raiserror ('Da co OrderID nay',16,1)
		rollback
	end
	else if not exists (select BranchID from BRANCH where BranchID in (select BranchID from inserted))
	begin
		raiserror ('Khong co BranchID nay',16,1)
		rollback
	end
	else if not exists (select CustomerID from CUSTOMERS_No_Address where CustomerID in (select CustomerID from inserted))
	begin
		raiserror ('Khong co CustomerID nay',16,1)
		rollback
	end
end

go
create trigger insertBookStockHanoi on BOOKSTOCK_HanoiMoreThan60000 after insert as
begin
	declare @countS1 int, @countS2 int, @countS3 int, @countS3_2 int;
	select @countS1 = count(BookID) from [DESKTOP-84SCD87\SITE1].BookManagement.dbo.BOOKSTOCK_HanoiMoreThan60000 where BookID in (select BookID from inserted)
	select @countS2 = count(BookID) from [DESKTOP-84SCD87\SITE1].BookManagement.dbo.BOOKSTOCK_HCMMoreThan60000 where BookID in (select BookID from inserted)
	select @countS3 = count(BookID) from [DESKTOP-84SCD87\SITE2].BookManagement.dbo.BOOKSTOCK_HanoiNoMoreThan60000 where BookID in (select BookID from inserted)
	select @countS3_2 = count(BookID) from [DESKTOP-84SCD87\SITE3].BookManagement.dbo.BOOKSTOCK_HCMNoMoreThan60000 where BookID in (select BookID from inserted)
	if (@countS1 + @countS2 + @countS3 + @countS3_2 > 1)
	begin
		raiserror ('Da co BookID nay',16,1)
		rollback
	end
	else if not exists (select BranchID from BRANCH where BranchID in (select BranchID from inserted))
	begin
		raiserror ('Khong co BranchID nay',16,1)
		rollback
	end
	else if not exists (select AuthorID from AUTHOR_No_Genre where AuthorID in (select AuthorID from inserted))
	begin
		raiserror ('Khong co AuthorID nay',16,1)
		rollback
	end
	else if not exists (select CategoryID from CATEGORIES where CategoryID in (select CategoryID from inserted))
	begin
		raiserror ('Khong co CategoryID nay',16,1)
		rollback
	end
	else if not exists (select PublCompanyID from PUBLISHINGCOMPANY where PublCompanyID in (select PublCompanyID from inserted))
	begin
		raiserror ('Khong co PublCompanyID nay',16,1)
		rollback
	end
end

go

create trigger insertBookStockHCM on BOOKSTOCK_HCMMoreThan60000 after insert as
begin
	declare @countS1 int, @countS2 int, @countS3 int, @countS3_2 int;
	select @countS1 = count(BookID) from [DESKTOP-84SCD87\SITE1].BookManagement.dbo.BOOKSTOCK_HanoiMoreThan60000 where BookID in (select BookID from inserted)
	select @countS2 = count(BookID) from [DESKTOP-84SCD87\SITE1].BookManagement.dbo.BOOKSTOCK_HCMMoreThan60000 where BookID in (select BookID from inserted)
	select @countS3 = count(BookID) from [DESKTOP-84SCD87\SITE2].BookManagement.dbo.BOOKSTOCK_HanoiNoMoreThan60000 where BookID in (select BookID from inserted)
	select @countS3_2 = count(BookID) from [DESKTOP-84SCD87\SITE3].BookManagement.dbo.BOOKSTOCK_HCMNoMoreThan60000 where BookID in (select BookID from inserted)
	if (@countS1 + @countS2 + @countS3 + @countS3_2 > 1)
	begin
		raiserror ('Da co BookID nay',16,1)
		rollback
	end
	else if not exists (select BranchID from BRANCH where BranchID in (select BranchID from inserted))
	begin
		raiserror ('Khong co BranchID nay',16,1)
		rollback
	end
	else if not exists (select AuthorID from AUTHOR_No_Genre where AuthorID in (select AuthorID from inserted))
	begin
		raiserror ('Khong co AuthorID nay',16,1)
		rollback
	end
	else if not exists (select CategoryID from CATEGORIES where CategoryID in (select CategoryID from inserted))
	begin
		raiserror ('Khong co CategoryID nay',16,1)
		rollback
	end
	else if not exists (select PublCompanyID from PUBLISHINGCOMPANY where PublCompanyID in (select PublCompanyID from inserted))
	begin
		raiserror ('Khong co PublCompanyID nay',16,1)
		rollback
	end
end
go

-- trigger delete
create trigger deleteBranch on BRANCH after delete as
begin
	if (exists (select BranchID from [DESKTOP-84SCD87\SITE1].BookManagement.dbo.BOOKSTOCK_HanoiMoreThan60000 where BranchID in (select BranchID from deleted))
	or exists (select BranchID from [DESKTOP-84SCD87\SITE1].BookManagement.dbo.BOOKSTOCK_HCMMoreThan60000 where BranchID in (select BranchID from deleted))
	or exists (select BranchID from [DESKTOP-84SCD87\SITE2].BookManagement.dbo.BOOKSTOCK_HanoiNoMoreThan60000 where BranchID in (select BranchID from deleted))
	or exists (select BranchID from [DESKTOP-84SCD87\SITE3].BookManagement.dbo.BOOKSTOCK_HCMNoMoreThan60000 where BranchID in (select BranchID from deleted))
	or exists (select BranchID from [DESKTOP-84SCD87\SITE1].BookManagement.dbo.ORDERS_HanoiLater2021 where BranchID in (select BranchID from deleted))
	or exists (select BranchID from [DESKTOP-84SCD87\SITE2].BookManagement.dbo.ORDERS_HCMLater2021 where BranchID in (select BranchID from deleted))
	or exists (select BranchID from [DESKTOP-84SCD87\SITE3].BookManagement.dbo.ORDERS_HanoiBefore2021 where BranchID in (select BranchID from deleted))
	or exists (select BranchID from [DESKTOP-84SCD87\SITE3].BookManagement.dbo.ORDERS_HCMBefore2021 where BranchID in (select BranchID from deleted)))
	begin
		raiserror ('van con BranchID nay trong cac bang Order va Bookstock',16,1)
		rollback
	end
end
go
delete from BRANCH where BranchID = 'B1'
select * from BRANCH
go

create trigger deleteCategory on CATEGORIES after delete as
begin
	if (exists (select CategoryID from [DESKTOP-84SCD87\SITE1].BookManagement.dbo.BOOKSTOCK_HanoiMoreThan60000 where CategoryID in (select CategoryID from deleted))
	or exists (select CategoryID from [DESKTOP-84SCD87\SITE1].BookManagement.dbo.BOOKSTOCK_HCMMoreThan60000 where CategoryID in (select CategoryID from deleted))
	or exists (select CategoryID from [DESKTOP-84SCD87\SITE2].BookManagement.dbo.BOOKSTOCK_HanoiNoMoreThan60000 where CategoryID in (select CategoryID from deleted))
	or exists (select CategoryID from [DESKTOP-84SCD87\SITE3].BookManagement.dbo.BOOKSTOCK_HCMNoMoreThan60000 where CategoryID in (select CategoryID from deleted)))
	begin
		raiserror ('van con CategoryID nay trong cac bang Bookstock',16,1)
		rollback
	end
end
go
delete from CATEGORIES where CategoryID = '01'
select * from CATEGORIES
go
create trigger deletePC on PUBLISHINGCOMPANY after delete as
begin
	if (exists (select PublCompanyID from [DESKTOP-84SCD87\SITE1].BookManagement.dbo.BOOKSTOCK_HanoiMoreThan60000 where PublCompanyID in (select PublCompanyID from deleted))
	or exists (select PublCompanyID from [DESKTOP-84SCD87\SITE1].BookManagement.dbo.BOOKSTOCK_HCMMoreThan60000 where PublCompanyID in (select PublCompanyID from deleted))
	or exists (select PublCompanyID from [DESKTOP-84SCD87\SITE2].BookManagement.dbo.BOOKSTOCK_HanoiNoMoreThan60000 where PublCompanyID in (select PublCompanyID from deleted))
	or exists (select PublCompanyID from [DESKTOP-84SCD87\SITE3].BookManagement.dbo.BOOKSTOCK_HCMNoMoreThan60000 where PublCompanyID in (select PublCompanyID from deleted)))
	begin
		raiserror ('van con PublCompanyID nay trong cac bang Bookstock',16,1)
		rollback
	end
end
go
delete from PUBLISHINGCOMPANY where PublCompanyID = '00'
go
create trigger deleteCustomer on CUSTOMERS_No_Address after delete as
begin
	if (exists (select CustomerID from [DESKTOP-84SCD87\SITE1].BookManagement.dbo.ORDERS_HanoiLater2021 where CustomerID in (select CustomerID from deleted))
	or exists (select CustomerID from [DESKTOP-84SCD87\SITE2].BookManagement.dbo.ORDERS_HCMLater2021 where CustomerID in (select CustomerID from deleted))
	or exists (select CustomerID from [DESKTOP-84SCD87\SITE3].BookManagement.dbo.ORDERS_HanoiBefore2021 where CustomerID in (select CustomerID from deleted))
	or exists (select CustomerID from [DESKTOP-84SCD87\SITE3].BookManagement.dbo.ORDERS_HCMBefore2021 where CustomerID in (select CustomerID from deleted)))
	begin
		raiserror ('van con CustomerID nay trong cac bang Order',16,1)
		rollback
	end
end
go
delete from CUSTOMERS_No_Address where CustomerID = '00'
go
create trigger deleteAuthor on AUTHOR_No_Genre after delete as
begin
	if (exists (select AuthorID from [DESKTOP-84SCD87\SITE1].BookManagement.dbo.BOOKSTOCK_HanoiMoreThan60000 where AuthorID in (select AuthorID from deleted))
	or exists (select AuthorID from [DESKTOP-84SCD87\SITE1].BookManagement.dbo.BOOKSTOCK_HCMMoreThan60000 where AuthorID in (select AuthorID from deleted))
	or exists (select AuthorID from [DESKTOP-84SCD87\SITE2].BookManagement.dbo.BOOKSTOCK_HanoiNoMoreThan60000 where AuthorID in (select AuthorID from deleted))
	or exists (select AuthorID from [DESKTOP-84SCD87\SITE3].BookManagement.dbo.BOOKSTOCK_HCMNoMoreThan60000 where AuthorID in (select AuthorID from deleted)))
	begin
		raiserror ('van con AuthorID nay trong cac bang Bookstock',16,1)
		rollback
	end
end
go
delete from AUTHOR_No_Genre where AuthorID = '00'
go
create trigger deleteBookstockHanoi on BOOKSTOCK_HanoiMoreThan60000 after delete as
begin
	if (exists (select BookID from [DESKTOP-84SCD87\SITE1].BookManagement.dbo.ORDERS_HanoiLater2021 where BookID in (select BookID from deleted))
	or exists (select BookID from [DESKTOP-84SCD87\SITE2].BookManagement.dbo.ORDERS_HCMLater2021 where BookID in (select BookID from deleted))
	or exists (select BookID from [DESKTOP-84SCD87\SITE3].BookManagement.dbo.ORDERS_HanoiBefore2021 where BookID in (select BookID from deleted))
	or exists (select BookID from [DESKTOP-84SCD87\SITE3].BookManagement.dbo.ORDERS_HCMBefore2021 where BookID in (select BookID from deleted)))
	begin
		raiserror ('van con BookID nay trong cac bang Order',16,1)
		rollback
	end
end
go
delete from BOOKSTOCK_HanoiMoreThan60000 where BookID = '00'
go
create trigger deleteBookstockHCM on BOOKSTOCK_HCMMoreThan60000 after delete as
begin
	if (exists (select BookID from [DESKTOP-84SCD87\SITE1].BookManagement.dbo.ORDERS_HanoiLater2021 where BookID in (select BookID from deleted))
	or exists (select BookID from [DESKTOP-84SCD87\SITE2].BookManagement.dbo.ORDERS_HCMLater2021 where BookID in (select BookID from deleted))
	or exists (select BookID from [DESKTOP-84SCD87\SITE3].BookManagement.dbo.ORDERS_HanoiBefore2021 where BookID in (select BookID from deleted))
	or exists (select BookID from [DESKTOP-84SCD87\SITE3].BookManagement.dbo.ORDERS_HCMBefore2021 where BookID in (select BookID from deleted)))
	begin
		raiserror ('van con BookID nay trong cac bang Order',16,1)
		rollback
	end
end
go
delete from BOOKSTOCK_HCMMoreThan60000 where BookID = '04'