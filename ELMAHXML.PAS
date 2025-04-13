{ @author: Sylvain Maltais (support@gladir.com)
  @created: 2025
  @website(https://www.gladir.com/CODER/ELMAH-0)
  @abstract(Target: Turbo Pascal 7, Free Pascal 3.2)
  @type: Library
}

Unit ELMAHXML;

INTERFACE

Procedure WriteErrorXml(Const FileName:String;ErrCode:Word;Const Msg,TypeMsg:String);

IMPLEMENTATION

Uses DOS,ELMAH;

Function PadRight(S:String;Space:Byte):String;
Var
 I:Byte;
Begin
 If Length(S)<Space Then For I:=Length(S)+1 to Space do S:=S+' ';
 PadRight:=S;
End;

Function PadZeroLeft(Value:Integer;Space:Byte):String;
Var
 S:String;
Begin
 Str(Value,S);
 While Length(S)<Space do S:='0'+S;
 PadZeroLeft:=S;
End;

Procedure WriteErrorXml(Const FileName:String;ErrCode:Word;Const Msg,TypeMsg:String);
Var
 f:Text;
 Year,Month,Day,DOW,Hour,Min,Sec,CentSec:Word;
Begin
 {$I-}Assign(f, FileName);
 Rewrite(f);{$I+}
 If IOResult<>0 Then Begin
  WriteLn('Impossibe de cr‚er un fichier XML');
  Halt;
 End;
 Writeln(f, '<error application="/',ELMAH.AppName,'"');
 Writeln(f, '       host="',ELMAH.HostName,'"');
 Writeln(f, '       type="',TypeMsg,'"');
 Writeln(f, '       message="',Msg,'"');
 Writeln(f, '       source="',ELMAH.MyProject,'"');
 Writeln(f, '       detail="',',TypeMsg,',': ..."');
 Write(f, '       time="');
 GetDate(Year,Month,Day,DOW);
 GetTime(Hour,Min,Sec,CentSec);
 Write(f,Year:4,'-',PadZeroLeft(Month,2),'-',
       PadZeroLeft(Day,2),' ',Hour:2,':',PadZeroLeft(Min,2),':',
       PadZeroLeft(Sec,2),'.',CentSec,' ');
 WriteLn(f, '"');
 Writeln(f, '       statusCode="',ErrCode,'"');
 Writeln(f, '       webHostHtmlMessage="',Msg,'">');
 WriteLn(f,'<serverVariables>');
 WriteLn(f,'   <item name="HTTP_HOST">');
 WriteLn(f,'     <value string="',ELMAH.HostName,':',ELMAH.PortNumber,'" />');
 WriteLn(f,'   </item>');
 WriteLn(f,'</serverVariables>');
 Writeln(f, '</error>');
 Close(f);
End;

END.