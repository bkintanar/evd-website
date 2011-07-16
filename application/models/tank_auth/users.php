<?php if (!defined('BASEPATH')) exit('No direct script access allowed');

/**
 * Users
 *
 * This model represents user authentication data. It operates the following tables:
 * - user account data,
 * - user profiles
 *
 * @package	Tank_auth
 * @author	Ilya Konyukhov (http://konyukhov.com/soft/)
 */
class Users extends CI_Model
{
	private $table_name			= 'users';			// user accounts
	private $profile_table_name	= 'user_profiles';	// user profiles

    private $em;

	function __construct()
	{
		parent::__construct();

		$ci =& get_instance();
		//$this->table_name			= $ci->config->item('db_table_prefix', 'tank_auth').$this->table_name;
		//$this->profile_table_name	= $ci->config->item('db_table_prefix', 'tank_auth').$this->profile_table_name;
		
        $this->em = $ci->doctrine->em;
	}

	/**
	 * Get user record by Id
	 *
	 * @param	int
	 * @param	bool
	 * @return	object
	 */
	function get_user_by_id($user_id, $activated)
	{
		// Doctrine port
        $user = $this->em->getRepository( 'models\User' )->findOneBy( array( 'user_id' => $user_id, 'user_activated' => $activated ? 1 : 0 ) );

        if (!$user)
        {
            return NULL;
        }
		
		return $user;
	}

	/**
	 * Get user record by login (username or email)
	 *
	 * @param	string
	 * @return	object
	 */
	function get_user_by_login($login)
	{
		// Doctrine port
        $qb = $this->em->createQueryBuilder();
        
        $qb->add('select', 'u')
            ->add('from', 'models\User u')
            ->add('where', $qb->expr()->orx(
                $qb->expr()->eq('u.user_login', '?1'),
                $qb->expr()->eq('u.user_email', '?2')
            ))
            ->setParameters(array( 1=> $login, 2 => $login));
        
        $query = $qb->getQuery();
        $result = $query->getResult();

        if (count($result) != 1)
        {
            return NULL;
        }
		
		return $result[0];
	}

	/**
	 * Get user record by username
	 *
	 * @param	string
	 * @return	object
	 */
	function get_user_by_username($username)
	{
		// Doctrine port
        $user = $this->em->getRepository( 'models\User' )->findOneBy( array( 'user_login' => strtolower($username) ) );
        
        if (!$user)
        {
            return NULL;
        }
		
		return $user;
	}

	/**
	 * Get user record by email
	 *
	 * @param	string
	 * @return	object
	 */
	function get_user_by_email($email)
	{
		// Doctrine port
        $user = $this->em->getRepository( 'models\User' )->findOneBy( array( 'user_email' => strtolower($email) ) );

        if (!$user)
        {
            return NULL;
        }
		
		return $user;
	}

	/**
	 * Check if login available for registering
	 *
	 * @param	string
	 * @return	bool
	 */
	function is_login_available($user_login)
	{
		// Doctrine port
        $user = $this->em->getRepository( 'models\User' )->findOneBy( array( 'user_login' => strtolower($user_login) ) );
        
        if (!$user)
        {
            return true;
        }
		
		return false;
	}

	/**
	 * Check if email available for registering
	 *
	 * @param	string
	 * @return	bool
	 */
	function is_email_available($email)
	{
		// Doctrine port
        $qb = $this->em->createQueryBuilder();
        
        $qb->add('select', 'u')
            ->add('from', 'models\User u')
            ->add('where', $qb->expr()->orx(
                $qb->expr()->eq('u.user_email', '?1'),
                $qb->expr()->eq('u.user_new_email', '?2')
            ))
            ->setParameters(array( 1=> $email, 2 => $email));
        
        $query = $qb->getQuery();
        $user = $query->getResult();

        if (!$user)
        {
            return true;
        }
		
		return false;
	}

	/**
	 * Create new user record
	 *
	 * @param	array
	 * @param	bool
	 * @return	array
	 */
	function create_user($data, $activated = TRUE)
	{
		$user = new \models\User;
		
		$user->setUserLogin($data['username']);
		$user->setUserPassword($data['password']);
		$user->setUserEmail($data['email']);
		$user->setUserLastIp($data['last_ip']);
        $user->setUserActivated($activated ? 1 : 0);
        
        if (isset($data['new_email_key']))
        {
            $user->setUserNewEmailKey($data['new_email_key']);
        }
		
        $this->em->persist($user);
		
		$this->em->flush();
		
		return $user;
	}

	/**
	 * Activate user if activation key is valid.
	 * Can be called for not activated users only.
	 *
	 * @param	int
	 * @param	string
	 * @param	bool
	 * @return	bool
	 */
	function activate_user($user_id, $activation_key, $activate_by_email)
	{
		$query_filter = NULL;
		if ($activate_by_email)
		{
            $query_filter = array( 'user_id' => $user_id,  'user_new_email_key' => $activation_key );
		} 
		else 
		{
            $query_filter = array( 'user_id' => $user_id,  'user_new_password_key' => $activation_key );
		}
        
        $query_filter['user_activated'] = 0;
        
		$user = $this->em->getRepository( 'models\User' )->findOneBy( $query_filter );
                
        if ($user)
        {
        
            $user->setUserActivated(1);
            $user->setUserNewEmailKey(NULL);

            $this->create_profile($user_id);
            
            $this->em->flush();

			return TRUE;
		}
		return FALSE;
	}

	/**
	 * Purge table of non-activated users
	 *
	 * @param	int
	 * @return	void
	 */
	function purge_na($expire_period = 172800)
	{
        // TODO: Port to Doctrine
		//$this->db->where('activated', 0);
		//$this->db->where('UNIX_TIMESTAMP(created) <', time() - $expire_period);
		//$this->db->delete($this->table_name);
	}

	/**
	 * Delete user record
	 *
	 * @param	int
	 * @return	bool
	 */
	function delete_user($user_id)
	{
		$this->where('id', $user_id);
		$this->db->delete($this->table_name);
		if ($this->db->affected_rows() > 0) {
			$this->delete_profile($user_id);
			return TRUE;
		}
		return FALSE;
	}

	/**
	 * Set new password key for user.
	 * This key can be used for authentication when resetting user's password.
	 *
	 * @param	int
	 * @param	string
	 * @return	bool
	 */
	function set_password_key($user_id, $new_pass_key)
	{
        $user = $this->em->find('models\User', $user_id);
        $user->setUserNewPasswordKey($new_pass_key);
        $user->setUserNewPasswordRequested(new \DateTime("now"));
		
		$this->em->flush();
		
		return true;
	}

	/**
	 * Check if given password key is valid and user is authenticated.
	 *
	 * @param	int
	 * @param	string
	 * @param	int
	 * @return	void
	 */
	function can_reset_password($user_id, $new_pass_key, $expire_period = 900)
	{
        $user = $this->em->find('models\User', $user_id);
        
        if (!$user)
        {
            return FALSE;
        }

        if ($user->getUserNewPasswordKey() == $new_pass_key AND $user->getUserNewPasswordRequested()->format('U') > time() - $expire_period )
        {
            return TRUE;
        }
		
		return FALSE;
	}

	/**
	 * Change user password if password key is valid and user is authenticated.
	 *
	 * @param	int
	 * @param	string
	 * @param	string
	 * @param	int
	 * @return	bool
	 */
	function reset_password($user_id, $new_pass, $new_pass_key, $expire_period = 900)
	{
        $user = $this->em->find('models\User', $user_id);
        
        if (!$user)
        {
            return FALSE;
        }
        
        if ($user->getUserNewPasswordKey() == $new_pass_key AND $user->getUserNewPasswordRequested()->format('U') >= time() - $expire_period )
        {
            $user->setUserPassword($new_pass);
            $user->setUserNewPasswordKey(NULL);
            $user->setUserNewPasswordRequested(NULL);            
            
            $this->em->flush();
            
            return TRUE;
        }
        
        return FALSE;
	}

	/**
	 * Change user password
	 *
	 * @param	int
	 * @param	string
	 * @return	bool
	 */
	function change_password($user_id, $new_pass)
	{
		$user = $this->em->find('models\User', $user_id);

        $user->setUserPassword($new_pass);
        
        $this->em->flush();
        
        return true;
	}

	/**
	 * Set new email for user (may be activated or not).
	 * The new email cannot be used for login or notification before it is activated.
	 *
	 * @param	int
	 * @param	string
	 * @param	string
	 * @param	bool
	 * @return	bool
	 */
	function set_new_email($user_id, $new_email, $new_email_key, $activated)
	{
        $user = $this->em->getRepository( 'models\User' )->findOneBy( array( 'user_id' => $user_id, 'user_activated' => $activated ? 1 : 0 ) );

        if (!$user)
        {
            return FALSE;
        }

		if ($activated)
		{
            $user->setUserNewEmail($new_email);
		}
		else
		{
            $user->setUserEmail($new_email);
		}
		
		$user->setUserNewEmailKey($new_email_key);

		$this->em->flush();
		
		return TRUE;
	}

	/**
	 * Activate new email (replace old email with new one) if activation key is valid.
	 *
	 * @param	int
	 * @param	string
	 * @return	bool
	 */
	function activate_new_email($user_id, $new_email_key)
	{
        $user = $this->em->getRepository( 'models\User' )->findOneBy( array( 'user_id' => $user_id, 'user_new_email_key' => $new_email_key ) );

        if (!$user)
        {
            return FALSE;
        }
        
        $user->setUserEmail($user->getUserNewEmail());
        $user->setUserNewEmail(NULL);
        $user->setUserNewEmailKey(NULL);
        
        $this->em->flush();
        
        return TRUE;
	}

	/**
	 * Update user login info, such as IP-address or login time, and
	 * clear previously generated (but not activated) passwords.
	 *
	 * @param	int
	 * @param	bool
	 * @param	bool
	 * @return	void
	 */
	function update_login_info($user_id, $record_ip, $record_time)
	{
		$user = $this->em->find('models\User', $user_id);
        $user->setUserNewPasswordKey(NULL);
        $user->setUserNewPasswordRequested(NULL);
        
        if ($record_ip)
        {
            $user->setUserLastIp($this->input->ip_address());
        }
        
        if ($record_time)
        {
            $user->setUserLastLogin(new \DateTime("now"));
        }

		$this->em->flush();
	}

	/**
	 * Ban user
	 *
	 * @param	int
	 * @param	string
	 * @return	void
	 */
	function ban_user($user_id, $reason = NULL)
	{
		$user = $this->em->find('models\User', $user_id);
        
        $user->setUserBanned(1);
        $user->setUserBanReason($reason);
		
		$this->em->flush();
	}

	/**
	 * Unban user
	 *
	 * @param	int
	 * @return	void
	 */
	function unban_user($user_id)
	{
		$user = $this->em->find('models\User', $user_id);
        
        $user->setUserBanned(0);
        $user->setUserBanReason(NULL);
		
		$this->em->flush();
	}

	/**
	 * Create an empty profile for a new user
	 *
	 * @param	int
	 * @return	bool
	 */
	private function create_profile($user_id)
	{
        $user = $this->em->find('models\User', $user_id);
        $user_profile = new \models\UserProfile;
        
        $user_profile->setUser($user);
        
        $this->em->persist($user_profile);
        $this->em->flush();
	}

	/**
	 * Delete user profile
	 *
	 * @param	int
	 * @return	void
	 */
	private function delete_profile($user_id)
	{
        $user_profile = $this->em->getRepository( 'models\UserProfile' )->findOneBy( array( 'user_id' => $user_id ) );

		$this->em->remove($user_profile);
	}
}

/* End of file users.php */
/* Location: ./application/models/auth/users.php */