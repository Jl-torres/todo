import { api, LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class ClickableLink extends NavigationMixin(LightningElement) {
    @api recordId; 
    @api email;
    @api link

    Tag_a;


    connectedCallback() {
        //console.log('link', this.link)
        if (this.link == 'sean@edge.com' || this.link == 'a_young@dickenson.com' ) {
            this.Tag_a = ''
        } else {
            this.Tag_a = 'NotLink'
        }
        //console.log('Tag_a' , this.Tag_a)
    }

    navigateToRecord(event){
        event.preventDefault();  
     if(this.link == 'sean@edge.com' || this.link == 'a_young@dickenson.com' ){
        this[NavigationMixin.GenerateUrl]({
            type:'standard__recordPage',
            attributes: {
                recordId: this.recordId,
                actionName:'view'
            }
   
        }).then(url => {window.open(url)});
   
       } else {
        console.log('Sin Link')
        //null
       }
     } 


     
   
}