<!DOCTYPE html>
<html lang="en">
   <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Movie</title>    
    <script src="script/jquery-3.6.4.js"></script>
    <link rel="stylesheet" href="style/movie.css">
    <script src="script/movie.js"></script>  
   </head>
   <body>
        <cfobject component="components/bookMyShow" name="objBookMyShow">
        <cfinclude  template="header.cfm">        
        <cfparam name="URL.movieId" default=""> 
        <cfset local.encryptedMovieId = replace(movieId,"!","+", "all")>
        <cfset local.encryptedMovieId = replace(local.encryptedMovieId,"@","\", "all")>
        <cfset local.decryptedMovieId = decrypt(local.encryptedMovieId,#application.key#, 'AES', 'Base64')>        
        <cfset session.movieId=local.decryptedMovieId>         
        <cfset local.movie=objBookMyShow.fetchMovieDetailsBasedOnId(local.decryptedMovieId)> 
        <cfloop query="local.movie">
            <cfoutput>       
                <div class="movie">
                    <div class="hhpXm" id="movieDiv"> 
                        <input type="hidden" id="profile_img" value="assests/#local.movie.cover_img#">                       
                        <div class="kSSnur">
                            <div class="brstsF">
                                <section class="hxpocV">
                                    <div type="vertical" class=" bGEZCd">
                                        <div class=" profile-img-div" >
                                            <img src="assests/#local.movie.profile_img#" alt="#local.movie.name#" width="100%" height="100%" class=" hoyqAn" style="border-radius: 16px 16px 0px 0px; object-fit: cover;">
                                        </div>                           
                                    </div>
                                    <section type="vertical"  class="text-black fGbICE">
                                        <div class="ePqEqS">
                                            <span class="text-white hnDFhW">In cinemas</span>
                                        </div>
                                    </section>
                                </section>
                            </div>
                            <div class="ghYvew">
                                <h1 class="movieNameTxt">#local.movie.name#</h1>
                                <section class="sectionVotes">
                                    <div class=" sectionDiv">                            
                                        <span class="ratingTxt d-flex"><img class="me-2" src="assests/star.png" alt="star" width="25" height="25">#local.movie.rating#/10</span>
                                        <span class="votes">5K Votes</span>                           
                                    </div>
                                </section>                            
                                <section class=" ratingSection">
                                    <div class=" ratingDiv">
                                        <div class="addingRateDiv">
                                            <h5 class=" addRateTxt">Add your rating & review</h5>
                                            <h6 class=" rateTxt">Your ratings matter</h6>
                                        </div>
                                        <button class="cJOuSt">
                                        <span>Rate now</span>
                                        </button>
                                    </div>                                    
                                </section>
                                <div class="detailsDiv">
                                    <div class="movieDetailsDiv">
                                        <div class="movieDetailsTxt">
                                            <a href="" class="fizEby text-decoration-none">#local.movie.dimension#</a>
                                        </div>
                                        <div class="movieDetailsTxt">
                                            <a href="" class=" fizEby text-decoration-none">#local.movie.language#</a>
                                        </div>
                                    </div>
                                    <div class="movieDetailsDiv">#local.movie.duration#
                                        <span class="starIcon">  *  </span>
                                        <a href="" class="text-white bHMPWI text-decoration-none">#local.movie.genre#</a>
                                        <span class="starIcon">  *  </span>#local.movie.cert_type#
                                        <span class="starIcon ">  * #dateFormat(local.movie.release_date, 'dd mmm, yyyy')#</span>
                                    </div>
                                </div>
                                <div class="w-50 bookingDiv">
                                    <cfset local.encryptedMovieId= encrypt(local.decryptedMovieId,#application.key#,'AES', 'Base64')>
                                    <cfset local.encryptedMovieId = replace(local.encryptedMovieId, "+", "!", "all")>
                                    <cfset local.encryptedMovieId = replace(local.encryptedMovieId, "\", "@", "all")>
                                    <a href="theaterList.cfm?movieId=#local.encryptedMovieId#">
                                        <button  class="btnBookTicket">
                                            <div class="bookTicketBtnDiv">
                                                <span  class="bookTicketBtn" >Book tickets</span>
                                            </div>
                                        </button>
                                    </a>                            
                                </div>
                            </div>
                        </div>
                    </div>
                <section class="sectionAbout bg-white">
                    <span class="aboutSpan">
                        <h4 class="aboutHeading">About the movie</h4>
                        <div class="aboutTxt">
                            <span class="fs-16">#local.movie.about#</span>
                        </div>
                    </span>
                </section>
            </cfoutput>
        </cfloop> 
        <cfinclude  template="footer.cfm">  
    </body>
</html>