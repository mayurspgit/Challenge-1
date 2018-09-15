/*
Class Name: EventTriggerHandler
CreatedDate:16/09/2018
Created By: Mayur Patil
Purpose: Handler class for EventTrigger.
	1. Validate if user is not having any conflicting event.
*/
public with sharing class EventTriggerHandler {
	public static void validateIfEventsAreConflicting(Map<Id,Event> eventMap,List<Event> eventList){
		Datetime NOW=System.now();
		Set<Id> eventOwnerIds=new Set<id>();
		for(Event eventObj:eventList){
			eventOwnerIds.add(eventObj.OwnerId);
		}
		Map<Id,User> ownerMap=new Map<Id,User>([SELECT Id,FirstName FROM User WHERE Id=:eventOwnerIds]);
		for(Event eventObj:[SELECT Id,Subject,OwnerId,StartDateTime,EndDateTime FROM Event WHERE OwnerId=:eventOwnerIds AND (StartDateTime>=:NOW OR EndDateTime>=:NOW)]){
			for(Event newEventObj:eventList){
				System.debug('old '+eventObj.StartDateTime+' '+eventObj.EndDateTime);
				System.debug('new '+newEventObj.StartDateTime+' '+newEventObj.EndDateTime);
				if(newEventObj.OwnerId==eventObj.OwnerId &&
					(newEventObj.StartDateTime>=eventObj.StartDateTime && newEventObj.StartDateTime<=eventObj.EndDateTime) ||
					(newEventObj.EndDateTime>=eventObj.StartDateTime && newEventObj.EndDateTime<=eventObj.EndDateTime)){
					newEventObj.addError('Hi '+ownerMap.get(eventObj.OwnerId).FirstName+',This Event is conflicting with your other event. <br>Event Details:(Event Subject:'+eventObj.Subject+',StartTime:'+eventObj.StartDateTime+',EndTime:'+eventObj.EndDateTime+')<br><a href="/'+eventObj.Id+'">Click to open the CONFLICTING EVENT.</a>',false);
				}

			}
		}
	}
}