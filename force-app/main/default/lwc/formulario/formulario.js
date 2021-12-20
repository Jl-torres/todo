import { LightningElement, track , wire } from 'lwc';
//Controler
import GetCaseByNumber from '@salesforce/apex/GetCase.GetCaseByNumber';
//Message Channel
import messageCase from '@salesforce/messageChannel/messagueCase__c';
import { publish, MessageContext } from 'lightning/messageService';

export default class Formulario extends LightningElement {
    
    show = true;
    accountName ='';
    accountPhone ='';

    accountChangeHandler(event){
        const inputBoxName = event.target.name;
        if(inputBoxName === 'Account Name'){
            this.accountName = event.target.value;
        } else if(inputBoxName === 'Account Phone'){
            this.accountPhone = event.target.value;
        }
    }

    searchByCase(){

        if (this.accountName !== '' && this.accountPhone !== ''){
            GetCaseByNumber({
                caso_n: this.accountName,
                LastName : this.accountPhone
            })
            .then(result => {
             this.publishNC(result)
             //console.log('this.Case ' + this.Case[0].CaseNumber , this.Case)
            })
            .catch(error => {
                this.error = error;
                console.log(error)
            });
            this.show = true;
            return
        } else {
            this.show = false;
        }  
        //console.log('String vacios')   
    }

    // Lightning Messaging Service 

    @wire(MessageContext) msgContext;
    
    publishNC( data ) {
        
    if(data[0]) {
        const send = {
        CaseMessage : data[0] 
    }
    publish(this.msgContext , messageCase, send )
    } else {
        const send = {
            CaseMessage : false 
    }
    publish(this.msgContext , messageCase, send )
    }   
}

}

