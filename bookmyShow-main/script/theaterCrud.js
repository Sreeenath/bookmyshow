$(".view").click(function () {
   $("#theaterTime").show();
   
   var theaterId = $(this).data("theaterid");
   $('#location').empty();
   $.ajax({

      url: 'components/bookMyShow.cfc?method=fetchTheaterDetailsBasedOnId',
      // Type of Request
      type: "POST",
      data: {
         theaterId: theaterId
      },
      success: function (data) {
         console.log(data);
         $("#theaterName").val($(data).find("field[name='NAME'] string").text());
         $("#address").val($(data).find("field[name='ADDRESS'] string").text());
         $("#location").append('<option value="' + $(data).find("field[name='LOCATION'] string").text() + '">' + $(data).find("field[name='LOCATION'] string").text() + '</option>');
         $("#phno").val($(data).find("field[name='PHNO'] string").text());
         $("#time").val($(data).find("field[name='TIMES'] string").text());
         var statusValue = parseFloat($(data).find("field[name='STATUS'] number").text());
         $("#status").empty();
         if (statusValue === 1.0) {
            $("#status").append('<option value="1" selected>Active</option>');
         } else {
            $("#status").append('<option value="0" selected>InActive</option>');
         } 

         $("#theaterName").prop("disabled", true);
         $("#address").prop("disabled", true);
         $("#location").prop("disabled", true);
         $("#phno").prop("disabled", true);
         $("#time").prop("disabled", true);
         $("#status").prop("disabled", true);
         $("#saveBtn").hide();


      },
      error: function (jqXHR, textStatus, errorThrown) {
         console.error("AJAX Error: " + textStatus, errorThrown);
      }


   });
 
 
 });
 
 $(".deleteTheaterBtn").click(function () {
    var theaterId = $(this).data("theaterid");

    $("#deleteYes").click(function(){

      $.ajax({
         url: 'components/bookMyShow.cfc?method=deleteTheater',
         type: "POST",
         data: {
            theaterId: theaterId,
   
         },
         success: function (data) {
            alert("Deleted Successfully");
            location.reload();
   
         },
         error: function (jqXHR, textStatus, errorThrown) {
            console.error("AJAX Error: " + textStatus, errorThrown);
         }
   
   
      });


    });
   
 
 });
 
 
$(".edit").click(function () {
   $("#theaterTime").hide();
   $("#saveBtn").show();
   var theaterId = $(this).data("theaterid");
   $('#status').empty();
   $('#location').empty();
   $.ajax({

      url: 'components/bookMyShow.cfc?method=fetchTheaterDetailsBasedOnId',
      // Type of Request
      type: "POST",
      data: {
         theaterId: theaterId
      },
      success: function (data) {

         $("#theaterName").val($(data).find("field[name='NAME'] string").text());
         $("#address").val($(data).find("field[name='ADDRESS'] string").text());
         $("#location").append('<option value="' + $(data).find("field[name='LOCATION'] string").text() + '">' + $(data).find("field[name='LOCATION'] string").text() + '</option>');
         $("#phno").val($(data).find("field[name='PHNO'] string").text());
         $("#time").val($(data).find("field[name='TIMES'] string").text());
         var statusValue = $(data).find("field[name='STATUS'] number").text();
         $("#status").empty();
         if (statusValue == "1.0") {
            $("#status").append('<option value="1" selected>Active</option>');
            $("#status").append('<option value="0">Inactive</option>');
         } else {
            $("#status").append('<option value="1">Active</option>');
            $("#status").append('<option value="0" selected>Inactive</option>');
         }

         $("#theaterName").prop("disabled", false);
         $("#address").prop("disabled", false);
         $("#location").prop("disabled", true);
         $("#phno").prop("disabled", true);
         $("#time").prop("disabled", true);
         $("#status").prop("disabled", false);
         $("#saveBtn").show();


      },
      error: function (jqXHR, textStatus, errorThrown) {
         console.error("AJAX Error: " + textStatus, errorThrown);
      }
 
 
    });
 
 
    $("#saveBtn").click(function () {
       var id = theaterId;
       var theaterName = $("#theaterName").val();
       var address = $("#address").val();
       var phno = $("#phno").val();
       var status = $("#status").val();
 
 
       $.ajax({
          url: 'components/bookMyShow.cfc?method=updateTheaterDetails',
          type: "POST",
          data: {
             id: id,
             theaterName: theaterName,
             address: address,
             phno: phno,
             status: status
          },
          success: function (data) {
 
             alert("Updated");
             window.location.href = "theaterCrud.cfm";
          },
          error: function (jqXHR, textStatus, errorThrown) {
             console.error("AJAX Error: " + textStatus, errorThrown);
          }
 
 
       });
 
    });
 
 
 });
 
 
 $("#addTheaterBtn").click(function () {
 
    $("#status").prop("disabled", true);
 
 })
 
 
 function addTime() {
    // Clone the existing time container
    var originalTimeContainer = document.querySelector('.time-container');
    var clonedTimeContainer = originalTimeContainer.cloneNode(true);
 
    // Clear the value of the cloned time input
    var clonedTimeInput = clonedTimeContainer.querySelector('.timeInput');
    clonedTimeInput.value = '';
 
    // Append the cloned container to the timeContainer div
    document.getElementById('timeContainer').appendChild(clonedTimeContainer);
    event.preventDefault();
 }
 
 function getAllTimes() {
    // Get all time input elements
    var timeInputs = document.querySelectorAll('.timeInput');
 
    // Create an array to store the formatted time values
    var allTimes = [];
 
    // Iterate through each time input and add its formatted value to the array
    timeInputs.forEach(function (timeInput) {
       var timeValue = timeInput.value;
       // Convert time to 12-hour format with AM/PM
       var formattedTime = format12HourTime(timeValue);
       allTimes.push(formattedTime);
    });
 
    // Log the array of all formatted time values (you can use it as needed)
    document.getElementById('formattedTimes').value = allTimes.join(', ');
 
    event.preventDefault();
 }
 
 function format12HourTime(time) {
    var timeParts = time.split(":");
    var hours = parseInt(timeParts[0], 10);
    var minutes = timeParts[1];
    var period = hours >= 12 ? "PM" : "AM";
    hours = hours % 12 || 12; // Convert hours to 12-hour format
    return hours + ":" + minutes + " " + period;
 }
 
 function updateFormattedTimes() {
    // Get all time input elements
    var timeInputs = document.querySelectorAll('.timeInput');
 
    // Create an array to store the formatted time values
    var allTimes = [];
 
    // Iterate through each time input and add its formatted value to the array
    timeInputs.forEach(function (timeInput) {
       var timeValue = timeInput.value;
       // Convert time to 12-hour format with AM/PM
       var formattedTime = format12HourTime(timeValue);
       allTimes.push(formattedTime);
    });
 
    // Join the array of formatted times with commas and set the value to the input field
    document.getElementById('formattedTimes').value = allTimes.join(', ');
 }
 
 
 $("#saveTheaterDetails").click(function () {
 
    var theaterName = $("#addTheaterName").val().trim();
    var address = $("#addAddress").val().trim();
    var location = $("#addLocation").val().trim();
    var phno = $("#addPhno").val().trim();
    var status = $("#addStatus").val().trim();
    var formattedTimes = $("#formattedTimes").val().trim();
    
    if((theaterName.length === 0 || address.length===0 || location.length === 0 || phno.length === 0 || status.length === 0 || formattedTimes.length === 0)){
      alert("fill all field");
      event.preventDefault();

    }
    else{
      $.ajax({
         url: 'components/bookMyShow.cfc?method=saveTheater',
         type: "POST",
         data: {
            theaterName: theaterName,
            address: address,
            location: location,
            phno: phno,
            status: status,
            formattedTimes: formattedTimes
   
         },
         success: function (data) {
            let result = $(data).find("boolean").attr("value");
            if (result == "false") {
               alert("Already Registered")
            }
   
         },
         error: function (jqXHR, textStatus, errorThrown) {
            console.error("AJAX Error: " + textStatus, errorThrown);
         }
   
   
      });
   
    }
    
 
 })

 function reloadPage() {
   window.location.href = "theaterCrud.cfm"
}