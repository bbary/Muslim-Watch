import Toybox.Lang;
import Toybox.Graphics;
using Toybox.Activity;
using Toybox.UserProfile;

module Triathlon {
    var sample;
    var type;
    var distance;

    var userActivityIterator;
    var activityTime;

    var _totalSwimDistance = -1;
    var _totalCycleDistance = -1;
    var _totalRunDistance = -1;

    var _totalSwimDistance_lastweek = -1;
    var _totalCycleDistance_lastweek = -1;
    var _totalRunDistance_lastweek = -1;

    var totalSwimDistance=0;
    var totalCycleDistance=0;
    var totalRunDistance=0;

    var totalSwimDistanceLastWeek=0;
    var totalCycleDistanceLastWeek=0;
    var totalRunDistanceLastWeek=0;

    var lastSundayDate;
    var lastlastSundayDate;

    // get total distances every x seconds 
    function getThisWeekTotals(){
        
        lastSundayDate = Utils.getLastSundayEpoch(); // Saturday at midnight to include sunday 
        lastlastSundayDate = lastSundayDate - 7*24*3600;
        Utils.log("updating triathlon totals from "+lastSundayDate);
        userActivityIterator = UserProfile.getUserActivityHistory();
        sample = userActivityIterator.next();  
        totalSwimDistance = 0;
        totalCycleDistance = 0;
        totalRunDistance = 0;        
        
        totalSwimDistanceLastWeek=0;
        totalCycleDistanceLastWeek=0;
        totalRunDistanceLastWeek=0;

        while (sample!=null) {
            if(sample.startTime!=null){
                // Fit epoch time is 20years behind
                activityTime = sample.startTime.value()+631065600;
                if(activityTime>lastSundayDate){
                    type = sample.type;
                    distance = sample.distance;
                    switch (type){
                        case Activity.SPORT_SWIMMING:
                            totalSwimDistance+=distance;
                            break;
                        case Activity.SPORT_CYCLING:
                            totalCycleDistance+=distance;
                            break;
                        case Activity.SPORT_RUNNING:
                            totalRunDistance+=distance;
                            break;
                        default:
                            Utils.log("other activity distance "+distance); 
                            break;
                    }
                }
                else if(activityTime<lastSundayDate and activityTime>lastlastSundayDate){
                    type = sample.type;
                    distance = sample.distance;
                    switch (type){
                        case Activity.SPORT_SWIMMING:
                            totalSwimDistanceLastWeek+=distance;
                            break;
                        case Activity.SPORT_CYCLING:
                            totalCycleDistanceLastWeek+=distance;
                            break;
                        case Activity.SPORT_RUNNING:
                            totalRunDistanceLastWeek+=distance;
                            break;
                        default:
                            Utils.log("other activity distance "+distance); 
                            break;
                    }
                 }
            }
            sample = userActivityIterator.next();
        }
        Utils.persist("totalSwimDistance", totalSwimDistance);
        Utils.persist("totalCycleDistance", totalCycleDistance);
        Utils.persist("totalRunDistance", totalRunDistance);

        Utils.persist("totalSwimDistanceLastWeek", totalSwimDistanceLastWeek);
        Utils.persist("totalCycleDistanceLastWeek", totalCycleDistanceLastWeek);
        Utils.persist("totalRunDistanceLastWeek", totalRunDistanceLastWeek);

        Utils.log("totalSwimDistance "+totalSwimDistance+" totalCycleDistance "+totalCycleDistance+" totalRunDistance "+totalRunDistance);
    }    

    function getTotalSwim(total_swim){
        if(_totalSwimDistance == -1){
            _totalSwimDistance = Utils.get_number_from_storage("totalSwimDistance");
        }
         
        total_swim.setColor(Graphics.COLOR_BLUE);
        total_swim.setFont(Graphics.FONT_MEDIUM);
        total_swim.setText((_totalSwimDistance.toFloat()/1000).format("%.1f"));
    } 

    function getTotalBike(total_bike){
        if(_totalCycleDistance == -1){
            _totalCycleDistance = Utils.get_number_from_storage("totalCycleDistance");
        }
        total_bike.setColor(Graphics.COLOR_YELLOW);
        total_bike.setFont(Graphics.FONT_LARGE);
        total_bike.setText(Utils.round(_totalCycleDistance.toFloat()/1000).toString());
    }

    function getTotalRun(total_run){
        if(_totalRunDistance == -1){
            _totalRunDistance = Utils.get_number_from_storage("totalRunDistance");
        }        
        total_run.setColor(Graphics.COLOR_GREEN);
        total_run.setFont(Graphics.FONT_MEDIUM);
        //total_run.setText((totalRunDistance.toFloat()/1000).format("%.1f"));
        total_run.setText(Utils.round(_totalRunDistance.toFloat()/1000).toString());
    }

    function getTotalSwimLastWeek(f){
        if(_totalSwimDistance_lastweek == -1){
            _totalSwimDistance_lastweek = Utils.get_number_from_storage("totalSwimDistanceLastWeek");
        }                
        f.setText((_totalSwimDistance_lastweek.toFloat()/1000).format("%.1f"));
    } 

    function getTotalBikeLastWeek(f){
        if(_totalCycleDistance_lastweek == -1){
            _totalCycleDistance_lastweek = Utils.get_number_from_storage("totalCycleDistanceLastWeek");
        }                
        f.setText(Utils.round(_totalCycleDistance_lastweek.toFloat()/1000).toString());
    }

    function getTotalRunLastWeek(f){
        if(_totalRunDistance_lastweek == -1){
            _totalRunDistance_lastweek = Utils.get_number_from_storage("totalRunDistanceLastWeek");
        }                
        f.setText(Utils.round(_totalRunDistance_lastweek.toFloat()/1000).toString());
    }
}