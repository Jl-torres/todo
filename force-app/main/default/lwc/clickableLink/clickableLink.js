import { api, LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class ClickableLink extends NavigationMixin(LightningElement) {
    @api recordId; 
    @api email;
    @api link

    Tag_a;


    connectedCallback() {
        if (this.link == 'sean@edge.com') {
            this.Tag_a = ''
        } else {
            this.Tag_a = 'NotLink'
        }
    }

    navigateToRecord(event){
        event.preventDefault();  
     if(this.link == 'sean@edge.com'){
        this[NavigationMixin.GenerateUrl]({
            type:'standard__recordPage',
            attributes: {
                recordId: this.recordId,
                actionName:'view'
            }
   
        }).then(url => {window.open(url)});
   
       } else {
        console.log('Sin Link')
       }
     } 


     /*
     
     if (link == 'sean@edge.com') {
        this.Tag_a = 'NotLink'
    } else {
        this.Tag_a = ''
    }
     
     */
   
}