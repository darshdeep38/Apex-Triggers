// As soon as Opportunity is Closed Lost, remove all Opportunity Team Members from the Opportunity
//OpportunityTrigger.apxt
trigger OpportunityTrigger on Opportunity (after  update) {
    OpportunityTriggerhandler.handleActivitiesAfterUpdate(Trigger.NEW);
}

//OpportunityTriggerhandler.apxc
public class OpportunityTriggerhandler {
  
    public static void handleActivitiesAfterUpdate(List<Opportunity> newRecords){
        List<Task>  taskListToInsert = new List<Task>();
        List<Id> ListOfOppIds = new List<Id>();
        List<OpportunityTeamMember> deleteMemberList =  new List<OpportunityTeamMember>();
        for( Opportunity opp : newRecords){
        ListOfOppIds.add(opp.Id);

        }

        List<OpportunityTeamMember> teamMembers = [Select id ,OpportunityId from OpportunityTeamMember where OpportunityId IN :ListOfOppIds];      
  for( Opportunity opp : newRecords){
               if(opp.StageName == 'Closed Won'){
                   Task taskRecord = new Task();
                   taskRecord.Priority = 'High';
                   taskRecord.OwnerId = opp.OwnerId;
                   taskRecord.Description = 'Please split the revenue into team members';
                   taskRecord.Status = 'Not Started';
                   taskRecord.Subject = 'Split Revenue';
                   taskRecord.WhatId = opp.Id;
                   taskListToInsert.add(taskRecord);
               }
               
               else if (opp.StageName == 'Closed Lost'){
                   for(OpportunityTeamMember teamMember : teamMembers){
                       if(teamMember.OpportunityId == opp.Id ){
                            deleteMemberList.add(teamMember);
                       }
                   }
               }
        
    }

    if(!deleteMemberList.isEmpty()){
            delete deleteMemberList;
        }
    }


