<?php if (!defined('BASEPATH')) exit('No direct script access allowed');

class Index extends MY_Controller {

    
    public function __construct()
    {
        parent::__construct();
        parent::_get_jscript(__FILE__);
    }
    
    public function index()
    {
    	$this->smarty->view("default.tpl", $data);
    }

}
