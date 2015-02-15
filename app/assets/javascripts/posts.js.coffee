$(document).on "page:change", ->
  $('#post_author_name,#filters_author_name').autocomplete serviceUrl: '/authors/autocomplete'
  $('#post_category_name,#filters_category_name').autocomplete serviceUrl: '/categories/autocomplete'

  $('#filters_form').on "ajax:success", (e, data, status, xhr) ->
    $('#posts').html xhr.responseText
