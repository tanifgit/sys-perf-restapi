/// An API for interacting with the SystemPerformance Utility<br/>
/// Business logic class defined by OpenAPI in zpButtons.API.REST.spec<br/>
/// Updated May 3, 2020 09:58:13
Class zpButtons.API.REST.impl Extends %REST.Impl [ ProcedureBlock ]
{

/// If ExposeServerExceptions is true, then details of internal errors will be exposed.
Parameter ExposeServerExceptions = 1;

/// Create a profile giving an interval and count<br/>
/// The method arguments hold values for:<br/>
///     name<br/>
///     description<br/>
///     interval<br/>
///     count<br/>
///     payloadBody, Request body contents<br/>
ClassMethod CreateProfilePerCount(name As %String, description As %String, interval As %String, count As %String, payloadBody As %Stream.Object) As %Stream.Object
{
    #dim status As %Status = $$$OK
    #dim ex As %Exception.SystemException

	Try {
		
        Do ..%SetContentType(##class(%CSP.REST).#CONTENTTYPEJSON)
		Set status = ##class(zpButtons.API.Basic.api).CreateProfilePerCount(name,description,interval,count,.result)
		
		If $$$ISOK(status) {
			Do ..%SetStatusCode(##class(%CSP.REST).#HTTP201CREATED)	
		} else {
            throw ##class(%Exception.StatusException).CreateFromStatus(status)
        }
        
	} Catch ex {
		throw ex	
	}
	
	Quit result
}

/// Edit a profile, providing new interval and count<br/>
/// The method arguments hold values for:<br/>
///     name<br/>
///     description<br/>
///     interval<br/>
///     count<br/>
///     payloadBody, Request body contents<br/>
ClassMethod EditProfile(name As %String, description As %String, interval As %String, count As %String, payloadBody As %Stream.Object) As %Stream.Object
{

    #dim status As %Status = $$$OK
    #dim ex As %Exception.SystemException

	Try {
        Do ..%SetContentType(##class(%CSP.REST).#CONTENTTYPEJSON)
		Set status = ##class(zpButtons.API.Basic.api).EditProfile(name,description,interval,count,.result)
				
		If $$$ISOK(status) {
			Do ..%SetStatusCode(##class(%CSP.REST).#HTTP200OK)	
		} else {
            throw ##class(%Exception.StatusException).CreateFromStatus(status)
        }
	} Catch ex {
		throw ex	
	}
	
	Quit result
}

/// Create a profile giving a duration and interval<br/>
/// The method arguments hold values for:<br/>
///     duration<br/>
///     interval<br/>
///     payloadBody, Request body contents<br/>
ClassMethod CreateProfilePerDuration(duration As %String, interval As %String, payloadBody As %Stream.Object) As %Stream.Object
{
    #dim status As %Status = $$$OK
    #dim ex As %Exception.SystemException

	Try {
		Do ..%SetContentType(##class(%CSP.REST).#CONTENTTYPEJSON)
		Set status = ##class(zpButtons.API.Basic.api).CreateProfilePerDuration(duration,interval,.result)
		
		If $$$ISOK(status) {
			Do ..%SetStatusCode(##class(%CSP.REST).#HTTP201CREATED)	
		} else {
            throw ##class(%Exception.StatusException).CreateFromStatus(status)
        }
        
	} Catch ex {
		throw ex	
	}
	
	Quit result
}

/// Delete a profile per name<br/>
/// The method arguments hold values for:<br/>
///     name<br/>
ClassMethod DeleteProfile(name As %String) As %Stream.Object
{
    #dim status As %Status = $$$OK
    #dim ex As %Exception.SystemException

	Try {
        Do ..%SetContentType(##class(%CSP.REST).#CONTENTTYPEJSON)
		Set status = ##class(zpButtons.API.Basic.api).DeleteProfile(name,.result)
				
		If $$$ISOK(status) {
			Do ..%SetStatusCode(##class(%CSP.REST).#HTTP200OK)	
		} else {
            throw ##class(%Exception.StatusException).CreateFromStatus(status)
        }
	} Catch ex {
		throw ex	
	}
	
	Quit result
}

/// gets a list of all the currently defined profiles
ClassMethod GetProfiles() As %Stream.Object
{
    #dim status As %Status = $$$OK
    #dim ex As %Exception.SystemException

	Try {
        Do ..%SetContentType(##class(%CSP.REST).#CONTENTTYPEJSON)
        set name = ""
		Set status = ##class(zpButtons.API.Basic.api).GetProfiles(name,.profiles)
				
		If $$$ISOK(status) {
			Do ..%SetStatusCode(##class(%CSP.REST).#HTTP200OK)	
		} else {
            throw ##class(%Exception.StatusException).CreateFromStatus(status)
        }
	} Catch ex {
		throw ex	
	}
	
	Quit profiles
}

/// Copy a Profile giving a new name<br/>
/// The method arguments hold values for:<br/>
///     name<br/>
///     newName<br/>
///     payloadBody, Request body contents<br/>
ClassMethod CopyProfile(name As %String, newName As %String, payloadBody As %Stream.Object) As %Stream.Object
{
    #dim status As %Status = $$$OK
    #dim ex As %Exception.SystemException

	Try {
		Do ..%SetContentType(##class(%CSP.REST).#CONTENTTYPEJSON)
		Set status = ##class(zpButtons.API.Basic.api).CopyProfile(name,newName,.result)
				
		If $$$ISOK(status) {
			Do ..%SetStatusCode(##class(%CSP.REST).#HTTP201CREATED)	
		} else {
            throw ##class(%Exception.StatusException).CreateFromStatus(status)
        }
        
	} Catch ex {
		throw ex	
	}
	
	Quit result
}

/// (provide functional description here)<br/>
/// The method arguments hold values for:<br/>
///     profile<br/>
///     liteRun<br/>
///     payloadBody, Request body contents<br/>
/// WARNING: This method's signature has changed.
ClassMethod RunProfile(profile As %String, liteRun As %String, payloadBody As %Stream.Object) As %Stream.Object
{
    #dim status As %Status = $$$OK
    #dim ex As %Exception.SystemException

	Try {
		Do ..%SetContentType(##class(%CSP.REST).#CONTENTTYPEJSON)
		Set status = ##class(zpButtons.API.Basic.api).RunProfile(profile,liteRun,.result)
				
		If $$$ISOK(status) {
			Do ..%SetStatusCode(##class(%CSP.REST).#HTTP202ACCEPTED)	
		} else {
            throw ##class(%Exception.StatusException).CreateFromStatus(status)
        }
        
	} Catch ex {
		throw ex	
	}
	
	Quit result
}

/// Return the time remaining to wait for current Runs
ClassMethod GetWaitTimeForCurrentRuns() As %Stream.Object
{
    #dim status As %Status = $$$OK
    #dim ex As %Exception.SystemException

	Try {
		Do ..%SetContentType(##class(%CSP.REST).#CONTENTTYPEJSON)
		Set status = ##class(zpButtons.API.Basic.api).GetWaitTimeForCurrentRuns(.result)
				
		If $$$ISOK(status) {
			Do ..%SetStatusCode(##class(%CSP.REST).#HTTP200OK)	
		} else {
            throw ##class(%Exception.StatusException).CreateFromStatus(status)
        }
        
	} Catch ex {
		throw ex	
	}
	
	Quit result
}

/// Return the time remaining to wait for a given Run ID<br/>
/// The method arguments hold values for:<br/>
///     runId<br/>
ClassMethod GetWaitTimeForRunId(runId As %String) As %Stream.Object
{
    #dim status As %Status = $$$OK
    #dim ex As %Exception.SystemException

	Try {
		Do ..%SetContentType(##class(%CSP.REST).#CONTENTTYPEJSON)
		Set status = ##class(zpButtons.API.Basic.api).GetWaitTimeForRunId(runId,.result)
				
		If $$$ISOK(status) {
			Do ..%SetStatusCode(##class(%CSP.REST).#HTTP200OK)	
		} else {
            throw ##class(%Exception.StatusException).CreateFromStatus(status)
        }
        
	} Catch ex {
		throw ex	
	}
	
	Quit result
}

/// Creat a Preview Report for a Run<br/>
/// The method arguments hold values for:<br/>
///     runId<br/>
///     payloadBody, Request body contents<br/>
ClassMethod CreatePreviewReport(runId As %String, payloadBody As %Stream.Object) As %Stream.Object
{
    #dim status As %Status = $$$OK
    #dim ex As %Exception.SystemException

	Try {
		Do ..%SetContentType(##class(%CSP.REST).#CONTENTTYPEJSON)
		Set status = ##class(zpButtons.API.Basic.api).CreatePreviewReport(runId,.result)
				
		If $$$ISOK(status) {
			Do ..%SetStatusCode(##class(%CSP.REST).#HTTP202ACCEPTED)	
		} else {
            throw ##class(%Exception.StatusException).CreateFromStatus(status)
        }
        
	} Catch ex {
		throw ex	
	}
	
	Quit result
}

/// (provide functional description here)<br/>
/// The method arguments hold values for:<br/>
///     runId<br/>
///     delete<br/>
ClassMethod StopRun(runId As %String, delete As %String) As %Stream.Object
{
    #dim status As %Status = $$$OK
    #dim ex As %Exception.SystemException

	Try {
		Do ..%SetContentType(##class(%CSP.REST).#CONTENTTYPEJSON)
		Set status = ##class(zpButtons.API.Basic.api).StopRun(runId,delete,.result)
				
		If $$$ISOK(status) {
			Do ..%SetStatusCode(##class(%CSP.REST).#HTTP202ACCEPTED)	
		} else {
            throw ##class(%Exception.StatusException).CreateFromStatus(status)
        }
        
	} Catch ex {
		throw ex	
	}
	
	Quit result
}

/// Return a list of previous runs
ClassMethod GetPreviousRuns() As %Stream.Object
{
    #dim status As %Status = $$$OK
    #dim ex As %Exception.SystemException

	Try {
		Do ..%SetContentType(##class(%CSP.REST).#CONTENTTYPEJSON)
		Set status = ##class(zpButtons.API.Basic.api).GetPreviousRuns(.result)
				
		If $$$ISOK(status) {
			Do ..%SetStatusCode(##class(%CSP.REST).#HTTP200OK)	
		} else {
            throw ##class(%Exception.StatusException).CreateFromStatus(status)
        }
        
	} Catch ex {
		throw ex	
	}
	
	Quit result
}

/// returns the current folder location for the output log files
ClassMethod GetLogFolder() As %Stream.Object
{
    #dim status As %Status = $$$OK
    #dim ex As %Exception.SystemException

	Try {
		Do ..%SetContentType(##class(%CSP.REST).#CONTENTTYPEJSON)
		Set status = ##class(zpButtons.API.Basic.api).GetLogFolder(.result)
				
		If $$$ISOK(status) {
			Do ..%SetStatusCode(##class(%CSP.REST).#HTTP200OK)	
		} else {
            throw ##class(%Exception.StatusException).CreateFromStatus(status)
        }
        
	} Catch ex {
		throw ex	
	}
	
	Quit result
}

/// changes the output log files folder location to a new value<br/>
/// The method arguments hold values for:<br/>
///     payloadBody, Request body contents<br/>
ClassMethod SetLogFolder(payloadBody As %Stream.Object) As %Stream.Object
{
    #dim status As %Status = $$$OK
    #dim ex As %Exception.SystemException

	Try {
		Do ..%SetContentType(##class(%CSP.REST).#CONTENTTYPEJSON)
        Set folder = %request.Get("folder")
		Set status = ##class(zpButtons.API.Basic.api).SetLogFolder(folder)
				
		If $$$ISOK(status) {
			Do ..%SetStatusCode(##class(%CSP.REST).#HTTP204NOCONTENT)	
		} else {
            throw ##class(%Exception.StatusException).CreateFromStatus(status)
        }
        
	} Catch ex {
		throw ex	
	}
	
	Quit ""
}

/// resets the folder location to the default value<br/>
/// The method arguments hold values for:<br/>
///     payloadBody, Request body contents<br/>
ClassMethod ResetLogFolder(payloadBody As %Stream.Object) As %Stream.Object
{
    #dim status As %Status = $$$OK
    #dim ex As %Exception.SystemException

	Try {
		Do ..%SetContentType(##class(%CSP.REST).#CONTENTTYPEJSON)
		Set status = ##class(zpButtons.API.Basic.api).ResetLogFolder()
				
		If $$$ISOK(status) {
			Do ..%SetStatusCode(##class(%CSP.REST).#HTTP204NOCONTENT)	
		} else {
            throw ##class(%Exception.StatusException).CreateFromStatus(status)
        }
        
	} Catch ex {
		throw ex	
	}
	
	Quit ""
}

/// Return version of the Utility
ClassMethod GetVersion() As %Stream.Object
{
    #dim status As %Status = $$$OK
    #dim ex As %Exception.SystemException

	Try {
		Do ..%SetContentType(##class(%CSP.REST).#CONTENTTYPEJSON)
		Set status = ##class(zpButtons.API.Basic.api).GetVersion(.result)
				
		If $$$ISOK(status) {
			Do ..%SetStatusCode(##class(%CSP.REST).#HTTP200OK)	
		} else {
            throw ##class(%Exception.StatusException).CreateFromStatus(status)
        }
        
	} Catch ex {
		throw ex	
	}
	
	Quit result
}

/// (provide functional description here)<br/>
/// The method arguments hold values for:<br/>
///     name<br/>
ClassMethod GetProfile(name As %String) As %Stream.Object
{
        #dim status As %Status = $$$OK
    #dim ex As %Exception.SystemException

	Try {
        Do ..%SetContentType(##class(%CSP.REST).#CONTENTTYPEJSON)
        If (name="") {
			Set name = %request.Get("Name")
		}
		Set status = ##class(zpButtons.API.Basic.api).GetProfiles(name,.profiles)
				
		If $$$ISOK(status) {
			Do ..%SetStatusCode(##class(%CSP.REST).#HTTP200OK)	
		} else {
            throw ##class(%Exception.StatusException).CreateFromStatus(status)
        }
	} Catch ex {
		throw ex	
	}
	
	Quit profiles
}

}
