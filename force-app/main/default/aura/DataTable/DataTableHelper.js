({
    /*var actions = [{
          label: 'Deactivate',
          iconName: 'utility:block_visitor',
          name: 'deactivate'
    }];*/
    COLUMNS: [
        { label: 'Name', fieldName: 'name' },
        {
            label: 'Age',
            fieldName: 'age',
            type: 'number',
            sortable: true,
            cellAttributes: { alignment: 'left' },
        },
       
        {label: 'Email', fieldName: 'email', type:'url', typeAttributes: { target: '_self'}},
         //{ type: 'action', typeAttributes: { rowActions: actions } }
        
    ],

    DATA: [
        { id: 1, name: 'url', age: 40, email: 'billy@salesforce.com' },
        { id: 2, name: 'url', age: 35, email: 'kelsey@salesforce.com' },
        { id: 3, name: 'url', age: 50, email: 'kyle@salesforce.com' },
        {
            id: 4,
            name: 'url',
            age: 37,
            email: 'krystina@salesforce.com',
        },
    ],
    
    setColumns: function(cmp) {
        cmp.set('v.columns', this.COLUMNS);
    },

    setData: function(cmp) {
        cmp.set('v.data', this.DATA);
    },

    // Used to sort the 'Age' column
    sortBy: function(field, reverse, primer) {
        var key = primer
            ? function(x) {
                  return primer(x[field]);
              }
            : function(x) {
                  return x[field];
              };

        return function(a, b) {
            a = key(a);
            b = key(b);
            return reverse * ((a > b) - (b > a));
        };
    },

    handleSort: function(cmp, event) {
        var sortedBy = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');

        var cloneData = this.DATA.slice(0);
        cloneData.sort((this.sortBy(sortedBy, sortDirection === 'asc' ? 1 : -1)));
        
        cmp.set('v.data', cloneData);
        cmp.set('v.sortDirection', sortDirection);
        cmp.set('v.sortedBy', sortedBy);
    }
})