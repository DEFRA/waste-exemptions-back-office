function sanitizeFormInput(searchForm) {
  searchForm.submit(function() {
    searchForm.find('input').each(function() {
      let input = $(this);
      input.val(input.val().replace(/\t/g, ''));
    });
  });
}

$(document).ready(function() {
  const searchForm = $('#search-filters').closest('form');
  sanitizeFormInput(searchForm);
});
