public with sharing class DataContact {

   @AuraEnabled(cacheable=true)
   public static List<Contact> getContacts( String searchKey, String sortBy, String sortDirection, Date EndDate, Date StartsDate ) {
      
       String query = 'SELECT Id, Name, Phone, Email  FROM Contact';
       System.debug('fecha ' + StartsDate + ' ' + EndDate );
   
       if(searchKey != null && searchKey != '' 
           || EndDate != null && StartsDate != null 
           ) {
           query += ' WHERE';
       }
       if ( EndDate != null && StartsDate != null ) {
        
        Date thisEndDate = Date.valueOf(date.newInstance(EndDate.year(), EndDate.month(), EndDate.day()));
        Date thisStartsDate = Date.valueOf(date.newInstance(StartsDate.year(), StartsDate.month(), StartsDate.day()));
       
        query += ' DAY_ONLY(CreatedDate) >= :thisEndDate  And DAY_ONLY(CreatedDate) <= :thisStartsDate';

       }
       if ( searchKey != null && searchKey != '' ) {

           String key = '%' + searchKey + '%';

           if (EndDate != null && StartsDate != null) {
            query += ' AND Name LIKE :key';
           } else {
            query += ' Name LIKE :key';   
           }
       }
       if ( sortBy != null && sortDirection != null ) {
           query += ' ORDER BY ' + sortBy + ' ' + sortDirection;
       }
         
       System.debug('query ' + query );

       return Database.query( query );
   }
}


// SELECT Id, CreatedDate, Name FROM Contact Where CreatedDate >=YESTERDAY AND CreatedDate <= TODAY  

//WHERE DAY_ONLY(CreatedDate) = 2021-08-06  AND

//DAY_ONLY(CreatedDate) >=:thisStartsDate And DAY_ONLY(CreatedDate) <=:thisEndDate

//SELECT Id, CreatedDate, Name FROM Contact WHERE DAY_ONLY(CreatedDate) >= 2021-08-06 And DAY_ONLY(CreatedDate) <= 2021-08-07

/*if (searchKey != null && searchKey != '' 
           || EndDate != null && StartsDate != null 
           ) {
           query += 'WHERE';
       }*/


/*
import { LightningElement, track } from 'lwc';
//Controler
import getSearchCase from '@salesforce/apex/GetCaseControlller.getSearchCase'
//Funciones JS
import { SoloNumeros } from 'c/helpers';
//Navegation
import { NavigationMixin } from 'lightning/navigation';
//import Id from '@salesforce/user/Id';

export default class GetCase_Lwc extends NavigationMixin(LightningElement) {
    
    @track show = true;
    showform = false;
    Loading = false;
    CaseNumber = '';
    numero_identidad = '';
    msg = '';
    @track BuscarPor
    @track showBuscarBy = false
    @track CasoTabTitle;
    @track caso 
    @track StatusOptions; 
    @track options;
    //Clases 
    @track n_idVacio = 'D_None';
    @track n_CasoVacio = 'D_None';
    @track SearchClass;
    @track Alinear = 'form AlinearVerticalmente'
   //Validacion Formulario 
    CaseChangeHandler(event){
        switch (event.target.name) {
             case 'Case Number':
                this.CaseNumber = event.target.value;
                //console.log('Onchange' + this.CaseNumber)
                this.show = true
                this.SearchClass =''
             break;
             case 'numero identidad':
               this.numero_identidad= event.target.value; 
               console.log('Onchange ' + this.numero_identidad)
             break;
          } 
    }

    keyNumber(event){
        SoloNumeros(event) 
        }
//PickList

get BuscarPorOptions() {
    return [
        { label: 'Número de Identidad', value: 'Identidad' },
        { label: 'Número de Placa', value: 'Placa' },                  
    ];
}

ChangePickListOptions(event){
    this.BuscarPor= event.target.value;
    this.showBuscarBy = true
}

//Buscar caso

    searchByCase(){
        this.CheckSearchByCase()
        if (this.CaseNumber !== '' &&  this.numero_identidad !== ''){
            this.CallGetSearchCase();
            this.GetSuccess();        
        }
        this.ChequearValidaciones();      
    }

    CallGetSearchCase(){
        if(this.BuscarPor = 'Identidad' ){
            var identidad = this.numero_identidad
            var placa = ''
        }else{
            var identidad = ''
            var placa = this.numero_identidad
        }
        this.Loading = true
        console.log('placa ' + placa , 'identidad ' +identidad)
        getSearchCase({
            vCaseNumber: this.CaseNumber,
            //vplaca: placa,
            //vIdentidad: identidad,
            //new : false
        })
        .then(result => {
            this.GetResponse(result)       
            console.log(result)
            this.Loading = false
        })
        .catch(error => {
            this.error = error;
            this.GetResponse(null)
            console.log(error)
            this.Loading = false
        });
    }

    GetResponse(result) {
        console.log(this.BuscarPor)
        if(result){
           this.showform = true
           this.caso = result
           this.msg = ''
        } else {
            this.msg = `Número de caso o número de ${this.BuscarPor} Invalido `; console.log(this.msg) ; this.show = false ; this.showform = false;  //this.Alinear ='form AlinearVerticalmente'
        }    
     //result ? this.case = result : this.msg = 'Numero de caso Invalido' ; this.show = false
    }
    //Llamado Exitoso
    GetSuccess(){
        this.show = true;
        this.Alinear ='form m-y'
        //this.Loading = true;
        this.SearchClass ='';
        this.template.querySelector('c-edit-form-case-l-w-c').EliminarDuplicados();
    }

    //Funciones que se activan si uno de los campos esta vacio
    CheckSearchByCase(){
        if(this.numero_identidad === ''){
            console.log('this.numero_identidad vacio')  //this.n_idVacio = 'D_None'; 
            this.n_idVacio = 'campo_vacio';
          }else{
            this.n_idVacio = 'D_None'
          }
  
        if(this.CaseNumber === ''){
              console.log('this.CaseNumber vacio')
              this.n_CasoVacio = 'campo_vacio'; 
         }else{
            this.n_CasoVacio = 'D_None';  
         }
    }

    ChequearValidaciones(){
        this.show = false;
        this.Loading = false;   
        this.showform = false
        console.log(this.numero_identidad)
        console.log(this.CaseNumber)     
    }; 
}



 /* 
 //Crear Caso

   CrearCaso(){
    this[NavigationMixin.Navigate]({
        type : 'standard__webPage',
        attributes: {
            url : 'https://uat-surapantest.cs199.force.com/s/createrecord/Crear_Caso'
        }
    });
   }

     SoloNumeros(evt){
        var code = (evt.which) ? evt.which : evt.keyCode;
        if(code==8) { // backspace.
            evt.preventDefault()  
          return true;
        } else if(code>=48 && code<=57) { // is a number.
            //console.log(evt)
          return true;
        } else{ 
        evt.preventDefault()  
        } }
   
 Link crear caso
 https://uat-surapantest.cs199.force.com/s/createrecord/Crear_Caso
 */


/*Controlador Query search 

  Case c = [SELECT id, SuppliedName, Subject, Description, Status, CreatedDate, ClosedDate, CaseNumber  
        FROM Case 
        WHERE CaseNumber = :vCaseNumber OR id =:vCaseNumber  
        LIMIT 1];
        return c;

*/    