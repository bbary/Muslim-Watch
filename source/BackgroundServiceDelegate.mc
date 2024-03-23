using Toybox.Background;
using Toybox.System as Sys;
using Toybox.Communications as Comm;
using Toybox.Application as App;
using Toybox.Lang as Lang;
import Toybox.Application.Storage;

// The Service Delegate is the main entry point for background processes
// our onTemporalEvent() method will get run each time our periodic event
// is triggered by the system.
//
(:background)
class BackgroundServiceDelegate extends Sys.ServiceDelegate 
{
	hidden var _received = {}; 
	 
	function initialize() 
	{
		Sys.ServiceDelegate.initialize();
	}
	
    function onTemporalEvent() 
    {
    	try
    	{
			// request update without condition, maybe i should check if bluetooth is enabled
			System.println("onTemporalEvent called (every 3 hours)");
			// call adhan API one time a day
			if(Storage.getValue("today") == null or Storage.getValue("today") != Time.today().value()){
            	System.println("calling adhan API one time a day");
				getNextPrayer();
        	}
		}
		catch(ex)
		{
			System.println("[onTemporalEvent] [TRY_CATCH] error: " + ex.getErrorMessage());
			_received.put("isErr", true);
			Background.exit(_received);
		}		 
    }

	function getNextPrayer()
    {
        var options = {
			:method => Comm.HTTP_REQUEST_METHOD_GET,
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
        };

        Comm.makeWebRequest(
            "https://api.aladhan.com/timingsByAddress?address=Paris&method=99&methodSettings=12,4min,80min&tune=0,-4,1,6,2,0,1,0,0",
            {},
            options,
            method(:OnReceiveUpdateNextPrayer)
        );  	
    }

    function OnReceiveUpdateNextPrayer(responseCode as Lang.Number, data as Null or Lang.Dictionary or Lang.String) as Void
	{
		try
		{
			if (responseCode == 200)
			{
				Storage.setValue("timings", data["data"]["timings"]);
				Storage.setValue("hijri_day", data["data"]["date"]["hijri"]["day"]);
				
				switch(data["data"]["date"]["hijri"]["month"]["number"]){
					case 1: 
						Storage.setValue("hijri_month", "محرم");
						break;
					case 2:
						Storage.setValue("hijri_month", "صفر");
						break;
					case 3:
						Storage.setValue("hijri_month", "ربيع ا");
						break;
					case 4:
						Storage.setValue("hijri_month", "ربيع اا");
						break;		
					case 5:
						Storage.setValue("hijri_month", "جمادى ا");
						break;
					case 6:
						Storage.setValue("hijri_month", "جمادى اا");
						break;
					case 7:
						Storage.setValue("hijri_month", "رجب");
						break;
					case 8:
						Storage.setValue("hijri_month", "شعبان");
						break;	
					case 9:
						Storage.setValue("hijri_month", "رمضان");
						break;
					case 10:
						Storage.setValue("hijri_month", "شوال");
						break;
					case 11:
						Storage.setValue("hijri_month", "ذو القعدة");
						break;
					case 12:
						Storage.setValue("hijri_month", "ذو الحجة");
						break;																							
				}
				
				// used to assure that api is called one time a day
				Storage.setValue("today", Time.today().value());
			}
			else
			{
				System.println("[OnReceiveUpdateNextPrayer] ERROR "+responseCode);
				_received.put("isErr", true);
			}

			//Background.exit(_received);
		}
		catch(ex)
		{
			Sys.println("[OnReceiveUpdateNextPrayer] [TRY_CATCH] error : " + ex.getErrorMessage());
			_received.put("isErr", true);
			Background.exit(_received);
		}
	}

}