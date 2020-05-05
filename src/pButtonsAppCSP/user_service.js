'use strict';


App.factory('Profile', ['$resource', function ($resource) {
	//$resource() function returns an object of resource class
	
	
    return $resource(
    		'/pButtons/profileMgmt', 
			{name:'@Name',description:'@Desc',interval:'@Interval',count:'@SamplesNum'},
			{ 
                'get':      {method:'GET',     url:'/pButtons/profileMgmt/:name'},
                'save':     {method:'POST',     url:'/pButtons/profileMgmt/:name/:description/:interval/:count'},
                'update':   {method:'PUT',      url:'/pButtons/profileMgmt/:name/:description/:interval/:count'},
                'query':    {method:'GET',  isArray:true},
                'remove':   {method:'DELETE',   url:'/pButtons/profileMgmt/:name'},
                'copy':     {method:'POST',     url:'/pButtons/profileMgmtCopy/:name/:newName',params:{name:'@Name',newName:'@newName'}},
                'run':      {method:'POST',     url:'/pButtons/runMgmt/:name/1'},
			    'delete':   {method:'DELETE',   url:'/pButtons/profileMgmt/:name'} }
    		
			
        
    );
}]);

App.factory('CurrentRun', ['$resource', function ($resource) {
	//$resource() function returns an object of resource class
	
	
    return $resource(
    		'/pButtons/runMgmt', 
			{runId:'@RunId'},
			
  {'query':  {method:'GET', isArray:true}, 
  'stop':  {method:'DELETE',url:'/pButtons/runMgmt/:runId'},
  'preview':  {method:'PUT',url:'/pButtons/runMgmt/:runId'}
  
   }
    		
			/*
			<Route Url="/runMgmt/:runId" Method="DELETE" Call="StopRun" Cors="true"/>
<Route Url="/runMgmt/:runId/:delete" Method="DELETE" Call="StopRun" Cors="true"/>
<Route Url="/runMgmt/:runId" Method="PUT" Call="CreatePreviewReport" Cors="true"/>
			*/
        
    );
}]);

App.factory('PreviousRun', ['$resource', function ($resource) {
	//$resource() function returns an object of resource class
	
	
    return $resource(
    		'/pButtons/runMgmtPrevious', 
			null,
			
  {'query':  {method:'GET', isArray:true}, //, headers: { 'Authorization': 'Basic U3VwZXIgVXNlcjpzeXM=' }},
   }
    		
			
        
    );
}]);

