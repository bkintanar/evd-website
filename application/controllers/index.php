<?php if (!defined('BASEPATH')) exit('No direct script access allowed');

class Index extends MY_Controller {

    
    public function __construct()
    {
        parent::__construct();
        parent::_get_jscript(__FILE__);
    }

    public function index()
    {
    	$this->load->library('pagination');
    	$this->load->library('table');
        $state_id = 25;
        $cities_objs   = $this->em->getRepository( 'models\City' )->findBy( array( 'state_id' => $state_id ) );
    	
    	$config['base_url']   = $this->config->item('base_url')."index/index/";
    	$config['total_rows'] = count($cities_objs);
    	$config['per_page']   = 10;
    	$config['num_links']  = 5;

    	$this->pagination->initialize($config);
    	
    	$this->qb->add('select', 'c')
    		->add('from', 'models\City c')
   			->add('where', 'c.state_id = ' . $state_id)
   			->setMaxResults( $config['per_page'] );
    	
    	if ( $this->uri->segment(3) )
    	{
    		$this->qb->setFirstResult( $this->uri->segment(3) );
    	}
    	$query = $this->qb->getQuery();
    	
    	$cities = $query->getResult();
    	
    	$this->smarty->assign("paginateLinks", $this->pagination->create_links());            
		$this->smarty->assign("cities", $cities);            
        
        // TODO: Move these variables to a config file
        $data['page_title'] = 'Index page';
        
        // Load the template from the views directory
        $this->smarty->view("index.tpl", $data);
    }

}
