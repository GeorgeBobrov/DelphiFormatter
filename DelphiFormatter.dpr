program DelphiFormatter;

uses
  Vcl.Forms,
  uFormDelphiFormatter in 'uFormDelphiFormatter.pas' {FormDelphiFormatter},
  uDelphiFormatter in 'uDelphiFormatter.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormDelphiFormatter, FormDelphiFormatter);
  Application.Run;
end.
