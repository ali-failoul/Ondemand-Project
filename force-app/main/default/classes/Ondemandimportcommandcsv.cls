public inherited sharing class Ondemandimportcommandcsv {

    @AuraEnabled
    public static list<Task_In_Round__c> readCSVFile(Id idContentDocument){
        list<Task_In_Round__c> lstcommToInsert = new list<Task_In_Round__c>();
        list<Client__c> lstClientoInsert = new list<Client__c>();
        list<Item_Task_In_Round__c> lstItemtoInsert = new list<Item_Task_In_Round__c>();
        if(idContentDocument != null) {
            
            // getting File Data based on document id 
            ContentVersion objVersion = [SELECT Id, VersionData FROM ContentVersion WHERE ContentDocumentId =:idContentDocument];
            // split the file data
            list<String> lstCSVLines = objVersion.VersionData.toString().split('\n');

            try{ 
            for(Integer i = 1; i < lstCSVLines.size(); i++){
                Client__c objclient = new Client__c();
                list<String> csvRowData = lstCSVLines[i].split(',');
                objclient.Name	        = csvRowData[9] ;
                objclient.Street__c	= csvRowData[10] ; 
                objclient.City__c	= csvRowData[11] ;
                objclient.Zip__c	= csvRowData[12] ;
                objclient.Phone__c	= csvRowData[18] ;
                objclient.Email__c	= csvRowData[21] ;
              
              
                lstClientoInsert.add(objclient);
            }

            if(!lstClientoInsert.isEmpty()) {
                insert lstClientoInsert;


            }
            for(Integer i = 1; i < lstCSVLines.size(); i++){
                Task_In_Round__c objTask = new Task_In_Round__c();
                list<String> csvRowData = lstCSVLines[i].split(',');
                Client__c queriedClient  = [SELECT ID FROM Client__c WHERE Name=:csvRowData[9] LIMIT 1];
                ID ClientID = queriedClient.ID;
                Contact queriedContact  = [SELECT ID FROM Contact WHERE LastName=:csvRowData[1] LIMIT 1];
                ID ContactID = queriedContact.ID;

                
                objTask.Client__c	        = ClientID ;
                objTask.Contact__c	= ContactID ; 
                objTask.TaskReference__c	= csvRowData[22] ;

                lstcommToInsert.add(objTask);
            }

            if(!lstcommToInsert.isEmpty()) {
                insert lstcommToInsert;


            }
            for(Integer i = 1; i < lstCSVLines.size(); i++){
                Item_Task_In_Round__c	 objItem = new Item_Task_In_Round__c();
                list<String> csvRowData = lstCSVLines[i].split(',');
                Task_In_Round__c queriedTask  = [SELECT ID FROM Task_In_Round__c WHERE TaskReference__c=:csvRowData[22] LIMIT 1];
                ID TaskID = queriedTask.ID;
                objItem.Task_In_Round__c	        = TaskID ; 
                objItem.Type__c         	= csvRowData[6] ;
                objItem.Quantity__c	= Integer.valueOf(csvRowData[7]) ;
                objItem.status__c	= csvRowData[2] ;
                

              
              
                lstItemtoInsert.add(objItem);
            }

            if(!lstItemtoInsert.isEmpty()) {
                insert lstItemtoInsert;


            }

            

           

             
            
                


                
            }
            catch (Exception ex) {
                throw new AuraHandledException(ex.getMessage());
            } 
        }
        return lstcommToInsert;    
    }
}
