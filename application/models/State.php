<?php

/**
 *
 * State Entity class
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
 * @Table(name="state")
 */
class State {

    /**
     * @Id
     * @Column(type="integer", nullable=false)
     * @GeneratedValue(strategy="AUTO")
     */
    private $state_id;
    
    /**
     * @Column(type="datetime", nullable=true)
     */
    private $state_date_created;
    
    /**
     * @Column(type="datetime", nullable=false)
     */
    private $state_last_modified;
    
    /**
     * @Column(type="string", length=255, unique=true, nullable=false)
     */
    private $state_name;
    
    /**
     * @ManyToOne(targetEntity="Country", inversedBy="states")
     * @JoinColumn(name="country_id", referencedColumnName="country_id")
     */
    private $country;
    
    /**
     * @Column(type="integer", nullable=false)
     */
    private $country_id;
    
    /**
     * @OneToMany(targetEntity="City", mappedBy="state")
     */
    private $cities;
    
    public function __construct()
    {
        // constructor is never called by Doctrine
        $this->state_date_created = $this->state_last_modified = new \DateTime( "now" );
    }
    
    /**
     * @PrePersist @PreUpdate
     */    
    public function updated()
    {
        $this->state_last_modified = new \DateTime( "now" );
    }
    
    /** Setter **/
    public function setStateDateCreated ( $state_date_created )
    {
    	$this->state_date_created = $state_date_created;
    }
    
    public function setStateLastModified ( $state_last_modified)
    {
    	$this->state_last_modified = $state_last_modified;
    }
    
    public function setStateName( $state_name )
    {
        $this->state_name = $state_name;
    }
        
    /** Getter **/
    public function getStateId()
    {
        return $this->state_id;
    }
    
    public function getStateDateCreated()
    {
    	return $this->state_date_created;
    }
    
    public function getStateLastModified()
    {
    	return $this->state_last_modified;
    }
    
    public function getStateName()
    {
        return $this->state_name;
    }
}
