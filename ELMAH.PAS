{ @author: Sylvain Maltais (support@gladir.com)
  @created: 2025
  @website(https://www.gladir.com/CODER/ELMAH-0)
  @abstract(Target: Turbo Pascal 7, Free Pascal 3.2)
  @type: Library
}

Unit ELMAH;

INTERFACE

Var
 AppName:String;
 HostName:String;
 MyProject:String;
 PortNumber:Word;

Function GetFileNameError:String;
Procedure LogError(Const Msg:String);
Procedure SetFileNameError(FileName:String);

IMPLEMENTATION

Uses DOS;

Var
 FileNameError:String;

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

Function GetFileNameError:String;Begin
 GetFileNameError:=FileNameError;
End;

Procedure LogError(Const Msg:String);
Var
 FileError:Text;
 Year,Month,Day,DOW,Hour,Min,Sec,CentSec:Word;
Begin
 {$I-}Assign(FileError,FileNameError);
 Append(FileError);{$I+}
 If IoResult<>0 Then Begin
  {$I-}Rewrite(FileError);{$I+}
 End;
 If IOResult=0 Then Begin
  GetDate(Year,Month,Day,DOW);
  GetTime(Hour,Min,Sec,CentSec);
  Write(FileError,Year:4,'-',PadZeroLeft(Month,2),'-',
        PadZeroLeft(Day,2),' ',Hour:2,':',PadZeroLeft(Min,2),':',
        PadZeroLeft(Sec,2),'.',CentSec,' ');
  WriteLn(FileError,Msg);
  Close(FileError);
 End
  Else
 Begin
  WriteLn('Impossible d''‚crire le LOG d''erreur : ',FileNameError);
  Halt;
 End;
End;

Procedure SetFileNameError(FileName:String);Begin
 FileNameError:=FileName;
End;

BEGIN
 AppName:=ParamStr(0);
 HostName:='localhost';
 MyProject:='MonProject';
 PortNumber:=8080;
 {$IFDEF LINUX}
  FileNameError:='/var/log/error.log';
 {$ELSE}
  FileNameError:='error.log';
 {$ENDIF}
END.