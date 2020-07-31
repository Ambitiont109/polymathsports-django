$(document).ready(function(){

    $.validator.addMethod("endDate", function(value, element) {
       var startDate = $('.startDate').val();
       return Date.parse(startDate) <= Date.parse(value) || value == "";
     }, "End date must be greater than start date");
    // $('#formId').validate();

    // $.validator.setDefaults({
    //   debug: true,
    //   success: "valid"
    // });

    $("#user-register").validate({
       rules: {
        name: {
          required: true,
          minlength: 3,
          maxlength: 50,
        },
        terms_conditions : {
          required:true,
        },
        email: {
          required : true,
          email :true,

        },
//        twitter: {
//           required: true,
//        },
        password: {
           required: true,
        },
        password_again: {
          equalTo: "#password"
        }
      },
      messages: {
         name:{
            required: "Please enter your name",
            minlength: "Name should be at least 3 characters",
            maxlength: "Name should be less than 50 characters"
         },
         email: {
            required : "Please enter your name",
         },
         password: {
            required : "Please enter your password",
         },
         password_again: "Enter Confirm Password Same as Password",
//         twitter: {
//            required : "Please enter your twitter",
//         },
      }
     });

     $.validator.addMethod('lessThanEqual', function(value, element, param) {
        if (this.optional(element)) return true;
        var i = parseInt(value);
        var j = parseInt($(param).val());
        return i <= j;
      }, "The value {0} must be less than {1}");


});
