public with sharing class statementeprueba {
    @auraenabled
      public static List<daWrapper> getStatementAcc (String acctId, Date endDate, Date startDate)  {
          DateTime endDatec = (Datetime) endDate;
          DateTime startDatec = (Datetime) startDate;
          String endDatecForm = (EndDate!=null) ? (endDatec.formatGMT('yyyyMMdd')) : null;
          String startDatecForm = (startDate!=null) ? (startDatec.formatGMT('yyyyMMdd')) : null;
          
          if ((startDatecForm != null) && (endDatecForm == null)) {
              Date currentDate = system.today();
              Datetime currentDatec = (Datetime) currentDate;
              endDatecForm = currentDatec.formatGMT('yyyyMMdd');
          }
          
          System.debug('ejecutando StatementAccController - ' + acctId + '/' + startDatecForm + '/' + endDatecForm);
          List<Network> networks  = [SELECT Id, Name, UrlPathPrefix, Description, Status, FirstActivationDate FROM Network where Status = 'Live'];
          System.debug('urlCommun2: ' + URL.getSalesforceBaseUrl().toExternalForm());
          String urlCurrent = URL.getSalesforceBaseUrl().toExternalForm();
          boolean isCommun = false;
          String urlPathPrefix = null;
          for (Network ne:networks) {
              String urlSite = Network.getLoginUrl(ne.Id);
              isCommun = urlSite.contains(urlCurrent);
              urlPathPrefix = ne.UrlPathPrefix;
              break;
          }
          
          
          Account accCons = [Select Id, ExternalId__c, Owner.Profile.Name from Account where Id = : acctId];
          
          String codSap = accCons.ExternalId__c;
          String profileName = accCons.Owner.Profile.Name; 
          Map<String, Object> mapObjects= DataChangeEndPoint.getStamentAccount(codSap, endDatecForm, startDatecForm);
          
          List<Object> listObjects = (List<Object>) mapObjects.get('Details');
          Decimal AccountBalance = (Decimal) mapObjects.get('AccountBalance');
          AccountBalance = AccountBalance.setScale(2);
          Decimal amountPendingOrder = 0;
          Decimal totalTBmAP = 0;
          List<daWrapper> listCurrent = new List<daWrapper>();
          Integer i = 0;
          
          for(Object fieldAccBal : listObjects) {
              Map<String, Object> rcRow = (Map<String, Object>)fieldAccBal;
              String docCode = String.valueOf(rcRow.get('DocCode'));
              String docDescription =  String.valueOf(rcRow.get('DocDescription'));
              String docNumber = String.valueOf(rcRow.get('DocNumber'));
              String docEntry = String.valueOf(rcRow.get('DocEntry'));
              double totalAmount = Double.valueOf(rcRow.get('TotalAmount'));
              double openAmount = Double.valueOf(rcRow.get('OpenAmount'));
              Date DocDate = convertirFecha(String.valueOf(rcRow.get('DocDate')));
              String urlObjet = generateUrlOrder(docNumber, isCommun, urlPathPrefix);
              if (docCode.equals('17')) {
                 amountPendingOrder = amountPendingOrder + openAmount;
              }
  
              daWrapper da = new daWrapper(docCode, docDescription, docNumber, docEntry, totalAmount, openAmount, DocDate, AccountBalance, urlObjet, 0, 0);
              listCurrent.add(da);
              
          }
          
          totalTBmAP = AccountBalance - amountPendingOrder;
          
          for (daWrapper ob : listCurrent) {
              ob.totalPendOrder = amountPendingOrder.setScale(2);
              ob.totalView = totalTBmAP.setScale(2);
          }
  
          System.debug('ejecutando controller' +  listCurrent.size());
          System.debug('amountPendingOrder: ' + amountPendingOrder + ' / ' + totalTBmAP);
          return listCurrent;
          
      }
      
      public static Date convertirFecha(string fechaString) {
          Integer year = Integer.valueof(fechaString.substring(0,4));
          Integer month = Integer.valueof(fechaString.substring(4,6));
          Integer day = Integer.valueof(fechaString.substring(6,8));
          Date dateconvert = Date.newInstance(year,month,day);
          System.debug('Fecha convertida ' + dateconvert);
          return dateconvert;
      }
      
      public class daWrapper{
          
          @AuraEnabled
          public string DocCode {get; set;}
          @AuraEnabled
          public string DocDescription {get; set;}
          @AuraEnabled
          public string DocNumber {get; set;}                
          @AuraEnabled
          public string DocEntry {get; set;}      
          @AuraEnabled
          public Double TotalAmount {get; set;} 
          @AuraEnabled
          public Double OpenAmount {get; set;} 
          @AuraEnabled
          public string SFCode {get; set;} 
          @AuraEnabled
          public Date DocDate {get; set;}
          @AuraEnabled
          public Decimal AccountBalance {get; set;}
          @AuraEnabled
          public string urlObject {get; set;}
          @AuraEnabled
          public Double totalPendOrder {get; set;}
          @AuraEnabled
          public Double totalView {get; set;}
          
          public daWrapper (String DocCodeVar, String DocDescriptionVar, String DocNumberVar, string DocEntryVar, Double TotalAmountVar, Double OpenAmountVar, Date DocDateVar, Decimal AccountBalanceVar, string urlObjectVar, Double totalPendOrderVar, Double totalViewVar) {
              
              DocCode = DocCodeVar;
              DocDescription = DocDescriptionVar;
              DocNumber = DocNumberVar;
              DocEntry = DocEntryVar;
              TotalAmount = TotalAmountVar;
              OpenAmount = OpenAmountVar;
              DocDate = DocDateVar;
              AccountBalance = AccountBalanceVar;
              urlObject = urlObjectVar;
              totalPendOrder = totalPendOrderVar;
              totalView = totalViewVar;
          }
      }
      
      public static String generateUrlOrder(String externalId, boolean isCommun, String urlPrefix) {
          List<order> listOrderConsul = [select Id from order where ExternalId__c = : externalId];
          String resultUrl = 'No';
          if (listOrderConsul.size() > 0) {
              if (isCommun) {
                  resultUrl = URL.getSalesforceBaseUrl().toExternalForm()+ '/' + urlPrefix +'/s/order/' + listOrderConsul[0].Id + '/detail';
              } else {
                  resultUrl = URL.getSalesforceBaseUrl().toExternalForm()+ '/'+ listOrderConsul[0].Id; 
                  
              }
          }
          
          return resultUrl;
      }
}
