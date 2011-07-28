<?php if (!defined('BASEPATH')) exit('No direct script access allowed');

class Index extends MY_Controller {

    
    public function __construct()
    {
        parent::__construct();
        parent::_get_jscript(__FILE__);
        
        if (ENVIRONMENT != 'development')
        {
        	$this->load->spark('twitterfetcher/1.0.3');
        }
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
        	$data['article_' . ++$idx] = $_article;
        }
        
        // get twitter feeds for @NaClOrg
        $twitterId = 'NaClOrg';
        $data['twitterId'] = $twitterId;
        
        if (ENVIRONMENT != 'development')
        {
        	$tweets = $this->twitterfetcher->getTweets(array('twitterID' => $twitterId, 'usecache' => false, 'count' => 5, 'numdays' => 30));
        	$data['tweets']    = $tweets;
        }
        
        // Load the template from the views directory
        $this->smarty->view("index.tpl", $data);
    }

}
