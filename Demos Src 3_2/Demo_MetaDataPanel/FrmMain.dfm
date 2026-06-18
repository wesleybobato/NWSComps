object FormMain: TFormMain
  Left = 0
  Top = 0
  Caption = 'FormMain'
  ClientHeight = 749
  ClientWidth = 840
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object ImageEnView1: TImageEnView
    Left = 0
    Top = 0
    Width = 504
    Height = 749
    Background = clBtnFace
    Ctl3D = False
    ParentCtl3D = False
    LegacyBitmap = True
    MouseWheelParams.Action = iemwZoom
    Align = alClient
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 504
    Top = 0
    Width = 336
    Height = 749
    Align = alRight
    TabOrder = 1
    object ListBox1: TListBox
      Left = 1
      Top = 42
      Width = 334
      Height = 218
      Align = alTop
      ItemHeight = 13
      TabOrder = 0
      OnClick = ListBox1Click
    end
    object Panel2: TPanel
      Left = 1
      Top = 260
      Width = 334
      Height = 68
      Align = alTop
      TabOrder = 1
      object rgTags: TRadioGroup
        Left = 1
        Top = 1
        Width = 157
        Height = 66
        Align = alLeft
        ItemIndex = 0
        Items.Strings = (
          'Default Tags'
          'Custom Tags')
        TabOrder = 0
        OnClick = rgTagsClick
      end
      object btnDefineCustomTags: TButton
        Left = 89
        Top = 37
        Width = 65
        Height = 25
        Caption = 'Define..'
        Enabled = False
        TabOrder = 1
        OnClick = btnDefineCustomTagsClick
      end
      object Panel4: TPanel
        Left = 160
        Top = 1
        Width = 173
        Height = 66
        Align = alRight
        Color = clYellow
        ParentBackground = False
        TabOrder = 2
        object btnSaveMeta: TButton
          Left = 3
          Top = 33
          Width = 169
          Height = 25
          Caption = 'Save Changes to Current File(s)'
          Enabled = False
          TabOrder = 0
          OnClick = btnSaveMetaClick
        end
        object btnAddExif: TButton
          Left = 68
          Top = 4
          Width = 65
          Height = 25
          Caption = 'Add Exif'
          Enabled = False
          TabOrder = 1
          OnClick = btnAddExifClick
        end
        object btnAddIptc: TButton
          Left = 3
          Top = 4
          Width = 65
          Height = 25
          Caption = 'Add Iptc'
          Enabled = False
          TabOrder = 2
          OnClick = btnAddIptcClick
        end
      end
    end
    object Panel3: TPanel
      Left = 1
      Top = 1
      Width = 334
      Height = 41
      Align = alTop
      TabOrder = 2
      object btnLoadFiles1: TButton
        Left = 5
        Top = 6
        Width = 156
        Height = 25
        Caption = 'Load Files.. (method 1)'
        TabOrder = 0
        OnClick = btnLoadFiles1Click
      end
      object btnLoadFiles2: TButton
        Left = 167
        Top = 6
        Width = 156
        Height = 25
        Caption = 'Load Files.. (method 2)'
        TabOrder = 1
        OnClick = btnLoadFiles2Click
      end
    end
    object PageControl1: TPageControl
      Left = 1
      Top = 363
      Width = 334
      Height = 385
      ActivePage = TabSheet1
      Align = alClient
      TabOrder = 3
      object TabSheet1: TTabSheet
        Caption = 'Metadata'
        object metadataPanel1: TThumbsBrowser_ExifIptcPanel
          Left = 0
          Top = 0
          Width = 326
          Height = 357
          Align = alClient
          Language = nwsLng_EN
          TabPosition = tpLeft
          DicomIncludeOptions = [DIn_Deprecated, DIn_Proprietary, DIn_Children, DIn_Unknown]
          ShowExif = True
          ShowIPTC = True
          ShowDICOM = True
          ShowXmp = True
          OnModified = metadataPanel1Modified
          OnFileInfoSaved = metadataPanel1FileInfoSaved
        end
      end
    end
    object Panel5: TPanel
      Left = 1
      Top = 328
      Width = 334
      Height = 35
      Align = alTop
      TabOrder = 4
      object Label1: TLabel
        Left = 24
        Top = 14
        Width = 130
        Height = 13
        Caption = 'MetaData Panel Language:'
      end
      object ComboBox_Language: TComboBox
        Left = 168
        Top = 8
        Width = 145
        Height = 21
        Style = csDropDownList
        TabOrder = 0
        OnClick = ComboBox_LanguageClick
      end
    end
  end
  object OpenImageEnDialog1: TOpenImageEnDialog
    Ctl3D = False
    Filter = 
      'File grafici comuni|*.tif;*.tiff;*.fax;*.g3n;*.g3f;*.xif;*.gif;*' +
      '.jpg;*.jpeg;*.jpe;*.jif;*.pcx;*.bmp;*.dib;*.rle;*.ico;*.cur;*.pn' +
      'g;*.dcm;*.dic;*.dicom;*.v2;*.wmf;*.emf;*.tga;*.targa;*.vda;*.icb' +
      ';*.vst;*.pix;*.pxm;*.ppm;*.pgm;*.pbm;*.wbmp;*.jp2;*.j2k;*.jpc;*.' +
      'j2c;*.dcx;*.crw;*.cr2;*.dng;*.nef;*.raw;*.raf;*.x3f;*.orf;*.srf;' +
      '*.mrw;*.dcr;*.bay;*.pef;*.sr2;*.arw;*.kdc;*.mef;*.3fr;*.k25;*.er' +
      'f;*.cam;*.cs1;*.dc2;*.dcs;*.fff;*.mdc;*.mos;*.nrw;*.ptx;*.pxn;*.' +
      'rdc;*.rw2;*.rwl;*.iiq;*.srw;*.psd;*.psb;*.iev;*.lyr;*.all;*.wdp;' +
      '*.hdp;*.jxr;*.avi;*.mpeg;*.mpg;*.wmv|Tutti (*.*)|*.*|JPEG Image ' +
      '(*.jpg;*.jpeg;*.jpe;*.jif)|*.jpg;*.jpeg;*.jpe;*.jif|TIFF Image (' +
      '*.tif;*.tiff;*.fax;*.g3n;*.g3f;*.xif)|*.tif;*.tiff;*.fax;*.g3n;*' +
      '.g3f;*.xif|GIF Image (*.gif)|*.gif|PaintBrush (*.pcx)|*.pcx|Wind' +
      'ows Bitmap (*.bmp;*.dib;*.rle)|*.bmp;*.dib;*.rle|Windows Icon (*' +
      '.ico)|*.ico|Windows Cursor (*.cur)|*.cur|Portable Network Graphi' +
      'cs (*.png)|*.png|DICOM Medical Image (*.dcm;*.dic;*.dicom;*.v2)|' +
      '*.dcm;*.dic;*.dicom;*.v2|Windows Metafile (*.wmf)|*.wmf|Enhanced' +
      ' Windows Metafile (*.emf)|*.emf|Targa Image (*.tga;*.targa;*.vda' +
      ';*.icb;*.vst;*.pix)|*.tga;*.targa;*.vda;*.icb;*.vst;*.pix|Portab' +
      'le Pixmap, Graymap, Bitmap (*.pxm;*.ppm;*.pgm;*.pbm)|*.pxm;*.ppm' +
      ';*.pgm;*.pbm|Wireless Bitmap (*.wbmp)|*.wbmp|JPEG2000 (*.jp2)|*.' +
      'jp2|JPEG2000 Code Stream (*.j2k;*.jpc;*.j2c)|*.j2k;*.jpc;*.j2c|M' +
      'ultipage PCX (*.dcx)|*.dcx|Camera Raw Image (*.cr2;*.crw;*.dng;*' +
      '.nef;*.raw;*.orf;*.nrw...)|*.crw;*.cr2;*.dng;*.nef;*.raw;*.raf;*' +
      '.x3f;*.orf;*.srf;*.mrw;*.dcr;*.bay;*.pef;*.sr2;*.arw;*.kdc;*.mef' +
      ';*.3fr;*.k25;*.erf;*.cam;*.cs1;*.dc2;*.dcs;*.fff;*.mdc;*.mos;*.n' +
      'rw;*.ptx;*.pxn;*.rdc;*.rw2;*.rwl;*.iiq;*.srw|Photoshop PSD (*.ps' +
      'd;*.psb)|*.psd;*.psb|Vectorial Objects (*.iev)|*.iev|Layers (*.l' +
      'yr)|*.lyr|Layers and Objects (*.all)|*.all|Microsoft HD Photo (*' +
      '.wdp;*.hdp;*.jxr)|*.wdp;*.hdp;*.jxr|Video for Windows (*.avi)|*.' +
      'avi|MPEG Video (*.mpeg;*.mpg)|*.mpeg;*.mpg|Windows Media Video (' +
      '*.wmv)|*.wmv'
    Options = [ofHideReadOnly, ofAllowMultiSelect]
    Left = 160
    Top = 48
  end
end
