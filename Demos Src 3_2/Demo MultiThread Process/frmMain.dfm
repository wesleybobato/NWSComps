object FormMain: TFormMain
  Left = 0
  Top = 0
  Caption = 'FormMain'
  ClientHeight = 573
  ClientWidth = 856
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ImageEnView1: TImageEnView
    Left = 193
    Top = 0
    Width = 478
    Height = 573
    Background = clBtnFace
    Ctl3D = False
    ParentCtl3D = False
    LegacyBitmap = False
    MouseInteract = [miZoom, miScroll]
    MouseWheelParams.Action = iemwZoom
    Align = alClient
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 671
    Top = 0
    Width = 185
    Height = 573
    Align = alRight
    TabOrder = 1
    object Label3: TLabel
      Left = 24
      Top = 90
      Width = 152
      Height = 60
      AutoSize = False
      Caption = 
        'Please for your test pick an image large enough.Also for best pe' +
        'rformance set the Nr of Threads = nr of cpus'
      WordWrap = True
    end
    object btnLoad: TButton
      Left = 54
      Top = 13
      Width = 75
      Height = 25
      Caption = 'Load'
      TabOrder = 0
      OnClick = btnLoadClick
    end
    object Button1: TButton
      Left = 54
      Top = 44
      Width = 75
      Height = 25
      Caption = 'Save'
      TabOrder = 1
      OnClick = Button1Click
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 193
    Height = 573
    Align = alLeft
    TabOrder = 2
    object GroupBox_Multi: TGroupBox
      Left = 1
      Top = 226
      Width = 191
      Height = 176
      Align = alTop
      Caption = 'Multi-thread'
      Color = clBtnFace
      ParentBackground = False
      ParentColor = False
      TabOrder = 0
      object Label1: TLabel
        Left = 71
        Top = 79
        Width = 49
        Height = 13
        Caption = 'N Threads'
      end
      object LabelProcTime_Multi: TLabel
        Left = 2
        Top = 15
        Width = 187
        Height = 13
        Align = alTop
        Alignment = taCenter
        AutoSize = False
        ExplicitLeft = -1
        ExplicitTop = 212
        ExplicitWidth = 171
      end
      object btnProcessMulti: TBitBtn
        Left = 18
        Top = 48
        Width = 75
        Height = 25
        Caption = 'Process'
        TabOrder = 0
        OnClick = btnProcessMultiClick
      end
      object SpinEditThreadsCount: TSpinEdit
        Left = 75
        Top = 96
        Width = 41
        Height = 22
        MaxValue = 12
        MinValue = 1
        TabOrder = 1
        Value = 2
      end
      object rgOverlapMethod: TRadioGroup
        Left = 2
        Top = 124
        Width = 187
        Height = 50
        Align = alBottom
        Caption = 'Overlap Method (when overlap > 0)'
        ItemIndex = 0
        Items.Strings = (
          'Add Pixels'
          'Add Threads')
        TabOrder = 2
      end
      object btnMultiAbort: TBitBtn
        Left = 99
        Top = 48
        Width = 75
        Height = 25
        Caption = 'Abort'
        TabOrder = 3
        OnClick = btnMultiAbortClick
      end
    end
    object GroupBox1: TGroupBox
      Left = 1
      Top = 38
      Width = 191
      Height = 100
      Align = alTop
      Caption = 'Filter'
      TabOrder = 1
      object cbFilter: TComboBox
        Left = 3
        Top = 24
        Width = 183
        Height = 21
        Style = csDropDownList
        DropDownCount = 16
        TabOrder = 0
        OnClick = cbFilterClick
        Items.Strings = (
          'Hue-Sat-Lum'
          'Gaussian Blur'
          'AutoSharp'
          'Wallis Filter')
      end
      object pnGBlur: TPanel
        Left = 2
        Top = 52
        Width = 187
        Height = 46
        Align = alBottom
        TabOrder = 1
        Visible = False
        object Label2: TLabel
          Left = 40
          Top = 0
          Width = 104
          Height = 13
          Caption = 'Gaussian Blur Amount'
        end
        object SpinEditGBlur: TSpinEdit
          Left = 69
          Top = 19
          Width = 41
          Height = 22
          MaxValue = 400
          MinValue = 1
          TabOrder = 0
          Value = 50
        end
      end
    end
    object GroupBox_Single: TGroupBox
      Left = 1
      Top = 138
      Width = 191
      Height = 71
      Align = alTop
      Caption = 'Single-thread'
      TabOrder = 2
      object LabelProcTime_Single: TLabel
        Left = 2
        Top = 15
        Width = 187
        Height = 13
        Align = alTop
        Alignment = taCenter
        AutoSize = False
        ExplicitLeft = -1
        ExplicitTop = 212
        ExplicitWidth = 171
      end
      object btnProcess_Single: TBitBtn
        Left = 58
        Top = 34
        Width = 75
        Height = 25
        Caption = 'Process'
        TabOrder = 0
        OnClick = btnProcess_SingleClick
      end
    end
    object GroupBox2: TGroupBox
      Left = 1
      Top = 1
      Width = 191
      Height = 37
      Align = alTop
      TabOrder = 3
      object btnResetPic: TBitBtn
        Left = 58
        Top = 6
        Width = 75
        Height = 25
        Caption = 'Reset Pic'
        TabOrder = 0
        OnClick = btnResetPicClick
      end
    end
    object ProgressBar1: TProgressBar
      Left = 1
      Top = 209
      Width = 191
      Height = 17
      Align = alTop
      TabOrder = 4
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
    Left = 408
  end
  object SaveImageEnDialog1: TSaveImageEnDialog
    Ctl3D = False
    Filter = 
      'JPEG Image (*.jpg;*.jpeg;*.jpe;*.jif)|*.jpg;*.jpeg;*.jpe;*.jif|T' +
      'IFF Image (*.tif;*.tiff;*.fax;*.g3n;*.g3f;*.xif)|*.tif;*.tiff;*.' +
      'fax;*.g3n;*.g3f;*.xif|GIF Image (*.gif)|*.gif|PaintBrush (*.pcx)' +
      '|*.pcx|Windows Bitmap (*.bmp;*.dib;*.rle)|*.bmp;*.dib;*.rle|Wind' +
      'ows Icon (*.ico)|*.ico|Portable Network Graphics (*.png)|*.png|D' +
      'ICOM Medical Image (*.dcm;*.dic;*.dicom;*.v2)|*.dcm;*.dic;*.dico' +
      'm;*.v2|Targa Image (*.tga;*.targa;*.vda;*.icb;*.vst;*.pix)|*.tga' +
      ';*.targa;*.vda;*.icb;*.vst;*.pix|Portable Pixmap, Graymap, Bitma' +
      'p (*.pxm;*.ppm;*.pgm;*.pbm)|*.pxm;*.ppm;*.pgm;*.pbm|Wireless Bit' +
      'map (*.wbmp)|*.wbmp|JPEG2000 (*.jp2)|*.jp2|JPEG2000 Code Stream ' +
      '(*.j2k;*.jpc;*.j2c)|*.j2k;*.jpc;*.j2c|PostScript (*.ps;*.eps)|*.' +
      'ps;*.eps|Adobe PDF (*.pdf)|*.pdf|Multipage PCX (*.dcx)|*.dcx|Pho' +
      'toshop PSD (*.psd;*.psb)|*.psd;*.psb|Vectorial Objects (*.iev)|*' +
      '.iev|Layers (*.lyr)|*.lyr|Layers and Objects (*.all)|*.all|Micro' +
      'soft HD Photo (*.wdp;*.hdp;*.jxr)|*.wdp;*.hdp;*.jxr|Video for Wi' +
      'ndows (*.avi)|*.avi'
    Left = 352
  end
end
