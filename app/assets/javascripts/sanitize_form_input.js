function sanitizeFormInput(searchForm) {
  searchForm.submit(function() {
    searchForm.find('input').each(function() {
      const input = $(this);
      input.val(input.val().replace(/\t/g, ''));
    });
  });
}

$(document).ready(function() {
  const searchForm = $('#search-filters').closest('form');
  sanitizeFormInput(searchForm);
});
