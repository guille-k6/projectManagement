public class Project_Resource_Helper {
    public static void updateCompletedHours(List<Project_Resource__c> resources){
        // Getting the projects with their ProjectProducts related to the project resources modified.
		Set<Id> projectIds = new Set<Id>();
        for(Project_Resource__c pr : resources){
            projectIds.add(pr.Project__c);
        }
        List<Project__c> projectsInvolved = [SELECT Id, (SELECT Id, Role__c, Quantity__c, Completed_Hours__c FROM Project_Products__r) FROM Project__c WHERE Id in :projectIds];
        
        // Getting all the projectResources from the projects modified in order to count their completed hours by role.
        List<Project_Resource__c> projectResources = [SELECT Id, Role__c, Project__c, AssignedHours__c FROM Project_Resource__c WHERE Project__c in :projectsInvolved];
        
        // Map of Projects with their ProjectResources
        Map<Project__c, List<Project_Resource__c>> projectsWithResources = new Map<Project__c, List<Project_Resource__c>>();
        for(Project__c project : projectsInvolved){
            List<Project_Resource__c> projectResourcesOfTheProject = new List<Project_Resource__c>();
            for(Project_Resource__c pr : projectResources){
                if(pr.Project__c == project.Id){
                    projectResourcesOfTheProject.add(pr);
                }
            }
            projectsWithResources.put(project, projectResourcesOfTheProject);
        }
        
        // For each project and for each role of the project I count the hours of that role.
        List<Project_Product__c> ProjectProductsToUpdate = new List<Project_Product__c>();
        for(Project__c project : projectsWithResources.keySet()){
            for(Project_Product__c pp : project.Project_Products__r){
                Integer counter = 0;
            	for(Project_Resource__c presource : projectsWithResources.get(project)){        
                    if(pp.Role__c == presource.Role__c){ 
                        System.debug('Roles iguales!');
                        counter = counter + Integer.valueOf(presource.AssignedHours__c);
                        //pp.Completed_Hours__c = pp.Completed_Hours__c + presource.AssignedHours__c;
                    }
                }
				pp.Completed_Hours__c = counter; 
                System.debug('Completed Hours: ' + pp.Completed_Hours__c);
                System.debug('Counter: ' + counter);
            }
            ProjectProductsToUpdate.add(project.Project_Products__r);            
        }
        
        update ProjectProductsToUpdate;
        
        
    }
}