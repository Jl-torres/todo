public with sharing class GetCase {
    @AuraEnabled(cacheable=true)
   public static Case[] GetCaseByNumber( String caso_n , String LastName   ) {
         
    Case[] query = [
                      SELECT Id, CaseNumber , Contact.name 
                      FROM Case 
                      WHERE CaseNumber = :caso_n
                      AND Contact.lastname = :LastName                       
                      ];

       return query ;
   }   

   @AuraEnabled 
   public static Boolean savefile(CaseComment vfile){
       try{
           insert vfile;
           //system.debug('caseNumber '+ objCaseComment.id);
           return true;
       }
       catch(Exception ex) {
           throw new AuraHandledException(ex.getMessage());
       }
   }
}

/*
SELECT Subject, Description, Status, CreatedDate, ClosedDate, CaseNumber 
FROM Case WHERE CaseNumber = '5000b00001a9CmNAAU' AND OR id ='5000b00001a9CmNAAU' 
*/

/*   Insertar con una relacion
      account acct = new account();
                acct.Name = 'cuenta asociada a un caso';
                insert acct;

                objcase.AccountId=acct.id
                insert objCase

                objCase.add(AccountId : acct.id);  
                System.debug(objCase);
                system.debug( acct.id );    
                case caso = new case();

                caso.SuppliedEmail='emailConCuenta@test004.com';
                caso.AccountId = acct.id;
      
                insert caso;
            
                system.debug('test con cuenta '+ caso.id );*/




