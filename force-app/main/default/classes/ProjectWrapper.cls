public class ProjectWrapper {
    
    @auraEnabled
    public Project__c Project;
    @auraEnabled
    public List<Project_Resource__c> ProjectResources; //Set<Id> ProjectResources;?
    @auraEnabled
    public List<Project_Product__c> ProjectProducts; //Set<Id> ProjectProducts;?
    @auraEnabled
    public List<User> Resources; //Set<Id> Resources;?
    
    public ProjectWrapper (Project__c Project, List<Project_Resource__c> ProjectResources, List<Project_Product__c> ProjectProducts, List<User> Resources){
        this.project = project;
        this.ProjectProducts = ProjectProducts;
        this.ProjectResources = ProjectResources;
        this.Resources = Resources;
    }      	 


    @AuraEnabled(cacheable=true)
    public static ProjectWrapper getProject (Id projectId) {
        List<Project_Product__c> ProjectProducts = [SELECT Id, Project__c, Quantity__c, Amount__c, Role__c, Completed_Hours__c 
													FROM Project_Product__c 
                                                    WHERE Project__c = :projectId];
        
        List<Project_Resource__c> ProjectResources = [SELECT Id, Project__c, Resource__c, Start_Date__c, Close_Date__c, Role__c, AssignedHours__c, Is_Squad_Lead__c 
                                                     FROM Project_Resource__c 
                                                     WHERE Project__c = :projectId];
        
       /* List<Id> ResourcesIds = new List<Id>();
        
            for(Project_Resource__c PR: ProjectResources){
				ResourcesIds.add(PR.Resource__c);                
            }*/
        List<String> rolAvailable = new List<String>{'Developer','Architect','Consultant', 'Project Manager'};
        
        List<UserRole> roles = [SELECT Id, Name FROM UserRole WHERE Name in :rolAvailable];
        	
        List<User> Resources = [SELECT Id, Rate__c, UserRoleId FROM User WHERE UserRoleId in :roles];
        
        Project__c project = [SELECT Id, Name, Amount__c, Client__c, Close_Date__c, Start_Date__c
 							FROM Project__c WHERE Id = :projectId];
        
        ProjectWrapper pr2 = new ProjectWrapper(Project, ProjectResources, ProjectProducts, Resources);

        return pr2;
    }
}