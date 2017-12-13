trigger timesheetTrigger on Timesheet__c (before update, before delete) {
    
    List<Timesheet__c> targetSheets = new List<Timesheet__c>();
    
    if (Trigger.isUpdate){
        for(Timesheet__c t : Trigger.New){
            if(t.Timesheet_Status__c == 'NOT SUBMITTED'){
                targetSheets.add(t);
            }
        }
        if (targetSheets.size() > 0){
            update targetSheets;
        }
    }
    else{
        for(Timesheet__c t : Trigger.Old){
            if(t.Timesheet_Status__c == 'NOT SUBMITTED'){
                targetSheets.add(t);
            }
        }
        if (targetSheets.size() > 0){
            delete targetSheets;
        }
    }
}