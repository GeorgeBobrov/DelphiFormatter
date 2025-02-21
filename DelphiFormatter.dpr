program DelphiFormatter;

uses
  Vcl.Forms,
  uFormDelphiFormatter in 'uFormDelphiFormatter.pas' {FormDelphiFormatter};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormDelphiFormatter, FormDelphiFormatter);
  Application.Run;
end.
