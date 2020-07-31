$(document).ready(function(){

    $("#support").validate({
       rules: {
        name: {
          required: true,
          minlength: 3,
          maxlength: 50,
        },
       
        email: {
          required : true,
          email :true,
        },
        subject : {
          required : true,
          minlength : 5,
          maxlength : 50
        },
        description : {
          required : true,
          minlength : 5,
          maxlength : 500
        }
      },
      messages: {
         name:{
            required: "Please enter your name",
            minlength: "Name should be at least 3 characters",
            maxlength: "Name should be less than 50 characters"
         },
         email: {
            required : "Please enter your email",
            email :"please enter a valid email"
         },
        subject : {
          required : "Please enter your subject",
          minlength: "subject should be at least 5 characters",
          maxlength: "subject should be less than 50 characters"
        },
        description : {
          required : "Please enter your description",
          minlength: "description should be at least 5 characters",
          maxlength: "description should be less than 500 characters"
        }
       }
     });


});
