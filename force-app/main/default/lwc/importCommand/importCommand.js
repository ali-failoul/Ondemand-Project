import { LightningElement, track, api } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import readCSV from '@salesforce/apex/Ondemandimportcommandcsv.readCSVFile';

const columns = [
 
    { label: 'TaskReference', fieldName: 'TaskReference__c' },
    { label: 'statue', fieldName: 'statue' },


   
];

export default class ReadCSVFileInLWC extends LightningElement {
    @api recordId;
    @track error;
    @track columns = columns;
    @track data;

    // accepted parameters
    get acceptedFormats() {


        
        return ['.csv'];
    }
    
    handleUploadFinished(event) {
        // Get the list of uploaded files
        const uploadedFiles = event.detail.files;

        // calling apex class
        readCSV({idContentDocument : uploadedFiles[0].documentId})
        .then(result => {
            window.console.log('result ===> '+result);
            this.data = result;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success!!',
                    message: 'Commande are created based CSV file!!!',
                    variant: 'success',
                }),
                
            );
        })
        .catch(error => {
            this.error = error;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error!!',
                    message: JSON.stringify(error),
                    variant: 'error',
                }),
            );     
        })

    }
}