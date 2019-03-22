

USE GED70362018;
SET NOCOUNT on;
GO

/** The query should help RCA GHANA to keep the details of member of the diaspora and their role on the platorm
1 stands for admin
0 stands for a normal 
 **/
GO
  CREATE PROCEDURE selectMembers
  @function     int
   AS
	BEGIN 
		SELECT fname, lname from Member where functio = @function;
	END
GO
EXEC selectMembers 0
EXEC selectMembers 1

/* Listing activities **/
GO
  CREATE PROCEDURE listActivities
   AS
	BEGIN 
		select event_name, coordinator, place, time from planned_activities order by time ASC
	END
GO
EXEC listActivities


/** Using the activity coordinators view to keep track of activies and their coordinators **/
GO
  CREATE PROCEDURE activitiesCordinator  
   AS
	BEGIN 
		select * from activitiesCordinators order by targetAmount DESC
	END
GO
EXEC activitiesCordinator


/**  Getting records of all the topics of the conversation  by using the allTopic view**/
GO
  CREATE PROCEDURE getAlltopics
   AS
	BEGIN 
		select user_id, username, fullname, topic_id, link, title body, status from allTopics
	END
GO
EXEC getAlltopics



/**  Checking all the comments that were made on a particular topic **/
GO
  CREATE PROCEDURE getComments
  @topic     int
   AS
	BEGIN 
		select user_id, fullname, topic_id, link, title, body, commentId, cbody as commentBody  from topicsComments where topic_id = @topic
	END
  GO

EXEC getComments 1


/**
Checking all the topics report and the id's of people who reported them
Reported topics are bad topics that people report to the moderator so that they can be deleted
**/
 GO
  CREATE PROCEDURE getReports
   AS
	BEGIN 
		select id, user_id, message, country, title, body from topicsreports
	END
GO

EXEC getReports

