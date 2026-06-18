unit myCustomFilters;

interface
   uses windows, sysutils, graphics, hyieutils, hyiedefs, imageenproc, iexBitmaps,
        NWSComps_Proc_Filter_Types, NWSComps_Proc_Filter_Lib, NWSComps_RGBCurves;

   const
     CUSTOMFILTER_RGBCURVES = 1000;  //id of the RGBCurves Custom Filter
     CUSTOMFILTER_SEPIA = 1001;     //id of the Sepia Custom Filter
     CUSTOMFILTER_WITHPARAM = 1002; //id of the Single Parameter Example Custom Filter


     CUSTOMPARAM_AMOUNT = 'Amount';   //name of parameter (should be unique inside the filter for each parameter)
     CUSTOMPARAM_AMOUNT_VTYPE= pt_Int;  //type of parameter
     CUSTOMPARAM_AMOUNT_MIN = 0;    //min value
     CUSTOMPARAM_AMOUNT_MAX = 9;    //max value
     CUSTOMPARAM_AMOUNT_DEFAULT = 0; //default value for the filter

     CUSTOMPARAM_FONTSIZE = 'FontSize';   //name of parameter (should be unique inside the filter for each parameter)
     CUSTOMPARAM_FONTSIZE_VTYPE= pt_Int;  //type of parameter
     CUSTOMPARAM_FONTSIZE_MIN = 0;    //min value
     CUSTOMPARAM_FONTSIZE_MAX = 1000;    //max value
     CUSTOMPARAM_FONTSIZE_DEFAULT = 50; //default value for the filter

     CUSTOMPARAM_X = 'X';   //name of parameter (should be unique inside the filter for each parameter)
     CUSTOMPARAM_X_VTYPE= pt_Int;  //type of parameter
     CUSTOMPARAM_X_MIN = 0;    //min value
     CUSTOMPARAM_X_MAX = 10000;    //max value
     CUSTOMPARAM_X_DEFAULT = 0; //default value for the filter

     CUSTOMPARAM_Y = 'Y';   //name of parameter (should be unique inside the filter for each parameter)
     CUSTOMPARAM_Y_VTYPE= pt_Int;  //type of parameter
     CUSTOMPARAM_Y_MIN = 0;    //min value
     CUSTOMPARAM_Y_MAX = 10000;    //max value
     CUSTOMPARAM_Y_DEFAULT = 0; //default value for the filter
   type

   //example of Custom filter that encapsulates the functionality of a TRGBCurves component
   TMyCustomFilter_RGBCurves = class(TIEProc_EX_Filter_Custom)
     private
      fRGBCurves:TRGBCurves;

     public
       Constructor Create(rgbCurves: TRGBCurves); reintroduce;  //reintroduce Create method to define filter's name and encapsulate the RGBCurves

       //this is the Filter's Process method, that implements the functionality of the filter
       //EditRect contains the coordinates of the rectangle to process (x1,y1,x2,y2)
       procedure Process(bitmap: TIEBitmap; EditRect: Trect;
                         FilterProgress: TIEProgressEvent); override;

       //inside this method you should specify the behaviour of the filter in Multithreading
       procedure GetMultiThreadInfo(EditedRect: TRect;
                                    var MtEnabled: TIEProc_EX_Filter_MultiThreadEnabled;
                                    var theOverlap: cardinal;
                                    var bAutoOverlap: boolean); override;
   end;


   //example of Custom filter that will use imageenproc for its process
    TMyCustomFilter_Sepia = class(TIEProc_EX_Filter_Custom)
     private


     public
       Constructor Create; override;  //override Create method in order to define filter's name

       //this is the Filter's Process method, that implements the functionality of the filter
       //EditRect contains the coordinates of the rectangle to process (x1,y1,x2,y2)
       procedure Process(bitmap: TIEBitmap; EditRect: Trect;
                         FilterProgress: TIEProgressEvent); override;

       //inside this method you should specify the behaviour of the filter in Multithreading
       procedure GetMultiThreadInfo(EditedRect: TRect;
                                    var MtEnabled: TIEProc_EX_Filter_MultiThreadEnabled;
                                    var theOverlap: cardinal;
                                    var bAutoOverlap: boolean); override;
   end;

   //example of Custom filter with 1 parameter
   TMyCustomFilter_WithParam = class(TIEProc_EX_Filter_Custom)
     private
    function GetAmount: integer;
    procedure Setamount(const Value: integer);


     public
       //Parameter Property
       //----------------------------------------------------------
       //Notice: you do not strictly need this property
       //you can access the parameter using the Filter.Params.ParamByName(nameofParam).GetValue_int
       property Amount: integer read GetAmount write Setamount;
       //----------------------------------------------------------

       Constructor Create; override;  //override Create method in order to define filter's name and the parameters of the filter

       //this is the Filter's Process method, that implements the functionality of the filter
       //EditRect contains the coordinates of the rectangle to process (x1,y1,x2,y2)
       procedure Process(bitmap: TIEBitmap; EditRect: Trect;
                        FilterProgress: TIEProgressEvent); override;

       //inside this method you should specify the behaviour of the filter in Multithreading
       procedure GetMultiThreadInfo(EditedRect: TRect;
                                    var MtEnabled: TIEProc_EX_Filter_MultiThreadEnabled;
                                    var theOverlap: cardinal;
                                    var bAutoOverlap: boolean); override;
   end;

implementation

{ TIEProc_EX_FilterRGBCurves }
//an example how to use rgbcurves to create a custom filter
constructor TMyCustomFilter_RGBCurves.Create(rgbCurves: TRGBCurves);
begin
  inherited Create;

  name := 'RGB Curves Filter';
  UserCaption := name;
  Id := CUSTOMFILTER_RGBCURVES;

  fRGBCurves := RGBCurves;
end;

procedure TMyCustomFilter_RGBCurves.GetMultiThreadInfo(EditedRect: TRect;
  var MtEnabled: TIEProc_EX_Filter_MultiThreadEnabled; var theOverlap: cardinal;
  var bAutoOverlap: boolean);
begin
  inherited;
  //inside this method you should specify the behaviour of the filter in Multithreading

  MtEnabled := mtAlwaysEnabled;  //set this to specify if your filter will accept Multithreading
  theOverlap := 0;     //the overlap in pixels, in case your filter computes the output based on an average of surrounding pixels
  bAutoOverlap := false;  //specify if the Multithreading engine is allowed change the overlap for its own optimizations
end;

procedure TMyCustomFilter_RGBCurves.Process(bitmap: TIEBitmap; EditRect: Trect;
   FilterProgress: TIEProgressEvent);
begin
  inherited;

  if not assigned(fRGBCurves) then EXIT;

  fRGBCurves.ApplyCurvestoIEBitmap(bitmap, nil, EditRect, false);
  if assigned(FilterProgress) then
    FilterProgress(self, 100);
end;



{ TIEProc_EX_Filter_Sepia }
 //an example how to use timageenproc to create a custom filter
constructor TMyCustomFilter_Sepia.Create;
begin
  inherited;
  name := 'Custom Sepia Filter';
  UserCaption := name;
  Id := CUSTOMFILTER_SEPIA;

end;

procedure TMyCustomFilter_Sepia.GetMultiThreadInfo(EditedRect: TRect;
  var MtEnabled: TIEProc_EX_Filter_MultiThreadEnabled; var theOverlap: cardinal;
  var bAutoOverlap: boolean);
begin
  inherited;
    //inside this method you should specify the behaviour of the filter in Multithreading

  MtEnabled := mtAlwaysEnabled;  //set this to specify if your filter will accept Multithreading
  theOverlap := 0;   //the overlap in pixels, in case your filter computes the output based on an average of surrounding pixels
  bAutoOverlap := false; //specify if the Multithreading engine is allowed change the overlap for its own optimizations
end;

procedure TMyCustomFilter_Sepia.Process(bitmap: TIEBitmap; EditRect: Trect;
                                         FilterProgress: TIEProgressEvent);
var
 tempBmp: TIEBitmap;
 proc:TImageenproc;
begin
  inherited;
 
  proc := timageenproc.Create(nil);
  tempBmp := TIEBitmap.Create(bitmap, editrect);
  try
    //do your process on tempbmp
    proc.OnProgress := FilterProgress;
    proc.AttachedIEBitmap := tempbmp;
    proc.ConvertToSepia;
    tempBmp.DrawToTIEBitmap(bitmap, editrect.left, editrect.Top);
  finally
    tempBmp.free;
    proc.free;
  end;

end;

{ TMyCustomFilter_WithParam }

constructor TMyCustomFilter_WithParam.Create;
var
   aPAram: TIEProc_EX_Filter_PAram;
 begin
   inherited;
    ID := CUSTOMFILTER_WITHPARAM;
    name := 'Custom Filter With Param';
    UserCaption := name;

   aPAram := self.Params.AddParam(CUSTOMPARAM_AMOUNT, CUSTOMPARAM_AMOUNT_VTYPE);  // we add our parameter here

   //initialize the parameter below
   aPAram.SetValue(CUSTOMPARAM_AMOUNT_DEFAULT);
   aPAram.SetMin(CUSTOMPARAM_AMOUNT_MIN);
    aPAram.SetMax(CUSTOMPARAM_AMOUNT_MAX);


   aPAram := self.Params.AddParam(CUSTOMPARAM_FONTSIZE, CUSTOMPARAM_FONTSIZE_VTYPE);  // we add our parameter here

   //initialize the parameter below
   aPAram.SetValue(CUSTOMPARAM_FONTSIZE_DEFAULT);
   aPAram.SetMin(CUSTOMPARAM_FONTSIZE_MIN);
   aPAram.SetMax(CUSTOMPARAM_FONTSIZE_MAX);
   aPAram.IsScalable := True; //this will account for preview scale factor


   aPAram := self.Params.AddParam(CUSTOMPARAM_X, CUSTOMPARAM_X_VTYPE);  // we add our parameter here
   //initialize the parameter below
   aPAram.SetValue(CUSTOMPARAM_X_DEFAULT);
   aPAram.SetMin(CUSTOMPARAM_X_MIN);
   aPAram.SetMax(CUSTOMPARAM_X_MAX);
   aPAram.IsCoordinateX := true;

   aPAram := self.Params.AddParam(CUSTOMPARAM_Y, CUSTOMPARAM_Y_VTYPE);  // we add our parameter here

   //initialize the parameter below
   aPAram.SetValue(CUSTOMPARAM_Y_DEFAULT);
   aPAram.SetMin(CUSTOMPARAM_Y_MIN);
   aPAram.SetMax(CUSTOMPARAM_Y_MAX);
   aPAram.IsCoordinateY := true;
end;

function TMyCustomFilter_WithParam.GetAmount: integer;
begin
  result := Params.Param_Byname(CUSTOMPARAM_AMOUNT).GetValue_int;
end;

procedure TMyCustomFilter_WithParam.GetMultiThreadInfo(EditedRect: TRect;
  var MtEnabled: TIEProc_EX_Filter_MultiThreadEnabled; var theOverlap: cardinal;
  var bAutoOverlap: boolean);
begin
  inherited;
    //inside this method you should specify the behaviour of the filter in Multithreading

  MtEnabled := mtDisabled;  //set this to specify if your filter will accept Multithreading
end;

procedure TMyCustomFilter_WithParam.Setamount(const Value: integer);
begin
  Params.Param_Byname(CUSTOMPARAM_AMOUNT).SetValue(Value, pt_Int);
  Update;
end;

procedure TMyCustomFilter_WithParam.Process(bitmap: TIEBitmap; EditRect: Trect;
                                           FilterProgress: TIEProgressEvent);
var
 amt, fontsize, x,y: integer;
begin
  inherited;

  amt := Params.Param_Byname(CUSTOMPARAM_AMOUNT).GetValue_int;
  fontSize := Params.Param_Byname(CUSTOMPARAM_FONTSIZE).GetValue_int;
  x := Params.Param_Byname(CUSTOMPARAM_X).GetValue_int;
  y := Params.Param_Byname(CUSTOMPARAM_Y).GetValue_int;
  case amt of
    0: bitmap.FillRect(editrect.Left, editrect.top, editrect.Right, EditRect.bottom, clRed);
    1: bitmap.FillRect(editrect.Left, editrect.top, editrect.Right, EditRect.bottom, clBlue);
    2: bitmap.FillRect(editrect.Left, editrect.top, editrect.Right, EditRect.bottom, clYellow);
    3: bitmap.FillRect(editrect.Left, editrect.top, editrect.Right, EditRect.bottom, clPurple);
    4: bitmap.FillRect(editrect.Left, editrect.top, editrect.Right, EditRect.bottom, clGreen);
    5: bitmap.FillRect(editrect.Left, editrect.top, editrect.Right, EditRect.bottom, clNavy);
    6: bitmap.FillRect(editrect.Left, editrect.top, editrect.Right, EditRect.bottom, clGray);
    7: bitmap.FillRect(editrect.Left, editrect.top, editrect.Right, EditRect.bottom, clWhite);
    8: bitmap.FillRect(editrect.Left, editrect.top, editrect.Right, EditRect.bottom, clTeal);
    9: bitmap.FillRect(editrect.Left, editrect.top, editrect.Right, EditRect.bottom, clOlive);
  end;



  bitmap.Canvas.font.Size := fontsize; //the font size is scaled according to preview factor
  bitmap.Canvas.Brush.Style := bsclear;
  bitmap.Canvas.TextRect(editrect, x, y,  inttostr(amt));
  bitmap.Location := ieMemory; //after using canvas imageEn changes the location to tbitmap
  if assigned(FilterProgress) then
    FilterProgress(self, 100);
end;



end.
