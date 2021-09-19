component {
    public any function init () {
        return this;
    }

    public boolean function onRequestStart (required string targetPage) {
        return true;
    }

    public void function onRequest(required string targetPage) {
        if(!cgi.path_info.listLen("/")) location(url = "/main", addToken = false);
        var out = "";
        variables['rc'] = {
            'handler': getHandler(),
            'action': getAction()
        };
        variables['prc'] = {};
        mergeScopes();
        processHandler(rc, prc);
        if(directoryExists(expandPath(".") & "/views/#rc.handler#") && !fileExists(expandPath(".") & "/views/#rc.handler#/#rc.action#.cfm")) {
            if(fileExists(expandPath(".") & "/views/#rc.handler#/index.cfm")) {
                saveContent variable = "out" {
                    include "/views/#rc.handler#/index.cfm";
                }
            }
        }
        if(fileExists(expandPath(".") & "/views/#rc.handler#/#rc.action#.cfm")) {
            saveContent variable = "out" {
                include "/views/#rc.handler#/#rc.action#.cfm";
            }
        }

        writeOutput(processLayout("/layouts/main.cfm", out));
        return;
    }

    private string function getHandler () {
        return cgi.path_info.listGetAt(1, "/");
    }

    private string function getAction () {
        return cgi.path_info.listLen("/") > 1 ? cgi.path_info.listGetAt(2, "/") : "index";
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
            obj[rc.action](rc, prc);
        }
        catch (any e) {}
    }

    private string function processLayout (string layout = "/layouts/main.cfm", string body) {
        saveContent variable="response" {
            include '#layout#';
        }
        return response;
    }
}