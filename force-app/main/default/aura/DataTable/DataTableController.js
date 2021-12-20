({
    doinit: function (component, event, helper) {
        
        var actions = [{
            label:'show',
            name:'show_details',
            type: 'text' 
        }]
        
        
        component.set('v.columns', [
            {label: 'Account name', fieldName: 'Name', type: 'text'},
            {label: 'Industry', fieldName: 'Industry', type: 'text'},
            {label: 'Rating', fieldName: 'Rating', type: 'text'},
            {label: 'Phone', fieldName: 'Phone', type: 'text'},
            { type: 'action', typeAttributes: { rowActions: actions } }
        ]);
                    
           var action = component.get('c.fetchAccount');
            action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state', state);
            if(state === 'SUCCESS'){
            var responseValue = response.getReturnValue();
            component.set('v.data' , responseValue );
            }
            });
         
            $A.enqueueAction(action); 
            }      
});