public with sharing class ConnectorConfig {
    private String baseUrl;
    private String sessionId;
    public Formats format{get;set;}
    
    public ConnectorConfig(String baseUrl, String sessionId) {
        this.baseUrl = baseUrl;
        this.sessionId = sessionId;
        format = Formats.JSON;
    }
    
    public String getBaseUrl() {
        return baseUrl;
    }

    public String getSessionId() {
        return sessionId;
    }
}