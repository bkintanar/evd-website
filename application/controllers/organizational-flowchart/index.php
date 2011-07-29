<?php if (!defined('BASEPATH')) exit('No direct script access allowed');

/**
 *
 * base_url/organizational-flowchart
 *
 * @package    controllers
 * @author     Bertrand Kintanar <bertrand.kintanar@gmail.com>
 * @version    $Id$
 * @copyright  &copy; 2011 NaCl.org WebGroup
 *
 */
class Index extends MY_Controller {

    
    public function __construct()
    {
        parent::__construct();
        parent::_get_jscript(__FILE__);
    }
    
    public function index()
    {
    	$this->smarty->view("default.tpl", $data);
    }

}
