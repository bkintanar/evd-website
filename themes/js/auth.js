$(document).ready(function()
{
    var url = location.href;
    var baseURL = url.substring(0, url.indexOf('/', 14));
    
    $(":submit").click(function ()
    {
        var login_form = $("#login_form").serialize();
        
        $.post(baseURL + "/aspl/auth/process_login", { login_form: login_form },
        
            function(data)
            {
                alert(data);
            }
        );

    });
});