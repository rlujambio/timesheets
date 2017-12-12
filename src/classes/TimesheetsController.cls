public class TimesheetsController {

    public Timesheet__c timesheet;
    public String ts {get; set;}

    
    public Timesheet__c getTimesheet(){
        if (ApexPages.currentPage().getParameters().get('id') != null){
            
            timesheet = [SELECT Id, Contact__c, Start_Date__c, End_Date__c, Type__c, Type_Details__c, Monday__c, Tuesday__c, Wednesday__c,
                    Thursday__c, Friday__c, Hour_Rate__c, Gross_Pay__c, Taxes__c, Comments__c, Submitted__c, Timesheet_Status__c 
                    FROM Timesheet__c WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
            
            ts = timesheet.Type__c;
        }
        else{
            timesheet = new Timesheet__c();
            ts = 'Regular';
        }   
			return timesheet;        
    }
    
    public void save(){
        insert timesheet;
    }    
}