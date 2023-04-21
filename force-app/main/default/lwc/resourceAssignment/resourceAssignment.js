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

}