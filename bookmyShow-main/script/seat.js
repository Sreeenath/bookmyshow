var totalRate=0;
var seatsArray = [];
var time="";
var date="";

function changeStyle(element,rate,seatNo,type,seatId) {

    var currentColor = window.getComputedStyle(element).backgroundColor;    
    if (currentColor == "rgb(30, 168, 60)") {
        element.style.backgroundColor = 'white';
        element.style.color='#1ea83c';       
        totalRate -= rate;     
        let index = seatsArray.indexOf(seatId);
        // Check if the value is found in the array
        if (index !== -1) {
        // Remove the element at the found index
            seatsArray.splice(index, 1);
        }
                
    } 
    if(currentColor == "rgb(255, 255, 255)") {
        element.style.backgroundColor = '#1ea83c';
        element.style.color='white';
        totalRate += rate;       
            seatsArray.push(seatId);
       
    }
    time=$(".time").val();
    date=$(".date").val();
    if(totalRate == 0){
        $("#payBtn").html("Pay");
    }
    else{
        $("#payBtn").html("Pay Rs." + totalRate + ".00");

    }
    
}


function booking(movieId,theaterId,userId){
    time=$(".time").val();
    date=$(".date").val();    
    var seatsString = seatsArray.join(',');   

    $.ajax({
        type:'post',
        url:'components/bookMyShow.cfc?method=movieBooking',
        data:{
            movieId:movieId,
            theaterId:theaterId,
            userId:userId,
            date:date,
            time:time,
            seatsString: seatsString,
            amount:totalRate
        },
        success:function(data){
            alert("booking Sucessfull");
            window.location.href="body.cfm"

        },
        error:function(error){
            console.error("Error changing session variable:", error);

        }


    });

}

function backPage(){
    window.history.back();
}