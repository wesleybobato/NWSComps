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
unit NWSComps_ThumbsBrowser_RES;
{$R-}
{$Q-}
{$I ..\_inc\NWSComps_ThumbsBrowser.inc}
{$I ..\_inc\NWSComps_Shared.inc}

interface
  uses classes, sysutils, NWSComps_Types, NWSComps_ThumbsBrowser_RES_CONST;

  Type

  

  TTBResStrManager = class
    private

    tm: TTBTranslateMemory;
    fLanguage: TNWSCompsLanguage;
    function GetStr(id: integer): String;

      procedure HandleGlobalNotification(sender: TObject; notType: TNWSCompsNotificationType);
    public

      procedure SetLanguage(lng: TNWSCompsLanguage);

      property Language: TNWSCompsLanguage read fLanguage write SetLanguage;
      property RSStr[id:integer]: String read GetStr; default;

      Constructor Create(const theLanguage: TNWSCompsLanguage; bHandleGlobalLanguage: boolean);
      Destructor Destroy; override;
  end;


  Function TBGetResStr(theLanguage:TNWSCompsLanguage; id:integer): string;

  var
  TBResStr: TTBResStrManager;




implementation
   uses  NWSComps_ThumbsBrowser_RES_EN
         {$IFDEF NWSCOMPS_LNG_IT},NWSComps_ThumbsBrowser_RES_IT{$ENDIF}
         {$IFDEF NWSCOMPS_LNG_ES},NWSComps_ThumbsBrowser_RES_ES{$ENDIF}
         {$IFDEF NWSCOMPS_LNG_DE},NWSComps_ThumbsBrowser_RES_DE{$ENDIF}
         ;

var
  fTBResStrManList: TList;
  //tempTBResStr: TTBResStrManager;

function FindManinList(theLanguage: TNWSCompsLanguage): integer;
var
  I: Integer;
begin
  result := -1;
  for I := 0 to fTBResStrManList.Count-1 do
    if TTBResStrManager(fTBResStrManList[i]).Language = theLanguage then
begin
      result := i;
      break;
    end;
end;

function AddManToList(theTBResManager: TTBResStrManager): integer;
begin
  result := FindManinList(theTBResManager.Language);
  if  result = -1 then
     result := fTBResStrManList.add(theTBResManager);
end;

procedure ClearManagers;
var
  I: Integer;
  begin

  for I := 0 to fTBResStrManList.Count-1 do
    TTBResStrManager(fTBResStrManList[i]).free;

  fTBResStrManList.clear;
  end;

Function TBGetResStr(theLanguage:TNWSCompsLanguage; id:integer): string;
var
foundidx: integer;
begin
  foundidx := FindManinList(theLanguage);
  if (foundidx = -1) then
    foundidx :=  AddManToList(TTBResStrManager.Create(theLanguage, false));

  result := TTBResStrManager(fTBResStrManList[foundidx]).RSStr[id];
end;

{ TTBResStrManager }

constructor TTBResStrManager.Create(const theLanguage: TNWSCompsLanguage; bHandleGlobalLanguage: boolean);
begin
  SetLanguage(theLanguage);
  if bHandleGlobalLanguage then
    NWSCOMPS.Subscribe(HandleGlobalNotification);
end;

destructor TTBResStrManager.Destroy;
begin
  NWSCOMPS.UnSubscribe(HandleGlobalNotification);

  if assigned(tm) then
    freeandnil(tm);
  inherited;
  end;

function TTBResStrManager.GetStr(id: integer): String;
begin
  with tm do
  begin
    case id of

    IDRS_TBSORT_NameA: result := FRS_TBSORT_NameA;
    IDRS_TBSORT_NameD: result := FRS_TBSORT_NameD;
    IDRS_TBSORT_DateA: result := FRS_TBSORT_DateA;
    IDRS_TBSORT_DateD: result := FRS_TBSORT_DateD;
    IDRS_TBSORT_ExifDateA: result := FRS_TBSORT_ExifDateA;
    IDRS_TBSORT_ExifDateD: result := FRS_TBSORT_ExifDateD;
    IDRS_TBSORT_SizeA: result := FRS_TBSORT_SizeA;
    IDRS_TBSORT_SizeD: result := FRS_TBSORT_SizeD;
    IDRS_TBSORT_FolderA: result := FRS_TBSORT_FolderA;
    IDRS_TBSORT_FolderD: result := FRS_TBSORT_FolderD;
    IDRS_TBSORT_FileTypeA: result := FRS_TBSORT_FileTypeA;
    IDRS_TBSORT_FileTypeD: result := FRS_TBSORT_FileTypeD;
    IDRS_TBSORT_NameNaturalA: result := FRS_TBSORT_NameNaturalA;
    IDRS_TBSORT_NameNaturalD: result := FRS_TBSORT_NameNaturalD;
    IDRS_TBSORT_FolderNaturalA: result := FRS_TBSORT_FolderNaturalA;
    IDRS_TBSORT_FolderNaturalD: result := FRS_TBSORT_FolderNaturalD;

    IDRS_METAHLP_Index: result := FRS_METAHLP_Index;
    IDRS_METAHLP_Field : result := FRS_METAHLP_Field;
    IDRS_METAHLP_ErrorParsingWrongGridFormat : result := FRS_METAHLP_ErrorParsingWrongGridFormat;

    IDRS_METAPN_DISPLAYMODE_NONEMPTY : result := FRS_METAPN_DISPLAYMODE_NONEMPTY;
    IDRS_METAPN_DISPLAYMODE_All : result := FRS_METAPN_DISPLAYMODE_All;
    IDRS_METAPN_DISPLAYMODE_GROUPED : result := FRS_METAPN_DISPLAYMODE_GROUPED;
    IDRS_METAPN_PENDINGCHANGES_SINGLE : result := FRS_METAPN_PENDINGCHANGES_SINGLE;
    IDRS_METAPN_PENDINGCHANGES_MULTI : result := FRS_METAPN_PENDINGCHANGES_MULTI;
    IDRS_METAPN_TABCOMMON: result := FRS_METAPN_TABCOMMON;

    IDRS_SH_OP_DELETINGFILES : result := FRS_SH_OP_DELETINGFILES;
    IDRS_SH_OP_RECYCLINGFILES : result := FRS_SH_OP_RECYCLINGFILES;
    IDRS_SH_OP_MOVINGFILES : result := FRS_SH_OP_MOVINGFILES;
    IDRS_SH_OP_COPYINGFILES : result := FRS_SH_OP_COPYINGFILES;
    IDRS_SH_OP_SAVINGFILES : result := FRS_SH_OP_SAVINGFILES;
    IDRS_SH_OP_CORRECTINGORIENTATION : result := FRS_SH_OP_CORRECTINGORIENTATION;
    IDRS_SH_OP_ROTATINGFILES : result := FRS_SH_OP_ROTATINGFILES;
    IDRS_SH_OP_WARNING_RECYCLE_NOTALLOWED_WPD : result := FRS_SH_OP_WARNING_RECYCLE_NOTALLOWED_WPD;
    IDRS_SH_OP_WARNING_RECYCLE_NOTALLOWED_WIA : result := FRS_SH_OP_WARNING_RECYCLE_NOTALLOWED_WIA;
    IDRS_SH_OP_WARNING_INTERNETFILE_CANNOTBEMOVED : result := FRS_SH_OP_WARNING_INTERNETFILE_CANNOTBEMOVED;


    IDRS_INFOFORM_FDate : result := FRS_INFOFORM_FDate;
    IDRS_INFOFORM_FSize : result := FRS_INFOFORM_FSize ;
    IDRS_INFOFORM_HINT_ADDEXIFINFO : result := FRS_INFOFORM_HINT_ADDEXIFINFO ;
    IDRS_INFOFORM_HINT_ADDIPTCINFO : result := FRS_INFOFORM_HINT_ADDIPTCINFO;
    IDRS_INFOFORM_ERROR_CANNOTWRITEMETA : result := FRS_INFOFORM_ERROR_CANNOTWRITEMETA;
    IDRS_INFOFORM_BTNSAVE : result := FRS_INFOFORM_BTNSAVE;
    IDRS_INFOFORM_BTNSAVERENAME : result := FRS_INFOFORM_BTNSAVERENAME;
    IDRS_INFOFORM_BTNRENAME : result := FRS_INFOFORM_BTNRENAME;
    IDRS_INFOFORM_BTNADDEXIF : result := FRS_INFOFORM_BTNADDEXIF;
    IDRS_INFOFORM_BTNADDIPTC : result := FRS_INFOFORM_BTNADDIPTC;


    IDRS_CAP_SHOWFILENAME  : result := FRS_CAP_SHOWFILENAME;
    IDRS_CAP_SHOWFILEDATE : result := FRS_CAP_SHOWFILEDATE;
    IDRS_CAP_SHOWFILESIZE : result := FRS_CAP_SHOWFILESIZE;
    IDRS_CAP_SHOWFILEDIMS : result := FRS_CAP_SHOWFILEDIMS;
    IDRS_CAP_SHOWEXIFDATETIME : result := FRS_CAP_SHOWEXIFDATETIME;
    IDRS_CAP_SHOWEXIFAUTHOR : result := FRS_CAP_SHOWEXIFAUTHOR;
    IDRS_CAP_SHOWEXIFTITLE : result := FRS_CAP_SHOWEXIFTITLE;
    IDRS_CAP_SHOWEXIFSUBJECT : result := FRS_CAP_SHOWEXIFSUBJECT;
    IDRS_CAP_SHOWEXIFCOMMENT : result := FRS_CAP_SHOWEXIFCOMMENT;
    IDRS_CAP_SHOWEXIFKEYWORDS : result := FRS_CAP_SHOWEXIFKEYWORDS;
    IDRS_CAP_SHOWEXIFRATING : result := FRS_CAP_SHOWRATING;
    IDRS_CAP_SHOWKEYWORDS : result := FRS_CAP_SHOWKEYWORDS;
    IDRS_CAP_SHOWRATING : result := FRS_CAP_SHOWEXIFRATING;
    IDRS_CAP_SHOWFILENAMEWITHOUT : result := FRS_CAP_SHOWFILENAMEWITHOUT;
    IDRS_CAP_SHOWFILEPATH : result := FRS_CAP_SHOWFILEPATH;
    IDRS_CAP_SHOWFILEDIMSSIZE : result := FRS_CAP_SHOWFILEDIMSSIZE;
    IDRS_CAP_SHOWFILECREATEDATE : result := FRS_CAP_SHOWFILECREATEDATE;
    IDRS_CAP_SHOWFILECREATEDATETIME : result := FRS_CAP_SHOWFILEEDITDATETIME;
    IDRS_CAP_SHOWFILEEDITDATE : result := FRS_CAP_SHOWFILEEDITDATE;
    IDRS_CAP_SHOWFILEEDITDATETIME : result := FRS_CAP_SHOWFILEEDITDATETIME;
    IDRS_CAP_SHOWFILETYPE : result := FRS_CAP_SHOWFILETYPE;
    IDRS_CAP_SHOWTOPTITLE : result := FRS_CAP_SHOWTOPTITLE;
    IDRS_CAP_SHOWBOTTOMTITLE : result := FRS_CAP_SHOWBOTTOMTITLE;
    IDRS_CAP_SHOWGENERAL : result := FRS_CAP_SHOWGENERAL;
    IDRS_CAP_SHOWOTHER1 : result := FRS_CAP_SHOWOTHER1;
    IDRS_CAP_SHOWOTHER2 : result := FRS_CAP_SHOWOTHER2;
    IDRS_CAP_SHOWOTHER3 : result := FRS_CAP_SHOWOTHER3;
    IDRS_CAP_SHOWOTHER4 : result := FRS_CAP_SHOWOTHER4;

    IDRS_IPTCTAG_PS_Title : result := FRS_IPTCTAG_PS_Title;
    IDRS_IPTCTAG_PS_Caption : result := FRS_IPTCTAG_PS_Caption;
    IDRS_IPTCTAG_PS_Keywords : result := FRS_IPTCTAG_PS_Keywords;
    IDRS_IPTCTAG_PS_Instructions : result := FRS_IPTCTAG_PS_Instructions;
    IDRS_IPTCTAG_PS_Date_Created : result := FRS_IPTCTAG_PS_Date_Created;
    IDRS_IPTCTAG_PS_Time_Created : result := FRS_IPTCTAG_PS_Time_Created;
    IDRS_IPTCTAG_PS_ByLine1 : result := FRS_IPTCTAG_PS_ByLine1;
    IDRS_IPTCTAG_PS_ByLine2 : result := FRS_IPTCTAG_PS_ByLine2;
    IDRS_IPTCTAG_PS_City : result := FRS_IPTCTAG_PS_City;
    IDRS_IPTCTAG_PS_State : result := FRS_IPTCTAG_PS_State;
    IDRS_IPTCTAG_PS_Country_Code : result := FRS_IPTCTAG_PS_Country_Code;
    IDRS_IPTCTAG_PS_Country_Name : result := FRS_IPTCTAG_PS_Country_Name;
    IDRS_IPTCTAG_PS_TransmissionRef : result := FRS_IPTCTAG_PS_TransmissionRef;
    IDRS_IPTCTAG_PS_Credit : result := FRS_IPTCTAG_PS_Credit;
    IDRS_IPTCTAG_PS_Editor : result := FRS_IPTCTAG_PS_Editor;
    IDRS_IPTCTAG_PS_EditStatus : result := FRS_IPTCTAG_PS_EditStatus;
    IDRS_IPTCTAG_PS_Urgency : result := FRS_IPTCTAG_PS_Urgency;
    IDRS_IPTCTAG_PS_Category : result := FRS_IPTCTAG_PS_Category;
    IDRS_IPTCTAG_PS_SupplCategory : result := FRS_IPTCTAG_PS_SupplCategory;
    IDRS_IPTCTAG_PS_FixtureID : result := FRS_IPTCTAG_PS_FixtureID;
    IDRS_IPTCTAG_PS_ReleaseDate : result := FRS_IPTCTAG_PS_ReleaseDate;
    IDRS_IPTCTAG_PS_ReleaseTime : result := FRS_IPTCTAG_PS_ReleaseTime;
    IDRS_IPTCTAG_PS_ReferenceService : result := FRS_IPTCTAG_PS_ReferenceService;
    IDRS_IPTCTAG_PS_ReferenceDate : result := FRS_IPTCTAG_PS_ReferenceDate;
    IDRS_IPTCTAG_PS_ReferenceNumber : result := FRS_IPTCTAG_PS_ReferenceNumber;
    IDRS_IPTCTAG_PS_OrigProgram : result := FRS_IPTCTAG_PS_OrigProgram;
    IDRS_IPTCTAG_PS_ProgVersion : result := FRS_IPTCTAG_PS_ProgVersion;
    IDRS_IPTCTAG_PS_ObjectCycle : result := FRS_IPTCTAG_PS_ObjectCycle;
    IDRS_IPTCTAG_PS_ImageType : result := FRS_IPTCTAG_PS_ImageType;
    IDRS_IPTCTAG_PS_CopyrightNotice: result := FRS_IPTCTAG_PS_CopyrightNotice;

    IDRS_XMP_Aux_ApproximateFocusDistance : result := FRS_XMP_Aux_ApproximateFocusDistance;
    IDRS_XMP_Aux_Firmware : result := FRS_XMP_Aux_Firmware;
    IDRS_XMP_Aux_FlashCompensation : result := FRS_XMP_Aux_FlashCompensation;
    IDRS_XMP_Aux_ImageNumber : result := FRS_XMP_Aux_ImageNumber;
    IDRS_XMP_Aux_Lens : result := FRS_XMP_Aux_Lens;
    IDRS_XMP_Aux_LensID : result := FRS_XMP_Aux_LensID;
    IDRS_XMP_Aux_LensInfo : result := FRS_XMP_Aux_LensInfo;
    IDRS_XMP_Aux_LensSerialNumber : result := FRS_XMP_Aux_LensSerialNumber;
    IDRS_XMP_Aux_OwnerName : result := FRS_XMP_Aux_OwnerName;
    IDRS_XMP_Aux_SerialNumber : result := FRS_XMP_Aux_SerialNumber;
    IDRS_XMP_CC_AttributionName : result := FRS_XMP_CC_AttributionName;
    IDRS_XMP_CC_AttributionURL : result := FRS_XMP_CC_AttributionURL;
    IDRS_XMP_CC_DeprecatedOn : result := FRS_XMP_CC_DeprecatedOn;
    IDRS_XMP_CC_Jurisdiction : result := FRS_XMP_CC_Jurisdiction;
    IDRS_XMP_CC_LegalCode : result := FRS_XMP_CC_LegalCode;
    IDRS_XMP_CC_License : result := FRS_XMP_CC_License;
    IDRS_XMP_CC_MorePermissions : result := FRS_XMP_CC_MorePermissions;
    IDRS_XMP_CC_Permits : result := FRS_XMP_CC_Permits;
    IDRS_XMP_CC_Prohibits : result := FRS_XMP_CC_Prohibits;
    IDRS_XMP_CC_Requires : result := FRS_XMP_CC_Requires;
    IDRS_XMP_CC_UseGuidelines : result := FRS_XMP_CC_UseGuidelines;
    IDRS_XMP_DC_Contributor : result := FRS_XMP_DC_Contributor;
    IDRS_XMP_DC_Coverage : result := FRS_XMP_DC_Coverage;
    IDRS_XMP_DC_Creator : result := FRS_XMP_DC_Creator;
    IDRS_XMP_DC_Date : result := FRS_XMP_DC_Date;
    IDRS_XMP_DC_Description : result := FRS_XMP_DC_Description;
    IDRS_XMP_DC_Format : result := FRS_XMP_DC_Format;
    IDRS_XMP_DC_Identifier : result := FRS_XMP_DC_Identifier;
    IDRS_XMP_DC_Language : result := FRS_XMP_DC_Language;
    IDRS_XMP_DC_Publisher : result := FRS_XMP_DC_Publisher;
    IDRS_XMP_DC_Relation : result := FRS_XMP_DC_Relation;
    IDRS_XMP_DC_Rights : result := FRS_XMP_DC_Rights;
    IDRS_XMP_DC_Source : result := FRS_XMP_DC_Source;
    IDRS_XMP_DC_Subject : result := FRS_XMP_DC_Subject;
    IDRS_XMP_DC_Title : result := FRS_XMP_DC_Title;
    IDRS_XMP_DC_Type : result := FRS_XMP_DC_Type;
    IDRS_XMP_Photoshop_AuthorsPosition : result := FRS_XMP_Photoshop_AuthorsPosition;
    IDRS_XMP_Photoshop_CaptionWriter : result := FRS_XMP_Photoshop_CaptionWriter;
    IDRS_XMP_Photoshop_Category : result := FRS_XMP_Photoshop_Category;
    IDRS_XMP_Photoshop_City : result := FRS_XMP_Photoshop_City;
    IDRS_XMP_Photoshop_ColorMode : result := FRS_XMP_Photoshop_ColorMode;
    IDRS_XMP_Photoshop_Country : result := FRS_XMP_Photoshop_Country;
    IDRS_XMP_Photoshop_Credit : result := FRS_XMP_Photoshop_Credit;
    IDRS_XMP_Photoshop_DateCreated : result := FRS_XMP_Photoshop_DateCreated;
    IDRS_XMP_Photoshop_DocumentAncestorID : result := FRS_XMP_Photoshop_DocumentAncestorID;
    IDRS_XMP_Photoshop_Headline : result := FRS_XMP_Photoshop_Headline;
    IDRS_XMP_Photoshop_History : result := FRS_XMP_Photoshop_History;
    IDRS_XMP_Photoshop_ICCProfileName : result := FRS_XMP_Photoshop_ICCProfileName;
    IDRS_XMP_Photoshop_Instructions : result := FRS_XMP_Photoshop_Instructions;
    IDRS_XMP_Photoshop_Source : result := FRS_XMP_Photoshop_Source;
    IDRS_XMP_Photoshop_State : result := FRS_XMP_Photoshop_State;
    IDRS_XMP_Photoshop_SupplementalCategories : result := FRS_XMP_Photoshop_SupplementalCategories;
    IDRS_XMP_Photoshop_TextLayerName : result := FRS_XMP_Photoshop_TextLayerName;
    IDRS_XMP_Photoshop_TextLayerText : result := FRS_XMP_Photoshop_TextLayerText;
    IDRS_XMP_Photoshop_TransmissionReference : result := FRS_XMP_Photoshop_TransmissionReference;
    IDRS_XMP_Photoshop_Urgency : result := FRS_XMP_Photoshop_Urgency;
    IDRS_XMP_Advisory : result := FRS_XMP_Advisory;
    IDRS_XMP_Author : result := FRS_XMP_Author;
    IDRS_XMP_BaseURL : result := FRS_XMP_BaseURL;
    IDRS_XMP_CreateDate : result := FRS_XMP_CreateDate;
    IDRS_XMP_CreatorTool : result := FRS_XMP_CreatorTool;
    IDRS_XMP_Description : result := FRS_XMP_Description;
    IDRS_XMP_Format : result := FRS_XMP_Format;
    IDRS_XMP_Identifier : result := FRS_XMP_Identifier;
    IDRS_XMP_Keywords : result := FRS_XMP_Keywords;
    IDRS_XMP_Label : result := FRS_XMP_Label;
    IDRS_XMP_MetadataDate : result := FRS_XMP_MetadataDate;
    IDRS_XMP_ModifyDate : result := FRS_XMP_ModifyDate;
    IDRS_XMP_Nickname : result := FRS_XMP_Nickname;
    IDRS_XMP_Rating : result := FRS_XMP_Rating;
    IDRS_XMP_Title: result := FRS_XMP_Title;

    IDRS_EXIF_UserComment : result := FRS_EXIF_UserComment;
    IDRS_EXIF_ImageDescription : result := FRS_EXIF_ImageDescription;
    IDRS_EXIF_CameraMake : result := FRS_EXIF_CameraMake;
    IDRS_EXIF_CameraModel : result := FRS_EXIF_CameraModel;
    IDRS_EXIF_XResolution : result := FRS_EXIF_XResolution;
    IDRS_EXIF_YResolution : result := FRS_EXIF_YResolution;
    IDRS_EXIF_DateTime : result := FRS_EXIF_DateTime;
    IDRS_EXIF_DateTimeOriginal : result := FRS_EXIF_DateTimeOriginal;
    IDRS_EXIF_DateTimeDigitized : result := FRS_EXIF_DateTimeDigitized;
    IDRS_EXIF_Copyright : result := FRS_EXIF_Copyright;
    IDRS_EXIF_Orientation : result := FRS_EXIF_Orientation;
    IDRS_EXIF_ExposureTime : result := FRS_EXIF_ExposureTime;
    IDRS_EXIF_FNumber : result := FRS_EXIF_FNumber;
    IDRS_EXIF_ExposureProgram : result := FRS_EXIF_ExposureProgram;
    IDRS_EXIF_ISOSpeedRatings : result := FRS_EXIF_ISOSpeedRatings;
    IDRS_EXIF_ShutterSpeedValue : result := FRS_EXIF_ShutterSpeedValue;
    IDRS_EXIF_ApertureValue : result := FRS_EXIF_ApertureValue;
    IDRS_EXIF_BrightnessValue : result := FRS_EXIF_BrightnessValue;
    IDRS_EXIF_ExposureBiasValue : result := FRS_EXIF_ExposureBiasValue;
    IDRS_EXIF_MaxApertureValue : result := FRS_EXIF_MaxApertureValue;
    IDRS_EXIF_SubjectDistance : result := FRS_EXIF_SubjectDistance;
    IDRS_EXIF_MeteringMode : result := FRS_EXIF_MeteringMode;
    IDRS_EXIF_LightSource : result := FRS_EXIF_LightSource;
    IDRS_EXIF_Flash : result := FRS_EXIF_Flash;
    IDRS_EXIF_FocalLength : result := FRS_EXIF_FocalLength;
    IDRS_EXIF_FlashPixVersion : result := FRS_EXIF_FlashPixVersion;
    IDRS_EXIF_ColorSpace : result := FRS_EXIF_ColorSpace;
    IDRS_EXIF_ExifImageWidth : result := FRS_EXIF_ExifImageWidth;
    IDRS_EXIF_ExifImageHeight : result := FRS_EXIF_ExifImageHeight;
    IDRS_EXIF_RelatedSoundFile : result := FRS_EXIF_RelatedSoundFile;
    IDRS_EXIF_FocalPlaneXResolution : result := FRS_EXIF_FocalPlaneXResolution;
    IDRS_EXIF_FocalPlaneYResolution : result := FRS_EXIF_FocalPlaneYResolution;
    IDRS_EXIF_ExposureIndex : result := FRS_EXIF_ExposureIndex;
    IDRS_EXIF_SensingMethod : result := FRS_EXIF_SensingMethod;
    IDRS_EXIF_FileSource : result := FRS_EXIF_FileSource;
    IDRS_EXIF_SceneType : result := FRS_EXIF_SceneType;
    IDRS_EXIF_YCbCrPositioning : result := FRS_EXIF_YCbCrPositioning;
    IDRS_EXIF_ExposureMode : result := FRS_EXIF_ExposureMode;
    IDRS_EXIF_WhiteBalance : result := FRS_EXIF_WhiteBalance;
    IDRS_EXIF_DigitalZoomRatio : result := FRS_EXIF_DigitalZoomRatio;
    IDRS_EXIF_FocalLengthIn35mmFilm : result := FRS_EXIF_FocalLengthIn35mmFilm;
    IDRS_EXIF_SceneCaptureType : result := FRS_EXIF_SceneCaptureType;
    IDRS_EXIF_GainControl : result := FRS_EXIF_GainControl;
    IDRS_EXIF_Contrast : result := FRS_EXIF_Contrast;
    IDRS_EXIF_Saturation : result := FRS_EXIF_Saturation;
    IDRS_EXIF_Sharpness : result := FRS_EXIF_Sharpness;
    IDRS_EXIF_SubjectDistanceRange : result := FRS_EXIF_SubjectDistanceRange;
    IDRS_EXIF_GPSLatitude : result := FRS_EXIF_GPSLatitude;
    IDRS_EXIF_GPSLongitude : result := FRS_EXIF_GPSLongitude;
    IDRS_EXIF_GPSAltitude : result := FRS_EXIF_GPSAltitude;
    IDRS_EXIF_GPSImageDirection : result := FRS_EXIF_GPSImageDirection;
    IDRS_EXIF_GPSTrack : result := FRS_EXIF_GPSTrack;
    IDRS_EXIF_GPSSpeed : result := FRS_EXIF_GPSSpeed;
    IDRS_EXIF_GPSDateAndTime : result := FRS_EXIF_GPSDateAndTime;
    IDRS_EXIF_GPSSatellites : result := FRS_EXIF_GPSSatellites;
    IDRS_EXIF_GPSVersionID : result := FRS_EXIF_GPSVersionID;
    IDRS_EXIF_Artist : result := FRS_EXIF_Artist;
    IDRS_EXIF_XPTitle : result := FRS_EXIF_XPTitle;
    IDRS_EXIF_XPComment : result := FRS_EXIF_XPComment;
    IDRS_EXIF_XPAuthor : result := FRS_EXIF_XPAuthor;
    IDRS_EXIF_XPKeywords : result := FRS_EXIF_XPKeywords;
    IDRS_EXIF_XPSubject : result := FRS_EXIF_XPSubject;
    IDRS_EXIF_XPRating : result := FRS_EXIF_XPRating;
    IDRS_EXIF_InteropVersion : result := FRS_EXIF_InteropVersion;
    IDRS_EXIF_CameraOwnerName : result := FRS_EXIF_CameraOwnerName;
    IDRS_EXIF_BodySerialNumber : result := FRS_EXIF_BodySerialNumber;
    IDRS_EXIF_LensMake : result := FRS_EXIF_LensMake;
    IDRS_EXIF_LensModel : result := FRS_EXIF_LensModel;
    IDRS_EXIF_LensSerialNumber : result := FRS_EXIF_LensSerialNumber;
    IDRS_EXIF_Gamma : result := FRS_EXIF_Gamma;
    IDRS_EXIF_SubjectArea : result := FRS_EXIF_SubjectArea;
    IDRS_EXIF_SubjectLocation : result := FRS_EXIF_SubjectLocation;
    ELSE
      result := '';
    end;
  end;
end;

procedure TTBResStrManager.HandleGlobalNotification(sender: TObject;
  notType: TNWSCompsNotificationType);
begin
  case notType of
    nwsNotTyp_Lang:
    begin
      SetLanguage(NWSCOMPS.Language);
    end;
  end;

end;

procedure TTBResStrManager.SetLanguage(lng: TNWSCompsLanguage);
begin
  if (fLanguage = lng) and (assigned(tm)) then EXIT; //same language of translation memory -> nothing to change


  fLanguage := lng;

  if assigned(tm) then
    freeandnil(tm);

  case lng of
    nwsLng_En: tm := TTBTranslateMemory_EN.create;
    {$IFDEF NWSCOMPS_LNG_IT}nwsLng_IT: tm := TTBTranslateMemory_IT.create;{$ENDIF}
    {$IFDEF NWSCOMPS_LNG_ES}nwsLng_ES: tm := TTBTranslateMemory_ES.create;{$ENDIF}
    {$IFDEF NWSCOMPS_LNG_DE}nwsLng_DE: tm := TTBTranslateMemory_DE.create;{$ENDIF}
    else
    begin
      tm := TTBTranslateMemory_EN.create;
      raise Exception.Create('Language Not Recognized');
    end;
  end;
end;



initialization
 fTBResStrManList := TList.create;
 TBResStr :=  TTBResStrManager.Create(NWSCOMPS.Language, true);
 AddManToList(TBResStr);


finalization
 // freeandnil(TBResStr);  //this will be freed in the clearmanagers
  ClearManagers;
  freeandnil(fTBResStrManList);

end.
