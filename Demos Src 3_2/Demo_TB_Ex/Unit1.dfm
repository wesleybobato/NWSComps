object Form1: TForm1
  Left = 328
  Top = 148
  Caption = 'ThumbsBrowser Extended Demo'
  ClientHeight = 749
  ClientWidth = 918
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  WindowState = wsMaximized
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 632
    Top = 0
    Width = 286
    Height = 749
    Align = alRight
    TabOrder = 0
    object PageControl1: TPageControl
      Left = 1
      Top = 383
      Width = 284
      Height = 365
      ActivePage = TabBrowsingOptions
      Align = alBottom
      TabOrder = 0
      object TabBrowsingOptions: TTabSheet
        Caption = 'Browsing Options'
        DesignSize = (
          276
          337)
        object Label3: TLabel
          Left = 119
          Top = 91
          Width = 42
          Height = 26
          Caption = 'File type filter'
          WordWrap = True
        end
        object Label4: TLabel
          Left = 13
          Top = 262
          Width = 19
          Height = 13
          Caption = 'Sort'
        end
        object Label6: TLabel
          Left = 13
          Top = 282
          Width = 91
          Height = 26
          Caption = 'Instant Search..   Type text to search'
          WordWrap = True
        end
        object rgpBrowserOrientation: TRadioGroup
          Left = 1
          Top = 23
          Width = 112
          Height = 85
          Caption = 'Browse Orientation'
          ItemIndex = 1
          Items.Strings = (
            'Horizontal'
            'Vertical')
          TabOrder = 0
          OnClick = rgpBrowserOrientationClick
        end
        object chkMultiSelect: TCheckBox
          Left = 119
          Top = 9
          Width = 146
          Height = 53
          Caption = 'MultiSelect (Use Ctrl or Shift for multiple selection)'
          Checked = True
          State = cbChecked
          TabOrder = 1
          WordWrap = True
          OnClick = chkMultiSelectClick
        end
        object chkFileCheckboxes: TCheckBox
          Left = 119
          Top = 52
          Width = 140
          Height = 17
          Caption = 'CheckBoxes'
          Checked = True
          State = cbChecked
          TabOrder = 2
          OnClick = chkFileCheckboxesClick
        end
        object chkShowRotateButtons: TCheckBox
          Left = 3
          Top = 137
          Width = 140
          Height = 17
          Caption = 'Show File Rotate Buttons'
          TabOrder = 3
          OnClick = chkShowRotateButtonsClick
        end
        object chkShowCaptions: TCheckBox
          Left = 3
          Top = 160
          Width = 140
          Height = 17
          Caption = 'Show Captions'
          Checked = True
          State = cbChecked
          TabOrder = 4
          OnClick = chkShowCaptionsClick
        end
        object chkFileSize: TCheckBox
          Left = 14
          Top = 192
          Width = 99
          Height = 17
          Caption = 'Show File Size'
          TabOrder = 5
          OnClick = chkFileSizeClick
        end
        object cmbFilterByFileType: TComboBox
          Left = 161
          Top = 91
          Width = 113
          Height = 21
          Style = csDropDownList
          DropDownCount = 12
          ItemIndex = 1
          TabOrder = 6
          Text = '*.*'
          OnClick = cmbFilterByFileTypeClick
          Items.Strings = (
            '[*.*]'
            '*.*'
            '[PICTURE FILES]'
            '[VIDEO FILES]'
            '[RAW FILES]'
            '*.jpg;*.jpeg'
            '*.gif'
            '*.bmp'
            '*.png'
            '*.tif;*.tiff'
            '*.psd')
        end
        object chkDBEnabled: TCheckBox
          Left = 0
          Top = 5
          Width = 140
          Height = 17
          Caption = 'Use Database Storage'
          TabOrder = 7
          Visible = False
          OnClick = chkDBEnabledClick
        end
        object btnResetSearch: TButton
          Left = 126
          Top = 306
          Width = 130
          Height = 25
          Caption = 'Reset Search'
          TabOrder = 8
          OnClick = btnResetSearchClick
        end
        object cmbSortThumbs: TComboBox
          Left = 38
          Top = 257
          Width = 125
          Height = 21
          Cursor = crHandPoint
          Hint = 'Change Thumbs Sorting'
          Style = csDropDownList
          Anchors = [akTop, akRight]
          DropDownCount = 16
          ItemIndex = 0
          ParentShowHint = False
          ShowHint = True
          TabOrder = 9
          Text = 'Sort by Name >'
          OnClick = cmbSortThumbsClick
          Items.Strings = (
            'Sort by Name >'
            'Sort by Name <'
            'Sort by Date >'
            'Sort by Date <'
            'Sort by EXIF Date >'
            'Sort by EXIF Date <'
            'Sort by Size >'
            'Sort by Size <'
            'Sort by Folder >'
            'Sort by Folder <'
            'Sort by File Type >'
            'Sort by File Type <'
            'Sort by Name (Natural Order) >'
            'Sort by Name (Natural Order) <'
            'Sort by Folder (Natural Order) >'
            'Sort by Folder (Natural Order) <')
        end
        object chkShowInfoButton: TCheckBox
          Left = 3
          Top = 114
          Width = 140
          Height = 17
          Caption = 'Show File Info button'
          Checked = True
          State = cbChecked
          TabOrder = 10
          OnClick = chkFileSizeClick
        end
        object Edit_search: TEdit
          Left = 12
          Top = 310
          Width = 106
          Height = 21
          TabOrder = 11
          OnChange = Edit_searchChange
        end
        object chkFolderCheckboxes: TCheckBox
          Left = 133
          Top = 68
          Width = 140
          Height = 17
          Caption = 'Folder CheckBoxes'
          Checked = True
          State = cbChecked
          TabOrder = 12
          OnClick = chkFileCheckboxesClick
        end
        object chkFileName: TCheckBox
          Left = 14
          Top = 177
          Width = 99
          Height = 17
          Caption = 'Show File Name'
          Checked = True
          State = cbChecked
          TabOrder = 13
          OnClick = chkFileSizeClick
        end
        object chkPicSize: TCheckBox
          Left = 14
          Top = 207
          Width = 99
          Height = 17
          Caption = 'Show Pic Size'
          Checked = True
          State = cbChecked
          TabOrder = 14
          OnClick = chkFileSizeClick
        end
        object chkFileDate: TCheckBox
          Left = 14
          Top = 223
          Width = 99
          Height = 17
          Caption = 'Show File Date'
          TabOrder = 15
          OnClick = chkFileSizeClick
        end
        object chkTopTitle: TCheckBox
          Left = 119
          Top = 160
          Width = 140
          Height = 17
          Caption = 'Show TopTitle'
          TabOrder = 16
          OnClick = chkTopTitleClick
        end
        object chkBottomTitle: TCheckBox
          Left = 119
          Top = 177
          Width = 140
          Height = 17
          Caption = 'Show BottomTitle'
          TabOrder = 17
          OnClick = chkBottomTitleClick
        end
        object chkShowThumbHint: TCheckBox
          Left = 119
          Top = 230
          Width = 140
          Height = 17
          Caption = 'Show Thumb Hint'
          TabOrder = 18
          OnClick = chkShowThumbHintClick
        end
        object chkShowTitlesOnFolders: TCheckBox
          Left = 137
          Top = 195
          Width = 140
          Height = 17
          Caption = 'Titles On Folders'
          TabOrder = 19
          OnClick = chkShowTitlesOnFoldersClick
        end
        object chkRating: TCheckBox
          Left = 160
          Top = 137
          Width = 113
          Height = 17
          Caption = 'Show Rating'
          TabOrder = 20
          OnClick = chkShowThumbHintClick
        end
        object chkShowTitleRect: TCheckBox
          Left = 119
          Top = 211
          Width = 140
          Height = 17
          Caption = 'Show Empty Title Frame'
          TabOrder = 21
          OnClick = chkShowThumbHintClick
        end
      end
      object TabCustomLook: TTabSheet
        Caption = 'Custom Look'
        ImageIndex = 2
        object Label16: TLabel
          Left = 186
          Top = 226
          Width = 86
          Height = 60
          AutoSize = False
          Caption = 'Any element can be changed'#13#10'in color, graphics and opacity'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          WordWrap = True
        end
        object Panel_Frame: TPanel
          Left = 3
          Top = 111
          Width = 174
          Height = 80
          BevelInner = bvLowered
          Color = clWhite
          ParentBackground = False
          TabOrder = 0
          OnClick = Panel_FrameClick
        end
        object Panel_Pic: TPanel
          Left = 14
          Top = 119
          Width = 153
          Height = 65
          BevelInner = bvLowered
          Color = clWhite
          ParentBackground = False
          TabOrder = 1
          OnClick = Panel_FrameClick
        end
        object Panel_Caption: TPanel
          Left = 3
          Top = 192
          Width = 174
          Height = 26
          BevelInner = bvLowered
          Color = clWhite
          ParentBackground = False
          TabOrder = 2
          OnClick = Panel_FrameClick
          object Label_Caption: TLabel
            Left = 70
            Top = 8
            Width = 36
            Height = 13
            Caption = 'Caption'
            OnClick = Panel_FrameClick
          end
        end
        object Panel_FrameSel: TPanel
          Left = 3
          Top = 233
          Width = 174
          Height = 80
          BevelInner = bvLowered
          Color = clWhite
          ParentBackground = False
          TabOrder = 3
          OnClick = Panel_FrameClick
        end
        object Panel_PicSel: TPanel
          Left = 14
          Top = 241
          Width = 153
          Height = 65
          BevelInner = bvLowered
          Color = clWhite
          ParentBackground = False
          TabOrder = 4
          OnClick = Panel_FrameClick
        end
        object Panel_CaptionSel: TPanel
          Left = 3
          Top = 313
          Width = 174
          Height = 26
          BevelInner = bvLowered
          Color = clWhite
          ParentBackground = False
          TabOrder = 5
          OnClick = Panel_FrameClick
          object Label_CaptionSel: TLabel
            Left = 70
            Top = 8
            Width = 36
            Height = 13
            Caption = 'Caption'
            OnClick = Panel_FrameClick
          end
        end
        object GroupBox2: TGroupBox
          Left = 1
          Top = 0
          Width = 272
          Height = 111
          Caption = 'Thumb Layout'
          TabOrder = 6
          object Label2: TLabel
            Left = 65
            Top = 13
            Width = 31
            Height = 13
            Caption = 'Width:'
          end
          object Label1: TLabel
            Left = 156
            Top = 30
            Width = 49
            Height = 13
            Caption = 'Spacing X'
          end
          object Label5: TLabel
            Left = 157
            Top = 13
            Width = 52
            Height = 13
            Caption = 'Frame Size'
          end
          object Label8: TLabel
            Left = 65
            Top = 44
            Width = 34
            Height = 13
            Caption = 'Height:'
          end
          object Label9: TLabel
            Left = 11
            Top = 94
            Width = 51
            Height = 13
            Caption = 'Buffer Size'
          end
          object Label15: TLabel
            Left = 11
            Top = 70
            Width = 194
            Height = 13
            Caption = 'Horizontal. layout Caption Width Percent:'
          end
          object Label10: TLabel
            Left = 118
            Top = 86
            Width = 152
            Height = 26
            AutoSize = False
            Caption = '<-Size in Pixels kept in memory (ideally set this once at start)'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            WordWrap = True
          end
          object Label17: TLabel
            Left = 210
            Top = 30
            Width = 49
            Height = 13
            Caption = 'Spacing Y'
          end
          object spinThumbWidth: TSpinEdit
            Left = 106
            Top = 8
            Width = 45
            Height = 22
            MaxValue = 160
            MinValue = 10
            TabOrder = 0
            Value = 145
            OnChange = spinThumbWidthChange
          end
          object spinSpacingX: TSpinEdit
            Left = 157
            Top = 44
            Width = 45
            Height = 22
            MaxValue = 50
            MinValue = 0
            TabOrder = 1
            Value = 2
            OnChange = spinSpacingXChange
          end
          object rgpThumbLayoutType: TRadioGroup
            Left = 0
            Top = 12
            Width = 59
            Height = 55
            ItemIndex = 1
            Items.Strings = (
              'Horz.'
              'Vert.')
            TabOrder = 2
            OnClick = rgpBrowserOrientationClick
          end
          object spinFrameSize: TSpinEdit
            Left = 215
            Top = 9
            Width = 45
            Height = 22
            MaxValue = 50
            MinValue = 0
            TabOrder = 3
            Value = 1
            OnChange = spinFrameSizeChange
          end
          object spinThumbHeight: TSpinEdit
            Left = 106
            Top = 39
            Width = 45
            Height = 22
            MaxValue = 160
            MinValue = 10
            TabOrder = 4
            Value = 135
            OnChange = spinThumbWidthChange
          end
          object spinThumbBufferSize: TSpinEdit
            Left = 68
            Top = 88
            Width = 45
            Height = 22
            MaxValue = 1000
            MinValue = 10
            TabOrder = 5
            Value = 160
            OnChange = spinThumbWidthChange
          end
          object spinCaptionPercWidth: TSpinEdit
            Left = 211
            Top = 67
            Width = 45
            Height = 22
            MaxValue = 500
            MinValue = 0
            TabOrder = 6
            Value = 120
            OnChange = spinThumbWidthChange
          end
          object spinSpacingY: TSpinEdit
            Left = 211
            Top = 44
            Width = 45
            Height = 22
            MaxValue = 50
            MinValue = 0
            TabOrder = 7
            Value = 2
            OnChange = spinSpacingXChange
          end
        end
        object btnResfolderup: TButton
          Left = 179
          Top = 134
          Width = 95
          Height = 22
          Caption = 'Folder Up Pic'
          TabOrder = 7
          OnClick = btnResfolderupClick
        end
        object btnResInfo: TButton
          Left = 179
          Top = 155
          Width = 95
          Height = 22
          Caption = 'Info Box Pic'
          TabOrder = 8
          OnClick = btnResfolderupClick
        end
        object btnResChecked: TButton
          Left = 179
          Top = 177
          Width = 95
          Height = 22
          Caption = 'Checked Pic'
          TabOrder = 9
          OnClick = btnResfolderupClick
        end
        object btnResunchecked: TButton
          Left = 179
          Top = 198
          Width = 95
          Height = 22
          Caption = 'Unchecked Pic'
          TabOrder = 10
          OnClick = btnResfolderupClick
        end
        object btnResThumbFrame: TButton
          Left = 45
          Top = 155
          Width = 95
          Height = 25
          Caption = 'Frame Pic'
          TabOrder = 11
          OnClick = btnResfolderupClick
        end
        object btnResThumbFrameSel: TButton
          Left = 45
          Top = 278
          Width = 95
          Height = 25
          Caption = 'Frame Pic (Sel.)'
          TabOrder = 12
          OnClick = btnResfolderupClick
        end
        object GroupBox3: TGroupBox
          Left = 182
          Top = 282
          Width = 90
          Height = 57
          Caption = 'Titles Colors'
          TabOrder = 13
          object Shape_Title_Bg: TShape
            Left = 16
            Top = 16
            Width = 17
            Height = 17
            Brush.Color = clBlack
            OnMouseUp = Shape_Title_BgMouseUp
          end
          object Shape_Title_Fg: TShape
            Left = 56
            Top = 16
            Width = 17
            Height = 17
            Brush.Color = clLime
            OnMouseUp = Shape_Title_BgMouseUp
          end
          object Label11: TLabel
            Left = 4
            Top = 18
            Width = 10
            Height = 13
            Caption = 'B:'
          end
          object Label12: TLabel
            Left = 46
            Top = 18
            Width = 9
            Height = 13
            Caption = 'F:'
          end
          object Label13: TLabel
            Left = 4
            Top = 36
            Width = 10
            Height = 13
            Caption = 'B:'
          end
          object Shape_Title_Bg_Sel: TShape
            Left = 16
            Top = 34
            Width = 17
            Height = 17
            Brush.Color = clBlack
            OnMouseUp = Shape_Title_BgMouseUp
          end
          object Label14: TLabel
            Left = 46
            Top = 36
            Width = 9
            Height = 13
            Caption = 'F:'
          end
          object Shape_Title_Fg_Sel: TShape
            Left = 56
            Top = 34
            Width = 17
            Height = 17
            Brush.Color = clRed
            OnMouseUp = Shape_Title_BgMouseUp
          end
        end
        object btnResBrowserBg: TButton
          Left = 179
          Top = 110
          Width = 95
          Height = 25
          Caption = 'Browser Bg Pic'
          TabOrder = 14
          OnClick = btnResfolderupClick
        end
      end
    end
    object PageControl2: TPageControl
      Left = 1
      Top = 42
      Width = 284
      Height = 341
      ActivePage = TabBrowsePc
      Align = alClient
      MultiLine = True
      TabOrder = 1
      TabPosition = tpLeft
      object TabBrowsePc: TTabSheet
        Caption = 'Browse Pc'
        object Panel4: TPanel
          Left = 0
          Top = 289
          Width = 238
          Height = 44
          Align = alBottom
          TabOrder = 0
          object btnBrowse: TButton
            Left = 0
            Top = 6
            Width = 75
            Height = 36
            Caption = 'Browse'
            TabOrder = 0
            OnClick = btnBrowseClick
          end
          object btnBrowseRecursive: TButton
            Left = 76
            Top = 6
            Width = 114
            Height = 36
            Caption = 'Browse Recursively'
            TabOrder = 1
            OnClick = btnBrowseRecursiveClick
          end
          object chkFolderThumbs: TCheckBox
            Left = 191
            Top = -4
            Width = 82
            Height = 36
            Caption = 'Browse Folders'
            Checked = True
            State = cbChecked
            TabOrder = 2
            WordWrap = True
            OnClick = chkFolderThumbsClick
          end
          object chkfolderMonitor: TCheckBox
            Left = 191
            Top = 25
            Width = 89
            Height = 17
            Caption = 'Monitor'
            Checked = True
            State = cbChecked
            TabOrder = 3
            OnClick = chkfolderMonitorClick
          end
        end
        object Panel6: TPanel
          Left = 0
          Top = 0
          Width = 238
          Height = 22
          Align = alTop
          TabOrder = 1
          object DriveComboBox1: TDriveComboBox
            Left = 0
            Top = 0
            Width = 145
            Height = 19
            TabOrder = 0
            OnChange = DriveComboBox1Change
          end
        end
        object DirectoryListBox1: TDirectoryListBox
          Left = 0
          Top = 22
          Width = 238
          Height = 267
          Align = alClient
          TabOrder = 2
          OnChange = JvDirListBox1Change
        end
      end
      object TabMultipleFolders: TTabSheet
        Caption = 'Multiple Folders'
        ImageIndex = 2
        object btnBrowseMultiRecursive: TButton
          Left = 15
          Top = 291
          Width = 241
          Height = 25
          Caption = 'Browse all folders Recursively'
          TabOrder = 0
          OnClick = btnBrowseMultiRecursiveClick
        end
        object ListBox2: TListBox
          Left = 16
          Top = 8
          Width = 241
          Height = 242
          ItemHeight = 13
          TabOrder = 1
        end
        object btnAddAFolder: TButton
          Left = 96
          Top = 264
          Width = 75
          Height = 25
          Caption = 'Add a Folder..'
          TabOrder = 2
          OnClick = btnAddAFolderClick
        end
        object btnBrowseMulti: TButton
          Left = 15
          Top = 316
          Width = 241
          Height = 25
          Caption = 'Browse all folders without recursion'
          TabOrder = 3
          OnClick = btnBrowseMultiClick
        end
      end
      object TabManualThumbs: TTabSheet
        Caption = 'Manual'
        ImageIndex = 1
        object btnAddThumbWithObject: TButton
          Left = 3
          Top = 3
          Width = 142
          Height = 25
          Caption = 'Add Thumb with Object'
          TabOrder = 0
          OnClick = btnAddThumbWithObjectClick
        end
        object btnDuplicateThumb: TButton
          Left = 151
          Top = 3
          Width = 102
          Height = 25
          Caption = 'Duplicate Thumb'
          TabOrder = 1
          OnClick = btnDuplicateThumbClick
        end
        object ListBox1: TListBox
          Left = 0
          Top = 179
          Width = 238
          Height = 154
          Style = lbOwnerDrawVariable
          Align = alBottom
          Anchors = [akLeft, akTop, akRight, akBottom]
          ItemHeight = 13
          TabOrder = 2
          OnClick = ListBox1Click
          OnDrawItem = ListBox1DrawItem
        end
        object btnAssignObjectToThumb: TButton
          Left = 3
          Top = 34
          Width = 250
          Height = 25
          Caption = 'Assign an object to Selected Thumb'
          TabOrder = 3
          OnClick = btnAssignObjectToThumbClick
        end
        object btnRemoveObjectFromThumb: TButton
          Left = 3
          Top = 62
          Width = 250
          Height = 25
          Caption = 'Remove Object From selected Thumb'
          TabOrder = 4
          OnClick = btnRemoveObjectFromThumbClick
        end
        object btnAddManyThumbsWithObject: TButton
          Left = 3
          Top = 93
          Width = 250
          Height = 46
          Caption = '>Add 5000 thumbs from file linked to an object<'#13#10'Very Fast'
          TabOrder = 5
          WordWrap = True
          OnClick = btnAddManyThumbsWithObjectClick
        end
        object btnClearObjects: TButton
          Left = 3
          Top = 145
          Width = 250
          Height = 25
          Caption = 'Clear All Thumbs with Objects'
          TabOrder = 6
          OnClick = btnClearObjectsClick
        end
      end
      object TabInternet: TTabSheet
        Caption = 'Internet'
        ImageIndex = 3
        object btnBrowseInternet: TButton
          Left = 32
          Top = 32
          Width = 193
          Height = 25
          Caption = 'Browse a few images on pixabay'
          Default = True
          TabOrder = 0
          OnClick = btnBrowseInternetClick
        end
        object chkInternetKeepAdding: TCheckBox
          Left = 35
          Top = 9
          Width = 206
          Height = 17
          Caption = 'Use AddFiles instead of StartBrowsing'
          TabOrder = 1
        end
      end
      object TabShellOperations: TTabSheet
        Caption = 'Shell Operations'
        ImageIndex = 4
        object btnFileRotate: TButton
          Left = 43
          Top = 3
          Width = 75
          Height = 25
          Caption = 'Rotate'
          TabOrder = 0
          OnClick = btnFileRotateClick
        end
        object btnSaveSelected: TButton
          Left = 43
          Top = 34
          Width = 130
          Height = 25
          Caption = 'Save Selected (example)'
          TabOrder = 1
          OnClick = btnSaveSelectedClick
        end
        object btnDeleteSelected: TButton
          Left = 43
          Top = 65
          Width = 130
          Height = 25
          Caption = 'Delete Selected Files'
          TabOrder = 2
          OnClick = btnDeleteSelectedClick
        end
        object grpBoxClipboard: TGroupBox
          Left = 19
          Top = 158
          Width = 169
          Height = 161
          Caption = 'Clipboard'
          TabOrder = 3
          object btnPasteToBrowser: TButton
            Left = 23
            Top = 79
            Width = 130
            Height = 25
            Caption = 'Browse files in Clbrd'
            Enabled = False
            TabOrder = 0
            OnClick = btnPasteToBrowserClick
          end
          object btnPasteToFolder: TButton
            Left = 23
            Top = 110
            Width = 130
            Height = 25
            Caption = 'Paste Files to Folder..'
            Enabled = False
            TabOrder = 1
            OnClick = btnPasteToFolderClick
          end
          object btnCopyToClip: TButton
            Left = 23
            Top = 48
            Width = 130
            Height = 25
            Caption = 'Copy Sel. files to Clbrd'
            TabOrder = 2
            OnClick = btnCopyToClipClick
          end
          object btnCutToClip: TButton
            Left = 23
            Top = 17
            Width = 130
            Height = 25
            Caption = 'Cut Sel. files to Clbrd'
            TabOrder = 3
            OnClick = btnCutToClipClick
          end
        end
        object btnMoveSelectedFiles: TButton
          Left = 43
          Top = 96
          Width = 130
          Height = 25
          Caption = 'Move Sel. To Folder..'
          TabOrder = 4
          OnClick = btnMoveSelectedFilesClick
        end
        object btnCopySelectedFiles: TButton
          Left = 43
          Top = 127
          Width = 130
          Height = 25
          Caption = 'Copy Sel. To Folder..'
          TabOrder = 5
          OnClick = btnCopySelectedFilesClick
        end
      end
    end
    object Panel3: TPanel
      Left = 1
      Top = 1
      Width = 284
      Height = 41
      Align = alTop
      TabOrder = 2
      object Label7: TLabel
        Left = 87
        Top = 1
        Width = 196
        Height = 39
        Align = alRight
        AutoSize = False
        Caption = 'Loading Infos:'
        WordWrap = True
      end
      object btnClearThumbs: TButton
        Left = 6
        Top = 8
        Width = 75
        Height = 25
        Caption = 'Clear'
        TabOrder = 0
        OnClick = btnClearThumbsClick
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 632
    Height = 749
    Align = alClient
    DoubleBuffered = False
    ParentDoubleBuffered = False
    TabOrder = 1
    object Splitter1: TSplitter
      Left = 1
      Top = 367
      Width = 630
      Height = 4
      Cursor = crVSplit
      Align = alBottom
      Visible = False
      ExplicitTop = 381
    end
    object TB1: TThumbsBrowser
      Left = 1
      Top = 1
      Width = 630
      Height = 366
      Cursor = crArrow
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alClient
      BorderStyle = bsNone
      Ctl3d = False
      Font.Charset = ANSI_CHARSET
      Font.Color = 5648150
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      ShowDesignTestThumbs = True
      Language = nwsLng_EN
      OwnUserObjects = True
      FolderMonitor_Active = True
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
      MetaData_Options.SyncField_TopTitle = '{EXIF}[57|Title (Windows)]{IPTC}[2|5|Title]{XMP}[dc:Title|Title]'
      MetaData_Options.SyncField_Rating = '{EXIF}[62|Rating (Windows)]{XMP}[xmp:Rating|Rating]'
      MetaData_Options.AutoSync_TopTitle = mdSyncOp_ReadWrite
      MetaData_Options.AutoSync_BottomTitle = mdSyncOp_ReadWrite
      MetaData_Options.AutoSync_Rating = mdSyncOp_ReadWrite
      MetaData_Options.AutoSync_Keywords = mdSyncOp_ReadWrite
      MetaData_Options.UseExifOrientationForThumbs = True
      DragDropOptions.IS_DragSource_TB = True
      DragDropOptions.IS_DropTarget_TB = True
      DragDropOptions.IS_DragSource_Explorer = True
      DragDropOptions.IS_DropTarget_Explorer = True
      DragDropOptions.TransferMode_TB = dd_DetectShiftState
      DragDropOptions.TransferMode_Exp = dd_DetectShiftState
      DragDropOptions.DropBehavior = ddb_Thumbs
      FileScanner_MaxTransfer = 1000
      MultiThread = True
      MultiThread_Pool_Count = 8
      MultiThread_Timeout = 500
      BrowsingOrientation = tbo_vert
      MaxRows = -1
      MaxCols = -1
      Centered = True
      DragScrollInterval = 200
      FileThumbs = True
      FolderThumbs = True
      NavMemory = True
      NavMemoryMaxThumbs = 500
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
      BackgroundColor = clGray
      Background2ndColor = clBlue
      StyleOptions.BrowserStyle = tbStyle_Custom
      StyleOptions.CaptionsOptions.SizePerc_HorzLayout = 150
      StyleOptions.CaptionsOptions.Style = capSt_RowsCentered
      StyleOptions.CaptionsOptions.TextPadding = 6
      StyleOptions.ThemeEnabled = False
      StyleOptions.ThemeColorOptions = [thmcl_BrowserBg, thmcl_FrameBg, thmcl_FrameBgSel, thmcl_FrameBorder, thmcl_FrameBorderSel, thmcl_CaptionBg, thmcl_CaptionBgSel, thmcl_CaptionFont, thmcl_CaptionFontSel]
      StyleOptions.ThemeElements = [thmele_CheckBox, thmele_InfoBox, thmele_RotateButtons]
      MultiSelect = False
      ThumbSize = 130
      ThumbSizeW = 130
      ThumbSizeH = 130
      Buffer_ThumbSize = 160
      StoreType = tbstore_Thumb
      ThumbsMouseOverOptions = [moFrameBg, moFrameBorder, moCaptionBg, moCaptionText]
      ThumbsFrameBgColor = 15132390
      ThumbsFrameBgSelectedColor = clWhite
      ThumbsCaptionFontColor = clBlack
      ThumbsCaptionFontSelectedColor = 4114935
      ThumbsCaptionBackColor = clSilver
      ThumbsCaptionBackSelectedColor = 21156
      ThumbsTopTitleFontColor = 4227327
      ThumbsTopTitleFontSelectedColor = clYellow
      ThumbsTopTitleBackColor = clSilver
      ThumbsTopTitleBackSelectedColor = clSilver
      ThumbsBottomTitleFontColor = 4227327
      ThumbsBottomTitleFontSelectedColor = clYellow
      ThumbsBottomTitleBackColor = clSilver
      ThumbsBottomTitleBackSelectedColor = clSilver
      ThumbsFrameBorderColor = clSilver
      ThumbsFrameBorderSelectedColor = 32767
      ThumbsFrameSize = 2
      ThumbsFrameRoundnessPerc = 8
      ThumbsCaptionRoundnessPerc = 10
      ThumbsTitleRoundnessPerc = 10
      ThumbsBackOpacity = 255
      ThumbsBackOpacitySelected = 255
      ThumbsFrameBgOpacity = 128
      ThumbsFrameBgOpacitySelected = 255
      ThumbsFrameBorderOpacity = 0
      ThumbsFrameBorderOpacitySelected = 255
      ThumbsCaptionOpacity = 128
      ThumbsCaptionOpacitySelected = 255
      ThumbsTitleOpacity = 255
      ThumbsTitleOpacitySelected = 255
      ThumbsTitleDrawFocusRectIfEmpty = True
      ThumbsBackPadding_Left = 0
      ThumbsBackPadding_Right = 0
      ThumbsBackPadding_Bottom = 0
      ThumbsBackPadding_Top = 0
      ThumbsFramePadding_Left = 5
      ThumbsFramePadding_Right = 5
      ThumbsFramePadding_Top = 5
      ThumbsFramePadding_Bottom = 5
      ThumbsSpacing = 6
      ThumbsSpacingX = 6
      ThumbsSpacingY = 6
      ResampleMethod = rfFastLinear
      DisplayMethod = rfTriangle
      Filter = '*.*'
      PopupDefaultExplorer = True
      ShowThumbnailHint = True
      ShowTopTitle = False
      ShowBottomTitle = False
      ShowCaptions = True
      ThumbCaption_Settings = [cap_ShowFileName, cap_ShowDateTime, cap_ShowEXIF_XPAuthor]
      ThumbCaptionIncludeInFrame = False
      ThumbDropShadow.Enabled = False
      ThumbDropShadow.Size = 3
      ThumbLayoutType = ltVertical
      ThumbDefaultChecked = True
      ShowRatingBox = False
      ShowCheckBoxes = True
      ShowRotateButtons = False
      ShowInfoButton = True
      SortType = stNameA
      OnThumbMouseOver = TB1ThumbMouseOver
      OnThumbLoaded = TB1ThumbLoaded
      OnThumbClicked = TB1ThumbClicked
      OnThumbInfoClicked = TB1ThumbInfoClicked
      OnThumbTopTitleClicked = TB1ThumbTopTitleClicked
      OnThumbBottomTitleClicked = TB1ThumbBottomTitleClicked
      OnItemCustomDrawCaption = TB1ItemCustomDrawCaption
      OnItemCustomDrawAfterDraw = TB1ItemCustomDrawAfterDraw
      OnItemCustomDrawTopTitle = TB1ItemCustomDrawTopTitle
      OnItemCustomDrawBottomTitle = TB1ItemCustomDrawBottomTitle
      OnInfoFormClosed = TB1InfoFormClosed
      OnItemSearchCompare = TB1ItemSearchCompare
      OnfinishedLoading = TB1finishedLoading
      OnInitialized = TB1Initialized
      OnAllThumbsLoaded = TB1AllThumbsLoaded
      OnNavigateFolder = TB1NavigateFolder
      ThumbCaption_MissingText = ''
    end
    object Panel_Info: TPanel
      Left = 1
      Top = 371
      Width = 630
      Height = 377
      Align = alBottom
      BevelOuter = bvLowered
      TabOrder = 1
      Visible = False
      object Panel5: TPanel
        Left = 1
        Top = 1
        Width = 628
        Height = 16
        Align = alTop
        BevelOuter = bvLowered
        Caption = 'Info'
        TabOrder = 0
        DesignSize = (
          628
          16)
        object btn_InfoClose: TBitBtn
          Left = 610
          Top = 0
          Width = 16
          Height = 16
          Anchors = [akTop, akRight]
          Caption = 'X'
          TabOrder = 0
          OnClick = btn_InfoCloseClick
        end
      end
    end
  end
  object TBSHProc1: TThumbsBrowserShellProcessor
    AttachedBrowser = TB1
    OnClipBoardChanged = TBSHProc1ClipBoardChanged
    Left = 520
    Top = 248
  end
  object ColorDialog1: TColorDialog
    Left = 496
    Top = 488
  end
  object OpenImageEnDialog1: TOpenImageEnDialog
    Ctl3D = False
    Filter = 
      'File grafici comuni (*.tif;*.gif;*.jpg;*.pcx;*.bmp;*.ico;*.cur;*' +
      '.png;*.dcm;*.wmf;*.emf;*.tga;*.pxm;*.wbmp;*.jp2;*.j2k;*.dcx;*.cr' +
      'w;*.psd;*.iev;*.lyr;*.all;*.wdp;*.avi;*.mpg;*.wmv)|*.tif;*.gif;*' +
      '.jpg;*.pcx;*.bmp;*.ico;*.cur;*.png;*.dcm;*.wmf;*.emf;*.tga;*.pxm' +
      ';*.wbmp;*.jp2;*.j2k;*.dcx;*.crw;*.psd;*.iev;*.lyr;*.all;*.wdp;*.' +
      'avi;*.mpg;*.wmv|Tutti (*.*)|*.*|JPEG Bitmap (*.jpg;*.jpeg;*.jpe;' +
      '*.jif)|*.jpg;*.jpeg;*.jpe;*.jif|TIFF Bitmap (*.tif;*.tiff;*.fax;' +
      '*.g3n;*.g3f;*.xif)|*.tif;*.tiff;*.fax;*.g3n;*.g3f;*.xif|CompuSer' +
      've Bitmap (*.gif)|*.gif|PaintBrush (*.pcx)|*.pcx|Windows Bitmap ' +
      '(*.bmp;*.dib;*.rle)|*.bmp;*.dib;*.rle|Windows Icon (*.ico)|*.ico' +
      '|Windows Cursor (*.cur)|*.cur|Portable Network Graphics (*.png)|' +
      '*.png|DICOM Bitmap (*.dcm;*.dic;*.dicom;*.v2)|*.dcm;*.dic;*.dico' +
      'm;*.v2|Windows Metafile (*.wmf)|*.wmf|Enhanced Windows Metafile ' +
      '(*.emf)|*.emf|Targa Bitmap (*.tga;*.targa;*.vda;*.icb;*.vst;*.pi' +
      'x)|*.tga;*.targa;*.vda;*.icb;*.vst;*.pix|Portable Pixmap, GrayMa' +
      'p, BitMap (*.pxm;*.ppm;*.pgm;*.pbm)|*.pxm;*.ppm;*.pgm;*.pbm|Wire' +
      'less Bitmap (*.wbmp)|*.wbmp|JPEG2000 (*.jp2)|*.jp2|JPEG2000 Code' +
      ' Stream (*.j2k;*.jpc;*.j2c)|*.j2k;*.jpc;*.j2c|Multipage PCX (*.d' +
      'cx)|*.dcx|Camera RAW (*.crw;*.cr2;*.nef;*.raw;*.pef;*.raf;*.x3f;' +
      '*.bay;*.orf;*.srf;*.mrw;*.dcr;*.sr2)|*.crw;*.cr2;*.nef;*.raw;*.p' +
      'ef;*.raf;*.x3f;*.bay;*.orf;*.srf;*.mrw;*.dcr;*.sr2|Photoshop PSD' +
      ' (*.psd)|*.psd|Vectorial objects (*.iev)|*.iev|Layers (*.lyr)|*.' +
      'lyr|Layers and objects (*.all)|*.all|Microsoft HD Photo (*.wdp;*' +
      '.hdp;*.jxr)|*.wdp;*.hdp;*.jxr|Video for Windows (*.avi)|*.avi|MP' +
      'EG (*.mpeg;*.mpg)|*.mpeg;*.mpg|Windows Media Video (*.wmv)|*.wmv'
    Left = 368
    Top = 560
  end
  object TBPrintProc1: TThumbsBrowserPrintProcessor
    AttachedShellProcessor = TBSHProc1
    Left = 432
    Top = 256
  end
end
