import Toybox.Application;
import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;

class Background extends WatchUi.Drawable {

    function initialize() {
        var dictionary = {
            :identifier => "Background"
        };

        Drawable.initialize(dictionary);
    }

    function draw(dc as Dc) as Void {

        // Set the background color then call to clear the screen
        //dc.setColor(Graphics.COLOR_TRANSPARENT, getApp().getProperty("BackgroundColor") as Number);
        //dc.clear();
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);

        // horizontal lines
        dc.drawLine(0, 42, 280, 42);
        //dc.drawLine(0, 105, 280, 105);
        //dc.drawLine(0, 175, 280, 175);
        dc.drawLine(0, 227, 280, 227);

        //vertical middle lines 
        dc.drawLine(140,0,140,42);
        dc.drawLine(140,255,140,280);

        //vertical 1/3 lines
        dc.drawLine(90, 42, 90, 105);
        dc.drawLine(186, 42, 186, 105);
        //dc.drawLine(94, 175, 94, 227);
        //dc.drawLine(186, 175, 186, 227);

        // time white rectangle
        // ###### 
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(0, 95, 280, 80);

        // allah icons
        var icon_ism_width = 40;
        var icon_ism_height = 40;
        //dc.drawBitmap(140-icon_ism_width/2, 70-icon_ism_height/2, Application.loadResource(Rez.Drawables.allah));
        
        // sun icons
        dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_TRANSPARENT);
        dc.drawText(125, 9, Utils.getWeatherFont(), "Z", Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
        dc.drawText(216, 30, Utils.getWeatherFont(), "[", Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
    
        // Triathlon icons

        dc.drawBitmap(95,180, Application.loadResource(Rez.Drawables.bike));
        dc.drawBitmap(180,180, Application.loadResource(Rez.Drawables.run));
        dc.drawBitmap(12,182, Application.loadResource(Rez.Drawables.swim));

        // bluetooth
        if(System.getDeviceSettings().phoneConnected){
            dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
        }
        else{
            dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        }       
        dc.drawText(202,245, Utils.getIconsFont(), "8", Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
    
        // heartrate
        dc.drawBitmap(63,226, Application.loadResource(Rez.Drawables.heart));

        //var minHR = ActivityMonitor.getHeartRateHistory(new Time.Duration(12*3600), true).getMin();
        //dc.drawText(85,245, Graphics.FONT_TINY, minHR.toString(), Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
        // The user's seven day average resting heart rate (bpm).
        //var profile = UserProfile.getProfile();
        //var avgHR = profile.averageRestingHeartRate;
        //var averageRestingHeartRate = profile.averageRestingHeartRate;
        //dc.drawText(85,241, Graphics.FONT_XTINY, minHR.toString(), Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(85,246, Graphics.FONT_TINY, UserProfile.getProfile().averageRestingHeartRate.toString(), Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);


        // battery
        var _battery = System.getSystemStats().battery.toNumber();
        var _batteryInDays = System.getSystemStats().batteryInDays.toNumber();
        dc.drawText(145,260, Graphics.FONT_TINY, _battery.toString()+"%", Graphics.TEXT_JUSTIFY_LEFT|Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(135,260, Graphics.FONT_TINY, _batteryInDays+"d", Graphics.TEXT_JUSTIFY_RIGHT|Graphics.TEXT_JUSTIFY_VCENTER);

        if(_battery<=20){
            dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
        }
        else if(_battery<=40 and _battery>20){
            dc.setColor(Graphics.COLOR_ORANGE, Graphics.COLOR_TRANSPARENT);
        }
        else if(_battery<=60 and _battery>40){
            dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_TRANSPARENT);
        }
        else{
            dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
        }
        dc.drawText(140,240, Utils.getIconsFont(), "9", Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER); 
    
        //ironman
        //dc.drawBitmap(2,97, Application.loadResource(Rez.Drawables.ironman));


    }
    

}
