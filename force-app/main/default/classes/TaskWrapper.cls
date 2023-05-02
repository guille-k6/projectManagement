public class TaskWrapper {
    
    public class TaskWrapperContainer{     
        @AuraEnabled public Project__c project;
        @AuraEnabled public List<Project_Task__c> tasks;
        
        public TaskWrapperContainer(Project__c project, List<Project_Task__c> tasks){
            this.project = project;
            this.tasks = tasks;
        }
    }
    
    // List of projects with his uncompleted tasks
    @AuraEnabled public List<TaskWrapperContainer> projectWithTasks;
    @AuraEnabled public Boolean hasTasks;
    
    public TaskWrapper(List<TaskWrapperContainer> projectWithTasks, Boolean hasTasks){
        this.projectWithTasks = projectWithTasks;
        this.hasTasks = hasTasks;
    }
    
	@AuraEnabled(cacheable=true)
    public static TaskWrapper getTaskWrapper(){
        //Id userId = UserInfo.getUserId(); 
        Id userId = '005Do000001ygnvIAA';
        
        List<Project_Resource__c> projectResources = [SELECT Id, Project__c, (SELECT Id, Summary__c, Status__c, Estimated_Hours__c, Recorded_Hours__c FROM Project_Tasks__r WHERE Status__c != 'Completed' ORDER BY Status__c DESC)
                                                      FROM Project_Resource__c
                                                      WHERE Resource__c = :userId];
        
        Set<Id> projectIds = new Set<Id>();
        for(Project_Resource__c pr : projectResources){
            projectIds.add(pr.Project__c);
        }
        
        List<Project__c> projects = [SELECT Id, Name, Pending_Tasks__c FROM Project__c WHERE Id IN :projectIds];
        
        List<TaskWrapperContainer> taskWrapperList = new List<TaskWrapperContainer>();
        
        for(Project__c project : projects){
            List<Project_Task__c> projectTasks = new List<Project_Task__c>();
            for(Project_Resource__c pr : projectResources){
                if(pr.Project__c == project.Id){
                    projectTasks.addAll(pr.Project_Tasks__r);
                }
            }   
            taskWrapperList.add(new TaskWrapperContainer(project, projectTasks));
        }
        Boolean hasTasks = false;
        if(taskWrapperList.size() > 0){
            hasTasks = true;
        }
        return new TaskWrapper(taskWrapperList, hasTasks);
    } 
}