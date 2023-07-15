
use finalproject2023;

select sum(subscriberstype.Price) / count(customers.CustID) as 'AVG'
from customers, subscriberstype;


select customers.First_Name, customers.Last_Name, custsub.Start_Of_Sub, custsub.End_Of_Sub,
	subscriberstype.Sub_Name, subscriberstype.Price, subscriberstype.Sub_Description
    from custsub 
    inner join subscriberstype on custsub.SubID = subscriberstype.SubID
    inner join customers on custsub.CustID = customers.CustID;
    
    
    
    SELECT 
	training.Id_Training AS 'Training ID',
	CONCAT(employee.First_Name, ' ', employee.Last_Name) AS 'Coach_Name', 
	groupofplayers.Group_Name AS 'Group Name', 
    COUNT(attendance.CustID) AS 'Number of Attendees',
	type_of_court.Type_Court AS 'Court Type', 
	training.DateOfTraining AS 'Date of Training', 
	training.Start_Of_Training AS 'Start Time',
	training.End_Of_Training AS 'End Time', 
	training.Remark AS 'Training Remark'
	
FROM 
	training
	INNER JOIN employee ON training.Id_Coach = employee.EmployeeID 
	INNER JOIN groupofplayers ON training.GroupID = groupofplayers.ID 
	INNER JOIN courts ON courts.CourtID = training.CourtID
	INNER JOIN type_of_court ON courts.Type_Court = type_of_court.ID
	LEFT JOIN attendance ON training.Id_Training = attendance.Id_Training
    
GROUP BY
	training.Id_Training, employee.First_Name,employee.Last_Name,
    groupofplayers.Group_Name, type_of_court.Type_Court, training.DateOfTraining,
    training.Start_Of_Training,training.End_Of_Training, training.Remark;
    
    
SELECT AVG(DATEDIFF(NOW(), Date_Of_Birth) / 365) AS Average_Age
	FROM Customers;


SELECT SUM(Price) AS Total_Revenue
FROM CustSub
JOIN SubscribersType ON CustSub.SubID = SubscribersType.SubID;
    
    
    
SELECT Type_Of_Court.Type_Court, COUNT(*) AS Training_Sessions
FROM Training
	JOIN Courts ON Training.CourtID = Courts.CourtID
	JOIN Type_Of_Court ON Courts.Type_Court = Type_Of_Court.ID
	GROUP BY Type_Of_Court.Type_Court;
    
    
SELECT First_Name, Last_Name, Start_Of_Work
FROM Employee
WHERE End_Of_Work = '3000-01-01'
ORDER BY Start_Of_Work
LIMIT 1;


SELECT customers.City ,count(customers.CustID) AS 'Amount of people'
from customers
where customers.City IN ('Tel Aviv Yafo', 'En Gedi', 'Jerusalem')
GROUP BY customers.City;



SELECT customers.Tz, customers.First_Name, customers.Last_Name
from customers inner join custsub
where customers.CustID = custsub.CustID and custsub.End_Of_Sub = '3000-01-01';

#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
    DELIMITER $$
CREATE FUNCTION `GetCustomerSubscription`(
    Tz INT
) RETURNS varchar(255) CHARSET utf8mb4
    READS SQL DATA
    DETERMINISTIC
BEGIN
    DECLARE first_name VARCHAR(50);
    DECLARE last_name VARCHAR(50);
    DECLARE sub_name VARCHAR(50);
    DECLARE sub_price DECIMAL(10, 2);
    DECLARE sub_start_date DATE;
    DECLARE sub_end_date DATE;

    SELECT customers.First_Name, customers.Last_Name, SubscribersType.Sub_Name, SubscribersType.Price, CustSub.Start_Of_Sub, CustSub.End_Of_Sub
    INTO first_name, last_name, sub_name, sub_price, sub_start_date, sub_end_date
    FROM SubscribersType
    JOIN CustSub ON SubscribersType.SubID = CustSub.SubID
    JOIN Customers ON CustSub.CustID = Customers.CustID
    WHERE Customers.Tz = Tz AND CURDATE() BETWEEN CustSub.Start_Of_Sub AND CustSub.End_Of_Sub;

    IF sub_name IS NULL THEN
        RETURN CONCAT('Customer with ID card (TZ) ', CAST(Tz AS CHAR), ' does not have an active subscription.');
    ELSEIF sub_end_date = '3000-01-01' THEN
        RETURN CONCAT('Customer with ID card (TZ) ', CAST(Tz AS CHAR), ' is subscribed to ', sub_name, ' for $', CAST(sub_price AS CHAR),
			' per month, starting on ', CAST(sub_start_date AS CHAR), ' with no end date.');
    END IF;
END;

DELIMITER $$
CREATE FUNCTION `GetEmployeeSummary`(TZNum INT) 
	RETURNS varchar(255) CHARSET utf8mb4
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(255);

    SELECT CONCAT(First_Name, ' ', Last_Name, ', Gender: ', Gender,
		', Phone Number: ', Phone_Number, ', Job: ', Job, ', Date of Birth: ',
				Date_Of_Birth, ', Start of Work: ', Start_Of_Work, ', End of Work: ',End_Of_Work)
    INTO result
    FROM Employee
    JOIN jobs ON Employee.Job_Id = jobs.ID
    WHERE Tz = TZNum;
    
    RETURN result;
END


    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    