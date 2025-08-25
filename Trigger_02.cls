// Do not allow contact creation if a contact already exists with the same last name, email & phone

// ContactTrigger.apxt
trigger ContactTrigger on Contact (before insert) {
    if(Trigger.isInsert && Trigger.isBefore){
        ContactTriggerHandler.handleBeforeInsert(Trigger.NEW);
    }
}

//ContactTriggerHandler.apxc
public class ContactTriggerHandler {

    public static  void handleBeforeInsert(List<Contact> newRecords ){
        List<Contact> existingRecords = [SELECT Id, LastName , Email , Phone From Contact Limit 5000];
  
        for(Contact con : newRecords){
            for(Contact existingCon : existingRecords){
                if(con.LastName == existingCon.LastName && con.Email == existingCon.Email && con.Phone == existingCon.LastName) {
                    con.addError('Duplicate Found ');
                }
            }
        }
        
        
    }
}
