import { api, LightningElement } from 'lwc';
import updateTodo from '@salesforce/apex/ToDoController.updateTodo';
import deleteTodo from "@salesforce/apex/ToDoController.deleteTodo";



export default class TodoItem extends LightningElement {
    @api todo


    updateHandler() {

        const todo = {
            todoId: this.todo.todoId,
            todoName : this.todo.todoName ,
            done: !this.todo.done ,
        }

       //make a call to server to update the item
    updateTodo({ payload: JSON.stringify(todo) })
    .then(result => {
        console.log('exito actualizado')
      //on successful update, fire an event to notify parent component
      const updateEvent = new CustomEvent("update");
      this.dispatchEvent(updateEvent);
    })
    .catch(error => {
      console.error("Error in updatig records ", error);
    });
    }

    deleteHandler() {
        //make a call to server to delete item
        deleteTodo({ todoId: this.todo.todoId })
          .then(result => {
              console.log('exito borrado')
            //on successful delete, fire an event to notify parent component
            this.dispatchEvent(new CustomEvent("delete", { detail: this.todo.todoId }));
          })
          .catch(error => {
            console.error("Error in updatig records ", error);
          });
      }

 get ContainerCLass() {
     return !this.todo.done 
     ?  
     'todo upcoming slds-grid slds-gutters slds-align_absolute-center' 
     : 
     'todo completed slds-grid slds-gutters slds-align_absolute-center'
 }

 get buttonIcon() {
    return this.done ? "utility:check" : "utility:add";
  }

}