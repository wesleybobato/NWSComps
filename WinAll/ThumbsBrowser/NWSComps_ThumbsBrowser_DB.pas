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
unit NWSComps_ThumbsBrowser_DB;
{$R-}
{$Q-}
{$J+}
{$I ..\_inc\NWSComps_ThumbsBrowser.inc}
{$I ..\_inc\NWSComps_Shared.inc}

interface
{$IFDEF TB_USEDB}

uses
  Windows,  Messages, Classes, controls, Forms,
  Dialogs, contnrs, math, syncobjs,
  db, nxdb, nxllcomponent, nxsdServerEngine, nxlltypes,
  nxsdtypes, nxsrServerEngine, nxseAllEngines, nxllconst,
  nxsdTableMapperDescriptor, nxsdDataDictionary, nxllbde, nxsqlEngine,
  NWSComps_ThumbsBrowser_Database_Utils, NWSComps_ThumbsBrowser_Utils_Types;


type

  TThumbsBrowser_DB_SeekResult = (seekOk, seekNone, seekError);

  TThumbsBrowser_DBSessionStorage = class
    private

    fGuid:TGuid;
    fSessionTimeout: cardinal;
    public

    property GUID:TGUID read fGuid;
    property SessionTimeout: cardinal read fSessionTimeOut;
    constructor Create(theGuid:TGuid; theTimeOut:cardinal);
  end;

  TThumbsBrowser_DBThreadSafeSession = class(TObject)
     private
      fGuid: TGuid;
      fSession: TNXSession;
      fDB: TNXDatabase;
      fTable: TNXTable;
     public
     property Guid: TGuid read fGuid write fGuid;
     property Session: TNXSession read fSession;
     property DB: TNxDatabase read fDB;
     property Table: TNXTable read fTable;



     constructor Create(theServer: TNXServerEngine; theAliasPath:string; theTableName:string;
                        theTimeOut: cardinal;
                        const bOpenTable: boolean); reintroduce;
     destructor Destroy; override;
  end;

  TThumbsBrowser_DBThreadSafeSessions = class(TThreadObjectList)

     private

        function GetSession(idx:integer):TThumbsBrowser_DBThreadSafeSession;
     public
        property Session[idx:integer]: TThumbsBrowser_DBThreadSafeSession read GetSession;  default;
        Function FindSession(guid:TGUID): TThumbsBrowser_DBThreadSafeSession;


  end;

  TThumbsBrowser_DB = class(TPersistent)

  private
    fOwner: TCustomControl;

    fDBSessions: TThumbsBrowser_DBThreadSafeSessions;
    fCopyDBSessions: TObjectList;

    fBaseSession: TThumbsBrowser_DBThreadSafeSession;

    fDBStarted: boolean;
    fDBLocation: string;


    fDBServer: TnxServerEngine;

    fDBDictionaryTable: TNxtable;
    FDBExternalServer: TNXServerEngine;


    FDBTableName: string;
    fDBActive: boolean;

    fThumbJpgQuality: integer;

    fMainCS: TCriticalSection;
 
    procedure SetDBServer(const Value: TnxServerEngine);


    procedure SetDBLocation(const Value: string);
    procedure SetDBExternalServer(const Value: TNXServerEngine);
    procedure SetDBTableName(const Value: string);
    procedure SetDBActive(const Value: boolean);


    function DB_Exists: TTB_Browser_DB_ExistsMatchType;

    procedure HandleTableCreation;

    procedure DICTIONARYTABLE_Create;
    procedure DICTIONARYTABLE_Open;

    procedure TABLE_Open;
    procedure TABLE_Close;
    procedure TABLE_Create;
    procedure TABLE_Restructure;

    function  TABLE_GetDictionary: TNXDatadictionary;
    procedure TABLE_SaveDictionary(thedbmode: TTB_Browser_DB_Mode);


    procedure CreateServer;
    procedure EnterDB(thePath:string);
    procedure LeaveDB;

    procedure SaveSessions;
    procedure RestoreSessions;

    procedure Finalize_DB;
    procedure Init_DB;

    procedure ChangeDB;


  protected
    function SessionInit(const SessionTimeOut: cardinal;const bOpenTable: boolean): TThumbsBrowser_DBThreadSafeSession;  overload;
    function SessionOk(theGuid:TGuid; var aSession: TThumbsBrowser_DBThreadSafeSession):boolean;

    function SeekRcd(theTable: TNXTable; const IDString: string): TThumbsBrowser_DB_SeekResult;
  public
    property DBServer: TnxServerEngine read fDBServer write SetDBServer;

  //  property DBTable: TNxTable read fDBTable;

    constructor create(theOwner: TCustomControl); reintroduce;
    destructor destroy; override;

    procedure Start;

    function SessionInit(sender:TObject;const SessionTimeOut: cardinal): TGUID;  overload;
    procedure SessionFinalize(theSessionGUID: TGuid);

    procedure CleanDatabase(theSessionGuid: TGuid;
                            const bNonExisting_Only, bInPath_Only: boolean; pathList: TStringList);


    procedure DeleteRcd(theSessionGuid: TGuid; const IDString: string);
    function SetFieldValue(theSessionGuid: TGuid; const IDString: string; const FieldName:string; FieldValue:Variant):boolean;
    function GetFieldValue(theSessionGuid: TGuid; const IDString: string; const FieldName:string; var FieldValue:Variant):boolean;

    function ThumbExistsinDB(theSessionGuid: TGuid; theThumbRef:TObject; uniqueName: string; sizeOffScreen: integer): TTB_DB_ThumbExistResult;
    function ThumbRetrieveFromDB(theSessionGuid: TGuid; theThumbRef:TObject; const bSeek: boolean): boolean;
    procedure ThumbSavetoDB(theSessionGuid: TGuid; theThumbRef:TObject; mode: TTB_Browser_DB_Mode; ParamsOnly: boolean);

    function DoQuery(theSessionGuid: TGuid; sql:string): TDataset;

    procedure SetThumbJpgQuality(value:integer);
    published

    property DBLocation: string read FDBLocation write SetDBLocation;
    property DBTableName: string read FDBTableName write SetDBTableName;
    property DBActive: boolean read fDBActive write SetDBActive;

    property DBExternalServer:TNXServerEngine read FDBExternalServer write SetDBExternalServer;

    property ThumbJpgQuality: integer read fThumbJpgQuality write SetThumbJpgQuality;
  end;
  {$ENDIF}  //TB_USEDB

implementation

{$IFDEF TB_USEDB}
 uses sysutils, shlobj,
      hyieutils, hyiedefs, imageenio,
      {$IFDEF IMAGEEN_6_2_LATER}
      iexBitmaps,
      {$ENDIF}
      NWSComps_ThumbsBrowser_Thumbs,
      NWSComps_Thumbsbrowser_Shell_Utils,
      NWSComps_Thumbsbrowser_Utils;

var
  SharedClients: TList;
  SharedServer: TnxServerEngine;
  SharedSqlServer: TnxSqlEngine;
  SharedTempDBLocation: string;
  debugErrors:integer;

function GetTempFolder: String;
begin
  setlength(result, max_path);
  GetTempPath(max_path, pchar(result));
  setlength(result, strlen(pchar(result)));
end;

function GetMyDocumentsFolder: string;
 var
  path: array[0..Max_Path] of Char;
 begin
  if (ShGetSpecialFolderPath(0, path, CSIDL_PERSONAL, False)) then
    Result := Path
  else
    Result :='';
 end;

function GetUniqueName:string;
var
aDBGuid:TGuid;
i:integer;
begin
  result := '';
  TBCoCreateGuid(aDBGuid);
  result := inttostr(aDBGuid.D1) + inttostr(aDBGuid.D2) + inttostr(aDBGuid.D3);
  for I := low(adbGuid.D4) to High(adbGuid.D4) do
    result := result + inttostr(aDBGuid.D4[i]);

end;

procedure SharedServer_Destroy;
begin
  //showmessage('Finalization');

  if assigned(SharedSQLServer) then
  begin
   //  showmessage('Shared SQL Server Is Assigned');
     SharedSQLServer.Close;
     freeandnil(SharedSQLServer);
   //  showmessage('Shared SQL Server Is Now Destroyed');
  end;

  if assigned(SharedServer) then
  begin
    // showmessage('Shared Server Is Assigned');
     SharedServer.Close;
     freeandnil(SharedServer);
    // showmessage('Shared Server Is Now Destroyed');
  end;

end;

function SharedServer_IsClient(theClient: TObject): boolean;
begin
  result := SharedClients.indexof(theClient) <> -1;
end;

procedure SharedServer_Join(theClient: TObject;
                        theOwner: TComponent;
                        var aServer: TnxServerEngine);
begin
//  showmessage('ok1');
  if not assigned(SharedServer) then
  begin
   //  showmessage('Shared Server Is Created');
     SharedServer := TnxServerEngine.Create(theOwner);
     SharedSqlServer := TnxSqlEngine.create(theOwner);
     SharedServer.SqlEngine := SharedSqlServer;

  end;
  aServer := SharedServer;
  if SharedClients.indexof(theClient) =-1 then
    SharedClients.add(theClient);

 // showmessage('ok2');
end;

procedure SharedServer_UnJoin(theClient: TObject);
begin
  SharedClients.remove(theClient);
  if SharedClients.count = 0 then
    SharedServer_Destroy;
end;


procedure SharedServer_CreateTempDBLocation;
begin
  SharedTempDBLocation := Tbs_AddSlash(GetTempFolder);

  if SharedTempDBLocation='' then
    SharedTempDBLocation := Tbs_AddSlash(GetMyDocumentsFolder);

  SharedTempDBLocation := SharedTempDBLocation + Tbs_AddSlash(GetUniqueName);

  if not DirectoryExists(SharedTempDBLocation) then
    ForceDirectories(SharedTempDBLocation);

end;

procedure SharedServer_DeleteTempDBLocation;
function DoDel(theFileName: string):boolean;
begin
  result := deletefile(theFileName);
end;
var
 sr: TSearchRec;
begin
  if not sysutils.DirectoryExists(SharedTempDBLocation) then EXIT;

  if findfirst(SharedTempDBLocation + '*.*', faAnyFile, sr) = 0 then
  begin
    if (sr.name<>'.') and (sr.name<>'..') and fileexists(SharedTempDBLocation + sr.Name) then
      DoDel(SharedTempDBLocation + sr.Name);
    while (findnext(sr) = 0) do
    begin
      if (sr.name<>'.') and (sr.name<>'..') and fileexists(SharedTempDBLocation + sr.Name) then
        DoDel(SharedTempDBLocation + sr.Name);
    end;
    findclose(sr);
  end;
  RemoveDir(SharedTempDBLocation);
end;

{ TThumbsBrowser_DB }
procedure TThumbsBrowser_DB.Init_DB;
begin

  fDBExternalServer := nil;

  fDBLocation := SharedTempDBLocation;

  fDBTableName := 'TBthumbs' ;
  fDBActive := false;
  fDBStarted := False;

  fCopyDBSessions := TObjectList.create;

end;


procedure TThumbsBrowser_DB.Finalize_DB;
begin
  LeaveDB;
  freeandnil(fCopyDBSessions);

  if SharedServer_IsClient(self) then
    SharedServer_UnJoin(self);

end;


function TThumbsBrowser_DB.SessionInit(sender:TObject; const SessionTimeOut: cardinal): TGUID;
var
aTSSession: TThumbsBrowser_DBThreadSafeSession;
begin
  aTSSession := SessionInit(SessionTimeOut, true);
  if aTSSession <> nil then
    result := aTSSession.Guid;
end;

function TThumbsBrowser_DB.SessionInit(const SessionTimeOut: cardinal; const bOpenTable: boolean): TThumbsBrowser_DBThreadSafeSession;
var
aTSSession: TThumbsBrowser_DBThreadSafeSession;
begin
  result := nil;
  if fDBServer = nil then EXIT;

  aTSSession := TThumbsBrowser_DBThreadSafeSession.create(fDBServer, fDBLocation, fDBTableName,
                                                          SessionTimeOut, fDBActive and bOpenTable);
  aTSSession.DB.Connect;
  fDBSessions.add(aTSSession);
  result := aTSSession;
end;

function TThumbsBrowser_DB.SessionOk(theGuid:TGuid; var aSession: TThumbsBrowser_DBThreadSafeSession):boolean;
begin
  result := false;

    if not fDBActive then Exit;
    if (isEqualGUID(theGuid, GUID_NULL)) or (IsEqualGUID(theGuid, fbaseSession.Guid)) then
    begin
      aSession := fBaseSession;
      result := true;
    end
    else
    begin
      aSession := fDBSessions.FindSession(theGuid);
      result := aSession <> nil;
    end;

end;

procedure TThumbsBrowser_DB.SessionFinalize(theSessionGUID: TGuid);
var
aSession: TThumbsBrowser_DBThreadSafeSession;
begin
  aSession := fDBSessions.FindSession(theSessionGuid);
  if aSession=nil then EXIT;

  fDBSessions.remove(aSession);
end;


procedure TThumbsBrowser_DB.Start;
begin

  CreateServer;
  fDBStarted := true;
  EnterDB(fDBLocation);
end;

constructor TThumbsBrowser_DB.create(theOwner: TCustomControl);
begin
  inherited Create;
  fMainCS := TCriticalSection.create;
  fOwner := theOwner;
  fThumbJpgQuality := 80;
  Init_DB;
end;

destructor TThumbsBrowser_DB.destroy;
begin
  Finalize_DB;
  fMainCS.free;
  inherited;
end;


procedure TThumbsBrowser_DB.SetDBActive(const Value: boolean);
begin
  if fDBActive = value then EXIT;

  fDBActive := Value;

  if not fDBStarted then EXIT;

  HandleTableCreation;

end;

procedure TThumbsBrowser_DB.SetDBExternalServer(const Value: TNXServerEngine);
begin
  FDBExternalServer := Value;

  fDBServer := Value;

  ChangeDB;
end;



procedure TThumbsBrowser_DB.SetDBLocation(const Value: string);
begin
  if not sysutils.directoryexists(Value) then exit;


  FDBLocation := Value;

  if not fDBStarted then EXIT;

  ChangeDB;

end;

procedure TThumbsBrowser_DB.SetDBTableName(const Value: string);
begin

  FDBTableName := Value;

  if not fDBStarted then EXIT;

  HandleTableCreation;
end;


procedure TThumbsBrowser_DB.SetDBServer(const Value: TnxServerEngine);
begin
  fDBServer := Value;
end;

procedure TThumbsbrowser_Db.SaveSessions;
var
  I: Integer;
begin
  fCopyDBSessions.clear;
  fDBSessions.Lock;
  try
  for I := 0 to fDBSessions.count-1 do
  begin
    if fDBSessions[i]<> fBaseSession then
    begin
      fCopyDBSessions.Add(TThumbsBrowser_DBSessionStorage.create(fDBSessions[i].Guid, fDBSessions[i].Session.Timeout));
    end;
  end;
  finally
    fDBSessions.Unlock;
  end;
end;

procedure TThumbsbrowser_Db.RestoreSessions;
var
  I: Integer;
  aSession: TThumbsBrowser_DBThreadSafeSession;
  stor: TThumbsBrowser_DBSessionStorage;
begin

  for I := 0 to fCopyDBSessions.count-1 do
  begin
    stor := TThumbsBrowser_DBSessionStorage(fCopyDBSessions[i]);
    aSession := SessionInit(stor.SessionTimeout, true);
    aSession.Guid := stor.GUID;
  end;
  fCopyDBSessions.clear;
end;

procedure TThumbsbrowser_Db.ChangeDB;
begin
  if not fDBStarted then EXIT;

  SaveSessions;
  LeaveDB;
  EnterDB(fDBLocation);
  RestoreSessions;
end;



procedure TThumbsBrowser_DB.CreateServer;
begin
  if (not assigned(fDBServer)) then
    SharedServer_Join(self, fOwner, fDBServer);

end;

procedure TThumbsBrowser_DB.EnterDB(thePath:string);
begin
  fDBSessions := TThumbsBrowser_DBThreadSafeSessions.create;

  fBaseSession := SessionInit(1000, false);

  fDBDictionaryTable := TNXTable.create(fOwner);
  HandleTableCreation;


end;

procedure TThumbsBrowser_DB.LeaveDB;
begin

  if assigned(fDBDictionaryTable) and fDBDictionaryTable.active then
    fDBDictionaryTable.Close;

  fDBDictionaryTable.free;

  fBaseSession := nil;
  freeandnil(fDBSessions);


end;





function TThumbsBrowser_DB.DB_Exists: TTB_Browser_DB_ExistsMatchType;
var
  tname: string;
  dictversion: double;
begin
  result := DBDoesntExist;

  tname := Tbs_AddSlash(fDBLocation) + fDBTableName;
  if not fileexists(tname + '.nx1') then Exit;
  if not fileexists(tname + '_Dict' + '.nx1') then Exit;

  result := DBExists;

  try
    if not fDBDictionaryTable.Active then
      DICTIONARYTABLE_Open;
    if fDBDictionaryTable.RecordCount = 0 then //table exists but dictionary misses info
    begin
      result := DBDoesntExist;
      exit;
    end;

    if fDBDictionaryTable.FieldByName(TB_TABLE_FIELD_DBKIND).asstring <> TBCONST_DBKind then //table was not created by thumbsbrowser
    begin
      result := DBDoesntExist;
      exit;
    end;

    dictversion := fDBDictionaryTable.FieldByName(TB_TABLE_FIELD_DBVERSION).asfloat;
    if abs(dictversion - TBCONST_DBVersion) <= 0.000001 then //version of dictionary is same
      exit;

      // when version is different then
    result := DBExistsOldVersion;


  except
    result := DBDoesntExist;
  end;
end;





procedure TThumbsBrowser_DB.HandleTableCreation;
var
  testdbexists: TTB_Browser_DB_ExistsMatchType;
begin
  fMainCS.enter;
  try
      if not fDBActive then
        TABLE_Close
      else
      begin
        testdbexists := DB_Exists;
        if testdbexists = DBDoesntExist then
        begin
          TABLE_Close;
            TABLE_Create;
          TABLE_Open;
        end
        else
          if testdbexists = DBExistsOldversion then
          begin
            TABLE_Close;
              TABLE_Restructure;
            TABLE_Open;
          end
          else
            TABLE_Open;
      end;
  finally
    fMainCS.leave;
  end;
end;


function TThumbsBrowser_DB.TABLE_GetDictionary: TNXDatadictionary;
begin

//Important!! remember to change the TBDBVersion number when adding new fields definitions

  result := TNxdatadictionary.create;
  with result.FieldsDescriptor do
  begin
    AddField(TB_TABLE_FIELD_REC, '', nxtAutoinc, 0, 0, true);
    AddField(TB_TABLE_FIELD_DBKIND, '', nxtNullString, 50, 0, false);
    AddField(TB_TABLE_FIELD_DBVERSION, '', nxtDouble, 0, 0, false);
    AddField(TB_TABLE_FIELD_IDSTRING, '', nxtNullString, TBCONST_MAXLEN_IDSTRING, 0, false);
    AddField(TB_TABLE_FIELD_PATH, '', nxtBlob, 0, 0, false);
    AddField(TB_TABLE_FIELD_FILENAME_FULL, '', nxtBlob, 0, 0, false);
    AddField(TB_TABLE_FIELD_FILEDATE, '', nxtDatetime, 0, 0, false);

    AddField(TB_TABLE_FIELD_EXIF_FILEDATE, '', nxtDatetime, 0, 0, false);
    AddField(TB_TABLE_FIELD_EXIF_XPTITLE, '', nxtNullString, 80, 0, false);
    AddField(TB_TABLE_FIELD_EXIF_XPAUTHOR, '', nxtNullString, 50, 0, false);
    AddField(TB_TABLE_FIELD_EXIF_XPCOMMENTS, '', nxtNullString, 150, 0, false);
    AddField(TB_TABLE_FIELD_EXIF_ORIENTATION, '', nxtInt8, 0, 0, false);


     //v.3.0 start
    AddField(TB_TABLE_FIELD_HASH_MD5, '', nxtNullString, 32, 0, false);
    AddField(TB_TABLE_FIELD_METATAGS_VERSION, '', nxtDouble, 0, 0, false);
    AddField(TB_TABLE_FIELD_KEYWORDS, '', nxtNullString, 150, 0, false);
    AddField(TB_TABLE_FIELD_RATING, '', nxtInt8, 0, 0, false);
    AddField(TB_TABLE_FIELD_TOPTITLE, '', nxtNullString, 80, 0, false);
    AddField(TB_TABLE_FIELD_BOTTOMTITLE, '', nxtNullString, 80, 0, false);


    AddField(TB_TABLE_FIELD_HASEXIF, '', nxtBoolean, 0, 0, false);
    AddField(TB_TABLE_FIELD_HASIPTC, '', nxtBoolean, 0, 0, false);
    AddField(TB_TABLE_FIELD_HASDICOM, '', nxtBoolean, 0, 0, false);
    AddField(TB_TABLE_FIELD_HASXMP, '', nxtBoolean, 0, 0, false);
    AddField(TB_TABLE_METADATA_SAVED, '', nxtBoolean, 0, 0, false);
    AddField(TB_TABLE_SYNCFIELDS_SAVED, '', nxtBoolean, 0, 0, false);


   //v.3.0 end

    AddField(TB_TABLE_FIELD_FILESIZE, '', nxtInt32, 0, 0, false);
    AddField(TB_TABLE_FIELD_PICTURE_RES, '', nxtInt32, 0, 0, false);
    AddField(TB_TABLE_FIELD_PICTURE_WIDTH, '', nxtInt32, 0, 0, false);
    AddField(TB_TABLE_FIELD_PICTURE_HEIGHT, '', nxtInt32, 0, 0, false);
    AddField(TB_TABLE_FIELD_THUMB_SIZE, '', nxtInt32, 0, 0, false);
    AddField(TB_TABLE_FIELD_THUMB, '', nxtBlob, 0, 0, false);
  end;

  with result.IndicesDescriptor do begin
// 0 : Sequential Access Index
// (internal)

// 1 : IX_IDString
    with AddIndex('IX_IDString', 0, False, '', TnxCompKeyDescriptor,
      TnxIndexDescriptor) do begin
      IndexFile.BlockSize := nxbs8k;
      with
        TnxCompKeyDescriptor(KeyDescriptor).Add(result.GetFieldFromName(TB_TABLE_FIELD_IDSTRING))
        do begin

        Ascend := True;
        OverrideLengthChars := 0;
        OverrideLengthBytes := 0;
        NullBehaviour := nbTop;
      end; // with
    end; // with

// default index
    DefaultIndex := GetIndexFromName('IX_IDString');
  end; // with

end;


procedure TThumbsBrowser_DB.TABLE_Create;
var
  dict: TNxdatadictionary;
begin

  dict := TABLE_GetDictionary;
  try
    fBaseSession.DB.CreateTable(true, fDBTablename, '', dict);
  finally
    dict.free;
  end;

  DICTIONARYTABLE_Create;
end;



procedure TThumbsBrowser_DB.TABLE_Restructure;
var
  OldDict, newDict: TnxDataDictionary;
  Mapper: TnxTableMapperDescriptor;
  TaskInfo: TnxAbstractTaskInfo;
  Completed: Boolean;
  TaskStatus: TnxTaskStatus;
begin

  OldDict := TnxDataDictionary.Create;
  NewDict := TABLE_GetDictionary;
  try
    if fBaseSession.DB.GetDataDictionaryEx(fDBtablename, '', OldDict) <>
      DBIERR_NONE then
      Exit;

    if OldDict.IsEqual(NewDict) then
      Exit;

    Mapper := TnxTableMapperDescriptor.Create;
    try
      Mapper.MapAllTablesAndFieldsByName(OldDict, NewDict);
      fBaseSession.DB.RestructureTableEx(fDBTableName, '', NewDict, Mapper, TaskInfo);
//      Check();
      if Assigned(TaskInfo) then
      try
        while True do begin
          TaskInfo.GetStatus(Completed, TaskStatus);
         // Application.ProcessMessages;
          if Completed then
            break;
        end;
      finally
        TaskInfo.Free;
      end;

    finally
      Mapper.Free;
    end;
  finally
    NewDict.free;
    OldDict.Free;
  end;

  Table_SaveDictionary(dbmEdit);
end;



procedure TThumbsBrowser_DB.TABLE_Open;
var
  I: Integer;
  aSession:TThumbsBrowser_DBThreadSafeSession;
begin
  for I := 0 to fDBSessions.count-1 do
  begin
    aSession := fDBSessions[i];
    aSession.Table.Close;
    aSession.Table.Tablename := fDBTableName;
    aSession.Table.Open;
  end;
end;


procedure TThumbsBrowser_DB.TABLE_Close;
var
  I: Integer;
  aSession:TThumbsBrowser_DBThreadSafeSession;
begin
  for I := 0 to fDBSessions.count-1 do
  begin
    aSession := fDBSessions[i];

    aSession.Table.Close;
  end;
end;



procedure TThumbsBrowser_DB.TABLE_SaveDictionary(thedbmode: TTB_Browser_DB_Mode);
procedure TBSaveStreamtoBlob(thetable: TNXTable; theBlobField: TBlobField; thestream: TStream; thesize: integer);
var
  bs: TStream;
begin
  bs := theTable.CreateBlobStream(theBlobField, bmReadWrite);
  try
    thestream.Seek(0, 0);
    bs.copyfrom(thestream, thestream.size);
  finally
    bs.free;
  end;
end;
var
  dict: TnxDataDictionary;
  astream: Tmemorystream;
begin
  if not assigned(fDBDictionaryTable) then exit;

  dict := TnxDataDictionary.create;
  astream := TMemorystream.Create;
  try
    fBaseSession.DB.GetDataDictionary(fDBTablename, TBCONST_DBPassword, dict);
    dict.WriteToStream(astream, nxVersion20000);

    if not fDBDictionaryTable.active then
      fDBDictionaryTable.open;

    try
      if thedbmode = dbmInsert then
        fDBDictionaryTable.insert
      else
        fDBDictionaryTable.edit;

      TBSaveStreamtoBlob(fDBDictionaryTable, TBlobfield(fDBDictionaryTable.fieldbyname(TB_TABLE_FIELD_DICTIONARY))
        , astream, aStream.size);

      fDBDictionaryTable.FieldByName(TB_TABLE_FIELD_DBKIND).asstring := TBCONST_DBKind;
      fDBDictionaryTable.FieldByName(TB_TABLE_FIELD_DBVERSION).asfloat := TBCONST_DBVersion;

      fDBDictionaryTable.post;
    except
      fDBDictionaryTable.cancel;
      raise;
    end;

  finally
    astream.free;
    dict.free;
  end;

end;


procedure TThumbsBrowser_DB.DICTIONARYTABLE_Create;
begin
         //fDBDictionaryTable
  if not assigned(fDBDictionaryTable) then exit;

  if fDBDictionaryTable.active then
    fDBDictionaryTable.close;

  fDBDictionaryTable.Database := fBaseSession.DB;

  with fDBDictionaryTable do
  begin

    Tablename := fDBTableName + '_Dict';

        //Add fields
    with FieldDefs do
    begin
      Clear;

      with AddFieldDef do
      begin
        Name := TB_TABLE_FIELD_DBKIND;
        Datatype := ftstring;
        size := 30;
      end;
      with AddFieldDef do
      begin
        Name := TB_TABLE_FIELD_DBVERSION;
        Datatype := ftfloat;
      end;
      with AddFieldDef do
      begin
        Name := TB_TABLE_FIELD_DICTIONARY;
        Datatype := ftBlob;
      end;
      CreateTable;
      Open;

    end;
  end;

  Table_SaveDictionary(dbmInsert);
end;


procedure TThumbsBrowser_DB.DICTIONARYTABLE_Open;
begin
  if not assigned(fDBDictionaryTable) then exit;

  if fDBDictionaryTable.active then fDBDictionaryTable.close;
  fDBDictionaryTable.Database := fBaseSession.DB;

  fDBDictionaryTable.Tablename := fDBTableName + '_Dict';

  fDBDictionaryTable.open;
end;

 function TThumbsBrowser_DB.SeekRcd(theTable: TNXTable; const IDString: string): TThumbsBrowser_DB_SeekResult;
 begin
   if not fDBActive then
   begin
     result := seekError;
     EXIT;
   end;

   try
     if theTable.locate(TB_TABLE_FIELD_IDSTRING, IDString, [loCaseInsensitive]) then
       result := seekOk
     else
       result := seekNone;
   except
     result := seekError;
     inc(debugErrors);
   end;
 end;

 procedure TThumbsBrowser_DB.DeleteRcd(theSessionGuid: TGuid; const IDString: string);
 var
  aSession: TThumbsBrowser_DBThreadSafeSession;
 begin
   if not SessionOk(theSessionGuid, aSession) then EXIT;

  fMainCS.Enter;
  try

      if Idstring <> '' then
      begin
        with aSession.Table do
        begin
          if SeekRcd(aSession.Table, IDString)= seekOk then
            Delete;
        end;
      end;

  finally
    fMainCS.Leave;
  end;
 end;



 function TThumbsBrowser_DB.SetFieldValue(theSessionGuid: TGuid; const IDString: string; const FieldName:string; FieldValue:Variant):boolean;
 var
  aSession: TThumbsBrowser_DBThreadSafeSession;
 begin
   result := false;
   if not SessionOk(theSessionGuid, aSession) then EXIT;

   fMainCS.Enter;
   try
        if  (comparetext(aSession.Table.FieldByName(TB_TABLE_FIELD_IDSTRING).AsString, IDString) <> 0) OR
            (SeekRcd(aSession.Table, IDString)<> seekOk) then
        Exit; //>>>>EXIT

        try
          aSession.Table.FieldValues[FieldName] := FieldValue;
          result := true;
        except
        ;
        end;

  finally
    fMainCS.Leave;
  end;
 end;




 function TThumbsBrowser_DB.GetFieldValue(theSessionGuid: TGuid; const IDString: string; const FieldName:string; var FieldValue:Variant):boolean;
 var
  aSession: TThumbsBrowser_DBThreadSafeSession;
 begin
    result := false;
    if not SessionOk(theSessionGuid, aSession) then EXIT;

    fMainCS.Enter;
    try
          if  (comparetext(aSession.Table.FieldByName(TB_TABLE_FIELD_IDSTRING).AsString, IDString) <> 0) OR
              (SeekRcd(aSession.Table, IDString)<> seekOk) then
          Exit; //>>>>EXIT

          try
            FieldValue := aSession.Table.FieldValues[FieldName];
            result := true;
          except
          ;
          end;

    finally
      fMainCS.Leave;
    end;
 end;

procedure TThumbsBrowser_DB.CleanDatabase(theSessionGuid: TGuid; const bNonExisting_Only: boolean;
                                          const bInPath_Only: boolean;
                                          pathList: TStringList);
function IsPathInPaths(const thePath: string): boolean;
var
  j: integer;
  sPath:string;

begin
  result := false;

  if thePath='' then EXIT;

  sPath := Tbs_AddSlash(thePath);

  for j := 0 to pathList.Count - 1 do
  begin
    result := (comparetext(sPAth, pathList[j]) = 0);
    if result then break;
  end;
end;
var
  bToDelete: boolean;
  aSession: TThumbsBrowser_DBThreadSafeSession;
begin
   if not SessionOk(theSessionGuid, aSession) then EXIT;

   fMainCS.Enter;
    try
        with aSession.Table do
        begin
          First;
          while not Eof do
          begin
            bToDelete := True;
            if bNonExisting_Only then
            begin
              btoDelete := btoDelete and (not fileexists(FieldbyName(TB_TABLE_FIELD_FILENAME_FULL).asstring));
            end;
            if bInPath_Only then
            begin
              btoDelete := btoDelete and (IsPathInPaths(tbs_getParentPath(FieldbyName(TB_TABLE_FIELD_FILENAME_FULL).asstring)));
            end;

            if bToDelete then
              Delete;

            if not EOF then Next;
          end;
        end;

    finally
      fMainCS.Leave;
    end;
end;


function TThumbsBrowser_DB.ThumbExistsinDB(theSessionGuid: TGuid; theThumbRef:TObject; uniqueName: string; sizeOffScreen: integer): TTB_DB_ThumbExistResult;
var
  idstring: string;
  aSession: TThumbsBrowser_DBThreadSafeSession;
  seekResult: TThumbsBrowser_DB_SeekResult;
begin
  result.Index := -1;
  result.MatchedThumb := theThumbRef; //no thumb needs to be matched just a record in the db-table
  result.MatchType := TEUnknown;

  if not SessionOk(theSessionGuid, aSession) then EXIT;

  fMainCS.Enter;
  try
      idstring := uniqueName;

      if idstring = '' then
         EXIT;


      if length(idstring)>=TBCONST_MAXLEN_IDSTRING then    //unique ids with more than 255 chars fail to be matched in database!
      begin
         result.MatchType := TEUnknown;
         EXIT;
      end;

      with aSession.Table do
      begin

        try
          seekResult := SeekRcd(aSession.Table, IDString);

          case seekResult of
            seekOk:
               begin
                result.Index := fieldbyname(TB_TABLE_FIELD_REC).asinteger;

                if sizeOffScreen > fieldbyname(TB_TABLE_FIELD_THUMB_SIZE).asinteger then // thumb to be recreated
                  result.MatchType := TERcdExistsOld
                else
                  if//(fieldbyname(TB_TABLE_FIELD_THUMB).IsNull) or
                    (fieldbyname(TB_TABLE_FIELD_PICTURE_WIDTH).IsNull) or
                    (fieldbyname(TB_TABLE_FIELD_PICTURE_HEIGHT).IsNull) or
                    (fieldbyname(TB_TABLE_FIELD_EXIF_FILEDATE).IsNull) or
                    (fieldbyname(TB_TABLE_FIELD_EXIF_FILEDATE).AsDateTime < 0) then
                    result.MatchType := TERcdExistsWithOldParams
                  else
                    result.MatchType := TERcdExists;

              end;
            seekNone:  result.MatchType := TERcdDoesntExist;
            seekError: result.MatchType := TEUnknown;
          end;

        except
           result.MatchType := TEUnknown;
           EXIT;
        end;

      end;
  finally
    fMainCS.Leave;
  end;

end;



function TThumbsBrowser_DB.ThumbRetrieveFromDB(theSessionGuid: TGuid; theThumbRef:TObject;const bSeek: boolean): boolean;
var
  ablobstream: Tstream;
  aIO: Timageenio;
  theThumb:TThumbEX;
  offscreenBMP: TIEBitmap;
  bMetadataPresent: boolean;
  bSyncFieldsPresent: boolean;

  mt:TTBThumbExistMatchType;
  aSession: TThumbsBrowser_DBThreadSafeSession;
begin
   result := false;
   if not SessionOk(theSessionGuid, aSession) then EXIT;

   fMainCS.Enter;
   try
        if not assigned(theThumbRef) then EXIT;

        Assert(theThumbRef is TThumbEX);

        theThumb := TThumbEX(theThumbRef);

        if bSeek then
        begin
          mt := ThumbExistsinDB(theSessionGuid, thethumb, thethumb.Unique_Name, theThumb.SizeOffScreen).MatchType;  //this will do the seek
          case mt of
            TERcdDoesntExist: EXIT;//>>>EXIT
            TERcdExistsOld: ;
            TERcdExistsWithOldParams: ;
            TERcdExists: ;
            TEUnknown: EXIT;//>>>EXIT
          end;
        end;


         with aSession.Table do
         begin
            bMetadataPresent := (FieldByName(TB_TABLE_METADATA_SAVED).asboolean);
            bSyncFieldsPresent := (FieldByName(TB_TABLE_SYNCFIELDS_SAVED).asboolean);
         end;

        aIO := TImageenio.Create(nil);
        offscreenBMP := TIEBitmap.create;
        ablobstream := aSession.Table.createblobstream(aSession.Table.FieldByName(TB_TABLE_FIELD_THUMB), bmread);

        theThumb.Events_Lock;  //lock events to avoid any event to occur because of updating the thumbnail
        try
          aIO.AttachedIEBitmap := offscreenBMP;

          if (not bMetadataPresent) or (not bSyncFieldsPresent) then
          begin
             aio.ParamsFromFile(theThumb.SourceFileName);
             theThumb.GetBasicIOParamsFromIO(aIO);
          end;

          if aIO.LoadFromStreamJpeg(ablobstream) then
          begin
            if offscreenBMP.PixelFormat <> ie24RGB then
              offscreenBMP.PixelFormat := ie24RGB;
            theThumb.AssignOffScreenBitmap(offscreenBMP);
          end
          else
            EXIT;  //result will be false
        finally
          theThumb.Events_UnLock;  //unlock events
          ablobstream.free;
          offscreenBMP.free;
          aIO.free;
        end;


        if (theThumb.IEBitmap.width <> 0) and (theThumb.IeBitmap.height <> 0) then
        begin
          theThumb.Events_Lock;  //lock events to avoid any event to occur because of updating the thumbnail
          try
            with aSession.Table do
            begin
                theThumb.SourceFileWidth := FieldByName(TB_TABLE_FIELD_PICTURE_WIDTH).asinteger;
                theThumb.SourceFileHeight := FieldByName(TB_TABLE_FIELD_PICTURE_HEIGHT).asinteger;
                theThumb.SourceFileRes := FieldbyName(TB_TABLE_FIELD_PICTURE_RES).asinteger;

                if bSyncFieldsPresent then
                begin
                  theThumb.TopTitle := FieldByName(TB_TABLE_FIELD_TOPTITLE).asstring;
                  theThumb.BottomTitle := FieldByName(TB_TABLE_FIELD_BOTTOMTITLE).asstring;
                  theThumb.Rating := FieldByName(TB_TABLE_FIELD_RATING).asInteger;
                  theThumb.Keywords := FieldByName(TB_TABLE_FIELD_KEYWORDS).asstring;
                end;

                if bMetadataPresent then
                begin
                  theThumb.SourceExifFileDate := Fieldbyname(TB_TABLE_FIELD_EXIF_FILEDATE).AsDateTime;
                  theThumb.SourceExif_XPTitle := FieldByName(TB_TABLE_FIELD_EXIF_XPTITLE).asstring;
                  theThumb.SourceExif_XPAuthor := FieldByName(TB_TABLE_FIELD_EXIF_XPAUTHOR).asstring;
                  theThumb.SourceExif_XPComments := FieldByName(TB_TABLE_FIELD_EXIF_XPCOMMENTS).asstring;
                  theThumb.SourceExif_Orientation := FieldByName(TB_TABLE_FIELD_EXIF_ORIENTATION).AsInteger;

                  thethumb.SourceHasExif := FieldByName(TB_TABLE_FIELD_HASEXIF).AsBoolean;
                  thethumb.SourceHasIptc := FieldByName(TB_TABLE_FIELD_HASIPTC).AsBoolean;
                  thethumb.SourceHasDicom := FieldByName(TB_TABLE_FIELD_HASDICOM).AsBoolean;
                  thethumb.SourceHasXmp := FieldByName(TB_TABLE_FIELD_HASXMP).AsBoolean;
                end;
                //TB_TABLE_FIELD_HASH_MD5
                //TB_TABLE_FIELD_METATAGS_VERSION
              end;

             theThumb.SourceHasIOParams_Basic := TRUE;
             theThumb.RefreshCaptions;

              //correct thumb orientation even in case there was no exif thumb
            if (theThumb.MetaOptions.UseExifOrientationForThumbs) then
              TBAdjustEXIFOrientation(theThumb.IEBitmap, theThumb.SourceEXIF_Orientation);

            //-------------------------------------------------------------------------------
            result := true;
            theThumb.SetAdjournedTrue;
            //-------------------------------------------------------------------------------
          finally
            theThumb.Events_UnLock;  //unlock events
          end;

        end
        else
          result := false;
   finally
     fMainCS.Leave;
   end;
end;




procedure TThumbsBrowser_DB.ThumbSavetoDB(theSessionGuid: TGuid; theThumbRef:TObject; mode: TTB_Browser_DB_Mode; ParamsOnly: boolean);
var
  ablobstream: Tstream;
  aIO: Timageenio;
  theThumb:TThumbEX;
  aSession: TThumbsBrowser_DBThreadSafeSession;
 begin
  if not SessionOk(theSessionGuid, aSession) then EXIT;

  fMainCS.Enter;
  try
      if not assigned(theThumbRef) then EXIT;

      Assert(theThumbRef is TThumbEX);

      theThumb := TThumbEX(theThumbRef);
      if not assigned(theThumb.IEBitmap) then EXIT;

      if mode = dbmEdit then
        aSession.Table.Edit
      else
        aSession.Table.Insert;

      try
        if (theThumb.IEBitmap.width<>0)and(theThumb.IEBitmap.Height<>0)and(not paramsonly) then
        begin
          aIO := TImageenio.Create(nil);
          ablobstream := aSession.Table.createblobstream(aSession.Table.FieldByName(TB_TABLE_FIELD_THUMB), bmwrite);
          try
            aIO.AttachedIEBitmap := theThumb.IEBitmap;
            aio.Params.JPEG_ColorSpace := ioJPEG_YCbCrK;
            aio.Params.JPEG_Quality := 80;
            aio.Params.JPEG_Smooth := 20;
            aio.Params.JPEG_OptimalHuffman := true;
            aIO.savetoStreamJpeg(ablobstream);
          finally
            ablobstream.free;
            aIO.free;
          end;
        end;

        try
          assert(length(theThumb.unique_name)<= TBCONST_MAXLEN_IDSTRING, 'field size exceeded');
          with aSession.Table do
          begin
            FieldByName(TB_TABLE_FIELD_DBKIND).asstring := TBCONST_DBKind;
            FieldByName(TB_TABLE_FIELD_DBVERSION).asfloat := TBCONST_DBVersion;
            FieldByName(TB_TABLE_FIELD_IDSTRING).asstring := theThumb.Unique_Name;
            FieldByName(TB_TABLE_FIELD_PATH).asstring := theThumb.SourceFilePath;
            FieldbyName(TB_TABLE_FIELD_FILENAME_FULL).asstring := theThumb.SourceFileName;
            FieldByName(TB_TABLE_FIELD_FILEDATE).asdatetime := theThumb.SourceFileDate;
        
            FieldByName(TB_TABLE_FIELD_FILESIZE).asinteger := theThumb.SourceFileSize;
            FieldByName(TB_TABLE_FIELD_PICTURE_WIDTH).asinteger := theThumb.SourceFileWidth;
            FieldByName(TB_TABLE_FIELD_PICTURE_HEIGHT).asinteger := theThumb.SourceFileHeight;
            Fieldbyname(TB_TABLE_FIELD_PICTURE_RES).asinteger := theThumb.SourceFileRes;
            FieldByName(TB_TABLE_FIELD_THUMB_SIZE).asinteger := theThumb.SizeOffScreen;

             //sync fields section
            FieldByName(TB_TABLE_FIELD_TOPTITLE).asstring := theThumb.TopTitle;
            FieldByName(TB_TABLE_FIELD_BOTTOMTITLE).asstring := theThumb.BottomTitle;
            FieldByName(TB_TABLE_FIELD_RATING).asInteger := theThumb.Rating;
            FieldByName(TB_TABLE_FIELD_KEYWORDS).asstring := theThumb.Keywords;
            FieldByName(TB_TABLE_SYNCFIELDS_SAVED).AsBoolean := true;


            //metadata section
            FieldByName(TB_TABLE_FIELD_EXIF_FILEDATE).asdatetime := max(0, theThumb.SourceExifFileDate);
            FieldByName(TB_TABLE_FIELD_EXIF_XPTITLE).asstring := theThumb.SourceExif_XPTitle;
            FieldByName(TB_TABLE_FIELD_EXIF_XPAUTHOR).asstring := theThumb.SourceExif_XPAuthor;
            FieldByName(TB_TABLE_FIELD_EXIF_XPCOMMENTS).asstring := theThumb.SourceExif_XPComments;
            FieldByName(TB_TABLE_FIELD_EXIF_ORIENTATION).AsInteger := theThumb.SourceExif_Orientation;

            FieldByName(TB_TABLE_FIELD_HASEXIF).AsBoolean := thethumb.SourceHasExif;
            FieldByName(TB_TABLE_FIELD_HASIPTC).AsBoolean := thethumb.SourceHasIptc;
            FieldByName(TB_TABLE_FIELD_HASDICOM).AsBoolean := thethumb.SourceHasDicom;
            FieldByName(TB_TABLE_FIELD_HASXMP).AsBoolean := thethumb.SourceHasXmp;
            FieldByName(TB_TABLE_METADATA_SAVED).AsBoolean := true;


            //TB_TABLE_FIELD_HASH_MD5
            //TB_TABLE_FIELD_METATAGS_VERSION
            //v.3.0 end
          end;
        finally

        end;
        aSession.Table.post;
      except
        aSession.Table.cancel;
      end;

  finally
    fMainCS.Leave;
  end;

end;


function TThumbsBrowser_DB.DoQuery(theSessionGuid: TGuid; sql:string): TDataset;
var
qr:TNxQuery;
sqls:TStringList;
aSession: TThumbsBrowser_DBThreadSafeSession;
begin
   result := nil;
   if not SessionOk(theSessionGuid, aSession) then EXIT;

   fMainCS.Enter;
   try
       qr := TnxQuery.Create(nil);
       sqls := TStringList.create;
       try
         try
         sqls.add(sql);
         qr.Database := aSession.DB;
         qr.Session := aSession.Session;

         qr.SQL := sqls;
         qr.Open;
         result := qr;
         qr.Close;
         except
           qr.Close;
           qr.free;
         end;
       finally
         sqls.free;
       end;
   finally
     fMainCS.Leave;
   end;
end;

procedure TThumbsBrowser_DB.SetThumbJpgQuality(value:integer);
begin
  fThumbJpgQuality := max(40, min(value, 100));
end;


{TThumbsBrowser_DBThreadSafeSession}
 
     constructor TThumbsBrowser_DBThreadSafeSession.Create(theServer: TNXServerEngine;
                                                           theAliasPath:string;
                                                           theTableName:string;
                                                           theTimeOut: cardinal;
                                                           const bOpenTable: boolean);
     begin
       inherited Create;

       TBCoCreateGuid(fGUID);

       fSession := TNXSession.create(theServer.Owner);
       fSession.Timeout := theTimeOut;
       fSession.ServerEngine := theServer;

       fDB := TnxDatabase.Create(theServer.Owner);
       fDB.AliasPath := theAliasPath;
       fDB.Session := fSession;

       fTable := TNXTable.create(theServer.Owner);
       fTable.Database := fDB;
       fTable.Tablename := theTableName;
       if bOpenTable then
         fTable.open;
     end;

     destructor TThumbsBrowser_DBThreadSafeSession.Destroy;
     begin
        fTable.close;
        fSession.close;
        fDb.free;
        fSession.free;
        fTable.free;

        inherited;
     end;



     {TThumbsBrowser_DBThreadSafeSessions}
      Function TThumbsBrowser_DBThreadSafeSessions.GetSession(idx:integer): TThumbsBrowser_DBThreadSafeSession;
      begin
        result := TThumbsBrowser_DBThreadSafeSession(items[idx]);
      end;

      Function TThumbsBrowser_DBThreadSafeSessions.FindSession(guid:TGUID): TThumbsBrowser_DBThreadSafeSession;
      var
        I: Integer;
      begin
        result := nil;
        Lock;
         try
            for I := 0 to count-1 do
            begin
              if IsEqualGUID(guid, Getsession(i).guid) then
              begin
                result := Getsession(i);
                break;
              end;
            end;
         finally
           Unlock;
         end;
      end;

      


    {TThumbsBrowser_DBSessionStorage}
    constructor TThumbsBrowser_DBSessionStorage.Create(theGuid:TGuid; theTimeOut:cardinal);
    begin
      fGuid := theGuid;
      fSessionTimeout := theTimeout;
    end;

  initialization

     debugErrors := 0;

     SharedServer := nil;
     SharedClients := TList.create;

     SharedServer_CreateTempDBLocation;
  finalization

    SharedClients.free;
    SharedServer_DeleteTempDBLocation;
    //  showmessage(inttostr(debugErrors));

{$ENDIF}

end.


