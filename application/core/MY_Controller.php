<?php defined('BASEPATH') OR exit('No direct script access allowed');

class  MY_Controller  extends  CI_Controller  {

    public $em; 
    
    function __construct()
    {
        parent::__construct();
        
        // Instantiate Doctrine's Entity manage and Query builder so we don't have to everytime we want to use Doctrine
        $this->em = $this->doctrine->em;
        $this->qb = $this->em->createQueryBuilder();
        
        $this->load->library('form_validation');
        $this->form_validation->set_error_delimiters($this->_get_error_ldelim(), $this->_get_error_rdelim());
        
        if (ENVIRONMENT != 'development')
        {
        	$this->smarty->assign('social_enabled', true);
        	$this->smarty->assign('plus_this', '<g:plusone size="tall"></g:plusone>');
        	$this->smarty->assign('tweet_this', '<a href="http://twitter.com/share" class="twitter-share-button" data-count="vertical" data-via="upcmandaue">Tweet</a>');
        }
        else
        {
        	$this->smarty->assign("evd", 'evd/');
        }
        
    }
    
    // retrieves the controller's js file if it exists.
    function _get_jscript($_file)
    {
        $_array = explode('/', $_file);
        $cnt = count($_array);
        
        if ( strpos($_array[$cnt-1], '.') === false )
		{
            $_array[$cnt-1] .= '.php';
        }
        $script_name = substr($_array[$cnt-1], 0, -4);
        if(fopen(FCPATH.'themes/js/' . $script_name . '.js', 'r'))
        {
            $script_name = base_url() . 'themes/js/' . $script_name . '.js';
            $this->smarty->assign('contoller_jscript', $script_name);
        }
    }
    
    function _get_error_ldelim()
    {
        return '<div class="ui-widget" id="error_login" style="">
                <div class="ui-state-error ui-corner-all" style="padding: 0 .7em;">
                    <p>
                        <span class="ui-icon ui-icon-alert" style="float: left; margin-right: .3em;"></span>
                        <strong>Alert:</strong> ';
    }
    
    function _get_error_rdelim()
    {
        return '</p>
                </div>
            </div>';
    }
}