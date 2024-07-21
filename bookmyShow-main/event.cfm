<!DOCTYPE html>
<html lang="en">
   <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Event</title>
      <script src="script/jquery-3.6.4.js"></script>             
      <link rel="stylesheet" href="style/event.css">   
   </head>
   <body>
      <cfobject component="components/bookMyShow" name="objBookMyShow">
      <cfinclude  template="header.cfm">
      <cfparam name="URL.eventId" default="">  
      <cfset local.encryptedeventId = replace(eventId,"!","+", "all")>
      <cfset local.encryptedeventId = replace(local.encryptedeventId,"@","\", "all")>
      <cfset local.decryptedEventId = decrypt(local.encryptedeventId,#application.key#, 'AES', 'Base64')> 
      <cfset local.event=objBookMyShow.fetchEventDetailsBasedOnId(local.decryptedEventId)>
      <cfoutput>         
         <cfloop query="local.event">
            <div class="hhpXm" id="movieDiv"> 
               <input type="hidden" id="profile_img" value="assests/#local.event.cover_img#">    
            </div>
           
            <div class="detailsMainDiv d-flex px-3">
               <div>
                  <div class="detailsDiv">
                     <h1 class="eventName">#local.event.name#</h1>
                  </div>
                  <div class="eventOtherDetailsDiv">
                     <div class="eventOtherDetails">#local.event.categories# | #local.event.languages# |  #local.event.duration#</div>
                  </div>
               </div>
               <div class="mt-2">
                  <button class="btnBookEventTkt" id="btnBookEventTkt" onclick="openForm()">Book</button>
               </div>
            </div>
            <div class="d-flex divStyle px-3 mt-2">        
               <div >#dateFormat(local.event.date, 'ddd dd mmm yyyy')#</div>       
               <div class="ms-1"> at 6:30 PM</div>
               <div class="ms-4">
                  <span class="material-symbols-outlined">
                     location_on
                  </span>
               </div>
               <div class="ms-1" >#local.event.venue#: #local.event.location# </div>
               <div class="ms-3"> | </div>
               <span class="material-symbols-outlined fs-6 ms-3 mt-1">
                  currency_rupee
                  </span>
               <div class="ms-1">#local.event.rate#</div>
            </div>
         </cfloop>
      </cfoutput>
      <div class="overlay" id="overlay" onclick="closeForm()"></div>
      <div class="form-popup" id="eventBookingFormDiv">
        <form action="eventList.cfm" class="eventBookingForm" method="post">
            <h4>Event Booking Form</h4>
            <div class="selectSeat">
               <label for="seat_select">How Many Seats?:</label>
               <select name="seats" id="seatSelect">            
                  <option value="1" selected>1</option>
                  <option value="2">2</option>
                  <option value="3">3</option>
                  <option value="4">4</option>
                  <option value="5">5</option>
                  <option value="6" >6</option>
                  <option value="7">7</option>
                  <option value="8">8</option>
                  <option value="9">9</option>
                  <option value="10">10</option>            
               </select>
            </div>
            <cfoutput>
               <input type="hidden" id="userId" value=" #session.userId#">
               <input type="hidden" id="eventId" value="#local.decryptedEventId#">
            </cfoutput>
            <button type="submit" class="btn"  onclick="eventBookingConfirm()">Confirm Booking</button>
            <button type="button" class="btn cancel" onclick="closeForm()">Close</button>
        </form>
      </div> 
      <cfinclude  template="footer.cfm">
      <script src="script/event.js"></script>  
   </body>
</html>