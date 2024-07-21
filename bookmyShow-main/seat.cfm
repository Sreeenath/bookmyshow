<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0"> 
    <title>seat</title>
    <script src="script/jquery-3.6.4.js"></script>
    <link rel="stylesheet" href="style/googleFont.css">
    <link rel="stylesheet" href="style/bootstrap.css">
    <link rel="stylesheet" href="style/theaterList.css">
    <link rel="stylesheet" href="style/seat.css">
    <script src="script/seat.js" ></script>
</head>
    <body>
        <cfobject component="components/bookMyShow" name="objBookMyShow">
        <cfif structKeyExists(form,"movieId")>
            <cfset local.movieId="#form.movieId#">  
            <cfset session.movieId=local.movieId>         
            <cfset local.theaterId="#form.theaterId#">
            <cfset session.theaterId=local.theaterId>
            <cfset local.time="#form.time#">
            <cfset session.time=local.time>
            <cfset local.date="#form.date#">
            <cfset session.date=local.date>            
        </cfif>
        <cfset local.theater=objBookMyShow.theaterDetailsBasedOnId(session.theaterId)>
        <cfset local.movieList=objBookMyShow.fetchMovieDetailsBasedOnId(session.movieId) >
        <cfoutput>            
            <div class="d-flex header justify-content-between pe-3">   
                <div class="d-flex">                    
                    <button  class="border-0 bg-white" onclick="backPage()"> 
                        <span class="material-symbols-outlined mt-1">
                            arrow_back_ios
                        </span>
                    </button>                     
                    <div>
                        <div class="d-flex">
                            <div>#local.movieList.name#</div>
                            <span class=" ms-1 ">
                                <span class="movie-cert p-1 fs-9">#local.movieList.cert_type#</span>
                            </span>  
                        </div>        
                        <div class="theater-date-details">
                            #local.theater.name#: #local.theater.location# | #dateFormat(session.date, 'ddd, dd mmm')#, #session.time#
                        </div>
                    </div> 
                </div>     
                <div>                    
                    <button type="submit" class="border-0 bg-white" onclick="backPage()"><span class="material-symbols-outlined ">
                        close
                    </span></button>
                </div>                        
            </div>
            <div class="ps-5 d-flex bg-light py-2">
                <cfset timeArray = listToArray(local.theater.times, ",")>                                    
                <cfloop array="#timeArray#" index="time">                                           
                    <button  type="submit" class="bg-white theater-time ms-3" >#time#</button> 
                </cfloop>    
            </div>
            <cfset local.seatList=objBookMyShow.getSeatDetails()>           
            <cfset local.bookedSeats=objBookMyShow.fetchBookedSeatDetails(session.movieId,local.theater.id,session.date,session.time)>
            <cfset local.bookedSeatsArray = []>
            <cfloop query="local.bookedSeats">
                <cfset arrayAppend(local.bookedSeatsArray, local.bookedSeats.seat)>
            </cfloop>
            <form  action="##" id="#local.seatList.type#" >  
                <div class="seatDiv pt-3">
                    <cfloop query="local.seatList">
                        <cfset local.seatType=#local.seatList.type#>
                        <div class="seatType mt-2">#local.seatList.type#-Rs. #local.seatList.rate#.00</div>                     
                    
                            <input type="hidden" name="movieId" id="movieId" value="#session.movieId#">                                            
                            <input type="hidden" name="time" class="time" value="#session.time#">
                          
                            <input type="hidden" name="date" id="date" class="date" value="#session.date#">
                            <cfif local.seatList.seats EQ 10>
                                <table class="m-auto">
                            <cfelse>
                                <table>
                            </cfif>  
                                    <tr>
                                        <cfloop from="1" to="#local.seatList.seats#" index="i">
                                            <cfset local.seat=local.seatType&i>
                                            <td>  
                                                <cfif arrayFind(local.bookedSeatsArray, local.seat) neq 0>
                                                    <div class="seat mx-2 mt-2 booked"  id="#local.seatList.type##i#">#i#</div>
                                                    <cfelse>
                                                        <div class="seat mx-2 mt-2" onclick="changeStyle(this,#local.seatList.rate#,#i#,'#local.seatList.type#','#local.seatList.type##i#')"  id="#local.seatList.type##i#">#i#</div>
                                                </cfif>
                                            </td>
                                            <cfif i % 20 EQ 0>
                                                </tr>
                                                <tr >
                                            </cfif>
                                        </cfloop>
                                    </tr>
                                </table>                                                             
                    </cfloop>                
                    <div class="eye-text text-center mt-5 pt-5">All eyes this way please!</div>
                    <div class="text-center mt-5">                    
                        <button class="payBtn fs-15"  onclick="booking(#session.movieId#,#local.theater.id#,#session.userId#)"  id="payBtn">Pay</button>
                    </div>
                </div>
            </form> 
        </cfoutput>
    </body>
</html>