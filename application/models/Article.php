<?php

/**
 *
 * Article Entity class
 *
 * @package    NaCl
 * @author     Bertrand Kintanar <bertrand.kintanar@gmail.com>
 * @version    $Id: Article.php 3 2011-07-16 03:43:26Z bertrand.kintanar@gmail.com $
 * @copyright  &copy; 2011 EVD1 Group
 *
 */
namespace models;

/**
 * @Entity
 * @Table(name="article")
 */
class Article {

    /**
     * @Id
     * @Column(type="integer", nullable=false)
     * @GeneratedValue(strategy="AUTO")
     */
    private $article_id;
    
    /**
     * @Column(type="datetime", nullable=true)
     */
    private $article_date_created;
    
    /**
     * @Column(type="datetime", nullable=false)
     */
    private $article_last_modified;
    
    /**
     * @Column(type="string", length=200, unique=true, nullable=false)
     */
    private $article_title;
    
    /**
     * @Column(type="string", length=10000, unique=true, nullable=true)
     */
    private $article_text;
    
    /**
     * @Column(type="integer", nullable=false)
     */
    private $user_id;
    
    /**
     * @ManyToOne(targetEntity="User", inversedBy="articles")
     * @JoinColumn(name="user_id", referencedColumnName="user_id")
     */
    private $user;
    
    /**
	 * Owning Side
	 *
	 * @ManyToMany(targetEntity="Tag", inversedBy="articles")
	 * @JoinTable(name="article_has_tag",
	 *      joinColumns={@JoinColumn(name="article_id", referencedColumnName="article_id")},
	 *      inverseJoinColumns={@JoinColumn(name="tag_id", referencedColumnName="tag_id")}
	 *      )
	 */
	private $tags;
    
    private $em;
    
    public function __construct()
    {
    
    	$ci =& get_instance();
		$this->em = $ci->doctrine->em;
		$this->qb = $this->em->createQueryBuilder();
		
        // constructor is never called by Doctrine
        $this->article_date_created = $this->article_last_modified = new \DateTime( "now" );
    }
    
    /**
     * @PrePersist @PreUpdate
     */    
    public function updated()
    {
        $this->article_last_modified = new \DateTime( "now" );
    }
    
    /** Setter **/
    public function setArticleDateCreated ( $article_date_created )
    {
    	$this->article_date_created = $article_date_created;
    }
    
    public function setArticleLastModified ( $article_last_modified)
    {
    	$this->article_last_modified = $article_last_modified;
    }
    
    public function setArticleTitle( $article_title )
    {
        $this->article_title = $article_title;
    }
    
    public function setArticleText( $article_text )
    {
        $this->article_text = $article_text;
    }
        
    /** Getter **/
    public function getArticleId()
    {
        return $this->article_id;
    }
    
    public function getArticleDateCreated()
    {
    	return $this->article_date_created;
    }
    
    public function getArticleLastModified()
    {
    	return $this->article_last_modified;
    }
    
    public function getArticleTitle()
    {
        return $this->article_title;
    }
    
    public function getArticleText()
    {
        return $this->article_text;
    }
    
    public function getArticleUser()
    {
    	return $this->user;
    }
    
    public function getArticleAuthor()
    {
    	$ci =& get_instance();
    	$name = $this->user->getUserFirstName() . ' ' . $this->user->getUserLastName();
    	
    	return '<a href="' . $ci->config->item('base_url') . "members/view/" . $this->user->getUserId() . '" title="' . $name . '">' . $name . '</a>';
    }
    
    public function getArticles()
    {
    	$this->qb->add('select', 'a')
    		->add('from', 'models\Article a');
    		
    	$query = $this->qb->getQuery();
    	
    	return $query->getResult();
    }
    
    public function getArticleTitleURL()
    {
    	$ci =& get_instance();
    	
    	$_title = $this->article_title;
    	
    	$_title = strtolower( trim( strip_tags( $_title ) ) );
        $_title = preg_replace('/[^a-z0-9-]/', '-', $_title);
        $_title = preg_replace('/-+/', "-", $_title);
        
        return $ci->config->item('base_url') . 'article/view/' . $this->getArticleId() . '/' . $str;
    }
    
    public function getArticleById($article_id)
    {
    	$article = $this->em->find('models\Article', $article_id);
    	
    	if ($article)
    	{
    		return $article;
    	}
    	
    	return false;
    }
    
    public function getArticleTags()
    {
    	return $this->tags;
    }
    
    public function getArticleLatestThree()
    {
    	$this->qb->add('select', 'a')
    		->add('from', 'models\Article a')
    		->add('orderBy', 'a.article_id DESC')
    		->setMaxResults( 3 );
    		
    	$query = $this->qb->getQuery();
    	
    	return $query->getResult();  
    }
}
