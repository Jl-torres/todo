import { LightningElement } from 'lwc';
import DataTables from '@salesforce/resourceUrl/DataTables';
import jqueryDataTables from '@salesforce/resourceUrl/jqueryDataTables'
import JqueryTableCss from '@salesforce/resourceUrl/JqueryTableCss'
import 	Jquery5 from '@salesforce/resourceUrl/Jquery5'; 
import { loadStyle, loadScript } from 'lightning/platformResourceLoader';

export default class JQueryDataTable extends LightningElement {

    JqLoaded = false

   renderedCallback(){
    if(!this.JqLoaded){
         Promise.all([
        loadStyle(this, DataTables+'/DataTables-1.10.25/css/jquery.dataTables.min.css'),
        //loadStyle(this, JqueryTableCss),
        //loadScript(this, Jquery5),
        //loadScript(this, jqueryDataTables),
        loadScript(this, DataTables+'/jQuery-3.3.1/jquery-3.3.1.min.js'),
        loadScript(this, DataTables+'/DataTables-1.10.25/js/jquery.dataTables.min.js'),
    ]).then(() => { 
        this.JqLoaded = true ; 
        console.log('load Success');  
        //$(this.template.querySelector('#example')).DataTable(); 
       
        //$(this.template.querySelector('.className')).DataTable();
   
        //$("#titulo").css("color", "#FF0040");
        // $("#titulo").css({"color":"red"});
    }).catch((error) => {
     console.error('LoadScript fail' , error )
    }) ;
   } 
   this.slideRight()
    }   

    slideRight(event){
        console.log('click');
        $(this.template.querySelector('.innerDiv')).animate({left: '400px'});
       
    }
   
}

/*
$(document).ready(function() {
    $('#example').DataTable();
} );

//cdn.datatables.net/1.10.25/css/jquery.dataTables.min.css

//cdn.datatables.net/1.10.25/js/jquery.dataTables.min.js

*/