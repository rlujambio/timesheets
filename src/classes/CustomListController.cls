public class CustomListController {
    
    public String filter {get; set;}
    public String whereClause = 'ALL';
    public List<Contact> contacts = new List<Contact>();
    public List<wTimesheet> wrapped = new List<wTimesheet>();
    public Boolean redirect = false;
    

    public List<wTimesheet> getTimesheets() {
        List<Timesheet__c> selected = new List<Timesheet__c>();
        List<wTimesheet> wtimesheets = new List<wTimesheet>();
        String employee = ApexPages.currentPage().getParameters().get('id');
        if (String.isEmpty(employee)){
            
            if (whereClause == 'ALL'){
             selected = Database.query('SELECT Id, Name, Contact__c, Start_Date__c, End_Date__c, Total_Hours__c, Gross_Pay__c, Taxes__c, Type__c, Submitted__c'
                                                    + ' FROM Timesheet__c' + ' LIMIT 10000');
        	}	
            else{
                if (whereClause == 'MOST RECENT'){
                    contacts = [SELECT Id, (SELECT Id, Name, Contact__c, Start_Date__c, End_Date__c, Total_Hours__c, Gross_Pay__c, Taxes__c, Type__c, Submitted__c, CreatedDate
                            FROM Timesheets__r ORDER BY CreatedDate DESC LIMIT 1) FROM Contact LIMIT 10000];
                
                    List<Timesheet__c> temp = new List<Timesheet__c>();
                    for (Contact c : contacts){
                        if(!c.Timesheets__r.isEmpty()){
                            temp.add(c.Timesheets__r);
                        }                
                    }
                    selected = temp;
                }
                else{
                    if(whereClause == 'SUBMITTED'){
                        selected = [SELECT Id, Name, Contact__c, Start_Date__c, End_Date__c, Total_Hours__c, Gross_Pay__c, Taxes__c, Type__c, Submitted__c, CreatedDate
                        FROM Timesheet__c WHERE Submitted__c = true LIMIT 10000];
                    }
                    else{
                        selected = [SELECT Id, Name, Contact__c, Start_Date__c, End_Date__c, Total_Hours__c, Gross_Pay__c, Taxes__c, Type__c, Submitted__c, CreatedDate
                        FROM Timesheet__c WHERE Submitted__c = false LIMIT 10000];
                    }
                }                
            }
        }
        else{
                selected = [SELECT Id, Name, Contact__c, Start_Date__c, End_Date__c, Total_Hours__c, Gross_Pay__c, Taxes__c, Type__c, Submitted__c, CreatedDate
                        FROM Timesheet__c WHERE Contact__c = :employee LIMIT 10000];
            	redirect = true;
            }
        
        for(Timesheet__c t : selected){
            wtimesheets.add(new wTimesheet(t));
        }
        wrapped = wtimesheets;
        return wtimesheets;
    }
    
    public PageReference refresh(){
        if(!redirect){
            if (filter == 'All'){
            	whereClause = 'ALL';            
        	}
        	else{
                if (filter == 'Most Recent'){
                    whereClause = 'MOST RECENT'; 
                }
                else{
                    if (filter == 'Submitted'){
                        whereClause = 'SUBMITTED'; 
                    }
                    else{
                        whereClause = 'NOT SUBMITTED';
                    }                    
                }
            		        
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
    
    public PageReference export(){
        	PageReference pdf = new PageReference('/apex/OrgTimesheetsPDF');
            return pdf;
    }
    
    public PageReference submitTimesheets(){
        List<Timesheet__c> selectedTimesheets = new List<Timesheet__c>();
        for(wTimesheet wts : wrapped){
            if(wts.selected == true){
                wts.ts.Submitted__c = true;
                selectedTimesheets.add(wts.ts);
            }
        }
        wrapped = null;
        update selectedTimesheets;
        return null;
    }
    
    public class wTimesheet{
        public Timesheet__c ts {get; set;}
        public Boolean selected {get; set;}
        
        public wTimesheet(Timesheet__c timesheet){
            ts = timesheet;
            selected = false;
        }
    }

}