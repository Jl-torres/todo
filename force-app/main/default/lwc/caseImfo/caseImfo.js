import { LightningElement , wire , track } from 'lwc';
//Message Channel
import { subscribe, APPLICATION_SCOPE, MessageContext } from 'lightning/messageService';
import messageCase from '@salesforce/messageChannel/messagueCase__c';

export default class CaseImfo extends LightningElement {

    
    show = false;
    msgCaso = 'Bienvenido Ingrese sus datos en el formulario';
    StyleAdvertencia = 'slds-align_absolute-center slds-notify slds-notify_alert Bg_Blue w-80'
    subscription = null;
    @track messages = [];

    @wire(MessageContext) msgContext;

    connectedCallback() {
        if (!this.subscription) {
          this.subscription = subscribe(
            this.msgContext,
            messageCase,
            msg => {
              this.messageHandler(msg);
            },
            { scope: APPLICATION_SCOPE }
          );
        }
      }

      messageHandler(msgPayload) {
        if (msgPayload.CaseMessage) {
            const caso = msgPayload.CaseMessage
             this.messages = {
                Id: caso.Id ,
                CaseNumber: caso.CaseNumber ,
                LastName: caso.Contact.Name ,
             } 
             this.show = true
        } else {
            this.show = false,
            this.StyleAdvertencia = 'slds-align_absolute-center slds-notify slds-notify_alert slds-alert_error w-80'
            this.msgCaso = 'No Hay Resultados, Numero de caso o Apellido No valido'
        }
        //console.log('this.messages con resultados ' + JSON.stringify(msgPayload))
      }
}