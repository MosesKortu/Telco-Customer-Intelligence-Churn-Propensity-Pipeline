-- -- CREATE OR ALTER VIEW VW_Subscriber_Master_Insights AS
-- -- WITH CalculatedMetrics AS (
-- --     SELECT 
-- --         customerID,
-- --         tenure,
-- --         Contract,
-- --         PaymentMethod,
-- --         MonthlyCharges AS ARPU,
-- --         TotalCharges,
-- --         InternetService,
-- --         PhoneService,
-- --         StreamingTV,
-- --         StreamingMovies,
-- --         -- 1. Infrastructure Mapping
-- --         CASE 
-- --             WHEN InternetService = 'Fiber optic' THEN '4G'
-- --             WHEN InternetService = 'DSL' THEN '3G'
-- --             ELSE 'Voice Only' 
-- --         END AS Network_Type,
-- --         -- 2. Behavioral Flags
-- --         CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END AS Is_Churned,
-- --         -- 3. Window Functions for Context
-- --         AVG(MonthlyCharges) OVER() AS Global_Avg_ARPU,
-- --         SUM(MonthlyCharges) OVER() AS Total_Revenue_Pool,
-- --         -- NEW: Tenure Deciles (Grouping into 10% buckets)
-- --         NTILE(10) OVER(ORDER BY tenure) AS Tenure_Decile
-- --     FROM dbo.Raw_Subscribers
-- -- )
-- -- SELECT 
-- --     customerID,
-- --     Network_Type,
-- --     tenure,
-- --     Tenure_Decile, -- 1 = Newest, 10 = Most Loyal
-- --     Contract,
-- --     -- 1. REVENUE STABILITY: CFO Metric
-- --     CASE 
-- --         WHEN Contract = 'Month-to-month' THEN 'At-Will (High Risk)' 
-- --         ELSE 'Contractual (Stable)' 
-- --     END AS Revenue_Stability,
    
-- --     ARPU,
-- --     -- 2. REVENUE VELOCITY: Growth Metric
-- --     CAST(TotalCharges / NULLIF(tenure, 0) AS DECIMAL(10, 2)) AS Monthly_Revenue_Velocity,
    
-- --     -- 3. PRODUCT DENSITY: Stickiness Metric
-- --     (CASE WHEN PhoneService = 'Yes' THEN 1 ELSE 0 END +
-- --      CASE WHEN InternetService != 'No' THEN 1 ELSE 0 END +
-- --      CASE WHEN StreamingTV = 'Yes' THEN 1 ELSE 0 END +
-- --      CASE WHEN StreamingMovies = 'Yes' THEN 1 ELSE 0 END) AS Product_Density_Score,
    
-- --     -- 4. DESCRIPTIVE LABELS
-- --     CASE WHEN Is_Churned = 1 THEN 'Churned/Inactive' ELSE 'Active' END AS Subscriber_Status,
-- --     (ARPU * tenure) AS LTV,
    
-- --     -- 5. STRATEGIC TARGETING
-- --     CASE 
-- --         WHEN Network_Type = '3G' AND ARPU > Global_Avg_ARPU THEN 'High-Value Upgrade' 
-- --         ELSE 'N/A' 
-- --     END AS Migration_Target_Label,
    
-- --     CAST(ARPU / NULLIF(Total_Revenue_Pool, 0) AS DECIMAL(10, 5)) AS Revenue_Weight
-- -- FROM CalculatedMetrics;
-- -- GO

-- CREATE OR ALTER VIEW VW_Subscriber_Master_Insights AS
-- WITH CalculatedMetrics AS (
--     SELECT 
--         customerID,
--         tenure,
--         Contract,
--         PaymentMethod,
--         MonthlyCharges AS ARPU,
--         TotalCharges,
--         InternetService,
--         PhoneService,
--         StreamingTV,
--         StreamingMovies,
--         CASE 
--             WHEN InternetService = 'Fiber optic' THEN '4G'
--             WHEN InternetService = 'DSL' THEN '3G'
--             ELSE 'Voice Only' 
--         END AS Network_Type,
--         CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END AS Is_Churned,
--         AVG(MonthlyCharges) OVER() AS Global_Avg_ARPU,
--         SUM(MonthlyCharges) OVER() AS Total_Revenue_Pool,
--         NTILE(10) OVER(ORDER BY tenure) AS Tenure_Decile
--     FROM dbo.Raw_Subscribers
-- ),
-- FinalCalculations AS (
--     SELECT 
--         customerID,
--         Network_Type,
--         tenure,
--         Tenure_Decile,
--         Contract,
--         CASE 
--             WHEN Contract = 'Month-to-month' THEN 'At-Will (High Risk)' 
--             ELSE 'Contractual (Stable)' 
--         END AS Revenue_Stability,
--         ARPU,
--         CAST(TotalCharges / NULLIF(tenure, 0) AS DECIMAL(10, 2)) AS Monthly_Revenue_Velocity,
--         (CASE WHEN PhoneService = 'Yes' THEN 1 ELSE 0 END +
--          CASE WHEN InternetService != 'No' THEN 1 ELSE 0 END +
--          CASE WHEN StreamingTV = 'Yes' THEN 1 ELSE 0 END +
--          CASE WHEN StreamingMovies = 'Yes' THEN 1 ELSE 0 END) AS Product_Density_Score,
--         CASE WHEN Is_Churned = 1 THEN 'Churned/Inactive' ELSE 'Active' END AS Subscriber_Status,
--         (ARPU * tenure) AS LTV,
--         CASE 
--             WHEN Network_Type = '3G' AND ARPU > Global_Avg_ARPU THEN 'High-Value Upgrade' 
--             ELSE 'N/A' 
--         END AS Migration_Target_Label,
--         CAST(ARPU / NULLIF(Total_Revenue_Pool, 0) AS DECIMAL(10, 5)) AS Revenue_Weight
--     FROM CalculatedMetrics
-- )
-- SELECT 
--     *,
--     /* Adding the Segmentation based on the distribution requested */
--     CASE 
--         WHEN PERCENT_RANK() OVER (ORDER BY Revenue_Weight) <= 0.37 THEN 'Low Value'
--         WHEN PERCENT_RANK() OVER (ORDER BY Revenue_Weight) <= 0.62 THEN 'Medium Value'
--         ELSE 'High Value'
--     END AS Customer_Segment
-- FROM FinalCalculations;
-- GO

/* Version 2 */

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