import { api, LightningElement, track } from 'lwc';
//1 archivo
import uploadFile from '@salesforce/apex/FileUploadService.uploadFile';
//import TRAILHEAD_CHARACTERS from '@salesforce/resourceUrl/trailhead_characters';
//varios archivos
import uploadFiles from '@salesforce/apex/FileUploadService.uploadFiles';
import Id from '@salesforce/user/Id';

export default class CampoTypeFile extends LightningElement {
@api userId = Id
@track documentos = [];
@track documentos2;
@track fileData;
@track fileDataPlural = [];
@track loading = false;
@track n_Archivos = 0
@track einsteinUrl = [];


       // Expose URL of assets included inside an archive file
       //einsteinUrl = TRAILHEAD_CHARACTERS + '/images/einstein.png';
    
    handleFilesChange2(event) {
        const file = event.target.files[0]
        var reader = new FileReader();

        reader.onload = () => {
            var base64 = reader.result.split(',')[1];
            this.fileData = {
                'filename' : file.name ,
                'base64' : base64 ,
                'recordId': this.userId
            }
            console.log(this.fileData)

        }
        reader.readAsDataURL(file)
        
    }

    SendFile2(){
        const {base64, filename, recordId} = this.fileData
        this.loading = true
        uploadFile({base64, filename, recordId})
        .then(result =>{
            console.log('resultado')
            console.log(result)
            this.loading = false
        })
        .catch(error => {
            console.log('error')
            console.log(error)
            this.loading = false
        })
    }

//Mas de un archivo
    handleFilesChange(event) {
        //console.log(this.recordId)
        const file = event.target.files[0]
        var reader = new FileReader();
 
        reader.onload = () => {
            var base64 = reader.result.split(',')[1];
            this.fileDataPlural.push(
             {
                 'filename' : file.name, //file.name ,
                 'base64' : base64 ,
                 'recordId': this.userId,
                 'id': this.n_Archivos 
             }
            )
            this.n_Archivos += 1 
            console.log(this.n_Archivos)
            if(this.n_Archivos > 3 ){
                this.einsteinUrl.shift()
                this.einsteinUrl.push({
                    'img':reader.result,
                    'index':this.n_Archivos
                })       
            }else{
                this.einsteinUrl.push({
                    'img':reader.result,
                    'index':this.n_Archivos
                })
            }
            //console.log(this.fileDataPlural)
        }
        reader.readAsDataURL(file)
     }


    SendFile(){    
        //const {base64, filename, recordId} = this.fileDataPlural
        this.loading = true
         uploadFiles({filesData:JSON.stringify(this.fileDataPlural)})
            .then(result =>{
                console.log('resultado')
                console.log(result)
                this.loading = false
            })
            .catch(error => {
                console.log('error')
                console.log(error)
                this.loading = false
            }) 
    }


     /*for (let index = 0; index < this.fileDataPlural.length; index++) {
            const {base64, filename, recordId} = this.fileDataPlural[index]
            uploadFile({base64, filename, recordId})
            .then(result =>{
                console.log('resultado')
                console.log(result)
                if(this.fileDataPlural.length === index + 1){
                    this.loading = false
                }
                //this.loading = false
            })
            .catch(error => {
                console.log('error')
                console.log(error)
                if(this.fileDataPlural.length === index + 1){
                    this.loading = false
                }
                //this.loading = false
            }) 
            //this.fileDataPlural = []
        }*/

}