<?php if (!defined('BASEPATH')) exit('No direct script access allowed');

class Members extends MY_Controller {

    
    public function __construct()
    {
        parent::__construct();
        parent::_get_jscript(__FILE__);
    }
    
    public function index()
    {
    	redirect('members/view');
    }

    public function view()
    {
    	$this->load->library('pagination');
    	$this->load->library('table');

        $_user_obj   = new \models\User;
        $_users = $_user_obj->getUsers();
    	
    	$config['base_url']   = $this->config->item('base_url') . "members/view/";
    	$config['total_rows'] = count($_users);
    	$config['per_page']   = 3;
    	$config['num_links']  = 5;

    	$this->pagination->initialize($config);
    	
    	$this->qb->add('select', 'u')
    		->add('from', 'models\User u')
    		->add('where', 'u.user_id != 1')
   			->setMaxResults( $config['per_page'] );
    	
    	if ( $this->uri->segment(3) )
    	{
    		$this->qb->setFirstResult( $this->uri->segment(3) );
    	}
    	$query = $this->qb->getQuery();
    	
    	$users = $query->getResult();
    	
    	$this->smarty->assign("paginateLinks", $this->pagination->create_links());
		$this->smarty->assign("users", $users);

        // TODO: Move these variables to a config file
        $data['page_title'] = 'Members';
        
        // Load the template from the views directory
        $this->smarty->view("members.tpl", $data);
    }

}
