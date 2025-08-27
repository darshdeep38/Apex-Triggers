// When an account record is restored from the bin, update its name, prefix it with “Restored” keyword

//AccountTriggerHandler.apxc
 public class AccountTriggerHandler {
    
    public static void handleAfterUndelete(List<Account> newRecords){
        List<Id> accIds = new List<Id>();
        List<Account> accToUpdate = new List<Account>();
        for( Account acc : newRecords){
            accIds.add(acc.Id);
        }
        
        List<Account> accountsToUpdate = [Select Id , Name from Account where id  in : accIds];
        for(Account acc: accountsToUpdate){
            acc.Name = 'Restored ' + acc.Name;
            accToUpdate.add(acc);
        }
        if(!accToUpdate.isEmpty()){
            update accToUpdate;
        }
  }      
        
    }


//AccountTrigger1.apxt
trigger AccountTrigger1 on Account (after update , after undelete ) {
    if(Trigger.isAfter && Trigger.isUndelete ){
        AccountTriggerHandler.handleAfterUndelete(Trigger.NEW);
    }
}
