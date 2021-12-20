public without sharing class FileUploadService {
//Cargar varios archivos
    @AuraEnabled
    public static void uploadFiles( String filesData) {
      List<Documents> filesDataList = (List<Documents>) JSON.deserialize(filesData, List<Documents>.class);
      list<ContentVersion> resp = createContentVersions(filesDataList);
      //System.debug(resp);
      }

    private static list<ContentVersion> createContentVersions( List<Documents> filesDataList) {
      list<ContentVersion> filesDataListToInsert = new list<ContentVersion>();
       for (Documents file : filesDataList) {
            ContentVersion cv = new ContentVersion();
            cv.VersionData = EncodingUtil.base64Decode(file.base64);
            cv.Title = file.filename;
            cv.PathOnClient = file.filename;
            filesDataListToInsert.add(cv); 
        }
        insert filesDataListToInsert; 
        
        set<id> Setcv_id = new set<id>();
        for (ContentVersion  FilesInsert: filesDataListToInsert) {
          Setcv_id.add(FilesInsert.id); 
        }

        //System.debug(Setcv_id);
        case Caso = [SELECT Id, CaseNumber, SuppliedName FROM Case limit 1];

       //Content Document Link
       list<ContentVersion> conVer = [select id,ContentDocumentId from ContentVersion where id IN :Setcv_id ]; 
       system.debug(conVer); 
       list<ContentDocumentLink> cDe = new list<ContentDocumentLink>(); 

       for (ContentVersion id_Cv : conVer) {
        ContentDocumentLink relacion = new ContentDocumentLink();
        relacion.ContentDocumentId = id_Cv.ContentDocumentId; //[SELECT ID, ContentDocumentId FROM ContentVersion WHERE Id =: id_Cv.id].ContentDocumentId;
        relacion.LinkedEntityId = Caso.Id; 
        relacion.ShareType = 'V';  
        cDe.add(relacion); 
       }
       //system.debug(cDe.size + 'tamaño'); 
       insert cDe ;
        system.debug(cDe); 

        return filesDataListToInsert;
        
      }

      public class Documents {        
        @AuraEnabled
        public String filename;
        @AuraEnabled
        public String base64;
        @AuraEnabled
        public String recordId;
        @AuraEnabled
        public String id;     
      }

    //Cargar un solo archivo
    @AuraEnabled
    public static ContentVersion uploadFile(String base64, String filename, id recordId) {
        ContentVersion c_v = createContentVersion(base64, filename, recordId);
        if (c_v == null ) { return null; } 
        return c_v;
      }


    private static ContentVersion createContentVersion(String base64, String filename, id recordId) {
        ContentVersion conVer = new ContentVersion();
        conVer.VersionData = EncodingUtil.base64Decode(base64);
        conVer.Title = filename;
        conVer.PathOnClient = filename;
        insert conVer;

        case Caso = [SELECT Id, CaseNumber, SuppliedName FROM Case limit 1];

          ContentVersion Content_V =  [select id,ContentDocumentId from ContentVersion where id =: conVer.id];            
          ContentDocumentLink cDe = new ContentDocumentLink();
          cDe.ContentDocumentId = [SELECT ID, ContentDocumentId FROM ContentVersion WHERE Id =: Content_V.Id].ContentDocumentId;
          cDe.LinkedEntityId = Caso.Id; 
          cDe.ShareType = 'V'; 
          insert cDe ;

          System.debug('cDe');
          System.debug(cDe);

         return conVer;
      }

      private static ContentDocumentLink createContentLink(String contentVersionId, String recordId) {
        if (contentVersionId == null || recordId == null) { return null; }
            ContentDocumentLink cdl = new ContentDocumentLink();
            cdl.ContentDocumentId = [
                SELECT ContentDocumentId 
                FROM ContentVersion 
                WHERE Id =: contentVersionId].ContentDocumentId;

            cdl.LinkedEntityId = recordId;
          
            cdl.ShareType = 'V';
                try {
                    insert cdl;
                    return cdl;
                 } catch(DMLException e) {
                    System.debug(e);
                    return null;
                }
}    
        
}


