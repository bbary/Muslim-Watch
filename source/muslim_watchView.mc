import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class muslim_watchView extends WatchUi.WatchFace {

    var lastUpdateTime = -1;
    var now;

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }


     /***
    executed Once per minute in Watch Faces when in low power mode
    Once per second in Watch Faces when in high power mode

    A WatchFace will run in a high power mode for a short period when responding to a gesture 
    (i.e., raising the watch to check the time) or when returning to the watch face from another application. 
    While in high power mode, the watch face will perform full screen updates every second via calls to onUpdate(), 
    and the application will have access to timers and animations.

    After this period in high power mode (typically about ten seconds), the system will call onEnterSleep() 
    to notify the application that it is preparing to enter low power mode.

    During low power mode the system will call onUpdate() at the top of every minute. 
    If partial update support is available, the onPartialUpdate() method will be called 
    for the first 59 seconds of every minute. The application will not have access to timers or animations 
    while in low power mode.

    When a gesture occurs while running in low power mode the system will call onExitSleep() 
    to notify the application that the transition to high power mode has occurred.
    ***/
    function onUpdate(dc as Dc) as Void {
        
        // updating Garmin weather (condiiton icon, high and lows, pop), sunrise, sunset and totals every 30min =1800s in low power mode
        
        // if we loose the memory (quit the watch face)
        if (lastUpdateTime == -1){
            lastUpdateTime = Storage.getValue("lastUpdateTime");    
        }
        // first time
        if(lastUpdateTime == null){
            Storage.setValue("lastUpdateTime",0);    
            lastUpdateTime = 0;
        }
        now = Time.now().value();
        if((now-lastUpdateTime)>10800){
            Utils.log("updating sun and triathlon totals (occurs every 3 hours)");
            lastUpdateTime = now;
            Storage.setValue("lastUpdateTime",now);    
            Triathlon.getThisWeekTotals();
            Sun.calculate();
            Asma.chooseIsm();
        }
        
        

        
        var sunrise = View.findDrawableById("Sunrise") as Text;
        var sunset = View.findDrawableById("Sunset") as Text;


        var hijri_date_month = View.findDrawableById("HijriDateMonth") as Text;
        var hijri_date_day = View.findDrawableById("HijriDateDay") as Text;

        var ism = View.findDrawableById("Ism") as Text;

        var next_salat = View.findDrawableById("NextSalat") as Text;
        var next_salat_time = View.findDrawableById("NextSalatTime") as Text;

        var total_swim = View.findDrawableById("TotalSwim") as Text;
        var total_bike = View.findDrawableById("TotalBike") as Text;
        var total_run = View.findDrawableById("TotalRun") as Text;

        var total_swim_lastweek = View.findDrawableById("TotalSwim_lastweek") as Text;
        var total_bike_lastweek = View.findDrawableById("TotalBike_lastweek") as Text;
        var total_run_lastweek = View.findDrawableById("TotalRun_lastweek") as Text;

        Sun.setSunrise(sunrise);
        Sun.setSunset(sunset);


        Salat.setNextPrayer(next_salat);
        Salat.setSalatTime(next_salat_time);

        Asma.setIsm(ism);
        //Asma.testIsm(ism);
        

        Salat.setHijriDay(hijri_date_day);
        Salat.setHijriMonth(hijri_date_month);

        Triathlon.getTotalSwim(total_swim);
        Triathlon.getTotalBike(total_bike);
        Triathlon.getTotalRun(total_run);


        Triathlon.getTotalSwimLastWeek(total_swim_lastweek);
        Triathlon.getTotalBikeLastWeek(total_bike_lastweek);
        Triathlon.getTotalRunLastWeek(total_run_lastweek);


        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);

        // draw time with fluids
        TimeDate.setTimeDate(dc);

    }


    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

}
