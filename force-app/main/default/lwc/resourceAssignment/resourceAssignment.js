import { LightningElement, api, wire } from 'lwc';
import getProject from '@salesforce/apex/ProjectWrapper.getProject';

export default class ResourceAssignment extends LightningElement {
    @api recordId;
    data;
    error;

    @wire(getProject, {projectId: '$recordId'})
    theWrapper({ error, data }) {
        if (data) {
          this.data = data;
          this.error = undefined;
          console.log('Aca te muestro la data');
          console.log(this.data);        
        } else if (error) {
          this.error = error;
        }
    }

    // renderedCallback(){
    //     getProject( {projectId: this.recordId} )
    //     .then(result =>{
    //         console.log('este es el result');
    //         console.log(result);
    //         this.data = result;
    //     })
    //     .catch(error => {
    //         console.log(this.recordId);
    //         console.log('este es el error');
    //         console.log(error);
    //         this.error = error;
    //     })
    //     console.log('DATA O ERROR');
    //     console.log(this.data);
    //     console.log(this.error);
    // }
}