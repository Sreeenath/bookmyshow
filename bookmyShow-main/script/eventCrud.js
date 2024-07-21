$(".view").click(function () {
   var eventId = $(this).data("eventid"); 
   $.ajax({
      url: 'components/bookMyShow.cfc?method=eventDetailsBasedOnId',
      // Type of Request
      type: "POST",
      data: {
         eventId: eventId
      },
      success: function (data) {
         const inputDateString = $(data).find("field[name='DATE'] dateTime").text();
         const inputDate = new Date(inputDateString);
         const options = {
            year: 'numeric',
            month: '2-digit',
            day: '2-digit'
         };
         const formattedDate = inputDate.toLocaleString('en-IN', options);
         var eventName = $("#eventName").val($(data).find("field[name='NAME'] string").text());
         var date = $("#date").val(formattedDate);
         var duration = $("#duration").val($(data).find("field[name='DURATION'] string").text());
         // $("#location").val($(data).find("field[name='LOCATION'] string").text());
         // Add a new option to the select element
         $("#location").append('<option value="' + $(data).find("field[name='LOCATION'] string").text() + '">' + $(data).find("field[name='LOCATION'] string").text() + '</option>');
         // Set the value of the select element
         // $("#location").val($(data).find("field[name='LOCATION'] string").text());
         var venue = $("#venue").val($(data).find("field[name='VENUE'] string").text());
         var rate = $("#rate").val($(data).find("field[name='RATE'] number").text());
         let eventimg = $(data).find("field[name='PROFILE_IMG'] string").text();
         let path = "assests/" + eventimg;
         $("#profileImg").attr("src",path);
         $("#eventName").prop("disabled",true);
         $("#date").prop("disabled", true);
         $("#duration").prop("disabled",true);
         $("#location").prop("disabled",true);
         $("#venue").prop("disabled",true);
         $("#rate").prop("disabled",true);
         $("#saveBtn").hide();
      },
      error: function (jqXHR, textStatus, errorThrown) {
         console.error("AJAX Error: " + textStatus, errorThrown);
      }
    });
 });
 
 
 $(".edit").click(function () {
   var eventId = $(this).data("eventid");
   var id = $("#id").val(eventId); 
   $.ajax({ 
      url: 'components/bookMyShow.cfc?method=eventDetailsBasedOnId', 
      // Type of Request
      type: "POST",
      data: {
         eventId: eventId
      },
      success: function (data) {
         const inputDateString = $(data).find("field[name='DATE'] dateTime").text();
         const inputDate = new Date(inputDateString);
         const options = {
            year: 'numeric',
            month: '2-digit',
            day: '2-digit'
         };
         const formattedDate = inputDate.toLocaleString('en-IN', options);
         var eventName = $("#eventName").val($(data).find("field[name='NAME'] string").text());
         var date = $("#date").val(formattedDate);
         
         var duration = $("#duration").val($(data).find("field[name='DURATION'] string").text());
         $("#location").append('<option value="' + $(data).find("field[name='LOCATION'] string").text() + '">' + $(data).find("field[name='LOCATION'] string").text() + '</option>');
         // Set the value of the select element
         $("#location").val($(data).find("field[name='LOCATION'] string").text());
         let eventimg = $(data).find("field[name='PROFILE_IMG'] string").text();
         let path = "assests/" + eventimg;
         $("#profileImg").attr("src", path);
         var venue = $("#venue").val($(data).find("field[name='VENUE'] string").text());
         var rate = $("#rate").val($(data).find("field[name='RATE'] number").text());
         $("#id").prop("disabled", true);
         $("#eventName").prop("disabled", false);
         $("#date").prop("disabled", false);
         $("#duration").prop("disabled", false);
         $("#location").prop("disabled", true);
         $("#venue").prop("disabled", true);
         $("#rate").prop("disabled", false);
         $("#saveBtn").show();

      },
      error: function (jqXHR, textStatus, errorThrown) {
         console.error("AJAX Error: " + textStatus, errorThrown);
      }
    });
 
    $("#saveBtn").click(function () {
      var id = $("#id").val();
      var eventName = $("#eventName").val();
      var date = $("#date").val();
      var duration = $("#duration").val();
      var location = $("#location").val();
      var venue = $("#venue").val();
      var rate = $("#rate").val();
      $.ajax({
         url: 'components/bookMyShow.cfc?method=updateEventDetails',
         type: "POST",
         data: {
            id: id,
            eventName: eventName,
            date: date,
            duration: duration,
            location: location,
            venue: venue,
            rate: rate
         },
         success: function (data) {
            alert("Updated");
            window.location.href = "eventCrud.cfm";
         },
         error: function (jqXHR, textStatus, errorThrown) {
            console.error("AJAX Error: " + textStatus, errorThrown);
         } 
 
       });
 
    });
 });
 
 
 $("#closeBtn").click(function () { 
   location.reload();
 });
 
 $(".deleteEventBtn").click(function () {
   var eventId = $(this).data("eventid");
   $.ajax({
      url: 'components/bookMyShow.cfc?method=deleteEvent',
      type: "POST",
      data: {
         eventId: eventId
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
 
 
 $("#addEventBtn").click(function () { 
   $("#addVenue").prop("disabled", true);
   var option = $('<option></option>').attr('value', "").text("");
   var selectElement = $('#addLocation');
   selectElement.empty();
   // var selectLang = $("#addLang");
   // selectLang.empty();
   // var selectCatogery = $("#addCateogry");
   // selectCatogery.empty();

   $.ajax({
      url: 'components/bookMyShow.cfc?method=fecthLocations',
      type: "POST",
      data: {

      },
      success: function (response) {
         console.log(response);
         var parser = new DOMParser();
         var xmlDoc = parser.parseFromString(response, "text/xml");
         // Extract data from the XML and store in a JavaScript structure
         var locations = [];
         var recordset = xmlDoc.querySelector("recordset");
         var rowCount = parseInt(recordset.getAttribute("rowCount"));
         for (var i = 0; i < rowCount; i++) {
            var location = {};
            var fields = recordset.querySelectorAll("field");
            fields.forEach(function (field, index) {
               var fieldName = field.getAttribute("name");
               var value = field.children[i].textContent;
               location[fieldName] = value;
            });
            locations.push(location);
         }
         var uniqueLocations = [];
         // Loop through the structure
         $.each(locations, function (index, venue) {
            // Check if the location is not already in the array
            if ($.inArray(venue.LOCATION, uniqueLocations) === -1) {
               uniqueLocations.push(venue.LOCATION);
            }
         });
         // Add unique locations to the select element
         selectElement.append(option);
         $.each(uniqueLocations, function (index, location) {
            selectElement.append('<option value="' + location + '">' + location + '</option>');
         });

      },
      error: function (jqXHR, textStatus, errorThrown) {
         console.error("AJAX Error: " + textStatus, errorThrown);
      }
 
    });
 
   //  $.ajax({
   //    url: 'components/bookMyShow.cfc?method=fetchLanguages',
   //    type: "POST",
   //    data: {

   //    },
   //    success: function (response) {
   //       console.log(response);
   //       var parser = new DOMParser();
   //       var xmlDoc = parser.parseFromString(response, "text/xml");
   //       // Extract data from the XML and store in a JavaScript structure
   //       var langs = [];
   //       var recordset = xmlDoc.querySelector("recordset");
   //       var rowCount = parseInt(recordset.getAttribute("rowCount"));
   //       for (var i = 0; i < rowCount; i++) {
   //          var lang = {};
   //          var fields = recordset.querySelectorAll("field");
   //          fields.forEach(function (field, index) {
   //             var fieldName = field.getAttribute("name");
   //             var value = field.children[i].textContent;
   //             lang[fieldName] = value;
   //          });
   //          langs.push(lang);
   //       }
   //       selectLang.append($('<option></option>').attr('value', "").text(""));
   //       $.each(langs, function (index, lang) {
   //          var option = $('<option></option>').attr('value', lang.LANG_ID).text(lang.LANGUAGE);
   //          selectLang.append(option);
   //       });

   //    },
   //    error: function (jqXHR, textStatus, errorThrown) {
   //       console.error("AJAX Error: " + textStatus, errorThrown);
   //    }
 
   //  });
 
   //  $.ajax({
   //    url: 'components/bookMyShow.cfc?method=fetchCategory',
   //    type: "POST",
   //    data: {

   //    },
   //    success: function (response) {
   //       console.log(response);
   //       var parser = new DOMParser();
   //       var xmlDoc = parser.parseFromString(response, "text/xml");
   //       // Extract data from the XML and store in a JavaScript structure
   //       var cats = [];
   //       var recordset = xmlDoc.querySelector("recordset");
   //       var rowCount = parseInt(recordset.getAttribute("rowCount"));
   //       for (var i = 0; i < rowCount; i++) {
   //          var cat = {};
   //          var fields = recordset.querySelectorAll("field");
   //          fields.forEach(function (field, index) {
   //             var fieldName = field.getAttribute("name");
   //             var value = field.children[i].textContent;
   //             cat[fieldName] = value;
   //          });
   //          cats.push(cat);

   //       }
   //       selectCatogery.append($('<option></option>').attr('value', "").text(""));

   //       $.each(cats, function (index, cat) {
   //          var option = $('<option></option>').attr('value', cat.CATEGORY_ID).text(cat.CATEGORY);
   //          selectCatogery.append(option);
   //       });

   //    },
   //    error: function (jqXHR, textStatus, errorThrown) {
   //       console.error("AJAX Error: " + textStatus, errorThrown);
   //    } 
 
   //  }); 
 
 });
 
 function showVenue() {  
    $("#addVenue").prop("disabled", false);
    var selectElement = $("#addVenue");
    selectElement.empty();
   //  var option = $('<option></option>').attr('value', "").text("");
   //  selectElement.append(option);
    var location = document.getElementById("addLocation").value; 
    $.ajax({
      url: 'components/bookMyShow.cfc?method=fecthVenues',
      type: "POST",
      data: {
         location: location,
      },
      success: function (response) {
         var parser = new DOMParser();
         var xmlDoc = parser.parseFromString(response, "text/xml");
         // Extract data from the XML and store in a JavaScript structure
         var venues = [];
         var recordset = xmlDoc.querySelector("recordset");
         var rowCount = parseInt(recordset.getAttribute("rowCount"));
         for (var i = 0; i < rowCount; i++) {
            var venue = {};
            var fields = recordset.querySelectorAll("field");
            fields.forEach(function (field, index) {
               var fieldName = field.getAttribute("name");
               var value = field.children[i].textContent;
               venue[fieldName] = value;
            });
            venues.push(venue);
         }

         $.each(venues, function (index, venue) {
            var option = $('<option></option>').attr('value', venue.VENUE).text(venue.VENUE);
            selectElement.append(option);
         });

      },
      error: function (jqXHR, textStatus, errorThrown) {
         console.error("AJAX Error: " + textStatus, errorThrown);
      }

   });
 
 } 
 var addRateInput = $("#addRate");
 addRateInput.on("input", function () {
   var enteredValue = $(this).val();
   if (isNaN(enteredValue)) {
      $(this).val('');
   }
 });


 function reloadPage() {
   window.location.href ="eventCrud.cfm"
}