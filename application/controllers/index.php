<?php if (!defined('BASEPATH')) exit('No direct script access allowed');

class Index extends MY_Controller {

    
    public function __construct()
    {
        parent::__construct();
        parent::_get_jscript(__FILE__);
    }

    public function index()
    {
        $user_obj       = $this->em->find( 'models\User', 5 );
        
        // TODO: Move these variables to a config file
        $data['page_title'] = 'Index page';
        
        // Load the template from the views directory
        $this->smarty->view("index.tpl", $data);
    }

}
