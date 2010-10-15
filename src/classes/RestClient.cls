public with sharing class RestClient {
        
    private ConnectorConfig config;
    
    public RestClient(ConnectorConfig config) {
        this.config = config;
    }
    
    public String get(String url) {
        return http(RequestMethods.GET.name(), url, '');
    }
    
    public String post(String url, String body) {
        return http(RequestMethods.POST.name(), url, body);
    }
    
    public String patch(String url, String body) {
        return http(RequestMethods.PATCH.name(), url, body);
    }
    
    private String http(String method, String url, String body) {
        HttpRequest req = new HttpRequest(); 
        req.setEndpoint(config.getBaseUrl() + url);
        req.setHeader('Authorization', 'OAuth ' + config.getSessionId()); 
        req.setHeader('X-PrettyPrint', 'true'); 
        
        //set the body only if it's a POST or PATCH; never for get
        if(method.equals(RequestMethods.POST.name()) || method.equals(RequestMethods.PATCH.name())) {
            req.setBody(body);
        }
        req.setMethod(method);
        return new Http().send(req).getBody(); 
    }
    
}