HTMLWidgets.widget({

  name: 'reactjson',

  type: 'output',

  factory: function(el, width, height) {

    // TODO: define shared variables for this instance

    return {

      renderValue: function(x) {

          ReactDOM.render(
            React.createElement(
              Json,
              {
                value: (typeof(x.data)==="string") ? JSON.parse(x.data) : x.data,
                onChange: logChange
              }
            ),
            document.body
          );

          function logChange( value ){
            console.log( value );
            if(typeof(Shiny) !== "undefined"){
              Shiny.onInputChange(el.id + "_change", {value:value});
            }
          }

      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size

      }

    };
  }
});
