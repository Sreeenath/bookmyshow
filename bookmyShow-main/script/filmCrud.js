$(document).ready(function () {
   $("#statusDiv").hide();
   new MultiSelectTag('theaters')  //for mutli select
   $('input[name="language"]').change(function () {
      var selectedLangs = [];
      $('input[name="language"]:checked').each(function () {
         selectedLangs.push($(this).val());
      });
      $('#selectedLanguages').val(selectedLangs.join(', '));
   });


   $('input[name="genres"]').change(function () {
      var selectedGenre = [];
      $('input[name="genres"]:checked').each(function () {
         selectedGenre.push($(this).val());
      });
      $('#Genre').val(selectedGenre.join(', '));
   });


   // $('input[name="theater"]').change(function () {
   //    var selectedGenre = [];
   //    $('input[name="theater"]:checked').each(function () {
   //       selectedGenre.push($(this).val());
   //    });
   //    $('#selectedTheater').val(selectedGenre.join(', '));
   // });

  



});
var countGenre = 0
var countLang = 0

function reloadPage() {
   window.location.href = "filmCrud.cfm"
}

$(".deleteMovieBtn").click(function () {
   var movieId = $(this).data("movieid");
   $.ajax({
      url: 'components/bookMyShow.cfc?method=deleteMovie',
      type: "POST",
      data: {
         movieId: movieId,

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


$(".view").click(function () {
   var movieId = $(this).data("movieid");


   $.ajax({

      url: 'components/bookMyShow.cfc?method=movieDetailsBasedOnId',

      // Type of Request
      type: "POST",
      data: {
         movieId: movieId
      },
      success: function (data) {
         console.log(data);
         $("#movieName").val($(data).find("field[name='NAME'] string").text());
         $("#duration").val($(data).find("field[name='DURATION'] string").text());
         $("#language").val($(data).find("field[name='LANGUAGE'] string").text());
         $("#genre").val($(data).find("field[name='GENRE'] string").text());
         $("#dimension").append('<option value="' + $(data).find("field[name='DIMENSION'] string").text() + '">' + $(data).find("field[name='DIMENSION'] string").text() + '</option>');
         $("#certificate").val($(data).find("field[name='CERT_TYPE'] string").text());
         $("#about").val($(data).find("field[name='ABOUT'] string").text());

         let img = $(data).find("field[name='PROFILE_IMG'] string").text();
         let path = "assests/" + img;
         $("#profileImg").attr("src", path);

         $("#movieName").prop("disabled", true);
         $("#duration").prop("disabled", true);
         $("#language").prop("disabled", true);
         $("#genre").prop("disabled", true);
         $("#dimension").prop("disabled", true);
         $("#certificate").prop("disabled", true);
         $("#about").prop("disabled", true);


      },
      error: function (jqXHR, textStatus, errorThrown) {
         console.error("AJAX Error: " + textStatus, errorThrown);
      }
   });
});


$(".edit").click(function () {
   var movieId = $(this).data("movieid");
   
   $.ajax({

      url: 'components/bookMyShow.cfc?method=movieDetailsBasedOnId',

      // Type of Request
      type: "POST",
      data: {
         movieId: movieId
      },
      success: function (data) {
         console.log(data);
         var timeInput = document.getElementById("time");
         var convertedTime = convertTimeTo24HourFormat($(data).find("field[name='DURATION'] string").text());
         timeInput.value = convertedTime;
         $('#convertedTime').text(convertTo12HourFormat(convertedTime));
         $("#editMovieName").val($(data).find("field[name='NAME'] string").text());
         $("#editLanguage").val($(data).find("field[name='LANGUAGE'] string").text());

         var languageValues = $(data).find("field[name='LANGUAGE'] string").text().split('/');
         // Loop through the language values
         languageValues.forEach(function (value) {
            // Remove the corresponding option from the select element
            $(".langInput option:contains('" + value + "')").remove();
         });

         $("#editGenre").val($(data).find("field[name='GENRE'] string").text());
         var genreValues = $(data).find("field[name='GENRE'] string").text().split('/');
         // Loop through the genre values
         genreValues.forEach(function (value) {
            // Remove the corresponding option from the select element
            $(".genreInput option:contains('" + value + "')").remove();
         });


         $("#editDimension").val(parseInt($(data).find("field[name='DIMENSIONID'] number").text()));
         $("#editCertificate").val(parseInt($(data).find("field[name='CERTID'] number").text()));
         $("#editAbout").val($(data).find("field[name='ABOUT'] string").text());
         var statusValue = $(data).find("field[name='STATUS'] number").text();
         $("#editStatus").empty();
         if (statusValue == "1.0") {
            $("#editStatus").append('<option value="1" selected>Active</option>');
            $("#editStatus").append('<option value="0">Inactive</option>');
         } else {
            $("#editStatus").append('<option value="1">Active</option>');
            $("#editStatus").append('<option value="0" selected>Inactive</option>');
         }
         let img = $(data).find("field[name='PROFILE_IMG'] string").text();
         let path = "assests/" + img;
         $("#editProfileImg").attr("src", path);

         $.ajax({

            url: 'components/bookMyShow.cfc?method=theaterListBasedOnMovieId',
   
            // Type of Request
            type: "POST",
            data: {              

               movieId:parseInt($(data).find("field[name='MOVIEID'] number").text()),
               
            },
            success: function (data) {
               console.log(data);
               const xmlDoc = $.parseXML(data);
               const $xml = $(xmlDoc);
               
               // Extract the ID values using jQuery
               const ids = $xml.find("field[name='ID'] number").map(function() {
                 return parseFloat($(this).text());
               }).get();
             
               // Display the IDs as a string
               console.log(ids);
               $("#editTheaters").val(ids);
               new MultiSelectTag('editTheaters');
   
            },
            error: function (jqXHR, textStatus, errorThrown) {
               console.error("AJAX Error: " + textStatus, errorThrown);
            }
         });


      },
      error: function (jqXHR, textStatus, errorThrown) {
         console.error("AJAX Error: " + textStatus, errorThrown);
      }

   });


   $("#saveBtn").click(function () {

      
      var theatersId= $("#editTheaters").val();
      var theatersId = theatersId.join(',');
      console.log(theatersId);
      var duration = $("#convertedTime").text();
      var langId = getAllSelectedLang();
      var genreId = getAllSelectedGenre();
      var name = $("#editMovieName").val();
      var dimension = $("#editDimension").val();
      var status = $("#editStatus").val();
      var cert = $("#editCertificate").val();
      var about = $("#editAbout").val();
      $.ajax({

         url: 'components/bookMyShow.cfc?method=updateMovieDetails',

         // Type of Request
         type: "POST",
         data: {
            name: name,
            movieId: movieId,
            duration: duration,
            langId: langId,
            genreId: genreId,
            dimension: dimension,
            status: status,
            cert: cert,
            about: about,
            theaters:theatersId
         },
         success: function (data) {
            alert("Updated Successfully");
            window.location.href = "filmCrud.cfm";


         },
         error: function (jqXHR, textStatus, errorThrown) {
            console.error("AJAX Error: " + textStatus, errorThrown);
         }
      });


   });
});

function convertTimeTo24HourFormat(timeString) {
   // Split the timeString into hours and minutes
   var timeArray = timeString.split(' ');

   // Extract hours and minutes from the array
   var hours = parseInt(timeArray[0].replace('h', ''), 10);
   var minutes = parseInt(timeArray[1].replace('m', ''), 10);

   // Convert to total minutes
   var totalMinutes = hours * 60 + minutes;

   // Convert to 24-hour format
   var hours24 = Math.floor(totalMinutes / 60);
   var minutes24 = totalMinutes % 60;

   // Format the result as "HH:mm"
   var formattedTime = ('0' + hours24).slice(-2) + ':' + ('0' + minutes24).slice(-2);

   return formattedTime;
}

$('#time').on('input', function () {
   var inputValue = $(this).val();
   var convertedTime = convertTo12HourFormat(inputValue);
   $('#convertedTime').text(convertedTime);
});

function convertTo12HourFormat(time24) {
   var timeArray = time24.split(':');
   var hours = parseInt(timeArray[0], 10);
   var minutes = timeArray[1];


   hours = hours % 12 || 12;

   // Format the time as "2h 30min"
   var formattedTime = hours + 'h ' + minutes + 'm ';

   return formattedTime;
}

function toggleLangDiv() {
   var selectDiv = document.getElementById("selectLangDiv");
   var selectbtn = document.getElementById("add");

   // Get the computed style of the element
   var computedStyle = window.getComputedStyle(selectDiv);

   // Toggle the visibility of the div
   if (computedStyle.display === "none") {
      selectDiv.style.display = "block";
      selectbtn.style.display = "none";
      countLang = 0;

   } else {
      selectDiv.style.display = "none";
      selectbtn.style.display = "block";
   }
}

function toggleDeleteLangDiv() {
   var selectDiv = document.getElementById("selectLangDiv");
   var selectbtn = document.getElementById("add");

   // Get the computed style of the element
   var computedStyle = window.getComputedStyle(selectDiv);

   // Toggle the visibility of the div
   if (computedStyle.display === "none") {
      selectDiv.style.display = "block";
      selectbtn.style.display = "none";

   } else {
      selectDiv.style.display = "none";
      selectbtn.style.display = "block";
   }
}

function addLanguage() {
   // Clone the existing time container
   var originalLangContainer = document.querySelector('.lang-container');
   var clonedLangContainer = originalLangContainer.cloneNode(true);

   // Clear the value of the cloned time input
   var clonedLangInput = clonedLangContainer.querySelector('.langInput');
   clonedLangInput.value = '';
   clonedLangInput.selectedIndex = 0;

   // Add a delete button
   var deleteButton = document.createElement('button');
   deleteButton.innerHTML = 'Delete';

   deleteButton.style.backgroundColor = '#dc3545';
   deleteButton.style.color = 'white';
   deleteButton.style.border = 'none';
   deleteButton.style.borderRadius = '5px';
   deleteButton.style.padding = '5px 10px';
   deleteButton.onclick = function () {
      // Remove the cloned genre container when delete button is clicked
      document.getElementById('langContainer').removeChild(clonedLangContainer);
   };
   // Append the delete button to the cloned container
   clonedLangContainer.appendChild(deleteButton);
   // Append the cloned container to the langContainer div
   document.getElementById('langContainer').appendChild(clonedLangContainer);


}

function getAllSelectedLang() {
   // Get all the selected <option> elements in all select elements
   var selectedOptions = Array.from(document.querySelectorAll('.langInput option:checked'));

   // Get an array of values from the selected <option> elements
   var selectedValues = selectedOptions.map(function (option) {
      return option.value;
   });
   if (countLang == 1) {
      return ("");
   } else {
      return (selectedValues.join(','));
   }

}

function toggleGenreDiv() {
   var selectDiv = document.getElementById("selectGenreDiv");
   var selectbtn = document.getElementById("addGenre");

   // Get the computed style of the element
   var computedStyle = window.getComputedStyle(selectDiv);

   // Toggle the visibility of the div
   if (computedStyle.display === "none") {
      selectDiv.style.display = "block";
      selectbtn.style.display = "none";
      countGenre = 0;
   } else {
      selectDiv.style.display = "none";
      selectbtn.style.display = "block";

   }

}

function toggleDeleteGenreDiv() {
   var selectDiv = document.getElementById("selectGenreDiv");
   var selectbtn = document.getElementById("addGenre");

   // Get the computed style of the element
   var computedStyle = window.getComputedStyle(selectDiv);

   // Toggle the visibility of the div
   if (computedStyle.display === "none") {
      selectDiv.style.display = "block";
      selectbtn.style.display = "none";
   } else {
      selectDiv.style.display = "none";
      selectbtn.style.display = "block";
   }
}


function deleteGenre() {
   toggleDeleteGenreDiv();
   countGenre += 1;
}

function deleteLang() {
   toggleDeleteLangDiv();
   countLang += 1;
}


function addGenre() {
   // Clone the existing genre container
   var originalGenreContainer = document.querySelector('.genre-container');
   var clonedGenreContainer = originalGenreContainer.cloneNode(true);

   // Clear the value of the cloned genre input
   var clonedGenreInput = clonedGenreContainer.querySelector('.genreInput');
   clonedGenreInput.value = '';
   clonedGenreInput.selectedIndex = 0;

   // Add a delete button
   var deleteButton = document.createElement('button');
   deleteButton.innerHTML = 'Delete';

   deleteButton.style.backgroundColor = '#dc3545';
   deleteButton.style.color = 'white';
   deleteButton.style.border = 'none';
   deleteButton.style.borderRadius = '5px';
   deleteButton.style.padding = '5px 10px';
   deleteButton.onclick = function () {
      // Remove the cloned genre container when delete button is clicked
      document.getElementById('genreContainer').removeChild(clonedGenreContainer);
   };

   // Append the delete button to the cloned container
   clonedGenreContainer.appendChild(deleteButton);

   // Append the cloned container to the genreContainer div
   document.getElementById('genreContainer').appendChild(clonedGenreContainer);
}

function getAllSelectedGenre() {
   // Get all the selected <option> elements in all select elements
   var selectedOptions = Array.from(document.querySelectorAll('.genreInput option:checked'));

   // Get an array of values from the selected <option> elements
   var selectedValues = selectedOptions.map(function (option) {
      return option.value;
   });

   if (countGenre == 1) {
      return ("");
   } else {
      return (selectedValues.join(','));
   }


}



function getAllSelectedtheater(){
   var selectElement = document.getElementById("theaters");
   // Get the hidden input element
   var hiddenInput = document.getElementById("selectedTheater");
   // Get all selected options
   var selectedOptions = Array.from(selectElement.selectedOptions).map(option => option.value); 
   // Set the hidden input value to the selected options
   hiddenInput.value = selectedOptions.join(',');
   console.log( selectedOptions.join(','));
}



function getSelectedGenre() {
   // Get all checkboxes with the name 'eventLanguages'
   var checkboxes = document.querySelectorAll('input[name="genres"]:checked');
   // Create an array to store selected values
   var selectedValuesGenre = [];
   // Loop through the selected checkboxes and add their values to the array
   checkboxes.forEach(function (checkbox) {
      selectedValuesGenre.push(checkbox.value);
   });
   // Display selected values (you can modify this part based on your requirements)
   alert("Selected Values: " + selectedValuesGenre.join(','));
}

function getSelectedLanguages() {
   // Get all checkboxes with the name 'eventLanguages'
   var checkboxes = document.querySelectorAll('input[name="languages"]:checked');
   // Create an array to store selected values
   var selectedValuesLang = [];
   // Loop through the selected checkboxes and add their values to the array
   checkboxes.forEach(function (checkbox) {
      selectedValuesLang.push(checkbox.value);
   });
   // Display selected values (you can modify this part based on your requirements)
   alert("Selected Values: " + selectedValuesLang.join(','));
}

function validateRating(input) {
   // Remove any non-numeric characters except dot
   input.value = input.value.replace(/[^0-9.]/g, '');

   // Check if the value is a valid floating-point number
   if (!/^\d*\.?\d*$/.test(input.value)) {
      alert("Please enter a valid integer or floating-point number");
      input.value = ''; // You can choose to clear the input or keep the last valid value
   }
}

function convertTime() {
   // Get the input value in 24-hour format
   var inputTime = document.getElementById('addduration').value;

   // Split the hours and minutes
   var [hours, minutes] = inputTime.split(':');

   // Convert hours to 12-hour format
   var ampm = hours >= 12 ? 'pm' : 'am';
   hours = hours % 12 || 12;

   // Format the result
   var formattedTime = hours + 'h ' + minutes + 'm';

   // Set the result to the text input field
   document.getElementById('moviedDuration').value = formattedTime;
}