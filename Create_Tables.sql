drop database witricity;

create database witricity;

use witricity;

Create table Config(
Config_ID INT NOT NULL AUTO_INCREMENT, 
Purpose VARCHAR(100) NOT NULL, 
Pattern VARCHAR(3) NOT NULL, 
Booster_Req CHAR(1) NOT NULL, 
Indoor_Outdoor CHAR(1) NOT NULL, 
PRIMARY KEY(Config_ID));


CREATE TABLE Building_Master (
 Building_ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY ,
 Building_Name VARCHAR(45) NOT NULL  ,
 No_of_Floors INT NOT NULL  ,
 No_of_Rooms INT NOT NULL  
  );
  
Create table Transmitter_Type_Info(
Description VARCHAR(45) NOT NULL, 
Transmitter_Type_ID INT NOT NULL AUTO_INCREMENT, 
Transmitter_Name VARCHAR(20) NOT NULL, 
PRIMARY KEY(Transmitter_Type_ID));

CREATE TABLE Room_Master (
 Room_ID INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
 Building_ID INT NOT NULL  ,
 Description VARCHAR(45) NOT NULL  ,
 Capacity INT NOT NULL  ,
 CONSTRAINT fk_Room_Master_Building_Master1
   FOREIGN KEY (Building_ID)
   REFERENCES Building_Master (Building_ID)
   );
   
    CREATE TABLE IF NOT EXISTS `Witricity`.`UserType_Validity` (
  `User_type` VARCHAR(10) NOT NULL PRIMARY KEY,
  `Validity` INT NOT NULL );
  
  CREATE TABLE IF NOT EXISTS `Witricity`.`Alert_Master` (
  `Alert_ID` INT NOT NULL PRIMARY KEY AUTO_INCREMENT ,
  `Message` VARCHAR(100) NOT NULL ,
  `Type` VARCHAR(45) NOT NULL 
    );
   
   CREATE TABLE IF NOT EXISTS `Witricity`.`User_privileges` (
  `User_ID` VARCHAR(45) NOT NULL PRIMARY KEY ,
  `User_type` VARCHAR(10) NOT NULL ,
  `Valladity_end_date` DATETIME NOT NULL ,
  `User_Consumption_Limit` DOUBLE NOT NULL ,
     CONSTRAINT `fk_User_ privileges _UserType_Validity1`
    FOREIGN KEY (`User_type`)
    REFERENCES `Witricity`.`UserType_Validity` (`User_type`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

    
    CREATE TABLE IF NOT EXISTS `Witricity`.`Login` (
  `User_ID` VARCHAR(45) NOT NULL PRIMARY KEY,
  `Password` VARCHAR(20) NOT NULL ,
  `Combination` INT NOT NULL ,
  `Preference_for_witricity` CHAR(1) NOT NULL ,
    CONSTRAINT `fk_Login_User_privileges1`
    FOREIGN KEY (`User_ID`)
    REFERENCES `Witricity`.`User_privileges` (`User_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

    
   
	
CREATE TABLE IF NOT EXISTS `Witricity`.`User_Location` (
  `User_ID` VARCHAR(45) NOT NULL COMMENT '',
  `GPS` INT NOT NULL COMMENT '',
  `Nearest_Transmitter` INT NOT NULL COMMENT '',
    CONSTRAINT `fk_User_Location_Login1`
    FOREIGN KEY (`User_ID`)
    REFERENCES `Witricity`.`Login`(`User_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);
	
    
CREATE TABLE Location_master (
 Location_Identifier INT NOT NULL PRIMARY KEY AUTO_INCREMENT  ,  
 Building_ID INT NOT NULL  ,
 Room_ID INT NOT NULL 	
   ) ;
   
   
   
   Create table Config_location_mapping(
   Config_ID INT NOT NULL,
   Location_Identifier INT NOT NULL,
   CONSTRAINT fk_Config_User_Location_Master1
   FOREIGN KEY(Config_ID) 
   REFERENCES Config(Config_ID),
   CONSTRAINT fk_Config_User_Location_Master2
   FOREIGN KEY(Location_Identifier)
   REFERENCES Location_Master(Location_Identifier));
      
   Create table Config_Detail(
   Config_ID INT NOT NULL, 
   Transmitter_Type_ID INT NOT NULL, 
   Max_Transmitters INT NOT NULL, 
   Min_Transmitters INT NOT NULL, 
   Max_Booster_Req INT NOT NULL, 
   Min_Booster_Req INT NOT NULL,
   CONSTRAINT fk_ConfigDetail_Config1
   FOREIGN KEY(Config_ID) 
   REFERENCES Config(Config_ID),
   CONSTRAINT fk_ConfigDetail_Transmitter_Type_Info2
   FOREIGN KEY(Transmitter_Type_ID) 
   REFERENCES Transmitter_Type_Info(Transmitter_Type_ID));
   
 CREATE TABLE Event_Master (
 Event_ID INT NOT NULL  PRIMARY KEY,
 Event_Name VARCHAR(45) NOT NULL  ,
 Event_Date DATETIME NOT NULL  , 
 Day_of_week CHAR(3) NOT NULL  ,
 Location_Identifier INT NOT NULL  ,
 CONSTRAINT fk_Event_Location_master1
   FOREIGN KEY (Location_Identifier)
   REFERENCES Location_master (Location_Identifier)
   ) ;
   
   Create table Config_event_mapping(
   Config_ID INT NOT NULL,
   Event_ID INT NOT NULL,
   CONSTRAINT fk_Config_event_mapping_Config1
   FOREIGN KEY(Config_ID) 
   REFERENCES Config(Config_ID),
   CONSTRAINT fk_Config_event_mapping_Event1
   FOREIGN KEY(Event_ID)
   REFERENCES Event_Master(Event_ID));
   
   Create table Config_day_mapping(
   Config_ID INT NOT NULL,
   Day_of_week CHAR(3) NOT NULL,
   Location_Identifier INT NOT NULL,
   On_Date DATETIME,
   CONSTRAINT fk_Config_day_mapping_Config1
   FOREIGN KEY(Config_ID) 
   REFERENCES Config(Config_ID),
   CONSTRAINT fk_Config_day_mapping_Location_master1
   FOREIGN KEY(Location_Identifier)
   REFERENCES Location_Master(Location_Identifier));
   
   
   CREATE TABLE Location_24_7 (
 Location_Identifier INT NOT NULL,  
 Reason VARCHAR(70) NOT NULL , 
CONSTRAINT fk_Location_master2
FOREIGN KEY(Location_Identifier)
REFERENCES Location_Master(Location_Identifier)
   ) ;

CREATE TABLE GPS_Location_Mapping (
 GPS INT NOT NULL  PRIMARY KEY,
 Location_Identifier INT NOT NULL , 
 CONSTRAINT fk_GPC_Loc_Map_Loc_Identifier1
 FOREIGN KEY(Location_Identifier) 
 REFERENCES Location_master(Location_Identifier)  
 );

CREATE TABLE `Witricity`.Power_Booster_Info
(
Booster_Type_ID int(10) NOT NULL AUTO_INCREMENT,
Booster_Description varchar(45),
Max_Transmitters_Possible int(10),
Booster_Name varchar(45),
PRIMARY KEY (Booster_Type_ID)
);


CREATE TABLE `Witricity`.Power_Booster_Master
(
Booster_ID int NOT NULL AUTO_INCREMENT,
Booster_Type_ID int,
Location_Identifier int,
Connected_Transmitter int,
Booster_Status varchar(3),
PRIMARY KEY (Booster_ID),
FOREIGN KEY(Booster_Type_ID) REFERENCES `Witricity`.Power_Booster_Info(Booster_Type_ID)
);


CREATE TABLE `Witricity`.Transmitter_Master
(
Transmiter_ID int NOT NULL AUTO_INCREMENT,
Transmitter_Type_ID int,
Location_Identifier int,
Transmitter_Status varchar(3),
PRIMARY KEY (Transmiter_ID),
FOREIGN KEY(Transmitter_Type_ID) REFERENCES `Witricity`.Transmitter_Type_Info(Transmitter_Type_ID)
);




CREATE TABLE `Witricity`.University_shuttle_Config
(
Shuttle_ID int NOT NULL AUTO_INCREMENT,
Transmitter_ID int,
Min_shuttle_capacity int,
Max_shuttle_capacity int,
Config_ID int,
PRIMARY KEY (Shuttle_ID),
FOREIGN KEY(Config_ID) REFERENCES `Witricity`.Config(Config_ID)
);




CREATE TABLE `Witricity`.`University_own_devices`
(
Device_ID VARCHAR(16) NOT NULL,
Device_type varchar(20) NOT NULL,
Location_identifier int NOT NULL,
FOREIGN KEY(Location_identifier) REFERENCES  `Witricity`.`Location_Master`(Location_identifier)
);



CREATE TABLE `Witricity`. `low_load_days` (
  `low_load_Date` datetime NOT NULL,
  `Reason` varchar(45) NOT NULL,
  PRIMARY KEY (`low_load_Date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE  `Witricity`.`university_holidays` (
  `holiday_date` datetime NOT NULL,
  `Description` varchar(45) NOT NULL,
  PRIMARY KEY (`holiday_date`),
  CONSTRAINT `fk_university_holidays_Low_Load_Days` FOREIGN KEY (`holiday_date`) REFERENCES `low_load_days` (`low_load_Date`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



CREATE TABLE IF NOT EXISTS `Witricity`.`Device_Power_Mapping` (
  `Device_Type` VARCHAR(45) NOT NULL PRIMARY KEY,
  `Max_Power` double NOT NULL,
  `Min_Power` double NOT NULL);
  
  CREATE TABLE  `Witricity`.`device_power_consumption` (
  `Device_ID` varchar(16) NOT NULL,
  `Device_Type` varchar(45) DEFAULT NULL,
  `Consumption` double DEFAULT NULL,
  PRIMARY KEY (`Device_ID`),
  CONSTRAINT fk_Device_Power_Consumption_Device_Power_Mapping
   FOREIGN KEY(Device_Type)
   REFERENCES device_power_mapping(Device_Type));
   



CREATE TABLE `Witricity`. `device_user_mapping` (
  `Device_ID` varchar(16) NOT NULL,
  `User_ID` varchar(45) DEFAULT NULL,
  CONSTRAINT fk_Device_User_Mapping_Device_Power_Consumption
   FOREIGN KEY(Device_ID)
   REFERENCES device_power_consumption(Device_ID),
   CONSTRAINT fk_Device_User_Mapping_lOGIN
   FOREIGN KEY(User_ID)
   REFERENCES login(User_ID));
    
    CREATE TABLE IF NOT EXISTS `Witricity`.`Alert_Log` (
  `Log_ID` INT NOT NULL PRIMARY KEY ,
  `User_ID` VARCHAR(45) NOT NULL ,
  `Alert_ID` INT NOT NULL ,
    CONSTRAINT `fk_Alert_Log_Alert_Master1`
    FOREIGN KEY (`Alert_ID`)
    REFERENCES `Witricity`.`Alert_Master` (`Alert_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);
    
    
    
CREATE TABLE Building_Master_Hist (
 Building_ID INT NOT NULL,
 Building_Name VARCHAR(45) NOT NULL  ,
 No_of_Floors INT NOT NULL  ,
 No_of_Rooms INT NOT NULL,
 DateModified datetime
  );

CREATE TABLE Room_Master_Hist (
 Room_ID INT NOT NULL,
 Building_ID INT NOT NULL  ,
 Description VARCHAR(45) NOT NULL  ,
 Capacity INT NOT NULL,
 DateModified datetime
   );
    
    CREATE TABLE IF NOT EXISTS `Witricity`.`Login_Hist` (
  `User_ID` VARCHAR(45) NOT NULL,
  `Password` VARCHAR(20) NOT NULL ,
  `Combination` INT NOT NULL ,
  `Preference_for_witricity` CHAR(1) NOT NULL,
  DateModified datetime);
	    
CREATE TABLE Location_master_Hist (
 Location_Identifier INT NOT NULL PRIMARY KEY AUTO_INCREMENT  ,
 Location_ID INT NOT NULL  , 
 Building_ID INT NOT NULL  ,
 Room_ID VARCHAR(45) NOT NULL,
 DateModified datetime
   ) ;
   
   Create table Config_Detail_Hist(
   Config_ID INT NOT NULL, 
   Transmitter_Type_ID INT NOT NULL, 
   Max_Transmitters INT NOT NULL, 
   Min_Transmitters INT NOT NULL, 
   Max_Booster_Req INT NOT NULL, 
   Min_Booster_Req INT NOT NULL,
   DateModified datetime);
   
 
CREATE TABLE `Witricity`.Power_Booster_Master_Hist
(
Booster_ID int NOT NULL,
Booster_Type_ID int,
Location_Identifier int,
Connected_Transmitter int,
Booster_Status varchar(3),
DateModified datetime);

CREATE TABLE `Witricity`.Transmitter_Master_Hist
(
Transmiter_ID int NOT NULL,
Transmitter_Type_ID int,
Location_Identifier int,
Transmitter_Status varchar(3),
DateModified datetime
);



Create table Error_Data(
Table_Name VARCHAR(30), 
Errored_Data VARCHAR(150), 
Error_Message VARCHAR(100) NOT NULL, 
Trans_Date DATETIME NOT NULL
);