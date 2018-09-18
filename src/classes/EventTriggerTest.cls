/*
Class Name: EventTriggerTest
CreatedDate:16/09/2018
Created By: Mayur Patil
Purpose: Test Class for EventTrigger
*/
@isTest
public class EventTriggerTest {
	@testSetup
    public static void setupData(){
        Contact conObj=new Contact(LastName='Test',Email='test@email123.com');
        insert conObj;
        Event eventObj = new Event(
            Location = 'Online',
            Subject = 'Meeting1',
            StartDateTime = System.now().addMinutes(30),
            WhoId = conObj.Id,
            EndDateTime = System.now().addMinutes(60),
            IsAllDayEvent = false
        );
        insert eventObj;
    }
    @isTest
    public static void testValidEvent(){
        Test.startTest();
        List<Contact> contactList=[SELECT Id FROM Contact LIMIT 1];
        if(contactList!=null && contactList.size()==1){
            Event eventObj = new Event(
            Location = 'Online',
            Subject = 'Valid Meeting',
            StartDateTime = System.now().addMinutes(60),
            WhoId = contactList[0].Id,
            EndDateTime = System.now().addMinutes(90),
            IsAllDayEvent = false
        	);
            insert eventObj;
            System.assert(eventObj.Id!=null);
        }
        Test.stopTest();
    }
    @isTest
    public static void testWhetherEventIsConflicting(){
        Test.startTest();
        List<Contact> contactList=[SELECT Id FROM Contact LIMIT 1];
        if(contactList!=null && contactList.size()==1){
            Event eventObj = new Event(
            Location = 'Online',
            Subject = 'Conflicting Meeting',
            StartDateTime = System.now().addMinutes(30),
            WhoId = contactList[0].Id,
            EndDateTime = System.now().addMinutes(60),
            IsAllDayEvent = false
        	);
            try{
                insert eventObj;
            }
            catch(Exception ex){
                System.assert(ex.getMessage().contains('This Event is conflicting with your other event.'));
            }
        }
        Test.stopTest();
    }
}