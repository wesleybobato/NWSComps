{*******************************************************************************
                 JanH_WinTab for Delphi 4,5,6,7 version 1.1
 Author:
        Jan HLAVENKA
        e-mail: jan@hlavenka.cz
        web: http://jan.hlavenka.cz

 Copyright © 1997-2003 by Jan HLAVENKA

 This software is provided as it is, without any kind of warranty
 given. Use it at your own risk.

 You may use this software in any kind of development, including
 comercial, redistribute, and modify it freely, under the
 following restrictions :

 1. The origin of this software may not be mispresented, you must
    not claim that you wrote the original software. If you use
    this software in any kind of product, it would be appreciated
    that there in a information box, or in the documentation would
    be an acknowledgmnent like this
           Parts Copyright © 2003 by Jan HLAVENKA

 2. You may not have any income from distributing this source
    to other developers. When you use this product in a comercial
    package, the source may not be charged seperatly.

 3. This notice should also follow the package if you use this
    source in a commercial product.

*******************************************************************************}

unit JH_WinTab;

interface

uses Messages, Forms, Classes, Windows, SysUtils, JH_WinTab_Const;

//------ WinTab specification --------------------------------------------------
type
  TJanHWinTab = class(TComponent)
  private

    //Field Added by Francesco Savastano
    FInProximity: boolean;


    FActive     : boolean;
    FParent     : THandle;
    FNewWndProc : pointer;
    FOldWndProc : pointer;
    FWorkCTX    : TLogContextA;
    FPacket     : TTabletPacket;

    FWinTabID           : string;
    FKnihovna           : HWND;
    FCTXHandle          : HCTX;

    FOnStart            : TNotifyEvent;
    FOnStop             : TNotifyEvent;
    FOnPacket           : TPacketEvent;
    FOnCSRChange        : TPacketEvent;
    FOnOpenContext      : TCTXEvent;
    FOnCloseContext     : TCTXEvent;
    FOnUpdateContext    : TCTXEvent;
    FOnOverlapContext   : TCTXEvent;
    FOnProximity        : TProximityEvent;
    FOnInfoChange       : TInfoChangedEvent;
  protected
    function    GetContext: TLogContextA;
    procedure   SetContext(const Value: TLogContextA);
    function    GetEnabled: boolean;
    procedure   SetEnabled(const Value: boolean);

    procedure   Start;
    procedure   NewWndProc(var Msg: TMessage);
    procedure   TestActive(bHodnota: boolean);
    
//format output info
    function    FormatInfo(Category, Index: DWORD): string;
    function    FormatInfoNum(Category, Index: DWORD): DWORD;
    function    FormatInfoNumInt(Category, Index: DWORD): LongInt;
    function    FormatInfoVer(Category, Index: DWORD): string;

// WTI Interface
    function    ReadWTID: string;
    function    ReadSpecVer: string;
    function    ReadImplVer: string;
    function    ReadNDevice: DWORD;
    function    ReadNCursors: DWORD;
    function    ReadNContexts: DWORD;
// WTI Status
    function    ReadContexts: DWORD;
    function    ReadPKTRate: DWORD;
// WTI Devices
    function    ReadDVCName: string;
// WTI Cursors
    function    ReadCSRName: string;
// WTI Extensions
    function    ReadEXTName: string;
  public

   //properties Added by Francesco Savastano

    property CurrentPacket: TTabletPacket read fPacket;
    property InProximity: boolean read FInProximity;
   /////////

    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure   OpenTablet(Context: TLogContextA; Enable: Boolean);
    procedure   CloseTablet;

    function    GetInfoAsString(Category, Index: DWORD; DataType: byte): string;
    function    GetInfoAsData(Category, Index: DWORD): pointer;
    function    GetPressure: TAxis;

    procedure   DefaultCTX(var Context: TLogContextA);

  published
    property    Active: boolean read FActive write TestActive;
    property    Context: TLogContextA read GetContext write SetContext;
    property    Enabled: boolean read GetEnabled write SetEnabled;
    property    Pressure: TAxis read GetPressure;

// WTI Interface
    property    WinTabId: string read ReadWTID write FWinTabID;
    property    SpecVersion: string read ReadSpecVer;
    property    ImplVersion: string read ReadImplVer;
    property    NDevices: DWORD read ReadNDevice;
    property    NCursors: DWORD read ReadNCursors;
    property    NContexts: DWORD read ReadNContexts;
// WTI Status
    property    Contexts: DWORD read ReadContexts;
    property    PktRate: DWORD read ReadPktRate;
// WTI Devices
    property    DeviceName: string read ReadDvcName;
// WTI Cursors
    property    CursorName: string read ReadCSRName;
// WTI Extensions
    property    ExtensionName: string read ReadEXTName;

// Events
    property    OnStart: TNotifyEvent read FOnStart write FOnStart;
    property    OnStop: TNotifyEvent read FOnStop write FOnStop;
    property    OnPacket: TPacketEvent read FOnPacket write FOnPacket;
    property    OnCSRChange: TPacketEvent read FOnCSRChange write FOnCSRChange;
    property    OnContextOpen: TCTXEvent read FOnOpenContext write FOnOpenContext;
    property    OnContextClose: TCTXEvent read FOnCloseContext write FOnCloseContext;
    property    OnContextUpdate: TCTXEvent read FOnUpdateContext write FOnUpdateContext;
    property    OnContextOverlap: TCTXEvent read FOnOverlapContext write FOnOverlapContext;
    property    OnProximity: TProximityEvent read FOnProximity write FOnProximity;
    property    OnInfoChange: TInfoChangedEvent read FOnInfoChange write FOnInfoChange;
  end;

resourcestring  TabError = 'No active Tablet found';

procedure Register;

implementation

//--------- Constructor --------------------------------------------------------
constructor TJanHWinTab.Create(AOwner: TComponent);
begin
   inherited Create(AOwner);
   FActive:=false;
   FParent:=(AOwner as TForm).Handle;
   FInProximity := false;
end;

//--------- Destructor ---------------------------------------------------------
destructor  TJanHWinTab.Destroy;
begin
   FreeLibrary(FKnihovna);
   inherited Destroy;
end;

//--------- Context ------------------------------------------------------------
procedure TJanHWinTab.OpenTablet(Context: TLogContextA; Enable: Boolean);
begin
   if FActive then FCTXHandle:=WTOpen(FParent,@Context,Enable);
end;

procedure TJanHWinTab.CloseTablet;
begin
   WTClose(FCTXHandle);
end;

function TJanHWinTab.GetInfoAsString(Category, Index: DWORD; DataType: byte): string;
begin
   if FActive then begin
    try
     case DataType of
      1: Result:=FormatInfo(Category,Index);                 //text data
      2: Result:=FormatInfoVer(Category,Index);              //version information
      3: Result:=InttoStr(FormatInfoNumInt(Category,Index));   //originaly DWORD
      else Result:=InttoStr(FormatInfoNum(Category,Index));  //originaly UINT
     end;
    except
     Result:='';
    end;
   end;
end;

function TJanHWinTab.GetInfoAsData(Category, Index: DWORD): pointer;
begin
   if FActive then begin
    GetMem(Result,WTInfo(Category,Index,nil));
    WTInfo(Category,Index,Result);
   end else Result:=nil;
end;

function TJanHWinTab.GetPressure: TAxis;
begin
   if FActive then Result:=TAxis(GetInfoAsData(WTI_DEVICES,DVC_NPRESSURE)^);
end;

procedure TJanHWinTab.DefaultCTX(var Context: TLogContextA);
begin
   WTInfo(WTI_DEFCONTEXT,0,@Context);
end;

//--------- Set Get CTX functions ----------------------------------------------
function TJanHWinTab.GetContext: TLogContextA;
begin
   if FActive then WTGet(FCTXHandle,@Result);
end;

procedure TJanHWinTab.SetContext(const Value: TLogContextA);
begin
   if FActive then WTSet(FCTXHandle,@Value);
end;

function TJanHWinTab.GetEnabled: boolean;
begin
   if FActive then Result:=WTGet(FCTXHandle,@FWorkCTX)
    else Result:=false;
end;

procedure TJanHWinTab.SetEnabled(const Value: boolean);
begin
   if FActive then WTEnable(FCTXHandle,value);
end;

//--------- Format output functions --------------------------------------------
function  TJanHWinTab.FormatInfo(Category, Index: DWORD): string;
var Buffer: PAnsiChar;
begin
   GetMem(Buffer,WTInfo(Category,Index,nil));
   WTInfo(Category,Index,Buffer);
   Result:=StrPas(Buffer);
   FreeMem(Buffer);
end;

function  TJanHWinTab.FormatInfoNum(Category, Index: DWORD): DWORD;
var Buffer: DWORD;
begin
   WTInfo(Category,Index,@Buffer);
   Result:=Buffer;
end;

function  TJanHWinTab.FormatInfoNumInt(Category, Index: DWORD): LongInt;
var Buffer: LongInt;
begin
   WTInfo(Category,Index,@Buffer);
   Result:=Buffer;
end;

function  TJanHWinTab.FormatInfoVer(Category, Index: DWORD): string;
var Buffer: DWORD;
begin
   WTInfo(Category,Index,@Buffer);
   Result:=InttoStr(Buffer div 255)+'.'+InttoStr(Buffer-255);
end;

//--------- Poperty readers ----------------------------------------------------
// WTI Interface
function  TJanHWinTab.ReadWTID: string;
begin
   if FActive then Result:=FormatInfo(WTI_INTERFACE,IFC_WINTABID)
     else Result:=TabError;
end;

function  TJanHWinTab.ReadSpecVer: string;
begin
   if FActive then Result:=FormatInfoVer(WTI_INTERFACE,IFC_SPECVERSION)
     else Result:='0';
end;

function  TJanHWinTab.ReadImplVer: string;
begin
   if FActive then Result:=FormatInfoVer(WTI_INTERFACE,IFC_IMPLVERSION)
     else Result:='0';
end;

function  TJanHWinTab.ReadNDevice: DWORD;
begin
   if FActive then Result:=FormatInfoNum(WTI_INTERFACE,IFC_NDEVICES)
     else Result:=0;
end;

function  TJanHWinTab.ReadNCursors: DWORD;
begin
   if FActive then Result:=FormatInfoNum(WTI_INTERFACE,IFC_NCURSORS)
     else Result:=0;
end;

function  TJanHWinTab.ReadNContexts: DWORD;
begin
   if FActive then Result:=FormatInfoNum(WTI_INTERFACE,IFC_NCONTEXTS)
     else Result:=0;
end;

// WTI Status
function TJanHWinTab.ReadContexts: DWORD;
begin
   if FActive then Result:=FormatInfoNum(WTI_STATUS,STA_CONTEXTS)
     else Result:=0;
end;

function  TJanHWinTab.ReadPKTRate: DWORD;
begin
   if FActive then Result:=FormatInfoNum(WTI_STATUS,STA_PKTRATE)
     else Result:=0;
end;

// WTI Devices
function  TJanHWinTab.ReadDVCName: string;
begin
   if FActive then Result:=FormatInfo(WTI_DEVICES,DVC_NAME)
     else Result:=TabError;
end;

// WTI Cursors
function TJanHWinTab.ReadCSRName: string;
begin
   if FActive then Result:=FormatInfo(WTI_CURSORS,CSR_NAME)
     else Result:=TabError;
end;

// WTI Extensions
function TJanHWinTab.ReadEXTName: string;
begin
   if FActive then Result:=FormatInfo(WTI_EXTENSIONS,EXT_NAME)
     else Result:=TabError;
end;

//------- Start ----------------------------------------------------------------
procedure TJanHWinTab.Start;
begin
   @WTInfo:=GetProcAddress(FKnihovna,'WTInfoA');
   @WTOpen:=GetProcAddress(FKnihovna,'WTOpenA');
   @WTClose:=GetProcAddress(FKnihovna,'WTClose');
   @WTPacketsGet:=GetProcAddress(FKnihovna,'WTPacketsGet');
   @WTPacket:=GetProcAddress(FKnihovna,'WTPacket');
   @WTEnable:=GetProcAddress(FKnihovna,'WTEnable');
   @WTOverlap:=GetProcAddress(FKnihovna,'WTOverlap');
   @WTConfig:=GetProcAddress(FKnihovna,'WTConfig');
   @WTGet:=GetProcAddress(FKnihovna,'WTGetA');
   @WTSet:=GetProcAddress(FKnihovna,'WTSetA');
   @WTExtGet:=GetProcAddress(FKnihovna,'WTExtGet');
   @WTExtSet:=GetProcAddress(FKnihovna,'WTExtSet');
   @WTSave:=GetProcAddress(FKnihovna,'WTSave');
   @WTRestore:=GetProcAddress(FKnihovna,'WTRestore');
   @WTPacketsPeek:=GetProcAddress(FKnihovna,'WTPacketsPeek');
   @WTDataGet:=GetProcAddress(FKnihovna,'WTDataGet');
   @WTDataPeek:=GetProcAddress(FKnihovna,'WTDataPeek');
   @WTQueuePacketsEx:=GetProcAddress(FKnihovna,'WTQueuePacketsEx');
   @WTQueueSizeGet:=GetProcAddress(FKnihovna,'WTQueueSizeGet');
   @WTQueueSizeSet:=GetProcAddress(FKnihovna,'WTQueueSizeSet');
   @WTMgrOpen:=GetProcAddress(FKnihovna,'WTMgrOpen');
   @WTMgrClose:=GetProcAddress(FKnihovna,'WTMgrClose');
   @WTMgrContextEnum:=GetProcAddress(FKnihovna,'WTMgrContextEnum');
   @WTMgrContextOwner:=GetProcAddress(FKnihovna,'WTMgrContextOwner');
   @WTMgrDefContext:=GetProcAddress(FKnihovna,'WTMgrDefContext');
   @WTMgrDefContextEx:=GetProcAddress(FKnihovna,'WTMgrDefContextEx');
   @WTMgrDeviceConfig:=GetProcAddress(FKnihovna,'WTMgrDeviceConfig');
   @WTMgrConfigReplaceEx:=GetProcAddress(FKnihovna,'WTMgrConfigReplaceExA');
   @WTMgrPacketHookEx:=GetProcAddress(FKnihovna,'WTMgrPacketHookExA');
   @WTMgrPacketUnHook:=GetProcAddress(FKnihovna,'WTMgrPacketUnHook');
   @WTMgrPacketHookNext:=GetProcAddress(FKnihovna,'WTMgrPacketHookNext');
   @WTMgrExt:=GetProcAddress(FKnihovna,'WTMgrExt');
   @WTMgrCsrEnable:=GetProcAddress(FKnihovna,'WTMgrCsrEnable');
   @WTMgrCsrButtonMap:=GetProcAddress(FKnihovna,'WTMgrCsrButtonMap');
   @WTMgrCsrPressureBtnMarksEx:=GetProcAddress(FKnihovna,'WTMgrCsrPressureBtnMarksEx');
   @WTMgrCsrPressureResponse:=GetProcAddress(FKnihovna,'WTMgrCsrPressureResponse');
   @WTMgrCsrExt:=GetProcAddress(FKnihovna,'WTMgrCsrExt');
end;

//--------- EventHandler -------------------------------------------------------
procedure TJanHWinTab.NewWndProc(var Msg: TMessage);
begin
    with Msg do begin
    case Msg of
      WT_PACKET:     if  WTPacket(lParam,wParam,@FPacket) then
                       if Assigned(FOnPacket) then
                         FOnPacket(Self,wParam,lParam,FPacket);

      WT_CSRCHANGE:  if WTPacket(lParam,wParam,@FPacket) then
                       if Assigned(FOnCSRChange) then
                          FOnCSRChange(Self,wParam,lParam,FPacket);
                          
      WT_CTXOPEN:    if Assigned(FOnOpenContext) then FOnOpenContext(Self,wParam,lParam);
      WT_CTXCLOSE:   if Assigned(FOnCloseContext) then FOnCloseContext(Self,wParam,lParam);
      WT_CTXUPDATE:  if Assigned(FOnUpdateContext) then FOnUpdateContext(Self,wParam,lParam);
      WT_CTXOVERLAP: if Assigned(FOnOverlapContext) then FOnOverlapContext(Self,wParam,lParam);
      WT_PROXIMITY:
      //Adapted by Francesco Savastano
                     begin
                       FInProximity :=  lParamLo<>0;
                       if Assigned(FOnProximity) then FOnProximity(Self,wParam, FInProximity);
                     end;
      WT_INFOCHANGE: if Assigned(FOnInfoChange) then FOnInfoChange(Self,wParam,lParamLo,lParamHi);
    end;
    Result:=CallWindowProc(FOldWndProc,FParent,Msg,wParam,lParam);
   end;

 //Modified by Francesco Savastano
(*
   with Msg do begin
    case Msg of
      WT_PACKET:     if (Assigned(FOnPacket) AND WTPacket(lParam,wParam,@FPacket)) then
                       FOnPacket(Self,wParam,lParam,FPacket);
      WT_CSRCHANGE:  if (Assigned(FOnCSRChange) AND WTPacket(lParam,wParam,@FPacket)) then
                       FOnCSRChange(Self,wParam,lParam,FPacket);
      WT_CTXOPEN:    if Assigned(FOnOpenContext) then FOnOpenContext(Self,wParam,lParam);
      WT_CTXCLOSE:   if Assigned(FOnCloseContext) then FOnCloseContext(Self,wParam,lParam);
      WT_CTXUPDATE:  if Assigned(FOnUpdateContext) then FOnUpdateContext(Self,wParam,lParam);
      WT_CTXOVERLAP: if Assigned(FOnOverlapContext) then FOnOverlapContext(Self,wParam,lParam);
      WT_PROXIMITY:  if Assigned(FOnProximity) then FOnProximity(Self,wParam,lParamLo<>0);
      WT_INFOCHANGE: if Assigned(FOnInfoChange) then FOnInfoChange(Self,wParam,lParamLo,lParamHi);
    end;
    Result:=CallWindowProc(FOldWndProc,FParent,Msg,wParam,lParam);
   end;
*)
end;

//------- Test active ----------------------------------------------------------
procedure TJanHWinTab.TestActive(bHodnota: boolean);
begin
   if bHodnota then begin
     if not FActive then begin     //activate
          FKnihovna:=LoadLibrary('wintab32.dll');
          if FKnihovna<>0 then begin
             Start;
             if not FActive then begin
              FNewWndProc:=MakeObjectInstance(NewWndProc);
              FOldWndProc:=pointer(SetWindowLong(FParent,GWL_WndProc,longInt(FNewWndProc)));
             end;
             FActive:=true;
             DefaultCTX(FWorkCTX);

             with FWorkCTX do begin
              lcOptions:=lcOptions or localCTXOption;
              lcPktData:=localPktData;
              lcBtnDnMask:=localBtnAssign;
              lcBtnUpMask:=localBtnAssign;
              lcMsgBase:=WT_DEFBASE;
             end;
             OpenTablet(FWorkCTX,true);
             if Assigned(FOnStart) then FOnStart(Self);
          end;
      end;
    end else begin                   //deactivate
             if FActive then begin
               Enabled:=false;
               CloseTablet;
               SetWindowLong(FParent,GWL_WndProc,LongInt(FOldWndProc));
               FreeObjectInstance(FNewWndProc);
             end;
             FActive:=false;
             FreeLibrary(FKnihovna);
             if Assigned(FOnStop) then FOnStop(Self);
    end;
end;

//------- Register -------------------------------------------------------------
procedure Register;
begin
   RegisterComponents('Jan Hlavenka', [TJanHWinTab]);
end;

end.

