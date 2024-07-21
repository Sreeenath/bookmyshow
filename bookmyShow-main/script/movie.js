$(document).ready(function () {
    // Get the element by its ID using jQuery
    const myElement = $("#movieDiv");
    // Get the URL from the hidden input
    const profileImgUrl = $("#profile_img").val();
    // Set the background property using the dynamically obtained URL
    myElement.css({
        background: `linear-gradient(90deg, #1A1A1A 24.97%, #1A1A1A 38.3%, rgba(26, 26, 26, 0.0409746) 97.47%, #1A1A1A 100%), url('${profileImgUrl}')`,
        backgroundRepeat: "no-repeat",
        backgroundSize: "cover",
    });
});
