/***
GEDEON NIYONKURU DATABASE
**/

USE master;

IF DB_ID('BACK_UP') IS  NULL CREATE DATABASE BACK_UP;
GO

-- Drop database
IF DB_ID('GED70362018') IS NOT NULL DROP DATABASE GED70362018;

-- If database could not be created due to open connections, abort
IF @@ERROR = 3702 
   RAISERROR('Database cannot be dropped because there are still open connections.', 127, 127) WITH NOWAIT, LOG;

-- Create database
CREATE DATABASE GED70362018;
GO

USE GED70362018;
SET NOCOUNT on;
GO

/*==============================================================*/
/* Table: Member                                              */
/*==============================================================*/
create table Member (
   id              INT IDENTITY PRIMARY KEY,
  username        NVARCHAR(20) NOT NULL,
  fname           NVARCHAR(20) NOT NULL,
  lname           NVARCHAR(20) NOT NULL,
  email           VARCHAR(50) NOT NULL UNIQUE,
  profile_pic     TEXT NOT NULL,
  pass            TEXT NOT NULL,
  phone           VARCHAR(20) NOT NULL,
  birthdate       DATETIME  NOT NULL,
  organization    VARCHAR(3) NOT NULL,
  statu          INT,
  functio        INT,
  marital_status  VARCHAR(15) NULL,
  years_of_stay   TEXT NULL,
  interest        TEXT NULL,
  quote           TEXT NULL
)
/* I will be constantly checking the availability of email and usernames while registering users **/
CREATE INDEX Member_username ON Member(username);
CREATE INDEX Member_email  ON Member(email);

/****************************************************************************
Creating an insert trigger the Member table
***************************************************************************/
IF object_id('BACK_UP.dbo.MemberBackup', 'U') is  null

CREATE TABLE BACK_UP.dbo.MemberBackup(
 id              INT ,
  username        NVARCHAR(20),
  fname           NVARCHAR(20) ,
  lname           NVARCHAR(20) ,
  email           VARCHAR(50) ,
  profile_pic     TEXT ,
  pass            TEXT,
  phone           VARCHAR(20),
  birthdate       DATETIME,
  organization    VARCHAR(3),
  audit_activity VARCHAR(200),
  audit_time DATETIME
)
GO

IF EXISTS (select * from sysobjects where name like '%insertMemberTrigger%')
DROP TRIGGER insertMemberTrigger
go
CREATE TRIGGER insertMemberTrigger
ON Member FOR INSERT
AS 
	  declare @id              INT ;
	  declare @username        NVARCHAR(20);
	  declare @fname           NVARCHAR(20);
	  declare @lname           NVARCHAR(20);
	  declare @email           VARCHAR(50);
	  declare @profile_pic     VARCHAR(100) ;
	  declare @pass            VARCHAR(100) ;
	  declare @phone           VARCHAR(20) ;
	  declare @birthdate       DATETIME ;
	  declare @organization    VARCHAR(3);
	  declare @activity		   VARCHAR(200);
	  declare @audit_time     DATETIME
	

	  select @id             = m.id FROM BACK_UP.dbo.MemberBackup m;
	  select @username       = m.username FROM BACK_UP.dbo.MemberBackup m;
	  select @fname          = m.fname FROM BACK_UP.dbo.MemberBackup m;
	  select @lname          = m.lname FROM BACK_UP.dbo.MemberBackup m;
	  select @email          = m.email FROM BACK_UP.dbo.MemberBackup m;
	  select @profile_pic    = m.profile_pic FROM BACK_UP.dbo.MemberBackup m;
	  select @pass           = m.pass FROM BACK_UP.dbo.MemberBackup m;
	  select @phone          = m.phone FROM BACK_UP.dbo.MemberBackup m;
	  select @birthdate      = m.birthdate FROM BACK_UP.dbo.MemberBackup m;
	  select @organization   = m.organization FROM BACK_UP.dbo.MemberBackup m;

	  set @activity = 'Record inserted in Member Table';
	  set @audit_time     = CURRENT_TIMESTAMP; 

	INSERT INTO  BACK_UP.dbo.MemberBackup(username, fname, lname, email, profile_pic, pass, phone, birthdate, organization, audit_activity, audit_time)
	VALUES( @username, @fname, @lname, @email, @profile_pic, @pass, @phone, @birthdate, @organization, @activity, @audit_time)

	PRINT 'After insert trigger on student table'
GO

INSERT INTO Member(username, fname, lname, email, profile_pic, pass, phone, birthdate, organization)
	VALUES('username', 'fname', 'lname', 'email@gmail.com', 'profile_pic', 'pass', '0493434434', '22-Jul-1996', 'gh') ;

Delete from Member where username = 'username';
GO

/****************************************************************************
Creating an UPDATE trigger the Member table
***************************************************************************/

IF EXISTS (select * from sysobjects where name like '%updateMemberTrigger%')
DROP TRIGGER updateMemberTrigger
go
CREATE TRIGGER updateMemberTrigger
ON Member FOR UPDATE
AS 
	  declare @id              INT;
	  declare @username        NVARCHAR(20);
	  declare @fname           NVARCHAR(20);
	  declare @lname           NVARCHAR(20);
	  declare @email           VARCHAR(50);
	  declare @profile_pic     VARCHAR(100) ;
	  declare @pass            VARCHAR(100) ;
	  declare @phone           VARCHAR(20) ;
	  declare @birthdate       DATETIME ;
	  declare @organization    VARCHAR(3);
	  declare @activity		   VARCHAR(200);
	  declare @audit_time     DATETIME
	

	  select @id             = m.id FROM BACK_UP.dbo.MemberBackup m;
	  select @username       = m.username FROM BACK_UP.dbo.MemberBackup m;
	  select @fname          = m.fname FROM BACK_UP.dbo.MemberBackup m;
	  select @lname          = m.lname FROM BACK_UP.dbo.MemberBackup m;
	  select @email          = m.email FROM BACK_UP.dbo.MemberBackup m;
	  select @profile_pic    = m.profile_pic FROM BACK_UP.dbo.MemberBackup m;
	  select @pass           = m.pass FROM BACK_UP.dbo.MemberBackup m;
	  select @phone          = m.phone FROM BACK_UP.dbo.MemberBackup m;
	  select @birthdate      = m.birthdate FROM BACK_UP.dbo.MemberBackup m;
	  select @organization   = m.organization FROM BACK_UP.dbo.MemberBackup m;

	  if update(profile_pic)	
		set @activity = 'Updated Member profile picture';
	  if update(phone)	
			set @activity = 'Updated Member phone number';
	  if update(birthdate)	
			set @activity = 'Updated Member Date of Birth';

	  set @audit_time     = CURRENT_TIMESTAMP; 

	  EXEC msdb.dbo.sp_send_dbmail
         @profile_name =  'mail profile',
         @recipients = 'dsampah@ashesi.edu.gh',
         @subject = 'Updated the member table',
         @body = 'Just updated the member table'

	INSERT INTO  BACK_UP.dbo.MemberBackup(username, fname, lname, email, profile_pic, pass, phone, birthdate, organization, audit_activity, audit_time)
	VALUES( @username, @fname, @lname, @email, @profile_pic, @pass, @phone, @birthdate, @organization, @activity, @audit_time)

	PRINT 'After Update trigger on Member table'
GO

  UPDATE Member set phone = '02154886566' ;
GO

/****************************************************************************
Creating an Delete trigger the Member table
***************************************************************************/

IF EXISTS (select * from sysobjects where name like '%deleteMemberTrigger%')
DROP TRIGGER deleteMemberTrigger
go
CREATE TRIGGER deleteMemberTrigger
ON Member FOR DELETE
AS 
	  declare @id              INT;
	  declare @username        NVARCHAR(20);
	  declare @fname           NVARCHAR(20);
	  declare @lname           NVARCHAR(20);
	  declare @email           VARCHAR(50);
	  declare @profile_pic     VARCHAR(100) ;
	  declare @pass            VARCHAR(100) ;
	  declare @phone           VARCHAR(20) ;
	  declare @birthdate       DATETIME ;
	  declare @organization    VARCHAR(3);
	  declare @activity		   VARCHAR(200);
	  declare @audit_time     DATETIME
	

	  select @id             = m.id FROM BACK_UP.dbo.MemberBackup m;
	  select @username       = m.username FROM BACK_UP.dbo.MemberBackup m;
	  select @fname          = m.fname FROM BACK_UP.dbo.MemberBackup m;
	  select @lname          = m.lname FROM BACK_UP.dbo.MemberBackup m;
	  select @email          = m.email FROM BACK_UP.dbo.MemberBackup m;
	  select @profile_pic    = m.profile_pic FROM BACK_UP.dbo.MemberBackup m;
	  select @pass           = m.pass FROM BACK_UP.dbo.MemberBackup m;
	  select @phone          = m.phone FROM BACK_UP.dbo.MemberBackup m;
	  select @birthdate      = m.birthdate FROM BACK_UP.dbo.MemberBackup m;
	  select @organization   = m.organization FROM BACK_UP.dbo.MemberBackup m;

	  set @activity = 'Record deleted in Member Table';
	  set @audit_time     = CURRENT_TIMESTAMP; 

	INSERT INTO  BACK_UP.dbo.MemberBackup(username, fname, lname, email, profile_pic, pass, phone, birthdate, organization, audit_activity, audit_time)
	VALUES( @username, @fname, @lname, @email, @profile_pic, @pass, @phone, @birthdate, @organization, @activity, @audit_time)

	EXEC msdb.dbo.sp_send_dbmail
         @profile_name =  'mail profile',
         @recipients = 'dsampah@ashesi.edu.gh',
         @subject = 'Deleted the member table',
         @body = 'Just Deleted the member table'

	PRINT 'After insert trigger on student table'
GO

INSERT INTO Member(username, fname, lname, email, profile_pic, pass, phone, birthdate, organization)
	VALUES('toDelete', 'fname', 'lname', 'email@gmail.com', 'profile_pic', 'pass', '0493434434', '22-Jul-1996', 'gh') ;

Delete from Member where username = 'toDelete';
GO


/*==============================================================*/
/* Table: Join Requests                                            */
/*==============================================================*/
create table join_requests (
  email           NVARCHAR(50)  UNIQUE,
  first_name      NVARCHAR(30) NOT NULL,
  last_name       NVARCHAR(30) NOT NULL,
  phoneNumber     VARCHAR(20) NOT NULL,
  country         VARCHAR(3) NOT NULL,
  message		  VARCHAR(200) NULL,

)

/****************************************************************************
Creating an insert trigger the Join request table
***************************************************************************/
IF object_id('BACK_UP.dbo.RequestsBackup', 'U') is  null

CREATE TABLE BACK_UP.dbo.RequestsBackup(
 email           NVARCHAR(50),
  first_name      NVARCHAR(30),
  last_name       NVARCHAR(30),
  phoneNumber     VARCHAR(20),
  country         VARCHAR(3),
  message		  VARCHAR(200),
  audit_activity  VARCHAR(200),
  audit_time      DATETIME
)
GO

IF EXISTS (select * from sysobjects where name like '%insertRequestsTrigger%')
DROP TRIGGER insertRequestsTrigger
go
CREATE TRIGGER insertRequestsTrigger
ON join_requests FOR INSERT
AS 
	  declare @email              NVARCHAR(50) ;
	  declare @first_name        NVARCHAR(30);
	  declare @last_name            NVARCHAR(30);
	  declare @phoneNumber           NVARCHAR(20);
	  declare @country          VARCHAR(3);
	  declare @message	   VARCHAR(200);
	  declare @activity		   VARCHAR(200);
	  declare @audit_time     DATETIME
	

	  select @email             = m.email FROM BACK_UP.dbo.RequestsBackup m;
	  select @first_name       = m.first_name FROM BACK_UP.dbo.RequestsBackup m;
	  select @last_name          = m.last_name FROM BACK_UP.dbo.RequestsBackup m;
	  select @phoneNumber           = m.phoneNumber FROM BACK_UP.dbo.RequestsBackup m;
	  select @country         = m.country FROM BACK_UP.dbo.RequestsBackup m;
	  select @message         = m.message FROM BACK_UP.dbo.RequestsBackup m;
	  

	  set @activity = 'Record inserted in Member Table';
	  set @audit_time     = CURRENT_TIMESTAMP; 

	INSERT INTO  BACK_UP.dbo.RequestsBackup(email, first_name, last_name, phoneNumber, country, audit_activity, audit_time)
	VALUES( @email, @first_name, @last_name, @phoneNumber, @country, @activity, @audit_time)

	PRINT 'After insert trigger on Join Request table'
GO


/***************************************************************************************
Creating triggers for update
***************************************************************************************/
IF EXISTS (select * from sysobjects where name like '%updateRequestsTrigger%')
DROP TRIGGER updateRequestsTrigger
go
CREATE TRIGGER updateRequestsTrigger
ON join_requests FOR UPDATE
AS 
	  declare @email              NVARCHAR(50) ;
	  declare @first_name        NVARCHAR(30);
	  declare @last_name            NVARCHAR(30);
	  declare @phoneNumber           NVARCHAR(20);
	  declare @country          VARCHAR(3);
	  declare @message	   VARCHAR(200);
	  declare @activity		   VARCHAR(200);
	  declare @audit_time     DATETIME
	

	  select @email             = m.email FROM BACK_UP.dbo.RequestsBackup m;
	  select @first_name       = m.first_name FROM BACK_UP.dbo.RequestsBackup m;
	  select @last_name          = m.last_name FROM BACK_UP.dbo.RequestsBackup m;
	  select @phoneNumber           = m.phoneNumber FROM BACK_UP.dbo.RequestsBackup m;
	  select @country         = m.country FROM BACK_UP.dbo.RequestsBackup m;
	  select @message         = m.message FROM BACK_UP.dbo.RequestsBackup m;
	  
	  if update(first_name)	
		set @activity = 'Updated Student Firstname';
	if update(last_name)	
		set @activity = 'Updated Student Lastname';

	  set @audit_time     = CURRENT_TIMESTAMP; 

	INSERT INTO  BACK_UP.dbo.RequestsBackup(email, first_name, last_name, phoneNumber, country,  audit_activity, audit_time)
	VALUES( @email, @first_name, @last_name, @phoneNumber, @country, @activity, @audit_time)

	EXEC msdb.dbo.sp_send_dbmail
         @profile_name =  'mail profile',
         @recipients = 'dsampah@ashesi.edu.gh',
         @subject = 'Updated the join_request table',
         @body = 'Just updated the join_request table'

	PRINT 'After update trigger on Join Request table'
GO


/******************************************************************
Delete trigger for join requests
*******************************************************************/
/***************************************************************************************
Creating triggers for update
***************************************************************************************/
IF EXISTS (select * from sysobjects where name like '%deleteRequestsTrigger%')
DROP TRIGGER updateRequestsTrigger
go
CREATE TRIGGER deleteRequestsTrigger
ON join_requests FOR UPDATE
AS 
	  declare @email              NVARCHAR(50) ;
	  declare @first_name        NVARCHAR(30);
	  declare @last_name            NVARCHAR(30);
	  declare @phoneNumber           NVARCHAR(20);
	  declare @country          VARCHAR(3);
	  declare @message	   VARCHAR(200);
	  declare @activity		   VARCHAR(200);
	  declare @audit_time     DATETIME
	

	  select @email           = m.email FROM BACK_UP.dbo.RequestsBackup m;
	  select @first_name      = m.first_name FROM BACK_UP.dbo.RequestsBackup m;
	  select @last_name       = m.last_name FROM BACK_UP.dbo.RequestsBackup m;
	  select @phoneNumber     = m.phoneNumber FROM BACK_UP.dbo.RequestsBackup m;
	  select @country         = m.country FROM BACK_UP.dbo.RequestsBackup m;
	  select @message         = m.message FROM BACK_UP.dbo.RequestsBackup m;
	  
	  
	  set @activity = 'Deleted a request to join the diaspora platform ';
	  set @audit_time     = CURRENT_TIMESTAMP; 

	INSERT INTO  BACK_UP.dbo.RequestsBackup(email, first_name, last_name, phoneNumber, country,  audit_activity, audit_time)
	VALUES( @email, @first_name, @last_name, @phoneNumber, @country, @activity, @audit_time)

	EXEC msdb.dbo.sp_send_dbmail
         @profile_name =  'mail profile',
         @recipients = 'dsampah@ashesi.edu.gh',
         @subject = 'Deleted the join_request table',
         @body = 'Just Deleted the join_request table'

	PRINT 'After delete trigger on Join Request table'
GO


/*==============================================================*/
/* Table: "Diasporas"                                               */
/*==============================================================*/
create table Diasporas (
   Id                   int          identity PRIMARY KEY,
   Organisation         varchar(15)  not null,
   leaders_email        nvarchar(50) not null UNIQUE,
   leaders_phone        varchar(12)  not null,
   committe_id          INT      not null,
)


/****************************************************************************
Creating an insert trigger the Member table
***************************************************************************/
IF object_id('BACK_UP.dbo.DiasporaBackup', 'U') is  null

CREATE TABLE BACK_UP.dbo.DiasporaBackup(
  id                   INT ,
  Organisation         varchar(15),
  leaders_email        nvarchar(50),
  leaders_phone        varchar(12),
  committe_id          INT,
  audit_activity       VARCHAR(200),
  audit_time           DATETIME
)
GO

IF EXISTS (select * from sysobjects where name like '%insertDiasporaTrigger%')
DROP TRIGGER insertDiasporaTrigger
go
CREATE TRIGGER insertDiasporaTrigger
ON Diasporas FOR INSERT
AS 
	  declare @id              INT ;
	  declare @Organisation        NVARCHAR(20);
	  declare @leaders_email            NVARCHAR(20);
	  declare @leaders_phone           NVARCHAR(20);
	  declare @committe_id           VARCHAR(50);
	  declare @activity		   VARCHAR(200);
	  declare @audit_time     DATETIME
	

	  select @id             = m.id FROM BACK_UP.dbo.DiasporaBackup m;
	  select @Organisation       = m.Organisation FROM BACK_UP.dbo.DiasporaBackup m;
	  select @leaders_email          = m.leaders_email FROM BACK_UP.dbo.DiasporaBackup m;
	  select @leaders_phone           = m.leaders_phone FROM BACK_UP.dbo.DiasporaBackup m;
	  select @committe_id          = m.committe_id FROM BACK_UP.dbo.DiasporaBackup m;
	  

	  set @activity = 'Record inserted in Member Table';
	  set @audit_time     = CURRENT_TIMESTAMP; 

	INSERT INTO  BACK_UP.dbo.DiasporaBackup(Organisation, leaders_email, leaders_phone, committe_id, audit_activity, audit_time)
	VALUES( @Organisation, @leaders_email, @leaders_phone, @committe_id, @activity, @audit_time)

	PRINT 'After insert trigger on Diaspora table'
GO

/****************************************************************************
Creating the update trigger on the diaspora table
****************************************************************************/

IF EXISTS (select * from sysobjects where name like '%updateDiasporaTrigger%')
DROP TRIGGER updateDiasporaTrigger
go
CREATE TRIGGER updateDiasporaTrigger
ON Diasporas FOR UPDATE
AS 
	  declare @id              INT ;
	  declare @Organisation        NVARCHAR(20);
	  declare @leaders_email            NVARCHAR(20);
	  declare @leaders_phone           NVARCHAR(20);
	  declare @committe_id           VARCHAR(50);
	  declare @activity		   VARCHAR(200);
	  declare @audit_time     DATETIME
	

	  select @id                 = m.id FROM BACK_UP.dbo.DiasporaBackup m;
	  select @Organisation       = m.Organisation FROM BACK_UP.dbo.DiasporaBackup m;
	  select @leaders_email      = m.leaders_email FROM BACK_UP.dbo.DiasporaBackup m;
	  select @leaders_phone      = m.leaders_phone FROM BACK_UP.dbo.DiasporaBackup m;
	  select @committe_id        = m.committe_id FROM BACK_UP.dbo.DiasporaBackup m;
	  

	 if update(leaders_phone)	
		set @activity = 'Updated Diaspora leader phone number';
	if update(leaders_email)	
		set @activity = 'Updated Diaspora leader email';

	  set @audit_time = CURRENT_TIMESTAMP; 

	INSERT INTO  BACK_UP.dbo.DiasporaBackup(Organisation, leaders_email, leaders_phone, committe_id, audit_activity, audit_time)
	VALUES( @Organisation, @leaders_email, @leaders_phone, @committe_id, @activity, @audit_time)

	EXEC msdb.dbo.sp_send_dbmail
         @profile_name =  'mail profile',
         @recipients = 'dsampah@ashesi.edu.gh',
         @subject = 'Updated the diaspora table',
         @body = 'Just updated the diaspora table'

	PRINT 'After update trigger on Diaspora table'
GO

/*****************************************************************
CREATING THE DELETE TRIGGER
*******************************************************************/
IF EXISTS (select * from sysobjects where name like '%deleteDiasporaTrigger%')
DROP TRIGGER deleteDiasporaTrigger
go
CREATE TRIGGER deleteDiasporaTrigger
ON Diasporas FOR DELETE
AS 
	  declare @id              INT ;
	  declare @Organisation        NVARCHAR(20);
	  declare @leaders_email            NVARCHAR(20);
	  declare @leaders_phone           NVARCHAR(20);
	  declare @committe_id           VARCHAR(50);
	  declare @activity		   VARCHAR(200);
	  declare @audit_time     DATETIME
	

	  select @id             = m.id FROM BACK_UP.dbo.DiasporaBackup m;
	  select @Organisation       = m.Organisation FROM BACK_UP.dbo.DiasporaBackup m;
	  select @leaders_email          = m.leaders_email FROM BACK_UP.dbo.DiasporaBackup m;
	  select @leaders_phone           = m.leaders_phone FROM BACK_UP.dbo.DiasporaBackup m;
	  select @committe_id          = m.committe_id FROM BACK_UP.dbo.DiasporaBackup m;
	  

	  Set @activity = 'Deleted A diaspora Record';

	  set @audit_time = CURRENT_TIMESTAMP; 

	INSERT INTO  BACK_UP.dbo.DiasporaBackup(Organisation, leaders_email, leaders_phone, committe_id, audit_activity, audit_time)
	VALUES( @Organisation, @leaders_email, @leaders_phone, @committe_id, @activity, @audit_time)

	EXEC msdb.dbo.sp_send_dbmail
         @profile_name =  'mail profile',
         @recipients = 'dsampah@ashesi.edu.gh',
         @subject = 'Deleted the Diaspora table',
         @body = 'Just Deleted the Diaspora table'

	PRINT 'After delete trigger on Diaspora table'
GO

INSERT INTO Diasporas(Organisation, leaders_email, leaders_phone, committe_id)
	VALUES('username', 'email@gmail.com', '5555555', '1') ;
update Diasporas set leaders_email = 'updatedE@gmail.com'
Delete from Diasporas where leaders_email = 'updatedE@gmail.com';

GO


/*==============================================================*/
/* Table: Committe                                             */
/*==============================================================*/
create table Committe (
   commette_id       int                  identity PRIMARY KEY,
   member            int                  not null,
   role              VARCHAR(50)          not null,
   country           VARCHAR(3)           not null, 
   FOREIGN KEY (member) REFERENCES Member(id)
)


/*==============================================================*/
/* Table: Topics                                               */
/*==============================================================*/


create table Topics (
   id               int                         PRIMARY KEY,
   creator          int                         not null,
   link             varchar(100)                        not null,
   title           varchar(100)               null ,
   body             nvarchar(30)                null,
   status           INT                         not null ,
   tags             text                        null ,
   likes            bit                         not null default 0,
   deleted_at       nvarchar(30)                null,
   created_at       timestamp                   not null,
   updated_at       nvarchar(30)                null ,
   FOREIGN KEY (creator) REFERENCES Member(id),
   
)

/** I will be frequently querying the topics **/
CREATE INDEX Topic_tittle  ON Topics(title);

/*==============================================================*/
/* Table: comments                                             */
/*==============================================================*/
create table comments (
   Id               int                  identity PRIMARY KEY,
   user_id          int                  not null,
   topic_id         int                  null,
   content			text                 null,
   likes            int                  null,
   deleted_at       nvarchar(30)                null,
   created_at       timestamp                   not null,
   updated_at       nvarchar(30)                null ,
   FOREIGN KEY (user_id) REFERENCES Member(id),
   FOREIGN KEY (topic_id) REFERENCES Topics(id)
)


/*==============================================================*/
/* Table: Private_messages                                            */
/*==============================================================*/
create table private_messages (
   sender_id            int                  not null,
   receiver_id          int                  not null,
   seen      			INT                  null, 
   date					timestamp            not null,
   PRIMARY KEY ( sender_id,receiver_id, date)
)


/*==============================================================*/
/* Table: planned_activities                                            */
/*==============================================================*/
create table planned_activities (
   event_name       NVARCHAR(60)         PRIMARY KEY,
   coordinator      NVARCHAR(60)           not null,
   place            NVARCHAR(50)         null,
   time 			DATE            null,
)

/** I will be constantly performing queries to check places of events **/
CREATE INDEX Event_place  ON planned_activities(place);


/*************************************************************************
Creating triggerss for planned activities 
***************************************************************************/
/****************************************************************************
Creating an insert trigger the Member table
***************************************************************************/


IF object_id('BACK_UP.dbo.ActivityBackup', 'U') is  null
CREATE TABLE BACK_UP.dbo.ActivityBackup(
  event_name       NVARCHAR(60) ,
  coordinator      NVARCHAR(60) ,
  place            NVARCHAR(50) ,
  time 			   DATE    ,
  audit_activity       VARCHAR(200),
  audit_time           DATETIME
)
GO



IF EXISTS (select * from sysobjects where name like '%insertActivityTrigger%')
DROP TRIGGER insertActivityTrigger
go
CREATE TRIGGER insertActivityTrigger
ON planned_activities FOR INSERT
AS 
	  declare @event_name       NVARCHAR(60) ;
	  declare @coordinator      NVARCHAR(60) ;
      declare @place            NVARCHAR(50) ;
      declare @time 			   DATE;
	  declare @activity		   VARCHAR(200);
	  declare @audit_time     DATETIME
	

	  select @event_name       = m.event_name FROM BACK_UP.dbo.ActivityBackup m;
	  select @coordinator      = m.coordinator FROM BACK_UP.dbo.ActivityBackup m;
	  select @place            = m.place FROM BACK_UP.dbo.ActivityBackup m;
	  select @activity         = m.audit_activity FROM BACK_UP.dbo.ActivityBackup m;
	  

	  set @activity = 'Record inserted in the activity Table';
	  set @audit_time     = CURRENT_TIMESTAMP; 

	INSERT INTO  BACK_UP.dbo.ActivityBackup(event_name, coordinator, place, audit_activity, audit_time)
	VALUES( @event_name, @coordinator, @place, @activity, @audit_time)

	PRINT 'After insert trigger on activity table'
GO

/************************************************************************************
adding a trigger on update
**************************************************************************************/
IF EXISTS (select * from sysobjects where name like '%updateActivityTrigger%')
DROP TRIGGER updateActivityTrigger
go
CREATE TRIGGER updateActivityTrigger
ON planned_activities FOR UPDATE
AS 
		
	  declare @event_name       NVARCHAR(60) ;
	  declare @coordinator      NVARCHAR(60) ;
      declare @place            NVARCHAR(50) ;
	  declare @activity		   VARCHAR(200);
	  declare @audit_time     DATETIME
	

	  select @event_name       = m.event_name FROM BACK_UP.dbo.ActivityBackup m;
	  select @coordinator      = m.coordinator FROM BACK_UP.dbo.ActivityBackup m;
	  select @place            = m.place FROM BACK_UP.dbo.ActivityBackup m;
	  select @activity         = m.audit_activity FROM BACK_UP.dbo.ActivityBackup m;
	  

		if update(event_name)	
		    set @activity = 'Updated the event name';
		if update(coordinator)	
			set @activity = 'Updated the coordinator ';
	
	  set @audit_time     = CURRENT_TIMESTAMP; 

	INSERT INTO  BACK_UP.dbo.ActivityBackup(event_name, coordinator, place, audit_activity, audit_time)
	VALUES( @event_name, @coordinator, @place, @activity, @audit_time)

	EXEC msdb.dbo.sp_send_dbmail
         @profile_name =  'mail profile',
         @recipients = 'dsampah@ashesi.edu.gh',
         @subject = 'Updated the the activity table',
         @body = 'Just Updated  the activity table'

	PRINT 'After update trigger on activity table'
GO

/************************************************************************************
A trigger for delete on the activity table 
***************************************************************************************/
IF EXISTS (select * from sysobjects where name like '%deleteActivityTrigger%')
DROP TRIGGER deleteActivityTrigger
go
CREATE TRIGGER deleteActivityTrigger
ON planned_activities FOR DELETE
AS 
		
	  declare @event_name       NVARCHAR(60) ;
	  declare @coordinator      NVARCHAR(60) ;
      declare @place            NVARCHAR(50) ;
	  declare @activity		    VARCHAR(200);
	  declare @audit_time       DATETIME
	

	  select @event_name       = m.event_name FROM BACK_UP.dbo.ActivityBackup m;
	  select @coordinator      = m.coordinator FROM BACK_UP.dbo.ActivityBackup m;
	  select @place            = m.place FROM BACK_UP.dbo.ActivityBackup m;
	  select @activity         = m.audit_activity FROM BACK_UP.dbo.ActivityBackup m;
	  

		
      set @activity = 'deleted an activity ';
	  set @audit_time     = CURRENT_TIMESTAMP; 

	INSERT INTO  BACK_UP.dbo.ActivityBackup(event_name, coordinator, place, audit_activity, audit_time)
	VALUES( @event_name, @coordinator, @place,  @activity, @audit_time)

	EXEC msdb.dbo.sp_send_dbmail
         @profile_name =  'mail profile',
         @recipients = 'dsampah@ashesi.edu.gh',
         @subject = 'Deleted the activity table',
         @body = 'Just Deleted an activity  in the activity table'
	PRINT 'After Delete trigger on activity table'

GO





/*==============================================================*/
/* Table: fundraising_campain                                    */
/*==============================================================*/
create table fundraising_campain (
   event             NVARCHAR(60)         PRIMARY KEY,
   targetAmount      int              not null,
   reachedAmount      int         null,
   FOREIGN KEY(event) REFERENCES   planned_activities(event_name)
)



/*==============================================================*/
/* Table: contributors                                    */
/*==============================================================*/
create table contributors (
   id             int         identity PRIMARY KEY,
   event_id      NVARCHAR(60)        not null,
   contributor    int                null,
   contribution   int                null,
   FOREIGN KEY (contributor) REFERENCES Member(id),
   FOREIGN KEY (event_id) REFERENCES planned_activities(event_name)
)

/*==============================================================*/
/* Table: " repoted"                                               */
/*==============================================================*/
CREATE TABLE reported (
  id int NOT NULL,
  user_id int NOT NULL,
  reportedId int NOT NULL,
  message varchar  NOT NULL,
  action varchar(3) DEFAULT null,
  country varchar(3) NOT NULL,
  PRIMARY KEY (id)
)


/****************************************************************
*TOPICS LIKES 
*****************************************************************/
 CREATE TABLE topiclikes (
  id int NOT NULL,
  user_id int NOT NULL,
  likedId int NOT NULL,
  action varchar(3) DEFAULT NULL,
  PRIMARY KEY (id),
  CONSTRAINT likeUser FOREIGN KEY (user_id) REFERENCES Member (id)
) 

/***************************************************************************************
CREATING A VIEW: topicsComments
This view helps to link each topic with all the comments that pople have written on it
***************************************************************************************/
GO
CREATE VIEW topicsComments
AS select U.id AS user_id,U.username AS username,concat(U.fname,U.lname) AS fullname,
U.profile_pic AS Oprofile_pic, T.id AS topic_id,T.link AS link,T.title AS title,T.body AS body,
T.status AS status,T.tags AS tags,T.likes AS likes,T.created_at AS created_at,T.updated_at AS updated_at,C.id AS commentId, C.topic_id AS cTopicId,C.content AS cBody,
C.likes AS cLikes,C.created_at AS cCreatedAt,C.updated_at AS cUpdatedAt 
FROM Member U join Topics T on U.id = T.creator left join comments C on T.id = C.topic_id 
GO 

/***************************************************************************************
A table linking the the reported topics with the corresponding topics in the database
****************************************************************************************/
GO
 CREATE VIEW topicsreports 
 AS select r.id AS id, r.user_id AS user_id, r.message AS message,r.country AS country,t.title AS title,t.body AS body from (reported r join topics t on((r.reportedId = t.id)))
GO

/***************************************************************************************
A table linking all topics and the corresponding users that have submitted them
****************************************************************************************/
GO
CREATE VIEW allTopics
AS select U.id AS user_id,U.username AS username,concat(U.fname,U.lname) AS fullname,
U.profile_pic AS Oprofile_pic, T.id AS topic_id,T.link AS link,T.title AS title,T.body AS body,
T.status AS status,T.tags AS tags,T.likes AS likes,T.created_at AS created_at,T.updated_at AS updated_at 
FROM Member U join Topics T on U.id = T.creator
GO

/********************************************************************************
This will help me to easily connect event coordinators to events themselves
**********************************************************************************/
GO
CREATE VIEW activitiesCordinators
AS select  F.event , P.coordinator, F.targetAmount, F.reachedAmount , P.place AS place
FROM planned_activities P join fundraising_campain F on P.event_name = F.event
GO

/**********************************************************************************************
***********************************************************************************************
Stored procedures
************************************************************************************************
************************************************************************************************/

/***********************************************************************************************
Stored procedures for the main tables 
***********************************************************************************************/
/* Procedure for inserting a member */
CREATE PROCEDURE insertMember
  @username        NVARCHAR(20),
  @fname           NVARCHAR(20),
  @lname           NVARCHAR(20),
  @email           VARCHAR(50),
  @profile_pic     TEXT,
  @pass            TEXT,
  @phone           VARCHAR(20),
  @birthdate       DATETIME,
  @organization    VARCHAR(3),
  @functio        INT
  
AS 
BEGIN 
	INSERT INTO Member(username,fname, lname, email,profile_pic, pass,phone ,birthdate, organization, functio)
	VALUES(@username,@fname, @lname, @email, @profile_pic, @pass, @phone ,@birthdate, @organization, @functio)
END
GO


EXEC insertMember 'gidiyoni', 'Gedeon', 'Niyonkuru','gedeoniyonkuru@gmail.com','location','*******','0215545552', '22-Jul-1996', 'GH', '1';
EXEC insertMember 'gidiyoni1', 'Gedeon', 'Niyonkuru','gedeoniyonkuru1@gmail.com','location','*****','0215545554', '22-Jul-1996', 'GH', '0';
EXEC insertMember 'gidiyoni2', 'Gedeon', 'Niyonkuru','gedeoniyonkuru2@gmail.com','location','*****','0215545555', '22-Jul-1996', 'GH', '1';
EXEC insertMember 'gidiyoni13', 'Gedeon', 'Niyonkuru','gedeoniyonkuru3@gmail.com','location','****','0215545556', '22-Jul-1996', 'GH', '0';
EXEC insertMember 'gidiyoni14', 'Gedeon', 'Niyonkuru','gedeoniyonkuru4@gmail.com','location','******','0215545557', '22-Jul-1996', 'GH', '0';
GO


/*a pocedure for inserting a join request*/
CREATE PROCEDURE InSjoinRequest
  @email           NVARCHAR(50),
  @first_name      NVARCHAR(30),
  @last_name       NVARCHAR(30),
  @phoneNumber     VARCHAR(20),
  @country         VARCHAR(3),
  @message		  VARCHAR(200)
  
AS 
BEGIN 
	INSERT INTO join_requests(email,first_name, last_name, phoneNumber,country, message)
	VALUES(@email,@first_name, @last_name, @phoneNumber, @country, @message)
END
GO

EXEC InSjoinRequest 'gedeoniyonkuru@gmail.com', 'Gedeon', 'Niyonkuru', '0215456655', 'GH', 'I am a new member';
EXEC InSjoinRequest 'gedeoniyonkuru1@gmail.com', 'Gedeon', 'Niyonkuru', '0215456656', 'GH', 'I am a new member';
EXEC InSjoinRequest 'gedeoniyonkuru2@gmail.com', 'Gedeon', 'Niyonkuru', '0215456657', 'GH', 'I am a new member';
EXEC InSjoinRequest 'gedeoniyonkuru3@gmail.com', 'Gedeon', 'Niyonkuru', '0215456658', 'GH', 'I am a new member';
EXEC InSjoinRequest 'gedeoniyonkuru4@gmail.com', 'Gedeon', 'Niyonkuru', '0215456659', 'GH', 'I am a new member';



/*a pocedure for inserting a diaspora*/
GO
CREATE PROCEDURE InsertDiaspora
   @Organisation         varchar(15),
   @leaders_email        nvarchar(50),
   @leaders_phone        varchar(12),
   @committe_id          INT
AS 
	BEGIN 
		INSERT INTO Diasporas(Organisation,leaders_email, leaders_phone, committe_id)
		VALUES(@Organisation,@leaders_email, @leaders_phone, @committe_id)
	END
GO

EXEC InsertDiaspora 'GH','gedeoniyonkuru@gmail.com','02112556164','1';
EXEC InsertDiaspora 'KE','patrick@gmail.com','02412556164','2';
EXEC InsertDiaspora 'CH','ngoga@gmail.com','02412556174','0';
EXEC InsertDiaspora 'FR','yves@gmail.com','02412556334','0';
EXEC InsertDiaspora 'US','mark@gmail.com','02412556974','0';



/*a pocedure for inserting a diaspora*/
GO
CREATE PROCEDURE insertActivities
   @event_name       NVARCHAR(60),
   @coordinator      NVARCHAR(60),
   @place            NVARCHAR(50),
   @time 			 DATE 
AS 
	BEGIN 
		INSERT INTO planned_activities(event_name,coordinator, place, time)
		VALUES(@event_name,@coordinator, @place, @time)
	END
GO


EXEC insertActivities 'kwibuka', 'gedeon', 'CEIBS', '22-Jul-2006';
EXEC insertActivities 'Umuganda', 'gedeon', 'CEIBS', '26-Jul-2007';
EXEC insertActivities 'Amatora', 'gedeon', 'CEIBS', '02-Jul-2007';
EXEC insertActivities 'Kuganira', 'gedeon', 'CEIBS', '12-Jul-2007';
EXEC insertActivities 'Inama', 'gedeon', 'CEIBS', '15-Jul-2007';
EXEC insertActivities 'meeting', 'gedeon', 'CEIBS', '22-Jul-2006';
EXEC insertActivities 'Remembering', 'gedeon', 'CEIBS', '26-Jul-2007';
EXEC insertActivities 'Work', 'gedeon', 'CEIBS', '02-Jul-2007';
EXEC insertActivities 'Ceremony', 'gedeon', 'CEIBS', '12-Jul-2007';
EXEC insertActivities 'Gathering', 'gedeon', 'CEIBS', '15-Jul-2007';


/***********************************************************************************************
Stored procedures for other tables
***********************************************************************************************/




/*a pocedure for inserting a topic*/
GO
CREATE PROCEDURE insertTopic
   @id               int,
   @creator          int,
   @link             varchar(100),
   @title            varchar(100),
   @body             nvarchar(30),
   @status           INT

   AS
	BEGIN 
		INSERT INTO Topics(id, creator,link, title, body, status)
		VALUES(@id, @creator,@link, @title, @body, @status)
	END
GO


EXEC insertTopic 1, 4, 'what', 'first post', 'first post',0;
EXEC insertTopic 2, 3, 'second-post', 'second post', 'second post',0;
EXEC insertTopic 3, 3, 'third-post', 'third post', 'third post',0;
EXEC insertTopic 4, 5, 'fourth-post', 'fourth post', 'fourth post',0;
EXEC insertTopic 5, 4, 'fifth-post', 'fifth post', 'fifth post',0;
EXEC insertTopic 6, 3, 'sixth-post', 'sixth post', 'sixth post',0;
EXEC insertTopic 7, 6, 'seventh-post', 'seventh post', 'seventh post',0;
EXEC insertTopic 8, 3, 'eighth-post', 'eighth post', 'eighth post',0;
EXEC insertTopic 9, 6, 'nineth-post', 'nineth post', 'nineth post',0;
EXEC insertTopic 10, 4, 'last-post', 'last post', 'last post',0;

/*a pocedure for inserting a comment*/
GO
CREATE PROCEDURE insertComments
   @user_id          int,
   @topic_id         int,
   @content			 text
AS 
	BEGIN 
		INSERT INTO comments(user_id,topic_id, content)
		VALUES(@user_id,@topic_id,  @content)
	END
GO


EXEC insertComments '3', '1', 'Just commenting';
EXEC insertComments '5', '2', 'Just throwing comments';
EXEC insertComments '4', '1', 'Just commenting ';
EXEC insertComments '5', '1', 'Simply commenting ';
EXEC insertComments '7', '1', 'Trying to comment';
EXEC insertComments '5', '1', 'Me commenting';
EXEC insertComments '4', '2', 'Me and you';
EXEC insertComments '4', '1', 'All of us ';
EXEC insertComments '5', '1', 'We will succeed ';
EXEC insertComments '6', '1', 'I will succeed';



/*a pocedure for inserting a reported*/
GO
CREATE PROCEDURE insertReported
  @id int,
  @user_id int,
  @reportedId int,
  @message varchar,
  @action varchar(3),
  @country varchar(3)

  AS
	BEGIN 
		INSERT INTO Reported(id, user_id, reportedId, message, action, country)
		VALUES(@id, @user_id, @reportedId, @message, @action, @country)
	END
GO

EXEC insertReported 1, '1', '1', 'this post is abusive', '1', 'GH';
EXEC insertReported 2,'1', '1', 'this post is abusive', '1', 'GH';
EXEC insertReported 3,'2', '1', 'this post is abusive', '1', 'GH';
EXEC insertReported 4,'1', '1', 'this post is abusive', '1', 'GH';
EXEC insertReported 5,'1', '1', 'this post is abusive', '1', 'GH';
EXEC insertReported 6,'4', '1', 'this post is abusive', '1', 'GH';
EXEC insertReported 7,'1', '1', 'this post is abusive', '1', 'GH';
EXEC insertReported 8,'3', '1', 'this post is abusive', '1', 'GH';
EXEC insertReported 9,'1', '1', 'this post is abusive', '1', 'GH';
EXEC insertReported 10,'1', '1', 'this post is abusive', '1', 'GH';

/*a pocedure for inserting a Committe*/
GO
CREATE PROCEDURE committeMember
   @member            int,
   @role              varchar(50),
   @country         varchar(3)
   AS
	BEGIN 
		INSERT INTO Committe(member, role, country)
		VALUES(@member, @role, @country)
	END
GO

EXEC committeMember '3', 'president', 'GH';
EXEC committeMember '4', 'vice-president', 'GH';
EXEC committeMember '3', 'secretaire','GH';
EXEC committeMember '4', 'treasurer', 'GH';
EXEC committeMember '5', 'event-organiser', 'GH';

/*a pocedure for inserting a Committe*/
GO
CREATE PROCEDURE InserFundraisers
   @event             NVARCHAR(60),
   @targetAmount      int,
   @reachedAmount      int

   AS
	BEGIN 
		INSERT INTO fundraising_campain(event, targetAmount, reachedAmount)
		VALUES(@event, @targetAmount, @reachedAmount)
	END
GO

EXEC InserFundraisers 'kwibuka', 1200, 1000;
EXEC InserFundraisers 'Umuganda', 1000, 1000;
EXEC InserFundraisers 'Amatora', 2000, 1000;
EXEC InserFundraisers 'Kuganira', 1500, 800;
EXEC InserFundraisers 'Inama', 900, 600;
EXEC InserFundraisers 'meeting', 2000, 1100;
EXEC InserFundraisers 'Remembering', 2200, 100;
EXEC InserFundraisers 'Work', 3000, 1210;
EXEC InserFundraisers 'Ceremony', 3210, 110;
EXEC InserFundraisers 'Gathering', 1300, 180;

/*a pocedure for inserting a like*/
GO
CREATE PROCEDURE insertLikes
  @id int,
  @user_id int,
  @likedId int ,
  @action varchar(3)

  AS
	BEGIN 
		INSERT INTO topiclikes(id, user_id, likedId, action)
		VALUES(@id, @user_id, @likedId, @action)
	END
GO

EXEC insertLikes 1,'3', 1, 1;
EXEC insertLikes 2,'3', 2, 0;
EXEC insertLikes 3, '5', 3, 1;
EXEC insertLikes 4, '4', 4, 0;
EXEC insertLikes 5, '3', 5, 0;

/*a pocedure for inserting a contributors*/
GO
CREATE PROCEDURE insertAcontributor
   
   @event_id      NVARCHAR(60),
   @contributor    int,
   @contribution   int

   AS
	BEGIN 
		INSERT INTO contributors( event_id, contributor, contribution)
		VALUES( @event_id, @contributor, @contribution)
	END
GO

EXEC insertAcontributor 'kwibuka', 3, 100;
EXEC insertAcontributor 'Umuganda', 3, 100;
EXEC insertAcontributor 'Amatora', 4, 100;
EXEC insertAcontributor 'Kuganira', 5, 80;
EXEC insertAcontributor 'Inama', 3, 60;

/*a pocedure for inserting a message*/
GO
CREATE PROCEDURE insertPrivateMsg
   @sender_id            int ,
   @receiver_id          int ,
   @seen      			INT  

   AS
	BEGIN 
		INSERT INTO private_messages(sender_id, receiver_id, seen)
		VALUES(@sender_id, @receiver_id, @seen)
	END
GO

EXEC insertPrivateMsg '1', 2, 0;
EXEC insertPrivateMsg '2', 1, 1;
EXEC insertPrivateMsg '1', 2, 0;
EXEC insertPrivateMsg '1', 2, 1;
EXEC insertPrivateMsg '2', 1, 0;
