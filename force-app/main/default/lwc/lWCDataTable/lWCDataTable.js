import { LightningElement, wire , track , api } from 'lwc';
import CONTACT_ID_FIELD from '@salesforce/schema/Contact.Id'
import CONTACT_EMAIL_FIELD from '@salesforce/schema/Contact.Email'
import getContacts from '@salesforce/apex/DataContact.getContacts';

const COLUMNS = [
{
    label:'Name',
    fieldName: 'Name',
    type: 'text'
},
{
    label:'Email',
    fieldName: 'Email',
    type: 'clickableLink',
    typeAttributes: {
      recordId: {fieldName:CONTACT_ID_FIELD.fieldApiName},
      Link : {fieldName:CONTACT_EMAIL_FIELD.fieldApiName}
    },
},
{
    label:'Phone',
    fieldName: 'Phone',
    type: 'text'
},
] ;

const BoxOptions = [
    { label: '1', value:' 1' },
    { label: '5', value: '5' },
    { label: '10', value: '10' },
    ]

export default class LWCDataTable extends LightningElement {

    @track value;
    @track error;
    @track data;
    @api sortedDirection = 'asc';
    @api sortedBy = 'Name';
    searchKey = '';
    result;
    @track comboBoxOptions = BoxOptions;
    @track recordsPerPage='vas';
    //Pagination
    @track page = 1; 
    @track contacts = []; 
    @track data = []; 
    @track columns=COLUMNS; 
    @track startingRecord = 1;
    @track endingRecord = 0; 
    @track pageSize = 5; 
    @track totalRecountCount = 0;
    @track totalPage = 0;

    //Date
    StartDate = null;
    EndDate = null;
    
    @wire(getContacts, {searchKey: '$searchKey', sortBy: '$sortedBy', sortDirection: '$sortedDirection', EndDate:'$StartDate', StartsDate:'$EndDate'})
    loadUser({ error, data }) {
        if (data) { 
            this.contacts = data;
            this.totalRecountCount = data.length; 
            this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize); 
            
            this.data = this.contacts.slice(0,this.pageSize); 
            this.endingRecord = this.pageSize;
            this.error = undefined;
            console.log('data');
            console.log(data);

        } else if (error) {
            this.error = error;
            this.data = undefined;
        }
        }

    
     //clicking on previous button this method will be called
     previousHandler() {
        if (this.page > 1) {
            this.page = this.page - 1; //decrease page by 1
            this.displayRecordPerPage(this.page);
        }
    }

    //clicking on next button this method will be called
    nextHandler() {
        if((this.page<this.totalPage) && this.page !== this.totalPage){
            this.page = this.page + 1; //increase page by 1
            this.displayRecordPerPage(this.page);            
        }             
    }

    //this method displays records page by page
    displayRecordPerPage(page){

        this.startingRecord = ((page -1) * this.pageSize) ;
        this.endingRecord = (this.pageSize * page);

        this.endingRecord = (this.endingRecord > this.totalRecountCount) 
                            ? this.totalRecountCount : this.endingRecord; 

        this.data = this.contacts.slice(this.startingRecord, this.endingRecord);

        this.startingRecord = this.startingRecord + 1;
    }    
    
    sortColumns( event ) {
        this.sortedBy = event.detail.fieldName;
        this.sortedDirection = event.detail.sortDirection;
       //return refreshApex(this.result);
        
    }
  
    handleKeyChange( event ) {
        this.searchKey = event.target.value;
        console.log(this.searchKey)
        //return refreshApex(this.result);
    }

    //ComboBox
    handleComboboxChange(event) {
        this.pageSize = event.target.value
        this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize);
        this.page = 1;
        this.displayRecordPerPage(this.page);
    }

    //Consultar por fecha
    handleStartDate(event){
        this.StartDate = event.target.value
        if(this.EndDate != null){
            this.page = 1;
            this.displayRecordPerPage(this.page);
        }      
    }

    handleEndDate(event){
        this.EndDate = event.target.value
        if(this.StartDate != null){
            this.page = 1;
            this.displayRecordPerPage(this.page);
        }  
    }

}


