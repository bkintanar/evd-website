<?php if (!defined('BASEPATH')) exit('No direct script access allowed');

/**
 *
 * base_url/auth
 *
 * @package    controllers
 * @author     Bertrand Kintanar <bertrand.kintanar@gmail.com>
 * @version    $Id$
 * @copyright  &copy; 2011 NaCl.org WebGroup
 *
 */
class Auth extends MY_Controller
{
    function __construct()
    {
        parent::__construct();
        parent::_get_jscript(__FILE__);

        $this->load->helper(array('form', 'url'));
        $this->load->library('security');
        $this->load->library('tank_auth');
        $this->lang->load('tank_auth');        
    }

    function index()
    {
        if ($message = $this->session->flashdata('message'))
        {
            $this->smarty->view('auth/general_message.tpl', array('message' => $message));
        } 
        else
        {
            redirect('/auth/login/');
        }
    }

    /**
     * Login user on the site
     *
     * @return void
     */
    function login()
    {
    	$this->smarty->assign('page_title', 'Login');
        
        // logged in
        if ($this->tank_auth->is_logged_in())
        {
            redirect('');

        }
        // logged in, not activated 
        elseif ($this->tank_auth->is_logged_in(FALSE))
        {
            redirect('/auth/send_again/');
        } 
        else 
        {
            $data['login_by_username'] = ($this->config->item('login_by_username', 'tank_auth') AND $this->config->item('use_username', 'tank_auth'));
            $data['login_by_email'] = $this->config->item('login_by_email', 'tank_auth');

            $this->form_validation->set_rules('login', 'Login', 'trim|required|xss_clean');
            $this->form_validation->set_rules('password', 'Password', 'trim|required|xss_clean');
            $this->form_validation->set_rules('remember', 'Remember me', 'integer');

            // Get login for counting attempts to login
            if ($this->config->item('login_count_attempts', 'tank_auth') AND ($login = $this->input->post('login'))) 
            {
                $login = $this->security->xss_clean($login);
            } 
            else
            {
                $login = '';
            }

            $data['use_recaptcha'] = $this->config->item('use_recaptcha', 'tank_auth');
            
            if ($this->tank_auth->is_max_login_attempts_exceeded($login))
            {
                if ($data['use_recaptcha'])
                {
                    $this->form_validation->set_rules('recaptcha_response_field', 'Confirmation Code', 'trim|xss_clean|required|callback__check_recaptcha');
                }
                else
                {
                    $this->form_validation->set_rules('captcha', 'Confirmation Code', 'trim|xss_clean|required|callback__check_captcha');
                }
            }
            $data['errors'] = array();

			// validation ok
            if ($this->form_validation->run())
            {
            	// success
                if ($this->tank_auth->login($this->form_validation->set_value('login'), $this->form_validation->set_value('password'), $this->form_validation->set_value('remember'), $data['login_by_username'], $data['login_by_email']))
                {
                    redirect('');

                }
                else
                {
                    $errors = $this->tank_auth->get_error_message();
                    
                    // banned user
                    if (isset($errors['banned']))
                    {
                        $this->_show_message($this->lang->line('auth_message_banned').' '.$errors['banned']);
                    }
                    // not activated user
                    elseif (isset($errors['not_activated']))
                    {
                        redirect('/auth/send_again/');
                    }
                    // fail
                    else
                    {
                        foreach ($errors as $k => $v)    $data['errors'][$k] = $this->lang->line($v);
                    }
                }
            }
            
            $data['show_captcha'] = FALSE;
            
            if ($this->tank_auth->is_max_login_attempts_exceeded($login))
            {
                $data['show_captcha'] = TRUE;
                
                if ($data['use_recaptcha'])
                {
                    $data['recaptcha_html'] = $this->_create_recaptcha();
                } 
                else
                {
                    $data['captcha_html'] = $this->_create_captcha();
                }
            }
            
            $this->smarty->view('auth/login_form.tpl', $data);
        }
    }

    /**
     * Logout user
     *
     * @return void
     */
    function logout()
    {
        $this->tank_auth->logout();

        $this->_show_message($this->lang->line('auth_message_logged_out'));
    }

    /**
     * Register user on the site
     *
     * @return void
     */
    function register()
    {
    	// logged in
        if ($this->tank_auth->is_logged_in())
        {
            redirect('');

        }
        // logged in, not activated
        elseif ($this->tank_auth->is_logged_in(FALSE))
        {
            redirect('/auth/send_again/');

        }
        // registration is off
        elseif (!$this->config->item('allow_registration', 'tank_auth'))
        {
            $this->_show_message($this->lang->line('auth_message_registration_disabled'));
        } 
        else
        {
            $use_username = $this->config->item('use_username', 'tank_auth');
            
            if ($use_username)
            {
                $this->form_validation->set_rules('username', 'Username', 'trim|required|xss_clean|min_length['.$this->config->item('username_min_length', 'tank_auth').']|max_length['.$this->config->item('username_max_length', 'tank_auth').']|alpha_dash');
            }
            
            $this->form_validation->set_rules('email', 'Email', 'trim|required|xss_clean|valid_email');
            $this->form_validation->set_rules('password', 'Password', 'trim|required|xss_clean|min_length['.$this->config->item('password_min_length', 'tank_auth').']|max_length['.$this->config->item('password_max_length', 'tank_auth').']|alpha_dash');
            $this->form_validation->set_rules('confirm_password', 'Confirm Password', 'trim|required|xss_clean|matches[password]');

            $captcha_registration = $this->config->item('captcha_registration', 'tank_auth');
            $use_recaptcha        = $this->config->item('use_recaptcha', 'tank_auth');
            
            if ($captcha_registration)
            {
                if ($use_recaptcha)
                {
                    $this->form_validation->set_rules('recaptcha_response_field', 'Confirmation Code', 'trim|xss_clean|required|callback__check_recaptcha');
                }
                else
                {
                    $this->form_validation->set_rules('captcha', 'Confirmation Code', 'trim|xss_clean|required|callback__check_captcha');
                }
            }
            
            $data['errors'] = array();

            $email_activation = $this->config->item('email_activation', 'tank_auth');
			
			// validation ok
            if ($this->form_validation->run())
            {
            	// success
                if (!is_null($data = $this->tank_auth->create_user($use_username ? $this->form_validation->set_value('username') : '', $this->form_validation->set_value('email'), $this->form_validation->set_value('password'), $email_activation)))
                {
                    $data['site_name'] = $this->config->item('website_name', 'tank_auth');
					
					// send "activate" email
                    if ($email_activation)
                    {
                        $data['activation_period'] = $this->config->item('email_activation_expire', 'tank_auth') / 3600;

                        $this->_send_email('activate', $data['email'], $data);

                        unset($data['password']); // Clear password (just for any case)

                        $this->_show_message($this->lang->line('auth_message_registration_completed_1'));
                    } 
                    else
                    {
                    	// send "welcome" email
                        if ($this->config->item('email_account_details', 'tank_auth'))
                        {
                            $this->_send_email('welcome', $data['email'], $data);
                        }
                        unset($data['password']); // Clear password (just for any case)

                        $this->_show_message($this->lang->line('auth_message_registration_completed_2').' '.anchor('/auth/login/', 'Login'));
                    }
                }
                else
                {
                    $errors = $this->tank_auth->get_error_message();
                    foreach ($errors as $k => $v)    $data['errors'][$k] = $this->lang->line($v);
                }
            }
            
            if ($captcha_registration)
            {
                if ($use_recaptcha)
                {
                    $data['recaptcha_html'] = $this->_create_recaptcha();
                }
                else
                {
                    $data['captcha_html'] = $this->_create_captcha();
                }
            }
            
            $data['use_username'] = $use_username;
            $data['captcha_registration'] = $captcha_registration;
            $data['use_recaptcha'] = $use_recaptcha;
            $this->smarty->view('auth/register_form.tpl', $data);
        }
    }

    /**
     * Send activation email again, to the same or new email address
     *
     * @return void
     */
    function send_again()
    {
    	// not logged in or activated
        if (!$this->tank_auth->is_logged_in(FALSE))
        {
            redirect('/auth/login/');
        }
        else
        {
            $this->form_validation->set_rules('email', 'Email', 'trim|required|xss_clean|valid_email');

            $data['errors'] = array();
			
			// validation ok
            if ($this->form_validation->run())
            {
            	// success
                if (!is_null($data = $this->tank_auth->change_email($this->form_validation->set_value('email'))))
                {
                    $data['site_name']         = $this->config->item('website_name', 'tank_auth');
                    $data['activation_period'] = $this->config->item('email_activation_expire', 'tank_auth') / 3600;

                    $this->_send_email('activate', $data['email'], $data);

                    $this->_show_message(sprintf($this->lang->line('auth_message_activation_email_sent'), $data['email']));
                }
                else
                {
                    $errors = $this->tank_auth->get_error_message();
                    foreach ($errors as $k => $v)    $data['errors'][$k] = $this->lang->line($v);
                }
            }
            
            $this->smarty->view('auth/send_again_form.tpl', $data);
        }
    }

    /**
     * Activate user account.
     * User is verified by user_id and authentication code in the URL.
     * Can be called by clicking on link in mail.
     *
     * @return void
     */
    function activate()
    {
        $user_id          = $this->uri->segment(3);
        $new_email_key    = $this->uri->segment(4);
        
        // Activate user
        // success
        if ($this->tank_auth->activate_user($user_id, $new_email_key))
        {
            $this->tank_auth->logout();
            $this->_show_message($this->lang->line('auth_message_activation_completed').' '.anchor('/auth/login/', 'Login'));

        }
        // fail
        else
        {
            $this->_show_message($this->lang->line('auth_message_activation_failed'));
        }
    }

    /**
     * Generate reset code (to change password) and send it to user
     *
     * @return void
     */
    function forgot_password()
    {
    	// logged in
        if ($this->tank_auth->is_logged_in())
        {
            redirect('');
        }
        // logged in, not activated
        elseif ($this->tank_auth->is_logged_in(FALSE))
        {
            redirect('/auth/send_again/');
        }
        else
        {
            $this->form_validation->set_rules('login', 'Email or login', 'trim|required|xss_clean');

            $data['errors'] = array();

			// validation ok
            if ($this->form_validation->run())
            {
                if (!is_null($data = $this->tank_auth->forgot_password($this->form_validation->set_value('login'))))
                {
                    $data['site_name'] = $this->config->item('website_name', 'tank_auth');

                    // Send email with password activation link
                    $this->_send_email('forgot_password', $data['email'], $data);

                    $this->_show_message($this->lang->line('auth_message_new_password_sent'));

                }
                else
                {
                    $errors = $this->tank_auth->get_error_message();
                    foreach ($errors as $k => $v)    $data['errors'][$k] = $this->lang->line($v);
                }
            }
            
            $this->smarty->view('auth/forgot_password_form.tpl', $data);
        }
    }

    /**
     * Replace user password (forgotten) with a new one (set by user).
     * User is verified by user_id and authentication code in the URL.
     * Can be called by clicking on link in mail.
     *
     * @return void
     */
    function reset_password()
    {
        $user_id         = $this->uri->segment(3);
        $new_pass_key    = $this->uri->segment(4);

        $this->form_validation->set_rules('new_password', 'New Password', 'trim|required|xss_clean|min_length['.$this->config->item('password_min_length', 'tank_auth').']|max_length['.$this->config->item('password_max_length', 'tank_auth').']|alpha_dash');
        $this->form_validation->set_rules('confirm_new_password', 'Confirm new Password', 'trim|required|xss_clean|matches[new_password]');

        $data['errors'] = array();

		// validation ok
        if ($this->form_validation->run())
        {
            // success
            if (!is_null($data = $this->tank_auth->reset_password($user_id, $new_pass_key, $this->form_validation->set_value('new_password'))))
            {

                $data['site_name'] = $this->config->item('website_name', 'tank_auth');

                // Send email with new password
                $this->_send_email('reset_password', $data['email'], $data);

                $this->_show_message($this->lang->line('auth_message_new_password_activated').' '.anchor('/auth/login/', 'Login'));

            }
            // fail
            else
            {
            	$this->_show_message($this->lang->line('auth_message_new_password_failed'));
            }
        }
        else
        {
            // Try to activate user by password key (if not activated yet)
            if ($this->config->item('email_activation', 'tank_auth'))
            {
                $this->tank_auth->activate_user($user_id, $new_pass_key, FALSE);
            }

            if (!$this->tank_auth->can_reset_password($user_id, $new_pass_key)) {
                $this->_show_message($this->lang->line('auth_message_new_password_failed'));
            }
        }
        
        $this->smarty->view('auth/reset_password_form.tpl', $data);
    }

    /**
     * Change user password
     *
     * @return void
     */
    function change_password()
    {
    	// not logged in or not activated
        if (!$this->tank_auth->is_logged_in())
        {
            redirect('/auth/login/');
        }
        else
        {
            $this->form_validation->set_rules('old_password', 'Old Password', 'trim|required|xss_clean');
            $this->form_validation->set_rules('new_password', 'New Password', 'trim|required|xss_clean|min_length['.$this->config->item('password_min_length', 'tank_auth').']|max_length['.$this->config->item('password_max_length', 'tank_auth').']|alpha_dash');
            $this->form_validation->set_rules('confirm_new_password', 'Confirm new Password', 'trim|required|xss_clean|matches[new_password]');

            $data['errors'] = array();

			// validation ok
            if ($this->form_validation->run())
            {
            	// success
                if ($this->tank_auth->change_password($this->form_validation->set_value('old_password'), $this->form_validation->set_value('new_password')))
                {
                    $this->_show_message($this->lang->line('auth_message_password_changed'));

                }
                // fail
                else
                {
                    $errors = $this->tank_auth->get_error_message();
                    foreach ($errors as $k => $v)    $data['errors'][$k] = $this->lang->line($v);
                }
            }
            $this->smarty->view('auth/change_password_form.tpl', $data);
        }
    }

    /**
     * Change user email
     *
     * @return void
     */
    function change_email()
    {
    	// not logged in or not activated
        if (!$this->tank_auth->is_logged_in())
        {
            redirect('/auth/login/');
        }
        else
        {
            $this->form_validation->set_rules('password', 'Password', 'trim|required|xss_clean');
            $this->form_validation->set_rules('email', 'Email', 'trim|required|xss_clean|valid_email');

            $data['errors'] = array();

			// validation ok
            if ($this->form_validation->run())
            {
            	// success
                if (!is_null($data = $this->tank_auth->set_new_email($this->form_validation->set_value('email'), $this->form_validation->set_value('password'))))
                {
                    $data['site_name'] = $this->config->item('website_name', 'tank_auth');

                    // Send email with new email address and its activation link
                    $this->_send_email('change_email', $data['new_email'], $data);

                    $this->_show_message(sprintf($this->lang->line('auth_message_new_email_sent'), $data['new_email']));

                }
                else
                {
                    $errors = $this->tank_auth->get_error_message();
                    foreach ($errors as $k => $v)    $data['errors'][$k] = $this->lang->line($v);
                }
            }
            
            $this->smarty->view('auth/change_email_form.tpl', $data);
        }
    }

    /**
     * Replace user email with a new one.
     * User is verified by user_id and authentication code in the URL.
     * Can be called by clicking on link in mail.
     *
     * @return void
     */
    function reset_email()
    {
        $user_id       = $this->uri->segment(3);
        $new_email_key = $this->uri->segment(4);

        // Reset email
        if ($this->tank_auth->activate_new_email($user_id, $new_email_key))
        {   
        	// success
            $this->tank_auth->logout();
            $this->_show_message($this->lang->line('auth_message_new_email_activated').' '.anchor('/auth/login/', 'Login'));

        }
        // fail
        else
        {
            $this->_show_message($this->lang->line('auth_message_new_email_failed'));
        }
    }

    /**
     * Delete user from the site (only when user is logged in)
     *
     * @return void
     */
    function unregister()
    {
    	// not logged in or not activated
        if (!$this->tank_auth->is_logged_in())
        {
            redirect('/auth/login/');
        }
        else
        {
            $this->form_validation->set_rules('password', 'Password', 'trim|required|xss_clean');

            $data['errors'] = array();

			// validation ok
            if ($this->form_validation->run())
            {
            	// success
                if ($this->tank_auth->delete_user($this->form_validation->set_value('password')))
                {
                    $this->_show_message($this->lang->line('auth_message_unregistered'));
                }
                // fail
                else
                {
                    $errors = $this->tank_auth->get_error_message();
                    foreach ($errors as $k => $v)    $data['errors'][$k] = $this->lang->line($v);
                }
            }
            $this->smarty->view('auth/unregister_form.tpl', $data);
        }
    }

    /**
     * Show info message
     *
     * @param    string
     * @return    void
     */
    function _show_message($message)
    {
        $this->session->set_flashdata('message', $message);
        redirect('/auth/');
    }

    /**
     * Send email message of given type (activate, forgot_password, etc.)
     *
     * @param    string
     * @param    string
     * @param    array
     * @return    void
     */
    function _send_email($type, $email, &$data)
    {
        $this->load->library('email');
        $this->email->from($this->config->item('webmaster_email', 'tank_auth'), $this->config->item('website_name', 'tank_auth'));
        $this->email->reply_to($this->config->item('webmaster_email', 'tank_auth'), $this->config->item('website_name', 'tank_auth'));
        $this->email->to($email);
        $this->email->subject(sprintf($this->lang->line('auth_subject_'.$type), $this->config->item('website_name', 'tank_auth')));
        $this->email->message($this->load->view('default/email/'.$type.'-html', $data, TRUE));
        $this->email->set_alt_message($this->load->view('default/email/'.$type.'-txt', $data, TRUE));
        $this->email->send();
        
        $this->email->print_debugger();
    }

    /**
     * Create CAPTCHA image to verify user as a human
     *
     * @return    string
     */
    function _create_captcha()
    {
        $this->load->helper('captcha');

        $cap = create_captcha(array(
            'img_path'   => './'.$this->config->item('captcha_path', 'tank_auth'),
            'img_url'    => base_url().$this->config->item('captcha_path', 'tank_auth'),
            'font_path'  => './'.$this->config->item('captcha_fonts_path', 'tank_auth'),
            'font_size'  => $this->config->item('captcha_font_size', 'tank_auth'),
            'img_width'  => $this->config->item('captcha_width', 'tank_auth'),
            'img_height' => $this->config->item('captcha_height', 'tank_auth'),
            'show_grid'  => $this->config->item('captcha_grid', 'tank_auth'),
            'expiration' => $this->config->item('captcha_expire', 'tank_auth'),
        ));

        // Save captcha params in session
        $this->session->set_flashdata(array(
            'captcha_word' => $cap['word'],
            'captcha_time' => $cap['time'],
        ));

        return $cap['image'];
    }

    /**
     * Callback function. Check if CAPTCHA test is passed.
     *
     * @param    string
     * @return    bool
     */
    function _check_captcha($code)
    {
        $time = $this->session->flashdata('captcha_time');
        $word = $this->session->flashdata('captcha_word');

        list($usec, $sec) = explode(" ", microtime());
        $now = ((float)$usec + (float)$sec);

        if ($now - $time > $this->config->item('captcha_expire', 'tank_auth'))
        {
            $this->form_validation->set_message('_check_captcha', $this->lang->line('auth_captcha_expired'));
            return FALSE;
        }
        elseif (($this->config->item('captcha_case_sensitive', 'tank_auth') AND $code != $word) OR strtolower($code) != strtolower($word))
        {
            $this->form_validation->set_message('_check_captcha', $this->lang->line('auth_incorrect_captcha'));
            return FALSE;
        }
        return TRUE;
    }

    /**
     * Create reCAPTCHA JS and non-JS HTML to verify user as a human
     *
     * @return    string
     */
    function _create_recaptcha()
    {
        $this->load->helper('recaptcha');

        // Add custom theme so we can get only image
        $options = "<script>var RecaptchaOptions = {theme: 'custom', custom_theme_widget: 'recaptcha_widget'};</script>\n";

        // Get reCAPTCHA JS and non-JS HTML
        $html = recaptcha_get_html($this->config->item('recaptcha_public_key', 'tank_auth'));

        return $options.$html;
    }

    /**
     * Callback function. Check if reCAPTCHA test is passed.
     *
     * @return    bool
     */
    function _check_recaptcha()
    {
        $this->load->helper('recaptcha');

        $resp = recaptcha_check_answer($this->config->item('recaptcha_private_key', 'tank_auth'),
                $_SERVER['REMOTE_ADDR'],
                $_POST['recaptcha_challenge_field'],
                $_POST['recaptcha_response_field']);

        if (!$resp->is_valid)
        {
            $this->form_validation->set_message('_check_recaptcha', $this->lang->line('auth_incorrect_captcha'));
            return FALSE;
        }
        return TRUE;
    }
    
    function process_login()
    {
        $a = explode('&', $this->input->post('login_form'));
        
        $i = 0;
        while ($i < count($a))
        {
            $b = explode('=', $a[$i]);
            
            $field[$b[0]] = $b[1];
            $i++;
        }
        
        // validate values for $fields   
    }

}

/* End of file auth.php */
/* Location: ./application/controllers/auth.php */