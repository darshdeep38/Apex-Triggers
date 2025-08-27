//Set the Account Owner’s Name as the Sales Rep field value when an Account is created


trigger AccountTrigger1 on Account (  before insert ) {
  if(Trigger.isBefore && Trigger.isInsert){
        AccountTriggerHandler.handleBeforeInsertActivities(Trigger.NEW);
        
    }
}

public class AccountTriggerHandler {

    public static void handleBeforeInsertActivities(List<Account> newRecords){
        Map<Id,Id> ownerMap = new Map<Id ,Id>();
        for(Account acc : newRecords){
            ownerMap.put(acc.Id , acc.OwnerId);
        }
        Map<Id ,User>  userRecords = new Map<Id , User> ([select Name from User  where Id in :ownerMap.values()]);
        
        for(Account acc: newRecords){
            acc.Sales_Rep__c = userRecords.get(ownerMap.get(acc.Id)).Name;
        }
        
    }
}
