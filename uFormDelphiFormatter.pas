unit uFormDelphiFormatter;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.RegularExpressions, Vcl.StdCtrls,
  Vcl.ExtCtrls, Types, StrUtils, IniFiles, IOUtils, ShellAPI;

type
  TFormDelphiFormatter = class(TForm)
    MemoSource: TMemo;
    PanelBottom: TPanel;
    MemoResult: TMemo;
    Splitter1: TSplitter;
    ButtonProcess: TButton;
    ButtonCopyResultToSource: TButton;
    GroupBox2: TGroupBox;
    CheckBoxAddSpacesAroundBinOps1: TCheckBox;
    CheckBoxAddSpacesAroundBinOpsWord: TCheckBox;
    EditAddNewLine: TEdit;
    CheckBoxAddNewLine: TCheckBox;
    CheckBoxAddSpaceAfterColon: TCheckBox;
    EditAddSpaceAfterColon: TEdit;
    PanelSource: TPanel;
    PanelResult: TPanel;
    Label1: TLabel;
    ButtonFormatAllFilesInDir: TButton;
    ButtonSaveConfig: TButton;
    PanelSettings: TPanel;
    PanelCommands: TPanel;
    Label3: TLabel;
    ButtonLoadConfig: TButton;
    OpenDialogConfig: TOpenDialog;
    SaveDialogConfig: TSaveDialog;
    LabelSourceFile: TLabel;
    OpenDialogPas: TOpenDialog;
    SaveDialogPas: TSaveDialog;
    ButtonOpen: TButton;
    PanelSourceTitle: TPanel;
    MemoProcessedFiles: TMemo;
    FlowPanel1: TFlowPanel;
    PanelResultTitle: TPanel;
    Label4: TLabel;
    LabelResultFile: TLabel;
    ButtonSave: TButton;
    OpenDialogDir: TOpenDialog;
    procedure ButtonProcessClick(Sender: TObject);
    procedure ButtonCopyResultToSourceClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ButtonSaveConfigClick(Sender: TObject);
    procedure ButtonLoadConfigClick(Sender: TObject);
    procedure ButtonFormatAllFilesInDirClick(Sender: TObject);
    procedure ButtonOpenClick(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Splitter1Moved(Sender: TObject);
  private
    { Private declarations }
    procedure WMDropFiles(var Msg: TWMDropFiles); message WM_DROPFILES;
  public
    { Public declarations }
    PanelsWidthRatio: extended;

    procedure LoadConfig(IniFileName: string);
    procedure SaveConfig(IniFileName: string);
  end;

var
  FormDelphiFormatter: TFormDelphiFormatter;

implementation
{$R *.dfm}


function AddNewLine(Input: string; KeyWord: string): string;
var
  RegEx: TRegEx;
  RegExpStr: string;
begin
  RegExpStr := '( +)(.+?)\b (' + KeyWord + ')';
  RegEx := TRegEx.Create(RegExpStr, [roMultiLine]);
  Result := RegEx.Replace(Input, '\1\2' + sLineBreak + '\1\3');
end;


function AddSpacesAroundBinaryOperators1(Input: string; Op: string): string;
var
  RegEx: TRegEx;
  RegExpStr: string;
begin
  RegExpStr := '([A-Za-z_\d''"])(' + Op + ')';
  RegEx := TRegEx.Create(RegExpStr, [roMultiLine]);
  Result := RegEx.Replace(Input, '\1 \2');

  RegExpStr := '(' + Op + ')([A-Za-z_\d''"])';
  RegEx := TRegEx.Create(RegExpStr, [roMultiLine]);
  Result := RegEx.Replace(Result, '\1 \2');
end;


function AddSpacesAroundBinaryOperatorsWord(Input: string; Op: string): string;
var
  RegEx: TRegEx;
  RegExpStr: string;
begin
  RegExpStr := '([\d])(' + Op + ')';
  RegEx := TRegEx.Create(RegExpStr, [roMultiLine]);
  Result := RegEx.Replace(Input, '\1 \2');

  RegExpStr := '(' + Op + ')([\d])';
  RegEx := TRegEx.Create(RegExpStr, [roMultiLine]);
  Result := RegEx.Replace(Result, '\1 \2');
end;


function AddSpaceAfterColon(Input: string; Op: string): string;
var
  RegEx: TRegEx;
  RegExpStr: string;
begin
  RegExpStr := '(' + Op + ')([A-Za-z_\d''"])';
  RegEx := TRegEx.Create(RegExpStr, [roMultiLine]);
  Result := RegEx.Replace(Input, '\1 \2');
end;


//------------------------------------- Process -------------------------------------------


procedure TFormDelphiFormatter.ButtonProcessClick(Sender: TObject);
var
  KeyWords: TArray<string>;
  FormattedCode: string;
  KeyWord: string;
begin
  FormattedCode := MemoSource.Text;

  // Add new line before some KeyWords
  if CheckBoxAddNewLine.Checked then
  begin
    KeyWords := SplitString(EditAddNewLine.Text, ' ');
    for KeyWord in KeyWords do
      FormattedCode := AddNewLine(FormattedCode, KeyWord);
  end;

  // Add Spaces Around Binary Operators
  if CheckBoxAddSpacesAroundBinOps1.Checked then
  begin
    KeyWords := ['\+', '\-', '\*', '\/', '=', '<', '>', '>=', '<=', '<>', ':='];
    for KeyWord in KeyWords do
      FormattedCode := AddSpacesAroundBinaryOperators1(FormattedCode, KeyWord);
  end;

  if CheckBoxAddSpacesAroundBinOpsWord.Checked then
  begin
    // Строковые операторы (div, mod, and, or, xor, as, is, in)
    KeyWords := ['div', 'mod', 'and', 'or', 'xor'];
    for KeyWord in KeyWords do
      FormattedCode := AddSpacesAroundBinaryOperatorsWord(FormattedCode, KeyWord);
  end;

  // Add Space After Colon
  if CheckBoxAddSpaceAfterColon.Checked then
  begin
    KeyWords := SplitString(EditAddSpaceAfterColon.Text, ' ');
    for KeyWord in KeyWords do
      FormattedCode := AddSpaceAfterColon(FormattedCode, KeyWord);
  end;

  MemoResult.Text := FormattedCode;
end;



procedure TFormDelphiFormatter.ButtonCopyResultToSourceClick(Sender: TObject);
begin
  MemoSource.Text := MemoResult.Text;
end;



procedure TFormDelphiFormatter.FormCreate(Sender: TObject);
var
  IniList: TStringList;
  i: Integer;
  SourceFileName, ResultFileName: string;

  AutoProcessAndClose: Boolean;
begin
  DragAcceptFiles(Handle, true);

  PanelsWidthRatio := 0.5;
  PanelSource.Width := Trunc(Self.Width * PanelsWidthRatio) - 2;

  IniList := TStringList.Create;

  for i := 1 to ParamCount do
    IniList.Add(ParamStr(i));

  // if exist param with .ini, load that ini
  for i := 0 to IniList.Count - 1 do
    if EndsText(IniList[i], '.conf') then
    begin
      OpenDialogConfig.FileName := IniList.Values['conf'];
      IniList.Delete(i);
      break;
    end;

  // else load default ApplicationExeName.conf
  if (OpenDialogConfig.FileName = '') then
    OpenDialogConfig.FileName := ChangeFileExt(Application.ExeName, '.conf');

  LoadConfig(OpenDialogConfig.FileName);

  // first param - SourceFileName
  if (IniList.Count >= 1) then
    SourceFileName := IniList[0];

  // if there are no more params, or there is param auto - auto process file
  AutoProcessAndClose := (IniList.Count = 1) or (IniList.IndexOfName('auto') >= 0);

  ResultFileName := IniList.Values['ResultFile'];
  LabelResultFile.Caption := ResultFileName;

  if (SourceFileName <> '') then
  begin
    MemoSource.Lines.LoadFromFile(SourceFileName);
    LabelSourceFile.Caption := ExpandFileName(SourceFileName);
  end;

  if AutoProcessAndClose then
  begin
    if (SourceFileName <> '') then
      ButtonProcessClick(Self);

    if (ResultFileName <> '') then
      MemoResult.Lines.SaveToFile(ResultFileName)
    else
      MemoResult.Lines.SaveToFile(SourceFileName);

    Close;
  end;
end;




procedure TFormDelphiFormatter.ButtonFormatAllFilesInDirClick(Sender: TObject);
var CurDir, FileName: String;
begin
  if (OpenDialogDir.FileName = '') then
    OpenDialogDir.InitialDir := ExtractFilePath(Application.ExeName);

  if OpenDialogDir.Execute then
  begin
    CurDir := ExtractFilePath(OpenDialogDir.FileName);
    MemoProcessedFiles.Visible := true;

    for FileName in TDirectory.GetFiles(CurDir, '*.pas') do
      if (FileName <> '') then
      begin
        MemoSource.Lines.LoadFromFile(FileName);
        LabelSourceFile.Caption := FileName;

        ButtonProcessClick(Self);

        MemoResult.Lines.SaveToFile(FileName);

        MemoProcessedFiles.Lines.Add(FileName);
      end;

  end;

end;


//------------------------------------- Open / Save -------------------------------------------


procedure TFormDelphiFormatter.ButtonOpenClick(Sender: TObject);
begin
  if (LabelSourceFile.Caption <> '') then
  begin
    OpenDialogPas.InitialDir := ExtractFilePath(LabelSourceFile.Caption);
    OpenDialogPas.FileName := ExtractFileName(LabelSourceFile.Caption);
  end;

  if OpenDialogPas.Execute then
    MemoSource.Lines.LoadFromFile(OpenDialogPas.FileName);
end;


procedure TFormDelphiFormatter.ButtonSaveClick(Sender: TObject);
begin
  if (LabelResultFile.Caption <> '') then
  begin
    SaveDialogPas.InitialDir := ExtractFilePath(LabelResultFile.Caption);
    SaveDialogPas.FileName := ExtractFileName(LabelResultFile.Caption);
  end
  else
    if (LabelSourceFile.Caption <> '') then
    begin
      SaveDialogPas.InitialDir := ExtractFilePath(LabelSourceFile.Caption);
      SaveDialogPas.FileName := ExtractFileName(LabelSourceFile.Caption);
    end;

  if SaveDialogPas.Execute then
  begin
    MemoResult.Lines.SaveToFile(SaveDialogPas.FileName);
    LabelResultFile.Caption := SaveDialogPas.FileName;
  end;

end;


procedure TFormDelphiFormatter.WMDropFiles(var Msg: TWMDropFiles);
const
  maxlen = 254;
var
  h: THandle;
  pchr: array[0..maxlen] of char;
  i, num: integer;
  FileName: string;
begin
  h := Msg.Drop;

  num := DragQueryFile(h, Dword(- 1), nil, 0);
  if num > 1 then num := 1; //dont process multiple drops

  for i := 0 to num - 1 do
  begin
    DragQueryFile(h, i, pchr, maxlen);
    FileName := string(pchr);
    MemoSource.Lines.LoadFromFile(FileName);
    LabelSourceFile.Caption := FileName;
  end;

  DragFinish(h);
end;


//------------------------------------- Config -------------------------------------------


procedure TFormDelphiFormatter.ButtonSaveConfigClick(Sender: TObject);
begin
  SaveDialogConfig.FileName := OpenDialogConfig.FileName;
  if SaveDialogConfig.Execute then
    SaveConfig(SaveDialogConfig.FileName);
end;


procedure TFormDelphiFormatter.ButtonLoadConfigClick(Sender: TObject);
begin
  if OpenDialogConfig.Execute then
    LoadConfig(OpenDialogConfig.FileName);
end;




procedure TFormDelphiFormatter.LoadConfig(IniFileName: string);
var
  IniFile: TMemIniFile;
begin
  IniFile := TMemIniFile.Create(IniFileName);

  CheckBoxAddNewLine.Checked := IniFile.ReadBool('Common', 'AddNewLine', CheckBoxAddNewLine.Checked);
  EditAddNewLine.Text := IniFile.ReadString('Common', 'AddNewLineKeyWords', EditAddNewLine.Text);
  CheckBoxAddSpacesAroundBinOps1.Checked := IniFile.ReadBool('Common', 'AddSpacesAroundBinOps1', CheckBoxAddSpacesAroundBinOps1.Checked);
  CheckBoxAddSpacesAroundBinOpsWord.Checked := IniFile.ReadBool('Common', 'AddSpacesAroundBinOpsWord', CheckBoxAddSpacesAroundBinOpsWord.Checked);
  CheckBoxAddSpaceAfterColon.Checked := IniFile.ReadBool('Common', 'AddSpaceAfterColon', CheckBoxAddSpaceAfterColon.Checked);
  EditAddSpaceAfterColon.Text := IniFile.ReadString('Common', 'AddSpaceAfterColonList', EditAddSpaceAfterColon.Text);

  FreeAndNil(IniFile);
end;


procedure TFormDelphiFormatter.SaveConfig(IniFileName: string);
var
  IniFile: TMemIniFile;
begin
  IniFile := TMemIniFile.Create(IniFileName);

  IniFile.WriteBool('Common', 'AddNewLine', CheckBoxAddNewLine.Checked);
  IniFile.WriteString('Common', 'AddNewLineKeyWords', EditAddNewLine.Text);
  IniFile.WriteBool('Common', 'AddSpacesAroundBinOps1', CheckBoxAddSpacesAroundBinOps1.Checked);
  IniFile.WriteBool('Common', 'AddSpacesAroundBinOpsWord', CheckBoxAddSpacesAroundBinOpsWord.Checked);
  IniFile.WriteBool('Common', 'AddSpaceAfterColon', CheckBoxAddSpaceAfterColon.Checked);
  IniFile.WriteString('Common', 'AddSpaceAfterColonList', EditAddSpaceAfterColon.Text);

  IniFile.UpdateFile;
  FreeAndNil(IniFile);
end;



//------------------------------------- GUI tricks -------------------------------------------


procedure TFormDelphiFormatter.FormResize(Sender: TObject);
begin
  FlowPanel1.Height := 1000;

  PanelSource.Width := Trunc(Self.Width * PanelsWidthRatio) - 2;
end;

procedure TFormDelphiFormatter.Splitter1Moved(Sender: TObject);
begin
  PanelsWidthRatio := (PanelSource.Width + 2) / Self.Width;
end;

end.




