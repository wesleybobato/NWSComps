object FormMain: TFormMain
  Left = 0
  Top = 0
  Caption = 'TThumbsBrowser Layout and Style Demo'
  ClientHeight = 641
  ClientWidth = 946
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 642
    Top = 0
    Width = 304
    Height = 641
    Align = alRight
    TabOrder = 0
    object Panel1: TPanel
      Left = 1
      Top = 61
      Width = 302
      Height = 579
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      DesignSize = (
        302
        579)
      object Label1: TLabel
        Left = 16
        Top = 389
        Width = 42
        Height = 13
        Caption = 'Captions'
      end
      object RadioGroup1: TRadioGroup
        Left = 6
        Top = 8
        Width = 267
        Height = 241
        Caption = 'Layouts'
        ItemIndex = 0
        Items.Strings = (
          'Thumbs (Vertical)'
          'Thumbs (Horizontal)'
          'Detail (Vertical)'
          'Detail (Horizontal)'
          'Report with Columns')
        TabOrder = 0
        OnClick = RadioGroup1Click
      end
      object CheckListBox1: TCheckListBox
        Left = 16
        Top = 408
        Width = 241
        Height = 169
        OnClickCheck = CheckListBox1ClickCheck
        Anchors = [akLeft, akTop, akBottom]
        ItemHeight = 13
        TabOrder = 1
      end
      object GroupBox1: TGroupBox
        Left = 5
        Top = 303
        Width = 268
        Height = 42
        TabOrder = 2
        object CheckBox_showCheckboxes: TCheckBox
          Left = 64
          Top = 3
          Width = 84
          Height = 17
          Caption = 'Check Boxes'
          TabOrder = 0
          OnClick = CheckBox_showCheckboxesClick
        end
        object CheckBox_InfoBox: TCheckBox
          Left = 149
          Top = 3
          Width = 79
          Height = 17
          Caption = 'Info Btns'
          TabOrder = 1
          OnClick = CheckBox_InfoBoxClick
        end
        object CheckBox_ShowHint: TCheckBox
          Left = 13
          Top = 3
          Width = 44
          Height = 17
          Caption = 'Hints'
          TabOrder = 2
          OnClick = CheckBox_ShowHintClick
        end
        object CheckBox_RotateBtns: TCheckBox
          Left = 64
          Top = 21
          Width = 79
          Height = 17
          Caption = 'Rotate Btns'
          TabOrder = 3
          OnClick = CheckBox_RotateBtnsClick
        end
      end
      object GroupBox2: TGroupBox
        Left = 5
        Top = 255
        Width = 268
        Height = 42
        TabOrder = 3
        object CheckBox_DropShadow: TCheckBox
          Left = 13
          Top = 3
          Width = 92
          Height = 17
          Caption = 'Drop Shadows'
          TabOrder = 0
          OnClick = CheckBox_DropShadowClick
        end
        object CheckBox_CaptionsInFrame: TCheckBox
          Left = 111
          Top = 3
          Width = 133
          Height = 17
          Caption = 'Captions inside Frame'
          TabOrder = 1
          OnClick = CheckBox_CaptionsInFrameClick
        end
        object CheckBox_BgGradient: TCheckBox
          Left = 13
          Top = 22
          Width = 148
          Height = 17
          Caption = 'Background Gradient'
          Checked = True
          State = cbChecked
          TabOrder = 2
          OnClick = CheckBox_BgGradientClick
        end
      end
    end
    object Panel_VCLStyles: TPanel
      Left = 1
      Top = 31
      Width = 302
      Height = 30
      Align = alTop
      BevelOuter = bvNone
      Ctl3D = False
      ParentBackground = False
      ParentCtl3D = False
      TabOrder = 1
      object Label4: TLabel
        Left = 16
        Top = 8
        Width = 76
        Height = 13
        Caption = 'Change Theme:'
      end
      object ComboBox_VCLStyles: TComboBox
        Left = 112
        Top = 5
        Width = 145
        Height = 21
        Style = csDropDownList
        BiDiMode = bdLeftToRight
        ParentBiDiMode = False
        TabOrder = 0
        OnClick = ComboBox_VCLStylesClick
      end
    end
    object Panel3: TPanel
      Left = 1
      Top = 1
      Width = 302
      Height = 30
      Align = alTop
      BevelOuter = bvNone
      Ctl3D = False
      ParentBackground = False
      ParentCtl3D = False
      TabOrder = 2
      object Button1: TButton
        Left = 184
        Top = 4
        Width = 75
        Height = 25
        Caption = 'Clear Thumbs'
        TabOrder = 0
        OnClick = Button1Click
      end
      object Button2: TButton
        Left = 16
        Top = 4
        Width = 97
        Height = 25
        Caption = 'Browse Folder..'
        TabOrder = 1
        OnClick = Button2Click
      end
    end
  end
  object Panel4: TPanel
    Left = 0
    Top = 0
    Width = 642
    Height = 641
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object tb1: TThumbsBrowser
      Left = 0
      Top = 30
      Width = 642
      Height = 611
      Cursor = crArrow
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
      FolderMonitor_TimerInterval = 1000
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
      MultiThread_Pool_Count = 8
      MultiThread_Timeout = 1600
      BrowsingOrientation = tbo_vert
      MaxRows = -1
      MaxCols = -1
      Centered = True
      DragScrollInterval = 100
      FileThumbs = True
      FolderThumbs = True
      NavMemory = True
      NavMemoryMaxThumbs = 4000
      FolderDefault = tbdfMyPictures
      FolderCurrent = 'C:\Users\nwsco\Pictures'
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
      StyleOptions.ThemeEnabled = True
      StyleOptions.ThemeColorOptions = [thmcl_BrowserBg, thmcl_FrameBg, thmcl_FrameBgSel, thmcl_FrameBorder, thmcl_FrameBorderSel, thmcl_CaptionBg, thmcl_CaptionBgSel, thmcl_CaptionFont, thmcl_CaptionFontSel]
      StyleOptions.ThemeElements = [thmele_CheckBox, thmele_InfoBox, thmele_RotateButtons]
      MultiSelect = True
      ThumbSize = 140
      ThumbSizeW = 140
      ThumbSizeH = 120
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
      ThumbCaption_Settings = [cap_ShowFileName, cap_ShowDateTime]
      ThumbCaptionIncludeInFrame = False
      ThumbDropShadow.Enabled = False
      ThumbDropShadow.Size = 3
      ThumbLayoutType = ltVertical
      ThumbDefaultChecked = True
      ShowRatingBox = False
      ShowCheckBoxes = False
      ShowRotateButtons = False
      ShowInfoButton = False
      SortType = stNameA
      OnCaptionsOrderChanged = tb1CaptionsOrderChanged
      OnThumbLayoutAssigned = tb1ThumbLayoutAssigned
      OnThumbLoaded = tb1ThumbLoaded
      ThumbCaption_MissingText = '????'
    end
    object Panel_Lang: TPanel
      Left = 0
      Top = 0
      Width = 642
      Height = 30
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      Visible = False
      object Label2: TLabel
        Left = 16
        Top = 8
        Width = 51
        Height = 13
        Caption = 'Language:'
      end
      object cbLang: TComboBox
        Left = 73
        Top = 3
        Width = 145
        Height = 21
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 0
        Text = 'English'
        OnClick = cbLangClick
        Items.Strings = (
          'English'
          'German'
          'Italian'
          'Spanish')
      end
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 24
    Top = 256
    object ab1: TMenuItem
      Caption = 'ab'
    end
    object cde1: TMenuItem
      Caption = 'cde'
    end
  end
end
