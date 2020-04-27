Class zpButtons.API.RESTAPI Extends %CSP.REST
{

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>

<Route Url="/profileMgmt/:name/:description/:interval/:count" Method="POST" Call="CreateProfilePerCount" Cors="true"/>
<Route Url="/profileMgmt/:duration/:interval" Method="POST" Call="CreateProfilePerDuration" Cors="true"/>
<Route Url="/profileMgmt/:name/:description/:interval/:count" Method="PUT" Call="EditProfile" Cors="true"/>
<Route Url="/profileMgmt/:name" Method="DELETE" Call="DeleteProfile" Cors="true"/>
<Route Url="/profileMgmt/:name" Method="GET" Call="GetProfiles" Cors="true"/>
<Route Url="/profileMgmt" Method="GET" Call="GetProfiles" Cors="true"/>
<Route Url="/profileMgmtCopy/:name/:newName" Method="POST" Call="CopyProfile" Cors="true"/>

<Route Url="/runMgmt/:profile" Method="POST" Call="RunProfile" Cors="true"/>
<Route Url="/runMgmt/:profile/:liteRun" Method="POST" Call="RunProfile" Cors="true"/>
<Route Url="/runMgmt" Method="GET" Call="GetWaitTimeForCurrentRuns" Cors="true"/>
<Route Url="/runMgmt/:runId" Method="GET" Call="GetWaitTimeForRunId" Cors="true"/>
<Route Url="/runMgmt/:runId" Method="DELETE" Call="StopRun" Cors="true"/>
<Route Url="/runMgmt/:runId/:delete" Method="DELETE" Call="StopRun" Cors="true"/>
<Route Url="/runMgmt/:runId" Method="PUT" Call="CreatePreviewReport" Cors="true"/>

<Route Url="/runMgmtPrevious" Method="GET" Call="GetPreviousRuns" Cors="true"/>

<Route Url="/generalMgmt/logFolder" Method="GET" Call="GetLogFolder" Cors="true"/>
<Route Url="/generalMgmt/logFolder" Method="PUT" Call="SetLogFolder" Cors="true"/>
<Route Url="/generalMgmt/logFolder" Method="POST" Call="ResetLogFolder" Cors="true"/>
<Route Url="/generalMgmt/version" Method="GET" Call="GetVersion" Cors="true"/>



</Routes>
}

ClassMethod CreateProfilePerCount(name, description, interval, count) As %Status
{
#dim status As %Status = $$$OK
#dim ex As %Exception.SystemException

	Try {
		
		Set status = ##class(zpButtons.API.BasicAPI).CreateProfilePerCount(name,description,interval,count,.result)
		
		If $$$ISOK(status) {
			Write result.%ToJSON()	
		}
	} Catch ex {
		Set status = ex.AsStatus()	
	}
	
	Quit status
}

ClassMethod EditProfile(name, description, interval, count) As %Status
{
#dim status As %Status = $$$OK
#dim ex As %Exception.SystemException

	Try {
		Set status = ##class(zpButtons.API.BasicAPI).EditProfile(name,description,interval,count,.result)
				
		If $$$ISOK(status) {
			Write result.%ToJSON()	
		}
	} Catch ex {
		Set status = ex.AsStatus()	
	}
	
	Quit status
}

ClassMethod CreateProfilePerDuration(duration, interval) As %Status
{
#dim status As %Status = $$$OK
#dim ex As %Exception.SystemException

	Try {
		Set status = ##class(zpButtons.API.BasicAPI).CreateProfilePerDuration(duration,interval,.result)
		
		If $$$ISOK(status) {
			Write result.%ToJSON()	
		}
	} Catch ex {
		Set status = ex.AsStatus()	
	}
	
	Quit status
}

ClassMethod CopyProfile(name, newName) As %Status
{
#dim status As %Status = $$$OK
#dim ex As %Exception.SystemException

	Try {
		Set status = ##class(zpButtons.API.BasicAPI).CopyProfile(name,newName,.result)
		
		If $$$ISOK(status) {
			Write result.%ToJSON()	
		}
	} Catch ex {
		Set status = ex.AsStatus()	
	}
	
	Quit status
}

ClassMethod DeleteProfile(name) As %Status
{
#dim status As %Status = $$$OK
#dim ex As %Exception.SystemException

	Try {
		Set status = ##class(zpButtons.API.BasicAPI).DeleteProfile(name,.result)
		
		If $$$ISOK(status) {
			Write result.%ToJSON()	
		}
	} Catch ex {
		Set status = ex.AsStatus()	
	}
	
	Quit status
}

ClassMethod GetProfiles(name As %String = "") As %Status
{
#dim status As %Status = $$$OK
#dim ex As %Exception.SystemException

	Try {
		If (name="") {
			Set name = %request.Get("Name")
		}
		Set status = ##class(zpButtons.API.BasicAPI).GetProfiles(name,.profiles)
		
		If $$$ISOK(status) {
			Write profiles.%ToJSON()	
		}
	} Catch ex {
		Set status = ex.AsStatus()	
	}
	
	Quit status
}

ClassMethod RunProfile(profile, liteRun = 0) As %Status
{
#dim status As %Status = $$$OK
#dim ex As %Exception.SystemException

	Try {
		Set status = ##class(zpButtons.API.BasicAPI).RunProfile(profile,liteRun,.result)
		
		If $$$ISOK(status) {
			Write result.%ToJSON()	
		}
	} Catch ex {
		Set status = ex.AsStatus()	
	}
	
	Quit status
}

ClassMethod GetWaitTimeForCurrentRuns() As %Status
{
#dim status As %Status = $$$OK
#dim ex As %Exception.SystemException

	Try {
		Set status = ##class(zpButtons.API.BasicAPI).GetWaitTimeForCurrentRuns(.result)
		
		If $$$ISOK(status) {
			Write result.%ToJSON()	
		}
	} Catch ex {
		Set status = ex.AsStatus()	
	}
	
	Quit status
}

ClassMethod GetWaitTimeForRunId(runId) As %Status
{
#dim status As %Status = $$$OK
#dim ex As %Exception.SystemException

	Try {
		Set status = ##class(zpButtons.API.BasicAPI).GetWaitTimeForRunId(runId,.result)
		
		If $$$ISOK(status) {
			Write result.%ToJSON()	
		}
	} Catch ex {
		Set status = ex.AsStatus()	
	}
	
	Quit status
}

ClassMethod StopRun(runId, delete = 1) As %Status
{
#dim status As %Status = $$$OK
#dim ex As %Exception.SystemException

	Try {
		Set status = ##class(zpButtons.API.BasicAPI).StopRun(runId,delete,.result)
		
		If $$$ISOK(status) {
			Write result.%ToJSON()	
		}
	} Catch ex {
		Set status = ex.AsStatus()	
	}
	
	Quit status
}

ClassMethod CreatePreviewReport(runId) As %Status
{
#dim status As %Status = $$$OK
#dim ex As %Exception.SystemException

	Try {
		Set status = ##class(zpButtons.API.BasicAPI).CreatePreviewReport(runId,.result)
		
		If $$$ISOK(status) {
			Write result.%ToJSON()	
		}
	} Catch ex {
		Set status = ex.AsStatus()	
	}
	
	Quit status
}

ClassMethod GetPreviousRuns() As %Status
{
#dim status As %Status = $$$OK
#dim ex As %Exception.SystemException

	Try {
		Set status = ##class(zpButtons.API.BasicAPI).GetPreviousRuns(.result)
		
		If $$$ISOK(status) {
			Write result.%ToJSON()	
		}
	} Catch ex {
		Set status = ex.AsStatus()	
	}
	
	Quit status
}

ClassMethod GetLogFolder() As %Status
{
#dim status As %Status = $$$OK
#dim ex As %Exception.SystemException

	Try {
		Set status = ##class(zpButtons.API.BasicAPI).GetLogFolder(.result)
		
		If $$$ISOK(status) {
			Write result.%ToJSON()	
		}
	} Catch ex {
		Set status = ex.AsStatus()	
	}
	
	Quit status
}

ClassMethod SetLogFolder() As %Status
{
#dim status As %Status = $$$OK
#dim ex As %Exception.SystemException

	Try {
		#dim %request As %CSP.Request
		Set folder = %request.Get("folder")
		Set status = ##class(zpButtons.API.BasicAPI).SetLogFolder(folder)
		
		
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
		Set status = ##class(zpButtons.API.BasicAPI).ResetLogFolder()
		
		
	} Catch ex {
		Set status = ex.AsStatus()	
	}
	
	Quit status
}

ClassMethod GetVersion() As %Status
{
#dim status As %Status = $$$OK
#dim ex As %Exception.SystemException

	Try {
		Set status = ##class(zpButtons.API.BasicAPI).GetVersion(.result)
		
		If $$$ISOK(status) {
			Write result.%ToJSON()	
		}
	} Catch ex {
		Set status = ex.AsStatus()	
	}
	
	Quit status
}

/// This method Gets called prior to dispatch of the request. Put any common code here
/// that you want to be executed for EVERY request. If pContinue is set to 0, the
/// request will NOT be dispatched according to the UrlMap. If this case it's the
/// responsibility of the user to return a response.
ClassMethod OnPreDispatch(pUrl As %String, pMethod As %String, ByRef pContinue As %Boolean) As %Status
{
	#dim %response As %CSP.Response
	
	Set %response.ContentType="application/json"
    Quit $$$OK
}

}
