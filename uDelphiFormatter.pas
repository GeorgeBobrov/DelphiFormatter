unit uDelphiFormatter;

interface

uses System.Classes, System.RegularExpressions, StrUtils, Generics.Collections;

type
  TFormatterConfig = record
    AddNewLine: Boolean;
    AddNewLineKeyWords: string;
    AddSpacesAroundBinOps1: Boolean;
    AddSpacesAroundBinOpsWord: Boolean;
    AddSpaceAfterColon: Boolean;
    AddSpaceAfterColonChars: string;
  end;

function FormatDelphiCode(Input: string; CodeStrings: TList<string>; FormatterConfig: TFormatterConfig): string;

implementation

function AddNewLine(Input: string; KeyWord: string): string;
var
  RegEx: TRegEx;
  RegExpStr: string;
begin
  RegExpStr := '([ \t]*)(.+?)\b (' + KeyWord + ')';
  RegEx := TRegEx.Create(RegExpStr, [roMultiLine]);
  Result := RegEx.Replace(Input, '\1\2' + sLineBreak + '\1\3');
end;


function AddSpacesAroundBinaryOperators1(Input: string; Op: string): string;
var
  RegEx: TRegEx;
  RegExpStr: string;
begin
  RegExpStr := '([A-Za-z_\d''")])(' + Op + ')';
  RegEx := TRegEx.Create(RegExpStr, [roMultiLine]);
  Result := RegEx.Replace(Input, '\1 \2');

  RegExpStr := '(' + Op + ')([-A-Za-z_\d''"(])';
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


procedure SkipCommentsAndStrings(Input: string; Op: string; var PartToProcess, PartToSkip: string);
var
  RegEx: TRegEx;
  RegExpStr: string;
  Match: TMatch;
begin
  RegExpStr := '^(.*?)(' + Op + '.*)';
  RegEx := TRegEx.Create(RegExpStr, [roMultiLine]);
  Match := RegEx.Match(Input);

  PartToProcess := Input;

  if Match.Success then
  begin
    PartToProcess := Match.Groups[1].Value;
    PartToSkip := Match.Groups[2].Value + PartToSkip;
  end
end;


//------------------------------------- Process -------------------------------------------


function FormatDelphiCodeCleaned(Input: string; FormatterConfig: TFormatterConfig): string;
var
  KeyWords: TArray<string>;
  FormattedCode: string;
  KeyWord: string;
begin
  FormattedCode := Input;

  // Add new line before some KeyWords
  if FormatterConfig.AddNewLine then
  begin
    KeyWords := SplitString(FormatterConfig.AddNewLineKeyWords, ' ');
    for KeyWord in KeyWords do
      FormattedCode := AddNewLine(FormattedCode, KeyWord);
  end;

  // Add Spaces Around Binary Operators
  if FormatterConfig.AddSpacesAroundBinOps1 then
  begin
    KeyWords := ['\+', '\-', '\*', '\/', '=', '<', '>', '>=', '<=', '<>', ':='];
    for KeyWord in KeyWords do
      FormattedCode := AddSpacesAroundBinaryOperators1(FormattedCode, KeyWord);
  end;

  if FormatterConfig.AddSpacesAroundBinOpsWord then
  begin
    // Строковые операторы (div, mod, and, or, xor, as, is, in)
    KeyWords := ['div', 'mod', 'and', 'or', 'xor'];
    for KeyWord in KeyWords do
      FormattedCode := AddSpacesAroundBinaryOperatorsWord(FormattedCode, KeyWord);
  end;

  // Add Space After Colon
  if FormatterConfig.AddSpaceAfterColon then
  begin
    KeyWords := SplitString(FormatterConfig.AddSpaceAfterColonChars, ' ');
    for KeyWord in KeyWords do
      FormattedCode := AddSpaceAfterColon(FormattedCode, KeyWord);
  end;

  Result := FormattedCode;
end;


function FormatDelphiCode(Input: string; CodeStrings: TList<string>; FormatterConfig: TFormatterConfig): string;
var
  i: Integer;
  StrList: TStringList;
  PartToProcess, PartToSkit: string;
  LastChar: Char;
begin
  if (CodeStrings = nil) then
  begin
    CodeStrings := TList<string>.Create;

    StrList := TStringList.Create;
    StrList.Text := Input;

    CodeStrings.AddRange(StrList.ToStringArray);
  end;

  for i := 0 to CodeStrings.Count - 1 do // process line by line
  begin
    PartToProcess := CodeStrings[i];
    PartToSkit := '';
    // Skip Comments
    SkipCommentsAndStrings(PartToProcess, '\/\/', PartToProcess, PartToSkit);
    SkipCommentsAndStrings(PartToProcess, '{', PartToProcess, PartToSkit);
    // Skip Strings
    SkipCommentsAndStrings(PartToProcess, '''', PartToProcess, PartToSkit);

    PartToProcess := FormatDelphiCodeCleaned(PartToProcess, FormatterConfig);

    // Workaround to add space after = and before string
    if (Length(PartToProcess) > 0) and (Length(PartToSkit) > 0) then
    begin
      LastChar := PartToProcess[Length(PartToProcess)];
      if ((LastChar = '=') or (LastChar = '+')) and (PartToSkit[1] = '''') then
        PartToProcess := PartToProcess + ' ';
    end;

    CodeStrings[i] := PartToProcess + PartToSkit;
  end;

  for i := 0 to CodeStrings.Count - 1 do
    Result := Result + CodeStrings[i] + sLineBreak;
//    MemoResult.Lines.Add(CodeStrings[i])
end;

end.
