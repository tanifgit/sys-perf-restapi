'use strict';

App.controller('ProfileController', ['$scope', '$rootScope','Profile', function($scope, $rootScope,Profile) {
          var self = this;
          self.profile= new Profile();
          
          self.profiles=[];
              
          self.fetchAllProfiles = function(){
        	  self.profiles = Profile.query();
          };
           
          self.createProfile = function(){
        	  self.profile.$save(function(){
        		  //self.fetchAllProfiles();
        		  $rootScope.$broadcast('refreshAll', '');
        	  });
          };
		  
          self.updateProfile = function(){
        	  self.profile.$update(function(){
    			  //self.fetchAllProfiles();
    			  $rootScope.$broadcast('refreshAll', '');
    		  });
          };
          
          
         self.deleteProfile = function(name){
        	 var profile = Profile.get({Name:name}, function() {
        		  profile.$delete(function(){
        			  console.log('Deleting profile with name ', name);
        			  //self.fetchAllProfiles();
        			  $rootScope.$broadcast('refreshAll', '');
        		  });
        	 });
          };
          
          self.runProfile = function(name){
        	 var profile = Profile.get({Name:name}, function() {
        		  profile.$run(function(){
        			  console.log('Running profile with name ', name);
        			  //self.fetchAllProfiles();
        		  });
        	 });
          };
          
          self.copyProfile = function(name){
	          
        	 var profile = Profile.get({Name:name}, function() {
	        	 profile.newName = "CopyOf"+name;
        		  profile.$copy(function(){
        			  console.log('copying profile with name ', name);
        			  //self.fetchAllProfiles();
        			  $rootScope.$broadcast('refreshAll', '');
        		  });
        	 });
          };

          self.fetchAllProfiles();

          self.submit = function() {
	         
              if(!$scope.existingProfile){
                  console.log('Saving New Profile', self.profile);    
                  self.createProfile();
              }else{
    			  console.log('Updating profile with id ', self.profile.Name);
                  self.updateProfile();
                  console.log('Profile updated with id ', self.profile.Name);
              }
              self.reset();
          };
              
          self.edit = function(name){
			  $scope.existingProfile=true;
              console.log('name to be edited', name);
              for(var i = 0; i < self.profiles.length; i++){
                  if(self.profiles[i].Name === name) {
                     self.profile = angular.copy(self.profiles[i]);
                     break;
                  }
              }
               $scope.myForm.$setDirty();
          };
          
          self.copy = function(name){
              console.log('name to be copied', name);
              
              self.copyProfile(name);
          };
          
          self.run = function(name){
              console.log('name to run', name);
              
              self.runProfile(name);
              
               $rootScope.$broadcast('refreshCurrent', '');
               $rootScope.$broadcast('refreshPrevious', '');
               $rootScope.$broadcast('refreshClock', '');
          };

              
          self.remove = function(name){
              console.log('name to be deleted', name);
              if(self.profile.Name === name) {//If it is the one shown on screen, reset screen
                 self.reset();
              }
              self.deleteProfile(name);
          };

          
          self.reset = function(){
	          $scope.existingProfile=false;
              self.profile= new Profile();
              $scope.myForm.$setPristine(); //reset Form
          };

      }]);
      
  App.controller('CurrentRunController', ['$scope', '$rootScope','CurrentRun', function($scope, $rootScope,CurrentRun) {
          var self = this;
          self.currentRun= new CurrentRun();
          
          self.currentRuns=[];
              
          self.fetchAllCurrentRuns = function(){
        	  self.currentRuns = CurrentRun.query();
          };
           
          self.fetchAllCurrentRuns();
          
          $scope.$on('refreshCurrent', function(message){
        	self.fetchAllCurrentRuns();
     	  });
     	  
     	  self.stop = function(runId){
              console.log('runId to stop', runId);
              
              self.stopRun(runId);
                            
              self.fetchAllCurrentRuns();
              
           };
           
           self.stopRun = function(runId){
        	 	var currentRun = new CurrentRun();
        	 	currentRun.RunId = runId;
        		  currentRun.$stop(function(){
        			  console.log('Stopping runId with runId ', runId);
        			  //self.fetchAllProfiles();
        		  });
        	
          };
          
          self.preview = function(runId){
              console.log('runId to preview', runId);
              
              self.previewRun(runId);
                            
                           
           };
           
           self.previewRun = function(runId){
        	 	var currentRun = new CurrentRun();
        	 	currentRun.RunId = runId;
        		  currentRun.$preview(function(){
        			  console.log('Previewing runId with runId ', runId);
        			  //self.fetchAllProfiles();
        		  });
        	
          };
          
          

      }]);
      
  App.controller('PrevRunController', ['$scope', '$rootScope','PreviousRun', function($scope, $rootScope,PreviousRun) {
          var self = this;
          self.previousRun= new PreviousRun();
          
          self.previousRuns=[];
              
          self.fetchAllPreviousRuns = function(){
        	  self.previousRuns = PreviousRun.query();
          };
           
          self.fetchAllPreviousRuns();
          
          $scope.$on('refreshPrevious', function(message){
        	self.fetchAllPreviousRuns();
     	  });

      }]);

App.controller('RefreshController', ['$scope', '$rootScope', function($scope, $rootScope) {
          
          $scope.date = new Date();
          
          $scope.refreshPage = function(name) {
    		console.log('Refresh...');
    		$rootScope.$broadcast('refreshCurrent', '')
    		$rootScope.$broadcast('refreshPrevious', '')
    		$scope.date = new Date();
		};
		
		$scope.$on('refreshClock', function(message){
        	$scope.date = new Date();
     	  });
     	  
     	  $scope.$on('refreshAll', function(message){
        	console.log('Refresh...');
    		$rootScope.$broadcast('refreshCurrent', '')
    		$rootScope.$broadcast('refreshPrevious', '')
    		$scope.date = new Date();
     	  });
		
		


      }]);
