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

      const userBoxes = this.template.querySelectorAll('.userBox');

      userBoxes.forEach((box) => {
        const parent = box.parentNode;
        const lastChild = parent.lastChild;
        lastChild.classList.add('lastUserBoxChild');
      });
    }
  }

  handleAssignClick(){
    // Get all the checkboxes
    const checkboxes = Array.from(this.template.querySelectorAll('.inputCheckbox'));

    let selectedUsers = [];

    checkboxes.forEach((checkbox) => {
      if (checkbox.checked) {
        
        const userBox = checkbox.closest('.userBox');
        const userId = userBox.querySelector('.userBoxParagraph').getAttribute('data-userid');
        const startDate = userBox.querySelector('.startDate').value;
        const finishDate = userBox.querySelector('.closeDate').value;
        const assignedHours = userBox.querySelector('.hoursAssigned').value;

        // Add the data to the selectedUsers array
        selectedUsers.push({
          Project__c: this.recordId,
          Resource__c: userId,
          Start_Date__c: startDate,
          Close_Date__c: finishDate,
          AssignedHours__c: assignedHours
        });
      }
    });

    // Do something with the selectedUsers array
    console.log(selectedUsers);

  }

}