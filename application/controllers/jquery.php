<?php if (!defined('BASEPATH')) exit('No direct script access allowed');

class Jquery extends MY_Controller {
    
    public function __construct()
    {
        parent::__construct();
        parent::_get_jscript(__FILE__);
    }

    public function index()
    {
    
        $subject_objs = $this->em->getRepository( 'models\Subject' )->findBy( array( 'prospectus_id' => 1 ) );
        
        $d = array();
        foreach ($subject_objs as $s)
        {
            $json = array();
            $json['value'] = $s->getSubjectId();
            $json['name'] = $s->getSubjectInfo()->getSubjectInfoCode() . " - " . htmlentities($s->getSubjectInfo()->getSubjectInfoName());
            
            $d[] = $json;
        }
        asort($d);
        
        $js_script = '$(document).ready(function() {
            var data = {items: ' . json_encode($d) . '};
            
            $(function() {
                $("input[type=text]").autoSuggest(data.items, {selectedItemProp: "name", searchObjProps: "name", asHtmlID: "my-as", retrieveLimit: "10", minChars: "1"});
            });
        });';
        
        $this->smarty->assign('js_script', $js_script);
        $this->smarty->assign('js', true);
        $this->smarty->assign('page_title', 'jQuery Test Pagse');
        
        $this->smarty->view("jquery.tpl");
    }
}