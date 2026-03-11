USING Progress.Lang.*.
USING OpenEdge.Web.WebResponseWriter.
USING OpenEdge.Net.HTTP.StatusCodeEnum.
USING OpenEdge.Web.WebHandler.
USING Progress.Json.ObjectModel.JsonObject.
USING Progress.Json.ObjectModel.JsonArray.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS employeeHandler INHERITS WebHandler:
    
    DEFINE TEMP-TABLE ttEmpmas NO-UNDO LIKE empmas.
    
    METHOD OVERRIDE PROTECTED INTEGER HandleNotAllowedMethod( INPUT poRequest AS OpenEdge.Web.IWebRequest ):
        UNDO, THROW NEW Progress.Lang.AppError("METHOD NOT IMPLEMENTED").
    END METHOD.
    
    METHOD OVERRIDE PROTECTED INTEGER HandleNotImplemented( INPUT poRequest AS OpenEdge.Web.IWebRequest ):  
        UNDO, THROW NEW Progress.Lang.AppError("METHOD NOT IMPLEMENTED").
    END METHOD.
    
    METHOD OVERRIDE PROTECTED INTEGER HandleGet( INPUT poRequest AS OpenEdge.Web.IWebRequest ):
        
    
        DEFINE VARIABLE oResponse AS OpenEdge.Net.HTTP.IHttpResponse      NO-UNDO.
        DEFINE VARIABLE oWriter   AS OpenEdge.Web.WebResponseWriter       NO-UNDO.
        DEFINE VARIABLE oJsonArr  AS JsonArray                            NO-UNDO.
        
        DEFINE VARIABLE cEmpno    AS CHARACTER NO-UNDO.
        DEFINE VARIABLE ix        AS INTEGER NO-UNDO.
        
        cEmpno = poRequest:GetPathParameter("id").
            
        ASSIGN 
            oResponse            = NEW OpenEdge.Web.WebResponse()
            oResponse:StatusCode = INTEGER(StatusCodeEnum:OK)
            oJsonArr             = NEW JsonArray().
            
        ix = 1.
        FOR EACH empmas 
            WHERE empmas.empno BEGINS cEmpno:
                
            CREATE ttEmpmas.
            BUFFER-COPY empmas TO ttEmpmas. 
            
            /* limit the data */
            IF ix = 100 THEN LEAVE. ELSE ix = ix + 1. 
        END.
        
        /* convert temp-table to json array */
        oJsonArr:Read(TEMP-TABLE ttEmpmas:HANDLE).
              
        ASSIGN 
            oResponse:Entity        = oJsonArr
            oResponse:ContentType   = 'application/json'.
        
        ASSIGN 
            oWriter = NEW WebResponseWriter(oResponse).
            
        oWriter:Open().
        oWriter:Close().
        
        RETURN 0.   
    END METHOD. 
END CLASS.