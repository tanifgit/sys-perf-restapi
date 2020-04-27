ROUTINE zpButtonsInc [Type=INC]
#if $system.Version.GetProduct()["IRIS"
///
#define pButtonsRoutine ^SystemPerformance
///
#define pButtonsData ^IRIS.SystemPerformance
///
#define usernamePar "IRISUserName"
///
#define passwordPar "IRISPassword"
#else
///
#define pButtonsRoutine ^pButtons
///
#define pButtonsData ^pButtons
///
#define usernamePar "CacheUserName"
///
#define passwordPar "CachePassword"
#endif