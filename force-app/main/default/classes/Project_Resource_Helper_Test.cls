@isTest
public class Project_Resource_Helper_Test {
	@isTest
    private static void testOne(){
        Project__c p = new Project__c();
        insert p;
        
        Project_Product__c pp = new Project_Product__c(
        	Project__c = p.Id,
            Role__c = 'Developer',
            Quantity__c = 40
        );
        insert pp;
        
       	Project_Resource__c pr = new Project_Resource__c(
        	Project__c = p.Id,
            Resource__c = '005Do000001SJJHIA4',
            AssignedHours__c = 20
        );
        insert pr;
        test.startTest();
          	pr.AssignedHours__c = 30;
          	update pr;
        test.stopTest();
        
        Project_Product__c testPP = [SELECT Id, Completed_Hours__c FROM Project_Product__c];
        System.assertEquals(30, testPP.Completed_Hours__c);
    }
    
    @isTest
    private static void testTwo(){
        Project__c p = new Project__c();
        insert p;
        
        Project_Product__c pp = new Project_Product__c(
        	Project__c = p.Id,
            Role__c = 'Developer',
            Quantity__c = 40
        );
        insert pp;
        
       	Project_Resource__c pr = new Project_Resource__c(
        	Project__c = p.Id,
            Resource__c = '005Do000001SJJHIA4',
            AssignedHours__c = 20
        );
        insert pr;
        test.startTest();
          	delete pr;
        test.stopTest();
        
        Project_Product__c testPP = [SELECT Id, Completed_Hours__c FROM Project_Product__c];
        System.assertEquals(0, testPP.Completed_Hours__c);
    }
}