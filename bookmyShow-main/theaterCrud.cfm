<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Theater</title>
    <link rel="stylesheet" href="style/bootstrap.min.css">
    <link rel="stylesheet" href="style/theaterCrud.css">    
</head>
    <body>
        <cfinclude  template="header.cfm">
        <cfobject component="components/bookMyShow" name="objBookMyShow">
        <cfset local.theater=objBookMyShow.fetchTheaterDetails()>
        <cfoutput>          
            <div class="px-5 pt-5 ">
                <div class="d-flex justify-content-between">
                    <h2>Theater Details</h2>
                    <button type="button" class="addTheaterBtn mt-1 px-1" id="addTheaterBtn" data-toggle="modal" data-target=".eventTheaterModal">Add Theater</button>
                </div>
                <center>
                    <table class="mt-5 table">
                        <tr>
                            <th class="d-none">Id</th>
                            <th>Name</th>
                            <th>Address</th>
                            <th>Location</th>
                            <th>Ph No</th>
                            <th>View</th>
                            <th>Edit</th>
                            <th>Delete</th>
                        </tr>        
                        <cfloop query="local.theater">
                            <tr>
                                <td  class="d-none">#local.theater.id#</td>
                                <cfif local.theater.status == 0>
                                    <td class="text-danger">#local.theater.name#</td>
                                <cfelse>
                                    <td>#local.theater.name#</td>
                                </cfif>                                
                                <td>#local.theater.address#</td>
                                <td>#local.theater.location#</td>
                                <td>#local.theater.phno#</td>
                                <td><button type="button" class="view border-0 bg-white btn btn-primary" data-theaterid="#local.theater.id#" data-toggle="modal" data-target=".theaterModal"><img src="assests/file.png" height="15px" width="15px" alt="view"></button></td>
                                <td><button type="button" class="edit border-0 bg-white btn btn-primary" data-theaterid="#local.theater.id#" data-toggle="modal" data-target=".theaterModal"><img src="assests/pen.png" height="15px" width="15px" alt="Edit"></button></td>                                
                                <td><button type="button" class="deleteTheaterBtn border-0 bg-white mt-1"  data-theaterid="#local.theater.id#" data-toggle="modal" data-target=".deleteConfirmModal"><img src="assests/trash.png" height="15px" width="15px" alt="Delete"></button></td>
                            </tr>
                        </cfloop>
                    </table>
                </center>             
            </div>            
        </cfoutput>   
        <!-- View Modal -->
        <div class="modal fade theaterModal" id="theaterModal" data-backdrop="static"  tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
            <div class="modal-content ">
                <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel">Theater Details</h5>
                <button type="button" class="close border-0 bg-white" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                </div>
                <div class="modal-body pe-5">                                
                    <div class="d-flex justify-content-between ps-4">
                        <label for="theaterName">Name</label>
                        <div class="">
                            <input type="text"id="theaterName" required>
                        </div>
                    </div>                    
                    <div class="mt-2 d-flex justify-content-between ps-4">
                    <label for="address">Address</label>
                        <div class="">
                            <textarea id="address" name="address" rows="4" cols="21"></textarea>
                        </div>
                    </div>                
                    <div class="mt-2 d-flex px-4">
                        <label for="location">Location</label>
                        <div class=" ms-5 p-20">
                            <select id="location"  required></select>
                        </div>
                    </div>
                    <div class="mt-2 d-flex justify-content-between ps-4">
                        <label for="phno">Ph no</label>
                        <div class="">
                            <input type="text" id="phno" required>
                        </div>
                    </div>
                    <div class="mt-2 d-flex px-4">
                        <label for="status">Status</label>
                        <div class=" ms-5 p-20">
                            <select class="ms-3" id="status"  required>                                
                            </select>
                        </div>
                    </div>
                    <div id="theaterTime">
                        <div class="mt-2 d-flex justify-content-between ps-4" >
                            <label for="time">Theater Time</label>
                            <div class="">
                                <textarea id="time" rows="4" cols="22"></textarea>
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
        <div class="modal fade eventTheaterModal" id="eventTheaterModal" data-backdrop="static"  tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalLabel">Add Theater Details</h5>
                        <button type="button" onclick="reloadPage()" class="close border-0 bg-white" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <form action="" class="" enctype="multipart/form-data"  method="post" > 
                            <div class="d-flex justify-content-between ps-4">
                                <label for="addTheaterName">Name</label>
                                <div class="">
                                    <input type="text" id="addTheaterName"  name="theaterName" >
                                </div>
                            </div>                    
                            <div class="mt-2 d-flex justify-content-between ps-4">
                            <label for="address">Address</label>
                                <div class="">
                                    <textarea id="addAddress" rows="4" cols="21" ></textarea>
                                </div>
                            </div>                
                            <div class="mt-2 d-flex px-4">
                                <label for="location">Location</label>
                                <div class=" ms-5 p-20">
                                    <select id="addLocation" class="ms-4"  >
                                        <option value="Thiruvananthapuram" selected>Thiruvananthapuram</option>
                                        <option value="Kollam">Kollam</option>
                                        <option value="Pathanamthitta">Pathanamthitta</option>
                                        <option value="Alappuzha">Alappuzha</option>
                                        <option value="Kottayam">Kottayam</option>
                                        <option value="Idukki">Idukki</option>
                                        <option value="Ernakulam">Ernakulam</option>
                                        <option value="Thrissur">Thrissur</option>
                                        <option value="Palakkad">Palakkad</option>
                                        <option value="Malappuram">Malappuram</option>
                                        <option value="Kozhikode">Kozhikode</option>
                                        <option value="Wayanad">Wayanad</option>
                                        <option value="Kannur">Kannur</option>
                                        <option value="Kasaragod">Kasaragod</option>
                                    </select>
                                </div>
                            </div>
                            <div class="mt-2 d-flex justify-content-between ps-4">
                                <label for="phno">Ph no</label>
                                <div class="">
                                    <input type="text" id="addPhno"  >
                                </div>
                            </div>
                            <div class="mt-2 d-flex px-4">
                                <label for="status" class="p-10">Status</label>
                                <div class=" ms-5 p-20 ">
                                    <select class="" id="addStatus" > 
                                        <option value="1" selected>Active</option>                                                                
                                    </select>
                                </div>
                            </div>
                            <div class="mt-2 d-flex  ps-4">
                                <label for="time">Theater Time</label>
                                <div id="timeContainer" class="ms-3">
                                    <!-- Initial time input field -->
                                     <button class="btn btn-success" onclick="addTime()">Add Time</button>
                                    <div class="time-container mt-2">
                                      <input type="time" name="time" class="timeInput"  onchange="updateFormattedTimes()" > 
                                    </div>
                                </div>
                            </div>    
                            <input type="hidden" id="formattedTimes" name="time" readonly>
                            <div class="mt-3">
                                <center>
                                    <button type="button"  onclick="reloadPage()" id="closeBtn" class="btn btn-secondary" data-dismiss="modal">Close</button>
                                    <button  type="submit"  name="saveTheaterDetails"  id="saveTheaterDetails" class="btn btn-primary">Save</button>
                                </center>
                            </div>            
                        </form>
                    </div>        
                </div>
            </div>
        </div>   
        <!---Delete Confirm Modal--->
        <div class="modal fade deleteConfirmModal" id="deleteConfirmModal" data-backdrop="static"  tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content ">
                    <div class="modal-header">
                        <button type="button" class="close border-0 bg-white" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body pe-5">                                
                        <h4 >Are you Sure? </h4>  
                    </div>
                    <div class="modal-footer">
                        <button type="button" id="closeBtn" class="btn btn-secondary" data-dismiss="modal">No</button>
                        <button type="button" id="deleteYes" class="btn btn-primary">Yes</button>
                    </div>
                </div>
            </div>
        </div>
        <script src="script/jquery-3.6.4.js"></script>
        <script src="script/popper.js"></script>
        <script src="script/bootstrap.min.js"></script>
        <script src="script/theaterCrud.js"></script>
    </body>
</html>