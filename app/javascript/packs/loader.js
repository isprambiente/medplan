document.addEventListener('ajax:beforeSend', function(event) {
  event.target.classList.add('is-loading')
  document.getElementById('loader').classList.remove('is-hidden')
  })
document.addEventListener('ajax:success', function(event) {
  event.target.classList.remove('is-loading')
  document.getElementById('loader').classList.add('is-hidden')
  })
document.addEventListener('ajax:error', function(event) {
  document.getElementById('error').classList.add('is-active')
  event.target.classList.remove('is-loading')
  document.getElementById('loader').classList.add('is-hidden')
 })
