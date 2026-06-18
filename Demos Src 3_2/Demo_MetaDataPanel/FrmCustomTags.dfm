object FormCustomTags: TFormCustomTags
  Left = 0
  Top = 0
  Caption = 'FormCustomTags'
  ClientHeight = 473
  ClientWidth = 458
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnShow = FormShow
  DesignSize = (
    458
    473)
  PixelsPerInch = 96
  TextHeight = 13
  object Panel_CustomTags: TPanel
    Left = 0
    Top = 73
    Width = 458
    Height = 352
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    TabOrder = 0
    object GridCustomTags: TStringGrid
      Left = 0
      Top = 0
      Width = 458
      Height = 325
      Align = alClient
      ColCount = 2
      DefaultColWidth = 30
      DefaultRowHeight = 20
      FixedRows = 0
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowMoving, goEditing, goAlwaysShowEditor]
      TabOrder = 0
      ExplicitTop = 24
      ExplicitWidth = 418
      ExplicitHeight = 190
    end
    object PageControl_CustomTags: TPageControl
      Left = 0
      Top = 325
      Width = 458
      Height = 27
      ActivePage = TabCustomExif
      Align = alBottom
      TabOrder = 1
      TabPosition = tpBottom
      OnChange = PageControl_CustomTagsChange
      OnChanging = PageControl_CustomTagsChanging
      object TabCustomExif: TTabSheet
        Caption = 'Exif'
        ExplicitWidth = 410
      end
      object TabCustomIptc: TTabSheet
        Caption = 'Iptc'
        ImageIndex = 1
        ExplicitWidth = 410
      end
      object TabCustomXMP: TTabSheet
        Caption = 'XMP'
        ImageIndex = 2
        ExplicitWidth = 410
      end
      object TabCommon: TTabSheet
        Caption = 'Common'
        ImageIndex = 3
      end
    end
  end
  object BitBtn1: TBitBtn
    Left = 371
    Top = 443
    Width = 75
    Height = 22
    Anchors = [akRight, akBottom]
    Caption = 'Save'
    TabOrder = 1
    OnClick = BitBtn1Click
    ExplicitLeft = 331
    ExplicitTop = 331
  end
  object BitBtn2: TBitBtn
    Left = 275
    Top = 443
    Width = 75
    Height = 22
    Anchors = [akRight, akBottom]
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = BitBtn2Click
    ExplicitLeft = 235
    ExplicitTop = 331
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 458
    Height = 73
    Align = alTop
    TabOrder = 3
    object ListBox1: TListBox
      Left = 1
      Top = 1
      Width = 456
      Height = 71
      Align = alClient
      ItemHeight = 13
      Items.Strings = (
        'In this grid:'
        
          'You can change the order of the fields by dragging the row numbe' +
          'rs'
        'You can add and delete Rows'
        
          'You can edit the field (but be sure to keep the format of the fi' +
          'eld otherwise'#11
        'the field will not be identified)')
      TabOrder = 0
      ExplicitHeight = 39
    end
  end
  object btnDel: TBitBtn
    Left = 1
    Top = 431
    Width = 75
    Height = 22
    Anchors = [akRight, akBottom]
    Caption = 'Delete'
    TabOrder = 4
    OnClick = btnDelClick
  end
  object btnAdd: TBitBtn
    Left = 82
    Top = 431
    Width = 75
    Height = 22
    Anchors = [akRight, akBottom]
    Caption = 'Add'
    TabOrder = 5
    OnClick = btnAddClick
  end
end
