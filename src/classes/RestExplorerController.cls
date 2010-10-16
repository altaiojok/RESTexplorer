public class RestExplorerController {
    public String url{get; set;}
    public String rawResponse{get; private set;}
    public String response{get; private set;}
    
    private RestClient client;
    private RestResponseInstrumenter insturmenter;
    
    public RestExplorerController() {        
        //prime the REST client
        final String staticBaseUrl = 'https://tapp0.salesforce.com'; //TODO: inject hostname in from VisualForce or custom setting
        final String sessionId = UserInfo.getSessionId();
        ConnectorConfig config = new ConnectorConfig(staticBaseUrl, sessionId);
        client = new RestClient(config);
        
        insturmenter = new RestResponseInstrumenter(ApexPages.currentPage().getUrl());
        
        url = ApexPages.currentPage().getParameters().get('url');
        if(url == null) {
            url = '/services/data';
        }
        
        if (ApexPages.currentPage().getParameters().get('autoExec') != null) {
            execute();
        }
    }

    public void execute() {
        rawResponse = client.get(url);
        response = insturmenter.instrument(rawResponse);
    }
}