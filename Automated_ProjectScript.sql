use witricity;
DROP FUNCTION IF EXISTS SPLIT_STR;
CREATE FUNCTION SPLIT_STR(
 x VARCHAR(255),
 delim VARCHAR(12),
 pos INT
 )
   RETURNS VARCHAR(255)
   RETURN REPLACE(SUBSTRING(SUBSTRING_INDEX(x, delim, pos),LENGTH(SUBSTRING_INDEX(x, delim, pos -1)) + 1),
delim, '');

--
--- Config table Error Handling and data Insert
--
DROP PROCEDURE IF EXISTS Config_data_insert;
DROP PROCEDURE IF EXISTS Building_Master_data_insert;
DROP PROCEDURE IF EXISTS Transmitter_Type_Info_data_insert;
DROP PROCEDURE IF EXISTS Room_Master_data_insert;
DROP PROCEDURE IF EXISTS UserType_Validity_data_insert;
DROP PROCEDURE IF EXISTS Alert_Master_data_insert;
DROP PROCEDURE IF EXISTS User_privileges_data_insert;
DROP PROCEDURE IF EXISTS Login_data_insert;
DROP PROCEDURE IF EXISTS User_Location_data_insert;
DROP PROCEDURE IF EXISTS Location_master_data_insert;
DROP PROCEDURE IF EXISTS Config_location_mapping_data_insert;
DROP PROCEDURE IF EXISTS Config_Detail_data_insert;
DROP PROCEDURE IF EXISTS Event_Master_data_insert;
DROP PROCEDURE IF EXISTS Config_event_mapping_data_insert;
DROP PROCEDURE IF EXISTS Config_day_mapping_data_insert;
DROP PROCEDURE IF EXISTS Location_24_7_data_insert;
DROP PROCEDURE IF EXISTS GPS_Location_Mapping_data_insert;
DROP PROCEDURE IF EXISTS Power_Booster_Info_data_insert;
DROP PROCEDURE IF EXISTS Power_Booster_Master_data_insert;
DROP PROCEDURE IF EXISTS Transmitter_Master_data_insert;
DROP PROCEDURE IF EXISTS University_shuttle_Config_data_insert;
DROP PROCEDURE IF EXISTS University_own_devices_data_insert;
DROP PROCEDURE IF EXISTS low_load_days_data_insert;
DROP PROCEDURE IF EXISTS university_holidays_data_insert;
DROP PROCEDURE IF EXISTS Device_Power_Mapping_data_insert;
DROP PROCEDURE IF EXISTS device_power_consumption_data_insert;
DROP PROCEDURE IF EXISTS device_user_mapping_data_insert;
DROP PROCEDURE IF EXISTS alert_log_data_insert;

DROP PROCEDURE IF EXISTS witricity_project_proc;

DELIMITER $$  

CREATE PROCEDURE Config_data_insert(pdata_insert varchar(2),pdata varchar(2000),ptable_name varchar(50))

   BEGIN
      -- Declaration Section
      --
	  DECLARE l_string varchar(2000) DEFAULT NULL;
	  DECLARE l_occurences INT default 0;
	  DECLARE l_column1 varchar(200) default NULL;
      DECLARE l_column2 varchar(200) default NULL;
      DECLARE l_column3 varchar(200) default NULL;
      DECLARE l_column4 varchar(200) default NULL;
      DECLARE l_column5 varchar(200) default NULL;
      DECLARE l_no_of_columns INT DEFAULT 0;
      DECLARE l_error_message varchar(200) default NULL;
      
      -- DECLARE CONTINUE HANDLER FOR 1062 SELECT 'Duplicate keys error encountered while inserting data in Config table' into l_error_message;
      DECLARE CONTINUE HANDLER FOR SQLEXCEPTION -- SELECT 'SQLException encountered while inserting data in Config table' into l_error_message; 
     -- DECLARE CONTINUE HANDLER FOR 1452 select 'Foreign key constraint violated while inserting data in Config table' into l_error_message;
      --
     BEGIN
        --
		get diagnostics condition 1
		       
          @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
			SET @full_error = CONCAT("ERROR ", @errno, @text);
		  
		
		IF @full_error like 'ERROR 1452Cannot add or update a child row: a foreign key constraint fails%' then
		   INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('Config',pdata,'Foreign key constraint violated',SYSDATE());
		END IF;
		--
		IF @full_error like 'ERROR 1062%' then
		   INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('Config',pdata,'Primary key constraint violated',SYSDATE());
		END IF;
		--
		SET l_error_message =  @full_error;
		--
        INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('Config',pdata,l_error_message,SYSDATE());
             commit;
        
        END;
      --
      IF pdata_insert NOT IN ('Y','N') THEN
         --
         SIGNAL SQLSTATE '45000'
         SET MESSAGE_TEXT = 'Invalid value passed to first parameter.(Valid value:Y/N)';
         INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('Config',pdata,'Invalid value passed to first parameter.(Valid value:Y/N)',SYSDATE());
             commit; 
     ELSE 
	  if pdata_insert = 'Y' then
	    --
        SET l_string = pdata;
	    --
        SELECT LENGTH(l_string) - LENGTH(REPLACE(l_string, '|', ''))+1 into l_occurences; 
	    --
        SELECT COUNT(*) into l_no_of_columns
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE upper(table_schema) = upper('witricity')
        AND upper(table_name) = upper(ptable_name);
        -- 
         IF(l_no_of_columns != l_occurences) THEN 
          SIGNAL SQLSTATE '45001'
          SET MESSAGE_TEXT = 'Insufficient data passed to the insert into table';
        --  INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
          --   VALUES('Config',pdata,'Insufficient data passed to the insert into table',SYSDATE());
            -- commit; 
          --
         ELSE
             --
             SET l_column1 = SPLIT_STR(pdata,'|',1);
             SET l_column2 = SPLIT_STR(pdata,'|',2);
             SET l_column3 = SPLIT_STR(pdata,'|',3);
             SET l_column4 = SPLIT_STR(pdata,'|',4);
             SET l_column5 = SPLIT_STR(pdata,'|',5);
             -- 
             START TRANSACTION;
             -- insert a new record into table
             INSERT INTO Config(Config_ID ,Purpose ,Pattern,Booster_Req,Indoor_Outdoor )
             VALUES(default,l_column2,l_column3,l_column4,l_column5);
             --             
             COMMIT;
             --
           END IF;
           -- 
		ELSE  -- Insert the bulk data using inseet statements pdata_insert = N
           --
           -- select 'Inside pdata_insert N';
           --
		   ALTER TABLE witricity.Config AUTO_INCREMENT= 300301;
		   
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Fall fest for members more than 1500', 'Hi', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Fall fest for members more than 800', 'Med', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Fall fest for members more than 150', 'Low', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Fall fest for members more than 350', 'Hi', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Fall fest for members more than 700', 'Med', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Fall fest for members more than 100', 'Low', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'LASO for members more than 1500', 'Hi', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'LASO for members more than 800', 'Med', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'LASO for members more than 150', 'Low', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'LASO for members more than 350', 'Hi', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'LASO for members more than 700', 'Med', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'LASO for members more than 100', 'Low', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Homecoming for members more than 1500', 'Hi', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Homecoming for members more than 800', 'Med', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Homecoming for members more than 150', 'Low', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Homecoming for members more than 350', 'Hi', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Homecoming for members more than 700', 'Med', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Homecoming for members more than 100', 'Low', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Spring fest for members more than 1500', 'Hi', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Spring fest for members more than 800', 'Med', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Spring fest for members more than 150', 'Low', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Spring fest for members more than 350', 'Hi', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Spring fest for members more than 700', 'Med', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Spring fest for members more than 100', 'Low', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Barbeque for members more than 1500', 'Hi', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Barbeque for members more than 800', 'Med', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Barbeque for members more than 150', 'Low', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Barbeque for members more than 350', 'Hi', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Barbeque for members more than 700', 'Med', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Barbeque for members more than 100', 'Low', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Halloween for members more than 1500', 'Hi', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Halloween for members more than 800', 'Med', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Halloween for members more than 150', 'Low', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Halloween for members more than 350', 'Hi', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Halloween for members more than 700', 'Med', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Halloween for members more than 100', 'Low', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Career fair Fall for members more than 1500', 'Hi', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Career fair Fall for members more than 800', 'Med', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Career fair Fall for members more than 150', 'Low', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Career fair Fall for members more than 350', 'Hi', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Career fair Fall for members more than 700', 'Med', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Career fair Fall for members more than 100', 'Low', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Career fair Spring for members more than 1500', 'Hi', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Career fair Spring for members more than 800', 'Med', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Career fair Spring for members more than 150', 'Low', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Career fair Spring for members more than 350', 'Hi', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Career fair Spring for members more than 700', 'Med', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Career fair Spring for members more than 100', 'Low', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Workshop for members more than 1500', 'Hi', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Workshop for members more than 800', 'Med', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Workshop for members more than 150', 'Low', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Workshop for members more than 350', 'Hi', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Workshop for members more than 700', 'Med', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Workshop for members more than 100', 'Low', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Seminar for members more than 1500', 'Hi', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Seminar for members more than 800', 'Med', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Seminar for members more than 150', 'Low', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Seminar for members more than 350', 'Hi', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Seminar for members more than 700', 'Med', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Seminar for members more than 100', 'Low', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Navrarti for members more than 1500', 'Hi', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Navrarti for members more than 800', 'Med', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Navrarti for members more than 150', 'Low', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Navrarti for members more than 350', 'Hi', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Navrarti for members more than 700', 'Med', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Navrarti for members more than 100', 'Low', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Trash2Treasure for members more than 1500', 'Hi', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Trash2Treasure for members more than 800', 'Med', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Trash2Treasure for members more than 150', 'Low', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Trash2Treasure for members more than 350', 'Hi', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Trash2Treasure for members more than 700', 'Med', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Trash2Treasure for members more than 100', 'Low', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day1 for members more than 1500', 'Hi', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day1 for members more than 800', 'Med', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day1 for members more than 150', 'Low', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day1 for members more than 350', 'Hi', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day1 for members more than 700', 'Med', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day1 for members more than 100', 'Low', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day2 for members more than 1500', 'Hi', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day2 for members more than 800', 'Med', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day2 for members more than 150', 'Low', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day2 for members more than 350', 'Hi', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day2 for members more than 700', 'Med', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day2 for members more than 100', 'Low', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day3 for members more than 1500', 'Hi', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day3 for members more than 800', 'Med', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day3 for members more than 150', 'Low', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day3 for members more than 350', 'Hi', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day3 for members more than 700', 'Med', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day3 for members more than 100', 'Low', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day4 for members more than 1500', 'Hi', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day4 for members more than 800', 'Med', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day4 for members more than 150', 'Low', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day4 for members more than 350', 'Hi', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day4 for members more than 700', 'Med', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day4 for members more than 100', 'Low', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day5 for members more than 1500', 'Hi', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day5 for members more than 800', 'Med', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day5 for members more than 150', 'Low', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day5 for members more than 350', 'Hi', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day5 for members more than 700', 'Med', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day5 for members more than 100', 'Low', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day6 for members more than 1500', 'Hi', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day6 for members more than 800', 'Med', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day6 for members more than 150', 'Low', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day6 for members more than 350', 'Hi', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day6 for members more than 700', 'Med', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day6 for members more than 100', 'Low', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'GaneshChaturthi for members more than 1500', 'Hi', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'GaneshChaturthi for members more than 800', 'Med', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'GaneshChaturthi for members more than 150', 'Low', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'GaneshChaturthi for members more than 350', 'Hi', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'GaneshChaturthi for members more than 700', 'Med', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'GaneshChaturthi for members more than 100', 'Low', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring Day1 for members more than 1500', 'Hi', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring Day1 for members more than 800', 'Med', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring Day1 for members more than 150', 'Low', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring Day1 for members more than 350', 'Hi', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring  Day1 for members more than 700', 'Med', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring  Day1 for members more than 100', 'Low', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring  Day2 for members more than 1500', 'Hi', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring  Day2 for members more than 800', 'Med', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring  Day2 for members more than 150', 'Low', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring  Day2 for members more than 350', 'Hi', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring  Day2 for members more than 700', 'Med', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring  Day2 for members more than 100', 'Low', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring  Day3 for members more than 1500', 'Hi', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring Day3 for members more than 800', 'Med', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring Day3 for members more than 150', 'Low', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring Day3 for members more than 350', 'Hi', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring Day3 for members more than 700', 'Med', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring Day3 for members more than 100', 'Low', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring Day4 for members more than 1500', 'Hi', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring Day4 for members more than 800', 'Med', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring Day4 for members more than 150', 'Low', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring Day4 for members more than 350', 'Hi', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring Day4 for members more than 700', 'Med', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring Day4 for members more than 100', 'Low', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring Day5 for members more than 1500', 'Hi', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring Day5 for members more than 800', 'Med', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring Day5 for members more than 150', 'Low', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring Day5 for members more than 350', 'Hi', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring Day5 for members more than 700', 'Med', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring Day5 for members more than 100', 'Low', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring Day6 for members more than 1500', 'Hi', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring Day6 for members more than 800', 'Med', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring Day6 for members more than 150', 'Low', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring Day6 for members more than 350', 'Hi', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring Day6 for members more than 700', 'Med', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring Day6 for members more than 100', 'Low', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Fall fest for members more than 1500', 'Hi', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Fall fest for members more than 800', 'Med', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Fall fest for members more than 150', 'Low', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Fall fest for members more than 350', 'Hi', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Fall fest for members more than 700', 'Med', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Fall fest for members more than 100', 'Low', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'LASO for members more than 1500', 'Hi', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'LASO for members more than 800', 'Med', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'LASO for members more than 150', 'Low', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'LASO for members more than 350', 'Hi', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'LASO for members more than 700', 'Med', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'LASO for members more than 100', 'Low', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Homecoming for members more than 1500', 'Hi', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Homecoming for members more than 800', 'Med', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Homecoming for members more than 150', 'Low', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Homecoming for members more than 350', 'Hi', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Homecoming for members more than 700', 'Med', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Homecoming for members more than 100', 'Low', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Spring fest for members more than 1500', 'Hi', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Spring fest for members more than 800', 'Med', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Spring fest for members more than 150', 'Low', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Spring fest for members more than 350', 'Hi', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Spring fest for members more than 700', 'Med', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Spring fest for members more than 100', 'Low', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Barbeque for members more than 1500', 'Hi', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Barbeque for members more than 800', 'Med', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Barbeque for members more than 150', 'Low', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Barbeque for members more than 350', 'Hi', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Barbeque for members more than 700', 'Med', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Barbeque for members more than 100', 'Low', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Halloween for members more than 1500', 'Hi', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Halloween for members more than 800', 'Med', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Halloween for members more than 150', 'Low', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Halloween for members more than 350', 'Hi', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Halloween for members more than 700', 'Med', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Halloween for members more than 100', 'Low', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Career fair Fall for members more than 1500', 'Hi', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Career fair Fall for members more than 800', 'Med', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Career fair Fall for members more than 150', 'Low', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Career fair Fall for members more than 350', 'Hi', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Career fair Fall for members more than 700', 'Med', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Career fair Fall for members more than 100', 'Low', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Career fair Spring for members more than 1500', 'Hi', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Career fair Spring for members more than 800', 'Med', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Career fair Spring for members more than 150', 'Low', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Career fair Spring for members more than 350', 'Hi', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Career fair Spring for members more than 700', 'Med', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Career fair Spring for members more than 100', 'Low', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Workshop for members more than 1500', 'Hi', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Workshop for members more than 800', 'Med', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Workshop for members more than 150', 'Low', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Workshop for members more than 350', 'Hi', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Workshop for members more than 700', 'Med', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Workshop for members more than 100', 'Low', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Seminar for members more than 1500', 'Hi', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Seminar for members more than 800', 'Med', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Seminar for members more than 150', 'Low', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Seminar for members more than 350', 'Hi', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Seminar for members more than 700', 'Med', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Seminar for members more than 100', 'Low', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Navrarti for members more than 1500', 'Hi', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Navrarti for members more than 800', 'Med', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Navrarti for members more than 150', 'Low', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Navrarti for members more than 350', 'Hi', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Navrarti for members more than 700', 'Med', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Navrarti for members more than 100', 'Low', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Trash2Treasure for members more than 1500', 'Hi', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Trash2Treasure for members more than 800', 'Med', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Trash2Treasure for members more than 150', 'Low', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Trash2Treasure for members more than 350', 'Hi', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Trash2Treasure for members more than 700', 'Med', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Trash2Treasure for members more than 100', 'Low', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day1 for members more than 1500', 'Hi', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day1 for members more than 800', 'Med', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day1 for members more than 150', 'Low', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day1 for members more than 350', 'Hi', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day1 for members more than 700', 'Med', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day1 for members more than 100', 'Low', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day2 for members more than 1500', 'Hi', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day2 for members more than 800', 'Med', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day2 for members more than 150', 'Low', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day2 for members more than 350', 'Hi', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day2 for members more than 700', 'Med', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day2 for members more than 100', 'Low', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day3 for members more than 1500', 'Hi', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day3 for members more than 800', 'Med', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day3 for members more than 150', 'Low', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day3 for members more than 350', 'Hi', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day3 for members more than 700', 'Med', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day3 for members more than 100', 'Low', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day4 for members more than 1500', 'Hi', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day4 for members more than 800', 'Med', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day4 for members more than 150', 'Low', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day4 for members more than 350', 'Hi', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day4 for members more than 700', 'Med', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day4 for members more than 100', 'Low', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day5 for members more than 1500', 'Hi', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day5 for members more than 800', 'Med', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day5 for members more than 150', 'Low', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day5 for members more than 350', 'Hi', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day5 for members more than 700', 'Med', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day5 for members more than 100', 'Low', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day6 for members more than 1500', 'Hi', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day6 for members more than 800', 'Med', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day6 for members more than 150', 'Low', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day6 for members more than 350', 'Hi', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day6 for members more than 700', 'Med', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Day6 for members more than 100', 'Low', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'GaneshChaturthi for members more than 1500', 'Hi', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'GaneshChaturthi for members more than 800', 'Med', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'GaneshChaturthi for members more than 150', 'Low', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'GaneshChaturthi for members more than 350', 'Hi', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'GaneshChaturthi for members more than 700', 'Med', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'GaneshChaturthi for members more than 100', 'Low', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring Day1 for members more than 1500', 'Hi', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring Day1 for members more than 800', 'Med', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring Day1 for members more than 150', 'Low', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring Day1 for members more than 350', 'Hi', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring  Day1 for members more than 700', 'Med', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring  Day1 for members more than 100', 'Low', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring  Day2 for members more than 1500', 'Hi', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring  Day2 for members more than 800', 'Med', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring  Day2 for members more than 150', 'Low', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring  Day2 for members more than 350', 'Hi', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring  Day2 for members more than 700', 'Med', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring  Day2 for members more than 100', 'Low', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring  Day3 for members more than 1500', 'Hi', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring Day3 for members more than 800', 'Med', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring Day3 for members more than 150', 'Low', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring Day3 for members more than 350', 'Hi', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring Day3 for members more than 700', 'Med', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring Day3 for members more than 100', 'Low', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring Day4 for members more than 1500', 'Hi', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring Day4 for members more than 800', 'Med', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring Day4 for members more than 150', 'Low', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring Day4 for members more than 350', 'Hi', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring Day4 for members more than 700', 'Med', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring Day4 for members more than 100', 'Low', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring Day5 for members more than 1500', 'Hi', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring Day5 for members more than 800', 'Med', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring Day5 for members more than 150', 'Low', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring Day5 for members more than 350', 'Hi', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring Day5 for members more than 700', 'Med', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring Day5 for members more than 100', 'Low', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring Day6 for members more than 1500', 'Hi', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring Day6 for members more than 800', 'Med', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring Day6 for members more than 150', 'Low', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring Day6 for members more than 350', 'Hi', 'N', 'I');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring Day6 for members more than 700', 'Med', 'Y', 'O');
            INSERT INTO witricity.Config (Config_ID, Purpose, Pattern, Booster_Req, Indoor_Outdoor) VALUES (default, 'Welcome Week Spring Day6 for members more than 100', 'Low', 'N', 'I');
            --             
            select 'After Inserting data into table Config';
			
            COMMIT;
            --
        END IF; 
        --
        END IF;
        --        
        
        --
END 
$$

--
--- Building_Master table Error Handling and data Insert
--


DELIMITER $$  

CREATE PROCEDURE Building_Master_data_insert(pdata_insert varchar(2),pdata varchar(2000),ptable_name varchar(50))

   BEGIN
      -- Declaration Section
      --
	  DECLARE l_string varchar(2000) DEFAULT NULL;
	  DECLARE l_occurences INT default 0;
	  DECLARE l_column1 varchar(200) default NULL;
      DECLARE l_column2 varchar(200) default NULL;
      DECLARE l_column3 varchar(200) default NULL;
      DECLARE l_column4 varchar(200) default NULL;
      DECLARE l_no_of_columns INT DEFAULT 0;
      DECLARE l_error_message varchar(200) default NULL;
      --
    --  DECLARE CONTINUE HANDLER FOR 1062 SELECT 'Duplicate keys error encountered while inserting data in Building_Master table' into l_error_message;
      DECLARE CONTINUE HANDLER FOR SQLEXCEPTION -- SELECT 'SQLException encountered while inserting data in Building_Master table' into l_error_message; 
	 -- DECLARE CONTINUE HANDLER FOR 1452 select 'Foreign key constraint violated while inserting data in Building_Master table' into l_error_message;
      --
     BEGIN
        --
		get diagnostics condition 1
		       
          @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
			SET @full_error = CONCAT("ERROR ", @errno, @text);
		  
		
		IF @full_error like 'ERROR 1452Cannot add or update a child row: a foreign key constraint fails%' then
		   INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('Building_Master',pdata,'Foreign key constraint violated',SYSDATE());
		END IF;
		--
		SET l_error_message =  @full_error;
		--
        INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('Building_Master',pdata,l_error_message,SYSDATE());
             commit;
        
        END;
      --
      IF pdata_insert NOT IN ('Y','N') THEN
         --
         SIGNAL SQLSTATE '45000'
         SET MESSAGE_TEXT = 'Invalid value passed to first parameter.(Valid value:Y/N)';
         INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('Building_Master',pdata,'Invalid value passed to first parameter.(Valid value:Y/N)',SYSDATE());
             commit; 
     ELSE 
      --
	  if pdata_insert = 'Y' then
	    --
        SET l_string = pdata;
	    --
        SELECT LENGTH(l_string) - LENGTH(REPLACE(l_string, '|', ''))+1 into l_occurences; 
	    --
        SELECT COUNT(*) into l_no_of_columns
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE upper(table_schema) = upper('witricity')
        AND upper(table_name) = upper(ptable_name);
        --
        IF(l_no_of_columns != l_occurences) THEN 
          SIGNAL SQLSTATE '45001'
          SET MESSAGE_TEXT = 'Insufficient data passed to the insert into table';
          --
          INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES(ptable_name,pdata,'Insufficient data passed to the insert into table',SYSDATE());
          --
          commit; 
          --   
         ELSE
             --
             SET l_column1 = SPLIT_STR(pdata,'|',1);
             SET l_column2 = SPLIT_STR(pdata,'|',2);
             SET l_column3 = SPLIT_STR(pdata,'|',3);
             SET l_column4 = SPLIT_STR(pdata,'|',4);
             -- 
             START TRANSACTION;
             -- insert a new record into table
             INSERT INTO Building_Master(Config_ID ,Purpose ,Pattern,Booster_Req,Indoor_Outdoor )
             VALUES(default,l_column2,CONVERT(l_column3, SIGNED INTEGER),CONVERT(l_column4, SIGNED INTEGER));
             -- 
             COMMIT;
             --
           END IF;
           --
       ELSE  -- Insert the bulk data using inseet statements pdata_insert = N
           --
          -- select 'Inside pdata_insert N';
             ALTER TABLE witricity.Building_Master AUTO_INCREMENT= 100100;
           
            INSERT INTO witricity.Building_Master (Building_ID, Building_Name, No_of_Floors, No_of_Rooms) VALUES ('100100', 'Northeastern 1', '6', '39');
            INSERT INTO witricity.Building_Master (Building_ID, Building_Name, No_of_Floors, No_of_Rooms) VALUES ('100200', 'Northeastern 2', '5', '43');
            INSERT INTO witricity.Building_Master (Building_ID, Building_Name, No_of_Floors, No_of_Rooms) VALUES ('100300', 'Northeastern 3', '7', '38');
            INSERT INTO witricity.Building_Master (Building_ID, Building_Name, No_of_Floors, No_of_Rooms) VALUES ('100400', 'Northeastern 4', '6', '24');
            INSERT INTO witricity.Building_Master (Building_ID, Building_Name, No_of_Floors, No_of_Rooms) VALUES ('100500', 'Northeastern 5', '5', '49');
            INSERT INTO witricity.Building_Master (Building_ID, Building_Name, No_of_Floors, No_of_Rooms) VALUES ('100600', 'Northeastern 6', '5', '36');
            INSERT INTO witricity.Building_Master (Building_ID, Building_Name, No_of_Floors, No_of_Rooms) VALUES ('100700', 'Northeastern 7', '4', '37');
            INSERT INTO witricity.Building_Master (Building_ID, Building_Name, No_of_Floors, No_of_Rooms) VALUES ('100800', 'Northeastern 8', '4', '35');
            INSERT INTO witricity.Building_Master (Building_ID, Building_Name, No_of_Floors, No_of_Rooms) VALUES ('100900', 'Northeastern 9', '4', '49');
            INSERT INTO witricity.Building_Master (Building_ID, Building_Name, No_of_Floors, No_of_Rooms) VALUES ('101000', 'Northeastern 10', '7', '31');
            INSERT INTO witricity.Building_Master (Building_ID, Building_Name, No_of_Floors, No_of_Rooms) VALUES ('101100', 'Northeastern 11', '7', '35');
            INSERT INTO witricity.Building_Master (Building_ID, Building_Name, No_of_Floors, No_of_Rooms) VALUES ('101200', 'Northeastern 12', '4', '27');
            INSERT INTO witricity.Building_Master (Building_ID, Building_Name, No_of_Floors, No_of_Rooms) VALUES ('101300', 'Northeastern 13', '6', '20');
            INSERT INTO witricity.Building_Master (Building_ID, Building_Name, No_of_Floors, No_of_Rooms) VALUES ('101400', 'Northeastern 14', '6', '46');
            INSERT INTO witricity.Building_Master (Building_ID, Building_Name, No_of_Floors, No_of_Rooms) VALUES ('101500', 'Northeastern 15', '6', '29');
            INSERT INTO witricity.Building_Master (Building_ID, Building_Name, No_of_Floors, No_of_Rooms) VALUES ('101600', 'Northeastern 16', '6', '40');
            INSERT INTO witricity.Building_Master (Building_ID, Building_Name, No_of_Floors, No_of_Rooms) VALUES ('101700', 'Northeastern 17', '4', '20');
            INSERT INTO witricity.Building_Master (Building_ID, Building_Name, No_of_Floors, No_of_Rooms) VALUES ('101800', 'Northeastern 18', '4', '21');
            INSERT INTO witricity.Building_Master (Building_ID, Building_Name, No_of_Floors, No_of_Rooms) VALUES ('101900', 'Northeastern 19', '4', '33');
            INSERT INTO witricity.Building_Master (Building_ID, Building_Name, No_of_Floors, No_of_Rooms) VALUES ('102000', 'Northeastern 20', '6', '30');
            --
            COMMIT;
            --
			select 'After Inserting data into table Building_Master';
        END IF; 
       --
       END IF;
        --
        
        --
END 
$$

--
--- Transmitter_Type_Info table Error Handling and data Insert
--



DELIMITER $$  

CREATE PROCEDURE Transmitter_Type_Info_data_insert(pdata_insert varchar(2),pdata varchar(2000),ptable_name varchar(50))

   BEGIN
      -- Declaration Section
      --
	  DECLARE l_string varchar(2000) DEFAULT NULL;
	  DECLARE l_occurences INT default 0;
	  DECLARE l_column1 varchar(200) default NULL;
      DECLARE l_column2 varchar(200) default NULL;
      DECLARE l_column3 varchar(200) default NULL;
      DECLARE l_column4 varchar(200) default NULL;
      DECLARE l_no_of_columns INT DEFAULT 0;
      DECLARE l_error_message varchar(200) default NULL;
      --
     -- DECLARE CONTINUE HANDLER FOR 1062 SELECT 'Duplicate keys error encountered while inserting data in Transmitter_Type_Info table' into l_error_message;
      DECLARE CONTINUE HANDLER FOR SQLEXCEPTION -- SELECT 'SQLException encountered while inserting data in Transmitter_Type_Info table' into l_error_message; 
	 -- DECLARE CONTINUE HANDLER FOR 1452 select 'Foreign key constraint violated while inserting data in Transmitter_Type_Info table' into l_error_message;
      --
      BEGIN
        --
		get diagnostics condition 1
		       
          @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
			SET @full_error = CONCAT("ERROR ", @errno, @text);
		  
		
		IF @full_error like 'ERROR 1452Cannot add or update a child row: a foreign key constraint fails%' then
		   INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('Transmitter_Type_Info',pdata,'Foreign key constraint violated',SYSDATE());
		END IF;
		--
		SET l_error_message =  @full_error;
		--
        INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('Transmitter_Type_Info',pdata,l_error_message,SYSDATE());
             commit;
        
        END;
      --
      IF pdata_insert NOT IN ('Y','N') THEN
         --
         SIGNAL SQLSTATE '45000'
         SET MESSAGE_TEXT = 'Invalid value passed to first parameter.(Valid value:Y/N)';
         INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('Transmitter_Type_Info',pdata,'Invalid value passed to first parameter.(Valid value:Y/N)',SYSDATE());
             commit; 
     ELSE 
	  if pdata_insert = 'Y' then
	    --
        SET l_string = pdata;
	    --
        SELECT LENGTH(l_string) - LENGTH(REPLACE(l_string, '|', ''))+1 into l_occurences; 
	    --
        SELECT COUNT(*) into l_no_of_columns
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE upper(table_schema) = upper('witricity')
        AND upper(table_name) = upper(ptable_name);
        --
        IF(l_no_of_columns != l_occurences) THEN 
          SIGNAL SQLSTATE '45001'
          SET MESSAGE_TEXT = 'Insufficient data passed to the insert into table';
          --
          INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES(ptable_name,pdata,'Insufficient data passed to the insert into table',SYSDATE());
             commit;
           --   
         ELSE
             --
             SET l_column1 = SPLIT_STR(pdata,'|',1);
             SET l_column2 = SPLIT_STR(pdata,'|',2);
             SET l_column3 = SPLIT_STR(pdata,'|',3);
             -- 
             START TRANSACTION;
             -- insert a new record into table
             INSERT INTO Transmitter_Type_Info(Description  ,Transmitter_Type ,Transmitter_Name )
             VALUES(l_column1,default,l_column3);
             -- 
             COMMIT;
             --
           END IF;
           -- 
       ELSE  -- Insert the bulk data using inseet statements pdata_insert = N
           --
          -- select 'Inside pdata_insert N';
            ALTER TABLE witricity.Transmitter_Type_Info AUTO_INCREMENT= 111;
            
            INSERT INTO witricity.Transmitter_Type_Info (Description, Transmitter_Type_ID, Transmitter_Name) VALUES ('Transmitter to be used during  low load', '111', 'Low load');
            INSERT INTO witricity.Transmitter_Type_Info (Description, Transmitter_Type_ID, Transmitter_Name) VALUES ('Transmitter to be used during medium load', '222', 'Medium load');
            INSERT INTO witricity.Transmitter_Type_Info (Description, Transmitter_Type_ID, Transmitter_Name) VALUES ('Transmitter to be used during high load', '333', 'High load');
            --
             COMMIT;
            --
			select 'After Inserting data into table Transmitter_Type_Info';
        END IF; 
       --
       END IF;
       --
       
       --
END 
$$

--
--- Room_Master  table Error Handling and data Insert
--


DELIMITER $$  

CREATE PROCEDURE Room_Master_data_insert(pdata_insert varchar(2),pdata varchar(2000),ptable_name varchar(50))

   BEGIN
      -- Declaration Section
      --
	  DECLARE l_string varchar(2000) DEFAULT NULL;
	  DECLARE l_occurences INT default 0;
	  DECLARE l_column1 varchar(200) default NULL;
      DECLARE l_column2 varchar(200) default NULL;
      DECLARE l_column3 varchar(200) default NULL;
      DECLARE l_column4 varchar(200) default NULL;
      DECLARE l_no_of_columns INT DEFAULT 0;
      DECLARE l_error_message varchar(200) default NULL;
      
    --  DECLARE CONTINUE HANDLER FOR 1062 SELECT 'Duplicate keys error encountered while inserting data in Room_Master table' into l_error_message;
      DECLARE CONTINUE HANDLER FOR SQLEXCEPTION -- SELECT 'SQLException encountered while inserting data in Room_Master table' into l_error_message; 
	 -- DECLARE CONTINUE HANDLER FOR 1452 select 'Foreign key constraint violated while inserting data in Room_Master table' into l_error_message;
      --
      BEGIN
        --
		get diagnostics condition 1
		       
          @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
			SET @full_error = CONCAT("ERROR ", @errno, @text);
		  
		
		IF @full_error like 'ERROR 1452Cannot add or update a child row: a foreign key constraint fails%' then
		   INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('Room_Master',pdata,'Foreign key constraint violated',SYSDATE());
		END IF;
		--
		SET l_error_message =  @full_error;
		--
        INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('Room_Master',pdata,l_error_message,SYSDATE());
             commit;
        
        END;
      --
      IF pdata_insert NOT IN ('Y','N') THEN
         --
         SIGNAL SQLSTATE '45000'
         SET MESSAGE_TEXT = 'Invalid value passed to first parameter.(Valid value:Y/N)';
         INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('Room_Master',pdata,'Invalid value passed to first parameter.(Valid value:Y/N)',SYSDATE());
             commit; 
     ELSE 
      --
	  if pdata_insert = 'Y' then
	    --
        SET l_string = pdata;
	    --
        SELECT LENGTH(l_string) - LENGTH(REPLACE(l_string, '|', ''))+1 into l_occurences; 
	    --
        SELECT COUNT(*) into l_no_of_columns
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE upper(table_schema) = upper('witricity')
        AND upper(table_name) = upper(ptable_name);
        --
        IF(l_no_of_columns != l_occurences) THEN 
          SIGNAL SQLSTATE '45000'
          SET MESSAGE_TEXT = 'Insufficient data passed to the insert into table';
          --
          INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES(ptable_name,pdata,'Insufficient data passed to the insert into table',SYSDATE());
             commit; 
         ELSE
             --
             SET l_column1 = SPLIT_STR(pdata,'|',1);
             SET l_column2 = SPLIT_STR(pdata,'|',2);
             SET l_column3 = SPLIT_STR(pdata,'|',3);
             SET l_column4 = SPLIT_STR(pdata,'|',4);
             -- 
             START TRANSACTION;
             -- insert a new record into table
             INSERT INTO Room_Master(Room_ID,Building_ID,Description,Capacity  )
             VALUES(default,CONVERT(l_column2, SIGNED INTEGER),l_column3,CONVERT(l_column4, SIGNED INTEGER));
             -- 
             COMMIT;
             --
           END IF;
           --
       ELSE  -- Insert the bulk data using inseet statements pdata_insert = N
           --
          -- select 'Inside pdata_insert N';
             ALTER TABLE witricity.Room_Master AUTO_INCREMENT=100110;
             
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '100100', 'Library', '50');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '100100', 'Server Room', '50');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '100100', 'Library', '50');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '100100', 'Library', '50');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '100100', 'Library', '70');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '100200', 'Library', '70');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '100200', 'Library', '70');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '100200', 'Server Room', '50');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '100200', 'Server Room', '50');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '100200', 'Server Room', '50');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '100300', 'Classroom', '50');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '100300', 'Auditorium', '300');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '100300', 'Classroom', '50');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '100300', 'Classroom', '50');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '100300', 'Classroom', '50');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '100400', 'Classroom', '50');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '100400', 'Classroom', '50');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '100400', 'Classroom', '50');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '100400', 'Classroom', '50');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '100400', 'Classroom', '50');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '100500', 'Classroom', '50');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '100500', 'Classroom', '50');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '100500', 'Classroom', '50');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '100500', 'Auditorium', '200');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '100500', 'Auditorium', '100');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '100600', 'Auditorium', '100');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '100600', 'Auditorium', '300');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '100600', 'Auditorium', '250');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '100600', 'Classroom', '50');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '100600', 'Classroom', '70');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '100700', 'Classroom', '70');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '100700', 'Classroom', '30');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '100700', 'Classroom', '30');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '100700', 'Classroom', '50');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '100700', 'Classroom', '50');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '100800', 'Classroom', '50');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '100800', 'Classroom', '50');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '100800', 'Classroom', '50');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '100800', 'Classroom', '50');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '100800', 'Classroom', '50');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '100900', 'Classroom', '50');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '100900', 'Classroom', '50');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '100900', 'Classroom', '50');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '100900', 'Classroom', '50');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '100900', 'Classroom', '50');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '101000', 'Auditorium', '200');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '101000', 'Classroom', '70');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '101000', 'Classroom', '30');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '101000', 'Classroom', '30');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '101000', 'Classroom', '50');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '101100', 'Classroom', '30');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '101100', 'Classroom', '30');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '101100', 'Classroom', '20');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '101100', 'Classroom', '40');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '101100', 'Classroom', '30');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '101200', 'Classroom', '50');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '101200', 'Auditorium', '150');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '101200', 'Classroom', '40');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '101200', 'Classroom', '50');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '101200', 'Classroom', '50');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '101300', 'Classroom', '70');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '101300', 'Classroom', '40');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '101300', 'Classroom', '40');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '101300', 'Classroom', '40');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '101300', 'Classroom', '40');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '101400', 'Auditorium', '200');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '101400', 'Auditorium', '200');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '101400', 'Classroom', '50');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '101400', 'Classroom', '40');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '101400', 'Classroom', '50');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '101500', 'Classroom', '50');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '101500', 'Classroom', '70');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '101500', 'Classroom', '50');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '101500', 'Classroom', '50');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '101500', 'Classroom', '70');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '101600', 'Classroom', '50');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '101600', 'Classroom', '70');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '101600', 'Classroom', '50');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '101600', 'Classroom', '50');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '101600', 'Auditorium', '250');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '101700', 'Auditorium', '200');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '101700', 'Classroom', '40');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '101700', 'Classroom', '30');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '101700', 'Auditorium', '150');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '101700', 'Classroom', '40');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '101800', 'Classroom', '50');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '101800', 'Classroom', '50');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '101800', 'Classroom', '50');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '101800', 'Classroom', '50');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '101800', 'Classroom', '50');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '101900', 'Classroom', '50');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '101900', 'Classroom', '50');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '101900', 'Classroom', '50');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '101900', 'Classroom', '50');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '101900', 'Auditorium', '100');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '102000', 'Classroom', '30');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '102000', 'Classroom', '30');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '102000', 'Classroom', '30');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '102000', 'Auditorium', '100');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '102000', 'Classroom', '30');
            INSERT INTO witricity.Room_Master (Room_ID, Building_ID, Description, Capacity) VALUES (default, '102000', 'Classroom', '30');
            COMMIT;
            select 'After Inserting data in Room_Master';
        END IF; 
      --
     END IF;      
        
        --     
END 
$$


--
--- UserType_Validity  table Error Handling and data Insert
--



DELIMITER $$  

CREATE PROCEDURE UserType_Validity_data_insert(pdata_insert varchar(2),pdata varchar(2000),ptable_name varchar(50))

   BEGIN
      -- Declaration Section
      --
	  DECLARE l_string varchar(2000) DEFAULT NULL;
	  DECLARE l_occurences INT default 0;
	  DECLARE l_column1 varchar(200) default NULL;
      DECLARE l_column2 varchar(200) default NULL;
      DECLARE l_no_of_columns INT DEFAULT 0;
      DECLARE l_error_message varchar(200) default NULL;
      
    --  DECLARE CONTINUE HANDLER FOR 1062 SELECT 'Duplicate keys error encountered while inserting data in UserType_Validity table' into l_error_message;
      DECLARE CONTINUE HANDLER FOR SQLEXCEPTION  -- SELECT 'SQLException encountered while inserting data in UserType_Validity table' into l_error_message; 
	--  DECLARE CONTINUE HANDLER FOR 1452 select 'Foreign key constraint violated while inserting data in UserType_Validity table' into l_error_message;
      --
      BEGIN
        --
		get diagnostics condition 1
		       
          @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
			SET @full_error = CONCAT("ERROR ", @errno, @text);
		  
		
		IF @full_error like 'ERROR 1452Cannot add or update a child row: a foreign key constraint fails%' then
		   INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('UserType_Validity',pdata,'Foreign key constraint violated',SYSDATE());
		END IF;
		--
		SET l_error_message =  @full_error;
		--
        INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('UserType_Validity',pdata,l_error_message,SYSDATE());
             commit;
        
        END;
      --
      IF pdata_insert NOT IN ('Y','N') THEN
         --
         SIGNAL SQLSTATE '45000'
         SET MESSAGE_TEXT = 'Invalid value passed to first parameter.(Valid value:Y/N)';
         INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('UserType_Validity',pdata,'Invalid value passed to first parameter.(Valid value:Y/N)',SYSDATE());
             commit; 
     ELSE 
	  if pdata_insert = 'Y' then
	    --
        SET l_string = pdata;
	    --
        SELECT LENGTH(l_string) - LENGTH(REPLACE(l_string, '|', ''))+1 into l_occurences; 
	    --
        SELECT COUNT(*) into l_no_of_columns
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE upper(table_schema) = upper('witricity')
        AND upper(table_name) = upper(ptable_name);
        --
        IF(l_no_of_columns != l_occurences) THEN 
          SIGNAL SQLSTATE '45001'
          SET MESSAGE_TEXT = 'Insufficient data passed to the insert into table';
          --
          INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES(ptable_name,pdata,'Insufficient data passed to the insert into table',SYSDATE());
             commit; 
         ELSE
             --
             SET l_column1 = SPLIT_STR(pdata,'|',1);
             SET l_column2 = SPLIT_STR(pdata,'|',2);
             -- 
              select 'Inside pdata_insert Y6' ;
           
             START TRANSACTION;
             -- insert a new record into table
             INSERT INTO UserType_Validity(User_type,Validity)
             VALUES(l_column1,CONVERT(l_column2, SIGNED INTEGER));
             -- 
             COMMIT;
             --
           END IF;
           --
       ELSE  -- Insert the bulk data using inseet statements pdata_insert = N
           --
            INSERT INTO witricity.UserType_Validity (User_type, Validity) VALUES ('Student', 360);
            INSERT INTO witricity.UserType_Validity (User_type, Validity) VALUES ('Professor', 999);
            INSERT INTO witricity.UserType_Validity (User_type, Validity) VALUES ('Staff', 720);
            INSERT INTO witricity.UserType_Validity (User_type, Validity) VALUES ('Admin', 999);
            --
            COMMIT;
             select 'After Inserting data UserType_Validity';
            
        END IF; 
      --
      END IF;
      --      
      
      --
END 
$$

--
--- Alert_Master  table Error Handling and data Insert
--



DELIMITER $$  

CREATE PROCEDURE Alert_Master_data_insert(pdata_insert varchar(2),pdata varchar(2000),ptable_name varchar(50))

   BEGIN
      -- Declaration Section
      --
	  DECLARE l_string varchar(2000) DEFAULT NULL;
	  DECLARE l_occurences INT default 0;
	  DECLARE l_column1 varchar(200) default NULL;
      DECLARE l_column2 varchar(200) default NULL;
      DECLARE l_column3 varchar(200) default NULL;
      DECLARE l_no_of_columns INT DEFAULT 0;
      DECLARE l_error_message varchar(200) default NULL;
      --
     -- DECLARE CONTINUE HANDLER FOR 1062 SELECT 'Duplicate keys error encountered while inserting data in Alert_Master table' into l_error_message;
      DECLARE CONTINUE HANDLER FOR SQLEXCEPTION -- SELECT 'SQLException encountered while inserting data in Alert_Master table' into l_error_message; 
	--  DECLARE CONTINUE HANDLER FOR 1452 select 'Foreign key constraint violated while inserting data in Alert_Master table' into l_error_message;
      --
      BEGIN
        --
		get diagnostics condition 1
		       
          @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
			SET @full_error = CONCAT("ERROR ", @errno, @text);
		  
		
		IF @full_error like 'ERROR 1452Cannot add or update a child row: a foreign key constraint fails%' then
		   INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('Alert_Master',pdata,'Foreign key constraint violated',SYSDATE());
		END IF;
		--
		SET l_error_message =  @full_error;
		--
        INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('Alert_Master',pdata,l_error_message,SYSDATE());
             commit;
        
        END;
      --
      IF pdata_insert NOT IN ('Y','N') THEN
         --
         SIGNAL SQLSTATE '45000'
         SET MESSAGE_TEXT = 'Invalid value passed to first parameter.(Valid value:Y/N)';
         INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('Alert_Master,pdata','Invalid value passed to first parameter.(Valid value:Y/N)',SYSDATE());
             commit; 
     ELSE 
	  if pdata_insert = 'Y' then
	    --
        SET l_string = pdata;
	    --
        SELECT LENGTH(l_string) - LENGTH(REPLACE(l_string, '|', ''))+1 into l_occurences; 
	    --
        SELECT COUNT(*) into l_no_of_columns
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE upper(table_schema) = upper('witricity')
        AND upper(table_name) = upper(ptable_name);
        --
        IF(l_no_of_columns != l_occurences) THEN 
          SIGNAL SQLSTATE '45000'
          SET MESSAGE_TEXT = 'Insufficient data passed to the insert into table';
          --
          INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES(ptable_name,pdata,'Insufficient data passed to the insert into table',SYSDATE());
             commit; 
         ELSE
             --
             SET l_column1 = SPLIT_STR(pdata,'|',1);
             SET l_column2 = SPLIT_STR(pdata,'|',2);
             SET l_column3 = SPLIT_STR(pdata,'|',3);
             --
             START TRANSACTION;
             -- insert a new record into table
             INSERT INTO Alert_Master(Alert_ID,Message,Type)
             VALUES(default,l_column2,l_column3);
             -- 
             COMMIT;
             --
           END IF;
           --
       ELSE  -- Insert the bulk data using inseet statements pdata_insert = N
           --
           ALTER TABLE witricity.Alert_Master AUTO_INCREMENT=7000;
           
            INSERT INTO witricity.Alert_Master (Alert_ID, Message, Type) VALUES (default, 'User Consumption Limit Exceeded Please Renew Subscription', 'Consumption');
            INSERT INTO witricity.Alert_Master (Alert_ID, Message, Type) VALUES (default, 'Validity Ended Please Renew Subscription', 'Validity');
            INSERT INTO witricity.Alert_Master (Alert_ID, Message, Type) VALUES (default, 'Consumpion Limit Covered 50 %', 'Consumption');
            INSERT INTO witricity.Alert_Master (Alert_ID, Message, Type) VALUES (default, 'Validity End Date is one week away', 'Validity');
            INSERT INTO witricity.Alert_Master (Alert_ID, Message, Type) VALUES (default, 'Consumption Limit Covered 60%', 'Consumption');
            INSERT INTO witricity.Alert_Master (Alert_ID, Message, Type) VALUES (default, 'Validity End Date is one month away', 'Validity');
            INSERT INTO witricity.Alert_Master (Alert_ID, Message, Type) VALUES (default, 'Consumption Limit Covered 70%', 'Consumption');
            INSERT INTO witricity.Alert_Master (Alert_ID, Message, Type) VALUES (default, 'Validity End Date is two months away', 'Validity');
            INSERT INTO witricity.Alert_Master (Alert_ID, Message, Type) VALUES (default, 'Consumption Limit Covered 80 %', 'Consumption');
            INSERT INTO witricity.Alert_Master (Alert_ID, Message, Type) VALUES (default, 'Validity End Date is Three Months away', 'Validity');
            INSERT INTO witricity.Alert_Master (Alert_ID, Message, Type) VALUES (default, 'Consumption Limit Covered 90%', 'Consumption');
            INSERT INTO witricity.Alert_Master (Alert_ID, Message, Type) VALUES (default, 'Validity End Date is four months away', 'Validity');
            INSERT INTO witricity.Alert_Master (Alert_ID, Message, Type) VALUES (default, 'Consumption Limit Covered 95 %', 'Consumption');
            INSERT INTO witricity.Alert_Master (Alert_ID, Message, Type) VALUES (default, 'Validity End Date is 5 Months away', 'Validity');
            INSERT INTO witricity.Alert_Master (Alert_ID, Message, Type) VALUES (default, 'Consumption Limit Covered 40 %', 'Consumption');
            INSERT INTO witricity.Alert_Master (Alert_ID, Message, Type) VALUES (default, 'Validity Ends Tomorrow', 'Validity');
            INSERT INTO witricity.Alert_Master (Alert_ID, Message, Type) VALUES (default, 'Consumption Limit Covered 30 %', 'Consumption');
            INSERT INTO witricity.Alert_Master (Alert_ID, Message, Type) VALUES (default, 'Guest Validity Ended - Please use new Login Credentials', 'Validity');
            INSERT INTO witricity.Alert_Master (Alert_ID, Message, Type) VALUES (default, 'Consumption Limit Reached 20 % ', 'Consumption');
            INSERT INTO witricity.Alert_Master (Alert_ID, Message, Type) VALUES (default, 'Guest Consumption Limit Reached - Please use new login Credentials', 'Consumption');
            --
            select 'After inserting records in table Alert_Master';             
             COMMIT;
             --
        END IF; 
        --
       END IF;
       --
       
       --
END 
$$

--
--- User_privileges  table Error Handling and data Insert
--



DELIMITER $$  

CREATE PROCEDURE User_privileges_data_insert(pdata_insert varchar(2),pdata varchar(2000),ptable_name varchar(50))

   BEGIN
      -- Declaration Section
      --
	  DECLARE l_string varchar(2000) DEFAULT NULL;
	  DECLARE l_occurences INT default 0;
	  DECLARE l_column1 varchar(200) default NULL;
      DECLARE l_column2 varchar(200) default NULL;
      DECLARE l_column3 varchar(200) default NULL;
      DECLARE l_column4 varchar(200) default NULL;
      DECLARE l_no_of_columns INT DEFAULT 0;
      DECLARE l_error_message varchar(200) default NULL;
      
    --  DECLARE CONTINUE HANDLER FOR 1062 SELECT 'Duplicate keys error encountered while inserting data in User_privileges table' into l_error_message;
      DECLARE CONTINUE HANDLER FOR SQLEXCEPTION -- SELECT 'SQLException encountered while inserting data in User_privileges table' into l_error_message; 
	--  DECLARE CONTINUE HANDLER FOR 1452 select 'Foreign key constraint violated while inserting data in User_privileges table' into l_error_message;
      --
      BEGIN
        --
		get diagnostics condition 1
		       
          @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
			SET @full_error = CONCAT("ERROR ", @errno, @text);
		  
		
		IF @full_error like 'ERROR 1452Cannot add or update a child row: a foreign key constraint fails%' then
		   INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('User_privileges',pdata,'Foreign key constraint violated',SYSDATE());
		END IF;
		--
		IF @full_error like 'ERROR 10626%' then
		   INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('User_privileges',pdata,'Primary key constraint violated',SYSDATE());
		END IF;
		--
		SET l_error_message =  @full_error;
		--
        INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('User_privileges',pdata,l_error_message,SYSDATE());
             commit;
        
        END;
      --
      IF pdata_insert NOT IN ('Y','N') THEN
         --
         SIGNAL SQLSTATE '45000'
         SET MESSAGE_TEXT = 'Invalid value passed to first parameter.(Valid value:Y/N)';
         INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('User_privileges',pdata,'Invalid value passed to first parameter.(Valid value:Y/N)',SYSDATE());
             commit; 
     ELSE 
	  if pdata_insert = 'Y' then
	    --
        SET l_string = pdata;
	    --
        SELECT LENGTH(l_string) - LENGTH(REPLACE(l_string, '|', ''))+1 into l_occurences; 
	    --
        SELECT COUNT(*) into l_no_of_columns
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE upper(table_schema) = upper('witricity')
        AND upper(table_name) = upper(ptable_name);
        -- 
         IF(l_no_of_columns != l_occurences) THEN 
          SIGNAL SQLSTATE '45001'
          SET MESSAGE_TEXT = 'Insufficient data passed to the insert into table';
          --
          INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES(ptable_name,pdata,'Insufficient data passed to the insert into table',SYSDATE());
             commit; 
           --  
         ELSE
             --
             SET l_column1 = SPLIT_STR(pdata,'|',1);
             SET l_column2 = SPLIT_STR(pdata,'|',2);
             SET l_column3 = SPLIT_STR(pdata,'|',3);
             SET l_column4 = SPLIT_STR(pdata,'|',4);
             -- 
             START TRANSACTION;
             -- insert a new record into table
             INSERT INTO User_privileges(User_ID,User_type,Valladity_end_date,User_Consumption_Limit)
             VALUES(l_column1,l_column2,CONVERT(l_column3, DATE),l_column4);
             -- 
             COMMIT;
             --
           END IF;
           --
       ELSE  -- Insert the bulk data using inseet statements pdata_insert = N
             --
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('ranjan.v@husky.neu.edu', 'Admin', '20170716', '4000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('survu.s@husky.neu.edu', 'Professor', '20170111', '8000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('reema.d@husky.ney.edu', 'Professor', '20171206', '8000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('archana.c@husky.neu.edu', 'Admin', '20171103', '4000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('vandhana.t@husky.neu.edu', 'Professor', '20171001', '8000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('john.k@husky.neu.edu', 'Admin', '20170226', '4000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('charles.c@husky.neu.edu', 'Professor', '20161120', '8000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('tim.c@husky.neu.edu', 'Professor', '20171126', '8000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('linda.r@husky.neu.edu', 'Student', '20171128', '1000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('cameron.p@husky.neu.edu', 'Admin', '20160709', '4000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('kumar.s@husky.neu.edu', 'Professor', '20170726', '8000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('kevin.s@husky.neu.edu', 'Staff', '20170728', '5000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('mary.g@husky.neu.edu', 'Staff', '20170926', '5000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('tess.b@husky.neu.edu', 'Student', '20161020', '1000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('catherine.t@husky.neu.edu', 'Professor', '20160108', '8000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('vimal.n@husky.neu.edu', 'Staff', '20171452', '5000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Johana.a@husky.neu.edu', 'Student', '20171002', '1000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Sherri.s@husky.neu.edu', 'Staff', '20160710', '5000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Michaela.d@husky.neu.edu', 'Student', '20170323', '1000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Song.c@husky.neu.edu', 'Student', '20170719', '1000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Ileana.x@husky.neu.edu', 'Admin', '20170715', '4000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('May.d@husky.neu.edu', 'Student', '20170515', '1000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Anne.f@husky.neu.edu', 'Student', '20160823', '1000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Sharolyn.r@husky.neu.edu', 'Staff', '20161026', '5000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Marissa.e@husky.neu.edu', 'Student', '20170420', '1000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Annamaria.d@husky.neu.edu', 'Admin', '20170610', '4000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Ursula.s@husky.neu.edu', 'Student', '20161017', '1000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Leonardo.c@husky.neu.edu', 'Staff', '20171101', '5000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Annelle.v@husky.neu.edu', 'Admin', '20170523', '4000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Johnnie.b@husky.neu.edu', 'Student', '20161212', '1000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Charley.n@husky.neu.edu', 'Staff', '20170129', '5000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Lacresha.h@husky.neu.edu', 'Professor', '20171117', '8000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Eliza.g@husky.neu.edu', 'Admin', '20160811', '4000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Fernando.t@husky.neu.edu', 'Staff', '20170107', '5000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Graig.y@husky.neu.edu', 'Student', '20171110', '1000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Alyson.r@husky.neu.edu', 'Student', '20170325', '1000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Carl.d@husky.neu.edu', 'Student', '20161022', '1000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Allene.e@husky.neu.edu', 'Professor', '20161213', '8000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Diane.w@husky.neu.edu', 'Student', '20171007', '1000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Janice.s@husky.neu.edu', 'Staff', '20170827', '5000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Mina.v@husky.neu.edu', 'Student', '20161019', '1000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Karole.b@husky.neu.edu', 'Admin', '20170306', '4000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Chiquita.g@husky.neu.edu', 'Student', '20160508', '1000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Sallie.h@husky.neu.edu', 'Professor', '20170213', '8000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Verlene.y@husky.neu.edu', 'Student', '20170817', '1000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Marlon.u@husky.neu.edu', 'Student', '20170523', '1000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Henriette.t@husky.neu.edu', 'Admin', '20160108', '4000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Micha.f@husky.neu.edu', 'Student', '20160609', '1000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Yuette.r@husky.neu.edu', 'Admin', '20161219', '4000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Lena.i@husky.neu.edu', 'Professor', '20170621', '8000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Alysa.o@husky.neu.edu', 'Student', '20170729', '1000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Rosena.p@husky.neu.edu', 'Admin', '20170626', '4000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Mercedes.l@husky.neu.edu', 'Professor', '20170801', '8000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Linette.k@husky.neu.edu', 'Student', '20171019', '1000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Steve.m@husky.neu.edu', 'Admin', '20160821', '4000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Kimbery.j@husky.neu.edu', 'Professor', '20161014', '8000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Myrna.h@husky.neu.edu', 'Student', '20170814', '1000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Rochelle.n@husky.neu.edu', 'Professor', '20170827', '8000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Katina.b@husky.neu.edu', 'Student', '20170425', '1000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Jessika.v@husky.neu.edu', 'Admin', '20170703', '4000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Syreeta.f@husky.neu.edu', 'Student', '20171208', '1000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Lona.g@husky.neu.edu', 'Student', '20170510', '1000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Drew.t@husky.neu.edu', 'Student', '20170224', '1000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Jayna.r@husky.neu.edu', 'Staff', '20170616', '5000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Tarra.c@husky.neu.edu', 'Admin', '20170310', '4000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Tegan.d@husky.neu.edu', 'Student', '20170227', '1000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Armando.a@husky.neu.edu', 'Student', '20160814', '1000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Wyatt.s@husky.neu.edu', 'Student', '20170127', '1000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Daina.d@husky.neu.edu', 'Professor', '20170625', '8000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Angelo.c@husky.neu.edu', 'Professor', '20170502', '8000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Arthur.x@husky.neu.edu', 'Admin', '20170719', '4000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Leighann.d@husky.neu.edu', 'Student', '20160918', '1000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Aileen.f@husky.neu.edu', 'Staff', '20161212', '5000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Carlie.r@husky.neu.edu', 'Staff', '20170102', '5000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Marcelina.e@husky.neu.edu', 'Student', '20171119', '1000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Julissa.d@husky.neu.edu', 'Staff', '20160817', '5000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Tracy.s@husky.neu.edu', 'Admin', '20170905', '4000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Jade.c@husky.neu.edu', 'Student', '20171013', '1000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Ivory.v@husky.neu.edu', 'Student', '20161222', '1000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Spencer.b@husky.neu.edu', 'Student', '20170729', '1000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Classie.n@husky.neu.edu', 'Staff', '20160915', '5000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Clarissa.h@husky.neu.edu', 'Professor', '20171230', '8000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Isaiah.g@husky.neu.edu', 'Admin', '20160919', '4000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Merissa.t@husky.neu.edu', 'Student', '20170211', '1000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Shaina.y@husky.neu.edu', 'Professor', '20171001', '8000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Carmella.r@husky.neu.edu', 'Student', '20171031', '1000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Chieko.d@husky.neu.edu', 'Admin', '20170111', '4000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Johnna.e@husky.neu.edu', 'Staff', '20170730', '5000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Gregoria.w@husky.neu.edu', 'Professor', '20160924', '8000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Jone.s@husky.neu.edu', 'Admin', '20170211', '4000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Bernadine.v@husky.neu.edu', 'Student', '20160109', '1000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Marylou.b@husky.neu.edu', 'Student', '20170531', '1000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Lacy.g@husky.neu.edu', 'Professor', '20171129', '8000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Laurice.h@husky.neu.edu', 'Admin', '20170609', '4000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Ena.y@husky.neu.edu', 'Student', '20170220', '1000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('Mimi.u@husky.neu.edu', 'Staff', '20170517', '5000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('casey.j@husky.neu.edu', 'Professor', '20171210', '8000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('logan.c@husky.neu.edu', 'Admin', '20170220', '4000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('raj.s@husky.neu.edu', 'Student', '20161116', '1000');
            INSERT INTO witricity.User_privileges (User_ID, User_type, Valladity_end_date, User_Consumption_Limit) VALUES ('mark.t@husky.neu.edu', 'Student', '20170920', '1000');
            --
            select 'After Inserting data in table User_privileges';
             
             COMMIT;
            
        END IF; 
       --
       END IF;
       --       
       
       --
 
END 
$$

--
--- Login  table Error Handling and data Insert
--



DELIMITER $$  

CREATE PROCEDURE Login_data_insert(pdata_insert varchar(2),pdata varchar(2000),ptable_name varchar(50))

   BEGIN
      -- Declaration Section
      --
	  DECLARE l_string varchar(2000) DEFAULT NULL;
	  DECLARE l_occurences INT default 0;
	  DECLARE l_column1 varchar(200) default NULL;
      DECLARE l_column2 varchar(200) default NULL;
      DECLARE l_column3 varchar(200) default NULL;
      DECLARE l_column4 varchar(200) default NULL;
      DECLARE l_no_of_columns INT DEFAULT 0;
      DECLARE l_error_message varchar(200) default NULL;
      
    --  DECLARE CONTINUE HANDLER FOR 1062 SELECT 'Duplicate keys error encountered while inserting data in Login table' into l_error_message;
      DECLARE CONTINUE HANDLER FOR SQLEXCEPTION -- SELECT 'SQLException encountered while inserting data in Login table' into l_error_message; 
	--  DECLARE CONTINUE HANDLER FOR 1452 select 'Foreign key constraint violated while inserting data in Login table' into l_error_message;
      --
      BEGIN
        --
		get diagnostics condition 1
		       
          @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
			SET @full_error = CONCAT("ERROR ", @errno, @text);
		  
		
		IF @full_error like 'ERROR 1452Cannot add or update a child row: a foreign key constraint fails%' then
		   INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('Login',pdata,'Foreign key constraint violated',SYSDATE());
		END IF;
		--
		SET l_error_message =  @full_error;
		--
        INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('Login',pdata,l_error_message,SYSDATE());
             commit;
        
        END;
      --
     IF pdata_insert NOT IN ('Y','N') THEN
         --
         SIGNAL SQLSTATE '45000'
         SET MESSAGE_TEXT = 'Invalid value passed to first parameter.(Valid value:Y/N)';
         INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('Login',pdata,'Invalid value passed to first parameter.(Valid value:Y/N)',SYSDATE());
             commit; 
     ELSE 
	  if pdata_insert = 'Y' then
	    --
        SET l_string = pdata;
	    --
        SELECT LENGTH(l_string) - LENGTH(REPLACE(l_string, '|', ''))+1 into l_occurences; 
	    --
        SELECT COUNT(*) into l_no_of_columns
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE upper(table_schema) = upper('witricity')
        AND upper(table_name) = upper(ptable_name);
        --
         IF(l_no_of_columns != l_occurences) THEN 
          SIGNAL SQLSTATE '45000'
          SET MESSAGE_TEXT = 'Insufficient data passed to the insert into table';
          --
          INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES(ptable_name,pdata,'Insufficient data passed to the insert into table',SYSDATE());
             commit; 
         ELSE
             --
             SET l_column1 = SPLIT_STR(pdata,'|',1);
             SET l_column2 = SPLIT_STR(pdata,'|',2);
             SET l_column3 = SPLIT_STR(pdata,'|',3);
             SET l_column4 = SPLIT_STR(pdata,'|',4);
             -- 
             START TRANSACTION;
             -- insert a new record into table
             INSERT INTO Login(User_ID,Password,Combination,Preference_for_witricity)
             VALUES(l_column1,l_column2,convert(l_column3, SIGNED INTEGER),l_column4);
             -- 
             COMMIT;
             --
           END IF;
           --
       ELSE  -- Insert the bulk data using inseet statements pdata_insert = N
             --
             
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('ranjan.v@husky.neu.edu', 'Pr+h8%nB', '1441', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('survu.s@husky.neu.edu', '8@mtHJBs', '6230', 'N');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('reema.d@husky.ney.edu', 'D!C@$4^A', '5884', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('archana.c@husky.neu.edu', '6F%>?p%H', '2202', 'N');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('vandhana.t@husky.neu.edu', 'V9eZFV>H', '6696', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('john.k@husky.neu.edu', 'g~$@W9VF', '7448', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('charles.c@husky.neu.edu', 'K7t&2%N?', '3755', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('tim.c@husky.neu.edu', '9j72d$P#', '1226', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('linda.r@husky.neu.edu', 'z6>wDdA3', '1366', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('cameron.p@husky.neu.edu', 'vn3!mjR5', '6716', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('kumar.s@husky.neu.edu', 'V2d7t!hg', '7402', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('kevin.s@husky.neu.edu', 'Y#z7L4Xg', '4408', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('mary.g@husky.neu.edu', '~PM5Hh6H', '4584', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('tess.b@husky.neu.edu', '$DxH@4u?', '6642', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('catherine.t@husky.neu.edu', 't5JLuN$Q', '4976', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('vimal.n@husky.neu.edu', 'A+nEf6h%', '3822', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Johana.a@husky.neu.edu', 'A+3D&c&6', '4372', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Sherri.s@husky.neu.edu', 'CweQ7N@!', '4564', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Michaela.d@husky.neu.edu', 'b?xPZ2vV', '6231', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Song.c@husky.neu.edu', 'xfK8FT$d', '2688', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Ileana.x@husky.neu.edu', '6f+R7&+%', '3955', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('May.d@husky.neu.edu', 'MBD46$2y', '4792', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Anne.f@husky.neu.edu', '2?$P%AaD', '8130', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Sharolyn.r@husky.neu.edu', '!^3VW@>j', '5209', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Marissa.e@husky.neu.edu', '7fN~SWA8', '6329', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Annamaria.d@husky.neu.edu', 'DMQd4&K~', '2021', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Ursula.s@husky.neu.edu', 'vCuy~v&4', '9492', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Leonardo.c@husky.neu.edu', 'j3ZD@!#S', '1135', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Annelle.v@husky.neu.edu', '$Q7E7sq#', '3773', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Johnnie.b@husky.neu.edu', 'qw5zGK!j', '1497', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Charley.n@husky.neu.edu', 'X3cq~e?K', '2503', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Lacresha.h@husky.neu.edu', 'QB+Fj4kA', '7706', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Eliza.g@husky.neu.edu', '>WybWt8?', '7749', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Fernando.t@husky.neu.edu', 'C9mdDeE%', '7022', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Graig.y@husky.neu.edu', '7$2XSv$Q', '2239', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Alyson.r@husky.neu.edu', 'jLQZ@Z3R', '7141', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Carl.d@husky.neu.edu', 'U6!DqM%#', '5718', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Allene.e@husky.neu.edu', 'qG8?WXF%', '6849', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Diane.w@husky.neu.edu', 'c>X5Q@>q', '9352', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Janice.s@husky.neu.edu', 'FX5&9G!8', '3314', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Mina.v@husky.neu.edu', 'VG&#3X?H', '9322', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Karole.b@husky.neu.edu', '8uK#@Fpg', '1708', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Chiquita.g@husky.neu.edu', '$wWkN3hX', '7578', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Sallie.h@husky.neu.edu', '9q7RV!KB', '7921', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Verlene.y@husky.neu.edu', '^CYXD3Rd', '8959', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Marlon.u@husky.neu.edu', '^hL9dAFE', '6144', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Henriette.t@husky.neu.edu', '#H5C3ZAK', '3788', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Micha.f@husky.neu.edu', 'STS5~N%q', '9547', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Yuette.r@husky.neu.edu', 'j4&^8DL&', '5302', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Lena.i@husky.neu.edu', '^MB%!Md6', '6226', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Alysa.o@husky.neu.edu', 'Gqj9b~4%', '8103', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Rosena.p@husky.neu.edu', 'pRs?da83', '9664', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Mercedes.l@husky.neu.edu', 'qZ%3pV&k', '7744', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Linette.k@husky.neu.edu', 'k6?VUcE6', '6548', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Steve.m@husky.neu.edu', 'ZD2^g@3t', '6373', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Kimbery.j@husky.neu.edu', '5S8$&%8H', '1354', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Myrna.h@husky.neu.edu', 'Y79&5S62', '6663', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Rochelle.n@husky.neu.edu', '&!sn77WV', '8884', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Katina.b@husky.neu.edu', 'XB>K7Xnc', '9673', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Jessika.v@husky.neu.edu', '@94N&YAM', '4783', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Syreeta.f@husky.neu.edu', '~2msEufr', '6996', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Lona.g@husky.neu.edu', 'YD~2N@P!', '1267', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Drew.t@husky.neu.edu', '8x~8RPs>', '6606', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Jayna.r@husky.neu.edu', 'A&e~!5aB', '5286', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Tarra.c@husky.neu.edu', '6P#Y#EXz', '9641', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Tegan.d@husky.neu.edu', '&Kr#U5gm', '7311', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Armando.a@husky.neu.edu', 'Cs!6GnpE', '8898', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Wyatt.s@husky.neu.edu', 'zN8$fc!V', '9171', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Daina.d@husky.neu.edu', 'R~6$u$XX', '6908', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Angelo.c@husky.neu.edu', 'n6qJ2?XE', '4997', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Arthur.x@husky.neu.edu', 'TdNE8M#h', '6777', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Leighann.d@husky.neu.edu', 'dt^Ry3DA', '1863', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Aileen.f@husky.neu.edu', 'Bmra8?C9', '4584', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Carlie.r@husky.neu.edu', '5&gs@GqY', '9184', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Marcelina.e@husky.neu.edu', '%kQ3pUF^', '4073', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Julissa.d@husky.neu.edu', '3hq~N7AD', '7141', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Tracy.s@husky.neu.edu', '3N$^gC3D', '9884', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Jade.c@husky.neu.edu', '3EGn^^d+', '7635', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Ivory.v@husky.neu.edu', '~7%WNK#4', '1196', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Spencer.b@husky.neu.edu', 'eN@D>f~7', '2412', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Classie.n@husky.neu.edu', '2WW&5$Vj', '8889', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Clarissa.h@husky.neu.edu', '^7L>JV3q', '1400', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Isaiah.g@husky.neu.edu', '3B~kJG3M', '3497', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Merissa.t@husky.neu.edu', '%h+&X34Z', '4211', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Shaina.y@husky.neu.edu', 'a>VV$35U', '7452', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Carmella.r@husky.neu.edu', 'Hh8SD&?d', '3849', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Chieko.d@husky.neu.edu', 'ZM$uJ3&5', '5814', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Johnna.e@husky.neu.edu', 'K!4GDD9P', '8459', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Gregoria.w@husky.neu.edu', '8^dYPcMh', '6950', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Jone.s@husky.neu.edu', 'ncD52+~y', '7805', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Bernadine.v@husky.neu.edu', 'W~4^SDmc', '3638', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Marylou.b@husky.neu.edu', 'aq~n+P27', '5262', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Lacy.g@husky.neu.edu', 'EY8&+82K', '4217', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Laurice.h@husky.neu.edu', 'tU!~J3M4', '4972', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Ena.y@husky.neu.edu', '+yJR@w3E', '6669', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('Mimi.u@husky.neu.edu', 'LnCdzS^9', '5291', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('casey.j@husky.neu.edu', 'NXxAQ?Y2', '5433', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('logan.c@husky.neu.edu', '3h@uJ#K~', '8371', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('raj.s@husky.neu.edu', 'aK^J3UkP', '2896', 'Y');
            INSERT INTO witricity.Login (User_ID, Password, Combination, Preference_for_witricity) VALUES ('mark.t@husky.neu.edu', 'Q>4Jp#UX', '1000', 'N');
             --            
             select 'After inserting data into table Login';
             --
             COMMIT;
             --
        END IF; 
       --
       END IF;
       --       
       
       -- 

END 
$$

--
--- User_Location  table Error Handling and data Insert
--



DELIMITER $$  

CREATE PROCEDURE User_Location_data_insert(pdata_insert varchar(2),pdata varchar(2000),ptable_name varchar(50))

   BEGIN
      -- Declaration Section
      --
	  DECLARE l_string varchar(2000) DEFAULT NULL;
	  DECLARE l_occurences INT default 0;
	  DECLARE l_column1 varchar(200) default NULL;
      DECLARE l_column2 varchar(200) default NULL;
      DECLARE l_column3 varchar(200) default NULL;
      DECLARE l_no_of_columns INT DEFAULT 0;
      DECLARE l_error_message varchar(200) default NULL;
      --
   --   DECLARE CONTINUE HANDLER FOR 1062 SELECT 'Duplicate keys error encountered while inserting data in User_Location table' into l_error_message;
      DECLARE CONTINUE HANDLER FOR SQLEXCEPTION -- SELECT 'SQLException encountered while inserting data in User_Location table' into l_error_message; 
	--  DECLARE CONTINUE HANDLER FOR 1452 select 'Foreign key constraint violated while inserting data in User_Location table' into l_error_message;
      --
      BEGIN
        --
		get diagnostics condition 1
		       
          @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
			SET @full_error = CONCAT("ERROR ", @errno, @text);
		  
		
		IF @full_error like 'ERROR 1452Cannot add or update a child row: a foreign key constraint fails%' then
		   INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('User_Location',pdata,'Foreign key constraint violated',SYSDATE());
		END IF;
		--
		SET l_error_message =  @full_error;
		--
        INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('User_Location',pdata,l_error_message,SYSDATE());
             commit;
        
        END;
      --
      IF pdata_insert NOT IN ('Y','N') THEN
         --
         SIGNAL SQLSTATE '45000'
         SET MESSAGE_TEXT = 'Invalid value passed to first parameter.(Valid value:Y/N)';
         INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('User_Location',pdata,'Invalid value passed to first parameter.(Valid value:Y/N)',SYSDATE());
             commit; 
     ELSE 
      --
	  if pdata_insert = 'Y' then
	    --
        SET l_string = pdata;
	    --
        SELECT LENGTH(l_string) - LENGTH(REPLACE(l_string, '|', ''))+1 into l_occurences; 
	    --
        SELECT COUNT(*) into l_no_of_columns
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE upper(table_schema) = upper('witricity')
        AND upper(table_name) = upper(ptable_name);
        --
        IF(l_no_of_columns != l_occurences) THEN 
          SIGNAL SQLSTATE '45001'
          SET MESSAGE_TEXT = 'Insufficient data passed to the insert into table';
          --
          INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES(ptable_name,pdata,'Insufficient data passed to the insert into table',SYSDATE());
             commit; 
         ELSE
             --
             SET l_column1 = SPLIT_STR(pdata,'|',1);
             SET l_column2 = SPLIT_STR(pdata,'|',2);
             SET l_column3 = SPLIT_STR(pdata,'|',3);
             -- 
             START TRANSACTION;
             -- insert a new record into table
             INSERT INTO User_Location(User_ID,GPS,Nearest_Transmitter)
             VALUES(l_column1,convert(l_column2, SIGNED INTEGER),convert(l_column3, SIGNED INTEGER));
             -- 
             COMMIT;
             --
           END IF;
           --
       ELSE  -- Insert the bulk data using inseet statements pdata_insert = N
             --
             
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('survu.s@husky.neu.edu', '10000001', '50132');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('reema.d@husky.ney.edu', '10000010', '50146');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('archana.c@husky.neu.edu', '10000011', '50190');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('reema.d@husky.ney.edu', '10000100', '50135');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('archana.c@husky.neu.edu', '10000101', '50076');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('vandhana.t@husky.neu.edu', '10000110', '50124');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('john.k@husky.neu.edu', '10000111', '50075');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('charles.c@husky.neu.edu', '10001000', '50177');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('tim.c@husky.neu.edu', '10001001', '50183');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('linda.r@husky.neu.edu', '10001010', '50052');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('cameron.p@husky.neu.edu', '10001011', '50116');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('kumar.s@husky.neu.edu', '10001100', '50120');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('kevin.s@husky.neu.edu', '10001101', '50053');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('mary.g@husky.neu.edu', '10001110', '50008');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('tess.b@husky.neu.edu', '10001111', '50142');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('catherine.t@husky.neu.edu', '10010000', '50154');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('vimal.n@husky.neu.edu', '10010001', '50013');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('Johana.a@husky.neu.edu', '10010010', '50058');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('Sherri.s@husky.neu.edu', '10010011', '50064');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('Michaela.d@husky.neu.edu', '10010100', '50174');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('Song.c@husky.neu.edu', '10010101', '50105');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('Ileana.x@husky.neu.edu', '10010110', '50032');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('May.d@husky.neu.edu', '10010111', '50162');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('Anne.f@husky.neu.edu', '10011000', '50168');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('Sharolyn.r@husky.neu.edu', '10011001', '50067');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('Marissa.e@husky.neu.edu', '10011010', '50045');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('Annamaria.d@husky.neu.edu', '10011011', '50069');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('Ursula.s@husky.neu.edu', '10011100', '50198');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('Leonardo.c@husky.neu.edu', '10011101', '50197');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('Annelle.v@husky.neu.edu', '10011110', '50040');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('Johnnie.b@husky.neu.edu', '10011111', '50076');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('Charley.n@husky.neu.edu', '10100000', '50057');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('Lacresha.h@husky.neu.edu', '10100001', '50009');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('Eliza.g@husky.neu.edu', '10100010', '50129');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('Fernando.t@husky.neu.edu', '10100011', '50195');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('Graig.y@husky.neu.edu', '10100100', '50080');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('Alyson.r@husky.neu.edu', '10100101', '50003');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('Carl.d@husky.neu.edu', '10100110', '50084');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('Allene.e@husky.neu.edu', '10100111', '50144');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('Diane.w@husky.neu.edu', '10101000', '50005');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('Janice.s@husky.neu.edu', '10101001', '50073');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('Mina.v@husky.neu.edu', '10101010', '50059');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('Karole.b@husky.neu.edu', '10101011', '50134');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('Chiquita.g@husky.neu.edu', '10101100', '50051');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('Sallie.h@husky.neu.edu', '10101101', '50061');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('Verlene.y@husky.neu.edu', '10101110', '50053');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('Marlon.u@husky.neu.edu', '10101111', '50163');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('Henriette.t@husky.neu.edu', '10110000', '50194');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('Micha.f@husky.neu.edu', '10110001', '50001');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('Yuette.r@husky.neu.edu', '10110010', '50115');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('Lena.i@husky.neu.edu', '10110011', '50133');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('Alysa.o@husky.neu.edu', '10110100', '50095');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('Rosena.p@husky.neu.edu', '10110101', '50052');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('Mercedes.l@husky.neu.edu', '10110110', '50046');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('Linette.k@husky.neu.edu', '10110111', '50071');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('Steve.m@husky.neu.edu', '10111000', '50014');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('Kimbery.j@husky.neu.edu', '10111001', '50053');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('Myrna.h@husky.neu.edu', '10111010', '50009');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('Rochelle.n@husky.neu.edu', '10111011', '50189');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('Katina.b@husky.neu.edu', '10111100', '50150');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('Jessika.v@husky.neu.edu', '10111101', '50147');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('Syreeta.f@husky.neu.edu', '10111110', '50058');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('Lona.g@husky.neu.edu', '10111111', '50146');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('Drew.t@husky.neu.edu', '11000000', '50087');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('Jayna.r@husky.neu.edu', '11000001', '50158');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('Tarra.c@husky.neu.edu', '11000010', '50047');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('Merissa.t@husky.neu.edu', '11000011', '50132');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('Shaina.y@husky.neu.edu', '11000100', '50054');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('Carmella.r@husky.neu.edu', '11000101', '50033');
                INSERT INTO witricity.User_Location (User_ID, GPS, Nearest_Transmitter) VALUES ('Gregoria.w@husky.neu.edu', '11000110', '50115');
                           
                select 'After Insering data in table User_Location';
             
             COMMIT;
            
        END IF; 
        --
        END IF;
        --
        
        --
 
END 
$$

--
--- Location_master  table Error Handling and data Insert
--



DELIMITER $$  

CREATE PROCEDURE Location_master_data_insert(pdata_insert varchar(2),pdata varchar(2000),ptable_name varchar(50))

   BEGIN
      -- Declaration Section
      --
	  DECLARE l_string varchar(2000) DEFAULT NULL;
	  DECLARE l_occurences INT default 0;
	  DECLARE l_column1 varchar(200) default NULL;
      DECLARE l_column2 varchar(200) default NULL;
      DECLARE l_column3 varchar(200) default NULL;
      DECLARE l_no_of_columns INT DEFAULT 0;
      DECLARE l_error_message varchar(200) default NULL;
      --
     -- DECLARE CONTINUE HANDLER FOR 1062 SELECT 'Duplicate keys error encountered while inserting data in Location_master table' into l_error_message;
      DECLARE CONTINUE HANDLER FOR SQLEXCEPTION -- SELECT 'SQLException encountered while inserting data in Location_master table' into l_error_message; 
	 -- DECLARE CONTINUE HANDLER FOR 1452 select 'Foreign key constraint violated while inserting data in Location_master table' into l_error_message;
      --
      BEGIN
        --
		get diagnostics condition 1
		       
          @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
			SET @full_error = CONCAT("ERROR ", @errno, @text);
		  
		
		IF @full_error like 'ERROR 1452Cannot add or update a child row: a foreign key constraint fails%' then
		   INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('Location_master',pdata,'Foreign key constraint violated',SYSDATE());
		END IF;
		--
		SET l_error_message =  @full_error;
		--
        INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('Location_master',pdata,l_error_message,SYSDATE());
             commit;
        
        END;
      --
      IF pdata_insert NOT IN ('Y','N') THEN
         --
         SIGNAL SQLSTATE '45000'
         SET MESSAGE_TEXT = 'Invalid value passed to first parameter.(Valid value:Y/N)';
         INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('Location_master',pdata,'Invalid value passed to first parameter.(Valid value:Y/N)',SYSDATE());
             commit; 
     ELSE 
      --
	  if pdata_insert = 'Y' then
	    --
        SET l_string = pdata;
	    --
        SELECT LENGTH(l_string) - LENGTH(REPLACE(l_string, '|', ''))+1 into l_occurences; 
	    --
        SELECT COUNT(*) into l_no_of_columns
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE upper(table_schema) = upper('witricity')
        AND upper(table_name) = upper(ptable_name);
        --
        IF(l_no_of_columns != l_occurences) THEN 
          SIGNAL SQLSTATE '45001'
          SET MESSAGE_TEXT = 'Insufficient data passed to the insert into table';
          --
          INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES(ptable_name,pdata,'Insufficient data passed to the insert into table',SYSDATE());
             commit;
         ELSE
             --
             SET l_column1 = SPLIT_STR(pdata,'|',1);
             SET l_column2 = SPLIT_STR(pdata,'|',2);
             SET l_column3 = SPLIT_STR(pdata,'|',3);
             -- 
             START TRANSACTION;
             -- insert a new record into table
             INSERT INTO Location_master(Location_Identifier,Building_ID,Room_ID)
             VALUES(default,convert(l_column2, SIGNED INTEGER),convert(l_column3, SIGNED INTEGER));
             -- 
             COMMIT;
             --
           END IF;
           --
       ELSE  -- Insert the bulk data using inseet statements pdata_insert = N
             --
             -- select 'Inside pdata_insert N';
             
             ALTER TABLE witricity.Location_master AUTO_INCREMENT=1;
           
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '100100', '100110');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '100100', '100111');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '100100', '100112');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '100100', '100113');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '100100', '100114');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '100200', '100115');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '100200', '100116');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '100200', '100117');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '100200', '100118');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '100200', '100119');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '100300', '100120');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '100300', '100121');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '100300', '100122');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '100300', '100123');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '100300', '100124');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '100400', '100125');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '100400', '100126');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '100400', '100127');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '100400', '100128');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '100400', '100129');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '100500', '100130');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '100500', '100131');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '100500', '100132');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '100500', '100133');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '100500', '100134');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '100600', '100135');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '100600', '100136');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '100600', '100137');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '100600', '100138');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '100600', '100139');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '100700', '100140');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '100700', '100141');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '100700', '100142');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '100700', '100143');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '100700', '100144');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '100800', '100145');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '100800', '100146');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '100800', '100147');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '100800', '100148');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '100800', '100149');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '100900', '100150');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '100900', '100151');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '100900', '100152');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '100900', '100153');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '100900', '100154');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '101000', '100155');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '101000', '100156');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '101000', '100157');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '101000', '100158');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '101000', '100159');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '101100', '100160');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '101100', '100161');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '101100', '100162');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '101100', '100163');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '101100', '100164');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '101200', '100165');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '101200', '100166');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '101200', '100167');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '101200', '100168');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '101200', '100169');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '101300', '100170');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '101300', '100171');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '101300', '100172');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '101300', '100173');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '101300', '100174');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '101400', '100175');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '101400', '100176');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '101400', '100177');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '101400', '100178');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '101400', '100179');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '101500', '100180');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '101500', '100181');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '101500', '100182');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '101500', '100183');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '101500', '100184');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '101600', '100185');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '101600', '100186');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '101600', '100187');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '101600', '100188');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '101600', '100189');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '101700', '100190');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '101700', '100191');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '101700', '100192');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '101700', '100193');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '101700', '100194');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '101800', '100195');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '101800', '100196');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '101800', '100197');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '101800', '100198');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '101800', '100199');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '101900', '100200');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '101900', '100201');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '101900', '100202');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '101900', '100203');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '101900', '100204');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '102000', '100205');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '102000', '100206');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '102000', '100207');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '102000', '100208');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '102000', '100209');
                INSERT INTO witricity.Location_master (Location_Identifier, Building_ID, Room_ID) VALUES (default, '102000', '100210');
               --
               select 'After data inserted in table Location_master';
               --
             COMMIT;
             --
        END IF; 
        -- 
        END IF;
        --
               
END 
$$

--
--- Config_location_mapping  table Error Handling and data Insert
--



DELIMITER $$  

CREATE PROCEDURE Config_location_mapping_data_insert(pdata_insert varchar(2),pdata varchar(2000),ptable_name varchar(50))

   BEGIN
      -- Declaration Section
      --
	  DECLARE l_string varchar(2000) DEFAULT NULL;
	  DECLARE l_occurences INT default 0;
	  DECLARE l_column1 varchar(200) default NULL;
      DECLARE l_column2 varchar(200) default NULL;
      DECLARE l_no_of_columns INT DEFAULT 0;
      DECLARE l_error_message varchar(200) default NULL;
      --
     -- DECLARE CONTINUE HANDLER FOR 1062 SELECT 'Duplicate keys error encountered while inserting data in Config_location_mapping table' into l_error_message;
    --  DECLARE CONTINUE HANDLER FOR 1452 sqlStatus = 1452; -- MESSAGE_TEXT = 'Foreign key constraint violated';  -- select 'Foreign key constraint violated while inserting data in Config_location_mapping table' into l_error_message;
      DECLARE CONTINUE HANDLER FOR SQLEXCEPTION -- SELECT -- 'SQLException encountered while inserting data in Config_location_mapping table' into l_error_message; 
	  --
      BEGIN
        --
		get diagnostics condition 1
		       
          @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
			SET @full_error = CONCAT("ERROR ", @errno, @text);
		  
		
		IF @full_error like 'ERROR 1452Cannot add or update a child row: a foreign key constraint fails%' then
		   INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('Config_location_mapping',pdata,'Foreign key constraint violated',SYSDATE());
		END IF;
		--
		SET l_error_message =  @full_error;
		--
        INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('Config_location_mapping',pdata,l_error_message,SYSDATE());
             commit;
        
        END;
      --
      IF pdata_insert NOT IN ('Y','N') THEN
         --
         SIGNAL SQLSTATE '45000'
         SET MESSAGE_TEXT = 'Invalid value passed to first parameter.(Valid value:Y/N)';
         INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('Config_location_mapping',pdata,'Invalid value passed to first parameter.(Valid value:Y/N)',SYSDATE());
             commit; 
     ELSE 
      --
	  IF pdata_insert = 'Y' then
	    --
        SET l_string = pdata;
	    --
        SELECT LENGTH(l_string) - LENGTH(REPLACE(l_string, '|', ''))+1 into l_occurences; 
	    --
        SELECT COUNT(*) into l_no_of_columns
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE upper(table_schema) = upper('witricity')
        AND upper(table_name) = upper(ptable_name);
        --
         IF(l_no_of_columns != l_occurences) THEN 
          SIGNAL SQLSTATE '45000'
          SET MESSAGE_TEXT = 'Insufficient data passed to the insert into table';
          --
          INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES(ptable_name,pdata,'Insufficient data passed to the insert into table',SYSDATE());
             commit; 
         ELSE
             --
             SET l_column1 = SPLIT_STR(pdata,'|',1);
             SET l_column2 = SPLIT_STR(pdata,'|',2);
              -- 
             START TRANSACTION;
             -- insert a new record into table
             INSERT INTO Config_location_mapping(Config_ID,Location_Identifier)
             VALUES(convert(l_column1, SIGNED INTEGER),convert(l_column2, SIGNED INTEGER));
             -- 
             COMMIT;
             --
           END IF;
           --
       ELSE  -- Insert the bulk data using inseet statements pdata_insert = N
             --
             -- select 'Inside pdata_insert N';
           
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300301', '45');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300302', '42');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300303', '22');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300304', '4');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300305', '49');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300306', '60');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300307', '49');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300308', '92');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300309', '94');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300310', '49');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300311', '7');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300312', '58');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300313', '94');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300314', '89');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300315', '48');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300316', '51');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300317', '101');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300318', '87');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300319', '9');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300320', '90');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300321', '58');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300322', '19');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300323', '43');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300324', '25');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300325', '98');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300326', '100');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300327', '9');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300328', '83');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300329', '19');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300330', '3');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300331', '43');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300332', '94');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300333', '69');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300334', '4');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300335', '1');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300336', '14');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300337', '72');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300338', '59');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300339', '3');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300340', '79');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300341', '71');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300342', '26');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300343', '46');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300344', '100');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300345', '50');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300346', '64');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300347', '88');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300348', '70');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300349', '10');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300350', '7');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300351', '15');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300352', '19');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300353', '17');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300354', '96');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300355', '76');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300356', '51');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300357', '90');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300358', '14');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300359', '2');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300360', '33');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300361', '50');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300362', '16');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300363', '74');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300364', '58');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300365', '85');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300366', '37');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300367', '92');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300368', '91');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300369', '90');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300370', '36');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300371', '43');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300372', '9');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300373', '71');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300374', '40');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300375', '64');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300376', '23');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300377', '29');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300378', '36');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300379', '94');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300380', '42');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300381', '24');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300382', '95');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300383', '58');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300384', '47');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300385', '46');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300386', '84');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300387', '74');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300388', '25');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300389', '14');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300390', '61');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300391', '24');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300392', '4');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300393', '75');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300394', '61');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300395', '4');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300396', '27');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300397', '80');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300398', '98');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300399', '54');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300400', '55');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300401', '100');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300402', '50');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300403', '64');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300404', '88');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300405', '70');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300406', '10');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300407', '7');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300408', '15');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300409', '19');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300410', '17');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300411', '96');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300412', '76');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300413', '51');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300414', '90');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300415', '14');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300416', '2');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300417', '24');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300418', '4');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300419', '75');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300420', '61');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300421', '36');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300422', '94');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300423', '42');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300424', '24');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300425', '95');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300426', '58');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300427', '47');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300428', '46');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300429', '84');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300430', '74');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300431', '25');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300432', '14');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300433', '61');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300434', '24');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300435', '1');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300436', '75');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300437', '24');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300438', '4');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300439', '75');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300440', '84');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300441', '74');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300442', '25');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300443', '14');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300444', '61');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300445', '24');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300446', '4');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300447', '75');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300448', '61');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300449', '4');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300450', '27');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300451', '80');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300452', '98');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300453', '54');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300454', '55');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300455', '1');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300456', '5');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300457', '2');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300458', '21');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300459', '58');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300460', '47');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300461', '46');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300462', '84');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300463', '74');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300464', '25');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300465', '14');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300466', '61');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300467', '24');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300468', '4');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300469', '75');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300470', '61');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300471', '4');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300472', '27');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300473', '80');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300474', '98');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300475', '54');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300476', '100');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300477', '50');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300478', '64');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300479', '88');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300480', '70');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300481', '101');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300482', '7');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300483', '15');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300484', '19');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300485', '17');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300486', '96');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300487', '76');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300488', '51');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300489', '90');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300490', '14');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300491', '2');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300492', '42');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300493', '22');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300494', '4');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300495', '49');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300496', '60');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300497', '49');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300498', '92');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300499', '94');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300500', '49');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300501', '7');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300502', '58');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300503', '94');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300504', '89');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300505', '48');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300506', '51');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300507', '1');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300508', '87');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300509', '9');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300510', '90');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300511', '58');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300512', '19');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300513', '43');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300514', '25');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300515', '98');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300516', '100');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300517', '9');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300518', '83');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300519', '19');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300520', '3');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300521', '43');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300522', '94');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300523', '69');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300524', '4');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300525', '1');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300526', '14');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300527', '72');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300528', '59');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300529', '3');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300530', '79');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300531', '71');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300532', '26');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300533', '101');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300534', '100');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300535', '50');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300536', '1');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300537', '88');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300538', '70');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300539', '10');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300540', '7');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300541', '15');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300542', '19');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300543', '17');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300544', '96');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300545', '76');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300546', '51');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300547', '90');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300548', '14');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300549', '2');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300550', '33');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300551', '50');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300552', '16');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300553', '74');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300554', '58');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300555', '85');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300556', '37');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300557', '92');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300558', '91');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300559', '90');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300560', '36');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300561', '43');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300562', '9');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300563', '71');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300564', '40');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300565', '64');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300566', '23');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300567', '29');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300568', '36');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300569', '94');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300570', '42');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300571', '24');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300572', '95');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300573', '58');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300574', '47');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300575', '46');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300576', '84');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300577', '74');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300578', '25');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300579', '14');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300580', '61');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300581', '24');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300582', '4');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300583', '75');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300584', '61');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300585', '4');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300586', '27');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300587', '80');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300588', '98');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300589', '54');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300590', '55');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300591', '87');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300592', '9');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300593', '90');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300594', '58');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300595', '19');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300596', '43');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300597', '25');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300598', '98');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300599', '100');
                INSERT INTO witricity.Config_location_mapping (Config_ID, Location_Identifier) VALUES ('300600', '9');
   
                select 'After inserting data in table Config_location_mapping';
             
             COMMIT;
            
        END IF; 
       --
       END IF;
       --
       
        --
END 
$$


--
--- Config_Detail  table Error Handling and data Insert
--



DELIMITER $$  

CREATE PROCEDURE Config_Detail_data_insert(pdata_insert varchar(2),pdata varchar(2000),ptable_name varchar(50))

   BEGIN
      -- Declaration Section
      --
	  DECLARE l_string varchar(2000) DEFAULT NULL;
	  DECLARE l_occurences INT default 0;
	  DECLARE l_column1 varchar(200) default NULL;
      DECLARE l_column2 varchar(200) default NULL;
      DECLARE l_column3 varchar(200) default NULL;
      DECLARE l_column4 varchar(200) default NULL;
      DECLARE l_column5 varchar(200) default NULL;
      DECLARE l_column6 varchar(200) default NULL;
      DECLARE l_no_of_columns INT DEFAULT 0;
      DECLARE l_error_message varchar(200) default NULL;
      --
    --  DECLARE CONTINUE HANDLER FOR 1062 SELECT 'Duplicate keys error encountered while inserting data in Config_Detail table' into l_error_message;
      DECLARE CONTINUE HANDLER FOR SQLEXCEPTION -- SELECT 'SQLException encountered while inserting data in Config_Detail table' into l_error_message; 
	--  DECLARE CONTINUE HANDLER FOR 1452 select 'Foreign key constraint violated while inserting data in Config_Detail table' into l_error_message;
      --
      BEGIN
        --
		get diagnostics condition 1
		       
          @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
			SET @full_error = CONCAT("ERROR ", @errno, @text);
		  
		
		IF @full_error like 'ERROR 1452Cannot add or update a child row: a foreign key constraint fails%' then
		   INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('Config_Detail',pdata,'Foreign key constraint violated',SYSDATE());
		END IF;
		--
		SET l_error_message =  @full_error;
		--
        INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('Config_Detail',pdata,l_error_message,SYSDATE());
             commit;
        
        END;
      --
      IF pdata_insert NOT IN ('Y','N') THEN
         --
         SIGNAL SQLSTATE '45000'
         SET MESSAGE_TEXT = 'Invalid value passed to first parameter.(Valid value:Y/N)';
         INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('Config_Detail',pdata,'Invalid value passed to first parameter.(Valid value:Y/N)',SYSDATE());
             commit; 
     ELSE 
      --
	  if pdata_insert = 'Y' then
	    --
        SET l_string = pdata;
	    --
         select 'Inside pdata_insert Y1' ;
		SELECT LENGTH(l_string) - LENGTH(REPLACE(l_string, '|', ''))+1 into l_occurences; 
	    --
        SELECT COUNT(*) into l_no_of_columns
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE upper(table_schema) = upper('witricity')
        AND upper(table_name) = upper(ptable_name);
        --
         IF(l_no_of_columns != l_occurences) THEN 
          SIGNAL SQLSTATE '45000'
          SET MESSAGE_TEXT = 'Insufficient data passed to the insert into table';
          --
          INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES(ptable_name,pdata,'Insufficient data passed to the insert into table',SYSDATE());
             commit; 
         ELSE
             --
             SET l_column1 = SPLIT_STR(pdata,'|',1);
             SET l_column2 = SPLIT_STR(pdata,'|',2);
             SET l_column3 = SPLIT_STR(pdata,'|',3);
             SET l_column4 = SPLIT_STR(pdata,'|',4);
             SET l_column5 = SPLIT_STR(pdata,'|',5);
             SET l_column6 = SPLIT_STR(pdata,'|',6);
             -- 
             START TRANSACTION;
             -- insert a new record into table
             INSERT INTO Config_Detail(Config_ID ,Transmitter_Type_ID,Max_Transmitters,Min_Transmitters,Max_Booster_Req,Min_Booster_Req)
             VALUES(convert(l_column1, SIGNED INTEGER),convert(l_column2, SIGNED INTEGER),convert(l_column3, SIGNED INTEGER),convert(l_column4, SIGNED INTEGER),convert(l_column5, SIGNED INTEGER),convert(l_column6, SIGNED INTEGER));
             -- 
             COMMIT;
             --
           END IF;
           --
       ELSE  -- Insert the bulk data using inseet statements pdata_insert = N
             --
             -- select 'Inside pdata_insert N';
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300301', '111', '4', '1', '4', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300302', '222', '3', '2', '3', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300303', '333', '3', '1', '3', '0');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300304', '111', '4', '1', '5', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300305', '222', '5', '1', '4', '0');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300306', '333', '3', '1', '2', '0');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300307', '111', '2', '2', '4', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300308', '222', '5', '2', '5', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300309', '333', '4', '1', '3', '0');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300310', '111', '2', '1', '3', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300311', '222', '4', '1', '3', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300312', '333', '5', '1', '4', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300313', '111', '3', '2', '5', '5');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300314', '222', '3', '3', '5', '3');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300315', '333', '3', '1', '3', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300316', '111', '4', '2', '2', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300317', '222', '5', '2', '5', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300318', '333', '5', '1', '4', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300319', '111', '3', '1', '5', '4');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300320', '222', '2', '1', '3', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300321', '333', '5', '1', '2', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300322', '111', '4', '3', '5', '3');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300323', '222', '2', '1', '4', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300324', '333', '4', '1', '2', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300325', '111', '5', '1', '4', '4');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300326', '222', '3', '1', '5', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300327', '333', '2', '1', '3', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300328', '111', '5', '2', '4', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300329', '222', '4', '1', '5', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300330', '333', '2', '1', '5', '3');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300331', '111', '4', '2', '3', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300332', '222', '5', '1', '4', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300333', '333', '3', '1', '3', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300334', '111', '3', '3', '4', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300335', '222', '3', '1', '5', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300336', '333', '4', '1', '3', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300337', '111', '5', '3', '3', '3');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300338', '222', '5', '1', '3', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300339', '333', '3', '1', '5', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300340', '111', '2', '2', '5', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300341', '222', '5', '2', '3', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300342', '333', '3', '1', '4', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300343', '111', '4', '3', '5', '3');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300344', '222', '5', '1', '5', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300345', '333', '3', '1', '3', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300346', '111', '2', '1', '2', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300347', '222', '5', '2', '5', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300348', '333', '4', '1', '4', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300349', '111', '2', '1', '2', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300350', '222', '4', '3', '4', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300351', '333', '5', '4', '5', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300352', '111', '3', '1', '3', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300353', '222', '3', '2', '3', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300354', '333', '3', '1', '3', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300355', '111', '4', '2', '4', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300356', '222', '5', '3', '5', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300357', '333', '5', '1', '5', '3');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300358', '111', '3', '3', '3', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300359', '222', '4', '2', '2', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300360', '333', '5', '1', '5', '3');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300361', '111', '5', '3', '6', '6');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300362', '222', '3', '1', '4', '3');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300363', '333', '2', '1', '5', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300364', '111', '5', '3', '3', '3');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300365', '222', '4', '1', '3', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300366', '333', '2', '1', '3', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300367', '111', '4', '3', '4', '3');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300368', '222', '5', '2', '5', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300369', '333', '3', '1', '5', '0');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300370', '111', '2', '1', '3', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300371', '222', '5', '3', '3', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300372', '333', '4', '2', '4', '0');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300373', '111', '2', '1', '5', '3');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300374', '222', '4', '1', '3', '3');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300375', '333', '5', '2', '2', '0');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300376', '111', '3', '1', '5', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300377', '222', '4', '2', '2', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300378', '333', '5', '3', '5', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300379', '111', '3', '1', '3', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300380', '222', '3', '1', '4', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300381', '333', '3', '1', '5', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300382', '111', '4', '2', '3', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300383', '222', '5', '2', '2', '0');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300384', '333', '5', '3', '5', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300385', '111', '3', '1', '6', '4');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300386', '222', '2', '1', '1', '0');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300387', '333', '5', '4', '2', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300388', '111', '3', '1', '2', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300389', '222', '4', '2', '4', '3');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300390', '333', '5', '5', '5', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300391', '111', '3', '1', '3', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300392', '222', '2', '1', '2', '0');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300393', '333', '5', '3', '5', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300394', '111', '4', '2', '4', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300395', '222', '2', '1', '2', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300396', '333', '4', '1', '4', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300397', '111', '5', '2', '5', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300398', '222', '3', '3', '3', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300399', '333', '3', '1', '4', '0');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300400', '111', '3', '2', '5', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300401', '222', '4', '4', '4', '3');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300402', '333', '5', '1', '5', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300403', '111', '5', '3', '3', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300404', '222', '3', '1', '2', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300405', '333', '4', '1', '5', '0');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300406', '111', '5', '4', '4', '3');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300407', '222', '5', '1', '2', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300408', '333', '3', '2', '4', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300409', '111', '2', '2', '5', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300410', '222', '5', '2', '3', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300411', '333', '4', '1', '4', '3');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300412', '111', '2', '2', '5', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300413', '222', '4', '3', '3', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300414', '333', '5', '1', '3', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300415', '111', '3', '3', '3', '3');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300416', '222', '2', '2', '3', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300417', '333', '5', '2', '4', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300418', '111', '4', '4', '5', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300419', '222', '2', '2', '5', '4');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300420', '333', '4', '1', '3', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300421', '111', '5', '1', '2', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300422', '222', '3', '2', '5', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300423', '333', '3', '1', '4', '3');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300424', '111', '3', '2', '5', '5');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300425', '222', '4', '1', '3', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300426', '333', '5', '2', '3', '0');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300427', '111', '5', '4', '3', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300428', '222', '3', '2', '3', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300429', '333', '2', '1', '4', '3');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300430', '111', '5', '3', '5', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300431', '222', '3', '1', '5', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300432', '333', '4', '2', '3', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300433', '111', '5', '5', '2', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300434', '222', '3', '1', '5', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300435', '333', '2', '1', '4', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300436', '111', '5', '1', '5', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300437', '222', '4', '2', '3', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300438', '333', '2', '1', '2', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300439', '111', '4', '1', '5', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300440', '222', '5', '5', '4', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300441', '333', '3', '1', '2', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300442', '111', '3', '3', '4', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300443', '222', '3', '2', '3', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300444', '333', '4', '1', '2', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300445', '111', '5', '5', '5', '4');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300446', '222', '5', '5', '3', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300447', '333', '3', '3', '1', '0');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300448', '111', '2', '2', '6', '3');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300449', '222', '4', '1', '4', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300450', '333', '5', '1', '5', '0');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300451', '111', '3', '2', '5', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300452', '222', '3', '3', '3', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300453', '333', '2', '1', '4', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300454', '111', '4', '2', '3', '3');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300455', '222', '5', '1', '2', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300456', '333', '3', '3', '5', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300457', '111', '3', '2', '4', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300458', '222', '3', '1', '2', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300459', '333', '4', '1', '4', '0');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300460', '111', '5', '4', '5', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300461', '222', '5', '4', '3', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300462', '333', '3', '1', '3', '5');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300463', '111', '5', '2', '3', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300464', '222', '3', '3', '4', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300465', '333', '2', '1', '5', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300466', '111', '5', '1', '3', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300467', '222', '4', '2', '3', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300468', '333', '2', '1', '4', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300469', '111', '4', '2', '5', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300470', '222', '5', '3', '5', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300471', '333', '3', '1', '3', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300472', '111', '2', '1', '4', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300473', '222', '5', '2', '3', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300474', '333', '4', '3', '3', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300475', '111', '2', '2', '5', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300476', '222', '4', '1', '4', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300477', '333', '5', '1', '2', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300478', '111', '3', '1', '4', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300479', '222', '3', '2', '5', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300480', '333', '3', '1', '3', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300481', '111', '4', '2', '3', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300482', '222', '2', '2', '3', '4');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300483', '333', '5', '1', '4', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300484', '111', '4', '1', '5', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300485', '222', '2', '1', '5', '3');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300486', '333', '4', '4', '3', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300487', '111', '5', '1', '2', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300488', '222', '3', '2', '5', '3');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300489', '333', '2', '1', '3', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300490', '111', '5', '1', '4', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300491', '222', '4', '1', '3', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300492', '333', '2', '1', '4', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300493', '111', '4', '2', '5', '4');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300494', '222', '5', '1', '3', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300495', '333', '3', '2', '3', '0');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300496', '111', '4', '2', '3', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300497', '222', '5', '1', '5', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300498', '333', '3', '2', '1', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300499', '111', '3', '1', '3', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300500', '222', '3', '3', '4', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300501', '333', '4', '2', '2', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300502', '111', '5', '1', '5', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300503', '222', '5', '5', '3', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300504', '333', '3', '1', '4', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300505', '111', '2', '2', '1', '0');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300506', '222', '5', '2', '5', '4');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300507', '333', '3', '1', '5', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300508', '111', '4', '1', '2', '0');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300509', '222', '5', '1', '4', '3');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300510', '333', '4', '1', '5', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300511', '111', '2', '1', '3', '0');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300512', '222', '4', '2', '2', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300513', '333', '5', '1', '3', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300514', '111', '3', '2', '4', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300515', '222', '3', '2', '1', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300516', '333', '3', '1', '6', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300517', '111', '4', '2', '4', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300518', '222', '2', '1', '5', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300519', '333', '5', '2', '5', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300520', '111', '3', '1', '4', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300521', '222', '4', '1', '2', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300522', '333', '3', '1', '4', '3');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300523', '111', '4', '4', '3', '0');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300524', '222', '5', '1', '4', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300525', '333', '3', '2', '5', '0');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300526', '111', '3', '3', '5', '0');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300527', '222', '3', '1', '3', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300528', '333', '4', '1', '2', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300529', '111', '5', '2', '5', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300530', '222', '5', '1', '3', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300531', '333', '3', '2', '6', '0');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300532', '111', '2', '1', '1', '0');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300533', '222', '5', '2', '4', '3');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300534', '333', '3', '1', '2', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300535', '111', '4', '2', '5', '3');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300536', '222', '5', '3', '4', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300537', '333', '2', '2', '2', '0');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300538', '111', '2', '1', '4', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300539', '222', '5', '1', '5', '0');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300540', '333', '3', '1', '3', '3');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300541', '111', '3', '2', '3', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300542', '222', '3', '1', '3', '0');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300543', '333', '4', '2', '3', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300544', '111', '5', '2', '4', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300545', '222', '5', '1', '5', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300546', '333', '3', '2', '5', '3');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300547', '111', '2', '2', '5', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300548', '222', '5', '1', '3', '0');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300549', '333', '3', '1', '4', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300550', '111', '4', '1', '5', '0');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300551', '222', '5', '1', '5', '3');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300552', '333', '3', '2', '3', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300553', '111', '2', '1', '2', '0');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300554', '222', '5', '3', '5', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300555', '333', '4', '4', '4', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300556', '111', '2', '2', '2', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300557', '222', '4', '1', '5', '3');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300558', '333', '5', '5', '3', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300559', '111', '3', '1', '3', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300560', '222', '3', '1', '3', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300561', '333', '3', '3', '5', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300562', '111', '4', '1', '4', '0');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300563', '222', '5', '1', '2', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300564', '333', '5', '1', '4', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300565', '111', '3', '1', '5', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300566', '222', '4', '2', '3', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300567', '333', '5', '1', '2', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300568', '111', '5', '2', '3', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300569', '222', '5', '2', '4', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300570', '333', '3', '1', '4', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300571', '111', '4', '2', '5', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300572', '222', '5', '5', '5', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300573', '333', '5', '1', '3', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300574', '111', '3', '2', '4', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300575', '222', '2', '2', '5', '5');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300576', '333', '5', '1', '1', '0');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300577', '111', '4', '1', '2', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300578', '222', '2', '1', '2', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300579', '333', '4', '1', '4', '3');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300580', '111', '5', '1', '5', '5');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300581', '222', '3', '2', '5', '0');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300582', '333', '2', '1', '3', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300583', '111', '3', '2', '4', '0');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300584', '222', '4', '2', '5', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300585', '333', '1', '1', '3', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300586', '111', '6', '3', '4', '0');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300587', '222', '4', '3', '3', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300588', '333', '5', '1', '4', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300589', '111', '5', '1', '5', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300590', '222', '4', '1', '3', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300591', '333', '2', '2', '3', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300592', '111', '4', '2', '3', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300593', '222', '3', '3', '4', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300594', '333', '4', '1', '5', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300595', '111', '5', '1', '5', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300596', '222', '5', '4', '3', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300597', '333', '3', '1', '2', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300598', '111', '2', '2', '5', '2');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300599', '222', '5', '5', '3', '1');
            INSERT INTO witricity.Config_Detail (Config_ID, Transmitter_Type_ID, Max_Transmitters, Min_Transmitters, Max_Booster_Req, Min_Booster_Req) VALUES ('300600', '333', '3', '1', '4', '2');
            --
            select 'After inserting data into table Config_Detail';
            --
            COMMIT;
            --
        END IF; 
        --
       END IF;
       --
             --
 
END 
$$


--
-- Event_Master table Error Handling and data Insert
--



DELIMITER $$  

CREATE PROCEDURE Event_Master_data_insert(pdata_insert varchar(2),pdata varchar(2000),ptable_name varchar(50))

   BEGIN
      -- Declaration Section
      --
	  DECLARE l_string varchar(2000) DEFAULT NULL;
	  DECLARE l_occurences INT default 0;
	  DECLARE l_column1 varchar(200) default NULL;
      DECLARE l_column2 varchar(200) default NULL;
      DECLARE l_column3 varchar(200) default NULL;
      DECLARE l_column4 varchar(200) default NULL;
      DECLARE l_column5 varchar(200) default NULL;
      DECLARE l_no_of_columns INT DEFAULT 0;
      DECLARE l_error_message varchar(200) default NULL;
      --
     -- DECLARE CONTINUE HANDLER FOR 1062 SELECT 'Duplicate keys error encountered while inserting data in Event_Master table' into l_error_message;
      DECLARE CONTINUE HANDLER FOR SQLEXCEPTION -- SELECT 'SQLException encountered while inserting data in Event_Master table' into l_error_message; 
	--  DECLARE CONTINUE HANDLER FOR 1452 select 'Foreign key constraint violated while inserting data in Event_Master table' into l_error_message;
      --
     BEGIN
        --
		get diagnostics condition 1
		       
          @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
			SET @full_error = CONCAT("ERROR ", @errno, @text);
		  
		
		IF @full_error like 'ERROR 1452Cannot add or update a child row: a foreign key constraint fails%' then
		   INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('Event_Master',pdata,'Foreign key constraint violated',SYSDATE());
		END IF;
		--
		SET l_error_message =  @full_error;
		--
        INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('Event_Master',pdata,l_error_message,SYSDATE());
             commit;
        
        END;
      --
     IF pdata_insert NOT IN ('Y','N') THEN
         --
         SIGNAL SQLSTATE '45000'
         SET MESSAGE_TEXT = 'Invalid value passed to first parameter.(Valid value:Y/N)';
         INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('Event_Master',pdata,'Invalid value passed to first parameter.(Valid value:Y/N)',SYSDATE());
             commit; 
     ELSE 
      --
	  if pdata_insert = 'Y' then
	    --
        SET l_string = pdata;
	    --
        SELECT LENGTH(l_string) - LENGTH(REPLACE(l_string, '|', ''))+1 into l_occurences; 
	    --
        SELECT COUNT(*) into l_no_of_columns
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE upper(table_schema) = upper('witricity')
        AND upper(table_name) = upper(ptable_name);
        --
         IF(l_no_of_columns != l_occurences) THEN 
          SIGNAL SQLSTATE '45000'
          SET MESSAGE_TEXT = 'Insufficient data passed to the insert into table';
          --
          INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES(ptable_name,pdata,'Insufficient data passed to the insert into table',SYSDATE());
             commit; 
         ELSE
             --
             SET l_column1 = SPLIT_STR(pdata,'|',1);
             SET l_column2 = SPLIT_STR(pdata,'|',2);
             SET l_column3 = SPLIT_STR(pdata,'|',3);
             SET l_column4 = SPLIT_STR(pdata,'|',4);
             SET l_column5 = SPLIT_STR(pdata,'|',5);
             -- 
             START TRANSACTION;
             -- insert a new record into table
             INSERT INTO Event_Master(Event_ID ,Event_Name,Event_Date,Day_of_week,Location_Identifier)
             VALUES(convert(l_column1, SIGNED INTEGER),l_column2,STR_TO_DATE(l_column3,'%y/%m/%d'),l_column4,convert(l_column5, SIGNED INTEGER));
             -- 
             COMMIT;
             --
           END IF;
           --
       ELSE  -- Insert the bulk data using inseet statements pdata_insert = N
             --
            INSERT INTO witricity.Event_Master (Event_ID, Event_Name, Event_Date, Day_of_week, Location_Identifier) VALUES ('200', 'Fall Fest', '2015/09/07', 'Mon', '1');
            INSERT INTO witricity.Event_Master (Event_ID, Event_Name, Event_Date, Day_of_week, Location_Identifier) VALUES ('201', 'Welcome ', '2015/09/15', 'Tue', '2');
            INSERT INTO witricity.Event_Master (Event_ID, Event_Name, Event_Date, Day_of_week, Location_Identifier) VALUES ('202', 'Homecoming', '2015/09/16', 'Wed', '3');
            INSERT INTO witricity.Event_Master (Event_ID, Event_Name, Event_Date, Day_of_week, Location_Identifier) VALUES ('203', 'LASO', '2015/09/17', 'Thu', '4');
            INSERT INTO witricity.Event_Master (Event_ID, Event_Name, Event_Date, Day_of_week, Location_Identifier) VALUES ('204', 'Spring Fest', '2015/09/18', 'Fri', '5');
            INSERT INTO witricity.Event_Master (Event_ID, Event_Name, Event_Date, Day_of_week, Location_Identifier) VALUES ('205', 'Halloween', '2015/09/19', 'Sat', '6');
            INSERT INTO witricity.Event_Master (Event_ID, Event_Name, Event_Date, Day_of_week, Location_Identifier) VALUES ('206', 'Homecoming', '2015/09/20', 'Sun', '7');
            INSERT INTO witricity.Event_Master (Event_ID, Event_Name, Event_Date, Day_of_week, Location_Identifier) VALUES ('207', 'Homecoming', '2015/09/21', 'Mon', '8');
            INSERT INTO witricity.Event_Master (Event_ID, Event_Name, Event_Date, Day_of_week, Location_Identifier) VALUES ('208', 'Homecoming', '2015/09/22', 'Tue', '9');
            INSERT INTO witricity.Event_Master (Event_ID, Event_Name, Event_Date, Day_of_week, Location_Identifier) VALUES ('209', 'Homecoming', '2015/09/23', 'Wed', '10');
            INSERT INTO witricity.Event_Master (Event_ID, Event_Name, Event_Date, Day_of_week, Location_Identifier) VALUES ('210', 'Homecoming', '2015/09/24', 'Thu', '11');
            INSERT INTO witricity.Event_Master (Event_ID, Event_Name, Event_Date, Day_of_week, Location_Identifier) VALUES ('211', 'Homecoming', '2015/09/25', 'Fri', '12');
            INSERT INTO witricity.Event_Master (Event_ID, Event_Name, Event_Date, Day_of_week, Location_Identifier) VALUES ('212', 'Homecoming', '2015/09/26', 'Sat', '13');
            INSERT INTO witricity.Event_Master (Event_ID, Event_Name, Event_Date, Day_of_week, Location_Identifier) VALUES ('213', 'Homecoming', '2015/09/27', 'Sun', '14');
            INSERT INTO witricity.Event_Master (Event_ID, Event_Name, Event_Date, Day_of_week, Location_Identifier) VALUES ('214', 'Homecoming', '2015/09/28', 'Mon', '15');
            INSERT INTO witricity.Event_Master (Event_ID, Event_Name, Event_Date, Day_of_week, Location_Identifier) VALUES ('215', 'Homecoming', '2015/09/29', 'Tue', '16');
            INSERT INTO witricity.Event_Master (Event_ID, Event_Name, Event_Date, Day_of_week, Location_Identifier) VALUES ('216', 'LASO', '2015/09/30', 'Wed', '17');
            INSERT INTO witricity.Event_Master (Event_ID, Event_Name, Event_Date, Day_of_week, Location_Identifier) VALUES ('217', 'Welcome ', '2015/10/01', 'Thu', '18');
            INSERT INTO witricity.Event_Master (Event_ID, Event_Name, Event_Date, Day_of_week, Location_Identifier) VALUES ('218', 'Welcome ', '2015/10/02', 'Fri', '19');
            INSERT INTO witricity.Event_Master (Event_ID, Event_Name, Event_Date, Day_of_week, Location_Identifier) VALUES ('219', 'Welcome ', '2015/10/03', 'Sat', '20');
            INSERT INTO witricity.Event_Master (Event_ID, Event_Name, Event_Date, Day_of_week, Location_Identifier) VALUES ('220', 'Welcome ', '2015/10/04', 'Sun', '21');
            INSERT INTO witricity.Event_Master (Event_ID, Event_Name, Event_Date, Day_of_week, Location_Identifier) VALUES ('221', 'Welcome ', '2015/10/05', 'Mon', '22');
            INSERT INTO witricity.Event_Master (Event_ID, Event_Name, Event_Date, Day_of_week, Location_Identifier) VALUES ('222', 'Welcome ', '2015/10/06', 'Tue', '23');
            INSERT INTO witricity.Event_Master (Event_ID, Event_Name, Event_Date, Day_of_week, Location_Identifier) VALUES ('223', 'Welcome ', '2015/10/07', 'Wed', '24');
            INSERT INTO witricity.Event_Master (Event_ID, Event_Name, Event_Date, Day_of_week, Location_Identifier) VALUES ('224', 'Welcome ', '2015/10/08', 'Thu', '25');
            INSERT INTO witricity.Event_Master (Event_ID, Event_Name, Event_Date, Day_of_week, Location_Identifier) VALUES ('225', 'Welcome ', '2015/10/09', 'Fri', '26');
            INSERT INTO witricity.Event_Master (Event_ID, Event_Name, Event_Date, Day_of_week, Location_Identifier) VALUES ('226', 'Workshop', '2015/10/10', 'Sat', '27');
            INSERT INTO witricity.Event_Master (Event_ID, Event_Name, Event_Date, Day_of_week, Location_Identifier) VALUES ('227', 'Cultural fest', '2015/10/11', 'Sun', '28');
            INSERT INTO witricity.Event_Master (Event_ID, Event_Name, Event_Date, Day_of_week, Location_Identifier) VALUES ('228', 'Diwali', '2015/10/12', 'Mon', '29');
            INSERT INTO witricity.Event_Master (Event_ID, Event_Name, Event_Date, Day_of_week, Location_Identifier) VALUES ('229', 'Ganesh Chaturthi', '2015/10/13', 'Tue', '30');
            INSERT INTO witricity.Event_Master (Event_ID, Event_Name, Event_Date, Day_of_week, Location_Identifier) VALUES ('230', 'Thanksgiving', '2015/10/14', 'Wed', '31');
            INSERT INTO witricity.Event_Master (Event_ID, Event_Name, Event_Date, Day_of_week, Location_Identifier) VALUES ('231', 'Seminar', '2015/10/15', 'Thu', '32');
            INSERT INTO witricity.Event_Master (Event_ID, Event_Name, Event_Date, Day_of_week, Location_Identifier) VALUES ('232', 'Seminar', '2015/10/16', 'Fri', '33');
            INSERT INTO witricity.Event_Master (Event_ID, Event_Name, Event_Date, Day_of_week, Location_Identifier) VALUES ('233', 'Seminar', '2015/10/17', 'Sat', '34');
            INSERT INTO witricity.Event_Master (Event_ID, Event_Name, Event_Date, Day_of_week, Location_Identifier) VALUES ('234', 'Seminar', '2015/10/18', 'Sun', '35');
            INSERT INTO witricity.Event_Master (Event_ID, Event_Name, Event_Date, Day_of_week, Location_Identifier) VALUES ('235', 'Seminar', '2015/10/19', 'Mon', '36');
            INSERT INTO witricity.Event_Master (Event_ID, Event_Name, Event_Date, Day_of_week, Location_Identifier) VALUES ('236', 'Seminar', '2015/10/20', 'Tue', '37');
            INSERT INTO witricity.Event_Master (Event_ID, Event_Name, Event_Date, Day_of_week, Location_Identifier) VALUES ('237', 'Seminar', '2015/10/21', 'Wed', '38');
            INSERT INTO witricity.Event_Master (Event_ID, Event_Name, Event_Date, Day_of_week, Location_Identifier) VALUES ('238', 'Seminar', '2015/10/22', 'Thu', '39');
            INSERT INTO witricity.Event_Master (Event_ID, Event_Name, Event_Date, Day_of_week, Location_Identifier) VALUES ('239', 'Seminar', '2015/10/23', 'Fri', '40');
            INSERT INTO witricity.Event_Master (Event_ID, Event_Name, Event_Date, Day_of_week, Location_Identifier) VALUES ('240', 'Seminar', '2015/10/24', 'Sat', '41');
            INSERT INTO witricity.Event_Master (Event_ID, Event_Name, Event_Date, Day_of_week, Location_Identifier) VALUES ('241', 'Seminar', '2015/10/25', 'Sun', '42');
            INSERT INTO witricity.Event_Master (Event_ID, Event_Name, Event_Date, Day_of_week, Location_Identifier) VALUES ('242', 'Seminar', '2015/10/26', 'Mon', '43');
            INSERT INTO witricity.Event_Master (Event_ID, Event_Name, Event_Date, Day_of_week, Location_Identifier) VALUES ('243', 'Seminar', '2015/10/27', 'Tue', '44');
            INSERT INTO witricity.Event_Master (Event_ID, Event_Name, Event_Date, Day_of_week, Location_Identifier) VALUES ('244', 'Workshop', '2015/10/28', 'Wed', '45');
            INSERT INTO witricity.Event_Master (Event_ID, Event_Name, Event_Date, Day_of_week, Location_Identifier) VALUES ('245', 'Workshop', '2015/10/29', 'Thu', '46');
            INSERT INTO witricity.Event_Master (Event_ID, Event_Name, Event_Date, Day_of_week, Location_Identifier) VALUES ('246', 'Workshop', '2015/10/30', 'Fri', '47');
            INSERT INTO witricity.Event_Master (Event_ID, Event_Name, Event_Date, Day_of_week, Location_Identifier) VALUES ('247', 'Spring Fest', '2015/10/31', 'Sat', '48');
            INSERT INTO witricity.Event_Master (Event_ID, Event_Name, Event_Date, Day_of_week, Location_Identifier) VALUES ('248', 'Health and fitness', '2015/11/01', 'Sun', '49');
            INSERT INTO witricity.Event_Master (Event_ID, Event_Name, Event_Date, Day_of_week, Location_Identifier) VALUES ('249', 'Health and fitness', '2015/11/02', 'Mon', '50');
            --
            select 'Aftre inserting data into table Event_Master';
            --
            COMMIT;
            --
        END IF; 
       --
       END IF;
       --        
        
        
    
END 
$$

--
--- Config_event_mapping table Error Handling and data Insert
--


DELIMITER $$  

CREATE PROCEDURE Config_event_mapping_data_insert(pdata_insert varchar(2),pdata varchar(2000),ptable_name varchar(50))

   BEGIN
      -- Declaration Section
      --
	  DECLARE l_string varchar(2000) DEFAULT NULL;
	  DECLARE l_occurences INT default 0;
	  DECLARE l_column1 varchar(200) default NULL;
      DECLARE l_column2 varchar(200) default NULL;
      DECLARE l_no_of_columns INT DEFAULT 0;
      DECLARE l_error_message varchar(200) default NULL;
      
     -- DECLARE CONTINUE HANDLER FOR 1062 SELECT 'Duplicate keys error encountered while inserting data in Config_event_mapping table' into l_error_message;
      DECLARE CONTINUE HANDLER FOR SQLEXCEPTION -- SELECT 'SQLException encountered while inserting data in Config_event_mapping table' into l_error_message; 
	 -- DECLARE CONTINUE HANDLER FOR 1452 select 'Foreign key constraint violated while inserting data in Config_event_mapping table' into l_error_message;
      --
      BEGIN
        --
		get diagnostics condition 1
		       
          @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
			SET @full_error = CONCAT("ERROR ", @errno, @text);
		  
		
		IF @full_error like 'ERROR 1452Cannot add or update a child row: a foreign key constraint fails%' then
		   INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('Config_event_mapping',pdata,'Foreign key constraint violated',SYSDATE());
		END IF;
		--
		SET l_error_message =  @full_error;
		--
        INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('Config_event_mapping',pdata,l_error_message,SYSDATE());
             commit;
        
        END;
		--
      IF pdata_insert NOT IN ('Y','N') THEN
         --
         SIGNAL SQLSTATE '45000'
         SET MESSAGE_TEXT = 'Invalid value passed to first parameter.(Valid value:Y/N)';
         INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('Config_event_mapping',pdata,'Invalid value passed to first parameter.(Valid value:Y/N)',SYSDATE());
             commit; 
     ELSE 
      --
	  if pdata_insert = 'Y' then
	    --
        SET l_string = pdata;
	    --
        SELECT LENGTH(l_string) - LENGTH(REPLACE(l_string, '|', ''))+1 into l_occurences; 
	    --
        SELECT COUNT(*) into l_no_of_columns
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE upper(table_schema) = upper('witricity')
        AND upper(table_name) = upper(ptable_name);
        --
         IF(l_no_of_columns != l_occurences) THEN 
          SIGNAL SQLSTATE '45000'
          SET MESSAGE_TEXT = 'Insufficient data passed to the insert data';
          --
          INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES(ptable_name,pdata,'Insufficient data passed to the insert data',SYSDATE());
             commit; 
         ELSE
             --
             SET l_column1 = SPLIT_STR(pdata,'|',1);
             SET l_column2 = SPLIT_STR(pdata,'|',2);
             -- 
             START TRANSACTION;
             -- insert a new record into table
             INSERT INTO Config_event_mapping(Config_ID ,Event_ID)
             VALUES(convert(l_column1, SIGNED INTEGER),convert(l_column2, SIGNED INTEGER));
             -- 
             COMMIT;
             --
           END IF;
           --
       ELSE  -- Insert the bulk data using inseet statements pdata_insert = N
             --
             -- select 'Inside pdata_insert N';
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300301', '243');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300302', '207');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300303', '246');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300304', '234');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300305', '202');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300306', '221');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300307', '202');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300308', '223');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300309', '204');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300310', '220');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300311', '208');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300312', '231');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300313', '218');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300314', '223');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300315', '216');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300316', '226');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300317', '245');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300318', '202');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300319', '247');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300320', '245');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300321', '238');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300322', '204');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300323', '201');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300324', '221');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300325', '249');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300326', '202');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300327', '207');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300328', '226');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300329', '205');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300330', '203');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300331', '201');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300332', '210');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300333', '237');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300334', '215');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300335', '223');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300336', '213');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300337', '200');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300338', '202');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300339', '244');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300340', '201');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300341', '237');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300342', '232');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300343', '214');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300344', '201');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300345', '213');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300346', '205');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300347', '239');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300348', '223');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300349', '239');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300350', '238');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300351', '220');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300352', '243');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300353', '245');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300354', '221');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300355', '235');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300356', '242');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300357', '231');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300358', '224');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300359', '226');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300360', '223');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300361', '215');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300362', '245');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300363', '219');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300364', '242');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300365', '207');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300366', '213');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300367', '237');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300368', '211');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300369', '208');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300370', '241');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300371', '243');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300372', '230');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300373', '205');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300374', '212');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300375', '225');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300376', '200');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300377', '241');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300378', '245');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300379', '245');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300380', '225');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300381', '237');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300382', '227');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300383', '202');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300384', '214');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300385', '228');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300386', '245');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300387', '217');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300388', '221');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300389', '238');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300390', '226');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300391', '241');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300392', '228');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300393', '224');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300394', '232');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300395', '235');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300396', '205');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300397', '229');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300398', '214');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300399', '220');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300400', '242');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300401', '239');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300402', '223');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300403', '239');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300404', '238');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300405', '220');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300406', '243');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300407', '245');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300408', '221');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300409', '235');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300410', '242');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300411', '231');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300412', '224');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300413', '226');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300414', '223');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300415', '215');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300416', '245');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300417', '226');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300418', '245');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300419', '202');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300420', '247');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300421', '245');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300422', '238');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300423', '204');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300424', '201');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300425', '221');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300426', '249');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300427', '202');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300428', '207');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300429', '226');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300430', '205');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300431', '203');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300432', '201');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300433', '210');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300434', '237');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300435', '215');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300436', '223');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300437', '213');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300438', '200');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300439', '202');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300440', '244');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300441', '201');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300442', '237');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300443', '232');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300444', '201');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300445', '210');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300446', '237');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300447', '215');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300448', '223');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300449', '213');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300450', '200');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300451', '202');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300452', '244');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300453', '201');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300454', '237');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300455', '232');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300456', '214');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300457', '201');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300458', '213');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300459', '205');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300460', '207');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300461', '246');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300462', '234');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300463', '202');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300464', '221');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300465', '202');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300466', '223');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300467', '204');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300468', '220');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300469', '208');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300470', '231');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300471', '218');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300472', '223');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300473', '216');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300474', '226');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300475', '245');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300476', '202');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300477', '247');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300478', '245');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300479', '238');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300480', '204');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300481', '201');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300482', '221');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300483', '249');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300484', '202');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300485', '207');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300486', '226');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300487', '205');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300488', '203');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300489', '201');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300490', '210');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300491', '237');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300492', '215');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300493', '223');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300494', '213');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300495', '200');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300496', '202');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300497', '244');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300498', '201');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300499', '237');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300500', '232');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300501', '214');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300502', '201');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300503', '213');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300504', '205');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300505', '239');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300506', '223');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300507', '239');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300508', '238');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300509', '220');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300510', '243');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300511', '245');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300512', '221');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300513', '235');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300514', '242');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300515', '231');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300516', '224');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300517', '226');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300518', '223');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300519', '215');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300520', '245');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300521', '219');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300522', '242');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300523', '207');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300524', '213');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300525', '237');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300526', '211');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300527', '208');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300528', '241');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300529', '243');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300530', '230');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300531', '205');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300532', '212');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300533', '225');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300534', '200');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300535', '241');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300536', '245');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300537', '245');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300538', '225');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300539', '237');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300540', '227');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300541', '202');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300542', '214');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300543', '228');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300544', '245');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300545', '217');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300546', '221');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300547', '238');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300548', '226');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300549', '241');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300550', '228');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300551', '224');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300552', '232');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300553', '235');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300554', '205');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300555', '229');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300556', '214');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300557', '220');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300558', '242');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300559', '219');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300560', '242');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300561', '207');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300562', '213');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300563', '237');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300564', '211');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300565', '208');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300566', '241');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300567', '243');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300568', '230');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300569', '205');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300570', '212');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300571', '225');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300572', '200');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300573', '241');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300574', '245');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300575', '245');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300576', '234');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300577', '202');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300578', '221');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300579', '202');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300580', '223');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300581', '204');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300582', '220');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300583', '208');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300584', '231');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300585', '218');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300586', '223');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300587', '216');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300588', '226');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300589', '245');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300590', '202');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300591', '247');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300592', '245');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300593', '238');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300594', '204');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300595', '201');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300596', '221');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300597', '249');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300598', '202');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300599', '207');
            INSERT INTO witricity.Config_event_mapping (Config_ID, Event_ID) VALUES ('300600', '226');
              
           select 'After inserting data into table Config_event_mapping';
             
             COMMIT;
            
        END IF; 
      --
      END IF;
      --      
     
      --  

END 
$$

--
--- Config_day_mapping table Error Handling and data Insert
--



DELIMITER $$  

CREATE PROCEDURE Config_day_mapping_data_insert(pdata_insert varchar(2),pdata varchar(2000),ptable_name varchar(50))

   BEGIN
      -- Declaration Section
      --
	  DECLARE l_string varchar(2000) DEFAULT NULL;
	  DECLARE l_occurences INT default 0;
	  DECLARE l_column1 varchar(200) default NULL;
      DECLARE l_column2 varchar(200) default NULL;
      DECLARE l_column3 varchar(200) default NULL;
      DECLARE l_column4 varchar(200) default NULL;
      DECLARE l_no_of_columns INT DEFAULT 0;
      DECLARE l_error_message varchar(200) default NULL;
      --
    --  DECLARE CONTINUE HANDLER FOR 1062 SELECT 'Duplicate keys error encountered while inserting data in Config_day_mapping table' into l_error_message;
      DECLARE CONTINUE HANDLER FOR SQLEXCEPTION -- SELECT 'SQLException encountered while inserting data in Config_day_mapping table' into l_error_message; 
	--  DECLARE CONTINUE HANDLER FOR 1452 select 'Foreign key constraint violated while inserting data in Config_day_mapping table' into l_error_message;
      --
       BEGIN
        --
		get diagnostics condition 1
		       
          @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
			SET @full_error = CONCAT("ERROR ", @errno, @text);
		  
		
		IF @full_error like 'ERROR 1452Cannot add or update a child row: a foreign key constraint fails%' then
		   INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('Config_day_mapping',pdata,'Foreign key constraint violated',SYSDATE());
		END IF;
		--
		SET l_error_message =  @full_error;
		--
        INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('Config_day_mapping',pdata,l_error_message,SYSDATE());
             commit;
        
        END;
      --
     IF pdata_insert NOT IN ('Y','N') THEN
         --
         SIGNAL SQLSTATE '45000'
         SET MESSAGE_TEXT = 'Invalid value passed to first parameter.(Valid value:Y/N)';
         INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('Config_day_mapping',pdata,'Invalid value passed to first parameter.(Valid value:Y/N)',SYSDATE());
             commit; 
     ELSE 
      --
	  if pdata_insert = 'Y' then
	    --
        SET l_string = pdata;
	    --
        SELECT LENGTH(l_string) - LENGTH(REPLACE(l_string, '|', ''))+1 into l_occurences; 
	    --
        SELECT COUNT(*) into l_no_of_columns
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE upper(table_schema) = upper('witricity')
        AND upper(table_name) = upper(ptable_name);
        --
        IF(l_no_of_columns != l_occurences) THEN 
          SIGNAL SQLSTATE '45000'
          SET MESSAGE_TEXT = 'Insufficient data passed to the insert into table';
          --
          INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES(ptable_name,pdata,'Insufficient data passed to the insert into table',SYSDATE());
             commit;
         ELSE
             --
             SET l_column1 = SPLIT_STR(pdata,'|',1);
             SET l_column2 = SPLIT_STR(pdata,'|',2);
             SET l_column3 = SPLIT_STR(pdata,'|',3);
             SET l_column4 = SPLIT_STR(pdata,'|',4);
            --
            START TRANSACTION;
             -- insert a new record into table
             INSERT INTO Config_day_mapping(Config_ID ,Day_of_week,Location_Identifier,On_Date)
             VALUES(convert(l_column1, SIGNED INTEGER),l_column2,convert(l_column3, SIGNED INTEGER),STR_TO_DATE(l_column4,'%y%m%d'));
             -- 
             COMMIT;
             --
           END IF;
           --
       ELSE  -- Insert the bulk data using inseet statements pdata_insert = N
             --
             -- select 'Inside pdata_insert N';
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300301', 'Mon', '45', '20151103');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300302', 'Tue', '42', '20160311');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300303', 'Wed', '22', '20160719');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300304', 'Thu', '4', '20160711');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300305', 'Fri', '49', '20161021');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300306', 'Sat', '60', '20160528');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300307', 'Sun', '49', '20161002');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300308', 'Mon', '92', '20150815');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300309', 'Tue', '94', '20150915');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300310', 'Wed', '49', '20160815');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300311', 'Thu', '7', '20150709');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300312', 'Fri', '58', '20150330');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300313', 'Sat', '94', '20150701');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300314', 'Sun', '89', '20160718');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300315', 'Mon', '48', '20150515');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300316', 'Tue', '51', '20160920');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300317', 'Wed', '101', '20160106');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300318', 'Thu', '87', '20150912');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300319', 'Fri', '9', '20161011');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300320', 'Sat', '90', '20141206');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300321', 'Sun', '58', '20160602');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300322', 'Mon', '19', '20160805');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300323', 'Tue', '43', '20150705');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300324', 'Wed', '25', '20150512');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300325', 'Thu', '98', '20160402');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300326', 'Fri', '100', '20160208');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300327', 'Sat', '9', '20160424');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300328', 'Sun', '83', '20150322');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300329', 'Mon', '19', '20151120');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300330', 'Tue', '3', '20161025');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300331', 'Wed', '43', '20160515');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300332', 'Thu', '94', '20150723');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300333', 'Fri', '69', '20151024');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300334', 'Sat', '4', '20160820');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300335', 'Sun', '1', '20150105');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300336', 'Mon', '14', '20150601');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300337', 'Tue', '72', '20151008');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300338', 'Wed', '59', '20160702');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300339', 'Thu', '3', '20150615');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300340', 'Fri', '79', '20160622');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300341', 'Sat', '71', '20160823');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300342', 'Sun', '26', '20160810');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300343', 'Mon', '46', '20160824');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300344', 'Tue', '100', '20151125');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300345', 'Wed', '50', '20160604');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300346', 'Thu', '64', '20151125');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300347', 'Fri', '88', '20160622');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300348', 'Sat', '70', '20160427');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300349', 'Sun', '10', '20150520');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300350', 'Mon', '7', '20160610');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300351', 'Tue', '15', '20160809');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300352', 'Wed', '19', '20141128');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300353', 'Thu', '17', '20150816');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300354', 'Fri', '96', '20160827');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300355', 'Sat', '76', '20160706');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300356', 'Sun', '51', '20150309');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300357', 'Mon', '90', '20150622');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300358', 'Tue', '14', '20160814');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300359', 'Wed', '2', '20150110');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300360', 'Thu', '33', '20150618');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300361', 'Fri', '50', '20160306');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300362', 'Sat', '16', '20150511');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300363', 'Sun', '74', '20160421');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300364', 'Mon', '58', '20161104');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300365', 'Tue', '85', '20150706');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300366', 'Wed', '37', '20150926');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300367', 'Thu', '92', '20151005');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300368', 'Fri', '91', '20141226');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300369', 'Sat', '90', '20160605');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300370', 'Sun', '36', '20160918');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300371', 'Mon', '43', '20160127');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300372', 'Tue', '9', '20141202');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300373', 'Wed', '71', '20160212');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300374', 'Thu', '40', '20150405');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300375', 'Fri', '64', '20160923');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300376', 'Sat', '23', '20150217');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300377', 'Sun', '29', '20141229');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300378', 'Mon', '36', '20150509');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300379', 'Tue', '94', '20160510');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300380', 'Wed', '42', '20160807');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300381', 'Thu', '24', '20160214');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300382', 'Fri', '95', '20150126');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300383', 'Sat', '58', '20160817');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300384', 'Sun', '47', '20150513');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300385', 'Mon', '46', '20141204');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300386', 'Tue', '84', '20161018');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300387', 'Wed', '74', '20150225');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300388', 'Thu', '25', '20160221');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300389', 'Fri', '14', '20151112');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300390', 'Sat', '61', '20160212');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300391', 'Sun', '24', '20161002');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300392', 'Mon', '4', '20160730');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300393', 'Tue', '75', '20150911');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300394', 'Wed', '61', '20141217');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300395', 'Thu', '4', '20160207');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300396', 'Fri', '27', '20141202');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300397', 'Sat', '80', '20160416');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300398', 'Sun', '98', '20151218');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300399', 'Mon', '54', '20160224');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300400', 'Tue', '55', '20150907');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300401', 'Wed', '100', '20150315');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300402', 'Thu', '50', '20151116');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300403', 'Fri', '64', '20160719');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300404', 'Sat', '88', '20160711');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300405', 'Sun', '70', '20161021');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300406', 'Mon', '10', '20160528');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300407', 'Tue', '7', '20161002');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300408', 'Wed', '15', '20150815');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300409', 'Thu', '19', '20150915');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300410', 'Fri', '17', '20160815');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300411', 'Sat', '96', '20150709');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300412', 'Sun', '76', '20150330');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300413', 'Mon', '51', '20150701');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300414', 'Tue', '90', '20160718');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300415', 'Wed', '14', '20150515');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300416', 'Thu', '2', '20160920');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300417', 'Fri', '24', '20160106');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300418', 'Sat', '4', '20150912');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300419', 'Sun', '75', '20161011');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300420', 'Mon', '61', '20141206');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300421', 'Tue', '36', '20160602');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300422', 'Wed', '94', '20160805');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300423', 'Thu', '42', '20150705');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300424', 'Fri', '24', '20150512');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300425', 'Sat', '95', '20160402');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300426', 'Sun', '58', '20160208');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300427', 'Mon', '47', '20160424');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300428', 'Tue', '46', '20150322');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300429', 'Wed', '84', '20151120');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300430', 'Thu', '74', '20161025');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300431', 'Fri', '25', '20160515');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300432', 'Sat', '14', '20150723');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300433', 'Sun', '61', '20151024');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300434', 'Mon', '24', '20160820');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300435', 'Tue', '1', '20150105');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300436', 'Wed', '75', '20150601');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300437', 'Thu', '61', '20151008');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300438', 'Fri', '24', '20160702');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300439', 'Sat', '4', '20150615');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300440', 'Sun', '84', '20160622');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300441', 'Mon', '74', '20160823');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300442', 'Tue', '25', '20160810');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300443', 'Wed', '14', '20160824');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300444', 'Thu', '61', '20151125');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300445', 'Fri', '24', '20160604');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300446', 'Sat', '4', '20151125');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300447', 'Sun', '75', '20160622');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300448', 'Mon', '61', '20160427');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300449', 'Tue', '4', '20150520');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300450', 'Wed', '27', '20160610');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300451', 'Thu', '80', '20160809');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300452', 'Fri', '98', '20141128');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300453', 'Sat', '54', '20150816');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300454', 'Sun', '55', '20160827');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300455', 'Mon', '1', '20160706');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300456', 'Tue', '5', '20150309');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300457', 'Wed', '2', '20150622');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300458', 'Thu', '21', '20160814');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300459', 'Fri', '58', '20150110');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300460', 'Sat', '47', '20150618');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300461', 'Sun', '46', '20160306');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300462', 'Mon', '84', '20150511');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300463', 'Tue', '74', '20160421');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300464', 'Wed', '25', '20161104');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300465', 'Thu', '14', '20150706');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300466', 'Fri', '61', '20150926');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300467', 'Sat', '24', '20151005');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300468', 'Sun', '4', '20141226');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300469', 'Mon', '75', '20160605');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300470', 'Tue', '61', '20160918');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300471', 'Wed', '4', '20160127');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300472', 'Thu', '27', '20141202');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300473', 'Fri', '80', '20160212');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300474', 'Sat', '98', '20150405');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300475', 'Sun', '54', '20160923');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300476', 'Mon', '100', '20150217');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300477', 'Tue', '50', '20141229');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300478', 'Wed', '64', '20150509');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300479', 'Thu', '88', '20160510');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300480', 'Fri', '70', '20160807');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300481', 'Sat', '101', '20160214');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300482', 'Sun', '7', '20150126');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300483', 'Mon', '15', '20160817');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300484', 'Tue', '19', '20150513');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300485', 'Wed', '17', '20141204');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300486', 'Thu', '96', '20161018');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300487', 'Fri', '76', '20150225');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300488', 'Sat', '51', '20160221');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300489', 'Sun', '90', '20151112');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300490', 'Mon', '14', '20160212');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300491', 'Tue', '2', '20161002');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300492', 'Wed', '42', '20160730');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300493', 'Thu', '22', '20150911');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300494', 'Fri', '4', '20141217');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300495', 'Sat', '49', '20160207');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300496', 'Sun', '60', '20141202');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300497', 'Mon', '49', '20160416');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300498', 'Tue', '92', '20151218');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300499', 'Wed', '94', '20160224');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300500', 'Thu', '49', '20150907');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300501', 'Fri', '7', '20150315');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300502', 'Sat', '58', '20151116');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300503', 'Sun', '94', '20160719');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300504', 'Mon', '89', '20160711');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300505', 'Tue', '48', '20161021');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300506', 'Wed', '51', '20160528');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300507', 'Thu', '1', '20161002');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300508', 'Fri', '87', '20150815');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300509', 'Sat', '9', '20150915');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300510', 'Sun', '90', '20160815');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300511', 'Mon', '58', '20150709');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300512', 'Tue', '19', '20150330');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300513', 'Wed', '43', '20150701');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300514', 'Thu', '25', '20160718');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300515', 'Fri', '98', '20150515');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300516', 'Sat', '100', '20160920');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300517', 'Sun', '9', '20160106');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300518', 'Mon', '83', '20150912');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300519', 'Tue', '19', '20161011');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300520', 'Wed', '3', '20141206');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300521', 'Thu', '43', '20160602');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300522', 'Fri', '94', '20160805');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300523', 'Sat', '69', '20150705');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300524', 'Sun', '4', '20150512');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300525', 'Mon', '1', '20160402');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300526', 'Tue', '14', '20160208');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300527', 'Wed', '72', '20160424');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300528', 'Thu', '59', '20150322');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300529', 'Fri', '3', '20151120');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300530', 'Sat', '79', '20161025');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300531', 'Sun', '71', '20160515');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300532', 'Mon', '26', '20150723');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300533', 'Tue', '101', '20151024');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300534', 'Wed', '100', '20160820');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300535', 'Thu', '50', '20150105');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300536', 'Fri', '1', '20150601');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300537', 'Sat', '88', '20151008');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300538', 'Sun', '70', '20160702');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300539', 'Mon', '10', '20150615');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300540', 'Tue', '7', '20160622');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300541', 'Wed', '15', '20160823');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300542', 'Thu', '19', '20160810');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300543', 'Fri', '17', '20160824');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300544', 'Sat', '96', '20151125');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300545', 'Sun', '76', '20160604');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300546', 'Mon', '51', '20151125');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300547', 'Tue', '90', '20160622');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300548', 'Wed', '14', '20160427');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300549', 'Thu', '2', '20150520');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300550', 'Fri', '33', '20160610');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300551', 'Sat', '50', '20160809');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300552', 'Sun', '16', '20141128');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300553', 'Mon', '74', '20150816');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300554', 'Tue', '58', '20160827');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300555', 'Wed', '85', '20160706');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300556', 'Thu', '37', '20150309');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300557', 'Fri', '92', '20150622');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300558', 'Sat', '91', '20160814');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300559', 'Sun', '90', '20150110');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300560', 'Mon', '36', '20150618');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300561', 'Tue', '43', '20160306');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300562', 'Wed', '9', '20150511');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300563', 'Thu', '71', '20160421');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300564', 'Fri', '40', '20161104');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300565', 'Sat', '64', '20150706');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300566', 'Sun', '23', '20150926');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300567', 'Mon', '29', '20151005');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300568', 'Tue', '36', '20141226');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300569', 'Wed', '94', '20160605');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300570', 'Thu', '42', '20160918');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300571', 'Fri', '24', '20160127');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300572', 'Sat', '95', '20141202');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300573', 'Sun', '58', '20160212');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300574', 'Mon', '47', '20150405');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300575', 'Tue', '46', '20160923');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300576', 'Wed', '84', '20150217');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300577', 'Thu', '74', '20141229');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300578', 'Fri', '25', '20150509');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300579', 'Sat', '14', '20160510');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300580', 'Sun', '61', '20160807');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300581', 'Mon', '24', '20160214');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300582', 'Tue', '4', '20150126');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300583', 'Wed', '75', '20160817');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300584', 'Thu', '61', '20150513');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300585', 'Fri', '4', '20141204');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300586', 'Sat', '27', '20161018');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300587', 'Sun', '80', '20150225');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300588', 'Mon', '98', '20160221');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300589', 'Tue', '54', '20151112');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300590', 'Wed', '55', '20160212');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300591', 'Thu', '87', '20161002');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300592', 'Fri', '9', '20160730');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300593', 'Sat', '90', '20150911');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300594', 'Sun', '58', '20141217');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300595', 'Mon', '19', '20160207');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300596', 'Tue', '43', '20141202');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300597', 'Wed', '25', '20160416');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300598', 'Thu', '98', '20151218');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300599', 'Fri', '100', '20160224');
            INSERT INTO witricity.Config_day_mapping (Config_ID, Day_of_week, Location_Identifier, On_Date) VALUES ('300600', 'Sat', '9', '20150907');

            select 'After inserting data into table Config_day_mapping';
             
             COMMIT;
            
        END IF; 
       END IF;
       --       
      
       --
END 
$$

--
-- Location_24_7  table Error Handling and data Insert
--



DELIMITER $$  

CREATE PROCEDURE Location_24_7_data_insert(pdata_insert varchar(2),pdata varchar(2000),ptable_name varchar(50))

   BEGIN
      -- Declaration Section
      --
	  DECLARE l_string varchar(2000) DEFAULT NULL;
	  DECLARE l_occurences INT default 0;
	  DECLARE l_column1 varchar(200) default NULL;
      DECLARE l_column2 varchar(200) default NULL;
      DECLARE l_no_of_columns INT DEFAULT 0;
      DECLARE l_error_message varchar(200) default NULL;
      --
    --  DECLARE CONTINUE HANDLER FOR 1062 SELECT 'Duplicate keys error encountered while inserting data in Location_24_7 table' into l_error_message;
      DECLARE CONTINUE HANDLER FOR SQLEXCEPTION -- SELECT 'SQLException encountered while inserting data in Location_24_7 table' into l_error_message; 
	--  DECLARE CONTINUE HANDLER FOR 1452 select 'Foreign key constraint violated while inserting data in Location_24_7 table' into l_error_message;
      --
      BEGIN
        --
		get diagnostics condition 1
		       
          @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
			SET @full_error = CONCAT("ERROR ", @errno, @text);
		  
		
		IF @full_error like 'ERROR 1452Cannot add or update a child row: a foreign key constraint fails%' then
		   INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('Location_24_7',pdata,'Foreign key constraint violated',SYSDATE());
		END IF;
		--
		SET l_error_message =  @full_error;
		--
        INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('Location_24_7',pdata,l_error_message,SYSDATE());
             commit;
        
        END;
      --
      IF pdata_insert NOT IN ('Y','N') THEN
         --
         SIGNAL SQLSTATE '45000'
         SET MESSAGE_TEXT = 'Invalid value passed to first parameter.(Valid value:Y/N)';
         INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('Location_24_7',pdata,'Invalid value passed to first parameter.(Valid value:Y/N)',SYSDATE());
             commit; 
     ELSE 
      --
	  if pdata_insert = 'Y' then
	    --
        SET l_string = pdata;
	    --
        SELECT LENGTH(l_string) - LENGTH(REPLACE(l_string, '|', ''))+1 into l_occurences; 
	    --
        SELECT COUNT(*) into l_no_of_columns
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE upper(table_schema) = upper('witricity')
        AND upper(table_name) = upper(ptable_name);
        --
         IF(l_no_of_columns != l_occurences) THEN 
          SIGNAL SQLSTATE '45001'
          SET MESSAGE_TEXT = 'Insufficient data passed to the insert into table';
          --
          INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES(ptable_name,pdata,'Insufficient data passed to the insert into table',SYSDATE());
             commit; 
         ELSE
             --
             SET l_column1 = SPLIT_STR(pdata,'|',1);
             SET l_column2 = SPLIT_STR(pdata,'|',2);
              -- 
             START TRANSACTION;
             -- insert a new record into table
             INSERT INTO Location_24_7(Location_Identifier,Reason)
             VALUES(convert(l_column1, SIGNED INTEGER),l_column2);
             -- 
             COMMIT;
             --
           END IF;
           --
       ELSE  -- Insert the bulk data using inseet statements pdata_insert = N
             --
             -- select 'Inside pdata_insert N';
            INSERT INTO witricity.Location_24_7 (Location_Identifier, Reason) VALUES ('1', 'Library');
            INSERT INTO witricity.Location_24_7 (Location_Identifier, Reason) VALUES ('2', 'Server Room');
            INSERT INTO witricity.Location_24_7 (Location_Identifier, Reason) VALUES ('3', 'Library');
            INSERT INTO witricity.Location_24_7 (Location_Identifier, Reason) VALUES ('4', 'Library');
            INSERT INTO witricity.Location_24_7 (Location_Identifier, Reason) VALUES ('5', 'Library');
            INSERT INTO witricity.Location_24_7 (Location_Identifier, Reason) VALUES ('6', 'Library');
            INSERT INTO witricity.Location_24_7 (Location_Identifier, Reason) VALUES ('7', 'Library');
            INSERT INTO witricity.Location_24_7 (Location_Identifier, Reason) VALUES ('8', 'Server Room');
            INSERT INTO witricity.Location_24_7 (Location_Identifier, Reason) VALUES ('9', 'Server Room');
            INSERT INTO witricity.Location_24_7 (Location_Identifier, Reason) VALUES ('10', 'Server Room');

             select 'After Inserting data into table Location_24_7';
             
             COMMIT;
            
        END IF; 
      END IF;  
      
       --
END 
$$

--
--- GPS_Location_Mapping   table Error Handling and data Insert
--



DELIMITER $$  

CREATE PROCEDURE GPS_Location_Mapping_data_insert(pdata_insert varchar(2),pdata varchar(2000),ptable_name varchar(50))

   BEGIN
      -- Declaration Section
      --
	  DECLARE l_string varchar(2000) DEFAULT NULL;
	  DECLARE l_occurences INT default 0;
	  DECLARE l_column1 varchar(200) default NULL;
      DECLARE l_column2 varchar(200) default NULL;
      DECLARE l_no_of_columns INT DEFAULT 0;
      DECLARE l_error_message varchar(200) default NULL;
      
    --  DECLARE CONTINUE HANDLER FOR 1062 SELECT 'Duplicate keys error encountered while inserting data in GPS_Location_Mapping table' into l_error_message;
      DECLARE CONTINUE HANDLER FOR SQLEXCEPTION -- SELECT 'SQLException encountered while inserting data in GPS_Location_Mapping table' into l_error_message; 
	 -- DECLARE CONTINUE HANDLER FOR 1452 select 'Foreign key constraint violated while inserting data in GPS_Location_Mapping table' into l_error_message;
      --
      BEGIN
        --
		get diagnostics condition 1
		       
          @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
			SET @full_error = CONCAT("ERROR ", @errno, @text);
		  
		
		IF @full_error like 'ERROR 1452Cannot add or update a child row: a foreign key constraint fails%' then
		   INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('GPS_Location_Mapping',pdata,'Foreign key constraint violated',SYSDATE());
		END IF;
		--
		SET l_error_message =  @full_error;
		--
        INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('GPS_Location_Mapping',pdata,l_error_message,SYSDATE());
             commit;
        
        END;
      --
     IF pdata_insert NOT IN ('Y','N') THEN
         --
         SIGNAL SQLSTATE '45000'
         SET MESSAGE_TEXT = 'Invalid value passed to first parameter.(Valid value:Y/N)';
         INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('GPS_Location_Mapping',pdata,'Invalid value passed to first parameter.(Valid value:Y/N)',SYSDATE());
             commit; 
     ELSE 
	  if pdata_insert = 'Y' then
	    --
        SET l_string = pdata;
	    --
        SELECT LENGTH(l_string) - LENGTH(REPLACE(l_string, '|', ''))+1 into l_occurences; 
	    --
        SELECT COUNT(*) into l_no_of_columns
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE upper(table_schema) = upper('witricity')
        AND upper(table_name) = upper(ptable_name);
        --
        IF(l_no_of_columns != l_occurences) THEN 
          SIGNAL SQLSTATE '45000'
          SET MESSAGE_TEXT = 'Insufficient data passed to the insert into table';
          --
          INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES(ptable_name,pdata,'Insufficient data passed to the insert into table',SYSDATE());
             commit; 
         ELSE
             --
             SET l_column1 = SPLIT_STR(pdata,'|',1);
             SET l_column2 = SPLIT_STR(pdata,'|',2);
             -- 
             START TRANSACTION;
             -- insert a new record into table
             INSERT INTO GPS_Location_Mapping(GPS ,Location_Identifier)
             VALUES(convert(l_column1, SIGNED INTEGER),convert(l_column2, SIGNED INTEGER));
             -- 
             COMMIT;
             --
           END IF;
           --
       ELSE  -- Insert the bulk data using inseet statements pdata_insert = N
             --
             -- select 'Inside pdata_insert N';
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('10000001', '1');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('10000010', '2');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('10000011', '3');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('10000100', '4');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('10000101', '5');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('10000110', '6');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('10000111', '7');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('10001000', '8');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('10001001', '9');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('10001010', '10');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('10001011', '11');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('10001100', '12');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('10001101', '13');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('10001110', '14');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('10001111', '15');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('10010000', '16');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('10010001', '17');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('10010010', '18');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('10010011', '19');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('10010100', '20');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('10010101', '21');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('10010110', '22');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('10010111', '23');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('10011000', '24');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('10011001', '25');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('10011010', '26');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('10011011', '27');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('10011100', '28');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('10011101', '29');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('10011110', '30');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('10011111', '31');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('10100000', '32');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('10100001', '33');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('10100010', '34');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('10100011', '35');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('10100100', '36');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('10100101', '37');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('10100110', '38');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('10100111', '39');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('10101000', '40');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('10101001', '41');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('10101010', '42');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('10101011', '43');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('10101100', '44');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('10101101', '45');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('10101110', '46');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('10101111', '47');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('10110000', '48');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('10110001', '49');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('10110010', '50');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('10110011', '51');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('10110100', '52');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('10110101', '53');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('10110110', '54');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('10110111', '55');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('10111000', '56');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('10111001', '57');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('10111010', '58');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('10111011', '59');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('10111100', '60');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('10111101', '61');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('10111110', '62');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('10111111', '63');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('11000000', '64');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('11000001', '65');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('11000010', '66');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('11000011', '67');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('11000100', '68');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('11000101', '69');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('11000110', '70');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('11000111', '71');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('11001000', '72');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('11001001', '73');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('11001010', '74');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('11001011', '75');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('11001100', '76');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('11001101', '77');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('11001110', '78');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('11001111', '79');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('11010000', '80');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('11010001', '81');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('11010010', '82');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('11010011', '83');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('11010100', '84');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('11010101', '85');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('11010110', '86');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('11010111', '87');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('11011000', '88');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('11011001', '89');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('11011010', '90');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('11011011', '91');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('11011100', '92');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('11011101', '93');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('11011110', '94');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('11011111', '95');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('11100000', '96');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('11100001', '97');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('11100010', '98');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('11100011', '99');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('11100100', '100');
            INSERT INTO witricity.GPS_Location_Mapping (GPS, Location_Identifier) VALUES ('11100101', '101');

             select 'After inserting data into table GPS_Location_Mapping';
             
             COMMIT;
            
        END IF; 
       END IF; 
       
        -- 
END 
$$


--
--- Power_Booster_Info   table Error Handling and data Insert
--



DELIMITER $$  

CREATE PROCEDURE Power_Booster_Info_data_insert(pdata_insert varchar(2),pdata varchar(2000),ptable_name varchar(50))

   BEGIN
      -- Declaration Section
      --
	  DECLARE l_string varchar(2000) DEFAULT NULL;
	  DECLARE l_occurences INT default 0;
	  DECLARE l_column1 varchar(200) default NULL;
      DECLARE l_column2 varchar(200) default NULL;
      DECLARE l_column3 varchar(200) default NULL;
      DECLARE l_column4 varchar(200) default NULL;
      DECLARE l_no_of_columns INT DEFAULT 0;
      DECLARE l_error_message varchar(200) default NULL;
      --
     -- DECLARE CONTINUE HANDLER FOR 1062 SELECT 'Duplicate keys error encountered while inserting data in Power_Booster_Info table' into l_error_message;
      DECLARE CONTINUE HANDLER FOR SQLEXCEPTION -- SELECT 'SQLException encountered while inserting data in Power_Booster_Info table' into l_error_message; 
	 -- DECLARE CONTINUE HANDLER FOR 1452 select 'Foreign key constraint violated while inserting data in Power_Booster_Info table' into l_error_message;
      --
      BEGIN
        --
		get diagnostics condition 1
		       
          @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
			SET @full_error = CONCAT("ERROR ", @errno, @text);
		  
		
		IF @full_error like 'ERROR 1452Cannot add or update a child row: a foreign key constraint fails%' then
		   INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('Power_Booster_Info',pdata,'Foreign key constraint violated',SYSDATE());
		END IF;
		--
		SET l_error_message =  @full_error;
		--
        INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('Power_Booster_Info',pdata,l_error_message,SYSDATE());
             commit;
        
        END;
      --
     IF pdata_insert NOT IN ('Y','N') THEN
         --
         SIGNAL SQLSTATE '45000'
         SET MESSAGE_TEXT = 'Invalid value passed to first parameter.(Valid value:Y/N)';
         --
         INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('Power_Booster_Info',pdata,'Invalid value passed to first parameter.(Valid value:Y/N)',SYSDATE());
             commit; 
     ELSE 
	  if pdata_insert = 'Y' then
	    --
        SET l_string = pdata;
	    --
        SELECT LENGTH(l_string) - LENGTH(REPLACE(l_string, '|', ''))+1 into l_occurences; 
	    --
        SELECT COUNT(*) into l_no_of_columns
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE upper(table_schema) = upper('witricity')
        AND upper(table_name) = upper(ptable_name);
        -- 
         IF(l_no_of_columns != l_occurences) THEN 
          SIGNAL SQLSTATE '45000'
          SET MESSAGE_TEXT = 'Insufficient data passed to the insert into table';
          --
          INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES(ptable_name,pdata,'Insufficient data passed to the insert into table',SYSDATE());
             commit;
         ELSE
             --
             SET l_column1 = SPLIT_STR(pdata,'|',1);
             SET l_column2 = SPLIT_STR(pdata,'|',2);
             SET l_column3 = SPLIT_STR(pdata,'|',3);
             SET l_column4 = SPLIT_STR(pdata,'|',4);
             -- 
             START TRANSACTION;
             -- insert a new record into table
             INSERT INTO Power_Booster_Info(Booster_Type_ID,Booster_Description,Max_Transmitters_Possible,Booster_Name)
             VALUES(convert(l_column1, SIGNED INTEGER),l_column2,convert(l_column3, SIGNED INTEGER),l_column4);
             -- 
             COMMIT;
             --
           END IF;
           --
       ELSE  -- Insert the bulk data using inseet statements pdata_insert = N
             --
             -- select 'Inside pdata_insert N';
            INSERT INTO witricity.Power_Booster_Info (Booster_Type_ID, Booster_Description, Max_Transmitters_Possible, Booster_Name) VALUES ('555', 'High', '4', 'Netgear EX6200: 6/10');
            INSERT INTO witricity.Power_Booster_Info (Booster_Type_ID, Booster_Description, Max_Transmitters_Possible, Booster_Name) VALUES ('666', 'medium', '6', 'Asus RP-N53: 8/10');
            INSERT INTO witricity.Power_Booster_Info (Booster_Type_ID, Booster_Description, Max_Transmitters_Possible, Booster_Name) VALUES ('777', 'Low', '2', 'D-Link DAP-1320: 8/10');
            --
            select 'After Inserting data into table Power_Booster_Info';
             --
             COMMIT;
            
        END IF; 
       END IF; 
      
        --
END 
$$


--
--- Power_Booster_Master table Error Handling and data Insert
--



DELIMITER $$  

CREATE PROCEDURE Power_Booster_Master_data_insert(pdata_insert varchar(2),pdata varchar(2000),ptable_name varchar(50))

   BEGIN
      -- Declaration Section
      --
	  DECLARE l_string varchar(2000) DEFAULT NULL;
	  DECLARE l_occurences INT default 0;
	  DECLARE l_column1 varchar(200) default NULL;
      DECLARE l_column2 varchar(200) default NULL;
      DECLARE l_column3 varchar(200) default NULL;
      DECLARE l_column4 varchar(200) default NULL;
      DECLARE l_column5 varchar(200) default NULL;
      DECLARE l_no_of_columns INT DEFAULT 0;
      DECLARE l_error_message varchar(200) default NULL;
      --
     -- DECLARE CONTINUE HANDLER FOR 1062 SELECT 'Duplicate keys error encountered while inserting data in Power_Booster_Master table' into l_error_message;
      DECLARE CONTINUE HANDLER FOR SQLEXCEPTION -- SELECT 'SQLException encountered while inserting data in Power_Booster_Master table' into l_error_message; 
	 -- DECLARE CONTINUE HANDLER FOR 1452 select 'Foreign key constraint violated while inserting data in Power_Booster_Master table' into l_error_message;
      --
      BEGIN
        --
		get diagnostics condition 1
		       
          @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
			SET @full_error = CONCAT("ERROR ", @errno, @text);
		  
		
		IF @full_error like 'ERROR 1452Cannot add or update a child row: a foreign key constraint fails%' then
		   INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('Power_Booster_Master',pdata,'Foreign key constraint violated',SYSDATE());
		END IF;
		--
		SET l_error_message =  @full_error;
		--
        INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('Power_Booster_Master',pdata,l_error_message,SYSDATE());
             commit;
        
        END;
      --
     IF pdata_insert NOT IN ('Y','N') THEN
         --
         SIGNAL SQLSTATE '45000'
         SET MESSAGE_TEXT = 'Invalid value passed to first parameter.(Valid value:Y/N)';
         INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('Power_Booster_Master',pdata,'Invalid value passed to first parameter.(Valid value:Y/N)',SYSDATE());
             commit; 
     ELSE 
      --
	  if pdata_insert = 'Y' then
	    --
        SET l_string = pdata;
	    --
        SELECT LENGTH(l_string) - LENGTH(REPLACE(l_string, '|', ''))+1 into l_occurences; 
	    --
        SELECT COUNT(*) into l_no_of_columns
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE upper(table_schema) = upper('witricity')
        AND upper(table_name) = upper(ptable_name);
        --
         IF(l_no_of_columns != l_occurences) THEN 
          SIGNAL SQLSTATE '45000'
          SET MESSAGE_TEXT = 'Insufficient data passed to the insert into table';
          --
          INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES(ptable_name,pdata,'Insufficient data passed to the insert into table',SYSDATE());
             commit;
         ELSE
             --
             SET l_column1 = SPLIT_STR(pdata,'|',1);
             SET l_column2 = SPLIT_STR(pdata,'|',2);
             SET l_column3 = SPLIT_STR(pdata,'|',3);
             SET l_column4 = SPLIT_STR(pdata,'|',4);
             SET l_column5 = SPLIT_STR(pdata,'|',5);
             -- 
             START TRANSACTION;
             -- insert a new record into table
             INSERT INTO Power_Booster_Master(Booster_ID,Booster_Type_ID,Location_Identifier,Connected_Transmitter,Booster_Status)
             VALUES(default,convert(l_column2, SIGNED INTEGER),convert(l_column3, SIGNED INTEGER),convert(l_column4, SIGNED INTEGER),l_column5);
             -- 
             COMMIT;
             --
           END IF;
          --
       ELSE  -- Insert the bulk data using inseet statements pdata_insert = N
             --
             -- select 'Inside pdata_insert N';
             ALTER TABLE witricity.Power_Booster_Master AUTO_INCREMENT=60001;
             
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '1', '50001', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '2', '50002', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '3', '50003', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '4', '50004', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '5', '50005', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '6', '50006', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '7', '50007', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '8', '50008', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '9', '50009', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '10', '50010', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '11', '50011', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '12', '50012', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '13', '50013', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '14', '50014', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '15', '50015', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '16', '50016', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '17', '50017', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '18', '50018', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '19', '50019', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '20', '50020', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '21', '50021', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '22', '50022', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '23', '50023', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '24', '50024', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '25', '50025', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '26', '50026', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '27', '50027', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '28', '50028', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '29', '50029', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '30', '50030', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '31', '50031', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '32', '50032', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '33', '50033', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '34', '50034', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '35', '50035', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '36', '50036', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '37', '50037', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '38', '50038', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '39', '50039', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '40', '50040', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '41', '50041', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '42', '50042', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '43', '50043', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '44', '50044', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '45', '50045', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '46', '50046', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '47', '50047', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '48', '50048', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '49', '50049', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '50', '50050', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '51', '50051', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '52', '50052', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '53', '50053', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '54', '50054', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '55', '50055', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '56', '50056', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '57', '50057', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '58', '50058', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '59', '50059', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '60', '50060', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '61', '50061', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '62', '50062', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '63', '50063', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '64', '50064', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '65', '50065', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '66', '50066', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '67', '50067', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '68', '50068', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '69', '50069', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '70', '50070', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '71', '50071', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '72', '50072', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '73', '50073', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '74', '50074', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '75', '50075', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '76', '50076', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '77', '50077', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '78', '50078', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '79', '50079', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '80', '50080', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '81', '50081', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '82', '50082', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '83', '50083', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '84', '50084', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '85', '50085', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '86', '50086', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '87', '50087', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '88', '50088', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '89', '50089', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '90', '50090', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '91', '50091', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '92', '50092', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '93', '50093', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '94', '50094', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '95', '50095', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '96', '50096', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '97', '50097', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '98', '50098', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '99', '50099', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '100', '50100', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '101', '50101', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '102', '50102', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '103', '50103', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '104', '50104', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '105', '50105', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '106', '50106', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '107', '50107', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '108', '50108', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '109', '50109', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '110', '50110', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '111', '50111', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '112', '50112', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '113', '50113', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '114', '50114', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '115', '50115', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '116', '50116', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '117', '50117', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '118', '50118', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '119', '50119', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '120', '50120', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '121', '50121', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '122', '50122', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '123', '50123', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '124', '50124', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '125', '50125', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '126', '50126', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '127', '50127', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '128', '50128', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '129', '50129', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '130', '50130', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '131', '50131', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '132', '50132', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '133', '50133', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '134', '50134', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '135', '50135', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '136', '50136', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '137', '50137', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '138', '50138', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '139', '50139', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '140', '50140', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '141', '50141', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '142', '50142', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '143', '50143', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '144', '50144', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '145', '50145', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '146', '50146', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '147', '50147', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '148', '50148', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '149', '50149', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '150', '50150', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '151', '50151', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '152', '50152', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '153', '50153', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '154', '50154', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '155', '50155', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '156', '50156', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '157', '50157', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '158', '50158', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '159', '50159', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '160', '50160', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '161', '50161', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '162', '50162', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '163', '50163', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '164', '50164', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '165', '50165', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '166', '50166', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '167', '50167', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '168', '50168', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '169', '50169', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '170', '50170', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '171', '50171', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '172', '50172', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '173', '50173', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '174', '50174', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '175', '50175', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '176', '50176', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '177', '50177', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '178', '50178', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '179', '50179', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '180', '50180', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '181', '50181', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '182', '50182', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '183', '50183', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '184', '50184', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '185', '50185', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '186', '50186', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '187', '50187', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '188', '50188', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '189', '50189', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '190', '50190', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '191', '50191', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '192', '50192', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '193', '50193', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '194', '50194', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '195', '50195', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '196', '50196', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '197', '50197', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '777', '198', '50198', 'OFF');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '555', '199', '50199', 'ON');
            INSERT INTO witricity.Power_Booster_Master (Booster_ID, Booster_Type_ID, Location_Identifier, Connected_Transmitter, Booster_Status) VALUES (default, '666', '200', '50200', 'OFF');

            select 'After Inserting data into table Power_Booster_Master';
             
             COMMIT;
            
        END IF; 
       END IF;
       
        --
END 
$$


--
--- Transmitter_Master   table Error Handling and data Insert
--         


DELIMITER $$  

CREATE PROCEDURE Transmitter_Master_data_insert(pdata_insert varchar(2),pdata varchar(2000),ptable_name varchar(50))

   BEGIN
      -- Declaration Section
      --
	  DECLARE l_string varchar(2000) DEFAULT NULL;
	  DECLARE l_occurences INT default 0;
	  DECLARE l_column1 varchar(200) default NULL;
      DECLARE l_column2 varchar(200) default NULL;
      DECLARE l_column3 varchar(200) default NULL;
      DECLARE l_column4 varchar(200) default NULL;
      DECLARE l_no_of_columns INT DEFAULT 0;
      DECLARE l_error_message varchar(200) default NULL;
      --
     -- DECLARE CONTINUE HANDLER FOR 1062 SELECT 'Duplicate keys error encountered while inserting data in Transmitter_Master table' into l_error_message;
      DECLARE CONTINUE HANDLER FOR SQLEXCEPTION -- SELECT 'SQLException encountered while inserting data in Transmitter_Master table' into l_error_message; 
	 -- DECLARE CONTINUE HANDLER FOR 1452 select 'Foreign key constraint violated while inserting data in Transmitter_Master table' into l_error_message;
      --
      BEGIN
        --
		get diagnostics condition 1
		       
          @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
			SET @full_error = CONCAT("ERROR ", @errno, @text);
		  
		
		IF @full_error like 'ERROR 1452Cannot add or update a child row: a foreign key constraint fails%' then
		   INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('Transmitter_Master',pdata,'Foreign key constraint violated',SYSDATE());
		END IF;
		--
		SET l_error_message =  @full_error;
		--
        INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('Transmitter_Master',pdata,l_error_message,SYSDATE());
             commit;
        
        END;
      --
     IF pdata_insert NOT IN ('Y','N') THEN
         --
         SIGNAL SQLSTATE '45000'
         SET MESSAGE_TEXT = 'Invalid value passed to first parameter.(Valid value:Y/N)';
         INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('Transmitter_Master',pdata,'Invalid value passed to first parameter.(Valid value:Y/N)',SYSDATE());
             commit; 
     ELSE 
      --
	  if pdata_insert = 'Y' then
	    --
        SET l_string = pdata;
	    --
        SELECT LENGTH(l_string) - LENGTH(REPLACE(l_string, '|', ''))+1 into l_occurences; 
	    --
        SELECT COUNT(*) into l_no_of_columns
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE upper(table_schema) = upper('witricity')
        AND upper(table_name) = upper(ptable_name);
        --
         IF(l_no_of_columns != l_occurences) THEN 
          SIGNAL SQLSTATE '45000'
          SET MESSAGE_TEXT = 'Insufficient data passed to the insert into table';
          --
          INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES(ptable_name,pdata,'Insufficient data passed to the insert into table',SYSDATE());
             commit;
         ELSE
             --
             SET l_column1 = SPLIT_STR(pdata,'|',1);
             SET l_column2 = SPLIT_STR(pdata,'|',2);
             SET l_column3 = SPLIT_STR(pdata,'|',3);
             SET l_column4 = SPLIT_STR(pdata,'|',4);
             -- 
             START TRANSACTION;
             -- insert a new record into table
             INSERT INTO Transmitter_Master(Transmiter_ID,Transmitter_Type_ID,Location_Identifier,Transmitter_Status)
             VALUES(default,convert(l_column2, SIGNED INTEGER),convert(l_column3, SIGNED INTEGER),l_column4);
             -- 
             COMMIT;
             --
           END IF;
           --
       ELSE  -- Insert the bulk data using inseet statements pdata_insert = N
             --
             -- select 'Inside pdata_insert N';
             ALTER TABLE witricity.Transmitter_Master AUTO_INCREMENT=50001;
             
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '1', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '2', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '3', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '4', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '5', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '6', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '7', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '8', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '9', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '10', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '11', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '12', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '13', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '14', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '15', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '16', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '17', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '18', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '19', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '20', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '21', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '22', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '23', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '24', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '25', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '26', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '27', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '28', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '29', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '30', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '31', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '32', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '33', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '34', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '35', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '36', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '37', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '38', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '39', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '40', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '41', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '42', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '43', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '44', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '45', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '46', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '47', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '48', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '49', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '50', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '51', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '52', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '53', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '54', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '55', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '56', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '57', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '58', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '59', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '60', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '61', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '62', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '63', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '64', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '65', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '66', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '67', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '68', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '69', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '70', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '71', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '72', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '73', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '74', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '75', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '76', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '77', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '78', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '79', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '80', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '81', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '82', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '83', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '84', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '85', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '86', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '87', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '88', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '89', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '90', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '91', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '92', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '93', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '94', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '95', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '96', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '97', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '98', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '99', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '100', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '101', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '102', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '103', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '104', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '105', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '106', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '107', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '108', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '109', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '110', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '111', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '112', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '113', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '114', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '115', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '116', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '117', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '118', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '119', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '120', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '121', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '122', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '123', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '124', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '125', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '126', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '127', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '128', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '129', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '130', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '131', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '132', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '133', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '134', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '135', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '136', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '137', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '138', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '139', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '140', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '141', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '142', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '143', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '144', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '145', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '146', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '147', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '148', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '149', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '150', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '151', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '152', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '153', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '154', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '155', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '156', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '157', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '158', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '159', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '160', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '161', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '162', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '163', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '164', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '165', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '166', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '167', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '168', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '169', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '170', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '171', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '172', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '173', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '174', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '175', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '176', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '177', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '178', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '179', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '180', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '181', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '182', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '183', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '184', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '185', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '186', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '187', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '188', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '189', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '190', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '191', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '192', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '193', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '194', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '195', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '196', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '197', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '333', '198', 'OFF');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '111', '199', 'ON');
            INSERT INTO witricity.Transmitter_Master (Transmiter_ID, Transmitter_Type_ID, Location_Identifier, Transmitter_Status) VALUES (default, '222', '200', 'OFF');

             select 'After Inserting data into table Transmitter_Master';
             
             COMMIT;
            
        END IF; 
       END IF;
      
END 
$$


--
--- University_shuttle_Config   table Error Handling and data Insert
--



DELIMITER $$  

CREATE PROCEDURE University_shuttle_Config_data_insert(pdata_insert varchar(2),pdata varchar(2000),ptable_name varchar(50))

   BEGIN
      -- Declaration Section
      --
	  DECLARE l_string varchar(2000) DEFAULT NULL;
	  DECLARE l_occurences INT default 0;
	  DECLARE l_column1 varchar(200) default NULL;
      DECLARE l_column2 varchar(200) default NULL;
      DECLARE l_column3 varchar(200) default NULL;
      DECLARE l_column4 varchar(200) default NULL;
      DECLARE l_column5 varchar(200) default NULL;
      DECLARE l_no_of_columns INT DEFAULT 0;
      DECLARE l_error_message varchar(200) default NULL;
      
      -- DECLARE CONTINUE HANDLER FOR 1062 SELECT 'Duplicate keys error encountered while inserting data in University_shuttle_Config table' into l_error_message;
      DECLARE CONTINUE HANDLER FOR SQLEXCEPTION -- SELECT 'SQLException encountered while inserting data in University_shuttle_Config table' into l_error_message; 
	  -- DECLARE CONTINUE HANDLER FOR 1452 select 'Foreign key constraint violated while inserting data in University_shuttle_Config table' into l_error_message;
      --
      BEGIN
        --
		get diagnostics condition 1
		       
          @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
			SET @full_error = CONCAT("ERROR ", @errno, @text);
		  
		
		IF @full_error like 'ERROR 1452Cannot add or update a child row: a foreign key constraint fails%' then
		   INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('University_shuttle_Config',pdata,'Foreign key constraint violated',SYSDATE());
		END IF;
		--
		SET l_error_message =  @full_error;
		--
        INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('University_shuttle_Config',pdata,l_error_message,SYSDATE());
             commit;
        
        END;
      --
     IF pdata_insert NOT IN ('Y','N') THEN
         --
         SIGNAL SQLSTATE '45000'
         SET MESSAGE_TEXT = 'Invalid value passed to first parameter.(Valid value:Y/N)';
         INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('University_shuttle_Config',pdata,'Invalid value passed to first parameter.(Valid value:Y/N)',SYSDATE());
             commit; 
     ELSE 
      --
	  if pdata_insert = 'Y' then
	    --
        SET l_string = pdata;
	    --
        SELECT LENGTH(l_string) - LENGTH(REPLACE(l_string, '|', ''))+1 into l_occurences; 
	    --
        SELECT COUNT(*) into l_no_of_columns
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE upper(table_schema) = upper('witricity')
        AND upper(table_name) = upper(ptable_name);
        
         select 'Inside pdata_insert Y3' ;
         
         IF(l_no_of_columns != l_occurences) THEN 
          SIGNAL SQLSTATE '45000'
          SET MESSAGE_TEXT = 'Insufficient data passed to the insert into table';
          --
          INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES(ptable_name,pdata,'Insufficient data passed to the insert into table',SYSDATE());
             commit; 
         ELSE
             --
             SET l_column1 = SPLIT_STR(pdata,'|',1);
             SET l_column2 = SPLIT_STR(pdata,'|',2);
             SET l_column3 = SPLIT_STR(pdata,'|',3);
             SET l_column4 = SPLIT_STR(pdata,'|',4);
             SET l_column5 = SPLIT_STR(pdata,'|',5);
             -- 
             START TRANSACTION;
             -- insert a new record into table
             INSERT INTO University_shuttle_Config(Shuttle_ID,Transmitter_ID,Min_shuttle_capacity,Max_shuttle_capacity,Config_ID)
             VALUES(default,convert(l_column2, SIGNED INTEGER),convert(l_column3, SIGNED INTEGER),convert(l_column4, SIGNED INTEGER),convert(l_column5, SIGNED INTEGER));
             -- 
             COMMIT;
             --
           END IF;
           --
       ELSE  -- Insert the bulk data using inseet statements pdata_insert = N
             --
             -- select 'Inside pdata_insert N';
             ALTER TABLE witricity.University_shuttle_Config AUTO_INCREMENT=1001;
             
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50001', '10', '14', '300301');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50002', '20', '24', '300302');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50003', '15', '19', '300303');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50004', '25', '29', '300304');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50005', '30', '34', '300305');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50006', '35', '39', '300306');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50007', '40', '44', '300307');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50008', '45', '49', '300308');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50009', '50', '54', '300309');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50010', '55', '59', '300310');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50011', '60', '64', '300311');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50012', '65', '69', '300312');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50013', '70', '74', '300313');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50014', '75', '79', '300314');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50015', '80', '84', '300315');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50016', '85', '89', '300316');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50017', '90', '94', '300317');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50018', '95', '99', '300318');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50019', '100', '104', '300319');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50020', '105', '109', '300320');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50021', '110', '114', '300321');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50022', '115', '119', '300322');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50023', '120', '124', '300323');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50024', '125', '129', '300324');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50025', '130', '134', '300325');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50026', '135', '139', '300326');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50027', '140', '144', '300327');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50028', '145', '149', '300328');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50029', '150', '154', '300329');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50030', '155', '159', '300330');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50031', '160', '164', '300331');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50032', '165', '169', '300332');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50033', '170', '174', '300333');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50034', '175', '179', '300334');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50035', '180', '184', '300335');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50036', '185', '189', '300336');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50037', '190', '194', '300337');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50038', '195', '199', '300338');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50039', '200', '204', '300339');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50040', '205', '209', '300340');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50041', '210', '214', '300341');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50042', '215', '219', '300342');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50043', '220', '224', '300343');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50044', '225', '229', '300344');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50045', '230', '234', '300345');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50046', '235', '239', '300346');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50047', '240', '244', '300347');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50048', '245', '249', '300348');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50049', '250', '254', '300349');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50050', '255', '259', '300350');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50051', '260', '264', '300351');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50052', '265', '269', '300352');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50053', '270', '274', '300353');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50054', '275', '279', '300354');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50055', '280', '284', '300355');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50056', '285', '289', '300356');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50057', '290', '294', '300357');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50058', '295', '299', '300358');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50059', '300', '304', '300359');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50060', '305', '309', '300360');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50061', '310', '314', '300361');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50062', '315', '319', '300362');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50063', '320', '324', '300363');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50064', '325', '329', '300364');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50065', '330', '334', '300365');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50066', '335', '339', '300366');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50067', '340', '344', '300367');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50068', '345', '349', '300368');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50069', '350', '354', '300369');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50070', '355', '359', '300370');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50071', '360', '364', '300371');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50072', '365', '369', '300372');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50073', '370', '374', '300373');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50074', '375', '379', '300374');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50075', '380', '384', '300375');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50076', '385', '389', '300376');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50077', '390', '394', '300377');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50078', '395', '399', '300378');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50079', '400', '404', '300379');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50080', '405', '409', '300380');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50081', '410', '414', '300381');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50082', '415', '419', '300382');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50083', '420', '424', '300383');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50084', '425', '429', '300384');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50085', '430', '434', '300385');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50086', '435', '439', '300386');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50087', '440', '444', '300387');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50088', '445', '449', '300388');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50089', '450', '454', '300389');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50090', '455', '459', '300390');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50091', '460', '464', '300391');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50092', '465', '469', '300392');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50093', '470', '474', '300393');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50094', '475', '479', '300394');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50095', '480', '484', '300395');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50096', '485', '489', '300396');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50097', '490', '494', '300397');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50098', '495', '499', '300398');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50099', '500', '504', '300399');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50100', '505', '509', '300400');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50101', '510', '514', '300401');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50102', '515', '519', '300402');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50103', '520', '524', '300403');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50104', '525', '529', '300404');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50105', '530', '534', '300405');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50106', '535', '539', '300406');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50107', '540', '544', '300407');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50108', '545', '549', '300408');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50109', '550', '554', '300409');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50110', '555', '559', '300410');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50111', '560', '564', '300411');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50112', '565', '569', '300412');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50113', '570', '574', '300413');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50114', '575', '579', '300414');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50115', '580', '584', '300415');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50116', '585', '589', '300416');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50117', '590', '594', '300417');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50118', '595', '599', '300418');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50119', '600', '604', '300419');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50120', '605', '609', '300420');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50121', '610', '614', '300421');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50122', '615', '619', '300422');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50123', '620', '624', '300423');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50124', '625', '629', '300424');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50125', '630', '634', '300425');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50126', '635', '639', '300426');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50127', '640', '644', '300427');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50128', '645', '649', '300428');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50129', '650', '654', '300429');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50130', '655', '659', '300430');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50131', '660', '664', '300431');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50132', '665', '669', '300432');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50133', '670', '674', '300433');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50134', '675', '679', '300434');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50135', '680', '684', '300435');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50136', '685', '689', '300436');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50137', '690', '694', '300437');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50138', '695', '699', '300438');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50139', '700', '704', '300439');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50140', '705', '709', '300440');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50141', '710', '714', '300441');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50142', '715', '719', '300442');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50143', '720', '724', '300443');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50144', '725', '729', '300444');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50145', '730', '734', '300445');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50146', '735', '739', '300446');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50147', '740', '744', '300447');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50148', '745', '749', '300448');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50149', '750', '754', '300449');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50150', '755', '759', '300450');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50151', '760', '764', '300451');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50152', '765', '769', '300452');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50153', '770', '774', '300453');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50154', '775', '779', '300454');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50155', '780', '784', '300455');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50156', '785', '789', '300456');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50157', '790', '794', '300457');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50158', '795', '799', '300458');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50159', '800', '804', '300459');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50160', '805', '809', '300460');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50161', '810', '814', '300461');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50162', '815', '819', '300462');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50163', '820', '824', '300463');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50164', '825', '829', '300464');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50165', '830', '834', '300465');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50166', '835', '839', '300466');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50167', '840', '844', '300467');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50168', '845', '849', '300468');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50169', '850', '854', '300469');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50170', '855', '859', '300470');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50171', '860', '864', '300471');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50172', '865', '869', '300472');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50173', '870', '874', '300473');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50174', '875', '879', '300474');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50175', '880', '884', '300475');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50176', '885', '889', '300476');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50177', '890', '894', '300477');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50178', '895', '899', '300478');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50179', '900', '904', '300479');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50180', '905', '909', '300480');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50181', '910', '914', '300481');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50182', '915', '919', '300482');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50183', '920', '924', '300483');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50184', '925', '929', '300484');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50185', '930', '934', '300485');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50186', '935', '939', '300486');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50187', '940', '944', '300487');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50188', '945', '949', '300488');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50189', '950', '954', '300489');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50190', '955', '959', '300490');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50191', '960', '964', '300491');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50192', '965', '969', '300492');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50193', '970', '974', '300493');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50194', '975', '979', '300494');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50195', '980', '984', '300495');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50196', '985', '989', '300496');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50197', '990', '994', '300497');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50198', '995', '999', '300498');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50199', '1000', '1004', '300499');
            INSERT INTO witricity.University_shuttle_Config (Shuttle_ID, Transmitter_ID, Min_shuttle_capacity, Max_shuttle_capacity, Config_ID) VALUES (default, '50200', '1005', '1009', '300500');

            select 'After Inserting data into table University_shuttle_Config';
             
             COMMIT;
            
        END IF; 
       END IF;
        
      
END 
$$


--
--- University_own_devices   table Error Handling and data Insert
--



DELIMITER $$  

CREATE PROCEDURE University_own_devices_data_insert(pdata_insert varchar(2),pdata varchar(2000),ptable_name varchar(50))

   BEGIN
      -- Declaration Section
      --
	  DECLARE l_string varchar(2000) DEFAULT NULL;
	  DECLARE l_occurences INT default 0;
	  DECLARE l_column1 varchar(200) default NULL;
      DECLARE l_column2 varchar(200) default NULL;
      DECLARE l_column3 varchar(200) default NULL;
      DECLARE l_no_of_columns INT DEFAULT 0;
      DECLARE l_error_message varchar(200) default NULL;
      --
     -- DECLARE CONTINUE HANDLER FOR 1062 SELECT 'Duplicate keys error encountered while inserting data in University_own_devices table' into l_error_message;
      DECLARE CONTINUE HANDLER FOR SQLEXCEPTION -- SELECT 'SQLException encountered while inserting data in University_own_devices table' into l_error_message; 
	  -- DECLARE CONTINUE HANDLER FOR 1452 select 'Foreign key constraint violated while inserting data in University_own_devices table' into l_error_message;
      --
      BEGIN
        --
		get diagnostics condition 1
		       
          @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
			SET @full_error = CONCAT("ERROR ", @errno, @text);
		  
		
		IF @full_error like 'ERROR 1452Cannot add or update a child row: a foreign key constraint fails%' then
		   INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('University_own_devices',pdata,'Foreign key constraint violated',SYSDATE());
		END IF;
		--
		SET l_error_message =  @full_error;
		--
        INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('University_own_devices',pdata,l_error_message,SYSDATE());
             commit;
        
        END;
      --
     IF pdata_insert NOT IN ('Y','N') THEN
         --
         SIGNAL SQLSTATE '45000'
         SET MESSAGE_TEXT = 'Invalid value passed to first parameter.(Valid value:Y/N)';
         INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('University_own_devices',pdata,'Invalid value passed to first parameter.(Valid value:Y/N)',SYSDATE());
             commit; 
     ELSE 
      --
	  if pdata_insert = 'Y' then
	    --
        select 'Inside pdata_insert Y1' ;
        
		SET l_string = pdata;
	    --
        SELECT LENGTH(l_string) - LENGTH(REPLACE(l_string, '|', ''))+1 into l_occurences; 
	    --
        SELECT COUNT(*) into l_no_of_columns
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE upper(table_schema) = upper('witricity')
        AND upper(table_name) = upper(ptable_name);
        --
         IF(l_no_of_columns != l_occurences) THEN 
          SIGNAL SQLSTATE '45000'
          SET MESSAGE_TEXT = 'Insufficient data passed to the insert into table';
          --
          INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES(ptable_name,pdata,'Insufficient data passed to the insert into table',SYSDATE());
             commit; 
         ELSE
             --
             SET l_column1 = SPLIT_STR(pdata,'|',1);
             SET l_column2 = SPLIT_STR(pdata,'|',2);
             SET l_column3 = SPLIT_STR(pdata,'|',3);
              -- 
             START TRANSACTION;
             -- insert a new record into table
             INSERT INTO University_own_devices(Device_ID,Device_type,Location_identifier)
             VALUES(l_column1,l_column2,convert(l_column3, SIGNED INTEGER));
             -- 
             COMMIT;
             --
           END IF;
           --
       ELSE  -- Insert the bulk data using inseet statements pdata_insert = N
             --
             -- select 'Inside pdata_insert N';
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA200', 'Phone', '1');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA201', 'Tablet', '2');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA203', 'Laptop', '3');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA205', 'Phone', '4');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA207', 'Tablet', '5');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA209', 'Laptop', '6');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA211', 'Phone', '7');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA213', 'Tablet', '8');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA215', 'Laptop', '9');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA217', 'Phone', '10');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA219', 'Tablet', '11');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA221', 'Laptop', '12');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA223', 'Phone', '13');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA225', 'Tablet', '14');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA227', 'Laptop', '15');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA229', 'Phone', '16');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA231', 'Tablet', '17');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA233', 'Laptop', '18');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA235', 'Phone', '19');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA237', 'Tablet', '20');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA239', 'Laptop', '21');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA241', 'Phone', '22');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA243', 'Tablet', '23');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA245', 'Laptop', '24');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA247', 'Phone', '25');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA249', 'Tablet', '26');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA251', 'Laptop', '27');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA253', 'Phone', '28');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA255', 'Tablet', '29');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA257', 'Laptop', '30');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA259', 'Phone', '31');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA261', 'Tablet', '32');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA263', 'Laptop', '33');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA265', 'Phone', '34');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA267', 'Tablet', '35');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA269', 'Laptop', '36');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA271', 'Phone', '37');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA273', 'Tablet', '38');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA275', 'Laptop', '39');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA277', 'Phone', '40');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA279', 'Tablet', '41');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA281', 'Laptop', '42');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA283', 'Phone', '43');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA285', 'Tablet', '44');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA287', 'Laptop', '45');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA289', 'Phone', '46');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA291', 'Tablet', '47');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA293', 'Laptop', '48');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA295', 'Phone', '49');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA297', 'Tablet', '50');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA299', 'Laptop', '51');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA301', 'Phone', '52');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA303', 'Tablet', '53');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA305', 'Laptop', '54');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA307', 'Phone', '55');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA309', 'Tablet', '56');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA311', 'Laptop', '57');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA313', 'Phone', '58');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA315', 'Tablet', '59');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA317', 'Laptop', '60');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA319', 'Phone', '61');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA321', 'Tablet', '62');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA323', 'Laptop', '63');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA325', 'Phone', '64');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA327', 'Tablet', '65');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA329', 'Laptop', '66');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA331', 'Phone', '67');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA333', 'Tablet', '68');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA335', 'Laptop', '69');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA337', 'Phone', '70');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA339', 'Tablet', '71');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA341', 'Laptop', '72');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA343', 'Phone', '73');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA345', 'Tablet', '74');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA347', 'Laptop', '75');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA349', 'Phone', '76');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA351', 'Tablet', '77');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA353', 'Laptop', '78');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA355', 'Phone', '79');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA357', 'Tablet', '80');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA359', 'Laptop', '81');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA361', 'Phone', '82');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA363', 'Tablet', '83');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA365', 'Laptop', '84');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA367', 'Phone', '85');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA369', 'Tablet', '86');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA371', 'Laptop', '87');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA373', 'Phone', '88');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA375', 'Tablet', '89');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA377', 'Laptop', '90');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA379', 'Phone', '91');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA381', 'Tablet', '92');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA383', 'Laptop', '93');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA385', 'Phone', '94');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA387', 'Tablet', '95');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA389', 'Laptop', '96');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA391', 'Phone', '97');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA393', 'Tablet', '98');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA395', 'Laptop', '99');
            INSERT INTO witricity.University_own_devices (Device_ID, Device_type, Location_identifier) VALUES ('DCOEA16AA397', 'Phone', '100');

            select 'After inserting data into table University_own_devices';
             
             COMMIT;
            
        END IF; 
       END IF;
       --       
      
END 
$$


--
-- low_load_days   table Error Handling and data Insert
--


DELIMITER $$  

CREATE PROCEDURE low_load_days_data_insert(pdata_insert varchar(2),pdata varchar(2000),ptable_name varchar(50))

   BEGIN
      -- Declaration Section
      --
	  DECLARE l_string varchar(2000) DEFAULT NULL;
	  DECLARE l_occurences INT default 0;
	  DECLARE l_column1 varchar(200) default NULL;
      DECLARE l_column2 varchar(200) default NULL;
      DECLARE l_no_of_columns INT DEFAULT 0;
      DECLARE l_error_message varchar(200) default NULL;
      --
      -- DECLARE CONTINUE HANDLER FOR 1062 SELECT 'Duplicate keys error encountered while inserting data in low_load_days table' into l_error_message;
      DECLARE CONTINUE HANDLER FOR SQLEXCEPTION -- SELECT 'SQLException encountered while inserting data in low_load_days table' into l_error_message; 
	  -- DECLARE CONTINUE HANDLER FOR 1452 select 'Foreign key constraint violated while inserting data in low_load_days table' into l_error_message;
      --
      BEGIN
        --
		get diagnostics condition 1
		       
          @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
			SET @full_error = CONCAT("ERROR ", @errno, @text);
		  
		
		IF @full_error like 'ERROR 1452Cannot add or update a child row: a foreign key constraint fails%' then
		   INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('low_load_days',pdata,'Foreign key constraint violated',SYSDATE());
		END IF;
		--
		SET l_error_message =  @full_error;
		--
        INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('low_load_days',pdata,l_error_message,SYSDATE());
             commit;
        
        END;
      --
     IF pdata_insert NOT IN ('Y','N') THEN
         --
         SIGNAL SQLSTATE '45000'
         SET MESSAGE_TEXT = 'Invalid value passed to first parameter.(Valid value:Y/N)';
         INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('low_load_days',pdata,'Invalid value passed to first parameter.(Valid value:Y/N)',SYSDATE());
             commit; 
     ELSE 
      --
	  if pdata_insert = 'Y' then
	    --
        SET l_string = pdata;
	    --
        SELECT LENGTH(l_string) - LENGTH(REPLACE(l_string, '|', ''))+1 into l_occurences; 
	    --
        SELECT COUNT(*) into l_no_of_columns
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE upper(table_schema) = upper('witricity')
        AND upper(table_name) = upper(ptable_name);
        --
         IF(l_no_of_columns != l_occurences) THEN 
          SIGNAL SQLSTATE '45000'
          SET MESSAGE_TEXT = 'Insufficient data passed to the insert into table';
          --
          INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES(ptable_name,pdata,'Insufficient data passed to the insert into table',SYSDATE());
             commit; 
         ELSE
             --
             SET l_column1 = SPLIT_STR(pdata,'|',1);
             SET l_column2 = SPLIT_STR(pdata,'|',2);
             -- 
             START TRANSACTION;
             -- insert a new record into table
             INSERT INTO low_load_days(low_load_Date,Reason)
             VALUES(STR_TO_DATE(l_column1,'%y%m%d'),l_column2);
             -- 
             COMMIT;
             --
           END IF;
           --
       ELSE  -- Insert the bulk data using inseet statements pdata_insert = N
             --
             -- select 'Inside pdata_insert N';
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20150523', 'holiday');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151210', 'holiday');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151211', 'holiday');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151212', 'holiday');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151213', 'holiday');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151214', 'holiday');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151452', 'holiday');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151452', 'holiday');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151217', 'holiday');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151218', 'holiday');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151219', 'holiday');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151220', 'holiday');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151221', 'holiday');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151222', 'holiday');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151223', 'holiday');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151224', 'fall break');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151225', 'fall break');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151226', 'fall break');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151101', 'fall break');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151102', 'fall break');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151103', 'fall break');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151104', 'fall break');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151105', 'fall break');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151106', 'fall break');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151107', 'fall break');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151108', 'fall break');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151109', 'fall break');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151110', 'fall break');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151111', 'fall break');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151112', 'fall break');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151113', 'fall break');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151114', 'fall break');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151115', 'fall break');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151116', 'fall break');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151117', 'fall break');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151118', 'fall break');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151119', 'fall break');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151120', 'fall break');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151121', 'fall break');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151122', 'fall break');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151123', 'fall break');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151124', 'fall break');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151125', 'fall break');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151126', 'fall break');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151127', 'summer break');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151128', 'summer break');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151129', 'summer break');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151130', 'summer break');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151001', 'summer break');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151002', 'summer break');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151003', 'summer break');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151004', 'summer break');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151005', 'summer break');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151006', 'summer break');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151007', 'summer break');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151008', 'summer break');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151009', 'government holiday');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151010', 'government holiday');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151011', 'government holiday');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151012', 'government holiday');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151013', 'government holiday');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151014', 'government holiday');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151015', 'government holiday');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151016', 'government holiday');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151017', 'government holiday');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151018', 'government holiday');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151019', 'government holiday');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151020', 'government holiday');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151021', 'spring holiday');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151022', 'spring holiday');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151023', 'spring holiday');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151024', 'spring holiday');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151025', 'spring holiday');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151026', 'spring holiday');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20151027', 'spring holiday');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20150901', 'spring holiday');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20150902', 'spring holiday');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20150903', 'spring holiday');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20150904', 'spring holiday');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20150905', 'spring holiday');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20150906', 'spring holiday');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20150907', 'spring holiday');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20150908', 'spring holiday');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20150909', 'spring holiday');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20150910', 'spring holiday');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20150911', 'spring holiday');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20150912', 'spring holiday');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20150913', 'spring holiday');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20150914', 'spring holiday');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20150915', 'spring holiday');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20150916', 'spring holiday');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20150917', 'spring holiday');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20150918', 'spring holiday');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20150919', 'spring holiday');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20150920', 'spring holiday');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20150921', 'spring holiday');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20150922', 'spring holiday');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20150923', 'spring holiday');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20150924', 'spring holiday');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20150925', 'thanks giving break');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20150926', 'thanks giving break');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20150927', 'thanks giving break');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20150928', 'thanks giving break');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20150929', 'thanks giving break');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20150930', 'thanks giving break');
            INSERT INTO witricity.low_load_days (low_load_Date, Reason) VALUES ('20150801', 'thanks giving break');

             select 'After Inserting data in table low_load_days';
             
             COMMIT;
            
        END IF; 
       END IF;
        
      
END 
$$

--
--- university_holidays   table Error Handling and data Insert
--



DELIMITER $$  

CREATE PROCEDURE university_holidays_data_insert(pdata_insert varchar(2),pdata varchar(2000),ptable_name varchar(50))

   BEGIN
      -- Declaration Section
      --
	  DECLARE l_string varchar(2000) DEFAULT NULL;
	  DECLARE l_occurences INT default 0;
	  DECLARE l_column1 varchar(200) default NULL;
      DECLARE l_column2 varchar(200) default NULL;
      DECLARE l_no_of_columns INT DEFAULT 0;
      DECLARE l_error_message varchar(200) default NULL;
      --
      -- DECLARE CONTINUE HANDLER FOR 1062 SELECT 'Duplicate keys error encountered while inserting data in university_holidays table' into l_error_message;
      DECLARE CONTINUE HANDLER FOR SQLEXCEPTION -- SELECT 'SQLException encountered while inserting data in university_holidays table' into l_error_message; 
	  -- DECLARE CONTINUE HANDLER FOR 1452 select 'Foreign key constraint violated while inserting data in university_holidays table' into l_error_message;
      --
      BEGIN
        --
		get diagnostics condition 1
		       
          @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
			SET @full_error = CONCAT("ERROR ", @errno, @text);
		  
		
		IF @full_error like 'ERROR 1452Cannot add or update a child row: a foreign key constraint fails%' then
		   INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('university_holidays',pdata,'Foreign key constraint violated',SYSDATE());
		END IF;
		--
		SET l_error_message =  @full_error;
		--
        INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('university_holidays',pdata,l_error_message,SYSDATE());
             commit;
        
        END;
      --
     IF pdata_insert NOT IN ('Y','N') THEN
         --
         SIGNAL SQLSTATE '45000'
         SET MESSAGE_TEXT = 'Invalid value passed to first parameter.(Valid value:Y/N)';
         INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('university_holidays',pdata,'Invalid value passed to first parameter.(Valid value:Y/N)',SYSDATE());
             commit; 
     ELSE 
      --
	  if pdata_insert = 'Y' then
	    --
        SET l_string = pdata;
	    --
        SELECT LENGTH(l_string) - LENGTH(REPLACE(l_string, '|', ''))+1 into l_occurences; 
	    --
        SELECT COUNT(*) into l_no_of_columns
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE upper(table_schema) = upper('witricity')
        AND upper(table_name) = upper(ptable_name);
        --
         IF(l_no_of_columns != l_occurences) THEN 
          SIGNAL SQLSTATE '45000'
          SET MESSAGE_TEXT = 'Insufficient data passed to the insert into table';
          --
          INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES(ptable_name,pdata,'Insufficient data passed to the insert into table',SYSDATE());
             commit; 
         ELSE
             --
             SET l_column1 = SPLIT_STR(pdata,'|',1);
             SET l_column2 = SPLIT_STR(pdata,'|',2);
              -- 
             START TRANSACTION;
             -- insert a new record into table
             INSERT INTO university_holidays(holiday_date,Description)
             VALUES(STR_TO_DATE(l_column1,'%y%m%d'),l_column2);
             -- 
             COMMIT;
             --
           END IF;
           --
       ELSE  -- Insert the bulk data using inseet statements pdata_insert = N
             --
             -- select 'Inside pdata_insert N';
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20150523', 'project start1');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151210', 'project start2');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151211', 'project start3');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151212', 'project start4');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151213', 'project start5');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151214', 'project start6');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151452', 'project start7');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151452', 'project start8');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151217', 'project start9');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151218', 'project start10');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151219', 'project start11');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151220', 'project start12');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151221', 'project start13');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151222', 'project start14');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151223', 'project start15');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151224', 'project start16');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151225', 'project start17');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151226', 'project start18');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151101', 'project start19');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151102', 'project start20');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151103', 'project start21');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151104', 'project start22');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151105', 'project start23');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151106', 'project start24');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151107', 'project start25');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151108', 'project start26');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151109', 'project start27');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151110', 'project start28');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151111', 'project start29');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151112', 'project start30');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151113', 'project start31');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151114', 'project start32');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151115', 'project start33');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151116', 'project start34');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151117', 'project start35');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151118', 'project start36');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151119', 'project start37');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151120', 'project start38');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151121', 'project start39');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151122', 'project start40');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151123', 'project start41');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151124', 'project start42');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151125', 'project start43');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151126', 'project start44');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151127', 'project start45');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151128', 'project start46');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151129', 'project start47');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151130', 'project start48');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151001', 'project start49');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151002', 'project start50');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151003', 'project start51');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151004', 'project start52');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151005', 'project start53');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151006', 'project start54');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151007', 'project start55');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151008', 'project start56');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151009', 'project start57');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151010', 'project start58');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151011', 'project start59');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151012', 'project start60');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151013', 'project start61');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151014', 'project start62');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151015', 'project start63');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151016', 'project start64');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151017', 'project start65');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151018', 'project start66');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151019', 'project start67');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151020', 'project start68');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151021', 'project start69');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151022', 'project start70');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151023', 'project start71');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151024', 'project start72');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151025', 'project start73');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151026', 'project start74');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20151027', 'project start75');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20150901', 'project start76');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20150902', 'project start77');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20150903', 'project start78');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20150904', 'project start79');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20150905', 'project start80');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20150906', 'project start81');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20150907', 'project start82');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20150908', 'project start83');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20150909', 'project start84');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20150910', 'project start85');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20150911', 'project start86');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20150912', 'project start87');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20150913', 'project start88');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20150914', 'project start89');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20150915', 'project start90');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20150916', 'project start91');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20150917', 'project start92');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20150918', 'project start93');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20150919', 'project start94');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20150920', 'project start95');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20150921', 'project start96');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20150922', 'project start97');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20150923', 'project start98');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20150924', 'project start99');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20150925', 'project start100');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20150926', 'project start101');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20150927', 'project start102');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20150928', 'project start103');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20150929', 'project start104');
            INSERT INTO witricity.university_holidays (holiday_date, Description) VALUES ('20150930', 'project start105');

            select 'After Inserting data into table university_holidays';
             
             COMMIT;
            
        END IF; 
       END IF; 
        
      
END 
$$


--
--- Device_Power_Mapping   table Error Handling and data Insert
--


DELIMITER $$  

CREATE PROCEDURE Device_Power_Mapping_data_insert(pdata_insert varchar(2),pdata varchar(2000),ptable_name varchar(50))

   BEGIN
      -- Declaration Section
      --
	  DECLARE l_string varchar(2000) DEFAULT NULL;
	  DECLARE l_occurences INT default 0;
	  DECLARE l_column1 varchar(200) default NULL;
      DECLARE l_column2 varchar(200) default NULL;
      DECLARE l_column3 varchar(200) default NULL;
      DECLARE l_no_of_columns INT DEFAULT 0;
      DECLARE l_error_message varchar(200) default NULL;
      
      -- DECLARE CONTINUE HANDLER FOR 1062 SELECT 'Duplicate keys error encountered while inserting data in Device_Power_Mapping table' into l_error_message;
      DECLARE CONTINUE HANDLER FOR SQLEXCEPTION -- SELECT 'SQLException encountered while inserting data in Device_Power_Mapping table' into l_error_message; 
	  -- DECLARE CONTINUE HANDLER FOR 1452 select 'Foreign key constraint violated while inserting data in Device_Power_Mapping table' into l_error_message;
      --
      BEGIN
        --
		get diagnostics condition 1
		       
          @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
			SET @full_error = CONCAT("ERROR ", @errno, @text);
		  
		
		IF @full_error like 'ERROR 1452Cannot add or update a child row: a foreign key constraint fails%' then
		   INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('Device_Power_Mapping',pdata,'Foreign key constraint violated',SYSDATE());
		END IF;
		--
		SET l_error_message =  @full_error;
		--
        INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('Device_Power_Mapping',pdata,l_error_message,SYSDATE());
             commit;
        
        END;
      --
     IF pdata_insert NOT IN ('Y','N') THEN
         --
         SIGNAL SQLSTATE '45000'
         SET MESSAGE_TEXT = 'Invalid value passed to first parameter.(Valid value:Y/N)';
         INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('Device_Power_Mapping',pdata,'Invalid value passed to first parameter.(Valid value:Y/N)',SYSDATE());
             commit; 
     ELSE 
      --
	  if pdata_insert = 'Y' then
	    --
        SET l_string = pdata;
	    --
        SELECT LENGTH(l_string) - LENGTH(REPLACE(l_string, '|', ''))+1 into l_occurences; 
	    --
        SELECT COUNT(*) into l_no_of_columns
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE upper(table_schema) = upper('witricity')
        AND upper(table_name) = upper(ptable_name);
        --
         IF(l_no_of_columns != l_occurences) THEN 
          SIGNAL SQLSTATE '45000'
          SET MESSAGE_TEXT = 'Insufficient data passed to the insert into table';
          --
          INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES(ptable_name,pdata,'Insufficient data passed to the insert into table',SYSDATE());
             commit; 
         ELSE
             --
             SET l_column1 = SPLIT_STR(pdata,'|',1);
             SET l_column2 = SPLIT_STR(pdata,'|',2);
             SET l_column3 = SPLIT_STR(pdata,'|',3);
             -- 
             START TRANSACTION;
             -- insert a new record into table
             INSERT INTO Device_Power_Mapping(Device_Type,Max_Power,Min_Power)
             VALUES(l_column1,convert(l_column2, SIGNED INTEGER),convert(l_column3, SIGNED INTEGER));
             -- 
             COMMIT;
             --
           END IF;
           --
       ELSE  -- Insert the bulk data using inseet statements pdata_insert = N
             --
             -- select 'Inside pdata_insert N';
            INSERT INTO witricity.Device_Power_Mapping (Device_Type, Max_Power, Min_Power) VALUES ('Phone', '100', '50');
            INSERT INTO witricity.Device_Power_Mapping (Device_Type, Max_Power, Min_Power) VALUES ('Tablet', '150', '50');
            INSERT INTO witricity.Device_Power_Mapping (Device_Type, Max_Power, Min_Power) VALUES ('Laptop', '200', '50');
            --
            select 'After inserting data into table Device_Power_Mapping';
             --
             COMMIT;
            
        END IF; 
       END IF;       
      
END 
$$


--
--- device_power_consumption   table Error Handling and data Insert
--



DELIMITER $$  

CREATE PROCEDURE device_power_consumption_data_insert(pdata_insert varchar(2),pdata varchar(2000),ptable_name varchar(50))

   BEGIN
      -- Declaration Section
      --
	  DECLARE l_string varchar(2000) DEFAULT NULL;
	  DECLARE l_occurences INT default 0;
	  DECLARE l_column1 varchar(200) default NULL;
      DECLARE l_column2 varchar(200) default NULL;
      DECLARE l_column3 varchar(200) default NULL;
      DECLARE l_no_of_columns INT DEFAULT 0;
      DECLARE l_error_message varchar(200) default NULL;
      --
      -- DECLARE CONTINUE HANDLER FOR 1062 SELECT 'Duplicate keys error encountered while inserting data in device_power_consumption table' into l_error_message;
      DECLARE CONTINUE HANDLER FOR SQLEXCEPTION -- SELECT 'SQLException encountered while inserting data in device_power_consumption table' into l_error_message; 
	  -- DECLARE CONTINUE HANDLER FOR 1452 select 'Foreign key constraint violated while inserting data in device_power_consumption table' into l_error_message;
      --
      BEGIN
        --
		get diagnostics condition 1
		       
          @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
			SET @full_error = CONCAT("ERROR ", @errno, @text);
		  
		
		IF @full_error like 'ERROR 1452Cannot add or update a child row: a foreign key constraint fails%' then
		   INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('device_power_consumption',pdata,'Foreign key constraint violated',SYSDATE());
		END IF;
		--
		SET l_error_message =  @full_error;
		--
        INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('device_power_consumption',pdata,l_error_message,SYSDATE());
             commit;
        
        END;
      --
     IF pdata_insert NOT IN ('Y','N') THEN
         --
         SIGNAL SQLSTATE '45000'
         SET MESSAGE_TEXT = 'Invalid value passed to first parameter.(Valid value:Y/N)';
         INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('device_power_consumption',pdata,'Invalid value passed to first parameter.(Valid value:Y/N)',SYSDATE());
             commit; 
     ELSE 
      --
	  if pdata_insert = 'Y' then
	    --
        SET l_string = pdata;
	    --
        SELECT LENGTH(l_string) - LENGTH(REPLACE(l_string, '|', ''))+1 into l_occurences; 
	    --
        SELECT COUNT(*) into l_no_of_columns
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE upper(table_schema) = upper('witricity')
        AND upper(table_name) = upper(ptable_name);
        -- 
         IF(l_no_of_columns != l_occurences) THEN 
          SIGNAL SQLSTATE '45000'
          SET MESSAGE_TEXT = 'Insufficient data passed to the insert into table';
         --
         INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES(ptable_name,pdata,'Insufficient data passed to the insert into table',SYSDATE());
             commit; 
         ELSE
             --
             SET l_column1 = SPLIT_STR(pdata,'|',1);
             SET l_column2 = SPLIT_STR(pdata,'|',2);
             SET l_column3 = SPLIT_STR(pdata,'|',3);
             -- 
             START TRANSACTION;
             -- insert a new record into table
             INSERT INTO device_power_consumption(Device_Type,Max_Power,Min_Power)
             VALUES(l_column1,l_column2,convert(l_column3, SIGNED INTEGER));
             -- 
             COMMIT;
             --
           END IF;
           --
       ELSE  -- Insert the bulk data using inseet statements pdata_insert = N
             --
             -- select 'Inside pdata_insert N';
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA200', 'phone', '50');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA201', 'phone', '50');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA202', 'phone', '50');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA203', 'phone', '50');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA204', 'phone', '50');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA205', 'phone', '50');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA206', 'phone', '50');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA207', 'phone', '50');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA208', 'phone', '50');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA209', 'phone', '50');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA210', 'phone', '50');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA211', 'phone', '50');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA212', 'phone', '50');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA213', 'phone', '50');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA214', 'phone', '50');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA215', 'phone', '50');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA216', 'phone', '50');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA217', 'phone', '50');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA218', 'phone', '50');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA219', 'phone', '50');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA220', 'phone', '51');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA221', 'phone', '51');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA222', 'phone', '51');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA223', 'phone', '51');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA224', 'phone', '51');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA225', 'phone', '51');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA226', 'phone', '51');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA227', 'phone', '51');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA228', 'phone', '51');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA229', 'phone', '51');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA230', 'phone', '52');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA231', 'phone', '52');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA232', 'phone', '52');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA233', 'phone', '52');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA234', 'phone', '52');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA235', 'phone', '52');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA236', 'phone', '52');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA237', 'phone', '53');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA238', 'Tablet', '100');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA239', 'Tablet', '100');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA240', 'Tablet', '100');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA241', 'Tablet', '100');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA242', 'Tablet', '100');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA243', 'Tablet', '100');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA244', 'Tablet', '100');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA245', 'Tablet', '100');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA246', 'Tablet', '100');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA247', 'Tablet', '100');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA248', 'Tablet', '100');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA249', 'Tablet', '100');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA250', 'Tablet', '100');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA251', 'Tablet', '100');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA252', 'Tablet', '100');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA253', 'Tablet', '100');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA254', 'Tablet', '100');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA255', 'Tablet', '100');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA256', 'Tablet', '100');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA257', 'Tablet', '100');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA258', 'Tablet', '100');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA259', 'Tablet', '100');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA260', 'Tablet', '100');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA261', 'Tablet', '100');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA262', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA263', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA264', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA265', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA266', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA267', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA268', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA269', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA270', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA271', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA272', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA273', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA274', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA275', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA276', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA277', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA278', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA279', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA280', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA281', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA282', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA283', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA284', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA285', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA286', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA287', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA288', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA289', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA290', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA291', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA292', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA293', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA294', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA295', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA296', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA297', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA298', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA299', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA300', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA301', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA302', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA303', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA304', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA305', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA306', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA307', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA308', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA309', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA310', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA311', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA312', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA313', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA314', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA315', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA316', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA317', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA318', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA319', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA320', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA321', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA322', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA323', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA324', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA325', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA326', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA327', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA328', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA329', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA330', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA331', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA332', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA333', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA334', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA335', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA336', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA337', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA338', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA339', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA340', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA341', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA342', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA343', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA344', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA345', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA346', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA347', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA348', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA349', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA350', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA351', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA352', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA353', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA354', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA355', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA356', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA357', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA358', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA359', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA360', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA361', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA362', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA363', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA364', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA365', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA366', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA367', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA368', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA369', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA370', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA371', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA372', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA373', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA374', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA375', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA376', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA377', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA378', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA379', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA380', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA381', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA382', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA383', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA384', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA385', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA386', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA387', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA388', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA389', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA390', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA391', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA392', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA393', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA394', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA395', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA396', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA397', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA398', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA399', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA400', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA401', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA402', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA403', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA404', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA405', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA406', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA407', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA408', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA409', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA410', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA411', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA412', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA413', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA414', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA415', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA416', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA417', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA418', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA419', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA420', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA421', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA422', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA423', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA424', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA425', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA426', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA427', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA428', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA429', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA430', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA431', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA432', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA433', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA434', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA435', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA436', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA437', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA438', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA439', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA440', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA441', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA442', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA443', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA444', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA445', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA446', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA447', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA448', 'Laptop', '150');
            INSERT INTO witricity.device_power_consumption (Device_ID, Device_Type, Consumption) VALUES ('DCOEA16AA449', 'Laptop', '150');

            select 'After Inserting data into table device_power_consumption';
             
             COMMIT;
            
        END IF; 
       END IF;        
      
END 
$$

--
-- device_user_mapping   table Error Handling and data Insert
--



DELIMITER $$  

CREATE PROCEDURE device_user_mapping_data_insert(pdata_insert varchar(2),pdata varchar(2000),ptable_name varchar(50))

   BEGIN
      -- Declaration Section
      --
	  DECLARE l_string varchar(2000) DEFAULT NULL;
	  DECLARE l_occurences INT default 0;
	  DECLARE l_column1 varchar(200) default NULL;
      DECLARE l_column2 varchar(200) default NULL;
      DECLARE l_no_of_columns INT DEFAULT 0;
      DECLARE l_error_message varchar(200) default NULL;
      
      -- DECLARE CONTINUE HANDLER FOR 1062 SELECT 'Duplicate keys error encountered while inserting data in device_user_mapping table' into l_error_message;
      DECLARE CONTINUE HANDLER FOR SQLEXCEPTION -- SELECT 'SQLException encountered while inserting data in device_user_mapping table' into l_error_message; 
	  -- DECLARE CONTINUE HANDLER FOR 1452 select 'Foreign key constraint violated while inserting data in device_user_mapping table' into l_error_message;
      --
      BEGIN
        --
		get diagnostics condition 1
		       
          @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
			SET @full_error = CONCAT("ERROR ", @errno, @text);
		  
		
		IF @full_error like 'ERROR 1452Cannot add or update a child row: a foreign key constraint fails%' then
		   INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('device_user_mapping',pdata,'Foreign key constraint violated',SYSDATE());
		END IF;
		--
		SET l_error_message =  @full_error;
		--
        INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('device_user_mapping',pdata,l_error_message,SYSDATE());
             commit;
        
        END;
      --
      IF pdata_insert NOT IN ('Y','N') THEN
         --
         SIGNAL SQLSTATE '45000'
         SET MESSAGE_TEXT = 'Invalid value passed to first parameter.(Valid value:Y/N)';
         INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('device_user_mapping',pdata,'Invalid value passed to first parameter.(Valid value:Y/N)',SYSDATE());
             commit; 
     ELSE 
      --
	  if pdata_insert = 'Y' then
	    --
        SET l_string = pdata;
	    --
        SELECT LENGTH(l_string) - LENGTH(REPLACE(l_string, '|', ''))+1 into l_occurences; 
	    --
        SELECT COUNT(*) into l_no_of_columns
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE upper(table_schema) = upper('witricity')
        AND upper(table_name) = upper(ptable_name);
        --
         IF(l_no_of_columns != l_occurences) THEN 
          SIGNAL SQLSTATE '45000'
          SET MESSAGE_TEXT = 'Insufficient data passed to the insert into table';
          --
          INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES(ptable_name,pdata,'Insufficient data passed to the insert into table',SYSDATE());
             commit;
         ELSE
             --
             SET l_column1 = SPLIT_STR(pdata,'|',1);
             SET l_column2 = SPLIT_STR(pdata,'|',2);
             -- 
             START TRANSACTION;
             -- insert a new record into table
             INSERT INTO device_user_mapping(Device_ID,User_ID)
             VALUES(l_column1,l_column2);
             -- 
             COMMIT;
             --
           END IF;
           --
       ELSE  -- Insert the bulk data using inseet statements pdata_insert = N
             --
             -- select 'Inside pdata_insert N';
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA200', 'ranjan.v@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA201', 'survu.s@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA202', 'reema.d@husky.ney.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA203', 'archana.c@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA204', 'vandhana.t@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA205', 'john.k@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA206', 'charles.c@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA207', 'tim.c@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA208', 'linda.r@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA209', 'cameron.p@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA210', 'kumar.s@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA211', 'kevin.s@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA212', 'mary.g@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA213', 'tess.b@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA214', 'catherine.t@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA215', 'vimal.n@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA216', 'Johana.a@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA217', 'Sherri.s@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA218', 'Michaela.d@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA219', 'Song.c@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA220', 'Ileana.x@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA221', 'May.d@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA222', 'Anne.f@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA223', 'Sharolyn.r@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA224', 'Marissa.e@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA225', 'Annamaria.d@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA226', 'Ursula.s@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA227', 'Leonardo.c@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA228', 'Annelle.v@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA229', 'Johnnie.b@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA230', 'Charley.n@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA231', 'Lacresha.h@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA232', 'Eliza.g@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA233', 'Fernando.t@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA234', 'Graig.y@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA235', 'Alyson.r@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA236', 'Carl.d@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA237', 'Allene.e@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA238', 'Diane.w@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA239', 'Janice.s@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA240', 'Mina.v@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA241', 'Karole.b@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA242', 'Chiquita.g@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA243', 'Sallie.h@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA244', 'Verlene.y@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA245', 'Marlon.u@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA246', 'Henriette.t@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA247', 'Micha.f@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA248', 'Yuette.r@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA249', 'Lena.i@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA250', 'Alysa.o@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA251', 'Rosena.p@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA252', 'Mercedes.l@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA253', 'Linette.k@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA254', 'Steve.m@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA255', 'Kimbery.j@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA256', 'Myrna.h@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA257', 'Rochelle.n@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA258', 'Katina.b@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA259', 'Jessika.v@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA260', 'Syreeta.f@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA261', 'Lona.g@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA262', 'Drew.t@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA263', 'Jayna.r@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA264', 'Tarra.c@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA265', 'Tegan.d@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA266', 'Armando.a@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA267', 'Wyatt.s@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA268', 'Daina.d@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA269', 'Angelo.c@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA270', 'Arthur.x@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA271', 'Leighann.d@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA272', 'Aileen.f@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA273', 'Carlie.r@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA274', 'Marcelina.e@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA275', 'Julissa.d@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA276', 'Tracy.s@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA277', 'Jade.c@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA278', 'Ivory.v@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA279', 'Spencer.b@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA280', 'Classie.n@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA281', 'Clarissa.h@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA282', 'Isaiah.g@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA283', 'Merissa.t@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA284', 'Shaina.y@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA285', 'Carmella.r@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA286', 'Chieko.d@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA287', 'Johnna.e@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA288', 'Gregoria.w@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA289', 'Jone.s@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA290', 'Bernadine.v@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA291', 'Marylou.b@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA292', 'Lacy.g@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA293', 'Laurice.h@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA294', 'Ena.y@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA295', 'Mimi.u@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA296', 'casey.j@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA297', 'logan.c@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA298', 'raj.s@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA299', 'ranjan.v@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA300', 'survu.s@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA301', 'reema.d@husky.ney.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA302', 'archana.c@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA303', 'vandhana.t@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA304', 'john.k@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA305', 'charles.c@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA306', 'tim.c@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA307', 'linda.r@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA308', 'cameron.p@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA309', 'kumar.s@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA310', 'kevin.s@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA311', 'mary.g@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA312', 'tess.b@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA313', 'catherine.t@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA314', 'vimal.n@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA315', 'Johana.a@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA316', 'Sherri.s@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA317', 'Michaela.d@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA318', 'Song.c@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA319', 'Ileana.x@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA320', 'May.d@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA321', 'Anne.f@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA322', 'Sharolyn.r@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA323', 'Marissa.e@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA324', 'Annamaria.d@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA325', 'Ursula.s@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA326', 'Leonardo.c@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA327', 'Annelle.v@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA328', 'Johnnie.b@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA329', 'Charley.n@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA330', 'Lacresha.h@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA331', 'Eliza.g@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA332', 'Fernando.t@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA333', 'Graig.y@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA334', 'Alyson.r@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA335', 'Carl.d@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA336', 'Allene.e@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA337', 'Diane.w@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA338', 'Janice.s@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA339', 'Mina.v@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA340', 'Karole.b@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA341', 'Chiquita.g@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA342', 'Sallie.h@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA343', 'Verlene.y@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA344', 'Marlon.u@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA345', 'Henriette.t@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA346', 'Micha.f@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA347', 'Yuette.r@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA348', 'Lena.i@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA349', 'Alysa.o@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA350', 'Rosena.p@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA351', 'Mercedes.l@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA352', 'Linette.k@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA353', 'Steve.m@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA354', 'Kimbery.j@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA355', 'Myrna.h@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA356', 'Rochelle.n@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA357', 'Katina.b@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA358', 'Jessika.v@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA359', 'Syreeta.f@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA360', 'Lona.g@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA361', 'Drew.t@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA362', 'Jayna.r@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA363', 'Tarra.c@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA364', 'Tegan.d@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA365', 'Armando.a@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA366', 'Wyatt.s@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA367', 'Daina.d@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA368', 'Angelo.c@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA369', 'Arthur.x@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA370', 'Leighann.d@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA371', 'Aileen.f@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA372', 'Carlie.r@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA373', 'Marcelina.e@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA374', 'Julissa.d@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA375', 'Tracy.s@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA376', 'Jade.c@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA377', 'Ivory.v@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA378', 'Spencer.b@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA379', 'Classie.n@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA380', 'Clarissa.h@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA381', 'Isaiah.g@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA382', 'Merissa.t@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA383', 'Shaina.y@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA384', 'Carmella.r@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA385', 'Chieko.d@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA386', 'Johnna.e@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA387', 'Gregoria.w@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA388', 'Jone.s@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA389', 'Bernadine.v@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA390', 'Marylou.b@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA391', 'Lacy.g@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA392', 'Laurice.h@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA393', 'Ena.y@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA394', 'Mimi.u@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA395', 'casey.j@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA396', 'logan.c@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA397', 'raj.s@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA398', 'Gregoria.w@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA399', 'Jone.s@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA400', 'Bernadine.v@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA401', 'Marylou.b@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA402', 'Lacy.g@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA403', 'Laurice.h@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA404', 'Ena.y@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA405', 'Mimi.u@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA406', 'casey.j@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA407', 'logan.c@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA408', 'raj.s@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA409', 'Gregoria.w@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA410', 'Jone.s@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA411', 'Bernadine.v@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA412', 'Marylou.b@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA413', 'Lacy.g@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA414', 'Laurice.h@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA415', 'Ena.y@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA416', 'Mimi.u@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA417', 'casey.j@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA418', 'logan.c@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA419', 'raj.s@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA420', 'Gregoria.w@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA421', 'Jone.s@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA422', 'Bernadine.v@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA423', 'Marylou.b@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA424', 'Lacy.g@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA425', 'Laurice.h@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA426', 'Ena.y@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA427', 'Mimi.u@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA428', 'casey.j@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA429', 'logan.c@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA430', 'raj.s@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA431', 'Yuette.r@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA432', 'Lena.i@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA433', 'Alysa.o@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA434', 'Rosena.p@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA435', 'Mercedes.l@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA436', 'Linette.k@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA437', 'Steve.m@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA438', 'Kimbery.j@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA439', 'Myrna.h@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA440', 'Rochelle.n@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA441', 'Katina.b@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA442', 'Jessika.v@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA443', 'Syreeta.f@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA444', 'Yuette.r@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA445', 'Lena.i@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA446', 'Alysa.o@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA447', 'Rosena.p@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA448', 'Mercedes.l@husky.neu.edu');
            INSERT INTO witricity.device_user_mapping (Device_ID, User_ID) VALUES ('DCOEA16AA449', 'Linette.k@husky.neu.edu');

             select 'After inserting data into table device_user_mapping';
             
             COMMIT;
            
        END IF; 
       END IF;        
      
END 
$$

-- Alert_log data insert Procedure with error handling
--


DELIMITER $$  

CREATE PROCEDURE alert_log_data_insert(pdata_insert varchar(2),pdata varchar(2000),ptable_name varchar(50))

   BEGIN
      -- Declaration Section
      --
	  DECLARE l_string varchar(2000) DEFAULT NULL;
	  DECLARE l_occurences INT default 0;
	  DECLARE l_column1 varchar(200) default '';
      DECLARE l_column2 varchar(200) default NULL;
      DECLARE l_column3 varchar(200) default NULL;
      DECLARE l_no_of_columns INT DEFAULT 0;
      DECLARE l_error_message varchar(200) default NULL;
      --
      -- DECLARE CONTINUE HANDLER FOR 1062 SELECT 'Duplicate keys error encountered' into l_error_message;
      DECLARE CONTINUE HANDLER FOR SQLEXCEPTION -- SELECT 'SQLException encountered' into l_error_message; 
	  -- DECLARE CONTINUE HANDLER FOR 1452 select 'Foreign key constraint violated' into l_error_message;
      --
      BEGIN
        --
		get diagnostics condition 1
		       
          @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
			SET @full_error = CONCAT("ERROR ", @errno, @text);
		  
		
		IF @full_error like 'ERROR 1452Cannot add or update a child row: a foreign key constraint fails%' then
		   INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('Alert_log',pdata,'Foreign key constraint violated',SYSDATE());
		END IF;
		--
		SET l_error_message =  @full_error;
		--
        INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('Alert_log',pdata,l_error_message,SYSDATE());
             commit;
        
        END;
      --
      IF pdata_insert NOT IN ('Y','N') THEN
         --
         SIGNAL SQLSTATE '45000'
         SET MESSAGE_TEXT = 'Invalid value passed to first parameter.(Valid value:Y/N)';
         INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES('alert_log_data_insert',pdata,'Invalid value passed to first parameter.(Valid value:Y/N)',SYSDATE());
             commit; 
     ELSE 
	  if pdata_insert = 'Y' then
	    --
        SET l_string = pdata;
	    --
        SELECT LENGTH(l_string) - LENGTH(REPLACE(l_string, '|', ''))+1 into l_occurences; 
	    --
        SELECT COUNT(*) into l_no_of_columns
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE upper(table_schema) = upper('witricity')
        AND upper(table_name) = upper(ptable_name);
        --
        IF(l_no_of_columns != l_occurences) THEN 
          SIGNAL SQLSTATE '45000'
          SET MESSAGE_TEXT = 'Insufficient data passed to the insert into table';
          --
          INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES(ptable_name,pdata,'Insufficient data passed to the insert into table',SYSDATE());
             commit; 
         ELSE
             --
             SET l_column1 = SPLIT_STR(pdata,'|',1);
             SET l_column2 = SPLIT_STR(pdata,'|',2);
             SET l_column3 = SPLIT_STR(pdata,'|',3);
             -- 
             START TRANSACTION;
             -- insert a new record into article_tags
            INSERT INTO alert_log(Log_ID,User_ID,Alert_ID)
             VALUES(convert(l_column1, SIGNED INTEGER),l_column2,CONVERT(l_column3, SIGNED INTEGER));
             -- 
             COMMIT;
             --
           END IF;
             --
		
		ELSE  -- Insert the bulk data using inseet statements pdata_insert = N
           --
           -- select 'Inside pdata_insert N';
           
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900001', 'ranjan.v@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900002', 'reema.d@husky.ney.edu', '7001');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900003', 'reema.d@husky.ney.edu', '7004');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900004', 'ranjan.v@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900005', 'archana.c@husky.neu.edu', '7000');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900006', 'survu.s@husky.neu.edu', '7001');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900007', 'archana.c@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900008', 'ranjan.v@husky.neu.edu', '7004');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900009', 'survu.s@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900010', 'linda.r@husky.neu.edu', '7006');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900011', 'tess.b@husky.neu.edu', '7009');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900012', 'Johana.a@husky.neu.edu', '7014');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900013', 'Michaela.d@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900014', 'Song.c@husky.neu.edu', '7005');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900015', 'May.d@husky.neu.edu', '7001');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900016', 'Anne.f@husky.neu.edu', '7006');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900017', 'Marissa.e@husky.neu.edu', '7007');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900018', 'Ursula.s@husky.neu.edu', '7009');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900019', 'Johnnie.b@husky.neu.edu', '7010');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900020', 'Graig.y@husky.neu.edu', '7005');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900021', 'Alyson.r@husky.neu.edu', '7012');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900022', 'Carl.d@husky.neu.edu', '7014');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900023', 'Diane.w@husky.neu.edu', '7007');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900024', 'Mina.v@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900025', 'Chiquita.g@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900026', 'Verlene.y@husky.neu.edu', '7009');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900027', 'Marlon.u@husky.neu.edu', '7001');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900028', 'Micha.f@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900029', 'Alysa.o@husky.neu.edu', '7012');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900030', 'Linette.k@husky.neu.edu', '7017');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900031', 'Myrna.h@husky.neu.edu', '7017');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900032', 'Katina.b@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900033', 'Syreeta.f@husky.neu.edu', '7010');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900034', 'linda.r@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900035', 'cameron.p@husky.neu.edu', '7009');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900036', 'kumar.s@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900037', 'kevin.s@husky.neu.edu', '7016');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900038', 'mary.g@husky.neu.edu', '7009');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900039', 'tess.b@husky.neu.edu', '7005');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900040', 'catherine.t@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900041', 'vimal.n@husky.neu.edu', '7014');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900042', 'Johana.a@husky.neu.edu', '7014');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900043', 'Sherri.s@husky.neu.edu', '7010');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900044', 'Michaela.d@husky.neu.edu', '7004');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900045', 'Song.c@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900046', 'Ileana.x@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900047', 'May.d@husky.neu.edu', '7006');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900048', 'Anne.f@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900049', 'Sharolyn.r@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900050', 'Marissa.e@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900051', 'Kimbery.j@husky.neu.edu', '7017');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900052', 'Myrna.h@husky.neu.edu', '7011');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900053', 'Rochelle.n@husky.neu.edu', '7001');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900054', 'Katina.b@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900055', 'Jessika.v@husky.neu.edu', '7008');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900056', 'Syreeta.f@husky.neu.edu', '7000');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900057', 'Lona.g@husky.neu.edu', '7011');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900058', 'Drew.t@husky.neu.edu', '7016');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900059', 'Jayna.r@husky.neu.edu', '7013');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900060', 'Tarra.c@husky.neu.edu', '7014');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900061', 'Tegan.d@husky.neu.edu', '7008');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900062', 'Armando.a@husky.neu.edu', '7018');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900063', 'Wyatt.s@husky.neu.edu', '7005');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900064', 'Daina.d@husky.neu.edu', '7010');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900065', 'Angelo.c@husky.neu.edu', '7008');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900066', 'Arthur.x@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900067', 'Leighann.d@husky.neu.edu', '7011');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900068', 'Aileen.f@husky.neu.edu', '7000');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900069', 'Carlie.r@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900070', 'Marcelina.e@husky.neu.edu', '7016');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900071', 'Julissa.d@husky.neu.edu', '7010');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900072', 'Tracy.s@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900073', 'Tarra.c@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900074', 'Tegan.d@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900075', 'Armando.a@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900076', 'Wyatt.s@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900077', 'Daina.d@husky.neu.edu', '7016');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900078', 'Angelo.c@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900079', 'Arthur.x@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900080', 'Leighann.d@husky.neu.edu', '7001');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900081', 'Aileen.f@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900082', 'Carlie.r@husky.neu.edu', '7006');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900083', 'Marcelina.e@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900084', 'Julissa.d@husky.neu.edu', '7012');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900085', 'Tracy.s@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900086', 'Jade.c@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900087', 'Ivory.v@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900088', 'Spencer.b@husky.neu.edu', '7011');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900089', 'Classie.n@husky.neu.edu', '7008');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900090', 'Clarissa.h@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900091', 'Isaiah.g@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900092', 'Merissa.t@husky.neu.edu', '7018');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900093', 'Shaina.y@husky.neu.edu', '7012');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900094', 'Carmella.r@husky.neu.edu', '7007');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900095', 'Chieko.d@husky.neu.edu', '7000');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900096', 'Johnna.e@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900097', 'Gregoria.w@husky.neu.edu', '7010');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900098', 'reema.d@husky.ney.edu', '7007');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900099', 'archana.c@husky.neu.edu', '7000');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900100', 'vandhana.t@husky.neu.edu', '7010');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900101', 'john.k@husky.neu.edu', '7017');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900102', 'charles.c@husky.neu.edu', '7007');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900103', 'tim.c@husky.neu.edu', '7013');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900104', 'linda.r@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900105', 'cameron.p@husky.neu.edu', '7018');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900106', 'kumar.s@husky.neu.edu', '7008');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900107', 'kevin.s@husky.neu.edu', '7007');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900108', 'mary.g@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900109', 'tess.b@husky.neu.edu', '7006');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900110', 'catherine.t@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900111', 'vimal.n@husky.neu.edu', '7008');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900112', 'Johana.a@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900113', 'Sherri.s@husky.neu.edu', '7018');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900114', 'Michaela.d@husky.neu.edu', '7010');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900115', 'Song.c@husky.neu.edu', '7006');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900116', 'Ileana.x@husky.neu.edu', '7012');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900117', 'May.d@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900118', 'Anne.f@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900119', 'Sharolyn.r@husky.neu.edu', '7017');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900120', 'Marissa.e@husky.neu.edu', '7012');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900121', 'Syreeta.f@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900122', 'linda.r@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900123', 'cameron.p@husky.neu.edu', '7013');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900124', 'kumar.s@husky.neu.edu', '7001');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900125', 'kevin.s@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900126', 'mary.g@husky.neu.edu', '7000');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900127', 'tess.b@husky.neu.edu', '7000');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900128', 'catherine.t@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900129', 'vimal.n@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900130', 'Johana.a@husky.neu.edu', '7007');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900131', 'Sherri.s@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900132', 'Michaela.d@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900133', 'Song.c@husky.neu.edu', '7014');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900134', 'Ileana.x@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900135', 'May.d@husky.neu.edu', '7009');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900136', 'Anne.f@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900137', 'Sharolyn.r@husky.neu.edu', '7016');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900138', 'Marissa.e@husky.neu.edu', '7009');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900139', 'Kimbery.j@husky.neu.edu', '7005');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900140', 'Myrna.h@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900141', 'Rochelle.n@husky.neu.edu', '7014');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900142', 'Katina.b@husky.neu.edu', '7014');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900143', 'Jessika.v@husky.neu.edu', '7010');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900144', 'Syreeta.f@husky.neu.edu', '7004');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900145', 'Lona.g@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900146', 'Drew.t@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900147', 'Jayna.r@husky.neu.edu', '7006');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900148', 'Tarra.c@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900149', 'Tegan.d@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900150', 'Armando.a@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900151', 'Wyatt.s@husky.neu.edu', '7017');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900152', 'Aileen.f@husky.neu.edu', '7011');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900153', 'Carlie.r@husky.neu.edu', '7001');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900154', 'Marcelina.e@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900155', 'Julissa.d@husky.neu.edu', '7008');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900156', 'Tracy.s@husky.neu.edu', '7000');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900157', 'Tarra.c@husky.neu.edu', '7011');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900158', 'Tegan.d@husky.neu.edu', '7016');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900159', 'Armando.a@husky.neu.edu', '7013');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900160', 'Wyatt.s@husky.neu.edu', '7014');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900161', 'Daina.d@husky.neu.edu', '7008');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900162', 'Angelo.c@husky.neu.edu', '7018');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900163', 'Arthur.x@husky.neu.edu', '7005');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900164', 'Leighann.d@husky.neu.edu', '7010');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900165', 'Aileen.f@husky.neu.edu', '7008');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900166', 'Carlie.r@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900167', 'Marcelina.e@husky.neu.edu', '7011');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900168', 'Julissa.d@husky.neu.edu', '7000');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900169', 'Tracy.s@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900170', 'Jade.c@husky.neu.edu', '7016');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900171', 'Ivory.v@husky.neu.edu', '7010');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900172', 'Spencer.b@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900173', 'Classie.n@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900174', 'Clarissa.h@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900175', 'Isaiah.g@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900176', 'Merissa.t@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900177', 'Shaina.y@husky.neu.edu', '7016');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900178', 'Carmella.r@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900179', 'Chieko.d@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900180', 'Johnna.e@husky.neu.edu', '7001');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900181', 'Gregoria.w@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900182', 'reema.d@husky.ney.edu', '7006');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900183', 'archana.c@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900184', 'vandhana.t@husky.neu.edu', '7012');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900185', 'john.k@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900186', 'charles.c@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900187', 'tim.c@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900188', 'linda.r@husky.neu.edu', '7011');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900189', 'cameron.p@husky.neu.edu', '7008');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900190', 'kumar.s@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900191', 'kevin.s@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900192', 'mary.g@husky.neu.edu', '7018');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900193', 'tess.b@husky.neu.edu', '7012');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900194', 'catherine.t@husky.neu.edu', '7007');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900195', 'vimal.n@husky.neu.edu', '7000');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900196', 'Johana.a@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900197', 'Sherri.s@husky.neu.edu', '7010');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900198', 'Michaela.d@husky.neu.edu', '7007');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900199', 'Song.c@husky.neu.edu', '7000');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900200', 'Ileana.x@husky.neu.edu', '7010');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900201', 'May.d@husky.neu.edu', '7017');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900202', 'Anne.f@husky.neu.edu', '7007');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900203', 'Sharolyn.r@husky.neu.edu', '7013');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900204', 'Marissa.e@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900205', 'Syreeta.f@husky.neu.edu', '7018');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900206', 'linda.r@husky.neu.edu', '7008');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900207', 'cameron.p@husky.neu.edu', '7007');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900208', 'kumar.s@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900209', 'kevin.s@husky.neu.edu', '7006');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900210', 'mary.g@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900211', 'tess.b@husky.neu.edu', '7008');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900212', 'catherine.t@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900213', 'vimal.n@husky.neu.edu', '7018');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900214', 'Johana.a@husky.neu.edu', '7010');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900215', 'Sherri.s@husky.neu.edu', '7006');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900216', 'Michaela.d@husky.neu.edu', '7012');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900217', 'Song.c@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900218', 'Ileana.x@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900219', 'May.d@husky.neu.edu', '7017');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900220', 'Anne.f@husky.neu.edu', '7012');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900221', 'Sharolyn.r@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900222', 'Marissa.e@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900223', 'Kimbery.j@husky.neu.edu', '7013');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900224', 'Myrna.h@husky.neu.edu', '7001');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900225', 'ranjan.v@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900226', 'reema.d@husky.ney.edu', '7000');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900227', 'reema.d@husky.ney.edu', '7000');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900228', 'ranjan.v@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900229', 'archana.c@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900230', 'survu.s@husky.neu.edu', '7007');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900231', 'archana.c@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900232', 'ranjan.v@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900233', 'survu.s@husky.neu.edu', '7014');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900234', 'linda.r@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900235', 'tess.b@husky.neu.edu', '7009');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900236', 'Johana.a@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900237', 'Michaela.d@husky.neu.edu', '7016');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900238', 'Song.c@husky.neu.edu', '7009');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900239', 'May.d@husky.neu.edu', '7005');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900240', 'Anne.f@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900241', 'Marissa.e@husky.neu.edu', '7014');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900242', 'Ursula.s@husky.neu.edu', '7014');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900243', 'Johnnie.b@husky.neu.edu', '7010');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900244', 'Graig.y@husky.neu.edu', '7004');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900245', 'Alyson.r@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900246', 'Carl.d@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900247', 'Diane.w@husky.neu.edu', '7006');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900248', 'Mina.v@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900249', 'Chiquita.g@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900250', 'Verlene.y@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900251', 'Marlon.u@husky.neu.edu', '7017');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900252', 'Micha.f@husky.neu.edu', '7011');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900253', 'Alysa.o@husky.neu.edu', '7001');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900254', 'Linette.k@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900255', 'Myrna.h@husky.neu.edu', '7008');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900256', 'Katina.b@husky.neu.edu', '7000');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900257', 'Syreeta.f@husky.neu.edu', '7011');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900258', 'linda.r@husky.neu.edu', '7016');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900259', 'cameron.p@husky.neu.edu', '7013');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900260', 'kumar.s@husky.neu.edu', '7014');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900261', 'kevin.s@husky.neu.edu', '7008');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900262', 'mary.g@husky.neu.edu', '7018');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900263', 'tess.b@husky.neu.edu', '7005');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900264', 'catherine.t@husky.neu.edu', '7010');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900265', 'vimal.n@husky.neu.edu', '7008');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900266', 'Johana.a@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900267', 'Sherri.s@husky.neu.edu', '7011');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900268', 'Michaela.d@husky.neu.edu', '7000');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900269', 'Song.c@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900270', 'Ileana.x@husky.neu.edu', '7016');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900271', 'May.d@husky.neu.edu', '7010');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900272', 'Anne.f@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900273', 'Sharolyn.r@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900274', 'Marissa.e@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900275', 'Kimbery.j@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900276', 'Myrna.h@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900277', 'Rochelle.n@husky.neu.edu', '7016');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900278', 'Katina.b@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900279', 'Jessika.v@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900280', 'Syreeta.f@husky.neu.edu', '7001');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900281', 'Lona.g@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900282', 'Drew.t@husky.neu.edu', '7006');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900283', 'Jayna.r@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900284', 'Tarra.c@husky.neu.edu', '7012');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900285', 'Tegan.d@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900286', 'Armando.a@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900287', 'Wyatt.s@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900288', 'Daina.d@husky.neu.edu', '7011');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900289', 'Angelo.c@husky.neu.edu', '7008');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900290', 'Arthur.x@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900291', 'Leighann.d@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900292', 'Aileen.f@husky.neu.edu', '7018');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900293', 'Carlie.r@husky.neu.edu', '7012');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900294', 'Marcelina.e@husky.neu.edu', '7007');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900295', 'Julissa.d@husky.neu.edu', '7000');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900296', 'Tracy.s@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900297', 'Tarra.c@husky.neu.edu', '7010');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900298', 'Tegan.d@husky.neu.edu', '7007');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900299', 'Armando.a@husky.neu.edu', '7000');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900300', 'Wyatt.s@husky.neu.edu', '7010');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900301', 'Daina.d@husky.neu.edu', '7017');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900302', 'Angelo.c@husky.neu.edu', '7007');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900303', 'Arthur.x@husky.neu.edu', '7013');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900304', 'Leighann.d@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900305', 'Aileen.f@husky.neu.edu', '7018');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900306', 'Carlie.r@husky.neu.edu', '7008');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900307', 'Marcelina.e@husky.neu.edu', '7007');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900308', 'Julissa.d@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900309', 'Tracy.s@husky.neu.edu', '7006');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900310', 'Jade.c@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900311', 'Ivory.v@husky.neu.edu', '7008');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900312', 'Spencer.b@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900313', 'Classie.n@husky.neu.edu', '7018');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900314', 'Clarissa.h@husky.neu.edu', '7010');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900315', 'Isaiah.g@husky.neu.edu', '7006');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900316', 'Merissa.t@husky.neu.edu', '7012');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900317', 'Shaina.y@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900318', 'Carmella.r@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900319', 'Chieko.d@husky.neu.edu', '7017');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900320', 'Johnna.e@husky.neu.edu', '7012');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900321', 'Gregoria.w@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900322', 'reema.d@husky.ney.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900323', 'archana.c@husky.neu.edu', '7013');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900324', 'vandhana.t@husky.neu.edu', '7001');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900325', 'john.k@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900326', 'charles.c@husky.neu.edu', '7000');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900327', 'tim.c@husky.neu.edu', '7000');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900328', 'linda.r@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900329', 'cameron.p@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900330', 'kumar.s@husky.neu.edu', '7007');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900331', 'kevin.s@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900332', 'mary.g@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900333', 'tess.b@husky.neu.edu', '7014');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900334', 'catherine.t@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900335', 'vimal.n@husky.neu.edu', '7009');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900336', 'Johana.a@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900337', 'Sherri.s@husky.neu.edu', '7016');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900338', 'Michaela.d@husky.neu.edu', '7009');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900339', 'Song.c@husky.neu.edu', '7005');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900340', 'Ileana.x@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900341', 'May.d@husky.neu.edu', '7014');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900342', 'Anne.f@husky.neu.edu', '7014');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900343', 'Sharolyn.r@husky.neu.edu', '7010');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900344', 'Marissa.e@husky.neu.edu', '7004');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900345', 'Syreeta.f@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900346', 'linda.r@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900347', 'cameron.p@husky.neu.edu', '7006');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900348', 'kumar.s@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900349', 'kevin.s@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900350', 'mary.g@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900351', 'tess.b@husky.neu.edu', '7017');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900352', 'catherine.t@husky.neu.edu', '7011');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900353', 'vimal.n@husky.neu.edu', '7001');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900354', 'Johana.a@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900355', 'Sherri.s@husky.neu.edu', '7008');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900356', 'Michaela.d@husky.neu.edu', '7000');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900357', 'Song.c@husky.neu.edu', '7011');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900358', 'Ileana.x@husky.neu.edu', '7016');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900359', 'May.d@husky.neu.edu', '7013');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900360', 'Anne.f@husky.neu.edu', '7014');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900361', 'Sharolyn.r@husky.neu.edu', '7008');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900362', 'Marissa.e@husky.neu.edu', '7018');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900363', 'Kimbery.j@husky.neu.edu', '7005');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900364', 'Myrna.h@husky.neu.edu', '7010');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900365', 'Rochelle.n@husky.neu.edu', '7008');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900366', 'Katina.b@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900367', 'Jessika.v@husky.neu.edu', '7011');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900368', 'Syreeta.f@husky.neu.edu', '7000');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900369', 'Lona.g@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900370', 'Drew.t@husky.neu.edu', '7016');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900371', 'Jayna.r@husky.neu.edu', '7010');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900372', 'Tarra.c@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900373', 'Tegan.d@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900374', 'Armando.a@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900375', 'Wyatt.s@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900376', 'Aileen.f@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900377', 'Carlie.r@husky.neu.edu', '7016');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900378', 'Marcelina.e@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900379', 'Julissa.d@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900380', 'Tracy.s@husky.neu.edu', '7001');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900381', 'Tarra.c@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900382', 'Tegan.d@husky.neu.edu', '7006');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900383', 'Armando.a@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900384', 'Wyatt.s@husky.neu.edu', '7012');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900385', 'Daina.d@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900386', 'Angelo.c@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900387', 'Arthur.x@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900388', 'Leighann.d@husky.neu.edu', '7011');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900389', 'Aileen.f@husky.neu.edu', '7008');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900390', 'Carlie.r@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900391', 'Marcelina.e@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900392', 'Julissa.d@husky.neu.edu', '7018');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900393', 'Tracy.s@husky.neu.edu', '7012');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900394', 'Jade.c@husky.neu.edu', '7007');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900395', 'Ivory.v@husky.neu.edu', '7000');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900396', 'Spencer.b@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900397', 'Classie.n@husky.neu.edu', '7010');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900398', 'Clarissa.h@husky.neu.edu', '7007');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900399', 'Isaiah.g@husky.neu.edu', '7000');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900400', 'Merissa.t@husky.neu.edu', '7010');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900401', 'Shaina.y@husky.neu.edu', '7017');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900402', 'Carmella.r@husky.neu.edu', '7007');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900403', 'Chieko.d@husky.neu.edu', '7013');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900404', 'Johnna.e@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900405', 'Gregoria.w@husky.neu.edu', '7018');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900406', 'reema.d@husky.ney.edu', '7008');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900407', 'archana.c@husky.neu.edu', '7007');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900408', 'vandhana.t@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900409', 'john.k@husky.neu.edu', '7006');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900410', 'charles.c@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900411', 'tim.c@husky.neu.edu', '7008');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900412', 'linda.r@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900413', 'cameron.p@husky.neu.edu', '7018');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900414', 'kumar.s@husky.neu.edu', '7010');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900415', 'kevin.s@husky.neu.edu', '7006');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900416', 'mary.g@husky.neu.edu', '7012');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900417', 'tess.b@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900418', 'catherine.t@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900419', 'vimal.n@husky.neu.edu', '7017');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900420', 'Johana.a@husky.neu.edu', '7012');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900421', 'Sherri.s@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900422', 'Michaela.d@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900423', 'Song.c@husky.neu.edu', '7013');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900424', 'Ileana.x@husky.neu.edu', '7001');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900425', 'May.d@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900426', 'Anne.f@husky.neu.edu', '7000');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900427', 'Sharolyn.r@husky.neu.edu', '7000');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900428', 'Marissa.e@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900429', 'Syreeta.f@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900430', 'linda.r@husky.neu.edu', '7007');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900431', 'cameron.p@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900432', 'kumar.s@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900433', 'kevin.s@husky.neu.edu', '7014');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900434', 'mary.g@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900435', 'tess.b@husky.neu.edu', '7009');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900436', 'catherine.t@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900437', 'vimal.n@husky.neu.edu', '7016');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900438', 'Johana.a@husky.neu.edu', '7009');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900439', 'Sherri.s@husky.neu.edu', '7005');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900440', 'Michaela.d@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900441', 'Song.c@husky.neu.edu', '7014');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900442', 'Ileana.x@husky.neu.edu', '7014');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900443', 'May.d@husky.neu.edu', '7010');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900444', 'Anne.f@husky.neu.edu', '7004');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900445', 'Sharolyn.r@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900446', 'Marissa.e@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900447', 'Kimbery.j@husky.neu.edu', '7006');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900448', 'Myrna.h@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900449', 'ranjan.v@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900450', 'reema.d@husky.ney.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900451', 'reema.d@husky.ney.edu', '7017');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900452', 'ranjan.v@husky.neu.edu', '7011');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900453', 'archana.c@husky.neu.edu', '7001');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900454', 'survu.s@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900455', 'archana.c@husky.neu.edu', '7008');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900456', 'ranjan.v@husky.neu.edu', '7000');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900457', 'survu.s@husky.neu.edu', '7011');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900458', 'linda.r@husky.neu.edu', '7016');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900459', 'tess.b@husky.neu.edu', '7013');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900460', 'Johana.a@husky.neu.edu', '7014');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900461', 'Michaela.d@husky.neu.edu', '7008');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900462', 'Song.c@husky.neu.edu', '7018');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900463', 'May.d@husky.neu.edu', '7005');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900464', 'Anne.f@husky.neu.edu', '7010');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900465', 'Marissa.e@husky.neu.edu', '7008');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900466', 'Ursula.s@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900467', 'Johnnie.b@husky.neu.edu', '7011');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900468', 'Graig.y@husky.neu.edu', '7000');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900469', 'Alyson.r@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900470', 'Carl.d@husky.neu.edu', '7016');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900471', 'Diane.w@husky.neu.edu', '7010');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900472', 'Mina.v@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900473', 'Chiquita.g@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900474', 'Verlene.y@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900475', 'Marlon.u@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900476', 'Micha.f@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900477', 'Alysa.o@husky.neu.edu', '7016');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900478', 'Linette.k@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900479', 'Myrna.h@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900480', 'Katina.b@husky.neu.edu', '7001');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900481', 'Syreeta.f@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900482', 'linda.r@husky.neu.edu', '7006');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900483', 'cameron.p@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900484', 'kumar.s@husky.neu.edu', '7012');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900485', 'kevin.s@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900486', 'mary.g@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900487', 'tess.b@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900488', 'catherine.t@husky.neu.edu', '7011');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900489', 'vimal.n@husky.neu.edu', '7008');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900490', 'Johana.a@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900491', 'Sherri.s@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900492', 'Michaela.d@husky.neu.edu', '7018');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900493', 'Song.c@husky.neu.edu', '7012');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900494', 'Ileana.x@husky.neu.edu', '7007');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900495', 'May.d@husky.neu.edu', '7000');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900496', 'Anne.f@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900497', 'Sharolyn.r@husky.neu.edu', '7010');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900498', 'Marissa.e@husky.neu.edu', '7007');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900499', 'Kimbery.j@husky.neu.edu', '7000');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900500', 'Myrna.h@husky.neu.edu', '7010');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900501', 'Rochelle.n@husky.neu.edu', '7017');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900502', 'Katina.b@husky.neu.edu', '7007');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900503', 'Jessika.v@husky.neu.edu', '7013');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900504', 'Syreeta.f@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900505', 'Lona.g@husky.neu.edu', '7018');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900506', 'Drew.t@husky.neu.edu', '7008');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900507', 'Jayna.r@husky.neu.edu', '7007');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900508', 'Tarra.c@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900509', 'Tegan.d@husky.neu.edu', '7006');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900510', 'Armando.a@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900511', 'Wyatt.s@husky.neu.edu', '7008');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900512', 'Daina.d@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900513', 'Angelo.c@husky.neu.edu', '7018');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900514', 'Arthur.x@husky.neu.edu', '7010');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900515', 'Leighann.d@husky.neu.edu', '7006');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900516', 'Aileen.f@husky.neu.edu', '7012');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900517', 'Carlie.r@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900518', 'Marcelina.e@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900519', 'Julissa.d@husky.neu.edu', '7017');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900520', 'Tracy.s@husky.neu.edu', '7012');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900521', 'Tarra.c@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900522', 'Tegan.d@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900523', 'Armando.a@husky.neu.edu', '7013');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900524', 'Wyatt.s@husky.neu.edu', '7001');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900525', 'Daina.d@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900526', 'Angelo.c@husky.neu.edu', '7000');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900527', 'Arthur.x@husky.neu.edu', '7000');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900528', 'Leighann.d@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900529', 'Aileen.f@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900530', 'Carlie.r@husky.neu.edu', '7007');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900531', 'Marcelina.e@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900532', 'Julissa.d@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900533', 'Tracy.s@husky.neu.edu', '7014');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900534', 'Jade.c@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900535', 'Ivory.v@husky.neu.edu', '7009');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900536', 'Spencer.b@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900537', 'Classie.n@husky.neu.edu', '7016');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900538', 'Clarissa.h@husky.neu.edu', '7009');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900539', 'Isaiah.g@husky.neu.edu', '7005');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900540', 'Merissa.t@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900541', 'Shaina.y@husky.neu.edu', '7014');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900542', 'Carmella.r@husky.neu.edu', '7014');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900543', 'Chieko.d@husky.neu.edu', '7010');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900544', 'Johnna.e@husky.neu.edu', '7004');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900545', 'Gregoria.w@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900546', 'reema.d@husky.ney.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900547', 'archana.c@husky.neu.edu', '7006');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900548', 'vandhana.t@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900549', 'john.k@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900550', 'charles.c@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900551', 'tim.c@husky.neu.edu', '7017');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900552', 'linda.r@husky.neu.edu', '7011');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900553', 'cameron.p@husky.neu.edu', '7001');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900554', 'kumar.s@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900555', 'kevin.s@husky.neu.edu', '7008');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900556', 'mary.g@husky.neu.edu', '7000');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900557', 'tess.b@husky.neu.edu', '7011');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900558', 'catherine.t@husky.neu.edu', '7016');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900559', 'vimal.n@husky.neu.edu', '7013');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900560', 'Johana.a@husky.neu.edu', '7014');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900561', 'Sherri.s@husky.neu.edu', '7008');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900562', 'Michaela.d@husky.neu.edu', '7018');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900563', 'Song.c@husky.neu.edu', '7005');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900564', 'Ileana.x@husky.neu.edu', '7010');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900565', 'May.d@husky.neu.edu', '7008');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900566', 'Anne.f@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900567', 'Sharolyn.r@husky.neu.edu', '7011');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900568', 'Marissa.e@husky.neu.edu', '7000');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900569', 'Syreeta.f@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900570', 'linda.r@husky.neu.edu', '7016');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900571', 'cameron.p@husky.neu.edu', '7010');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900572', 'kumar.s@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900573', 'kevin.s@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900574', 'mary.g@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900575', 'tess.b@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900576', 'catherine.t@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900577', 'vimal.n@husky.neu.edu', '7016');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900578', 'Johana.a@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900579', 'Sherri.s@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900580', 'Michaela.d@husky.neu.edu', '7001');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900581', 'Song.c@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900582', 'Ileana.x@husky.neu.edu', '7006');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900583', 'May.d@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900584', 'Anne.f@husky.neu.edu', '7012');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900585', 'Sharolyn.r@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900586', 'Marissa.e@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900587', 'Kimbery.j@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900588', 'Myrna.h@husky.neu.edu', '7011');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900589', 'Rochelle.n@husky.neu.edu', '7008');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900590', 'Katina.b@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900591', 'Jessika.v@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900592', 'Syreeta.f@husky.neu.edu', '7018');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900593', 'Lona.g@husky.neu.edu', '7012');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900594', 'Drew.t@husky.neu.edu', '7007');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900595', 'Jayna.r@husky.neu.edu', '7000');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900596', 'Tarra.c@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900597', 'Tegan.d@husky.neu.edu', '7010');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900598', 'Armando.a@husky.neu.edu', '7007');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900599', 'Wyatt.s@husky.neu.edu', '7000');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900600', 'Aileen.f@husky.neu.edu', '7010');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900601', 'Carlie.r@husky.neu.edu', '7017');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900602', 'Marcelina.e@husky.neu.edu', '7007');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900603', 'Julissa.d@husky.neu.edu', '7013');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900604', 'Tracy.s@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900605', 'Tarra.c@husky.neu.edu', '7018');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900606', 'Tegan.d@husky.neu.edu', '7008');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900607', 'Armando.a@husky.neu.edu', '7007');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900608', 'Wyatt.s@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900609', 'Daina.d@husky.neu.edu', '7006');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900610', 'Angelo.c@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900611', 'Arthur.x@husky.neu.edu', '7008');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900612', 'Leighann.d@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900613', 'Aileen.f@husky.neu.edu', '7018');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900614', 'Carlie.r@husky.neu.edu', '7010');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900615', 'Marcelina.e@husky.neu.edu', '7006');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900616', 'Julissa.d@husky.neu.edu', '7012');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900617', 'Tracy.s@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900618', 'Jade.c@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900619', 'Ivory.v@husky.neu.edu', '7017');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900620', 'Spencer.b@husky.neu.edu', '7012');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900621', 'Classie.n@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900622', 'Clarissa.h@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900623', 'Isaiah.g@husky.neu.edu', '7013');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900624', 'Merissa.t@husky.neu.edu', '7001');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900625', 'Shaina.y@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900626', 'Carmella.r@husky.neu.edu', '7000');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900627', 'Chieko.d@husky.neu.edu', '7000');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900628', 'Johnna.e@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900629', 'Gregoria.w@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900630', 'reema.d@husky.ney.edu', '7007');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900631', 'archana.c@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900632', 'vandhana.t@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900633', 'john.k@husky.neu.edu', '7014');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900634', 'charles.c@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900635', 'tim.c@husky.neu.edu', '7009');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900636', 'linda.r@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900637', 'cameron.p@husky.neu.edu', '7016');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900638', 'kumar.s@husky.neu.edu', '7009');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900639', 'kevin.s@husky.neu.edu', '7005');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900640', 'mary.g@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900641', 'tess.b@husky.neu.edu', '7014');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900642', 'catherine.t@husky.neu.edu', '7014');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900643', 'vimal.n@husky.neu.edu', '7010');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900644', 'Johana.a@husky.neu.edu', '7004');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900645', 'Sherri.s@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900646', 'Michaela.d@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900647', 'Song.c@husky.neu.edu', '7006');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900648', 'Ileana.x@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900649', 'May.d@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900650', 'Anne.f@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900651', 'Sharolyn.r@husky.neu.edu', '7017');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900652', 'Marissa.e@husky.neu.edu', '7011');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900653', 'Syreeta.f@husky.neu.edu', '7001');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900654', 'linda.r@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900655', 'cameron.p@husky.neu.edu', '7008');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900656', 'kumar.s@husky.neu.edu', '7000');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900657', 'kevin.s@husky.neu.edu', '7011');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900658', 'mary.g@husky.neu.edu', '7016');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900659', 'tess.b@husky.neu.edu', '7013');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900660', 'catherine.t@husky.neu.edu', '7014');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900661', 'vimal.n@husky.neu.edu', '7008');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900662', 'Johana.a@husky.neu.edu', '7018');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900663', 'Sherri.s@husky.neu.edu', '7005');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900664', 'Michaela.d@husky.neu.edu', '7010');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900665', 'Song.c@husky.neu.edu', '7008');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900666', 'Ileana.x@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900667', 'May.d@husky.neu.edu', '7011');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900668', 'Anne.f@husky.neu.edu', '7000');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900669', 'Sharolyn.r@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900670', 'Marissa.e@husky.neu.edu', '7016');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900671', 'Kimbery.j@husky.neu.edu', '7010');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900672', 'Myrna.h@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900673', 'ranjan.v@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900674', 'reema.d@husky.ney.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900675', 'reema.d@husky.ney.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900676', 'ranjan.v@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900677', 'archana.c@husky.neu.edu', '7016');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900678', 'survu.s@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900679', 'archana.c@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900680', 'ranjan.v@husky.neu.edu', '7001');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900681', 'survu.s@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900682', 'linda.r@husky.neu.edu', '7006');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900683', 'tess.b@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900684', 'Johana.a@husky.neu.edu', '7012');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900685', 'Michaela.d@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900686', 'Song.c@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900687', 'May.d@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900688', 'Anne.f@husky.neu.edu', '7011');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900689', 'Marissa.e@husky.neu.edu', '7008');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900690', 'Ursula.s@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900691', 'Johnnie.b@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900692', 'Graig.y@husky.neu.edu', '7018');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900693', 'Alyson.r@husky.neu.edu', '7012');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900694', 'Carl.d@husky.neu.edu', '7007');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900695', 'Diane.w@husky.neu.edu', '7000');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900696', 'Mina.v@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900697', 'Chiquita.g@husky.neu.edu', '7010');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900698', 'Verlene.y@husky.neu.edu', '7007');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900699', 'Marlon.u@husky.neu.edu', '7000');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900700', 'Micha.f@husky.neu.edu', '7010');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900701', 'Alysa.o@husky.neu.edu', '7017');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900702', 'Linette.k@husky.neu.edu', '7007');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900703', 'Myrna.h@husky.neu.edu', '7013');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900704', 'Katina.b@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900705', 'Syreeta.f@husky.neu.edu', '7018');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900706', 'linda.r@husky.neu.edu', '7008');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900707', 'cameron.p@husky.neu.edu', '7007');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900708', 'kumar.s@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900709', 'kevin.s@husky.neu.edu', '7006');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900710', 'mary.g@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900711', 'tess.b@husky.neu.edu', '7008');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900712', 'catherine.t@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900713', 'vimal.n@husky.neu.edu', '7018');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900714', 'Johana.a@husky.neu.edu', '7010');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900715', 'Sherri.s@husky.neu.edu', '7006');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900716', 'Michaela.d@husky.neu.edu', '7012');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900717', 'Song.c@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900718', 'Ileana.x@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900719', 'May.d@husky.neu.edu', '7017');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900720', 'Anne.f@husky.neu.edu', '7012');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900721', 'Sharolyn.r@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900722', 'Marissa.e@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900723', 'Kimbery.j@husky.neu.edu', '7013');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900724', 'Myrna.h@husky.neu.edu', '7001');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900725', 'Rochelle.n@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900726', 'Katina.b@husky.neu.edu', '7000');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900727', 'Jessika.v@husky.neu.edu', '7000');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900728', 'Syreeta.f@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900729', 'Lona.g@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900730', 'Drew.t@husky.neu.edu', '7007');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900731', 'Jayna.r@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900732', 'Tarra.c@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900733', 'Tegan.d@husky.neu.edu', '7014');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900734', 'Armando.a@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900735', 'Wyatt.s@husky.neu.edu', '7009');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900736', 'Daina.d@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900737', 'Angelo.c@husky.neu.edu', '7016');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900738', 'Arthur.x@husky.neu.edu', '7009');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900739', 'Leighann.d@husky.neu.edu', '7005');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900740', 'Aileen.f@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900741', 'Carlie.r@husky.neu.edu', '7014');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900742', 'Marcelina.e@husky.neu.edu', '7014');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900743', 'Julissa.d@husky.neu.edu', '7010');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900744', 'Tracy.s@husky.neu.edu', '7004');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900745', 'Tarra.c@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900746', 'Tegan.d@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900747', 'Armando.a@husky.neu.edu', '7006');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900748', 'Wyatt.s@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900749', 'Daina.d@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900750', 'Angelo.c@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900751', 'Arthur.x@husky.neu.edu', '7017');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900752', 'Leighann.d@husky.neu.edu', '7011');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900753', 'Aileen.f@husky.neu.edu', '7001');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900754', 'Carlie.r@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900755', 'Marcelina.e@husky.neu.edu', '7008');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900756', 'Julissa.d@husky.neu.edu', '7000');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900757', 'Tracy.s@husky.neu.edu', '7011');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900758', 'Jade.c@husky.neu.edu', '7016');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900759', 'Ivory.v@husky.neu.edu', '7013');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900760', 'Spencer.b@husky.neu.edu', '7014');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900761', 'Classie.n@husky.neu.edu', '7008');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900762', 'Clarissa.h@husky.neu.edu', '7018');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900763', 'Isaiah.g@husky.neu.edu', '7005');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900764', 'Merissa.t@husky.neu.edu', '7010');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900765', 'Shaina.y@husky.neu.edu', '7008');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900766', 'Carmella.r@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900767', 'Chieko.d@husky.neu.edu', '7011');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900768', 'Johnna.e@husky.neu.edu', '7000');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900769', 'Gregoria.w@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900770', 'reema.d@husky.ney.edu', '7016');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900771', 'archana.c@husky.neu.edu', '7010');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900772', 'vandhana.t@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900773', 'john.k@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900774', 'charles.c@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900775', 'tim.c@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900776', 'linda.r@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900777', 'cameron.p@husky.neu.edu', '7016');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900778', 'kumar.s@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900779', 'kevin.s@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900780', 'mary.g@husky.neu.edu', '7001');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900781', 'tess.b@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900782', 'catherine.t@husky.neu.edu', '7006');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900783', 'vimal.n@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900784', 'Johana.a@husky.neu.edu', '7012');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900785', 'Sherri.s@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900786', 'Michaela.d@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900787', 'Song.c@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900788', 'Ileana.x@husky.neu.edu', '7011');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900789', 'May.d@husky.neu.edu', '7008');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900790', 'Anne.f@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900791', 'Sharolyn.r@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900792', 'Marissa.e@husky.neu.edu', '7018');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900793', 'Syreeta.f@husky.neu.edu', '7012');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900794', 'linda.r@husky.neu.edu', '7007');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900795', 'cameron.p@husky.neu.edu', '7000');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900796', 'kumar.s@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900797', 'kevin.s@husky.neu.edu', '7010');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900798', 'mary.g@husky.neu.edu', '7007');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900799', 'tess.b@husky.neu.edu', '7000');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900800', 'catherine.t@husky.neu.edu', '7010');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900801', 'vimal.n@husky.neu.edu', '7017');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900802', 'Johana.a@husky.neu.edu', '7007');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900803', 'Sherri.s@husky.neu.edu', '7013');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900804', 'Michaela.d@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900805', 'Song.c@husky.neu.edu', '7018');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900806', 'Ileana.x@husky.neu.edu', '7008');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900807', 'May.d@husky.neu.edu', '7007');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900808', 'Anne.f@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900809', 'Sharolyn.r@husky.neu.edu', '7006');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900810', 'Marissa.e@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900811', 'Kimbery.j@husky.neu.edu', '7008');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900812', 'Myrna.h@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900813', 'Rochelle.n@husky.neu.edu', '7018');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900814', 'Katina.b@husky.neu.edu', '7010');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900815', 'Jessika.v@husky.neu.edu', '7006');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900816', 'Syreeta.f@husky.neu.edu', '7012');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900817', 'Lona.g@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900818', 'Drew.t@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900819', 'Jayna.r@husky.neu.edu', '7017');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900820', 'Tarra.c@husky.neu.edu', '7012');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900821', 'Tegan.d@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900822', 'Armando.a@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900823', 'Wyatt.s@husky.neu.edu', '7013');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900824', 'Aileen.f@husky.neu.edu', '7001');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900825', 'Carlie.r@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900826', 'Marcelina.e@husky.neu.edu', '7000');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900827', 'Julissa.d@husky.neu.edu', '7000');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900828', 'Tracy.s@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900829', 'Tarra.c@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900830', 'Tegan.d@husky.neu.edu', '7007');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900831', 'Armando.a@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900832', 'Wyatt.s@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900833', 'Daina.d@husky.neu.edu', '7014');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900834', 'Angelo.c@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900835', 'Arthur.x@husky.neu.edu', '7009');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900836', 'Leighann.d@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900837', 'Aileen.f@husky.neu.edu', '7016');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900838', 'Carlie.r@husky.neu.edu', '7009');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900839', 'Marcelina.e@husky.neu.edu', '7005');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900840', 'Julissa.d@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900841', 'Tracy.s@husky.neu.edu', '7014');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900842', 'Jade.c@husky.neu.edu', '7014');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900843', 'Ivory.v@husky.neu.edu', '7010');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900844', 'Spencer.b@husky.neu.edu', '7004');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900845', 'Classie.n@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900846', 'Clarissa.h@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900847', 'Isaiah.g@husky.neu.edu', '7006');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900848', 'Merissa.t@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900849', 'Shaina.y@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900850', 'Carmella.r@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900851', 'Chieko.d@husky.neu.edu', '7017');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900852', 'Johnna.e@husky.neu.edu', '7011');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900853', 'Gregoria.w@husky.neu.edu', '7001');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900854', 'reema.d@husky.ney.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900855', 'archana.c@husky.neu.edu', '7008');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900856', 'vandhana.t@husky.neu.edu', '7000');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900857', 'john.k@husky.neu.edu', '7011');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900858', 'charles.c@husky.neu.edu', '7016');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900859', 'tim.c@husky.neu.edu', '7013');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900860', 'linda.r@husky.neu.edu', '7014');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900861', 'cameron.p@husky.neu.edu', '7008');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900862', 'kumar.s@husky.neu.edu', '7018');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900863', 'kevin.s@husky.neu.edu', '7005');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900864', 'mary.g@husky.neu.edu', '7010');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900865', 'tess.b@husky.neu.edu', '7008');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900866', 'catherine.t@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900867', 'vimal.n@husky.neu.edu', '7011');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900868', 'Johana.a@husky.neu.edu', '7000');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900869', 'Sherri.s@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900870', 'Michaela.d@husky.neu.edu', '7016');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900871', 'Song.c@husky.neu.edu', '7010');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900872', 'Ileana.x@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900873', 'May.d@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900874', 'Anne.f@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900875', 'Sharolyn.r@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900876', 'Marissa.e@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900877', 'Syreeta.f@husky.neu.edu', '7016');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900878', 'linda.r@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900879', 'cameron.p@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900880', 'kumar.s@husky.neu.edu', '7001');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900881', 'kevin.s@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900882', 'mary.g@husky.neu.edu', '7006');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900883', 'tess.b@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900884', 'catherine.t@husky.neu.edu', '7012');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900885', 'vimal.n@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900886', 'Johana.a@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900887', 'Sherri.s@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900888', 'Michaela.d@husky.neu.edu', '7011');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900889', 'Song.c@husky.neu.edu', '7008');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900890', 'Ileana.x@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900891', 'May.d@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900892', 'Anne.f@husky.neu.edu', '7018');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900893', 'Sharolyn.r@husky.neu.edu', '7012');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900894', 'Marissa.e@husky.neu.edu', '7007');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900895', 'Kimbery.j@husky.neu.edu', '7000');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900896', 'Myrna.h@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900897', 'tess.b@husky.neu.edu', '7010');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900898', 'Johana.a@husky.neu.edu', '7007');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900899', 'Michaela.d@husky.neu.edu', '7000');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900900', 'Song.c@husky.neu.edu', '7010');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900901', 'May.d@husky.neu.edu', '7017');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900902', 'Anne.f@husky.neu.edu', '7007');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900903', 'Marissa.e@husky.neu.edu', '7013');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900904', 'Ursula.s@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900905', 'Johnnie.b@husky.neu.edu', '7018');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900906', 'Graig.y@husky.neu.edu', '7008');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900907', 'Alyson.r@husky.neu.edu', '7007');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900908', 'Carl.d@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900909', 'Diane.w@husky.neu.edu', '7006');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900910', 'Mina.v@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900911', 'Chiquita.g@husky.neu.edu', '7008');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900912', 'Verlene.y@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900913', 'Marlon.u@husky.neu.edu', '7018');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900914', 'Micha.f@husky.neu.edu', '7010');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900915', 'Alysa.o@husky.neu.edu', '7006');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900916', 'Linette.k@husky.neu.edu', '7012');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900917', 'Myrna.h@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900918', 'Katina.b@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900919', 'Syreeta.f@husky.neu.edu', '7017');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900920', 'linda.r@husky.neu.edu', '7012');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900921', 'cameron.p@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900922', 'kumar.s@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900923', 'kevin.s@husky.neu.edu', '7013');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900924', 'mary.g@husky.neu.edu', '7001');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900925', 'tess.b@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900926', 'catherine.t@husky.neu.edu', '7000');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900927', 'vimal.n@husky.neu.edu', '7000');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900928', 'Johana.a@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900929', 'Sherri.s@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900930', 'Michaela.d@husky.neu.edu', '7007');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900931', 'Song.c@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900932', 'Ileana.x@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900933', 'May.d@husky.neu.edu', '7014');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900934', 'Anne.f@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900935', 'Sharolyn.r@husky.neu.edu', '7009');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900936', 'Marissa.e@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900937', 'Kimbery.j@husky.neu.edu', '7016');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900938', 'Myrna.h@husky.neu.edu', '7009');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900939', 'Rochelle.n@husky.neu.edu', '7005');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900940', 'Katina.b@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900941', 'Jessika.v@husky.neu.edu', '7014');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900942', 'Syreeta.f@husky.neu.edu', '7014');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900943', 'Lona.g@husky.neu.edu', '7010');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900944', 'Drew.t@husky.neu.edu', '7004');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900945', 'Jayna.r@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900946', 'Tarra.c@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900947', 'Tegan.d@husky.neu.edu', '7006');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900948', 'Armando.a@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900949', 'Wyatt.s@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900950', 'Daina.d@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900951', 'Angelo.c@husky.neu.edu', '7017');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900952', 'Arthur.x@husky.neu.edu', '7011');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900953', 'Leighann.d@husky.neu.edu', '7001');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900954', 'Aileen.f@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900955', 'Carlie.r@husky.neu.edu', '7008');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900956', 'Marcelina.e@husky.neu.edu', '7000');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900957', 'Julissa.d@husky.neu.edu', '7011');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900958', 'Tracy.s@husky.neu.edu', '7016');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900959', 'Tarra.c@husky.neu.edu', '7013');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900960', 'Tegan.d@husky.neu.edu', '7014');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900961', 'Armando.a@husky.neu.edu', '7008');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900962', 'Wyatt.s@husky.neu.edu', '7018');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900963', 'Daina.d@husky.neu.edu', '7005');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900964', 'Angelo.c@husky.neu.edu', '7010');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900965', 'Arthur.x@husky.neu.edu', '7008');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900966', 'Leighann.d@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900967', 'Aileen.f@husky.neu.edu', '7011');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900968', 'Carlie.r@husky.neu.edu', '7000');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900969', 'Marcelina.e@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900970', 'Julissa.d@husky.neu.edu', '7016');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900971', 'Tracy.s@husky.neu.edu', '7010');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900972', 'Jade.c@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900973', 'Ivory.v@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900974', 'Spencer.b@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900975', 'Classie.n@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900976', 'Clarissa.h@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900977', 'Isaiah.g@husky.neu.edu', '7016');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900978', 'Merissa.t@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900979', 'Shaina.y@husky.neu.edu', '7019');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900980', 'Carmella.r@husky.neu.edu', '7001');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900981', 'Chieko.d@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900982', 'Johnna.e@husky.neu.edu', '7006');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900983', 'Gregoria.w@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900984', 'reema.d@husky.ney.edu', '7012');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900985', 'archana.c@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900986', 'vandhana.t@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900987', 'john.k@husky.neu.edu', '7002');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900988', 'charles.c@husky.neu.edu', '7011');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900989', 'tim.c@husky.neu.edu', '7008');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900990', 'linda.r@husky.neu.edu', '7003');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900991', 'cameron.p@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900992', 'kumar.s@husky.neu.edu', '7018');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900993', 'kevin.s@husky.neu.edu', '7012');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900994', 'mary.g@husky.neu.edu', '7007');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900995', 'tess.b@husky.neu.edu', '7000');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900996', 'catherine.t@husky.neu.edu', '7015');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900997', 'vimal.n@husky.neu.edu', '7010');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900998', 'Johana.a@husky.neu.edu', '7007');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('900999', 'Sherri.s@husky.neu.edu', '7000');
            INSERT INTO witricity.Alert_Log (Log_ID, User_ID, Alert_ID) VALUES ('901000', 'Michaela.d@husky.neu.edu', '7010');
             
            select 'After inserting data into Alert_Log table.';
             
             COMMIT;
            
        END IF; 
        END IF;          
END 
$$



DELIMITER $$  

CREATE PROCEDURE witricity_project_proc(pdata_insert varchar(2),pdata varchar(2000),ptable_name varchar(50))

   BEGIN
      -- Declaration Section
      --
	  DECLARE l_error_message varchar(200) default NULL;
      DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SELECT 'SQLException encountered in Main Procedure' into l_error_message; 
	  --
      BEGIN
        select l_error_message;
		        		
        INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES(ptable_name,pdata,l_error_message,SYSDATE());
      END;
     IF pdata_insert NOT IN ('Y','N') THEN
         --
         SIGNAL SQLSTATE '45000'
         SET MESSAGE_TEXT = 'Invalid value passed to first parameter.(Valid value:Y/N)';
		 SET l_error_message = 'Invalid value passed to first parameter.(Valid value:Y/N)';
             INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES(ptable_name,pdata,'Invalid value passed to first parameter.(Valid value:Y/N)',SYSDATE());
             commit; 
             --
      ELSE
      
       IF pdata_insert = 'Y' and ((trim(pdata) IS NULL OR  trim(ptable_name) IS NULL) or (pdata IS NULL OR  ptable_name IS NULL)) THEN
	     --
		 SIGNAL SQLSTATE '45002'
         SET MESSAGE_TEXT = '2nd and 3rd parameter is mandatory if first parameter is Y';
		 SET l_error_message = '2nd and 3rd parameter is mandatory if first parameter is Y';
             INSERT INTO error_data(table_name ,Errored_Data ,Error_Message,Trans_Date )
             VALUES(ptable_name,pdata,'2nd and 3rd parameter is mandatory if first parameter is Y',SYSDATE());
             commit; 
		ELSE	 
       --  ELSEIF ((pdata_insert = 'Y' and (trim(pdata) IS NOT NULL OR  trim(ptable_name) IS NOT NULL ))
         --       OR (pdata_insert = 'N'))	THEN
          --	
          IF pdata_insert = 'Y' THEN
            -- 
             IF UPPER(ptable_name) = 'ALERT_LOG' THEN
                --
                CALL alert_log_data_insert(pdata_insert,pdata,ptable_name);
                --
             ELSEIF upper(ptable_name) = 'ALERT_MASTER' THEN
                --
                CALL Alert_Master_data_insert(pdata_insert,pdata,ptable_name);
                --
             ELSEIF upper(ptable_name) = 'BUILDING_MASTER' THEN
                --
                CALL Building_Master_data_insert(pdata_insert,pdata,ptable_name);
                --
             ELSEIF upper(ptable_name) = 'CONFIG' THEN
                 --
                CALL Config_data_insert(pdata_insert,pdata,ptable_name);
                --
             ELSEIF upper(ptable_name) = 'CONFIG_DAY_MAPPING' THEN
                 --
                CALL Config_day_mapping_data_insert(pdata_insert,pdata,ptable_name);
                --
             ELSEIF upper(ptable_name) = 'CONFIG_DETAIL' THEN
                 --
                CALL Config_Detail_data_insert(pdata_insert,pdata,ptable_name);
                --
             ELSEIF upper(ptable_name) = 'CONFIG_EVENT_MAPPING' THEN
                 --
                CALL Config_event_mapping_data_insert(pdata_insert,pdata,ptable_name);
                --
             ELSEIF upper(ptable_name) = 'CONFIG_LOCATION_MAPPING' THEN
                 --
                CALL Config_location_mapping_data_insert(pdata_insert,pdata,ptable_name);
                --
             ELSEIF upper(ptable_name) = 'DEVICE_POWER_CONSUMPTION' THEN
                 --
                CALL device_power_consumption_data_insert(pdata_insert,pdata,ptable_name);
                --
             ELSEIF upper(ptable_name) = 'DEVICE_POWER_MAPPING' THEN
                 --
                CALL Device_Power_Mapping_data_insert(pdata_insert,pdata,ptable_name);
                --
             ELSEIF upper(ptable_name) = 'DEVICE_USER_MAPPING' THEN
                 --
                CALL device_user_mapping_data_insert(pdata_insert,pdata,ptable_name);
                --
             ELSEIF upper(ptable_name) = 'EVENT_MASTER' THEN
                 --
                CALL Event_Master_data_insert(pdata_insert,pdata,ptable_name);
                --
             ELSEIF upper(ptable_name) = 'GPS_LOCATION_MAPPING' THEN
                 --
                CALL GPS_Location_Mapping_data_insert(pdata_insert,pdata,ptable_name);
                --
             ELSEIF upper(ptable_name) = 'Location_24_7' THEN
                 --
                CALL Location_24_7_data_insert(pdata_insert,pdata,ptable_name);
                --
             ELSEIF upper(ptable_name) = 'LOCATION_MASTER' THEN
                 --
                CALL Location_master_data_insert(pdata_insert,pdata,ptable_name);
                --
             ELSEIF upper(ptable_name) = 'LOGIN' THEN
                 --
                CALL Login_data_insert(pdata_insert,pdata,ptable_name);
                --
             ELSEIF upper(ptable_name) = 'LOW_LOAD_DAYS' THEN
                 --
                CALL low_load_days_data_insert(pdata_insert,pdata,ptable_name);
                --
             ELSEIF upper(ptable_name) = 'POWER_BOOSTER_INFO' THEN
                 --
                CALL Power_Booster_Info_data_insert(pdata_insert,pdata,ptable_name);
                --
             ELSEIF upper(ptable_name) = 'POWER_BOOSTER_MASTER' THEN
                 --
                CALL Power_Booster_Master_data_insert(pdata_insert,pdata,ptable_name);
                --
             ELSEIF upper(ptable_name) = 'ROOM_MASTER' THEN
                 --
                CALL Room_Master_data_insert(pdata_insert,pdata,ptable_name);
                --
               --
             ELSEIF upper(ptable_name) = 'TRANSMITTER_MASTER' THEN
                 --
                CALL Transmitter_Master_data_insert(pdata_insert,pdata,ptable_name);
                --
             ELSEIF upper(ptable_name) = 'TRANSMITTER_TYPE_INFO' THEN
                 --
                CALL Transmitter_Type_Info_data_insert(pdata_insert,pdata,ptable_name);
                --
             ELSEIF upper(ptable_name) = 'UNIVERSITY_HOLIDAYS' THEN
                 --
                CALL university_holidays_data_insert(pdata_insert,pdata,ptable_name);
                --
             ELSEIF upper(ptable_name) = 'UNIVERSITY_OWN_DEVICES' THEN
                 --
                CALL University_own_devices_data_insert(pdata_insert,pdata,ptable_name);
                --
             ELSEIF upper(ptable_name) = 'UNIVERSITY_SHUTTLE_CONFIG' THEN
                 --
                CALL University_shuttle_Config_data_insert(pdata_insert,pdata,ptable_name);
                --
             ELSEIF upper(ptable_name) = 'USERTYPE_VALIDITY' THEN
                 --
                CALL UserType_Validity_data_insert(pdata_insert,pdata,ptable_name);
                --
             ELSEIF upper(ptable_name) = 'USER_LOCATION' THEN
                 --
                CALL User_Location_data_insert(pdata_insert,pdata,ptable_name);
                --
             ELSEIF upper(ptable_name) = 'USER_PRIVILEGES' THEN
                 --
                CALL User_privileges_data_insert(pdata_insert,pdata,ptable_name);
                --
             END IF;
             --        
        
         --
       ELSE  -- Insert the bulk data using insert statements pdata_insert = N
            --
            -- 
            --
			
			CALL Config_data_insert(pdata_insert,pdata,ptable_name);
			--
			CALL Building_Master_data_insert(pdata_insert,pdata,ptable_name);
            --
			CALL Transmitter_Type_Info_data_insert(pdata_insert,pdata,ptable_name);
            --
			CALL Room_Master_data_insert(pdata_insert,pdata,ptable_name);
            --
			CALL UserType_Validity_data_insert(pdata_insert,pdata,ptable_name);
            --
			CALL Alert_Master_data_insert(pdata_insert,pdata,ptable_name);
            --
			CALL User_privileges_data_insert(pdata_insert,pdata,ptable_name);
			--
			CALL Login_data_insert(pdata_insert,pdata,ptable_name);
            --
			CALL User_Location_data_insert(pdata_insert,pdata,ptable_name);
            -- 
			CALL Location_master_data_insert(pdata_insert,pdata,ptable_name);
            --
			CALL Config_location_mapping_data_insert(pdata_insert,pdata,ptable_name);
            --
			CALL Config_Detail_data_insert(pdata_insert,pdata,ptable_name);
            --
			CALL Event_Master_data_insert(pdata_insert,pdata,ptable_name);
            --
			CALL Config_event_mapping_data_insert(pdata_insert,pdata,ptable_name);
            --
			CALL Config_day_mapping_data_insert(pdata_insert,pdata,ptable_name);
            --
			CALL Location_24_7_data_insert(pdata_insert,pdata,ptable_name);
            --
			CALL GPS_Location_Mapping_data_insert(pdata_insert,pdata,ptable_name);
            --
			CALL Power_Booster_Info_data_insert(pdata_insert,pdata,ptable_name);
            --
			CALL Power_Booster_Master_data_insert(pdata_insert,pdata,ptable_name);
            --
			CALL Transmitter_Master_data_insert(pdata_insert,pdata,ptable_name);
            --
			CALL University_shuttle_Config_data_insert(pdata_insert,pdata,ptable_name);
            --
			CALL University_own_devices_data_insert(pdata_insert,pdata,ptable_name);
            --
			CALL low_load_days_data_insert(pdata_insert,pdata,ptable_name);
            --
			CALL university_holidays_data_insert(pdata_insert,pdata,ptable_name);
            --
			CALL Device_Power_Mapping_data_insert(pdata_insert,pdata,ptable_name);
            --
			CALL device_power_consumption_data_insert(pdata_insert,pdata,ptable_name);
            --
			CALL device_user_mapping_data_insert(pdata_insert,pdata,ptable_name);
            --
            CALL alert_log_data_insert(pdata_insert,pdata,ptable_name);
            --            
                
        END IF; 
        --
     END IF; 
     -- 
    END IF; -- pdata_insert = Y/N  
END 
$$
