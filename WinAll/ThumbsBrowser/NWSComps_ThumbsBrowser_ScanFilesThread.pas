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
unit NWSComps_ThumbsBrowser_ScanFilesThread;
{$R-}
{$Q-}
{$J+}
{$I ..\_inc\NWSComps_ThumbsBrowser.inc}
{$I ..\_inc\NWSComps_Shared.inc}
interface

uses
  windows, sysutils, Classes, forms, graphics, messages, dialogs, Contnrs, syncobjs, hyiedefs, hyieutils, imageenio;



type


  TThumbsBrowser_ScanFilesThread_FileRcd = class(TPersistent)
    public
    fname: string;
    fext: string;
    fdate: Tdatetime;
    fsize: integer;
    fFolderSlashed: string;
    sr:TSearchRec;

    procedure Assign(Source:TThumbsBrowser_ScanFilesThread_FileRcd); reintroduce;
  end;

  TThumbsBrowser_ScanFilesThread_FileRcds = TList;

  TThumbsBrowser_ScanFiles_Get_Event = function(filelist: TThumbsBrowser_ScanFilesThread_FileRcds; bTerminated: boolean):boolean of object;

  TThumbsBrowser_ScanFiles_CheckFileExt_Supported = procedure(var bsupported:boolean; fext: string) of object;
  TThumbsBrowser_ScanFiles_CheckFileExt_InFilter = procedure(var bInFilter:boolean; fname, fext: string) of object;



  TThumbsBrowser_ScanFilesThread = class(TThread)
  private
    { Private declarations }
    fCS: TCriticalSection;
    fAcceptFiles: boolean;
    fAcceptFolders: boolean;
    fProgressStep: integer;

    fRunning, fRunningsynch: boolean;
    fPaths: TStringlist;
    fFolders: TStringlist;
    fLastFound: TThumbsBrowser_ScanFilesThread_FileRcds;
  //  fper: integer;

    fScanfiles_ProgressEvent: TThumbsBrowser_ScanFiles_Get_Event;
    //fScanfiles_CheckFileExt_Supported: TThumbsBrowser_ScanFiles_CheckFileExt_Supported;
    fScanfiles_CheckFileExt_InFilter:  TThumbsBrowser_ScanFiles_CheckFileExt_InFilter;

    procedure FireProgress;
    procedure FireTerminate;



    procedure Load_FromFolder(var bTerminated: boolean; theFolder: string);
    procedure HandleNewSearchRecord(sr: TSearchRec; const thefolder_slashed: string);

    function GetRunning: boolean;
    procedure SetRunning(value:boolean);
    procedure SetRunningSynch;
    procedure FreeResources;
    procedure TestMsg;
    procedure BeforeDestruction; override;

  protected


    procedure Execute; override;
  public

    property Scanfiles_ProgressEvent: TThumbsBrowser_ScanFiles_Get_Event read fScanfiles_ProgressEvent write fScanfiles_ProgressEvent;
  //  property Scanfiles_CheckFileExt_Supported: TThumbsBrowser_ScanFiles_CheckFileExt_Supported read fScanfiles_CheckFileExt_Supported write fScanfiles_CheckFileExt_Supported;
    property Scanfiles_CheckFileExt_InFilter: TThumbsBrowser_ScanFiles_CheckFileExt_InFilter read fScanfiles_CheckFileExt_InFilter write fScanfiles_CheckFileExt_InFilter;

    property Paths: TStringlist read fPAths;
    property Running: boolean read GetRunning;

    constructor Create(bFreeOnTerminate: boolean; theCriticalSection: TCriticalSection);  reintroduce;
    destructor Destroy; override;
    procedure AssignFileScanParams(thefolders: TStringlist; iProgressStep: integer);
    procedure Start(bAcceptFiles, bAcceptFolders: boolean); reintroduce; overload;
    procedure Stop;


  end;





  TThumbsBrowser_GetFoldersRecursively_DoneEvent = procedure(sender: TObject; bAborted: boolean; theFolder: string; theFolderList: TStringlist; thePaths: TStringlist) of object;
  TThumbsBrowser_GetFoldersRecursively_ProgressEvent = procedure(sender: TObject; theCurrentFolder: string) of object;

  TThumbsBrowser_BrowseFoldersRecursiveThread = class(TThread)
  private
     fCS: TCriticalSection;
     fRunning: boolean;
     fAborted: boolean;
     fSuccess: boolean;
     fFolder:string;
     fFolderList: TStringList;
     fPaths: TStringlist;
     fDoneEventHandler: TThumbsBrowser_GetFoldersRecursively_DoneEvent;
     fProgressEventHandler: TThumbsBrowser_GetFoldersRecursively_ProgressEvent;
     fSyncCheckDone: TNotifyEvent;
    procedure CheckDone;
  protected
    procedure Done;
    procedure Execute; override;

  public

    property Running: boolean read fRunning write fRunning;
    property Aborted: boolean read fAborted write fAborted;
    property Success: boolean read fSuccess write fSuccess;


    Constructor Create(theFolder: string; theFolderRecursionList: TStringlist; theBrowsedPaths: TStringlist;
                        Handle_DoneFoldersRecursively: TThumbsBrowser_GetFoldersRecursively_DoneEvent;
                        Handle_Progress: TThumbsBrowser_GetFoldersRecursively_ProgressEvent;
                        Handle_SyncCheckDone: tNotifyEvent;
                        theCriticalSection: TCriticalSection); reintroduce;

    destructor Destroy; override;

    procedure Abort;
  end;


  procedure Dispose_ScanFilesThread_FileRcds(rcds:TThumbsBrowser_ScanFilesThread_FileRcds; bFreeList: boolean);


implementation

uses  math, NWSComps_ThumbsBrowser_Utils, NWSComps_ThumbsBrowser_Shell_Utils;


procedure Dispose_ScanFilesThread_FileRcds(rcds:TThumbsBrowser_ScanFilesThread_FileRcds; bFreeList: boolean);
var
  I: Integer;
begin
    try
    for I := 0 to rcds.Count-1 do
    begin
      if assigned(rcds[i]) then
        TThumbsBrowser_ScanFilesThread_FileRcd(rcds[i]).free;
    end;
       if bFreeList and assigned(rcds) then
         freeandnil(rcds);
  finally

  end;
end;

{ TThumbsBrowser_ScanFilesThread  }

constructor TThumbsBrowser_ScanFilesThread.Create(bFreeOnTerminate: boolean ; theCriticalSection: TCriticalSection);
begin
inherited create(true);
  FreeOnTerminate := bFreeOnTerminate;
  fCS :=  theCriticalSection;

  fRunning := False;
  fRunningsynch := False;

  fAcceptFiles := false;
  fAcceptFolders := False;
  fProgressStep := 100;

  fPaths := TStringlist.create;
  fLastFound := TThumbsBrowser_ScanFilesThread_FileRcds.Create;
  fFolders := TStringlist.create;
  fScanfiles_ProgressEvent := nil;

  Priority := tpLowest;
 // fiebmp.Location := iefile;


end;

procedure TThumbsBrowser_ScanFilesThread.BeforeDestruction;
begin
 inherited;
end;

destructor TThumbsBrowser_ScanFilesThread.Destroy;
begin
//  synchronize(testmsg);

  fScanfiles_ProgressEvent := nil;
 // fScanfiles_CheckFileExt_Supported := nil;
 // fScanfiles_CheckFileExt_InFilter := nil;
  sleep(100);

  FreeResources;


  inherited;
end;

procedure TThumbsBrowser_ScanFilesThread.FreeResources;
begin
 if assigned(fCS) then
   fCS.Enter;
  try
    freeandnil(fpaths);
    freeandnil(fFolders);

    Dispose_ScanFilesThread_FileRcds(fLastFound, true);

  finally
    if assigned(fCS) then
      fCs.Leave;
  end;


 // synchronize(TestMsg);

end;

procedure TThumbsBrowser_ScanFilesThread.FireTerminate;
begin
  if assigned(fScanfiles_ProgressEvent) then
  begin
    if fScanfiles_ProgressEvent(fLastFound, true) then
    begin
     //Dispose_ScanFilesThread_FileRcds(fLastFound, false);
     fLastFound.Clear;
    end;
  end;
end;

procedure TThumbsBrowser_ScanFilesThread.FireProgress;
begin
  //if self = nil then exit;

  if assigned(fScanfiles_ProgressEvent) then
  begin
    if fScanfiles_ProgressEvent(fLastFound, false) then
    begin
     //Dispose_ScanFilesThread_FileRcds(fLastFound, false);
     fLastFound.Clear;
    end;
  end;
end;

procedure TThumbsBrowser_ScanFilesThread.TestMsg;
begin
  showmessage('ok_TThumbsBrowser_ScanFilesThread_Destroy');
end;

procedure TThumbsBrowser_ScanFilesThread.Execute;
var
 i: integer;
 bTerminated: boolean;
begin
  { Place thread code here }
    SetRunning(true);

    fpaths.Clear;
    fLastfound.Clear;
   // Dispose_ScanFilesThread_FileRcds(fLastFound, false);
     try

       for I := 0 to ffolders.Count-1 do
       begin
         Load_FromFolder( bTerminated, fFolders[i]);
         if bTerminated then
           break;
       end;
     finally
       synchronize(FireTerminate);
        SetRunning(False);
      // FireTerminate(false);
     end;

end;



procedure TThumbsBrowser_ScanFilesThread.AssignFileScanParams(thefolders: TStringlist; iProgressStep: integer);
begin
  fProgressStep := iProgressStep;
  TBStringListcopy(thefolders, ffolders);

end;

procedure TThumbsBrowser_ScanFilesThread.Start(bAcceptFiles, bAcceptFolders: boolean);
begin
  fAcceptFiles := bAcceptFiles;
  fAcceptFolders := bAcceptFolders;
  {$IFDEF NWSCOMPS_DXE2_UPPER}
  Start;
 {$ELSE}
  resume;
 {$ENDIF}
end;

procedure TThumbsBrowser_ScanFilesThread.Stop;
begin
  terminate;
end;













procedure TThumbsBrowser_ScanFilesThread.Load_FromFolder(var bTerminated: boolean; theFolder: string);
var
  sr: TSearchRec;
  thefolder_slashed: string;
  FileAttrs: Integer;
  startTk: integer;
  isl, slTo, slDelta:integer;
begin
    if theFolder = '' then exit;
    if not directoryexists(theFolder) then exit;

    thefolder_slashed := Tbs_AddSlash(theFolder);

    TBCheckandAddPath(thefolder_slashed, fpaths);


    FileAttrs := faAnyFile;
    if FindFirst(thefolder_slashed + '*.*', FileAttrs, sr) = 0 then
    begin
      try
        HandleNewSearchRecord(sr, thefolder_slashed);
        bTerminated := self.Terminated;
        if bTerminated then EXIT;

        while FindNext(sr) = 0 do
        begin
          HandleNewSearchRecord(sr, thefolder_slashed);
          bTerminated := self.Terminated;
          if bTerminated then EXIT;

          if ((fLastFound.count>0) and (fLastFound.count mod fProgressStep = 0)) then
          begin
            startTk := GetTickCount;
           synchronize(FireProgress);
            if GetTickCount - startTk > 500 then
            begin
              slTo := min(1000, (GetTickCount - startTk) div 5);
              slDelta := slTo div 50;
              for isl := 0 to slTo do
              begin
                if bTerminated then break;
                if isl mod slDelta = 0 then
                  sleep(slDelta);
              end;
            end;

          end;
        end;

     finally
      FindClose(sr);
     end;
     
    end;

end;


procedure TThumbsBrowser_ScanFilesThread.HandleNewSearchRecord(sr: TSearchRec; const thefolder_slashed: string);
var
aFileRecord: TThumbsBrowser_ScanFilesThread_FileRcd;
bOK: boolean;
begin
  aFileRecord := TThumbsBrowser_ScanFilesThread_FileRcd.Create;
  aFileRecord.fext := extractfileext(sr.name);

  //fAcceptFolders
  //if sr.Attr=fadirectory then
  if (sr.attr and faDirectory) <> 0  then
  begin
    bOK := fAcceptFolders and ((sr.Name<>'.') and (sr.Name <> '..'));
  end
  else
  begin
     bOK := False;
     if fAcceptFiles then
     begin
        if assigned(fScanfiles_CheckFileExt_InFilter) then
          fScanfiles_CheckFileExt_InFilter(bOk, sr.name, aFileRecord.fext);
     end;
  end;
      //if TBStringinArray(fext, TBValidList) then
      if bOK then
      begin

          aFileRecord.fFolderSlashed := thefolder_slashed;
          aFileRecord.fname := thefolder_slashed + sr.Name;
          aFileRecord.fdate := tbs_getfiledate(sr);

          aFileRecord.fsize := sr.Size;

          aFileRecord.sr := sr;


          fLastFound.Add(aFileRecord)  //add record

      end
      else
        aFileRecord.free;  //else record was not added, so free it immediately
end;



function TThumbsBrowser_ScanFilesThread.GetRunning: boolean;
begin
  result := fRunningsynch;
end;

procedure TThumbsBrowser_ScanFilesThread.SetRunning(value:boolean);
begin
  fRunning := value;
  synchronize(SetRunningSynch);
end;

procedure TThumbsBrowser_ScanFilesThread.SetRunningSynch;
begin
  fRunningsynch := fRunning;
end;




{ TThumbsBrowser_ScanFilesThread_FileRcd }
procedure TThumbsBrowser_ScanFilesThread_FileRcd.Assign(Source: TThumbsBrowser_ScanFilesThread_FileRcd);
begin
  self.sr := source.sr;
  self.fname := source.fname;
  self.fext := source.fext;
  self.fdate := source.fdate;
  self.fsize := source.fsize;
  self.fFolderSlashed := source.fFolderSlashed;
end;





{ TThumbsBrowser_BrowseFoldersRecursiveThread }
procedure GetFoldersRecursively(theFolder: string;
                                theFolderRecursionList: TStringList;
                                theBrowsedPaths: TStringList;
                                TheProgressEvent: TThumbsBrowser_GetFoldersRecursively_ProgressEvent;
                                var bAborted: boolean);
const
  flagInRecursion: integer = -1;
  lastTick: integer = 0;

  procedure AddFolder(thename: string; const bAddSelf, bAddTree: boolean);
  begin
    //StartBrowsing(thename);
    if bAddSelf then
    begin
      theFolderRecursionList.add(thename);
      TBCheckandAddPath(Tbs_AddSlash(thename), theBrowsedPaths);
    end;

    if bAddTree then
      GetFoldersRecursively(thename, theFolderRecursionList, theBrowsedPaths,TheProgressEvent, bAborted);
  end;

var
  sr: TSearchRec;
  FileAttrs: Integer;
  slashedfolder: string;
  i: integer;

begin
  if bAborted then EXIT;


  if theFolder = '' then
  begin
    for i := 0 to theBrowsedPaths.Count - 1 do
    begin
      GetFoldersRecursively(theBrowsedPaths[i], theFolderRecursionList, theBrowsedPaths, TheProgressEvent, bAborted);
    end;
    EXIT;
  end;

  if flagInRecursion = -1 then
    theFolderRecursionList.clear;

  if GetTickCount - lastTick > 200 then
  begin
    lastTick := GetTickCount;
    TheProgressEvent(nil, theFolder);
  end;

  flagInRecursion := flagInRecursion+1;

  slashedfolder := Tbs_AddSlash(theFolder);

  try
    FileAttrs := faAnyfile;

    if FindFirst(slashedfolder + '*.*', FileAttrs, sr) = 0 then
    begin
      try
        if ((sr.attr and faDirectory) <> 0)and (sr.name<>'.') and (sr.name<>'..') then
        begin
          AddFolder(slashedfolder + sr.name, true, true);
        end;

        while findnext(sr) = 0 do
        begin
          if ((sr.attr and faDirectory) <> 0)and (sr.name<>'.') and (sr.name<>'..') then
          begin
            AddFolder(slashedfolder + sr.name, true, true);
          end;
        end;
      finally
        FindClose(sr);
      end;
    end;

    dec(flagInRecursion);
    finally
    ;
  end;

end;

constructor TThumbsBrowser_BrowseFoldersRecursiveThread.Create(
  theFolder: string; theFolderRecursionList, theBrowsedPaths: TStringlist;
  Handle_DoneFoldersRecursively: TThumbsBrowser_GetFoldersRecursively_DoneEvent;
  Handle_Progress: TThumbsBrowser_GetFoldersRecursively_ProgressEvent;
  Handle_SyncCheckDone: tNotifyEvent;
  theCriticalSection: TCriticalSection);
begin

  inherited Create(False);
  FreeOnTerminate := false;

  fRunning := true;
  fAborted := false;
  fSuccess := false;
  fFolder := theFolder;
  fFolderList := theFolderRecursionList;
  fPaths := theBrowsedPaths;
  fDoneEventHandler := Handle_DoneFoldersRecursively;
  fProgressEventHandler := Handle_Progress;
  fSyncCheckDone := Handle_SyncCheckDone;
  fCS := theCriticalSection;

end;

procedure TThumbsBrowser_BrowseFoldersRecursiveThread.Execute;
begin
  inherited;


  try
     if assigned(fCS) then
       fCS.Enter;
     try
     GetFoldersRecursively(fFolder, fFolderList, fPaths, fProgressEventHandler, fAborted);
     fSuccess := not fAborted;

     synchronize(CheckDone);

     Done;
     finally
       if assigned(fCS) then
         fCS.Leave;
     end;

     //synchronize(CheckDone);
  finally
     fRunning := false;
  end;

end;

procedure TThumbsBrowser_BrowseFoldersRecursiveThread.CheckDone;
begin
   if assigned(fSyncCheckDone) then
     fSyncCheckDone(self);
end;

procedure TThumbsBrowser_BrowseFoldersRecursiveThread.Abort;
begin
   fAborted := true;
end;

destructor TThumbsBrowser_BrowseFoldersRecursiveThread.Destroy;
begin
  sleep(0);
  inherited;
end;

procedure TThumbsBrowser_BrowseFoldersRecursiveThread.Done;
begin
   if assigned(fDoneEventHandler) then
     fDoneEventHandler(self, fAborted, fFolder, fFolderList, fPaths);
end;


end.
