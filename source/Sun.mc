using Toybox.Graphics as Gfx;
using Toybox.Time.Gregorian as Greg;
using Toybox.Time;
import Toybox.Lang;
using Toybox.Position;

module Sun {

    var _sunriseTime = -1;
    var _sunsetTime = -1;

    function calculate(){
        Utils.log("updating sunset and sunrise");
        var sc = new SunCalc();
        var info = Position.getInfo();
        if (info != null && info.accuracy != Position.QUALITY_NOT_AVAILABLE) {
            var loc = info.position.toRadians();
            var now = Time.now();
            var sunrise_moment = sc.calculate(now, loc, SUNRISE);
            var sunset_moment = sc.calculate(now, loc, SUNSET);
            var timeInfoSunrise = Greg.info(sunrise_moment, Time.FORMAT_SHORT);
            var timeInfoSunset = Greg.info(sunset_moment, Time.FORMAT_SHORT);
            _sunriseTime = timeInfoSunrise.hour.format("%01d") + ":" + timeInfoSunrise.min.format("%02d");
            _sunsetTime = timeInfoSunset.hour.format("%01d") + ":" + timeInfoSunset.min.format("%02d");
            Utils.persist("sunriseTime",_sunriseTime);
            Utils.persist("sunsetTime",_sunsetTime);
        }  
    } 
    
    function setSunrise(sunrise) {
        if(_sunriseTime == -1){
           _sunriseTime = Utils.get_from_storage("sunriseTime");     
        }
        sunrise.setText(_sunriseTime);
    }

     function setSunset(sunset) {
        if(_sunsetTime == -1){
           _sunsetTime = Utils.get_from_storage("sunsetTime");     
        }
        sunset.setText(_sunsetTime);
    }
        
}