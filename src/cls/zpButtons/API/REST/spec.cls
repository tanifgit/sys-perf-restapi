Class zpButtons.API.REST.spec Extends %REST.Spec [ ProcedureBlock ]
{

XData OpenAPI [ MimeType = application/json ]
{
{
  "info":{
    "title":"",
    "description":"",
    "version":"",
    "x-ISC_Namespace":"%SYS"
  },
  "basePath":"/pButtons",
  "paths":{
    "/profileMgmt/{name}/{description}/{interval}/{count}":{
      "post":{
        "parameters":[
          {
            "name":"name",
            "in":"path",
            "required":true,
            "type":"string"
          },
          {
            "name":"description",
            "in":"path",
            "required":true,
            "type":"string"
          },
          {
            "name":"interval",
            "in":"path",
            "required":true,
            "type":"string"
          },
          {
            "name":"count",
            "in":"path",
            "required":true,
            "type":"string"
          },
          {
            "name":"payloadBody",
            "in":"body",
            "description":"Request body contents",
            "required":false,
            "schema":{
              "type":"string"
            }
          }
        ],
        "operationId":"CreateProfilePerCount",
        "x-ISC_ServiceMethod":"CreateProfilePerCount",
        "x-ISC_CORS":true,
        "responses":{
          "default":{
            "description":"(Unexpected Error)"
          },
          "200":{
            "description":"(Expected Result)"
          }
        }
      },
      "put":{
        "parameters":[
          {
            "name":"name",
            "in":"path",
            "required":true,
            "type":"string"
          },
          {
            "name":"description",
            "in":"path",
            "required":true,
            "type":"string"
          },
          {
            "name":"interval",
            "in":"path",
            "required":true,
            "type":"string"
          },
          {
            "name":"count",
            "in":"path",
            "required":true,
            "type":"string"
          },
          {
            "name":"payloadBody",
            "in":"body",
            "description":"Request body contents",
            "required":false,
            "schema":{
              "type":"string"
            }
          }
        ],
        "operationId":"EditProfile",
        "x-ISC_ServiceMethod":"EditProfile",
        "x-ISC_CORS":true,
        "responses":{
          "default":{
            "description":"(Unexpected Error)"
          },
          "200":{
            "description":"(Expected Result)"
          }
        }
      }
    },
    "/profileMgmt/{duration}/{interval}":{
      "post":{
        "parameters":[
          {
            "name":"duration",
            "in":"path",
            "required":true,
            "type":"string"
          },
          {
            "name":"interval",
            "in":"path",
            "required":true,
            "type":"string"
          },
          {
            "name":"payloadBody",
            "in":"body",
            "description":"Request body contents",
            "required":false,
            "schema":{
              "type":"string"
            }
          }
        ],
        "operationId":"CreateProfilePerDuration",
        "x-ISC_ServiceMethod":"CreateProfilePerDuration",
        "x-ISC_CORS":true,
        "responses":{
          "default":{
            "description":"(Unexpected Error)"
          },
          "200":{
            "description":"(Expected Result)"
          }
        }
      }
    },
    "/profileMgmt/{name}":{
      "delete":{
        "parameters":[
          {
            "name":"name",
            "in":"path",
            "required":true,
            "type":"string"
          }
        ],
        "operationId":"DeleteProfile",
        "x-ISC_ServiceMethod":"DeleteProfile",
        "x-ISC_CORS":true,
        "responses":{
          "default":{
            "description":"(Unexpected Error)"
          },
          "200":{
            "description":"(Expected Result)"
          }
        }
      },
      "get":{
        "parameters":[
          {
            "name":"name",
            "in":"path",
            "required":true,
            "type":"string"
          }
        ],
        "operationId":"GetProfile",
        "x-ISC_ServiceMethod":"GetProfile",
        "x-ISC_CORS":true,
        "responses":{
          "default":{
            "description":"(Unexpected Error)"
          },
          "200":{
            "description":"(Expected Result)"
          }
        }
      }
    },
    "/profileMgmt":{
      "get":{
        "operationId":"GetProfiles",
        "x-ISC_ServiceMethod":"GetProfiles",
        "x-ISC_CORS":true,
        "responses":{
          "default":{
            "description":"(Unexpected Error)"
          },
          "200":{
            "description":"(Expected Result)"
          }
        },
        "description":"gets a list of all the currently defined profiles"
      }
    },
    "/profileMgmtCopy/{name}/{newName}":{
      "post":{
        "parameters":[
          {
            "name":"name",
            "in":"path",
            "required":true,
            "type":"string"
          },
          {
            "name":"newName",
            "in":"path",
            "required":true,
            "type":"string"
          },
          {
            "name":"payloadBody",
            "in":"body",
            "description":"Request body contents",
            "required":false,
            "schema":{
              "type":"string"
            }
          }
        ],
        "operationId":"CopyProfile",
        "x-ISC_ServiceMethod":"CopyProfile",
        "x-ISC_CORS":true,
        "responses":{
          "default":{
            "description":"(Unexpected Error)"
          },
          "200":{
            "description":"(Expected Result)"
          }
        }
      }
    },
    "/runMgmt/{profile}":{
      "post":{
        "parameters":[
          {
            "name":"profile",
            "in":"path",
            "required":true,
            "type":"string"
          },
          {
            "name":"payloadBody",
            "in":"body",
            "description":"Request body contents",
            "required":false,
            "schema":{
              "type":"string"
            }
          }
        ],
        "operationId":"RunProfile",
        "x-ISC_ServiceMethod":"RunProfile",
        "x-ISC_CORS":true,
        "responses":{
          "default":{
            "description":"(Unexpected Error)"
          },
          "200":{
            "description":"(Expected Result)"
          }
        }
      }
    },
    "/runMgmt/{profile}/{liteRun}":{
      "post":{
        "parameters":[
          {
            "name":"profile",
            "in":"path",
            "required":true,
            "type":"string"
          },
          {
            "name":"liteRun",
            "in":"path",
            "required":true,
            "type":"string"
          },
          {
            "name":"payloadBody",
            "in":"body",
            "description":"Request body contents",
            "required":false,
            "schema":{
              "type":"string"
            }
          }
        ],
        "operationId":"RunProfile01",
        "x-ISC_ServiceMethod":"RunProfile",
        "x-ISC_CORS":true,
        "responses":{
          "default":{
            "description":"(Unexpected Error)"
          },
          "200":{
            "description":"(Expected Result)"
          }
        }
      }
    },
    "/runMgmt":{
      "get":{
        "operationId":"GetWaitTimeForCurrentRuns",
        "x-ISC_ServiceMethod":"GetWaitTimeForCurrentRuns",
        "x-ISC_CORS":true,
        "responses":{
          "default":{
            "description":"(Unexpected Error)"
          },
          "200":{
            "description":"(Expected Result)"
          }
        }
      }
    },
    "/runMgmt/{runId}":{
      "get":{
        "parameters":[
          {
            "name":"runId",
            "in":"path",
            "required":true,
            "type":"string"
          }
        ],
        "operationId":"GetWaitTimeForRunId",
        "x-ISC_ServiceMethod":"GetWaitTimeForRunId",
        "x-ISC_CORS":true,
        "responses":{
          "default":{
            "description":"(Unexpected Error)"
          },
          "200":{
            "description":"(Expected Result)"
          }
        }
      },
      "delete":{
        "parameters":[
          {
            "name":"runId",
            "in":"path",
            "required":true,
            "type":"string"
          }
        ],
        "operationId":"StopRun",
        "x-ISC_ServiceMethod":"StopRun",
        "x-ISC_CORS":true,
        "responses":{
          "default":{
            "description":"(Unexpected Error)"
          },
          "200":{
            "description":"(Expected Result)"
          }
        }
      },
      "put":{
        "parameters":[
          {
            "name":"runId",
            "in":"path",
            "required":true,
            "type":"string"
          },
          {
            "name":"payloadBody",
            "in":"body",
            "description":"Request body contents",
            "required":false,
            "schema":{
              "type":"string"
            }
          }
        ],
        "operationId":"CreatePreviewReport",
        "x-ISC_ServiceMethod":"CreatePreviewReport",
        "x-ISC_CORS":true,
        "responses":{
          "default":{
            "description":"(Unexpected Error)"
          },
          "200":{
            "description":"(Expected Result)"
          }
        }
      }
    },
    "/runMgmt/{runId}/{delete}":{
      "delete":{
        "parameters":[
          {
            "name":"runId",
            "in":"path",
            "required":true,
            "type":"string"
          },
          {
            "name":"delete",
            "in":"path",
            "required":true,
            "type":"string"
          }
        ],
        "operationId":"StopRun01",
        "x-ISC_ServiceMethod":"StopRun",
        "x-ISC_CORS":true,
        "responses":{
          "default":{
            "description":"(Unexpected Error)"
          },
          "200":{
            "description":"(Expected Result)"
          }
        }
      }
    },
    "/runMgmtPrevious":{
      "get":{
        "operationId":"GetPreviousRuns",
        "x-ISC_ServiceMethod":"GetPreviousRuns",
        "x-ISC_CORS":true,
        "responses":{
          "default":{
            "description":"(Unexpected Error)"
          },
          "200":{
            "description":"(Expected Result)"
          }
        }
      }
    },
    "/generalMgmt/logFolder":{
      "get":{
        "operationId":"GetLogFolder",
        "x-ISC_ServiceMethod":"GetLogFolder",
        "x-ISC_CORS":true,
        "responses":{
          "default":{
            "description":"(Unexpected Error)"
          },
          "200":{
            "description":"(Expected Result)"
          }
        },
        "description":"returns the current folder location for the output log files"
      },
      "put":{
        "parameters":[
          {
            "name":"payloadBody",
            "in":"body",
            "description":"Request body contents",
            "required":false,
            "schema":{
              "type":"string"
            }
          }
        ],
        "operationId":"SetLogFolder",
        "x-ISC_ServiceMethod":"SetLogFolder",
        "x-ISC_CORS":true,
        "responses":{
          "default":{
            "description":"(Unexpected Error)"
          },
          "200":{
            "description":"(Expected Result)"
          }
        },
        "description":"changes the output log files folder location to a new value"
      },
      "post":{
        "parameters":[
          {
            "name":"payloadBody",
            "in":"body",
            "description":"Request body contents",
            "required":false,
            "schema":{
              "type":"string"
            }
          }
        ],
        "operationId":"ResetLogFolder",
        "x-ISC_ServiceMethod":"ResetLogFolder",
        "x-ISC_CORS":true,
        "responses":{
          "default":{
            "description":"(Unexpected Error)"
          },
          "200":{
            "description":"(Expected Result)"
          }
        },
        "description":"resets the folder location to the default value"
      }
    },
    "/generalMgmt/version":{
      "get":{
        "operationId":"GetVersion",
        "x-ISC_ServiceMethod":"GetVersion",
        "x-ISC_CORS":true,
        "responses":{
          "default":{
            "description":"(Unexpected Error)"
          },
          "200":{
            "description":"(Expected Result)"
          }
        }
      }
    }
  },
  "swagger":"2.0"
}
}

}
