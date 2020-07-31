$(document).ready(function(){

    $("#payment").validate({
       rules: {
        name: {
          required: true,
          minlength: 3,
          maxlength: 50,
        },
       
        card_number: {
          required : true,
          minlength: 16,
          maxlength: 18
          // email :true,
        },
        expiry_date : {
          required : true,
          // maxlength : 50
        },
        cvv : {
          required : true,
          minlength : 3,
          maxlength : 4
        }
      },
      messages: {
         name:{
            required: "Please enter your name",
            minlength: "Name should be at least 3 characters",
            maxlength: "Name should be less than 50 characters"
         },
         card_number: {
            required : "Please enter your card-number",
            minlength: "card_number should be at least 16 digits",
            maxlength: "card_number should be less than 18 digits"
         },
        expiry_date : {
          required : "Please enter your expiry-date",
          // minlength: "subject should be at least 4 characters",
          // maxlength: "subject should be less than 5 characters"
        },
        cvv : {
          required : "Please enter your cvv",
          minlength: "cvv should be at least 3 characters",
          maxlength: "cvv should be less than 4 characters"
        }
       }
     });


});
