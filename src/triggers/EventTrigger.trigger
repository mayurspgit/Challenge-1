trigger EventTrigger on Event (before insert, before update) {
	if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
		EventTriggerHandler.validateIfEventsAreConflicting(Trigger.newMap,Trigger.new);
	}
}