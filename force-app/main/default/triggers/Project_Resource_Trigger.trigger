trigger Project_Resource_Trigger on Project_Resource__c (after insert, after update, after delete) {
    if((Trigger.isUpdate || Trigger.isInsert) && Trigger.isAfter){
        Project_Resource_Helper.updateCompletedHours(Trigger.new);
    }
    if(Trigger.isDelete && Trigger.isAfter){
        Project_Resource_Helper.updateCompletedHours(Trigger.old);
    }
}