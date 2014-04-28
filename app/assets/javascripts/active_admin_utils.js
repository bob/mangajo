function switch_dish_ingredients() {
  $('#new_dish,#edit_dish div.dish_compositions select[id^=\'dish_dish_compositions_attributes\']').each(function() {
    var num = $(this).attr('id').match(/[0-9]+/);
    toggle_dish_ingredient($(this), num);
  });
}

function toggle_dish_ingredient(selem, num) {
  var pu = $('option:selected', selem).attr('pu');

  if(pu == 'gramm') {
    $("#dish_dish_compositions_attributes_"+ num + "_portions_input").hide();
    $("#dish_dish_compositions_attributes_"+ num + "_weight_input").show();
  }

  if(pu == 'item') {
    $("#dish_dish_compositions_attributes_"+ num + "_portions_input").show();
    $("#dish_dish_compositions_attributes_"+ num + "_weight_input").hide();
  }
}

$(function(){
  $('#edit_dish, #new_dish').on("change", ".dish_ingredient_select", function() {
    var num = $(this).parents("li[id^='dish_dish_compositions_attributes']").attr('id').match(/[0-9]+/);
    toggle_dish_ingredient($(this), num);
  });

});


