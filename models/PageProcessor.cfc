component output=false {

    function processPath (required string pathInfo) {
        saveContent variable = "out" {
            include template = "/views/#pathInfo#.cfm";
        }
        return out;
    }
}