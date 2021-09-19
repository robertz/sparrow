component {
    public any function init () {
        return this;
    }

    // ===============================================================================================================
    // Application.cfc specific functions
    // ===============================================================================================================
    public boolean function onRequestStart (required string targetPage) {
        return true;
    }

    public void function onRequest(required string targetPage) {
        // redirect to main handler if one was not supplied
        if(!cgi.path_info.listLen("/")) location(url = "/" & variables.fwSettings.defaultHandler, addToken = false);
        variables['rc'] = {
            'handler': getHandler(),
            'action': getAction()
        };
        variables['prc'] = {};
        // merge url, form, and path params to rc scope
        mergeScopes();
        // execute the handler if it is present
        processHandler(rc, prc);
        // place the body in the layout
        writeOutput(processLayout("/layouts/main.cfm", processView()));
        return;
    }

    // ===============================================================================================================
    // Framework specific functions
    // ===============================================================================================================
    private string function getHandler () {
        return cgi.path_info.listGetAt(1, "/");
    }

    private string function getAction () {
        return cgi.path_info.listLen("/") > 1 ? cgi.path_info.listGetAt(2, "/") : variables.fwSettings.defaultAction;
    }

    private void function mergeScopes () {
        rc.append(url);
        rc.append(form);
        var path = cgi.path_info.listToArray("/");
        // merge additional path_info values into rc scope
        if(path.len() > 2){
            path.deleteAt(2);
            path.deleteAt(1);
            for(var i = 1; i <= path.len(); i += 2){
                rc[path[i]] = (i + 1) <= path.len() ? path[i + 1] : "";
            }
        }
    }

    private void function processHandler (required struct rc, required struct prc) {
        // check to see if the handler exists
        try {
            var obj = createObject("component", "handlers." & rc.handler);
            if(isDefined('obj.' & rc.action)) obj[rc.action](rc, prc);
        }
        catch (any e) {
            writeOutput("<h3>Sparrow :: Missing Handler</h3>");
            writeOutput("The handler <strong>" & rc.handler & "</strong> does not exist!");
            abort;
        }
    }

    private string function processView (string view) {
        var out = "";
        // generate the main body
        if(directoryExists(expandPath(".") & "/views/#rc.handler#") && !fileExists(expandPath(".") & "/views/#rc.handler#/#rc.action#.cfm")) {
            if(fileExists(expandPath(".") & "/views/#rc.handler#/index.cfm") && rc.action == variables.fwSettings.defaultAction) {
                saveContent variable = "out" {
                    include "/views/#rc.handler#/index.cfm";
                }
            }
            // missing view
            writeOutput("<h3>Sparrow :: Missing view</h3>");
            writeOutput("The view <strong>" & rc.handler & "/" & rc.action & "</strong> does not exist!");
            abort;
        }
        if(fileExists(expandPath(".") & "/views/#rc.handler#/#rc.action#.cfm")) {
            saveContent variable = "out" {
                include "/views/#rc.handler#/#rc.action#.cfm";
            }
        }
        return out;
    }

    private string function processLayout (string layout = "/layouts/main.cfm", string body) {
        saveContent variable="response" {
            include "#layout#";
        }
        return response;
    }

    public string function renderView (string view = "") {
        var out = "";
        try{
            saveContent variable = "out" {
                include "/views/#view#.cfm";
            }
        }
        catch(any e){}
        return out;
    }

}