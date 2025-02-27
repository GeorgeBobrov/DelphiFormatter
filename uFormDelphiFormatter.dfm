object FormDelphiFormatter: TFormDelphiFormatter
  Left = 0
  Top = 0
  Caption = 'Delphi Formatter 1.5'
  ClientHeight = 582
  ClientWidth = 934
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 15
  object Splitter1: TSplitter
    Left = 393
    Top = 0
    Height = 408
    ResizeStyle = rsUpdate
    OnMoved = Splitter1Moved
    ExplicitLeft = 227
    ExplicitTop = -6
    ExplicitHeight = 384
  end
  object PanelBottom: TPanel
    Left = 0
    Top = 408
    Width = 934
    Height = 174
    Align = alBottom
    TabOrder = 1
    object PanelConfig: TPanel
      Left = 1
      Top = 1
      Width = 280
      Height = 172
      Align = alLeft
      TabOrder = 0
      object CheckBoxAddNewLine: TCheckBox
        Left = 9
        Top = 40
        Width = 130
        Height = 17
        Caption = 'Add new line before:'
        Checked = True
        State = cbChecked
        TabOrder = 0
      end
      object CheckBoxAddSpaceAfterColon: TCheckBox
        Left = 9
        Top = 131
        Width = 114
        Height = 17
        Caption = 'Add Space after:'
        Checked = True
        State = cbChecked
        TabOrder = 3
      end
      object EditAddNewLine: TEdit
        Left = 145
        Top = 38
        Width = 126
        Height = 22
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Consolas'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        Text = 'begin else'
      end
      object EditAddSpaceAfterColon: TEdit
        Left = 145
        Top = 129
        Width = 126
        Height = 22
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Consolas'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
        Text = ': ; ,'
      end
      object GroupBox2: TGroupBox
        Left = 7
        Top = 63
        Width = 264
        Height = 61
        Caption = 'Add Spaces Around Binary Operators:'
        TabOrder = 2
        object CheckBoxAddSpacesAroundBinOpsWord: TCheckBox
          Left = 12
          Top = 38
          Width = 197
          Height = 17
          Caption = 'div mod and or xor'
          Checked = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Consolas'
          Font.Style = []
          ParentFont = False
          State = cbChecked
          TabOrder = 1
        end
        object CheckBoxAddSpacesAroundBinOps1: TCheckBox
          Left = 12
          Top = 19
          Width = 229
          Height = 17
          Caption = '+ - * / = < > >= <= <> :='
          Checked = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Consolas'
          Font.Style = []
          ParentFont = False
          State = cbChecked
          TabOrder = 0
        end
      end
      object PanelConfigTitle: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 274
        Height = 22
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 1
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 5
        object Label5: TLabel
          AlignWithMargins = True
          Left = 5
          Top = 1
          Width = 45
          Height = 20
          Margins.Left = 5
          Margins.Top = 1
          Margins.Bottom = 1
          Align = alLeft
          Caption = 'Config:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
          Layout = tlCenter
          ExplicitHeight = 17
        end
        object LabelConfigFile: TLabel
          AlignWithMargins = True
          Left = 58
          Top = 2
          Width = 133
          Height = 19
          Margins.Left = 5
          Margins.Top = 2
          Margins.Bottom = 1
          Align = alClient
          AutoSize = False
          EllipsisPosition = epPathEllipsis
          Layout = tlCenter
          ExplicitLeft = 54
          ExplicitTop = 1
          ExplicitWidth = 3
          ExplicitHeight = 15
        end
        object ButtonLoadConfig: TButton
          Left = 194
          Top = 0
          Width = 40
          Height = 22
          Align = alRight
          Caption = 'Load'
          TabOrder = 0
          OnClick = ButtonLoadConfigClick
        end
        object ButtonSaveConfig: TButton
          Left = 234
          Top = 0
          Width = 40
          Height = 22
          Align = alRight
          Caption = 'Save'
          TabOrder = 1
          OnClick = ButtonSaveConfigClick
        end
      end
    end
    object PanelCommands: TPanel
      Left = 281
      Top = 1
      Width = 652
      Height = 172
      Align = alClient
      TabOrder = 1
      object MemoProcessedFiles: TMemo
        AlignWithMargins = True
        Left = 4
        Top = 34
        Width = 644
        Height = 134
        Margins.Top = 2
        Align = alClient
        Lines.Strings = (
          'Processed Files:')
        ScrollBars = ssBoth
        TabOrder = 1
        Visible = False
      end
      object FlowPanel1: TFlowPanel
        AlignWithMargins = True
        Left = 4
        Top = 4
        Width = 644
        Height = 27
        Margins.Bottom = 1
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        TabOrder = 0
        object ButtonProcess: TButton
          AlignWithMargins = True
          Left = 3
          Top = 1
          Width = 114
          Height = 25
          Margins.Top = 1
          Margins.Bottom = 1
          Caption = 'Process'
          TabOrder = 0
          OnClick = ButtonProcessClick
        end
        object ButtonCopyResultToSource: TButton
          AlignWithMargins = True
          Left = 123
          Top = 1
          Width = 145
          Height = 25
          Margins.Top = 1
          Margins.Bottom = 1
          Caption = 'Copy Result To Source'
          TabOrder = 1
          OnClick = ButtonCopyResultToSourceClick
        end
        object ButtonFormatAllFilesInDir: TButton
          AlignWithMargins = True
          Left = 274
          Top = 1
          Width = 215
          Height = 25
          Margins.Top = 1
          Margins.Bottom = 1
          Caption = 'Format all *.pas files in directory'
          TabOrder = 2
          OnClick = ButtonFormatAllFilesInDirClick
        end
      end
    end
  end
  object PanelSource: TPanel
    Left = 0
    Top = 0
    Width = 393
    Height = 408
    Align = alLeft
    TabOrder = 0
    object MemoSource: TMemo
      AlignWithMargins = True
      Left = 4
      Top = 27
      Width = 385
      Height = 360
      Margins.Top = 1
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Consolas'
      Font.Style = []
      ParentFont = False
      ScrollBars = ssBoth
      TabOrder = 1
    end
    object PanelSourceTitle: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 387
      Height = 22
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 1
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object Label1: TLabel
        AlignWithMargins = True
        Left = 5
        Top = 1
        Width = 45
        Height = 20
        Margins.Left = 5
        Margins.Top = 1
        Margins.Bottom = 1
        Align = alLeft
        Caption = 'Source:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
        ExplicitHeight = 17
      end
      object LabelSourceFile: TLabel
        AlignWithMargins = True
        Left = 58
        Top = 2
        Width = 251
        Height = 19
        Margins.Left = 5
        Margins.Top = 2
        Margins.Bottom = 1
        Align = alClient
        AutoSize = False
        EllipsisPosition = epPathEllipsis
        Layout = tlCenter
        ExplicitLeft = 54
        ExplicitTop = 1
        ExplicitWidth = 3
        ExplicitHeight = 15
      end
      object ButtonOpen: TButton
        Left = 312
        Top = 0
        Width = 75
        Height = 22
        Align = alRight
        Caption = 'Open'
        TabOrder = 0
        OnClick = ButtonOpenClick
      end
    end
    object PanelEncoding: TPanel
      Left = 1
      Top = 390
      Width = 391
      Height = 17
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 2
      object Label2: TLabel
        AlignWithMargins = True
        Left = 5
        Top = 0
        Width = 53
        Height = 17
        Margins.Left = 5
        Margins.Top = 0
        Margins.Bottom = 0
        Align = alLeft
        Caption = 'Encoding:'
        ExplicitHeight = 15
      end
      object LabelEncoding: TLabel
        AlignWithMargins = True
        Left = 66
        Top = 0
        Width = 322
        Height = 17
        Margins.Left = 5
        Margins.Top = 0
        Margins.Bottom = 0
        Align = alClient
        Caption = '-'
        ExplicitWidth = 5
        ExplicitHeight = 15
      end
    end
  end
  object PanelResult: TPanel
    Left = 396
    Top = 0
    Width = 538
    Height = 408
    Align = alClient
    Caption = 'PanelResult'
    TabOrder = 2
    object MemoResult: TMemo
      AlignWithMargins = True
      Left = 4
      Top = 27
      Width = 530
      Height = 377
      Margins.Top = 1
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Consolas'
      Font.Style = []
      ParentFont = False
      ScrollBars = ssBoth
      TabOrder = 1
    end
    object PanelResultTitle: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 532
      Height = 22
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 1
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object Label4: TLabel
        AlignWithMargins = True
        Left = 5
        Top = 1
        Width = 42
        Height = 20
        Margins.Left = 5
        Margins.Top = 1
        Margins.Bottom = 1
        Align = alLeft
        Caption = 'Result:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
        ExplicitHeight = 17
      end
      object LabelResultFile: TLabel
        AlignWithMargins = True
        Left = 55
        Top = 2
        Width = 399
        Height = 19
        Margins.Left = 5
        Margins.Top = 2
        Margins.Bottom = 1
        Align = alClient
        AutoSize = False
        EllipsisPosition = epPathEllipsis
        Layout = tlCenter
        ExplicitLeft = 54
        ExplicitTop = 1
        ExplicitWidth = 3
        ExplicitHeight = 15
      end
      object ButtonSave: TButton
        Left = 457
        Top = 0
        Width = 75
        Height = 22
        Align = alRight
        Caption = 'Save'
        TabOrder = 0
        OnClick = ButtonSaveClick
      end
    end
  end
  object OpenDialogConfig: TOpenDialog
    Filter = '*.conf|*.conf|*.*|*.*'
    Options = [ofHideReadOnly, ofFileMustExist, ofEnableSizing]
    Title = 'Load Config'
    Left = 233
    Top = 345
  end
  object SaveDialogConfig: TSaveDialog
    DefaultExt = 'conf'
    Filter = '*.conf|*.conf|*.*|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Title = 'Save Config'
    Left = 297
    Top = 345
  end
  object OpenDialogPas: TOpenDialog
    Filter = '*.pas|*.pas|*.*|*.*'
    Options = [ofHideReadOnly, ofFileMustExist, ofEnableSizing]
    Title = 'Open file to Format '
    Left = 425
    Top = 345
  end
  object SaveDialogPas: TSaveDialog
    DefaultExt = 'pas'
    Filter = '*.pas|*.pas|*.*|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Title = 'Save file'
    Left = 481
    Top = 345
  end
  object OpenDialogDir: TOpenDialog
    Filter = '*.pas|*.pas|*.*|*.*'
    Options = [ofHideReadOnly, ofFileMustExist, ofEnableSizing]
    Title = 'Choose any file in Directory'
    Left = 617
    Top = 345
  end
end
