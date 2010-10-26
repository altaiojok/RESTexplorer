public class RestResponseInstrumenter {

    private class Insturmentation {
        private final Pattern pattern;
        private final String replacement; 
        
        Insturmentation(Pattern pattern, String replacement) {
            this.pattern = pattern;
            this.replacement = replacement;
        }
        
        String instrument(final String s) {
            final Matcher matcher = pattern.matcher(s);
            matcher.find();
            return matcher.replaceAll(replacement);      
        }
    }
    
    private final List<Insturmentation> insturmentations = new List<Insturmentation>();
    
    public RestResponseInstrumenter(String baseUrl) {
        // strip existing url or autoExec param from url to form base url
        baseUrl = new Insturmentation(Pattern.compile('[?](autoExec|url)=[^&]*[&]'),'?').instrument(baseUrl);
        baseUrl = new Insturmentation(Pattern.compile('[?&](autoExec|url)=[^&]*'),'').instrument(baseUrl);
        baseUrl += baseUrl.contains('?') ? '&' : '?';
        
        final String restBasePattern = '/services/data/v\\d+\\.\\d';
            
        // add link url to any rest url
        insturmentations.add(new Insturmentation(Pattern.compile('\"(' + restBasePattern + '.*)\"'),
                                                                 '\"<a class=\'RestLinkable\' href=' + baseUrl + 'url=$1&autoExec=0>$1</a>\"'));

        // add autoExec to everything but query and search
        insturmentations.add(new Insturmentation(Pattern.compile('(url=' + restBasePattern + '(?!/query|/search|.*/.*\\{ID\\}).*&)autoExec=0'),
                                                                 '$1autoExec=1'));

        // query url                                                         
        insturmentations.add(new Insturmentation(Pattern.compile('(' + restBasePattern + '/query)<'),
                                                                 '$1</a>&nbsp;<a class=\'miniLink RestLinkable\' href=' + baseUrl + 'url=$1?q=SELECT%2Bid,name,profile.name%2BFROM%2Buser%2BWHERE%2BlastName=\'' + UserInfo.getLastName() + '\'&autoExec=1>SAMPLE<'));  

        // search url                                                         
        insturmentations.add(new Insturmentation(Pattern.compile('(' + restBasePattern + '/search)<'),
                                                                 '$1</a>&nbsp;<a class=\'miniLink RestLinkable\' href=' + baseUrl + 'url=$1?q=FIND%2B%7B' + UserInfo.getLastName() + '%7D%2BIN%2BALL%2BFIELDS&autoExec=1>SAMPLE<'));  

    }

    public String instrument(String s) {
        for (Insturmentation i : insturmentations) {
            s = i.instrument(s);
        }
        return s;
    }
}