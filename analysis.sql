USE InsuranceProject;
GO

--   1) Data cleaning
CREATE OR ALTER VIEW dbo.vw_Insurance_Clean AS
SELECT
    PolicyNumber,
    CustomerID,
    Gender,
    Age,
    PolicyType,

    -- From Date DD/MM/YYYY to sql date format
    TRY_CONVERT(date, PolicyStartDate, 103) AS PolicyStartDate,
    TRY_CONVERT(date, PolicyEndDate, 103)   AS PolicyEndDate,
    TRY_CONVERT(date, ClaimDate, 103)       AS ClaimDate,

    PremiumAmount,
    CoverageAmount,
    ClaimNumber,
    ClaimAmount,
    LTRIM(RTRIM(ClaimStatus)) AS ClaimStatus
FROM dbo.InsuranceData;
GO


--   2) Risk by PolicyType
CREATE OR ALTER VIEW dbo.vw_Risk_PolicyType AS
SELECT
    PolicyType,
    COUNT(DISTINCT PolicyNumber) AS PolicyCount,
    COUNT(ClaimNumber) AS ClaimCount,
    SUM(PremiumAmount) AS TotalPremium,
    SUM(ClaimAmount) AS TotalClaimAmount,
    CASE WHEN SUM(PremiumAmount) = 0 THEN NULL
         ELSE SUM(ClaimAmount) / SUM(PremiumAmount)
    END AS LossRatio
FROM dbo.vw_Insurance_Clean
GROUP BY PolicyType;
GO


--   3) ClaimStatus distribution
CREATE OR ALTER VIEW dbo.vw_Risk_ClaimStatus AS
SELECT
    ClaimStatus,
    COUNT(ClaimNumber) AS ClaimCount,
    SUM(ClaimAmount) AS TotalClaimAmount
FROM dbo.vw_Insurance_Clean
GROUP BY ClaimStatus;
GO



-- 4) Claim analysis by agegroup
CREATE OR ALTER VIEW dbo.vw_Risk_AgeGroup AS
SELECT
    CASE
      WHEN Age BETWEEN 18 AND 35 THEN '18-35'
      WHEN Age BETWEEN 36 AND 55 THEN '36-55'
      WHEN Age >= 56 THEN '56+'
      ELSE 'Unknown'
    END AS AgeGroup,
    COUNT(ClaimNumber) AS ClaimCount,
    SUM(ClaimAmount) AS TotalClaimAmount,
    SUM(PremiumAmount) AS TotalPremium
FROM dbo.vw_Insurance_Clean
GROUP BY CASE
      WHEN Age BETWEEN 18 AND 35 THEN '18-35'
      WHEN Age BETWEEN 36 AND 55 THEN '36-55'
      WHEN Age >= 56 THEN '56+'
      ELSE 'Unknown'
    END;
GO


--   5) Claim trend by month
CREATE OR ALTER VIEW dbo.vw_Risk_MonthlyClaims AS
SELECT
    DATEFROMPARTS(YEAR(ClaimDate), MONTH(ClaimDate), 1) AS ClaimMonth,
    COUNT(ClaimNumber) AS ClaimCount,
    SUM(ClaimAmount) AS TotalClaimAmount
FROM dbo.vw_Insurance_Clean
WHERE ClaimDate IS NOT NULL
GROUP BY DATEFROMPARTS(YEAR(ClaimDate), MONTH(ClaimDate), 1);
GO


--Check
SELECT TOP 10 * FROM dbo.vw_Risk_PolicyType ORDER BY LossRatio DESC;
SELECT TOP 10 * FROM dbo.vw_Risk_ClaimStatus ORDER BY ClaimCount DESC;
SELECT TOP 10 * FROM dbo.vw_Risk_AgeGroup ORDER BY TotalClaimAmount DESC;
SELECT TOP 24 * FROM dbo.vw_Risk_MonthlyClaims ORDER BY ClaimMonth DESC;
GO

USE InsuranceProject;
GO
SELECT name
FROM sys.views
WHERE name IN (
  'vw_Insurance_Clean',
  'vw_Risk_PolicyType',
  'vw_Risk_ClaimStatus',
  'vw_Risk_AgeGroup',
  'vw_Risk_MonthlyClaims'
);
GO


--Data Inspection
SELECT * FROM vw_Risk_PolicyType;

SELECT * FROM vw_Risk_ClaimStatus;

SELECT * FROM vw_Risk_AgeGroup;

SELECT * FROM vw_Risk_MonthlyClaims;

SELECT * FROM vw_Insurance_Clean;