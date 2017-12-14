trigger timesheetTrigger on Timesheet__c (before update, before delete) {
    
    List<Timesheet__c> targetSheets = new List<Timesheet__c>();
    
    if (Trigger.isUpdate){
        for(Timesheet__c t : Trigger.Old){
            if(t.Submitted__c == true){
                Trigger.newMap.get(t.Id).addError('Cannot update an already submitted Timesheet');
            }
        }

    }
    else{
        for(Timesheet__c t : Trigger.Old){
            if(t.Submitted__c == true){
                t.addError('Cannot delete an already submitted Timesheet');
            }
        }
    }
}