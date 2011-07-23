<?php

/**
 *
 * Tag Entity class
 *
 * @package    NaCl
 * @author     Bertrand Kintanar <bertrand.kintanar@gmail.com>
 * @version    $Id: Tag.php 3 2011-07-16 03:43:26Z bertrand.kintanar@gmail.com $
 * @copyright  &copy; 2011 EVD1 Group
 *
 */
namespace models;

/**
 * @Entity
 * @Table(name="tag")
 */
class Tag {

    /**
     * @Id
     * @Column(type="integer", nullable=false)
     * @GeneratedValue(strategy="AUTO")
     */
    private $tag_id;
    
    /**
     * @Column(type="datetime", nullable=true)
     */
    private $tag_date_created;
    
    /**
     * @Column(type="datetime", nullable=false)
     */
    private $tag_last_modified;
    
    /**
     * @Column(type="string", length=100, unique=true, nullable=true)
     */
    private $tag_name;
	
	/**
	 * Inverse Side
	 *
	 * @ManyToMany(targetEntity="Article", mappedBy="tags")
	 */
	private $articles;
    
    private $em;
    
    public function __construct()
    {
    
    	$ci =& get_instance();
		$this->em = $ci->doctrine->em;
		$this->qb = $this->em->createQueryBuilder();
		
        // constructor is never called by Doctrine
        $this->tag_date_created = $this->tag_last_modified = new \DateTime( "now" );
    }
    
    /**
     * @PrePersist @PreUpdate
     */    
    public function updated()
    {
        $this->tag_last_modified = new \DateTime( "now" );
    }
    
    /** Setter **/
    public function setTagDateCreated ( $tag_date_created )
    {
    	$this->tag_date_created = $tag_date_created;
    }
    
    public function setTagLastModified ( $tag_last_modified)
    {
    	$this->tag_last_modified = $tag_last_modified;
    }
    
    public function setTagTitle( $tag_name )
    {
        $this->tag_name = $tag_name;
    }
        
    /** Getter **/
    public function getTagId()
    {
        return $this->tag_id;
    }
    
    public function getTagDateCreated()
    {
    	return $this->tag_date_created;
    }
    
    public function getTagLastModified()
    {
    	return $this->tag_last_modified;
    }
    
    public function getTagName()
    {
        return $this->tag_name;
    }
    
    public function getTags()
    {
    	$this->qb->add('select', 't')
    		->add('from', 'models\Tag t');
    		
    	$query = $this->qb->getQuery();
    	
    	return $query->getResult();    
    }
    
    public function getTagById($tag_id)
    {
    	$tag = $this->em->find('models\Tag', $tag_id);
    	
    	if ($tag)
    	{
    		return $tag;
    	}
    	
    	return false;
    }
}
