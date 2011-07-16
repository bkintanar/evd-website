<?php if (!defined('BASEPATH')) exit('No direct script access allowed');

require_once APPPATH."third_party/Smarty/Smarty.class.php";

class CI_Smarty extends Smarty {

    // Codeigniter instance
    protected $CI;

    public function __construct()
    {
        parent::__construct();

        // Store the Codeigniter super global instance... whatever
        $this->CI =& get_instance();

        $this->CI->load->config('smarty');

        $this->template_dir      = $this->CI->config->item('template_directory');
        $this->compile_dir       = $this->CI->config->item('compile_directory');
        $this->cache_dir         = $this->CI->config->item('cache_directory');
        $this->config_dir        = $this->CI->config->item('config_directory');
        $this->exception_handler = null;

        // Add all helpers to plugins_dir
        $helpers = glob(APPPATH . 'helpers/', GLOB_ONLYDIR | GLOB_MARK);
        
        foreach ($helpers as $helper)
        {
            $this->plugins_dir[] = $helper;
        }

        // Completely experimental, not even sure this will work
        if ( method_exists( $this, 'assignByRef') )
        {
            $this->assignByRef("this", $this->CI);
        }

    }
    
	function view($template, $data = array(), $return = FALSE)
	{
		if ( strpos($template, '.') === false )
		{
            $template .= '.tpl';
		}
		
		foreach ($data as $key => $val)
		{
			$this->assign($key, $val);
		}
		
		if ($return == FALSE)
		{
			$CI =& get_instance();
			$CI->output->set_output($this->fetch($template));
			return;
		}
		else
		{
			return $this->fetch($template);
		}
	}

}