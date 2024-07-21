<!DOCTYPE html>
<html lang="en">
  <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Event</title>
      <link rel="stylesheet" href="style/bootstrap.min.css">
      <link rel="stylesheet" href="style/eventCrud.css">    
  </head>
  <body>
    <cfinclude  template="header.cfm">
    <cfobject component="components/bookMyShow" name="objBookMyShow">
    <cfset local.event=objBookMyShow.fetchEventDetails()>
    
    <cfoutput>          
        <div class="px-5 pt-5 ">
            <div class="d-flex justify-content-between">
                <h2>Event Details</h2>
                <button type="button" class="addEventBtn mt-1" id="addEventBtn" data-toggle="modal" data-target=".eventAddModal">Add Event</button>
            </div>
            <center>
                <table class="mt-5 table">
                    <tr>
                        <th class="d-none">Id</th>
                        <th>Name</th>
                        <th>Category</th>
                        <th>Location</th>
                        <th>Venue</th>
                        <th>View</th>                    
                        <th>Edit</th>
                        <th>Delete</th>
                    </tr>        
                    <cfloop query="local.event">
                        <tr>
                            <td class="d-none">#local.event.event_id#</td>
                            <td>#local.event.name#</td>
                            <td>#local.event.category#</td>
                            <td>#local.event.location#</td>
                            <td>#local.event.venue#</td>
                            <td><button type="button" class="view border-0 bg-white btn btn-primary" data-eventid="#local.event.event_id#" data-toggle="modal" data-target=".eventModal"><img src="assests/file.png" height="15px" width="15px" alt="view"></button></td>
                            <td><button type="button" class="edit border-0 bg-white btn btn-primary" data-eventid="#local.event.event_id#" data-toggle="modal" data-target=".eventModal"><img src="assests/pen.png" height="15px" width="15px" alt="Edit"></button></td>                                
                            <td><button type="button" class="deleteEventBtn border-0 bg-white mt-1"  data-eventid="#local.event.event_id#"><img src="assests/trash.png" height="15px" width="15px" alt="Delete"></button></td>
                        </tr>
                    </cfloop>
                </table>
            </center>             
        </div>            
    </cfoutput>            
    <!-- Button trigger modal -->  
    <!-- View Modal -->
    <div class="modal fade eventModal" id="eventModal" data-backdrop="static"  tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
      <div class="modal-dialog" role="document">
        <div class="modal-content w-100">
          <div class="modal-header">
            <h5 class="modal-title" id="exampleModalLabel">Event Details</h5>
            <button type="button" class="close border-0 bg-white" data-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
          <div class="modal-body d-flex">
            <div class="w-25"><img id="profileImg" alt="img" height=100% width="100%"></div>
            <div>
              <div class="d-flex">
                <label  class="d-none" for="id">Event Id</label>
                <input type="hidden" id="id" required>
              </div>
              <div class="d-flex justify-content-between ps-4">
                <label for="eventName">Event name</label>
                <div>
                  <input type="text"id="eventName" required>
                </div>
              </div>
              <div class="mt-2 d-flex justify-content-between ps-4">
                <label for="date">Date</label>
                <div>
                  <input type="text"  id="date" required>
                </div>
              </div>
              <div class="mt-2 d-flex justify-content-between ps-4">
                <label for="duration">Duration</label>
                <div>
                  <input type="text"  id="duration" required>
                </div>
              </div>         
              <div class="mt-2 d-flex px-4">
                <label for="location">Location</label>
                <div class=" ms-4 ">
                  <select id="location"  required></select>
                </div>
              </div>
              <div class="mt-2 d-flex justify-content-between ps-4">
                <label for="venue">Venue</label>
                <div>
                  <input type="text" id="venue" required>
                </div>
              </div>
              <div class="mt-2 d-flex justify-content-between ps-4">
                <label for="rate">Rate</label>
                <div>
                  <input type="text"   id="rate" required>
                </div>
              </div>
            </div>          
          </div>
          <div class="modal-footer">
            <button type="button" id="closeBtn" class="btn btn-secondary" data-dismiss="modal">Close</button>
            <button type="button" id="saveBtn" class="btn btn-primary">Save changes</button>
          </div>
        </div>
      </div>
    </div>
    <!---Add Modal--->
    <div class="modal fade eventAddModal" id="eventAddModal" data-backdrop="static"  tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="exampleModalLabel">Add Event Details</h5>
            <button type="button" class="close border-0 bg-white" onclick="reloadPage()" data-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
          <div class="modal-body">
            <cfoutput>
              <form action="##" class="" enctype="multipart/form-data"  method="post" > 
                <div class="d-flex justify-content-between px-5">
                  <label for="addEventName">Event name</label>
                  <div>
                    <input type="text" name="name" id="addEventName" required>
                  </div>
                </div>
                <div class="mt-2 d-flex  px-5">
                  <label for="addDate">Date</label>
                  <div class="ms-5 ps-16">
                    <input class="ms-1" type="date" name="date" id="addDate" required>
                  </div>
                </div>
                <div class="mt-2 d-flex justify-content-between px-5">
                  <label for="addDuration">Duration</label>
                  <div class="">
                    <input type="text" name="duration" id="addDuration" required>
                  </div>
                </div>    
                <cfset local.lang=objBookMyShow.fetchEventLanguages()>
                <div class="mt-2 d-flex px-5">
                  <label for="addLang">Language</label>
                  <div class=" ms-3 ps-16">
                    <select id="addLang"  name="lang" required>   
                      <cfloop query="local.lang">
                        <option value="#local.lang.lang_id#">#local.lang.language#</option> 
                      </cfloop>
                    </select>
                  </div>
                </div>
                <cfset local.cat=objBookMyShow.fetchEventCategory()>
                <div class="mt-2 d-flex px-5">
                  <label for="addCateogry">Cateogry</label>
                  <div class=" ms-4 ps-16">
                    <select id="addCateogry" name="category" required>  
                      <cfloop query="local.cat">
                        <option value="#local.cat.category_id#">#local.cat.category#</option> 
                      </cfloop>              
                    </select>
                  </div>
                </div>            
                <div class="mt-2 d-flex px-5">
                  <label for="addLocation">Location</label>
                  <div class=" ms-4 ps-16">
                    <select id="addLocation" name="location" required onchange="showVenue()">                    
                    </select>
                  </div>
                </div>
                <div class="mt-2 d-flex  px-5">
                  <label for="addVenue">Venue</label>
                  <div class="ms-5  ps-5">
                    <select id="addVenue"  name="venue" required>                  
                    </select>
                  </div>
                </div>
                <div class="mt-2 d-flex justify-content-between px-5">
                  <label for="addRate">Rate(in Rs)</label>
                  <div>
                    <input type="text" name="rate" id="addRate" required>
                  </div>
                </div>
                <div class="mt-2 ps-5">
                  <label for="addProfileImage">Profile Image</label>
                  <div>
                    <input type="file" name="profileImage" id="addProfileImage"  accept="image/jpeg, image/png"required>
                  </div>
                </div>
                <div class="mt-2 ps-5">
                  <label for="addCoverImage">Cover Image</label>
                  <div>
                    <input type="file" name="coverImage" id="addCoverImage" accept="image/jpeg, image/png" required>
                  </div>
                </div>
                <div class="mt-3">
                  <center>
                    <button type="button" id="closeBtn" onclick="reloadPage()" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    <button  type="submit"  name="saveEventDetails"  id="saveEventDetails" class="btn btn-primary">Save</button>
                  </center>
                </div>            
              </form> 
            </cfoutput>             
            <cfif  structKeyExists(form,"saveEventDetails")> 
              <cfinvoke component="components/bookMyShow" method="saveEvent" fileupload1="form.profileImage" fileupload2="form.coverImage">
                <cfinvokeargument name="name" value="#form.name#">
                <cfinvokeargument name="date" value="#form.date#">
                <cfinvokeargument name="duration" value="#form.duration#">
                <cfinvokeargument name="lang" value="#form.lang#">  
                <cfinvokeargument name="category" value="#form.category#">
                <cfinvokeargument name="location" value="#form.location#">
                <cfinvokeargument name="venue" value="#form.venue#"> 
                <cfinvokeargument name="rate" value="#form.rate#">              
              </cfinvoke>
          </cfif>
          </div>        
        </div>
      </div>
    </div>  
    <script src="script/jquery-3.6.4.js"></script>
    <script src="script/popper.js"></script>
    <script src="script/bootstrap.min.js"></script>
    <script src="script/eventCrud.js"></script>

  </body>
</html>