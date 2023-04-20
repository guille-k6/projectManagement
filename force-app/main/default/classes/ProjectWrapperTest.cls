@isTest
public class ProjectWrapperTest {
    
    @isTest
    static void testGetProject() {
        // Create a test user
        /*User testUser = new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser@example.com',
            Username = 'testuser@example.com',
            Alias = 'tuser',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = UserInfo.getProfileId(),
            Role = 'Developer'
        );
        insert testUser;*/
        
        // Create a test project
        Project__c testProject = new Project__c(
            Close_Date__c = Date.today(),
            Start_Date__c = Date.today().addDays(-7)
        );
        insert testProject;
        
        // Create test project resources
        Project_Resource__c testResource1 = new Project_Resource__c(
            Project__c = testProject.Id,
            Start_Date__c = Date.today().addDays(-7),
            Close_Date__c = Date.today().addDays(7),
            AssignedHours__c = 40,
            Is_Squad_Lead__c = false,
            Resource__c = '005Do000001ygnvIAA'
        );
        insert testResource1;
        
        Project_Resource__c testResource2 = new Project_Resource__c(
            Project__c = testProject.Id,
            Start_Date__c = Date.today().addDays(-7),
            Close_Date__c = Date.today().addDays(7),
            AssignedHours__c = 20,
            Is_Squad_Lead__c = true,
           	Resource__c = '005Do000001ygnvIAA'
        );
        insert testResource2;
        
        // Create test project products
        Project_Product__c testProduct1 = new Project_Product__c(
            Project__c = testProject.Id,
            Quantity__c = 10,
            Amount__c = 100,
            Role__c = 'Developer'
        );
        insert testProduct1;
        
        Project_Product__c testProduct2 = new Project_Product__c(
            Project__c = testProject.Id,
            Quantity__c = 5,
            Amount__c = 200,
            Role__c = 'Project Manager',
            Completed_Hours__c = 0
        );
        insert testProduct2;
    
   
        Project__c testProject1 = [SELECT Id, Name, Amount__c, Client__c, Close_Date__c, Start_Date__c FROM Project__c WHERE Id = :testProject.Id LIMIT 1];
        
        Test.startTest();
        ProjectWrapper projectWrapper = ProjectWrapper.getProject(testProject1.Id);
        Test.stopTest();
        
        System.assertEquals(testProject.Id, projectWrapper.Project.Id);
        System.assertEquals(2, projectWrapper.ProjectResources.size());
        System.assertEquals(2, projectWrapper.ProjectProducts.size());
        System.assertEquals(1, projectWrapper.Resources.size());
    }
}