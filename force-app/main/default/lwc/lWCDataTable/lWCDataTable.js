import { LightningElement, wire } from 'lwc';
import CONTACT_ID_FIELD from '@salesforce/schema/Contact.Id'
import CONTACT_NAME_FIELD from '@salesforce/schema/Contact.Name'
import CONTACT_EMAIL_FIELD from '@salesforce/schema/Contact.Email'
import CONTACT_PHONE_FIELD from '@salesforce/schema/Contact.Phone'
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
]

export default class LWCDataTable extends LightningElement {

    columns=COLUMNS;
    contacts;

    @wire(getContacts)
    loadUser(result) {
        this.contacts = result.data;
        console.log('JUMMM' , CONTACT_ID_FIELD.fieldApiName )
        }

}