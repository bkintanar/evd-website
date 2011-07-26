<?php if (!defined('BASEPATH')) exit('No direct script access allowed');

class Index extends MY_Controller {

    
    public function __construct()
    {
        parent::__construct();
        parent::_get_jscript(__FILE__);
    }

    public function index()
    {
    	$_article_obj = new \models\Article;
    	$_articles = $_article_obj->getArticleLatestThree();
    	
    	// TODO: Move these variables to a config file
        $data['page_title'] = 'Index page';
        
        // load jquery library and jquery rotator 
        $this->smarty->assign('load_jquery', true);
        $this->smarty->assign('load_wt_rotator', true);
        
        $idx = 0;
        foreach ($_articles as $_article)
        {
        	$this->smarty->assign('article_' . ++$idx, $_article);
        }
        
        // Load the template from the views directory
        $this->smarty->view("index.tpl", $data);
    }

}
