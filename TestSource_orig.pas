procedure TFormPETesterMain.ButtonStartClick(Sender: TObject;a:integer);
var
  resCode:string; //test add space after : ; ,
  j,i:integer;
begin
  if TesterTerminalCOM<>nil then
  with ButtonStart do
    if tag=0 then begin
      Caption:='Stop 1+2'; //test non-interference with strings
      tag:=1+2+3*4*5/6/7; //test add spaces aroung binary operators
      tag:=-1+2+3mod 4xor-5; //a:=1+2; //test non-interference with slash-comments
      StatusBar1.Panels[0].Text:=TesterTerminalCOM.OpErrorCodeStr;
    end else begin 
      if tag>=-2 then Caption:='Start UDP://192.168.5.113';
      tag:=(0-1)*(2-3); {a:=1+2; test non-interference with old-comments; also test brackets}
      StatusBar1.Panels[0].Text:=TesterTerminalCOM.OpErrorCodeStr;
    end;

  resCode:='1+2'+'3'; //test binary operators after strings
  resCode:={comment}5+2; //test binary operators after comments

//test comments with diferent idents
//a:=1+2; // no-ident
  //a:=1+2; // space-ident
		//a:=1+2; // tab-ident 

//test AddNewLine before begin with diferent idents
if tag=0 then begin//test comment just after begin; no-ident
	if tag=0 then begin //test tab-ident 
end;

var //test non-deleting my new-lines
  RegTypesStr: array[TOSRegisterType] of string = (
    'Binary',
    'String',
    'RAW');

// test utf-8 support
      LabelLog.Caption := IntToStr(Resistance)+' Ω ' +
        'speed = ' + FloatToStrF(BytesReceived/TimePast,ffFixed,10,1) + ' B/s';

