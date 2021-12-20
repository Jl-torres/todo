import { LightningElement } from 'lwc';

export default class Hijo extends LightningElement {
    click(){
        this.dispatchEvent(new CustomEvent('padre' , { detail: 'soy el componente hijo' })); 
    }
}