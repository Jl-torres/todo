import { LightningElement } from 'lwc';

export default class Time extends LightningElement {
 
    time = '8:00 pm';
    greeting = 'Buenas tardes';
 
    connectedCallback() {
        this.getTime()
       setInterval(() => {
            this.getTime(); 
        }, 1000)
    }

    getTime() {
        const date = new Date();
        const hour = date.getHours();
        const min = date.getMinutes();
        this.time = `${this.getHours(hour)}:${this.getDoubleDigit(min)}${this.getMinDay(hour)}`
        this.setGreting(hour)
    }

    getHours(hour){
        return hour === 0 ? 12 : hour > 12 ? hour-12 : hour
    }

    getDoubleDigit(min) {
        return min < 10 ? '0'+min : min
    }

    getMinDay(hour){
        return  hour >= 12 ? 'PM' : 'AM';
    }

    setGreting(hour) {
     if (hour >= 12 && hour <=19 ){
         this.greeting = 'Buenas tardes'
     } else if (hour >19 && hour <= 24) {
         this.greeting = 'Buenas Noches'
     } else {
         this.greeting = 'Buenos Dias'
     }
    }

}