# Sparrow: A lightweight CF Framework

Sparrow is a light CF framework I wrote just to see if I could modeled after ColdBox and 
Framework One.

### Conventions
* handlers
* layouts
* models
* views

Sparrow works by parsing out the path_info from the url. Here is a very simple example:

https://127.0.0.1/main/index

The example above will execute the _*index*_ function in the _*main*_ handler and will try
to render the response using _*views/main/index.cfm*_.

Additional values in the path info will be interpreted as key/value pairs and added to the rc
scope.

