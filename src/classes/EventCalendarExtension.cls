public with sharing class EventCalendarExtension {
	public EventCalendarExtension(ApexPages.StandardController stdCtrl){
	}
	@RemoteAction
	public static String createEvent(Id contactId,String subject,String startDateTime,String endDateTime){
		System.debug(contactId);
		System.debug(subject);
		System.debug(Datetime.valueOfGmt(startDateTime));
		System.debug(Datetime.valueOfGmt(endDateTime));
		try{
			Event eventObj=new Event();
			eventObj.Subject=subject;
			eventObj.StartDateTime=Datetime.valueOfGmt(startDateTime);
			eventObj.EndDateTime=Datetime.valueOfGmt(endDateTime);
			eventObj.OwnerId=UserInfo.getUserId();
			insert eventObj;
			System.debug('event id: '+eventObj.Id);
			EventRelation erObj=new EventRelation();
			erObj.EventId=eventObj.Id;
			erObj.Status='New';
			erObj.RelationId=ContactId;
			erObj.IsParent=true;
			erObj.IsInvitee=true;
			Database.DMLOptions dlo = new Database.DMLOptions();
			dlo.EmailHeader.triggerOtherEmail  = true;
			Database.insert(erObj,dlo);
            return 'Event Updated Successfully';
		}catch(Exception ex){
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage());
            ApexPages.addMessage(myMsg);
            return ex.getMessage();
		}
	}
    @RemoteAction
	public static String updateEvent(Id eventId,String startDateTime,String endDateTime){
		System.debug(eventId);
		System.debug(Datetime.valueOfGmt(startDateTime));
		System.debug(Datetime.valueOfGmt(endDateTime));
		try{
			Event eventObj=new Event();
            eventObj.Id=eventId;
			eventObj.StartDateTime=Datetime.valueOfGmt(startDateTime);
			eventObj.EndDateTime=Datetime.valueOfGmt(endDateTime);
			update eventObj;
			EventRelation erObj=[SELECT Id FROM EventRelation WHERE EventId=:eventId LIMIT 1];
			erObj.IsParent=true;
			erObj.IsInvitee=true;
			Database.DMLOptions dlo = new Database.DMLOptions();
			dlo.EmailHeader.triggerOtherEmail  = true;
			Database.update(erObj,dlo);
            return 'Event Updated Successfully';
		}catch(Exception ex){
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage());
            ApexPages.addMessage(myMsg);
            return ex.getMessage();
		}
	}
}
