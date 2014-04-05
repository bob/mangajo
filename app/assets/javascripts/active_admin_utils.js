$(function(){
  $('#edit_dish, #new_dish').on("change", ".dish_ingredient_select", function() {
    var pu = $('option:selected', this).attr('pu');
    var num = $(this).parents("li[id^='dish_dish_compositions_attributes']").attr('id').match(/[0-9]+/);

    if(pu == 'gramm') {
      $("#dish_dish_compositions_attributes_"+ num + "_portions_input").hide();
      $("#dish_dish_compositions_attributes_"+ num + "_weight_input").show();
    }

    if(pu == 'item') {
      $("#dish_dish_compositions_attributes_"+ num + "_portions_input").show();
      $("#dish_dish_compositions_attributes_"+ num + "_weight_input").hide();
    }
  });
});
