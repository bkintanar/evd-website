<?php if (!defined('BASEPATH')) exit('No direct script access allowed');
 
use Doctrine\Common\ClassLoader,
    Doctrine\ORM\Configuration,
    Doctrine\ORM\EntityManager,
    Doctrine\Common\Cache\ArrayCache,
    Doctrine\DBAL\Logging\EchoSqlLogger;
 
class Doctrine {

    public $em = null;
    
    public function __construct()
    {
        // load database configuration from CodeIgniter
        require_once APPPATH.'config/database.php';
        // Set up class loading. You could use different autoloaders, provided by your favorite framework, if you want to.
        require_once APPPATH.'third_party/Doctrine/Common/ClassLoader.php';
        
        $doctrineClassLoader = new ClassLoader('Doctrine',  APPPATH.'third_party');
        $doctrineClassLoader->register();
        $entitiesClassLoader = new ClassLoader('models', rtrim(APPPATH, '/'));
        $entitiesClassLoader->register();
        $proxiesClassLoader = new ClassLoader('Proxies', APPPATH.'models/proxies');
        $proxiesClassLoader->register();
        
        // Set up caches
        $config = new Configuration;
        $cache = new ArrayCache;
        $config->setMetadataCacheImpl($cache);
        $config->setQueryCacheImpl($cache);
        
        // Set up driver
        \Doctrine\Common\Annotations\AnnotationRegistry::registerFile(APPPATH.'/third_party/Doctrine/ORM/Mapping/Driver/DoctrineAnnotations.php');
		$Doctrine_AnnotationReader = new \Doctrine\Common\Annotations\AnnotationReader();
        $Doctrine_AnnotationReader->setDefaultAnnotationNamespace('Doctrine\ORM\Mapping\\');
        $Doctrine_AnnotationReader->setIgnoreNotImportedAnnotations(true);
    	$Doctrine_AnnotationReader->setEnableParsePhpImports(false);
    	$Doctrine_AnnotationReader = new \Doctrine\Common\Annotations\CachedReader(
        	new \Doctrine\Common\Annotations\IndexedReader($Doctrine_AnnotationReader), new ArrayCache()
    	);
    	$driver = new \Doctrine\ORM\Mapping\Driver\AnnotationDriver($Doctrine_AnnotationReader, APPPATH.'models');
        $config->setMetadataDriverImpl($driver);
        
        // Proxy configuration
        $config->setProxyDir(APPPATH.'/models/proxies');
        $config->setProxyNamespace('Proxies');
        
        // Set up logger
        //$logger = new EchoSqlLogger;
        //$config->setSqlLogger($logger);
        
        $config->setAutoGenerateProxyClasses( TRUE );
        
        // Database connection information
        $connectionOptions = array(
            'driver'   => 'pdo_mysql',
            'user'     => $db['default']['username'],
            'password' => $db['default']['password'],
            'host'     => $db['default']['hostname'],
            'dbname'   => $db['default']['database']
        );
        
        // Create EntityManager
        $this->em = EntityManager::create($connectionOptions, $config);
    }
}