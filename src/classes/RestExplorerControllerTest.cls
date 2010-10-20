@isTest
private class RestExplorerControllerTest {

    static testmethod void testInitialization() {
        Test.setCurrentPage(Page.RestExplorer);
        
        RestExplorerController c = new RestExplorerController();
        
        System.assertEquals('/services/data', c.url);
        System.assertEquals(null, c.response);
        System.assertEquals(null, c.rawResponse);
    }

    static testmethod void testAutoExecution() {
        Test.setCurrentPage(Page.RestExplorer);
        ApexPages.currentPage().getParameters().put('autoExec', '1');
        RestExplorerController c = new RestExplorerController();
        
        System.assertEquals('/services/data', c.url);
        System.assert(c.response.contains('version'));
        System.assert(c.rawResponse.contains('version'));
    }

    static testmethod void testCustomUrl() {
        Test.setCurrentPage(Page.RestExplorer);
        final String customUrl = 'xxx';
        ApexPages.currentPage().getParameters().put('url', customUrl);
        RestExplorerController c = new RestExplorerController();
        
        System.assertEquals(customUrl, c.url);
    }

    static testmethod void testGetAvailableRequestMethodsl() {
        Test.setCurrentPage(Page.RestExplorer);

        RestExplorerController c = new RestExplorerController();
        
        System.assert(null != c.getAvailableRequestMethods());
    }
}