<cfcomponent>
    <cfset this.name ="Book My Show">
    <cfset this.applicationTimeout = createTimeSpan( 0, 0, 10,0 )>
    <cfset this.sessionManagement = true>
    <cfset this.sessionTimeout = CreateTimeSpan(0 ,0,5,0)>    
    <cfset this.ormsettings={}/>
    <cfset this.ormsettings.cfclocation="components"/>
    <cfset this.ormsettings.dbcreate="update"/>
    <cfset this.ormsettings.logsql="true"/>
    <cfset this.ormenabled=true/>
    <cfset this.datasource ="mydb">    
    
    <cffunction name="onSessionStart" returnType="boolean">        
        <cfset session.userId=0>
        <cfset session.userName="">
        <cfreturn true>
    </cffunction>

    <cffunction name="onApplicationStart" returnType="boolean">
        <cfset application.key ="gGi5XR2UKAgTi3ge6V2ONw==">
        <cfreturn true>
    </cffunction>

    <cffunction name="onRequestStart" access="public" returntype="boolean">
        <cfargument name="targetPage" type="string" required="false">        
        <!--- Check if it's an AJAX request --->
        <cfif NOT IsAjaxRequest()>
            <cfif (!StructKeyExists(session, "userId") || session.userId EQ 0) && arguments.targetPage NEQ '/BookmyShow/body.cfm'>
                <cflocation url="body.cfm">
            </cfif>
        </cfif>        
        <cfreturn true>
    </cffunction>

    <cffunction name="IsAjaxRequest" access="public" returntype="boolean">
        <cfreturn StructKeyExists(getHttpRequestData().headers, "x-requested-with") 
        AND getHttpRequestData().headers["x-requested-with"] EQ "XMLHttpRequest">
    </cffunction>
    
</cfcomponent>


