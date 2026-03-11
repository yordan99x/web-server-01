USING Progress.Lang.*.
USING OpenEdge.Web.WebResponseWriter.
USING OpenEdge.Net.HTTP.StatusCodeEnum.
USING OpenEdge.Web.WebHandler.
USING Progress.Json.ObjectModel.JsonObject.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS healthHandler INHERITS WebHandler:
	METHOD OVERRIDE PROTECTED INTEGER HandleNotAllowedMethod( INPUT poRequest AS OpenEdge.Web.IWebRequest ):
		UNDO, THROW NEW Progress.Lang.AppError("METHOD NOT IMPLEMENTED").
	END METHOD.
	
	METHOD OVERRIDE PROTECTED INTEGER HandleNotImplemented( INPUT poRequest AS OpenEdge.Web.IWebRequest ):	
		UNDO, THROW NEW Progress.Lang.AppError("METHOD NOT IMPLEMENTED").
   	END METHOD.
   	
 	METHOD OVERRIDE PROTECTED INTEGER HandleGet( INPUT poRequest AS OpenEdge.Web.IWebRequest ):
 	
        DEFINE VARIABLE oResponse AS OpenEdge.Net.HTTP.IHttpResponse      NO-UNDO.
        DEFINE VARIABLE oWriter   AS OpenEdge.Web.WebResponseWriter       NO-UNDO.
        DEFINE VARIABLE oJson     AS JsonObject                           NO-UNDO.
            
        ASSIGN 
            oResponse            = NEW OpenEdge.Web.WebResponse()
            oResponse:StatusCode = INTEGER(StatusCodeEnum:OK)
            oJson                = NEW JsonObject().
            
        oJson:Add("status", "running").
        
        ASSIGN 
            oResponse:Entity        = oJson
            oResponse:ContentType   = 'application/json'.
        
        ASSIGN 
            oWriter = NEW WebResponseWriter(oResponse).
            
        oWriter:Open().
        oWriter:Close().
        
        RETURN 0.	
 	END METHOD. 
END CLASS.