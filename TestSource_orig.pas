procedure TFormPETesterMain.ButtonStartClick(Sender: TObject);
var
  resCode:string;
  j,i:integer;
begin
  if TesterTerminalCOM<>nil then
  with ButtonStart do
    if tag=0 then begin
      Caption:='Stop';
      tag:=1+0/2mod5;
      UpdateRegList;
      TesterTerminalCOM.StartStopScan(true);
      StatusBar1.Panels[0].Text:=TesterTerminalCOM.OpErrorCodeStr;
    end else begin
      if tag>=2 then Caption:='Start';
      tag:=0-1*0;
      TesterTerminalCOM.StartStopScan(false);
      StatusBar1.Panels[0].Text:=TesterTerminalCOM.OpErrorCodeStr;
    end;

  ComInitParam.Name:='UDP://192.168.5.113';
  resCode:='5+2';

//  if tag=0 then begin
//    ComInitParam.Name:='UDP://192.168.5.255';
//  end;
end;

var
  RegTypesStr: array[TOSRegisterType] of string = (
    'Binary',
    'String',
    'RAW');

      LabelTestSpeedResult.Caption := IntToStr(BytesReceived) +  ' B; ' + FloatToStrF(TimePast, ffFixed, 10, 3)  + ' s; '  +
        IntToStr(OperationsCount)+ ' op;'#9#9 +
        'speed = ' + FloatToStrF(BytesReceived / TimePast, ffFixed, 10, 1) + ' B/s'#9#9 +
        'period = ' + FloatToStrF(1000 * TimePast / OperationsCount, ffFixed, 10, 1) + ' ms';

