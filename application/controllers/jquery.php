<?php if (!defined('BASEPATH')) exit('No direct script access allowed');

class Jquery extends MY_Controller {
    
    public function __construct()
    {
        parent::__construct();
        parent::_get_jscript(__FILE__);
    }

    public function index()
    {
    
    	$_user_obj = new \models\User;
        $_user_objs = $_user_obj->getUsers();
        
        $d = array();
        foreach ($_user_objs as $u)
        {
            $json = array();
            $json['value'] = $u->getUserId();
            $json['name'] = htmlentities($u->getPastorNameWithTitle());
            
            $d[] = $json;
        }
        asort($d);
        
        $js_script = '$(document).ready(function() {
            var data = {items: ' . json_encode($d) . '};
            
            $(function() {
                $("input[type=text]").autoSuggest(data.items, {selectedItemProp: "name", searchObjProps: "name", asHtmlID: "my-as", retrieveLimit: "10", minChars: "1"});
            });
        });';
        
        $this->smarty->assign('js_script', $js_script);
        $this->smarty->assign('js', true);
        $this->smarty->assign('page_title', 'jQuery Test Pagse');
        
        $this->smarty->view("jquery.tpl");
    }
}