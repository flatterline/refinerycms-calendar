jQuery ->
  datetimes = jQuery(".datetime_range").datetimepicker
    ampm: true
    dateFormat: 'M d, yy'
    changeMonth: true
    changeYear: true
    numberOfMonths: 2

  jQuery('.add-to-calendar-link').on 'click', () ->
    jQuery(this).siblings('.calendar-options').toggle()
    false
