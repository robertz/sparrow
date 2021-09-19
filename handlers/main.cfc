component {

    function index(rc, prc) {
        rc['more'] = "Some cool stuff here";

        prc['other'] = "The private requests context";
        //writeDump(var = [rc, prc], abort = 1);
    }

    function welcome (rc, prc) {

    }
}
