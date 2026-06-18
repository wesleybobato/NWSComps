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
unit NWSComps_Proc_Filter_Types;
{$R-}
{$Q-}
interface

{$I ..\_inc\NWSComps_Shared.inc}
uses
  Windows, SysUtils, Classes, forms, Graphics, math, messages, contnrs, variants,
  {$IFDEF IMAGEEN_6_2_LATER}  iexBitmaps ,{$ENDIF} hyiedefs, hyieutils;


  type
  TIEProc_EX_Filter_MultiThreadEnabled = (mtAlwaysEnabled, mtEnabledExceptPreview, mtEnabledInPreviewOnly, mtDisabled);

  TIEProc_EX_Filter_Channels_Flags= (ch_Red, ch_Green, ch_Blue, ch_Alpha);
  TIEProc_EX_Filter_Channels_Flags_Set = Set of TIEProc_EX_Filter_Channels_Flags;


  TIEProc_EX_Filter_Param_Type = (pt_boolean, pt_byte, pt_Int, pt_Cardinal,
                               pt_single, pt_double, pt_string, pt_Variant);

  TIEProc_EX_Filter_Param_QueryType = (qt_Value, qt_Min, qt_Max);

  TIEProc_EX_Filter_Param_UIRepresentation = (UIStandard, UIColor, UICombo);

  TIEProc_EX_Filter_Blendmode = (blmnormal = 0,
                                 blmoverlay = 1,
                                 blmhardlight = 2,
                                 blmmultiply = 3,
                                 blmscreen = 4,
                                 blmhsl = 5);
  TIEProc_EX_Filter_Kernelsize = (ksSmall = 0, ksMedium = 1);

  const
    IEPROC_EX_GUID_NULL: TGUID = '{00000000-0000-0000-0000-000000000000}';

    IEPROC_EX_FLAGS_FULLAPPLY = 'Flags_ID1_FullApply';
    IEPROC_EX_FLAGS_FULLAPPLY_VTYPE= pt_boolean;
    IEPROC_EX_FLAGS_FULLAPPLY_DEFAULT = TRUE;
    //---------------------------------------------

    IEPROC_EX_FLAGS_PREVIEWID = 'Flags_ID2_PreviewID';
    IEPROC_EX_FLAGS_PREVIEWID_VTYPE = pt_string;
  //  IEPROC_EX_FLAGS_PREVIEWID_DEFAULT = IEPROC_EX_GUID_NULL;
    //---------------------------------------------




  type
  TIEProc_EX_Filter_Param = class(TPersistent)
    private
    fID: integer;
    fIsFlag: boolean;

    fvalueType:TIEProc_EX_Filter_Param_Type;
    fName: string;
    fUserCaption: string;

    fvalue, fMin, fMax, fDefValue: variant;
    fvalueAssigned, fDefValueAssigned, fMinAssigned, fMaxAssigned: boolean;

    fIsScalable: boolean;
    fIsCoordinateX: boolean;
    fIsCoordinateY: boolean;
    fUIRepresentation: TIEProc_EX_Filter_Param_UIRepresentation;
    
    public
      property ID: integer read fID write fID;
      property Name: string read fName write fName;
      property UserCaption: string read fUserCaption write fUserCaption;

      property ValueType: TIEProc_EX_Filter_Param_Type read fvalueType;
      property Has_Min: boolean read fMinAssigned;
      property Has_Max: boolean read fMaxAssigned;
      property Has_Default: boolean read fDefValueAssigned;

      property Value: variant read fValue;
      property DefValue: variant read fDefValue;

      property IsFlag: boolean read fIsFlag;
      property IsScalable: boolean read fIsScalable write fIsScalable;
      property IsCoordinateX:boolean read fIsCoordinateX write fIsCoordinateX;
      property IsCoordinateY:boolean read fIsCoordinateY write fIsCoordinateY;

      property UIRepresentation: TIEProc_EX_Filter_Param_UIRepresentation read fUIRepresentation write fUIRepresentation;

      procedure Assign(source:TObject);reintroduce;

      function SameValue(theParam: TIEProc_EX_Filter_Param): boolean;
      function ValueIsDefault: boolean;

      function GetValue_bool(qt: TIEProc_EX_Filter_Param_QueryType = qt_Value): boolean;
      function GetValue_byte(qt: TIEProc_EX_Filter_Param_QueryType = qt_Value): byte;
      function GetValue_int(qt: TIEProc_EX_Filter_Param_QueryType = qt_Value): integer;
      function GetValue_Cardinal(qt: TIEProc_EX_Filter_Param_QueryType = qt_Value): Cardinal;
      function GetValue_single(qt: TIEProc_EX_Filter_Param_QueryType = qt_Value): single;
      function GetValue_double(qt: TIEProc_EX_Filter_Param_QueryType = qt_Value): double;
      function GetValue_string(qt: TIEProc_EX_Filter_Param_QueryType = qt_Value): string;
      function GetValue_GUID(qt: TIEProc_EX_Filter_Param_QueryType = qt_Value): TGUID;

      procedure GetMinMax_bool(var theMin, theMax: boolean; var bSuccess:boolean);
      procedure GetMinMax_byte(var theMin, theMax: byte; var bSuccess:boolean);
      procedure GetMinMax_int(var theMin, theMax: integer; var bSuccess:boolean);
      procedure GetMinMax_Cardinal(var theMin, theMax: cardinal; var bSuccess:boolean);
      procedure GetMinMax_single(var theMin, theMax: single; var bSuccess:boolean);
      procedure GetMinMax_double(var theMin, theMax: double; var bSuccess:boolean);
      procedure GetMinMax_string(var theMin, theMax: string; var bSuccess:boolean);

      procedure SetDefValue(theValue: variant);

      procedure SetValue(theValue: variant; theType: TIEProc_EX_Filter_Param_Type);overload;
      procedure SetMin(theValue: variant; theType: TIEProc_EX_Filter_Param_Type); overload;
      procedure SetMax(theValue: variant; theType: TIEProc_EX_Filter_Param_Type); overload;

      procedure SetValue(theValue: variant); overload;
      procedure SetMin(theValue: variant); overload;
      procedure SetMax(theValue: variant); overload;

      constructor Create(bIsFlag: boolean;  theName:string; theValueType: TIEProc_EX_Filter_Param_Type; theDefValue: variant; bHasDefValue: boolean = false); reintroduce;
  end;


  TIEProc_EX_Filter_Params = class(TPersistent)
    private
    fParamsList: TObjectList;
    fDefaultNoChangeParams: TList;


    function GetParam(idx: integer): TIEProc_EX_Filter_Param;
    procedure SetParam(idx: integer; thePAram: TIEProc_EX_Filter_Param);
    function GetCount: integer;

    function AddParam(bIsFlag: boolean; theName: string;
                      theValueType: TIEProc_EX_Filter_Param_Type;
                      theDefValue: variant; bHasDefaultValue: boolean): TIEProc_EX_Filter_Param; overload;

    protected
      procedure DeleteParam(idx:integer);
      procedure Clear;
      procedure MarkParamAsDefaultNoChange(param: TIEProc_EX_Filter_Param; defValue: variant);

    public

      property Count: integer read GetCount;
      Property Params[idx: integer]: TIEProc_EX_Filter_Param read GetParam write SetPAram;  default;

      function AddFlagParam(theName: string; theValueType: TIEProc_EX_Filter_Param_Type): TIEProc_EX_Filter_Param;

      function AddParam(theName: string; theValueType: TIEProc_EX_Filter_Param_Type): TIEProc_EX_Filter_Param; overload;
      function AddParam(theName: string; theValueType: TIEProc_EX_Filter_Param_Type; theDefValue:Variant): TIEProc_EX_Filter_Param; overload;

      function Param_Byname(paramname: string): TIEProc_EX_Filter_Param;

      procedure Assign(source:TObject);reintroduce;


      Constructor Create; reintroduce;
      Destructor Destroy; override;

      procedure ClearParams(bClearFlags: boolean; bClearNormalParams: boolean);

      procedure DefineDefNoChangesParams(listOfDefNoChanges: TList);
      function IsParamDefNoChange(param: TIEProc_EX_Filter_Param): boolean;
  end;

    TIEProc_EX_Filter_Progress_Event = procedure(perc: integer) of object;

    TIEProc_EX_Filter = class(TPersistent)
    private


    fParams: TIEProc_EX_Filter_Params;
    fActive: boolean;
    fUpdLock: integer;
    fName: String;
    fID: integer;
    fOnFilterProgress: TIEProc_EX_Filter_Progress_Event;
    fOnFilterUpdate: TNotifyEvent;
    fChannels_Flags: TIEProc_EX_Filter_Channels_Flags_Set;
    fUserCaption: string;

    function GetLocked: boolean;


    public

      property Name: String read fName write fName;
      property ID: integer read fID write fID;
      property UserCaption: string read fUserCaption write fUserCaption;

      property Channels_Flags: TIEProc_EX_Filter_Channels_Flags_Set read fChannels_Flags write fChannels_Flags;

      Property Params: TIEProc_EX_Filter_Params read fParams;
      Property Active: boolean read fActive write fActive;
      Property Locked: boolean read GetLocked;


      property OnFilterProgress: TIEProc_EX_Filter_Progress_Event read fOnFilterProgress write fOnFilterProgress;
      property OnFilterUpdate: TNotifyEvent read fOnFilterUpdate write fOnFilterUpdate;

      Constructor Create; reintroduce; virtual;
      Destructor Destroy; override;

      procedure ClearParams;
      procedure ClearFlags;

      procedure SetParamValue(theParamName: string; theValue: variant);


      procedure Assign(Source: TObject); reintroduce;
      procedure AssignParams(srcparams: TIEProc_EX_Filter_Params);
      Procedure Update;

      Procedure Update_Lock;
      Procedure Update_Unlock(DoUpdate: boolean);

       procedure GetMultiThreadInfo(EditedRect: TRect;
                                    var MtEnabled: TIEProc_EX_Filter_MultiThreadEnabled;
                                    var theOverlap: cardinal;
                                    var bAutoOverlap: boolean); virtual;
  end;


  TIEProc_EX_Filter_BaseCustom = class(TIEProc_EX_Filter)
  private

  public
   procedure Process(bitmap: TIEBitmap; EditRect: Trect;
                     FilterProgress: TIEProgressEvent); virtual;


   procedure Abort; virtual;
 end;


  TIEProc_EX_Filter_Collection = class(TPersistent)
    private
    fFilters: TObjectList;
    fName: string;
    fUpdLock: integer;
    fUserCaption: string;

    function GetLocked: boolean;
    function GetCount: integer;
    function GetFilter(idx: integer): TIEProc_EX_Filter;
    procedure SetFilter(idx: integer; theFilter: TIEProc_EX_Filter);
    function GetActiveCount:integer;
    public
      OnFilterUpdate: TNotifyEvent;
      property ActiveCount: integer read GetActiveCount;
      Property Name: string read fName write fName;
      property UserCaption: string read fUserCaption write fUserCaption;

      Property Locked: boolean read GetLocked;

      Property Count: integer read GetCount;
      Property Filter[idx: integer]: TIEProc_EX_Filter read GetFilter write SetFilter; default;
      function FilterById(FilterId:integer):TIEProc_EX_Filter;

      function AddFilter: TIEProc_EX_Filter;  overload;
      procedure AddFilter(filter:TIEProc_EX_Filter); overload;
      procedure RemoveFilter(filter: TIEProc_EX_Filter);
      Constructor Create; reintroduce;
      Destructor Destroy; override;

      procedure Assign(Source: TPersistent); reintroduce;
      Procedure Update;

      Procedure Update_Lock;
      Procedure Update_Unlock(DoUpdate: boolean);
  end;

implementation
  uses NWSComps_Proc_Filter_Lib_Const;

  constructor TIEProc_EX_Filter_Param.Create(bIsFlag: boolean; theName:string; theValueType: TIEProc_EX_Filter_Param_Type; theDefValue: variant; bHasDefValue: boolean = false);
  begin
    inherited Create;
    fIsFlag := bIsFlag;
    fName := theName;
    fvalueType := theValueType;

    fvalueAssigned := false;
    fMinAssigned := False;
    fMaxAssigned := False;
    fDefValue := theDefValue;
    fDefValueAssigned := bHasDefValue;

    fIsScalable := false;
    fIsCoordinateX := false;
    fIsCoordinateY := false;
    fUIRepresentation := UIStandard;
  end;


  procedure TIEProc_EX_Filter_Param.Assign(source:TObject);
  var
  src: TIEProc_EX_Filter_Param;
  begin
    if not (source is TIEProc_EX_Filter_Param) then
      raise Exception.Create('Source is not a ' + TIEProc_EX_Filter_Param.ClassName);


    src := TIEProc_EX_Filter_Param(Source);
    fIsFlag := src.IsFlag;
    fIsScalable := src.IsScalable;
    fIsCoordinateX := src.IsCoordinateX;
    fIsCoordinateY := src.IsCoordinateY;
    fvalueType := src.fvalueType;
    fvalue := src.fvalue;
    fMin := src.fMin;
    fMax := src.fMax;
    fDefValue := src.fDefValue;

    fvalueAssigned := src.fvalueAssigned;
    fMinAssigned := src.fMinAssigned;
    fMaxAssigned := src.fMaxAssigned;
    fDefValueAssigned := src.fDefValueAssigned;

    fID := src.ID;
    fName := src.name;
    fUserCaption := src.UserCaption;
    fUIRepresentation := src.UIRepresentation;
  end;

  function TIEProc_EX_Filter_Param.GetValue_bool(qt: TIEProc_EX_Filter_Param_QueryType = qt_Value): boolean;
  var
  aValue: boolean;
  begin
    case qt of
      qt_Value: aValue := boolean(fValue);
      qt_Min: aValue := boolean(fMin);
      qt_Max: aValue := boolean(fMax);
      else aValue := false;
    end;
    result := avalue;
  end;

  function TIEProc_EX_Filter_Param.GetValue_byte(qt: TIEProc_EX_Filter_Param_QueryType = qt_Value): byte;
  var
  aValue: byte;
  begin
    case qt of
      qt_Value: aValue := byte(fValue);
      qt_Min: aValue := byte(fMin);
      qt_Max: aValue := byte(fMax);
      else aValue := 0;
    end;
   result := aValue;
  end;

  function TIEProc_EX_Filter_Param.GetValue_int(qt: TIEProc_EX_Filter_Param_QueryType = qt_Value): integer;
  var
  aValue: integer;
  begin
    case qt of
      qt_Value: aValue := integer(fValue);
      qt_Min: aValue := integer(fMin);
      qt_Max: aValue := integer(fMax);
      else aValue := 0;
    end;
    result := aValue;
  end;

  function TIEProc_EX_Filter_Param.GetValue_Cardinal(qt: TIEProc_EX_Filter_Param_QueryType = qt_Value): Cardinal;
  var
  aValue: Cardinal;
  begin
    case qt of
      qt_Value: aValue := Cardinal(fValue);
      qt_Min: aValue := Cardinal(fMin);
      qt_Max: aValue := Cardinal(fMax);
      else aValue := 0;
    end;
    result := aValue;
  end;

  function TIEProc_EX_Filter_Param.GetValue_single(qt: TIEProc_EX_Filter_Param_QueryType = qt_Value): single;
  var
  aValue: single;
  begin
    case qt of
      qt_Value: aValue := single(fValue);
      qt_Min: aValue := single(fMin);
      qt_Max: aValue := single(fMax);
      else aValue := 0;
    end;
    result := aValue;
  end;

  function TIEProc_EX_Filter_Param.GetValue_double(qt: TIEProc_EX_Filter_Param_QueryType = qt_Value): double;
  var
  aValue: double;
  begin
    case qt of
      qt_Value: aValue := double(fValue);
      qt_Min: aValue := double(fMin);
      qt_Max: aValue := double(fMax);
      else aValue := 0;
    end;
    result := aValue;
  end;

  function TIEProc_EX_Filter_Param.GetValue_string(qt: TIEProc_EX_Filter_Param_QueryType = qt_Value): string;
  var
  aValue: string;
  begin
    case qt of
      qt_Value: aValue := string(fValue);
      qt_Min: aValue := string(fMin);
      qt_Max: aValue := string(fMax);
      else aValue := '';
    end;
    result := aValue;
  end;

  function TIEProc_EX_Filter_Param.GetValue_GUID(qt: TIEProc_EX_Filter_Param_QueryType = qt_Value): TGUID;
  begin
    result := StringToGUID(fValue);
  end;

  procedure TIEProc_EX_Filter_Param.GetMinMax_bool(var theMin, theMax: boolean; var bSuccess:boolean);
  begin

    theMin := GetValue_Bool(qt_Min);
    theMax := GetValue_Bool(qt_Max);
  end;

  procedure TIEProc_EX_Filter_Param.GetMinMax_byte(var theMin, theMax: byte; var bSuccess:boolean);
  begin
    theMin := GetValue_Byte(qt_Min);
    theMax := GetValue_Byte(qt_Max);
  end;

  procedure TIEProc_EX_Filter_Param.GetMinMax_int(var theMin, theMax: integer; var bSuccess:boolean);
  begin
    theMin := GetValue_Int(qt_Min);
    theMax := GetValue_Int(qt_Max);
  end;

  procedure TIEProc_EX_Filter_Param.GetMinMax_Cardinal(var theMin, theMax: cardinal; var bSuccess:boolean);
  begin
    theMin := GetValue_Cardinal(qt_Min);
    theMax := GetValue_Cardinal(qt_Max);
  end;

  procedure TIEProc_EX_Filter_Param.GetMinMax_single(var theMin, theMax: single; var bSuccess:boolean);
  begin
    theMin := GetValue_Single(qt_Min);
    theMax := GetValue_Single(qt_Max);
  end;

  procedure TIEProc_EX_Filter_Param.GetMinMax_double(var theMin, theMax: double; var bSuccess:boolean);
  begin
    theMin := GetValue_double(qt_Min);
    theMax := GetValue_double(qt_Max);
  end;

  procedure TIEProc_EX_Filter_Param.GetMinMax_string(var theMin, theMax: string; var bSuccess:boolean);
  begin
    theMin := GetValue_String(qt_Min);
    theMax := GetValue_String(qt_Max);
  end;


  procedure TIEProc_EX_Filter_Param.SetValue(theValue: variant; theType: TIEProc_EX_Filter_Param_Type);
  begin
    fValue := theValue;
    fvalueType :=theType;
    fvalueAssigned := true;
  end;

  procedure TIEProc_EX_Filter_Param.SetMax(theValue: variant);
  begin
     SetMax(theValue, fvalueType);
  end;

  procedure TIEProc_EX_Filter_Param.SetMin(theValue: variant);
  begin
    SetMin(theValue, fvalueType);
  end;

  procedure TIEProc_EX_Filter_Param.SetValue(theValue: variant);
  begin
    SetValue(theValue, fvalueType);
  end;

  function VariantsHaveSameValue(_A, _B: Variant): Boolean;
  var
    LA, LB: TVarData;
  begin
    LA := FindVarData(_A)^;
    LB := FindVarData(_B)^;
    if LA.VType <> LB.VType then
      Result := False
    else
      Result := (_A = _B);
  end;

  function TIEProc_EX_Filter_Param.ValueIsDefault: boolean;
  begin
     result := fDefValueAssigned and fvalueAssigned and (fValue = fDefValue); //and VariantsHaveSameValue(fValue, fDefValue);
  end;

  function TIEProc_EX_Filter_Param.SameValue(
  theParam: TIEProc_EX_Filter_Param): boolean;
  begin
    result := VariantsHaveSameValue(fValue, theParam.Value);
  end;

  procedure TIEProc_EX_Filter_Param.SetMin(theValue: variant; theType: TIEProc_EX_Filter_Param_Type);
  begin
    Assert(fvaluetype = theType);
    fMin := theValue;

    fMinAssigned := True;
  end;



  procedure TIEProc_EX_Filter_Param.SetDefValue(theValue: variant);
  begin
    fDefValue := theValue;
    fDefValueAssigned := true;
  end;

  procedure TIEProc_EX_Filter_Param.SetMax(theValue: variant; theType: TIEProc_EX_Filter_Param_Type);
  begin
    Assert(fvaluetype = theType);
    fMax := theValue;

    fMaxAssigned := True;
  end;

   //------------------------------------------------------------------------


  procedure TIEProc_EX_Filter_Params.Clear;
  begin
    fDefaultNoChangeParams.clear;
    fParamsList.clear;
  end;

procedure TIEProc_EX_Filter_Params.ClearParams(bClearFlags,
  bClearNormalParams: boolean);
var
    I: Integer;
    bFlag, bNormal: boolean;
  begin
     for I := fParamsList.Count-1 downto 0 do
     begin
       bFlag := GetParam(i).IsFlag;
       bNormal := not bFlag;
       if (bClearFlags and bFlag) or
          (bClearNormalParams and bNormal) then
       begin
         DeleteParam(i);
       end;
     end;
end;





Constructor TIEProc_EX_Filter_Params.Create;
   begin
     inherited Create;
      fParamsList := TObjectList.Create(True);
      fDefaultNoChangeParams := TList.create;
   end;

   procedure TIEProc_EX_Filter_Params.DefineDefNoChangesParams(
  listOfDefNoChanges: TList);
  var
  I: Integer;
  aParam:TIEProc_EX_Filter_Param;
  begin
    Assert(assigned(listOfDefNoChanges));

    //preliminary check. Must not fail on all parameters
    for I := 0 to listOfDefNoChanges.count-1 do
    begin
      aPAram := TIEProc_EX_Filter_Param(listOfDefNoChanges[i]);  //must be a valid param
      assert(aParam.Has_Default, 'Parameter has no default Value');  //must have a default value
      assert(fParamsList.IndexOf(aParam)<> -1, 'Parameter not present'); //must have already been included in the params list
    end;

    //check ok then we can add all params
    fDefaultNoChangeParams.clear;
    for I := 0 to listOfDefNoChanges.count-1 do
    begin
      aPAram := TIEProc_EX_Filter_Param(listOfDefNoChanges[i]);
      fDefaultNoChangeParams.add(aPAram);
    end;
  end;

procedure TIEProc_EX_Filter_Params.DeleteParam(idx: integer);
   begin
     fDefaultNoChangeParams.remove(fParamsList[idx]);
     fParamsList.Delete(idx);
   end;

   Destructor TIEProc_EX_Filter_Params.Destroy;
   begin
     fDefaultNoChangeParams.free;
     fParamsList.free;
     inherited Destroy;
   end;

  procedure TIEProc_EX_Filter_Params.Assign(source: TObject);
  var
  src: TIEProc_EX_Filter_Params;
  aParam: TIEProc_EX_Filter_Param;
  I: Integer;
  begin
    if not (source is TIEProc_EX_Filter_Params) then
      raise Exception.Create('Cannot assign to a ' + TIEProc_EX_Filter_Params.ClassName);


    src := TIEProc_EX_Filter_Params(Source);

    Clear;
    for I := 0 to src.fParamsList.count-1 do
    begin
      aParam := TIEProc_EX_Filter_Param.Create(false, '', pt_Variant, 0);
      aParam.Assign(src.Params[i]);
      fParamsList.Add(aParam);

      if src.IsParamDefNoChange(src.Params[i]) then
         MarkParamAsDefaultNoChange(aParam, src.Params[i].DefValue);
    end;

  end;

   


  function TIEProc_EX_Filter_Params.AddParam(bIsFlag: boolean; theName: string;
                                             theValueType: TIEProc_EX_Filter_Param_Type;
                                             theDefValue: variant; bHasDefaultValue: boolean): TIEProc_EX_Filter_Param;
  begin
     result := TIEProc_EX_Filter_Param.Create(bIsFlag, theName, theValueType, theDefValue, bHasDefaultValue);
     fParamsList.Add(result);
  end;

  function TIEProc_EX_Filter_Params.AddParam(theName: string; theValueType: TIEProc_EX_Filter_Param_Type; theDefValue:Variant): TIEProc_EX_Filter_Param;
   begin
     result := AddParam(false, theName, thevaluetype, theDefValue, true);
     result.SetValue(theDefValue, theValueType);
   end;

  function TIEProc_EX_Filter_Params.AddParam(theName: string; theValueType: TIEProc_EX_Filter_Param_Type): TIEProc_EX_Filter_Param;
  begin
    result := AddParam(false, theName, theValueType, 0, false);
  end;

  function TIEProc_EX_Filter_Params.AddFlagParam(theName: string; theValueType: TIEProc_EX_Filter_Param_Type): TIEProc_EX_Filter_Param;
  begin
    result := AddParam(true, theName, theValueType, 0 , false);
  end;

   function TIEProc_EX_Filter_Params.GetCount: integer;
   begin
     result := fParamsList.Count;
   end;

   function TIEProc_EX_Filter_Params.GetParam(idx: integer): TIEProc_EX_Filter_Param;
   begin
      assert(idx< fParamsList.count);
      result := TIEProc_EX_Filter_Param(fParamsList[idx]);
   end;

   function TIEProc_EX_Filter_Params.IsParamDefNoChange(
  param: TIEProc_EX_Filter_Param): boolean;
  begin
    result := fDefaultNoChangeParams.IndexOf(param)<> -1;
  end;

procedure TIEProc_EX_Filter_Params.MarkParamAsDefaultNoChange(
              param: TIEProc_EX_Filter_Param; defValue: variant);
  begin
    if fDefaultNoChangeParams.indexof(Param) = -1 then
    begin
      param.SetDefValue(defValue);
      fDefaultNoChangeParams.add(param);
    end;
  end;

   procedure TIEProc_EX_Filter_Params.SetParam(idx: integer; thePAram: TIEProc_EX_Filter_Param);
   begin
     assert(idx< fParamsList.count);
     TIEProc_EX_Filter_Param(fParamsList[idx]).assign(theParam);
   end;




function TIEProc_EX_Filter_Params.Param_Byname(paramname: string): TIEProc_EX_Filter_Param;
   var
     i: integer;
     bFound: boolean;
   begin
     bFound := False;
     for i := 0 to fParamsList.count - 1 do
     begin
       bFound := GetParam(i).Name = paramname;
       if bFound then break;
     end;

     if bFound then
      result := TIEProc_EX_Filter_Param(fParamsList[i])
     else
       result := nil;
   end;
   //-----------------------------------------------------------------------------





  procedure TIEProc_EX_Filter.ClearFlags;
  begin
    fParams.ClearParams(true, false);
  end;

  procedure TIEProc_EX_Filter.ClearParams;
  begin
     fParams.ClearParams(false, true);
  end;

Constructor TIEProc_EX_Filter.Create;
   var
    aFlagParam: TIEProc_EX_Filter_PAram;
   begin
     inherited Create;
     fId := 0;
     fName := '';
     fUpdLock := 0;
     fActive := True;
     fChannels_Flags:= [ch_Red, ch_Green, ch_Blue];  //by default works on rgb channels

     fPArams := TIEProc_EX_Filter_Params.create;

     //add flags....
       aFlagParam := self.Params.AddFlagParam(IEPROC_EX_FLAGS_FULLAPPLY, IEPROC_EX_FLAGS_FULLAPPLY_VTYPE);
       aFlagParam.SetValue(IEPROC_EX_FLAGS_FULLAPPLY_DEFAULT, IEPROC_EX_FLAGS_FULLAPPLY_VTYPE);

       aFlagParam := self.Params.AddFlagParam(IEPROC_EX_FLAGS_PREVIEWID, IEPROC_EX_FLAGS_PREVIEWID_VTYPE);
       aFlagParam.SetValue(GUIDToString(IEPROC_EX_GUID_NULL), IEPROC_EX_FLAGS_PREVIEWID_VTYPE);

    end;

   Destructor TIEProc_EX_Filter.Destroy;
   begin
     fPArams.free;
     inherited Destroy;
   end;


  procedure TIEProc_EX_Filter.SetParamValue(theParamName: string;
  theValue: variant);
  var
  aParam : TIEProc_EX_Filter_Param;
  begin
    aParam := fParams.Param_Byname(theParamName);
    if aParam = nil then EXIT;

    aParam.SetValue(theValue, aParam.ValueType);
  end;


  function TIEProc_EX_Filter.GetLocked: boolean;
  begin
    result := fUpdLock > 0;
  end;

  procedure TIEProc_EX_Filter.Assign(source:TObject);
  var
  src: TIEProc_EX_Filter;
  begin
    if not (source is TIEProc_EX_Filter) then
      raise Exception.Create('Cannot assign to a ' + TIEProc_EX_Filter.ClassName);

    src := TIEProc_EX_Filter(Source);

    AssignParams(src.Params);

    fName := src.Name;
    fID := src.ID;
    fChannels_Flags := src.Channels_Flags;

    fActive := src.Active;
    fOnFilterProgress := src.OnFilterProgress;
    fOnFilterUpdate := src.OnFilterUpdate;

  end;

  procedure TIEProc_EX_Filter.AssignParams(srcparams: TIEProc_EX_Filter_Params);
  begin
    fParams.assign(srcParams);
  end;

   Procedure TIEProc_EX_Filter.Update;
   begin
     if not fActive then EXIT;  //do nothing
     if Locked then EXIT; //do nothing

     if assigned(OnFilterUpdate) then OnFilterUpdate(self);

   end;

   Procedure TIEProc_EX_Filter.Update_Lock;
   begin
     inc(fUpdLock);
   end;

   Procedure TIEProc_EX_Filter.Update_Unlock(DoUpdate: boolean);
   begin
     dec(fUpdLock);
     if fupdLock<0 then
       fUpdLock := 0;

     if DoUpdate then
       Update;
   end;

   procedure TIEProc_EX_Filter.GetMultiThreadInfo(EditedRect: TRect;
                                                  var MtEnabled: TIEProc_EX_Filter_MultiThreadEnabled;
                                                  var theOverlap: cardinal;
                                                  var bAutoOverlap: boolean);
    var
    w,h: integer;
    paramradius: string;
    begin
       MtEnabled := mtDisabled;
       theOverlap := 0;
       bAutoOverlap := false;


       w := EditedRect.right - EditedRect.left + 1;
       h := EditedRect.bottom - EditedRect.top + 1;



       case fID of
         IEPROC_EX_SMARTFLASH_ID: paramradius := IEPROC_EX_SMARTFLASH_RADIUS;
         IEPROC_EX_REDUCEHIGHLIGHTS_ID: paramradius := IEPROC_EX_REDUCEHIGHLIGHTS_RADIUS;
         IEPROC_EX_FILLBACKLIGHT_ID: paramradius := IEPROC_EX_FILLBACKLIGHT_RADIUS;
         IEPROC_EX_SMARTCONTRAST_ID: paramradius := IEPROC_EX_SMARTCONTRAST_RADIUS;
         IEPROC_EX_IE_UNSHARPMASK_ID: paramradius := IEPROC_EX_IE_UNSHARPMASK_RADIUS;
         IEPROC_EX_IE_BLUR_ID: paramradius := IEPROC_EX_IE_BLUR_RADIUS;
         else
           paramradius := IEPROC_EX_SMARTFLASH_RADIUS;
       end;



       case fID of
         IEPROC_EX_SMARTFLASH_ID, IEPROC_EX_REDUCEHIGHLIGHTS_ID, IEPROC_EX_FILLBACKLIGHT_ID,
          IEPROC_EX_SMARTCONTRAST_ID:
         begin
           MtEnabled := mtEnabledExceptPreview; //do not change this because the preview cache mechanism
                                                //is faster than multithreading !!!
                                                //but it is incompatible with it!


           theOverlap := max(round((w + h) div 100), round(1.0 * params.Param_Byname(paramradius).GetValue_int));
           theOverlap := max(5, theOverlap);
           bAutoOverlap := true;
         end;
         IEPROC_EX_BILATERALFILTER_ID:
         begin
           MtEnabled := mtAlwaysEnabled;
           theOverlap :=  max((w + h) div 250, 5);
           bAutoOverlap := false;
         end;
         IEPROC_EX_IE_UNSHARPMASK_ID, IEPROC_EX_IE_BLUR_ID:
         begin
           MtEnabled := mtAlwaysEnabled;
           theOverlap :=  max(round((w + h) div 100), round(1.0 * params.Param_Byname(paramradius).GetValue_int));
           theOverlap := max(5, theOverlap);
           bAutoOverlap := true;
         end;
         IEPROC_EX_RGBBALANCE_ID:
         begin
           MtEnabled := mtAlwaysEnabled;
           theOverlap := 0;
           bAutoOverlap := false;
         end;
         IEPROC_EX_COLORFILTER_ID:
         begin
           MtEnabled := mtAlwaysEnabled;
           theOverlap := 0;
           bAutoOverlap := false;
         end;
         IEPROC_EX_AUTOCOLOR_ID:
         begin
           MtEnabled := mtDisabled;
           theOverlap := max(10, round((w + h) div 50));;
           bAutoOverlap := false;
         end;
         IEPROC_EX_IE_MEDIANSHARPEN_ID:
         begin
           MtEnabled := mtAlwaysEnabled;
           theOverlap := max(5, params.Param_Byname(IEPROC_EX_IE_MEDIANSHARPEN_WINDOW).GetValue_int);
           bAutoOverlap := false;
         end;
         IEPROC_EX_IE_MEDIAN_ID:
         begin
           MtEnabled := mtAlwaysEnabled;
           theOverlap := max(5, params.Param_Byname(IEPROC_EX_IE_MEDIAN_WINDOW).GetValue_int);
           bAutoOverlap := false;
         end;

         IEPROC_EX_IE_HSLVAR_ID, IEPROC_EX_IE_HSVVAR_ID, IEPROC_EX_IE_NEGATIVE_ID,
         IEPROC_EX_IE_INTENSITYRGBALL_ID, IEPROC_EX_IE_INTENSITY_ID, IEPROC_EX_IE_CONTRAST_ID,
         IEPROC_EX_IE_CONTRAST2_ID, IEPROC_EX_IE_CONTRAST3_ID, IEPROC_EX_IE_GAMMACORRECT_ID,
         IEPROC_EX_IE_COLORIZE_ID, IEPROC_EX_IE_BRIGHTNESS_CONTRAST_SATURATION_ID, IEPROC_EX_IE_ADJUST_TINT_ID,
         IEPROC_EX_IE_ADJUST_SATURATION_ID, IEPROC_EX_IE_ADJUST_TEMPERATURE_ID,
       //  IEPROC_EX_IE_ADJUST_LUM_SAT_HISTOGRAM_ID,
         IEPROC_EX_IE_WHITEBALANCE_COEF_ID:
         begin
           MtEnabled := mtAlwaysEnabled;
           theOverlap := 0;
           bAutoOverlap := false;
         end;
         IEPROC_EX_IE_AUTOSHARP_ID:
         begin
           MtEnabled := mtAlwaysEnabled;
           theOverlap := 5; //5 pixels
           bAutoOverlap := true;
         end;
         IEPROC_EX_IE_SHARPEN_ID:
         begin
           MtEnabled := mtAlwaysEnabled;
           theOverlap := max(5, params.Param_Byname(IEPROC_EX_IE_SHARPEN_WINDOW).GetValue_int);
           bAutoOverlap := true;
         end;
         IEPROC_EX_IE_FINDEDGES_ID:
         begin
           MtEnabled := mtDisabled;

         end;
         IEPROC_EX_IE_WHITEBALANCE_GRAYWORLD_ID, IEPROC_EX_IE_WHITEBALANCE_AUTOWHITE_ID,
          IEPROC_EX_IE_AUTOIMAGEENHANCE1_ID, IEPROC_EX_IE_AUTOIMAGEENHANCE2_ID:
         begin
           MtEnabled := mtDisabled;
         end;
         
         IEPROC_EX_IE_AUTOIMAGEENHANCE3_ID :
         begin
           MtEnabled := mtAlwaysEnabled;
           theOverlap := max(10, round((w + h) div 45));
           bAutoOverlap := false;
         end;
       end;
    end;
   //--------------------------------------------------------------------------------


   function TIEProc_EX_Filter_Collection.AddFilter: TIEProc_EX_Filter;
   begin
      result := TIEProc_EX_Filter.create;
      fFilters.add(result);
   end;

   procedure TIEProc_EX_Filter_Collection.AddFilter(filter:TIEProc_EX_Filter);
   begin
     fFilters.Add(filter);
   end;

   procedure TIEProc_EX_Filter_Collection.RemoveFilter(filter: TIEProc_EX_Filter);
   begin
     fFilters.Remove(filter);
   end;

   function TIEProc_EX_Filter_Collection.GetLocked: boolean;
   begin
     result := fUpdLock > 0;
   end;

   function TIEProc_EX_Filter_Collection.GetCount: integer;
   begin
     result := ffilters.count;
   end;

   function TIEProc_EX_Filter_Collection.GetFilter(idx: integer): TIEProc_EX_Filter;
   begin
      assert(idx< fFilters.count);
      result := TIEProc_EX_Filter(fFilters[idx]);
   end;

   procedure TIEProc_EX_Filter_Collection.SetFilter(idx: integer; theFilter: TIEProc_EX_Filter);
   begin
     assert(idx< fFilters.count);
    // TIEProc_EX_Filter(fFilters[idx]).assign(theFilter);
     fFilters[idx] := TIEProc_EX_Filter(theFilter);
   end;

   Constructor TIEProc_EX_Filter_Collection.Create;
   begin
     inherited Create;
     fUpdLock := 0;
     fName := '';
     fUserCaption := '';
     fFilters := TObjectList.create(true);
   end;

   Destructor TIEProc_EX_Filter_Collection.Destroy;
   begin
     fFilters.free;
   inherited Destroy;
   end;

   function TIEProc_EX_Filter_Collection.GetActiveCount:integer;
   var
   I: Integer;
   begin
     result := 0;
     for I := 0 to fFilters.Count-1 do
        if TIEProc_EX_Filter(ffilters[i]).active then
           inc(result);
   end;

  function TIEProc_EX_Filter_Collection.FilterById(
  FilterId: integer): TIEProc_EX_Filter;
var
  I: Integer;
  begin
     result := nil;
     for I := 0 to ffilters.Count-1 do
     begin
        if TIEProc_EX_Filter(ffilters[i]).ID = FilterId then
        begin
           result := TIEProc_EX_Filter(ffilters[i]);
           break;
        end;
     end;
  end;

procedure TIEProc_EX_Filter_Collection.Assign(Source: TPersistent);
    var
  src: TIEProc_EX_Filter_Collection;
  begin
    if source is TIEProc_EX_Filter_Collection then
    begin
      src := TIEProc_EX_Filter_Collection(Source);

      fFilters.Assign(src.fFilters);

      OnFilterUpdate := src.OnFilterUpdate;
     {}

    end
    else
      inherited;

   end;

   Procedure TIEProc_EX_Filter_Collection.Update;
   begin
      if Locked then EXIT;

      if assigned(OnFilterUpdate) then OnFilterUpdate(self);
   end;

   Procedure TIEProc_EX_Filter_Collection.Update_Lock;
   begin
     inc(fUpdLock);
   end;

   Procedure TIEProc_EX_Filter_Collection.Update_Unlock(DoUpdate: boolean);
   begin
     dec(fUpdLock);
     if fupdLock<0 then
       fUpdLock := 0;

     if DoUpdate then
       Update;
   end;


{ TIEProc_EX_Filter_BaseCustom }

procedure TIEProc_EX_Filter_BaseCustom.Abort;
begin

end;

procedure TIEProc_EX_Filter_BaseCustom.Process(bitmap: TIEBitmap; EditRect: Trect;
                                               FilterProgress: TIEProgressEvent);
begin

end;







end.
