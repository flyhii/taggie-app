function showProgressBar() {
  console.log('Hiiii');
  var progressBar = document.getElementById('progress-bar');
  var progressText = document.getElementById('progress-text');

  progressBar.style.display = 'block';

  var width = 0;
  var interval = setInterval(function() {
    if (width >= 100) {
      clearInterval(interval);
      updateProgressText(progressText, width);
      progressBar.style.display = 'block';
    } else {
      if (width > 50) {
        clearInterval(interval);
        interval = setInterval(function() {
          if (width >= 100) {
            clearInterval(interval);
            progressBar.style.display = 'none';
          } else {
            width += 10;
            progressBar.style.width = width + '%';
            updateProgressText(progressText, width);
          }
        }, 700);
      } else {
        width += 20;
        progressBar.style.width = width + '%';
        updateProgressText(progressText, width);
      }
    }
  }, 900);
}

function updateProgressText(progressText, width) {
  if (width === 20) {
    progressText.innerText = 'Start finding'; // 寬度為 20% 顯示 "Start"
  } else if (width === 60) {
    progressText.innerText = 'Almost there'; // 寬度為 60% 顯示 "Almost"
  } else if (width === 100) {
    progressText.innerText = 'Finished'; // 寬度為 100% 顯示 "Finished"
  }
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
