$(document).ready(function () {
    $("#calender").hide();
    // Trigger the datepicker when the div is clicked
    $("#datepickerTrigger").on("click", function () {
       $("#calender").show();
        $("#calender").datepicker("show");
    });
 
    var date = new Date();
    var weekday = date.toLocaleString('en-us', {
        weekday: 'short'
    });
    var day = date.toLocaleString('en-us', {
        day: '2-digit'
    });
    var month = date.toLocaleString('en-us', {
        month: 'short'
    });
    var formattedDate = date.toLocaleDateString('en-US', {
     month: '2-digit',
     day: '2-digit',
     year: 'numeric'
   });
 
   // Set the value of the input field
     $("#calender").val(formattedDate);   
     $(".date").val(formattedDate);   
 
     $("#weekday").text(weekday);
     $("#day").text(day);
     $("#month").text(month);
 
    $("#calender").datepicker({
       minDate: new Date(),
        onSelect: function (dateText, inst) {  
 
            var date = new Date(dateText);
            var weekday = date.toLocaleString('en-us', {
                weekday: 'short'
            });
            var day = date.toLocaleString('en-us', {
                day: '2-digit'
            });
            var month = date.toLocaleString('en-us', {
                month: 'short'
            });
            var formattedDate = date.toLocaleDateString('en-US', {
             month: '2-digit',
             day: '2-digit',
             year: 'numeric'
           });
           $(".date").val(formattedDate);   
            $("#weekday").text(weekday);
            $("#day").text(day);
            $("#month").text(month);
 
        },
        onClose: function () {
            // When the datepicker is closed, check if the calendar field is empty, and clear the second input field if it is
            var calendarValue = $("#calender").val();
            if (!calendarValue) {
                $("#filterDate").val("");
                $("#date").val("");
            }
        }
    });
 });
 
 