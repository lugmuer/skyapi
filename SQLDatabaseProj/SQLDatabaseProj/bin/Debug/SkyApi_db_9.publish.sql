﻿/*
Deployment script for SkyApi_db

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "SkyApi_db"
:setvar DefaultFilePrefix "SkyApi_db"
:setvar DefaultDataPath ""
:setvar DefaultLogPath ""

GO
:on error exit
GO
/*
Detect SQLCMD mode and disable script execution if SQLCMD mode is not supported.
To re-enable the script after enabling SQLCMD mode, execute the following:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'SQLCMD mode must be enabled to successfully execute this script.';
        SET NOEXEC ON;
    END


GO
USE [$(DatabaseName)];


GO
/*
The column [dbo].[User].[Email] on table [dbo].[User] must be added, but the column has no default value and does not allow NULL values. If the table contains data, the ALTER script will not work. To avoid this issue you must either: add a default value to the column, mark it as allowing NULL values, or enable the generation of smart-defaults as a deployment option.

The column Name on table [dbo].[User] must be changed from NULL to NOT NULL. If the table contains data, the ALTER script may not work. To avoid this issue, you must add values to this column for all rows or mark it as allowing NULL values, or enable the generation of smart-defaults as a deployment option.

The type for column Name in table [dbo].[User] is currently  NCHAR (10) NULL but is being changed to  VARCHAR (MAX) NOT NULL. Data loss could occur.
*/

IF EXISTS (select top 1 1 from [dbo].[User])
    RAISERROR (N'Rows were detected. The schema update is terminating because data loss might occur.', 16, 127) WITH NOWAIT

GO
PRINT N'Rename refactoring operation with key de6b65e8-81a0-4151-88a3-01c2e63dee13 is skipped, element [dbo].[Flightmembers].[UsedId] (SqlSimpleColumn) will not be renamed to UserId';


GO
PRINT N'Starting rebuilding table [dbo].[User]...';


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER OFF;


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER OFF;


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_User] (
    [Id]    INT           NOT NULL,
    [Name]  VARCHAR (MAX) NOT NULL,
    [Email] VARCHAR (MAX) NOT NULL,
    [Token] VARCHAR (MAX) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[User])
    BEGIN
        INSERT INTO [dbo].[tmp_ms_xx_User] ([Id], [Name])
        SELECT   [Id],
                 [Name]
        FROM     [dbo].[User]
        ORDER BY [Id] ASC;
    END

DROP TABLE [dbo].[User];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_User]', N'User';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


GO
PRINT N'Creating [dbo].[Flightmembers]...';


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER OFF;


GO
CREATE TABLE [dbo].[Flightmembers] (
    [Id]       INT NOT NULL,
    [FlightId] INT NOT NULL,
    [UserId]   INT NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


GO
PRINT N'Creating [dbo].[FK_Member_ToFlight]...';


GO
ALTER TABLE [dbo].[Flightmembers] WITH NOCHECK
    ADD CONSTRAINT [FK_Member_ToFlight] FOREIGN KEY ([FlightId]) REFERENCES [dbo].[Flight] ([Id]);


GO
PRINT N'Creating [dbo].[FK_Member_ToAirport]...';


GO
ALTER TABLE [dbo].[Flightmembers] WITH NOCHECK
    ADD CONSTRAINT [FK_Member_ToAirport] FOREIGN KEY ([UserId]) REFERENCES [dbo].[User] ([Id]);


GO
