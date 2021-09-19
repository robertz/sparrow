component extends = "models.Sparrow" {
    this.name = "sparrow";
    this.clientManagement = true;

    variables['fwSettings'] = {
        'defaultHandler': "main",
        'defaultAction': "index"
    };

}