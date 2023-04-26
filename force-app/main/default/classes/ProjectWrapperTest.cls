@isTest
public class ProjectWrapperTest {
    @isTest
   static void testGetProject() {
        // Create a test project
        Project__c testProject = new Project__c(Close_Date__c = Date.today(),
                                                Start_Date__c = Date.today().addDays(7));
        insert testProject;

        // Create a test project product
         Project_Product__c pp = new Project_Product__c(
        	Project__c = testProject.Id,
            Role__c = 'Developer',
            Quantity__c = 40
        );
        insert pp;


        // Create a test project resource
        Project_Resource__c testProjectResource = new Project_Resource__c(Project__c = testProject.Id, Resource__c = '005Dp000000OgubIAC',
                                                                            Start_Date__c = Date.today().addDays(2), 
                                                                            Close_Date__c = Date.today().addDays(5));
        

        Test.startTest();
        insert testProjectResource;
        // Call the getProject method with the test project's ID
        ProjectWrapper result = ProjectWrapper.getProject(testProject.Id);

        // Verify that the result object is not null and contains the correct data
        System.assertNotEquals(null, result);
        System.assertEquals(testProject.Id, result.project.Id);
        System.assertEquals(pp.Id, result.requirementList[0].projectProduct.Id);
        //System.assertEquals(testUser.Id, result.requirementList[0].users[0].Id);
        Test.stopTest();
    }

}