Include (%occXSLT, zpButtonsInc)

Class zpButtons.Test.BasicAPITest Extends %UnitTest.TestCase
{

Parameter APITYPE [ Constraint = "Basic,REST", Flags = ENUM ] = "Basic";

Property HttpRequest As %Net.HttpRequest;

Method MakeCall(methodName As %String, hasOutputArg As %Boolean = 1, Output jsonResultArg As %String, args...) As %Status
{
	Set status = $$$OK
	If ..#APITYPE="Basic" {
		If $Data(args) {
			Set status = $ClassMethod("zpButtons.API.BasicAPI",methodName,args...) 
		} ElseIf hasOutputArg {
			Set status = $ClassMethod("zpButtons.API.BasicAPI",methodName,.jsonResultArg) 
		} Else {
			Set status = $ClassMethod("zpButtons.API.BasicAPI",methodName) 
		}
		
		Do $$$AssertStatusOK(status,methodName_" returned an OK status: "_status)
		
		If $$$ISERR(status) Quit status
		
		If (hasOutputArg&&$Data(args)) {
			Set jsonResultArg = args(args)
		}
		
	} ElseIf ..#APITYPE="REST" {
		
		Set status = ..GetURLAndHttpType(methodName,.url,.httpMethodType)
		Set url = "/pButtons" _ url
		
		Set argsNum = $Get(args,0)
		
		If hasOutputArg {
			Set argsNum = argsNum-1	
		}
		
		Set parsURLpart = ""
		
		If methodName="SetLogFolder" {
			Set url = url _ "?folder=" _ ##class(%CSP.Page).EscapeURL(args(1))
		} Else {
			For i = 1:1:argsNum {
				If (i=argsNum)&&(args(i)="") {
					// do not include just a / at the end with no value	
				} Else {
					Set parsURLpart = parsURLpart _ "/" _ args(i)	
				}
			}
			Set parsURLpart = ##class(%CSP.Page).EscapeURL(parsURLpart)
		
			Set url = url _ parsURLpart
		}
		
		
		
		Set ..HttpRequest.Timeout = 120
		
		Do ..HttpRequest.SetParam($$$usernamePar,"SuperUser")
		Do ..HttpRequest.SetParam($$$passwordPar,"sys")
		
		Set status = ..HttpRequest.Send(httpMethodType,url)	
		
		Do $$$AssertStatusOK(status,"http "_httpMethodType_" request to "_url_" returned an OK status: "_status)		
		
		If $$$ISOK(status) {
			Set statusCode = ..HttpRequest.HttpResponse.StatusCode
			
			Do $$$AssertEquals(statusCode,200,methodName_" REST call returned success Status code: "_statusCode)				
			
			Set returnData = ..HttpRequest.HttpResponse.Data
			
			If $IsObject(returnData) {
				Set returnData = returnData.Read()	
			}
			
			If statusCode'=200 {
				Quit $$$ERROR(statusCode_" : "_returnData)
			}
				
			If hasOutputArg {
				Set jsonResultArg = {}.%FromJSON(returnData)
			}
		} Else {
			Quit status	
		}
	}
	Quit status
}

Method TestFullProfileMgmtFlow()
{

		// First create a new profile 
		//	Using the full details
	
		// Setup some info
		Set randomNum = $Random(999)
		Set profileName = "TestNewProfile"_randomNum
		Set profileDesc = "Profile Description"
		Set interval = 10 
		Set count = 200
		Set result = ""
		
				
		Set status = ..MakeCall("CreateProfilePerCount",1,.JSONResult,profileName,profileDesc,interval,count,.result)
		Do $$$AssertStatusOK(status,"MakeCall for CreateProfilePerCount returned an OK status: "_status)
		If $$$ISERR(status) Quit status
		
		Set okJSON = "{""StatusCode"":""1"",""Message"":""""}"
		
		Do $$$AssertEquals(JSONResult.%ToJSON(),okJSON,"CreateProfilePerCount returned the expected JSON result: "_JSONResult.%ToJSON())
		
		// Now create one just with a duration

		Set duration = $Random(60)+1
		Set durationName = duration _ "mins"
		Set durationDesc = duration_" minute run sampling every "_interval_" seconds"
		Set durationCount = duration*60/interval
		
		Do ..OnBeforeOneTest()
		
		//Set status = ##class(zpButtons.API.BasicAPI).CreateProfilePerDuration(duration,interval,.result)
		Set status = ..MakeCall("CreateProfilePerDuration",1,.JSONResult,duration,interval,.result)
		Do $$$AssertStatusOK(status,"MakeCall for CreateProfilePerDuration returned an OK status: "_status)
		If $$$ISERR(status) Quit status
		
		Do $$$AssertEquals(JSONResult.%ToJSON(),okJSON,"CreateProfilePerDuration returned the expected JSON result: "_JSONResult.%ToJSON())
		
		// Now try and copy one
		
		Set copyProfileName = profileName _ "Copy"
		//Set status = ##class(zpButtons.API.BasicAPI).CopyProfile(profileName,copyProfileName,.result)
		Set status = ..MakeCall("CopyProfile",1,.JSONResult,profileName,copyProfileName,.result)
		Do $$$AssertStatusOK(status,"MakeCall for CopyProfile returned an OK status: "_status)
		If $$$ISERR(status) Quit status
		
		
		Do $$$AssertEquals(JSONResult.%ToJSON(),okJSON,"CopyProfile returned the expected JSON result: "_JSONResult.%ToJSON())
		
		// Now verify the profiles were created correctly

		//Set status = ##class(zpButtons.API.BasicAPI).GetProfiles(.profiles)
		Set status = ..MakeCall("GetProfiles",1,.profiles,"",.profiles)
		Do $$$AssertStatusOK(status,"MakeCall for GetProfiles returned an OK status: "_status)
		If $$$ISERR(status) Quit status
		
		
		
		#dim profiles As %DynamicArray
		#dim iter As %Iterator.Array		
		
		Set foundFirst = 0
		Set foundSecond = 0
		Set foundCopy = 0
		
		Set dataFirstOK = 0
		Set dataSecondOK = 0
		Set dataCopyOK = 0
		
		Set dataFirstJSON = ""
		Set dataSecondJSON = ""
		Set dataCopyJSON = ""
		
		Set iter = profiles.%GetIterator()
		While ((('foundFirst)||('foundSecond)||('foundCopy))&&(iter.%GetNext(.key,.profile))) {
			If (('foundFirst)&&(profile.Name=profileName)) {
				Set foundFirst = 1
				Set dataFirstOK = ((profile.Desc=profileDesc)&&(profile.Interval=interval)&&(profile.SamplesNum=count))
				Set dataFirstJSON = profile.%ToJSON()
			}
			If (('foundSecond)&&(profile.Name=durationName)) {
				Set foundSecond = 1
				Set dataSecondOK = ((profile.Desc=durationDesc)&&(profile.Interval=interval)&&(profile.SamplesNum=durationCount))
				Set dataSecondJSON = profile.%ToJSON()
			}
			If (('foundCopy)&&(profile.Name=copyProfileName)) {
				Set foundCopy = 1
				Set dataCopyOK = ((profile.Desc=profileDesc)&&(profile.Interval=interval)&&(profile.SamplesNum=count))
				Set dataCopyJSON = profile.%ToJSON()
			}
		}
		
		Do $$$AssertTrue(foundFirst,"Found first (create per count) profile")
		
		Do $$$AssertTrue(dataFirstOK,"First (create per count) profile's data is OK: "_dataFirstJSON)
		
		Do $$$AssertTrue(foundSecond,"Found second (create per duration) profile")
		
		Do $$$AssertTrue(dataSecondOK,"Second (create per duration) profile's data is OK: "_dataSecondJSON)
		
		Do $$$AssertTrue(foundCopy,"Found copy (copy profile) profile")
		
		Do $$$AssertTrue(dataCopyOK,"Copy (copy profile) profile's data is OK: "_dataCopyJSON)
		
		// Let's try and edit a profile
		
		// Set profileName = "TestNewProfile"_randomNum
		Set profileChangedDesc = "Profile Change Description"
		Set changedInterval = 20 
		Set changedCount = 50
		
		//Set status = ##class(zpButtons.API.BasicAPI).EditProfile(profileName,profileChangedDesc,changedInterval,changedCount,.result)
		Set status = ..MakeCall("EditProfile",1,.JSONResult,profileName,profileChangedDesc,changedInterval,changedCount,.result)
		Do $$$AssertStatusOK(status,"MakeCall for EditProfile returned an OK status: "_status)
		If $$$ISERR(status) Quit status
		
		
		
		Set okJSON = "{""StatusCode"":""1"",""Message"":""""}"
		
		Do $$$AssertEquals(JSONResult.%ToJSON(),okJSON,"Edit Profile returned the expected JSON result: "_JSONResult.%ToJSON())
		
		// Let's check this was changed ok
		
		// This time we'll use the GetProfiles with the profile name
		//Set status = ##class(zpButtons.API.BasicAPI).GetProfiles(.profiles)
		Set status = ..MakeCall("GetProfiles",1,.profiles,profileName,.profiles)
		Do $$$AssertStatusOK(status,"MakeCall for GetProfiles (with parameter, for edited) returned an OK status: "_status)
		If $$$ISERR(status) Quit status
		
		Do $$$AssertNotEquals(+profiles,0,"Did not get a 0 (zero) error code back "_profiles)
		
		If $IsObject(profiles) {
		
			Set dataChangedOK = ((profiles.Desc=profileChangedDesc)&&(profiles.Interval=changedInterval)&&(profiles.SamplesNum=changedCount))
			
			Set dataChangedJSON = profiles.%ToJSON()
		}
		
		
		Do $$$AssertTrue(dataChangedOK,"Edited profile's data is OK: "_dataChangedJSON)
		
		// Now delete
		
		//Set status = ##class(zpButtons.API.BasicAPI).DeleteProfile(profileName,.result)
		Set status = ..MakeCall("DeleteProfile",1,.JSONResult,profileName,.result)
		Do $$$AssertStatusOK(status,"MakeCall for DeleteProfile (first) returned an OK status: "_status)
		If $$$ISERR(status) Quit status
						
		Do $$$AssertEquals(JSONResult.%ToJSON(),okJSON,"Delete Profile (first) returned the expected JSON result: "_JSONResult.%ToJSON())
		
		
		
		//Set status = ##class(zpButtons.API.BasicAPI).DeleteProfile(durationName,.result)
		Set status = ..MakeCall("DeleteProfile",1,.JSONResult,durationName,.result)
		Do $$$AssertStatusOK(status,"MakeCall for DeleteProfile (second - duration) returned an OK status: "_status)
		If $$$ISERR(status) Quit status
		
		Do $$$AssertEquals(JSONResult.%ToJSON(),okJSON,"Delete Profile (second - duration) returned the expected JSON result: "_JSONResult.%ToJSON())
		
		
		
		//Set status = ##class(zpButtons.API.BasicAPI).DeleteProfile(copyProfileName,.result)
		Set status = ..MakeCall("DeleteProfile",1,.JSONResult,copyProfileName,.result)
		Do $$$AssertStatusOK(status,"MakeCall for DeleteProfile (third - copy) returned an OK status: "_status)
		If $$$ISERR(status) Quit status
		
		Do $$$AssertEquals(JSONResult.%ToJSON(),okJSON,"Delete Profile (third - copy) returned the expected JSON result: "_JSONResult.%ToJSON())
}

Method TestVersion()
{
	Set checkVersion = $$version$$$pButtonsRoutine
	
	//Set status = ##class(zpButtons.API.BasicAPI).GetVersion(.apiVersion)
	Set status = ..MakeCall("GetVersion",1,.apiVersion)
	Do $$$AssertStatusOK(status,"MakeCall for GetVersion returned an OK status: "_status)
	If $$$ISERR(status) Quit status
	
	Set version = apiVersion.Version
	
	Do $$$AssertStatusOK(status,"GetVersion returned an OK status: "_status)
	
	If $$$ISERR(status) Quit
		
	Do $$$AssertEquals(checkVersion,version,"GetVersion returned the expected version: "_checkVersion_"="_version)
}

Method TestRunFlow()
{
	// First let's create a short running profile
	
	// Setup some info
	
	Set timeStamp = $Translate($ZDateTime($Horolog,8)," :","")
	Set profileName = "TestShortProfile"_timeStamp
	
	Set profileDesc = "Profile Description"
	Set interval = 10 
	Set count = 2
	Set result = ""
	
	//Set status = ##class(zpButtons.API.BasicAPI).CreateProfilePerCount(profileName,profileDesc,interval,count,.result)
	Set status = ..MakeCall("CreateProfilePerCount",1,.JSONResult,profileName,profileDesc,interval,count,.result)
	Do $$$AssertStatusOK(status,"MakeCall for CreateProfile returned an OK status: "_status)
	If $$$ISERR(status) Quit status
	
	
	// Now we'll run this profile
	
	Set runInfo = ""
	Write !,"		>> Going to run Profile, will pause a little...",!
	//Set status = ##class(zpButtons.API.BasicAPI).RunProfile(profileName,/* lite run */,.runInfo)
	Set status = ..MakeCall("RunProfile",1,.runInfo,profileName,0 /* lite run */,.runInfo)
	Do $$$AssertStatusOK(status,"MakeCall for RunProfile returned an OK status: "_status)
	If $$$ISERR(status) Quit status
		
	Set runId = runInfo.RunId
	
	Do $$$AssertNotEquals(runId,"","got runId ok: "_runId)
	
	Set waitInfo = ""
	//Set status = ##class(zpButtons.API.BasicAPI).GetWaitTimeForRunId(runId,.waitInfo)
	Set status = ..MakeCall("GetWaitTimeForRunId",1,.waitInfo,runId,.waitInfo)
	Do $$$AssertStatusOK(status,"MakeCall for GetWaitTimeForRunId returned an OK status: "_status)
	If $$$ISERR(status) Quit status
		
	Set waitTime = waitInfo.WaitTime
	
	Do $$$AssertNotEquals(waitTime,"","got expected wait time ok: "_waitInfo.%ToJSON())
		
	// Now collect a preview
	
	Write !,"		>> Going to create Preview Report, will pause...",!
	
	//Set status = ##class(zpButtons.API.BasicAPI).CreatePreviewReport(runId,.result)
	Set status = ..MakeCall("CreatePreviewReport",1,.result,runId,.result)
	Do $$$AssertStatusOK(status,"MakeCall for CreatePreviewReport returned an OK status: "_status)
	If $$$ISERR(status) Quit status
		
	Set previewStatus = result.StatusCode
	Set previewPath = result.Path
	
	Do $$$AssertEquals(previewStatus,1,"got expected Preview status: "_result.StatusCode)
	Do $$$AssertNotEquals(previewPath,"","got expected Preview path: "_result.%ToJSON())
	
	Set previewExists = ##class(%File).Exists(previewPath)
	
	Do $$$AssertEquals(previewExists,1,"preview file exists: "_previewExists)
	
	
	// Lets get WaitTime again - this time without runId so we get an array
	
	Set waitInfo = ""
	//Set status = ##class(zpButtons.API.BasicAPI).GetWaitTimeForCurrentRuns(.waitInfo)
	Set status = ..MakeCall("GetWaitTimeForCurrentRuns",1,.waitInfo)
	Do $$$AssertStatusOK(status,"MakeCall for GetWaitTimeForCurrentRuns (without Id) returned an OK status: "_status)
	If $$$ISERR(status) Quit status
	
	set found = 0
	Set iter = waitInfo.%GetIterator()
	While (iter.%GetNext(.key,.run)) {
		If (run.RunId=runId) {
			Set found = 1
			Quit
		}
	}
	
	Do $$$AssertEquals(found,1,"found run (in wait time)")
	
	Set waitTime = run.WaitTime
	
	Do $$$AssertNotEquals(waitTime,"","got wait time ok: "_waitTime)
	
	// Let's calculate the actual time so we can wait accordingly
	//	sample: 2 minutes 13 seconds
	
	Set waitTimeLength = $Length(waitTime," ")
	If waitTimeLength = 4 {
		Set minutes = $Piece(waitTime," ",1)
		Set seconds = $Piece(waitTime," ",3)
	} Else {
		Set minutes = 0
		Set seconds = $Piece(waitTime," ",1)	
	}
	Set extra = 15
	Set totalTime = (minutes * 60) + seconds + extra
	
	
	// Now wait until done
	
	
	Set pause = 5
	//Set grace = 120
	//Set totalTime = (interval*count+grace)
	Set loops = (totalTime / pause) + 1
	Set displayMinutes = $FNumber((totalTime / 60),,2)
	Set minute = 60/pause
	
	Write !," ===>>>> Waiting for approx. ",displayMinutes," minutes......",!
	
	Write "			"
	For i=1:1:loops {
		Hang pause
		Write "."
		If i#minute=0 write i*pause,"sec",!,"			"
	}
	
	Set waitInfo = ""
	//Set status = ##class(zpButtons.API.BasicAPI).GetWaitTimeForRunId(runId,.waitInfo)
	Set status = ..MakeCall("GetWaitTimeForRunId",1,.waitInfo,runId,.waitInfo)
	Do $$$AssertStatusOK(status,"MakeCall for GetWaitTimeForRunId (after done) returned an OK status: "_status)
	If $$$ISERR(status) Quit status
		
	Set waitStatus = waitInfo.StatusCode
	
	Do $$$AssertEquals(waitStatus,-2,"got expected wait status (does not exist any more): "_waitInfo.%ToJSON())
	
	// Now lets run the profile again - this time attempting to stop it
	
	Write !,"		>> Going to run Profile (for stopping flow), will pause a little...",!
	//Set status = ##class(zpButtons.API.BasicAPI).RunProfile(profileName,/* lite run */,.runInfo)
	Set status = ..MakeCall("RunProfile",1,.runInfo,profileName,0 /* lite run */,.runInfo)
	Do $$$AssertStatusOK(status,"MakeCall for RunProfile (for stopping) returned an OK status: "_status)
	If $$$ISERR(status) Quit status
		
	Set runIdForStop = runInfo.RunId
	
	Do $$$AssertNotEquals(runIdForStop,"","got runId (for stopping) ok: "_runIdForStop)
	
	// Now will stop it
	
	//Set status = ##class(zpButtons.API.BasicAPI).StopRun(runIdForStop,/* delete files = 1 */,.stopInfo)
	Set status = ..MakeCall("StopRun",1,.stopInfo,runIdForStop,1 /* delete files */,.stopInfo)
	Do $$$AssertStatusOK(status,"MakeCall for StopRun returned an OK status: "_status)
	If $$$ISERR(status) Quit status
	
	Do $$$LogMessage("got JSON: "_stopInfo.%ToJSON())
	
	Do $$$AssertTrue((stopInfo.Cache.jobsStopped>0),"got more than 0 jobs stopped: "_stopInfo.Cache.stoppedJobs)
	
	Do $$$AssertTrue((stopInfo.Cache.filesDeleted>0),"got more than 0 files deleted: "_stopInfo.Cache.filesDeleted)
	
	// Now delete the profile and the generated files
	
	//Set status = ##class(zpButtons.API.BasicAPI).DeleteProfile(profileName,.result)
	Set status = ..MakeCall("DeleteProfile",1,.result,profileName,.result)
	Do $$$AssertStatusOK(status,"MakeCall for DeleteProfile returned an OK status: "_status)
	If $$$ISERR(status) Quit status
		
	// Delete Preview file
	
	Set status = ##class(%File).Delete(previewPath)
	
	Do $$$AssertStatusOK(status,"Deleted preview report file with OK status: "_status)
	
	
	
	// Now let's get the previous runs and verify we get this run
	
	
	
	#dim runs As %DynamicArray
	#dim iter As %Iterator.Array
	Set runs = ""
	
	//Set status = ##class(zpButtons.API.BasicAPI).GetPreviousRuns(.runs)
	Set status = ..MakeCall("GetPreviousRuns",1,.runs)
	Do $$$AssertStatusOK(status,"MakeCall for GetPreviousRuns returned an OK status: "_status)
	If $$$ISERR(status) Quit status
		
	
	
	set found = 0
	Set iter = runs.%GetIterator()
	While (iter.%GetNext(.key,.run)) {
		If (run.Id=runId) {
			Set found = 1
			Quit
		}
	}
	
	Do $$$AssertEquals(found,1,"found run (in previous runs)")
	
	Do $$$LogMessage(run.%ToJSON())
	
	Set dateTime = run.DateTime
	
	Do $$$AssertNotEquals(dateTime,"","got date-time of end of run "_dateTime)
	
	Set folder = run.Folder
	
	Do $$$AssertNotEquals(folder,"","got folder of report "_folder)
	
	Set reportFilename = run.ReportFilename
	
	Do $$$AssertNotEquals(reportFilename,"","got filename of report "_reportFilename)
	
	Set fileExists = run.ReportFileExists
	
	Do $$$AssertEquals(fileExists,1,"filename exists")
	
	// Now delete the filename and check again - this time that the file does not exist...
	
	Set status = ##class(%File).Delete(reportFilename)
	
	Do $$$AssertStatusOK(status,"Deleted report file with OK status: "_status)
	
	Set runs = ""
	
	//Set status = ##class(zpButtons.API.BasicAPI).GetPreviousRuns(.runs)
	Set status = ..MakeCall("GetPreviousRuns",1,.runs)
	Do $$$AssertStatusOK(status,"MakeCall for GetPreviousRuns (after delete report file) returned an OK status: "_status)
	If $$$ISERR(status) Quit status
		
	
	set found = 0
	Set iter = runs.%GetIterator()
	While (iter.%GetNext(.key,.run)) {
		If (run.Id=runId) {
			Set found = 1
			Quit
		}
	}
	
	Do $$$AssertEquals(found,1,"found run (after delete report file)")
	
	Set fileExists = run.ReportFileExists
	
	Do $$$AssertEquals(fileExists,0,"filename does not exist (after delete)")
}

Method TestLogFolder()
{
	
	// First get current folder (also to return to in the end)
	Set folder = ""
	
	//Set status = ##class(zpButtons.API.BasicAPI).GetLogFolder(.folder)
	Set status = ..MakeCall("GetLogFolder",1,.folder,.folder)
	Do $$$AssertStatusOK(status,"MakeCall for GetLogFolder (org) returned an OK status: "_status)
	If $$$ISERR(status) Quit status
	
	
	Set orgFolderName = folder.Name
		
	Do $$$AssertNotEquals(orgFolderName,"","folder name has value: "_orgFolderName)
	
	Set mgrFolder = $system.Util.ManagerDirectory()
	Set tempFolder = ##class(%SYS.System).TempDirectory()
	
	
	// Now change to Temp
	
	//Set status = ##class(zpButtons.API.BasicAPI).SetLogFolder(tempFolder)
	Set status = ..MakeCall("SetLogFolder",0,,tempFolder)
	Do $$$AssertStatusOK(status,"MakeCall for SetLogFolder (to temp) returned an OK status: "_status)
	If $$$ISERR(status) Quit status
		
	
	// Get again to verify changed
	
	Set folder = ""
	
	//Set status = ##class(zpButtons.API.BasicAPI).GetLogFolder(.folder)
	Set status = ..MakeCall("GetLogFolder",1,.folder,.folder)
	Do $$$AssertStatusOK(status,"MakeCall for GetLogFolder (temp) returned an OK status: "_status)
	If $$$ISERR(status) Quit status
	
	
	Set changedFolderName = folder.Name
	
	// The temp folder returned from the pButtons could have an extra '\' to it
	//	So will trunctate to compare lengths
		
	If ($Length(changedFolderName) = ($Length(tempFolder) + 1)) {
		
		Set changedFolderName = $Extract(changedFolderName,1,*-1)
		
	}
	Do $$$AssertEquals(changedFolderName,tempFolder,"folder changed ok (to temp): "_changedFolderName_" = "_tempFolder)
	
	// Now reset (to mgr)
	
	//Set status = ##class(zpButtons.API.BasicAPI).ResetLogFolder()
	Set status = ..MakeCall("ResetLogFolder",0)
	Do $$$AssertStatusOK(status,"MakeCall for ResetLogFolder returned an OK status: "_status)
	If $$$ISERR(status) Quit status
	
	// Get again - to verify change to mgr
	
	//Set status = ##class(zpButtons.API.BasicAPI).GetLogFolder(.folder)
	Set status = ..MakeCall("GetLogFolder",1,.folder,.folder)
	Do $$$AssertStatusOK(status,"MakeCall for GetLogFolder (mgr) returned an OK status: "_status)
	If $$$ISERR(status) Quit status
	
	Set resetFolderName = folder.Name
		
	Do $$$AssertEquals(resetFolderName,mgrFolder,"folder reset ok (to mgr): "_resetFolderName_" = "_mgrFolder)
	
	// Now return back to original
	
	//Set status = ##class(zpButtons.API.BasicAPI).SetLogFolder(orgFolderName)
	Set status = ..MakeCall("SetLogFolder",0,,orgFolderName)
	Do $$$AssertStatusOK(status,"MakeCall for SetLogFolder (back to org) returned an OK status: "_status)
	If $$$ISERR(status) Quit status
}

/// Run by <B>RunTest</B> once <a href="#OnBeforeAll">before any test methods</a> in the test class are run. Can be used to set up a 
/// test environment that will be later cleaned up by <B>OnAfterAllTests</B>. 
/// <br><br>Example: Setup and Cleanup of an environment: 
/// <pre>
/// Method OnBeforeAllTests() As %Status
/// {
/// 	//do setup stuff here
///  	set ^inputMessage = "input message"
/// 	quit $$$OK
/// }
/// Method OnAfterAllTests() As %Status
/// {
/// 	//do clean up stuff here
/// 	kill ^inputMessage
/// 	quit $$$OK
/// }</pre>
/// 
Method OnBeforeOneTest(testname As %String) As %Status
{

	Set ..HttpRequest = ##class(%Net.HttpRequest).%New()
	Set ..HttpRequest.Server="localhost"
	Set webportstatus = ##class(%RoutineMgr).GetWebServerPort(.webPort)
	If $$$ISOK(webportstatus) {
		Set ..HttpRequest.Port = webPort	
	}
		
 	Quit $$$OK
}

Method GetURLAndHttpType(methodName As %String, Output URL As %String, Output HttpType As %String) As %Status
{
	set xdata = ##class(%Dictionary.XDataDefinition).%OpenId("zpButtons.API.RESTAPI||UrlMap")	
	
	Set status=##class(%XML.XPATH.Document).CreateFromStream(xdata.Data,.document)
	$$$QuitOnError(status)
	
	#dim results As %ListOfObjects = ""
	Set status=document.EvaluateExpression("/Routes","Route[@Call='"_methodName_"']",.results)
	$$$QuitOnError(status)
	
	#dim result As %XML.XPATH.DOMResult
	Set result=results.GetAt(1)
            
	Set read = result.Read()
	
	Do result.MoveToAttributeIndex(1)
	
	Set URL = $Piece(result.Value,":",1)
	If $Extract(URL,*) = "/" {
		Set URL = $Extract(URL,1,*-1)	
	}
	
	Do result.MoveToAttributeIndex(2)
	
	Set HttpType = result.Value
	
	Quit status
}

}
