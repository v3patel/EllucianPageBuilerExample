if (data.length <= 0) {
    // hide progress  block if no data
    //console.log("status data is empty");
    $UpdateStuAcctsProgressBlock.$visible = false;
    $CsvTableBlock.$visible=true;
     alert('Update student accounts process completed', {type:"success",flash:true});// send back an alert to user
} else {
    $CsvTableBlock.$visible=false;
    $UpdateStuAcctsProgressBlock.$visible = true;
    //console.log("status data is NOT empty",data);
    var firstRow = data[0];
    //console.log("first row",firstRow);
    // determine percent complete
    var pctComplete = ((firstRow.SO_FAR/firstRow.TOTAL_WORK) * 100).toFixed(0);
    // update progress bar width and text
    var pctCompleteString = pctComplete+"%";
    $("#pbid-UpdateStuAcctsProgressBar").width(pctCompleteString);
    $("#pbid-UpdateStuAcctsProgressBar").html(pctCompleteString);
     
    // if the current status is the same as what is currently being displayed add a period to the end so the
    // the user gets some visual that we are still processing
 
    var currentStatusData = firstRow.STATUS_TEXT;
    var currentStatusDisplay = $("#pbid-UpdateStuAcctsStatusDisplay").text();
     if (currentStatusDisplay === undefined) {
       $("#pbid-UpdateStuAcctsStatusDisplay").text(currentStatusData);
    }
    else if (currentStatusDisplay.includes(currentStatusData)) {
       $("#pbid-UpdateStuAcctsStatusDisplay").text(currentStatusDisplay + ".");
    } else {
       $("#pbid-UpdateStuAcctsStatusDisplay").text(currentStatusData);
    }
    // wait 1.5 seconds to check the data again
    var interval = setInterval(function() {
         $UpdStuAccountsProgressData.$load({clearCache:true});
          clearInterval(interval);
    }, 1500);
 
}