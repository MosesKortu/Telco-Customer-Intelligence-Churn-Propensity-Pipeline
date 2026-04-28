
CREATE OR ALTER VIEW VW_Subscriber_Master_Insights AS
WITH CalculatedMetrics AS (
    SELECT 
        customerID,
        tenure,
        Contract,
        PaymentMethod,
        MonthlyCharges AS ARPU,
        TotalCharges,
        InternetService,
        PhoneService,
        StreamingTV,
        StreamingMovies,
        CASE 
            WHEN InternetService = 'Fiber optic' THEN '4G'
            WHEN InternetService = 'DSL' THEN '3G'
            ELSE 'Voice Only' 
        END AS Network_Type,
        CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END AS Is_Churned,
        AVG(MonthlyCharges) OVER() AS Global_Avg_ARPU,
        SUM(MonthlyCharges) OVER() AS Total_Revenue_Pool,
        NTILE(10) OVER(ORDER BY tenure) AS Tenure_Decile
    FROM dbo.Raw_Subscribers
),
FinalCalculations AS (
    SELECT 
        customerID,
        Network_Type,
        tenure,
        Tenure_Decile,
        Contract,
        CASE 
            WHEN Contract = 'Month-to-month' THEN 'At-Will (High Risk)' 
            ELSE 'Contractual (Stable)' 
        END AS Revenue_Stability,
        ARPU,
        CAST(TotalCharges / NULLIF(tenure, 0) AS DECIMAL(10, 2)) AS Monthly_Revenue_Velocity,
        (CASE WHEN PhoneService = 'Yes' THEN 1 ELSE 0 END +
         CASE WHEN InternetService != 'No' THEN 1 ELSE 0 END +
         CASE WHEN StreamingTV = 'Yes' THEN 1 ELSE 0 END +
         CASE WHEN StreamingMovies = 'Yes' THEN 1 ELSE 0 END) AS Product_Density_Score,
        CASE WHEN Is_Churned = 1 THEN 'Churned/Inactive' ELSE 'Active' END AS Subscriber_Status,
        (ARPU * tenure) AS LTV,
        
        -- UPGRADED STRATEGIC TARGETING
        CASE 
            WHEN Is_Churned = 1 THEN 'Churn'
            WHEN Network_Type = '3G' AND ARPU > Global_Avg_ARPU THEN 'Upgrade' 
            ELSE 'Retain' 
        END AS Migration_Target_Label,
        
        CAST(ARPU / NULLIF(Total_Revenue_Pool, 0) AS DECIMAL(10, 5)) AS Revenue_Weight
    FROM CalculatedMetrics
)
SELECT 
    *,
    CASE 
        WHEN PERCENT_RANK() OVER (ORDER BY Revenue_Weight) <= 0.37 THEN 'Low Value'
        WHEN PERCENT_RANK() OVER (ORDER BY Revenue_Weight) <= 0.62 THEN 'Medium Value'
        ELSE 'High Value'
    END AS Customer_Segment
FROM FinalCalculations;
GO
