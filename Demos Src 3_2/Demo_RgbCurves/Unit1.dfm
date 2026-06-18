object Form1: TForm1
  Left = 374
  Top = 159
  Caption = 'RGBCurves Demo'
  ClientHeight = 617
  ClientWidth = 865
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl_Display: TPageControl
    Left = 369
    Top = 0
    Width = 496
    Height = 617
    ActivePage = TabSheet2
    Align = alClient
    TabOrder = 0
    OnChange = PageControl_DisplayChange
    object TabSheet1: TTabSheet
      Caption = 'Apply to Bitmap'
      object Panel3: TPanel
        Left = 0
        Top = 0
        Width = 488
        Height = 548
        Align = alClient
        DoubleBuffered = True
        ParentDoubleBuffered = False
        TabOrder = 0
        object PaintBox1: TPaintBox
          Left = 1
          Top = 1
          Width = 486
          Height = 546
          Align = alClient
          OnPaint = PaintBox1Paint
          ExplicitLeft = 2
          ExplicitTop = 0
          ExplicitWidth = 479
          ExplicitHeight = 542
        end
      end
      object Panel4: TPanel
        Left = 0
        Top = 548
        Width = 488
        Height = 41
        Align = alBottom
        TabOrder = 1
        object btnLoadTBitmap: TButton
          Left = 8
          Top = 9
          Width = 75
          Height = 25
          Caption = 'Load Image'
          TabOrder = 0
          OnClick = btnLoadTBitmapClick
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Do Preview and Apply Changes to IEView'
      ImageIndex = 2
      object Panel2: TPanel
        Left = 0
        Top = 558
        Width = 488
        Height = 31
        Align = alBottom
        TabOrder = 0
        object sbToggle: TSpeedButton
          Left = 195
          Top = 3
          Width = 87
          Height = 25
          Glyph.Data = {
            DE030000424DDE03000000000000360000002800000011000000120000000100
            180000000000A8030000232E0000232E00000000000000000001FFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFC0C0C0C0C0C0C0C0C0FFFFFFFFFFFFC0C0C0FFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFC0C0C0C0C0C0C0C0C0808080
            808080808080000000808080808080C0C0C0C0C0C0C0C0C0C0C0C0FFFFFFFFFF
            FF00FFFFFFFFFFFFC0C0C0C0C0C0808080808080808080808080808080808080
            808080808080000000808080C0C0C0FFFFFFFFFFFF00FFFFFF808080808080C0
            C0C0C0C0C0C0C0C0FFFFFFFFFFFFC0C0C0C0C0C0FFFFFFC0C0C0808080808080
            C0C0C0808080FFFFFF00FFFFFF808080C0C0C0C0C0C0FFFFFFFFFFFF80808080
            8000808000808000808000FFFFFFFFFFFFFFFFFFC0C0C0808080C0C0C000FFFF
            FFC0C0C0C0C0C0C0C0C0FFFFFFC0C0C0FCFCFA80800080800080800080800080
            8000FFFFFFC0C0C080808000000000000000FFFFFFC0C0C0808080808080FFFF
            FF808080808000808080000000808000808000808000FFFFFFC0C0C000000000
            000080808000C0C0C0000000000000000000808080808080808000FFFFFF8080
            80000000808000808000C0C0C0000000000000808080C0C0C000C0C0C0808080
            808080000000000000F0EDE3EFECE2F0EDE3EFECE2F0EDE3EFECE2EFECE20000
            00000000808080C0C0C080808000C0C0C0C0C0C0C0C0C0000000808080000000
            000000000000000000000000000000000000000000808080C0C0C0808080C0C0
            C000C0C0C0C0C0C0808080C0C0C0808080808080FFFFFF000000808080C0C0C0
            808080808080808080C0C0C0808080C0C0C0C0C0C000FFFFFFC0C0C0C0C0C0C0
            C0C0808080808080C0C0C0808080FFFFFFFFFFFFC0C0C0808080808080808080
            808080C0C0C0C0C0C000FFFFFFFFFFFFFFFFFFC0C0C0C0C0C0C0C0C080808080
            8080808080808080000000000000808080808080C0C0C0C0C0C0C0C0C000C0C0
            C0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC0C0C0C0C0C0C0C0C080808080808080
            8080C0C0C0C0C0C0808080808080C0C0C000C0C0C0808080C0C0C0FFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFC0C0C0FFFFFFC0C0C080808080808000000000
            000080808000FFFFFF808080000000808080C0C0C0C0C0C0FFFFFFFFFFFFFFFF
            FFC0C0C080808000000000000000000000000000000080808000FFFFFFFFFFFF
            8080800000000000000000000000000000000000000000000000000000000000
            00000000000000808080FFFFFF00FFFFFFFFFFFFFFFFFFC0C0C0808080000000
            000000000000000000000000000000808080808080C0C0C0FFFFFFFFFFFFFFFF
            FF00}
          OnMouseDown = sbToggleMouseDown
          OnMouseUp = sbToggleMouseUp
        end
        object btnApplyCurves: TButton
          Left = 285
          Top = 3
          Width = 92
          Height = 25
          Caption = 'Apply Curves'
          TabOrder = 0
          OnClick = btnApplyCurvesClick
        end
        object ToolBar1: TToolBar
          Left = 1
          Top = 1
          Width = 110
          Height = 29
          Align = alLeft
          ButtonHeight = 26
          ButtonWidth = 27
          Caption = 'ToolBar1'
          Images = ImageList1
          TabOrder = 1
          object ToolButton1: TToolButton
            Left = 0
            Top = 0
            Caption = 'ToolButton1'
            Down = True
            Grouped = True
            ImageIndex = 0
            Style = tbsCheck
            OnClick = ToolButton1Click
          end
          object ToolButton3: TToolButton
            Left = 27
            Top = 0
            Caption = 'ToolButton3'
            Grouped = True
            ImageIndex = 2
            Style = tbsCheck
            OnClick = ToolButton3Click
          end
          object ToolButton2: TToolButton
            Left = 54
            Top = 0
            Caption = 'ToolButton2'
            Grouped = True
            ImageIndex = 1
            Style = tbsCheck
            OnClick = ToolButton2Click
          end
        end
        object btnSaveImage: TButton
          Left = 383
          Top = 3
          Width = 92
          Height = 25
          Caption = 'Save Result'
          TabOrder = 2
          OnClick = btnSaveImageClick
        end
      end
      object Panel6: TPanel
        Left = 0
        Top = 0
        Width = 488
        Height = 65
        Align = alTop
        TabOrder = 1
        object Label5: TLabel
          Left = 133
          Top = 7
          Width = 61
          Height = 13
          Caption = 'Previewed in'
        end
        object CheckBox_UseFastPReview: TCheckBox
          Left = 2
          Top = -1
          Width = 109
          Height = 31
          Caption = 'Use Fast Preview'
          Checked = True
          State = cbChecked
          TabOrder = 0
          OnClick = CheckBox_UseFastPReviewClick
        end
        object btnLoadImageBg: TButton
          Left = 2
          Top = 34
          Width = 75
          Height = 25
          Caption = 'Load Image'
          TabOrder = 1
          OnClick = btnLoadImageBgClick
        end
        object btnAddLayer_Transp: TButton
          Left = 83
          Top = 34
          Width = 100
          Height = 25
          Caption = 'Add Transp. Layer'
          TabOrder = 2
          OnClick = btnAddLayer_TranspClick
        end
        object btnAddLayer: TButton
          Left = 189
          Top = 34
          Width = 100
          Height = 25
          Caption = 'Add Layer'
          TabOrder = 3
          OnClick = btnAddLayerClick
        end
      end
      object ImageEnView1: TImageEnView
        Left = 0
        Top = 65
        Width = 488
        Height = 493
        Background = clBtnFace
        Ctl3D = False
        ParentCtl3D = False
        LegacyBitmap = False
        ZoomFilter = rfLanczos3
        ScrollBars = ssNone
        MouseInteractGeneral = [miZoom, miScroll]
        OnLayerNotify = ImageEnView1LayerNotify
        PlaySpeed = 1.000000000000000000
        MouseWheelParams.Action = iemwZoom
        Align = alClient
        TabOrder = 2
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 369
    Height = 617
    Align = alLeft
    Caption = ' '
    TabOrder = 1
    object Panel5: TPanel
      Left = 1
      Top = 340
      Width = 367
      Height = 276
      Align = alBottom
      TabOrder = 0
      object Label1: TLabel
        Left = 7
        Top = 14
        Width = 43
        Height = 13
        Caption = 'Line Size'
      end
      object Label2: TLabel
        Left = 7
        Top = 60
        Width = 47
        Height = 13
        Caption = 'Point Size'
      end
      object Label3: TLabel
        Left = 3
        Top = 109
        Width = 63
        Height = 13
        Caption = 'Point Opacity'
      end
      object Label4: TLabel
        Left = 3
        Top = 151
        Width = 73
        Height = 52
        Caption = 'Layout is Customizable in Many More aspects'
        WordWrap = True
      end
      object SpinEdit_LineSize: TSpinEdit
        Left = 5
        Top = 31
        Width = 51
        Height = 22
        MaxValue = 3
        MinValue = 1
        TabOrder = 0
        Value = 2
        OnChange = SpinEdit_LineSizeChange
      end
      object CheckBox_UseGDIPlus: TCheckBox
        Left = 2
        Top = 206
        Width = 74
        Height = 39
        Caption = 'Use GDIPlus Rendering'
        Checked = True
        State = cbChecked
        TabOrder = 1
        WordWrap = True
        OnClick = CheckBox_UseGDIPlusClick
      end
      object SpinEdit_PointSize: TSpinEdit
        Left = 5
        Top = 77
        Width = 51
        Height = 22
        MaxValue = 100
        MinValue = 1
        TabOrder = 2
        Value = 12
        OnChange = SpinEdit_PointSizeChange
      end
      object SpinEdit_PointOpacity: TSpinEdit
        Left = 5
        Top = 126
        Width = 51
        Height = 22
        MaxValue = 255
        MinValue = 0
        TabOrder = 3
        Value = 200
        OnChange = SpinEdit_PointOpacityChange
      end
      object Panel7: TPanel
        Left = 87
        Top = 1
        Width = 279
        Height = 274
        Align = alRight
        TabOrder = 4
        object PageControl_PointsOrFormula: TPageControl
          Left = 1
          Top = 28
          Width = 277
          Height = 245
          ActivePage = Tab_CurvesbyPoints
          Align = alClient
          TabOrder = 0
          OnChange = PageControl_PointsOrFormulaChange
          object Tab_CurvesbyPoints: TTabSheet
            Caption = 'Interpolated Curves (by Points)'
            object BtnLoadCurves: TButton
              Left = 54
              Top = 127
              Width = 75
              Height = 25
              Caption = 'Load'
              TabOrder = 0
              OnClick = BtnLoadCurvesClick
            end
            object btnSaveCurves: TButton
              Left = 135
              Top = 127
              Width = 75
              Height = 25
              Caption = 'Save'
              TabOrder = 1
              OnClick = btnSaveCurvesClick
            end
            object Button3: TButton
              Left = 95
              Top = 158
              Width = 75
              Height = 25
              Caption = 'Reset'
              TabOrder = 2
              OnClick = Button3Click
            end
            object RadioGroup_Channel: TRadioGroup
              Left = 54
              Top = 16
              Width = 106
              Height = 105
              Caption = 'Edit Channel:'
              ItemIndex = 0
              Items.Strings = (
                'Luminance'
                'Red'
                'Green'
                'Blue')
              TabOrder = 3
              OnClick = RadioGroup_ChannelClick
            end
            object btnLoadPSCurve: TButton
              Left = 3
              Top = 189
              Width = 114
              Height = 25
              Caption = 'Load PS curve'
              TabOrder = 4
              OnClick = btnLoadPSCurveClick
            end
            object btnSavePSCurve: TButton
              Left = 135
              Top = 189
              Width = 114
              Height = 25
              Caption = 'Save PS curve'
              TabOrder = 5
              OnClick = btnSavePSCurveClick
            end
          end
          object TabFunctions: TTabSheet
            Caption = 'Math Curves'
            ImageIndex = 1
            object ComboBox_Formula: TComboBox
              Left = 23
              Top = 16
              Width = 215
              Height = 21
              Style = csDropDownList
              TabOrder = 0
              OnChange = ComboBox_FormulaChange
              Items.Strings = (
                'No Formula'
                'Gamma R-G-B Example'
                'Contrast R-G-B Example'
                'Threshold with param'
                'Levels with params')
            end
            object Panel11: TPanel
              Left = 0
              Top = 43
              Width = 269
              Height = 174
              Align = alBottom
              TabOrder = 1
              object btnLoadIni: TButton
                Left = 39
                Top = 136
                Width = 75
                Height = 25
                Caption = 'Load Ini'
                TabOrder = 3
                OnClick = btnLoadIniClick
              end
              object btnSaveIni: TButton
                Left = 142
                Top = 136
                Width = 75
                Height = 25
                Caption = 'Save Ini'
                TabOrder = 2
                OnClick = btnSaveIniClick
              end
              object GroupBox_InputLevels: TGroupBox
                Left = 1
                Top = -3
                Width = 128
                Height = 84
                Caption = 'Input Levels'
                TabOrder = 0
                object TrackBar2: TTrackBar
                  Left = 3
                  Top = 20
                  Width = 50
                  Height = 36
                  Max = 255
                  TabOrder = 0
                  OnChange = TrackBar1Change
                end
                object TrackBar3: TTrackBar
                  Left = 72
                  Top = 20
                  Width = 49
                  Height = 36
                  Max = 255
                  Position = 255
                  TabOrder = 1
                  OnChange = TrackBar1Change
                end
                object TrackBar4: TTrackBar
                  Left = 22
                  Top = 48
                  Width = 83
                  Height = 36
                  Max = 400
                  Min = 10
                  Position = 100
                  TabOrder = 2
                  OnChange = TrackBar1Change
                end
              end
              object GroupBox_OutputLevels: TGroupBox
                Left = 142
                Top = 0
                Width = 111
                Height = 84
                Caption = 'Output Levels'
                TabOrder = 1
                object TrackBar5: TTrackBar
                  Left = 3
                  Top = 20
                  Width = 50
                  Height = 36
                  Max = 255
                  TabOrder = 0
                  OnChange = TrackBar1Change
                end
                object TrackBar6: TTrackBar
                  Left = 48
                  Top = 20
                  Width = 50
                  Height = 36
                  Max = 255
                  Position = 255
                  TabOrder = 1
                  OnChange = TrackBar1Change
                end
              end
              object GroupBox_Threshold: TGroupBox
                Left = 39
                Top = 80
                Width = 178
                Height = 50
                Caption = 'Threshold'
                TabOrder = 4
                object TrackBar1: TTrackBar
                  Left = 11
                  Top = 20
                  Width = 150
                  Height = 27
                  Max = 255
                  Position = 127
                  TabOrder = 0
                  OnChange = TrackBar1Change
                end
              end
            end
          end
        end
        object Panel8: TPanel
          Left = 1
          Top = 1
          Width = 277
          Height = 27
          Align = alTop
          TabOrder = 1
          object Label6: TLabel
            Left = 7
            Top = 8
            Width = 60
            Height = 13
            Caption = 'RGB Space:'
          end
          object ComboBox1: TComboBox
            Left = 73
            Top = 4
            Width = 79
            Height = 21
            Style = csDropDownList
            ItemIndex = 0
            TabOrder = 0
            Text = 'RGB'
            OnChange = ComboBox1Change
            Items.Strings = (
              'RGB'
              'Mixed'
              'Lum')
          end
          object CheckBoxComplementary: TCheckBox
            Left = 167
            Top = 4
            Width = 97
            Height = 17
            Caption = 'Complementary'
            TabOrder = 1
            OnClick = CheckBoxComplementaryClick
          end
        end
      end
    end
    object Panel9: TPanel
      Left = 1
      Top = 1
      Width = 367
      Height = 339
      Align = alClient
      TabOrder = 1
      object RGBCurves1: TRGBCurves
        Left = 1
        Top = 1
        Width = 365
        Height = 313
        Cursor = crCross
        ComplementaryCurves = False
        TransposeCurveOnComplementaryChanged = True
        IO_Options.File_DefaultExtension = '.fcc'
        IO_Options.File_DefaultFilterStr = 'Curve files (*.fcc)|*.fcc'
        Layout.DrawPointOverCurves = True
        Layout.GraphBackColor = clWhite
        Layout.GraphBorderColor = clTeal
        Layout.GridPenStyle = psDot
        Layout.GridLineSize = 2
        Layout.GridColor = 15395562
        Layout.GridMedianLinePenStyle = psDot
        Layout.GridMedianLineSize = 3
        Layout.GridMedianLineColor = clMedGray
        Layout.CurveColor_Lum = clGray
        Layout.CurveColor_Red = clRed
        Layout.CurveColor_Green = clGreen
        Layout.CurveColor_Blue = clBlue
        Layout.CurveColor_Ink = clGray
        Layout.CurveColor_Cyan = clAqua
        Layout.CurveColor_Magenta = clPurple
        Layout.CurveColor_Yellow = clYellow
        Layout.PointColor_Lum = 2928083
        Layout.PointColor_Red = clRed
        Layout.PointColor_Green = clGreen
        Layout.PointColor_Blue = clBlue
        Layout.PointColor_Ink = 2928083
        Layout.PointColor_Cyan = clAqua
        Layout.PointColor_Magenta = clPurple
        Layout.PointColor_Yellow = clYellow
        Layout.LineSize = 3
        Layout.LineOpacity = 255
        Layout.PointSize = 8
        Layout.PointOpacity = 200
        Layout.PointFillStyle = bsSolid
        Layout.BorderPercent = 17.000000000000000000
        Layout.BorderFixed = 61
        Layout.ShowVerticalCaptions = True
        Layout.ShowMedianLine = True
        InterpLinear_Min = 40
        InterpLinear_Max = 85
        Options = [Opt_Allow_AddPoints, Opt_Allow_RemovePoints]
        CurveMode = cmBuildCurves
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 7433324
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        PointDetectTolerance = 7
        RGBSpace = csMixed
        UseGDIPlus = True
        UseFastPreview = True
        PreviewMode = pm_Auto
        ShowHistogram = False
        HistogramDisplayMode = HDmTransparent
        HistogramRGBMode = HmAll
        Histogramscalemode = HSmauto
        OnChangeRGBMode = RGBCurves1ChangeRGBMode
        OnMovePoint = RGBCurves1MovePoint
        OnMovingPoint = RGBCurves1MovingPoint
        OnCustomDraw_Labels_HorzAxis = RGBCurves1CustomDraw_Labels_HorzAxis
        OnCustomDraw_Labels_VertAxis = RGBCurves1CustomDraw_Labels_VertAxis
        OnCustomDraw_Point = RGBCurves1CustomDraw_Point
        OnIEView_BeforePreview = RGBCurves1IEView_BeforePreview
        OnIEView_AfterPreview = RGBCurves1IEView_AfterPreview
        Align = alClient
        ParentColor = False
        OnMouseMove = RGBCurves1MouseMove
        OnMouseUp = RGBCurves1MouseUp
      end
      object Panel10: TPanel
        Left = 1
        Top = 314
        Width = 365
        Height = 24
        Align = alBottom
        TabOrder = 1
        object Label_Coords: TLabel
          Left = 1
          Top = 1
          Width = 363
          Height = 22
          Align = alClient
          ExplicitWidth = 3
          ExplicitHeight = 13
        end
      end
    end
  end
  object ImageList1: TImageList
    Height = 20
    Width = 20
    Left = 752
    Top = 425
    Bitmap = {
      494C010103000400CC0014001400FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000500000001400000001002000000000000019
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C0C0C000C0C0C000FF000000FF000000FF000000C0C0C000C0C0
      C000FF000000FF000000C0C0C000C0C0C000FF000000FF000000FF000000C0C0
      C000C0C0C000FF000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C0C0C000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007D7E7F006468
      7300183D60000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C0C0C000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000064687300497C
      CC0041578C00183D600000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000003C98E40051C0
      FF00497CCC0041578C00183D6000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C0C0C00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000003C98
      E40051C0FF00497CCC0041578C00183D60000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C0C0C00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00003C98E40051C0FF00497CCC0041578C00183D600000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C0C0C000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000003C98E40051C0FF00497CCC007E82900000000000B5979400A987
      8300A9878300A9878300B5979400000000000000000000000000000000000000
      000000000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C0C0C000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000003C98E4008398AB00C8AA9F00A9878300F7EEC900FEF1
      C700FFF3CF00FDF4D700E7D9BE00A98783000000000000000000000000000000
      000000000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000A9878300FEF6CF00FFE7B900C574
      2D0098300000F3CE8D00FFFDF900ECE2D000A987830000000000000000000000
      000000000000C0C0C00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000B5979400EDE3C400FFE9BB00F3CE8D00C574
      2D0098300000F3CE8D00F3CE8D00FCF7E700D5C2AF00B5979400000000000000
      000000000000C0C0C00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000A9878300F9F3D0009830000098300000C574
      2D00983000009830000098300000FFF1CF00E1D0B600A9878300000000000000
      000000000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C0C0C000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000A9878300F8F3D000C5742D00C5742D00C574
      2D00C5742D00C5742D00C5742D00FFEABC00E0D0B800A9878300000000000000
      000000000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C0C0C000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000B5979400EADFC500FFFDF000FFFDFB00C574
      2D0098300000F3CE8D00FFE3B100FAEEC600D0BDAF00B5979400000000000000
      000000000000C0C0C00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000A9878300EADFC500FFFDF500C574
      2D0098300000FFE4B400FEF2C800E4D7BD00A987830000000000000000000000
      000000000000C0C0C00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000A9878300FFE3B100FBF5
      D100FCF6CF00F7F0CC00E2D4BC00A98783000000000000000000000000000000
      000000000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000B5979400A987
      8300A9878300A9878300B5979400000000000000000000000000000000000000
      000000000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C0C0C000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000C0C0C000C0C0C000FF000000FF000000C0C0C000C0C0
      C000FF000000FF000000C0C0C000C0C0C000FF000000FF000000C0C0C000C0C0
      C000FF000000FF000000C0C0C000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000050000000140000000100010000000000F00000000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFFFFFFFFF000000000FFFFF800
      01FFFFF000000000FFFFFBFFFDFFBFF000000000C7FFFBFFFDFF5FF000000000
      C3FFFBFFFDFEEFF000000000C1FFFBFFFDFE4FF000000000E0FFFBFFFDFF5FF0
      00000000F07FFBFFFDF359F000000000F841FBFFFDE842F000000000FC00FBFF
      FDDFFF7000000000FF007BFFFDE842F000000000FE003BFFFDF359F000000000
      FE003BFFFDFF5FF000000000FE003BFFFDFE4FF000000000FE003BFFFDFEEFF0
      00000000FF007BFFFDFF5FF000000000FF80FBFFFDFFBFF000000000FFC1FBFF
      FDFFFFF000000000FFFFF80001FFFFF000000000FFFFFFFFFFFFFFF000000000
      00000000000000000000000000000000000000000000}
  end
  object OpenImageEnDialog1: TOpenImageEnDialog
    Left = 735
    Top = 96
  end
  object SaveImageEnDialog1: TSaveImageEnDialog
    Left = 680
    Top = 96
  end
  object OpenDialog_PS: TOpenDialog
    Filter = 'PS Curves|*.atf;*.acv'
    Left = 448
    Top = 288
  end
  object SaveDialog_PS: TSaveDialog
    Filter = 'PS Curves|*.atf;*.acv'
    Left = 208
    Top = 176
  end
end
