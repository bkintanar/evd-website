<?php

/**
 *
 * District Entity class
 *
 * @package    NaCl
 * @author     Bertrand Kintanar <bertrand.kintanar@gmail.com>
 * @version    $Id$
 * @copyright  &copy; 2011 EVD1 Group
 *
 */
namespace models;

/**
 * @Entity
 * @Table(name="district")
 */
class District {

    /**
     * @Id
     * @Column(type="integer", nullable=false)
     * @GeneratedValue(strategy="AUTO")
     */
    private $district_id;
    
    /**
     * @Column(type="datetime", nullable=true)
     */
    private $district_date_created;
    
    /**
     * @Column(type="datetime", nullable=false)
     */
    private $district_last_modified;
    
    /**
     * @Column(type="string", length=255, unique=true, nullable=false)
     */
    private $district_name;
    
    /**
     * @OneToOne(targetEntity="PastorProfile", mappedBy="district")
     */
    private $pastor_profile;
    
    public function __construct()
    {
        // constructor is never called by Doctrine
        $this->district_date_created = $this->district_last_modified = new \DateTime( "now" );
    }
    
    /**
     * @PrePersist @PreUpdate
     */    
    public function updated()
    {
        $this->district_last_modified = new \DateTime( "now" );
    }
    
    /** Setter **/
    public function setDistrictDateCreated ( $district_date_created )
    {
    	$this->district_date_created = $district_date_created;
    }
    
    public function setDistrictLastModified ( $district_last_modified)
    {
    	$this->district_last_modified = $district_last_modified;
    }
    
    public function setDistrictName( $district_name )
    {
        $this->district_name = $district_name;
    }
        
    /** Getter **/
    public function getDistrictId()
    {
        return $this->district_id;
    }
    
    public function getDistrictDateCreated()
    {
    	return $this->district_date_created;
    }
    
    public function getDistrictLastModified()
    {
    	return $this->district_last_modified;
    }
    
    public function getDistrictName()
    {
        return $this->district_name;
    }

    public function getDistrictPresbyter()
    {
        return $this->pastor_profile;
    }
    
    public function getDistrictPresbyterName()
    {
    	return $this->pastor_profile->getPastorProfileName();
    }
    
    public function getDistrictPresbyterNameWithTitle()
    {
    	return $this->pastor_profile->getPastorProfileNameWithTitle();
    }
}
