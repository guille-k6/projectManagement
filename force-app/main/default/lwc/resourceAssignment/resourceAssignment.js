import { LightningElement, api, track, wire } from 'lwc';
import getProject from '@salesforce/apex/ProjectWrapper.getProject';

export default class ResourceAssignment extends LightningElement {
    @api recordId;
    data;
    error;
    @track requirements=[];

    @wire(getProject, {projectId: '$recordId'})
    theWrapper({ error, data }) {
        if (data) {
          this.data = data;
          this.error = undefined;

          const newData = [...data.requirementList];
          // updatedData is like data.requirementList but with hoursMissing field adittion.
          this.requirements = newData.map(obj => {
            const { projectProduct } = obj;
            let hoursMissing;
            if(hoursMissing = projectProduct.Quantity__c - projectProduct.Completed_Hours__c < 0){
              hoursMissing = 0;
            }else{
              hoursMissing = projectProduct.Quantity__c - projectProduct.Completed_Hours__c;
            }
            return {
              ...obj,
              projectProduct: {
                ...projectProduct,
                hoursMissing
              }
            };
          });
        } else if (error) {
          this.error = error;
        }
    }

    // SubmitButton handler


  renderedCallback(){
    if(this.data){
      console.log('aca esta la data');
      console.log(this.data);
      const userBoxes = this.template.querySelectorAll('.userBox');
      console.log('userboxes');
      console.log(userBoxes);
      userBoxes.forEach((box) => {
        const parent = box.parentNode;
        const lastChild = parent.lastChild;
        lastChild.classList.add('lastUserBoxChild');
      });
      console.log('Im adding this classes');
    }
  }

}