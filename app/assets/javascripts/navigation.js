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
              el.parents(".video-link").fadeOut('hide');
              show_flash_notice_only(response["message"]);
          },
          error: function(response, textStatus, errorThrown) {
              show_flash_alert_from_response(response);
          }
        });
      }
      return false;
    });

    $('body').on('click', '.toggle-feature, .approve-video', function() {
        var el = $(this);
        $.ajax({
          type: 'POST',
          url: el.data("url"),
          data: {
            _method: 'post'
          },
          dataType: 'json',
          success: function(response) {
              if (el.data("action") == "feature")
              {
                el.text(el.text() == "Feature" ? "Un-feature" : "Feature");
              }
              else if (el.data("action") == "approve")
              {
                  el.parents("#unapproved").hide();
                  $("#approved", el.parents(".approve-container")).show();
              }
              show_flash_notice_only(response["message"]);
          },
          error: function(response, textStatus, errorThrown) {
              show_flash_alert_from_response(response);
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

    $(".slider-container").each(function() {
        var value = parseInt($(".rating_value", $(this)).text());
        var disabled = $(".rating_value", $(this)).data("disabled");

        $(".slider-range-min", $(this)).slider({
          value: value,
          disabled: disabled,
          orientation: "vertical",
          min: 0,
          max: 100,
          slide: function( event, ui ) {
            $(".rating_value", $(this).parent() ).text( ui.value + "%" );
            $(".video_score", $(this).parent()).val(ui.value);
          }
        });
    });
});

function clear_search_pane()
{
    $.each($("div#sidebar select"), function(index, select_obj) {
        var default_value = $(select_obj).data("default");
        if ((default_value == undefined) || (default_value == null))
        {
            default_value = "";
        }
        $(select_obj).val(default_value);
    });
    $("div#sidebar input[type='text']").val("");
    $.each($("input[type='checkbox'].clearable, input[type='radio'].clearable", $("div#sidebar")), function(index, check_box) {
        var default_val = $(check_box).data("default");
        if ((default_val == true) || (default_val == false))
        {
            $(check_box).prop("checked", default_val);
        }
    });
    $("div#sidebar .hide-on-clear").hide();
    $("div#sidebar #rating_value").text("0.00");
    $("div#sidebar #q_resource_rating_gteq").val("0.00");
    $("div#sidebar #slider-range-filter .ui-slider-handle").css("left", "0");
}

var scroll_speed = 500;

function scroll_page(element)
{
    if (element.length != 0)
    {
        $(document.body).animate({
            'scrollTop':   $(element).offset().top
        }, scroll_speed);
    }
}

function show_flash_notice_only(text)
{
    show_flash_notice_with_parent_only(text, null);
}

function show_flash_notice_with_parent_only(text, parent_el)
{
    $(".alert").hide();
    $(".notice", parent_el).text(text).show();
}

function show_flash_alert_from_response(response)
{
    if ((response.responseJSON == undefined) || (response.responseJSON == null) || (response.responseJSON["error"] == null))
    {
        if ((response.responseText == undefined) || (response.responseText == null))
        {
            show_flash_alert_only("An error has occurred, please try again.");
        }
        else
        {
            show_flash_alert_only(response.responseText);
        }
    }
    else
    {
        show_flash_alert_only(response.responseJSON["error"]);
    }
}

function show_flash_alert_only(text)
{
    $(".notice").hide();
    $(".alert").text(text).show();
}