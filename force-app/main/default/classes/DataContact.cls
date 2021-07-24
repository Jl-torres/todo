public with sharing class DataContact {
   @AuraEnabled(cacheable=True)
   public static List<Contact> getContacts() {
        return [SELECT Id, Name, Phone, Email  FROM Contact LIMIT 6];
   }
}
