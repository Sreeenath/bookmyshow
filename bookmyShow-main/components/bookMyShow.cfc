<cfcomponent>    
    <cffunction name="signInWithGoogle" access="remote">
		<cfset clientID ="1076698100399-au2dd41l4tuklhipi3p52r5bodsr6pec.apps.googleusercontent.com">
		<cfset clientSecret ="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">
		<cfset redirectURI ="http://127.0.0.1:8500/bookmyShow/body.cfm">
		<cfset authURL ="https://accounts.google.com/o/oauth2/auth">
		<cfset responseType ="code">		
		<cfset scope ="https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile">
		<cfset local.url="#authURL#?client_id=#clientID#&redirect_uri=#redirectURI#&scope=#scope#&response_type=#responseType#">
		<cfset session.clientID=clientID>
        <cfset session.clientSecret=clientSecret>
        <cfset session.redirectURI=redirectURI>
        <cfreturn local.url>
	</cffunction>

    <cffunction name="getGoogleUserInfo" access="remote">
        <cfargument name="code" required="true">    
        <cfhttp url="https://accounts.google.com/o/oauth2/token" method="post">
            <cfhttpparam type="url" name="code" value="#code#">
            <cfhttpparam type="url" name="client_id" value="#session.clientID#">
            <cfhttpparam type="url" name="client_secret" value="#session.clientSecret#">
            <cfhttpparam type="url" name="redirect_uri" value="#session.redirectURI#">
            <cfhttpparam type="url" name="grant_type" value="authorization_code">
            <cfhttpparam type="url" name="scope" value="https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/user.phonenumbers.read">
        </cfhttp>

        <cfset accessToken = deserializeJSON(cfhttp.filecontent).access_token>    
               
        <cfhttp url="https://www.googleapis.com/oauth2/v2/userinfo" method="get">
            <cfhttpparam type="url" name="access_token" value="#accessToken#">
        </cfhttp>
           
        <cfset local.userInfo = deserializeJSON(cfhttp.filecontent)>  
       
        <cfset local.name = local.userInfo.given_name>
        <cfset local.email = local.userInfo.email>
        <cfset local.roleId=2>  

        <cfquery name="qryUserExists">
            SELECT user_id
            FROM
            tb_user
            WHERE
            mail = <cfqueryparam value="#local.email#" cfsqltype="CF_SQL_VARCHAR">           
        </cfquery> 

        <cfif  qryUserExists.recordCount>            
            <cfset session.userName=local.name>
            <cfset session.userId=qryUserExists.user_id[1]>
            <cflocation  url="body.cfm">
        <cfelse>
            <cfquery name="qryInsertUser" result="insertResult">
                INSERT
                INTO tb_user
                (name,mail,role_id)
                VALUES
                (
                    <cfqueryparam value="#local.name#" cfsqltype="CF_SQL_VARCHAR">,
                    <cfqueryparam value="#local.email#" cfsqltype="CF_SQL_VARCHAR">,               
                    <cfqueryparam value="#local.roleId#" cfsqltype="CF_SQL_INTEGER">        
                        
                )                        
            </cfquery>
            <cfset session.userId=#insertResult.GENERATEDKEY#>
            <cfset session.userName=local.name>
            <cflocation  url="body.cfm">
        </cfif>
       
    </cffunction>

    <cffunction name="fetchDetails" access="remote" returntype="any">
        <cfargument name="phone" type="string" required="true">
        <cfset local.result = {}>
            <cfquery name="qryfetchDetails">
                SELECT name,user_id,role_id,mail,phone
                FROM
                tb_user
                WHERE
                phone = <cfqueryparam value="#arguments.phone#" cfsqltype="CF_SQL_VARCHAR">
            </cfquery>
                <cfif qryfetchDetails.recordCount>
                    <!-- Access the role_id from the first row of the query result -->
                    <cfset session.userId=qryfetchDetails.user_id[1]>
                    <cfset session.userName= qryfetchDetails.name[1]>
                    <cfset local.roleId = qryfetchDetails.role_id[1]> 
                    <cfset local.result.name = qryfetchDetails.name[1]>
                    <cfset local.result.mail = qryfetchDetails.mail[1]>
                    <cfset local.result.phone = qryfetchDetails.phone[1]>
                    <cfquery name="qryFetchRole">
                        SELECT  role
                        FROM
                        tb_role
                        WHERE
                        role_id = <cfqueryparam value="#local.roleId#" cfsqltype="CF_SQL_INTEGER">
                    </cfquery>  
                    <cfif qryFetchRole.recordCount>
                        <cfset local.result.role = qryFetchRole.role[1]> 
                    </cfif> 
                </cfif>                          
        <cfreturn local.result>
    </cffunction>

    <cffunction name="insertUser" access="remote" returnformat="json">
        <cfargument name="name" type="string" required="true">
        <cfargument name="mail" type="string" required="true">
        <cfargument name="phone" type="string" required="true">
        <cfset local.roleId=2>      
        <cfquery name="qryUserExists">
            SELECT  role_id
            FROM
            tb_user
            WHERE
            phone = <cfqueryparam value="#arguments.phone#" cfsqltype="CF_SQL_VARCHAR">
            AND
            mail = <cfqueryparam value="#arguments.mail#" cfsqltype="CF_SQL_VARCHAR">
        </cfquery> 
        <cfif qryUserExists.recordCount>
            <cfreturn SerializeJSON({ "success": true })> 
            <cfelse>
                <cfquery name="qryInsertUser">
                    INSERT
                    INTO tb_user
                    (name,mail,phone,role_id)
                    VALUES
                    (
                        <cfqueryparam value="#arguments.name#" cfsqltype="CF_SQL_VARCHAR">,
                        <cfqueryparam value="#arguments.mail#" cfsqltype="CF_SQL_VARCHAR">,
                        <cfqueryparam value="#arguments.phone#" cfsqltype="CF_SQL_VARCHAR">,               
                        <cfqueryparam value="#local.roleId#" cfsqltype="CF_SQL_INTEGER">        
                            
                    )                        
                </cfquery>
                 <cfreturn SerializeJSON({ "success": false })> 
        </cfif>        
    </cffunction>

    <cffunction  name="logout" access="remote">
        <cfset StructClear(Session)>
    </cffunction>

    <cffunction  name="fetchAllMovieDetails" access="public" returntype="query" maxrows="5">  
        <cfquery name="qryFetchAllMovieDetails">
            SELECT
                tb_movie.movie_id as movieId,
                name,
                release_date,
                duration,
                profile_img,
                cover_img,
                about,
                status,
                
                STUFF((
                    SELECT '/' + genre_type
                    FROM tb_movie_genre
                    INNER JOIN tb_genre ON tb_genre.genre_id = tb_movie_genre.genre_id
                    WHERE tb_movie_genre.movie_id = tb_movie.movie_id
                    FOR XML PATH('')), 1, 1, '') AS genre,
                STUFF((
                    SELECT '/' + language
                    FROM tb_movie_language
                    INNER JOIN tb_language ON tb_language.lang_id = tb_movie_language.lang_id
                    WHERE tb_movie_language.movie_id = tb_movie.movie_id
                    FOR XML PATH('')), 1, 1, '') AS language,
                dimension,
                rating,
                cert_type
            FROM tb_movie
            INNER JOIN tb_movie_dimension ON tb_movie.movie_id = tb_movie_dimension.movie_id
            INNER JOIN tb_dimension ON tb_dimension.dimension_id = tb_movie_dimension.dimension_id
            INNER JOIN tb_movie_rating ON tb_movie.movie_id = tb_movie_rating.movie_id
            INNER JOIN tb_movie_cert ON tb_movie.movie_id = tb_movie_cert.movie_id
            INNER JOIN tb_certificate ON tb_movie_cert.cert_id = tb_certificate.cert_id
            WHERE status !=0
            GROUP BY tb_movie.movie_id, name, release_date, status,duration, profile_img, cover_img, about, dimension, rating, cert_type
            ORDER BY tb_movie.movie_id DESC
        </cfquery>
        <cfreturn qryFetchAllMovieDetails>
    </cffunction>

    <cffunction  name="fetchMovieDetails" access="public" returntype="query"> 
        <cfquery name="qryFetchMovieDetails">
            SELECT 
                tb_movie.movie_id as movieId,
                name,
                release_date,status,
                duration,
                profile_img,
                cover_img,
                about,
                STUFF((
                    SELECT '/' + genre_type
                    FROM tb_movie_genre
                    INNER JOIN tb_genre ON tb_genre.genre_id = tb_movie_genre.genre_id
                    WHERE tb_movie_genre.movie_id = tb_movie.movie_id
                    FOR XML PATH('')), 1, 1, '') AS genre,
                STUFF((
                    SELECT '/' + language
                    FROM tb_movie_language
                    INNER JOIN tb_language ON tb_language.lang_id = tb_movie_language.lang_id
                    WHERE tb_movie_language.movie_id = tb_movie.movie_id
                    FOR XML PATH('')), 1, 1, '') AS language,
                dimension,
                rating,
                cert_type
            FROM tb_movie
            INNER JOIN tb_movie_dimension ON tb_movie.movie_id = tb_movie_dimension.movie_id
            INNER JOIN tb_dimension ON tb_dimension.dimension_id = tb_movie_dimension.dimension_id
            INNER JOIN tb_movie_rating ON tb_movie.movie_id = tb_movie_rating.movie_id
            INNER JOIN tb_movie_cert ON tb_movie.movie_id = tb_movie_cert.movie_id
            INNER JOIN tb_certificate ON tb_movie_cert.cert_id = tb_certificate.cert_id
            GROUP BY tb_movie.movie_id, name, release_date,status, duration, profile_img, cover_img, about, dimension, rating, cert_type
            ORDER BY tb_movie.movie_id DESC
        </cfquery>
        <cfreturn qryFetchMovieDetails>
    </cffunction>

    <cffunction  name="fetchMovieDetailsBasedOnId" access="public" returntype="query">
        <cfargument  name="movieId" >
        <cfquery name="qryFetchMovieDetailsBasedOnId">
            SELECT 
                tb_movie.movie_id as movieId,
                name,
                release_date,
                duration,
                profile_img,
                cover_img,
                about,
                status,
                STUFF((
                    SELECT '/' + genre_type
                    FROM tb_movie_genre
                    INNER JOIN tb_genre ON tb_genre.genre_id = tb_movie_genre.genre_id
                    WHERE tb_movie_genre.movie_id = tb_movie.movie_id
                    FOR XML PATH('')), 1, 1, '') AS genre,
                STUFF((
                    SELECT '/' + language
                    FROM tb_movie_language
                    INNER JOIN tb_language ON tb_language.lang_id = tb_movie_language.lang_id
                    WHERE tb_movie_language.movie_id = tb_movie.movie_id
                    FOR XML PATH('')), 1, 1, '') AS language,
                dimension,
                rating,
                cert_type
            FROM tb_movie
            INNER JOIN tb_movie_dimension ON tb_movie.movie_id = tb_movie_dimension.movie_id
            INNER JOIN tb_dimension ON tb_dimension.dimension_id = tb_movie_dimension.dimension_id
            INNER JOIN tb_movie_rating ON tb_movie.movie_id = tb_movie_rating.movie_id
            INNER JOIN tb_movie_cert ON tb_movie.movie_id = tb_movie_cert.movie_id
            INNER JOIN tb_certificate ON tb_movie_cert.cert_id = tb_certificate.cert_id
			WHERE tb_movie.movie_id = <cfqueryparam value="#arguments.movieId#" cfsqltype="CF_SQL_INTEGER">
            GROUP BY tb_movie.movie_id, name, release_date,status, duration, profile_img, cover_img, about, dimension, rating, cert_type
          
        </cfquery>
        <cfreturn qryFetchMovieDetailsBasedOnId>
    </cffunction>


    <cffunction  name="movieDetailsBasedOnId" access="remote" returntype="query">
        <cfargument  name="movieId" >
        <cfquery name="qryFetchMovieDetailsBasedOnId">
            SELECT 
                tb_movie.movie_id as movieId,
                name,
                release_date,
                duration,
                profile_img,
                cover_img,
                about,
                status,
                STUFF((
                    SELECT '/' + genre_type
                    FROM tb_movie_genre
                    INNER JOIN tb_genre ON tb_genre.genre_id = tb_movie_genre.genre_id
                    WHERE tb_movie_genre.movie_id = tb_movie.movie_id
                    FOR XML PATH('')), 1, 1, '') AS genre,
                STUFF((
                    SELECT '/' + language
                    FROM tb_movie_language
                    INNER JOIN tb_language ON tb_language.lang_id = tb_movie_language.lang_id
                    WHERE tb_movie_language.movie_id = tb_movie.movie_id
                    FOR XML PATH('')), 1, 1, '') AS language,
                dimension,
                tb_dimension.dimension_id as dimensionId,
                rating,
                cert_type,
                tb_certificate.cert_id  as certId
            FROM tb_movie
            INNER JOIN tb_movie_dimension ON tb_movie.movie_id = tb_movie_dimension.movie_id
            INNER JOIN tb_dimension ON tb_dimension.dimension_id = tb_movie_dimension.dimension_id
            INNER JOIN tb_movie_rating ON tb_movie.movie_id = tb_movie_rating.movie_id
            INNER JOIN tb_movie_cert ON tb_movie.movie_id = tb_movie_cert.movie_id
            INNER JOIN tb_certificate ON tb_movie_cert.cert_id = tb_certificate.cert_id
			WHERE tb_movie.movie_id = <cfqueryparam value="#arguments.movieId#" cfsqltype="CF_SQL_INTEGER">
            GROUP BY tb_movie.movie_id, name, release_date, tb_dimension.dimension_id,tb_certificate.cert_id ,status,duration, profile_img, cover_img, about, dimension, rating, cert_type
          
        </cfquery>
        <cfreturn qryFetchMovieDetailsBasedOnId>
    </cffunction>


    <cffunction  name="fetchEventDetails" access="public" returntype="query">
        <cfquery name="qryFetchEventDetails"> 
            SELECT tb_event.event_id,name,duration,date,rate,profile_img,cover_img,language,category,location,venue 
            FROM tb_event 
            INNER JOIN tb_language 
            ON tb_event.lang_id = tb_language.lang_id           
            INNER JOIN tb_event_venue
            ON tb_event_venue.event_id = tb_event.event_id
            INNER JOIN tb_venue
            ON tb_event_venue.venue_id = tb_venue.venue_id
			 INNER JOIN tb_category
            ON tb_event.category_id = tb_category.category_id
        </cfquery>        
        <cfreturn qryFetchEventDetails>
    </cffunction>

    <cffunction  name="fetchEventDetailsBasedOnId" access="public" returntype="query">
        <cfargument  name="eventId" >
        <cfquery name="qryFetchEventDetails">
            SELECT tb_event.event_id, name, duration, date, rate,profile_img, cover_img,
                   STUFF((SELECT ', ' + category
                          FROM tb_category
                          WHERE tb_event.category_id = tb_category.category_id
                          FOR XML PATH('')), 1, 2, '') AS categories,
                   STUFF((SELECT ', ' + language
                          FROM tb_language
                          WHERE tb_event.lang_id = tb_language.lang_id
                          FOR XML PATH('')), 1, 2, '') AS languages,
                   location, venue
            FROM tb_event
            INNER JOIN tb_language ON tb_event.lang_id = tb_language.lang_id
            INNER JOIN tb_event_venue ON tb_event_venue.event_id = tb_event.event_id
            INNER JOIN tb_venue ON tb_event_venue.venue_id = tb_venue.venue_id
            INNER JOIN tb_category ON tb_event.category_id = tb_category.category_id
            WHERE tb_event.event_id = <cfqueryparam value="#arguments.eventId#" cfsqltype="CF_SQL_INTEGER">
        </cfquery>
        <cfreturn qryFetchEventDetails>
    </cffunction>    

    <cffunction  name="eventDetailsBasedOnId" access="remote" returntype="query">
        <cfargument  name="eventId" >
        <cfquery name="qryFetchEventDetails">
            SELECT tb_event.event_id, name, duration, date, rate, profile_img, cover_img,
                   STUFF((SELECT ', ' + category
                          FROM tb_category
                          WHERE tb_event.category_id = tb_category.category_id
                          FOR XML PATH('')), 1, 2, '') AS categories,
                   STUFF((SELECT ', ' + language
                          FROM tb_language
                          WHERE tb_event.lang_id = tb_language.lang_id
                          FOR XML PATH('')), 1, 2, '') AS languages,
                   location, venue
            FROM tb_event
            INNER JOIN tb_language ON tb_event.lang_id = tb_language.lang_id
            INNER JOIN tb_event_venue ON tb_event_venue.event_id = tb_event.event_id
            INNER JOIN tb_venue ON tb_event_venue.venue_id = tb_venue.venue_id
            INNER JOIN tb_category ON tb_event.category_id = tb_category.category_id
            WHERE tb_event.event_id = <cfqueryparam value="#arguments.eventId#" cfsqltype="CF_SQL_INTEGER">
        </cfquery>
        <cfreturn qryFetchEventDetails>
    </cffunction> 
    <cffunction  name="fetchEventLanguages" access="public" returntype="query">
        <cfquery name="qryFetchEventLanguages"> 
            SELECT  *
            FROM tb_language 
                     
        </cfquery>
        <cfreturn qryFetchEventLanguages>
    </cffunction>

    <cffunction  name="fetchLanguages" access="remote" returntype="query">
        <cfquery name="qryFetchEventLanguages"> 
            SELECT *
            FROM tb_language          
        </cfquery>
        <cfreturn qryFetchEventLanguages>
    </cffunction>

    <cffunction  name="fetchGenre" access="public" returntype="query">
        <cfquery name="qryFetchGenre"> 
            SELECT *
            FROM  tb_genre                
        </cfquery>
        <cfreturn qryFetchGenre>
    </cffunction>
    

    <cffunction  name="fetchEventCategory" access="public" returntype="query">
        <cfquery name="qryFetchEventCategory"> 
            SELECT *
            FROM  tb_category                  
        </cfquery>
        <cfreturn qryFetchEventCategory>
    </cffunction>

    <cffunction  name="fetchCategory" access="remote" returntype="query">
        <cfquery name="qryFetchEventCategory"> 
            SELECT *
            FROM  tb_category                  
        </cfquery>
        <cfreturn qryFetchEventCategory>
    </cffunction>

    <cffunction  name="eventFilter" access="remote" returntype="query">
        <cfargument name="date">
        <cfargument name="languages">
        <cfargument name="category">        
        <cfset languageArray = listToArray(arguments.languages, ",")>
        <cfset categoryArray = listToArray(arguments.category, ",")>    
        <cfset trimmedLanguages = trim(arguments.languages)>
        <cfset trimmedCategory = trim(arguments.category)>
        <cfquery name="qryFetchEventDetails"> 
            SELECT tb_event.event_id, name, duration, date, rate, profile_img, cover_img, language, category, location, venue 
            FROM tb_event 
            INNER JOIN tb_language ON tb_event.lang_id = tb_language.lang_id           
            INNER JOIN tb_event_venue ON tb_event_venue.event_id = tb_event.event_id
            INNER JOIN tb_venue ON tb_event_venue.venue_id = tb_venue.venue_id
            INNER JOIN tb_category ON tb_event.category_id = tb_category.category_id
            WHERE 1=1
            <cfif len(trimmedLanguages)>
                <cfloop list="#arguments.languages#" index="language">
                    AND tb_language.language = <cfqueryparam value="#language#" cfsqltype="CF_SQL_VARCHAR">
                </cfloop>
            </cfif>
            <cfif len(trimmedCategory)>
                <cfloop list="#arguments.category#" index="category">
                    AND tb_category.category = <cfqueryparam value="#category#" cfsqltype="CF_SQL_VARCHAR">
                </cfloop>
            </cfif>
            <cfif len(date)>                
                    AND date=<cfqueryparam value="#arguments.date#" cfsqltype="cf_sql_date">                
            </cfif>
        </cfquery>
        <cfreturn qryFetchEventDetails>
    </cffunction>

    <cffunction name="saveEventBookingDetails" access="remote" returntype="any">
        <cfargument name="eventId">
        <cfargument name="seats">
        <cfargument name="userId">        
        <cfquery name="qryEventRate">
            SELECT rate
            FROM tb_event
            WHERE tb_event.event_id = <cfqueryparam value="#arguments.eventId#" cfsqltype="CF_SQL_INTEGER">
        </cfquery>  
        <cfif qryEventRate.recordCount EQ 0>
            <cfthrow message="Event not found with ID: #arguments.eventId#" />
        </cfif>        
        <cfset local.rate = qryEventRate.rate[1]>
        <cfset local.amount = local.rate * arguments.seats>    
        <cfquery name="qrySaveEventBookingDetails">
            INSERT INTO 
            tb_event_booking (user_id, event_id, seat_count, amount)
            VALUES (
                <cfqueryparam value="#arguments.userId#" cfsqltype="CF_SQL_INTEGER">,
                <cfqueryparam value="#arguments.eventId#" cfsqltype="CF_SQL_INTEGER">,
                <cfqueryparam value="#arguments.seats#" cfsqltype="CF_SQL_INTEGER">,
                <cfqueryparam value="#local.amount#" cfsqltype="CF_SQL_INTEGER">
            )
        </cfquery>    
        <cfreturn true>
    </cffunction>
    
    <cffunction  name="theaterListBasedOnMovie" access="public" returntype="query">
        <cfargument  name="movieId">
        <cfquery name="qryTheaterList">
            SELECT tb_theater.id, tb_theater.name,tb_theater.address,tb_theater.location,tb_theater.phno,
                STRING_AGG(tb_theater_time.time, ',') AS times
                FROM
                tb_theater
                INNER JOIN
                tb_movie_theater ON tb_movie_theater.theater_id = tb_theater.id
                INNER JOIN
                tb_theater_time ON tb_theater.id = tb_theater_time.theater_id
                WHERE
                tb_movie_theater.movie_id = <cfqueryparam value="#arguments.movieId#" cfsqltype="CF_SQL_INTEGER">
                AND 
				 tb_theater .status = 1
                GROUP BY
                tb_theater.id, tb_theater.name,  tb_theater.address, tb_theater.location, tb_theater.phno;
        </cfquery>
        <cfreturn qryTheaterList>
    </cffunction>

    <cffunction  name="theaterListBasedOnMovieId" access="remote" returntype="query">
        <cfargument  name="movieId">
        <cfquery name="qryTheaterList">
            SELECT tb_theater.id, tb_theater.name,tb_theater.address,tb_theater.location,tb_theater.phno,
                STRING_AGG(tb_theater_time.time, ',') AS times
                FROM
                tb_theater
                INNER JOIN
                tb_movie_theater ON tb_movie_theater.theater_id = tb_theater.id
                INNER JOIN
                tb_theater_time ON tb_theater.id = tb_theater_time.theater_id
                WHERE
                tb_movie_theater.movie_id = <cfqueryparam value="#arguments.movieId#" cfsqltype="CF_SQL_INTEGER">
                AND 
				 tb_theater .status = 1
                GROUP BY
                tb_theater.id, tb_theater.name,  tb_theater.address, tb_theater.location, tb_theater.phno;
        </cfquery>
        <cfreturn qryTheaterList>
    </cffunction>

    <cffunction  name="getSeatDetails">
        <cfquery name="qryGetSeatDetails">
            SELECT *FROM tb_seat
        </cfquery>
        <cfreturn qryGetSeatDetails>
    </cffunction>

    <cffunction  name="theaterDetailsBasedOnId" access="public">
        <cfargument  name="theaterId">
        <cfquery name="qryTheaterDetails">
          SELECT tb_theater.id, tb_theater.name,tb_theater.location,tb_theater.address,tb_theater.phno,
            STRING_AGG(tb_theater_time.time, ',') AS times
            FROM
            tb_theater               
            INNER JOIN
            tb_theater_time ON tb_theater.id = tb_theater_time.theater_id
            WHERE
            tb_theater.id =<cfqueryparam value="#arguments.theaterId#" cfsqltype="CF_SQL_INTEGER">
            GROUP BY
            tb_theater.id, tb_theater.name, tb_theater.location,tb_theater.address,tb_theater.phno        
        </cfquery>
        <cfreturn qryTheaterDetails>
    </cffunction>

    <cffunction  name="fetchTheaterDetailsBasedOnId" access="remote">
        <cfargument  name="theaterId">
        <cfquery name="qryTheaterDetails">
          SELECT tb_theater.id, tb_theater.name,tb_theater.location,tb_theater.address,tb_theater.phno,tb_theater.status,
            STRING_AGG(tb_theater_time.time, ',') AS times
            FROM
            tb_theater               
            INNER JOIN
            tb_theater_time ON tb_theater.id = tb_theater_time.theater_id
            <cfif len(trim(arguments.theaterId))>
                WHERE
                tb_theater.id =<cfqueryparam value="#arguments.theaterId#" cfsqltype="CF_SQL_INTEGER">
            </cfif>
            
            GROUP BY
            tb_theater.id, tb_theater.name, tb_theater.location,tb_theater.address,tb_theater.phno,tb_theater.status       
        </cfquery>
        <cfreturn qryTheaterDetails>
    </cffunction>


    <cffunction  name="movieBooking" access="remote"> 
        <cfargument  name="movieId">
        <cfargument  name="theaterId">
        <cfargument  name="userId">
        <cfargument  name="date">
        <cfargument  name="time">
        <cfargument  name="amount">
        <cfargument  name="seatsString">

        <cfquery name="qryMoviebooking">
            INSERT INTO tb_movie_booking(movieId,theaterId,userId,date,time,seats,amount)
            VALUES(
                <cfqueryparam value="#arguments.movieId#" cfsqltype="CF_SQL_INTEGER">,
                <cfqueryparam value="#arguments.theaterId#" cfsqltype="CF_SQL_INTEGER">,
                <cfqueryparam value="#arguments.userId#" cfsqltype="CF_SQL_INTEGER">,
                <cfqueryparam value="#arguments.date#" cfsqltype="CF_SQL_VARCHAR">,
                <cfqueryparam value="#arguments.time#" cfsqltype="CF_SQL_VARCHAR">,
                <cfqueryparam value="#arguments.seatsString#" cfsqltype="CF_SQL_VARCHAR">,
                <cfqueryparam value="#arguments.amount#" cfsqltype="CF_SQL_INTEGER">

            )
        </cfquery>
    </cffunction>


    <cffunction  name="fetchBookedSeatDetails" access="public">
        <cfargument  name="movieId">
        <cfargument  name="theaterId">
        <cfargument  name="date">
        <cfargument  name="time">
        <cfquery name="qryFetchBookedSeatDetails">
                SELECT
                    TRIM(VALUE) AS Seat
                FROM
                    tb_movie_booking
                CROSS APPLY
                    STRING_SPLIT(seats, ',')
                WHERE
                    movieId =<cfqueryparam value="#arguments.movieId#" cfsqltype="CF_SQL_INTEGER">
                    AND theaterId = <cfqueryparam value="#arguments.theaterId#" cfsqltype="CF_SQL_INTEGER">
                    AND date =<cfqueryparam value="#arguments.date#" cfsqltype="CF_SQL_VARCHAR">
                    AND time = <cfqueryparam value="#arguments.time#" cfsqltype="CF_SQL_VARCHAR">

        </cfquery>
        <cfreturn qryFetchBookedSeatDetails>
    </cffunction>

    <cffunction  name="searchValue" access="public" returntype="any">   
        <cfargument  name="value">
        <cfset local.result ={}>
        <cfquery name="qryFetchSearchMovieDetails">
            SELECT   movie_id as movieId
            FROM tb_movie
            WHERE LOWER(name)=LOWER(<cfqueryparam value="#arguments.value#" cfsqltype="CF_SQL_VARCHAR">)
        </cfquery>
        <cfif qryFetchSearchMovieDetails.recordCount>
            <cfset local.result.flag=1>
            <cfset local.result.id=qryFetchSearchMovieDetails.movieId[1]>
        </cfif>  
        <cfquery  name="qryFetchSearchEventDetails">
            SELECT   event_id as eventId
            FROM tb_event
            WHERE LOWER(name)=LOWER(<cfqueryparam value="#arguments.value#" cfsqltype="CF_SQL_VARCHAR">)
        </cfquery>
        <cfif qryFetchSearchEventDetails.recordCount>
            <cfset local.result.flag=2>
            <cfset local.result.id=qryFetchSearchEventDetails.eventId[1]>
        </cfif>
        <cfquery  name="qryFetchSearchTheaterDetails">
            SELECT tb_theater.id as theaterId
            FROM
            tb_theater  
            WHERE
			LOWER(name)=LOWER(<cfqueryparam value="#arguments.value#" cfsqltype="CF_SQL_VARCHAR">)
        </cfquery>
        <cfif qryFetchSearchTheaterDetails.recordCount>
            <cfset local.result.flag=3>
            <cfset local.result.id=qryFetchSearchTheaterDetails.theaterId[1]>
        </cfif>
        <cfreturn local.result>  
    </cffunction>

    <cffunction  name="theaterDetails" access="public" returntype="query">
        <cfargument  name="theaterId">
        <cfquery name="qryTheaterDetails">  
            SELECT 
                tb_theater.id as theaterId,tb_movie.movie_id AS movieId,tb_movie.name as movieName,tb_theater.name,tb_theater.address,
                STRING_AGG(language, '/')  AS language,
                dimension, cert_type,tb_theater.location
                FROM tb_theater
                inner join tb_movie_theater on tb_movie_theater.theater_id = tb_theater.id
                inner join tb_movie on tb_movie.movie_id = tb_movie_theater.movie_id
                INNER JOIN tb_movie_language ON tb_movie.movie_id = tb_movie_language.movie_id
                INNER JOIN tb_language ON tb_language.lang_id = tb_movie_language.lang_id
                INNER JOIN tb_movie_dimension ON tb_movie.movie_id = tb_movie_dimension.movie_id
                INNER JOIN tb_dimension ON tb_dimension.dimension_id = tb_movie_dimension.dimension_id
                INNER JOIN tb_movie_cert ON tb_movie.movie_id = tb_movie_cert.movie_id
                INNER JOIN tb_certificate ON tb_movie_cert.cert_id = tb_certificate.cert_id 
                WHERE tb_theater.id=<cfqueryparam value="#arguments.theaterId#" cfsqltype="CF_SQL_INTEGER">               
                GROUP BY tb_theater.id,tb_movie.movie_id, tb_movie.name,tb_theater.name, dimension, cert_type,tb_theater.address,tb_theater.location	
        </cfquery>
        <cfreturn qryTheaterDetails>
    </cffunction>

    <cffunction  name="updateEventDetails" access="remote">
        <cfargument name="id" required="true">
        <cfargument name="eventName" required="true">
        <cfargument name="duration" required="true">       
        <cfargument name="rate" required="true">
        <cfargument name="date" required="true">

        <cfquery name="qryUpdateEventDetails">
            UPDATE tb_event
            SET
                name = <cfqueryparam value="#arguments.eventName#" cfsqltype="CF_SQL_VARCHAR">,
                date = <cfqueryparam value="#arguments.date#" cfsqltype="CF_SQL_DATE">,
                duration = <cfqueryparam value="#arguments.duration#" cfsqltype="CF_SQL_VARCHAR">,               
                rate = <cfqueryparam value="#arguments.rate#" cfsqltype="CF_SQL_INTEGER">
            WHERE event_id = <cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_INTEGER">
        </cfquery>

    </cffunction>


    <cffunction  name="deleteEvent" access="remote">
        <cfargument  name="eventId" >
        <cfquery name="qryDeleteEventVenue">
            DELETE FROM tb_event_venue WHERE event_id = <cfqueryparam value="#arguments.eventId#" cfsqltype="CF_SQL_INTEGER">
        </cfquery>         
    </cffunction>
   

    <cffunction  name="fecthLocations" access="remote" returntype="query">
        <cfquery name="qryFecthLocations">
            SELECT * FROM tb_venue
        </cfquery>
        <cfreturn qryFecthLocations>
    </cffunction>


    <cffunction  name="fecthVenues" access="remote" returntype="query">
        <cfargument  name="location">
        <cfquery name="qryFecthVenues">
            SELECT venue FROM tb_venue WHERE location=<cfqueryparam value="#arguments.location#" cfsqltype="CF_SQL_VARCHAR">
        </cfquery>        
            <cfreturn qryFecthVenues>
    </cffunction>


    <cffunction  name="fetchTheaterDetails" access="remote" returntype="query">
        <cfquery name="qryFetchTheaterDetails">
            SELECT * FROM tb_theater
        </cfquery>
        <cfreturn qryFetchTheaterDetails>
    </cffunction>


    <cffunction  name="saveEvent" access="public">
        <cfargument name="name">
       <cfargument name="date">
       <cfargument name="duration">
       <cfargument name="lang">
       <cfargument  name="category">
       <cfargument name="location">
       <cfargument name="venue">
       <cfargument name="rate">
       <cfargument name="fileupload1">
       <cfargument name="fileupload2">
       
       <cfset destination=ExpandPath("/bookmyShow/assests")>
       <cffile action = "upload" 
            fileField = "#arguments.fileupload1#"
            destination = "#destination#"
            nameConflict = "MakeUnique"
            allowedextensions=".jpg,.jpeg,.png" >
        <cfset profileFile = cffile.serverfile>
          
       <cffile action = "upload" 
            fileField = "#arguments.fileupload2#"
            destination = "#destination#"
            nameConflict = "MakeUnique"
            allowedextensions=".jpg,.jpeg,.png">
       <cfset coverFile = cffile.serverfile>

       <cfquery name="qryInsertEventDetails" result="insertResult">
            INSERT INTO tb_event(name,duration,rate,lang_id,cover_img,profile_img,date,category_id)
            VALUES(
               <cfqueryparam value="#arguments.name#" cfsqltype="CF_SQL_VARCHAR">,
               <cfqueryparam value="#arguments.duration#" cfsqltype="CF_SQL_VARCHAR">, 
               <cfqueryparam value="#arguments.rate#" cfsqltype="CF_SQL_INTEGER">, 
               <cfqueryparam value="#arguments.lang#" cfsqltype="CF_SQL_INTEGER">,
               <cfqueryparam value="#coverFile#" cfsqltype="CF_SQL_VARCHAR">,
               <cfqueryparam value="#profileFile#" cfsqltype="CF_SQL_VARCHAR">,
               <cfqueryparam value="#arguments.date#" cfsqltype="CF_SQL_DATE">,
               <cfqueryparam value="#arguments.category#" cfsqltype="CF_SQL_INTEGER">  

            )
       </cfquery>
       <!-- Get the ID of the newly inserted event -->
       <cfset local.newEventID =#insertResult.GENERATEDKEY#>
        <cfquery name="qryGetVenueId">
            SELECT venue_id
            FROM tb_venue
            WHERE 
            location =<cfqueryparam value="#arguments.location#" cfsqltype="CF_SQL_VARCHAR">
            AND
            venue =<cfqueryparam value="#arguments.venue#" cfsqltype="CF_SQL_VARCHAR">
        </cfquery>
        <cfset local.venueId=#qryGetVenueId.venue_id#>

        <cfquery name="qryAddEventVenue">
            INSERT INTO tb_event_venue(event_id,venue_id)
            VALUES(
                    <cfqueryparam value="#local.newEventID#" cfsqltype="CF_SQL_INTEGER">, 
                    <cfqueryparam value="#local.venueId#" cfsqltype="CF_SQL_INTEGER">
            )            
        </cfquery>
       <cflocation  url="eventCrud.cfm">       
    </cffunction>

    <cffunction  name="deleteTheater" access="remote">
        <cfargument  name="theaterId" >
        <cfquery name="qryDeleteTheater">
           UPDATE tb_theater SET status = 0
           WHERE id = <cfqueryparam value="#arguments.theaterId#" cfsqltype="CF_SQL_INTEGER">
        </cfquery>         
    </cffunction>

    <cffunction  name="updateTheaterDetails" access="remote">
        <cfargument  name="id"  type="numeric" required="true">
        <cfargument  name="theaterName"  type="string" required="true">
        <cfargument  name="address"  type="string" required="true">
        <cfargument  name="phno"  type="string" required="true">
        <cfargument  name="status"  type="numeric" required="true">

        <cfquery name="qryUpdateTheaterDetails">
            UPDATE tb_theater
            SET
                name = <cfqueryparam value="#arguments.theaterName#" cfsqltype="CF_SQL_VARCHAR">,
                address = <cfqueryparam value="#arguments.address#" cfsqltype="CF_SQL_VARCHAR">,
                phno = <cfqueryparam value="#arguments.phno#" cfsqltype="CF_SQL_VARCHAR">,               
                status = <cfqueryparam value="#arguments.status#" cfsqltype="CF_SQL_INTEGER">
                WHERE id = <cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_INTEGER">
        </cfquery>

    </cffunction>


    <cffunction  name="saveTheater" access="remote" returntype="boolean">
        <cfargument  name="theaterName" type="string">
        <cfargument  name="address" type="string">
        <cfargument  name="location" type="string">
        <cfargument  name="phno" type="string">
        <cfargument  name="formattedTimes" type="string">
        <cfargument  name="status" type="numeric">

        <cfquery name="qrytheater">
            SELECT id
            FROM tb_theater
            WHERE phno = <cfqueryparam value="#arguments.phno#" cfsqltype="CF_SQL_VARCHAR">
        </cfquery>
    
        <cfif qrytheater.recordCount>
            <cfreturn false>
        <cfelse>
            <cfquery name="qrySaveTheater" result="insertResult">
                INSERT INTO tb_theater(name, address, phno, location, status)
                VALUES (
                    <cfqueryparam value="#arguments.theaterName#" cfsqltype="CF_SQL_VARCHAR">, 
                    <cfqueryparam value="#arguments.address#" cfsqltype="CF_SQL_VARCHAR">, 
                    <cfqueryparam value="#arguments.phno#" cfsqltype="CF_SQL_VARCHAR">, 
                    <cfqueryparam value="#arguments.location#" cfsqltype="CF_SQL_VARCHAR">, 
                    <cfqueryparam value="#arguments.status#" cfsqltype="CF_SQL_INTEGER">
                ) 
            </cfquery>
            <cfset local.newTheaterId =#insertResult.GENERATEDKEY#>

            <cfquery name="qryAddtime">
                <!--- Assuming time is a comma-separated string --->
                <cfset var timeArray = ListToArray(arguments.formattedTimes, ",")>
            
                <!--- Loop through the array and insert each value into the table --->
                <cfloop array="#timeArray#" index="local.time">
                    INSERT INTO tb_theater_time (theater_id, time)
                    VALUES (
                        <cfqueryparam value="#local.newTheaterId#" cfsqltype="CF_SQL_INTEGER">, 
                        <cfqueryparam value="#local.time#" cfsqltype="CF_SQL_VARCHAR">
                    )
                </cfloop>
            </cfquery>
            <cflocation  url="theaterCrud.cfm">    
            <cfreturn true>
        </cfif>       
    </cffunction>

    <cffunction  name="deleteMovie" access="remote">
        <cfargument  name="movieId" >
        <cfquery name="qryDeleteMovie">
           UPDATE tb_movie SET status = 0
           WHERE movie_id = <cfqueryparam value="#arguments.movieId#" cfsqltype="CF_SQL_INTEGER">
        </cfquery>         
    </cffunction>

    <cffunction name="fetchDimensions" access="public" returntype="query"> 
        <cfquery name="qryFetchDimensions">
            SELECT *FROM tb_dimension
        </cfquery>
        <cfreturn qryFetchDimensions>
    </cffunction>

    <cffunction name="fetchCertificate" access="public" returntype="query"> 
        <cfquery name="qryFetchCertificate">
            SELECT *FROM tb_certificate
        </cfquery>
        <cfreturn qryFetchCertificate>
    </cffunction>
   
    <cffunction  name="updateMovieDetails" access="remote">
        <cfargument  name="movieId">
        <cfargument  name="name">
        <cfargument  name="duration">
        <cfargument  name="langId">
        <cfargument  name="genreId">
        <cfargument  name="dimension">
        <cfargument  name="status">
        <cfargument  name="cert">
        <cfargument  name="about">
        <cfargument  name="theaters">

        <cfquery name="qryUpdateMovie">
            UPDATE tb_movie
            SET
            name= <cfqueryparam value="#arguments.name#" cfsqltype="CF_SQL_VARCHAR">,
            duration= <cfqueryparam value="#arguments.duration#" cfsqltype="CF_SQL_VARCHAR">,
            status= <cfqueryparam value="#arguments.status#" cfsqltype="CF_SQL_VARCHAR">,
            about= <cfqueryparam value="#arguments.about#" cfsqltype="CF_SQL_VARCHAR">
            WHERE movie_id=<cfqueryparam value="#arguments.movieId#" cfsqltype="CF_SQL_INTEGER">
        </cfquery>
        <cfquery name="qryUpdateMovieCert">
            UPDATE tb_movie_cert
            SET
            cert_id=<cfqueryparam value="#arguments.cert#" cfsqltype="CF_SQL_INTEGER">
            WHERE movie_id=<cfqueryparam value="#arguments.movieId#" cfsqltype="CF_SQL_INTEGER">
        </cfquery>
        <cfquery name="qryUpdateMovieCert">
            UPDATE tb_movie_dimension
            SET
            dimension_id=<cfqueryparam value="#arguments.dimension#" cfsqltype="CF_SQL_INTEGER">
            WHERE movie_id=<cfqueryparam value="#arguments.movieId#" cfsqltype="CF_SQL_INTEGER">
        </cfquery>
        <cfif len(trim(langId))>
            <cfquery name="qryAddLang">              
                <cfset var langArray = ListToArray(arguments.langId, ",")>
                <cfloop array="#langArray#" index="langId">
                    <cfif len(trim(langId))>
                        INSERT INTO tb_movie_language (movie_id, lang_id)
                        VALUES (
                            <cfqueryparam value="#arguments.movieId#" cfsqltype="CF_SQL_INTEGER">, 
                            <cfqueryparam value="#langId#" cfsqltype="CF_SQL_INTEGER">
                        )
                    </cfif>
                </cfloop>
            </cfquery>
        </cfif>
        <cfif len(trim(genreId))>
            <cfquery name="qryAddGenre">              
                <cfset var genreArray = ListToArray(arguments.genreId, ",")>
                <cfloop array="#genreArray#" index="genreId">
                    <cfif len(trim(genreId))>
                        INSERT INTO tb_movie_genre (movie_id,genre_id)
                        VALUES (
                            <cfqueryparam value="#arguments.movieId#" cfsqltype="CF_SQL_INTEGER">, 
                            <cfqueryparam value="#genreId#" cfsqltype="CF_SQL_INTEGER">
                        )
                    </cfif>
                </cfloop>
            </cfquery>
        </cfif>
        <cfquery name="deleteTheaters">
            delete from tb_movie_theater where movie_id =<cfqueryparam value="#arguments.movieId#" cfsqltype="CF_SQL_INTEGER">
        </cfquery>
        <cfquery name="insertNewTheaters">            
            <cfloop list="#arguments.theaters#" index="id">                
                INSERT INTO tb_movie_theater (movie_id,theater_id)
                 VALUES (
                <cfqueryparam value="#arguments.movieId#" cfsqltype="CF_SQL_INTEGER">, 
                <cfqueryparam value="#id#" cfsqltype="CF_SQL_INTEGER">
            )
            </cfloop>            
        </cfquery>
        
    </cffunction>
    <cffunction  name="insertMovie" access="public">
        <cfargument name="name">
        <cfargument name="releaseDate">
        <cfargument name="duration" >
        <cfargument name="about">  
        <cfargument name="rating">
        <cfargument name="certificate">
        <cfargument name="dimension"> 
        <cfargument name="language">
        <cfargument name="genre">        
        <cfargument name="theater">         
        <cfargument name="fileupload1">
        <cfargument name="fileupload2"> 
        <cfset destination=ExpandPath("/bookmyShow/assests")>
        <cffile action = "upload" 
                fileField = "#arguments.fileupload1#"
                destination = "#destination#"
                nameConflict = "MakeUnique"
                allowedextensions=".jpg,.jpeg,.png" >
        <cfset profileFile = cffile.serverfile>            
        <cffile action = "upload" 
                fileField = "#arguments.fileupload2#"
                destination = "#destination#"
                nameConflict = "MakeUnique"
                allowedextensions=".jpg,.jpeg,.png">
        <cfset coverFile = cffile.serverfile>              
        <cfquery name="qryInsertMovie" result="insertResult">
            INSERT INTO tb_movie(name,release_date,duration,profile_img,cover_img,about,status)
            VALUES(
                <cfqueryparam value="#arguments.name#" cfsqltype="CF_SQL_VARCHAR">,
                <cfqueryparam value="#arguments.releaseDate#" cfsqltype="CF_SQL_DATE">,
                <cfqueryparam value="#arguments.duration#" cfsqltype="CF_SQL_VARCHAR">,
                <cfqueryparam value="#profileFile#" cfsqltype="CF_SQL_VARCHAR">,
                <cfqueryparam value="#coverFile#" cfsqltype="CF_SQL_VARCHAR">,
                <cfqueryparam value="#arguments.about#" cfsqltype="CF_SQL_VARCHAR">,
                <cfqueryparam value="1" cfsqltype="CF_SQL_INTEGER">
            )
        </cfquery>
        <cfset local.movieId =#insertResult.GENERATEDKEY#>

        <cfquery name="qryInsertMovieCert">
            INSERT INTO tb_movie_cert(movie_id,cert_id)
            VALUES(
                <cfqueryparam value="#local.movieId#" cfsqltype="CF_SQL_INTEGER">, 
                <cfqueryparam value="#arguments.certificate#" cfsqltype="CF_SQL_INTEGER">
            )
        </cfquery>

        <cfquery name="qryInsertMovieCert">
            INSERT INTO tb_movie_dimension(movie_id,dimension_id)
            VALUES(
                <cfqueryparam value="#local.movieId#" cfsqltype="CF_SQL_INTEGER">, 
                <cfqueryparam value="#arguments.dimension#" cfsqltype="CF_SQL_INTEGER">
            )
        </cfquery>
        <cfquery name="qryInsertMovieRating">
            INSERT INTO tb_movie_rating(movie_id,rating)
            VALUES(
                <cfqueryparam value="#local.movieId#" cfsqltype="CF_SQL_INTEGER">, 
                <cfqueryparam value="#arguments.rating#" cfsqltype="CF_SQL_VARCHAR">
            )
        </cfquery>        
        <cfif len(trim(genre))>
            <cfquery name="qryAddMovieGenre">              
                <cfset var genreArray = ListToArray(arguments.genre, ",")>
                <cfloop array="#genreArray#" index="genreId">
                    <cfif len(trim(genreId))>
                        INSERT INTO tb_movie_genre (movie_id,genre_id)
                        VALUES (
                            <cfqueryparam value="#local.movieId#" cfsqltype="CF_SQL_INTEGER">, 
                            <cfqueryparam value="#genreId#" cfsqltype="CF_SQL_INTEGER">
                        )
                    </cfif>
                </cfloop>
            </cfquery>
        </cfif>  
        <cfif len(trim(language))>
            <cfquery name="qryAddLang">              
                <cfset var langArray = ListToArray(arguments.language, ",")>
                <cfloop array="#langArray#" index="langId">
                    <cfif len(trim(langId))>
                        INSERT INTO tb_movie_language (movie_id,lang_id)
                        VALUES (
                            <cfqueryparam value="#local.movieId#" cfsqltype="CF_SQL_INTEGER">, 
                            <cfqueryparam value="#langId#" cfsqltype="CF_SQL_INTEGER">
                        )
                    </cfif>
                </cfloop>
            </cfquery>
        </cfif>
        <cfif len(trim(theater))>
            <cfquery name="qryAddLang">              
                <cfset var theaterArray = ListToArray(arguments.theater, ",")>
                <cfloop array="#theaterArray#" index="theaterId">
                    <cfif len(trim(theaterId))>
                        INSERT INTO tb_movie_theater (movie_id,theater_id)
                        VALUES (
                            <cfqueryparam value="#local.movieId#" cfsqltype="CF_SQL_INTEGER">, 
                            <cfqueryparam value="#theaterId#" cfsqltype="CF_SQL_INTEGER">
                        )
                    </cfif>
                </cfloop>
            </cfquery>
        </cfif>
        <cflocation  url="filmCrud.cfm"> 
        
    </cffunction>

   
</cfcomponent>



