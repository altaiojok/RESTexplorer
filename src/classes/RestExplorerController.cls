public class RestExplorerController {  
    public String url {get; set;}
    public String requestBody {get; set;}
    public String requestMethod {get; set;}
    public String rawResponseHeaders {get; private set;}
    public String rawResponse {get; private set;}
    public String response {get; private set;}
    
    private RestClient client;
    private RestResponseInstrumenter insturmenter;
    
    public RestExplorerController() {        
        final String staticBaseUrl = RestExplorerConfig__c.getInstance('baseUrl').value__c;
        final String sessionId = UserInfo.getSessionId();
        ConnectorConfig config = new ConnectorConfig(staticBaseUrl, sessionId);
        client = new RestClient(config);
        
        requestMethod = RequestMethods.GET.name();
        
        insturmenter = new RestResponseInstrumenter(ApexPages.currentPage().getUrl());
        
        url = ApexPages.currentPage().getParameters().get('url');
        if(url == null) {
            url = '/services/data';
        }
        
        if (ApexPages.currentPage().getParameters().get('autoExec') == '1') {
            execute();
        }
    }

    public List<SelectOption> getAvailableRequestMethods() {
        List<SelectOption> options = new List<SelectOption>(); 
        
        for (RequestMethods rm : RequestMethods.values()) {
            options.add(new SelectOption(rm.name(), rm.name()));     
        }
         
        return options; 
    }


    public void execute() {
        // clear any old values, in case we don't populate them on this request
        rawResponseHeaders = null;
        rawResponse = null;
        response = null;
        ApexPages.currentPage().getParameters().put('autoExec',null);
        
        // send the resonse
        HttpResponse httpResponse = client.send(requestMethod,
                                                url, 
                                                RequestMethods.POST.name().equals(requestMethod) 
                                                    ? requestBody 
                                                    : null
                                               );
        
        // process the headers
        rawResponseHeaders = '';                 
        for (String headerKey : httpResponse.getHeaderKeys()) {
            if (headerKey == null) continue;
            rawResponseHeaders += headerKey + ': ' + httpResponse.getHeader(headerKey) + '\n';
        }
        
        // process the body
        rawResponse = httpResponse.getBody();
        response = insturmenter.instrument(rawResponse);
    }
}