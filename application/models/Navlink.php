<?php

/**
 *
 * Navlink Entity class
 *
 * @package    NaCl
 * @author     Bertrand Kintanar <bertrand.kintanar@gmail.com>
 * @version    $Id: Navlink.php 3 2011-07-16 03:43:26Z bertrand.kintanar@gmail.com $
 * @copyright  &copy; 2011 EVD1 Group
 *
 */
namespace models;

/**
 * @Entity
 * @Table(name="navlink")
 */
class Navlink {

    /**
     * @Id
     * @Column(type="integer", nullable=false)
     * @GeneratedValue(strategy="AUTO")
     */
    private $navlink_id;
    
    /**
     * @Column(type="datetime", nullable=true)
     */
    private $navlink_date_created;
    
    /**
     * @Column(type="datetime", nullable=false)
     */
    private $navlink_last_modified;
    
    /**
     * @Column(type="string", length=100, unique=true, nullable=false)
     */
    private $navlink_name;
    
    /**
     * @Column(type="string", length=1000, unique=false, nullable=true)
     */
    private $navlink_href;
    
    /**
     * @Column(type="integer", nullable=false)
     */
    private $navlink_parent_id;
    
    private $em;
    
    public function __construct()
    {
    
    	$ci =& get_instance();
		$this->em = $ci->doctrine->em;
		$this->qb = $this->em->createQueryBuilder();
		
        // constructor is never called by Doctrine
        $this->navlink_date_created = $this->navlink_last_modified = new \DateTime( "now" );
    }
    
    /**
     * @PrePersist @PreUpdate
     */    
    public function updated()
    {
        $this->navlink_last_modified = new \DateTime( "now" );
    }
    
    /** Setter **/
    public function setNavlinkDateCreated ( $navlink_date_created )
    {
    	$this->navlink_date_created = $navlink_date_created;
    }
    
    public function setNavlinkLastModified ( $navlink_last_modified)
    {
    	$this->navlink_last_modified = $navlink_last_modified;
    }
    
    public function setNavlinkName( $navlink_name )
    {
        $this->navlink_name = $navlink_name;
    }
    
    public function setNavlinkHref( $navlink_href )
    {
        $this->navlink_href = $navlink_href;
    }
        
    /** Getter **/
    public function getNavlinkId()
    {
        return $this->navlink_id;
    }
    
    public function getNavlinkDateCreated()
    {
    	return $this->navlink_date_created;
    }
    
    public function getNavlinkLastModified()
    {
    	return $this->navlink_last_modified;
    }
    
    public function getNavlinkName()
    {
        return $this->navlink_name;
    }
    
    public function getNavlinkHref()
    {
        return $this->navlink_href;
    }
    
    public function getNavlinks()
    {
    	$this->qb->add('select', 'n')
    		->add('from', 'models\Navlink n');
    		
    	$query = $this->qb->getQuery();
    	
    	return $query->getResult();    
    }
    
    public function getNavlinkParentLinks()
    {
    	$this->qb->add('select', 'n')
    		->add('from', 'models\Navlink n')
    		->add('where', 'n.navlink_parent_id = 0');
    	
    	$query = $this->qb->getQuery();
    	
    	return $query->getResult();
    }
    
    public function getNavlinkChildLinks($_navlink_id)
    {
    	$this->qb->add('select', 'n')
    		->add('from', 'models\Navlink n')
    		->add('where', "n.navlink_parent_id = $_navlink_id");
    	
    	$query = $this->qb->getQuery();
    	
    	return $query->getResult();
    }
    
    public function getNavlinkById($navlink_id)
    {
    	$navlink = $this->em->find('models\Navlink', $navlink_id);
    	
    	if ($navlink)
    	{
    		return $navlink;
    	}
    	
    	return false;
    }
    
    public function createNavlinks()
    {    	
    	$parent_links = $this->getNavlinkParentLinks();
    	
    	$html_link = '<div id="mainmenu"><ul id="nav" class="dropdown dropdown-horizontal">';
    	foreach ($parent_links as $pl)
    	{
   			$_navlink_id = $pl->getNavlinkId();
    		if ($pl->getNavlinkId() == 1)
    		{
    			$ci =& get_instance();
    			
    			$html_link .= "<li class=\"main\"><a href=\"". $ci->config->item('base_url') . "\">" . $pl->getNavlinkName() . "</a></li>";
    		}
    		else
    		{
    			$_child_links = $this->getNavlinkChildLinks($_navlink_id);
    			if (count($_child_links))
    			{
    				$html_link .= "<li class=\"dir\">";
    				if ($pl->getNavlinkHref())
    				{
    					$html_link .= "<a href=\"" . $ci->config->item('base_url') . $pl->getNavlinkHref() . "\">" . $pl->getNavlinkName() . "</a><ul>";    				
    				}
    				else
    				{
    					$html_link .= $pl->getNavlinkName() . "<ul>";
					}
					
    				foreach($_child_links as $cl)
    				{
    					$html_link .= "<li><a href=\"" . $ci->config->item('base_url') . $cl->getNavlinkHref() . "\">" . $cl->getNavlinkName() . "</a></li>";
    				}
    				$html_link .= "</ul></li>";
    			}
    			else
    			{
    				$html_link .= "<li><a href=\"" . $ci->config->item('base_url') . $pl->getNavlinkHref() . "\">" . $pl->getNavlinkName() . "</a></li>";
    			}
    		}
    	}
    	$html_link .= "</ul></div>";
    	
    	return $html_link;
    }
}
