$(document).ready(function(){
    // Banner Window Height
    $('.banner-sec').css({'height': ($(window).height()) + 'px'});
    // Set Input Type Password To Input Type Text And Input Type Text To Password
    $('.pass').click(function(){
        if($('#password').prop('type')=='password'){
            $('#password').prop('type','text');
        }else{
            $('#password').prop('type','password');
        }

    });
    $('.cpass').click(function(){
        if($('#cpassword').prop('type')=='password'){
            $('#cpassword').prop('type','text');
        }else{
            $('#cpassword').prop('type','password');
        }

    });
});