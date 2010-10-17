public class RestExplorerController {
    public String url{get; set;}
    public String rawResponse{get; private set;}
    public String response{get; private set;}
    
    private RestClient client;
    private RestResponseInstrumenter insturmenter;
    
    public RestExplorerController() {        
        final String staticBaseUrl = RestExplorerConfig__c.getInstance('baseUrl').value__c;
        final String sessionId = UserInfo.getSessionId();
        ConnectorConfig config = new ConnectorConfig(staticBaseUrl, sessionId);
        client = new RestClient(config);
        
        insturmenter = new RestResponseInstrumenter(ApexPages.currentPage().getUrl());
        
        url = ApexPages.currentPage().getParameters().get('url');
        if(url == null) {
            url = '/services/data';
        }
        
        if (ApexPages.currentPage().getParameters().get('autoExec') == '1') {
            execute();
        }
    }

    public void execute() {
        ApexPages.currentPage().getParameters().put('autoExec',null);
        rawResponse = client.get(url);
        response = insturmenter.instrument(rawResponse);
    }
}