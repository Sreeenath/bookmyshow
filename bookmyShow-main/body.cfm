
<cfobject component="components/bookMyShow" name="objBookMyShow">
<cfinclude  template="header.cfm">
<cfinclude  template="slide.cfm">
<cfset currentURL = "http://#CGI.SERVER_NAME#:#CGI.SERVER_PORT##CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#">
<!-- Extract 'code' parameter value from the URL -->
<cfset code = "">
<cfif StructKeyExists(URL, "code")>
   <cfset code = URL.code>
   <cfset local.user=objBookMyShow.getGoogleUserInfo(code)>  
</cfif>
 
<div class="titleDiv px-5 ">
   <div class="textDiv">
      <h2 class="text-1">Recommended Movies</h2>
   </div>
   <div>
      <a href="movieList.cfm" class="text2style">
         <div class="text-2">See All ></div>
      </a>
   </div>
</div>
<div class="movieMainDiv mt-2 px-5">
   <div class="movieListDiv">
      <div class="moviesDiv">
         <cfset local.movies=objBookMyShow.fetchAllMovieDetails()>
         
         <cfloop query="local.movies">
            <cfoutput>
               <div> 
                  <cfset local.movieId=local.movies.movieId>
                  <cfset local.encryptedMovieId= encrypt(local.movieId,#application.key#,'AES', 'Base64')>
                  <cfset local.encryptedMovieId = replace(local.encryptedMovieId, "+", "!", "all")>
                  <cfset local.encryptedMovieId = replace(local.encryptedMovieId, "\", "@", "all")>
                  <cfif local.movies.status NEQ 0> 
                     <a href="movie.cfm?movieId=#local.encryptedMovieId#" id="" class=" movieLink">
                        <div >
                           <div class="">
                           </div>
                           <div width="100%" height="100%" >
                              <div class="movieImg">
                                 <img src="assests/#local.movies.profile_img#" alt="#local.movies.name#" width="100%" height="100%">
                                 <div class="rating text-white fs-15 d-flex justify-content-around">                                          
                                    <span class="d-flex"><img class="me-2" src="assests/star.png" alt="star" width="20" height="20">#local.movies.rating#/10</span>
                                    <span>6.7k Votes</span>
                                 </div>
                              </div>
                           </div>
                           <div class="detailsDiv">
                              <div>
                                 <div class="movieName">#local.movies.name#</div>
                              </div>
                              <div>
                                 <div class="movieGenre">#local.movies.genre#</div>
                              </div>
                           </div>
                        </div>
                     </a>
                  </cfif>
               </div>
            </cfoutput>
         </cfloop>
      </div>
   </div>
</div>
<div class="streamDiv px-5 mt-3">
   <img src="assests/stream.jpg" alt="Stream" width="100%" height="100%">
</div>
<div class="titleDiv px-5 pt-5">
   <div class="textDiv">
      <h2 class="text-1">Events</h2>
   </div>
   <div>
      <a href="eventList.cfm" class="text2style">
         <div class="text-2">See All ></div>
      </a>
   </div>
</div>
<div class=" movieMainDiv mt-2 px-5">
   <div class=" movieListDiv">
      <div class="moviesDiv">
         <cfset local.event=objBookMyShow.fetchEventDetails()>
         <cfloop query="local.event">
            <cfoutput>
               <div>
                  <cfset local.encryptedEventId= encrypt(local.event.event_id,#application.key#,'AES', 'Base64')>
                  <cfset local.encryptedEventId = replace(local.encryptedEventId, "+", "!", "all")>
                  <cfset local.encryptedEventId = replace(local.encryptedEventId, "\", "@", "all")>
                  <a href="event.cfm?eventId=#local.encryptedEventId#" class=" movieLink">
                     <div>
                        <div>
                        </div>
                        <div width="100%" height="100%" >
                           <div class=" movieImg">
                              <img src="assests/#local.event.profile_img#" alt="#local.event.name#" width="100%" height="100%">
                              <div class="rating text-white fs-15 ">                                          
                                 <span class="d-flex ms-2">
                                 #dateFormat(local.event.date, 'ddd, dd mmm')#
                                 </span>                                    
                              </div>
                           </div>
                        </div>
                        <div class="detailsDiv">
                           <div >
                              <div class=" movieName">#local.event.name#</div>
                           </div>
                           <div>
                              <div class=" movieGenre">#local.event.venue#:#local.event.location# </div>
                           </div>
                        </div>
                     </div>
                  </a>
               </div>               
            </cfoutput>
         </cfloop>
      </div>
   </div>
</div>
<cfinclude  template="footer.cfm">
