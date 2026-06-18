object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 585
  ClientWidth = 765
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 765
    Height = 108
    ActivePage = TabBrowsePC
    Align = alTop
    TabOrder = 0
    OnChange = PageControl1Change
    object TabBrowsePC: TTabSheet
      Caption = 'Browse PC'
      object Label1: TLabel
        Left = 3
        Top = 5
        Width = 66
        Height = 13
        Caption = 'Select Folder:'
      end
      object beFolder: TButtonedEdit
        Left = 3
        Top = 21
        Width = 430
        Height = 21
        Images = ImageList1
        ReadOnly = True
        RightButton.ImageIndex = 0
        RightButton.Visible = True
        TabOrder = 0
        OnClick = beFolderRightButtonClick
        OnRightButtonClick = beFolderRightButtonClick
      end
    end
    object TabBrowseWia: TTabSheet
      Caption = 'Browse WIA'
      ImageIndex = 1
      object Label2: TLabel
        Left = 3
        Top = 10
        Width = 93
        Height = 13
        Caption = 'Select WIA Source:'
      end
      object cmbWIADevices: TComboBox
        Left = 3
        Top = 24
        Width = 257
        Height = 21
        Style = csDropDownList
        TabOrder = 0
        OnClick = cmbWIADevicesClick
      end
      object btnRefreshWiaDevices: TButton
        Left = 266
        Top = 22
        Width = 105
        Height = 25
        Caption = 'Refresh Devices'
        TabOrder = 1
        OnClick = btnRefreshWiaDevicesClick
      end
      object pgBarWIA: TProgressBar
        Left = 0
        Top = 0
        Width = 757
        Height = 9
        Align = alTop
        TabOrder = 2
      end
      object pnWiaCommands: TPanel
        Left = 377
        Top = 16
        Width = 352
        Height = 41
        BevelOuter = bvLowered
        TabOrder = 3
        object btnBrowseWia: TButton
          Left = 15
          Top = 8
          Width = 105
          Height = 25
          Caption = 'Browse WIA'
          TabOrder = 0
          OnClick = btnBrowseWiaClick
        end
      end
    end
    object TabBrowseWPD: TTabSheet
      Caption = 'Browse Portable Device'
      ImageIndex = 3
      DesignSize = (
        757
        80)
      object Label3: TLabel
        Left = 3
        Top = 10
        Width = 95
        Height = 13
        Caption = 'Select WPD Source:'
      end
      object cmbWPDDevices: TComboBox
        Left = 3
        Top = 24
        Width = 257
        Height = 22
        Style = csOwnerDrawFixed
        TabOrder = 0
        OnClick = cmbWPDDevicesClick
        OnDrawItem = cmbWPDDevicesDrawItem
      end
      object btnRefreshWPDDevices: TButton
        Left = 266
        Top = 22
        Width = 105
        Height = 25
        Caption = 'Refresh Devices'
        TabOrder = 1
        OnClick = btnRefreshWPDDevicesClick
      end
      object pgBarWPD: TProgressBar
        Left = 0
        Top = 0
        Width = 757
        Height = 9
        Align = alTop
        TabOrder = 2
      end
      object pnWPDCommands: TPanel
        Left = 380
        Top = 13
        Width = 372
        Height = 60
        Anchors = [akLeft, akTop, akRight]
        BevelOuter = bvLowered
        TabOrder = 3
        DesignSize = (
          372
          60)
        object btnBrowseWPD: TButton
          Left = 15
          Top = 5
          Width = 105
          Height = 25
          Caption = 'Browse WPD'
          TabOrder = 0
          OnClick = btnBrowseWPDClick
        end
        object btnSearchWPD: TButton
          Left = 15
          Top = 30
          Width = 105
          Height = 25
          Caption = 'Search WPD'
          TabOrder = 1
          OnClick = btnSearchWPDClick
        end
        object EditSearchWPD: TEdit
          Left = 125
          Top = 32
          Width = 211
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 2
          Text = '*.jpg;*.jpeg;*.Tif;*.tiff;*.png;*.bmp;*.gif'
        end
      end
    end
    object TabScanner: TTabSheet
      Caption = 'Scanner'
      ImageIndex = 2
      DesignSize = (
        757
        80)
      object Label4: TLabel
        Left = 3
        Top = 10
        Width = 187
        Height = 13
        Caption = 'Select Scanner Source (Twain or WIA):'
      end
      object cmbScannerDevices: TComboBox
        Left = 3
        Top = 24
        Width = 257
        Height = 22
        Style = csOwnerDrawFixed
        TabOrder = 0
        OnClick = cmbScannerDevicesClick
        OnDrawItem = cmbScannerDevicesDrawItem
      end
      object btnRefreshScannerDevices: TButton
        Left = 266
        Top = 22
        Width = 105
        Height = 25
        Caption = 'Refresh Devices'
        TabOrder = 1
        OnClick = btnRefreshScannerDevicesClick
      end
      object pnScannerComands: TPanel
        Left = 380
        Top = 13
        Width = 372
        Height = 71
        Anchors = [akLeft, akTop, akRight]
        BevelOuter = bvLowered
        TabOrder = 2
        object btnAcquire: TButton
          Left = 15
          Top = 10
          Width = 105
          Height = 25
          Caption = 'Scan Image(s)'
          TabOrder = 0
          OnClick = btnAcquireClick
        end
        object pnScannerParams: TPanel
          Left = 126
          Top = 1
          Width = 245
          Height = 69
          Align = alRight
          BevelOuter = bvNone
          TabOrder = 1
          object Label6: TLabel
            Left = 130
            Top = 50
            Width = 59
            Height = 13
            Caption = 'Y Res (DPI):'
          end
          object Label5: TLabel
            Left = 130
            Top = 28
            Width = 59
            Height = 13
            Caption = 'X Res (DPI):'
          end
          object chkFeederEnabled: TCheckBox
            Left = 9
            Top = 5
            Width = 110
            Height = 17
            Caption = 'Feeder Enabled'
            Checked = True
            State = cbChecked
            TabOrder = 0
          end
          object chkAutoFeed: TCheckBox
            Left = 9
            Top = 21
            Width = 110
            Height = 17
            Caption = 'Auto-Feed'
            Checked = True
            State = cbChecked
            TabOrder = 1
          end
          object chkDuplexEnabled: TCheckBox
            Left = 9
            Top = 38
            Width = 110
            Height = 17
            Caption = 'Duplex Enabled'
            Checked = True
            State = cbChecked
            TabOrder = 2
          end
          object edtResY: TEdit
            Left = 192
            Top = 47
            Width = 53
            Height = 21
            TabOrder = 3
          end
          object edtResX: TEdit
            Left = 192
            Top = 25
            Width = 53
            Height = 21
            TabOrder = 4
          end
          object cmbColors: TComboBox
            Left = 131
            Top = 3
            Width = 114
            Height = 21
            Style = csDropDownList
            TabOrder = 5
          end
        end
        object chkShowScannerDialog: TCheckBox
          Left = 16
          Top = 39
          Width = 110
          Height = 17
          Caption = 'Show Dialog'
          Checked = True
          State = cbChecked
          TabOrder = 2
          OnClick = chkShowScannerDialogClick
        end
      end
      object PgBarScanner: TProgressBar
        Left = 0
        Top = 0
        Width = 757
        Height = 9
        Align = alTop
        TabOrder = 3
      end
    end
  end
  object tb1: TThumbsBrowser
    Left = 0
    Top = 108
    Width = 765
    Height = 380
    Cursor = crHandPoint
    Align = alClient
    BorderStyle = bsSingle
    Ctl3d = False
    ParentColor = False
    ParentShowHint = False
    ShowHint = True
    ShowDesignTestThumbs = False
    Language = nwsLng_EN
    OwnUserObjects = False
    FolderMonitor_Active = False
    FolderMonitor_Actions = [waAdded, waRemoved, waModified, waRenamedOld, waRenamedNew]
    FolderMonitor_TimerInterval = 300
    MetaData_Options.Fields_Exif.Strings = (
      '0|User Comment'
      '1|Image Description'
      '2|Camera Make'
      '3|Camera Model'
      '4|X Resolution'
      '5|Y Resolution'
      '6|Date-Time'
      '7|Date-Time Original'
      '8|Date-Time Digitized'
      '9|Copyright'
      '10|Orientation'
      '11|Exposure Time'
      '12|FNumber'
      '13|Exposure Program'
      '14|ISO Speed Ratings'
      '15|Shutter Speed Value'
      '16|Aperture'
      '17|Brightness'
      '18|ExposureBias'
      '19|Max Aperture'
      '20|Subject Distance'
      '21|Metering Mode'
      '22|Light Source'
      '23|Flash'
      '24|Focal Length'
      '25|FlashPix V.'
      '26|Color Space'
      '27|Image Width'
      '28|Image Height'
      '29|Related Sound File'
      '30|Focal Plane XRes'
      '31|Focal Plane YRes'
      '32|Exposure Index'
      '33|Sensing Method'
      '34|File Source'
      '35|Scene Type'
      '36|YCbCr Positioning'
      '37|Exposure Mode'
      '38|White Balance'
      '39|Digital-Zoom Ratio'
      '40|Focal Length 35mm eq.'
      '41|Scene Capture Type'
      '42|Gain Control'
      '43|Contrast'
      '44|Saturation'
      '45|Sharpness'
      '46|Subject Distance Range'
      '47|GPS Latitude'
      '48|GPS Longitude'
      '49|GPS Altitude'
      '50|GPS Image Direction'
      '51|GPS Track'
      '52|GPS Speed'
      '53|GPS Date And Time'
      '54|GPS Satellites'
      '55|GPS VersionID'
      '56|Artist'
      '57|Title (Windows)'
      '58|Comment (Windows)'
      '59|Author (Windows)'
      '60|Keywords (Windows)'
      '61|Subject (Windows)'
      '62|Rating (Windows)'
      '63|Interop Version'
      '64|Camera Owner Name'
      '65|Body Serial Number'
      '66|Lens Make'
      '67|Lens Model'
      '68|Lens Serial Number'
      '69|Gamma'
      '70|Subject Area'
      '71|Subject Location')
    MetaData_Options.Fields_IPTC.Strings = (
      '2|5|Title'
      '2|120|Caption'
      '2|25|Keywords'
      '2|40|Special Instructions'
      '2|40|Special Instructions'
      '2|55|Date Created (YYYYMMDD)'
      '2|60|Time Created (HHMMSS'#177'HHMM)'
      '2|80|By-line 1'
      '2|85|By-line 2'
      '2|90|City'
      '2|95|State/Province'
      '2|100|Country/ Location Code'
      '2|101|Country/ Location Name'
      '2|103|Original Transmission Reference'
      '2|110|Credit'
      '2|122|Editor'
      '2|7|Edit status'
      '2|10|Urgency'
      '2|15|Category'
      '2|20|Supplemental Category'
      '2|22|Fixture Identifier'
      '2|30|Release Date (YYYYMMDD)'
      '2|35|Release Time (HHMMSS'#177'HHMM)'
      '2|45|Reference Service'
      '2|47|Reference Date (YYYYMMDD)'
      '2|50|Reference Number'
      '2|65|Originating Program'
      '2|70|Program Version'
      '2|75|Object Cycle (a=AM, b=PM, c=both)'
      '2|130|Image Type'
      '2|116|Copyright Notice')
    MetaData_Options.Fields_Xmp.Strings = (
      'aux:ApproximateFocusDistance|Focus Distance'
      'aux:Firmware|Firmware'
      'aux:FlashCompensation|Flash Compensation'
      'aux:ImageNumber|Image Number'
      'aux:Lens|Lens'
      'aux:LensID|Lens ID'
      'aux:LensInfo|Lens Info'
      'aux:LensSerialNumber|Lens Serial Number'
      'aux:OwnerName|Owner Name'
      'aux:SerialNumber|Serial Number'
      'cc:AttributionName|Attribution Name'
      'cc:AttributionURL|Attribution URL'
      'cc:DeprecatedOn|Deprecated On'
      'cc:Jurisdiction|Jurisdiction'
      'cc:LegalCode|Legal Code'
      'cc:License|License'
      'cc:MorePermissions|More Permissions'
      'cc:Permits|Permits'
      'cc:Prohibits|Prohibits'
      'cc:Requires|Requires'
      'cc:UseGuidelines|Use Guidelines'
      'dc:Contributor|Contributor'
      'dc:Coverage|Coverage'
      'dc:Creator|Creator'
      'dc:Date|Date'
      'dc:Description|Description'
      'dc:Format|Format'
      'dc:Identifier|Identifier'
      'dc:Language|Language'
      'dc:Publisher|Publisher'
      'dc:Relation|Relation'
      'dc:Rights|Rights'
      'dc:Source|Source'
      'dc:Subject|Subject'
      'dc:Title|Title'
      'dc:Type|Type'
      'photoshop:AuthorsPosition|Authors Position'
      'photoshop:CaptionWriter|Caption Writer'
      'photoshop:Category|Category'
      'photoshop:City|City'
      'photoshop:ColorMode|Color Mode'
      'photoshop:Country|Country'
      'photoshop:Credit|Credit'
      'photoshop:DateCreated|Date Created'
      'photoshop:DocumentAncestorID|Document Ancestor ID'
      'photoshop:Headline|Headline'
      'photoshop:History|History'
      'photoshop:ICCProfileName|ICC Profile Name'
      'photoshop:Instructions|Instructions'
      'photoshop:Source|Source'
      'photoshop:State|State'
      'photoshop:SupplementalCategories|Supplemental Categories'
      'photoshop:TextLayerName|Text-Layer Name'
      'photoshop:TextLayerText|Text-Layer Text'
      'photoshop:TransmissionReference|Transmission Reference'
      'photoshop:Urgency|Urgency'
      'xmp:Advisory|Advisory'
      'xmp:Author|Author'
      'xmp:BaseURL|BaseURL'
      'xmp:CreateDate|Create Date'
      'xmp:CreatorTool|Creator Tool'
      'xmp:Description|Description'
      'xmp:Format|Format'
      'xmp:Identifier|Identifier'
      'xmp:Keywords|Keywords'
      'xmp:Label|Label'
      'xmp:MetadataDate|Metadata Date'
      'xmp:ModifyDate|Modify Date'
      'xmp:Nickname|Nickname'
      'xmp:Rating|Rating'
      'xmp:Title|Title')
    MetaData_Options.Fields_Common.Strings = (
      '{EXIF}[57|Title (Windows)]{IPTC}[2|5|Title]{XMP}[dc:Title|Title]'
      
        '{EXIF}[61|Subject (Windows)]{IPTC}[2|120|Caption]{XMP}[dc:Subjec' +
        't|Subject]'
      '{EXIF}[58|Comment (Windows)]{XMP}[dc:Description|Description]'
      '{EXIF}[62|Rating (Windows)]{XMP}[xmp:Rating|Rating]'
      
        '{EXIF}[60|Keywords (Windows)]{IPTC}[2|25|Keywords]{XMP}[xmp:Keyw' +
        'ords|Keywords]'
      '{IPTC}[2|15|Category]{XMP}[photoshop:Category|Category]'
      
        '{IPTC}[2|20|Supplemental Category]{XMP}[photoshop:SupplementalCa' +
        'tegories|Supplemental Categories]')
    MetaData_Options.AutoSync_TopTitle = mdSyncOp_ReadWrite
    MetaData_Options.AutoSync_BottomTitle = mdSyncOp_ReadWrite
    MetaData_Options.AutoSync_Rating = mdSyncOp_ReadWrite
    MetaData_Options.AutoSync_Keywords = mdSyncOp_ReadWrite
    MetaData_Options.UseExifOrientationForThumbs = True
    DragDropOptions.IS_DragSource_TB = True
    DragDropOptions.IS_DropTarget_TB = True
    DragDropOptions.IS_DragSource_Explorer = False
    DragDropOptions.IS_DropTarget_Explorer = False
    DragDropOptions.TransferMode_TB = dd_DetectShiftState
    DragDropOptions.TransferMode_Exp = dd_Copy
    DragDropOptions.DropBehavior = ddb_Thumbs
    FileScanner_MaxTransfer = 250
    MultiThread = True
    MultiThread_Pool_Count = 5
    MultiThread_Timeout = 3000
    BrowsingOrientation = tbo_vert
    MaxRows = -1
    MaxCols = -1
    Centered = True
    DragScrollInterval = 200
    FileThumbs = True
    FolderThumbs = True
    NavMemory = True
    NavMemoryMaxThumbs = 4000
    FolderDefault = tbdfNone
    FolderUpNavThumb = True
    FolderNavigation = True
    FolderCheckBoxes = True
    FolderTitles = False
    FileOptions.HiddenFiles = False
    FileOptions.HiddenFolders = False
    FileOptions.SystemFiles = False
    FileOptions.SystemFolders = False
    BackgroundType = tbbgt_SolidColor
    BackgroundColor = clWhite
    Background2ndColor = clSkyBlue
    StyleOptions.BrowserStyle = tbStyle_Custom
    StyleOptions.CaptionsOptions.SizePerc_HorzLayout = 150
    StyleOptions.CaptionsOptions.Style = capSt_RowsCentered
    StyleOptions.CaptionsOptions.TextPadding = 6
    StyleOptions.ThemeEnabled = False
    StyleOptions.ThemeColorOptions = [thmcl_BrowserBg, thmcl_FrameBg, thmcl_FrameBgSel, thmcl_FrameBorder, thmcl_FrameBorderSel, thmcl_CaptionBg, thmcl_CaptionBgSel, thmcl_CaptionFont, thmcl_CaptionFontSel]
    StyleOptions.ThemeElements = [thmele_CheckBox, thmele_InfoBox, thmele_RotateButtons]
    MultiSelect = True
    ThumbSize = 150
    ThumbSizeW = 150
    ThumbSizeH = 150
    Buffer_ThumbSize = 170
    StoreType = tbstore_Thumb
    ThumbsMouseOverOptions = [moFrameBg, moFrameBorder, moCaptionBg, moCaptionText]
    ThumbsFrameBgColor = clWhite
    ThumbsFrameBgSelectedColor = clWhite
    ThumbsCaptionFontColor = clBlack
    ThumbsCaptionFontSelectedColor = clBlack
    ThumbsCaptionBackColor = clSkyBlue
    ThumbsCaptionBackSelectedColor = clSkyBlue
    ThumbsTopTitleFontColor = clBlack
    ThumbsTopTitleFontSelectedColor = clBlack
    ThumbsTopTitleBackColor = clWhite
    ThumbsTopTitleBackSelectedColor = clWhite
    ThumbsBottomTitleFontColor = clBlack
    ThumbsBottomTitleFontSelectedColor = clBlack
    ThumbsBottomTitleBackColor = clWhite
    ThumbsBottomTitleBackSelectedColor = clWhite
    ThumbsFrameBorderColor = 16744448
    ThumbsFrameBorderSelectedColor = 32767
    ThumbsFrameSize = 2
    ThumbsFrameRoundnessPerc = 8
    ThumbsCaptionRoundnessPerc = 10
    ThumbsTitleRoundnessPerc = 0
    ThumbsBackOpacity = 255
    ThumbsBackOpacitySelected = 255
    ThumbsFrameBgOpacity = 255
    ThumbsFrameBgOpacitySelected = 255
    ThumbsFrameBorderOpacity = 255
    ThumbsFrameBorderOpacitySelected = 255
    ThumbsCaptionOpacity = 128
    ThumbsCaptionOpacitySelected = 255
    ThumbsTitleOpacity = 0
    ThumbsTitleOpacitySelected = 255
    ThumbsTitleDrawFocusRectIfEmpty = True
    ThumbsBackPadding_Left = 0
    ThumbsBackPadding_Right = 0
    ThumbsBackPadding_Bottom = 0
    ThumbsBackPadding_Top = 0
    ThumbsFramePadding_Left = 2
    ThumbsFramePadding_Right = 2
    ThumbsFramePadding_Top = 1
    ThumbsFramePadding_Bottom = 1
    ThumbsSpacing = 6
    ThumbsSpacingX = 6
    ThumbsSpacingY = 6
    ResampleMethod = rfNearest
    DisplayMethod = rfNearest
    Filter = '*.*'
    PopupDefaultExplorer = True
    ShowThumbnailHint = False
    ShowTopTitle = False
    ShowBottomTitle = False
    ShowCaptions = True
    ThumbCaption_Settings = [cap_ShowFileName, cap_ShowDateTime, cap_ShowFileDimensionsAndSize]
    ThumbCaptionIncludeInFrame = True
    ThumbDropShadow.Enabled = True
    ThumbDropShadow.Size = 3
    ThumbLayoutType = ltVertical
    ThumbDefaultChecked = True
    ShowRatingBox = False
    ShowCheckBoxes = False
    ShowRotateButtons = False
    ShowInfoButton = False
    SortType = stNameA
    OnThumbSelectionChange = tb1ThumbSelectionChange
    ThumbCaption_MissingText = '????'
  end
  object pnBottom: TPanel
    Left = 0
    Top = 488
    Width = 765
    Height = 97
    Align = alBottom
    TabOrder = 2
    object GroupBox1: TGroupBox
      Left = 16
      Top = 13
      Width = 729
      Height = 76
      Caption = 'What do you wish to do with Selected Items?'
      TabOrder = 0
      object Label7: TLabel
        Left = 236
        Top = 53
        Width = 90
        Height = 13
        Caption = 'TIFF Compression:'
      end
      object Button1: TButton
        Left = 516
        Top = 13
        Width = 201
        Height = 25
        Caption = 'Save To MultiBitmap'
        TabOrder = 0
        OnClick = Button1Click
      end
      object Button2: TButton
        Left = 516
        Top = 44
        Width = 201
        Height = 25
        Caption = 'Save To MultiFile..'
        TabOrder = 1
        OnClick = Button2Click
      end
      object trbCompression: TTrackBar
        Left = 329
        Top = 48
        Width = 150
        Height = 25
        TabOrder = 2
      end
      object rbtBW: TRadioButton
        Left = 13
        Top = 52
        Width = 61
        Height = 17
        Caption = 'B/W'
        TabOrder = 3
      end
      object rbtGrayscale: TRadioButton
        Left = 80
        Top = 52
        Width = 74
        Height = 17
        Caption = 'GrayScale'
        TabOrder = 4
      end
      object rbtFullColor: TRadioButton
        Left = 160
        Top = 52
        Width = 61
        Height = 17
        Caption = 'Full Color'
        Checked = True
        TabOrder = 5
        TabStop = True
      end
      object chkOnlyThumbnails: TCheckBox
        Left = 334
        Top = 18
        Width = 150
        Height = 17
        Caption = 'Export Only Thumbnails'
        TabOrder = 6
      end
    end
    object ProgressBar1: TProgressBar
      Left = 1
      Top = 1
      Width = 763
      Height = 9
      Align = alTop
      TabOrder = 1
    end
  end
  object ImageList1: TImageList
    Left = 32
    Top = 424
    Bitmap = {
      494C010101000800640010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000F8F8F800EDF1
      F200000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000DCDCDD009BA5
      AB009CE0F90096D9F30093DBF600D4F0FB0000000000FDFDFD00F3F4F40075BC
      D800D2E1E7000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E7E7E700C0C0C1008CA7
      B30094D8F300A5D8ED00D0E2EC00E1E4E500B3C0BA0053857E00204A41004892
      BD007AC2E000C2E2F00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000D8D8D800CFCFD00096B2
      BC003F6E5F0000463A0005524C000054430006614A00317262005F757400339E
      CC002DA4D7002BA6DA0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F0F0F000E9E9EA00E3E3E3009BC0
      CE00C0C4C500614D51007C7D81005B5C5C004F545D003C373E00655C6F003BA3
      CF0038A9DC002FA9DE0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FBFBFB00A7C7
      D4008C9F9D00EACCAA00D0B8A500888798004C474300EAC99B00C4A883003AA0
      D1003FACE10035AAE20000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000DCBEA300FBC59400FAC49200998B8F00A5775C00F9C18E0068CAF8006BC4
      EE004EB7EA003BADE70000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000F9C28D00F6B27800F3B47E00F1B17B00F2B07800EEAF790072D0FA0073C7
      F00082CBF0003DAFEA0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000F6B57D00EFB88D00E7A06A00E7A06A00E59E6900E39E6B007AD6FE007CCD
      F2008DD1F30070C4F00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000E9A26800EEDBCC00DF955F00DC945E00DB935D00D98E58007BD7FF0089D2
      F7009AD4F500A1D6F50000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000DE905800E4CDBC00EEE2D900F1EAE400EBCDB500E8B082008BDCFF0097D9
      FC00AADDFC00ACDCF80000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000D1844A00D78A5100DC945F00DC945F00DE976200E29C680093E0FF009FDE
      FD00B8E5FF00B9E1FA0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000A2E7FE009ADFFA00B1E9FF00E6F1F500EDCAB100D895630098E2FF00ACE1
      FC00C8E8FF00C7E4FA0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000A6E9FE00A1E4FE00A1E4FE00A2E5FF00A3E5FF00A1E5FF00C6E7FA00D0E9
      FC00D5EDFF00D4EAFA0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000B5C5CB00B4E3F40093DBF60099E0FC00A1E4FE00A3E4FD0090DB
      F900DEEFFB00DDECFA0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FDFDFD00FCFCFC0000000000000000000000
      0000F0F2F300DDF2FA0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFCF000000000000C087000000000000
      800300000000000080030000000000000003000000000000C003000000000000
      F003000000000000F003000000000000F003000000000000F003000000000000
      F003000000000000F003000000000000F003000000000000F003000000000000
      F803000000000000FE7300000000000000000000000000000000000000000000
      000000000000}
  end
  object SaveImageEnDialog1: TSaveImageEnDialog
    Filter = 'GIF|*.gif|TIFF|*.tif;*.tiff|ICO|*.ico|AVI|*.avi|PDF|*.pdf'
    AutoSetFilter = False
    ExOptions = [sdShowPreview, sdShowAdvanced]
    Left = 544
    Top = 120
  end
end
