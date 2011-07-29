<?php

/**
 *
 * City Entity class
 *
 * @package    models
 * @author     Bertrand Kintanar <bertrand.kintanar@gmail.com>
 * @version    $Id$
 * @copyright  &copy; 2011 NaCl.org WebGroup
 *
 */
namespace models;

/**
 * @Entity
 * @Table(name="city")
 */
class City {

    /**
     * @Id
     * @Column(type="integer", nullable=false)
     * @GeneratedValue(strategy="AUTO")
     */
    private $city_id;
    
    /**
     * @Column(type="datetime", nullable=true)
     */
    private $city_date_created;
    
    /**
     * @Column(type="datetime", nullable=false)
     */
    private $city_last_modified;
    
    /**
     * @Column(type="string", length=255, unique=true, nullable=false)
     */
    private $city_name;
    
    /**
     * @ManyToOne(targetEntity="State", inversedBy="cities")
     * @JoinColumn(name="state_id", referencedColumnName="state_id")
     */
    private $state;
    
    /**
     * @Column(type="integer", nullable=false)
     */
    private $state_id;
    
    public function __construct()
    {
        // constructor is never called by Doctrine
        $this->city_date_created = $this->city_last_modified = new \DateTime( "now" );
    }
    
    /**
     * @PrePersist @PreUpdate
     */    
    public function updated()
    {
        $this->city_last_modified = new \DateTime( "now" );
    }
    
    /** Setter **/
    public function setCityDateCreated ( $city_date_created )
    {
    	$this->city_date_created = $city_date_created;
    }
    
    public function setCityLastModified ( $city_last_modified )
    {
    	$this->city_last_modified = $city_last_modified;
    }
    
    public function setCityName( $city_name )
    {
        $this->city_name = $city_name;
    }
        
    /** Getter **/
    public function getCityId()
    {
        return $this->city_id;
    }
    
    public function getCityDateCreated()
    {
    	return $this->city_date_created;
    }
    
    public function getCityLastModified()
    {
    	return $this->city_last_modified;
    }
    
    public function getCityName()
    {
        return $this->city_name;
    }
    
    public function getState()
    {
        return $this->state;
    }
}
