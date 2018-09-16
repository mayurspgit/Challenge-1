public with sharing class CreatingMeetingController {
	public Event eventObj{get;set;}
	Id ContactId;
	public CreatingMeetingController(ApexPages.StandardController stdController) {
		ContactId=((Contact)stdController.getRecord()).Id;
		eventObj=new Event();
		eventObj.WhoId=ContactId;
		eventObj.OwnerId=UserInfo.getUserId();
		eventObj.StartDateTime=System.now();
		eventObj.EndDateTime=System.now().addMinutes(15);
	}
	public PageReference saveEvent(){
		Event newEventObj=eventObj;
		Datetime NOW=System.now();
		Map<Id,User> ownerMap=new Map<Id,User>([SELECT Id,FirstName FROM User WHERE Id=:UserInfo.getUserId()]);
		for(Event eventObj:[SELECT Id,Subject,OwnerId,StartDateTime,EndDateTime FROM Event WHERE OwnerId=:UserInfo.getUserId() AND (StartDateTime>=:NOW OR EndDateTime>=:NOW)]){
			if(newEventObj.OwnerId==eventObj.OwnerId &&
				(newEventObj.StartDateTime>=eventObj.StartDateTime && newEventObj.StartDateTime<=eventObj.EndDateTime) ||
				(newEventObj.EndDateTime>=eventObj.StartDateTime && newEventObj.EndDateTime<=eventObj.EndDateTime)){
				ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Hi '+ownerMap.get(eventObj.OwnerId).FirstName+',This Event is conflicting with your other event. <br>Event Details:(Event Subject:'+eventObj.Subject+',StartTime:'+eventObj.StartDateTime+',EndTime:'+eventObj.EndDateTime+')<br><a href="/'+eventObj.Id+'">Click to open the CONFLICTING EVENT.</a>');
				ApexPages.addMessage(myMsg);
				return null;
			}
		}
		try{

			eventObj.WhoId=null;
			upsert eventObj;
			System.debug('event id: '+eventObj.Id);

			EventRelation erObj=new EventRelation();
			erObj.EventId=eventObj.Id;
			erObj.Status='New';
			erObj.RelationId=ContactId;
			erObj.IsParent=true;
			erObj.IsInvitee=true;
			//insert erObj;

			Database.DMLOptions dlo = new Database.DMLOptions();
			dlo.EmailHeader.triggerOtherEmail  = true;
			Database.insert(erObj,dlo);
		}catch(Exception ex){
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage());
            ApexPages.addMessage(myMsg);
            return null;
		}
		return new PageReference('/'+eventObj.Id);
	}		
}