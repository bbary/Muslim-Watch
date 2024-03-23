import Toybox.System;
import Toybox.Lang;
import Toybox.Application.Storage;
import Toybox.Graphics;
import Toybox.Application.Properties;

module Salat {

    
    var nextPrayer, nextNextPrayer, precedentPrayer;
    var remainingTime, pastTime;
    var nextPrayerTime, precedentPrayerTime;

    var hijri_day = -1;
    var hijriDay;

    var hijri_month = -1;

    var nextPrayer_ar = -1;
    var salat_changed = false;

    var timings = -1;

    function setHijriDay(c){
        if(hijri_day == -1){
            hijri_day = Utils.get_number_from_storage("hijri_day");
            // calculate hijri date with adjustment from properties
            var adjutHijri = Properties.getValue("adjust_hijri");
            if( adjutHijri.equals("")){
                adjutHijri = 0;     
            }
            hijriDay = hijri_day.toNumber() + adjutHijri.toNumber();
        }
        c.setText(hijriDay.toString());
        //c.setText("29");
    }   

    function setHijriMonth(c){
        if(hijri_month == -1){
            hijri_month = Utils.get_from_storage("hijri_month");
        }
        c.setText(hijri_month.toString());
        //c.setText("ramadan");
    }

    function setNextPrayer(c){   
        if(nextPrayer_ar == -1 or salat_changed){
            nextPrayer_ar = Utils.get_from_storage("nextPrayer_ar");
        }
        
        switch(nextPrayer_ar){
            case "Fajr":
                c.setText("الفجر");
                break;
            case "Sunrise":
                c.setText("الشروق");
                break;
            case "Dhuhr":
                c.setText("الظهر");
                break;
            case "Asr":
                c.setText("العصر");
                break;
            case "Maghrib":
                c.setText("المغرب");
                break;
            case "Isha":
                c.setText("العشاء");
                break; 
            default:
                c.setText("ERR");
                break;           
        }
        //c.setText(nextPrayer_ar);
        //c.setText("sho");
    }

    function setSalatTime(c){
        if(timings == -1){
           timings = Storage.getValue("timings");      
        }
        
        if(timings==null){
            c.setText("NA");
            return;  
        }
        // get fixed prayer times from properties
        var ichaTime = Properties.getValue("icha_time");
        if(ichaTime.equals("")){
		    ichaTime = timings["Isha"];
		}
        var duhrTime = Properties.getValue("duhr_time");
        if(duhrTime.equals("")){
		    duhrTime = timings["Dhuhr"];
		}
        var asrTime = Properties.getValue("asr_time");
        if(asrTime.equals("")){
		    asrTime = timings["Asr"];
		}

        var timeNow = Lang.format("$1$:$2$", [System.getClockTime().hour.format("%02d"), System.getClockTime().min.format("%02d")]);

        

        //nextPrayer = Storage.getValue("nextPrayer");
        nextPrayer = calculateNextPrayer(timeNow, timings);
        if(!nextPrayer.equals(nextPrayer_ar)){
            salat_changed = true;
            Storage.setValue("nextPrayer_ar", nextPrayer);  
        }
        

        switch (nextPrayer){
            case "Fajr":
                precedentPrayer = "Isha";
                nextNextPrayer = "Sunrise";
                break;
            case "Sunrise":
                precedentPrayer = "Fajr";
                nextNextPrayer = "Dhuhr";
                break;
            case "Dhuhr":
                precedentPrayer = "Sunrise";
                nextNextPrayer = "Asr";
                break;
            case "Asr":
                precedentPrayer = "Dhuhr";
                nextNextPrayer = "Maghrib";
                break;
            case "Maghrib":
                precedentPrayer = "Asr";
                nextNextPrayer = "Isha";
                break;
            case "Isha":
                precedentPrayer = "Maghrib";
                nextNextPrayer = "Fajr";
                break;                
        }

        //Do all these tests  using Time simulation
        //      Salat - 5min  / Salat / Salat +5  / Slat+15 
        //Utils.log("titmins "+timings);

        var t = timeToNextSalat(nextPrayer, precedentPrayer, timeNow, timings);
        c.setText(t);   
    }  

    function add24(FajrTime){
        var time_hours=FajrTime.substring(0, 2).toNumber()+24;
        var time_min=FajrTime.substring(3, 5);
        return time_hours.toString()+":"+time_min;
    }

    function timeDiff(time1, time2){

        var time1_hours=time1.substring(0, 2).toNumber();
        var time1_min=time1.substring(3, 5).toNumber();
        var time1_total_min = time1_hours*60 +  time1_min;

        var time2_hours=time2.substring(0, 2).toNumber();
        var time2_min=time2.substring(3, 5).toNumber();
        var time2_total_min = time2_hours*60 +  time2_min;

        return time1_total_min-time2_total_min;

    }

    function timeToNextSalat(nextPrayer, precedentPrayer, timeNow, timings){
        nextPrayerTime = timings[nextPrayer];
        precedentPrayerTime = timings[precedentPrayer];

        remainingTime = timeDiff(timeNow, nextPrayerTime);
        pastTime = timeDiff(timeNow, precedentPrayerTime);

        // if next prayer is Fajr and timeNow < 00:00 we need to add 24 to fajr time
        if(nextPrayer.equals("Fajr") and timeDiff(timeNow, nextPrayerTime)>0){
            remainingTime = timeDiff(timeNow, add24(nextPrayerTime));
        }

        // if next prayer is Fajr and timeNow > 00:00 we need to add 24 to timenow
        // but we can't because timenow need to has his value in next lines
        // so we change pastTime to value > 15
        if(nextPrayer.equals("Fajr") and timeDiff(timeNow, precedentPrayerTime)<0){
            pastTime = 20;
        }
        if(remainingTime>=0){
            Utils.log("remainingTime ="+remainingTime+"  salat "+nextPrayer+" time!    nextNextPrayer = "+nextNextPrayer);
            Storage.setValue("nextPrayer", nextNextPrayer);   
            return "! قم";
        }
        else if(pastTime<0){
            Utils.log("ER1  pastTime="+pastTime);
            return "ER1";
        }
        else if(remainingTime<=0 and pastTime>15) {
            if(remainingTime.abs()<=90){
                return remainingTime.abs()+"'";
            }
            else{
                return nextPrayerTime;
            }
        }     
        else if (pastTime<=15){
            if(pastTime==15){
                Utils.log("صل علي  nextPrayer_ar="+nextPrayer);
                Storage.setValue("nextPrayer_ar", nextPrayer);  
                return "صل عليه"; 
            }
            return "+"+pastTime+"'";
        }
        else {
            Utils.log("ER2  pastTime=  "+pastTime+"   remainingTime= "+remainingTime+" ");
            Utils.log(    "nextPrayer "+nextPrayer+", precedentPrayer "+precedentPrayer);
            return "ER2";
        }
    }   

    function calculateNextPrayer(timeNow, timings){
        if(timeDiff(timeNow, timings["Fajr"])<=0){
            return "Fajr";
        } else if(timeDiff(timeNow, timings["Sunrise"])<=0){
            return "Sunrise";
        } else if(timeDiff(timeNow, timings["Dhuhr"])<=0){
            return "Dhuhr";
        } else if(timeDiff(timeNow, timings["Asr"])<=0){
            return "Asr";
        } else if(timeDiff(timeNow, timings["Maghrib"])<=0){
            return "Maghrib";
        } else if(timeDiff(timeNow, timings["Isha"])<=0){
            return "Isha";
        } else{
            return "Fajr";
        }
    }
}
/*

*/