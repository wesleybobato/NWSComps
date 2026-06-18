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
unit NWSComps_ThumbsBrowser_Utils_Types;
{$R-}
{$Q-}

interface

{$I ..\_inc\NWSComps_Shared.inc}
{$IFDEF IMAGEEN_5_2_LATER}
{$IFDEF NWSCOMPS_DELPHI2005_UPPER}
{$DEFINE NWSCOMPS_TB_METADATA_USEHELPERS}
{$ENDIF}
{$ENDIF}
{$IFDEF IMAGEEN_5_0_LATER}
{$DEFINE TB_FOLDERMONITOR}
{$ENDIF}
{$IFDEF IMAGEEN_6_2_LATER}
{$DEFINE TB_MULTIBITMAP}
{$ENDIF}

uses Windows, Messages, SysUtils, Classes, contnrs, graphics, dialogs, inifiles,
  hyieutils, hyiedefs, imageenproc,
  iewia,
{$IFDEF IMAGEEN_5_0_LATER} iexWindowsFunctions, {$ENDIF}
{$IFDEF IMAGEEN_6_2_LATER} iexBitmaps, {$ENDIF}
{$IFDEF NWSCOMPS_TB_METADATA_USEHELPERS}
  iexMetaHelpers,
{$ELSE}
  iexEXIFRoutines,
  iexIPTCRoutines,
  iexDICOMRoutines,
{$ENDIF}
  imageenio,
  NWSComps_Types;

const
  EXIFSEP = '|';
  IPTCSEP = '|';
  XMPSEP = '|';
  DICOMSEP = '|';
  COM_TAGSEP_OP = '[';
  COM_TAGSEP_CL = ']';
  COM_TAGID_EXIF = '{EXIF}';
  COM_TAGID_IPTC = '{IPTC}';
  COM_TAGID_DICOM = '{DICOM}';
  COM_TAGID_XMP = '{XMP}';

type
{$IFNDEF IMAGEEN_6_2_LATER}
  TIOParams = TIOParamsVals;
{$ENDIF}

  TNamedList = class(TList)
  private
    fNames: THashedStringList;

    function GetItems(AKey: String): Pointer;
    procedure Sort; reintroduce; // implemented just to hide the method
    procedure Pack; reintroduce; // implemented just to hide the method
  public
    constructor Create;
    destructor Destroy; override;

    procedure Assign(Source: TList); reintroduce;
    procedure Clear;

    function GetKey(idx: integer): string;
    procedure SetKey(idx: integer; const theKey: string);

    function Add(AKey: String; Item: Pointer): integer; overload;
    function Add(Item: Pointer): integer; reintroduce; overload;

    function Insert(Index: integer; AKey: String; Item: Pointer): integer; overload;
    function Insert(Index: integer; Item: Pointer): integer; reintroduce; overload;

    procedure Delete(AKey: String; const bFindAll: boolean); overload;
    procedure Delete(Index: integer); reintroduce; overload;

    procedure Remove(Item: Pointer); reintroduce;
    procedure Move(CurIndex: integer; NewIndex: integer); reintroduce;

    function IndexOf(AKey: String): integer; overload; virtual;
    function IndexOf(Item: Pointer): integer; reintroduce; overload; virtual;

    function Get(AKey: string; var AResult: Pointer): boolean;
    property Items[AKey: String]: Pointer read GetItems; default;

  end;

  TThreadObjectList = class // source: https://github.com/dkstar88/httppool
  private
    FList: TObjectList;
    FLock: TRTLCriticalSection;
    FDuplicates: TDuplicates;
    function GetItems(Index: integer): TObject;
    procedure SetItems(Index: integer; const Value: TObject);
    function getOwnsObjects: boolean;
    procedure setOwnsObjects(const Value: boolean);
  protected
    function GetCount: integer; virtual;
    procedure Notify(Ptr: Pointer; Action: TListNotification); virtual;

  public
    constructor Create;
    destructor Destroy; override;
    function Add(Item: TObject): integer; virtual;
    function Insert(APos: integer; AItem: TObject): integer; virtual;
    procedure Clear; virtual;
    function LockList: TList;
    procedure Lock;
    procedure Unlock;
    function TryLockList: boolean;
    procedure Remove(Item: TObject); virtual;
    procedure Delete(Aindex: integer); virtual;
    procedure Sort(Compare: TListSortCompare);
    procedure UnlockList;
    function IndexOf(AItem: TObject): integer;

    property Duplicates: TDuplicates read FDuplicates write FDuplicates;

    property Count: integer read GetCount;
    property List: TObjectList read FList;

    property Items[Index: integer]: TObject read GetItems write SetItems;
    property OwnsObjects: boolean read getOwnsObjects write setOwnsObjects;
  end;

  TThumbsbrowser_LoadingType = (tblt_FileSystem, tblt_WPD, tblt_Reload, tblt_None);

  TThumbsbrowser_FileDisplay_Options = class(Tpersistent)
  private
    fHiddenfiles: boolean;
    fSystemfiles: boolean;
    fHiddenfolders: boolean;
    fSystemfolders: boolean;

  Published

    property HiddenFiles: boolean read fHiddenfiles write fHiddenfiles;
    property HiddenFolders: boolean read fHiddenfolders write fHiddenfolders;
    property SystemFiles: boolean read fSystemfiles write fSystemfiles;
    property SystemFolders: boolean read fSystemfolders write fSystemfolders;

  end;

  TThumbsbrowser_MetaData_Type = (mdft_Common, mdft_Exif, mdft_Iptc, mdft_Dicom, mdft_Xmp);
  TThumbsbrowser_MetaData_FieldUpdateMode = (mdum_Replace, mdum_Merge);

  TTBDicomTagsIncludeOption = (DIn_Deprecated, DIn_Proprietary, DIn_Children, DIn_Unknown);
  TTBDicomTagsIncludeOptions = set of TTBDicomTagsIncludeOption;

  TTBGeneralTag = class(TObject)
  private
    fDataType: TThumbsbrowser_MetaData_Type;
    fLangStrId: integer;

    fDesc: string;

  public
    property Desc: string read fDesc; // Field Description

    property LangStrId: integer read fLangStrId;
    property DataType: TThumbsbrowser_MetaData_Type read fDataType;

    Constructor Create(theDataType: TThumbsbrowser_MetaData_Type; theLangStrId: integer); reintroduce; virtual;
    destructor Destroy; override;

    procedure LoadDescrFromRes(theLanguage: TNWSCompsLanguage);
  end;

  TTBExifTag = class(TTBGeneralTag)
  private
    fIdx: integer;

  public
    property idx: integer read fIdx;

    constructor Create(const theIdx: integer); reintroduce; overload;
    constructor Create(const theIdx: integer; const theDesc: string); reintroduce; overload;
  end;

  TTBGeneralTags = class(TObjectList)
  private
    fLanguage: TNWSCompsLanguage;
  public
    property Language: TNWSCompsLanguage read fLanguage;
    constructor Create; reintroduce;

    procedure SetLanguage(theLanguage: TNWSCompsLanguage; bForceTranslate: boolean = False); virtual;
  end;

  TTBExifTags = class(TTBGeneralTags)

  private

    function GetTagAsStr(idx: integer): string;
    procedure InitTags;
    procedure SetTag(idx: integer; const Value: TTBExifTag);
    procedure SetTagAsStr(idx: integer; const Value: string);

    property Items;

    function GetTag(idx: integer): TTBExifTag;

  public

    property Tags[idx: integer]: TTBExifTag read GetTag write SetTag; default;
    property TagAsStr[idx: integer]: string read GetTagAsStr write SetTagAsStr;

    constructor Create(const bFill: boolean); reintroduce; overload;
    constructor Create; reintroduce; overload;

    function GetTagIdx(theTag: TTBExifTag): integer;

    procedure Add(aObject: TObject); reintroduce; overload;
    procedure Add(TagStr: string); overload;
    procedure Assign(Source: TObject); reintroduce;

  end;

  TTBIptcTag = class(TTBGeneralTag)
  private
    fRec: integer;
    fDSet: integer;

  public
    property Rec: integer read fRec; // Record Number
    property DSet: integer read fDSet; // Data Set

    constructor Create(const theRec, theDSet: integer); reintroduce; overload;
    constructor Create(const theRec, theDSet: integer; const theDescr: string); reintroduce; overload;
  end;

  TTBIptcTags = class(TTBGeneralTags)

  private

    function GetTagAsStr(idx: integer): string;
    procedure SetTag(idx: integer; const Value: TTBIptcTag);
    procedure SetTagAsStr(idx: integer; const Value: string);
    property Items;

    function GetTag(idx: integer): TTBIptcTag;

    procedure InitTags;

  public

    property Tags[idx: integer]: TTBIptcTag read GetTag write SetTag; default;
    property TagAsStr[idx: integer]: string read GetTagAsStr write SetTagAsStr;

    constructor Create(const bFill: boolean); reintroduce; overload;
    constructor Create; reintroduce; overload;

    procedure Add(aObject: TObject); reintroduce; overload;
    procedure Add(TagStr: string); overload;

    function GetTagIdx(theTag: TTBIptcTag): integer;

    procedure Assign(Source: TObject); reintroduce;
  end;

  TTBXmpTag = class(TTBGeneralTag)
  private

    fName: string;
  public

    property Name: string read fName; // Tag name identifier

    constructor Create(const theName: string); reintroduce; overload;
    constructor Create(const theName, theDesc: string); reintroduce; overload;
  end;

  TTBXmpTags = class(TTBGeneralTags)

  private

    function GetTagAsStr(idx: integer): string;
    procedure SetTag(idx: integer; const Value: TTBXmpTag);
    procedure SetTagAsStr(idx: integer; const Value: string);

    property Items;

    function GetTag(idx: integer): TTBXmpTag;

    procedure InitTags;
  public

    property Tags[idx: integer]: TTBXmpTag read GetTag write SetTag; default;
    property TagAsStr[idx: integer]: string read GetTagAsStr write SetTagAsStr;

    constructor Create(const bFill: boolean); reintroduce; overload;
    constructor Create; reintroduce; overload;

    function GetTagIdx(theTag: TTBXmpTag): integer;

    procedure Add(aObject: TObject); reintroduce; overload;
    procedure Add(TagStr: string); overload;
    procedure Assign(Source: TObject); reintroduce;
  end;

  TTBCommonTag = class(TTBGeneralTag)
  private
    fLinkedExifTags: TTBExifTags;
    fLinkedIptcTags: TTBIptcTags;

    fLinkedXMPTags: TTBXmpTags;
    function GetDesc: string;

  public
    property LinkedEXIFTags: TTBExifTags read fLinkedExifTags; // linked Exif Tags
    property LinkedIPTCTags: TTBIptcTags read fLinkedIptcTags; // linked Iptc Tags
    property LinkedXMPTags: TTBXmpTags read fLinkedXMPTags; // linked Xmp Tags

    constructor Create(theLinkedExifTags: TTBExifTags; theLinkedIPTCTags: TTBIptcTags; theLinkedXmpTags: TTBXmpTags;
      theDesc: string; theLangStrId: integer); reintroduce;
    destructor Destroy; override;

    property Desc: string read GetDesc;
  end;

  TTBCommonTags = class(TTBGeneralTags)

  private

    function GetTagAsStr(idx: integer): string;
    procedure SetTag(idx: integer; const Value: TTBCommonTag);
    procedure SetTagAsStr(idx: integer; const Value: string);

    property Items;

    function GetTag(idx: integer): TTBCommonTag;

    procedure InitTags;

  public

    const
    SEP: string = ';';

    property Tags[idx: integer]: TTBCommonTag read GetTag write SetTag; default;
    property TagAsStr[idx: integer]: string read GetTagAsStr write SetTagAsStr;

    constructor Create(const bFill: boolean); reintroduce; overload;
    constructor Create; reintroduce; overload;

    procedure Add(aObject: TObject); reintroduce; overload;
    procedure Add(TagStr: string); overload;
    procedure Assign(Source: TObject); reintroduce;

    function GetTagIdx(theTag: TTBCommonTag): integer;

    procedure SetLanguage(theLanguage: TNWSCompsLanguage; bForceTranslate: boolean = False); override;
  end;

  TThumbsbrowser_MetaTags = class(Tpersistent)
  private
    fIptcTags: TTBIptcTags;
    fExifTags: TTBExifTags;
    fXmpTags: TTBXmpTags;
    fCommonTags: TTBCommonTags;
    fVersion: single;
  public

    property ExifTags: TTBExifTags read fExifTags;
    property IptcTags: TTBIptcTags read fIptcTags;
    property XmpTags: TTBXmpTags read fXmpTags;
    property CommonTags: TTBCommonTags read fCommonTags;

    property Version: single read fVersion;

    Constructor Create(const bFill: boolean); reintroduce;
    Destructor Destroy; override;

    procedure Assign(Source: TObject); reintroduce;

    procedure SetLanguage(theLanguage: TNWSCompsLanguage);
  end;

  TThumbsbrowser_MetaData_SyncOpType = (mdSyncOpNone, mdSyncOp_ReadOnly, mdSyncOp_ReadWrite);

  TThumbsbrowser_MetaData_SyncType = (mdSyncTopTitle, mdSyncBottomTitle, mdSyncRating, mdSyncKeywords);

  TThumbsbrowser_MetaData_SyncTagChangedEvent = procedure(sender: TObject; syncType: TThumbsbrowser_MetaData_SyncType;
    const oldTagstr, newTagstr: string) of object;
  TThumbsbrowser_MetaData_SyncPropertyChangedEvent = procedure(sender: TObject;
    syncType: TThumbsbrowser_MetaData_SyncType) of object;

  TThumbsbrowser_MetaData_AutoSyncOptionChangedEvent = procedure(sender: TObject;
    syncType: TThumbsbrowser_MetaData_SyncType; oldOption, newOption: TThumbsbrowser_MetaData_SyncOpType) of object;

  TThumbsbrowser_MetaData_Options = class(Tpersistent)

  private

    fFields_Exif: Tstringlist;
    fFields_IPTC: Tstringlist;
    fFields_Xmp: Tstringlist;
    fFields_Common: Tstringlist;

    fOnExifFieldsChanged: TNotifyEvent;
    fOnIptcFieldsChanged: TNotifyEvent;
    fOnXmpFieldsChanged: TNotifyEvent;
    fOnCommonFieldsChanged: TNotifyEvent;
    fSyncField_Rating: string;
    fSyncField_Keywords: string;
    fSyncField_Bottomtitle: string;
    fSyncField_TopTitle: string;
    fOnSyncTagChanged: TThumbsbrowser_MetaData_SyncTagChangedEvent;
    fAutoSync_Rating: TThumbsbrowser_MetaData_SyncOpType;
    fAutoSync_Keywords: TThumbsbrowser_MetaData_SyncOpType;
    fAutoSync_BottomTitle: TThumbsbrowser_MetaData_SyncOpType;
    fAutoSync_TopTitle: TThumbsbrowser_MetaData_SyncOpType;
    fOnAutoSyncOptionsChanged: TThumbsbrowser_MetaData_AutoSyncOptionChangedEvent;
    fUseExifOrientationForThumbs: boolean;

    procedure SetFields_IPTC(const Value: Tstringlist);
    procedure SetFields_Xmp(const Value: Tstringlist);
    procedure SetFields_Exif(const Value: Tstringlist);
    procedure SetFields_Common(const Value: Tstringlist);
    procedure setBottomTitle_SyncCommonField(const Value: string);
    procedure setKeywords_SyncCommonField(const Value: string);
    procedure setRating_SyncCommonField(const Value: string);
    procedure setTopTitle_SyncCommonField(const Value: string);
    procedure setAutoSync_BottomTitle(const Value: TThumbsbrowser_MetaData_SyncOpType);
    procedure setAutoSync_Keywords(const Value: TThumbsbrowser_MetaData_SyncOpType);
    procedure setAutoSync_Rating(const Value: TThumbsbrowser_MetaData_SyncOpType);
    procedure setAutoSync_TopTitle(const Value: TThumbsbrowser_MetaData_SyncOpType);

  public

    property OnCommonFieldsChanged: TNotifyEvent read fOnCommonFieldsChanged write fOnCommonFieldsChanged;
    property OnExifFieldsChanged: TNotifyEvent read fOnExifFieldsChanged write fOnExifFieldsChanged;
    property OnIptcFieldsChanged: TNotifyEvent read fOnIptcFieldsChanged write fOnIptcFieldsChanged;
    property OnXmpFieldsChanged: TNotifyEvent read fOnXmpFieldsChanged write fOnXmpFieldsChanged;

    property OnSyncTagChanged: TThumbsbrowser_MetaData_SyncTagChangedEvent read fOnSyncTagChanged
      write fOnSyncTagChanged;
    property OnAutoSyncOptionsChanged: TThumbsbrowser_MetaData_AutoSyncOptionChangedEvent read fOnAutoSyncOptionsChanged
      write fOnAutoSyncOptionsChanged;

    constructor Create; reintroduce;
    destructor Destroy; override;

    procedure Update;
    function GetSyncTag(syncType: TThumbsbrowser_MetaData_SyncType): string;
    function GetAutoSyncOption(syncType: TThumbsbrowser_MetaData_SyncType): TThumbsbrowser_MetaData_SyncOpType;
  published

    property Fields_Exif: Tstringlist read fFields_Exif write SetFields_Exif;
    property Fields_IPTC: Tstringlist read fFields_IPTC write SetFields_IPTC;
    property Fields_Xmp: Tstringlist read fFields_Xmp write SetFields_Xmp;
    property Fields_Common: Tstringlist read fFields_Common write SetFields_Common;

    property SyncField_TopTitle: string read fSyncField_TopTitle write setTopTitle_SyncCommonField;
    property SyncField_BottomTitle: string read fSyncField_Bottomtitle write setBottomTitle_SyncCommonField;
    property SyncField_Rating: string read fSyncField_Rating write setRating_SyncCommonField;
    property SyncField_Keywords: string read fSyncField_Keywords write setKeywords_SyncCommonField;

    property AutoSync_TopTitle: TThumbsbrowser_MetaData_SyncOpType read fAutoSync_TopTitle write setAutoSync_TopTitle;
    property AutoSync_BottomTitle: TThumbsbrowser_MetaData_SyncOpType read fAutoSync_BottomTitle
      write setAutoSync_BottomTitle;
    property AutoSync_Rating: TThumbsbrowser_MetaData_SyncOpType read fAutoSync_Rating write setAutoSync_Rating;
    property AutoSync_Keywords: TThumbsbrowser_MetaData_SyncOpType read fAutoSync_Keywords write setAutoSync_Keywords;

    property UseExifOrientationForThumbs: boolean read fUseExifOrientationForThumbs write fUseExifOrientationForThumbs;
    // property Captions_SyncCommonFields: tstringlist read fCaptions_SyncCommonFields write setCaptions_SyncCommonFields;

  end;

  TThumbsbrowser_MetaData_DisplayMode = (mdm_NonEmpty, mdm_All, mdm_GroupedByCore);

  TThumbsbrowser_MetaData_FileRcd = class(TObject)
  private
    // fThumb:TThumbEX;
    FFileName: string;
    fIsWia: boolean;
    fIsWPD: boolean;
    fIsUrl: boolean;
    fWiaItem: TIEWiaItem;
    fWPDObjectID: String;
    fHasExif: boolean;
    fHasIptc: boolean;
    fHasDicom: boolean;
    fHasXmp: boolean;
    fEdited: boolean;
    fDisplayMode_Exif: TThumbsbrowser_MetaData_DisplayMode;
    fDisplayMode_Xmp: TThumbsbrowser_MetaData_DisplayMode;
    fDisplayMode_Common: TThumbsbrowser_MetaData_DisplayMode;
    fDisplayMode_Iptc: TThumbsbrowser_MetaData_DisplayMode;
    fDisplayMode_Dicom: TThumbsbrowser_MetaData_DisplayMode;
    fThumbOrientation: integer;

    fThumbHasFullImg: boolean;
    fThumbImg: TIEBitmap;

    fForceExif, fForceIptc, fForceXmp, fForceDicom: boolean;

    fMetaInitialized: boolean;

    procedure InitShort(theFileName: string);

    procedure Init(theFileName: string; bIsUrl, bIsWia, bIsWPD: boolean; bHasExif: boolean; bHasIptc: boolean;
      bHasDicom: boolean; bHasXmp: boolean; iThumbOrientation: integer; theWiaItem: TIEWiaItem; theWPDObjID: String;
      bThumbHasFullImg: boolean; theThumbImg: TIEBitmap);
    function GetFileExtension: string;
    function GetDicomEditable: boolean;
    function GetExifEditable: boolean;
    function GetIptcEditable: boolean;
    function GetXmpEditable: boolean;
    function GetCommonEditable: boolean;
    function GetHasDicom: boolean;
    function GetHasExif: boolean;
    function GetHasIptc: boolean;
    function GetHasXmp: boolean;
    procedure SetHasDicom(const Value: boolean);
    procedure SetHasExif(const Value: boolean);
    procedure SetHasIptc(const Value: boolean);
    procedure SetHasXmp(const Value: boolean);
  public

    property MetaInitialized: boolean read fMetaInitialized;

    property FileName: string read FFileName;
    property FileExtension: string read GetFileExtension;

    property CommonEditable: boolean read GetCommonEditable;
    property ExifEditable: boolean read GetExifEditable;
    property IptcEditable: boolean read GetIptcEditable;
    property DicomEditable: boolean read GetDicomEditable;
    property XmpEditable: boolean read GetXmpEditable;

    property IsUrl: boolean read fIsUrl;
    property IsWia: boolean read fIsWia;
    property IsWpd: boolean read fIsWPD;
    property HasExif: boolean read GetHasExif write SetHasExif;
    property HasIptc: boolean read GetHasIptc write SetHasIptc;
    property HasDicom: boolean read GetHasDicom write SetHasDicom;
    property HasXmp: boolean read GetHasXmp write SetHasXmp;
    property WiaItem: TIEWiaItem read fWiaItem;
    property WPDObjectID: String read fWPDObjectID;
    property DisplayMode_Common: TThumbsbrowser_MetaData_DisplayMode read fDisplayMode_Common write fDisplayMode_Common;
    property DisplayMode_Exif: TThumbsbrowser_MetaData_DisplayMode read fDisplayMode_Exif write fDisplayMode_Exif;
    property DisplayMode_Iptc: TThumbsbrowser_MetaData_DisplayMode read fDisplayMode_Iptc write fDisplayMode_Iptc;
    property DisplayMode_Xmp: TThumbsbrowser_MetaData_DisplayMode read fDisplayMode_Xmp write fDisplayMode_Xmp;
    property DisplayMode_Dicom: TThumbsbrowser_MetaData_DisplayMode read fDisplayMode_Dicom write fDisplayMode_Dicom;

    property ThumbOrientation: integer read fThumbOrientation write fThumbOrientation;

    property ThumbHasFullImg: boolean read fThumbHasFullImg;
    property ThumbImg: TIEBitmap read fThumbImg;
    // Constructor Create(theThumb:TThumbEX); overload;
    Constructor Create(theFileName: string; bIsUrl, bIsWia, bIsWPD: boolean; bHasExif: boolean; bHasIptc: boolean;
      bHasDicom: boolean; bHasXmp: boolean; iThumbOrientation: integer; theWiaItem: TIEWiaItem = nil;
      theWPDObjID: String = ''; bThumbHasFullImg: boolean = False; theThumbImg: TIEBitmap = nil); overload;

    Constructor Create(theFileName: string); overload;
    Constructor Create(theFileName: string; theParams: TIOParams); overload;

    procedure InitMeta(bHasExif, bHasIptc, bHasDicom, bHasXmp: boolean);
    procedure RenameFile(theNewName: string);

    procedure ForceMetaInfo(const bForceExif, bForceIptc, bForceXmp, bForceDicom: boolean);
    procedure UnForceMetaInfo(const bUnForceExif, bUnForceIptc, bUnForceXmp, bUnForceDicom: boolean);
  end;

  TThumbsbrowser_MetaData_FileRcds = Class

  private
    FList: TObjectList;
    function GetRcd(idx: integer): TThumbsbrowser_MetaData_FileRcd;
    procedure SetRcd(idx: integer; const Value: TThumbsbrowser_MetaData_FileRcd);
    function GetCount: integer;
  public
    property Count: integer read GetCount;
    property Rcd[idx: integer]: TThumbsbrowser_MetaData_FileRcd read GetRcd write SetRcd; default;

    procedure Insert(const idx: integer; theRcd: TThumbsbrowser_MetaData_FileRcd);
    procedure Add(theRcd: TThumbsbrowser_MetaData_FileRcd);
    procedure Remove(theRcd: TThumbsbrowser_MetaData_FileRcd);
    procedure Delete(const idx: integer);
    procedure Clear;

    constructor Create;
    destructor Destroy; override;

  End;

  TThumbsbrowser_MetaData_Field = class(Tpersistent)
  private
    fIdx: integer;
    fFieldType: TThumbsbrowser_MetaData_Type;
    fValue: string;
    fUpdateMode: TThumbsbrowser_MetaData_FieldUpdateMode;
    procedure Init(theIdx: integer; theFieldType: TThumbsbrowser_MetaData_Type; theValue: string;
      theUpdateMode: TThumbsbrowser_MetaData_FieldUpdateMode);

  public

    property idx: integer read fIdx;
    property FieldType: TThumbsbrowser_MetaData_Type read fFieldType;
    property Value: string read fValue write fValue;
    property UpdateMode: TThumbsbrowser_MetaData_FieldUpdateMode read fUpdateMode;

    constructor Create(theIdx: integer; theFieldType: TThumbsbrowser_MetaData_Type; theValue: string;
      theUpdateMode: TThumbsbrowser_MetaData_FieldUpdateMode); reintroduce; overload;

    constructor Create(TagStr: string; Tags: TThumbsbrowser_MetaTags; theFieldType: TThumbsbrowser_MetaData_Type;
      theValue: string; theUpdateMode: TThumbsbrowser_MetaData_FieldUpdateMode); reintroduce; overload;

    constructor Create(theTag: TTBGeneralTag; Tags: TThumbsbrowser_MetaTags; theValue: string;
      theUpdateMode: TThumbsbrowser_MetaData_FieldUpdateMode); reintroduce; overload;

  end;

  TThumbsbrowser_MetaData_FieldsList = class(TObjectList)
  private
    fMetaTags: TThumbsbrowser_MetaTags;
    fIoParams: TIOParams;
    fIPTCModified: boolean;
    fDICOMModified: boolean;
    fExifModified: boolean;
    fCommonModified: boolean;
    fXmpModified: boolean;
    function FieldExists(theField: TThumbsbrowser_MetaData_Field): integer;
    procedure SetFieldValue(idx: integer; theValue: string);
    procedure ResetModified;
    procedure CheckModified;

    property Items;

    function GetField(idx: integer): TThumbsbrowser_MetaData_Field;
    procedure Add(aObject: TObject);
    procedure Remove(aObject: TObject);

  public

    property MetaTags: TThumbsbrowser_MetaTags read fMetaTags;

    property ExifModified: boolean read fExifModified;
    property IPTCModified: boolean read fIPTCModified;
    property DICOMModified: boolean read fDICOMModified;
    property XMPModified: boolean read fXmpModified;

    property Field[idx: integer]: TThumbsbrowser_MetaData_Field read GetField;
    procedure AddField(theField: TThumbsbrowser_MetaData_Field);

    procedure Clear; override;

    Constructor Create(theMetaTags: TThumbsbrowser_MetaTags; theIoParams: TIOParams); reintroduce;

  end;

  TThumbsBrowser_MetadataVisibilityEvent = procedure(metadataField: TThumbsbrowser_MetaData_Field;
    var bVisible: boolean) of object;

  TThumbsbrowser_MetaData_FileEvent = procedure(sender: TObject; theFileRcd: TThumbsbrowser_MetaData_FileRcd) of object;

  TThumbsbrowser_MetaData_Field_ModifiedEvent = procedure(sender: TObject; theField: TThumbsbrowser_MetaData_Field)
    of object;

  TTB_Browser_CurrentBrowsingMode = (bm_Files, bm_WIA, bm_WPD, bm_Undefined);

  // --------------Events---------------------------------------------------
  TTB_Browser_OnNavigateFolderEvent = procedure(theFolder: string) of object;
  TTB_Browser_OnNavigateWPDFolderEvent = procedure(theDeviceID, theFolderID: string) of object;
  TTB_Browser_OnInitializedEvent = procedure(sender: TObject; InitType: TTB_Browser_CurrentBrowsingMode) of object;
  TTB_Browser_ProgressEvent = procedure(sender: TObject; const Pos, minPos, maxPos: integer) of object;
  TTB_Browser_ProgressEvent_Perc = procedure(sender: TObject; per: integer; const Caption: string = '') of object;

  TThumbsBrowserOnDragRequest = procedure(sender: TObject; shift: TShiftstate; x, y: integer;
    var AcceptExternalDragDrop: boolean) of object;

  TTB_Browser_OnItemCommand = procedure(itemindex: integer) of object;
  TTB_Browser_OnFileModified = procedure(theFileName: string) of object;
  TTB_Browser_OnItemFileNameChanged = procedure(const old_filename: string; const new_filename: string) of object;

  TTB_Browser_OnThumbLoadedEvent = procedure(sender: TObject; idx: integer) of object;

  // --------------Thumb---------------------------------------------------
  TTB_Thumb_Originator = (tborig_Auto, tborig_Manual);
  TTB_Thumb_StoreType = (tbStore_Unspecified, tbstore_Thumb, tbstore_FullImage);

  TTB_SourceFileType = (ft_Pic, ft_Video, ft_Other);
  TTB_SourceType = (st_General, st_File, st_Folder, st_FolderNav, st_WIA, st_URL, st_WPDFile, st_WPDFolder,
    st_WPDFolderNav);
  TTB_SourceTypes = set of TTB_SourceType;

  TTB_Thumb_CaptionsSetting = (cap_ShowFileName, cap_ShowDateTime, cap_ShowFileSize, cap_ShowDimensions,
    cap_ShowEXIFDateTime, cap_ShowEXIF_XPAuthor, cap_ShowEXIF_XPTitle, cap_ShowEXIF_XPSubject, cap_ShowEXIF_XPComment,
    cap_ShowEXIF_XPKeywords, cap_ShowEXIF_XPRating, cap_ShowKeywords, cap_ShowRating,

    cap_ShowFileNameWithoutExtension, cap_ShowFilePath, cap_ShowFileDimensionsAndSize, cap_ShowCreateDate,
    cap_ShowCreateDateAndTime, cap_ShowEditDate, cap_ShowEditDateAndTime, cap_ShowFileType, cap_ShowTopTitle,
    cap_ShowBottomTitle, cap_ShowCustomMetaData, cap_General, cap_Other1, cap_Other2, cap_Other3, cap_Other4, cap_Empty);

  TTB_Thumb_CaptionsSettings = set of TTB_Thumb_CaptionsSetting;
  TTB_Thumb_CaptionStyle = (capSt_Rows, capSt_Cols, capSt_RowsCentered, capSt_ColsCentered);
  // TODO implement caption styles multiple rows or multiple columns

  TTB_Thumb_CaptionInfo = record
    capIdx: integer;
    ColPercWidth: single;
  end;

  TTB_Thumb_Layout_Type = (ltHorizontal, ltVertical);

  TTB_Thumb_LayoutElementType = (leCheck, leInfoBox, leRotateButtonLeft, leRotateButtonRight, leTopTitle, leBottomTitle,
    leRatingBox);
  TTB_Thumb_LayoutElementTypes = set of TTB_Thumb_LayoutElementType;

  TTB_Thumb_LayoutElement = class
  private
    fRect: TRect;
    fElementType: TTB_Thumb_LayoutElementType;
    fWidth: integer;
    fHeight: integer;
    procedure SetRect(const Value: TRect);

  public

    property ElementType: TTB_Thumb_LayoutElementType read fElementType;
    property Rect: TRect read fRect write SetRect;
    property Width: integer read fWidth;
    property Height: integer read fHeight;

    procedure Assign(Source: TObject);

    constructor Create(theElementType: TTB_Thumb_LayoutElementType);
  end;

  TTB_Thumb_LayoutElements = class

  private
    FList: TObjectList;

    fRotateButtons_L: TTB_Thumb_LayoutElement;
    fTopTitle: TTB_Thumb_LayoutElement;
    fInfoBox: TTB_Thumb_LayoutElement;
    fRotateButtons_R: TTB_Thumb_LayoutElement;
    fCheckBox: TTB_Thumb_LayoutElement;
    fBottomTitle: TTB_Thumb_LayoutElement;
    fRatingBox: TTB_Thumb_LayoutElement;

    function GetElement(theElementType: TTB_Thumb_LayoutElementType): TTB_Thumb_LayoutElement;
    procedure CalcQuickRef(e: TTB_Thumb_LayoutElement);
  public
    function GetRect(theElementType: TTB_Thumb_LayoutElementType): TRect;
    procedure SetRect(theElementType: TTB_Thumb_LayoutElementType; theRect: TRect);

    constructor Create;
    destructor Destroy; override;

    procedure Assign(Source: TObject);

    property InfoBox: TTB_Thumb_LayoutElement read fInfoBox;
    property CheckBox: TTB_Thumb_LayoutElement read fCheckBox;
    property RotateButtons_L: TTB_Thumb_LayoutElement read fRotateButtons_L;
    property RotateButtons_R: TTB_Thumb_LayoutElement read fRotateButtons_R;
    property TopTitle: TTB_Thumb_LayoutElement read fTopTitle;
    property BottomTitle: TTB_Thumb_LayoutElement read fBottomTitle;
    property RatingBox: TTB_Thumb_LayoutElement read fRatingBox;
  end;

  TTB_Thumb_DropShadowOptions = class(Tpersistent)
  private
    fEnabled: boolean;
    fSize: cardinal;
    fNotifier: TNotifyEvent;
    procedure SetEnabled(const Value: boolean);
    procedure SetSize(const Value: cardinal);
  published
    property Enabled: boolean read fEnabled write SetEnabled;
    property Size: cardinal read fSize write SetSize;
    Constructor Create(Notifier: TNotifyEvent);
  end;

  TTB_Thumb_MouseOverOption = (moFrameBg, moFrameBorder, moCaptionBg, moCaptionText);
  TTB_Thumb_MouseOverOptions = set of TTB_Thumb_MouseOverOption;

  TTB_Thumb_OnThumbBufferLoaded = procedure(sender: TObject; const bufWidth, bufHeight: integer;
    var bResizeBuffer: boolean; var newbufWidth, newbufHeight: integer) of object;
  TTB_Thumb_OnCustomDraw = procedure(sender: TObject; cv: Tcanvas; cv_rect: TRect; var Handled: boolean) of object;
  TTB_Thumb_OnCustomDrawText = procedure(sender: TObject; cv: Tcanvas; cv_rect: TRect; var theText: string;
    var theTextColor: TColor; var theTextSelectedColor: TColor; var theTextBackColor: TColor;
    var theTextBackSelectedColor: TColor; var theTextStyle: TFontStyles; var theTextStyle_Selected: TFontStyles;
    var theText_Opacity: cardinal; var theText_OpacitySelected: cardinal; var Handled: boolean) of object;

  TTB_Thumb_ShowSetting = (th_ShowCaption, th_ShowCheckBox, th_ShowRotateButtons, th_ShowInfoBox, th_ShowTopTitle,
    th_ShowBottomTitle, th_ShowRatingBox);
  TTB_Thumb_ShowSettings = set of TTB_Thumb_ShowSetting;
  TTB_Thumb_MouseUpResult = (mupOutside, mupInside);
  TTB_Thumb_HitRectResult = (HitOutside, HitInsideGeneral, HitPicture, HitCheck, HitRotateButtonLeft,
    HitRotateButtonRight, HitInfoBox, HitCaption, HitTopTitle, HitBottomTitle, HitRatingBox, HitThumbArea);

  TTB_Thumb_OnGetCaptionInfo = procedure(const capSet: TTB_Thumb_CaptionsSetting; var info: TTB_Thumb_CaptionInfo)
    of object;
  TTB_Thumb_OnGetCaptionIdx = procedure(const Pos: integer; var capIdx: integer) of object;

  TTB_Thumb_RotationMode = (tRmRight, TRmNone, tRmLeft);

  TTB_Thumb_Caption = Class
  private
    fCaptionSetting: TTB_Thumb_CaptionsSetting;
    fText: string;

  public
    property Text: string read fText write fText;
    property CaptionSetting: TTB_Thumb_CaptionsSetting read fCaptionSetting write fCaptionSetting;

    procedure Assign(Source: TTB_Thumb_Caption);

    Constructor Create(const theText: string; const theCaptionSetting: TTB_Thumb_CaptionsSetting); overload;
  End;

  TTB_Thumb_Captions = Class(TObjectList)
  private
    function GetCaption(Index: integer): TTB_Thumb_Caption;
    procedure SetCaption(Index: integer; const Value: TTB_Thumb_Caption); overload;

  public
    function GetCaptionbySetting(const capSet: TTB_Thumb_CaptionsSetting): TTB_Thumb_Caption;
    property Caption[Index: integer]: TTB_Thumb_Caption read GetCaption write SetCaption; default;
    procedure SetCaption(const theText: string; const theCaptionSetting: TTB_Thumb_CaptionsSetting); overload;
    function Add(const theText: string; const theCaptionSetting: TTB_Thumb_CaptionsSetting): integer; reintroduce;
    procedure Insert(idx: integer; const theText: string; const theCaptionSetting: TTB_Thumb_CaptionsSetting);
      reintroduce;
    procedure Assign(Source: TTB_Thumb_Captions; bExcludeGenCaptions: boolean = False); reintroduce;
  End;

  TTB_Thumb_GraphicResource_GradBmpInfo = record
    GradBmp: TIEBitmap;
    GradBmpSel: TIEBitmap;
    ColStart: TColor;
    ColEnd: TColor;
    ColStartSel: TColor;
    ColEndSel: TColor;
  end;

  TTB_Thumb_GraphicResourceType = (gr_Bg, gr_Checked, gr_Unchecked, gr_Info, gr_RotStrip, gr_RotRight_Up,
    gr_RotRight_Down, gr_RotLeft_Up, gr_RotLeft_Down, gr_FolderNormal, gr_FolderUp, gr_ThumbBg, gr_ThumbBgSel,
    gr_ThumbFrame, gr_ThumbFrameSel, gr_ThumbCapBg, gr_ThumbCapBgSel, gr_RatingStar, gr_RatingStarEmpty);

  TTB_GraphicResources = class(Tpersistent)
  private
    fGradBg: TIEBitmap;
    fGradBgStartColor, fGradBgEndColor: TColor;
    fGradVertical: boolean;

    fDropShadow: TIEBitmap;
    fDropShadowSize: integer;

    fBMP_Bg: TIEBitmap;
    fbmp_Checked: TIEBitmap;
    fbmp_UnChecked: TIEBitmap;
    fbmp_Info: TIEBitmap;
    fBMP_Rotatebtns_Strip: TIEBitmap;
    fbmp_RotRight_Up: TIEBitmap;
    fbmp_RotRight_Down: TIEBitmap;
    fbmp_RotLeft_Up: TIEBitmap;
    fbmp_RotLeft_Down: TIEBitmap;
    fBMP_FolderUpLevel: TIEBitmap;
    fBMP_FolderNormal: TIEBitmap;
    fbmp_ThumbFrame: TIEBitmap;
    fbmp_ThumbFrameSelected: TIEBitmap;
    fbmp_ThumbCaptionBg: TIEBitmap;
    fbmp_ThumbCaptionBgSelected: TIEBitmap;
    fbmp_ThumbBg: TIEBitmap;
    fbmp_ThumbBgSelected: TIEBitmap;
    fbmp_RatingStarEmpty: TIEBitmap;
    fbmp_RatingStar: TIEBitmap;

    FHAS_Bg: boolean;
    FHAS_Checked: boolean;
    FHAS_UnChecked: boolean;
    FHAS_FolderUpLevel: boolean;
    fHas_FolderNormal: boolean;
    FHAS_Info: boolean;
    FHAS_RotRight_Up: boolean;
    FHAS_RotRight_Down: boolean;
    FHAS_RotLeft_Up: boolean;
    FHAS_RotLeft_Down: boolean;
    FHAS_Rotatebtns_Strip: boolean;

    FHAS_ThumbBg: boolean;
    FHAS_ThumbBgSelected: boolean;
    FHAS_ThumbFrame: boolean;
    FHAS_ThumbFrameSelected: boolean;
    FHAS_ThumbCaptionBg: boolean;
    FHAS_ThumbCaptionBgSelected: boolean;
    fHAS_RatingStar: boolean;
    fHAS_RatingStarEmpty: boolean;

    procedure Setbmp_Bg(Value: TIEBitmap);
    procedure Setbmp_Checked(Value: TIEBitmap);
    procedure Setbmp_UnChecked(Value: TIEBitmap);
    procedure SetBmpInfo(Value: TIEBitmap);
    procedure SetBMP_FolderUpLevel(Value: TIEBitmap);
    procedure SetBMP_FolderNormal(Value: TIEBitmap);

    procedure SetBMP_Rotatebtns_Strip(Value: TIEBitmap);
    procedure Setbmp_RotLeft_Down(const Value: TIEBitmap);
    procedure Setbmp_RotLeft_Up(const Value: TIEBitmap);
    procedure Setbmp_RotRight_Down(const Value: TIEBitmap);
    procedure Setbmp_RotRight_Up(const Value: TIEBitmap);

    procedure Setbmp_ThumbBg(const Value: TIEBitmap);
    procedure Setbmp_ThumbBgSelected(const Value: TIEBitmap);
    procedure Setbmp_ThumbCaptionBg(const Value: TIEBitmap);
    procedure Setbmp_ThumbCaptionBgSelected(const Value: TIEBitmap);
    procedure Setbmp_ThumbFrame(const Value: TIEBitmap);
    procedure Setbmp_ThumbFrameSelected(const Value: TIEBitmap);

    procedure AssignResource(resType: TTB_Thumb_GraphicResourceType; src: TObject;
      bConvertTranspToAlpha: boolean = False; TranspColor: TColor = clFuchsia); overload;
    procedure Setbmp_RatingStar(const Value: TIEBitmap);
    procedure Setbmp_RatingStarEmpty(const Value: TIEBitmap);

  public

    OnResourceChanged: TNotifyEvent;

    function GetGradientBg(w, h: integer; StartColor, EndColor: TColor; bVertical: boolean): TIEBitmap;
    function GetDropShadow(w, h: integer; dropsize: integer): TIEBitmap;

    constructor Create; reintroduce;
    destructor Destroy; override;
    procedure Assign(Source: Tpersistent); override;
    procedure LoadFromResources;

    procedure AssignResource(src: TIEBitmap; resType: TTB_Thumb_GraphicResourceType); overload;
    // order of parameters inverted to avoid conflicts with other overloaded

    property bmp_Bg: TIEBitmap read fBMP_Bg write Setbmp_Bg;
    property bmp_ThumbBg: TIEBitmap read fbmp_ThumbBg write Setbmp_ThumbBg;
    property bmp_ThumbBgSelected: TIEBitmap read fbmp_ThumbBgSelected write Setbmp_ThumbBgSelected;
    property bmp_ThumbFrame: TIEBitmap read fbmp_ThumbFrame write Setbmp_ThumbFrame;
    property bmp_ThumbFrameSelected: TIEBitmap read fbmp_ThumbFrameSelected write Setbmp_ThumbFrameSelected;
    property bmp_ThumbCaptionBg: TIEBitmap read fbmp_ThumbCaptionBg write Setbmp_ThumbCaptionBg;
    property bmp_ThumbCaptionBgSelected: TIEBitmap read fbmp_ThumbCaptionBgSelected write Setbmp_ThumbCaptionBgSelected;

    property bmp_Checked: TIEBitmap read fbmp_Checked write Setbmp_Checked;
    property bmp_UnChecked: TIEBitmap read fbmp_UnChecked write Setbmp_UnChecked;
    property bmp_Info: TIEBitmap read fbmp_Info write SetBmpInfo;
    property BMP_FolderUpLevel: TIEBitmap read fBMP_FolderUpLevel write SetBMP_FolderUpLevel;
    property BMP_FolderNormal: TIEBitmap read fBMP_FolderNormal write SetBMP_FolderNormal;
    property BMP_Rotatebtns_Strip: TIEBitmap read fBMP_Rotatebtns_Strip write SetBMP_Rotatebtns_Strip;

    property bmp_RotRight_Up: TIEBitmap read fbmp_RotRight_Up write Setbmp_RotRight_Up;
    property bmp_RotRight_Down: TIEBitmap read fbmp_RotRight_Down write Setbmp_RotRight_Down;
    property bmp_RotLeft_Up: TIEBitmap read fbmp_RotLeft_Up write Setbmp_RotLeft_Up;
    property bmp_RotLeft_Down: TIEBitmap read fbmp_RotLeft_Down write Setbmp_RotLeft_Down;

    property bmp_RatingStar: TIEBitmap read fbmp_RatingStar write Setbmp_RatingStar;
    property bmp_RatingStarEmpty: TIEBitmap read fbmp_RatingStarEmpty write Setbmp_RatingStarEmpty;

    property HAS_Bg: boolean read FHAS_Bg;

    property HAS_ThumbBg: boolean read FHAS_ThumbBg;
    property HAS_ThumbBgSelected: boolean read FHAS_ThumbBgSelected;
    property HAS_ThumbFrame: boolean read FHAS_ThumbFrame;
    property HAS_ThumbFrameSelected: boolean read FHAS_ThumbFrameSelected;
    property HAS_ThumbCaptionBg: boolean read FHAS_ThumbCaptionBg;
    property HAS_ThumbCaptionBgSelected: boolean read FHAS_ThumbCaptionBgSelected;

    property HAS_Checked: boolean read FHAS_Checked;
    property HAS_UnChecked: boolean read FHAS_UnChecked;
    property HAS_Info: boolean read FHAS_Info;
    property HAS_FolderUpLevel: boolean read FHAS_FolderUpLevel;
    property HAS_FolderNormal: boolean read fHas_FolderNormal;
    property HAS_Rotatebtns_Strip: boolean read FHAS_Rotatebtns_Strip;

    property HAS_RotRight_Up: boolean read FHAS_RotRight_Up;
    property HAS_RotRight_Down: boolean read FHAS_RotRight_Down;
    property HAS_RotLeft_Up: boolean read FHAS_RotLeft_Up;
    property HAS_RotLeft_Down: boolean read FHAS_RotLeft_Down;

  end;

  // --------------Browser---------------------------------------------------
  TTB_Browser_BackgroundType = (tbbgt_SolidColor, tbbgt_CheckBoard, tbbgt_Wallpaper, tbbgt_GradientH, tbbgt_GradientV);

  TTB_Browser_Style_CaptionOptions = class(Tpersistent)
  private
    fStyle: TTB_Thumb_CaptionStyle;
    fSizePerc_HorzLayout: cardinal;
    fNotifier: TNotifyEvent;
    fTextPadding: cardinal;

    procedure SetSizePerc_HorzLayout(const Value: cardinal);
    procedure SetStyle(const Value: TTB_Thumb_CaptionStyle);
    procedure SetTextPadding(const Value: cardinal);

  public
    Constructor Create(Notifier: TNotifyEvent);
  published
    property SizePerc_HorzLayout: cardinal read fSizePerc_HorzLayout write SetSizePerc_HorzLayout;
    property Style: TTB_Thumb_CaptionStyle read fStyle write SetStyle;
    property TextPadding: cardinal read fTextPadding write SetTextPadding;
  end;

  TTB_Browser_Style_ThemeElement = (thmele_CheckBox, thmele_InfoBox, thmele_RotateButtons);
  TTB_Browser_Style_ThemeElements = set of TTB_Browser_Style_ThemeElement;

  TTB_Browser_Style_ThemeElement_Info = record
    Size: TSize;
  end;

  TTB_Browser_Style_ThemeElement_InfoArray = array [low(TTB_Browser_Style_ThemeElement)
    .. high(TTB_Browser_Style_ThemeElement)] of TTB_Browser_Style_ThemeElement_Info;
  TTB_Browser_Style_ThemeColorOption = (thmcl_BrowserBg, thmcl_FrameBg, thmcl_FrameBgSel, thmcl_FrameBorder,
    thmcl_FrameBorderSel, thmcl_CaptionBg, thmcl_CaptionBgSel, thmcl_CaptionFont, thmcl_CaptionFontSel);
  TTB_Browser_Style_ThemeColorOptions = set of TTB_Browser_Style_ThemeColorOption;

  TTB_Browser_Style = (tbStyle_Custom, tbStyle_ThumbsH, tbStyle_ThumbsV, tbStyle_DetailsH, tbStyle_DetailsV,
    tbStyle_Columns);

  TTB_Browser_StyleOptions = class(Tpersistent)
  private
    fThemeEnabled: boolean;
    fThemeColorOptions: TTB_Browser_Style_ThemeColorOptions;
    fThemeElements: TTB_Browser_Style_ThemeElements;
    fThemeElementsInfos: TTB_Browser_Style_ThemeElement_InfoArray;
    fCaptionsOptions: TTB_Browser_Style_CaptionOptions;
    fNotifier: TNotifyEvent;
    fBrowserStyle: TTB_Browser_Style;
    procedure HandleNotification(sender: TObject);
    function GetThemeElementInfo(el: TTB_Browser_Style_ThemeElement): TTB_Browser_Style_ThemeElement_Info;
    procedure SetThemeColorOptions(const Value: TTB_Browser_Style_ThemeColorOptions);
    procedure SetThemeElements(const Value: TTB_Browser_Style_ThemeElements);
    procedure SetThemeEnabled(const Value: boolean);
    procedure SetBrowserStyle(const Value: TTB_Browser_Style);

  public
    Constructor Create(Notifier: TNotifyEvent);
    Destructor Destroy; override;
    procedure RefreshThemeInfo;
    property ThemeElementInfo[el: TTB_Browser_Style_ThemeElement]: TTB_Browser_Style_ThemeElement_Info
      read GetThemeElementInfo;
  published
    property BrowserStyle: TTB_Browser_Style read fBrowserStyle write SetBrowserStyle;
    property CaptionsOptions: TTB_Browser_Style_CaptionOptions read fCaptionsOptions write fCaptionsOptions;
    property ThemeEnabled: boolean read fThemeEnabled write SetThemeEnabled;
    property ThemeColorOptions: TTB_Browser_Style_ThemeColorOptions read fThemeColorOptions write SetThemeColorOptions;
    property ThemeElements: TTB_Browser_Style_ThemeElements read fThemeElements write SetThemeElements;

  end;

  TTB_Browser_WIA_Transfer_JpegQuality = (wtq_Png, wtq_Jpeg96, wtq_Jpeg90);

  TTB_Browser_InternetParams = class(Tpersistent)
  private
    FProxyPassword: string;
    FProxyAddress: string;
    FProxyUser: string;

  Published

    property ProxyAddress: string read FProxyAddress write FProxyAddress;
    property ProxyUser: string read FProxyUser write FProxyUser;
    property ProxyPassword: string read FProxyPassword write FProxyPassword;
  end;

  TTB_Browser_Orientation = (tbo_horz, tbo_vert);

  TTB_Browser_FileRecord_AddMode = (amAppend, amInsert, amReplace, amNoAction);
  TTB_Browser_InfoDlg_Mode = set of (tbi_editname, tbi_info, tbi_preview);
  TTB_Browser_InfoDlg_EditStatus = set of (tbiEdited_FileName, tbiEdited_MetaInfo);

  TTB_Browser_Loading_Range = record
    StartRange: integer;
    EndRange: integer;
  end;

  TTB_Browser_ScrollAmount = (sa_SmallAmount_Next, sa_SmallAmount_Prev, sa_LargeAmount_Next, sa_LargeAmount_Prev);

  TTB_Browser_FileReaderFunction = function(var bCanSaveToDB: boolean; theIEBMP: TIEBitmap; const theFileName: string;
    const thePicIdx: integer): boolean; // v.1.0.1

  TTB_Browser_FileFormat = record
    Extension: string;
    Description: string;
    IsMultiPicture: boolean;
    IsVideo: boolean;
    ReaderFunction: TTB_Browser_FileReaderFunction;
    GenericFile: boolean;
  end;
  // v.1.0.1

  TTB_Browser_PickCondition = (IfSelected, IfChecked, IfNo_condition);

  TTB_Browser_SortType = (stNameA, stNameD, stDateA, stDateD, stEXIFDateA, stEXIFDateD, stSizeA, stSizeD, stFolderA,
    stFolderD, stFileTypeA, stFileTypeD, stNameNaturalA, stNameNaturalD, stFolderNaturalA, stFolderNaturalD, stCustomA,
    stCustomD, stAsFromReportHeader, stNameWithPathA, stNameWithPathD, stNameWithPathNaturalA, stNameWithPathNaturalD,
    stTopTitleA, stTopTitleD, stBottomTitleA, stBottomTitleD, stNotSorted);

  // --------------Print---------------------------------------------------

  TTB_Print_Options = record
    ShowName: boolean;
    ShowDate: boolean;
    ShowSize: boolean;
    HasDropShadows: boolean;
  end;

  TTB_Print_Margins = record
    Left, Top, Right, Bottom: Double end;

    // ---------------Folder Monitor---------------------------------------------------------

{$IFDEF TB_FOLDERMONITOR}
    TThumbsBrowser_FolderMonitor_Item = class(TObject)private fAction: TWatchAction;
    FFileName: string;
  public
    property FileName: string read FFileName;
    property Action: TWatchAction read fAction;

    Constructor Create(theFileName: string; theAction: TWatchAction); reintroduce;
  end;

  TThumbsBrowser_FolderMonitor_Items = class(TObjectList)
  private
    function GetItems(idx: integer): TThumbsBrowser_FolderMonitor_Item;
  public
    property Items[idx: integer]: TThumbsBrowser_FolderMonitor_Item read GetItems; default;
  end;

  TThumbsBrowser_FolderMonitor_SuspendedItem = class
  private
    FFileName: string;
    fSuspendInterval: integer;
    fSuspensionStart: cardinal;
    fSuspendedActions: TWatchActions;
  public
    property FileName: string read FFileName;
    property SuspendInterval: integer read fSuspendInterval write fSuspendInterval;
    property SuspensionStart: cardinal read fSuspensionStart write fSuspensionStart;
    property SuspendedActions: TWatchActions read fSuspendedActions write fSuspendedActions;
    Constructor Create(theFileName: string; theSuspendInterval: integer; theSuspendedActions: TWatchActions = []);
      reintroduce;
  end;

{$ENDIF}
{$IFDEF TB_FOLDERMONITOR}

  TThumbsBrowser_FolderMonitor_Listener = class(TObject)
  public
    FileChangeNotifyHandler: TFileChangeNotifyEvent;
    ListeningObject: TObject;
    WatchOptions: TWatchOptions;
    WatchActions: TWatchActions;
    Monitors: TList;

    Constructor Create(TheFileChangeNotifyHandler: TFileChangeNotifyEvent; theListeningObject: TObject;
      theWatchOptions: TWatchOptions; theWatchActions: TWatchActions); reintroduce;

    destructor Destroy; override;

    procedure Notify(const sender: TObject; const Action: TWatchAction; const FileName: string);
  end;
{$ENDIF}
{$IFDEF TB_FOLDERMONITOR}

  TThumbsBrowser_FolderMonitor_Path = class(TObject)
  public
    Path: string;
    Listener: TThumbsBrowser_FolderMonitor_Listener;
    // ListeningObject: TObject;

    // Constructor Create(thePath:string; theListeningObject: TObject); reintroduce;
    Constructor Create(thePath: string; theListener: TThumbsBrowser_FolderMonitor_Listener); reintroduce;
  end;
{$ENDIF}
{$IFDEF TB_FOLDERMONITOR}

  TThumbsBrowser_FolderMonitor = class(TComponent)
  private
    fMonitors: TObjectList;
    fListeners: TObjectList;
    fPaths: TObjectList;

    procedure HandleMonitorNotify(const sender: TObject; const Action: TWatchAction; const FileName: string);

    function GetMonitor(idx: integer): TIEFolderWatch;
    function GetPath(idx: integer): TThumbsBrowser_FolderMonitor_Path;
    function GetListener(idx: integer): TThumbsBrowser_FolderMonitor_Listener;

    function FindListener(theListeningObject: TObject): TThumbsBrowser_FolderMonitor_Listener;
    function FindPath(thePath: string; theListeningObject: TObject): TThumbsBrowser_FolderMonitor_Path;

    function PathWatched(Path: string; theListener: TThumbsBrowser_FolderMonitor_Listener): boolean; overload;

    function FindCloserMonitor(Path: string; var sFoundPath: string): TIEFolderWatch; overload;

    function FindCloserMonitor(Path: string): TIEFolderWatch; overload;

    procedure AddMonitor(Listener: TThumbsBrowser_FolderMonitor_Listener; thePath: string; bSubTree: boolean); overload;
    function AddMonitor(thePath: string; bSubTree: boolean; theWatchOptions: TWatchOptions): TIEFolderWatch; overload;

    function FileNameInBrowsePaths(FileName: string; var ListOfListeningObjects: TList): boolean;

    procedure AddPath(Listener: TThumbsBrowser_FolderMonitor_Listener; thePath: string; theMonitor: TIEFolderWatch);

    procedure TryDeleteMonitor(Listener: TThumbsBrowser_FolderMonitor_Listener; thePath: string);
    function FindSuitableParentMonitor(Path: string): TIEFolderWatch;
    procedure ReplaceMonitor(aMonitor: TIEFolderWatch; const newPath: string; const bSubTree: boolean);
  protected

  public
    function PathWatched(Path: string; theListeningObject: TObject): boolean; overload;

    procedure StartWatching(ListeningObject: TObject; Path: string; bSubTree: boolean);
    procedure StopWatching(ListeningObject: TObject; Path: string); overload;
    procedure StopWatching(ListeningObject: TObject); overload;

    procedure AddListener(ListeningObject: TObject; FileChangeNotifyHandler: TFileChangeNotifyEvent;
      theWatchOptions: TWatchOptions; theWatchActions: TWatchActions);
    procedure RemoveListener(ListeningObject: TObject);

    procedure ChangeListenerProperties(ListeningObject: TObject; newOptions: TWatchOptions; newActions: TWatchActions);

    Constructor Create; reintroduce;
    Destructor Destroy; override;
  end;
{$ENDIF}

const
  CAP_LOW_IDX: integer = ord(low(TTB_Thumb_CaptionsSetting));

const
  CAP_HIGH_IDX: integer = ord(high(TTB_Thumb_CaptionsSetting));

function TBMetaDataReadFieldAsStr(params: TIOParams; FieldType: TThumbsbrowser_MetaData_Type; fieldNr: integer;
  theTags: TThumbsbrowser_MetaTags): string;

procedure TBMetaDataWriteFieldAsStr(params: TIOParams; FieldType: TThumbsbrowser_MetaData_Type; fieldNr: integer;
  theValue: string; theTags: TThumbsbrowser_MetaTags); overload;

procedure TBMetaDataWriteFieldAsStr(aio: TImageenio; FieldType: TThumbsbrowser_MetaData_Type; fieldNr: integer;
  theValue: string; theTags: TThumbsbrowser_MetaTags); overload;

function TBIsCaptionGeneral(cap: TTB_Thumb_CaptionsSetting): boolean;

implementation

uses NWSComps_ThumbsBrowser_RES_CONST,
  NWSComps_ThumbsBrowser_RES,
  NWSComps_ThumbsBrowser_Utils_Const,
  NWSComps_ThumbsBrowser_Shell_Utils,
  NWSComps_StyleEngine;

function LUT_EXIF_STRID(Rcd: integer): integer;
begin
  result := -1;

  case Rcd of
    IDX_EXIF_UserComment:
      result := IDRS_EXIF_UserComment;
    IDX_EXIF_ImageDescription:
      result := IDRS_EXIF_ImageDescription;
    IDX_EXIF_CameraMake:
      result := IDRS_EXIF_CameraMake;
    IDX_EXIF_CameraModel:
      result := IDRS_EXIF_CameraModel;
    IDX_EXIF_XResolution:
      result := IDRS_EXIF_XResolution;
    IDX_EXIF_YResolution:
      result := IDRS_EXIF_YResolution;
    IDX_EXIF_DateTime:
      result := IDRS_EXIF_DateTime;
    IDX_EXIF_DateTimeOriginal:
      result := IDRS_EXIF_DateTimeOriginal;
    IDX_EXIF_DateTimeDigitized:
      result := IDRS_EXIF_DateTimeDigitized;
    IDX_EXIF_Copyright:
      result := IDRS_EXIF_Copyright;
    IDX_EXIF_Orientation:
      result := IDRS_EXIF_Orientation;
    IDX_EXIF_ExposureTime:
      result := IDRS_EXIF_ExposureTime;
    IDX_EXIF_FNumber:
      result := IDRS_EXIF_FNumber;
    IDX_EXIF_ExposureProgram:
      result := IDRS_EXIF_ExposureProgram;
    IDX_EXIF_ISOSpeedRatings:
      result := IDRS_EXIF_ISOSpeedRatings;
    IDX_EXIF_ShutterSpeedValue:
      result := IDRS_EXIF_ShutterSpeedValue;
    IDX_EXIF_ApertureValue:
      result := IDRS_EXIF_ApertureValue;
    IDX_EXIF_BrightnessValue:
      result := IDRS_EXIF_BrightnessValue;
    IDX_EXIF_ExposureBiasValue:
      result := IDRS_EXIF_ExposureBiasValue;
    IDX_EXIF_MaxApertureValue:
      result := IDRS_EXIF_MaxApertureValue;
    IDX_EXIF_SubjectDistance:
      result := IDRS_EXIF_SubjectDistance;
    IDX_EXIF_MeteringMode:
      result := IDRS_EXIF_MeteringMode;
    IDX_EXIF_LightSource:
      result := IDRS_EXIF_LightSource;
    IDX_EXIF_Flash:
      result := IDRS_EXIF_Flash;
    IDX_EXIF_FocalLength:
      result := IDRS_EXIF_FocalLength;
    IDX_EXIF_FlashPixVersion:
      result := IDRS_EXIF_FlashPixVersion;
    IDX_EXIF_ColorSpace:
      result := IDRS_EXIF_ColorSpace;
    IDX_EXIF_ExifImageWidth:
      result := IDRS_EXIF_ExifImageWidth;
    IDX_EXIF_ExifImageHeight:
      result := IDRS_EXIF_ExifImageHeight;
    IDX_EXIF_RelatedSoundFile:
      result := IDRS_EXIF_RelatedSoundFile;
    IDX_EXIF_FocalPlaneXResolution:
      result := IDRS_EXIF_FocalPlaneXResolution;
    IDX_EXIF_FocalPlaneYResolution:
      result := IDRS_EXIF_FocalPlaneYResolution;
    IDX_EXIF_ExposureIndex:
      result := IDRS_EXIF_ExposureIndex;
    IDX_EXIF_SensingMethod:
      result := IDRS_EXIF_SensingMethod;
    IDX_EXIF_FileSource:
      result := IDRS_EXIF_FileSource;
    IDX_EXIF_SceneType:
      result := IDRS_EXIF_SceneType;
    IDX_EXIF_YCbCrPositioning:
      result := IDRS_EXIF_YCbCrPositioning;
    IDX_EXIF_ExposureMode:
      result := IDRS_EXIF_ExposureMode;
    IDX_EXIF_WhiteBalance:
      result := IDRS_EXIF_WhiteBalance;
    IDX_EXIF_DigitalZoomRatio:
      result := IDRS_EXIF_DigitalZoomRatio;
    IDX_EXIF_FocalLengthIn35mmFilm:
      result := IDRS_EXIF_FocalLengthIn35mmFilm;
    IDX_EXIF_SceneCaptureType:
      result := IDRS_EXIF_SceneCaptureType;
    IDX_EXIF_GainControl:
      result := IDRS_EXIF_GainControl;
    IDX_EXIF_Contrast:
      result := IDRS_EXIF_Contrast;
    IDX_EXIF_Saturation:
      result := IDRS_EXIF_Saturation;
    IDX_EXIF_Sharpness:
      result := IDRS_EXIF_Sharpness;
    IDX_EXIF_SubjectDistanceRange:
      result := IDRS_EXIF_SubjectDistanceRange;
    IDX_EXIF_GPSLatitude:
      result := IDRS_EXIF_GPSLatitude;
    IDX_EXIF_GPSLongitude:
      result := IDRS_EXIF_GPSLongitude;
    IDX_EXIF_GPSAltitude:
      result := IDRS_EXIF_GPSAltitude;
    IDX_EXIF_GPSImageDirection:
      result := IDRS_EXIF_GPSImageDirection;
    IDX_EXIF_GPSTrack:
      result := IDRS_EXIF_GPSTrack;
    IDX_EXIF_GPSSpeed:
      result := IDRS_EXIF_GPSSpeed;
    IDX_EXIF_GPSDateAndTime:
      result := IDRS_EXIF_GPSDateAndTime;
    IDX_EXIF_GPSSatellites:
      result := IDRS_EXIF_GPSSatellites;
    IDX_EXIF_GPSVersionID:
      result := IDRS_EXIF_GPSVersionID;
    IDX_EXIF_Artist:
      result := IDRS_EXIF_Artist;
    IDX_EXIF_XPTitle:
      result := IDRS_EXIF_XPTitle;
    IDX_EXIF_XPComment:
      result := IDRS_EXIF_XPComment;
    IDX_EXIF_XPAuthor:
      result := IDRS_EXIF_XPAuthor;
    IDX_EXIF_XPKeywords:
      result := IDRS_EXIF_XPKeywords;
    IDX_EXIF_XPSubject:
      result := IDRS_EXIF_XPSubject;
    IDX_EXIF_XPRating:
      result := IDRS_EXIF_XPRating;
    IDX_EXIF_InteropVersion:
      result := IDRS_EXIF_InteropVersion;
    IDX_EXIF_CameraOwnerName:
      result := IDRS_EXIF_CameraOwnerName;
    IDX_EXIF_BodySerialNumber:
      result := IDRS_EXIF_BodySerialNumber;
    IDX_EXIF_LensMake:
      result := IDRS_EXIF_LensMake;
    IDX_EXIF_LensModel:
      result := IDRS_EXIF_LensModel;
    IDX_EXIF_LensSerialNumber:
      result := IDRS_EXIF_LensSerialNumber;
    IDX_EXIF_Gamma:
      result := IDRS_EXIF_Gamma;
    IDX_EXIF_SubjectArea:
      result := IDRS_EXIF_SubjectArea;
    IDX_EXIF_SubjectLocation:
      result := IDRS_EXIF_SubjectLocation;
  end;
end;

function LUT_IPTC_STRID(Rcd, DSet: integer): integer;
begin
  result := -1;
  if Rcd = PhotoShop_IPTC_Records then
  begin
    case DSet of
      IPTC_PS_Title:
        result := IDRS_IPTCTAG_PS_Title;
      IPTC_PS_Caption:
        result := IDRS_IPTCTAG_PS_Caption;
      IPTC_PS_Keywords:
        result := IDRS_IPTCTAG_PS_Keywords;
      IPTC_PS_Instructions:
        result := IDRS_IPTCTAG_PS_Instructions;
      IPTC_PS_Date_Created:
        result := IDRS_IPTCTAG_PS_Date_Created;
      IPTC_PS_Time_Created:
        result := IDRS_IPTCTAG_PS_Time_Created;
      IPTC_PS_Byline_1:
        result := IDRS_IPTCTAG_PS_ByLine1;
      IPTC_PS_Byline_2:
        result := IDRS_IPTCTAG_PS_ByLine2;
      IPTC_PS_City:
        result := IDRS_IPTCTAG_PS_City;
      IPTC_PS_State_Province:
        result := IDRS_IPTCTAG_PS_State;
      IPTC_PS_Country_Code:
        result := IDRS_IPTCTAG_PS_Country_Code;
      IPTC_PS_Country:
        result := IDRS_IPTCTAG_PS_Country_Name;
      IPTC_PS_Transmission_Reference:
        result := IDRS_IPTCTAG_PS_TransmissionRef;
      IPTC_PS_Credit:
        result := IDRS_IPTCTAG_PS_Credit;
      IPTC_PS_Writer:
        result := IDRS_IPTCTAG_PS_Editor;
      IPTC_PS_Edit_Status:
        result := IDRS_IPTCTAG_PS_EditStatus;
      IPTC_PS_Urgency:
        result := IDRS_IPTCTAG_PS_Urgency;
      IPTC_PS_Category:
        result := IDRS_IPTCTAG_PS_Category;
      IPTC_PS_Category_2:
        result := IDRS_IPTCTAG_PS_SupplCategory;
      IPTC_PS_Fixture_Identifier:
        result := IDRS_IPTCTAG_PS_FixtureID;
      IPTC_PS_Release_Date:
        result := IDRS_IPTCTAG_PS_ReleaseDate;
      IPTC_PS_Release_Time:
        result := IDRS_IPTCTAG_PS_ReleaseTime;
      IPTC_PS_Reference_Service:
        result := IDRS_IPTCTAG_PS_ReferenceService;
      IPTC_PS_Reference_Date:
        result := IDRS_IPTCTAG_PS_ReferenceDate;
      IPTC_PS_Reference_Number:
        result := IDRS_IPTCTAG_PS_ReferenceNumber;
      IPTC_PS_Originating_Program:
        result := IDRS_IPTCTAG_PS_OrigProgram;
      IPTC_PS_Program_Version:
        result := IDRS_IPTCTAG_PS_ProgVersion;
      IPTC_PS_Object_Cycle:
        result := IDRS_IPTCTAG_PS_ObjectCycle;
      IPTC_PS_Image_Type:
        result := IDRS_IPTCTAG_PS_ImageType;
      IPTC_PS_Copyright_Notice:
        result := IDRS_IPTCTAG_PS_CopyrightNotice;
    end;
  end;
end;

function LUT_XMP_STRID(XMP_ID: string): integer;
begin
  result := -1;
{$IFDEF NWSCOMPS_TB_METADATA_USEHELPERS}
  if XMP_ID = XMP_Aux_ApproximateFocusDistance then
    result := IDRS_XMP_Aux_ApproximateFocusDistance
  else if XMP_ID = XMP_Aux_Firmware then
    result := IDRS_XMP_Aux_Firmware
  else if XMP_ID = XMP_Aux_FlashCompensation then
    result := IDRS_XMP_Aux_FlashCompensation
  else if XMP_ID = XMP_Aux_ImageNumber then
    result := IDRS_XMP_Aux_ImageNumber
  else if XMP_ID = XMP_Aux_Lens then
    result := IDRS_XMP_Aux_Lens
  else if XMP_ID = XMP_Aux_LensID then
    result := IDRS_XMP_Aux_LensID
  else if XMP_ID = XMP_Aux_LensInfo then
    result := IDRS_XMP_Aux_LensInfo
  else if XMP_ID = XMP_Aux_LensSerialNumber then
    result := IDRS_XMP_Aux_LensSerialNumber
  else if XMP_ID = XMP_Aux_OwnerName then
    result := IDRS_XMP_Aux_OwnerName
  else if XMP_ID = XMP_Aux_SerialNumber then
    result := IDRS_XMP_Aux_SerialNumber
  else if XMP_ID = XMP_CC_AttributionName then
    result := IDRS_XMP_CC_AttributionName
  else if XMP_ID = XMP_CC_AttributionURL then
    result := IDRS_XMP_CC_AttributionURL
  else if XMP_ID = XMP_CC_DeprecatedOn then
    result := IDRS_XMP_CC_DeprecatedOn
  else if XMP_ID = XMP_CC_Jurisdiction then
    result := IDRS_XMP_CC_Jurisdiction
  else if XMP_ID = XMP_CC_LegalCode then
    result := IDRS_XMP_CC_LegalCode
  else if XMP_ID = XMP_CC_License then
    result := IDRS_XMP_CC_License
  else if XMP_ID = XMP_CC_MorePermissions then
    result := IDRS_XMP_CC_MorePermissions
  else if XMP_ID = XMP_CC_Permits then
    result := IDRS_XMP_CC_Permits
  else if XMP_ID = XMP_CC_Prohibits then
    result := IDRS_XMP_CC_Prohibits
  else if XMP_ID = XMP_CC_Requires then
    result := IDRS_XMP_CC_Requires
  else if XMP_ID = XMP_CC_UseGuidelines then
    result := IDRS_XMP_CC_UseGuidelines
  else if XMP_ID = XMP_DC_Contributor then
    result := IDRS_XMP_DC_Contributor
  else if XMP_ID = XMP_DC_Coverage then
    result := IDRS_XMP_DC_Coverage
  else if XMP_ID = XMP_DC_Creator then
    result := IDRS_XMP_DC_Creator
  else if XMP_ID = XMP_DC_Date then
    result := IDRS_XMP_DC_Date
  else if XMP_ID = XMP_DC_Description then
    result := IDRS_XMP_DC_Description
  else if XMP_ID = XMP_DC_Format then
    result := IDRS_XMP_DC_Format
  else if XMP_ID = XMP_DC_Identifier then
    result := IDRS_XMP_DC_Identifier
  else if XMP_ID = XMP_DC_Language then
    result := IDRS_XMP_DC_Language
  else if XMP_ID = XMP_DC_Publisher then
    result := IDRS_XMP_DC_Publisher
  else if XMP_ID = XMP_DC_Relation then
    result := IDRS_XMP_DC_Relation
  else if XMP_ID = XMP_DC_Rights then
    result := IDRS_XMP_DC_Rights
  else if XMP_ID = XMP_DC_Source then
    result := IDRS_XMP_DC_Source
  else if XMP_ID = XMP_DC_Subject then
    result := IDRS_XMP_DC_Subject
  else if XMP_ID = XMP_DC_Title then
    result := IDRS_XMP_DC_Title
  else if XMP_ID = XMP_DC_Type then
    result := IDRS_XMP_DC_Type
  else if XMP_ID = XMP_Photoshop_AuthorsPosition then
    result := IDRS_XMP_Photoshop_AuthorsPosition
  else if XMP_ID = XMP_Photoshop_CaptionWriter then
    result := IDRS_XMP_Photoshop_CaptionWriter
  else if XMP_ID = XMP_Photoshop_Category then
    result := IDRS_XMP_Photoshop_Category
  else if XMP_ID = XMP_Photoshop_City then
    result := IDRS_XMP_Photoshop_City
  else if XMP_ID = XMP_Photoshop_Country then
    result := IDRS_XMP_Photoshop_Country
  else if XMP_ID = XMP_Photoshop_Credit then
    result := IDRS_XMP_Photoshop_Credit
  else if XMP_ID = XMP_Photoshop_DateCreated then
    result := IDRS_XMP_Photoshop_DateCreated
  else if XMP_ID = XMP_Photoshop_DocumentAncestorID then
    result := IDRS_XMP_Photoshop_DocumentAncestorID
  else if XMP_ID = XMP_Photoshop_Headline then
    result := IDRS_XMP_Photoshop_Headline
  else if XMP_ID = XMP_Photoshop_History then
    result := IDRS_XMP_Photoshop_History
  else if XMP_ID = XMP_Photoshop_ICCProfileName then
    result := IDRS_XMP_Photoshop_ICCProfileName
  else if XMP_ID = XMP_Photoshop_Instructions then
    result := IDRS_XMP_Photoshop_Instructions
  else if XMP_ID = XMP_Photoshop_Source then
    result := IDRS_XMP_Photoshop_Source
  else if XMP_ID = XMP_Photoshop_State then
    result := IDRS_XMP_Photoshop_State
  else if XMP_ID = XMP_Photoshop_SupplementalCategories then
    result := IDRS_XMP_Photoshop_SupplementalCategories
  else if XMP_ID = XMP_Photoshop_TextLayerName then
    result := IDRS_XMP_Photoshop_TextLayerName
  else if XMP_ID = XMP_Photoshop_TextLayerText then
    result := IDRS_XMP_Photoshop_TextLayerText
  else if XMP_ID = XMP_Photoshop_TransmissionReference then
    result := IDRS_XMP_Photoshop_TransmissionReference
  else if XMP_ID = XMP_Photoshop_Urgency then
    result := IDRS_XMP_Photoshop_Urgency
  else if XMP_ID = XMP_Advisory then
    result := IDRS_XMP_Advisory
  else if XMP_ID = XMP_Author then
    result := IDRS_XMP_Author
  else if XMP_ID = XMP_BaseURL then
    result := IDRS_XMP_BaseURL
  else if XMP_ID = XMP_CreateDate then
    result := IDRS_XMP_CreateDate
  else if XMP_ID = XMP_CreatorTool then
    result := IDRS_XMP_CreatorTool
  else if XMP_ID = XMP_Description then
    result := IDRS_XMP_Description
  else if XMP_ID = XMP_Format then
    result := IDRS_XMP_Format
  else if XMP_ID = XMP_Identifier then
    result := IDRS_XMP_Identifier
  else if XMP_ID = XMP_Keywords then
    result := IDRS_XMP_Keywords
  else if XMP_ID = XMP_Label then
    result := IDRS_XMP_Label
  else if XMP_ID = XMP_MetadataDate then
    result := IDRS_XMP_MetadataDate
  else if XMP_ID = XMP_ModifyDate then
    result := IDRS_XMP_ModifyDate
  else if XMP_ID = XMP_Nickname then
    result := IDRS_XMP_Nickname
  else if XMP_ID = XMP_Rating then
    result := IDRS_XMP_Rating
  else if XMP_ID = XMP_Title then
    result := IDRS_XMP_Title;

{$ENDIF}
end;

function TBMetaDataReadFieldAsStr(params: TIOParams; FieldType: TThumbsbrowser_MetaData_Type; fieldNr: integer;
  theTags: TThumbsbrowser_MetaTags): string;
  function FindIptcIdx(Rec, DSet: integer): integer;
  var
    i: integer;
  begin
    result := -1;
    for i := 0 to params.IPTC_Info.Count - 1 do
    begin
      if (params.IPTC_Info.RecordNumber[i] = Rec) and (params.IPTC_Info.DataSet[i] = DSet) then
      begin
        result := i;
        break;
      end;
    end;
  end;

  function AddCommonTagValue(const s, sValue, SEP: string): string;
  begin
    if sValue = '' then
      result := s
    else
    begin
      if s = '' then
        result := s + sValue
      else
      begin
        if Pos(sValue, s) = 0 then // if the value is not included then add it
          result := s + SEP + sValue
        else
          result := s; // otherwise result is the source string
      end;
    end;

  end;

var
  ieIdx, i: integer;
  iptcTag: TTBIptcTag;
  iptcFieldNr: integer;
  exifTag: TTBExifTag;
  exifFieldNr: integer;
  xmpTag: TTBXmpTag;
  xmpFieldNr: integer;
  sValue: string;
begin
  result := '';
  case FieldType of
    mdft_Common:
      begin
        result := '';
        for i := 0 to theTags.CommonTags[fieldNr].LinkedEXIFTags.Count - 1 do
        begin
          exifTag := theTags.CommonTags[fieldNr].LinkedEXIFTags[i];
          exifFieldNr := theTags.ExifTags.GetTagIdx(exifTag);

          sValue := TBMetaDataReadFieldAsStr(params, mdft_Exif, exifFieldNr, theTags);
          result := AddCommonTagValue(result, sValue, theTags.CommonTags.SEP);
        end;
        for i := 0 to theTags.CommonTags[fieldNr].LinkedIPTCTags.Count - 1 do
        begin
          iptcTag := theTags.CommonTags[fieldNr].LinkedIPTCTags[i];
          iptcFieldNr := theTags.IptcTags.GetTagIdx(iptcTag);
          sValue := TBMetaDataReadFieldAsStr(params, mdft_Iptc, iptcFieldNr, theTags);
          result := AddCommonTagValue(result, sValue, theTags.CommonTags.SEP);
        end;
        for i := 0 to theTags.CommonTags[fieldNr].LinkedXMPTags.Count - 1 do
        begin
          xmpTag := theTags.CommonTags[fieldNr].LinkedXMPTags[i];
          xmpFieldNr := theTags.XmpTags.GetTagIdx(xmpTag);
          sValue := TBMetaDataReadFieldAsStr(params, mdft_Xmp, xmpFieldNr, theTags);
          result := AddCommonTagValue(result, sValue, theTags.CommonTags.SEP);
        end;
      end;
    mdft_Exif:
      begin
        ieIdx := theTags.ExifTags[fieldNr].idx;
        try
          result := params.EXIF_AsStr[ieIdx];
        except
          ;
        end;
      end;
    mdft_Iptc:
      begin
{$IFDEF NWSCOMPS_TB_METADATA_USEHELPERS}
        result := params.ReadIPTCField(theTags.IptcTags[fieldNr].Rec, theTags.IptcTags[fieldNr].DSet);
{$ELSE}
        result := params.IPTC_Info.StringItem[FindIptcIdx(theTags.IptcTags[fieldNr].Rec,
          theTags.IptcTags[fieldNr].DSet)]
{$ENDIF}
      end;
    mdft_Xmp:
      begin
{$IFDEF NWSCOMPS_TB_METADATA_USEHELPERS}
        result := params.XMP_AsStr[theTags.XmpTags[fieldNr].Name]; // xmp was not introduced before the metahelpers
{$ENDIF}
      end;
    mdft_Dicom:
      begin
        ieIdx := fieldNr; // in this case we use directly the field number because dicom tags are the same as ie
        result := params.DICOM_Tags.GetTagString(ieIdx);
      end;
  end;

  result := trim(result);
end;

procedure TBMetaDataWriteFieldAsStr(params: TIOParams; FieldType: TThumbsbrowser_MetaData_Type; fieldNr: integer;
  theValue: string; theTags: TThumbsbrowser_MetaTags);
var
  ieIdx: integer;

  i: integer;
  iptcTag: TTBIptcTag;
  iptcFieldNr: integer;
  exifTag: TTBExifTag;
  exifFieldNr: integer;
  xmpTag: TTBXmpTag;
  xmpFieldNr: integer;
begin

  case FieldType of
    mdft_Common:
      begin
        for i := 0 to theTags.CommonTags[fieldNr].LinkedEXIFTags.Count - 1 do
        begin
          exifTag := theTags.CommonTags[fieldNr].LinkedEXIFTags[i];
          exifFieldNr := theTags.ExifTags.GetTagIdx(exifTag);
          TBMetaDataWriteFieldAsStr(params, mdft_Exif, exifFieldNr, theValue, theTags);
        end;
        for i := 0 to theTags.CommonTags[fieldNr].LinkedIPTCTags.Count - 1 do
        begin
          iptcTag := theTags.CommonTags[fieldNr].LinkedIPTCTags[i];
          iptcFieldNr := theTags.IptcTags.GetTagIdx(iptcTag);
          TBMetaDataWriteFieldAsStr(params, mdft_Iptc, iptcFieldNr, theValue, theTags);
        end;
        for i := 0 to theTags.CommonTags[fieldNr].LinkedXMPTags.Count - 1 do
        begin
          xmpTag := theTags.CommonTags[fieldNr].LinkedXMPTags[i];
          xmpFieldNr := theTags.XmpTags.GetTagIdx(xmpTag);
          TBMetaDataWriteFieldAsStr(params, mdft_Xmp, xmpFieldNr, theValue, theTags);
        end;
      end;
    mdft_Exif:
      begin
        ieIdx := theTags.ExifTags[fieldNr].idx;
{$IFDEF NWSCOMPS_TB_METADATA_USEHELPERS}
        params.EXIF_AsStr[ieIdx] := theValue;
{$ELSE}
        aio := TImageenio.Create(nil);
        try
          aio.params.Assign(params);
          SetEXIFField(aio, f.idx, theValue);
          params.Assign(aio.params);
        finally
          aio.free;
        end;
{$ENDIF}
      end;
    mdft_Iptc:
      begin
        params.WriteIPTCField(theTags.IptcTags[fieldNr].Rec, theTags.IptcTags[fieldNr].DSet, theValue);
      end;
    mdft_Xmp:
      begin
        // write not supported
      end;
    mdft_Dicom:
      begin
        // write not supported
      end;
  end;

end;

procedure TBMetaDataWriteFieldAsStr(aio: TImageenio; FieldType: TThumbsbrowser_MetaData_Type; fieldNr: integer;
  theValue: string; theTags: TThumbsbrowser_MetaTags);
begin
  case FieldType of
    mdft_Common:
      begin
        TBMetaDataWriteFieldAsStr(aio.params, FieldType, fieldNr, theValue, theTags);
      end;
    mdft_Exif:
      begin
{$IFDEF NWSCOMPS_TB_METADATA_USEHELPERS}
        TBMetaDataWriteFieldAsStr(aio.params, FieldType, fieldNr, theValue, theTags);
{$ELSE}
        ieIdx := theTags.ExifTags[fieldNr].idx;
        SetEXIFField(aio, f.idx, theValue);
{$ENDIF}
      end;
    mdft_Iptc:
      begin
        TBMetaDataWriteFieldAsStr(aio.params, FieldType, fieldNr, theValue, theTags);
      end;
    mdft_Xmp:
      begin
        TBMetaDataWriteFieldAsStr(aio.params, FieldType, fieldNr, theValue, theTags);
      end;
    mdft_Dicom:
      begin
        TBMetaDataWriteFieldAsStr(aio.params, FieldType, fieldNr, theValue, theTags);
      end;
  end;

end;

function TTBExifTag_ParseString(const TagStr: string; var theIdx: integer; var theDescr: string): boolean;
var
  s, subs: string;
  posSep: integer;

begin
  result := False;

  s := TagStr;

  // get the Rec
  posSep := Pos(EXIFSEP, s);
  if posSep <= 1 then
    EXIT; // >>>EXIT invalid string: cannot parse

  try
    subs := copy(s, 1, posSep - 1); // get the substring containing the value
    s := copy(s, posSep + 1, length(s) - length(subs + EXIFSEP));

    theIdx := strtoint(subs);
  except
    // showmessage(s + ' ' + subs);
    EXIT; // >>>EXIT invalid string: cannot parse
  end;

  // get the description
  theDescr := s;
  result := true;
end;

function TTBExifTag_GetTagAsStr(theTag: TTBExifTag): string;
begin
  result := inttostr(theTag.idx) + EXIFSEP + theTag.Desc;
end;

function TTBExifTag_CreateTagByParsing(const TagStr: string): TTBExifTag;
var
  theIdx: integer;
  theDescr: string;
  bParsed: boolean;
begin
  bParsed := TTBExifTag_ParseString(TagStr, theIdx, theDescr);
  if bParsed then
  begin
    result := TTBExifTag.Create(theIdx, theDescr);
  end
  else
    result := nil;
end;

function TTBIptcTag_GetTagAsStr(theTag: TTBIptcTag): string;
begin
  result := inttostr(theTag.Rec) + IPTCSEP + inttostr(theTag.DSet) + IPTCSEP + theTag.Desc;
end;

function TTBIptcTag_ParseString(const TagStr: string; var theRec, theDSet: integer; var theDescr: string): boolean;
var
  s, subs: string;
  posSep: integer;

begin
  result := False;

  s := TagStr;

  // get the Rec
  posSep := Pos(IPTCSEP, s);
  if posSep <= 1 then
    EXIT; // >>>EXIT invalid string: cannot parse

  try
    subs := copy(s, 1, posSep - 1); // get the substring containing the value
    s := copy(s, posSep + 1, length(s) - length(subs + IPTCSEP));

    theRec := strtoint(subs);
  except
    // showmessage(s + ' ' + subs);
    EXIT; // >>>EXIT invalid string: cannot parse
  end;

  // get the DSet
  posSep := Pos(IPTCSEP, s);
  if posSep <= 1 then
    EXIT; // >>>EXIT invalid string: cannot parse

  try
    subs := copy(s, 1, posSep - 1); // get the substring containing the value
    s := copy(s, posSep + 1, length(s) - length(subs + IPTCSEP));

    theDSet := strtoint(subs);
  except
    // showmessage(s + ' ' + subs);
    EXIT; // >>>EXIT invalid string: cannot parse
  end;

  // get the description
  theDescr := s;
  result := true;
end;

function TTBIptcTag_CreateTagByParsing(const TagStr: string): TTBIptcTag;
var
  theRec, theDSet: integer;
  theDescr: string;
  bParsed: boolean;
begin
  bParsed := TTBIptcTag_ParseString(TagStr, theRec, theDSet, theDescr);
  if bParsed then
  begin
    result := TTBIptcTag.Create(theRec, theDSet, theDescr);
  end
  else
    result := nil;
end;

function TTBXmpTag_GetTagAsStr(theTag: TTBXmpTag): string;
begin
  result := theTag.Name + XMPSEP + theTag.Desc;
end;

function TTBXmpTag_ParseString(const TagStr: string; var theName, theDesc: string): boolean;
var
  s, subs: string;
  posSep: integer;
begin
  result := False;

  s := TagStr;

  // get the Name
  posSep := Pos(XMPSEP, s);
  if posSep <= 1 then
    EXIT; // >>>EXIT invalid string: cannot parse

  try
    subs := copy(s, 1, posSep - 1); // get the substring containing the value
    s := copy(s, posSep + 1, length(s) - length(subs + XMPSEP));

    theName := subs;
  except
    // showmessage(s + ' ' + subs);
    EXIT; // >>>EXIT invalid string: cannot parse
  end;
  // get the description
  theDesc := s;
  result := true;
end;

function TTBXmpTag_CreateTagByParsing(const TagStr: string): TTBXmpTag;
var
  theName: string;
  theDescr: string;
  bParsed: boolean;
begin
  bParsed := TTBXmpTag_ParseString(TagStr, theName, theDescr);
  if bParsed then
  begin
    result := TTBXmpTag.Create(theName, theDescr);
  end
  else
    result := nil;
end;

function TTBCommonTag_GetTagAsStr(theTag: TTBCommonTag): string;
var
  i: integer;
begin
  result := '';

  if theTag = nil then
    EXIT;

  if assigned(theTag.LinkedEXIFTags) then
  begin
    for i := 0 to theTag.LinkedEXIFTags.Count - 1 do
    begin
      result := result + COM_TAGID_EXIF;
      result := result + COM_TAGSEP_OP;
      result := result + TTBExifTag_GetTagAsStr(theTag.LinkedEXIFTags[i]);
      result := result + COM_TAGSEP_CL;
    end;
  end;

  if assigned(theTag.LinkedIPTCTags) then
  begin
    for i := 0 to theTag.LinkedIPTCTags.Count - 1 do
    begin
      result := result + COM_TAGID_IPTC;
      result := result + COM_TAGSEP_OP;
      result := result + TTBIptcTag_GetTagAsStr(theTag.LinkedIPTCTags[i]);
      result := result + COM_TAGSEP_CL;
    end;
  end;

  if assigned(theTag.LinkedXMPTags) then
  begin
    for i := 0 to theTag.LinkedXMPTags.Count - 1 do
    begin
      result := result + COM_TAGID_XMP;
      result := result + COM_TAGSEP_OP;
      result := result + TTBXmpTag_GetTagAsStr(theTag.LinkedXMPTags[i]);
      result := result + COM_TAGSEP_CL;
    end;
  end;

  // [IPTC][2|25|DescrIptc]
  // [EXIF][2|DescrExif]
  // [XMP][XmpName|DescrXmp]
  // [DICOM][Group|Element|DescrDicom] // (Group: $0000; Element: $0000;

end;

function TTBCommonTag_FindFirstTag(TagID: string; s: string; var sTag: string; var posStart, posEnd: integer): boolean;
var
  i: integer;
begin
  result := False;
  i := Pos(TagID, s);
  if i = 0 then
    result := False
  else
  begin
    i := i + length(TagID);
    if s[i] <> COM_TAGSEP_OP then
      result := False
    else
    begin

      posStart := i;
      inc(i);
      while (i <= length(s)) do
      begin
        if s[i] = COM_TAGSEP_CL then
        begin
          result := true;
          posEnd := i;
          sTag := copy(s, posStart + 1, (posEnd - 1) - (posStart + 1) + 1);
          break;
        end;
        inc(i)
      end;

    end;
  end;
end;

function TTBCommonTag_ParseString(const TagStr: string; var theExifTags: TTBExifTags; var theIptcTags: TTBIptcTags;
  var theXmpTags: TTBXmpTags; var theDesc: string): boolean; overload;
var
  s, sTag: string;
  sl: Tstringlist;
  posStart, posEnd: integer;
  i: integer;
  aIptcTag: TTBIptcTag;
  aExifTag: TTBExifTag;
  aXmpTag: TTBXmpTag;
  firstFound, lastFound: integer;
begin

  result := False;

  sl := Tstringlist.Create;
  try
    firstFound := 0;
    lastFound := -1;

    // EXIF Tags Parsing------------------------------------------------------------------------
    // {EXIF}[2|25|DescrExif]
    // ^              ^
    // posStart        posEnd
    // start and end are the positions where the [ and ] symbols are
    // first get the various tags separated into a stringlist

    s := TagStr;
    while TTBCommonTag_FindFirstTag(COM_TAGID_EXIF, s, sTag, posStart, posEnd) = true do
    begin
      sl.Add(sTag);
      inc(lastFound);
      s := copy(s, posEnd + 1, length(s) - posEnd);
    end;

    theExifTags.Clear;
    for i := firstFound to lastFound do
    begin
      aExifTag := TTBExifTag_CreateTagByParsing(sl[i]);
      if aExifTag <> nil then
        theExifTags.Add(aExifTag);
    end;

    // IPTC Tags Parsing------------------------------------------------------------------------
    firstFound := lastFound + 1;
    // {IPTC}[2|25|DescrIptc]
    // ^              ^
    // posStart        posEnd
    // start and end are the positions where the [ and ] symbols are
    // first get the various tags separated into a stringlist

    s := TagStr;
    while TTBCommonTag_FindFirstTag(COM_TAGID_IPTC, s, sTag, posStart, posEnd) = true do
    begin
      sl.Add(sTag);
      inc(lastFound);
      s := copy(s, posEnd + 1, length(s) - posEnd);
    end;

    theIptcTags.Clear;
    for i := firstFound to lastFound do
    begin
      aIptcTag := TTBIptcTag_CreateTagByParsing(sl[i]);
      if aIptcTag <> nil then
        theIptcTags.Add(aIptcTag);
    end;

    // XMP Tags Parsing------------------------------------------------------------------------
    firstFound := lastFound + 1;
    // {XMP}[XmpName|DescrXmp]
    // ^                ^
    // posStart        posEnd
    // start and end are the positions where the [ and ] symbols are
    // first get the various tags separated into a stringlist

    s := TagStr;
    while TTBCommonTag_FindFirstTag(COM_TAGID_XMP, s, sTag, posStart, posEnd) = true do
    begin
      sl.Add(sTag);
      inc(lastFound);
      s := copy(s, posEnd + 1, length(s) - posEnd);
    end;

    theXmpTags.Clear;
    for i := firstFound to lastFound do
    begin
      aXmpTag := TTBXmpTag_CreateTagByParsing(sl[i]);
      if aXmpTag <> nil then
        theXmpTags.Add(aXmpTag);
    end;

  finally
    sl.free;
  end;
  result := true;
  // {IPTC}[2|DescrExif]
  // {XMP}[XmpName|DescrXmp]
  // {DICOM}[Group|Element|DescrDicom] // (Group: $0000; Element: $0000;

end;

function TTBCommonTag_ParseString(const TagStr: string): boolean; overload;
var
  theExifTags: TTBExifTags;
  theIptcTags: TTBIptcTags;
  theXmpTags: TTBXmpTags;
  theDesc: string;
begin
  theExifTags := TTBExifTags.Create(False);
  theIptcTags := TTBIptcTags.Create(False);
  theXmpTags := TTBXmpTags.Create(False);
  try
    result := TTBCommonTag_ParseString(TagStr, theExifTags, theIptcTags, theXmpTags, theDesc);
  finally
    theExifTags.free;
    theIptcTags.free;
    theXmpTags.free;
  end;

end;

function TTBCommonTag_CreateTagByParsing(const TagStr: string): TTBCommonTag;
var
  theExifTags: TTBExifTags;
  theIptcTags: TTBIptcTags;
  theXmpTags: TTBXmpTags;
  theDescr: string;
  bParsed: boolean;
begin
  theExifTags := TTBExifTags.Create(False);
  theIptcTags := TTBIptcTags.Create(False);
  theXmpTags := TTBXmpTags.Create(False);
  bParsed := TTBCommonTag_ParseString(TagStr, theExifTags, theIptcTags, theXmpTags, theDescr);
  if bParsed then
  begin
    result := TTBCommonTag.Create(theExifTags, theIptcTags, theXmpTags, theDescr, -1);
  end
  else
  begin
    result := nil;
    theExifTags.free;
    theIptcTags.free;
    theXmpTags.free;
  end;
end;

procedure TTB_GraphicResources_ConvertTransparentToAlpha(theIEBMP: TIEBitmap; TranspColor: TColor);
var
  proc: TimageenProc;
begin
  if not theIEBMP.HasAlphaChannel then
  begin
{$IFDEF IMAGEEN_6_2_2_LATER}
    theIEBMP.ReplaceAlphaChannel(TIEBitmap.CreateAsAlphaChannel(theIEBMP.Width, theIEBMP.Height, iememory));
{$ELSE}
    if assigned(theIEBMP.AlphaChannel) then
      theIEBMP.AlphaChannel.free;
    theIEBMP.AlphaChannel := TIEBitmap.CreateAsAlphaChannel(theIEBMP.Width, theIEBMP.Height, iememory);
{$ENDIF}
  end;
  proc := TimageenProc.Create(nil);
  try
    proc.AttachedIEBitmap := theIEBMP;
    proc.SetTransparentColors(TColor2TRGB(TranspColor), TColor2TRGB(TranspColor));
  finally
    proc.free;
  end;
end;

function TBIsCaptionGeneral(cap: TTB_Thumb_CaptionsSetting): boolean;
begin
  result := (cap = cap_General) or (cap = cap_Other1) or (cap = cap_Other2) or (cap = cap_Other3) or (cap = cap_Other4);
end;

{ TNamedList }

function TNamedList.Add(AKey: String; Item: Pointer): integer;
begin
  fNames.Add(AKey);
  result := Inherited Add(Item);
end;

function TNamedList.Add(Item: Pointer): integer;
begin
  result := Add('', Item);
end;

procedure TNamedList.Assign(Source: TList);
begin

  if not(Source is TNamedList) then
    EXIT;

  fNames.Assign(TNamedList(Source).fNames);
  inherited Assign(Source);

end;

procedure TNamedList.Clear;
begin
  fNames.Clear;
  inherited Clear;
end;

constructor TNamedList.Create;
begin
  inherited Create;
  fNames := THashedStringList.Create;
  fNames.Sorted := False;
  fNames.Duplicates := dupAccept;
end;

procedure TNamedList.Delete(AKey: String; const bFindAll: boolean);
var
  idx: integer;
begin
  repeat
    idx := fNames.IndexOf(AKey);
    if idx <> -1 then
      Delete(idx);
  until (not bFindAll) or (idx = -1);
end;

procedure TNamedList.Delete(Index: integer);
begin
  fNames.Delete(Index);
  inherited Delete(Index);
end;

destructor TNamedList.Destroy;
begin
  fNames.free;
  inherited;
end;

function TNamedList.Get(AKey: string; var AResult: Pointer): boolean;
var
  i: integer;
begin
  i := IndexOf(AKey);
  result := i >= 0;
  if result then
    AResult := inherited Items[i];
end;

function TNamedList.GetItems(AKey: String): Pointer;
begin
  if not Get(AKey, result) then
    result := nil;
end;

function TNamedList.GetKey(idx: integer): string;
begin
  result := fNames[idx];
end;

function TNamedList.IndexOf(AKey: String): integer;
begin
  result := fNames.IndexOf(AKey);
end;

function TNamedList.Insert(Index: integer; AKey: String; Item: Pointer): integer;
begin
  fNames.Insert(Index, AKey);
  inherited Insert(Index, Item);

  result := Index;
end;

function TNamedList.IndexOf(Item: Pointer): integer;
begin
  result := inherited IndexOf(Item);
end;

function TNamedList.Insert(Index: integer; Item: Pointer): integer;
begin
  result := Insert(index, '', Item);
end;

procedure TNamedList.Move(CurIndex, NewIndex: integer);
begin
  fNames.Move(CurIndex, NewIndex);
  inherited Move(CurIndex, NewIndex);
end;

procedure TNamedList.Pack;
begin
  raise Exception.Create('Packing Not Supported');
end;

procedure TNamedList.Remove(Item: Pointer);
var
  idx: integer;
begin
  idx := IndexOf(Item);
  if idx <> -1 then
    Delete(idx);
end;

procedure TNamedList.SetKey(idx: integer; const theKey: string);
begin
  if idx = -1 then
    EXIT;

  fNames[idx] := theKey;
end;

procedure TNamedList.Sort;
begin
  raise Exception.Create('Sorting Not Supported');
end;

{ TThreadObjectList }

constructor TThreadObjectList.Create;
begin
  inherited Create;
  InitializeCriticalSection(FLock);
  FList := TObjectList.Create;
  FDuplicates := dupIgnore;
end;

procedure TThreadObjectList.Delete(Aindex: integer);
var
  Temp: TObject;
begin
  LockList;
  try
    if (Aindex >= 0) or (Aindex < FList.Count) then
    begin
      Temp := FList[Aindex];
      FList.Delete(Aindex);
      if Temp <> nil then
        Notify(Temp, lnDeleted);
    end;
  finally
    UnlockList;
  end;
end;

destructor TThreadObjectList.Destroy;
begin
  LockList; // Make sure nobody else is inside the list.
  try
    FList.free;
    inherited Destroy;
  finally
    UnlockList;
    DeleteCriticalSection(FLock);
  end;
end;

function TThreadObjectList.GetCount: integer;
begin
  result := FList.Count;
end;

function TThreadObjectList.GetItems(Index: integer): TObject;
begin
  result := FList.Items[Index];
end;

function TThreadObjectList.getOwnsObjects: boolean;
begin
  result := FList.OwnsObjects;
end;

function TThreadObjectList.IndexOf(AItem: TObject): integer;
begin
  result := FList.IndexOf(AItem);
end;

function TThreadObjectList.Insert(APos: integer; AItem: TObject): integer;
begin
  LockList;
  try
    if (Duplicates = dupAccept) or (FList.IndexOf(AItem) = -1) then
    begin
      FList.Insert(APos, AItem);
      result := APos;
    end
    else
      result := -1;

  finally
    UnlockList;
  end;
  if AItem <> nil then
    Notify(AItem, lnAdded);

end;

function TThreadObjectList.Add(Item: TObject): integer;
begin
  LockList;
  try
    if (Duplicates = dupAccept) or (FList.IndexOf(Item) = -1) then
      result := FList.Add(Item)
    else
      result := -1;
  finally
    UnlockList;
  end;
  if Item <> nil then
    Notify(Item, lnAdded);
end;

procedure TThreadObjectList.Clear;
begin
  LockList;
  try
    FList.Clear;
  finally
    UnlockList;
  end;
end;

procedure TThreadObjectList.Lock;
begin
  LockList;
end;

function TThreadObjectList.LockList: TList;
begin
  EnterCriticalSection(FLock);
  result := FList;
end;

procedure TThreadObjectList.Notify(Ptr: Pointer; Action: TListNotification);
begin
  inherited;

end;

procedure TThreadObjectList.Remove(Item: TObject);
begin
  LockList;
  try
    FList.Remove(Item);
  finally
    UnlockList;
  end;
end;

procedure TThreadObjectList.SetItems(Index: integer; const Value: TObject);
begin
  FList.Items[Index] := Value;
end;

procedure TThreadObjectList.setOwnsObjects(const Value: boolean);
begin
  FList.OwnsObjects := Value;
end;

procedure TThreadObjectList.Sort(Compare: TListSortCompare);
begin
  FList.Sort(Compare);
end;

function TThreadObjectList.TryLockList: boolean;
begin
  result := TryEnterCriticalSection(FLock);
end;

procedure TThreadObjectList.Unlock;
begin
  UnlockList;
end;

procedure TThreadObjectList.UnlockList;
begin
  LeaveCriticalSection(FLock);
end;

{ TTB_GraphicResources }
// --------------------------------------------------------------

procedure TTB_GraphicResources.AssignResource(resType: TTB_Thumb_GraphicResourceType; src: TObject;
  bConvertTranspToAlpha: boolean = False; TranspColor: TColor = clFuchsia);
var
  dest: TIEBitmap;
begin
  case resType of
    gr_Bg:
      begin
        dest := fBMP_Bg;
      end;
    gr_Checked:
      begin
        dest := fbmp_Checked;
      end;
    gr_Unchecked:
      begin
        dest := fbmp_UnChecked;
      end;
    gr_Info:
      begin
        dest := fbmp_Info;
      end;
    gr_RotStrip:
      begin
        dest := fBMP_Rotatebtns_Strip;
      end;
    gr_RotRight_Up:
      begin
        dest := fbmp_RotRight_Up;
      end;
    gr_RotRight_Down:
      begin
        dest := fbmp_RotRight_Down;
      end;
    gr_RotLeft_Up:
      begin
        dest := fbmp_RotLeft_Up;
      end;
    gr_RotLeft_Down:
      begin
        dest := fbmp_RotLeft_Down;
      end;
    gr_FolderUp:
      begin
        dest := fBMP_FolderUpLevel;
      end;
    gr_FolderNormal:
      begin
        dest := fBMP_FolderNormal;
      end;
    gr_ThumbBg:
      begin
        dest := fbmp_ThumbBg;
      end;
    gr_ThumbBgSel:
      begin
        dest := fbmp_ThumbBgSelected;
      end;
    gr_ThumbFrame:
      begin
        dest := fbmp_ThumbFrame;
      end;
    gr_ThumbFrameSel:
      begin
        dest := fbmp_ThumbFrameSelected;
      end;
    gr_ThumbCapBg:
      begin
        dest := fbmp_ThumbCaptionBg;
      end;
    gr_ThumbCapBgSel:
      begin
        dest := fbmp_ThumbCaptionBgSelected;
      end;
    gr_RatingStar:
      begin
        dest := fbmp_RatingStar;
      end;
    gr_RatingStarEmpty:
      begin
        dest := fbmp_RatingStarEmpty;
      end
  else
    EXIT;
    /// >>>> EXIT
  end;

  if assigned(src) then
  begin
    if src is TBitmap then
    begin
      dest.CopyFromTBitmap(TBitmap(src));
      if bConvertTranspToAlpha then
        TTB_GraphicResources_ConvertTransparentToAlpha(dest, TranspColor);

    end
    else if src is TIEBitmap then
    begin
      dest.Assign(TIEBitmap(src));
    end;

    if resType = gr_RotStrip then
      SetBMP_Rotatebtns_Strip(dest); // this will call the setter, to perform extra operations. do not remove

  end;

  case resType of
    gr_Bg:
      begin
        FHAS_Bg := assigned(src);
      end;
    gr_Checked:
      begin
        FHAS_Checked := assigned(src);
      end;
    gr_Unchecked:
      begin
        FHAS_UnChecked := assigned(src);
      end;
    gr_Info:
      begin
        FHAS_Info := assigned(src);
      end;
    gr_RotStrip:
      begin
        FHAS_Rotatebtns_Strip := assigned(src);
      end;
    gr_RotRight_Up:
      begin
        FHAS_RotRight_Up := assigned(src);
      end;
    gr_RotRight_Down:
      begin
        FHAS_RotRight_Down := assigned(src);
      end;
    gr_RotLeft_Up:
      begin
        FHAS_RotLeft_Up := assigned(src);
      end;
    gr_RotLeft_Down:
      begin
        FHAS_RotLeft_Down := assigned(src);
      end;
    gr_FolderUp:
      begin
        FHAS_FolderUpLevel := assigned(src);
      end;
    gr_FolderNormal:
      begin
        fHas_FolderNormal := assigned(src);
      end;
    gr_ThumbBg:
      begin
        FHAS_ThumbBg := assigned(src);
      end;
    gr_ThumbBgSel:
      begin
        FHAS_ThumbBgSelected := assigned(src);
      end;
    gr_ThumbFrame:
      begin
        FHAS_ThumbFrame := assigned(src);
      end;
    gr_ThumbFrameSel:
      begin
        FHAS_ThumbFrameSelected := assigned(src);
      end;
    gr_ThumbCapBg:
      begin
        FHAS_ThumbCaptionBg := assigned(src);
      end;
    gr_ThumbCapBgSel:
      begin
        FHAS_ThumbCaptionBgSelected := assigned(src);
      end;
    gr_RatingStar:
      begin
        fHAS_RatingStar := assigned(src);
      end;
    gr_RatingStarEmpty:
      begin
        fHAS_RatingStarEmpty := assigned(src);
      end;
  end;
end;

procedure TTB_GraphicResources.AssignResource(src: TIEBitmap; resType: TTB_Thumb_GraphicResourceType);
begin
  AssignResource(resType, src, False, 0);
end;

constructor TTB_GraphicResources.Create;
begin
  inherited;
  fGradBg := nil;
  fDropShadow := nil;
  fDropShadowSize := 3;
  fBMP_Bg := TIEBitmap.Create;
  fbmp_Checked := TIEBitmap.Create;
  fbmp_UnChecked := TIEBitmap.Create;
  fbmp_Info := TIEBitmap.Create;
  fBMP_FolderUpLevel := TIEBitmap.Create;
  fBMP_FolderNormal := TIEBitmap.Create;
  fBMP_Rotatebtns_Strip := TIEBitmap.Create;
  fbmp_RotRight_Up := TIEBitmap.Create;
  fbmp_RotRight_Down := TIEBitmap.Create;
  fbmp_RotLeft_Up := TIEBitmap.Create;
  fbmp_RotLeft_Down := TIEBitmap.Create;

  fbmp_RatingStar := TIEBitmap.Create;
  fbmp_RatingStarEmpty := TIEBitmap.Create;

  fbmp_ThumbFrame := TIEBitmap.Create;
  fbmp_ThumbFrameSelected := TIEBitmap.Create;
  fbmp_ThumbCaptionBg := TIEBitmap.Create;
  fbmp_ThumbCaptionBgSelected := TIEBitmap.Create;
  fbmp_ThumbBg := TIEBitmap.Create;
  fbmp_ThumbBgSelected := TIEBitmap.Create;

  FHAS_Bg := False;

  FHAS_ThumbBg := False;
  FHAS_ThumbBgSelected := False;
  FHAS_ThumbFrame := False;
  FHAS_ThumbFrameSelected := False;
  FHAS_ThumbCaptionBg := False;
  FHAS_ThumbCaptionBgSelected := False;

  FHAS_Checked := False;
  FHAS_UnChecked := False;
  FHAS_Info := False;
  FHAS_FolderUpLevel := False;
  fHas_FolderNormal := False;
  FHAS_Rotatebtns_Strip := False;

  FHAS_RotRight_Up := False;
  FHAS_RotRight_Down := False;
  FHAS_RotLeft_Up := False;
  FHAS_RotLeft_Down := False;

  fHAS_RatingStar := False;
  fHAS_RatingStarEmpty := False;
end;

destructor TTB_GraphicResources.Destroy;
begin
  if assigned(fGradBg) then
    freeandnil(fGradBg);
  if assigned(fDropShadow) then
    freeandnil(fDropShadow);
  fBMP_Bg.free;
  fbmp_Checked.free;
  fbmp_UnChecked.free;
  fbmp_Info.free;
  fBMP_FolderUpLevel.free;
  fBMP_FolderNormal.free;
  fBMP_Rotatebtns_Strip.free;
  fbmp_RotRight_Up.free;
  fbmp_RotRight_Down.free;
  fbmp_RotLeft_Up.free;
  fbmp_RotLeft_Down.free;

  fbmp_RatingStar.free;
  fbmp_RatingStarEmpty.free;

  fbmp_ThumbFrame.free;
  fbmp_ThumbFrameSelected.free;
  fbmp_ThumbCaptionBg.free;
  fbmp_ThumbCaptionBgSelected.free;
  fbmp_ThumbBg.free;
  fbmp_ThumbBgSelected.free;

  inherited;
end;

// fDropShadow
function TTB_GraphicResources.GetDropShadow(w, h: integer; dropsize: integer): TIEBitmap;
var
  maxSize: integer;
begin
  if (fDropShadow = nil) then
  begin
    fDropShadow := TIEBitmap.Create;
    fDropShadow.PixelFormat := ie24RGB;
  end;

  // ------------------
  result := fDropShadow;
  // ------------------
  if w > h then
    maxSize := 2 * w
  else
    maxSize := 2 * h;
  if (abs(maxSize - fDropShadow.Width) > 0.2 * maxSize) or (dropsize <> fDropShadowSize) then
  begin

    fDropShadow.Width := maxSize + 4 * dropsize;
    fDropShadow.Height := maxSize + 4 * dropsize;
    fDropShadow.Fill(0);
    fDropShadow.AlphaChannel.Fill(0);
    fDropShadow.AlphaChannel.FillRect(2 * dropsize, 2 * dropsize, maxSize - 2 * dropsize, maxSize - 2 * dropsize, 200);
    _IEGBlurRect8(fDropShadow.AlphaChannel, 0, 0, fDropShadow.AlphaChannel.Width - 1,
      fDropShadow.AlphaChannel.Height - 1, 2 * dropsize);
    fDropShadowSize := dropsize;
    {
      black.r := 0;
      black.g := 0;
      black.b := 0;
      _IEAddSoftShadow(fDropShadow, 6,6, 6, 100, true, black, nil, nil);
    }
  end;

end;

function TTB_GraphicResources.GetGradientBg(w, h: integer; StartColor, EndColor: TColor; bVertical: boolean): TIEBitmap;
var
  tempbmp: TBitmap;
begin
  if (fGradBg = nil) then
  begin
    fGradBg := TIEBitmap.Create;
    fGradBg.PixelFormat := ie24RGB;
  end;

  // ------------------
  result := fGradBg;
  // ------------------

  if (fGradBgStartColor <> StartColor) or (fGradBgEndColor <> EndColor) or (w > fGradBg.Width) or
    (w < round(0.9 * fGradBg.Width)) or (h > fGradBg.Height) or (h < round(0.9 * fGradBg.Height)) or
    (fGradVertical <> bVertical) then
  begin
    fGradBg.Width := w;
    fGradBg.Height := h;
    if (w > 0) and (h > 0) then
    begin
      tempbmp := TBitmap.Create; // need to create a temp tbitmap because of a bug in TIEBitmap.canvas
      tempbmp.PixelFormat := pf24bit;
      try
        fGradBg.CopyToTBitmap(tempbmp);
        IEDrawGradient(Rect(0, 0, tempbmp.Width, tempbmp.Height), tempbmp.Canvas.handle, StartColor, EndColor,
          bVertical);
      finally
        fGradBg.CopyFromTBitmap(tempbmp);
        fGradBg.Location := ieFile;
        tempbmp.free;
      end;
    end;
    // fGradBg.Location := ieFile;

    fGradBgStartColor := StartColor;
    fGradBgEndColor := EndColor;
    fGradVertical := bVertical;
  end;

end;

procedure TTB_GraphicResources.LoadFromResources;
var
  tempIeBmp: TIEBitmap;
  stream: tstream;
begin

  tempIeBmp := TIEBitmap.Create;
  try
    stream := TResourceStream.Create(HInstance, 'CHECK_YES', RT_RCDATA);
    try
      tempIeBmp.Read(stream);
      AssignResource(gr_Checked, tempIeBmp);
    finally
      stream.free;
    end;

    stream := TResourceStream.Create(HInstance, 'CHECK_NO', RT_RCDATA);
    try
      tempIeBmp.Read(stream);
      AssignResource(gr_Unchecked, tempIeBmp);
    finally
      stream.free;
    end;

    stream := TResourceStream.Create(HInstance, 'INFO_BOX', RT_RCDATA);
    try
      tempIeBmp.Read(stream);
      AssignResource(gr_Info, tempIeBmp);
    finally
      stream.free;
    end;

    stream := TResourceStream.Create(HInstance, 'FOLDER_UP', RT_RCDATA);
    try
      tempIeBmp.Read(stream);
      AssignResource(gr_FolderUp, tempIeBmp);
    finally
      stream.free;
    end;

    stream := TResourceStream.Create(HInstance, 'ROTATE_LEFT_OFF', RT_RCDATA);
    try
      tempIeBmp.Read(stream);
      AssignResource(gr_RotLeft_Up, tempIeBmp);
    finally
      stream.free;
    end;

    stream := TResourceStream.Create(HInstance, 'ROTATE_LEFT_ON', RT_RCDATA);
    try
      tempIeBmp.Read(stream);
      AssignResource(gr_RotLeft_Down, tempIeBmp);
    finally
      stream.free;
    end;

    stream := TResourceStream.Create(HInstance, 'ROTATE_RIGHT_OFF', RT_RCDATA);
    try
      tempIeBmp.Read(stream);
      AssignResource(gr_RotRight_Up, tempIeBmp);
    finally
      stream.free;
    end;

    stream := TResourceStream.Create(HInstance, 'ROTATE_RIGHT_ON', RT_RCDATA);
    try
      tempIeBmp.Read(stream);
      AssignResource(gr_RotRight_Down, tempIeBmp);
    finally
      stream.free;
    end;

    stream := TResourceStream.Create(HInstance, 'RATING_STAR', RT_RCDATA);
    try
      tempIeBmp.Read(stream);
      AssignResource(gr_RatingStar, tempIeBmp);
    finally
      stream.free;
    end;

    stream := TResourceStream.Create(HInstance, 'RATING_STAR_EMPTY', RT_RCDATA);
    try
      tempIeBmp.Read(stream);
      AssignResource(gr_RatingStarEmpty, tempIeBmp);
    finally
      stream.free;
    end;

  finally
    tempIeBmp.free;
  end;

end;

procedure TTB_GraphicResources.Assign(Source: Tpersistent);
var
  src: TTB_GraphicResources;
begin
  if not(Source is TTB_GraphicResources) then
    EXIT;

  src := TTB_GraphicResources(Source);
  // AssignResource(gr_FolderNormal, src.BMP_FolderNormal);
  AssignResource(gr_FolderUp, src.BMP_FolderUpLevel);
  AssignResource(gr_Bg, src.bmp_Bg);
  AssignResource(gr_Checked, src.bmp_Checked);
  AssignResource(gr_Unchecked, src.bmp_UnChecked);
  AssignResource(gr_Info, src.bmp_Info);

  // do not need this once loaded from resources //  fBMP_Rotatebtns_Strip.assign(src.BMP_Rotatebtns_Strip);

  AssignResource(gr_RotRight_Up, src.bmp_RotRight_Up);
  AssignResource(gr_RotRight_Down, src.bmp_RotRight_Down);
  AssignResource(gr_RotLeft_Up, src.bmp_RotLeft_Up);
  AssignResource(gr_RotLeft_Down, src.bmp_RotLeft_Down);

  AssignResource(gr_ThumbBg, src.bmp_ThumbBg);
  AssignResource(gr_ThumbBgSel, src.bmp_ThumbBgSelected);
  AssignResource(gr_ThumbFrame, src.bmp_ThumbFrame);
  AssignResource(gr_ThumbFrameSel, src.bmp_ThumbFrameSelected);
  AssignResource(gr_ThumbCapBg, src.bmp_ThumbCaptionBg);
  AssignResource(gr_ThumbCapBgSel, src.bmp_ThumbCaptionBgSelected);

  AssignResource(gr_RatingStar, src.bmp_RatingStar);
  AssignResource(gr_RatingStarEmpty, src.bmp_RatingStarEmpty);

  FHAS_Bg := src.HAS_Bg;
  FHAS_Checked := src.HAS_Checked;
  FHAS_UnChecked := src.HAS_UnChecked;
  FHAS_FolderUpLevel := src.HAS_FolderUpLevel;
  fHas_FolderNormal := src.HAS_FolderNormal;
  FHAS_Info := src.HAS_Info;
  FHAS_RotRight_Up := src.HAS_RotRight_Up;
  FHAS_RotRight_Down := src.HAS_RotRight_Down;
  FHAS_RotLeft_Up := src.HAS_RotLeft_Up;
  FHAS_RotLeft_Down := src.HAS_RotLeft_Down;

  FHAS_ThumbBg := src.HAS_ThumbBg;
  FHAS_ThumbBgSelected := src.HAS_ThumbBgSelected;
  FHAS_ThumbFrame := src.HAS_ThumbFrame;
  FHAS_ThumbFrameSelected := src.HAS_ThumbFrameSelected;
  FHAS_ThumbCaptionBg := src.HAS_ThumbCaptionBg;
  FHAS_ThumbCaptionBgSelected := src.HAS_ThumbCaptionBgSelected;

end;

procedure TTB_GraphicResources.Setbmp_Bg(Value: TIEBitmap);
begin
  AssignResource(gr_Bg, Value);
end;

procedure TTB_GraphicResources.Setbmp_Checked(Value: TIEBitmap);
begin
  AssignResource(gr_Checked, Value);
end;

procedure TTB_GraphicResources.Setbmp_RotLeft_Down(const Value: TIEBitmap);
begin
  AssignResource(gr_RotLeft_Down, Value);
end;

procedure TTB_GraphicResources.Setbmp_RotLeft_Up(const Value: TIEBitmap);
begin
  AssignResource(gr_RotLeft_Up, Value);
end;

procedure TTB_GraphicResources.Setbmp_RotRight_Down(const Value: TIEBitmap);
begin
  AssignResource(gr_RotRight_Down, Value);
end;

procedure TTB_GraphicResources.Setbmp_RotRight_Up(const Value: TIEBitmap);
begin
  AssignResource(gr_RotRight_Up, Value);
end;

procedure TTB_GraphicResources.Setbmp_ThumbBg(const Value: TIEBitmap);
begin
  AssignResource(gr_ThumbBg, Value);
end;

procedure TTB_GraphicResources.Setbmp_ThumbBgSelected(const Value: TIEBitmap);
begin
  AssignResource(gr_ThumbBgSel, Value);
end;

procedure TTB_GraphicResources.Setbmp_ThumbCaptionBg(const Value: TIEBitmap);
begin
  AssignResource(gr_ThumbCapBg, Value);
end;

procedure TTB_GraphicResources.Setbmp_ThumbCaptionBgSelected(const Value: TIEBitmap);
begin
  AssignResource(gr_ThumbCapBgSel, Value);
end;

procedure TTB_GraphicResources.Setbmp_ThumbFrame(const Value: TIEBitmap);
begin
  AssignResource(gr_ThumbFrame, Value);
end;

procedure TTB_GraphicResources.Setbmp_ThumbFrameSelected(const Value: TIEBitmap);
begin
  AssignResource(gr_ThumbFrameSel, Value);
end;

procedure TTB_GraphicResources.Setbmp_UnChecked(Value: TIEBitmap);
begin
  AssignResource(gr_Unchecked, Value);
end;

procedure TTB_GraphicResources.SetBmpInfo(Value: TIEBitmap);
begin
  AssignResource(gr_Info, Value);
end;

procedure TTB_GraphicResources.SetBMP_FolderNormal(Value: TIEBitmap);
begin
  AssignResource(gr_FolderNormal, Value);
end;

procedure TTB_GraphicResources.SetBMP_FolderUpLevel(Value: TIEBitmap);
begin
  AssignResource(gr_FolderUp, Value);
end;

procedure TTB_GraphicResources.Setbmp_RatingStar(const Value: TIEBitmap);
begin
  AssignResource(gr_RatingStar, Value);
end;

procedure TTB_GraphicResources.Setbmp_RatingStarEmpty(const Value: TIEBitmap);
begin
  AssignResource(gr_RatingStarEmpty, Value);
end;

procedure TTB_GraphicResources.SetBMP_Rotatebtns_Strip(Value: TIEBitmap);
  procedure GetBmpAtPos(bmp: TIEBitmap; Pos: integer);
  var
    w, h: integer;
  begin
    w := fBMP_Rotatebtns_Strip.Width div 6;
    h := fBMP_Rotatebtns_Strip.Height;
    bmp.PixelFormat := ie24RGB;
    bmp.Width := w;
    bmp.Height := h;
    fBMP_Rotatebtns_Strip.CopyRectTo(bmp, w * Pos, 0, 0, 0, bmp.Width, bmp.Height);

  end;

var
  tempbmp: TIEBitmap;
  i: integer;
begin
  if fBMP_Rotatebtns_Strip <> Value then
    fBMP_Rotatebtns_Strip.Assign(Value);

  for i := 0 to 5 do
  begin
    tempbmp := TIEBitmap.Create;
    try
      GetBmpAtPos(tempbmp, i);
      TTB_GraphicResources_ConvertTransparentToAlpha(tempbmp, clFuchsia);
      case i of
        0:
          AssignResource(gr_RotRight_Up, tempbmp); // fbmp_RotRight_Up.Assign(tempbmp);
        2:
          AssignResource(gr_RotLeft_Up, tempbmp); // fbmp_RotLeft_Up.Assign(tempbmp);
        3:
          AssignResource(gr_RotRight_Down, tempbmp); // fbmp_RotRight_Down.Assign(tempbmp);
        5:
          AssignResource(gr_RotLeft_Down, tempbmp); // fbmp_RotLeft_Down.Assign(tempbmp);
      end;
    finally
      tempbmp.free;
    end;
  end;

end;

{ TThumbsBrowser_FolderMonitor }
{$IFDEF TB_FOLDERMONITOR}

procedure TThumbsBrowser_FolderMonitor.AddListener(ListeningObject: TObject;
  FileChangeNotifyHandler: TFileChangeNotifyEvent; theWatchOptions: TWatchOptions; theWatchActions: TWatchActions);
begin
  fListeners.Add(TThumbsBrowser_FolderMonitor_Listener.Create(FileChangeNotifyHandler, ListeningObject, theWatchOptions,
    theWatchActions));
end;

procedure TThumbsBrowser_FolderMonitor.RemoveListener(ListeningObject: TObject);
var
  i: integer;
  aListener: TThumbsBrowser_FolderMonitor_Listener;
begin

  aListener := FindListener(ListeningObject);
  if not assigned(aListener) then
    EXIT;

  fListeners.Remove(aListener);

  for i := fPaths.Count - 1 downto 0 do
  begin

    if (GetPath(i).Listener.ListeningObject = ListeningObject) then
    // AND (@(listener.FileChangeNotifyHandler) = @@FileChangeNotifyHandler) then
    begin
      fPaths.Remove(GetPath(i));
    end; { }
  end;
end;

procedure TThumbsBrowser_FolderMonitor.ChangeListenerProperties(ListeningObject: TObject; newOptions: TWatchOptions;
  newActions: TWatchActions);
var
  aListener: TThumbsBrowser_FolderMonitor_Listener;
begin

  aListener := FindListener(ListeningObject);
  if not assigned(aListener) then
    EXIT;

  aListener.WatchOptions := newOptions;
  aListener.WatchActions := newActions;

end;

constructor TThumbsBrowser_FolderMonitor.Create;
begin
  inherited Create(nil);

  fListeners := TObjectList.Create;
  fMonitors := TObjectList.Create;
  fPaths := TObjectList.Create;
end;

destructor TThumbsBrowser_FolderMonitor.Destroy;
begin
  freeandnil(fMonitors);
  freeandnil(fListeners);
  freeandnil(fPaths);

  inherited;
end;

function TThumbsBrowser_FolderMonitor.GetListener(idx: integer): TThumbsBrowser_FolderMonitor_Listener;
begin
  result := TThumbsBrowser_FolderMonitor_Listener(fListeners[idx]);
end;

function TThumbsBrowser_FolderMonitor.GetMonitor(idx: integer): TIEFolderWatch;
begin
  result := TIEFolderWatch(fMonitors[idx]);
end;

function TThumbsBrowser_FolderMonitor.GetPath(idx: integer): TThumbsBrowser_FolderMonitor_Path;
begin
  result := TThumbsBrowser_FolderMonitor_Path(fPaths[idx]);
end;

procedure TThumbsBrowser_FolderMonitor.HandleMonitorNotify(const sender: TObject; const Action: TWatchAction;
  const FileName: string);
var
  ObjectsListeningToPath: TList;
  i: integer;
  j: integer;
  aListener: TThumbsBrowser_FolderMonitor_Listener;
begin

  ObjectsListeningToPath := TList.Create;
  try
    if FileNameInBrowsePaths(FileName, ObjectsListeningToPath) then
    begin
      for i := 0 to ObjectsListeningToPath.Count - 1 do
      begin
        for j := 0 to fListeners.Count - 1 do
        begin
          aListener := GetListener(j);
          if assigned(aListener) then
          begin
            if ObjectsListeningToPath[i] = aListener.ListeningObject then
            begin
              aListener.Notify(self, Action, FileName);
            end;
          end;
        end;
      end;
    end;
  finally
    ObjectsListeningToPath.free;
  end;

end;

function TThumbsBrowser_FolderMonitor.FileNameInBrowsePaths(FileName: string;
  var ListOfListeningObjects: TList): boolean;
var
  i: integer;
  sPath: string;
  aPath: TThumbsBrowser_FolderMonitor_Path;
begin

  sPath := extractfilepath(FileName);
  result := False;
  for i := 0 to fPaths.Count - 1 do
  begin
    aPath := GetPath(i);
    if tbs_ComparePaths(sPath, aPath.Path) = 0 then
    begin
      result := true;
      ListOfListeningObjects.Add(aPath.Listener.ListeningObject);
    end;
  end;
end;

function TThumbsBrowser_FolderMonitor.PathWatched(Path: string;
  theListener: TThumbsBrowser_FolderMonitor_Listener): boolean;
begin
  result := False;
  if not assigned(theListener) then
    EXIT;

  result := PathWatched(Path, theListener.ListeningObject);
end;

function TThumbsBrowser_FolderMonitor.PathWatched(Path: string; theListeningObject: TObject): boolean;
begin
  result := assigned(FindPath(Path, theListeningObject));
end;

function TThumbsBrowser_FolderMonitor.FindCloserMonitor(Path: string; var sFoundPath: string): TIEFolderWatch;
var
  i: integer;
  sDrive, sDrive_slashed, sTryPath: string;
  aMonitor: TIEFolderWatch;
begin
  result := nil;

  // path := Tbs_AddSlash(path);
  sDrive := ExtractFileDrive(Path);
  sDrive_slashed := Tbs_AddSlash(sDrive);
  sFoundPath := '';

  for i := 0 to fMonitors.Count - 1 do
  begin
    aMonitor := GetMonitor(i);

    if (comparetext(ExtractFileDrive(aMonitor.Path), sDrive) = 0) then
    begin
      sTryPath := aMonitor.Path;
      while (length(sTryPath) > length(sDrive_slashed)) and (not tbs_PathIsChildOfPath(Path, sTryPath)) do
      begin
        sTryPath := Tbs_AddSlash(tbs_GetParentPath(sTryPath));
      end;

      if length(sTryPath) > length(sFoundPath) then
      begin
        sFoundPath := sTryPath;
        result := GetMonitor(i);
      end;
    end;

  end;

end;

function TThumbsBrowser_FolderMonitor.FindCloserMonitor(Path: string): TIEFolderWatch;
var
  s: string;
begin
  result := FindCloserMonitor(Path, s);
end;

function TThumbsBrowser_FolderMonitor.FindListener(theListeningObject: TObject): TThumbsBrowser_FolderMonitor_Listener;
var
  i: integer;
begin
  result := nil;
  for i := 0 to fListeners.Count - 1 do
  begin
    if GetListener(i).ListeningObject = theListeningObject then
    begin
      result := GetListener(i);
      break;
    end;
  end;
end;

function TThumbsBrowser_FolderMonitor.FindPath(thePath: string; theListeningObject: TObject)
  : TThumbsBrowser_FolderMonitor_Path;
var
  i: integer;
begin
  result := nil;
  for i := 0 to fPaths.Count - 1 do
  begin
    if (tbs_ComparePaths(GetPath(i).Path, thePath) = 0) and (GetPath(i).Listener.ListeningObject = theListeningObject)
    then
    begin
      result := GetPath(i);
    end;
  end;
end;

procedure TThumbsBrowser_FolderMonitor.StartWatching(ListeningObject: TObject; Path: string; bSubTree: boolean);
var
  aMonitor: TIEFolderWatch;
  bFoundSuitableParent: boolean;
  sCloserPath: string;
  aListener: TThumbsBrowser_FolderMonitor_Listener;
begin
  if Path = '' then
    EXIT;

  aListener := FindListener(ListeningObject);

  if not assigned(aListener) then
    EXIT;

  if PathWatched(Path, aListener) then
  begin
    EXIT;
  end;

  bFoundSuitableParent := False;
  // search the closest parent path
  // example: our path is d:\test\myfolders\1\
  // but there is a path d:\test\
  // so we can use it (eventually setting watchSubTree to true)
  aMonitor := FindSuitableParentMonitor(Path);
  if aMonitor <> nil then
  begin
    if (tbs_ComparePaths(Path, aMonitor.Path) = 0) then // the path is exactly the same as one of the monitors
    begin
      // TODO EnsureListenerWatchOptionsOnPath(aMonitor.Path, aListener);
      bFoundSuitableParent := true;
      AddPath(aListener, Path, aMonitor);
    end
    else // if the path is in a parent BUT IS DIFFERENT FROM PARENT  enable subtree watching of Parent
    begin
      if not aMonitor.WatchSubTree then
        ReplaceMonitor(aMonitor, aMonitor.Path, true);
      // we create a new monitor with same path but with Sub tree = true
      // TODO EnsureListenerWatchOptionsOnPath(aMonitor.Path, aListener);
      bFoundSuitableParent := true;
      AddPath(aListener, Path, aMonitor);
    end;
  end;

  if not bFoundSuitableParent then
  begin
    // search the closest path among those that were not suitable
    // example: our path is d:\test\myfolders\1\
    // a path like: c:\ will not do
    // but there is a path d:\test\myfolders\1\b\c\
    // so we replace the monitor for that path with a new monitor with the parent path d:\test\myfolders\1\
    aMonitor := FindCloserMonitor(Path, sCloserPath);
    if assigned(aMonitor) then
    begin // change existing monitor to include the new path and set watchsubtree = true
      ReplaceMonitor(aMonitor, sCloserPath, true);
      AddPath(aListener, Path, aMonitor);
    end
    else
    begin // create a new monitor
      AddMonitor(aListener, Path, False);
    end;
  end;

end;

function TThumbsBrowser_FolderMonitor.FindSuitableParentMonitor(Path: string): TIEFolderWatch;
var
  i: integer;
  aMonitor: TIEFolderWatch;
begin
  result := nil;
  for i := 0 to fMonitors.Count - 1 do
  begin
    aMonitor := GetMonitor(i);
    if tbs_PathIsChildOfPath(Path, aMonitor.Path) then
    begin
      result := aMonitor;
      break;
    end;
  end;
end;

procedure TThumbsBrowser_FolderMonitor.ReplaceMonitor(aMonitor: TIEFolderWatch; const newPath: string;
  const bSubTree: boolean);
var
  i: integer;
  aListener: TThumbsBrowser_FolderMonitor_Listener;
  newMonitor: TIEFolderWatch;
begin
  // stop old monitor
  aMonitor.Stop;

  // create a new one
  newMonitor := AddMonitor(newPath, bSubTree, aMonitor.WatchOptions);

  // replace monitor in listeners
  for i := 0 to fListeners.Count - 1 do
  begin
    aListener := GetListener(i);

    if aListener.Monitors.Remove(aMonitor) >= 0 then
      aListener.Monitors.Add(newMonitor);
  end;

  fMonitors.Remove(aMonitor); // delete old monitor completely
end;

procedure TThumbsBrowser_FolderMonitor.StopWatching(ListeningObject: TObject);
var
  i: integer;
begin
  for i := fPaths.Count - 1 downto 0 do
  begin
    if GetPath(i).Listener.ListeningObject = ListeningObject then
      StopWatching(ListeningObject, GetPath(i).Path);
  end;
end;

procedure TThumbsBrowser_FolderMonitor.StopWatching(ListeningObject: TObject; Path: string);
var
  aListener: TThumbsBrowser_FolderMonitor_Listener;
  aPath: TThumbsBrowser_FolderMonitor_Path;
begin

  aListener := FindListener(ListeningObject);
  if not assigned(aListener) then
    EXIT;

  aPath := FindPath(Path, ListeningObject);

  if not assigned(aPath) then
    EXIT;

  fPaths.Delete(fPaths.IndexOf(aPath));
  TryDeleteMonitor(aListener, Path);

end;

procedure TThumbsBrowser_FolderMonitor.TryDeleteMonitor(Listener: TThumbsBrowser_FolderMonitor_Listener;
  thePath: string);
var
  aMonitor: TIEFolderWatch;
  aListener: TThumbsBrowser_FolderMonitor_Listener;
  i, j: integer;
  bCanDelete: boolean;

begin
  aMonitor := FindCloserMonitor(thePath);

  if not assigned(aMonitor) then
    EXIT;

  bCanDelete := true;
  for i := 0 to fListeners.Count - 1 do
  begin
    aListener := GetListener(i);
    if aListener <> Listener then
    begin
      for j := 0 to aListener.Monitors.Count - 1 do
      begin
        if aListener.Monitors[j] = aMonitor then
        begin
          bCanDelete := False;
          break;
        end;
      end;
      if not bCanDelete then
        break;
    end;
  end;

  if bCanDelete then
  begin
    aMonitor.Stop;
    Listener.Monitors.Remove(aMonitor); // first this
    fMonitors.Remove(aMonitor); // then this
  end;

end;

procedure TThumbsBrowser_FolderMonitor.AddMonitor(Listener: TThumbsBrowser_FolderMonitor_Listener; thePath: string;
  bSubTree: boolean);
var
  aMonitor: TIEFolderWatch;
begin

  aMonitor := AddMonitor(thePath, bSubTree, Listener.WatchOptions);

  if not PathWatched(thePath, Listener) then
    AddPath(Listener, thePath, aMonitor);

end;

function TThumbsBrowser_FolderMonitor.AddMonitor(thePath: string; bSubTree: boolean; theWatchOptions: TWatchOptions)
  : TIEFolderWatch;
begin
  {$IFDEF IMAGEEN_8_7_0_LATER}
  result := TIEFolderWatch.Create(nil);
   {$ELSE}
   result := TIEFolderWatch.Create;
  {$ENDIF}


  result.Path := thePath;
  result.WatchOptions := theWatchOptions;
  result.WatchActions := [waAdded, waRemoved, waModified, waRenamedOld, waRenamedNew];
  result.WatchSubTree := bSubTree;
  result.OnNotify := HandleMonitorNotify;

  fMonitors.Add(result);
  result.Start;

end;

procedure TThumbsBrowser_FolderMonitor.AddPath(Listener: TThumbsBrowser_FolderMonitor_Listener; thePath: string;
  theMonitor: TIEFolderWatch);
begin
  fPaths.Add(TThumbsBrowser_FolderMonitor_Path.Create(thePath, Listener));
  if theMonitor <> nil then
    if Listener.Monitors.IndexOf(theMonitor) = -1 then
      Listener.Monitors.Add(theMonitor);
end;
{$ENDIF}  // Endif Compiler directive Imageen 5 - folder monitor

{ TThumbsBrowser_FolderMonitor_Listener }
{$IFDEF TB_FOLDERMONITOR}

constructor TThumbsBrowser_FolderMonitor_Listener.Create(TheFileChangeNotifyHandler: TFileChangeNotifyEvent;
  theListeningObject: TObject; theWatchOptions: TWatchOptions; theWatchActions: TWatchActions);
begin
  inherited Create;

  FileChangeNotifyHandler := TheFileChangeNotifyHandler;
  ListeningObject := theListeningObject;
  WatchOptions := theWatchOptions;
  WatchActions := theWatchActions;

  Monitors := TList.Create;
end;

destructor TThumbsBrowser_FolderMonitor_Listener.Destroy;
begin
  Monitors.free;
  inherited;
end;

procedure TThumbsBrowser_FolderMonitor_Listener.Notify(const sender: TObject; const Action: TWatchAction;
  const FileName: string);
begin
  if not(Action in self.WatchActions) then
    EXIT;

  if assigned(FileChangeNotifyHandler) then
    FileChangeNotifyHandler(self, Action, FileName);
end;
{$ENDIF}
{ TThumbsBrowser_FolderMonitor_Path }
{$IFDEF TB_FOLDERMONITOR}

constructor TThumbsBrowser_FolderMonitor_Path.Create(thePath: string;
  theListener: TThumbsBrowser_FolderMonitor_Listener);
begin
  Path := thePath;
  Listener := theListener;
end;
{$ENDIF}
{ TThumbsBrowser_FolderMonitor_Item }
{$IFDEF TB_FOLDERMONITOR}

constructor TThumbsBrowser_FolderMonitor_Item.Create(theFileName: string; theAction: TWatchAction);
begin
  inherited Create;

  FFileName := theFileName;
  fAction := theAction;
end;
{$ENDIF}
{ TThumbsBrowser_FolderMonitor_SuspendedItem }
{$IFDEF TB_FOLDERMONITOR}

Constructor TThumbsBrowser_FolderMonitor_SuspendedItem.Create(theFileName: string; theSuspendInterval: integer;
  // use -1 to suspend without limit
  theSuspendedActions: TWatchActions = []);
begin
  FFileName := theFileName;
  fSuspendInterval := theSuspendInterval;
  fSuspendedActions := theSuspendedActions;
  fSuspensionStart := GetTickCount;
end;
{$ENDIF}
{ TThumbsBrowser_FolderMonitor_Items }
{$IFDEF TB_FOLDERMONITOR}

function TThumbsBrowser_FolderMonitor_Items.GetItems(idx: integer): TThumbsBrowser_FolderMonitor_Item;
begin
  result := TThumbsBrowser_FolderMonitor_Item(GetItem(idx));
end;
{$ENDIF}
{ TThumbsbrowser_MetaInfo_FileRcd }

constructor TThumbsbrowser_MetaData_FileRcd.Create(theFileName: string; bIsUrl, bIsWia, bIsWPD: boolean;
  bHasExif: boolean; bHasIptc: boolean; bHasDicom: boolean; bHasXmp: boolean; iThumbOrientation: integer;
  theWiaItem: TIEWiaItem = nil; theWPDObjID: String = ''; bThumbHasFullImg: boolean = False;
  theThumbImg: TIEBitmap = nil);
begin
  Init(theFileName, bIsUrl, bIsWia, bIsWPD, bHasExif, bHasIptc, bHasDicom, bHasXmp, iThumbOrientation, theWiaItem,
    theWPDObjID, bThumbHasFullImg, theThumbImg);
end;

constructor TThumbsbrowser_MetaData_FileRcd.Create(theFileName: string);
begin
  InitShort(theFileName);
end;

constructor TThumbsbrowser_MetaData_FileRcd.Create(theFileName: string; theParams: TIOParams);
begin
  if not assigned(theParams) then
  begin
    InitShort(theFileName);
    EXIT;
  end;

  Init(theFileName, False, False, False, theParams.EXIF_HasEXIFData, theParams.IPTC_Info.Count > 0,
    theParams.DICOM_Tags.Count > 0, theParams.XMP_Info <> '', theParams.EXIF_Orientation, nil, '', False, nil);
end;

procedure TThumbsbrowser_MetaData_FileRcd.ForceMetaInfo(const bForceExif, bForceIptc, bForceXmp, bForceDicom: boolean);
begin
  if bForceExif then
    fForceExif := true;
  if bForceIptc then
    fForceIptc := true;
  if bForceXmp then
    fForceXmp := true;
  if bForceDicom then
    fForceDicom := true;

end;

procedure TThumbsbrowser_MetaData_FileRcd.UnForceMetaInfo(const bUnForceExif, bUnForceIptc, bUnForceXmp,
  bUnForceDicom: boolean);
begin
  if bUnForceExif then
    fForceExif := False;
  if bUnForceIptc then
    fForceIptc := False;
  if bUnForceXmp then
    fForceXmp := False;
  if bUnForceDicom then
    fForceDicom := False;
end;

function TThumbsbrowser_MetaData_FileRcd.GetCommonEditable: boolean;
begin
  result := GetExifEditable or GetIptcEditable or GetXmpEditable;
end;

function TThumbsbrowser_MetaData_FileRcd.GetDicomEditable: boolean;
begin
  result := False;
end;

function TThumbsbrowser_MetaData_FileRcd.GetExifEditable: boolean;
begin
  result := fForceExif or tbs_FileExtIsJPG(FileExtension) or tbs_FileExtIsTif(FileExtension);
end;

function TThumbsbrowser_MetaData_FileRcd.GetIptcEditable: boolean;
begin
  result := fForceIptc or tbs_FileExtIsJPG(FileExtension) or tbs_FileExtIsTif(FileExtension);
end;

function TThumbsbrowser_MetaData_FileRcd.GetXmpEditable: boolean;
begin
  result := False;
end;

function TThumbsbrowser_MetaData_FileRcd.GetFileExtension: string;
begin
  result := extractfileext(FFileName);
end;

function TThumbsbrowser_MetaData_FileRcd.GetHasDicom: boolean;
begin
  result := fForceDicom or fHasDicom;
end;

function TThumbsbrowser_MetaData_FileRcd.GetHasExif: boolean;
begin
  result := fForceExif or fHasExif;
end;

function TThumbsbrowser_MetaData_FileRcd.GetHasIptc: boolean;
begin
  result := fForceIptc or fHasIptc;
end;

function TThumbsbrowser_MetaData_FileRcd.GetHasXmp: boolean;
begin
  result := fForceXmp or fHasXmp;
end;

procedure TThumbsbrowser_MetaData_FileRcd.Init(theFileName: string; bIsUrl, bIsWia, bIsWPD, bHasExif: boolean;
  bHasIptc: boolean; bHasDicom: boolean; bHasXmp: boolean; iThumbOrientation: integer; theWiaItem: TIEWiaItem;
  theWPDObjID: String; bThumbHasFullImg: boolean; theThumbImg: TIEBitmap);
begin
  InitShort(theFileName);
  InitMeta(bHasExif, bHasIptc, bHasDicom, bHasXmp);

  fIsUrl := bIsUrl;
  fIsWia := bIsWia;
  fIsWPD := bIsWPD;
  fThumbOrientation := iThumbOrientation;
  fWiaItem := theWiaItem;
  fWPDObjectID := theWPDObjID;
  fThumbHasFullImg := bThumbHasFullImg;
  fThumbImg := theThumbImg;
end;

procedure TThumbsbrowser_MetaData_FileRcd.InitMeta(bHasExif, bHasIptc, bHasDicom, bHasXmp: boolean);
begin
  fHasExif := bHasExif;
  fHasIptc := bHasIptc;
  fHasDicom := bHasDicom;
  fHasXmp := bHasXmp;
  fMetaInitialized := true;
end;

procedure TThumbsbrowser_MetaData_FileRcd.InitShort(theFileName: string);
begin
  fMetaInitialized := False;
  fEdited := False;

  fHasExif := true;
  fHasIptc := true;
  fHasDicom := true;
  fHasXmp := true;

  fForceExif := False;
  fForceIptc := False;
  fForceXmp := False;
  fForceDicom := False;

  FFileName := theFileName;

  fDisplayMode_Common := mdm_All;
  fDisplayMode_Exif := mdm_All;
  fDisplayMode_Iptc := mdm_All;
  fDisplayMode_Xmp := mdm_NonEmpty;
  fDisplayMode_Dicom := mdm_NonEmpty;
end;

procedure TThumbsbrowser_MetaData_FileRcd.RenameFile(theNewName: string);
begin
  FFileName := theNewName;
end;

procedure TThumbsbrowser_MetaData_FileRcd.SetHasDicom(const Value: boolean);
begin
  fHasDicom := Value;
end;

procedure TThumbsbrowser_MetaData_FileRcd.SetHasExif(const Value: boolean);
begin
  fHasExif := Value;
end;

procedure TThumbsbrowser_MetaData_FileRcd.SetHasIptc(const Value: boolean);
begin
  fHasIptc := Value;
end;

procedure TThumbsbrowser_MetaData_FileRcd.SetHasXmp(const Value: boolean);
begin
  fHasXmp := Value;
end;

{ TThumbsbrowser_MetaData_Field }

constructor TThumbsbrowser_MetaData_Field.Create(theIdx: integer; theFieldType: TThumbsbrowser_MetaData_Type;
  theValue: string; theUpdateMode: TThumbsbrowser_MetaData_FieldUpdateMode);
begin
  inherited Create;
  Init(theIdx, theFieldType, theValue, theUpdateMode);
end;

constructor TThumbsbrowser_MetaData_Field.Create(TagStr: string; Tags: TThumbsbrowser_MetaTags;
  theFieldType: TThumbsbrowser_MetaData_Type; theValue: string; theUpdateMode: TThumbsbrowser_MetaData_FieldUpdateMode);
var
  aTagCommon: TTBCommonTag;
  aTagExif: TTBExifTag;
  aTagIptc: TTBIptcTag;
  aTagXmp: TTBXmpTag;
  // aTagDicom: TTBDicomTag;
  idx: integer;
begin
  inherited Create;

  idx := -1;
  case theFieldType of
    mdft_Common:
      begin
        aTagCommon := TTBCommonTag_CreateTagByParsing(TagStr);
        if aTagCommon <> nil then
        begin
          idx := Tags.CommonTags.GetTagIdx(aTagCommon);
          aTagCommon.free;
        end;

      end;
    mdft_Exif:
      begin
        aTagExif := TTBExifTag_CreateTagByParsing(TagStr);
        if aTagExif <> nil then
        begin
          idx := Tags.ExifTags.GetTagIdx(aTagExif);
          aTagExif.free;
        end;

      end;
    mdft_Iptc:
      begin
        aTagIptc := TTBIptcTag_CreateTagByParsing(TagStr);
        if aTagIptc <> nil then
        begin
          idx := Tags.IptcTags.GetTagIdx(aTagIptc);
          aTagIptc.free;
        end;

      end;
    mdft_Xmp:
      begin
        aTagXmp := TTBXmpTag_CreateTagByParsing(TagStr);
        if aTagXmp <> nil then
        begin
          idx := Tags.XmpTags.GetTagIdx(aTagXmp);
          aTagXmp.free;
        end;

      end;
    mdft_Dicom:
      begin

      end;

  end;

  Init(idx, theFieldType, theValue, theUpdateMode);
end;

constructor TThumbsbrowser_MetaData_Field.Create(theTag: TTBGeneralTag; Tags: TThumbsbrowser_MetaTags; theValue: string;
  theUpdateMode: TThumbsbrowser_MetaData_FieldUpdateMode);
var
  idx: integer;
begin
  inherited Create;

  idx := -1;
  case theTag.DataType of
    mdft_Common:
      begin
        idx := Tags.CommonTags.GetTagIdx(TTBCommonTag(theTag));
      end;
    mdft_Exif:
      begin
        idx := Tags.ExifTags.GetTagIdx(TTBExifTag(theTag));
      end;
    mdft_Iptc:
      begin
        idx := Tags.IptcTags.GetTagIdx(TTBIptcTag(theTag));
      end;
    mdft_Xmp:
      begin
        idx := Tags.XmpTags.GetTagIdx(TTBXmpTag(theTag));
      end;
    mdft_Dicom:
      begin

      end;

  end;

  Init(idx, theTag.DataType, theValue, theUpdateMode);

end;

procedure TThumbsbrowser_MetaData_Field.Init(theIdx: integer; theFieldType: TThumbsbrowser_MetaData_Type;
  theValue: string; theUpdateMode: TThumbsbrowser_MetaData_FieldUpdateMode);
begin
  fIdx := theIdx;
  fFieldType := theFieldType;
  fValue := theValue;
  fUpdateMode := theUpdateMode;
end;

{ TThumbsbrowser_MetaData_FieldsList }

function TThumbsbrowser_MetaData_FieldsList.GetField(idx: integer): TThumbsbrowser_MetaData_Field;
begin
  if (idx < 0) or (idx > Count - 1) then
    result := nil
  else
    result := TThumbsbrowser_MetaData_Field(Items[idx]);
end;

procedure TThumbsbrowser_MetaData_FieldsList.Add(aObject: TObject);
begin
  inherited Add(aObject);
end;

function TThumbsbrowser_MetaData_FieldsList.FieldExists(theField: TThumbsbrowser_MetaData_Field): integer;
var
  i: integer;
  f: TThumbsbrowser_MetaData_Field;
begin
  result := -1;
  for i := 0 to Count - 1 do
  begin
    f := Field[i];
    if (f.FieldType = theField.FieldType) and (f.idx = theField.idx) then
    begin
      result := i;
      break;
    end;

  end;
end;

procedure TThumbsbrowser_MetaData_FieldsList.SetFieldValue(idx: integer; theValue: string);
var
  f: TThumbsbrowser_MetaData_Field;
begin
  f := Field[idx];
  f.Value := theValue;

  TBMetaDataWriteFieldAsStr(fIoParams, f.FieldType, f.idx, f.Value, fMetaTags);
  fCommonModified := f.FieldType = mdft_Common;
  fExifModified := (f.FieldType = mdft_Exif) OR
    ((f.FieldType = mdft_Common) and (fMetaTags.CommonTags[f.idx].LinkedEXIFTags.Count > 0));
  fIPTCModified := (f.FieldType = mdft_Iptc) OR
    ((f.FieldType = mdft_Common) and (fMetaTags.CommonTags[f.idx].LinkedIPTCTags.Count > 0));
  fXmpModified := (f.FieldType = mdft_Xmp) OR
    ((f.FieldType = mdft_Common) and (fMetaTags.CommonTags[f.idx].LinkedXMPTags.Count > 0));;
  fDICOMModified := f.FieldType = mdft_Dicom;

end;

procedure TThumbsbrowser_MetaData_FieldsList.AddField(theField: TThumbsbrowser_MetaData_Field);

var
  eIdx: integer;
begin

  eIdx := FieldExists(theField);
  if eIdx <> -1 then
  begin
    SetFieldValue(eIdx, theField.Value); // updates with new value
  end
  else
  begin
    Add(theField);
    SetFieldValue(Count - 1, theField.Value); // updates with new value
  end;

end;

procedure TThumbsbrowser_MetaData_FieldsList.Clear;
begin
  inherited;
  ResetModified;
end;

procedure TThumbsbrowser_MetaData_FieldsList.Remove(aObject: TObject);
begin
  inherited Remove(aObject);
  CheckModified;
end;

procedure TThumbsbrowser_MetaData_FieldsList.ResetModified;
begin
  fIPTCModified := False;
  fDICOMModified := False;
  fExifModified := False;
  fCommonModified := False;
  fXmpModified := False;
end;

procedure TThumbsbrowser_MetaData_FieldsList.CheckModified;
var
  i: integer;
  comTag: TTBCommonTag;
begin
  fIPTCModified := False;
  fDICOMModified := False;
  fExifModified := False;
  fCommonModified := False;
  fXmpModified := False;
  for i := 0 to Count - 1 do
  begin
    if fExifModified and fIPTCModified and fDICOMModified and fXmpModified and fCommonModified then
      break;

    if (Field[i].FieldType = mdft_Common) then
    begin
      fCommonModified := true;
      comTag := fMetaTags.CommonTags[Field[i].idx];
      fExifModified := comTag.LinkedEXIFTags.Count > 0;
      fIPTCModified := comTag.LinkedIPTCTags.Count > 0;
      fXmpModified := comTag.LinkedXMPTags.Count > 0;
    end
    else if (Field[i].FieldType = mdft_Exif) then
    begin
      fExifModified := true;
    end
    else if (Field[i].FieldType = mdft_Iptc) then
    begin
      fIPTCModified := true;
    end
    else if (Field[i].FieldType = mdft_Dicom) then
    begin
      fDICOMModified := true;
    end
    else if (Field[i].FieldType = mdft_Xmp) then
    begin
      fXmpModified := true;
    end;

  end;

end;

constructor TThumbsbrowser_MetaData_FieldsList.Create(theMetaTags: TThumbsbrowser_MetaTags; theIoParams: TIOParams);
begin
  fMetaTags := theMetaTags;
  fIoParams := theIoParams;

  ResetModified;

end;

{ TThumbsbrowser_MetaData_Options }

constructor TThumbsbrowser_MetaData_Options.Create;
begin
  inherited Create;

  fFields_Exif := Tstringlist.Create;
  fFields_IPTC := Tstringlist.Create;
  fFields_Xmp := Tstringlist.Create;
  fFields_Common := Tstringlist.Create;

  fSyncField_Rating := '';
  fSyncField_Keywords := '';
  fSyncField_Bottomtitle := '';
  fSyncField_TopTitle := '';

  fAutoSync_Rating := mdSyncOp_ReadWrite;
  fAutoSync_Keywords := mdSyncOp_ReadWrite;
  fAutoSync_BottomTitle := mdSyncOp_ReadWrite;
  fAutoSync_TopTitle := mdSyncOp_ReadWrite;

  fUseExifOrientationForThumbs := true;

end;

procedure TThumbsbrowser_MetaData_Options.SetFields_Common(const Value: Tstringlist);
begin
  fFields_Common.Assign(Value);
  if assigned(fOnCommonFieldsChanged) then
    fOnCommonFieldsChanged(self);
end;

procedure TThumbsbrowser_MetaData_Options.SetFields_Exif(const Value: Tstringlist);
begin
  fFields_Exif.Assign(Value);
  if assigned(fOnExifFieldsChanged) then
    fOnExifFieldsChanged(self);
end;

procedure TThumbsbrowser_MetaData_Options.SetFields_IPTC(const Value: Tstringlist);
begin
  fFields_IPTC.Assign(Value);
  if assigned(fOnIptcFieldsChanged) then
    fOnIptcFieldsChanged(self);
end;

procedure TThumbsbrowser_MetaData_Options.setKeywords_SyncCommonField(const Value: string);
var
  oldValue: string;
begin
  if not TTBCommonTag_ParseString(Value) then
  begin
    showmessage('Could not Parse Tag');
    EXIT;
  end;

  oldValue := fSyncField_Keywords;
  fSyncField_Keywords := Value;

  if assigned(fOnSyncTagChanged) then
    fOnSyncTagChanged(self, mdSyncKeywords, oldValue, Value);
end;

procedure TThumbsbrowser_MetaData_Options.setRating_SyncCommonField(const Value: string);
var
  oldValue: string;
begin
  if not TTBCommonTag_ParseString(Value) then
  begin
    showmessage('Could not Parse Tag');
    EXIT;
  end;

  oldValue := fSyncField_Rating;
  fSyncField_Rating := Value;

  if assigned(fOnSyncTagChanged) then
    fOnSyncTagChanged(self, mdSyncRating, oldValue, Value);
end;

procedure TThumbsbrowser_MetaData_Options.setTopTitle_SyncCommonField(const Value: string);
var
  oldValue: string;
begin
  if not TTBCommonTag_ParseString(Value) then
  begin
    showmessage('Could not Parse Tag');
    EXIT;
  end;
  oldValue := fSyncField_TopTitle;
  fSyncField_TopTitle := Value;

  if assigned(fOnSyncTagChanged) then
    fOnSyncTagChanged(self, mdSyncTopTitle, oldValue, Value);
end;

procedure TThumbsbrowser_MetaData_Options.setAutoSync_BottomTitle(const Value: TThumbsbrowser_MetaData_SyncOpType);
var
  oldValue: TThumbsbrowser_MetaData_SyncOpType;
begin
  if fAutoSync_BottomTitle = Value then
    EXIT;

  oldValue := fAutoSync_BottomTitle;

  fAutoSync_BottomTitle := Value;

  if assigned(fOnAutoSyncOptionsChanged) then
    fOnAutoSyncOptionsChanged(self, mdSyncBottomTitle, oldValue, Value);

end;

procedure TThumbsbrowser_MetaData_Options.setAutoSync_Keywords(const Value: TThumbsbrowser_MetaData_SyncOpType);
var
  oldValue: TThumbsbrowser_MetaData_SyncOpType;
begin
  if fAutoSync_Keywords = Value then
    EXIT;

  oldValue := fAutoSync_Keywords;

  fAutoSync_Keywords := Value;

  if assigned(fOnAutoSyncOptionsChanged) then
    fOnAutoSyncOptionsChanged(self, mdSyncKeywords, oldValue, Value);

end;

procedure TThumbsbrowser_MetaData_Options.setAutoSync_Rating(const Value: TThumbsbrowser_MetaData_SyncOpType);
var
  oldValue: TThumbsbrowser_MetaData_SyncOpType;
begin
  if fAutoSync_Rating = Value then
    EXIT;

  oldValue := fAutoSync_Rating;

  fAutoSync_Rating := Value;

  if assigned(fOnAutoSyncOptionsChanged) then
    fOnAutoSyncOptionsChanged(self, mdSyncRating, oldValue, Value);

end;

procedure TThumbsbrowser_MetaData_Options.setAutoSync_TopTitle(const Value: TThumbsbrowser_MetaData_SyncOpType);
var
  oldValue: TThumbsbrowser_MetaData_SyncOpType;
begin
  if fAutoSync_TopTitle = Value then
    EXIT;

  oldValue := fAutoSync_TopTitle;

  fAutoSync_TopTitle := Value;

  if assigned(fOnAutoSyncOptionsChanged) then
    fOnAutoSyncOptionsChanged(self, mdSyncTopTitle, oldValue, Value);
end;

procedure TThumbsbrowser_MetaData_Options.setBottomTitle_SyncCommonField(const Value: string);
var
  oldValue: string;
begin
  if not TTBCommonTag_ParseString(Value) then
  begin
    showmessage('Could not Parse Tag');
    EXIT;
  end;

  oldValue := fSyncField_Bottomtitle;
  fSyncField_Bottomtitle := Value;

  if assigned(fOnSyncTagChanged) then
    fOnSyncTagChanged(self, mdSyncBottomTitle, oldValue, Value);
end;

procedure TThumbsbrowser_MetaData_Options.SetFields_Xmp(const Value: Tstringlist);
begin
  fFields_Xmp.Assign(Value);
  if assigned(fOnXmpFieldsChanged) then
    fOnXmpFieldsChanged(self);
end;

procedure TThumbsbrowser_MetaData_Options.Update;
begin
  if assigned(fOnExifFieldsChanged) then
    fOnExifFieldsChanged(self);
  if assigned(fOnIptcFieldsChanged) then
    fOnIptcFieldsChanged(self);
  if assigned(fOnXmpFieldsChanged) then
    fOnXmpFieldsChanged(self);
  if assigned(fOnCommonFieldsChanged) then
    fOnCommonFieldsChanged(self);
end;

destructor TThumbsbrowser_MetaData_Options.Destroy;
begin
  fFields_Common.free;
  fFields_Exif.free;
  fFields_IPTC.free;
  fFields_Xmp.free;
  inherited;
end;

function TThumbsbrowser_MetaData_Options.GetAutoSyncOption(syncType: TThumbsbrowser_MetaData_SyncType)
  : TThumbsbrowser_MetaData_SyncOpType;
begin
  case syncType of
    mdSyncTopTitle:
      result := fAutoSync_TopTitle;
    mdSyncBottomTitle:
      result := fAutoSync_BottomTitle;
    mdSyncRating:
      result := fAutoSync_Rating;
    mdSyncKeywords:
      result := fAutoSync_Keywords;
  else
    result := mdSyncOpNone;
  end;
end;

function TThumbsbrowser_MetaData_Options.GetSyncTag(syncType: TThumbsbrowser_MetaData_SyncType): string;
begin
  case syncType of
    mdSyncTopTitle:
      result := fSyncField_TopTitle;
    mdSyncBottomTitle:
      result := fSyncField_Bottomtitle;
    mdSyncRating:
      result := fSyncField_Rating;
    mdSyncKeywords:
      result := fSyncField_Keywords;
  end;
end;

{ TTBIptcTag }

constructor TTBIptcTag.Create(const theRec, theDSet: integer);
var
  resId: integer;
begin
  resId := LUT_IPTC_STRID(theRec, theDSet);
  inherited Create(mdft_Iptc, resId);
  fRec := theRec;
  fDSet := theDSet;
  fDesc := TBResStr[resId];
end;

constructor TTBIptcTag.Create(const theRec, theDSet: integer; const theDescr: string);
begin
  Create(theRec, theDSet);
  fDesc := theDescr;
end;

{ TTBIptcTags }

procedure TTBIptcTags.Add(aObject: TObject);
begin
  Assert(aObject is TTBIptcTag);
  inherited Add(aObject);
end;

procedure TTBIptcTags.Add(TagStr: string);
var
  theRec, theDSet: integer;
var
  theDescr: string;
begin
  if TTBIptcTag_ParseString(TagStr, theRec, theDSet, theDescr) then
    Add(TTBIptcTag.Create(theRec, theDSet, theDescr));
end;

procedure TTBIptcTags.Assign(Source: TObject);
var
  src: TTBIptcTags;
  i: integer;
begin
  if not(Source is TTBIptcTags) then
    EXIT;

  src := TTBIptcTags(Source);
  Clear;
  for i := 0 to src.Count - 1 do
    Add(TTBIptcTag.Create(src[i].Rec, src[i].fDSet, src[i].Desc));
end;

constructor TTBIptcTags.Create(const bFill: boolean);
begin
  inherited Create;
  if bFill then
    InitTags;
end;

constructor TTBIptcTags.Create;
begin
  inherited Create;
  InitTags;

end;

function TTBIptcTags.GetTagIdx(theTag: TTBIptcTag): integer;
var
  i: integer;
begin
  result := -1;
  for i := 0 to Count - 1 do
    if (GetTag(i).Rec = theTag.Rec) and (GetTag(i).DSet = theTag.DSet) then
    begin
      result := i;
      break;
    end;

end;

function TTBIptcTags.GetTagAsStr(idx: integer): string;
begin
  result := TTBIptcTag_GetTagAsStr(Tags[idx]);
end;

function TTBIptcTags.GetTag(idx: integer): TTBIptcTag;
begin
  result := TTBIptcTag(Items[idx]);
end;

procedure TTBIptcTags.InitTags;
begin
  Add(TTBIptcTag.Create(PhotoShop_IPTC_Records, IPTC_PS_Title));
  Add(TTBIptcTag.Create(PhotoShop_IPTC_Records, IPTC_PS_Caption));
  Add(TTBIptcTag.Create(PhotoShop_IPTC_Records, IPTC_PS_Keywords));
  Add(TTBIptcTag.Create(PhotoShop_IPTC_Records, IPTC_PS_Instructions));
  Add(TTBIptcTag.Create(PhotoShop_IPTC_Records, IPTC_PS_Date_Created));
  Add(TTBIptcTag.Create(PhotoShop_IPTC_Records, IPTC_PS_Time_Created));
  Add(TTBIptcTag.Create(PhotoShop_IPTC_Records, IPTC_PS_Byline_1));
  Add(TTBIptcTag.Create(PhotoShop_IPTC_Records, IPTC_PS_Byline_2));
  Add(TTBIptcTag.Create(PhotoShop_IPTC_Records, IPTC_PS_City));
  Add(TTBIptcTag.Create(PhotoShop_IPTC_Records, IPTC_PS_State_Province));
  Add(TTBIptcTag.Create(PhotoShop_IPTC_Records, IPTC_PS_Country_Code));
  Add(TTBIptcTag.Create(PhotoShop_IPTC_Records, IPTC_PS_Country));
  Add(TTBIptcTag.Create(PhotoShop_IPTC_Records, IPTC_PS_Transmission_Reference));
  Add(TTBIptcTag.Create(PhotoShop_IPTC_Records, IPTC_PS_Credit));
  Add(TTBIptcTag.Create(PhotoShop_IPTC_Records, IPTC_PS_Writer));
  Add(TTBIptcTag.Create(PhotoShop_IPTC_Records, IPTC_PS_Edit_Status));
  Add(TTBIptcTag.Create(PhotoShop_IPTC_Records, IPTC_PS_Urgency));
  Add(TTBIptcTag.Create(PhotoShop_IPTC_Records, IPTC_PS_Category));
  Add(TTBIptcTag.Create(PhotoShop_IPTC_Records, IPTC_PS_Category_2));
  Add(TTBIptcTag.Create(PhotoShop_IPTC_Records, IPTC_PS_Fixture_Identifier));
  Add(TTBIptcTag.Create(PhotoShop_IPTC_Records, IPTC_PS_Release_Date));
  Add(TTBIptcTag.Create(PhotoShop_IPTC_Records, IPTC_PS_Release_Time));
  Add(TTBIptcTag.Create(PhotoShop_IPTC_Records, IPTC_PS_Reference_Service));
  Add(TTBIptcTag.Create(PhotoShop_IPTC_Records, IPTC_PS_Reference_Date));
  Add(TTBIptcTag.Create(PhotoShop_IPTC_Records, IPTC_PS_Reference_Number));
  Add(TTBIptcTag.Create(PhotoShop_IPTC_Records, IPTC_PS_Originating_Program));
  Add(TTBIptcTag.Create(PhotoShop_IPTC_Records, IPTC_PS_Program_Version));
  Add(TTBIptcTag.Create(PhotoShop_IPTC_Records, IPTC_PS_Object_Cycle));
  Add(TTBIptcTag.Create(PhotoShop_IPTC_Records, IPTC_PS_Image_Type));
  Add(TTBIptcTag.Create(PhotoShop_IPTC_Records, IPTC_PS_Copyright_Notice));

end;

procedure TTBIptcTags.SetTag(idx: integer; const Value: TTBIptcTag);
begin
  if OwnsObjects and (Items[idx] <> nil) then
    Items[idx].free;
  Items[idx] := Value;
end;

procedure TTBIptcTags.SetTagAsStr(idx: integer; const Value: string);
var
  aIptcTag: TTBIptcTag;
begin
  aIptcTag := TTBIptcTag_CreateTagByParsing(Value);
  if aIptcTag <> nil then
    SetTag(idx, aIptcTag);
end;

{ TTBXmpTag }

constructor TTBXmpTag.Create(const theName: string);
var
  resId: integer;
begin
  resId := LUT_XMP_STRID(theName);
  inherited Create(mdft_Xmp, resId);
  fName := theName;
  fDesc := TBResStr[resId];
end;

constructor TTBXmpTag.Create(const theName, theDesc: string);
begin
  Create(theName);
  fDesc := theDesc;
end;

{ TTBXmpTags }

procedure TTBXmpTags.Add(TagStr: string);
var
  sName, sDesc: string;
begin
  if TTBXmpTag_ParseString(TagStr, sName, sDesc) then
    Add(TTBXmpTag.Create(sName, sDesc));
end;

procedure TTBXmpTags.Assign(Source: TObject);
var
  src: TTBXmpTags;
  i: integer;
begin
  if not(Source is TTBXmpTags) then
    EXIT;

  src := TTBXmpTags(Source);
  Clear;
  for i := 0 to src.Count - 1 do
    Add(TTBXmpTag.Create(src[i].Name, src[i].Desc));

end;

procedure TTBXmpTags.Add(aObject: TObject);
begin
  Assert(aObject is TTBXmpTag);
  inherited Add(aObject);
end;

constructor TTBXmpTags.Create;
begin
  inherited Create;

  InitTags;
end;

constructor TTBXmpTags.Create(const bFill: boolean);
begin
  inherited Create;

  if bFill then
    InitTags;
end;

function TTBXmpTags.GetTagIdx(theTag: TTBXmpTag): integer;
var
  i: integer;
begin
  result := -1;
  for i := 0 to Count - 1 do
    if (GetTag(i).Name = theTag.Name) then
    begin
      result := i;
      break;
    end;

end;

function TTBXmpTags.GetTag(idx: integer): TTBXmpTag;
begin
  result := TTBXmpTag(Items[idx]);
end;

procedure TTBXmpTags.InitTags;
begin
{$IFDEF NWSCOMPS_TB_METADATA_USEHELPERS}
  Add(TTBXmpTag.Create(XMP_Aux_ApproximateFocusDistance));
  Add(TTBXmpTag.Create(XMP_Aux_Firmware));
  Add(TTBXmpTag.Create(XMP_Aux_FlashCompensation));
  Add(TTBXmpTag.Create(XMP_Aux_ImageNumber));
  Add(TTBXmpTag.Create(XMP_Aux_Lens));
  Add(TTBXmpTag.Create(XMP_Aux_LensID));
  Add(TTBXmpTag.Create(XMP_Aux_LensInfo));
  Add(TTBXmpTag.Create(XMP_Aux_LensSerialNumber));
  Add(TTBXmpTag.Create(XMP_Aux_OwnerName));
  Add(TTBXmpTag.Create(XMP_Aux_SerialNumber));
  Add(TTBXmpTag.Create(XMP_CC_AttributionName));
  Add(TTBXmpTag.Create(XMP_CC_AttributionURL));
  Add(TTBXmpTag.Create(XMP_CC_DeprecatedOn));
  Add(TTBXmpTag.Create(XMP_CC_Jurisdiction));
  Add(TTBXmpTag.Create(XMP_CC_LegalCode));
  Add(TTBXmpTag.Create(XMP_CC_License));
  Add(TTBXmpTag.Create(XMP_CC_MorePermissions));
  Add(TTBXmpTag.Create(XMP_CC_Permits));
  Add(TTBXmpTag.Create(XMP_CC_Prohibits));
  Add(TTBXmpTag.Create(XMP_CC_Requires));
  Add(TTBXmpTag.Create(XMP_CC_UseGuidelines));

  Add(TTBXmpTag.Create(XMP_DC_Contributor));
  Add(TTBXmpTag.Create(XMP_DC_Coverage));
  Add(TTBXmpTag.Create(XMP_DC_Creator));
  Add(TTBXmpTag.Create(XMP_DC_Date));
  Add(TTBXmpTag.Create(XMP_DC_Description));
  Add(TTBXmpTag.Create(XMP_DC_Format));
  Add(TTBXmpTag.Create(XMP_DC_Identifier));
  Add(TTBXmpTag.Create(XMP_DC_Language));
  Add(TTBXmpTag.Create(XMP_DC_Publisher));
  Add(TTBXmpTag.Create(XMP_DC_Relation));
  Add(TTBXmpTag.Create(XMP_DC_Rights));
  Add(TTBXmpTag.Create(XMP_DC_Source));
  Add(TTBXmpTag.Create(XMP_DC_Subject));
  Add(TTBXmpTag.Create(XMP_DC_Title));
  Add(TTBXmpTag.Create(XMP_DC_Type));

  Add(TTBXmpTag.Create(XMP_Photoshop_AuthorsPosition));
  Add(TTBXmpTag.Create(XMP_Photoshop_CaptionWriter));
  Add(TTBXmpTag.Create(XMP_Photoshop_Category));
  Add(TTBXmpTag.Create(XMP_Photoshop_City));
  Add(TTBXmpTag.Create(XMP_Photoshop_ColorMode));
  Add(TTBXmpTag.Create(XMP_Photoshop_Country));
  Add(TTBXmpTag.Create(XMP_Photoshop_Credit));
  Add(TTBXmpTag.Create(XMP_Photoshop_DateCreated));
  Add(TTBXmpTag.Create(XMP_Photoshop_DocumentAncestorID));
  Add(TTBXmpTag.Create(XMP_Photoshop_Headline));
  Add(TTBXmpTag.Create(XMP_Photoshop_History));
  Add(TTBXmpTag.Create(XMP_Photoshop_ICCProfileName));
  Add(TTBXmpTag.Create(XMP_Photoshop_Instructions));
  Add(TTBXmpTag.Create(XMP_Photoshop_Source));
  Add(TTBXmpTag.Create(XMP_Photoshop_State));
  Add(TTBXmpTag.Create(XMP_Photoshop_SupplementalCategories));
  Add(TTBXmpTag.Create(XMP_Photoshop_TextLayerName));
  Add(TTBXmpTag.Create(XMP_Photoshop_TextLayerText));
  Add(TTBXmpTag.Create(XMP_Photoshop_TransmissionReference));
  Add(TTBXmpTag.Create(XMP_Photoshop_Urgency));

  Add(TTBXmpTag.Create(XMP_Advisory));
  Add(TTBXmpTag.Create(XMP_Author));
  Add(TTBXmpTag.Create(XMP_BaseURL));
  Add(TTBXmpTag.Create(XMP_CreateDate));
  Add(TTBXmpTag.Create(XMP_CreatorTool));
  Add(TTBXmpTag.Create(XMP_Description));
  Add(TTBXmpTag.Create(XMP_Format));
  Add(TTBXmpTag.Create(XMP_Identifier));
  Add(TTBXmpTag.Create(XMP_Keywords));
  Add(TTBXmpTag.Create(XMP_Label));
  Add(TTBXmpTag.Create(XMP_MetadataDate));
  Add(TTBXmpTag.Create(XMP_ModifyDate));
  Add(TTBXmpTag.Create(XMP_Nickname));
  Add(TTBXmpTag.Create(XMP_Rating));
  Add(TTBXmpTag.Create(XMP_Title));

{$ENDIF}
end;

procedure TTBXmpTags.SetTag(idx: integer; const Value: TTBXmpTag);
begin
  if OwnsObjects and (Items[idx] <> nil) then
    Items[idx].free;
  Items[idx] := Value;
end;

procedure TTBXmpTags.SetTagAsStr(idx: integer; const Value: string);
var
  aXmpTag: TTBXmpTag;
begin
  aXmpTag := TTBXmpTag_CreateTagByParsing(Value);
  if aXmpTag <> nil then
    SetTag(idx, aXmpTag);
end;

function TTBXmpTags.GetTagAsStr(idx: integer): string;
begin
  result := TTBXmpTag_GetTagAsStr(GetTag(idx));
end;

{ TTBCommonTag }
constructor TTBCommonTag.Create(theLinkedExifTags: TTBExifTags; theLinkedIPTCTags: TTBIptcTags;
  theLinkedXmpTags: TTBXmpTags; theDesc: string; theLangStrId: integer);
begin
  inherited Create(mdft_Common, theLangStrId);

  fLinkedExifTags := theLinkedExifTags;
  fLinkedIptcTags := theLinkedIPTCTags;
  fLinkedXMPTags := theLinkedXmpTags;

  fDesc := theDesc;
end;

destructor TTBCommonTag.Destroy;
begin
  if assigned(fLinkedExifTags) then
    fLinkedExifTags.free;

  if assigned(fLinkedIptcTags) then
    fLinkedIptcTags.free;

  if assigned(fLinkedXMPTags) then
    fLinkedXMPTags.free;

  inherited Destroy;
end;

function TTBCommonTag.GetDesc: string;
begin
  if fDesc = '' then
  begin
    if fLinkedXMPTags.Count > 0 then
      result := fLinkedXMPTags[0].Desc
    else if fLinkedIptcTags.Count > 0 then
      result := fLinkedIptcTags[0].Desc
    else if fLinkedExifTags.Count > 0 then
      result := fLinkedExifTags[0].Desc;
  end
  else
    result := fDesc;

end;

{ TTBCommonTags }
procedure TTBCommonTags.Add(TagStr: string);
var
  aCommonTag: TTBCommonTag;
begin
  aCommonTag := TTBCommonTag_CreateTagByParsing(TagStr);
  if aCommonTag <> nil then
  begin
    Add(aCommonTag);
  end;

end;

procedure TTBCommonTags.Assign(Source: TObject);
var
  src: TTBCommonTags;
  i: integer;

begin
  if not(Source is TTBCommonTags) then
    EXIT;

  src := TTBCommonTags(Source);
  Clear;
  for i := 0 to src.Count - 1 do
  begin
    Add(TTBCommonTag_CreateTagByParsing(src.GetTagAsStr(i)));
  end;

end;

procedure TTBCommonTags.Add(aObject: TObject);
begin
  Assert(aObject is TTBCommonTag);
  inherited Add(aObject);
end;

constructor TTBCommonTags.Create(const bFill: boolean);
begin
  inherited Create;
  if bFill then
    InitTags;
end;

function TTBCommonTags.GetTagIdx(theTag: TTBCommonTag): integer;
var
  i: integer;
  TagStr: string;
begin
  result := -1;
  TagStr := TTBCommonTag_GetTagAsStr(theTag);
  for i := 0 to Count - 1 do
    if GetTagAsStr(i) = TagStr then
    begin
      result := i;
      break;
    end;

end;

constructor TTBCommonTags.Create;
begin
  Inherited Create;
  InitTags;

end;

function TTBCommonTags.GetTag(idx: integer): TTBCommonTag;
begin
  result := TTBCommonTag(Items[idx]);
end;

procedure TTBCommonTags.InitTags;
var
  LinkedEXIFTags: TTBExifTags;
  LinkedIPTCTags: TTBIptcTags;
  LinkedXMPTags: TTBXmpTags;
begin


  // Iptc copyright          ->  Xmp.PS Copyright
  // Iptc Country            ->  XMP.PS Country
  // Iptc Creator            ->  XMP.PS Author
  // IPTC Creator job title  ->  XMP.PS Author Title
  // IPTC Credit line        ->  XMP.PS credit
  // IPTC Copyright notice   ->  XMP.PS Copyright notice
  // IPTC Country            ->  XMP.PS Country
  // IPTC Date created       ->  XMP.PS Date created
  // IPTC Description        ->  XMP.PS Description
  // IPTC Description Writer ->  XMP.PS Description Writer
  // IPTC Title              ->  XMP.PS Headline
  // IPTC Instructions       ->  XMP.PS Instructions



  // -----------------------------------------------------------------------------------------
  // 1st common tag
  {
    RS_EXIF_XPTitle
    RS_IPTCTAG_PS_Title
    RS_XMP_DC_Title
  }

  LinkedEXIFTags := TTBExifTags.Create(False);
  LinkedEXIFTags.Add(TTBExifTag.Create(IDX_EXIF_XPTitle));

  LinkedIPTCTags := TTBIptcTags.Create(False);
  LinkedIPTCTags.Add(TTBIptcTag.Create(PhotoShop_IPTC_Records, IPTC_PS_Title));

  LinkedXMPTags := TTBXmpTags.Create(False);
  LinkedXMPTags.Add(TTBXmpTag.Create(XMP_DC_Title));

  Add(TTBCommonTag.Create(LinkedEXIFTags, LinkedIPTCTags, LinkedXMPTags, '', -1));

  // 2nd common tag
  {
    RS_EXIF_XPSubject
    RS_IPTCTAG_PS_Caption
    RS_XMP_DC_Subject
  }
  LinkedEXIFTags := TTBExifTags.Create(False);
  LinkedEXIFTags.Add(TTBExifTag.Create(IDX_EXIF_XPSubject));

  LinkedIPTCTags := TTBIptcTags.Create(False);
  LinkedIPTCTags.Add(TTBIptcTag.Create(PhotoShop_IPTC_Records, IPTC_PS_Caption));

  LinkedXMPTags := TTBXmpTags.Create(False);
  LinkedXMPTags.Add(TTBXmpTag.Create(XMP_DC_Subject));

  Add(TTBCommonTag.Create(LinkedEXIFTags, LinkedIPTCTags, LinkedXMPTags, '', -1));

  // 3rd common tag
  {
    RS_EXIF_XPComment
    RS_XMP_DC_Description
  }

  LinkedEXIFTags := TTBExifTags.Create(False);
  LinkedEXIFTags.Add(TTBExifTag.Create(IDX_EXIF_XPComment));

  LinkedIPTCTags := TTBIptcTags.Create(False);

  LinkedXMPTags := TTBXmpTags.Create(False);
  LinkedXMPTags.Add(TTBXmpTag.Create(XMP_DC_Description));

  Add(TTBCommonTag.Create(LinkedEXIFTags, LinkedIPTCTags, LinkedXMPTags, '', -1));

  // 4th common tag
  {
    RS_EXIF_XPRating
    RS_XMP_Rating
  }
  LinkedEXIFTags := TTBExifTags.Create(False);
  LinkedEXIFTags.Add(TTBExifTag.Create(IDX_EXIF_XPRating));

  LinkedIPTCTags := TTBIptcTags.Create(False);

  LinkedXMPTags := TTBXmpTags.Create(False);
  LinkedXMPTags.Add(TTBXmpTag.Create(XMP_Rating));

  Add(TTBCommonTag.Create(LinkedEXIFTags, LinkedIPTCTags, LinkedXMPTags, '', -1));



  // 5th common tag
  {
    RS_EXIF_XPKeywords
    RS_XMP_Keywords
  }

  LinkedEXIFTags := TTBExifTags.Create(False);
  LinkedEXIFTags.Add(TTBExifTag.Create(IDX_EXIF_XPKeywords));

  LinkedIPTCTags := TTBIptcTags.Create(False);
  LinkedIPTCTags.Add(TTBIptcTag.Create(PhotoShop_IPTC_Records, IPTC_PS_Keywords));

  LinkedXMPTags := TTBXmpTags.Create(False);
  LinkedXMPTags.Add(TTBXmpTag.Create(XMP_Keywords));

  Add(TTBCommonTag.Create(LinkedEXIFTags, LinkedIPTCTags, LinkedXMPTags, '', -1));

  // 6th common tag
  {
    RS_IPTCTAG_PS_Category
    RS_XMP_Photoshop_Category
  }

  LinkedEXIFTags := TTBExifTags.Create(False);

  LinkedIPTCTags := TTBIptcTags.Create(False);
  LinkedIPTCTags.Add(TTBIptcTag.Create(PhotoShop_IPTC_Records, IPTC_PS_Category));

  LinkedXMPTags := TTBXmpTags.Create(False);
  LinkedXMPTags.Add(TTBXmpTag.Create(XMP_Photoshop_Category));

  Add(TTBCommonTag.Create(LinkedEXIFTags, LinkedIPTCTags, LinkedXMPTags, '', -1));

  // 7th common tag
  {
    RS_IPTCTAG_PS_SupplCategory
    RS_XMP_Photoshop_SupplementalCategories
  }
  LinkedEXIFTags := TTBExifTags.Create(False);

  LinkedIPTCTags := TTBIptcTags.Create(False);
  LinkedIPTCTags.Add(TTBIptcTag.Create(PhotoShop_IPTC_Records, IPTC_PS_Category_2));

  LinkedXMPTags := TTBXmpTags.Create(False);
  LinkedXMPTags.Add(TTBXmpTag.Create(XMP_Photoshop_SupplementalCategories));

  Add(TTBCommonTag.Create(LinkedEXIFTags, LinkedIPTCTags, LinkedXMPTags, '', -1));

end;

procedure TTBCommonTags.SetLanguage(theLanguage: TNWSCompsLanguage; bForceTranslate: boolean = False);
var
  i: integer;
begin
  inherited;

  for i := 0 to Count - 1 do
  begin
    Tags[i].LinkedEXIFTags.SetLanguage(theLanguage, true);
    Tags[i].LinkedIPTCTags.SetLanguage(theLanguage, true);
    Tags[i].LinkedXMPTags.SetLanguage(theLanguage, true);
  end;
end;

procedure TTBCommonTags.SetTag(idx: integer; const Value: TTBCommonTag);
begin
  if OwnsObjects and (Items[idx] <> nil) then
    Items[idx].free;
  Items[idx] := Value;
end;

procedure TTBCommonTags.SetTagAsStr(idx: integer; const Value: string);
var
  aCommonTag: TTBCommonTag;
begin
  aCommonTag := TTBCommonTag_CreateTagByParsing(Value);
  if aCommonTag <> nil then
    SetTag(idx, aCommonTag);

end;

function TTBCommonTags.GetTagAsStr(idx: integer): string;
begin
  result := TTBCommonTag_GetTagAsStr(GetTag(idx));

end;

{ TTBExifTag }

constructor TTBExifTag.Create(const theIdx: integer);
var
  resId: integer;
begin
  resId := LUT_EXIF_STRID(theIdx);
  inherited Create(mdft_Exif, resId);
  fIdx := theIdx;
  fDesc := TBResStr[resId];
end;

constructor TTBExifTag.Create(const theIdx: integer; const theDesc: string);
begin
  Create(theIdx);
  fDesc := theDesc;
end;

{ TTBExifTags }

procedure TTBExifTags.Add(TagStr: string);
var
  sDesc: string;
  idx: integer;
begin
  if TTBExifTag_ParseString(TagStr, idx, sDesc) then
    Add(TTBExifTag.Create(idx, sDesc));
end;

procedure TTBExifTags.Assign(Source: TObject);
var
  src: TTBExifTags;
  i: integer;
begin
  if not(Source is TTBExifTags) then
    EXIT;

  src := TTBExifTags(Source);
  Clear;
  for i := 0 to src.Count - 1 do
    Add(TTBExifTag.Create(src[i].idx, src[i].Desc));

end;

procedure TTBExifTags.Add(aObject: TObject);
begin
  Assert(aObject is TTBExifTag);
  inherited Add(aObject);
end;

constructor TTBExifTags.Create(const bFill: boolean);
begin
  inherited Create;
  if bFill then
    InitTags;
end;

constructor TTBExifTags.Create;
begin
  inherited Create;
  InitTags;
end;

procedure TTBExifTags.InitTags;
begin
  Add(TTBExifTag.Create(IDX_EXIF_UserComment));
  Add(TTBExifTag.Create(IDX_EXIF_ImageDescription));
  Add(TTBExifTag.Create(IDX_EXIF_CameraMake));
  Add(TTBExifTag.Create(IDX_EXIF_CameraModel));
  Add(TTBExifTag.Create(IDX_EXIF_XResolution));
  Add(TTBExifTag.Create(IDX_EXIF_YResolution));
  Add(TTBExifTag.Create(IDX_EXIF_DateTime));
  Add(TTBExifTag.Create(IDX_EXIF_DateTimeOriginal));
  Add(TTBExifTag.Create(IDX_EXIF_DateTimeDigitized));
  Add(TTBExifTag.Create(IDX_EXIF_Copyright));
  Add(TTBExifTag.Create(IDX_EXIF_Orientation));
  Add(TTBExifTag.Create(IDX_EXIF_ExposureTime));
  Add(TTBExifTag.Create(IDX_EXIF_FNumber));
  Add(TTBExifTag.Create(IDX_EXIF_ExposureProgram));
  Add(TTBExifTag.Create(IDX_EXIF_ISOSpeedRatings));
  Add(TTBExifTag.Create(IDX_EXIF_ShutterSpeedValue));
  Add(TTBExifTag.Create(IDX_EXIF_ApertureValue));
  Add(TTBExifTag.Create(IDX_EXIF_BrightnessValue));
  Add(TTBExifTag.Create(IDX_EXIF_ExposureBiasValue));
  Add(TTBExifTag.Create(IDX_EXIF_MaxApertureValue));
  Add(TTBExifTag.Create(IDX_EXIF_SubjectDistance));
  Add(TTBExifTag.Create(IDX_EXIF_MeteringMode));
  Add(TTBExifTag.Create(IDX_EXIF_LightSource));
  Add(TTBExifTag.Create(IDX_EXIF_Flash));
  Add(TTBExifTag.Create(IDX_EXIF_FocalLength));
  Add(TTBExifTag.Create(IDX_EXIF_FlashPixVersion));
  Add(TTBExifTag.Create(IDX_EXIF_ColorSpace));
  Add(TTBExifTag.Create(IDX_EXIF_ExifImageWidth));
  Add(TTBExifTag.Create(IDX_EXIF_ExifImageHeight));
  Add(TTBExifTag.Create(IDX_EXIF_RelatedSoundFile));
  Add(TTBExifTag.Create(IDX_EXIF_FocalPlaneXResolution));
  Add(TTBExifTag.Create(IDX_EXIF_FocalPlaneYResolution));
  Add(TTBExifTag.Create(IDX_EXIF_ExposureIndex));
  Add(TTBExifTag.Create(IDX_EXIF_SensingMethod));
  Add(TTBExifTag.Create(IDX_EXIF_FileSource));
  Add(TTBExifTag.Create(IDX_EXIF_SceneType));
  Add(TTBExifTag.Create(IDX_EXIF_YCbCrPositioning));
  Add(TTBExifTag.Create(IDX_EXIF_ExposureMode));
  Add(TTBExifTag.Create(IDX_EXIF_WhiteBalance));
  Add(TTBExifTag.Create(IDX_EXIF_DigitalZoomRatio));
  Add(TTBExifTag.Create(IDX_EXIF_FocalLengthIn35mmFilm));
  Add(TTBExifTag.Create(IDX_EXIF_SceneCaptureType));
  Add(TTBExifTag.Create(IDX_EXIF_GainControl));
  Add(TTBExifTag.Create(IDX_EXIF_Contrast));
  Add(TTBExifTag.Create(IDX_EXIF_Saturation));
  Add(TTBExifTag.Create(IDX_EXIF_Sharpness));
  Add(TTBExifTag.Create(IDX_EXIF_SubjectDistanceRange));
  Add(TTBExifTag.Create(IDX_EXIF_GPSLatitude));
  Add(TTBExifTag.Create(IDX_EXIF_GPSLongitude));
  Add(TTBExifTag.Create(IDX_EXIF_GPSAltitude));
  Add(TTBExifTag.Create(IDX_EXIF_GPSImageDirection));
  Add(TTBExifTag.Create(IDX_EXIF_GPSTrack));
  Add(TTBExifTag.Create(IDX_EXIF_GPSSpeed));
  Add(TTBExifTag.Create(IDX_EXIF_GPSDateAndTime));
  Add(TTBExifTag.Create(IDX_EXIF_GPSSatellites));
  Add(TTBExifTag.Create(IDX_EXIF_GPSVersionID));
  Add(TTBExifTag.Create(IDX_EXIF_Artist));
  Add(TTBExifTag.Create(IDX_EXIF_XPTitle));
  Add(TTBExifTag.Create(IDX_EXIF_XPComment));
  Add(TTBExifTag.Create(IDX_EXIF_XPAuthor));
  Add(TTBExifTag.Create(IDX_EXIF_XPKeywords));
  Add(TTBExifTag.Create(IDX_EXIF_XPSubject));
  Add(TTBExifTag.Create(IDX_EXIF_XPRating));
  Add(TTBExifTag.Create(IDX_EXIF_InteropVersion));
  Add(TTBExifTag.Create(IDX_EXIF_CameraOwnerName));
  Add(TTBExifTag.Create(IDX_EXIF_BodySerialNumber));
  Add(TTBExifTag.Create(IDX_EXIF_LensMake));
  Add(TTBExifTag.Create(IDX_EXIF_LensModel));
  Add(TTBExifTag.Create(IDX_EXIF_LensSerialNumber));
  Add(TTBExifTag.Create(IDX_EXIF_Gamma));
  Add(TTBExifTag.Create(IDX_EXIF_SubjectArea));
  Add(TTBExifTag.Create(IDX_EXIF_SubjectLocation));
end;

procedure TTBExifTags.SetTag(idx: integer; const Value: TTBExifTag);
begin
  if OwnsObjects and (Items[idx] <> nil) then
    Items[idx].free;
  Items[idx] := Value;
end;

procedure TTBExifTags.SetTagAsStr(idx: integer; const Value: string);
var
  aExifTag: TTBExifTag;
begin
  aExifTag := TTBExifTag_CreateTagByParsing(Value);
  if aExifTag <> nil then
    SetTag(idx, aExifTag);
end;

function TTBExifTags.GetTagAsStr(idx: integer): string;
begin
  result := TTBExifTag_GetTagAsStr(GetTag(idx));
end;

function TTBExifTags.GetTagIdx(theTag: TTBExifTag): integer;
var
  i: integer;
begin
  result := -1;
  for i := 0 to Count - 1 do
    if GetTag(i).idx = theTag.idx then
    begin
      result := i;
      break;
    end;

end;

function TTBExifTags.GetTag(idx: integer): TTBExifTag;
begin
  result := TTBExifTag(Items[idx]);
end;

{ TThumbsbrowser_MetaTags }

procedure TThumbsbrowser_MetaTags.Assign(Source: TObject);
var
  src: TThumbsbrowser_MetaTags;
begin
  if not(Source is TThumbsbrowser_MetaTags) then
    raise Exception.Create('Wrong Class Type');

  src := TThumbsbrowser_MetaTags(Source);

  fVersion := src.Version;
  fExifTags.Assign(src.ExifTags);
  fIptcTags.Assign(src.IptcTags);
  fXmpTags.Assign(src.XmpTags);
  fCommonTags.Assign(src.CommonTags);

end;

constructor TThumbsbrowser_MetaTags.Create(const bFill: boolean);
begin
  inherited Create;
  fVersion := 1.0;
  fExifTags := TTBExifTags.Create(bFill);
  fIptcTags := TTBIptcTags.Create(bFill);
  fXmpTags := TTBXmpTags.Create(bFill);
  fCommonTags := TTBCommonTags.Create(bFill);
end;

destructor TThumbsbrowser_MetaTags.Destroy;
begin
  freeandnil(fExifTags);
  freeandnil(fIptcTags);
  freeandnil(fXmpTags);
  freeandnil(fCommonTags);
  inherited;
end;

procedure TThumbsbrowser_MetaTags.SetLanguage(theLanguage: TNWSCompsLanguage);
begin
  fExifTags.SetLanguage(theLanguage);
  fIptcTags.SetLanguage(theLanguage);
  fXmpTags.SetLanguage(theLanguage);
  fCommonTags.SetLanguage(theLanguage);

end;

{ TTBGeneralTag }

constructor TTBGeneralTag.Create(theDataType: TThumbsbrowser_MetaData_Type; theLangStrId: integer);
begin
  fDataType := theDataType;
  fLangStrId := theLangStrId;
end;

destructor TTBGeneralTag.Destroy;
begin
  inherited;
end;

procedure TTBGeneralTag.LoadDescrFromRes(theLanguage: TNWSCompsLanguage);
begin
  if theLanguage = TBResStr.Language then
    fDesc := TBResStr[fLangStrId]
  else
    fDesc := TBGetResStr(theLanguage, fLangStrId);
end;

{ TThumbsbrowser_MetaData_FileRcds }

procedure TThumbsbrowser_MetaData_FileRcds.Add(theRcd: TThumbsbrowser_MetaData_FileRcd);
begin
  FList.Add(theRcd);
end;

procedure TThumbsbrowser_MetaData_FileRcds.Clear;
begin
  FList.Clear;
end;

constructor TThumbsbrowser_MetaData_FileRcds.Create;
begin
  FList := TObjectList.Create;
end;

procedure TThumbsbrowser_MetaData_FileRcds.Delete(const idx: integer);
begin
  FList.Delete(idx);
end;

destructor TThumbsbrowser_MetaData_FileRcds.Destroy;
begin
  FList.free;
  inherited Destroy;
end;

function TThumbsbrowser_MetaData_FileRcds.GetCount: integer;
begin
  result := FList.Count;
end;

function TThumbsbrowser_MetaData_FileRcds.GetRcd(idx: integer): TThumbsbrowser_MetaData_FileRcd;
begin
  result := TThumbsbrowser_MetaData_FileRcd(FList[idx]);
end;

procedure TThumbsbrowser_MetaData_FileRcds.Insert(const idx: integer; theRcd: TThumbsbrowser_MetaData_FileRcd);
begin
  FList.Insert(idx, theRcd);
end;

procedure TThumbsbrowser_MetaData_FileRcds.Remove(theRcd: TThumbsbrowser_MetaData_FileRcd);
begin
  FList.Remove(theRcd);
end;

procedure TThumbsbrowser_MetaData_FileRcds.SetRcd(idx: integer; const Value: TThumbsbrowser_MetaData_FileRcd);
begin
  FList[idx] := Value;
end;

{ TTB_Thumb_LayoutElement }

procedure TTB_Thumb_LayoutElement.Assign(Source: TObject);
var
  src: TTB_Thumb_LayoutElement;
begin
  src := TTB_Thumb_LayoutElement(Source);

  fElementType := src.ElementType;
  fRect := src.Rect;
  fWidth := src.Width;
  fHeight := src.Height;

end;

constructor TTB_Thumb_LayoutElement.Create(theElementType: TTB_Thumb_LayoutElementType);
begin
  fElementType := theElementType;

  fWidth := 0;
  fHeight := 0;
  fRect := Classes.Rect(0, 0, 0, 0);
end;

procedure TTB_Thumb_LayoutElement.SetRect(const Value: TRect);
begin
  fRect := Value;
  fWidth := fRect.Right - fRect.Left + 1;
  fHeight := fRect.Bottom - fRect.Top + 1;
end;

{ TTB_Thumb_LayoutElements }

procedure TTB_Thumb_LayoutElements.Assign(Source: TObject);
var
  src: TTB_Thumb_LayoutElements;
  i: integer;
  e, eSrc: TTB_Thumb_LayoutElement;
begin
  src := TTB_Thumb_LayoutElements(Source);

  FList.Clear;
  for i := 0 to src.FList.Count - 1 do
  begin
    eSrc := TTB_Thumb_LayoutElement(src.FList[i]);
    e := TTB_Thumb_LayoutElement.Create(eSrc.ElementType);
    e.Assign(eSrc);
    FList.Add(e);
    CalcQuickRef(e);
  end;

end;

procedure TTB_Thumb_LayoutElements.CalcQuickRef(e: TTB_Thumb_LayoutElement);
begin
  case e.ElementType of
    leCheck:
      fCheckBox := e;
    leInfoBox:
      fInfoBox := e;
    leRotateButtonLeft:
      fRotateButtons_L := e;
    leRotateButtonRight:
      fRotateButtons_R := e;
    leTopTitle:
      fTopTitle := e;
    leBottomTitle:
      fBottomTitle := e;
    leRatingBox:
      fRatingBox := e;
  end;
end;

constructor TTB_Thumb_LayoutElements.Create;
var
  typ: TTB_Thumb_LayoutElementType;
  e: TTB_Thumb_LayoutElement;
begin
  FList := TObjectList.Create;
  for typ := Low(TTB_Thumb_LayoutElementType) to High(TTB_Thumb_LayoutElementType) do
  begin
    e := TTB_Thumb_LayoutElement.Create(typ);
    FList.Add(e);
    CalcQuickRef(e);
  end;
end;

destructor TTB_Thumb_LayoutElements.Destroy;
begin
  FList.free;

  inherited Destroy;
end;

function TTB_Thumb_LayoutElements.GetElement(theElementType: TTB_Thumb_LayoutElementType): TTB_Thumb_LayoutElement;
var
  i: integer;
begin
  result := nil;
  for i := 0 to FList.Count - 1 do
    if TTB_Thumb_LayoutElement(FList[i]).ElementType = theElementType then
    begin
      result := TTB_Thumb_LayoutElement(FList[i]);
      break;
    end;

end;

function TTB_Thumb_LayoutElements.GetRect(theElementType: TTB_Thumb_LayoutElementType): TRect;
begin
  result := GetElement(theElementType).Rect;
end;

procedure TTB_Thumb_LayoutElements.SetRect(theElementType: TTB_Thumb_LayoutElementType; theRect: TRect);
begin
  GetElement(theElementType).Rect := theRect;
end;

{ TTB_Thumb_Caption }

procedure TTB_Thumb_Caption.Assign(Source: TTB_Thumb_Caption);
begin
  fText := Source.Text;
  fCaptionSetting := Source.CaptionSetting;
end;

constructor TTB_Thumb_Caption.Create(const theText: string; const theCaptionSetting: TTB_Thumb_CaptionsSetting);
begin
  fText := theText;
  fCaptionSetting := theCaptionSetting;
end;

{ TTB_Thumb_Captions }

function TTB_Thumb_Captions.Add(const theText: string; const theCaptionSetting: TTB_Thumb_CaptionsSetting): integer;
begin
  result := inherited Add(TTB_Thumb_Caption.Create(theText, theCaptionSetting));
end;

procedure TTB_Thumb_Captions.Assign(Source: TTB_Thumb_Captions; bExcludeGenCaptions: boolean = False);
var
  i, idx: integer;
  genCapsDest: TTB_Thumb_Captions;
begin

  if bExcludeGenCaptions then
  begin
    genCapsDest := TTB_Thumb_Captions.Create;
    for i := 0 to Source.Count - 1 do
    begin
      if TBIsCaptionGeneral(Source[i].CaptionSetting) then
        genCapsDest.Add(Source[i].Text, Source[i].CaptionSetting);
    end;
  end
  else
    genCapsDest := nil;

  Clear;

  for i := 0 to Source.Count - 1 do
  begin
    if (not bExcludeGenCaptions) or (Source[i].CaptionSetting <> cap_General) then
    begin
      idx := inherited Add(TTB_Thumb_Caption.Create);
      Caption[idx].Assign(Source[i]);
    end;
  end;

  if genCapsDest <> nil then
  begin
    for i := 0 to genCapsDest.Count - 1 do
      Add(genCapsDest[i].Text, genCapsDest[i].CaptionSetting);

    freeandnil(genCapsDest);
  end;
end;

function TTB_Thumb_Captions.GetCaption(Index: integer): TTB_Thumb_Caption;
begin
  result := TTB_Thumb_Caption(Items[index]);
end;

function TTB_Thumb_Captions.GetCaptionbySetting(const capSet: TTB_Thumb_CaptionsSetting): TTB_Thumb_Caption;
var
  i: integer;
begin
  result := nil;
  for i := 0 to Count - 1 do
    if Caption[i].CaptionSetting = capSet then
    begin
      result := Caption[i];
      break;
    end;

end;

procedure TTB_Thumb_Captions.Insert(idx: integer; const theText: string;
  const theCaptionSetting: TTB_Thumb_CaptionsSetting);
begin
  inherited Insert(idx, TTB_Thumb_Caption.Create(theText, theCaptionSetting));
end;

procedure TTB_Thumb_Captions.SetCaption(const theText: string; const theCaptionSetting: TTB_Thumb_CaptionsSetting);
var
  cap: TTB_Thumb_Caption;
begin
  cap := GetCaptionbySetting(theCaptionSetting);
  if cap = nil then
    Add(theText, theCaptionSetting)
  else
    cap.Text := theText;
end;

procedure TTB_Thumb_Captions.SetCaption(Index: integer; const Value: TTB_Thumb_Caption);
begin
  Items[index] := Value;
end;

{ TTB_Browser_StyleOptions }

constructor TTB_Browser_StyleOptions.Create(Notifier: TNotifyEvent);

begin
  fNotifier := Notifier;
  fCaptionsOptions := TTB_Browser_Style_CaptionOptions.Create(HandleNotification);
  fThemeEnabled := False;
  fThemeColorOptions := [thmcl_BrowserBg, thmcl_FrameBg, thmcl_FrameBgSel, thmcl_FrameBorder, thmcl_FrameBorderSel,
    thmcl_CaptionBg, thmcl_CaptionBgSel, thmcl_CaptionFont, thmcl_CaptionFontSel];
  fThemeElements := [thmele_CheckBox, thmele_InfoBox, thmele_RotateButtons];

  RefreshThemeInfo;
end;

procedure TTB_Browser_StyleOptions.RefreshThemeInfo;
var
  el: TTB_Browser_Style_ThemeElement;
  bmp: TBitmap;
begin
  bmp := TBitmap.Create;
  try
    for el := Low(TTB_Browser_Style_ThemeElement) to High(TTB_Browser_Style_ThemeElement) do
    begin
      case el of
        thmele_CheckBox:
          fThemeElementsInfos[el].Size := NwscompsStyle_GetElementSize(nwsStyleEl_CheckBoxChecked, bmp.Canvas);
        thmele_InfoBox:
          fThemeElementsInfos[el].Size := NwscompsStyle_GetElementSize(nwsStyleEl_InfoButton, bmp.Canvas);
        thmele_RotateButtons:
          fThemeElementsInfos[el].Size := NwscompsStyle_GetElementSize(nwsStyleEl_RotateButtonRight, bmp.Canvas);
      end;
    end;
  finally
    bmp.free;
  end;
end;

procedure TTB_Browser_StyleOptions.SetBrowserStyle(const Value: TTB_Browser_Style);
begin
  if Value = fBrowserStyle then
    EXIT;

  fBrowserStyle := Value;
  HandleNotification(self);

end;

procedure TTB_Browser_StyleOptions.SetThemeColorOptions(const Value: TTB_Browser_Style_ThemeColorOptions);
begin
  if fThemeColorOptions = Value then
    EXIT;

  fThemeColorOptions := Value;
  HandleNotification(self);
end;

procedure TTB_Browser_StyleOptions.SetThemeElements(const Value: TTB_Browser_Style_ThemeElements);
begin
  if fThemeElements = Value then
    EXIT;

  fThemeElements := Value;
  HandleNotification(self);
end;

procedure TTB_Browser_StyleOptions.SetThemeEnabled(const Value: boolean);
begin
  if fThemeEnabled = Value then
    EXIT;

  fThemeEnabled := Value;
  HandleNotification(self);
end;

destructor TTB_Browser_StyleOptions.Destroy;
begin
  fCaptionsOptions.free;
  inherited;
end;

function TTB_Browser_StyleOptions.GetThemeElementInfo(el: TTB_Browser_Style_ThemeElement)
  : TTB_Browser_Style_ThemeElement_Info;
begin
  result := fThemeElementsInfos[el];
end;

procedure TTB_Browser_StyleOptions.HandleNotification(sender: TObject);
begin
  if assigned(fNotifier) then
    fNotifier(self);
end;

{ TTB_Browser_Style_CaptionOptions }

constructor TTB_Browser_Style_CaptionOptions.Create(Notifier: TNotifyEvent);
begin
  fNotifier := Notifier;
  fSizePerc_HorzLayout := 150;
  fStyle := capSt_RowsCentered;
  fTextPadding := 6;
end;

procedure TTB_Browser_Style_CaptionOptions.SetSizePerc_HorzLayout(const Value: cardinal);
begin
  if fSizePerc_HorzLayout = Value then
    EXIT;

  fSizePerc_HorzLayout := Value;
  if assigned(fNotifier) then
    fNotifier(self);
end;

procedure TTB_Browser_Style_CaptionOptions.SetStyle(const Value: TTB_Thumb_CaptionStyle);
begin
  if fStyle = Value then
    EXIT;

  fStyle := Value;
  if assigned(fNotifier) then
    fNotifier(self);
end;

procedure TTB_Browser_Style_CaptionOptions.SetTextPadding(const Value: cardinal);
begin
  if fTextPadding = Value then
    EXIT;

  fTextPadding := Value;

  if assigned(fNotifier) then
    fNotifier(self);
end;



{ TTB_Thumb_DropShadowOptions }

constructor TTB_Thumb_DropShadowOptions.Create(Notifier: TNotifyEvent);
begin
  fNotifier := Notifier;
  fEnabled := False;
  fSize := 3;
end;

procedure TTB_Thumb_DropShadowOptions.SetEnabled(const Value: boolean);
begin
  if fEnabled = Value then
    EXIT;
  fEnabled := Value;
  if assigned(fNotifier) then
    fNotifier(self);
end;

procedure TTB_Thumb_DropShadowOptions.SetSize(const Value: cardinal);
begin
  if fSize = Value then
    EXIT;
  fSize := Value;
  if assigned(fNotifier) then
    fNotifier(self);
end;

{ TTBGeneralTags }

constructor TTBGeneralTags.Create;
begin
  inherited Create(true);
  fLanguage := TBResStr.Language;
end;

procedure TTBGeneralTags.SetLanguage(theLanguage: TNWSCompsLanguage; bForceTranslate: boolean = False);
var
  i: integer;
begin
  if (fLanguage = theLanguage) and (not bForceTranslate) then
    EXIT;

  fLanguage := theLanguage;

  for i := 0 to Count - 1 do
    TTBGeneralTag(Items[i]).LoadDescrFromRes(theLanguage);
end;

end.
