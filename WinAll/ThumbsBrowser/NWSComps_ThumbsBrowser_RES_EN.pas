(*
  Part of NWSComps Bundle
  v. 3
  Copyright (C) Francesco Savastano. All Rights Reserved.

  This software comes without any warranty either implied or expressed.
  In no case shall the author be liable for any damage or unwanted behavior
  of any computer hardware and/or software.

  You cannot DISTRIBUTE THIS SOURCE CODE OR ITS COMPILED .DCU IN ANY FORM.

  This unit cannot be included in any commercial, shareware or freeware DELPHI
  libraries or components.

  email: nws@centurybyte.com
  web site: www.nwscomps.com
*)
unit NWSComps_ThumbsBrowser_RES_EN;


interface
    uses NWSComps_ThumbsBrowser_RES_CONST;

    type
    TTBTranslateMemory_EN = class(TTBTranslateMemory)
      public
      Constructor Create; reintroduce;
    end;


implementation


{ TTBTranslateMemory_EN }

constructor TTBTranslateMemory_EN.Create;
begin
  FRS_TBSORT_NameA := 'Name ->';
  FRS_TBSORT_NameD :=  'Name <-';
  FRS_TBSORT_DateA :=  'Date ->';
  FRS_TBSORT_DateD :=  'Date <-';
  FRS_TBSORT_ExifDateA :=  'Exif Date ->';
  FRS_TBSORT_ExifDateD :=  'Exif Date <-';
  FRS_TBSORT_SizeA := 'Size ->';
  FRS_TBSORT_SizeD := 'Size <-';
  FRS_TBSORT_FolderA := 'Folder ->';
  FRS_TBSORT_FolderD := 'Folder <-';
  FRS_TBSORT_FileTypeA := 'File Type ->';
  FRS_TBSORT_FileTypeD := 'File Type <-';
  FRS_TBSORT_NameNaturalA := 'Name ->';
  FRS_TBSORT_NameNaturalD := 'Name <-';
  FRS_TBSORT_FolderNaturalA := 'Folder ->';
  FRS_TBSORT_FolderNaturalD := 'Folder <-';

  FRS_METAHLP_Index := 'Nr.';
  FRS_METAHLP_Field := 'Field';
  FRS_METAHLP_ErrorParsingWrongGridFormat := 'Parsing Error: Wrong Grid Format';

  FRS_METAPN_DISPLAYMODE_NONEMPTY := 'Display Non-Empty';
  FRS_METAPN_DISPLAYMODE_All := 'Display All';
  FRS_METAPN_DISPLAYMODE_GROUPED := 'Display Grouped by Core';
  FRS_METAPN_PENDINGCHANGES_SINGLE :=
    'Infos for the current file were modified. Save the changes?';
  FRS_METAPN_PENDINGCHANGES_MULTI :=
    'Infos for multiple files were modified. Save the changes?';
  FRS_METAPN_TABCOMMON := 'Common';

  FRS_SH_OP_DELETINGFILES := 'Deleting Files..';
  FRS_SH_OP_RECYCLINGFILES := 'Recycling Files..';
  FRS_SH_OP_MOVINGFILES := 'Moving Files..';
  FRS_SH_OP_COPYINGFILES := 'Copying Files..';
  FRS_SH_OP_SAVINGFILES := 'Saving Files..';
  FRS_SH_OP_CORRECTINGORIENTATION := 'Correcting Files Orientation (EXIF)..';
  FRS_SH_OP_ROTATINGFILES := 'Rotating Files..';
  FRS_SH_OP_WARNING_RECYCLE_NOTALLOWED_WPD :=
    'Warning! Recycling not allowed for %s' +
    ' files because they are on Portable Devices.' +
    ' Instead do you want to delete them? (This cannot be undone!)';
  FRS_SH_OP_WARNING_RECYCLE_NOTALLOWED_WIA :=
    'Warning! Recycling not allowed for %s' +
    ' files because they are retrieved on a WIA connection.' +
    ' Instead do you want to delete them? (This cannot be undone!)';
  FRS_SH_OP_WARNING_INTERNETFILE_CANNOTBEMOVED :=
    'There are internet files, for which only a copy is possible.' +
    'Do you want to transfer them anyway?';

  FRS_INFOFORM_FDate := 'Date: ';
  FRS_INFOFORM_FSize := 'Image Size: ';
  FRS_INFOFORM_HINT_ADDEXIFINFO := 'Add Exif Info';
  FRS_INFOFORM_HINT_ADDIPTCINFO := 'Add IPTC Info';
  FRS_INFOFORM_ERROR_CANNOTWRITEMETA := 'Cannot write metadata to this file';
  FRS_INFOFORM_BTNSAVE := 'Save';
  FRS_INFOFORM_BTNSAVERENAME := 'Save/Rename';
  FRS_INFOFORM_BTNRENAME := 'Rename';
  FRS_INFOFORM_BTNADDEXIF := 'Add Exif';
  FRS_INFOFORM_BTNADDIPTC := 'Add Iptc';

  FRS_CAP_SHOWFILENAME := 'Name';
  FRS_CAP_SHOWFILEDATE := 'Date';
  FRS_CAP_SHOWFILESIZE := 'Size';
  FRS_CAP_SHOWFILEDIMS := 'Dimensions';
  FRS_CAP_SHOWEXIFDATETIME := 'Exif Date-Time';
  FRS_CAP_SHOWEXIFAUTHOR := 'Exif Author';
  FRS_CAP_SHOWEXIFTITLE := 'Exif Title';
  FRS_CAP_SHOWEXIFSUBJECT := 'Exif Subject';
  FRS_CAP_SHOWEXIFCOMMENT := 'Exif Comment';
  FRS_CAP_SHOWEXIFKEYWORDS := 'Exif Keywords';
  FRS_CAP_SHOWEXIFRATING := 'Exif Rating';
  FRS_CAP_SHOWKEYWORDS := 'Keywords';
  FRS_CAP_SHOWRATING := 'Rating';
  FRS_CAP_SHOWFILENAMEWITHOUT := 'Name';
  FRS_CAP_SHOWFILEPATH := 'Path';
  FRS_CAP_SHOWFILEDIMSSIZE := 'Dimensions and Size';
  FRS_CAP_SHOWFILECREATEDATE := 'Create Date';
  FRS_CAP_SHOWFILECREATEDATETIME := 'Create Date-Time';
  FRS_CAP_SHOWFILEEDITDATE := 'Edit Date';
  FRS_CAP_SHOWFILEEDITDATETIME := 'Edit Date-Time';
  FRS_CAP_SHOWFILETYPE := 'File Type';
  FRS_CAP_SHOWTOPTITLE := 'Top Title';
  FRS_CAP_SHOWBOTTOMTITLE := 'Bottom Title';
  FRS_CAP_SHOWGENERAL := 'Info';
  FRS_CAP_SHOWOTHER1 := 'Other';
  FRS_CAP_SHOWOTHER2 := 'Other';
  FRS_CAP_SHOWOTHER3 := 'Other';
  FRS_CAP_SHOWOTHER4 := 'Other';


  FRS_IPTCTAG_PS_Title := 'Title'; // Object name
  FRS_IPTCTAG_PS_Caption := 'Caption'; // Caption/Abstract
  FRS_IPTCTAG_PS_Keywords := 'Keywords';
  FRS_IPTCTAG_PS_Instructions := 'Special Instructions';

  FRS_IPTCTAG_PS_Date_Created := 'Date Created (YYYYMMDD)';
  FRS_IPTCTAG_PS_Time_Created := 'Time Created (HHMMSS±HHMM)';
  FRS_IPTCTAG_PS_ByLine1 := 'By-line 1';
  FRS_IPTCTAG_PS_ByLine2 := 'By-line 2';
  FRS_IPTCTAG_PS_City := 'City';
  FRS_IPTCTAG_PS_State := 'State/Province';
  FRS_IPTCTAG_PS_Country_Code := 'Country/ Location Code';
  FRS_IPTCTAG_PS_Country_Name := 'Country/ Location Name';
  FRS_IPTCTAG_PS_TransmissionRef := 'Original Transmission Reference';
  FRS_IPTCTAG_PS_Credit := 'Credit';
  FRS_IPTCTAG_PS_Editor := 'Editor';
  FRS_IPTCTAG_PS_EditStatus := 'Edit status';
  FRS_IPTCTAG_PS_Urgency := 'Urgency';
  FRS_IPTCTAG_PS_Category := 'Category';
  FRS_IPTCTAG_PS_SupplCategory := 'Supplemental Category';
  FRS_IPTCTAG_PS_FixtureID := 'Fixture Identifier';
  FRS_IPTCTAG_PS_ReleaseDate := 'Release Date (YYYYMMDD)';
  FRS_IPTCTAG_PS_ReleaseTime := 'Release Time (HHMMSS±HHMM)';
  FRS_IPTCTAG_PS_ReferenceService := 'Reference Service';
  FRS_IPTCTAG_PS_ReferenceDate := 'Reference Date (YYYYMMDD)';
  FRS_IPTCTAG_PS_ReferenceNumber := 'Reference Number';
  FRS_IPTCTAG_PS_OrigProgram := 'Originating Program';
  FRS_IPTCTAG_PS_ProgVersion := 'Program Version';
  FRS_IPTCTAG_PS_ObjectCycle := 'Object Cycle (a:=AM, b:=PM, c:=both)';
  FRS_IPTCTAG_PS_ImageType := 'Image Type';
  FRS_IPTCTAG_PS_CopyrightNotice := 'Copyright Notice';

  FRS_XMP_Aux_ApproximateFocusDistance := 'Focus Distance';
  FRS_XMP_Aux_Firmware := 'Firmware';
  FRS_XMP_Aux_FlashCompensation := 'Flash Compensation';
  FRS_XMP_Aux_ImageNumber := 'Image Number';
  FRS_XMP_Aux_Lens := 'Lens';
  FRS_XMP_Aux_LensID := 'Lens ID';
  FRS_XMP_Aux_LensInfo := 'Lens Info';
  FRS_XMP_Aux_LensSerialNumber := 'Lens Serial Number';
  FRS_XMP_Aux_OwnerName := 'Owner Name';
  FRS_XMP_Aux_SerialNumber := 'Serial Number';
  FRS_XMP_CC_AttributionName := 'Attribution Name';
  FRS_XMP_CC_AttributionURL := 'Attribution URL';
  FRS_XMP_CC_DeprecatedOn := 'Deprecated On';
  FRS_XMP_CC_Jurisdiction := 'Jurisdiction';
  FRS_XMP_CC_LegalCode := 'Legal Code';
  FRS_XMP_CC_License := 'License';
  FRS_XMP_CC_MorePermissions := 'More Permissions';
  FRS_XMP_CC_Permits := 'Permits';
  FRS_XMP_CC_Prohibits := 'Prohibits';
  FRS_XMP_CC_Requires := 'Requires';
  FRS_XMP_CC_UseGuidelines := 'Use Guidelines';

  FRS_XMP_DC_Contributor := 'Contributor';
  FRS_XMP_DC_Coverage := 'Coverage';
  FRS_XMP_DC_Creator := 'Creator';
  FRS_XMP_DC_Date := 'Date';
  FRS_XMP_DC_Description := 'Description';
  FRS_XMP_DC_Format := 'Format';
  FRS_XMP_DC_Identifier := 'Identifier';
  FRS_XMP_DC_Language := 'Language';
  FRS_XMP_DC_Publisher := 'Publisher';
  FRS_XMP_DC_Relation := 'Relation';
  FRS_XMP_DC_Rights := 'Rights';
  FRS_XMP_DC_Source := 'Source';
  FRS_XMP_DC_Subject := 'Subject';
  FRS_XMP_DC_Title := 'Title';
  FRS_XMP_DC_Type := 'Type';

  FRS_XMP_Photoshop_AuthorsPosition := 'Authors Position';
  FRS_XMP_Photoshop_CaptionWriter := 'Caption Writer';
  FRS_XMP_Photoshop_Category := 'Category';
  FRS_XMP_Photoshop_City := 'City';
  FRS_XMP_Photoshop_ColorMode := 'Color Mode';
  FRS_XMP_Photoshop_Country := 'Country';
  FRS_XMP_Photoshop_Credit := 'Credit';
  FRS_XMP_Photoshop_DateCreated := 'Date Created';
  FRS_XMP_Photoshop_DocumentAncestorID := 'Document Ancestor ID';
  FRS_XMP_Photoshop_Headline := 'Headline';
  FRS_XMP_Photoshop_History := 'History';
  FRS_XMP_Photoshop_ICCProfileName := 'ICC Profile Name';
  FRS_XMP_Photoshop_Instructions := 'Instructions';
  FRS_XMP_Photoshop_Source := 'Source';
  FRS_XMP_Photoshop_State := 'State';
  FRS_XMP_Photoshop_SupplementalCategories := 'Supplemental Categories';
  FRS_XMP_Photoshop_TextLayerName := 'Text-Layer Name';
  FRS_XMP_Photoshop_TextLayerText := 'Text-Layer Text';
  FRS_XMP_Photoshop_TransmissionReference := 'Transmission Reference';
  FRS_XMP_Photoshop_Urgency := 'Urgency';

  FRS_XMP_Advisory := 'Advisory';
  FRS_XMP_Author := 'Author';
  FRS_XMP_BaseURL := 'BaseURL';
  FRS_XMP_CreateDate := 'Create Date';
  FRS_XMP_CreatorTool := 'Creator Tool';
  FRS_XMP_Description := 'Description';
  FRS_XMP_Format := 'Format';
  FRS_XMP_Identifier := 'Identifier';
  FRS_XMP_Keywords := 'Keywords';
  FRS_XMP_Label := 'Label';
  FRS_XMP_MetadataDate := 'Metadata Date';
  FRS_XMP_ModifyDate := 'Modify Date';
  FRS_XMP_Nickname := 'Nickname';
  FRS_XMP_Rating := 'Rating';
  FRS_XMP_Title := 'Title';

  FRS_EXIF_UserComment := 'User Comment';
  FRS_EXIF_ImageDescription := 'Image Description';
  FRS_EXIF_CameraMake := 'Camera Make';
  FRS_EXIF_CameraModel := 'Camera Model';
  FRS_EXIF_XResolution := 'X Resolution';
  FRS_EXIF_YResolution := 'Y Resolution';
  FRS_EXIF_DateTime := 'Date-Time';
  FRS_EXIF_DateTimeOriginal := 'Date-Time Original';
  FRS_EXIF_DateTimeDigitized := 'Date-Time Digitized';
  FRS_EXIF_Copyright := 'Copyright';
  FRS_EXIF_Orientation := 'Orientation';
  FRS_EXIF_ExposureTime := 'Exposure Time';
  FRS_EXIF_FNumber := 'FNumber';
  FRS_EXIF_ExposureProgram := 'Exposure Program';
  FRS_EXIF_ISOSpeedRatings := 'ISO Speed Ratings';
  FRS_EXIF_ShutterSpeedValue := 'Shutter Speed Value';
  FRS_EXIF_ApertureValue := 'Aperture';
  FRS_EXIF_BrightnessValue := 'Brightness';
  FRS_EXIF_ExposureBiasValue := 'ExposureBias';
  FRS_EXIF_MaxApertureValue := 'Max Aperture';
  FRS_EXIF_SubjectDistance := 'Subject Distance';
  FRS_EXIF_MeteringMode := 'Metering Mode';
  FRS_EXIF_LightSource := 'Light Source';
  FRS_EXIF_Flash := 'Flash';
  FRS_EXIF_FocalLength := 'Focal Length';
  FRS_EXIF_FlashPixVersion := 'FlashPix V.';
  FRS_EXIF_ColorSpace := 'Color Space';
  FRS_EXIF_ExifImageWidth := 'Image Width';
  FRS_EXIF_ExifImageHeight := 'Image Height';
  FRS_EXIF_RelatedSoundFile := 'Related Sound File';
  FRS_EXIF_FocalPlaneXResolution := 'Focal Plane XRes';
  FRS_EXIF_FocalPlaneYResolution := 'Focal Plane YRes';
  FRS_EXIF_ExposureIndex := 'Exposure Index';
  FRS_EXIF_SensingMethod := 'Sensing Method';
  FRS_EXIF_FileSource := 'File Source';
  FRS_EXIF_SceneType := 'Scene Type';
  FRS_EXIF_YCbCrPositioning := 'YCbCr Positioning';
  FRS_EXIF_ExposureMode := 'Exposure Mode';
  FRS_EXIF_WhiteBalance := 'White Balance';
  FRS_EXIF_DigitalZoomRatio := 'Digital-Zoom Ratio';
  FRS_EXIF_FocalLengthIn35mmFilm := 'Focal Length 35mm eq.';
  FRS_EXIF_SceneCaptureType := 'Scene Capture Type';
  FRS_EXIF_GainControl := 'Gain Control';
  FRS_EXIF_Contrast := 'Contrast';
  FRS_EXIF_Saturation := 'Saturation';
  FRS_EXIF_Sharpness := 'Sharpness';
  FRS_EXIF_SubjectDistanceRange := 'Subject Distance Range';
  FRS_EXIF_GPSLatitude := 'GPS Latitude';
  FRS_EXIF_GPSLongitude := 'GPS Longitude';
  FRS_EXIF_GPSAltitude := 'GPS Altitude';
  FRS_EXIF_GPSImageDirection := 'GPS Image Direction';
  FRS_EXIF_GPSTrack := 'GPS Track';
  FRS_EXIF_GPSSpeed := 'GPS Speed';
  FRS_EXIF_GPSDateAndTime := 'GPS Date And Time';
  FRS_EXIF_GPSSatellites := 'GPS Satellites';
  FRS_EXIF_GPSVersionID := 'GPS VersionID';
  FRS_EXIF_Artist := 'Artist';
  FRS_EXIF_XPTitle := 'Title (Windows)';
  FRS_EXIF_XPComment := 'Comment (Windows)';
  FRS_EXIF_XPAuthor := 'Author (Windows)';
  FRS_EXIF_XPKeywords := 'Keywords (Windows)';
  FRS_EXIF_XPSubject := 'Subject (Windows)';
  FRS_EXIF_XPRating := 'Rating (Windows)';
  FRS_EXIF_InteropVersion := 'Interop Version';
  FRS_EXIF_CameraOwnerName := 'Camera Owner Name';
  FRS_EXIF_BodySerialNumber := 'Body Serial Number';
  FRS_EXIF_LensMake := 'Lens Make';
  FRS_EXIF_LensModel := 'Lens Model';
  FRS_EXIF_LensSerialNumber := 'Lens Serial Number';
  FRS_EXIF_Gamma := 'Gamma';
  FRS_EXIF_SubjectArea := 'Subject Area';
  FRS_EXIF_SubjectLocation := 'Subject Location';
end;



end.
