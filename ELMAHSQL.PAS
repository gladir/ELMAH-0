{ @author: Sylvain Maltais (support@gladir.com)
  @created: 2025
  @website(https://www.gladir.com/CODER/ELMAH-0)
  @abstract(Target: Turbo Pascal 7, Free Pascal 3.2)
  @type: Library
}

Unit ELMAHSQL;

INTERFACE

IMPLEMENTATION

Uses ELMAH;

Function WriteErrorSQL(ErrorId:LongInt;Const Application,Host,
                       TypeStr,Source,Msg,User:String;StatusCode:Word;
                       TimeUtc:LongInt;Url,AllXml:String):String;
Var
 CommandText:String;
 ErrorIdStr,StatusCodeStr,TimeUtcStr:String;
Begin
 Str(ErrorId,ErrorIdStr);
 Str(StatusCode,StatusCodeStr);
 Str(TimeUtc,TimeUtcStr);
 CommandText:='INSERT INTO ELMAH_Error ('+
               'ErrorId, Application, Host, Type,'+
               'Source, Message, User, StatusCode,'+
               'TimeUtc, Url, AllXml) VALUES ('+
                ErrorIdStr+', '+
                '"'+Application+'",'+
                '"'+Host+'",'','+
                '"'+TypeStr+'",'+
                '"'+Source+'",'+
                '"'+Msg+'",'+
                '"'+User+'",'+
                StatusCodeStr+','+
                TimeUtcStr+','+
                '"'+Url+'",'+
                '"'+AllXml+'")';
End;

END.