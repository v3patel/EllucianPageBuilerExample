var r = confirm("This can take several minutes.  Do you want to continue?");
if (r == true) {
  $UpdateStuAcctsStatusBlock.$visible=true;
  $CsvTableBlock.$visible=false;
  // use jQuery selector to get input file name to pass into POST
  var filenameParts = $("#input-file").val().split("\\");
  console.log("posting to student accounts",filenameParts);
  var filename = filenameParts[filenameParts.length - 1];
  console.log("filename:" + filename);
  $UpdateStudentAccountsResource.$post({"CsvFileName": filename},
      null,
      function(response){ // if everything goes okay, this executes
         alert('Update student accounts process started', {type:"success",flash:true});// send back an alert to user
      },
      function(response){ // something did not go as expected, time for error handling
         var errors = response.data.errors;
         if (errors === undefined) {
            alert ("No error messge data. Status code:" + response.status);
         } else {
           var errorMessage =response.data.errors?response.data.errors.errorMessage: null;
           if (response.data.errors.errorMessage) {
             alert(response.data.errors.errorMessage,{type:"error"}); // send back an alert to user
           }
           else if (response.data.errors[0].errorMessage) {
             alert(response.data.errors[0].errorMessage,{type:"error"});// send back an alert to user
           } else {
             alert(errorMessage?errorMessage:response.data, {type:"error"});// send back an alert to user
          }
        }
      }
  ); // end of $post
  $UpdStuAccountsProgressData.$load();
} else {
  console.log("cancel pressed");
  $UpdateStuAcctsStatusBlock.$visible=false;
  $CsvTableBlock.$visible=true;
}