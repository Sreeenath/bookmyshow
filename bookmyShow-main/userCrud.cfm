<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Chosen Multi-Select Example</title>
  <link rel="stylesheet" href="style/userCrud.css">  
</head>
  <body>
    <cfinclude  template="header.cfm">   
   <cfset userDetails=entityLoad("user")/> 
   <div class="d-flex justify-content-between px-4 mt-4">
    <h2>User  Details</h2>
    <button type="button" class="addTheaterBtn mt-1 px-1" id="addTheaterBtn" data-toggle="modal" data-target=".">Add User</button>
</div>
   <center>
    <table class="mt-4 table">
        <tr>
            <th class="d-none">Id</th>
            <th>Name</th>
            <th>Mail</th>
            <th>Phone</th>
            <th>View</th>
            <th>Edit</th>
            <th>Delete</th>
        </tr>  
        <cfloop array="#userDetails#" index="user">
          <cfoutput>
              <tr>
                <td>#user.getName()#</td>
                  <td>#user.getMail()#</td>
                  <td>#user.getPhone()#</td>
                  <td><button type="button" class="border-0 bg-white btn btn-primary" data-userId="#user.getUser_id()#" data-toggle="modal" data-target=""><img src="assests/file.png" height="15px" width="15px" alt="view"></button></td>
                  <td><button type="button" class="border-0 bg-white btn btn-primary" data-userId="#user.getUser_id()#" data-toggle="modal" data-target=""><img src="assests/pen.png" height="15px" width="15px" alt="Edit"></button></td>                                
                  <td><button type="button" class="border-0 bg-white mt-1"  data-userId="#user.getUser_id()#" data-toggle="modal" data-target=""><img src="assests/trash.png" height="15px" width="15px" alt="Delete"></button></td>
              </tr>
              <tr>  
          </cfoutput>
        </cfloop>        
      </table>
    </center>
  </body>
</html>
