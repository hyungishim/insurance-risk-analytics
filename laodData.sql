--Select Database
USE InsuranceProject;
GO

--InsuranceData table
CREATE TABLE InsuranceData(
    PolicyNumber VARCHAR(20),
    CustomerID VARCHAR(20),
    Gender VARCHAR(20),
    Age INT,
    PolicyType VARCHAR(50),
    PolicyStartDate VARCHAR(20),
    PolicyEndDate VARCHAR(20),
    PremiumAmount DECIMAL(18,2),
    CoverageAmount DECIMAL(18,2),
    ClaimNumber VARCHAR(30),
    ClaimDate VARCHAR(20),
    ClaimAmount DECIMAL(18,2),
    ClaimStatus VARCHAR(20)
);

--load InsuranceData

BULK INSERT dbo.InsuranceData
FROM '/var/opt/mssql/data/InsuranceData.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a'
);
GO

SELECT COUNT(*) FROM dbo.InsuranceData;

-- CustomerFeedback table
CREATE TABLE dbo.CustomerFeedback (
    CustomerName NVARCHAR(200),
    Feedback NVARCHAR(MAX)
);
GO

BULK INSERT dbo.CustomerFeedback
FROM '/var/opt/mssql/data/Insurance+Customer+Feedback.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a'
);
GO

SELECT COUNT(*) AS FeedbackRowCount
FROM dbo.CustomerFeedback;

SELECT TOP 5 *
FROM dbo.CustomerFeedback;
GO