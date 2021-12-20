import { LightningElement, track , api} from 'lwc';
import addTodo from '@salesforce/apex/ToDoController.addTodo';
import getCurrentTodos from '@salesforce/apex/ToDoController.getCurrentTodos';

export default class HellowWorld extends LightningElement {

    @track todos= [];

    connectedCallback() {
        this.fetchTodos();
    }

    boatId;

    @api
    get recordId() {
        return this.boatId;
    }
    set recordId(value) {
        //sets boatId attribute
        this.setAttribute('boatId', value);        
        //sets boatId assignment
        this.boatId = value;

        //console.log('value' , value)
    }

    //Lista de Tareas

    fetchTodos() {
        getCurrentTodos()
          .then(result => {
            if (result) {
              
              this.todos = result;
            }
          })
          .catch(error => {
            console.error("Error in fetching todo" + error);
          });
      }

    //Añadir tarea

    addTodoHandler() {
       const inputBox = this.template.querySelector('lightning-input');
       
 
       const todo = {
           todoName : inputBox.value ,
           done: false ,
       }

       addTodo({payload:JSON.stringify(todo)}).then(response => {
           //console.log(response)
           this.fetchTodos();

       }).catch(error => {
           console.log('error', error)
       })
      
       inputBox.value = ''
    }

  get upcomingTodos() {
    return this.todos && this.todos.length
      ? this.todos.filter(todo => !todo.done)
      : [];
  }

  get completedTodos() {
    return this.todos && this.todos.length
      ? this.todos.filter(todo => todo.done)
      : [];
  }
  //Actualizar tarea

  updateTodoHandler(event) {
    if (event) {
      this.fetchTodos();
    }
  }

  deleteTodoHandler(event) {
    if (event) {
      this.fetchTodos();
    }
  }
}



/*CODIGO ANTERIOR STATEMEN ACCOUNT

<aura:component 
                implements="flexipage:availableForAllPageTypes,force:appHostable,lightning:actionOverride,flexipage:availableForRecordHome,force:hasRecordId,force:hasSObjectName,force:LightningQuickAction,forceCommunity:availableForAllPageTypes"
                controller="StatementAccController" access="global">
    
    
    <aura:attribute name="Lines" type="Object[]"/>
    <aura:attribute name="LineColumns" type="List"/>
    <aura:attribute name="description" type="String" default=""/>
    <aura:attribute name="sortedBy" type="String" default="ArrivalDate"/>
    <aura:attribute name="sortedDirection" type="String" default="asc"/>
    <aura:attribute name="defaultSortDirection" type="String" default="asc"/>
    <aura:attribute name="creating" type="Boolean" default="true" />
    <aura:attribute name="recordId" type="String" default="" />
    <aura:attribute name="AccountBalance" type="String" default="0.00" />
    <aura:attribute name="clientId" type="String" default="" />

    <aura:handler name="init" value="{!this}" action="{!c.doInit}" />

    <!-- <div  class="exampleHolder"> -->
    <div  class="x-large">
        
     <!--Base Card Structure -->
     <article class="slds-card">   
       <div class="slds-card__header slds-grid">
    <header class="slds-media slds-media_center slds-has-flexi-truncate">
      <div class="slds-media__figure">
         <lightning:icon iconName="standard:contact_list" alternativeText="Facturas Pendientes" title="Facturas Pendientes" />
      </div>
      <div class="slds-media__body">
        <h2 class="slds-card__header-title TitleEC"> 
            <span>Estado de Cuenta</span>
        </h2>
      </div>
      <div class="slds-no-flex">
        <button class="slds-button slds-button_neutral">Pagos</button>
      </div>
    </header>       
  </div>       
     <div class="slds-card__body slds-card__body_inner">
          <lightning:recordViewForm  aura:id="accountRecordForm" recordId="{!v.recordId}" objectApiName="Account" class="slds-size_6-of-6">

                <div class="slds-grid ">
                    <lightning:outputField fieldName="ExternalId__c" />   
                </div>

                
            </lightning:recordViewForm>
         <div>
              Total Balance:  
            <!--<br/>-->
             <ui:outputText value="{!v.AccountBalance}"/>
            <!--<br/>
			<br/>
            <br/>-->
         </div>
      </div>     
 </article>      
   <!-- Base Card Structure End -->   
            <lightning:recordViewForm  aura:id="accountRecordForm" recordId="{!v.recordId}" objectApiName="Account" class="slds-size_6-of-6">

                <div class="slds-grid ">
                    <lightning:outputField fieldName="ExternalId__c" />   
                </div>

                
            </lightning:recordViewForm>
            
              Total Balance:  
	
            <br/>
             <ui:outputText value="{!v.AccountBalance}"/>
            <br/>
			<br/>
            <br/>
            <div>
                <lightning:datatable keyField="id" data="{! v.Lines }" columns="{! v.LineColumns }" 
                                     aura:id="linesTable" />
            </div> 
     
    </div>
    
    
</aura:component>

*/

