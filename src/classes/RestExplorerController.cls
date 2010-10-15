public class RestExplorerController {
    public String baseUrl{get; set;}
    public String url{get; set;}
    public RequestMethods requestMethod{get; set;}
    public String requestBody{get; set;}
    public String rawResponse{get; private set;}
    public String response{get; private set;}
    
    
    private RestClient client;
    
    private Pattern apiBaseUrl = Pattern.compile('/services/data/v[0-9]..[0-9]/');
    private Pattern queryUrl = Pattern.compile('(/services/data/v[0-9]..[0-9]/query)<');
    private Pattern recentUrl = Pattern.compile('>(/services/data/v[0-9]..[0-9]/recent.*)');
    private Pattern searchUrl = Pattern.compile('(/services/data/v[0-9]..[0-9]/search)<');
    private Pattern sobjectUrl = Pattern.compile('>(/services/data/v[0-9]..[0-9]/sobject.*)');
    private Pattern anyRestUrl = Pattern.compile('\"(/services/data/v[0-9]..[0-9].*)\"');
        
    
    public RestExplorerController() {
        
        //TODO: inject hostname in from VisualForce
        String staticBaseUrl = 'https://tapp0.salesforce.com';
        
        final String sessionId = UserInfo.getSessionId();
        url = ApexPages.currentPage().getParameters().get('url');
        if(url == null) {
            url = '/services/data/v20.0';
        }
        
        requestBody = '';
        requestMethod = RequestMethods.GET;
        
        //prime the REST client
        ConnectorConfig config = new ConnectorConfig(staticBaseUrl, sessionId);
        client = new RestClient(config);
        
        if (ApexPages.currentPage().getParameters().get('autoExec') != null) {
            execute();
        }
    }

    public void execute() {
        if (requestMethod == RequestMethods.GET) {
            executeGet();
        }
        else if (requestMethod == RequestMethods.POST) {
            executePost();
        }
        else if (requestMethod == RequestMethods.PATCH) {
            executePatch();
        }
        else {
            executeGet();    //default
        }
        
        //make all of the URLs hyperlinks
        Matcher matcher = anyRestUrl.matcher(rawResponse);
        if(matcher.find()) {
            response = matcher.replaceAll('\"<a href=' + Page.RestExplorer.getUrl() + '?url=$1>$1</a>\"');      
        }
        else {
            response = rawResponse;
        }
        
        //add auto-execute to sobjects
        matcher = sobjectUrl.matcher(response);
        if(matcher.find()) {
            response = matcher.replaceAll('&autoExec=1>$1');
        }
        
        //add auto-execute to recent results
        matcher = recentUrl.matcher(response);
        if(matcher.find()) {
            response = matcher.replaceAll('&autoExec=1>$1');
        }
        
        //fill out the query hyperlink
        matcher = queryUrl.matcher(response);
        if(matcher.find()) {
            response = matcher.replaceAll('$1</a>&nbsp;<a class=miniLink href=' + Page.RestExplorer.getUrl() + '?url=$1?q=SELECT%2Bid,name,profile.name%2BFROM%2Buser%2BWHERE%2BlastName=\'' + UserInfo.getLastName() + '\'&autoExec=1>SAMPLE<');
        }
        
        //fill out the search hyperlink
        matcher = searchUrl.matcher(response);
        if(matcher.find()) {
            response = matcher.replaceAll('$1</a>&nbsp;<a class=miniLink href=' + Page.RestExplorer.getUrl() + '?url=$1?q=FIND%2B%7B' + UserInfo.getLastName() + '%7D%2BIN%2BALL%2BFIELDS&autoExec=1>SAMPLE<');
        }
        
    }
        
    public void executeGet() {
        rawResponse = client.get(url);
    }
    
    public void executePost() {
        rawResponse = client.post(url, requestBody);
    }
        
    public void executePatch() {
        rawResponse = client.patch(url, requestBody);       
    }
    
}