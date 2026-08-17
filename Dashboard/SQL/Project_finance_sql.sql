DROP DATABASE IF EXISTS HealthcareFinancialAnalysis;
CREATE DATABASE HealthcareFinancialAnalysis;
USE HealthcareFinancialAnalysis;

CREATE TABLE Company_Master
(
    CompanyID INT PRIMARY KEY,
    CompanyName VARCHAR(100),
    Sector VARCHAR(100)
);

CREATE TABLE Income_Statement
(
    CompanyID INT,
    CompanyName VARCHAR(100),
    FinancialYear VARCHAR(10),
    Revenue DECIMAL(18,2),
    OperatingProfit DECIMAL(18,2),
    NetProfit DECIMAL(18,2),

    FOREIGN KEY (CompanyID)
    REFERENCES Company_Master(CompanyID)
);

CREATE TABLE Balance_Sheet
(
    CompanyID INT,
    CompanyName VARCHAR(100),
    FinancialYear VARCHAR(10),

    TotalAssets DECIMAL(18,2),
    CurrentAssets DECIMAL(18,2),
    CurrentLiabilities DECIMAL(18,2),

    Borrowings DECIMAL(18,2),
    Equity DECIMAL(18,2),
    CashAndCashEquivalents DECIMAL(18,2),

    FOREIGN KEY (CompanyID)
    REFERENCES Company_Master(CompanyID)
);

CREATE TABLE Cash_Flow
(
    CompanyID INT,
    CompanyName VARCHAR(100),
    FinancialYear VARCHAR(10),

    OperatingCashFlow DECIMAL(18,2),
    InvestingCashFlow DECIMAL(18,2),
    FinancingCashFlow DECIMAL(18,2),

    FOREIGN KEY (CompanyID)
    REFERENCES Company_Master(CompanyID)
);

SHOW TABLES;
DESCRIBE Company_Master;
DESCRIBE Income_Statement;
DESCRIBE Balance_Sheet;
DESCRIBE Cash_Flow;

SELECT * FROM Company_Master;
SELECT * FROM Income_Statement;
SELECT COUNT(*) AS TotalRows
FROM Income_Statement;

SELECT COUNT(*) AS TotalRows
FROM Balance_Sheet;

SELECT COUNT(*) AS TotalRows
FROM Cash_Flow;

SELECT COUNT(*) FROM Company_Master;
SELECT COUNT(*) FROM Income_Statement;
SELECT COUNT(*) FROM Balance_Sheet;
SELECT COUNT(*) FROM Cash_Flow;

-- Data Validation
SELECT * FROM Company_Master;
SELECT * FROM Income_Statement;
SELECT * FROM Balance_Sheet;
SELECT * FROM Cash_Flow;

SELECT COUNT(*) AS TotalCompanies
FROM Company_Master;

SELECT COUNT(*) AS TotalIncomeRows
FROM Income_Statement;

SELECT COUNT(*) AS TotalBalanceRows
FROM Balance_Sheet;

SELECT COUNT(*) AS TotalCashFlowRows
FROM Cash_Flow;

-- check null values
SELECT *
FROM Income_Statement
WHERE Revenue IS NULL
   OR OperatingProfit IS NULL
   OR NetProfit IS NULL;

SELECT *
FROM Balance_Sheet
WHERE TotalAssets IS NULL;

SELECT *
FROM Cash_Flow
WHERE OperatingCashFlow IS NULL;

SELECT CompanyID,
       FinancialYear,
       COUNT(*) AS DuplicateCount
FROM Income_Statement
GROUP BY CompanyID, FinancialYear
HAVING COUNT(*) > 1;

SELECT DISTINCT FinancialYear
FROM Income_Statement
ORDER BY FinancialYear;

SELECT *
FROM Income_Statement
WHERE Revenue < 0;

-- Check Foreign Key Integrity
SELECT i.CompanyID
FROM Income_Statement i
LEFT JOIN Company_Master c
ON i.CompanyID = c.CompanyID
WHERE c.CompanyID IS NULL;

-- Exploratory Data Analysis (EDA)
SELECT *
FROM Company_Master;
SELECT *
FROM Income_Statement;
SELECT *
FROM Balance_Sheet;
SELECT *
FROM Cash_Flow;

-- Total Revenue by Company
SELECT
    CompanyName,
    SUM(Revenue) AS TotalRevenue
FROM Income_Statement
GROUP BY CompanyName
ORDER BY TotalRevenue DESC;

-- Total Operating Profit
SELECT
    CompanyName,
    SUM(OperatingProfit) AS TotalOperatingProfit
FROM Income_Statement
GROUP BY CompanyName
ORDER BY TotalOperatingProfit DESC;

-- Total Net Profit
SELECT
    CompanyName,
    SUM(NetProfit) AS TotalNetProfit
FROM Income_Statement
GROUP BY CompanyName
ORDER BY TotalNetProfit DESC;

-- Revenue by Year
SELECT
    FinancialYear,
    SUM(Revenue) AS Revenue
FROM Income_Statement
GROUP BY FinancialYear
ORDER BY FinancialYear;

-- Net Profit by Year
SELECT
    FinancialYear,
    SUM(NetProfit) AS Profit
FROM Income_Statement
GROUP BY FinancialYear
ORDER BY FinancialYear;

-- Company-wise Revenue Trend
SELECT
    CompanyName,
    FinancialYear,
    Revenue
FROM Income_Statement
ORDER BY CompanyName, FinancialYear;

-- Company-wise Operating Profit
SELECT
    CompanyName,
    SUM(OperatingProfit) AS TotalOperatingProfit
FROM Income_Statement
GROUP BY CompanyName
ORDER BY TotalOperatingProfit DESC;

-- Company-wise Net Profit
SELECT
    CompanyName,
    SUM(NetProfit) AS TotalNetProfit
FROM Income_Statement
GROUP BY CompanyName
ORDER BY TotalNetProfit DESC;

-- Net Profit by Company and Year
SELECT
    CompanyName,
    FinancialYear,
    NetProfit
FROM Income_Statement
ORDER BY CompanyName, FinancialYear;

-- Operating Profit Margin
SELECT
    CompanyName,
    FinancialYear,
    Revenue,
    OperatingProfit,
    ROUND((OperatingProfit / Revenue) * 100, 2) AS OperatingProfitMargin
FROM Income_Statement
ORDER BY CompanyName, FinancialYear;

-- Net Profit Margin
SELECT
    CompanyName,
    FinancialYear,
    Revenue,
    NetProfit,
    ROUND((NetProfit / Revenue) * 100, 2) AS NetProfitMargin
FROM Income_Statement
ORDER BY CompanyName, FinancialYear;

-- Compare Companies in FY2025
SELECT
    CompanyName,
    Revenue
FROM Income_Statement
WHERE FinancialYear = 'FY2025'
ORDER BY Revenue DESC;

-- Highest net profit in FY2025
SELECT
    CompanyName,
    NetProfit
FROM Income_Statement
WHERE FinancialYear = 'FY2025'
ORDER BY NetProfit DESC;

-- Highest operating margin in FY2025
SELECT
    CompanyName,
    ROUND((OperatingProfit / Revenue) * 100, 2) AS OperatingProfitMargin
FROM Income_Statement
WHERE FinancialYear = 'FY2025'
ORDER BY OperatingProfitMargin DESC;

-- Growth Analysis
SELECT
    CompanyName,
    FinancialYear,
    Revenue,
    LAG(Revenue) OVER (
        PARTITION BY CompanyName
        ORDER BY FinancialYear
    ) AS PreviousYearRevenue
FROM Income_Statement;

-- Net Profit Growth
SELECT
    CompanyName,
    FinancialYear,
    NetProfit,
    LAG(NetProfit) OVER (
        PARTITION BY CompanyName
        ORDER BY FinancialYear
    ) AS PreviousYearProfit
FROM Income_Statement;

-- Revenue YoY Growth %
SELECT
    CompanyName,
    FinancialYear,
    Revenue,
    LAG(Revenue) OVER (
        PARTITION BY CompanyName
        ORDER BY FinancialYear
    ) AS PreviousYearRevenue,

    ROUND(
        ((Revenue - LAG(Revenue) OVER (
            PARTITION BY CompanyName
            ORDER BY FinancialYear
        )) /
        LAG(Revenue) OVER (
            PARTITION BY CompanyName
            ORDER BY FinancialYear
        )) * 100,
        2
    ) AS RevenueGrowthPercent

FROM Income_Statement
ORDER BY CompanyName, FinancialYear;

-- Net Profit YoY Growth
SELECT
    CompanyName,
    FinancialYear,
    NetProfit,

    LAG(NetProfit) OVER (
        PARTITION BY CompanyName
        ORDER BY FinancialYear
    ) AS PreviousYearNetProfit,

    ROUND(
        (
            (NetProfit - LAG(NetProfit) OVER (
                PARTITION BY CompanyName
                ORDER BY FinancialYear
            ))
            /
            LAG(NetProfit) OVER (
                PARTITION BY CompanyName
                ORDER BY FinancialYear
            )
        ) * 100,
        2
    ) AS NetProfitGrowthPercent

FROM Income_Statement
ORDER BY CompanyName, FinancialYear;

-- Revenue CAGR
SELECT
    CompanyName,

    MAX(CASE
        WHEN FinancialYear = 'FY2021' THEN Revenue
    END) AS Revenue_FY2021,

    MAX(CASE
        WHEN FinancialYear = 'FY2025' THEN Revenue
    END) AS Revenue_FY2025,

    ROUND(
        (
            POWER(
                MAX(CASE
                    WHEN FinancialYear = 'FY2025' THEN Revenue
                END)
                /
                MAX(CASE
                    WHEN FinancialYear = 'FY2021' THEN Revenue
                END),
                1.0 / 4
            ) - 1
        ) * 100,
        2
    ) AS Revenue_CAGR_Percent

FROM Income_Statement
GROUP BY CompanyName
ORDER BY Revenue_CAGR_Percent DESC;

-- Net Profit CAGR
SELECT
    CompanyName,

    MAX(CASE
        WHEN FinancialYear = 'FY2021' THEN NetProfit
    END) AS NetProfit_FY2021,

    MAX(CASE
        WHEN FinancialYear = 'FY2025' THEN NetProfit
    END) AS NetProfit_FY2025,

    ROUND(
        (
            POWER(
                MAX(CASE
                    WHEN FinancialYear = 'FY2025' THEN NetProfit
                END)
                /
                MAX(CASE
                    WHEN FinancialYear = 'FY2021' THEN NetProfit
                END),
                1.0 / 4
            ) - 1
        ) * 100,
        2
    ) AS NetProfit_CAGR_Percent

FROM Income_Statement
GROUP BY CompanyName
ORDER BY NetProfit_CAGR_Percent DESC;

-- Total Assets by Company
SELECT
    CompanyName,
    SUM(TotalAssets) AS TotalAssets
FROM Balance_Sheet
GROUP BY CompanyName
ORDER BY TotalAssets DESC;

-- Assets Trend by Year
SELECT
    CompanyName,
    FinancialYear,
    TotalAssets
FROM Balance_Sheet
ORDER BY CompanyName, FinancialYear;

-- Current Assets vs Current Liabilities
SELECT
    CompanyName,
    FinancialYear,
    CurrentAssets,
    CurrentLiabilities
FROM Balance_Sheet
ORDER BY CompanyName, FinancialYear;

-- Current Ratio
SELECT
    CompanyName,
    FinancialYear,
    CurrentAssets,
    CurrentLiabilities,
    ROUND(
        CurrentAssets / NULLIF(CurrentLiabilities, 0),
        2
    ) AS CurrentRatio
FROM Balance_Sheet
ORDER BY CompanyName, FinancialYear;

-- Borrowings by Company and Year
SELECT
    CompanyName,
    FinancialYear,
    Borrowings
FROM Balance_Sheet
ORDER BY CompanyName, FinancialYear;

-- First, check Borrowings + Equity together
SELECT
    CompanyName,
    FinancialYear,
    Borrowings,
    Equity
FROM Balance_Sheet
ORDER BY CompanyName, FinancialYear;

-- Calculate Debt-to-Equity Ratio
SELECT
    CompanyName,
    FinancialYear,
    Borrowings,
    Equity,
    ROUND(Borrowings / NULLIF(Equity, 0), 2) AS DebtToEquityRatio
FROM Balance_Sheet
ORDER BY CompanyName, FinancialYear;

-- Compare the 5 companies
SELECT
    CompanyName,
    ROUND(AVG(Borrowings / NULLIF(Equity, 0)), 2) AS AverageDebtToEquity
FROM Balance_Sheet
GROUP BY CompanyName
ORDER BY AverageDebtToEquity DESC;

-- Find the highest D/E year
SELECT
    CompanyName,
    FinancialYear,
    ROUND(Borrowings / NULLIF(Equity, 0), 2) AS DebtToEquityRatio
FROM Balance_Sheet
ORDER BY DebtToEquityRatio DESC;

-- Return on Equity (ROE)
-- Formula
-- ROE = (Net Profit ÷ Equity) × 100

SELECT
    i.CompanyName,
    i.FinancialYear,
    i.NetProfit,
    b.Equity,
    ROUND((i.NetProfit / NULLIF(b.Equity, 0)) * 100, 2) AS ROE
FROM Income_Statement i
JOIN Balance_Sheet b
    ON i.CompanyID = b.CompanyID
    AND i.FinancialYear = b.FinancialYear
ORDER BY i.CompanyName, i.FinancialYear;

-- ROA — Return on Assets
-- Formula
-- ROA = (Net Profit ÷ Total Assets) × 100
SELECT
    i.CompanyName,
    i.FinancialYear,
    i.NetProfit,
    b.TotalAssets,
    ROUND(
        (i.NetProfit / NULLIF(b.TotalAssets, 0)) * 100,
        2
    ) AS ROA
FROM Income_Statement i
JOIN Balance_Sheet b
    ON i.CompanyID = b.CompanyID
    AND i.FinancialYear = b.FinancialYear
ORDER BY i.CompanyName, i.FinancialYear;

-- CASH FLOW ANALYSIS
DESCRIBE Cash_Flow;
SELECT *
FROM Cash_Flow
ORDER BY CompanyName, FinancialYear;

-- Cash Flow by Company & Year
SELECT
    CompanyName,
    FinancialYear,
    OperatingCashFlow,
    InvestingCashFlow,
    FinancingCashFlow
FROM Cash_Flow
ORDER BY CompanyName, FinancialYear;

-- Calculate Net Cash Flow
SELECT
    CompanyName,
    FinancialYear,
    OperatingCashFlow,
    InvestingCashFlow,
    FinancingCashFlow,
    ROUND(
        OperatingCashFlow 
        + InvestingCashFlow 
        + FinancingCashFlow, 2
    ) AS NetCashFlow
FROM Cash_Flow
ORDER BY CompanyName, FinancialYear;

-- Average Operating Cash Flow by Company
SELECT
    CompanyName,
    ROUND(AVG(OperatingCashFlow), 2) AS AvgOperatingCashFlow
FROM Cash_Flow
GROUP BY CompanyName
ORDER BY AvgOperatingCashFlow DESC;

-- Total Cash Flow by Company
SELECT
    CompanyName,
    ROUND(SUM(OperatingCashFlow), 2) AS TotalOperatingCashFlow,
    ROUND(SUM(InvestingCashFlow), 2) AS TotalInvestingCashFlow,
    ROUND(SUM(FinancingCashFlow), 2) AS TotalFinancingCashFlow,
    ROUND(
        SUM(OperatingCashFlow)
        + SUM(InvestingCashFlow)
        + SUM(FinancingCashFlow), 2
    ) AS TotalNetCashFlow
FROM Cash_Flow
GROUP BY CompanyName
ORDER BY TotalNetCashFlow DESC;

-- Operating Cash Flow vs Net Profit-- 
SELECT
    i.CompanyName,
    i.FinancialYear,
    i.NetProfit,
    c.OperatingCashFlow,
    ROUND(
        c.OperatingCashFlow / NULLIF(i.NetProfit, 0), 2
    ) AS CashConversionRatio
FROM Income_Statement i
JOIN Cash_Flow c
    ON i.CompanyID = c.CompanyID
    AND i.FinancialYear = c.FinancialYear
ORDER BY i.CompanyName, i.FinancialYear;

-- Cash Flow Analysis-- 
DESCRIBE Cash_Flow;
-- View complete cash-flow data
SELECT
    CompanyName,
    FinancialYear,
    OperatingCashFlow,
    InvestingCashFlow,
    FinancingCashFlow
FROM Cash_Flow
ORDER BY CompanyName, FinancialYear;

-- Operating Cash Flow by company
SELECT
    CompanyName,
    SUM(OperatingCashFlow) AS TotalOperatingCashFlow
FROM Cash_Flow
GROUP BY CompanyName
ORDER BY TotalOperatingCashFlow DESC;

-- Investing Cash Flow by company
SELECT
    CompanyName,
    SUM(InvestingCashFlow) AS TotalInvestingCashFlow
FROM Cash_Flow
GROUP BY CompanyName
ORDER BY TotalInvestingCashFlow DESC;

-- Financing Cash Flow by company
SELECT
    CompanyName,
    SUM(FinancingCashFlow) AS TotalFinancingCashFlow
FROM Cash_Flow
GROUP BY CompanyName
ORDER BY TotalFinancingCashFlow DESC;

-- Net Cash Flow
SELECT
    CompanyName,
    FinancialYear,
    OperatingCashFlow,
    InvestingCashFlow,
    FinancingCashFlow,
    (OperatingCashFlow + InvestingCashFlow + FinancingCashFlow) AS NetCashFlow
FROM Cash_Flow
ORDER BY CompanyName, FinancialYear;

-- Total Net Cash Flow by company
SELECT
    CompanyName,
    SUM(OperatingCashFlow + InvestingCashFlow + FinancingCashFlow) AS TotalNetCashFlow
FROM Cash_Flow
GROUP BY CompanyName
ORDER BY TotalNetCashFlow DESC;
-- Cash Flow trend year-wise
SELECT
    CompanyName,
    FinancialYear,
    OperatingCashFlow,
    InvestingCashFlow,
    FinancingCashFlow,
    (OperatingCashFlow + InvestingCashFlow + FinancingCashFlow) AS NetCashFlow
FROM Cash_Flow
ORDER BY CompanyName, FinancialYear;

-- Overall Revenue-- 
SELECT
    CompanyName,
    SUM(Revenue) AS TotalRevenue
FROM Income_Statement
GROUP BY CompanyName
ORDER BY TotalRevenue DESC;

-- Overall Net Profit
SELECT
    CompanyName,
    SUM(NetProfit) AS TotalNetProfit
FROM Income_Statement
GROUP BY CompanyName
ORDER BY TotalNetProfit DESC;

-- Average ROE
SELECT
    i.CompanyName,
    ROUND(AVG((i.NetProfit / NULLIF(b.Equity, 0)) * 100), 2) AS AverageROE
FROM Income_Statement i
JOIN Balance_Sheet b
    ON i.CompanyID = b.CompanyID
    AND i.FinancialYear = b.FinancialYear
GROUP BY i.CompanyName
ORDER BY AverageROE DESC;

-- Average ROA
SELECT
    i.CompanyName,
    ROUND(AVG((i.NetProfit / NULLIF(b.TotalAssets, 0)) * 100), 2) AS AverageROA
FROM Income_Statement i
JOIN Balance_Sheet b
    ON i.CompanyID = b.CompanyID
    AND i.FinancialYear = b.FinancialYear
GROUP BY i.CompanyName
ORDER BY AverageROA DESC;

-- Average Current Ratio
SELECT
    CompanyName,
    ROUND(AVG(CurrentAssets / NULLIF(CurrentLiabilities, 0)), 2) AS AverageCurrentRatio
FROM Balance_Sheet
GROUP BY CompanyName
ORDER BY AverageCurrentRatio DESC;

-- Average Debt-to-Equity
SELECT
    CompanyName,
    ROUND(AVG(Borrowings / NULLIF(Equity, 0)), 2) AS AverageDebtToEquity
FROM Balance_Sheet
GROUP BY CompanyName
ORDER BY AverageDebtToEquity ASC;

-- Average Operating Cash Flow
SELECT
    CompanyName,
    ROUND(AVG(OperatingCashFlow), 2) AS AverageOperatingCashFlow
FROM Cash_Flow
GROUP BY CompanyName
ORDER BY AverageOperatingCashFlow DESC;

-- Create the overall company score
WITH CompanySummary AS
(
    SELECT
        i.CompanyName,

        SUM(i.Revenue) AS TotalRevenue,
        SUM(i.NetProfit) AS TotalNetProfit,

        ROUND(AVG(
            (i.OperatingProfit / NULLIF(i.Revenue, 0)) * 100
        ), 2) AS AvgOperatingMargin,

        ROUND(AVG(
            (i.NetProfit / NULLIF(b.Equity, 0)) * 100
        ), 2) AS AvgROE,

        ROUND(AVG(
            (i.NetProfit / NULLIF(b.TotalAssets, 0)) * 100
        ), 2) AS AvgROA,

        ROUND(AVG(
            b.CurrentAssets / NULLIF(b.CurrentLiabilities, 0)
        ), 2) AS AvgCurrentRatio,

        ROUND(AVG(
            b.Borrowings / NULLIF(b.Equity, 0)
        ), 2) AS AvgDebtToEquity

    FROM Income_Statement i
    JOIN Balance_Sheet b
        ON i.CompanyID = b.CompanyID
        AND i.FinancialYear = b.FinancialYear

    GROUP BY i.CompanyName
)

SELECT *
FROM CompanySummary;

-- Add Cash Flow to the Summary
WITH CompanySummary AS
(
    SELECT
        i.CompanyName,

        SUM(i.Revenue) AS TotalRevenue,
        SUM(i.NetProfit) AS TotalNetProfit,

        ROUND(AVG(
            (i.OperatingProfit / NULLIF(i.Revenue, 0)) * 100
        ), 2) AS AvgOperatingMargin,

        ROUND(AVG(
            (i.NetProfit / NULLIF(b.Equity, 0)) * 100
        ), 2) AS AvgROE,

        ROUND(AVG(
            (i.NetProfit / NULLIF(b.TotalAssets, 0)) * 100
        ), 2) AS AvgROA,

        ROUND(AVG(
            b.CurrentAssets / NULLIF(b.CurrentLiabilities, 0)
        ), 2) AS AvgCurrentRatio,

        ROUND(AVG(
            b.Borrowings / NULLIF(b.Equity, 0)
        ), 2) AS AvgDebtToEquity

    FROM Income_Statement i
    JOIN Balance_Sheet b
        ON i.CompanyID = b.CompanyID
        AND i.FinancialYear = b.FinancialYear

    GROUP BY i.CompanyName
),

CashFlowSummary AS
(
    SELECT
        CompanyName,
        ROUND(AVG(OperatingCashFlow), 2) AS AvgOperatingCashFlow,
        ROUND(
            AVG(
                OperatingCashFlow
                + InvestingCashFlow
                + FinancingCashFlow
            ), 2
        ) AS AvgNetCashFlow

    FROM Cash_Flow
    GROUP BY CompanyName
)

SELECT
    c.*,
    f.AvgOperatingCashFlow,
    f.AvgNetCashFlow

FROM CompanySummary c
JOIN CashFlowSummary f
    ON c.CompanyName = f.CompanyName
ORDER BY c.CompanyName;

-- Create the final ranking
WITH CompanySummary AS
(
    SELECT
        i.CompanyName,
        SUM(i.Revenue) AS TotalRevenue,
        SUM(i.NetProfit) AS TotalNetProfit,

        AVG((i.OperatingProfit / NULLIF(i.Revenue,0)) * 100)
            AS AvgOperatingMargin,

        AVG((i.NetProfit / NULLIF(b.Equity,0)) * 100)
            AS AvgROE,

        AVG((i.NetProfit / NULLIF(b.TotalAssets,0)) * 100)
            AS AvgROA,

        AVG(b.CurrentAssets / NULLIF(b.CurrentLiabilities,0))
            AS AvgCurrentRatio,

        AVG(b.Borrowings / NULLIF(b.Equity,0))
            AS AvgDebtToEquity

    FROM Income_Statement i
    JOIN Balance_Sheet b
        ON i.CompanyID = b.CompanyID
        AND i.FinancialYear = b.FinancialYear

    GROUP BY i.CompanyName
),

CashFlowSummary AS
(
    SELECT
        CompanyName,
        AVG(OperatingCashFlow) AS AvgOperatingCashFlow,
        AVG(
            OperatingCashFlow
            + InvestingCashFlow
            + FinancingCashFlow
        ) AS AvgNetCashFlow
    FROM Cash_Flow
    GROUP BY CompanyName
),

Ranked AS
(
    SELECT
        c.*,
        f.AvgOperatingCashFlow,
        f.AvgNetCashFlow,

        RANK() OVER (ORDER BY TotalRevenue DESC) AS RevenueRank,

        RANK() OVER (ORDER BY TotalNetProfit DESC) AS NetProfitRank,

        RANK() OVER (ORDER BY AvgOperatingMargin DESC) AS MarginRank,

        RANK() OVER (ORDER BY AvgROE DESC) AS ROERank,

        RANK() OVER (ORDER BY AvgROA DESC) AS ROARank,

        RANK() OVER (ORDER BY AvgCurrentRatio DESC) AS CurrentRatioRank,

        RANK() OVER (ORDER BY AvgDebtToEquity ASC) AS DebtEquityRank,

        RANK() OVER (ORDER BY AvgOperatingCashFlow DESC) AS CashFlowRank,

        RANK() OVER (ORDER BY AvgNetCashFlow DESC) AS NetCashFlowRank

    FROM CompanySummary c
    JOIN CashFlowSummary f
        ON c.CompanyName = f.CompanyName
)

SELECT
    CompanyName,
    ROUND(TotalRevenue,2) AS TotalRevenue,
    ROUND(TotalNetProfit,2) AS TotalNetProfit,
    ROUND(AvgOperatingMargin,2) AS AvgOperatingMargin,
    ROUND(AvgROE,2) AS AvgROE,
    ROUND(AvgROA,2) AS AvgROA,
    ROUND(AvgCurrentRatio,2) AS AvgCurrentRatio,
    ROUND(AvgDebtToEquity,2) AS AvgDebtToEquity,
    ROUND(AvgOperatingCashFlow,2) AS AvgOperatingCashFlow,
    ROUND(AvgNetCashFlow,2) AS AvgNetCashFlow,

    RevenueRank +
    NetProfitRank +
    MarginRank +
    ROERank +
    ROARank +
    CurrentRatioRank +
    DebtEquityRank +
    CashFlowRank +
    NetCashFlowRank AS TotalScore

FROM Ranked
ORDER BY TotalScore ASC;

-- Add the final overall rank
WITH CompanySummary AS
(
    SELECT
        i.CompanyName,
        SUM(i.Revenue) AS TotalRevenue,
        SUM(i.NetProfit) AS TotalNetProfit,

        AVG((i.OperatingProfit / NULLIF(i.Revenue,0)) * 100)
            AS AvgOperatingMargin,

        AVG((i.NetProfit / NULLIF(b.Equity,0)) * 100)
            AS AvgROE,

        AVG((i.NetProfit / NULLIF(b.TotalAssets,0)) * 100)
            AS AvgROA,

        AVG(b.CurrentAssets / NULLIF(b.CurrentLiabilities,0))
            AS AvgCurrentRatio,

        AVG(b.Borrowings / NULLIF(b.Equity,0))
            AS AvgDebtToEquity

    FROM Income_Statement i
    JOIN Balance_Sheet b
        ON i.CompanyID = b.CompanyID
        AND i.FinancialYear = b.FinancialYear

    GROUP BY i.CompanyName
),

CashFlowSummary AS
(
    SELECT
        CompanyName,
        AVG(OperatingCashFlow) AS AvgOperatingCashFlow,
        AVG(OperatingCashFlow + InvestingCashFlow + FinancingCashFlow)
            AS AvgNetCashFlow
    FROM Cash_Flow
    GROUP BY CompanyName
),

Ranked AS
(
    SELECT
        c.*,
        f.AvgOperatingCashFlow,
        f.AvgNetCashFlow,

        RANK() OVER (ORDER BY TotalRevenue DESC) +
        RANK() OVER (ORDER BY TotalNetProfit DESC) +
        RANK() OVER (ORDER BY AvgOperatingMargin DESC) +
        RANK() OVER (ORDER BY AvgROE DESC) +
        RANK() OVER (ORDER BY AvgROA DESC) +
        RANK() OVER (ORDER BY AvgCurrentRatio DESC) +
        RANK() OVER (ORDER BY AvgDebtToEquity ASC) +
        RANK() OVER (ORDER BY AvgOperatingCashFlow DESC) +
        RANK() OVER (ORDER BY AvgNetCashFlow DESC)
        AS TotalScore

    FROM CompanySummary c
    JOIN CashFlowSummary f
        ON c.CompanyName = f.CompanyName
)

SELECT
    CompanyName,
    ROUND(TotalScore,0) AS TotalScore,
    RANK() OVER (ORDER BY TotalScore ASC) AS OverallRank
FROM Ranked
ORDER BY OverallRank;

-- Create Income Statement View
CREATE OR REPLACE VIEW vw_income_analysis AS
SELECT
    CompanyName,
    FinancialYear,
    Revenue,
    OperatingProfit,
    NetProfit,

    ROUND(
        (OperatingProfit / NULLIF(Revenue, 0)) * 100,
        2
    ) AS OperatingProfitMargin,

    ROUND(
        (NetProfit / NULLIF(Revenue, 0)) * 100,
        2
    ) AS NetProfitMargin,

    ROUND(
        (
            (
                Revenue -
                LAG(Revenue) OVER (
                    PARTITION BY CompanyName
                    ORDER BY FinancialYear
                )
            )
            /
            NULLIF(
                LAG(Revenue) OVER (
                    PARTITION BY CompanyName
                    ORDER BY FinancialYear
                ),
                0
            )
        ) * 100,
        2
    ) AS RevenueYoYGrowth

FROM Income_Statement;

-- Create Balance Sheet View
CREATE OR REPLACE VIEW vw_balance_analysis AS
SELECT
    CompanyName,
    FinancialYear,
    TotalAssets,
    CurrentAssets,
    CurrentLiabilities,
    Borrowings,
    Equity,

    ROUND(
        CurrentAssets / NULLIF(CurrentLiabilities, 0),
        2
    ) AS CurrentRatio,

    ROUND(
        Borrowings / NULLIF(Equity, 0),
        2
    ) AS DebtToEquity,

    ROUND(
        (SELECT i.NetProfit
         FROM Income_Statement i
         WHERE i.CompanyID = Balance_Sheet.CompanyID
           AND i.FinancialYear = Balance_Sheet.FinancialYear)
        / NULLIF(TotalAssets, 0) * 100,
        2
    ) AS ROA

FROM Balance_Sheet;

-- Create Cash Flow View
CREATE OR REPLACE VIEW vw_cashflow_analysis AS
SELECT
    CompanyName,
    FinancialYear,
    OperatingCashFlow,
    InvestingCashFlow,
    FinancingCashFlow,

    (
        OperatingCashFlow
        + InvestingCashFlow
        + FinancingCashFlow
    ) AS NetCashFlow

FROM Cash_Flow;

-- Create ROE View
CREATE OR REPLACE VIEW vw_roe_analysis AS
SELECT
    i.CompanyName,
    i.FinancialYear,
    i.NetProfit,
    b.Equity,

    ROUND(
        (i.NetProfit / NULLIF(b.Equity, 0)) * 100,
        2
    ) AS ROE

FROM Income_Statement i

JOIN Balance_Sheet b
    ON i.CompanyID = b.CompanyID
    AND i.FinancialYear = b.FinancialYear;
    
-- Create Company Summary View
CREATE OR REPLACE VIEW vw_company_summary AS

SELECT
    i.CompanyName,

    SUM(i.Revenue) AS TotalRevenue,

    SUM(i.NetProfit) AS TotalNetProfit,

    ROUND(
        AVG(
            (i.OperatingProfit / NULLIF(i.Revenue,0)) * 100
        ), 2
    ) AS AvgOperatingMargin,

    ROUND(
        AVG(
            (i.NetProfit / NULLIF(b.Equity,0)) * 100
        ), 2
    ) AS AvgROE,

    ROUND(
        AVG(
            (i.NetProfit / NULLIF(b.TotalAssets,0)) * 100
        ), 2
    ) AS AvgROA,

    ROUND(
        AVG(
            b.CurrentAssets /
            NULLIF(b.CurrentLiabilities,0)
        ), 2
    ) AS AvgCurrentRatio,

    ROUND(
        AVG(
            b.Borrowings /
            NULLIF(b.Equity,0)
        ), 2
    ) AS AvgDebtToEquity

FROM Income_Statement i

JOIN Balance_Sheet b
    ON i.CompanyID = b.CompanyID
    AND i.FinancialYear = b.FinancialYear

GROUP BY i.CompanyName;

-- Verify the Views
SHOW FULL TABLES
WHERE Table_type = 'VIEW';

SELECT *
FROM vw_company_summary;

SELECT *
FROM vw_cashflow_analysis;

-- Create the Final Power BI Master View
CREATE OR REPLACE VIEW vw_powerbi_master AS
SELECT
    i.CompanyID,
    i.CompanyName,
    i.FinancialYear,

    -- Income Statement
    i.Revenue,
    i.OperatingProfit,
    i.NetProfit,

    ROUND(
        (i.OperatingProfit / NULLIF(i.Revenue, 0)) * 100,
        2
    ) AS OperatingProfitMargin,

    ROUND(
        (i.NetProfit / NULLIF(i.Revenue, 0)) * 100,
        2
    ) AS NetProfitMargin,

    -- Balance Sheet
    b.TotalAssets,
    b.CurrentAssets,
    b.CurrentLiabilities,
    b.Borrowings,
    b.Equity,

    ROUND(
        b.CurrentAssets / NULLIF(b.CurrentLiabilities, 0),
        2
    ) AS CurrentRatio,

    ROUND(
        b.Borrowings / NULLIF(b.Equity, 0),
        2
    ) AS DebtToEquity,

    -- Profitability
    ROUND(
        (i.NetProfit / NULLIF(b.Equity, 0)) * 100,
        2
    ) AS ROE,

    ROUND(
        (i.NetProfit / NULLIF(b.TotalAssets, 0)) * 100,
        2
    ) AS ROA,

    -- Cash Flow
    c.OperatingCashFlow,
    c.InvestingCashFlow,
    c.FinancingCashFlow,

    (
        c.OperatingCashFlow
        + c.InvestingCashFlow
        + c.FinancingCashFlow
    ) AS NetCashFlow,

    ROUND(
        c.OperatingCashFlow / NULLIF(i.NetProfit, 0),
        2
    ) AS CashConversionRatio

FROM Income_Statement i

JOIN Balance_Sheet b
    ON i.CompanyID = b.CompanyID
    AND i.FinancialYear = b.FinancialYear

JOIN Cash_Flow c
    ON i.CompanyID = c.CompanyID
    AND i.FinancialYear = c.FinancialYear;
    
-- Check the master view
SELECT *
FROM vw_powerbi_master;

ALTER USER 'root'@'localhost' IDENTIFIED BY 'YourNewPassword123!';

SELECT USER(), CURRENT_USER();