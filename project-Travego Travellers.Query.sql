
/* 1.Creating the schema and required tables using MySQL workbench a. 
Create a schema named Travego and create the tables mentioned above with the mentioned column names.
 Also, declare the relevant datatypes for each feature/column in the dataset.*/

## CREATING DATABASE TRAVEGO

CREATE DATABASE IF NOT EXISTS Travego;
USE Travego;

## CREATE TABLE PASSENGER

CREATE TABLE Passenger(
Passenger_id INT,
Passenger_Name VARCHAR(20),
Category VARCHAR(20),
Gender VARCHAR(20),
Boarding_City VARCHAR(20),
Destination_City VARCHAR(20),
Distance INT,
Bus_type VARCHAR(20)
);
/*b. Insert the data in the newly created tables.*/

## CREATE TABLE PRICE

create TABLE Price(
id INT,
Bus_type VARCHAR(20),
Distance INT,
Price INT
);

## INSERT RECORDS INTO TABLE PASSENGER

INSERT INTO Passenger VALUES (1,"sejal","AC","F","Bengaluru","Chennai",350,"Sleeper"),
                             (2,"Anmol","Non_AC","M","Mumbai","Hyderabad",700,"Sitting"),
                             (3,"Pallavi","AC","F","Panaji","Bengaluru",600,"Sleeper"),
                             (4,"Khusboo","AC","F","Chennai","Mumbai",1500,"Sleeper"),
                             (5,"Udit","Non_AC","M","Trivandrum","Panaji",1000,"Sleeper"),
                             (6,"Ankur","AC","M","Nagpur","Hyderabad",500,"Sitting"),
                             (7,"Hemant","Non_AC","M","Panaji","Munbai",700,"Sleeper"),
                             (8,"Manish","Non_AC","M","Hyderabad","Bengaluru",500,"Sitting"),
                             (9,"Piyush","AC","M","Pune","Nagpur",700,"Sitting");

## INSERT RECORDS INTO TABLE PRICE

INSERT INTO Price VALUES (1,"Sleeper",350,770),
						(2,"Sleeper",500,1100),
                        (3,"sleeper",600,1320),
                        (4,"Sleeper",700,1540),
                        (5,"Sleeper",1000,2200),
                        (6,"Sleeper",1200,2640),
                        (7,"Sleeper",1500,2700),
                        (8,"Sitting",500,620),
                        (9,"Sitting",600,744),
                        (10,"Sitting",700,868),
                        (11,"Sitting",1000,1240),
                        (12,"Sitting",1200,1488),
                        (13,"Sitting",1500,1860);

SELECT * FROM Passenger;
SELECT * FROM Price;

####################################################  TASK-II ###################################################


-- a. HOW MANY FEMALE PASSENGERS TRAVELED A MINIMUM DIATANCE OF 600 KMs?

SELECT  count(Gender) as Female_Passengers 
	FROM passenger 
	WHERE Gender like "%F%" and Distance>=600;

-- b. Write a query to display the passenger details whose travel distance is greater than 500 and who are traveling in a sleeper bus.

SELECT * 
     FROM passenger 
     WHERE Distance > 500 and Bus_type="Sleeper";
     
-- c. Select passenger names whose names start with the character 'S'.
     
SELECT * 
        FROM passenger 
        WHERE Passenger_Name like "S%";
        
-- d. Calculate the price charged for each passenger, displaying the Passenger name, Boarding City, Destination City, Bus type, and Price in the output.
        
SELECT t1.Passenger_Name,t1.Boarding_City,t1.Destination_City,t1.Bus_type,t1.Distance,t2.price 
FROM passenger as t1
LEFT JOIN price as t2 ON t1.Distance=t2.Distance and t1.bus_type=t2.bus_type;

-- e. What are the passenger name(s) and the ticket price for those who traveled 1000 KMs Sitting in a bus?

/*NOTE : As per data provided in the database(Travego) there are no passengers travelling 1000 Kms Sitting in a bus
          That's why its showing null for the passenger name */
          
SELECT passenger_name, price 
FROM passenger p1 
LEFT JOIN price p2 USING(distance,bus_type)
WHERE p1.distance = 1000 and p1.bus_type = 'Sitting'
UNION
SELECT passenger_name, price 
FROM passenger p1 
RIGHT JOIN price p2 USING (distance,bus_type)
WHERE p2.distance = 1000 and p2.bus_type = 'Sitting'; 

/*NOTE : From the database, the person who travels 1000KMs , sitting_name is null
														   sleeper_name is udit ------> refers code below */
                                                           
SELECT t1.Passenger_Name , t2.price ,"sitting" as bus_type
FROM passenger as t1 
RIGHT JOIN price as t2 on t1.Distance=t2.Distance and t1.bus_type=t2.bus_type
WHERE t2.Distance=1000 and t2.Bus_type like "%Sitting%"
UNION
SELECT t1.Passenger_Name , t2.price , "sleeper"  
FROM passenger as t1 
LEFT JOIN price as t2 ON t1.Distance=t2.Distance and t1.bus_type=t2.bus_type
WHERE t1.Distance=1000 and t1.Bus_type like "%Sleeper%";

/* f. What will be the Sitting and Sleeper bus charge for Pallavi to travel from Bangalore to Panaji? */                                                            
-- USING SUB-QUERY
SELECT "pallavi"as passenger_name,(SELECT price FROM price WHERE bus_type="sleeper" and 
                                                                       distance=(SELECT distance 
																       FROM passenger
																	   WHERE passenger_name="pallavi" and bus_type="sleeper")) as sleeper_price,
		(SELECT price FROM price WHERE bus_type="sitting" and 
                                                distance=(SELECT distance FROM passenger
                                                WHERE passenger_name="pallavi" and
                                                bus_type="sleeper")) as sitting_price;
-- USING JOINS
SELECT passenger_name,p1.bus_type, price FROM passenger p1 LEFT JOIN price p2 
USING(distance,bus_type)
WHERE p1.distance = (SELECT distance FROM passenger WHERE passenger_name='Pallavi') and p1.bus_type in ('Sitting','Sleeper')
UNION
SELECT passenger_name,p2.bus_type, price FROM passenger p1 RIGHT JOIN price p2 
USING(distance,bus_type)
WHERE p2.distance = (SELECT distance FROM passenger WHERE passenger_name='Pallavi') and p2.bus_type in ('Sitting','Sleeper');

/* NOTE : From the database we have passenger pallavi travelled panaji to bengaluru in sleeper 
		  Return from panaji to bengaluru with same distance ...... Matching distance in both tables we get price of two bus_types*/

-- g. Alter the column category with the value "Non-AC" where the Bus_Type is sleeper.

UPDATE passenger 
            SET category="Non_AC" 
            WHERE bus_type="Sleeper";

-- h. Delete an entry from the table where the passenger name is Piyush and commit this change in the database. 

DELETE FROM Passenger
                  WHERE Passenger_Name="Piyush";
COMMIT;
SELECT * FROM Passenger;

-- i. Truncate the table passenger and comment on the number of rows in the table (explain if required).

TRUNCATE TABLE Passenger;
SELECT * FROM Passenger;

/* NOTE : "0" number of records in the passenger table after truncate
           Truncate will delete all the records in the table but not table itself , structure of the table remains . 
           Dropping table will delete the table from database.*/
           
-- j. Delete the table passenger from the database.
           
DROP TABLE Passenger;
