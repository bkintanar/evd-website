<?php

/**
 *
 * Section Entity class
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
 * @Table(name="section")
 */
class Section {

    /**
     * @Id
     * @Column(type="integer", nullable=false)
     * @GeneratedValue(strategy="AUTO")
     */
    private $section_id;
    
    /**
     * @Column(type="datetime", nullable=true)
     */
    private $section_date_created;
    
    /**
     * @Column(type="datetime", nullable=false)
     */
    private $section_last_modified;
    
    /**
     * @Column(type="string", length=255, unique=true, nullable=false)
     */
    private $section_name;
    
    /**
     * @OneToOne(targetEntity="PastorProfile", mappedBy="section")
     */
    private $pastor_profile;
    
    /**
     * @OneToMany(targetEntity="Church", mappedBy="section")
     */
    private $churches;
    
    /**
     * @Column(type="integer", nullable=false)
     */
    private $district_id;
    
    public function __construct()
    {
        // constructor is never called by Doctrine
        $this->section_date_created = $this->section_last_modified = new \DateTime( "now" );
    }
    
    /**
     * @PrePersist @PreUpdate
     */    
    public function updated()
    {
        $this->section_last_modified = new \DateTime( "now" );
    }
    
    /** Setter **/
    public function setSectionDateCreated ( $section_date_created )
    {
    	$this->section_date_created = $section_date_created;
    }
    
    public function setSectionLastModified ( $section_last_modified)
    {
    	$this->section_last_modified = $section_last_modified;
    }
    
    public function setSectionName( $section_name )
    {
        $this->section_name = $section_name;
    }
        
    /** Getter **/
    public function getSectionId()
    {
        return $this->section_id;
    }
    
    public function getSectionDateCreated()
    {
    	return $this->section_date_created;
    }
    
    public function getSectionLastModified()
    {
    	return $this->section_last_modified;
    }
    
    public function getSectionName()
    {
        return $this->section_name;
    }

    public function getSectionPresbyter()
    {
        return $this->pastor_profile;
    }
    
    public function getSectionPresbyterName()
    {
    	return $this->pastor_profile->getPastorProfileName();
    }
    
    public function getSectionPresbyterNameWithTitle()
    {
    	return $this->pastor_profile->getPastorProfileNameWithTitle();
    }
}
