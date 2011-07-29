<?php if (!defined('BASEPATH')) exit('No direct script access allowed');

/**
 *
 * base_url/article
 *
 * @package    controllers
 * @author     Bertrand Kintanar <bertrand.kintanar@gmail.com>
 * @version    $Id$
 * @copyright  &copy; 2011 NaCl.org WebGroup
 *
 */
class Article extends MY_Controller {

    
    public function __construct()
    {
        parent::__construct();
        parent::_get_jscript(__FILE__);
    	
    	$this->load->library('pagination');
    	
    	$this->_article_obj = new \models\Article;
    	$_articles    = $this->_article_obj->getArticles();
    }
    
    public function index()
    {
    	
    	$config['base_url'] = $this->config->item('base_url').'article/index/';
    	$config['total_rows'] = count($_articles);
    	$config['per_page']   = 5;
    	$config['num_links']  = 5;
    	
    	$this->pagination->initialize($config);

    	$this->qb->add('select', 'a')
    		->add('from', 'models\Article a')
   			->setMaxResults( $config['per_page'] );
    	
    	if ( $this->uri->segment(3) )
    	{
    		$this->qb->setFirstResult( $this->uri->segment(3) );
    	}
    	
    	$query = $this->qb->getQuery();
    	
    	$articles = $query->getResult();

    	$this->smarty->assign("paginateLinks", $this->pagination->create_links());
		$this->smarty->assign("articles", $articles);
    	    	
        $this->smarty->view("articles.tpl", $data);
    }

    public function view()
    {
    	$this->load->library('pagination');

        if ( $this->uri->segment(3) )
    	{
    		$_article_id = $this->uri->segment(3);
    		$_article = $this->_article_obj->getArticleById($_article_id);
    	}
    	if ($_article)
    	{
    		$this->smarty->assign("article", $_article);
    		$_tags = $_article->getArticleTags();
    		
    		if ($_tags)
    		{
    			$this->smarty->assign('tags', $_tags);
    		}
    	}

        // TODO: Move these variables to a config file
        $data['page_title'] = $_article->getArticleTitle();
        
        // Load the template from the views directory
        $this->smarty->view("article_view.tpl", $data);
    }

}
