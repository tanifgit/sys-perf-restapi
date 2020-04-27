Include zpButtonsInc

Class zpButtons.API.BasicAPI
{

/// undocumented / unsupported
ClassMethod GetProfiles(profileName As %String = "", Output profiles As %DynamicArray) As %Status
{
#dim status As %Status = $$$OK
#dim ex As %Exception.SystemException

	Try {
		
		If (profileName'="") {
			Set profiles = {}
		
			Set profileData = $Get($$$pButtonsData("profile",profileName))
			
			If profileData="" {
				Set makeupResultString = "0^profile does not exist"
				Set profiles = ..GetResultObjFromString(makeupResultString)
			} Else {
				Set profiles.Name = profileName
				Set profiles.Desc = $ListGet(profileData,1)
				Set profiles.Interval = $ListGet(profileData,2)
				Set profiles.SamplesNum = $ListGet(profileData,3)
			}
		} Else {		
			Set profiles = []
		
		
			Set profileName = ""
			Set profileName = $Order($$$pButtonsData("profile",profileName))
			
			While (profileName'="") {
				Set profile = {}
				Set profile.Name = profileName
				
				// Sample: $$$pButtonsRoutine("profile","24hours")=$lb("24 hour run sampling every 10 seconds",10,8640)
				Set profileData = $Get($$$pButtonsData("profile",profileName))
				Set profile.Desc = $ListGet(profileData,1)
				Set profile.Interval = $ListGet(profileData,2)
				Set profile.SamplesNum = $ListGet(profileData,3)
				
				Do profiles.%Push(profile)
				
				Set profileName = $Order($$$pButtonsData("profile",profileName))
				
			}
		}
	} Catch ex {
		Set status = ex.AsStatus()	
	}
	
	Quit status
}

/// undocumented / unsupported
ClassMethod GetProfile(profileName As %String, Output profile As %DynamicObject) As %Status
{
#dim status As %Status = $$$OK
#dim ex As %Exception.SystemException

	Try {
		Set profile = {}
	
		Set profileData = $Get($$$pButtonsData("profile",profileName))
		
		If profileData="" {
			Set makeupResultString = "0^profile does not exist"
			Set profile = ..GetResultObjFromString(makeupResultString)
		} Else {
			Set profile.Name = profileName
			Set profile.Desc = $ListGet(profileData,1)
			Set profile.Interval = $ListGet(profileData,2)
			Set profile.SamplesNum = $ListGet(profileData,3)
		}		
		
	} Catch ex {
		Set status = ex.AsStatus()	
	}
	
	Quit status
}

/// undocumented / unsupported
ClassMethod GetPreviousRuns(Output runs As %DynamicArray) As %Status
{
#dim status As %Status = $$$OK
#dim ex As %Exception.SystemException

	Try {
		Set runs = []
		
		Set runId = ""
		Set runId = $Order($$$pButtonsData("history",runId))
		
		While (runId'="") {
			Set run = {}
			Set run.Id = runId
			
			// Sample: $$$pButtonsRoutine("history","20170516_152246_3mins")="64419,55671^c:\intersystems\ensemble20162\mgr\"
			
			Set runData = $Get($$$pButtonsData("history",runId))
			Set run.DateTime = $ZDateTime($Piece(runData,"^",1),3)
			Set run.Folder = $Piece(runData,"^",2)
			
			Set system = $Translate($system,":","_")
			Set fileReportName = run.Folder _ system _ "_" _ runId _ ".html"
			
			Set reportFileExists = ##class(%File).Exists(fileReportName)
			
			Set run.ReportFilename = fileReportName
			Set run.ReportFileExists = reportFileExists
			
			Do runs.%Push(run)
			
			Set runId = $Order($$$pButtonsData("history",runId))
			
		}
	} Catch ex {
		Set status = ex.AsStatus()	
	}
	
	Quit status
}

ClassMethod DeleteProfile(profileName As %String, Output result As %DynamicObject) As %Status
{
	#dim status As %Status = $$$OK
	#dim ex As %Exception.SystemException

	Try {
		Set result = {}
		
		Set returnCode = $$delprofile$$$pButtonsRoutine(profileName)
		
		// Sample error return code:
		//	0^no profile to delete
		Set result = ..GetResultObjFromString(returnCode)
	
	} Catch ex {
		Set status = ex.AsStatus()	
	}
	
	Quit status
}

ClassMethod RunProfile(profileName As %String, liteRun As %Boolean = 0, Output runInfo As %DynamicObject) As %Status
{
	#dim status As %Status = $$$OK
	#dim ex As %Exception.SystemException

	Try {
		Set runInfo = {}
		
		If 'liteRun {
			Set runId = $$run$$$pButtonsRoutine(profileName)
		} Else {
			Set runId = $$literun$$$pButtonsRoutine(profileName)
		}
		
		Set runInfo.RunId = runId
	
	} Catch ex {
		Set status = ex.AsStatus()	
	}
	
	Quit status
}

ClassMethod GetWaitTimeForRunId(runId As %String, Output waitInfo As %DynamicObject) As %Status
{
	#dim status As %Status = $$$OK
	#dim ex As %Exception.SystemException

	Try {
		Set waitInfo = {}
		
		Set returnCode = $$waittime$$$pButtonsRoutine(runId)
		
		If +returnCode>0 {
			Set waitInfo.WaitTime = returnCode
		} Else {
			// Sample error return code:
			//	-2^no such runid
			Set waitInfo = ..GetResultObjFromString(returnCode)
			
		}
			
		
	
	} Catch ex {
		Set status = ex.AsStatus()	
	}
	
	Quit status
}

/// undocumented / unsupported
ClassMethod GetWaitTimeForCurrentRuns(Output waitInfo As %DynamicArray) As %Status
{
	#dim status As %Status = $$$OK
	#dim ex As %Exception.SystemException

	Try {
		Set waitInfo = []
		
		// Need to supress Output 
		Set returnInfo = $$waittime$$$pButtonsRoutine()
		
		If +returnInfo>0 {
			Set runsCount = $Length(returnInfo,",")
			
			// sample: 20170716_151934_quick:2 minutes 13 seconds,20170716_151951_quick:2 minutes 30 seconds
			For runI = 1:1:runsCount {
				Set run = {}
				Set runInfo = $Piece(returnInfo,",",runI)
				
				Set run.RunId = $Piece(runInfo,":",1)
				Set run.WaitTime = $Piece(runInfo,":",2)
				
				Do waitInfo.%Push(run)
			}
			
		} Else {
			// Sample error return code:
			//	-1^nothing running
			Set waitInfo = ..GetResultObjFromString(returnInfo)
			If waitInfo.StatusCode = -1 { // nothing running
				Set waitInfo = []
			}	
		}
		
		
			
		
	
	} Catch ex {
		Set status = ex.AsStatus()	
	}
	
	Quit status
}

ClassMethod StopRun(runId As %String, deleteLogs As %Boolean = 1, Output stopInfo As %DynamicObject) As %Status
{
	#dim status As %Status = $$$OK
	#dim ex As %Exception.SystemException

	Try {
		Set stopInfo = {}
		
		Set returnData = $$Stop$$$pButtonsRoutine(runId,deleteLogs)
		
		/*
			1:2:3:4_1:2:3:4
			
			1. Number of jobs successfully stopped
			2. Number of jobs that failed to stop
			3. Number of files successfully deleted
			4. Number of files not deleted
		
		*/
		
		Set errorStatus = $Piece(returnData,"^",1)
		
		If errorStatus'=0 {
			Set stopInfo.OS = {}
			
			Set OSpart = $Piece(returnData,"_",1)
			
			Set stopInfo.OS.jobsStopped = $Piece(OSpart,":",1)
			Set stopInfo.OS.jobsNotStopped = $Piece(OSpart,":",2)
			Set stopInfo.OS.filesDeleted = $Piece(OSpart,":",3)
			Set stopInfo.OS.filesNotDeleted = $Piece(OSpart,":",4)
			
			Set stopInfo.Cache = {}
			
			Set CachePart = $Piece(returnData,"_",2)
			
			Set stopInfo.Cache.jobsStopped = $Piece(CachePart,":",1)
			Set stopInfo.Cache.jobsNotStopped = $Piece(CachePart,":",2)
			Set stopInfo.Cache.filesDeleted = $Piece(CachePart,":",3)
			Set stopInfo.Cache.filesNotDeleted = $Piece(CachePart,":",4)
			
		} Else {
			// Sample error return code:
			//	0^no such runid found
			//	0^runid already completed
			Set stopInfo = ..GetResultObjFromString(returnData)
			
		}
			
		
	
	} Catch ex {
		Set status = ex.AsStatus()	
	}
	
	Quit status
}

ClassMethod CopyProfile(profileName As %String, newProfileName As %String, Output result As %DynamicObject) As %Status
{
	#dim status As %Status = $$$OK
	#dim ex As %Exception.SystemException

	Try {
		Set result = {}
		
		Set returnCode = $$copyprofile$$$pButtonsRoutine(profileName,newProfileName)
		
		// Sample error return codes:
		//	0^source profile not found
		//	0^target profile exists

		Set result = ..GetResultObjFromString(returnCode)
	
	} Catch ex {
		Set status = ex.AsStatus()	
	}
	
	Quit status
}

ClassMethod GetVersion(Output version As %DynamicObject) As %Status
{
	#dim status As %Status = $$$OK
	#dim ex As %Exception.SystemException

	Try {
		Set version = {}
		
		Set version.Version = $$version$$$pButtonsRoutine
			
	} Catch ex {
		Set status = ex.AsStatus()	
	}
	
	Quit status
}

ClassMethod CreateProfilePerCount(profileName As %String = "", profileDescription As %String = "", interval As %String = "", count As %Integer = "", Output result As %DynamicObject) As %Status
{
	#dim status As %Status = $$$OK
	#dim ex As %Exception.SystemException

	Try {
		Set result = {}
		
		Set returnCode = $$addprofile$$$pButtonsRoutine(profileName,profileDescription,interval,count)
		
		// Sample error return codes:
		//	0^profile name exists already
		//	0^must specify a count value
		//	0^null profile name invalid
		
		Set result = ..GetResultObjFromString(returnCode)
	
	} Catch ex {
		Set status = ex.AsStatus()	
	}
	
	Quit status
}

ClassMethod EditProfile(profileName As %String = "", profileDescription As %String = "", interval As %String = "", count As %Integer = "", Output result As %DynamicObject) As %Status
{
	#dim status As %Status = $$$OK
	#dim ex As %Exception.SystemException

	Try {
		Set result = {}
		
		Set returnCode = $$editprofile$$$pButtonsRoutine(profileName,profileDescription,interval,count)
		
		// Sample error return codes:
		//	0^profile does not exist
		//	0^count property invalid
		//	0^interval property invalid
		
		Set result = ..GetResultObjFromString(returnCode)
	
	} Catch ex {
		Set status = ex.AsStatus()	
	}
	
	Quit status
}

ClassMethod CreateProfilePerDuration(duration As %String = "", interval As %String = "", Output result As %DynamicObject) As %Status
{
	#dim status As %Status = $$$OK
	#dim ex As %Exception.SystemException

	Try {
		Set result = {}
		
		Set returnCode = $$genprofile$$$pButtonsRoutine(duration,interval)
		
		// Sample error return codes:
		//	0^zero time duration
				
		Set result = ..GetResultObjFromString(returnCode)
			
	} Catch ex {
		Set status = ex.AsStatus()	
	}
	
	Quit status
}

ClassMethod CreatePreviewReport(runId As %String = "", Output result As %DynamicObject) As %Status
{
	#dim status As %Status = $$$OK
	#dim ex As %Exception.SystemException

	Try {
		Set result = {}
		
		Set returnCode = $$Preview$$$pButtonsRoutine(runId)
		
		// When ok will be:
		// 1^c:\intersystems\ensemble\mgr\server_ENSEMBLE_20170713_161211_quick_P1.html
		
		If $Piece(returnCode,"^",1)=1 {
			Set result.StatusCode = 1
			Set result.Path = $Piece(returnCode,"^",2)
		} Else {
			// Sample error return codes:
			//	0
			Set result = ..GetResultObjFromString(returnCode)
		}
				
			
	} Catch ex {
		Set status = ex.AsStatus()	
	}
	
	Quit status
}

ClassMethod SetLogFolder(folder As %String = "") As %Status
{
	#dim status As %Status = $$$OK
	#dim ex As %Exception.SystemException

	Try {
		
		Do setlogdir$$$pButtonsRoutine(folder,0 /* output */)		
			
	} Catch ex {
		Set status = ex.AsStatus()	
	}
	
	Quit status
}

ClassMethod ResetLogFolder() As %Status
{
	#dim status As %Status = $$$OK
	#dim ex As %Exception.SystemException

	Try {
		
		Do clrlogdir$$$pButtonsRoutine()		
			
	} Catch ex {
		Set status = ex.AsStatus()	
	}
	
	Quit status
}

/// undocumented / unsupported
ClassMethod GetLogFolder(Output folder As %DynamicObject) As %Status
{
	#dim status As %Status = $$$OK
	#dim ex As %Exception.SystemException

	Try {
		Set folder = {}
		
		Set folder.Name = $$getlogdir$$$pButtonsRoutine()		
			
	} Catch ex {
		Set status = ex.AsStatus()	
	}
	
	Quit status
}

ClassMethod GetResultObjFromString(resultString As %String = "") As %DynamicObject [ Private ]
{
	Set result = {}
	
	Set result.StatusCode = $Piece(resultString,"^",1)
	Set result.Message = $Piece(resultString,"^",2)
	
	Return result
}

}
