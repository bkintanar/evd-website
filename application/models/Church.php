<?php

/**
 *
 * Church Entity class
 *
 * @package    NaCl
 * @author     Bertrand Kintanar <bertrand.kintanar@gmail.com>
 * @version    $Id: Church.php 3 2011-07-16 03:43:26Z bertrand.kintanar@gmail.com $
 * @copyright  &copy; 2011 EVD1 Group
 *
 */
namespace models;

/**
 * @Entity
 * @Table(name="church")
 */
class Church {

    /**
     * @Id
     * @Column(type="integer", nullable=false)
     * @GeneratedValue(strategy="AUTO")
     */
    private $church_id;
    
    /**
     * @Column(type="datetime", nullable=true)
     */
    private $church_date_created;
    
    /**
     * @Column(type="datetime", nullable=false)
     */
    private $church_last_modified;
    
    /**
     * @Column(type="string", length=255, unique=true, nullable=false)
     */
    private $church_name;
    
    /**
     * @ManyToOne(targetEntity="Section", inversedBy="churches")
     * @JoinColumn(name="section_id", referencedColumnName="section_id")
     */
    private $section;
    
    /**
     * @OneToMany(targetEntity="PastorProfile", mappedBy="church")
     */
    private $pastor_profiles;
    
    public function __construct()
    {
        // constructor is never called by Doctrine
        $this->church_date_created = $this->church_last_modified = new \DateTime( "now" );
    }
    
    /**
     * @PrePersist @PreUpdate
     */    
    public function updated()
    {
        $this->church_last_modified = new \DateTime( "now" );
    }
    
    /** Setter **/
    public function setChurchDateCreated ( $church_date_created )
    {
    	$this->church_date_created = $church_date_created;
    }
    
    public function setChurchLastModified ( $church_last_modified)
    {
    	$this->church_last_modified = $church_last_modified;
    }
    
    public function setChurchName( $church_name )
    {
        $this->church_name = $church_name;
    }
        
    /** Getter **/
    public function getChurchId()
    {
        return $this->church_id;
    }
    
    public function getChurchDateCreated()
    {
    	return $this->church_date_created;
    }
    
    public function getChurchLastModified()
    {
    	return $this->church_last_modified;
    }
    
    public function getChurchName()
    {
        return $this->church_name;
    }
    
    public function getChurchSection()
    {
    	return $this->section;
    }
}
