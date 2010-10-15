@isTest
private class RestClientTest {

    static testMethod void testAuthentication() {
        final String baseUrl = 'https://tapp0.salesforce.com';
        final String sessionId = UserInfo.getSessionId();
        ConnectorConfig config = new ConnectorConfig(baseUrl, sessionId);
 
        String response = new RestClient(config).get('/services/data/v20.0');
        System.assert(null != response); 
        System.debug(response);
    }
}