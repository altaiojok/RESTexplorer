@isTest
private class RestResponseInstrumenterTest {

    static testmethod void testNoMatchesDoesNotInsturment() {
        String rawResponse = 'ABC\"/services/SOAP/v20.0/sobjects\"XYZ';
        String instResponse = rawResponse;
        System.assertEquals(instResponse, new RestResponseInstrumenter('').instrument(rawResponse));
    }

    static testmethod void testUrlInsturmentionWithSimpleBaseUrl() {
        String baseUrl = 'http://www.example.com';
        String rawResponse = 'ABC\"/services/data/v20.0/sobjects\"XYZ';
        String instResponse = 'ABC\"<a href=' + baseUrl + '?url=/services/data/v20.0/sobjects&autoExec=1>/services/data/v20.0/sobjects</a>\"XYZ';
        System.assertEquals(instResponse, new RestResponseInstrumenter(baseUrl).instrument(rawResponse));
    }
    
    static testmethod void testUrlInsturmentionWithExistingNonUrlQueryParameters() {
        String baseUrl = 'http://www.example.com?lang=en';
        String rawResponse = 'ABC\"/services/data/v20.0/sobjects\"XYZ';
        String instResponse = 'ABC\"<a href=' + baseUrl + '&url=/services/data/v20.0/sobjects&autoExec=1>/services/data/v20.0/sobjects</a>\"XYZ';
        System.assertEquals(instResponse, new RestResponseInstrumenter(baseUrl).instrument(rawResponse));
    }

    static testmethod void testUrlInsturmentionWithUrlQueryParameterAlone() {
        String baseUrl = 'http://www.example.com';
        String existingUrlParam = 'url=xxx';
        String rawResponse = 'ABC\"/services/data/v20.0/sobjects\"XYZ';
        String instResponse = 'ABC\"<a href=' + baseUrl + '?url=/services/data/v20.0/sobjects&autoExec=1>/services/data/v20.0/sobjects</a>\"XYZ';
        System.assertEquals(instResponse, new RestResponseInstrumenter(baseUrl + '?' + existingUrlParam).instrument(rawResponse));
    }

    static testmethod void testUrlInsturmentionWithUrlQueryParameterAsFirstOfTwo() {
        String baseUrl = 'http://www.example.com';
        String existingUrlParam = 'url=xxx';
        String existingOtherParam = 'lang=en';
        String rawResponse = 'ABC\"/services/data/v20.0/sobjects\"XYZ';
        String instResponse = 'ABC\"<a href=' + baseUrl + '?' + existingOtherParam + '&url=/services/data/v20.0/sobjects&autoExec=1>/services/data/v20.0/sobjects</a>\"XYZ';
        System.assertEquals(instResponse, new RestResponseInstrumenter(baseUrl + '?' + existingUrlParam + '&' + existingOtherParam).instrument(rawResponse));
    }

    static testmethod void testUrlInsturmentionWithUrlQueryParameterAsSecondOfTwo() {
        String baseUrl = 'http://www.example.com';
        String existingOtherParam = 'lang=en';
        String existingUrlParam = 'url=xxx';
        String rawResponse = 'ABC\"/services/data/v20.0/sobjects\"XYZ';
        String instResponse = 'ABC\"<a href=' + baseUrl + '?' + existingOtherParam + '&url=/services/data/v20.0/sobjects&autoExec=1>/services/data/v20.0/sobjects</a>\"XYZ';
        System.assertEquals(instResponse, new RestResponseInstrumenter(baseUrl + '?' + existingOtherParam + '&' + existingUrlParam).instrument(rawResponse));
    }

    static testmethod void testSingleDigitApiVersion() {
        String baseUrl = 'http://www.example.com';
        String rawResponse = 'ABC\"/services/data/v2.0/sobjects\"XYZ';
        String instResponse = 'ABC\"<a href=' + baseUrl + '?url=/services/data/v2.0/sobjects&autoExec=1>/services/data/v2.0/sobjects</a>\"XYZ';
        System.assertEquals(instResponse, new RestResponseInstrumenter(baseUrl).instrument(rawResponse));
    }

    static testmethod void testTripleDigitApiVersion() {
        String baseUrl = 'http://www.example.com';
        String rawResponse = 'ABC\"/services/data/v200.0/sobjects\"XYZ';
        String instResponse = 'ABC\"<a href=' + baseUrl + '?url=/services/data/v200.0/sobjects&autoExec=1>/services/data/v200.0/sobjects</a>\"XYZ';
        System.assertEquals(instResponse, new RestResponseInstrumenter(baseUrl).instrument(rawResponse));
    }
            
    static testmethod void testSobjectUrlInsturmention() {
        String rawResponse = 'ABC\"/services/data/v20.0/sobjects\"XYZ';
        String instResponse = 'ABC\"<a href=?url=/services/data/v20.0/sobjects&autoExec=1>/services/data/v20.0/sobjects</a>\"XYZ';
        System.assertEquals(instResponse, new RestResponseInstrumenter('').instrument(rawResponse));
    }

    static testmethod void testRecentUrlInsturmention() {
        String rawResponse = 'ABC\"/services/data/v20.0/recent\"XYZ';
        String instResponse = 'ABC\"<a href=?url=/services/data/v20.0/recent&autoExec=1>/services/data/v20.0/recent</a>\"XYZ';
        System.assertEquals(instResponse, new RestResponseInstrumenter('').instrument(rawResponse));
    }

    static testmethod void testQueryUrlInsturmention() {
        String rawResponse = 'ABC\"/services/data/v20.0/query\"XYZ';
        String instResponse = 'ABC\"<a href=?url=/services/data/v20.0/query>/services/data/v20.0/query</a>&nbsp;<a class=miniLink href=?url=/services/data/v20.0/query?q=SELECT%2Bid,name,profile.name%2BFROM%2Buser%2BWHERE%2BlastName=\'' + UserInfo.getLastName() + '\'&autoExec=1>SAMPLE</a>\"XYZ';
        System.assertEquals(instResponse, new RestResponseInstrumenter('').instrument(rawResponse));
    }

    static testmethod void testSearchUrlInsturmention() {
        String rawResponse = 'ABC\"/services/data/v20.0/search\"XYZ';
        String instResponse = 'ABC\"<a href=?url=/services/data/v20.0/search>/services/data/v20.0/search</a>&nbsp;<a class=miniLink href=?url=/services/data/v20.0/search?q=FIND%2B%7B' + UserInfo.getLastName() + '%7D%2BIN%2BALL%2BFIELDS&autoExec=1>SAMPLE</a>\"XYZ';
        System.assertEquals(instResponse, new RestResponseInstrumenter('').instrument(rawResponse));
    }
}