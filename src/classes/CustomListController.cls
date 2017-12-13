public class CustomListController {
    
    public String filter {get; set;}
    public String whereClause = 'ALL';
    public List<Contact> contacts = new List<Contact>();
    public Boolean redirect = false;
    

    public List<Timesheet__c> getTimesheets() {
        List<Timesheet__c> selected = new List<Timesheet__c>();
        String employee = ApexPages.currentPage().getParameters().get('id');
        if (String.isEmpty(employee)){
            
            if (whereClause == 'ALL'){
             selected = Database.query('SELECT Id, Name, Contact__c, Start_Date__c, End_Date__c, Total_Hours__c, Gross_Pay__c, Taxes__c, Type__c, Submitted__c'
                                                    + ' FROM Timesheet__c');
        	}	
            else{
                contacts = [SELECT Id, (SELECT Id, Name, Contact__c, Start_Date__c, End_Date__c, Total_Hours__c, Gross_Pay__c, Taxes__c, Type__c, Submitted__c, CreatedDate
                            FROM Timesheets__r ORDER BY CreatedDate DESC LIMIT 1) FROM Contact];
                
                List<Timesheet__c> temp = new List<Timesheet__c>();
                for (Contact c : contacts){
                    if(!c.Timesheets__r.isEmpty()){
                        temp.add(c.Timesheets__r);
                    }                
                }
                selected = temp;
            }
        }
        else{
                selected = [SELECT Id, Name, Contact__c, Start_Date__c, End_Date__c, Total_Hours__c, Gross_Pay__c, Taxes__c, Type__c, Submitted__c, CreatedDate
                        FROM Timesheet__c WHERE Contact__c = :employee];
            	redirect = true;
            }           
        
        return selected;
    }
    
    public PageReference refresh(){
        if(!redirect){
            if (filter == 'All'){
            	whereClause = 'ALL';            
        	}
        	else{
            	whereClause = 'MOST RECENT';         
        	}
            return null;
        }
        else{
            redirect = false;
            PageReference index = new PageReference('/one/one.app#/n/Employee_s_Timesheets');
            index.setRedirect(true);
            return index;
        }
        
    }

}