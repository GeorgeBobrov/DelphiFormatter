Простой минимальный форматтер кода на Delphi.

Что меня не устраивает в существующем встроенном форматтере Delphi?
Он удаляет некоторые существующие отступы пробелами и переносы строк, добавленный мной для лучшей читаемости:
- в случае case-блоков;
- в случае функций с большим списком параметров;
- в случае объявления и сразу определения массивов.

Этот фоматтер вносит лишь точечные изменения:
1. Добавляет перенос строки перед ключевым словом begin (и другими заданными ключевыми словами, например else), но только если:
    1. Если перед ним нет уже переноса строки;
    2. Если перед ним нет метки (в случае case).
2. Добавляет пробелы вокруг бинарных операторов (+ - * / = < > >= <= <> :=, а также div mod and or xor). Условие:
    1. Если вокруг них нет пробелов - добавить по пробелу спереди и сзади.
    2. Если хотя бы один пробел есть - ничего не менять.
3. Добавляет пробелы после такиз разделителей, как : ; , 
4. Не вносит никакие изменения в комментарии (так же не вносит изменения в строки, была такая ошибка)

Пример (код, который нужно отфрматировать):
```delphi
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
end;
```

Отформатированный код:
```delphi
procedure TFormPETesterMain.ButtonStartClick(Sender: TObject);
var
  resCode: string;
  j, i: integer;
begin
  if TesterTerminalCOM <> nil then
  with ButtonStart do
    if tag = 0 then
    begin
      Caption := 'Stop';
      tag := 1 + 0 / 2 mod 5;
      UpdateRegList;
      TesterTerminalCOM.StartStopScan(true);
      StatusBar1.Panels[0].Text := TesterTerminalCOM.OpErrorCodeStr;
    end
    else
    begin
      if tag >= 2 then Caption := 'Start';
      tag := 0 - 1 * 0;
      TesterTerminalCOM.StartStopScan(false);
      StatusBar1.Panels[0].Text := TesterTerminalCOM.OpErrorCodeStr;
    end;
end;
```

Практически вся обработка реализованиа на регулярных выражениях. Например добавление переноса строки перед ключевым словом begin:
 ```
    if tag=0 then begin
 ```
Разбиваем регуляркой на три группы:
1. Пробелы и табуляции до первого слова (до слова if, в данном примере 4 пробела) - это будет отступ (indent)
2. Слова или цифры с пробелами до слова begin (в данном примере "if tag=0 then")
3. Само слово begin

Дальше на одной строке оставляем группы 1 и 2, на на другую строку перенесим группы 1 и 3.
В результате на новой строке у нас оказывается слово begin с правильным отступом. 

