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

    let flag = true;

    checkboxes.forEach((checkbox) => {

      if (checkbox.checked) {
        
        const userBox = checkbox.closest('.userBox');
        const userId = userBox.querySelector('.userBoxParagraph').getAttribute('data-userid');
        const startDate = userBox.querySelector('.startDate').value;
        const finishDate = userBox.querySelector('.closeDate').value;
        const assignedHours = userBox.querySelector('.hoursAssigned').value;
        const assignButton = this.template.querySelector('.assignButton');
        const hoursPendingNode = userBox.parentNode.querySelector('.hoursMissing');
        const hoursPendingNumber = parseInt(hoursPendingNode.textContent.split(': ')[1]);

        if(startDate && finishDate && assignedHours){
          if(new Date(startDate) >= new Date(finishDate) || new Date(startDate) <= new Date()){
            // Means all the fields were filled, but the date were not valid.
            flag = false;
            const newDiv = document.createElement('div');
            newDiv.innerHTML = "Start date must be after today and before finish date";
            // CSS Properties of newDiv
            newDiv.style['color'] = 'red';
            newDiv.style['position'] = 'absolute';
            newDiv.style['top'] = '-10%';
            newDiv.style['right'] = '3%';
            newDiv.style['width'] = 'max-content';
            newDiv.style['background-color'] = 'white';
            newDiv.style['color'] = 'red';
            newDiv.style['padding'] = '0px 4px';
            userBox.appendChild(newDiv);
            userBox.classList.add('validateRed');
            assignButton.disabled = true;
            setTimeout(() => {
              userBox.classList.remove('validateRed');
              userBox.removeChild(newDiv);
              assignButton.disabled = false;
            }, 6000);         
          }else if(new Date(startDate) < new Date(this.data.project.Start_Date__c) || new Date(finishDate) > new Date(this.data.project.Close_Date__c)){
            // Means date ranges are not in the project range.
            flag = false;
            const newDiv = document.createElement('div');
            newDiv.innerHTML = "Date ranges must be in date range of the project";
            // CSS Properties of newDiv
            newDiv.style['color'] = 'red';
            newDiv.style['position'] = 'absolute';
            newDiv.style['top'] = '-10%';
            newDiv.style['right'] = '3%';
            newDiv.style['width'] = 'max-content';
            newDiv.style['background-color'] = 'white';
            newDiv.style['color'] = 'red';
            newDiv.style['padding'] = '0px 4px';
            userBox.appendChild(newDiv);
            userBox.classList.add('validateRed');
            assignButton.disabled = true;
            setTimeout(() => {
              userBox.classList.remove('validateRed');
              userBox.removeChild(newDiv);
              assignButton.disabled = false;
            }, 6000);          
          }
          else if(assignedHours > hoursPendingNumber){
            flag = false;
            const newDiv = document.createElement('div');
            newDiv.innerHTML = "Too many assigned hours";
            // CSS Properties of newDiv
            newDiv.style['color'] = 'red';
            newDiv.style['position'] = 'absolute';
            newDiv.style['top'] = '-10%';
            newDiv.style['right'] = '3%';
            newDiv.style['width'] = 'max-content';
            newDiv.style['background-color'] = 'white';
            newDiv.style['color'] = 'red';
            newDiv.style['padding'] = '0px 4px';
            userBox.appendChild(newDiv);
            userBox.classList.add('validateRed');
            assignButton.disabled = true;
            setTimeout(() => {
              userBox.classList.remove('validateRed');
              userBox.removeChild(newDiv);
              assignButton.disabled = false;
            }, 6000);

          }else{
            // Add the data to the selectedUsers array
            selectedUsers.push({
              Project__c: this.recordId,
              Resource__c: userId,
              Start_Date__c: startDate,
              Close_Date__c: finishDate,
              AssignedHours__c: assignedHours
            });
          }


        }else{

          flag = false;

          const newDiv = document.createElement('div');
          newDiv.innerHTML = "Fill all the fields";
          // CSS Properties of newDiv
          newDiv.style['color'] = 'red';
          newDiv.style['position'] = 'absolute';
          newDiv.style['top'] = '-10%';
          newDiv.style['right'] = '3%';
          newDiv.style['width'] = 'max-content';
          newDiv.style['background-color'] = 'white';
          newDiv.style['color'] = 'red';
          newDiv.style['padding'] = '0px 4px';
          userBox.appendChild(newDiv);
          userBox.classList.add('validateRed');
          assignButton.disabled = true;
          setTimeout(() => {
            userBox.classList.remove('validateRed');
            userBox.removeChild(newDiv);
            assignButton.disabled = false;
          }, 6000);
          console.log('fill all the fields!');
        }

      }
    });

    if(flag===false){
      selectedUsers = [];
    }

    // Do something with the selectedUsers array
    console.log(JSON.parse(JSON.stringify(selectedUsers)));

  }

}