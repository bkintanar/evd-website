<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>  
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <title>UPC Eastern Visayas District</title> 
  <link rel="stylesheet" type="text/css" href="{ci_config name='base_url'}themes/css/evdcss.css">

  <link href="favicon.ico" rel="shortcut icon" type="image/ico">
  <meta name="application-name" content="UPC Eastern Visayas &bull; NaCl">
  <meta name="msapplication-starturl" content="">
  <meta name="msapplication-navbutton-color" content="#000000">
  <meta name="msapplication-window" content="width=1024;height=768">
  <meta name="msapplication-tooltip" content="UPC Eastern Visayas District - NaCl">
  <meta name="msapplication-task" content="name=Salf of the Earth - NaCl;action-uri=http://twitter.com/NaClOrg;icon-uri={ci_config name='base_url'}themes/images/favicons/twitter.ico">     
  <meta name="msapplication-task" content="name=UPC Mandaue - Twitter;action-uri=http://twitter.com/upcmandaue;icon-uri={ci_config name='base_url'}themes/images/favicons/upcmandaue.ico">     
  <meta name="msapplication-task" content="name=NaCl - New Apostolic Christian Laborers;action-uri=http://www.facebook.com/#!/pages/NaCl-New-Apostolic-Christian-Laborers/124249627588648;icon-uri={ci_config name='base_url'}themes/images/favicons/facebook.ico">
  <!-- Start: load css file needed by all pages -->
  <link href="{ci_config name='base_url'}themes/css/dropdown/dropdown.limited.css" media="screen" rel="stylesheet" type="text/css">
  <link href="{ci_config name='base_url'}themes/css/dropdown/default.css" media="screen" rel="stylesheet" type="text/css">
  <!-- End: load css file needed by all pages -->
  {if isset($load_jquery)}
  <!-- Start: load jquery -->
  <script type="text/javascript" src="{ci_config name='base_url'}themes/js/jquery-1.6.1.min.js"></script>
  <!-- End: load jquery -->
  {/if}
  {if isset($load_wt_rotator) }
  <!-- Start: load css and js for wt-rotator -->
  <link rel="stylesheet" type="text/css" href="{ci_config name='base_url'}themes/css/wt-rotator-1.5/wt-rotator.css">
  <script type="text/javascript" src="{ci_config name='base_url'}themes/js/wt-rotator-1.5/jquery.easing.1.3.min.js"></script>
  <script type="text/javascript" src="{ci_config name='base_url'}themes/js/wt-rotator-1.5/jquery.wt-rotator.min.js"></script>    
  <script type="text/javascript" src="{ci_config name='base_url'}themes/js/wt-rotator-1.5/preview.min.js"></script>
  <!-- End: load css and js for wt-rotator -->
  {/if}

  <!--[if lt IE 7]>
  <style type="text/css" media="screen">
  body { behavior:url("{ci_config name='base_url'}themes/js/csshover.htc"); }
  </style>
  <![endif]-->

</head>
<body>	 
	<div id="border"></div>	
  <div id="container">
  <div id="center-page">
  
      <header>
        <!--Logo and Mainlinks-->
        <div id="header-part">
           <div class="site-logo"><img src="{ci_config name='base_url'}themes/images/upcevdlogo.png" alt="upcevdlogo" height="75" width="700"></div>
           <div id="mainlinks">
            <img src="{ci_config name='base_url'}themes/images/social/youtube.png" alt="youtube" height="30" width="30">
            <img src="{ci_config name='base_url'}themes/images/social/facebook.png" alt="facebook" height="30" width="30">
            <img src="{ci_config name='base_url'}themes/images/social/twitter.png" alt="twitter" height="30" width="30">
            <img src="{ci_config name='base_url'}themes/images/social/rss.png" alt="rss" height="30" width="30">
           </div>
        </div>
        <!--Logo and Mainlinks-->
        
        <!--Main Menu-->
        {$navlinks}
        <!--Main Menu-->
      
      </header>