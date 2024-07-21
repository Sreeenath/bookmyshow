// script.js
let slideIndex = 1;
showSlides(slideIndex);

function plusSlides(n) {
  showSlides(slideIndex += n, n);
}

function showSlides(n, direction) {
  let i;
  const slides = document.getElementsByClassName("mySlides");

  if (n > slides.length) {
    slideIndex = 1;
  }

  if (n < 1) {
    slideIndex = slides.length;
  }

  for (i = 0; i < slides.length; i++) {
    slides[i].style.display = "none";
  }

  slides[slideIndex - 1].style.display = "block";

  // Change the slide animation direction
  if (direction === 1) {
    slides[slideIndex - 1].style.animation = "slideFromRight 1s";
  } else {
    slides[slideIndex - 1].style.animation = "slideFromLeft 1s";
  }
}

// Automatically advance slides every 4 seconds
setInterval(function () {
  plusSlides(1);
}, 3000);
