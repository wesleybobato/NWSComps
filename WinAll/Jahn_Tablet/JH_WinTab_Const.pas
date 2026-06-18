{*******************************************************************************
                 JanH_WinTab_Contants for Delphi 4,5,6,7 version 1.1
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

unit JH_WinTab_Const;

interface

uses Windows;

const
  WT_DEFBASE = $7FF0;
  WT_MAXOFFSET = $F;

  WT_PACKET = WT_DEFBASE + 0;
  WT_CTXOPEN = WT_DEFBASE + 1;
  WT_CTXCLOSE = WT_DEFBASE + 2;
  WT_CTXUPDATE = WT_DEFBASE + 3;
  WT_CTXOVERLAP = WT_DEFBASE + 4;
  WT_PROXIMITY = WT_DEFBASE + 5;
  WT_INFOCHANGE = WT_DEFBASE + 6;
  WT_CSRCHANGE = WT_DEFBASE + 7;
  WT_MAX = WT_DEFBASE + WT_MAXOFFSET;

type
  FIX32 = DWORD;
  HMGR = HWND;
  HCTX = HWND;
  HWTHOOK = HWND;
  WTPKT = DWORD;
  WTENUMPROC = function(hCtx: HCTX; lParam: Longint): boolean;
  WTCONFIGPROC = function(hCtx: HCTX; hWnd: HWND): boolean;
  WTHOOKPROC = function(wParam: DWORD; lParam: LongInt):LResult;

    TOrientation = record
    orAzimuth: integer;
    orAltitude: integer;
    orTwist: integer;
  end;

  TRotation = record
    roPitch: integer;
    roRoll: integer;
    roYaw: integer;
  end;

  TAxis = record
           axMin: longint;
           axMax: longint;
           axUnits: DWORD;
           axResolution: FIX32;
          end;

  TTabletPacket = record
                   pkContext:     HCTX;
                   pkStatus:      DWORD;
                   pkCursor:      DWORD;
                   pkButtons:     LongInt;
                   pkPosition:    TPoint;
                   pkPressure:    DWORD;
                   pkTangPress:   DWORD;
                   pkOrientation: TOrientation;
                   pkRotation:    TRotation;
                  end;

  TPacketEvent = procedure(Sender: TObject; PacketSerial, Handle: HCTX; Packet: TTabletPacket) of object;
  TCTXEvent =  procedure(Sender: TObject; CTXHandle, Flags: DWORD) of object;
  TProximityEvent = procedure(Sender: TObject; CTXHandle: HCTX; Enter: Boolean) of object;
  TInfoChangedEvent = procedure(Sender: TObject; ManagerHandle: HCTX; Category, Index: DWORD) of object;

const
  PK_CONTEXT          = $0001;  // reporting context
  PK_STATUS           = $0002;  // status bits
  PK_TIME             = $0004;  // time stamp
  PK_CHANGED          = $0008;  // change bit vector
  PK_SERIAL_NUMBER    = $0010;  // packet serial number
  PK_CURSOR           = $0020;  // reporting cursor
  PK_BUTTONS          = $0040;  // button information
  PK_X                = $0080;  // x axis
  PK_Y                = $0100;  // y axis
  PK_Z	              = $0200;  // z axis
  PK_NORMAL_PRESSURE  = $0400;  // normal or tip pressure
  PK_TANGENT_PRESSURE = $0800;  // tangential or barrel pressure
  PK_ORIENTATION      = $1000;  // orientation info: tilts
  PK_ROTATION	      = $2000;  // rotation info; 1.1

  TU_NONE = 0;
  TU_INCHES = 1;
  TU_CENTIMETERS = 2;
  TU_CIRCLE = 3;

  WTI_INTERFACE = 1;
     IFC_WINTABID    = 1;
     IFC_SPECVERSION = 2;
     IFC_IMPLVERSION = 3;
     IFC_NDEVICES    = 4;
     IFC_NCURSORS    = 5;
     IFC_NCONTEXTS   = 6;
     IFC_CTXOPTIONS  = 7;
     IFC_CTXSAVESIZE = 8;
     IFC_NEXTENSIONS = 9;
     IFC_NMANAGERS   = 10;
     IFC_MAX	     = 10;

  WTI_STATUS = 2;
     STA_CONTEXTS  = 1;
     STA_SYSCTXS   = 2;
     STA_PKTRATE   = 3;
     STA_PKTDATA   = 4;
     STA_MANAGERS  = 5;
     STA_SYSTEM    = 6;
     STA_BUTTONUSE = 7;
     STA_SYSBTNUSE = 8;
     STA_MAX	   = 8;

  WTI_DEFCONTEXT = 3;
  WTI_DEFSYSCTX  = 4;
  WTI_DDCTXS     = 400;  //1.1
  WTI_DSCTXS     = 500;  //1.1
     CTX_NAME      = 1;
     CTX_OPTIONS   = 2;
     CTX_STATUS    = 3;
     CTX_LOCKS     = 4;
     CTX_MSGBASE   = 5;
     CTX_DEVICE    = 6;
     CTX_PKTRATE   = 7;
     CTX_PKTDATA   = 8;
     CTX_PKTMODE   = 9;
     CTX_MOVEMASK  = 10;
     CTX_BTNDNMASK = 11;
     CTX_BTNUPMASK = 12;
     CTX_INORGX    = 13;
     CTX_INORGY    = 14;
     CTX_INORGZ    = 15;
     CTX_INEXTX    = 16;
     CTX_INEXTY    = 17;
     CTX_INEXTZ    = 18;
     CTX_OUTORGX   = 19;
     CTX_OUTORGY   = 20;
     CTX_OUTORGZ   = 21;
     CTX_OUTEXTX   = 22;
     CTX_OUTEXTY   = 23;
     CTX_OUTEXTZ   = 24;
     CTX_SENSX     = 25;
     CTX_SENSY     = 26;
     CTX_SENSZ     = 27;
     CTX_SYSMODE   = 28;
     CTX_SYSORGX   = 29;
     CTX_SYSORGY   = 30;
     CTX_SYSEXTX   = 31;
     CTX_SYSEXTY   = 32;
     CTX_SYSSENSX  = 33;
     CTX_SYSSENSY  = 34;
     CTX_MAX	   = 34;

  WTI_DEVICES = 100;
     DVC_NAME        = 1;
     DVC_HARDWARE    = 2;
        HWC_INTEGRATED     = $0001;
        HWC_TOUCH	   = $0002;
        HWC_HARDPROX       = $0004;
        HWC_PHYSID_CURSORS = $0008; //1.1
     DVC_NCSRTYPES   = 3;
     DVC_FIRSTCSR    = 4;
     DVC_PKTRATE     = 5;
     DVC_PKTDATA     = 6;
     DVC_PKTMODE     = 7;
     DVC_CSRDATA     = 8;
     DVC_XMARGIN     = 9;
     DVC_YMARGIN     = 10;
     DVC_ZMARGIN     = 11;
     DVC_X	     = 12;
     DVC_Y	     = 13;
     DVC_Z	     = 14;
     DVC_NPRESSURE   = 15;
     DVC_TPRESSURE   = 16;
     DVC_ORIENTATION = 17;
     DVC_ROTATION    = 18; //1.1
     DVC_PNPID       = 19; //1.1
     DVC_MAX	     = 19;

  WTI_CURSORS = 200;
     CSR_NAME	      = 1;
     CSR_ACTIVE	      = 2;
     CSR_PKTDATA      = 3;
     CSR_BUTTONS      = 4;
     CSR_BUTTONBITS   = 5;
     CSR_BTNNAMES     = 6;
     CSR_BUTTONMAP    = 7;
     CSR_SYSBTNMAP    = 8;
     CSR_NPBUTTON     = 9;
     CSR_NPBTNMARKS   = 10;
     CSR_NPRESPONSE   = 11;
     CSR_TPBUTTON     = 12;
     CSR_TPBTNMARKS   = 13;
     CSR_TPRESPONSE   = 14;
     CSR_PHYSID	      = 15; //1.1
     CSR_MODE	      = 16; //1.1
     CSR_MINPKTDATA   = 17; //1.1
     CSR_MINBUTTONS   = 18; //1.1
     CSR_CAPABILITIES = 19; //1.1
        CRC_MULTIMODE = $0001; //1.1
        CRC_AGGREGATE = $0002; //1.1
        CRC_INVERT    = $0004; //1.1
     CSR_MAX	      = 19;

  WTI_EXTENSIONS = 300;
     EXT_NAME       = 1;
     EXT_TAG	    = 2;
     EXT_MASK       = 3;
     EXT_SIZE       = 4;
     EXT_AXES       = 5;
     EXT_DEFAULT    = 6;
     EXT_DEFCONTEXT = 7;
     EXT_DEFSYSCTX  = 8;
     EXT_CURSORS    = 9;
     EXT_MAX	    = 109; //Allow 100 cursors
     
  SBN_NONE        = $00;
  SBN_LCLICK	  = $01;
  SBN_LDBLCLICK   = $02;
  SBN_LDRAG	  = $03;
  SBN_RCLICK	  = $04;
  SBN_RDBLCLICK   = $05;
  SBN_RDRAG	  = $06;
  SBN_MCLICK	  = $07;
  SBN_MDBLCLICK   = $08;
  SBN_MDRAG	  = $09;
  //for Pen Windows
  SBN_PTCLICK	  = $10;
  SBN_PTDBLCLICK  = $20;
  SBN_PTDRAG	  = $30;
  SBN_PNCLICK	  = $40;
  SBN_PNDBLCLICK  = $50;
  SBN_PNDRAG	  = $60;
  SBN_P1CLICK	  = $70;
  SBN_P1DBLCLICK  = $80;
  SBN_P1DRAG	  = $90;
  SBN_P2CLICK	  = $A0;
  SBN_P2DBLCLICK  = $B0;
  SBN_P2DRAG	  = $C0;
  SBN_P3CLICK	  = $D0;
  SBN_P3DBLCLICK  = $E0;
  SBN_P3DRAG	  = $F0;

//LogContext
  LCNAMELEN  = 40;
  LC_NAMELEN = 40;

type
  TLogContextA = record
    lcName: array[0..LCNAMELEN-1] of ansichar;
    lcOptions: DWORD;
    lcStatus: DWORD;
    lcLocks: DWORD;
    lcMsgBase: DWORD;
    lcDevice: DWORD;
    lcPktRate: DWORD;
    lcPktData: WTPKT;
    lcPktMode: WTPKT;
    lcMoveMask: WTPKT;
    lcBtnDnMask: DWORD;
    lcBtnUpMask: DWORD;
    lcInOrgX: LongInt;
    lcInOrgY: LongInt;
    lcInOrgZ: LongInt;
    lcInExtX: LongInt;
    lcInExtY: LongInt;
    lcInExtZ: LongInt;
    lcOutOrgX: LongInt;
    lcOutOrgY: LongInt;
    lcOutOrgZ: LongInt;
    lcOutExtX: LongInt;
    lcOutExtY: LongInt;
    lcOutExtZ: LongInt;
    lcSensX: FIX32;
    lcSensY: FIX32;
    lcSensZ: FIX32;
    lcSysMode: boolean;
    lcSysOrgX: integer;
    lcSysOrgY: integer;
    lcSysExtX: integer;
    lcSysExtY: integer;
    lcSysSensX: FIX32;
    lcSysSensY: FIX32;
  end;

  LPLOGCONTEXT = ^TLogContextA;
  LPWORD = ^Word;
  LPINT = ^Integer;

  XBTNMASK = record
    xBtnDnMask: array[1..31] of byte;
    xBtnUpMask: array[1..31] of byte;
  end;

const
//Context options values
  CXO_SYSTEM      = $0001;
  CXO_PEN         = $0002;
  CXO_MESSAGES    = $0004;
  CXO_MARGIN      = $8000;
  CXO_MGNINSIDE	  = $4000;
  CXO_CSRMESSAGES = $0008; //1.1

//Context status values
  CXS_DISABLED = $0001;
  CXS_OBSCURED = $0002;
  CXS_ONTOP    = $0004;

//Context lock values
  CXL_INSIZE	  = $0001;
  CXL_INASPECT	  = $0002;
  CXL_SENSITIVITY = $0004;
  CXL_MARGIN	  = $0008;
  CXL_SYSOUT	  = $0010;

//Buttons constants
  TBN_NONE = 0;
  TBN_UP   = 1;
  TBN_DOWN = 2;

//Packet status values
  TPS_PROXIMITY	= $0001;
  TPS_QUEUE_ERR	= $0002;
  TPS_MARGIN	= $0004;
  TPS_GRAB	= $0008;
  TPS_INVERT	= $0010; //1.1

//Device config constants
  WTDC_NONE    = 0;
  WTDC_CANCEL  = 1;
  WTDC_OK      = 2;
  WTDC_RESTART = 3;

//Hook constants
  WTH_PLAYBACK	  = 1;
  WTH_RECORD	  = 2;

  WTHC_GETLPLPFN  =-3;
  WTHC_LPLPFNNEXT =-2;
  WTHC_LPFNNEXT	  =-1;
  WTHC_ACTION	  = 0;
  WTHC_GETNEXT    = 1;
  WTHC_SKIP 	  = 2;

//Extension tags
  WTX_OBT      = 0;  //Out of bounds tracking
  WTX_FKEYS    = 1;  //Function keys
  WTX_TILT     = 2;  //Raw Cartesian tilt          1.1
  WTX_CSRMASK  = 3;  //Select input by cursor type 1.1
  WTX_XBTNMASK = 4;  //Extended button mask        1.1

//Local packet settings  
  localPktData = PK_STATUS or PK_CONTEXT or PK_CURSOR or PK_BUTTONS or PK_X or PK_Y
                 or PK_NORMAL_PRESSURE or PK_TANGENT_PRESSURE or PK_ORIENTATION
                 or PK_ROTATION;
  localCTXOption = CXO_SYSTEM or CXO_MESSAGES or CXO_CSRMESSAGES;
  localBtnAssign = SBN_LCLICK or SBN_LDBLCLICK or SBN_LDRAG or     //left button
                   SBN_RCLICK or SBN_RDBLCLICK or SBN_RDRAG or     //right button
                   SBN_MCLICK or SBN_MDBLCLICK or SBN_MDRAG or     //middle button
                   SBN_PTCLICK or SBN_PTDBLCLICK or SBN_PTDRAG or  //pen tip
                   SBN_PNCLICK or SBN_PNDBLCLICK or SBN_PNDRAG or  //inverted pen tip
                   SBN_P1CLICK or SBN_P1DBLCLICK or SBN_P1DRAG or  //barrel button 1
                   SBN_P2CLICK or SBN_P2DBLCLICK or SBN_P2DRAG or  //barrel button 2
                   SBN_P3CLICK or SBN_P3DBLCLICK or SBN_P3DRAG;    //barrel button 3


//main functions ---------------------------------------------------------------------
type
  TWTInfo = function(wCategory: DWord; nIndex: DWord; lpOutput: pointer): DWord; stdcall;
  TWTOpen = function(hWnd: HWND; lpLogCtx: LPLOGCONTEXT; fEnable: boolean): HCTX; stdcall;
  TWTClose = function(hCtx: HCTX): boolean; stdcall;
  TWTPacketsGet = function(hCtx: HCTX; cMaxPkts: integer; lpPkts: pointer): integer; stdcall;
  TWTPacket = function(hCtx: HCTX; wSerial: DWORD; lpPkt: pointer): boolean; stdcall;
  TWTEnable = function(hCtx: HCTX; fEnable: boolean): boolean; stdcall;
  TWTOverlap = function(hCtx: HCTX; fToTop: boolean): boolean; stdcall;
  TWTConfig = function(hCtx: HCTX; hWnd: HWND): boolean; stdcall;
  TWTGet = function(hCtx: HCTX; lpLogCtx: LPLOGCONTEXT): boolean; stdcall;
  TWTSet = function(hCtx: HCTX; lpLogCtx: LPLOGCONTEXT): boolean; stdcall;
  TWTExtGet = function(hCtx: HCTX; wExt: DWORD; lpData: pointer): boolean; stdcall;
  TWTExtSet = function(hCtx: HCTX; wExt: DWORD; lpData: pointer): boolean; stdcall;
  TWTSave = function(hCtx: HCTX; lpSaveInfo: pointer): boolean; stdcall;
  TWTRestore = function(hWnd: HWND; lpSaveInfo: pointer; fEnable: boolean): HCTX; stdcall;
  TWTPacketsPeek = function(hCtx: HCTX; cMaxPkts: integer; lpPkts:pointer): integer; stdcall;
  TWTDataGet = function(hCtx: HCTX; wBegin: DWORD; wEnd: DWORD; cMaxPkts: integer; lpPkts: pointer; lpNPkts: LPINT): integer; stdcall;
  TWTDataPeek = function(hCtx: HCTX; wBegin: DWORD; wEnd: DWORD; cMaxPkts: integer; lpPkts: pointer; lpNPkts: LPINT): integer; stdcall;
  TWTQueuePacketsEx = function(hCtx: HCTX; lpOld: LPWORD; lpNew: LPWORD): boolean; stdcall;
  TWTQueueSizeGet = function(hCtx: HCTX): integer; stdcall;
  TWTQueueSizeSet = function(hCtx: HCTX; nPkts: integer): boolean; stdcall;
  TWTMgrOpen = function(hWnd: HWND; wMsgBase: DWORD): HWND; stdcall;
  TWTMgrClose = function(hMgr: HWND): boolean; stdcall;
  TWTMgrContextEnum = function(hMgr: HWND; lpEnumFunc: pointer; lParam: LongInt): boolean; stdcall;
  TWTMgrContextOwner = function(hMgr: HMGR; hCtx: HCTX): HWND; stdcall;
  TWTMgrDefContext = function(hMgr: HMGR; fSystem: boolean): HCTX; stdcall;
  TWTMgrDefContextEx = function(hMgr: HMGR; wDevice: DWORD; fSystem: boolean): HCTX; stdcall;
  TWTMgrDeviceConfig = function(hMgr: HMGR; wDevice: DWORD; hWnd: HWND): DWORD; stdcall;
  TWTMgrConfigReplaceEx = function(hMgr: HMGR; fInstall: boolean; lpszModule: PAnsiChar; lpszCfgProc: PAnsiChar): boolean; stdcall;
  TWTMgrPacketHookEx = function(hMgr: HMGR; nType: integer; lpszModule: PAnsiChar; lpszHookProc: PAnsiChar): HWTHOOK; stdcall;
  TWTMgrPacketUnHook = function(hHook: HWTHOOK): boolean; stdcall;
  TWTMgrPacketHookNext = function(hHook: HWTHOOK; nCode: integer; wParam: DWORD; lParam: LongInt): DWORD; stdcall;
  TWTMgrExt = function(hMgr: HMGR; wExt: DWORD; lpData: pointer): boolean; stdcall;
  TWTMgrCsrEnable = function(hMgr: HMGR; wCursor: DWORD; fEnable: boolean): boolean; stdcall;
  TWTMgrCsrButtonMap = function(hMgr: HMGR; wCursor: DWORD; lpLogBtns:  pointer; lpSysBtns: pointer): boolean; stdcall;
  TWTMgrCsrPressureBtnMarksEx = function(hMgr: HMGR; wCsr: DWORD; lpNMarks: pointer; lpTMarks: pointer): boolean; stdcall;
  TWTMgrCsrPressureResponse = function(hMgr: HMGR; wCsr: DWORD; lpNResp: pointer; lpTResp: pointer): boolean; stdcall;
  TWTMgrCsrExt = function(hMgr: HMGR; wCsr: DWORD; wExt: DWORD; lpData: pointer): boolean; stdcall;

//variables WinTab
var WTInfo: TWTInfo;
    WTOpen: TWTOpen;
    WTClose: TWTClose;
    WTPacketsGet: TWTPacketsGet;
    WTPacket: TWTPacket;
    WTEnable: TWTEnable;
    WTOverlap: TWTOverlap;
    WTConfig: TWTConfig;
    WTGet: TWTGet;
    WTSet: TWTSet;
    WTExtGet: TWTExtGet;
    WTExtSet: TWTExtSet;
    WTSave: TWTSave;
    WTRestore: TWTRestore;
    WTPacketsPeek: TWTPacketsPeek;
    WTDataGet: TWTDataGet;
    WTDataPeek: TWTDataPeek;
    WTQueuePacketsEx: TWTQueuePacketsEx;
    WTQueueSizeGet: TWTQueueSizeGet;
    WTQueueSizeSet: TWTQueueSizeSet;
    WTMgrOpen: TWTMgrOpen;
    WTMgrClose: TWTMgrClose;
    WTMgrContextEnum: TWTMgrContextEnum;
    WTMgrContextOwner: TWTMgrContextOwner;
    WTMgrDefContext: TWTMgrDefContext;
    WTMgrDefContextEx: TWTMgrDefContextEx;
    WTMgrDeviceConfig: TWTMgrDeviceConfig;
    WTMgrConfigReplaceEx: TWTMgrConfigReplaceEx;
    WTMgrPacketHookEx: TWTMgrPacketHookEx;
    WTMgrPacketUnHook: TWTMgrPacketUnHook;
    WTMgrPacketHookNext: TWTMgrPacketHookNext;
    WTMgrExt: TWTMgrExt;
    WTMgrCsrEnable: TWTMgrCsrEnable;
    WTMgrCsrButtonMap: TWTMgrCsrButtonMap;
    WTMgrCsrPressureBtnMarksEx: TWTMgrCsrPressureBtnMarksEx;
    WTMgrCsrPressureResponse: TWTMgrCsrPressureResponse;
    WTMgrCsrExt: TWTMgrCsrExt;

implementation

end.
