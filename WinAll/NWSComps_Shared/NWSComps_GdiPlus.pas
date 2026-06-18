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
unit NWSComps_GdiPlus;
{$R-}
{$Q-}

interface
{$I ..\_inc\NWSComps_Shared.inc}
uses Windows, Classes, sysutils, Graphics, hyiedefs, hyieutils, iegdiplus;


 // values of TIEMetafileHeader.Type_
  const GDIPlusMetafileTypeInvalid = 0;
  const GDIPlusMetafileTypeWmf = 1;
  const GDIPlusMetafileTypeWmfPlaceable = 2;
  const GDIPlusMetafileTypeEmf = 3;
  const GDIPlusMetafileTypeEmfPlusOnly = 4;
  const GDIPlusMetafileTypeEmfPlusDual = 5;

type
  TGDIPlus2DPointArray = TIE2DPointArray;

  TGDIPlusSmoothingMode = (smFast = ord(iesmBestPerformance), smBestQty = ord(iesmBestRenderingQuality),
                           smNone = ord(iesmNone), smAntialias = ord(iesmAntialias));

  TGDIPlusPenLineJoin = TIECanvasPenLineJoin;

 // TGDIPlusCompositingQuality = TIECanvasCompositingQuality;

  //TGDIPlusCompositingMode = TIECanvasCompositingMode;



//  TGDIPlusMetafileHeader = TIEMetafileHeader;

 // TGDIPlusMetafile =  TIEMetafile;


  // GDI+ Pen wrapper and VCL TPen wrapper
  TGDIPlusPen = class(TIEPen)
    private
      property LineJoin;

      function GetAlpha: integer;
      procedure SetAlpha(const Value: integer);
      function getLine_Join: TGDIPlusPenLineJoin;
      procedure setLine_Join(const Value: TGDIPlusPenLineJoin);


    public
      property Alpha: integer read GetAlpha write SetAlpha;
      property Line_Join: TGDIPlusPenLineJoin read getLine_Join write setLine_Join;
  end;

  // GDI+ Brush wrapper and VCL TBrush wrapper
  TGDIPlusBrush = class(TIEBrush)
    private
    function GetAlpha: integer;
    function GetBackAlpha: integer;
    procedure SetAlpha(const Value: integer);
    procedure SetBackAlpha(const Value: integer);

    protected


    public
      property Alpha: integer read GetAlpha write SetAlpha;
      property BackAlpha: integer read GetBackAlpha write SetBackAlpha;

  end;


  TGDIPlusCanvas = class(TIECanvas)
    private
    function GetGDPBrush: TGDIPlusBrush;
    function GetGDPPen: TGDIPlusPen;
    function GetGDPSmoothingMode: TGDIPlusSmoothingMode;
    procedure SetGDPSmoothingMode(const Value: TGDIPlusSmoothingMode);

      property SmoothingMode;
      property Pen;
      property Brush;

    public
      property GDPSmoothingMode: TGDIPlusSmoothingMode read GetGDPSmoothingMode write SetGDPSmoothingMode;
      property GDPPen: TGDIPlusPen read GetGDPPen;
      property GDPBrush: TGDIPlusBrush read GetGDPBrush;

      procedure DrawLinesPath(points: TGDIPlus2DPointArray); reintroduce;

      //procedure SetCompositingMode(Mode: TGDIPlusCompositingMode; Quality: TGDIPlusCompositingQuality);
    //  procedure Draw(Metafile: TGDIPlusMetaFile; x: double; y: double; width: single; height: single);
  end;




{$IFNDEF IMAGEEN_8_1_0_LATER}
function GDIPLUS_Enabled: boolean;
function GDIPLUS_Available: boolean;
procedure GDIPLUS_LoadLibrary;
procedure GDIPLUS_UnLoadLibrary;
{$ENDIF}

//procedure GDIPLUS_Initialize;
//procedure GDIPLUS_Finalize;

implementation

{$IFNDEF IMAGEEN_8_1_0_LATER}
function GDIPLUS_Enabled: boolean;
begin
  result := IEGDIPEnabled;
end;

function GDIPLUS_Available: boolean;
begin
  result := IEGDIPAvailable;
end;

procedure GDIPLUS_LoadLibrary;
begin
   IEGDIPLoadLibrary;
end;

procedure GDIPLUS_UnLoadLibrary;
begin
   IEGDIPUnLoadLibrary;
end;
{$ENDIF}



{ TGDIPlusPen }

function TGDIPlusPen.GetAlpha: integer;
begin
  result :=  self.Transparency;
end;



function TGDIPlusPen.getLine_Join: TGDIPlusPenLineJoin;
begin
  result := self.LineJoin;
end;

procedure TGDIPlusPen.SetAlpha(const Value: integer);
begin
  self.Transparency := value;
end;



procedure TGDIPlusPen.setLine_Join(const Value: TGDIPlusPenLineJoin);
begin
  self.LineJoin := value;
end;

{ TGDIPlusCanvas }

procedure TGDIPlusCanvas.DrawLinesPath(points: TGDIPlus2DPointArray);
begin
  inherited DrawLinesPath(points);
end;



function TGDIPlusCanvas.GetGDPBrush: TGDIPlusBrush;
begin
  result := TGDIPlusBrush(self.Brush);
end;

function TGDIPlusCanvas.GetGDPPen: TGDIPlusPen;
begin
  result := TGDIPlusPen(self.pen);
end;

function TGDIPlusCanvas.GetGDPSmoothingMode: TGDIPlusSmoothingMode;
begin
  case self.SmoothingMode of

    iesmNone: result := smNone;
    iesmBestPerformance: result := smFast;
    iesmBestRenderingQuality: result := smBestQty;
    iesmAntialias: result := smAntialias;
    else
    result := smFast;
  end;
end;



procedure TGDIPlusCanvas.SetGDPSmoothingMode(
  const Value: TGDIPlusSmoothingMode);
begin
  case value of
    smFast: self.SmoothingMode := iesmBestPerformance;
    smBestQty: self.SmoothingMode := iesmBestRenderingQuality;
    smNone: self.SmoothingMode := iesmNone;
    smAntialias: self.SmoothingMode := iesmAntialias;
  end;

end;

{ TGDIPlusBrush }

function TGDIPlusBrush.GetAlpha: integer;
begin
  result := self.Transparency;
end;

function TGDIPlusBrush.GetBackAlpha: integer;
begin
  result := self.BackTransparency;
end;

procedure TGDIPlusBrush.SetAlpha(const Value: integer);
begin
  self.Transparency := value;
end;

procedure TGDIPlusBrush.SetBackAlpha(const Value: integer);
begin
  self.BackTransparency := value;
end;

initialization

//GDIPLUS_Initialize;

finalization

//GDIPLUS_Finalize;

end.
