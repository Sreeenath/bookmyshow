<!DOCTYPE html>
<html lang="en">
   <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>EventListing</title>
      <script src="script/jquery-3.6.4.js"></script>
      <link rel="stylesheet" href="style/jquery-ui.css">
      <script src="script/jquery-ui.js"></script>
      <script src="script/bootstrap-js.js"></script>
      <link rel="stylesheet" href="style/bootstrap.css">
      <link rel="stylesheet" href="style/eventList.css">
      <link rel="stylesheet" href="style/movieList.css">
      <script src="script/eventListing.js"></script>
   </head>
   <body class="bg-body-secondary">
     <cfoutput>      
         <cfobject component="components/bookMyShow" name="objBookMyShow">
         <cfinclude  template="header.cfm">
         <div class="ps-5">
            <img  src="assests/eventCover.jpg" alt="promotion-banner " width="95%">
         </div>
         <div class="mainDiv">
            <form class="w-25">               
               <div class=" w-100 filterMainDiv">
                  <div class="filterTxt">Filters</div>   
                  <div class="dateDiv">
                     <div class="headingDate">
                        <div class=" dateTxtDiv">
                           <svg id="svgDate" xmlns="http://www.w3.org/2000/svg" onclick="toggleCalendar()" viewBox="0 0 15 10">
                              <path fill="none" stroke="##666666" stroke-width="1.5" d="M335 3L342 9.5 335 16" transform="rotate(90 175.5 -158.5)"></path>
                           </svg>
                        </div>
                        <span id="dateTxt">Date</span>
                        <div class="clear"  onclick="clearCalendar()">Clear</div>
                     </div>
                     <input  type="text" class=" mt-2 ms-1 calender" name="calender" id="calender" >
                  </div>   
                  <div class="dateDiv">
                     <div class="headingDate">
                        <div class=" dateTxtDiv">
                           <svg id="svgLanguage" xmlns="http://www.w3.org/2000/svg" onclick="toggleLanguage()" viewBox="0 0 15 10">
                              <path fill="none" stroke="##666666" stroke-width="1.5" d="M335 3L342 9.5 335 16" transform="rotate(90 175.5 -158.5)"></path>
                           </svg>
                        </div>
                        <span id="languageTxt">Language</span>
                        <div class="clear w-53"  onclick="clearLanguage()">Clear</div>
                     </div>
                     <div id="lang" >
                        <cfset local.event=objBookMyShow.fetchEventLanguages()>            
                        <cfloop query="local.event">
                           <div class="langMainDiv" >
                              <div class="langDiv" id="#local.event.language#">
                                 <div class="langTxt">#local.event.language#</div>
                              </div>
                           </div>
                        </cfloop> 
                        <input type="hidden" id="filterLanguages" value=""> 
                     </div>
                  </div>   
                  <div class="dateDiv">
                     <div class="headingDate">
                        <div class=" dateTxtDiv">
                           <svg id="svgCategories" xmlns="http://www.w3.org/2000/svg" onclick="toggleCategories()" viewBox="0 0 15 10">
                              <path fill="none" stroke="##666666" stroke-width="1.5" d="M335 3L342 9.5 335 16" transform="rotate(90 175.5 -158.5)"></path>
                           </svg>
                        </div>
                        <span id="categoriesTxt">Categories</span>
                        <div class="clear w-50"  onclick="clearCategories()">Clear</div>
                     </div>
                     <div id="categories" >
                        <cfset local.event=objBookMyShow.fetchEventCategory()>            
                        <cfloop query="local.event">
                           <div class="categoriesMainDiv" >
                              <div class="categoriesDiv" id="#local.event.category#">
                                 <div class="categryTxt">#local.event.category#</div>
                              </div>
                           </div>
                        </cfloop>  
                        <input type="hidden" id="filterCategories" value="">
                     </div>
                  </div>
                  <div class="filterDiv" onclick="filterValues()" >                  
                     Apply Filter
                  </div>
               </div>
            </form>
            <div class="eventListMainDiv">
               <div class="filterTxt">Events</div>
               <div class="eventMainListDiv mt-3">
                  <div class="divEventList">
                     <div class="event">
                        <div class="eventDiv">
                           <div class="eventNameDiv">
                              <div class="eventTxt">Comedy Shows</div>
                           </div>
                        </div>
                     </div>
                     <div class="event">
                        <div class="eventDiv">
                           <div class="eventNameDiv">
                              <div class="eventTxt">Music Shows</div>
                           </div>
                        </div>
                     </div>
                     <div class="event">
                        <div class="eventDiv">
                           <div class="eventNameDiv">
                              <div class="eventTxt">Workshops</div>
                           </div>
                        </div>
                     </div>
                     <div class="event">
                        <div class="eventDiv">
                           <div class="eventNameDiv">
                              <div class="eventTxt">New Year Parties</div>
                           </div>
                        </div>
                     </div>
                     <div class="event">
                        <div class="eventDiv">
                           <div class="eventNameDiv">
                              <div class="eventTxt">Performances</div>
                           </div>
                        </div>
                     </div>
                     <div class="event">
                        <div class="eventDiv">
                           <div class="eventNameDiv">
                              <div class="eventTxt">Kids</div>
                           </div>
                        </div>
                     </div>
                     <div class="event">
                        <div class="eventDiv">
                           <div class="eventNameDiv">
                              <div class="eventTxt">Online Streaming Events</div>
                           </div>
                        </div>
                     </div>
                     <div class="event">
                        <div class="eventDiv">
                           <div class="eventNameDiv">
                              <div class="eventTxt">Conferences</div>
                           </div>
                        </div>
                     </div>
                  </div>                  
               </div>
               <cfset local.event=objBookMyShow.fetchEventDetails()>                                                                       
               <div class="movieRowDiv p-0 mt-3" id="movieRowDiv"> 
                  <cfloop query="local.event">
                     <cfset local.encryptedEventId= encrypt(local.event.event_id,#application.key#,'AES', 'Base64')>
                     <cfset local.encryptedEventId = replace(local.encryptedEventId, "+", "!", "all")>
                     <cfset local.encryptedEventId = replace(local.encryptedEventId, "\", "@", "all")>  
                     <a href="event.cfm?eventId=#local.encryptedEventId#" class=" movieLink" id="eventLinkDetails">
                        <div>                              
                           <div width="100%" height="100%" >
                              <div class="movieImg">
                                 <img src="assests/#local.event.profile_img#" alt="#local.event.profile_img#" width="100%" height="100%">
                                 <div class="rating text-white fs-15 ">                                          
                                    <span class="d-flex ms-2">
                                    #dateFormat(local.event.date, 'ddd, dd mmm')#
                                    </span>                                    
                                 </div>
                              </div>
                           </div>
                           <div class="detailsDiv">
                              <div>
                                 <div class="movieName">#local.event.name#</div>
                              </div>
                              <div>
                                 <div class="movieGenre">#local.event.venue#:#local.event.location#  </div>
                              </div>
                              <div>
                                 <div class="movieGenre fs-14">#local.event.category#  </div>
                              </div>
                           </div>
                        </div>
                     </a>    
                  </cfloop> 
               </div>            
            </div>
         </div>
     </cfoutput>
   </body>
</html>