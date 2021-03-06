using Toybox.WatchUi as Ui;
using Toybox.Communications as Comm;
using Toybox.Attention as Attention;
using Toybox.System as Sys;

class ImageNotifyDelegate extends Ui.BehaviorDelegate
{
	hidden var size;
	hidden var notify;

	function initialize(s, handler) {
        Ui.BehaviorDelegate.initialize();
        size = s;
        notify = handler;
        if(Comm has :registerForPhoneAppMessages) {
            Comm.registerForPhoneAppMessages(method(:onMsg));
        } else {
            Comm.setMailboxListener(method(:onMail));
        }
        if (size == 0) {
        	Comm.makeWebRequest(
            	"http://127.0.0.1:8080/",
				{},
				{
               		"Content-Type" => Comm.REQUEST_CONTENT_TYPE_URL_ENCODED
            	},
            	method(:onReceive)
        	);
        }
        
     }

    function onKey(evt) {
        var key = evt.getKey();
 		if ( key == KEY_ENTER ) {
    		Comm.makeWebRequest(
            	"http://127.0.0.1:8080/",
				{},
				{
               		"Content-Type" => Comm.REQUEST_CONTENT_TYPE_URL_ENCODED
            	},
            	method(:onReceive)
        	);
 			return true;
 		}
 	
        return Ui.BehaviorDelegate.onKey(evt); 
    }
    
    function onReceive(responseCode, data) {
        if( responseCode == 200 ) {
        	size = data["count"].toNumber();
 			notify.invoke(size);
        }
        else {
            size = 0;
            notify.invoke(0);
        }
    }
    
    function onMail(mailIter)
    {
    	Sys.println("onMail");
    	try {
    	Comm.makeWebRequest(
				"http://127.0.0.1:8080/",
				{},
				{
            		"Content-Type" => Comm.REQUEST_CONTENT_TYPE_URL_ENCODED
            	},
            	method(:onReceive)
        );
        	//Comm.emptyMailbox();
        }
        catch (ex) {
        	Sys.println(ex.getErrorMessage());
        }
    }
    function onMsg(msg) {
       	Sys.println("onMsg");
    	try {
    		Comm.makeWebRequest(
				"http://127.0.0.1:8080/",
				{},
				{
            		"Content-Type" => Comm.REQUEST_CONTENT_TYPE_URL_ENCODED
            	},
            	method(:onReceive)
        	);
       }
        catch (ex) {
        	Sys.println(ex.getErrorMessage());
        }
    
    }

}
