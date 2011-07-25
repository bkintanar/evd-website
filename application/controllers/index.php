<?php if (!defined('BASEPATH')) exit('No direct script access allowed');

class Index extends MY_Controller {

    
    public function __construct()
    {
        parent::__construct();
        parent::_get_jscript(__FILE__);
    }

    public function index()
    {
    	// TODO: Move these variables to a config file
        $data['page_title'] = 'Index page';
        
        // load jquery library and jquery rotator 
        $this->smarty->assign('load_jquery', true);
        $this->smarty->assign('load_wt_rotator', true);
        
        // Load the template from the views directory
        $this->smarty->view("index.tpl", $data);
    }

}
