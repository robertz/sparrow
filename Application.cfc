component extends = "models.Sparrow" {
    this.name = "sparrow";
    this.clientManagement = true;

    variables['fwSettings'] = {
        'defaultHandler': "main",
        'defaultAction': "index",
        'routes': [
            { '/debug/key/:key': '/main/debug' },
            { '/debug': '/main/debug' }
        ]
    };

}