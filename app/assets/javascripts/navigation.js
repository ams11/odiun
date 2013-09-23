$(document).on("ready page:change", function() {

    $('body').on('click', '.delete-resource', function() {
      var el = $(this);
      if (confirm(el.data("confirm"))) {
        $.ajax({
          type: 'POST',
          url: $(this).attr("data-url"),
          data: {
            _method: 'delete'
          },
          dataType: 'json',
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

    $('body').on('click', '.toggle-feature', function() {
      var el = $(this);
        $.ajax({
          type: 'POST',
          url: $(this).attr("data-url"),
          data: {
            _method: 'post'
          },
          dataType: 'json',
          success: function(response) {
            el.text(el.text() == "Feature" ? "Un-feature" : "Feature");
            $(".notice").text(response);
          },
          error: function(response, textStatus, errorThrown) {
            $(".alert").text(response.responseText);
          }
        });
      return false;
    });

    $("#slides").slidesjs({
      play: {
          active: true,
          auto: true,
          interval: 15000,
          swap: true,
          pauseOnHover: true,
          restartDelay: 2500
        }
    });
});