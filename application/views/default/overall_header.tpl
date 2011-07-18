<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>

    <meta http-equiv="content-type" content="text/html; charset=UTF-8" />
    <meta http-equiv="content-style-type" content="text/css" />
    <meta http-equiv="content-language" content="en" />
    <meta http-equiv="imagetoolbar" content="no" />
    <meta name="resource-type" content="document" />
    <meta name="distribution" content="global" />
    <meta name="copyright" content="2011 b3rx Technologies" />
    <meta name="keywords" content="" />
    <meta name="description" content="" />
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7; IE=EmulateIE9" />
    <link rel="shortcut icon" href="{ci_config name='base_url'}favicon.ico" />
    <link href="{ci_config name='base_url'}themes/common.css" rel="stylesheet" type="text/css" media="screen, projection" />
    <link type="text/css" href="{ci_config name='base_url'}themes/css/autosuggest-1.4/autoSuggest.css" rel="stylesheet" />
    <link type="text/css" href="{ci_config name='base_url'}themes/css/ui-lightness/jquery-ui-1.8.11.custom.css" rel="stylesheet" />
    <title>{ci_config name="site_name"} &bull; {ci_config name="app_name"} &bull; {$page_title}</title>
    <script type="text/javascript" src="{ci_config name='base_url'}themes/js/jquery-1.5.2.min.js"></script>
    <script type="text/javascript" src="{ci_config name='base_url'}themes/js/jquery-ui-1.8.11.custom.min.js"></script>
    <script type="text/javascript" src="{ci_config name='base_url'}themes/js/autosuggest-1.4/jquery.autoSuggest.js"></script>
    {if isset($contoller_jscript)}<script type="text/javascript" src="{$contoller_jscript}"></script>{/if}
    
    {if isset($social_enabled)}
    <!-- Start - Loads jscript for social networks -->
    <script type="text/javascript" src="http://connect.facebook.net/en_US/all.js#xfbml=1"></script>
    <script type="text/javascript" src="https://apis.google.com/js/plusone.js"></script>
    <script type="text/javascript" src="http://platform.twitter.com/widgets.js"></script>
    <!-- End - Loads jscript for social networks -->
    {/if}
    
    {if isset($js)}
<script type="text/javascript">
	{$js_script}
</script>
	{/if}
</head>
<body>
    <div id="page-header">
        <div class="navbar">
            <div class="inner">
                <span class="corners-top"><span>
                </span></span>
                <div class="site-logo">
                <a href="{ci_config name='base_url'}" accesskey="h">
                    <img src="{ci_config name='base_url'}themes/images/site_logo.png" alt="site_logo.png" title="{ci_config name='site_name'} &bull; {ci_config name='app_name'}" />
                </a>
                </div>
                <ul class="linklist navlinks"><li></li></ul>
                <ul class="linklist leftside"><li></li></ul>
                <ul class="linklist rightside">
                    {if isset($user_login)}
                    <li>
                        <a href="{ci_config name='base_url'}auth/logout" title="Logout [ {$user_login} ]" accesskey="l">Logout [ {$user_login} ]</a>
                    </li>
                    {else}
                    <li>
                        <a href="{ci_config name='base_url'}auth/register" title="Register" accesskey="r">Register</a>
                    </li>
                    <li>
                        <a href="{ci_config name='base_url'}auth/login" title="Login" accesskey="l">Login</a>
                    </li>
                    {/if}
                </ul>
                <span class="corners-bottom"><span>
                </span></span>
            </div>
        </div>
    </div>
    <div><span class='corners-top'></span></div>
    <div id="page_body">
        <div class="panel">
            <div class="inner">
                <span class="corners-top"><span>
                </span></span>
                <div class="content">