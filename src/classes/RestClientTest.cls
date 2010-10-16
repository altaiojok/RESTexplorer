@isTest
private class RestClientTest {
    
    private class RestClientSpy extends RestClient {

        private Integer sendCount = 0;
        private HttpRequest httpRequest;
        
        RestClientSpy() {
            super(new ConnectorConfig('https://tapp0.salesforce.com', UserInfo.getSessionId()));
        }
        
        public HttpResponse send(HttpRequest httpRequest) {
            this.sendCount++;
            this.httpRequest = httpRequest;
            return new HttpResponse();
        }
        
        Integer getSendCount() {
            return sendCount;
        }
        
        HttpRequest getHttpRequest() {
            return httpRequest;
        }
    }

    static testmethod void testGet() { 
        RestClientSpy spy = new RestClientSpy();
        
        spy.get('/services/data');
        
        System.assertEquals(1, spy.getSendCount());
        System.assertEquals(null, spy.getHttpRequest().getBody()); 
        System.assertEquals('GET', spy.getHttpRequest().getMethod()); 
    }
        
    static testmethod void testPost() { 
        RestClientSpy spy = new RestClientSpy();
        
        final String expectedBody = 'xxx';
        spy.post('/services/data', expectedBody);
        
        System.assertEquals(1, spy.getSendCount());
        System.assertEquals(expectedBody, spy.getHttpRequest().getBody()); 
        System.assertEquals('POST', spy.getHttpRequest().getMethod()); 
    }
    
        
    static testmethod void testPatch() { 
        RestClientSpy spy = new RestClientSpy();
        
        final String expectedBody = 'xxx';
        spy.patch('/services/data', expectedBody);
        
        System.assertEquals(1, spy.getSendCount());
        System.assertEquals(expectedBody, spy.getHttpRequest().getBody()); 
        System.assertEquals('PATCH', spy.getHttpRequest().getMethod()); 
    }
}