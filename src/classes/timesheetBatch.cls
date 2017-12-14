global class timesheetBatch implements Database.Batchable<SObject> {


	global Database.QueryLocator start(Database.BatchableContext BC) {
		String query = 'SELECT Id, Submitted__c, Gross_Pay__c FROM Timesheet__c WHERE (Gross_Pay__c > 5000 AND Submitted__c = false)';
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<Timesheet__c> scope) {
			for(Timesheet__c ts : scope){
				ts.Submitted__c = true;
			}
			update scope;
	}

	global void finish(Database.BatchableContext BC) {

	}
}