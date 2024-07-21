<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="script/jquery-3.6.4.js"></script>   
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/habibmhamadi/multi-select-tag@2.0.1/dist/css/multi-select-tag.css">
    <link rel="stylesheet" href="style/bootstrap.css">
    <link rel="stylesheet" href="style/jquery-ui.css">
    <link rel="stylesheet" href="style/filmCrud.css"> 
</head>
    <body>
        <cfinclude  template="header.cfm">
        <cfobject component="components/bookMyShow" name="objBookMyShow">
        <cfset local.movie=objBookMyShow.fetchMovieDetails()>
        <cfset local.theater=objBookMyShow.fetchTheaterDetailsBasedOnId("")>
        <cfoutput>          
            <div class="px-5 pt-5 ">
                <div class="d-flex justify-content-between">
                    <h2>Movie Details</h2>
                    <button type="button" class="addMovieBtn mt-1 px-1" id="addMovieBtn" data-toggle="modal" data-target=".movieAddModal">Add Movie</button>
                </div>
                <center>
                    <table class="mt-5 table">
                        <tr>
                            <th class="d-none">Id</th>
                            <th>Name</th>
                            <th>Duration</th>
                            <th>Language</th>
                            <th>Genre</th>
                            <th>Dimension</th>
                            <th>Certificate</th>
                            <th>View</th>
                            <th>Edit</th>
                            <th>Delete</th>
                        </tr>        
                        <cfloop query="local.movie">
                            <tr>
                                <td class="d-none">#local.movie.movieId#</td>
                                <cfif local.movie.status == 0>
                                    <td class="text-danger">#local.movie.name#</td>
                                <cfelse>
                                    <td>#local.movie.name#</td>
                                </cfif>                                
                                <td>#local.movie.duration#</td>
                                <td>#local.movie.language#</td>
                                <td>#local.movie.genre#</td>
                                <td>#local.movie.dimension#</td>
                                <td>#local.movie.cert_type#</td>
                                <td><button type="button" class="view border-0 bg-white btn btn-primary" data-movieid="#local.movie.movieId#" data-toggle="modal" data-target=".movieModal"><img src="assests/file.png" height="15px" width="15px" alt="view"></button></td>
                                <td><button type="button" class="edit border-0 bg-white btn btn-primary" data-movieid="#local.movie.movieId#" data-toggle="modal" data-target=".movieEditModal"><img src="assests/pen.png" height="15px" width="15px" alt="Edit"></button></td>                                
                                <td><button type="button" class="deleteMovieBtn border-0 bg-white mt-1"  data-movieid="#local.movie.movieId#"><img src="assests/trash.png" height="15px" width="15px" alt="Delete"></button></td>
                            </tr>
                        </cfloop>
                    </table>
                </center>             
            </div>            
        </cfoutput>

        <!---ViewModal--->
        <div class="modal fade movieModal" id="movieModal" data-backdrop="static"  tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
            <div class="modal-content1">
                <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel">Movie Details</h5>
                <button type="button" class="close border-0 bg-white" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                </div>
                <div class="modal-body pe-3"> 
                    <div class="d-flex">
                        <div>
                            <img id="profileImg" alt="img" height=75% width="100%" >
                        </div>
                        <div>
                            <div class="d-flex justify-content-between ps-4">
                                <label for="movieName">Name</label>
                                <div class="">
                                    <input type="text"id="movieName"  >
                                </div>
                            </div>                    
                            <div class="mt-2 d-flex justify-content-between ps-4">
                            <label for="duration">Duration</label>
                                <div class="">
                                    <input type="text"id="duration"  >
                                </div>
                            </div>                
                            <div class="mt-2 d-flex px-4">
                                <label for="language">Language</label>
                                <div class=" ms-5 p-8">
                                    <textarea id="language" name="language" rows="3" cols="21" ></textarea>
                                </div>
                            </div>
                            <div class="mt-2 d-flex justify-content-between ps-4">
                                <label for="genre">Genre</label>
                                <div class="">
                                    <textarea id="genre" name="genre" rows="3" cols="21" > </textarea>
                                </div>
                            </div>
                            <div class="mt-2 d-flex px-4">
                                <label for="dimension">Dimension</label>
                                <div class=" ms-5 p-20">
                                    <select class="ms-3" id="dimension" >                                
                                    </select>
                                </div>
                            </div>
                            <div  id="statusDiv">
                                <div class="mt-2 d-flex px-4">
                                    <label for="status">Status</label>
                                    <div class=" ms-5 p-10">
                                        <select class="ms-3" id="status" >                                
                                        </select>
                                    </div>
                                </div>
                            </div>                           
                            <div class="mt-2 d-flex justify-content-between ps-4">
                                <label for="certificate">Certificate</label>
                                <div class="">
                                    <input type="text" id="certificate"  > 
                                </div>
                            </div>
                            <div class="mt-2 d-flex px-4">
                                <label for="about">About</label>
                                <div class=" ms-5 p-17">
                                    <textarea id="about" name="about" rows="3" cols="21" ></textarea>
                                </div>
                            </div>
                        </div>
                    </div>                 
                </div>
                <div class="modal-footer">
                <button type="button" id="closeBtn" class="btn btn-secondary" data-dismiss="modal">Close</button>
                </div>
            </div>
            </div>
        </div>
         <!---EditModal--->
        <div class="modal fade movieEditModal" id="movieEditModal" data-backdrop="static"  tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content1">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalLabel">Movie Details</h5>
                        <button type="button" class="close border-0 bg-white" data-dismiss="modal" aria-label="Close" onclick="reloadPage()">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body pe-3"> 
                        <div class="d-flex">
                            <div>
                                <img id="editProfileImg" alt="img"  width="100%" >
                            </div>
                            <div>
                                <div class="d-flex justify-content-between ps-4">
                                    <label for="editMovieName">Name</label>
                                    <div class="">
                                        <input type="text"id="editMovieName"  >
                                    </div>
                                </div>                    
                                <div class="mt-2 d-flex  ps-4">
                                <label for="editDuration">Duration</label>
                                    <div class="p-25">
                                        <input type="time" id="time" name="time">
                                        <span class="d-none" id="convertedTime"></span>
                                    </div>
                                </div>      
                                <cfoutput>          
                                    <div class="mt-2 d-flex px-4">
                                        <label for="editLanguage">Language</label>
                                        <div class=" ms-5 p-8">
                                            <textarea id="editLanguage" name="editLanguage"  rows="1" cols="21"  readonly></textarea>
                                            <button  id="add" class="btn btn-success" onclick="toggleLangDiv()">Add</button>
                                            <cfset local.lang=objBookMyShow.fetchEventLanguages()>  
                                            <div id="selectLangDiv" class="hidden">
                                                <div id="langContainer" class="ms-3">
                                                    <!-- Initial time input field -->
                                                    <button class="btn btn-success" onclick="addLanguage()">Add</button>   
                                                    <button class="btn btn-danger" onclick="deleteLang()">Delete</button>                                                  
                                                    <div class="lang-container mt-2">
                                                        <select  id="lang" class="langInput" >
                                                            <option value="" selected></option>
                                                            <cfloop query="local.lang">
                                                                <option value="#local.lang.lang_id#">#local.lang.language#</option>
                                                            </cfloop>                                                        
                                                        </select>
                                                    </div>
                                                </div>
                                            </div>                                     
                                        </div>
                                    </div>                                    
                                    <div class="mt-2 d-flex justify-content-between ps-4">
                                        <label for="editGenre">Genre</label>
                                        <div class="">                                        
                                            <textarea id="editGenre" name="editGenre" rows="1" cols="21" readonly> </textarea>
                                            <div>
                                                <button  id="addGenre" class="btn btn-success" onclick="toggleGenreDiv()">Add</button>
                                                <cfset local.genre=objBookMyShow.fetchGenre()>   
                                                <div id="selectGenreDiv" class="hidden">
                                                    <div id="genreContainer" class="ms-3">
                                                        <!-- Initial time input field -->
                                                        <button class="btn btn-success" onclick="addGenre()">Add</button>                                                    
                                                        <button class="btn btn-danger" onclick="deleteGenre()">Delete</button> 
                                                        <div class="genre-container mt-2">
                                                            <select  id="genre" class="genreInput">
                                                                <option value="" selected></option>
                                                                <cfloop query="local.genre">
                                                                    <option value="#local.genre.genre_id#">#local.genre.genre_type#</option>
                                                                </cfloop>
                                                            </select>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <cfset local.dimension=objBookMyShow.fetchDimensions()> 
                                    <div class="mt-2 d-flex px-4">
                                        <label for="editDimension">Dimension</label>
                                        <div class=" ms-5">
                                            <select class="ms-3" id="editDimension" > 
                                                <cfloop query="local.dimension">
                                                    <option value="#local.dimension.dimension_id#">#local.dimension.dimension#</option>
                                                </cfloop>                                
                                            </select>
                                        </div>
                                    </div>                            
                                    <div  id="statusDiv">
                                        <div class="mt-2 d-flex px-4">
                                            <label for="editStatus">Status</label>
                                            <div class=" ms-5 p-10">
                                                <select class="ms-3" id="editStatus" >                                
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <cfset local.cert=objBookMyShow.fetchCertificate()>  
                                    <div class="mt-2 d-flex ps-4">
                                        <label for="editCertificate">Certificate</label>
                                        <div class="p-15">
                                            <select class="ms-3 " id="editCertificate" > 
                                                <cfloop query="local.cert">
                                                    <option  value="#local.cert.cert_id#">#local.cert.cert_type#</option>
                                                </cfloop> 
                                            </select>
                                        </div>
                                    </div>
                                    <div class="d-flex  ps-4">
                                        Select Theater
                                        <input type="hidden" id="editSelectedTheater" name="editSelectedTheater"> 
                                        <div class="w-75 ps-3">
                                            <select name="editTheaters" onchange="" id="editTheaters" multiple  >
                                                <cfloop query="local.theater">
                                                    <option value="#local.theater.id#">#local.theater.name#</option> 
                                                </cfloop>                                       
                                            </select>                                    
                                        </div>
                                    </div> 
                                </cfoutput>
                                <div class="mt-2 d-flex px-4">
                                    <label for="editAbout">About</label>
                                    <div class=" ms-5 p-17">
                                        <textarea id="editAbout" name="editAbout" rows="3" cols="21" ></textarea>
                                    </div>
                                </div>
                            </div>
                        </div>                  
                    </div>
                    <div class="modal-footer">
                    <button type="button" id="closeBtn" class="btn btn-secondary" data-dismiss="modal" onclick="reloadPage()">Close</button>
                    <button type="button" id="saveBtn" class="btn btn-primary">Save changes</button>
                    </div>
                </div>
            </div>
        </div>
         <!---InsertModal--->
        <cfoutput>
            <div class="modal fade movieAddModal" id="movieAddModal" data-backdrop="static"  tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
                <form action="filmCrud.cfm" enctype="multipart/form-data"  method="post">
                    <div class="modal-dialog" role="document">
                        <div class="modal-content1">
                            <div class="modal-header">
                                <h5 class="modal-title" id="exampleModalLabel">Add Movie Details</h5>
                                <button type="button" class="close border-0 bg-white" data-dismiss="modal" aria-label="Close" onclick="reloadPage()">
                                    <span aria-hidden="true">&times;</span>
                                </button>
                            </div>
                            <div class="modal-body pe-3"> 
                                <cfset local.lang=objBookMyShow.fetchEventLanguages()>
                                <cfset local.genre=objBookMyShow.fetchGenre()>
                                <cfset local.dimension=objBookMyShow.fetchDimensions()>
                                <cfset local.cert=objBookMyShow.fetchCertificate()>                               
                                <div class="d-flex  px-4 justify-content-between">
                                    <label for="addMovieName">Name</label>
                                    <div class="">
                                        <input type="text"id="addMovieName" name="addMovieName">
                                    </div>
                                </div> 
                                <div class="d-flex  px-4 justify-content-between">
                                    <label for="addReleaseDate">Release Date</label>
                                    <div class="">
                                        <input type="date" id="addReleaseDate" name="addReleaseDate">
                                    </div>
                                </div>
                                <div class="d-flex px-4 justify-content-between">

                                    <label for="addduration">Duration</label>
                                    <div class="">
                                        <input type="time" id="addduration" name="addduration" onchange="convertTime()">
                                        <input type="hidden" name="moviedDuration" id="moviedDuration">
                                    </div>
                                </div>
                                <div class="mt-2 px-4 justify-content-between">
                                    <label for="addProfileImage">Profile Image</label>
                                    <div class="">
                                    <input type="file" name="profileImage" id="addProfileImage"  accept="image/jpeg, image/png"required>
                                    </div>
                                </div>
                                <div class="mt-2 px-4 justify-content-between">
                                    <label for="addCoverImage">Cover Image</label>
                                    <div class="">
                                    <input type="file" name="coverImage" id="addCoverImage" accept="image/jpeg, image/png" required>
                                    </div>
                                </div>
                                <div class="mt-2 d-flex px-4 justify-content-between">
                                    <label for="addAbout">About</label>
                                    <div class=" ms-5 p-17">
                                        <textarea id="addAbout" name="addAbout" rows="3" cols="21" ></textarea>
                                    </div>
                                </div>
                                <div class="ps-4">
                                    Select Language
                                  <input type="hidden" id="selectedLanguages" name="selectedLanguages">
                                </div>
                                <div class="d-flex ps-4">
                                    <cfloop query="local.lang">
                                        <div class=class="d-flex align-items-baseline mt-2">
                                            <input type="checkbox" name="language" value="#local.lang.lang_id#" id="lang_#local.lang.lang_id#" class="ms-2">
                                            <label for="lang_#local.lang.lang_id#">#local.lang.language#</label> 
                                        </div>                                        
                                    </cfloop>  
                                </div>    
                                <div class="ps-4">
                                    Select Genre
                                    <input type="hidden" id="Genre" name="genre">
                                </div>
                                <div class="d-flex ps-4">
                                    <cfloop query="local.genre">
                                        <div class=class="d-flex align-items-baseline mt-2">
                                            <input type="checkbox" name="genres" value="#local.genre.genre_id#" id="lang_#local.genre.genre_id#" class="ms-2">
                                            <label for="lang_#local.genre.genre_id#">#local.genre.genre_type#</label> 
                                        </div>                                       
                                    </cfloop>  
                                </div> 
                                <div class="mt-2 d-flex px-4 justify-content-between">
                                    <label for="addCertificate">Certificate</label>
                                    <div class="p-15">
                                        <select class="ms-3 " id="addCertificate" name="addCertificate"> 
                                            <option value="" selected></option>
                                            <cfloop query="local.cert">
                                                <option  value="#local.cert.cert_id#">#local.cert.cert_type#</option>
                                            </cfloop> 
                                        </select>
                                    </div>
                                </div>
                                <div class="mt-2 d-flex px-4 justify-content-between">
                                    <label for="addDimension">Dimension</label>
                                    <div class=" ms-5">
                                        <select class="ms-3" id="addDimension" name="addDimension"> 
                                            <option value="" selected></option>
                                            <cfloop query="local.dimension">
                                                <option value="#local.dimension.dimension_id#">#local.dimension.dimension#</option>
                                            </cfloop>                                
                                        </select>
                                    </div>
                                </div>
                                <div class="d-flex  px-4 justify-content-between">
                                    <label for="addRating">Rating</label>
                                    <div class="">
                                        <input type="text" id="addRating"  name="addRating" oninput="validateRating(this)">
                                    </div>
                                </div>
                                <div class="d-flex px-4 justify-content-between">
                                    Select Theater
                                    <input type="hidden" id="selectedTheater" name="selectedTheater"> 
                                    <div class="w-50">
                                        <select name="theaters" onchange="updateSelectedTheater(this)" id="theaters" multiple >
                                            <cfloop query="local.theater">
                                                <option value="#local.theater.id#">#local.theater.name#</option> 
                                            </cfloop>                                       
                                        </select>                                    
                                    </div>
                                </div>  
                            </div>
                            <div class="modal-footer">
                            <button type="button" id="closeBtn" class="btn btn-secondary" data-dismiss="modal" onclick="reloadPage()">Close</button>
                            <button type="submit"  name="saveMovieDetails" class="btn btn-primary"  onclick="getAllSelectedtheater()">Save</button>
                            </div>
                        </div>
                    </div>
                </form>                  
                <cfif  structKeyExists(form,"saveMovieDetails") >                           
                    <cfinvoke component="components/bookMyShow" method="insertMovie" fileupload1="form.profileImage" fileupload2="form.coverImage">
                       <cfinvokeargument name="name" value="#form.addMovieName#">
                       <cfinvokeargument name="releaseDate" value="#form.addReleaseDate#">
                       <cfinvokeargument name="duration" value="#form.moviedDuration#">
                       <cfinvokeargument name="about" value="#form.addAbout#">  
                       <cfinvokeargument name="rating" value="#form.addRating#">
                       <cfinvokeargument name="certificate" value="#form.addCertificate#">
                       <cfinvokeargument name="dimension" value="#form.addDimension#">
                        <cfif structKeyExists(form,"selectedLanguages")>                        
                            <cfinvokeargument name="language" value="#form.selectedLanguages#">
                        </cfif>
                        <cfif structKeyExists(form,"genre")>                        
                            <cfinvokeargument name="genre" value="#form.genre#">
                        </cfif>
                        <cfif structKeyExists(form,"selectedTheater")>                        
                            <cfinvokeargument name="theater" value="#form.selectedTheater#">
                        </cfif>                                         
                    </cfinvoke>
                </cfif>
            </div>
        </cfoutput>        
        <script src="script/jquery-3.6.4.js"></script>
        <script src="script/popper.js"></script>
        <script src="script/bootstrap.min.js"></script>
        <script src="https://cdn.jsdelivr.net/gh/habibmhamadi/multi-select-tag@2.0.1/dist/js/multi-select-tag.js"></script>
        <script src="script/filmCrud.js"></script>   

    </body>
</html>
