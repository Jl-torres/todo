public with sharing class ApexDateProbando {
      
        @future (callout=true)
        public static  void  CreateClientBO(string jsons, Id idAccount, String method) {
            
            try {
                String mainUrl = 'callout:urlac';
                //String endpoint = 'https://servicesbus.aquacristalina.com:9010/BusinessPartners'; //'callout:boatyard';
                String endpoint = mainUrl + '/BusinessPartners';
                System.debug('EndPoint: ' + endpoint);
                HttpRequest req = new HttpRequest();
                req.setHeader('Content-Type', 'application/json');
                req.setEndpoint(endpoint);
                req.setMethod(method);
                req.setbody(jsons);
                Http http = new Http();
                
                req.setTimeout(120000);
                HTTPResponse response = http.send(req);
                if(response.getStatusCode() == 200) {
                    
                    Map<String, Object> valueMetaBom = (Map<String, Object>) JSON.deserializeUntyped(response.getBody()); 
                    Object result =  valueMetaBom.get('Result');
                    Map<String, Object> resultMap =  (Map<String, Object>) result;
                    String SAPCardCode = (String)resultMap.get('SAPCardCode');
                    System.debug('SAPCardCode **** ' + SAPCardCode);
                    
                    Account account = New Account();
                    account.Id = idAccount;
                    // if (method.equals('POST')) {
                    account.ExternalId__c = SAPCardCode;
                    // } 
                    account.Resultado_de_Integraci_n__c = '1';
                    account.Mensaje_Integraci_n__c = null;
                    update account; 
                    
                    System.debug(' Actualizada la cuenta ' + idAccount + ', con el codigo SAP : ' + SAPCardCode); 
                    System.debug(' Response Status : ' + response); 
                    System.debug(' Response JSON : ' + response.getBody());  
                    
                } else {
                    IntegrationLog integrationLog = new IntegrationLog();
                    integrationLog.createRegister(method, 'Account', response.getBody(), idAccount, jsons);                   
                    Map<String, Object> MapMes = (Map<String, Object>) JSON.deserializeUntyped(response.getBody()); 
                    Object result =  MapMes.get('ResponseObject');
                    Map<String, Object> resultMap =  (Map<String, Object>) result;
                    String msg = (String)resultMap.get('Message');
                    
                    Account acc = new Account();
                    acc.Id = idAccount;
                    acc.Mensaje_Integraci_n__c = msg;
                    acc.Resultado_de_Integraci_n__c = '0';
                    update acc;
                    
                    System.debug(' Failed transaction, Response: ' + response); 
                    System.debug(' Failed transaction, Response detail: ' + response.getBody()); 
                    
                }
                
            }  catch(exception e) { 
                System.debug('Callout error: '+ e); 
                String msg = e.getMessage();
                IntegrationLog integrationLog = new IntegrationLog();
                integrationLog.createRegister(method, 'Account', msg, idAccount, jsons);
                Account acc = new Account();
                acc.Id = idAccount;
                acc.Mensaje_Integraci_n__c = msg;
                acc.Resultado_de_Integraci_n__c = '0';
                update acc;
            }
        }
        
        @future (callout=true)
        public static  void  CreateAddressContactB1(string jsons, Id contId, String method, String objectName) {    
            
            try {
                String mainUrl = 'callout:urlac';
                //String endpoint = 'https://servicesbus.aquacristalina.com:9010/BusinessPartners'; //'callout:boatyard';
                String endpoint = mainUrl + '/BusinessPartners';
                System.debug('EndPoint: ' + endpoint);
                HttpRequest req = new HttpRequest();
                req.setHeader('Content-Type', 'application/json');
                req.setEndpoint(endpoint);
                req.setMethod(method);
                req.setbody(jsons);
                Http http = new Http();
                req.setTimeout(120000);
                HTTPResponse response = http.send(req); 
                if(response.getStatusCode() == 200) {
                    Map<String, Object> valueMetaBom = (Map<String, Object>) JSON.deserializeUntyped(response.getBody()); 
                    Object result =  valueMetaBom.get('Result');
                    Map<String, Object> resultMap =  (Map<String, Object>) result;
                    String SAPCardCode = (String)resultMap.get('SAPCardCode');
                    System.debug(' Actualizada la Dirección/Contacto de la cuenta con el codigo SAP : ' + SAPCardCode); 
                    System.debug(' Response Status : ' + response); 
                    System.debug(' Response JSON : ' + response.getBody());                     
                    if (objectName.equals('Contact')) {
                        Contact contact = new Contact();
                        contact.Id = contId;
                        contact.Resultado_de_Integraci_n__c = '1';
                        contact.Mensaje_Integraci_n__c = null;
                        update contact;
                    } else if (objectName.equals('Direccion')) {
                        Direcciones__c direccion = new Direcciones__c();
                        direccion.Id = contId;
                        direccion.Resultado_de_Integraci_n__c = '1';
                        direccion.Mensaje_Integraci_n__c = null;
                        update direccion;
                    }
                } else { 
                    IntegrationLog integrationLog = new IntegrationLog();
                    integrationLog.createRegister(method, objectName, response.getBody(), contId, jsons);
                    System.debug(' Se genera error al actualizar la dirección o contacto *** '); 
                    Map<String, Object> MapMes = (Map<String, Object>) JSON.deserializeUntyped(response.getBody()); 
                    Object result =  MapMes.get('ResponseObject');
                    Map<String, Object> resultMap =  (Map<String, Object>) result;
                    String msg = (String)resultMap.get('Message');
                    
                    if (objectName.equals('Contact')) {
                        Contact contact = new Contact();
                        contact.Id = contId;
                        contact.Resultado_de_Integraci_n__c = '0';
                        contact.Mensaje_Integraci_n__c = msg;
                        update contact;
                    } else if (objectName.equals('Direccion')) {
                        Direcciones__c direccion = new Direcciones__c();
                        direccion.Id = contId;
                        direccion.Resultado_de_Integraci_n__c = '0';
                        direccion.Mensaje_Integraci_n__c = msg;
                        update direccion; 
                    }
                    
                    System.debug(' Failed transaction, Response: ' + response); 
                    System.debug(' Failed transaction, Response detail: ' + response.getBody()); 
                }
                
            }  catch(exception e) {
                System.debug('Callout errorx: '+ e); 
                String msg = e.getMessage();
                IntegrationLog integrationLog = new IntegrationLog();
                integrationLog.createRegister(method, objectName, msg, contId, jsons);
                
               if (objectName.equals('Contact')) {
                        Contact contact = new Contact();
                        contact.Id = contId;
                        contact.Resultado_de_Integraci_n__c = '0';
                        contact.Mensaje_Integraci_n__c = msg;
                        update contact;
                    } else if (objectName.equals('Direccion')) {
                        Direcciones__c direccion = new Direcciones__c();
                        direccion.Id = contId;
                        direccion.Resultado_de_Integraci_n__c = '0';
                        direccion.Mensaje_Integraci_n__c = msg;
                        update direccion;
                    } 
            }
        }
        
        @future (callout=true)
        public static  void  CreateOrderInvoiceB1(string jsons, Id idOrder) {
            
            try {
                String mainUrl = 'callout:urlac';
                //String endpoint = 'https://servicesbus.aquacristalina.com:9010/Documents';
                String endpoint = mainUrl + '/Documents';
                System.debug('EndPoint: ' + endpoint);
                HttpRequest req = new HttpRequest();
                req.setHeader('Content-Type', 'application/json');
                req.setEndpoint(endpoint);
                req.setMethod('POST');
                req.setbody(jsons);
                req.setTimeout(120000);
                Http http = new Http();
                
                HTTPResponse response = http.send(req); 
                if(response.getStatusCode() == 200) {
                    Map<String, Object> valueMetaBom = (Map<String, Object>) JSON.deserializeUntyped(response.getBody()); 
                    Object result =  valueMetaBom.get('Result');
                    Map<String, Object> resultMap =  (Map<String, Object>) result;
                    String SAPDocNum = String.valueOf(resultMap.get('SAPDocNum'));
                    String SAPDOCENTRY = String.valueOf(resultMap.get('SAPDocEntry'));
                    System.debug(' Create Order with code SAP : ' + SAPDocNum); 
                    System.debug(' Create Order with code SAPDocEntry : ' + SAPDOCENTRY); 
                    System.debug(' Response Status : ' + response); 
                    System.debug(' Response JSON : ' + response.getBody()); 
                    
                    Order ord = New Order();
                    ord.Id = idOrder;
                    ord.ExternalId__c = SAPDocNum;
                    ord.SAPDOCENTRY__c = SAPDOCENTRY;
                    ord.Resultado_de_Integraci_n__c = '1';
                    ord.Mensaje_Integraci_n__c = null;
                    update ord;                     
                    
                } else {
                    IntegrationLog integrationLog = new IntegrationLog();
                    integrationLog.createRegister('POST', 'Order', response.getBody(), idOrder, jsons);
                    
                    Map<String, Object> MapMes = (Map<String, Object>) JSON.deserializeUntyped(response.getBody()); 
                    Object result =  MapMes.get('ResponseObject');
                    Map<String, Object> resultMap =  (Map<String, Object>) result;
                    String msg = (String)resultMap.get('Message');
                    
                    Order ord = New Order();
                    ord.Id = idOrder;
                    ord.Resultado_de_Integraci_n__c = '0';
                    ord.Mensaje_Integraci_n__c = msg;
                    update ord;
                    System.debug('Error enviando el pedido  ');    
                    System.debug(' Failed transaction, Response: ' + response); 
                    System.debug(' Failed transaction, Response detail: ' + response.getBody()); 
                }
                
            }  catch(exception e) {
                System.debug('Callout error: '+ e); 
                String msg = e.getMessage();
                IntegrationLog integrationLog = new IntegrationLog();
                integrationLog.createRegister('POST', 'Order', msg, idOrder, jsons); 
                
                Order ord = New Order();
                ord.Id = idOrder;
                ord.Resultado_de_Integraci_n__c = '0';
                ord.Mensaje_Integraci_n__c = msg;
                update ord;
                System.debug('Error enviando el pedido '); 
            }
            
        }
        
        
        @future (callout=true)
        public static  void  generatePaymentB1(string jsons, Id idOrder) {
            
            try {
                String mainUrl = 'callout:urlac';
                //String endpoint = 'https://servicesbus.aquacristalina.com:9010/Payments';
                String endpoint = mainUrl + '/Payments';
                System.debug('EndPoint: ' + endpoint);
                HttpRequest req = new HttpRequest();
                req.setHeader('Content-Type', 'application/json');
                req.setEndpoint(endpoint);
                req.setMethod('POST');
                req.setbody(jsons);
                req.setTimeout(120000);
                Http http = new Http();
                System.debug(' Ejecutando pago por puntos a B1 (DataChangeEndPoint.generatePaymentB1)');
                HttpResponse response = new HttpResponse();
                response = http.send(req); 
                
                if(response.getStatusCode() == 200) {
                    
                    Map<String, Object> valueMetaBom = (Map<String, Object>) JSON.deserializeUntyped(response.getBody()); 
                    Object result =  valueMetaBom.get('Result');
                    Map<String, Object> resultMap =  (Map<String, Object>) result;
                    String SAPDocNum = String.valueOf(resultMap.get('SAPDocNum'));
                    System.debug(' Create Payment with code SAP : ' + SAPDocNum); 
                    System.debug(' Response Status : ' + response); 
                    System.debug(' Response JSON : ' + response.getBody()); 
                    
                    Order ord = New Order();
                    ord.Id = idOrder;
                    ord.C_digo_Pago_Ptos_SAP__c = SAPDocNum;
                    ord.Resultado_de_Integraci_n_Pago_por_Puntos__c = '1';
                    ord.Mensaje_Integraci_n_Pago_por_Puntos__c = null;
                    //ord.Resultado_de_Integraci_n__c = '1';
                   // ord.Mensaje_Integraci_n__c = null;
                    ord.Jsonpayment__c = jsons;
                    update ord; 
                    
                    System.debug(' Response JSON : Fue enviado el pago por puntos a B1 ');                 
                    
                } else {
                    IntegrationLog integrationLog = new IntegrationLog();
                    integrationLog.createRegister('POST', 'OrderPayment', response.getBody(), idOrder, jsons);
                    
                    Map<String, Object> MapMes = (Map<String, Object>) JSON.deserializeUntyped(response.getBody()); 
                    Object result =  MapMes.get('ResponseObject');
                    Map<String, Object> resultMap =  (Map<String, Object>) result;
                    String msg = (String)resultMap.get('Message');
                    System.debug(' Error enviando el pago de pedido  ' + idOrder + ': ' + msg);    
                    Order ord = New Order();
                    ord.Id = idOrder;
                    ord.Resultado_de_Integraci_n_Pago_por_Puntos__c = '0';
                    ord.Mensaje_Integraci_n_Pago_por_Puntos__c = msg;
                    //ord.Resultado_de_Integraci_n__c = '0';
                    //ord.Mensaje_Integraci_n__c = 'OrderPayment: ' + msg;
                    ord.Jsonpayment__c = jsons;
                    update ord;
                    System.debug(' Error enviando el pago de pedido  ');    
                    System.debug(' Failed transaction (DataChangeEndPoint.generatePaymentB1), Response: ' + response); 
                    System.debug(' Failed transaction generatePaymentB1, Response detail: ' + response.getBody()); 
                }
                
            } 
            catch(exception e) {
                System.debug('Callout error: '+ e); 
                String msg = e.getMessage();
                IntegrationLog integrationLog = new IntegrationLog();
                integrationLog.createRegister('POST', 'OrderPayment', msg, idOrder, jsons); 
                
                Order ord = New Order();
                ord.Id = idOrder;
                ord.Resultado_de_Integraci_n_Pago_por_Puntos__c = '0';
                ord.Mensaje_Integraci_n_Pago_por_Puntos__c = msg;
                ord.Jsonpayment__c = jsons;
                //ord.Resultado_de_Integraci_n__c = '0';
                //ord.Mensaje_Integraci_n__c = 'OrderPayment: ' + msg;
                update ord;
                
                System.debug('Error enviando pago del pedido ' + msg); 
            }
            
        }
        
        @future (callout = true)
        public static  void  getSpecialPrice(string cardCodeClient, String itemCode, Integer quantity, Date dateCurrent, Id idOrderItem) {
            try { 
                DateTime DocDate = (Datetime) dateCurrent;
                String DocDateForm = DocDate.format('yyyyMMdd');
                itemCode = EncodingUtil.urlEncode(itemCode, 'UTF-8');
                String mainUrl = 'callout:urlac';
                //String endpoint = 'https://servicesbus.aquacristalina.com:9010/Prices';
                String endpoint = mainUrl + '/Prices';
                endpoint = endpoint + '/' + cardCodeClient + '/' + itemCode + '/' + quantity + '/' + DocDateForm;
                System.debug('EndPont: ' + endpoint);
                HttpRequest req = new HttpRequest();
                req.setHeader('Content-Type', 'application/json');
                // req.setHeader('ACCEPT','application/xml');
                req.setEndpoint(endpoint);
                req.setMethod('GET');
                Http http = new Http();
                
                req.setTimeout(120000);
                HTTPResponse response = http.send(req); 
                System.debug(' Buscando precio especial en B1, para el codigo de producto ' + itemCode + ' msg '+  response);    
                if(response.getStatusCode() == 200) {
                    System.debug(' Respuesta B1: ' + response);    
                    Map<String, Object> valueMetaBom = (Map<String, Object>) JSON.deserializeUntyped(response.getBody()); 
                    Object result =  valueMetaBom.get('SpecialPrice');
                    Map<String, Object> resultMap =  (Map<String, Object>) result;
                    Decimal specialPrice = (Decimal) resultMap.get('SpecialPrice');
                    OrderItem ordi = new OrderItem();
                    ordi.Id = idOrderItem;
                    ordi.UnitPrice = specialPrice;
                    ordi.Verifico_Precio_Especial__c = true;
                    update ordi;
                    System.debug('Actualizado el producto ' + itemCode + ', con el precio especial ' + specialPrice);
                    
                } else {
                    OrderItem ordi = new OrderItem();
                    ordi.Id = idOrderItem;
                    ordi.Verifico_Precio_Especial__c = true;
                    update ordi;
                    
                    System.debug(' Failed transaction (DataChangeEndPoint.getSpecialPrice), Response: ' + response); 
                    System.debug(' Failed transaction (DataChangeEndPoint.getSpecialPrice), Response detail: ' + response.getBody()); 
                }          
                
            } 
            catch(exception e) {
                System.debug('Callout error: '+ e); 
            }
        }
        
        //       @future (callout = true)
        public static Map<String, Object>  getStamentAccount(string CardCode, String endDate, String startDate) {       
            try { 
                String mainUrl = 'callout:urlac';
                String endpoint;
                string finalEndPont = (endDate != null) ? ('/' + endDate + ((startDate!=null) ? ('/' + startDate): '')):'';
                endpoint = mainUrl + '/BusinessPartners/AccountBalance/' + CardCode + finalEndPont;    
                // if ((endDate!=null) && (startDate!=null)) {
                //     endpoint = mainUrl + '/BusinessPartners/AccountBalance/' + CardCode + '/' + endDate + '/' + startDate;  
                //  } else {
                //     endpoint = mainUrl + '/BusinessPartners/AccountBalance/' + CardCode;    
                //  }
                
                System.debug('EndPoint: ' + endpoint);
                HttpRequest req = new HttpRequest();
                req.setHeader('Content-Type', 'application/json');
                req.setEndpoint(endpoint);
                req.setMethod('GET');
                Http http = new Http();
                
                req.setTimeout(120000);
                HTTPResponse response = http.send(req); 
                //          System.debug(' Respuesta del estado de cuenta del cliente ' + CardCode + ', msg:  ' +  response);   
                
                if(response.getStatusCode() == 200) {
                    //                String jsonPrueba = '{"UniqueId":"","TimeStamp":"","AccountBalance":5.0,"Details":[{"DocCode":"A1","DocDescription":"B1","DocNumber":"53091","DocEntry":"D1","TotalAmount":"1.0","OpenAmount":"2.0","SFCode":"X1","DocDate":"20210720"},{"DocCode":"A2","DocDescription":"B2","DocNumber":"C2","DocEntry":"D2","TotalAmount":"3.0","OpenAmount":"4.0","SFCode":"X2","DocDate":"20210720"},{"DocCode":"A3","DocDescription":"B3","DocNumber":"C3","DocEntry":"D3","TotalAmount":"5.0","OpenAmount":"6.0","SFCode":"X3","DocDate":"20210720"}]}';
                    Map<String, Object> valueMetaBom = (Map<String, Object>) JSON.deserializeUntyped(response.getBody()); 
                    //                Map<String, Object> valueMetaBom = (Map<String, Object>) JSON.deserializeUntyped(jsonPrueba); 
                    
                    System.debug('resultado : ' + valueMetaBom);
                    return valueMetaBom;
                    
                } else {
                    
                    System.debug(' Failed transaction (DataChangeEndPoint.getSpecialPrice), Response: ' + response); 
                    System.debug(' Failed transaction (DataChangeEndPoint.getSpecialPrice), Response detail: ' + response.getBody()); 
                    return null;
                }          
                
            } 
            catch(exception e) {
                System.debug('Callout error: '+ e); 
                return null;
            }
            
        }
        
        @future (callout=true)
        public static  void  generatePaymentYappyB1(string jsons, Id idOrder, Id paymentRecordId) {
            
            try {
                String mainUrl = 'callout:urlac';
                //String endpoint = 'https://servicesbus.aquacristalina.com:9010/Payments';
                String endpoint = mainUrl + '/Payments';
                System.debug('EndPoint: ' + endpoint);
                HttpRequest req = new HttpRequest();
                req.setHeader('Content-Type', 'application/json');
                req.setEndpoint(endpoint);
                req.setMethod('POST');
                req.setbody(jsons);
                req.setTimeout(120000);
                Http http = new Http();
                System.debug(' Ejecutando pago a B1 (DataChangeEndPoint.generatePaymentB1Var)');
                HttpResponse response = new HttpResponse();
                response = http.send(req); 
                
                if(response.getStatusCode() == 200) {
                    
                    Map<String, Object> valueMetaBom = (Map<String, Object>) JSON.deserializeUntyped(response.getBody()); 
                    Object result =  valueMetaBom.get('Result');
                    Map<String, Object> resultMap =  (Map<String, Object>) result;
                    String SAPDocNum = String.valueOf(resultMap.get('SAPDocNum'));
                    System.debug(' Create Payment with code SAP : ' + SAPDocNum); 
                    System.debug(' Response Status : ' + response); 
                    System.debug(' Response JSON : ' + response.getBody()); 
                    
                    Registro_Pago__c pay = New Registro_Pago__c();
                    pay.Id = paymentRecordId;
                    pay.Resultado_de_Integraci_n__c = '1';
                    pay.Mensaje_Integraci_n__c = null;
                    pay.Enviado_SAP__c = true;
                    pay.C_digo_Pago_SAP__c = SAPDocNum;
                    update pay; 
                    
                    System.debug(' Respuesta JSON : Fue enviado el pago por puntos a B1 ');                 
                    
                } else {
                    IntegrationLog integrationLog = new IntegrationLog();
                    integrationLog.createRegister('POST', 'RegistroPago', response.getBody(), paymentRecordId, jsons);
                    
                    Map<String, Object> MapMes = (Map<String, Object>) JSON.deserializeUntyped(response.getBody()); 
                    Object result =  MapMes.get('ResponseObject');
                    Map<String, Object> resultMap =  (Map<String, Object>) result;
                    String msg = (String)resultMap.get('Message');
                    System.debug(' Error enviando el pago ' + paymentRecordId + ': ' + msg);    
                    Registro_Pago__c pay = New Registro_Pago__c();
                    pay.Id = paymentRecordId;
                    pay.Resultado_de_Integraci_n__c = '0';
                    pay.Mensaje_Integraci_n__c = 'RegistroPago: ' + msg;
                    update pay;
                    
                    System.debug('Error enviando pago ' + paymentRecordId + ' del pedido ' + idOrder  + '- Msj: ' + msg);
    
                }
                
            } 
            catch(exception e) {
                System.debug('Callout error: '+ e); 
                String msg = e.getMessage();
                IntegrationLog integrationLog = new IntegrationLog();
                integrationLog.createRegister('POST', 'RegistroPago', msg, idOrder, jsons); 
                
                Registro_Pago__c pay = New Registro_Pago__c();
                pay.Id = paymentRecordId;
                pay.Resultado_de_Integraci_n__c = '0';
                pay.Mensaje_Integraci_n__c = 'RegistroPago: ' + msg;
                update pay;
                
                System.debug('Error enviando pago ' + paymentRecordId + ' del pedido ' + idOrder  + '- Msj: ' + msg); 
            }
            
        }
        
        //@future (callout=true)
        public static String  existClientSap(String idAccount) {    
            try {
                String mainUrl = 'callout:urlac';
                //String endpoint = 'https://servicesbus.aquacristalina.com:9010/BusinessPartners/SF/' + idAccount;
                String endpoint = mainUrl + '/BusinessPartners/SF/' + idAccount;
                System.debug('EndPoint: ' + endpoint);
                HttpRequest req = new HttpRequest();
                req.setHeader('Content-Type', 'application/json');
                req.setEndpoint(endpoint);
                req.setMethod('GET');
                // req.setbody(jsons);
                req.setTimeout(120000);
                Http http = new Http();
                System.debug(' Ejecutando... (DataChangeEndPoint.existClientSap)');
                HttpResponse response = new HttpResponse();
                response = http.send(req);
                if(response.getStatusCode() == 200) { 
                    Map<String, Object> valueMetaBom = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                    Object result =  valueMetaBom.get('BOM');
                    Map<String, Object> resultMapBO =  (Map<String, Object>) result; 
                    result = resultMapBO.get('BO');
                    Map<String, Object> resultMapMain =  (Map<String, Object>) result;
                    result = resultMapMain.get('BusinessPartners');
                    Map<String, Object> resultMapRow =  (Map<String, Object>) result;
                    result = resultMapRow.get('row');
                    Map<String, Object> resultMapCardCode =  (Map<String, Object>) result;
                    result = resultMapCardCode.get('CardCode');
                    String CardCode = (result != null ? String.valueOf(result) : null);
                    System.debug('CardCode ' + CardCode);  
                    return CardCode;
                } 
                return null;
            } 
            catch(exception e) {
                System.debug('Callout error: '+ e); 
                return null;
            }  
        }
}
