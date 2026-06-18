object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 539
  ClientWidth = 1006
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 771
    Top = 0
    Width = 235
    Height = 539
    Align = alRight
    TabOrder = 0
    ExplicitLeft = 725
    object PageControl1: TPageControl
      Left = 1
      Top = 1
      Width = 233
      Height = 537
      ActivePage = Tab1
      Align = alClient
      TabOrder = 0
      OnChange = PageControl1Change
      object Tab1: TTabSheet
        Caption = '1st Scenario'
        object Label1: TLabel
          Left = 13
          Top = 267
          Width = 177
          Height = 13
          Caption = 'Drop To ImageEn below also possible'
        end
        object Memo1: TMemo
          Left = 0
          Top = 0
          Width = 225
          Height = 137
          Align = alTop
          Lines.Strings = (
            'In this scenario:'
            ' >TB1 (White) is the Source '
            ' >TB2 (Yellow) is the Target'
            ' >Listbox1 (blue) is also a Target'
            ''
            'We want just to drag & drop the thumbnails '
            'from one component to the other, without '
            'copying or moving the actual files'
            '')
          TabOrder = 0
        end
        object RadioGroup1: TRadioGroup
          Left = 24
          Top = 143
          Width = 185
          Height = 105
          Caption = 'DragDrop Settings:'
          ItemIndex = 0
          Items.Strings = (
            'Copy Thumbs'
            'Move Thumbs')
          TabOrder = 1
          OnClick = RadioGroup1Click
        end
        object PageControl2: TPageControl
          Left = 0
          Top = 286
          Width = 225
          Height = 223
          ActivePage = TabSheet1
          Align = alBottom
          TabOrder = 2
          object TabSheet1: TTabSheet
            Caption = 'ImageEnView'
            ExplicitHeight = 177
            object ImageEnView1: TImageEnView
              Left = 0
              Top = 0
              Width = 217
              Height = 195
              Background = clBtnFace
              ParentCtl3D = False
              LegacyBitmap = True
              MouseInteract = [miZoom]
              BackgroundStyle = iebsChessboard
              EnableInteractionHints = True
              Align = alClient
              TabOrder = 0
              OnDragDrop = OtherCompDragDrop
              ExplicitLeft = -8
              ExplicitTop = -40
              ExplicitWidth = 225
              ExplicitHeight = 217
            end
          end
          object TabSheet2: TTabSheet
            Caption = 'ImageEnMView'
            ImageIndex = 1
            ExplicitHeight = 177
            object ImageEnMView1: TImageEnMView
              Left = 0
              Top = 0
              Width = 217
              Height = 195
              Background = clBtnFace
              ParentCtl3D = False
              StoreType = ietNormal
              ThumbWidth = 100
              ThumbHeight = 100
              HorizBorder = 4
              VertBorder = 4
              TextMargin = 0
              GridWidth = 0
              Style = iemsACD
              ThumbnailsBackground = clBtnFace
              ThumbnailsBackgroundSelected = clBtnFace
              MultiSelectionOptions = []
              ThumbnailsBorderWidth = 0
              DefaultBottomText = iedtNone
              Align = alClient
              TabOrder = 0
              OnDragDrop = OtherCompDragDrop
              ExplicitLeft = 56
              ExplicitTop = 24
              ExplicitWidth = 180
              ExplicitHeight = 90
            end
          end
        end
      end
      object Tab2: TTabSheet
        Caption = '2nd Scenario'
        ImageIndex = 1
        object Memo2: TMemo
          Left = 0
          Top = 0
          Width = 225
          Height = 161
          Align = alTop
          Lines.Strings = (
            'In this scenario:'
            'Both TB1 and TB2 are possible Source and '
            'Target'
            ''
            'We want to copy or move the actual files '
            '(not just the thumbnails) using the '
            'components as they were part of Windows '
            'Explorer'
            ''
            'Here You can also DragDrop Files From and '
            'To Windows Explorer')
          TabOrder = 0
        end
        object RadioGroup2: TRadioGroup
          Left = 24
          Top = 176
          Width = 185
          Height = 105
          Caption = 'DragDrop Settings:'
          ItemIndex = 0
          Items.Strings = (
            'Copy Files'
            'Move Files')
          TabOrder = 1
          OnClick = RadioGroup2Click
        end
        object CheckBoxFolderMonitor: TCheckBox
          Left = 32
          Top = 352
          Width = 153
          Height = 17
          Caption = 'Activate Folder Monitor'
          TabOrder = 2
          OnClick = CheckBoxFolderMonitorClick
        end
      end
    end
  end
  object ListBox1: TListBox
    Left = 616
    Top = 0
    Width = 155
    Height = 539
    Align = alRight
    Color = 16247242
    ItemHeight = 13
    TabOrder = 1
    OnDragDrop = OtherCompDragDrop
    ExplicitLeft = 568
    ExplicitHeight = 537
  end
  object Panel4: TPanel
    Left = 0
    Top = 0
    Width = 616
    Height = 539
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    ExplicitLeft = 1
    ExplicitTop = 1
    ExplicitWidth = 723
    ExplicitHeight = 537
    object Splitter1: TSplitter
      Left = 312
      Top = 0
      Width = 5
      Height = 539
      ExplicitLeft = 310
      ExplicitTop = 1
      ExplicitHeight = 396
    end
    object Panel6: TPanel
      Left = 317
      Top = 0
      Width = 299
      Height = 539
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      ExplicitWidth = 274
      ExplicitHeight = 537
      object ThumbsBrowser2: TThumbsBrowser
        Left = 0
        Top = 40
        Width = 299
        Height = 499
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
        MultiThread_Timeout = 4000
        BrowsingOrientation = tbo_vert
        MaxRows = -1
        MaxCols = -1
        Centered = True
        DragScrollInterval = 200
        FileThumbs = True
        FolderThumbs = False
        NavMemory = True
        NavMemoryMaxThumbs = 4000
        FolderDefault = tbdfNone
        FolderUpNavThumb = False
        FolderNavigation = True
        FolderCheckBoxes = True
        FolderTitles = False
        FileOptions.HiddenFiles = False
        FileOptions.HiddenFolders = False
        FileOptions.SystemFiles = False
        FileOptions.SystemFolders = False
        BackgroundType = tbbgt_SolidColor
        BackgroundColor = 10813439
        Background2ndColor = clSkyBlue
        StyleOptions.BrowserStyle = tbStyle_Custom
        StyleOptions.CaptionsOptions.SizePerc_HorzLayout = 150
        StyleOptions.CaptionsOptions.Style = capSt_RowsCentered
        StyleOptions.CaptionsOptions.TextPadding = 6
        StyleOptions.ThemeEnabled = False
        StyleOptions.ThemeColorOptions = [thmcl_BrowserBg, thmcl_FrameBg, thmcl_FrameBgSel, thmcl_FrameBorder, thmcl_FrameBorderSel, thmcl_CaptionBg, thmcl_CaptionBgSel, thmcl_CaptionFont, thmcl_CaptionFontSel]
        StyleOptions.ThemeElements = [thmele_CheckBox, thmele_InfoBox, thmele_RotateButtons]
        MultiSelect = True
        ThumbSize = 170
        ThumbSizeW = 170
        ThumbSizeH = 170
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
        ExplicitWidth = 274
        ExplicitHeight = 497
        ThumbCaption_MissingText = '????'
      end
      object Panel7: TPanel
        Left = 0
        Top = 0
        Width = 299
        Height = 40
        Align = alTop
        BevelOuter = bvNone
        BorderWidth = 3
        TabOrder = 1
        ExplicitWidth = 274
        object LabelTb2: TLabel
          Left = 3
          Top = 3
          Width = 293
          Height = 34
          Align = alClient
          ExplicitWidth = 3
          ExplicitHeight = 13
        end
        object btnFolder2: TButton
          Left = 2
          Top = 18
          Width = 20
          Height = 20
          Hint = 'Select Folder..'
          Caption = '..'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnClick = btnFolder1Click
        end
      end
    end
    object Panel8: TPanel
      Left = 0
      Top = 0
      Width = 312
      Height = 539
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 1
      ExplicitHeight = 537
      object ThumbsBrowser1: TThumbsBrowser
        Left = 0
        Top = 40
        Width = 312
        Height = 499
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
        MultiThread_Timeout = 4000
        BrowsingOrientation = tbo_vert
        MaxRows = -1
        MaxCols = -1
        Centered = True
        DragScrollInterval = 200
        FileThumbs = True
        FolderThumbs = False
        NavMemory = True
        NavMemoryMaxThumbs = 4000
        FolderDefault = tbdfNone
        FolderUpNavThumb = False
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
        ThumbSize = 120
        ThumbSizeW = 120
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
        ThumbsSpacing = 4
        ThumbsSpacingX = 4
        ThumbsSpacingY = 4
        ResampleMethod = rfNearest
        DisplayMethod = rfNearest
        Filter = '*.*'
        PopupDefaultExplorer = True
        ShowThumbnailHint = False
        ShowTopTitle = False
        ShowBottomTitle = False
        ShowCaptions = True
        ThumbCaption_Settings = [cap_ShowFileName, cap_ShowDateTime, cap_ShowFileDimensionsAndSize]
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
        ExplicitHeight = 497
        ThumbCaption_MissingText = '????'
      end
      object Panel9: TPanel
        Left = 0
        Top = 0
        Width = 312
        Height = 40
        Align = alTop
        BevelOuter = bvNone
        BorderWidth = 3
        TabOrder = 1
        object LabelTB1: TLabel
          Left = 3
          Top = 3
          Width = 306
          Height = 34
          Align = alClient
          ExplicitWidth = 3
          ExplicitHeight = 13
        end
        object btnFolder1: TButton
          Left = 0
          Top = 18
          Width = 20
          Height = 20
          Hint = 'Select Folder..'
          Caption = '..'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnClick = btnFolder1Click
        end
      end
    end
  end
  object ShProc1: TThumbsBrowserShellProcessor
    AttachedBrowser = ThumbsBrowser1
    Left = 424
    Top = 320
  end
end
