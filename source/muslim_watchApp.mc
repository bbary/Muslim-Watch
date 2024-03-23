import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Background;

(:background)
class muslim_watchApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() as Array<Views or InputDelegates>? {
        InitBackgroundEvents();
        return [ new muslim_watchView() ] as Array<Views or InputDelegates>;
    }

    // New app settings have been received so trigger a UI update
    function onSettingsChanged() as Void {
        WatchUi.requestUpdate();
    }

    function getServiceDelegate()
    {
        return [new BackgroundServiceDelegate()];
    }
    
    function InitBackgroundEvents()
    {
		if (Background.getLastTemporalEventTime() != null) {
    		Background.registerForTemporalEvent(new Toybox.Time.Duration(3* 60 * 60));
		}else{
    		Background.registerForTemporalEvent(Time.now());
		}
    }

}

function getApp() as muslim_watchApp {
    return Application.getApp() as muslim_watchApp;
}