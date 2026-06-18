object Thumbsbrowser_InfoForm: TThumbsbrowser_InfoForm
  Left = 533
  Top = 337
  Caption = 'Picture Info'
  ClientHeight = 416
  ClientWidth = 560
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDesigned
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel_Form: TPanel
    Left = 0
    Top = 0
    Width = 560
    Height = 416
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object Panel3: TPanel
      Left = 6
      Top = 31
      Width = 548
      Height = 385
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object Panel_Fileinfo: TPanel
        Left = 0
        Top = 59
        Width = 548
        Height = 34
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object Bevel1: TBevel
          Left = 0
          Top = 0
          Width = 548
          Height = 4
          Align = alTop
          Shape = bsFrame
          ExplicitWidth = 525
        end
        object Label_Location: TLabel
          Left = 0
          Top = 4
          Width = 548
          Height = 13
          Align = alTop
          AutoSize = False
          Caption = 'Location:'
          ParentShowHint = False
          ShowHint = True
          Transparent = True
          ExplicitWidth = 525
        end
        object Panel2: TPanel
          Left = 0
          Top = 17
          Width = 548
          Height = 18
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          object Label_FSize: TLabel
            Left = 0
            Top = 0
            Width = 23
            Height = 13
            Align = alLeft
            Caption = 'Size:'
            Transparent = True
          end
          object Label_FDate: TLabel
            Left = 33
            Top = 0
            Width = 45
            Height = 13
            Align = alLeft
            Caption = 'File Date:'
            Transparent = True
          end
          object Bevel2: TBevel
            Left = 23
            Top = 0
            Width = 10
            Height = 18
            Align = alLeft
            Shape = bsSpacer
          end
        end
      end
      object Panel_save: TPanel
        Left = 0
        Top = 29
        Width = 548
        Height = 30
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        object Button_save: TBitBtn
          Left = 201
          Top = 3
          Width = 112
          Height = 25
          Caption = 'Save'
          Enabled = False
          TabOrder = 0
          OnClick = Button_saveClick
        end
        object button_AddMetaTags_Exif: TBitBtn
          Left = -1
          Top = 2
          Width = 78
          Height = 25
          Caption = 'Add Exif'
          Enabled = False
          TabOrder = 1
          OnClick = button_AddMetaTags_ExifClick
        end
        object button_AddMetaTags_Iptc: TBitBtn
          Left = 78
          Top = 2
          Width = 78
          Height = 25
          Caption = 'Add Iptc'
          Enabled = False
          TabOrder = 2
          OnClick = button_AddMetaTags_IptcClick
        end
      end
      object Panel_EditName: TPanel
        Left = 0
        Top = 0
        Width = 548
        Height = 29
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 2
        DesignSize = (
          548
          29)
        object Edit_FileName: TEdit
          Left = 3
          Top = 4
          Width = 544
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 0
          Text = 'Edit_FileName'
          OnChange = Edit_FileNameChange
        end
      end
      object PanelBottom: TPanel
        Left = 0
        Top = 93
        Width = 548
        Height = 292
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 3
        object Splitter1: TSplitter
          Left = 273
          Top = 0
          Height = 292
          Beveled = True
          ResizeStyle = rsUpdate
          ExplicitLeft = 232
          ExplicitTop = 40
          ExplicitHeight = 100
        end
        object Panel_info: TPanel
          Left = 0
          Top = 0
          Width = 273
          Height = 292
          Align = alLeft
          BevelOuter = bvNone
          TabOrder = 0
          object Panel_exif: TPanel
            Left = 0
            Top = 0
            Width = 273
            Height = 292
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 0
            object ExifIptcPanel1: TThumbsBrowser_ExifIptcPanel
              Left = 0
              Top = 0
              Width = 273
              Height = 292
              Align = alClient
              Language = nwsLng_EN
              TabPosition = tpTop
              DicomIncludeOptions = [DIn_Deprecated, DIn_Proprietary, DIn_Children, DIn_Unknown]
              ShowExif = True
              ShowIPTC = True
              ShowDICOM = True
              ShowXmp = True
              OnModified = ExifIptcPanel1Modified
              OnFileInfoSaved = ExifIptcPanel1FileInfoSaved
            end
          end
        end
        object Panel_preview: TPanel
          Left = 276
          Top = 0
          Width = 272
          Height = 292
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 1
          object IEPreview: TImageEnView
            Left = 0
            Top = 9
            Width = 272
            Height = 283
            Background = clWhite
            ParentCtl3D = False
            OnMouseEnter = IEPreviewMouseEnter
            OnMouseLeave = IEPreviewMouseLeave
            LegacyBitmap = False
            ZoomFilter = rfFastLinear
            MouseInteract = [miZoom, miScroll]
            BackgroundStyle = iebsChessboard
            OnDShowNewFrame = IEPreviewDShowNewFrame
            OnDShowEvent = IEPreviewDShowEvent
            EnableInteractionHints = True
            Align = alClient
            TabOrder = 0
          end
          object ProgressBar1: TProgressBar
            Left = 0
            Top = 0
            Width = 272
            Height = 9
            Align = alTop
            TabOrder = 1
            Visible = False
          end
        end
      end
    end
    object Panel1: TPanel
      Left = 0
      Top = 31
      Width = 6
      Height = 385
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 1
    end
    object Panel4: TPanel
      Left = 554
      Top = 31
      Width = 6
      Height = 385
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 2
    end
    object PageControl_MultiPics: TPageControl
      Left = 0
      Top = 0
      Width = 560
      Height = 31
      Align = alTop
      TabOrder = 3
    end
  end
end
