function showProgressBar() {
  console.log('Hiiii');
  var progressBar = document.getElementById('progress-bar');
  var progressText = document.getElementById('progress-text');

  progressBar.style.display = 'block';

  var width = 0;
  var interval = setInterval(function() {
    if (width >= 100) {
      clearInterval(interval);
      progressBar.style.display = 'none';
      progressText.textContent = 'Finished';
    } else {
      if (width > 50) {
        clearInterval(interval);
        interval = setInterval(function() {
          if (width >= 100) {
            clearInterval(interval);
            progressBar.style.display = 'none';
            progressText.textContent = 'Finished';
          } else {
            if (width >= 80) {
              progressText.textContent = 'Almost';
            } else if (width >= 40) {
              progressText.textContent = 'Halfway';
            } else {
              progressText.textContent = 'Start';
            }
            width += 10;
            progressBar.style.width = width + '%';
          }
        }, 700);
      } else {
        width += 20;
        progressBar.style.width = width + '%';
      }
    }
  }, 900);
}

var mediaFormSubmitButton = document.getElementById('media-form-submit');
console.log(mediaFormSubmitButton);

mediaFormSubmitButton.addEventListener('mouseup', function() {
  showProgressBar();
});

// $(document).ready(function($) {
//   $(".table-row").click(function() {
//       window.document.location = $(this).data("href");
//   });
// });
