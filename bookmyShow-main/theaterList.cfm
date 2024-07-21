<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>theater</title>
    <script src="script/jquery-3.6.4.js"></script>
    <link rel="stylesheet" href="style/jquery-ui.css">
    <script src="script/jquery-ui.js"></script>
    <script src="script/bootstrap-js.js"></script>
    <script src="script/theaterList.js"></script>
    <link rel="stylesheet" href="style/theaterList.css">    
</head>
    <body>
        <cfobject component="components/bookMyShow" name="objBookMyShow">
        <cfinclude  template="header.cfm">
        <cfparam name="URL.movieId" default=""> 
        <cfset local.encryptedMovieId = replace(movieId,"!","+", "all")>
        <cfset local.encryptedMovieId = replace(local.encryptedMovieId,"@","\", "all")>
        <cfset local.decryptedMovieId = decrypt(local.encryptedMovieId,#application.key#, 'AES', 'Base64')>
        <cfset session.encryptedMovieId=local.encryptedMovieId>  
        <cfset session.movieId=local.decryptedMovieId>              
        <cfset local.theaterList=objBookMyShow.theaterListBasedOnMovie(session.movieId) >
        <cfset local.movieList=objBookMyShow.fetchMovieDetailsBasedOnId(session.movieId) >
        <cfset formId=1>            
        <cfoutput>            
            <div class="pb-3 movie-details-div">
                <div class="movie-name pt-3 ps-3" >#local.movieList.name# - #local.movieList.language#</div>
                <div class="d-flex">
                    <div class="movie-cert ms-4">
                        <span class="fs-11">#local.movieList.cert_type#</span>
                    </div>
                    <cfset genreArray = listToArray(local.movieList.genre, "/")>
                    <cfloop array="#genreArray#" index="genre">
                        <div class="movie-genre fs-11 px-2 pt-1 ms-2">#genre#</div>
                    </cfloop>                   
                </div> 
            </div>            
            <input  type="hidden" class="ms-3 mt-2 ms-1 calender " name="calender"  id="calender"/>
            <div class="d-flex px-3 justify-content-between pb-1">
                <div class="dateDiv py-2 mt-2" id="datepickerTrigger"> 
                    <div id="weekday" class="date"></div>
                    <div id="day" class="date"></div>
                    <div id="month" class="date"></div>
                </div>
                <div class="d-flex ">
                    <div class="movie-lang-div bottom-border">
                        Malayalam - 2D
                    </div>
                    <div class="movie-lang-div d-flex ">
                        <span class="text-filter">Filter Price Range</span>
                        <span class="material-symbols-outlined  pointer">
                            expand_more
                            </span>
                    </div>
                    <div class="movie-lang-div d-flex ">
                        <span class="text-filter">Filter Show Timings</span>                   
                    </div>
    
                    <div class="movie-lang-div d-flex ">
                        <span class="material-symbols-outlined pointer">
                            search
                        </span>                    
                    </div>
                </div>  
            </div>
            <div class="bg-secondary-subtle p-3">
                <div  class="bg-white"> 
                    <div class=" d-flex pt-2 pb-2 px-3 justify-content-end ">
                        <div class="d-flex">
                            <div class="dot green "></div>
                            <div class="dot-text ms-2">Available</div>
                        </div>
                        <div class="d-flex ms-2">
                            <div class="dot orange "></div>
                            <div class="dot-text ms-2">Fast Filling</div>
                        </div>
                        <div class="d-flex ms-2">
                            <div class="subtitle-icon">LAN</div>
                            <div class="dot-text ms-2">Subtitles Language</div>
                        </div>                   
                    </div>
                     <!--- Theater List Div--->
                     <cfloop query="local.theaterList">
                        <div class="d-flex py-3 px-3 topBorder"> 
                            <div>
                                <div class="d-flex">
                                    <div>
                                        <span class="heart">
                                            favorite
                                        </span>
                                    </div>
                                    <div class="theater-name ms-2">
                                        #local.theaterList.name#: #local.theaterList.location#
                                    </div>
                                    <div class="info"> 
                                        <img src="assests/info.jpg"  width="15px" height="15px" alt="info">
                                        <span class="info-txt">INFO</span>
                                    </div>
                                </div>
                            </div>
                            <div>
                                <div class="ps-5 d-flex">
                                    <cfset timeArray = listToArray(local.theaterList.times, ",")>                                    
                                    <cfloop array="#timeArray#" index="time">
                                        <form action="seat.cfm"  method="post">
                                            <input type="hidden" name="movieId" id="movieId" value="#session.movieId#">                                            
                                            <input type="hidden" name="time" id="time" value="#time#">
                                            <input type="hidden" name="date" id="date" class="date">
                                            <input type="hidden" name="theaterId" id="theaterId" value="#local.theaterList.id#">
                                            <button  type="submit" class="bg-white theater-time ms-3" >#time#</button>
                                        </form>
                                        <cfset formId+=1>                                        
                                    </cfloop>    
                                </div>
                                <div class="ps-5 ms-4 mt-3 d-flex">
                                    <span class="gold-icon mt-2"></span>
                                    <span class="px-2 nonCancelTxt">Non-cancellable</span>
                                </div>
                            </div>
                        </div>
                     </cfloop>                    
                </div> 
            </div>
        </cfoutput>    
        <cfinclude  template="footer.cfm">
    </body>
</html>