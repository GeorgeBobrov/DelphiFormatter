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
  RegEx := TRegEx.Create(RegExpStr, [roMultiLine, roIgnoreCase]);
  Result := RegEx.Replace(Input, '\1\2' + sLineBreak + '\1\3');
end;


function AddSpacesAroundBinaryOperatorSymbol(Input: string; Op: string): string;
var
  RegEx: TRegEx;
  RegExpStr: string;
begin
  RegExpStr := '([\w''"\])])(' + Op + ')';
  RegEx := TRegEx.Create(RegExpStr, [roMultiLine, roIgnoreCase]);
  Result := RegEx.Replace(Input, '\1 \2');

  RegExpStr := '(' + Op + ')([-\w''"([])';
  RegEx := TRegEx.Create(RegExpStr, [roMultiLine, roIgnoreCase]);
  Result := RegEx.Replace(Result, '\1 \2');
end;


function AddSpacesAroundOperatorSymbol(Input: string; Op: string): string;
var
  RegEx: TRegEx;
  RegExpStr: string;
begin
  RegExpStr := '([^e( ])(' + Op + ')';
  RegEx := TRegEx.Create(RegExpStr, [roMultiLine, roIgnoreCase]);
  Result := RegEx.Replace(Input, '\1 \2');

  RegExpStr := '([^e=<>(\*\/ ])( *)(' + Op + ')([\w''"([])';
  RegEx := TRegEx.Create(RegExpStr, [roMultiLine, roIgnoreCase]);
  Result := RegEx.Replace(Result, '\1\2\3 \4');

  // Process one more time, because one of 4 match groups may capture next operator sequence,
  // and than that next operator will be unprocessed
  Result := RegEx.Replace(Result, '\1\2\3 \4');
end;


function AddSpacesAroundBinaryOperatorWord(Input: string; Op: string): string;
var
  RegEx: TRegEx;
  RegExpStr: string;
begin
  RegExpStr := '([\d])(' + Op + ')';
  RegEx := TRegEx.Create(RegExpStr, [roMultiLine, roIgnoreCase]);
  Result := RegEx.Replace(Input, '\1 \2');
end;


function AddSpaceAfterColon(Input: string; Op: string): string;
var
  RegEx: TRegEx;
  RegExpStr: string;
begin
  RegExpStr := '(' + Op + ')([\w''"])';
  RegEx := TRegEx.Create(RegExpStr, [roMultiLine, roIgnoreCase]);
  Result := RegEx.Replace(Input, '\1 \2');
end;


procedure SkipComments(Input: string; Op: string; var PartToProcess, PartToSkip: string);
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
    KeyWords := ['\*', '\/', '=', '>=', '<=', '<>', ':='];
    for KeyWord in KeyWords do
      FormattedCode := AddSpacesAroundBinaryOperatorSymbol(FormattedCode, KeyWord);

    // Workaround for < > in Generics, like TList<Byte>
    if ContainsText(FormattedCode, 'if') then
    begin
      KeyWords := ['<', '>'];
      for KeyWord in KeyWords do
        FormattedCode := AddSpacesAroundBinaryOperatorSymbol(FormattedCode, KeyWord);
    end;

    KeyWords := ['\+', '\-'];   // Operator may be unary or binary
    for KeyWord in KeyWords do
      FormattedCode := AddSpacesAroundOperatorSymbol(FormattedCode, KeyWord);
  end;


  if FormatterConfig.AddSpacesAroundBinOpsWord then
  begin
    // Строковые операторы (div, mod, and, or, xor, as, is, in)
    KeyWords := ['div', 'mod', 'and', 'or', 'xor'];
    for KeyWord in KeyWords do
      FormattedCode := AddSpacesAroundBinaryOperatorWord(FormattedCode, KeyWord);
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
  i, si: Integer;
  StrList: TStringList;
  PartToProcess, PartToSkit: string;
  SplittedStrings: TArray<string>;
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

    SkipComments(PartToProcess, '\/\/', PartToProcess, PartToSkit);
    SkipComments(PartToProcess, '{', PartToProcess, PartToSkit);

    // Skip Strings from processing
    SplittedStrings := SplitString(PartToProcess, '''');
    PartToProcess := '';
    for si := 0 to Length(SplittedStrings) - 1 do
    begin
      if not Odd(si) then // Only even are code, odd are strings
      begin
        // Add back quotes
        if si - 1 >= 0 then SplittedStrings[si] := '''' + SplittedStrings[si];
        if si + 1 < Length(SplittedStrings) then SplittedStrings[si] := SplittedStrings[si] + '''';

        SplittedStrings[si] := FormatDelphiCodeCleaned(SplittedStrings[si], FormatterConfig);
      end;

      PartToProcess := PartToProcess + SplittedStrings[si];
    end;

    CodeStrings[i] := PartToProcess + PartToSkit;
  end;

  for i := 0 to CodeStrings.Count - 1 do
    Result := Result + CodeStrings[i] + sLineBreak;
end;

end.
