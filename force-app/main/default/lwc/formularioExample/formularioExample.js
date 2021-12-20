import { LightningElement, track } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
//Controler
import createCase from '@salesforce/apex/createCaseController.createCase';
//helper
import { options_origin_picklist } from './picklist';

const ObjCase = {
    SuppliedName:'',
    Origin:'',
};

const objContact = {
    FirstName:'',
    LastName:'',
    Email:''
};


export default class FormularioExample extends LightningElement {

    rCase = ObjCase//Objeto Caso  
    rContact = objContact //Objeto Contacto

    //Onchange General
      formChangeContact(event){
          const {name , value} = event.target;
          this.rContact={ ...this.rContact, [name]:value} 
        }
    
      hanledchangeCase(event){
        this.rCase.SuppliedName = event.target.value 
      } 
         
      //Mostrar ocultar email
      @track Show_email = false;
      handledChangeOring(event){
        this.rCase.Origin = event.target.value 
        if(event.target.value  === 'Email'){
            this.Show_email = true
           }else{
            this.Show_email = false 
           }
      } 
      
      

      /*//Forma alternativa
      handledChangeBySwitch(event){
        switch (event.target.name) {
            case 'SuppliedName':
            this.rCase.SuppliedName = event.target.value         
            break;
            case 'Origin':
            this.originCheck(event.target.value);        
            break; 
        }
      }  
     //show email
      originCheck(value) {
        this.rCase.Origin = value ;
        if(value === 'Email'){
         this.Show_email = true
        }else{
         this.Show_email = false 
        }
      }*/

    //Send
     //Revisar que los campos esten correctos
     checkIfError(){
        var areAllValid = true
        var inputs = this.template.querySelectorAll(".input"); 
        inputs.forEach(input =>{
            if(!input.checkValidity()){
                input.reportValidity();
                areAllValid = false;  
            }
        });   
        return areAllValid  
       }

    Send(){
        console.log('send')
        if(this.checkIfError()){ //&& this.idpoliza != null
            this.handleSave()
        }        
    } 

    hijo(event){
        console.log(this.rContact)
        console.log('event.detail')
        console.log(event.detail)
    }
    
    handleSave(){
        console.log('handleSave')
        console.log(this.rCase)
        console.log(this.rContact)

        createCase({objCase: this.rCase , objContact: this.rContact })
        .then(result => { 
            console.log('result')
            console.log(result)   
            this.showToast('Success', 'Caso guardado', 'Success');    
        })
        .catch(error => {
            this.error = error.message;
            console.log('error caso')     
            console.log(error)
            this.showToast('error', 'Error al Guardar Caso', 'error');
        });
        
    }

   

    //PickList
    get options_origin() {return options_origin_picklist() };

    //Alerta
    showToast(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(evt);
    }
        
}