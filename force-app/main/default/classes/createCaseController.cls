public without sharing class createCaseController {
    @AuraEnabled
    public static string createCase(case objCase , contact objContact ) {

      insert objContact;
      
      objCase.ContactId = objContact.id;
      insert objCase;

      return objCase.id;

    }

    
    

    
}


/*case cs = new case ();
cs.supliedname = objcase.supliedname;
cs.origin = objcase.origin;
insert cs

public class OBJFormularioAfectado {        
      @AuraEnabled
      public String name;
      @AuraEnabled
      public String apellido; 
    }

*/
