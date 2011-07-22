<?php

/**
 *
 * User Entity class
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
 * @Table(name="user")
 */
class User {

    /**
     * @Id
     * @Column(type="integer", nullable=false)
     * @GeneratedValue(strategy="AUTO")
     */
    private $user_id;
    
    /**
     * @Column(type="datetime", nullable=true)
     */
    private $user_date_created;
    
    /**
     * @Column(type="datetime", nullable=false)
     */
    private $user_last_modified;
    
    /**
     * @Column(type="datetime", nullable=false)
     */
    private $user_last_login;
    
    /**
     * @Column(type="string", length=255, unique=true, nullable=false)
     */
    private $user_login;
 
    /**
     * @Column(type="string", length=40, nullable=false)
     */
    private $user_password;
 
    /**
     * @Column(type="string", length=100, nullable=false)
     */
    private $user_email;
 
    /**
     * @Column(type="integer", nullable=false)
     */
    private $user_activated;
 
    /**
     * @Column(type="integer", nullable=false)
     */
    private $user_banned;
 
    /**
     * @Column(type="string", length=255, nullable=true)
     */
    private $user_ban_reason;
 
    /**
     * @Column(type="string", length=50, nullable=true)
     */
    private $user_new_password_key;
 
    /**
     * @Column(type="datetime", nullable=true)
     */
    private $user_new_password_requested;
 
    /**
     * @Column(type="string", length=100, nullable=true)
     */
    private $user_new_email;
 
    /**
     * @Column(type="string", length=50, nullable=true)
     */
    private $user_new_email_key;
 
    /**
     * @Column(type="string", length=40, nullable=false)
     */
    private $user_last_ip;
    
    /**
     * @Column(type="string", length=255, nullable=false)
     */
    private $user_firstname;
    
    /**
     * @Column(type="string", length=255, nullable=true)
     */
    private $user_middlename;
    
    /**
     * @Column(type="string", length=255, nullable=false)
     */
    private $user_lastname;
    
    /**
     * @OneToOne(targetEntity="PastorProfile", mappedBy="user")
     */
    private $pastor_profile;
    
    private $em;
    
    public function __construct()
    {
    
    	$ci =& get_instance();
		$this->em = $ci->doctrine->em;
		$this->qb = $this->em->createQueryBuilder();
        
        // constructor is never called by Doctrine
        $this->user_last_login = $this->user_date_created = $this->user_last_modified = new \DateTime("now");
        $this->user_banned = 0;
        $this->user_firstname = "";
        $this->user_middlename = "";
        $this->user_lastname = "";
    }
    
    /**
     * @PrePersist @PreUpdate
     */
    public function updated()
    {
        $this->user_last_modified = new \DateTime("now");
    }
    
    /** Setters **/
    public function setUserLogin($user_login)
    {
        $this->user_login = $user_login;
    }
    
    public function setUserPassword($user_password)
    {
        $this->user_password = $user_password;
    }
    
    public function setUserFirstname($user_firstname)
    {
        $this->user_firstname = $user_firstname;
    }
    
    public function setUserMiddlename($user_middlename)
    {
        $this->user_middlename = $user_middlename;
    }
    
    public function setUserLastname($user_lastname)
    {
        $this->user_lastname = $user_lastname;
    }
    
    public function setUserActivated($user_activated)
    {
        $this->user_activated = $user_activated;
    }
    
    public function setUserNewEmailKey($user_new_email_key)
    {
        $this->user_new_email_key = $user_new_email_key;
    }
    
    public function setUserNewEmail($user_new_email)
    {
        $this->user_new_email = $user_new_email;
    }
    
    public function setUserEmail($user_email)
    {
        $this->user_email = $user_email;
    }
    
    public function setUserLastIp($user_last_ip)
    {
        $this->user_last_ip = $user_last_ip;
    }
    
    public function setUserLastLogin($user_last_login)
    {
        $this->user_last_login = $user_last_login;
    }
    
    public function setUserNewPasswordRequested($user_new_password_requested)
    {
        $this->user_new_password_requested = $user_new_password_requested;
    }
    
    public function setUserNewPasswordKey($user_new_password_key)
    {
        $this->user_new_password_key = $user_new_password_key;
    }
    
    public function setPastorProfile($pastor_profile)
    {
        $this->pastor_profile = $pastor_profile;
    }
    
    /** Getters **/
    public function getUserId()
    {
        return $this->user_id;
    }
    
    public function getUserLogin()
    {
        return $this->user_login;
    }
    
    public function getUserPassword()
    {
        return $this->user_password;
    }
    
    public function getUserFirstname()
    {
        return $this->user_firstname;
    }
    
    public function getUserMiddlename()
    {
        return $this->user_middlename;
    }
    
    public function getUserLastname()
    {
        return $this->user_lastname;
    }
    
    public function getUserActivated()
    {
        return $this->user_activated;
    }
    
    public function getProspectus()
    {
        return $this->prospectus;
    }
    
    public function getUserBanned()
    {
        return $this->user_banned;
    }
    
    public function getUserBanReason()
    {
        return $this->user_ban_reason;
    }
    
    public function getUserNewEmailKey()
    {
        return $this->user_new_email_key;
    }
    
    public function getUserNewEmail()
    {
        return $this->user_new_email;
    }
    
    public function getUserEmail()
    {
        return $this->user_email;
    }
    
    public function getUserNewPasswordKey()
    {
        return $this->user_new_password_key;
    }
    
    public function getUserNewPasswordRequested()
    {
        return $this->user_new_password_requested;
    }
    
    public function getPastorProfile()
    {
    	return $this->pastor_profile;
    }
    
    public function getUserLastLogin()
    {
    	return $this->user_last_login;
    }
    
    public function getPastorName()
    {    	
    	return $this->getUserFirstname() . ' ' . $this->getUserLastname();
    }
    
    public function getPastorNameWithTitle()
    {
    	return $this->getPastorProfile()->getPastorProfileNameWithTitle();
    }
    
    public function getUsers()
    {
    	$this->qb->add('select', 'u')
    		->add('from', 'models\User u')
    		->add('where', 'u.user_id != 1');
    		
    	$query = $this->qb->getQuery();
    	
    	return $query->getResult();
    }
}
