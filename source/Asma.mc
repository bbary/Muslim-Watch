import Toybox.WatchUi;
import Toybox.Application.Storage;
import Toybox.Math;


module Asma{

    var count_start = 32;
    var count_end = 126;
    var ism = -1;

    // change every 3 hours
    function chooseIsm(){
        var index = Math.rand()%(count_end-count_start)+count_start;
        ism = index.toChar().toString();
        Storage.setValue("Ism", ism);
    }

    function setIsm(c){
        if(ism == -1){
            ism = Storage.getValue("Ism");
        }
        // first time
        if(ism == null){
           chooseIsm();     
        }
        c.setFont(WatchUi.loadResource(Rez.Fonts.asmaa));
        c.setText(ism);
    }

    function testIsm(c){
        var index = Math.rand()%(count_end-count_start)+count_start;
        ism = index.toChar().toString();
        c.setFont(WatchUi.loadResource(Rez.Fonts.asmaa));
        c.setText(ism);
    }
}