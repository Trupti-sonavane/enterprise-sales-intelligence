USE [EnterpriseSalesDB]
GO

/****** Object:  StoredProcedure [dbo].[usp_Automate_EnterpriseSales_Load]    Script Date: 11/8/2026 04:03:19 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/* 1. Create the automated CSV loading procedure */
ALTER   PROCEDURE [dbo].[usp_Automate_EnterpriseSales_Load]
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @Map TABLE
    (
        TargetTable SYSNAME,
        StageTable  SYSNAME,
        FileName    NVARCHAR(260)
    );

    INSERT INTO @Map VALUES
    ('Customer data',       'stg_Customer data',       'Customer data.csv'),
    ('Date data',           'stg_Date data',           'Date data.csv'),
    ('Product data',        'stg_Product data',        'Product data.csv'),
    ('Reseller data',       'stg_Reseller data',       'Reseller data.csv'),
    ('Sales data',          'stg_Sales data',          'sales data.csv'),
    ('Sales_order data',    'stg_Sales_order data',    'Sales_order data.csv'),
    ('Sales_territory data','stg_Sales_territory data','Sales_territory data.csv');

    DECLARE
        @Target SYSNAME,
        @Stage SYSNAME,
        @File NVARCHAR(260),
        @Path NVARCHAR(500),
        @SQL NVARCHAR(MAX),
        @Rows BIGINT;

    BEGIN TRY

        /* 2. Create staging tables and load CSV files */
        DECLARE LoadCursor CURSOR LOCAL FAST_FORWARD FOR
        SELECT TargetTable, StageTable, FileName
        FROM @Map;

        OPEN LoadCursor;

        FETCH NEXT FROM LoadCursor
        INTO @Target, @Stage, @File;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @Path = N'C:\SQLData\EnterpriseCSV\' + @File;

            IF OBJECT_ID(N'dbo.' + @Target, N'U') IS NULL
                THROW 51000, 'A target table was not found.', 1;

            /* Create staging table with the same column structure */
            IF OBJECT_ID(N'dbo.' + @Stage, N'U') IS NULL
            BEGIN
                SET @SQL =
                    N'SELECT TOP (0) * INTO dbo.' +
                    QUOTENAME(@Stage) +
                    N' FROM dbo.' + QUOTENAME(@Target) + N';';

                EXEC sys.sp_executesql @SQL;
            END;

            /* Clear previous staging data */
            SET @SQL =
                N'TRUNCATE TABLE dbo.' + QUOTENAME(@Stage) + N';';

            EXEC sys.sp_executesql @SQL;

            /* Load CSV, skipping its header row */
            SET @SQL =
                N'BULK INSERT dbo.' + QUOTENAME(@Stage) +
                N' FROM ''' + REPLACE(@Path, '''', '''''') +
                N''' WITH
                (
                    FIRSTROW = 2,
                    FORMAT = ''CSV'',
                    FIELDQUOTE = ''"'',
                    CODEPAGE = ''65001'',
                    ROWTERMINATOR = ''0x0a'',
                    TABLOCK
                );';

            EXEC sys.sp_executesql @SQL;

            /* Validate staging row count */
            SET @Rows = 0;

            SET @SQL =
                N'SELECT @Count = COUNT_BIG(*) FROM dbo.' +
                QUOTENAME(@Stage) + N';';

            EXEC sys.sp_executesql
                @SQL,
                N'@Count BIGINT OUTPUT',
                @Count = @Rows OUTPUT;

            IF @Rows = 0
                THROW 51001, 'A CSV file loaded zero rows. Main tables were not refreshed.', 1;

            PRINT @File + N' loaded successfully. Rows: ' +
                  CONVERT(NVARCHAR(30), @Rows);

            FETCH NEXT FROM LoadCursor
            INTO @Target, @Stage, @File;
        END;

        CLOSE LoadCursor;
        DEALLOCATE LoadCursor;

        /* 3. Refresh main tables only after all CSVs load successfully */
        BEGIN TRANSACTION;

        DELETE FROM dbo.[Sales data];
        DELETE FROM dbo.[Sales_order data];
        DELETE FROM dbo.[Customer data];
        DELETE FROM dbo.[Date data];
        DELETE FROM dbo.[Product data];
        DELETE FROM dbo.[Reseller data];
        DELETE FROM dbo.[Sales_territory data];

        /* Insert dimensions first */
        INSERT INTO dbo.[Customer data]
            SELECT * FROM dbo.[stg_Customer data];

        INSERT INTO dbo.[Date data]
            SELECT * FROM dbo.[stg_Date data];

        INSERT INTO dbo.[Product data]
            SELECT * FROM dbo.[stg_Product data];

        INSERT INTO dbo.[Reseller data]
            SELECT * FROM dbo.[stg_Reseller data];

        INSERT INTO dbo.[Sales_territory data]
            SELECT * FROM dbo.[stg_Sales_territory data];

        /* Insert sales tables */
        INSERT INTO dbo.[Sales_order data]
            SELECT * FROM dbo.[stg_Sales_order data];

        INSERT INTO dbo.[Sales data]
            SELECT * FROM dbo.[stg_Sales data];

        COMMIT TRANSACTION;

        PRINT 'SUCCESS: All seven CSV files loaded and main tables refreshed.';

    END TRY
    BEGIN CATCH

        IF CURSOR_STATUS('local', 'LoadCursor') >= 0
            CLOSE LoadCursor;

        IF CURSOR_STATUS('local', 'LoadCursor') > -3
            DEALLOCATE LoadCursor;

        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;

        THROW;

    END CATCH;
END;
GO

