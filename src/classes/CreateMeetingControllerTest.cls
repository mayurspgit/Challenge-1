/*
 * Class Name: CreatingMeetingControllerTest
 * Created Date: 18/09/2018
 * Created By: Mayur Patil
 * Purpose: Test Class for CreateMeetingController.
*/
@isTest
public class CreateMeetingControllerTest {
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
    public static void testConstructor(){
        List<Contact> contactList=[SELECT Id FROM Contact LIMIT 1];
        Test.startTest();
        Test.setCurrentPage(Page.CreateMeetingPage);
        ApexPages.currentPage().getParameters().get('');
        ApexPages.StandardController stdCtrl=new ApexPages.StandardController(contactList[0]);
        CreatingMeetingController createMeetObj=new CreatingMeetingController(stdCtrl);
        System.assertEquals(contactList[0].Id,createMeetObj.eventObj.WhoId);
        Test.stopTest();
    }
    @isTest
    public static void testConflictingEvent(){
        List<Contact> contactList=[SELECT Id FROM Contact LIMIT 1];
        Test.startTest();
        Test.setCurrentPage(Page.CreateMeetingPage);
        ApexPages.currentPage().getParameters().get('');
        ApexPages.StandardController stdCtrl=new ApexPages.StandardController(contactList[0]);
        CreatingMeetingController createMeetObj=new CreatingMeetingController(stdCtrl);
        createMeetObj.eventObj.StartDateTime = System.now().addMinutes(35);
        createMeetObj.eventObj.EndDateTime = System.now().addMinutes(100);
        System.assertEquals(null,createMeetObj.saveEvent());
        Test.stopTest();
    }
    @isTest
    public static void testValidEvent(){
        List<Contact> contactList=[SELECT Id FROM Contact LIMIT 1];
        Test.startTest();
        Test.setCurrentPage(Page.CreateMeetingPage);
        ApexPages.currentPage().getParameters().get('');
        ApexPages.StandardController stdCtrl=new ApexPages.StandardController(contactList[0]);
        CreatingMeetingController createMeetObj=new CreatingMeetingController(stdCtrl);
        createMeetObj.eventObj.StartDateTime = System.now().addMinutes(60);
        createMeetObj.eventObj.EndDateTime = System.now().addMinutes(100);
        System.assert(createMeetObj.saveEvent()!=null);
        Test.stopTest();
    }
}