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
        // strip existing URL param from url to form base url
        baseUrl = new Insturmentation(Pattern.compile('[?]url=[^&]*[&]'),'?').instrument(baseUrl); // url is first and followed by other params
        baseUrl = new Insturmentation(Pattern.compile('[?&]url=[^&]*'),'').instrument(baseUrl);    // url is second or first and not followed 
        baseUrl += baseUrl.contains('?') ? '&' : '?'; 
        
        final String restBasePattern = '/services/data/v\\d+\\.\\d';
            
        // any rest url
        insturmentations.add(new Insturmentation(Pattern.compile('\"(' + restBasePattern + '.*)\"'),
                                                                 '\"<a href=' + baseUrl + 'url=$1>$1</a>\"'));
                       
        // sobject url                                                         
        insturmentations.add(new Insturmentation(Pattern.compile('>(' + restBasePattern + '/sobject.*)'),
                                                                 '&autoExec=1>$1'));                                                         
      
        // recent url                                                         
        insturmentations.add(new Insturmentation(Pattern.compile('>(' + restBasePattern + '/recent.*)'),
                                                                 '&autoExec=1>$1'));  

        // query url                                                         
        insturmentations.add(new Insturmentation(Pattern.compile('(' + restBasePattern + '/query)<'),
                                                                 '$1</a>&nbsp;<a class=miniLink href=' + baseUrl + 'url=$1?q=SELECT%2Bid,name,profile.name%2BFROM%2Buser%2BWHERE%2BlastName=\'' + UserInfo.getLastName() + '\'&autoExec=1>SAMPLE<'));  

        // search url                                                         
        insturmentations.add(new Insturmentation(Pattern.compile('(' + restBasePattern + '/search)<'),
                                                                 '$1</a>&nbsp;<a class=miniLink href=' + baseUrl + 'url=$1?q=FIND%2B%7B' + UserInfo.getLastName() + '%7D%2BIN%2BALL%2BFIELDS&autoExec=1>SAMPLE<'));  

    }

    public String instrument(String s) {
        for (Insturmentation i : insturmentations) {
            s = i.instrument(s);
        }
        return s;
    }
}