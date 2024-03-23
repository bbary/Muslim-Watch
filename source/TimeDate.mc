import Toybox.System;
import Toybox.Lang;
using Toybox.Time.Gregorian as Gre;
using Toybox.Graphics as Gfx;
using Toybox.Time;
import Toybox.Application.Properties;

module TimeDate {
    var clockTime, hours, moment, day_number, day_of_week;
    var txt_height, txt_width, txt_x, txt_y;
    var x, y_top, y_bot;
    var daynum_txt_y, dayofweek_txt_y;  
    var _totalSwimDistance  = -1;
    var _totalCycleDistance = -1;
    var _totalRunDistance   = -1; 

    function setTimeDate(dc){
         // Get the current time and format it correctly
        clockTime = System.getClockTime();
        hours = clockTime.hour;
        if (!System.getDeviceSettings().is24Hour) {
            if (hours > 12) {
                hours = hours - 12;
            }
        }

        moment = Time.now();
        day_number = (Gre.info(moment, Time.FORMAT_LONG).day).toString();
        day_of_week = Gre.info(moment, Time.FORMAT_LONG).day_of_week.toUpper();
        if(day_of_week.equals("MON")){
            day_of_week = "MO";
        }
        if(day_of_week.equals("WED")){
            day_of_week = "WE";
        }
        
        var hoursString = hours.format("%02d");
        var minString = clockTime.min.format("%02d");

        var doneColor = Properties.getValue("time_done_color");
        var todoColor = Properties.getValue("time_todo_color");

        if(_totalSwimDistance == -1){
            _totalSwimDistance = Utils.get_number_from_storage("totalSwimDistance");
        }
        if(_totalCycleDistance == -1){
            _totalCycleDistance = Utils.get_number_from_storage("totalCycleDistance");
        }
        if(_totalRunDistance == -1){
            _totalRunDistance = Utils.get_number_from_storage("totalRunDistance");
        }

        // during the first hours of the week while no activity is recorded use last week totals
        if(_totalSwimDistance == 0 and _totalCycleDistance == 0 and _totalRunDistance == 0){
            _totalSwimDistance = Utils.get_number_from_storage("totalSwimDistanceLastWeek");
            _totalCycleDistance = Utils.get_number_from_storage("totalCycleDistanceLastWeek"); 
            _totalRunDistance = Utils.get_number_from_storage("totalRunDistanceLastWeek");
        }

        var swim_per = (_totalSwimDistance.toFloat()/1000)/Properties.getValue("swim_goal");
        var bike_per = (_totalCycleDistance.toFloat()/1000)/Properties.getValue("bike_goal");
        var run_per = (_totalRunDistance.toFloat()/1000)/Properties.getValue("run_goal");

        
        //swim_per = 0.50;
        //bike_per = 0.50;
        //run_per = 0.25;
        

        if(swim_per>1){
            swim_per = 1;
        }
        if(bike_per>1){
            bike_per = 1;
        }
        if(run_per>1){
            run_per = 1;
        }


        var time_font = Utils.getTimeFont();
        var date_font = Utils.getDateFont();

        var x_time_sep = 94;
        var y_time_sep = 140;

        //dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_YELLOW);
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
        dc.drawText(x_time_sep, y_time_sep, time_font, ":", Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);

        // hours
        txt_height = 65; //dc.getFontHeight(time_font) this function is not working
        txt_width = dc.getTextWidthInPixels(hoursString,time_font);
        
        txt_x = x_time_sep - txt_width/2 - 7;
        txt_y = 133;

        x = txt_x - txt_width/2+1;
        y_top = txt_y - txt_height/2 + 3;
        y_bot = txt_y + txt_height/2 + 3;

        // todo box
        dc.setColor(todoColor,Gfx.COLOR_TRANSPARENT);
        dc.fillRectangle(x, y_top, txt_width-1, txt_height);
        // done box
        dc.setColor(doneColor,Gfx.COLOR_TRANSPARENT);
        dc.fillRectangle(x, y_bot-txt_height*swim_per, txt_width-1, txt_height*swim_per+1);

        // magic        
        dc.setColor(Gfx.COLOR_TRANSPARENT,Gfx.COLOR_WHITE);
        dc.setClip(x, y_top, txt_width+5, txt_height);
        dc.drawText(txt_x, txt_y, time_font, hoursString, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
        dc.clearClip();

        dc.setColor(todoColor, Gfx.COLOR_TRANSPARENT);

        // min
        txt_width = dc.getTextWidthInPixels(minString,time_font);
        txt_x = x_time_sep + dc.getTextWidthInPixels(":",time_font) + 30;

        x = txt_x - txt_width/2 + 1;
        y_top = txt_y - txt_height/2 + 3;
        y_bot = txt_y + txt_height/2 + 3;

        // todo box
        dc.setColor(todoColor,Gfx.COLOR_TRANSPARENT);
        dc.fillRectangle(x, y_top, txt_width-1, txt_height-1);
        // done box
        dc.setColor(doneColor,Gfx.COLOR_TRANSPARENT);
        dc.fillRectangle(x, y_bot-txt_height*bike_per, txt_width-1, txt_height*bike_per);

        // magic       
        dc.setColor(Gfx.COLOR_TRANSPARENT,Gfx.COLOR_WHITE);
        dc.setClip(x, y_top, txt_width+5, txt_height-1);
        dc.drawText(txt_x, txt_y, time_font, minString, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
        dc.clearClip();

        dc.setColor(todoColor, Gfx.COLOR_TRANSPARENT);


        // date
        var daynum_txt_height = 33;
        var dayofweek_txt_height = 32;
        var daynum_txt_width = dc.getTextWidthInPixels(day_number,date_font);
        var dayofweek_txt_width = dc.getTextWidthInPixels(day_of_week,date_font);
        var daynum_txt_x = 225;
        var dayofweek_txt_x = 230;
        daynum_txt_y = 117;    
        dayofweek_txt_y = 150;    

        var daynum_x = daynum_txt_x - daynum_txt_width/2f;
        var dayofweek_x = dayofweek_txt_x - dayofweek_txt_width/2f;
        var daynum_y_top = daynum_txt_y - daynum_txt_height/2f + 3;
        var daynum_y_bot = daynum_txt_y + daynum_txt_height/2f + 3;
        //var dayofweek_y_top = dayofweek_txt_y - dayofweek_txt_height/2f +2;
        var dayofweek_y_bot = dayofweek_txt_y + dayofweek_txt_height/2f + 1;
        
        // daynum todo box
        dc.setColor(todoColor,Gfx.COLOR_TRANSPARENT);
        dc.fillRectangle(daynum_x+1, daynum_y_top, daynum_txt_width-1, daynum_txt_height);
        // Tue
        dc.fillRectangle(dayofweek_x+1, dayofweek_y_bot-dayofweek_txt_height, dayofweek_txt_width-1, dayofweek_txt_height+1);
        // done box
        dc.setColor(doneColor,Gfx.COLOR_TRANSPARENT);
        if(run_per>0.5){
            dc.fillRectangle(daynum_x+1, daynum_y_bot-daynum_txt_height*(run_per-0.5)*2, daynum_txt_width-1, daynum_txt_height*(run_per-0.5)*2);
            dc.fillRectangle(dayofweek_x+1, dayofweek_y_bot-dayofweek_txt_height, dayofweek_txt_width-1, dayofweek_txt_height+1);
        }
        else{
            dc.fillRectangle(dayofweek_x+1, dayofweek_y_bot-dayofweek_txt_height*run_per*2, dayofweek_txt_width-1, dayofweek_txt_height*run_per*2+1);
        }

        // magic       
        dc.setColor(Gfx.COLOR_TRANSPARENT,Gfx.COLOR_WHITE);
        
        dc.setClip(daynum_x, daynum_y_top, daynum_txt_width, daynum_txt_height);
        dc.drawText(daynum_txt_x, daynum_txt_y, Utils.getDateFont(), day_number, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
        dc.clearClip();
        dc.setClip(dayofweek_x, dayofweek_y_bot-dayofweek_txt_height, dayofweek_txt_width, dayofweek_txt_height+1);
        dc.drawText(dayofweek_txt_x, dayofweek_txt_y, Utils.getDateFont(), day_of_week, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);    
        dc.clearClip();

        dc.setColor(todoColor, Gfx.COLOR_TRANSPARENT);

        //dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_LT_GRAY);
    }
}