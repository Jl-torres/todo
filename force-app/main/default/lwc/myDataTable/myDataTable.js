//myTypes.js
import LightningDatatable from 'lightning/datatable';
import clickableLinkTemplate from './clickableLinkTemplate.html';

export default class MyDataTable extends LightningDatatable {
    static customTypes = {
        clickableLink:{
            template: clickableLinkTemplate,
            standardCellLayout: true,
            typeAttributes: ['recordId' , 'Link' ],
        }
    }
}