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
unit NWSComps_ThumbsBrowser_Print;
{$R-}
{$Q-}
interface

{$I ..\_inc\NWSComps_ThumbsBrowser.inc}
{$I ..\_inc\NWSComps_Shared.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics,
  contnrs,  hyieutils, hyiedefs, {$IFDEF IMAGEEN_6_2_LATER}  iexBitmaps, {$ENDIF}
   imageenio, imageenproc,  ieWIA,
   NWSComps_ThumbsBrowser, NWSComps_ThumbsBrowser_Thumbs,
   NWSComps_ThumbsBrowser_Shell,
   NWSComps_ThumbsBrowser_Shell_Utils,
   NWSComps_ThumbsBrowser_const,
   NWSComps_ThumbsBrowser_Utils_Types;


type

 TThumbsPrintPage = class(Tcomponent)
  private
    FthList: TList;
    FCols: cardinal;
    FRows: cardinal;
    fPageAborted: boolean;
  protected
    procedure AbortPage;
  public
    OnPageProgress: TTB_Browser_ProgressEvent_Perc;
    property Cols: cardinal read fCols write fCols;
    property Rows: cardinal read fRows write fRows;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AddPrintThumb(thethumb: TThumbex);
    procedure GetBitmap(var bmp: Tbitmap; dpi: cardinal; w_inch, h_inch: double; options: TTB_Print_Options);
  end;


 TThumbsBrowserPrintProcessor = class(TComponent)
  private


    fAttachedShellProcessor: TThumbsBrowserShellProcessor;

    fPages: TObjectList;
    FColspp: cardinal;
    FRowspp: cardinal;

    fAborted: boolean;


    procedure SetAborted(value: boolean);
    procedure PRT_OP_GetFilenameList(var fl: Tstringlist; om: TTB_Shell_PickMode; condition: TTB_Browser_PickCondition);

    procedure DoPageProgress(sender: Tobject; per: integer; const Caption:string = '');
    procedure ReCalcPages(om: TTB_Shell_PickMode; condition: TTB_Browser_PickCondition);

  public

    MinExifYear: integer;
    Compare_Date: Tdatetime;
    Compare_DateRange_Start, Compare_DateRange_End: Tdatetime;
    OnProgress: TTB_Browser_ProgressEvent_Perc;
    NPages: integer;
    NThumbstoPrint: integer;
    PrintOptions: TTB_Print_Options;

    property Aborted: boolean read fAborted write SetAborted;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AbortProcess;
    procedure PreparePages(NRowspp, NColspp: cardinal; om: TTB_Shell_PickMode; condition: TTB_Browser_PickCondition);

    procedure DoPreviews(dpi: cardinal; pgwidth_inch, pgheight_inch: double);

    procedure GetPageBMP(pgidx: integer; destbmp: Tbitmap; pgwidth_pix, pgheight_pix: integer); overload;
    procedure GetPageBMP(pgidx: integer; destbmp: Tbitmap; dpi: cardinal; pgwidth_inch, pgheight_inch: double); overload;
    procedure DrawPage(pgidx: integer; destcanvas: Tcanvas; dpi: cardinal; pgwidth_inch, pgheight_inch: double);
    procedure PrintPage(pgidx: integer; pgwidth_inch, pgheight_inch: double);
    procedure PrintAllPages(pgwidth_inch, pgheight_inch: double);
    procedure SavePageBMPtoFile(pgidx: integer; filename: string; dpi: cardinal; pgwidth_inch, pgheight_inch: double);

   published

   property AttachedShellProcessor: TThumbsBrowserShellProcessor read fAttachedShellProcessor write fAttachedShellProcessor;
  end;


implementation

  uses math, printers, NWSComps_ThumbsBrowser_utils;



procedure TBPrintBitmap(Canvas: TCanvas; DestRect: TRect; Bitmap: TBitmap);
var
  BitmapHeader: pBitmapInfo;
  BitmapImage: POINTER;
  HeaderSize: DWORD; // Use DWORD for D3-D5 compatibility
  ImageSize: DWORD;
begin
  GetDIBSizes(Bitmap.Handle, HeaderSize, ImageSize);
  GetMem(BitmapHeader, HeaderSize);
  GetMem(BitmapImage, ImageSize);
  try
    GetDIB(Bitmap.Handle, Bitmap.Palette, BitmapHeader^, BitmapImage^);
    StretchDIBits(Canvas.Handle,
      DestRect.Left, DestRect.Top, // Destination Origin
      DestRect.Right - DestRect.Left, // Destination Width
      DestRect.Bottom - DestRect.Top, // Destination Height
      0, 0, // Source Origin
      Bitmap.Width, Bitmap.Height, // Source Width & Height
      BitmapImage,
      TBitmapInfo(BitmapHeader^),
      DIB_RGB_COLORS,
      SRCCOPY)
  finally
    FreeMem(BitmapHeader);
    FreeMem(BitmapImage)
  end
end;

procedure TBGetSetPrinterInfos(pgwidth_inch, pgheight_inch: double);
var
  PhysPageSize: TPoint;
  OffsetStart: TPoint;
  PageRes: TPoint;
  Margins: TTB_Print_Margins;
begin
  try
    Escape(Printer.Handle, GETPHYSPAGESIZE, 0, nil, @PhysPageSize);
    Escape(Printer.Handle, GETPRINTINGOFFSET, 0, nil, @OffsetStart);
    PageRes.y := GetDeviceCaps(Printer.Handle, VERTRES);
    PageRes.x := GetDeviceCaps(Printer.Handle, HORZRES);
  // Top Margin
    Margins.Top := OffsetStart.y;
  // Left Margin
    Margins.Left := OffsetStart.x;
  // Bottom Margin
    Margins.Bottom := PhysPageSize.y - OffsetStart.y; // - PageRes.y;
  // Right Margin
    Margins.Right := PhysPageSize.x - OffsetStart.x; // - PageRes.x;

    if pgwidth_inch <= pgheight_inch then
      printer.orientation := poportrait
    else
      printer.Orientation := polandscape;


  except

  end;
end;

function TBGetPrintRect(pgwidth_inch, pgheight_inch: double): TRect;
var
  w_bmp, h_bmp: integer;
  printxpixperinch:integer;
  printypixperinch:integer;
begin
  printxpixperinch := getdevicecaps(printer.handle, logpixelsx);
  printypixperinch := getdevicecaps(printer.handle, logpixelsy);
  w_bmp := round(pgwidth_inch * printxpixperinch);
  h_bmp := round(pgheight_inch * printypixperinch);
  with result do
  begin
   { left := (printwidth - w_bmp) div 2;
    top := (printheight - h_bmp) div 2;
    }
    left := (printer.pagewidth - w_bmp) div 2;
    top := (printer.pageheight - h_bmp) div 2;
    right := left + w_bmp;
    bottom := top + h_bmp;
  end;

end;






  //Class TThumbsPrintPage

constructor TThumbsPrintPage.Create(AOwner: TComponent);
begin
  inherited;
  FthList := TList.create;

  fPageAborted := false;
  FRows := 1;
  FCols := 1;
end;


destructor TThumbsPrintPage.Destroy;
begin
  FthList.free;
  inherited;
end;


procedure TThumbsPrintPage.AddPrintThumb(thethumb: TThumbex);
begin
  FthList.Add(thethumb);
end;

procedure TThumbsPrintPage.AbortPage;
begin
  fPageAborted := true;
end;

procedure TThumbsPrintPage.GetBitmap(var bmp: Tbitmap; dpi: cardinal; w_inch, h_inch: double; options: TTB_Print_Options);
var
  w_pix, h_pix, max_thsize, picsize, picthsize, thsize, thdpi: integer;
  i: integer;
  leftmargin, topmargin, spacingw, spacingh: integer;
  p: Tpoint;
  athumb: TThumbex;
  athumbbmp: tiebitmap;
  shbmp: Tbitmap;
  proc: Timageenproc;
  thratio: double;
  CaptionHeight, Captionwidth: integer;
  fixedTextHeight: integer;
  tempy, tempw, temph: integer;
  DestBitmapScanline: ppointerarray;
  XLUT, YLUT: pinteger;

begin
  if FthList.Count = 0 then exit;

  fPageAborted := false;
   //Create a blank bitmap with size which matches the required dpi and inches
  w_pix := round(w_inch * dpi);
  h_pix := round(h_inch * dpi);
  bmp.PixelFormat := pf24bit;
  bmp.width := w_pix;
  bmp.height := h_pix;
  bmp.Canvas.Brush.color := clwhite;
  bmp.Canvas.fillrect(Rect(0, 0, bmp.width, bmp.height));
   //  Fix margins

  with bmp.canvas.Font do
  begin
    Size := max(8, round(8 * bmp.height / 2000));
    Name := 'Arial';
    Style := style + [fsbold];
  end;

  fixedTextHeight := bmp.canvas.TextHeight('I');
  CaptionHeight := 0;
  CaptionHeight := CaptionHeight + ord(options.ShowName) * fixedTextHeight;
  CaptionHeight := CaptionHeight + ord(options.ShowDate) * fixedTextHeight;
  CaptionHeight := CaptionHeight + ord(options.ShowSize) * fixedTextHeight;


  leftmargin := round(0.03 * w_pix);
  topmargin := round(0.03 * h_pix);
  spacingw := round(0.03 * w_pix);
  spacingh := round(0.03 * h_pix) + CaptionHeight;
   // Fix max possible size for thumbnails on the paper (according to n° of rows and columns)
  max_thsize := min(trunc((h_pix - 2 * topmargin) / FRows) - spacingh, trunc((w_pix - 2 * leftmargin) / FCols) - spacingw);

  leftmargin := leftmargin + (w_pix - fCols * (max_thsize + spacingw)) div 2 - spacingw;
  topmargin := topmargin + (h_pix - frows * (max_thsize + spacingh)) div 2 - spacingh;


  picthsize := TThumbex(FthList[0]).SizeOffScreen;

  p.x := leftmargin;
  p.y := topmargin;
  proc := timageenproc.create(nil);
  try
    for i := 0 to FthList.count - 1 do
    begin
      if fPageAborted then
      begin
        if assigned(onpageprogress) then onpageprogress(self, 100);
        break;
      end;
      athumb := TThumbex(fthlist[i]);
      thdpi := max(92, athumb.SourceFileRes);
      if dpi = 0 then
        picsize := round(max(athumb.SourceFileWidth, athumb.SourceFileHeight) / thdpi * 200)
      else
        picsize := round(max(athumb.SourceFileWidth, athumb.SourceFileHeight) / thdpi * dpi);

      thsize := min(picsize, max_thsize);


      athumbbmp := tiebitmap.create;
      try
        if (thsize <= picthsize) and athumb.HasConsistentOrientation then //the thumb is smaller so we take it from the browser
          athumbbmp.Assign(athumb.IEBitmap)
        else //the thumb is bigger so we have to take it from file
          TBLoadFromFile(athumbbmp, athumb.sourcefilename, true);

        proc.AttachedIEBitmap := athumbbmp;
        if (athumbbmp.width <> 0) and (athumbbmp.height <> 0) then
        begin
          //TODO here also have to calculate space for pic's description (name, date, exif etc..)
          thratio := athumbbmp.Width / athumbbmp.height;
          if thratio > 1 then
            proc.Resample(thsize, round(1 / thratio * thsize), rflanczos3)
          else
            proc.resample(round(thratio * thsize), thsize, rflanczos3);
        end;

        if options.HasDropShadows then
        begin

          tempw := athumbbmp.Width;
          temph := athumbbmp.Height;
          if (tempw <> 0) and (temph <> 0) then
          begin

            proc.AddSoftShadow(round(0.03 * max_thsize), round(0.03 * max_thsize), round(0.03 * max_thsize), true);
            shbmp := tbitmap.create;
            try
              shbmp.PixelFormat := pf24bit;
              shbmp.width := tempw;
              shbmp.height := temph;
              DestBitmapScanline := nil;
              XLUT := nil;
              YLUT := nil;
              athumbbmp.RenderToTBitmap(shbmp,{$IFNDEF IMAGEEN_6_3_0_LATER} DestBitmapScanline,{$ENDIF} Xlut, YLut, nil,
                0, 0, tempw, temph, 0, 0, athumbbmp.width, athumbbmp.Height, true, true, 255,
                rfbilinear, true, ielnormal);
              athumbbmp.CopyFromTBitmap(shbmp);
            finally
              shbmp.free;
            end;
          end;
        (*  *)
        end;

        athumbbmp.DrawToCanvas(bmp.canvas, p.x + (max_thsize - athumbbmp.width) div 2, p.y + (max_thsize - athumbbmp.Height) div 2); // draw the thumb in position
        //TODO here write also pic's description (name, date, exif etc..)
        tempy := p.y;
        CaptionWidth := bmp.Canvas.TextWidth(athumb.SourceFileNameShort);
        if options.ShowName then
        begin
          bmp.canvas.Textout(p.x + (max_thsize - captionwidth) div 2, tempy + max_thsize, athumb.SourceFileNameShort);
          tempy := tempy + fixedTextHeight;
        end;

        CaptionWidth := bmp.Canvas.TextWidth(datetimetostr(athumb.SourceFileDate));
        if options.ShowDate then
        begin
          bmp.canvas.Textout(p.x + (max_thsize - captionwidth) div 2, tempy + max_thsize, datetimetostr(athumb.SourceFileDate));
          tempy := tempy + fixedTextHeight;
        end;

        CaptionWidth := bmp.Canvas.TextWidth(inttostr(athumb.SourceFileSize) + ' bytes');
        if options.ShowSize then
        begin
          bmp.canvas.Textout(p.x + (max_thsize - captionwidth) div 2, tempy + max_thsize, inttostr(athumb.SourceFileSize) + ' bytes');
          tempy := tempy + fixedTextHeight;
        end;

      finally
        athumbbmp.free;
      end;



      if assigned(onpageprogress) then onpageprogress(self, TBGetPercent(i + 1, 1, FthList.count));
      p.x := p.x + max_thsize + spacingw; //inc column
      if (i + 1) mod fcols = 0 then // inc row and reset column
      begin
        p.x := leftmargin;
        p.y := p.y + max_thsize + spacingh;
      end;
    end;

  finally
    proc.free;
  end;
end;









//Class TThumbsBrowserPrintProcessor

constructor TThumbsBrowserPrintProcessor.Create(AOwner: TComponent);
begin
  inherited;
 

  fPages := TObjectlist.create;

  fAborted := true;
  NPages := 0;
  NThumbstoPrint := 0;
  FColspp := 1;
  FRowspp := 1;
  Compare_Date := now;
  Compare_DateRange_Start := now;
  Compare_DateRange_End := now;
  MinExifYear := 1970;
  with PrintOptions do
  begin
    ShowName := false;
    ShowDate := false;
    ShowSize := false;
    HasDropShadows := false;
  end;
end;

destructor TThumbsBrowserPrintProcessor.Destroy;
begin
  fPages.Clear;
  fPages.free;

  inherited;
end;


procedure TThumbsBrowserPrintProcessor.SetAborted(value: boolean);
var
  i: integer;
begin
  faborted := value;
  if faborted = false then exit;

  for i := 0 to fPages.count - 1 do
    TThumbsPrintPage(fpages[i]).AbortPage;

  //showmessage('aborted');
end;

procedure TThumbsBrowserPrintProcessor.AbortProcess;
begin
  Aborted := true;
end;


procedure TThumbsBrowserPrintProcessor.PRT_OP_GetFilenameList(var fl: Tstringlist; om: TTB_Shell_PickMode; condition: TTB_Browser_PickCondition);
var
  remCompare_Date, remCompare_DateRange_Start, remCompare_DateRange_End: TDatetime;
  remMinExifYear: integer;
begin
  if not assigned(fattachedShellProcessor) then EXIT; ////EXIT


    remMinExifYear := fattachedShellProcessor.MinExifYear;
    remCompare_Date := fattachedShellProcessor.Compare_Date;
    remCompare_DateRange_Start := fattachedShellProcessor.Compare_DateRange_Start;
    remCompare_DateRange_End := fattachedShellProcessor.Compare_DateRange_End;

  try
    fattachedShellProcessor.MinExifYear := MinExifYear;
    fattachedShellProcessor.Compare_Date := Compare_Date;
    fattachedShellProcessor.Compare_DateRange_Start := Compare_DateRange_Start;
    fattachedShellProcessor.Compare_DateRange_End := Compare_DateRange_End;

    fattachedShellProcessor.SH_OP_GetFilenameList(fl, om, condition); //Call ShellProcessor's SH_OP_GetFilenameList

  finally
    fattachedShellProcessor.MinExifYear := remMinExifYear;
    fattachedShellProcessor.Compare_Date := remCompare_Date;
    fattachedShellProcessor.Compare_DateRange_Start := remCompare_DateRange_Start;
    fattachedShellProcessor.Compare_DateRange_End := remCompare_DateRange_End;
  end;
end;


procedure TThumbsBrowserPrintProcessor.ReCalcPages(om: TTB_Shell_PickMode; condition: TTB_Browser_PickCondition);
var
  fl: Tstringlist;
  thspp: cardinal;
  np: cardinal;
  i, pos, k: integer;
  apage: TThumbsPrintPage;
begin
  if not assigned(fAttachedShellProcessor) then exit;
  if not assigned(fAttachedShellProcessor.AttachedBrowser) then exit;

  fl := TStringlist.create;
  try
    PRT_OP_GetFilenameList(fl, om, condition);
    NThumbstoPrint := fl.count;
    thspp := Fcolspp * Frowspp;
    np := max(1, round(fl.count / thspp));
    NPages := np;
    fPages.Clear;
    pos := 0;
    for i := 0 to np - 1 do //loop through pages
    begin
      apage := TThumbsPrintPage.Create(nil);
      apage.Rows := Frowspp;
      apage.Cols := FColspp;
      apage.OnPageProgress := DoPageProgress;
      for k := 0 to thspp - 1 do // loop through thumbs in each page
      begin
        if pos > fl.count - 1 then break;

        apage.AddPrintThumb(fAttachedShellProcessor.AttachedBrowser.Thumbat(fl[pos]));
        inc(pos);
      end;

      fpages.Add(apage);
    end;
  finally
    fl.free;
  end;
end;


procedure TThumbsBrowserPrintProcessor.DoPageProgress(sender: Tobject; per: integer; const Caption:string = '');
begin
  if assigned(onprogress) then Onprogress(sender, per, Caption);
end;

procedure TThumbsBrowserPrintProcessor.PreparePages(NRowspp, NColspp: cardinal; om: TTB_Shell_PickMode; condition: TTB_Browser_PickCondition);
begin
  FRowspp := max(1, NRowspp);
  fColspp := max(1, NColspp);
  recalcpages(om, condition);
end;

procedure TThumbsBrowserPrintProcessor.DoPreviews(dpi: cardinal; pgwidth_inch, pgheight_inch: double);
begin

end;

procedure TThumbsBrowserPrintProcessor.GetPageBMP(pgidx: integer; destbmp: Tbitmap; pgwidth_pix, pgheight_pix: integer);
var
  apage: TThumbsPrintPage;
  dpi: integer;
  pgwidth_inch, pgheight_inch: double;
begin
  if (pgidx < 0) or (pgidx > fpages.Count - 1) then exit;

  dpi := 90;
  pgwidth_inch := pgwidth_pix / dpi;
  pgheight_inch := pgheight_pix / dpi;


  apage := TThumbsPrintPage(fpages[pgidx]);
  apage.GetBitmap(destbmp, dpi, pgwidth_inch, pgheight_inch, PrintOptions);
end;


procedure TThumbsBrowserPrintProcessor.GetPageBMP(pgidx: integer; destbmp: Tbitmap; dpi: cardinal; pgwidth_inch, pgheight_inch: double);
var
  apage: TThumbsPrintPage;
begin
  if (pgidx < 0) or (pgidx > fpages.Count - 1) then exit;

  apage := TThumbsPrintPage(fpages[pgidx]);
  apage.GetBitmap(destbmp, dpi, pgwidth_inch, pgheight_inch, PrintOptions);
end;


procedure TThumbsBrowserPrintProcessor.DrawPage(pgidx: integer; destcanvas: Tcanvas; dpi: cardinal; pgwidth_inch, pgheight_inch: double);
var
  abmp: Tbitmap;
begin
  if (pgidx < 0) or (pgidx > fpages.Count - 1) then exit;

  abmp := tbitmap.create;
  try
    GetPageBmp(pgidx, abmp, dpi, pgwidth_inch, pgheight_inch);
    destcanvas.draw(0, 0, abmp);
  finally
    abmp.free;
  end;
end;


procedure TThumbsBrowserPrintProcessor.PrintPage(pgidx: integer; pgwidth_inch, pgheight_inch: double);
var
  abmp: Tbitmap;
begin
  if (pgidx < 0) or (pgidx > fpages.Count - 1) then exit;

  TBGetSetPrinterInfos(pgwidth_inch, pgheight_inch);

  abmp := tbitmap.create;
  try
    printer.BeginDoc;
    GetPageBMP(pgidx, abmp, 200, pgwidth_inch, pgheight_inch);
    TBprintbitmap(printer.canvas, TBGetPrintRect(pgwidth_inch, pgheight_inch), abmp);
  finally
    printer.enddoc;
    abmp.free;
  end;
end;


procedure TThumbsBrowserPrintProcessor.PrintAllPages(pgwidth_inch, pgheight_inch: double);
var
  i: integer;
  abmp: Tbitmap;
  arect: trect;
begin
  fAborted := false;
  TBGetSetPrinterInfos(pgwidth_inch, pgheight_inch);

  try
    printer.BeginDoc;
    for i := 0 to fPages.Count - 1 do
    begin
      if faborted then break;
      abmp := tbitmap.create;
      try
        GetPageBMP(i, abmp, 200, pgwidth_inch, pgheight_inch);
        abmp.PixelFormat := pf24bit;
        arect := TBGetPrintRect(pgwidth_inch, pgheight_inch);

        TBprintbitmap(printer.canvas, arect, abmp);

        if i < fPages.Count - 1 then
          printer.NewPage;
      finally
        abmp.free;
      end;
    end;
  finally
    faborted := true;
    printer.enddoc;

  end;
end;

procedure TThumbsBrowserPrintProcessor.SavePageBMPtoFile(pgidx: integer; filename: string; dpi: cardinal; pgwidth_inch, pgheight_inch: double);
var
  abmp: tbitmap;
  io: Timageenio;
begin
  abmp := tbitmap.create;
  io := timageenio.create(nil);
  try
    GetPageBmp(pgidx, abmp, dpi, pgwidth_inch, pgheight_inch);
    io.AttachedBitmap := abmp;
    io.Params.Dpi := dpi;
    io.Params.Dpix := dpi;
    io.Params.Dpiy := dpi;
    TBSavetoFile(io, filename);
  finally
    io.free;
    abmp.free;
  end;
end;

end.
