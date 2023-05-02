import { LightningElement, api, wire, track } from 'lwc';
import getTaskWrapper from '@salesforce/apex/TaskWrapper.getTaskWrapper';

export default class TaskManagement extends LightningElement {
    @track data;
    error;
    refresh;

    @wire(getTaskWrapper)
    theWrapper(result) {
        // using theWrapper(result) structure to use refreshApex
        // Previously used theWrapper( {data, error} ) didn't work refresh apex that way.
        this.refresh = result
        if(result.data) {
          console.log('aca esta la data');
          console.log(result.data);
          this.data = result.data;
        } else if(result.error){
          this.error = result.error;
        }
    }
}