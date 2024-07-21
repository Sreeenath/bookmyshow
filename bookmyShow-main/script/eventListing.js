$(document).ready(function () {

   $("#calender").hide();
   $("#lang").hide();
   $("#categories").hide();
   
   $("#calender").datepicker({
      onSelect: function (dateText, inst) {
         // When a date is picked, set the value to the second input field
         $("#filterDate").val(dateText);
      },
      onClose: function () {
         // When the datepicker is closed, check if the calendar field is empty, and clear the second input field if it is
         var calendarValue = $("#calender").val();
         if (!calendarValue) {
            $("#filterDate").val("");
         }
      }
   });


});


$(function () {
   $("#calender").datepicker();

});


function toggleCalendar() {
   var calendar = document.getElementById('calender');
   var svgDate = document.getElementById('svgDate');
   var dateTxt = document.getElementById('dateTxt')


   if (calendar.style.display === 'none') {
      calendar.style.display = 'block';
      svgDate.classList.add('rotate-down');
      dateTxt.style.color = 'red';

   } else {
      calendar.style.display = 'none';
      svgDate.classList.remove('rotate-down');
      dateTxt.style.color = 'black';


   }
}

function toggleLanguage() {

   var svgLanguage = document.getElementById('svgLanguage');
   var languageTxt = document.getElementById('languageTxt')
   var main = document.getElementById('lang');


   if (main.style.display === 'none') {

      main.style.display = 'block';
      svgLanguage.classList.add('rotate-down');
      languageTxt.style.color = 'red';

   } else {

      main.style.display = 'none';

      svgLanguage.classList.remove('rotate-down');
      languageTxt.style.color = 'black';


   }
}

function toggleCategories() {

   var svgCategories = document.getElementById('svgCategories');
   var categoriesTxt = document.getElementById('categoriesTxt')
   var main = document.getElementById('categories');


   if (main.style.display === 'none') {

      main.style.display = 'block';
      svgCategories.classList.add('rotate-down');
      categoriesTxt.style.color = 'red';

   } else {

      main.style.display = 'none';

      svgCategories.classList.remove('rotate-down');
      categoriesTxt.style.color = 'black';


   }
}

function clearCalendar() {
   // Get the calender input element
   var calenderInput = document.getElementById("calender");


   // Clear the value of the calender input field
   calenderInput.value = "";

}


function clearLanguage() {
   // Get all elements with class 'langDiv'
   var langDivs = document.querySelectorAll('.langDiv');

   // Reset styles for each 'langDiv'
   langDivs.forEach(function (langDiv) {
      // Set default background color
      langDiv.style.backgroundColor = ''; // This will remove the inline style

      // Reset text color for the nested 'langTxt' element
      var langTxt = langDiv.querySelector('.langTxt');
      langTxt.style.color = ''; // This will remove the inline style
      var msgElement = document.getElementById("filterLanguages");
      msgElement.value = "";
      selectedLanguages = {};


   });
}


function clearCategories() {
   // Get all elements with class 'langDiv'
   var categoriesDivs = document.querySelectorAll('.categoriesDiv');

   // Reset styles for each 'categoriesDivDiv'
   categoriesDivs.forEach(function (categoriesDiv) {
      // Set default background color
      categoriesDiv.style.backgroundColor = ''; // This will remove the inline style

      // Reset text color for the nested 'categoriesDivTxt' element
      var categoriesDivTxt = categoriesDiv.querySelector('.categryTxt');
      categoriesDivTxt.style.color = ''; // This will remove the inline style
      // Reassign an empty array to the variable
      selectedCategory = {};
      // Now, selectedCategory is an empty array
      var msgElement = document.getElementById("filterCategories");
      msgElement.value ="";

   });
}


var selectedLanguages = {};

document.addEventListener('DOMContentLoaded', function () {
   // Get all elements with class 'langDiv'
   var langDivs = document.querySelectorAll('.langDiv');

   // Add click event listener to each 'langDiv'
   langDivs.forEach(function (langDiv) {
      langDiv.addEventListener('click', function () {
         // Toggle background color
         this.style.backgroundColor = this.style.backgroundColor === 'red' ? 'white' : 'red';

         // Toggle text color for the nested 'langTxt' element
         var langTxt = this.querySelector('.langTxt');
         langTxt.style.color = langTxt.style.color === 'white' ? 'red' : 'white';

         // Get the ID of the clicked element
         var selectedId = this.id;

         // Toggle the selection status using an object
         if (selectedLanguages[selectedId]) {
            // ID is already in the object, remove it
            delete selectedLanguages[selectedId];


            var inputValueLang = document.getElementById('filterLanguages').value;

            // Split the input values into an array
            var valuesArray = inputValueLang.split(",");

            // Loop through the values and remove 'malayalam' if found
            for (var i = 0; i < valuesArray.length; i++) {
               if (valuesArray[i] === selectedId) {
                  valuesArray.splice(i, 1);
                  i--; // Adjust index to account for removed element
               }
            }
            inputValueLang.value = " ";
            // Join the modified array back into a string
            var newInputValue = valuesArray.join(',');

            // Update the input field with the new value
            document.getElementById('filterLanguages').value = newInputValue;


         } else {
            // ID is not in the object, add it
            var msgElement = document.getElementById("filterLanguages");
            msgElement.value += selectedId + ",";
            selectedLanguages[selectedId] = true;
         }

         // Output the selectedLanguages object for testing
      });
   });
});


var selectedCategory = {};

document.addEventListener('DOMContentLoaded', function () {
   // Get all elements with class 'langDiv'
   var categoriesDivs = document.querySelectorAll('.categoriesDiv');

   // Add click event listener to each 'categoriesDiv'
   categoriesDivs.forEach(function (categoriesDiv) {
      categoriesDiv.addEventListener('click', function () {
         // Toggle background color
         this.style.backgroundColor = this.style.backgroundColor === 'red' ? 'white' : 'red';

         // Toggle text color for the nested 'categryTxt' element
         var categryTxt = this.querySelector('.categryTxt');
         categryTxt.style.color = categryTxt.style.color === 'white' ? 'red' : 'white';

         var selectedId = this.id;

         // Toggle the selection status using an object
         if (selectedCategory[selectedId]) {
            // ID is already in the object, remove it
            delete selectedCategory[selectedId];


            var inputValue = document.getElementById('filterCategories').value;

            // Split the input values into an array
            var valuesArray = inputValue.split(',');

            // Loop through the values and remove 'malayalam' if found
            for (var i = 0; i < valuesArray.length; i++) {
               if (valuesArray[i] === selectedId) {
                  valuesArray.splice(i, 1);
                  i--; // Adjust index to account for removed element
               }
            }
            inputValue.value = " ";
            // Join the modified array back into a string
            var newInputValue = valuesArray.join(',');

            // Update the input field with the new value
            document.getElementById('filterCategories').value = newInputValue;
            console.log(document.getElementById('filterCategories').value);


         } else {
            // ID is not in the object, add it
            selectedCategory[selectedId] = true;
            var msgElement = document.getElementById("filterCategories");
            msgElement.value += selectedId + ",";
            console.log(document.getElementById('filterCategories').value);
         }



      });
   });
});


function filterValues() {
   var date = $("#calender").val();
   var languages = $("#filterLanguages").val();
   var category = $("#filterCategories").val();

   $.ajax({
      type: "POST",
      url: 'components/bookMyShow.cfc?method=eventFilter',
      data: {
         date: date,
         languages: languages,
         category: category
      },
      success: function (response) {
         // Parse the XML response        
         var movieRowDiv = $('#movieRowDiv');
         movieRowDiv.empty();
         // Use DOMParser to parse the XML string
         var parser = new DOMParser();
         var xmlDoc = parser.parseFromString(response, "text/xml");

         // Extract data from the XML and store in a JavaScript structure
         var events = [];
         var recordset = xmlDoc.querySelector("recordset");
         var rowCount = parseInt(recordset.getAttribute("rowCount"));

         if (rowCount == 0) {
            movieRowDiv.append("No Data");
         }

         for (var i = 0; i < rowCount; i++) {
            var event = {};
            var fields = recordset.querySelectorAll("field");
            fields.forEach(function (field, index) {
               var fieldName = field.getAttribute("name");
               var value = field.children[i].textContent;
               event[fieldName] = value;
            });
            events.push(event);
         }

       
         events.forEach(function (event) {
            var eventDate = new Date(event.DATE);
            // var formattedDate = eventDate.toLocaleString('en-us', { weekday: 'short', day: 'numeric', month: 'short' });
            var weekday = eventDate.toLocaleString('en-us', {
               weekday: 'short'
            });
            var day = eventDate.toLocaleString('en-us', {
               day: '2-digit'
            });
            var month = eventDate.toLocaleString('en-us', {
               month: 'short'
            });

            // Construct the formatted date
            var formattedDate = weekday + ', ' + day + ' ' + month;
            var eventHtml =
               '<a href="event.cfm?eventId=' + event.EVENT_ID + '" class="movieLink" id="eventLinkDetails">' +
               '<div>' +
               '<div width="100%" height="100%">' +
               '<div class="movieImg">' +
               '<img src="assests/' + event.PROFILE_IMG + '" alt="' + event.PROFILE_IMG + '" width="100%" height="100%">' +
               '<div class="rating text-white fs-15 ">' +
               '<span class="d-flex ms-2">' + formattedDate + '</span>' +
               '</div>' +
               '</div>' +
               '</div>' +
               '<div class="detailsDiv">' +
               '<div>' +
               '<div class="movieName">' + event.NAME + '</div>' +
               '</div>' +
               '<div>' +
               '<div class="movieGenre">' + event.VENUE + ':' + event.LOCATION + ' </div>' +
               '</div>' +
               '<div>' +
               '<div class="movieGenre fs-14">' + event.CATEGORY + ' </div>' +
               '</div>' +
               '</div>' +
               '</div>' +
               '</div>' +
               '</a>';
            movieRowDiv.append(eventHtml);


         });


      },
      error: function (error) {
         console.error("Error changing session variable:", error);
      }
   });
}