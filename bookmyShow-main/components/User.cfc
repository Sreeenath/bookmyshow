<!--- User.cfc --->
<cfcomponent persistent="true"  entityname="user" table="tb_user"> 
    <cfproperty name="user_id"  fieldtype="id" generator="native" type="numeric">     
    <cfproperty name="name"> 
    <cfproperty name="mail"> 
    <cfproperty name="phone" >
    <cfproperty name="role_id" type="numeric"> 
</cfcomponent>
