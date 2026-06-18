unit NWSComps_Proc_Gblur;

interface

uses Windows, Graphics, BEScanlines;


procedure GaussianBlur(Bitmap: TBitmap; radius: double);


implementation

uses Classes, SysUtils;

type



  PRGBRow = ^TRGBRow;
  TRGBRow = array[0..1000000] of TRGBTriple;

  PRGB = ^TRGBTriple;

procedure _IEBlurRow24Bit(const Kernel: TIEGaussKernel; SourcePtr, DestPtr: PRGBROW; RowLen: Integer);
var
  RowIndex, LoopIndex, KernelIndex, StopIndex: Integer;
  Src, Dst: PRGB;
  MaxLen: Integer;
  RR, GG, BB: Integer;
  W: Integer;
begin
  MaxLen := RowLen - 1;
  Dst := @DestPtr^[0];
  for RowIndex := 0 to MaxLen do begin
    KernelIndex := -Kernel.Size;
    LoopIndex := RowIndex - Kernel.Size;
    StopIndex := RowIndex + Kernel.Size;
    if StopIndex > MaxLen then
      StopIndex := MaxLen;
      // start values
    RR := IEKernelMultiplierd2;
    GG := IEKernelMultiplierd2;
    BB := IEKernelMultiplierd2;
      // left part
    W := 0;
    while LoopIndex < 0 do begin
      inc(W, Kernel.IntWeights[KernelIndex]);
      inc(KernelIndex);
      inc(LoopIndex);
    end;
    with PRGB(SourcePtr)^ do begin
      inc(RR, W * rgbtred);
      inc(GG, W * rgbtgreen);
      inc(BB, W * rgbtblue);
    end;
    Src := @SourcePtr^[LoopIndex];
      // center part
    while LoopIndex <= StopIndex do begin
      W := Kernel.IntWeights[KernelIndex];
      with Src^ do begin
        inc(RR, W * rgbtred);
        inc(GG, W * rgbtgreen);
        inc(BB, W * rgbtblue);
      end;
      inc(KernelIndex);
      inc(LoopIndex);
      inc(Src);
    end;
    W := 0;
    while KernelIndex <= Kernel.Size do begin
      inc(W, Kernel.IntWeights[KernelIndex]);
      inc(KernelIndex);
    end;
    with SourcePtr^[MaxLen] do begin
      inc(RR, W * rgbtred);
      inc(GG, W * rgbtgreen);
      inc(BB, W * rgbtblue);
    end;
      // set pixel
    with Dst^ do begin
      rgbtred := RR shr IEKernelScale;
      rgbtgreen := GG shr IEKernelScale;
      rgbtblue := BB shr IEKernelScale;
    end;
    inc(Dst);
  end;
end;

procedure _IEBlurRow8Bit(const Kernel: TIEGaussKernel; SourcePtr, DestPtr: pbytearray; RowLen: Integer);
var
  RowIndex, LoopIndex, KernelIndex, StopIndex: Integer;
  Src, Dst: pbyte;
  MaxLen: Integer;
  GR: Integer;
  W: Integer;
begin
  MaxLen := RowLen - 1;
  Dst := @DestPtr^[0];
  for RowIndex := 0 to MaxLen do begin
    KernelIndex := -Kernel.Size;
    LoopIndex := RowIndex - Kernel.Size;
    StopIndex := RowIndex + Kernel.Size;
    if StopIndex > MaxLen then
      StopIndex := MaxLen;
      // start values
    GR := IEKernelMultiplierd2;
      // left part
    W := 0;
    while LoopIndex < 0 do begin
      inc(W, Kernel.IntWeights[KernelIndex]);
      inc(KernelIndex);
      inc(LoopIndex);
    end;
    inc(GR, W * SourcePtr[0]);
    Src := @SourcePtr^[LoopIndex];
      // center part
    while LoopIndex <= StopIndex do begin
      W := Kernel.IntWeights[KernelIndex];
      inc(GR, W * Src^);
      inc(KernelIndex);
      inc(LoopIndex);
      inc(Src);
    end;
    W := 0;
    while KernelIndex <= Kernel.Size do begin
      inc(W, Kernel.IntWeights[KernelIndex]);
      inc(KernelIndex);
    end;
    inc(GR, W * SourcePtr^[MaxLen]);
      // set pixel
    Dst^ := GR shr IEKernelScale;
    inc(Dst);
  end;
end;


procedure GaussianBlur(Bitmap: TBitmap; radius: double);
var
  X, Y: Integer;
  RowPtr, ColPtr: PRGBROW;
  RowPtr8, ColPtr8: pbytearray;
  Kernel: TIEGaussKernel;
  per: double;

  ScanBMP: TbeScanlines;

begin

  ScanBMP :=  TbeScanlines.create;
  
  try


  if Radius > 0 then begin
      // calculate kernel
    per := 100 / (Bitmap.Height + Bitmap.Width);
    _IEMakeGaussKernel(Kernel, Radius);
    case Bitmap.PixelFormat of
      pf24bit:
        begin
          ScanBMP.CreateScanlines_RGB(bitmap);
          if Bitmap.Width > Bitmap.Height then
            GetMem(RowPtr, Bitmap.Width * SizeOf(TRGBTriple))
          else
            GetMem(RowPtr, Bitmap.Height * SizeOf(TRGBTriple));
               // blur rows
          for Y := 0 to Bitmap.Height - 1 do begin
             { _IEBlurRow24Bit(Kernel, Bitmap.ScanLine[y], RowPtr, Bitmap.Width);
            copymemory(Bitmap.ScanLine[Y], RowPtr, Bitmap.Width * SizeOf(TRGBTriple));    }

             _IEBlurRow24Bit(Kernel, PRGBRow(ScanBMP.Scanlines_RGB[y]), RowPtr, Bitmap.Width);
            copymemory(PRGBRow(ScanBMP.Scanlines_RGB[Y]), RowPtr, Bitmap.Width * SizeOf(TRGBTriple));    
          end;

         
               // blur columns
          GetMem(ColPtr, Bitmap.Height * SizeOf(TRGBTriple));
          for X := 0 to Bitmap.Width - 1 do begin
            for Y := 0 to Bitmap.Height - 1 do
            begin
             // RowPtr[Y] := PRGBROW(Bitmap.Scanline[y])[x];
              RowPtr[Y] := PRGBROW(ScanBMP.Scanlines_RGB[y])[x];
            end;
            _IEBlurRow24Bit(Kernel, RowPtr, ColPtr, Bitmap.Height);

            for Y := 0 to Bitmap.Height - 1 do
            begin
             // PRGBROW(Bitmap.Scanline[y])[x] := ColPtr[Y];
              PRGBROW(ScanBMP.Scanlines_RGB[y])[x] := ColPtr[Y];
            end;
          end;
          FreeMem(ColPtr);
          FreeMem(RowPtr);
        end;
      pf8bit:
        begin
          ScanBMP.CreateScanlines(bitmap);
          if Bitmap.Width > Bitmap.Height then
            GetMem(RowPtr8, Bitmap.Width)
          else
            GetMem(RowPtr8, Bitmap.Height);
               // blur rows
          for Y := 0 to Bitmap.Height - 1 do begin
            _IEBlurRow8Bit(Kernel, pbytearray(ScanBMP.Scanlines[y]), RowPtr8, Bitmap.Width);
            copymemory(pbytearray(ScanBMP.Scanlines[y]), RowPtr8, Bitmap.Width);
          {
            _IEBlurRow8Bit(Kernel, Bitmap.ScanLine[y], RowPtr8, Bitmap.Width);
            copymemory(Bitmap.ScanLine[Y], RowPtr8, Bitmap.Width);
            }
          end;
               // blur columns
          GetMem(ColPtr8, Bitmap.Height);
          for X := 0 to Bitmap.Width - 1 do begin
            for Y := 0 to Bitmap.Height - 1 do
            begin
               RowPtr8[Y] := pbytearray(ScanBMP.Scanlines[y])[x];
              //RowPtr8[Y] := pbytearray(Bitmap.Scanline[y])[x];
            end;
            _IEBlurRow8Bit(Kernel, RowPtr8, ColPtr8, Bitmap.Height);
            for Y := 0 to Bitmap.Height - 1 do
            begin
              pbytearray(ScanBMP.Scanlines[y])[x] := ColPtr8[Y];
              //pbytearray(Bitmap.Scanline[y])[x] := ColPtr8[Y];
            end;
          end;
          FreeMem(ColPtr8);
          FreeMem(RowPtr8);
        end;
    end;
  end;


  finally
    ScanBMP.free;
  end;
end;


end.
