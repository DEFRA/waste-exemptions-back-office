function sanitizeFormInput(form) {
  form.addEventListener('submit', function() {
    form.querySelectorAll('input').forEach(function(input) {
      input.value = input.value.replace(/[\t\&\<\\>"\'\/]+/ig, '');
    });
  });
}

document.addEventListener('DOMContentLoaded', function() {
  var searchFilters = document.getElementById('search-filters');
  if (!searchFilters) return;

  var form = searchFilters.closest('form');
  if (form) {
    sanitizeFormInput(form);
  }
});
