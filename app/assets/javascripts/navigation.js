$(document).ready(function() {

    $('body').on('click', '.delete-resource', function() {
      var el = $(this);
      if (confirm(el.data("confirm"))) {
        $.ajax({
          type: 'POST',
          url: $(this).attr("href"),
          data: {
            _method: 'delete'
          },
          dataType: 'script',
          success: function(response) {
            el.parents("div.video-link").fadeOut('hide');
          },
          error: function(response, textStatus, errorThrown) {
            $(".alert").text(response.responseText);
          }
        });
      }
      return false;
    });
});