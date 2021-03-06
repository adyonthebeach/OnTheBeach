/************************************************************
**
** OnTheBeach MSSQL Database creation and Data Insert Script
**
**
** Author adyonthebeach
** Date 11/06/2015
**
************************************************************/

/* Create Database */
CREATE DATABASE [OnTheBeach] ON  PRIMARY 
( NAME = N'OnTheBeach', FILENAME = N'C:\Git\OnTheBeach\MSSQL\OnTheBeach.mdf' , SIZE = 3072KB , MAXSIZE = 1024000KB , FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'OnTheBeach_log', FILENAME = N'C:\Git\OnTheBeach\MSSQL\OnTheBeach_log.ldf' , SIZE = 5120KB , MAXSIZE = 1024000KB , FILEGROWTH = 10%)
GO
ALTER DATABASE [OnTheBeach] SET COMPATIBILITY_LEVEL = 100
GO
ALTER DATABASE [OnTheBeach] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [OnTheBeach] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [OnTheBeach] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [OnTheBeach] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [OnTheBeach] SET ARITHABORT OFF 
GO
ALTER DATABASE [OnTheBeach] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [OnTheBeach] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [OnTheBeach] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [OnTheBeach] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [OnTheBeach] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [OnTheBeach] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [OnTheBeach] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [OnTheBeach] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [OnTheBeach] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [OnTheBeach] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [OnTheBeach] SET  DISABLE_BROKER 
GO
ALTER DATABASE [OnTheBeach] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [OnTheBeach] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [OnTheBeach] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [OnTheBeach] SET  READ_WRITE 
GO
ALTER DATABASE [OnTheBeach] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [OnTheBeach] SET  MULTI_USER 
GO
ALTER DATABASE [OnTheBeach] SET PAGE_VERIFY CHECKSUM  
GO
USE [OnTheBeach]
GO
IF NOT EXISTS (SELECT name FROM sys.filegroups WHERE is_default=1 AND name = N'PRIMARY') ALTER DATABASE [OnTheBeach] MODIFY FILEGROUP [PRIMARY] DEFAULT
GO

/**************************************************
** Table Creation 
**************************************************/

/****** Object:  Table [dbo].[Currencies]    Script Date: 06/11/2015 22:34:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Currencies](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[unit] [nvarchar](255) NOT NULL,
	[conversion_factor] [decimal](18, 0) NOT NULL,
 CONSTRAINT [PK_Currencies] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [dbo].[Roles]    Script Date: 06/11/2015 22:33:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Roles](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_Roles] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [dbo].[Employees]    Script Date: 06/11/2015 22:33:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Employees](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](255) NOT NULL,
	[role_id] [int] NOT NULL,
 CONSTRAINT [PK_Employees] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[Employees]  WITH CHECK ADD  CONSTRAINT [FK_Employee_Role] FOREIGN KEY([role_id])
REFERENCES [dbo].[Roles] ([id])
GO

ALTER TABLE [dbo].[Employees] CHECK CONSTRAINT [FK_Employee_Role]
GO	

/* Create a unique index using the employee's name to help support future growth 
** This could cause issues with employees with the same name */
CREATE UNIQUE NONCLUSTERED INDEX [EmployeeName] ON [dbo].[Employees] 
(
	[name] ASC
)WITH (STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[Salaries]    Script Date: 06/11/2015 22:33:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
/* Note the diversion from the spec for the size of the annual_amount column*/
CREATE TABLE [dbo].[Salaries](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[employee_id] [int] NOT NULL,
	[currency] [int] NOT NULL,
	[annual_amount] [bigint] NOT NULL, /* This was spec'd as an int but the Professors Salary was too big!*/
 CONSTRAINT [PK_Salaries] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[Salaries]  WITH CHECK ADD  CONSTRAINT [FK_Salary_Currency] FOREIGN KEY([currency])
REFERENCES [dbo].[Currencies] ([id])
GO

ALTER TABLE [dbo].[Salaries] CHECK CONSTRAINT [FK_Salary_Currency]
GO

ALTER TABLE [dbo].[Salaries]  WITH CHECK ADD  CONSTRAINT [FK_Salary_Employee] FOREIGN KEY([employee_id])
REFERENCES [dbo].[Employees] ([id])
GO

ALTER TABLE [dbo].[Salaries] CHECK CONSTRAINT [FK_Salary_Employee]
GO


/***************************************************************
**
** Initial Data Insert
**
***************************************************************/

/* Roles */
INSERT INTO dbo.Roles (name)
VALUES ('Staff')

INSERT INTO dbo.Roles (name)
VALUES ('Manager')

INSERT INTO dbo.Roles (name)
VALUES ('Owner')

/* Currencies */
INSERT INTO dbo.Currencies (unit, conversion_factor)
VALUES ('GBP', 1)

INSERT INTO dbo.Currencies (unit, conversion_factor)
VALUES ('USD', 1.54)

INSERT INTO dbo.Currencies (unit, conversion_factor)
VALUES ('Rocks', 10)

INSERT INTO dbo.Currencies (unit, conversion_factor)
VALUES ('Sweets', 12)

INSERT INTO dbo.Currencies (unit, conversion_factor)
VALUES ('Credits', 8000)

/* Employees */
INSERT INTO dbo.Employees (name, role_id)
VALUES ('Homer Simpson', (SELECT id FROM dbo.Roles WHERE name = 'Staff'))

INSERT INTO dbo.Employees (name, role_id)
VALUES ('Sterling Archer', (SELECT id FROM dbo.Roles WHERE name = 'Staff'))

INSERT INTO dbo.Employees (name, role_id)
VALUES ('Eric Cartman', (SELECT id FROM dbo.Roles WHERE name = 'Staff'))

INSERT INTO dbo.Employees (name, role_id)
VALUES ('Fred Flintstone', (SELECT id FROM dbo.Roles WHERE name = 'Manager'))

INSERT INTO dbo.Employees (name, role_id)
VALUES ('Professor Farnsworth', (SELECT id FROM dbo.Roles WHERE name = 'Owner'))

/* Salaries */
INSERT INTO dbo.Salaries (employee_id, currency, annual_amount)
VALUES ((SELECT id FROM dbo.Employees WHERE name = 'Homer Simpson'),
		(SELECT id FROM dbo.Currencies WHERE unit = 'USD'),
		22000)
		
INSERT INTO dbo.Salaries (employee_id, currency, annual_amount)
VALUES ((SELECT id FROM dbo.Employees WHERE name = 'Sterling Archer'),
		(SELECT id FROM dbo.Currencies WHERE unit = 'USD'),
		150000)
		
INSERT INTO dbo.Salaries (employee_id, currency, annual_amount)
VALUES ((SELECT id FROM dbo.Employees WHERE name = 'Eric Cartman'),
		(SELECT id FROM dbo.Currencies WHERE unit = 'Sweets'),
		60000)
		
INSERT INTO dbo.Salaries (employee_id, currency, annual_amount)
VALUES ((SELECT id FROM dbo.Employees WHERE name = 'Fred Flintstone'),
		(SELECT id FROM dbo.Currencies WHERE unit = 'Rocks'),
		900000)
		
INSERT INTO dbo.Salaries (employee_id, currency, annual_amount)
VALUES ((SELECT id FROM dbo.Employees WHERE name = 'Professor Farnsworth'),
		(SELECT id FROM dbo.Currencies WHERE unit = 'Credits'),
		5000000000)
	

/**************************************************************************************
** Views 
**************************************************************************************/

/****** Object:  View [dbo].[StaffSalaries]    Script Date: 06/11/2015 23:28:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[StaffSalaries]
AS
SELECT     e.id AS employee_id, e.name, r.name AS role, c.unit AS local_currency, s.annual_amount AS salary_local, 
			CONVERT(DECIMAL(10, 2), s.annual_amount / c.conversion_factor) AS salary_GBP
FROM         dbo.Employees AS e INNER JOIN
                      dbo.Roles AS r ON e.role_id = r.id INNER JOIN
                      dbo.Salaries AS s ON e.id = s.employee_id INNER JOIN
                      dbo.Currencies AS c ON s.currency = c.id

GO

/**********************************************
** Stored Procedures
**********************************************/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		AdyOnTheBeach
-- Create date: 11/06/2015
-- Description:	Get an Employees Salary
-- =============================================
CREATE PROCEDURE GetEmployeeSalary 
	@employee_name nvarchar(255)
AS
BEGIN
	SET NOCOUNT ON;
	SELECT employee_id,
		   name,
		   role,
		   local_currency,
		   salary_local,
		   salary_GBP
	FROM StaffSalaries
	WHERE UPPER(name) = UPPER(@employee_name) 
END
GO

/****** Object:  StoredProcedure [dbo].[GetOrderedStaffSalaries]    Script Date: 06/13/2015 12:10:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		AdyOnTheBeach
-- Create date: 11/06/2015
-- Description:	Get Ordered Salaries for Role
-- =============================================
CREATE PROCEDURE [dbo].[GetOrderedSalariesByRole] 
	@role nvarchar(255)
AS
BEGIN
	SET NOCOUNT ON;
	SELECT employee_id,
		   name,
		   role,
		   local_currency,
		   salary_local,
		   salary_GBP
	FROM StaffSalaries
	WHERE UPPER(role) = UPPER(@role) 
	ORDER BY salary_GBP DESC
END

GO
