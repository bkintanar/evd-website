<?php

/**
 *
 * Country Entity class
 *
 * @package    NaCl
 * @author     Bertrand Kintanar <bertrand.kintanar@gmail.com>
 * @version    $Id: Country.php 3 2011-07-16 03:43:26Z bertrand.kintanar@gmail.com $
 * @copyright  &copy; 2011 EVD1 Group
 *
 */
namespace models;

/**
 * @Entity
 * @Table(name="country")
 */
class Country {

    /**
     * @Id
     * @Column(type="integer", nullable=false)
     * @GeneratedValue(strategy="AUTO")
     */
    private $country_id;
    
    /**
     * @Column(type="datetime", nullable=true)
     */
    private $country_date_created;
    
    /**
     * @Column(type="datetime", nullable=false)
     */
    private $country_last_modified;
    
    /**
     * @Column(type="string", length=255, unique=true, nullable=false)
     */
    private $country_name;
    
    public function __construct()
    {
        // constructor is never called by Doctrine
        $this->country_date_created = $this->country_last_modified = new \DateTime( "now" );
    }
    
    /**
     * @OneToMany(targetEntity="State", mappedBy="country")
     */
    private $states;
    
    /**
     * @PrePersist @PreUpdate
     */    
    public function updated()
    {
        $this->country_last_modified = new \DateTime( "now" );
    }
    
    /** Setter **/
    public function setCountryDateCreated ( $country_date_created )
    {
    	$this->country_date_created = $country_date_created;
    }
    
    public function setCountryLastModified ( $country_last_modified)
    {
    	$this->country_last_modified = $country_last_modified;
    }
    
    public function setCountryName( $country_name )
    {
        $this->country_name = $country_name;
    }
        
    /** Getter **/
    public function getCountryId()
    {
        return $this->country_id;
    }
    
    public function getCountryDateCreated()
    {
    	return $this->country_date_created;
    }
    
    public function getCountryLastModified()
    {
    	return $this->country_last_modified;
    }
    
    public function getCountryName()
    {
        return $this->country_name;
    }
}
