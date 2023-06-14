function sanitizeFormInput(searchForm) {
  searchForm.submit(function() {
    searchForm.find("input").each(function() {
      var input = $(this);
      input.val(input.val().replace(/\t/g, ''));
    });
  });
}

$(document).ready(function() {
  var searchForm = $("#search-filters").closest("form");
  sanitizeFormInput(searchForm);
});
