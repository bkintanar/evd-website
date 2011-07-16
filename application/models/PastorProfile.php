<?php

/**
 *
 * PastorProfile Entity class
 *
 * @package    NaCl
 * @author     Bertrand Kintanar <bertrand.kintanar@gmail.com>
 * @version    $Id$
 * @copyright  &copy; 2011 EVD1 Web Group
 *
 */
namespace models;

/**
 * @Entity
 * @Table(name="pastor_profile")
 */
class PastorProfile {

    /**
     * @Id
     * @Column(type="integer", nullable=false)
     * @GeneratedValue(strategy="AUTO")
     */
    private $pastor_profile_id;
    
    /**
     * @Column(type="datetime", nullable=true)
     */
    private $pastor_profile_date_created;
    
    /**
     * @Column(type="datetime", nullable=false)
     */
    private $pastor_profile_last_modified;
    
    /**
     * @Column(type="string", length=20, nullable=true)
     */
    private $pastor_profile_country;
    
    /**
     * @Column(type="string", length=255, nullable=true)
     */
    private $pastor_profile_website;
    
    /**
     * @Column(type="string", length=10, nullable=true)
     */
    private $pastor_profile_license;
    
    /**
     * @Column(type="string", length=10, nullable=true)
     */
    private $pastor_profile_title;
    
    /**
     * @OneToOne(targetEntity="User", inversedBy="pastor_profile")
     * @JoinColumn(name="user_id", referencedColumnName="user_id")
     */
    private $user;
    
    /**
     * @ManyToOne(targetEntity="Church", inversedBy="pastor_profiles")
     * @JoinColumn(name="church_id", referencedColumnName="church_id")
     */
    private $church;
    
    /**
     * @OneToOne(targetEntity="Section", inversedBy="pastor_profile")
     * @JoinColumn(name="pastor_profile_id", referencedColumnName="section_presbyter")
     */
    private $section;
    
    /**
     * @OneToOne(targetEntity="District", inversedBy="pastor_profile")
     * @JoinColumn(name="pastor_profile_id", referencedColumnName="district_presbyter")
     */
    private $district;
    
    public function __construct()
    {
        // constructor is never called by Doctrine
        $this->pastor_profile_date_created = $this->pastor_profile_last_modified = new \DateTime("now");
    }
    
    public function setUser($user)
    {
        $this->user = $user;
    }
    
    public function setChurch($church)
    {
    	$this->church = $church;
    }
    
    public function getUser()
    {
        return $this->user;
    }
    
    public function getChurch()
    {
        return $this->church;
    }
    
    public function getPastorProfileLicense()
    {
        return $this->pastor_profile_license;
    }
    
    public function getPastorProfileTitle()
    {
    	$title = array();
    	switch ($this->pastor_profile_title)
    	{
    		case 'pastor':
    			$title['name'] = 'Pastor';
    			$title['abbr'] = 'Ptr.';
    			break;
    			
    		case 'reverend':
    			$title['name'] = 'Reverend';
    			$title['abbr'] = 'Rev.';
    			break;
    	}
    	
    	return $title;
    }
    
    public function getPastorProfileName()
    {
    	$_user  = $this->getUser();
    	
    	return $_title['abbr'] . ' ' . $_user->getUserFirstname() . ' ' . $_user->getUserLastname();
    }
    
    public function getPastorProfileNameWithTitle()
    {
    	$_title = $this->getPastorProfileTitle();
    	$_user  = $this->getUser();
    	
    	return $_title['abbr'] . ' ' . $_user->getUserFirstname() . ' ' . $_user->getUserLastname();
    }
}