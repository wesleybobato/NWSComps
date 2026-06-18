(* -----------------------------------------------------------------------------
  NWSComps Proc Filter Library Demo
  Credits for icons , and part of GUI: William Miller, Adirondack Software & Graphics
  --------------------------------------------------------------------------- *)
unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons, jpeg, ComCtrls, ieview, ExtDlgs, UITypes,
  imageenview, imageen, imageenproc, ImgList, ToolWin, ieopensavedlg, GIFImg,
  Spin, nwscomps_proc, NWSComps_Proc_Filter_Types, NWSComps_Proc_Filter_Lib,
  NWSComps_Proc_Filter_Lib_Const,NWSComps_IEUtils_Previews,  NWSComps_RGBCurves, NWSComps_RGBCurves_Types,
  hyieutils, hyiedefs, iesettings, iexBitmaps, myCustomFilters, iexLayers,
  iexRulers, NWSComps_FiltersPanel;

type
  TForm1 = class(TForm)
    Panel2: TPanel;
    Panel3: TPanel;
    ImageEnView1: TImageEnView;
    Panel6: TPanel;
    IEProcEX1: TIEProc_EX;
    ImageList1: TImageList;
    Panel4: TPanel;
    Panel5: TPanel;
    OpenImageEnDialog1: TOpenImageEnDialog;
    SaveImageEnDialog1: TSaveImageEnDialog;
    Open1: TButton;
    AddTransparentLayer1: TButton;
    AddLayer1: TButton;
    RemoveLayer1: TButton;
    Redo1: TButton;
    Undo1: TButton;
    ProgressBar1: TProgressBar;
    Deselect1: TButton;
    Panel1: TPanel;
    FiltersPanel1: TIEProc_EX_FiltersPanel;
    Panel_Curves: TPanel;
    RGBCurves1: TRGBCurves;
    ToolBar1: TToolBar;
    ToolButtonCurveLum: TToolButton;
    ToolButtonCurveRed: TToolButton;
    ToolButtonCurveGreen: TToolButton;
    ToolButtonCurveBlue: TToolButton;
    Panel7: TPanel;
    TogglePreview1: TSpeedButton;
    Apply1: TButton;
    btnResetSliders: TSpeedButton;
    CheckBox_MT: TCheckBox;
    SpinEdit_NThreads: TSpinEdit;
    SaveResult1: TButton;
    ToolBar2: TToolBar;
    tbPanZoom: TToolButton;
    tbSelectLasso: TToolButton;
    tbMoveLayer: TToolButton;
    ImageList2: TImageList;
    tbRotateLayer: TToolButton;
    tbSelectSquare: TToolButton;
    tbSelectWand: TToolButton;
    CbMTMode: TComboBox;
    ToolBar3: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;

    procedure FormCreate(Sender: TObject);
    procedure AddLayer1Click(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure AddTransparentLayer1Click(Sender: TObject);
    procedure TogglePreview1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure TogglePreview1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure SaveResult1Click(Sender: TObject);
    procedure Apply1Click(Sender: TObject);
    procedure IEProcEX1Filter_Progress(Sender: TObject; per: integer);
    procedure IEProcEX1Filter_FinishWork(Sender: TObject);
    procedure Undo1Click(Sender: TObject);
    procedure Redo1Click(Sender: TObject);
    procedure Reset1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure RemoveLayer1Click(Sender: TObject);
    procedure ImageEnView1LayerNotify(Sender: TObject; layer: integer;
      event: TIELayerEvent);
    procedure Deselect1Click(Sender: TObject);
    procedure ImageEnView1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RGBCurves1ChangeCurve(Sender: TObject);
    procedure ToolButtonCurveLumClick(Sender: TObject);
    procedure CheckBox_MTClick(Sender: TObject);
    procedure SpinEdit_NThreadsChange(Sender: TObject);
    procedure btnResetSlidersClick(Sender: TObject);
    procedure tbRotateLayerClick(Sender: TObject);
    procedure tbSelectLassoClick(Sender: TObject);
    procedure tbPanZoomClick(Sender: TObject);
    procedure tbMoveLayerClick(Sender: TObject);
    procedure tbSelectWandClick(Sender: TObject);
    procedure tbSelectSquareClick(Sender: TObject);
    procedure ImageEnView1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImageEnView1SelectionChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CbMTModeClick(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure RGBCurves1Click(Sender: TObject);
  private
    { Private declarations }

    fFilterList: TIEProc_EX_Filter_Collection;

    procedure UpdateGUI;
    procedure Undo;
    procedure Redo;
    procedure HandleFilterProgress(Sender: TObject; per: integer);
    procedure ResetFiltersToDefault;
    procedure AddLayer(const Opacity: byte);
    procedure HandleFiltersPanelCustomInsert(Filter:TIEProc_EX_Filter;  var ControlToInsert: TControl);
    procedure HandleAddFilterParam(Filter:TIEProc_EX_Filter; Param:TIEProc_EX_Filter_Param; var bCanAdd:boolean);

    procedure CheckCurvesActive;

    procedure ChangeMouseInteract(miGen: TIEMouseInteract; miLay:TIEMouseInteractLayers);

    procedure ChangeCurveMode;
    procedure SetMultiThread;
    procedure  SetCustomFilterWithPAramMax;

  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses math,  imageenio, inifiles, activex, shlobj, NWSComps_MultiThreadProc;

{$R *.DFM}



procedure TForm1.SetMultiThread;
begin
  IEProcEX1.MultiThreadEnabled := CheckBox_MT.checked;
  IEProcEX1.MultiThreadNrThreads := SpinEdit_NThreads.Value;
  if CbMTMode.ItemIndex = 0 then
    IEProcEX1.MultiThreadDefOverlapMethod := omAddExtraPixels
  else
     IEProcEX1.MultiThreadDefOverlapMethod := omAddExtraThreads;
  ImageEnView1.Refresh;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  IEProcEX1.Preview_Unregister;
end;

procedure TForm1.FormCreate(Sender: TObject);
{ Initialize. }
begin
  SetMultiThread;
  IEProcEX1.AutoUndo := false;
  ImageEnView1.Proc.AutoUndo := true;
  Imageenview1.MagicWandTolerance := 80;
  ImageEnView1.Proc.UndoLimit := 100;

  OpenImageEnDialog1.Filter := GraphicFilter(TGraphic);
  SaveImageEnDialog1.Filter := GraphicFilter(TGraphic);
  RGBCurves1.ShowHistogram := true;
  RGBCurves1.ExportDirectory := '\Presets';

  { Create the collection and add filters }
  fFilterList := TIEProc_EX_Filter_Collection.Create;

    //adding a filter to the filterlist will change its owner:
    // you do not have to free it later on, the filterlist does it when it is destroyed

    fFilterList.AddFilter(TIEProc_EX_Filter_IE_AutoImageEnhance2.Create);
    fFilterList.AddFilter(TIEProc_EX_Filter_IE_AutoImageEnhance3.Create);
    fFilterList.AddFilter(TIEProc_EX_Filter_IE_WhiteBalance_AutoWhite.Create);
    fFilterList.AddFilter(TIEProc_EX_Filter_IE_WhiteBalance_Grayworld.Create);
    fFilterList.AddFilter(TIEProc_EX_Filter_IE_WhiteBalance_coef.Create);
    fFilterList.AddFilter(TIEProc_EX_Filter_AutoColor.Create);
    fFilterList.AddFilter(TIEProc_EX_Filter_IE_GammaCorrect.create);
    fFilterList.AddFilter(TIEProc_EX_Filter_ColorFilter.Create);
    fFilterList.AddFilter(TIEProc_EX_Filter_IE_AdjustTemperature.Create);
    fFilterList.AddFilter(TIEProc_EX_Filter_IE_HSVVar.Create);
    fFilterList.AddFilter(TIEProc_EX_Filter_RGBBalance.Create);
    fFilterList.AddFilter(TMyCustomFilter_RGBCurves.Create(RGBCurves1));
    fFilterList.AddFilter(TIEProc_EX_Filter_SmartFlash.Create);
    fFilterList.AddFilter(TIEProc_EX_Filter_SmartContrast.Create);
    fFilterList.AddFilter(TIEProc_EX_Filter_IE_UnsharpMask.Create);
    fFilterList.AddFilter(TIEProc_EX_Filter_IE_Sharpen.Create);
    fFilterList.AddFilter(TIEProc_EX_Filter_ReduceHighlights.Create);
    fFilterList.AddFilter(TIEProc_EX_Filter_FillBackLight.Create);
    fFilterList.AddFilter(TMyCustomFilter_Sepia.Create);
    fFilterList.AddFilter(TMyCustomFilter_WithParam.create);


    ResetFiltersToDefault; //Set Active= false for all filters and change the params to default value
    SetCustomFilterWithPAramMax;
    IEProcEX1.Preview_Register(ImageEnView1, fFilterList);
   //Register the filters for previewing with imageenview by IEProcEx1


  //assign the filters to Filters Panel
  with FiltersPanel1 do
  begin
    OnCustomInsert := HandleFiltersPanelCustomInsert; //we use this to insert our RGBCurves panel
    OnAddFilterParam := HandleAddFilterParam; //to check which parameters we do not want in the GUI
    FilterList := fFilterList;  //Assign the Filter List: Creates automatically the filters GUI
  end;

  UpdateGUI;
  SetMultiThread;
end;

procedure TForm1.HandleFiltersPanelCustomInsert(Filter:TIEProc_EX_Filter;  var ControlToInsert: TControl);
begin
  if Filter.ID = CUSTOMFILTER_RGBCURVES then
    ControlToInsert := Panel_Curves;
end;

procedure TForm1.HandleAddFilterParam(Filter:TIEProc_EX_Filter; Param:TIEProc_EX_Filter_Param; var bCanAdd:boolean);
begin
   if Filter.ID = IEPROC_EX_IE_AUTOIMAGEENHANCE1_ID then
   begin
     bCanAdd := false; //no parameters for autoenhance (use default)
   end
   else if Filter.ID = IEPROC_EX_IE_AUTOIMAGEENHANCE2_ID then
   begin
     bCanAdd := false; //no parameters for autoenhance  (use default)
   end
   else if Filter.ID = IEPROC_EX_IE_GAMMACORRECT_ID then
   begin
     bCanAdd := Param.Name = IEPROC_EX_IE_GAMMACORRECT_GAMMA; //only the Gamma amount
   end
   else if filter.ID = IEPROC_EX_RGBBALANCE_ID then
   begin
     bCanAdd := Param.Name <> IEPROC_EX_RGBBALANCE_UNIFORM;
   end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
   fFilterList.Free;
end;

procedure TForm1.SpinEdit_NThreadsChange(Sender: TObject);
begin
  SetMultiThread;
end;



procedure TForm1.tbPanZoomClick(Sender: TObject);
begin
  ChangeMouseInteract([miZoom, miScroll],[]);
end;

procedure TForm1.tbMoveLayerClick(Sender: TObject);
begin
ChangeMouseInteract([],[miMoveLayers, miResizeLayers]);
end;

procedure TForm1.tbRotateLayerClick(Sender: TObject);
begin
  ChangeMouseInteract([],[miRotateLayers]);

end;

procedure TForm1.tbSelectLassoClick(Sender: TObject);
begin
  ChangeMouseInteract([miSelectLasso],[]);
end;

procedure TForm1.tbSelectSquareClick(Sender: TObject);
begin
  ChangeMouseInteract([miSelect],[]);

end;

procedure TForm1.tbSelectWandClick(Sender: TObject);
begin
  ChangeMouseInteract([miSelectMagicWand],[]);
end;

procedure TForm1.ChangeMouseInteract(miGen: TIEMouseInteract; miLay:TIEMouseInteractLayers);
begin
   ImageEnView1.MouseInteractGeneral := miGen;
   ImageEnView1.MouseInteractLayers := miLay;
end;

procedure TForm1.UpdateGUI;
{ Update the state of GUI buttons. }
begin
    Deselect1.Enabled := imageenview1.Selected;
    tbMoveLayer.Enabled := (ImageEnView1.LayersCount > 1);
    tbRotateLayer.Enabled :=  (ImageEnView1.LayersCount > 1)and (ImageEnView1.CurrentLayer.GetIndex > 0);
    RemoveLayer1.Enabled := (ImageEnView1.LayersCount > 1)and (ImageEnView1.CurrentLayer.GetIndex > 0);

    Redo1.Enabled := imageenview1.Proc.RedoCount > 0;
    Undo1.Enabled := imageenview1.Proc.UndoCount > 0;

end;

procedure TForm1.Undo;
{ Undo last edit. }
begin

    IEProcEX1.Preview_Lock;
    try
      imageenview1.Proc.SaveRedo;
      imageenview1.Proc.Undo;
      imageenview1.Proc.ClearUndo;
      UpdateGUI;
    finally
      IEProcEX1.Preview_Unlock;
    end;
end;

procedure TForm1.Redo;
{ Redo A last undo. }
begin

    IEProcEX1.Preview_Lock;
    try
      imageenview1.Proc.SaveUndo;
      imageenview1.Proc.Redo;
      imageenview1.Proc.ClearRedo;
      UpdateGUI;
    finally
      IEProcEX1.Preview_Unlock;
    end;

end;



procedure TForm1.HandleFilterProgress(Sender: TObject; per: integer);
{ HandleFilterProgress. }
begin
  ProgressBar1.Position := per;
end;



procedure TForm1.Reset1Click(Sender: TObject);
{ Reset. }
begin
  ResetFiltersToDefault;
end;

procedure TForm1.ResetFiltersToDefault;
{ Reset trackbars. }
var
I:integer;
filter: TIEProc_EX_Filter;
param : TIEProc_EX_Filter_Param;
  j: Integer;
begin
  if assigned(fFilterList) then
    fFilterList.Update_Lock;    //this temporarily suspends any update of the filters
                                  // to allow the sliders to be reset without updating the preview
  try
    for I := 0 to fFilterList.Count-1 do
    begin
      filter := fFilterList.Filter[i];
      filter.Active := false;
      for j := 0 to filter.Params.Count-1 do
      begin
        param := filter.Params.Params[j];
        if param.Has_Default then
          filter.SetParamValue(param.Name, param.DefValue);
      end;
    end;

    //RGBCurves being an external component needs its own reset
    RGBCurves1.ResetPoints;
    ToolButtonCurveLum.Down := true;

    FiltersPanel1.UpdateFromFilters; //update sliders in the filters panel

  finally
    if assigned(fFilterList) then
      fFilterList.Update_UnLock(False);    //Remove lock
  end;
end;

procedure TForm1.RGBCurves1ChangeCurve(Sender: TObject);
begin
  fFilterList.Update;
end;



procedure TForm1.AddLayer(const Opacity: byte);
{ Add a layer. }
begin
  if OpenImageEnDialog1.Execute then
  begin

     IEProcEX1.Preview_Lock; //when changing the content of the imageenview (i.e. adding a new layer)
                          // if the TIEProc_Ex component is registered with the imageenview
                             //you need to put the code inside a Preview_Lock...Preview_Unlock
    try
      ImageEnView1.LayersCurrent := ImageEnView1.LayersAdd;
      ImageEnView1.layers[ImageEnView1.LayersCurrent].Transparency := Opacity;
      ImageEnView1.IO.LoadFromFile(OpenImageEnDialog1.FileName);
      SetCustomFilterWithPAramMax;
    finally
      IEProcEX1.Preview_Unlock;
    end;
  end;
end;

procedure TForm1.TogglePreview1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
{ Toggle preview off. Handle RGBCurves or IEProcEX Preview_Toggle. }
begin
    IEProcEX1.Preview_Toggle(False);
end;

procedure TForm1.TogglePreview1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
{ Toggle preview on. Handle RGBCurves or IEProcEX Preview_Toggle. }
begin
    IEProcEX1.Preview_Toggle(True);
end;

procedure TForm1.ToolButton1Click(Sender: TObject);
begin
  if (RGBCurves1.ImportCurves) then
     CheckCurvesActive;
end;

procedure TForm1.RGBCurves1Click(Sender: TObject);
begin
  CheckCurvesActive;
end;

procedure TForm1.CheckCurvesActive;
begin
  fFilterList.FilterById(CUSTOMFILTER_RGBCURVES).Active := true;
  FiltersPanel1.UpdateFromFilters;
  fFilterList.Update;
end;

procedure TForm1.ToolButton2Click(Sender: TObject);
begin
  RGBCurves1.ExportCurves;
end;

procedure TForm1.ToolButtonCurveLumClick(Sender: TObject);
begin
  ChangeCurveMode;
end;

procedure TForm1.CbMTModeClick(Sender: TObject);
begin
SetMultiThread;
end;

procedure TForm1.ChangeCurveMode;
begin
  if ToolButtonCurveLum.Down then
    RGBCurves1.RGBMode := cmAll
  else if ToolButtonCurveRed.Down then
    RGBCurves1.RGBMode := cmRed
  else if ToolButtonCurveGreen.Down then
    RGBCurves1.RGBMode := cmGreen
  else if ToolButtonCurveBlue.Down then
    RGBCurves1.RGBMode := cmBlue;
end;

procedure TForm1.SaveResult1Click(Sender: TObject);
{ Save A image to disk. }
begin
  Apply1.Click;
  if SaveImageEnDialog1.Execute then
    ImageEnView1.IO.SaveToFile(SaveImageEnDialog1.FileName);
end;

procedure TForm1.AddLayer1Click(Sender: TObject);
{ Add a layer. }
begin
  AddLayer(255);
  UpdateGUI;
end;

procedure TForm1.AddTransparentLayer1Click(Sender: TObject);
{ Add a transparent layer. }
begin
  AddLayer(180);
  UpdateGUI;
end;

procedure TForm1.IEProcEX1Filter_FinishWork(Sender: TObject);
{ IEProc_EX1Filter_FinishWork. }
begin
  ProgressBar1.Position := 0;
  UpdateGUI;
end;

procedure TForm1.IEProcEX1Filter_Progress(Sender: TObject; per: integer);
{ IEProc_EX1Filter_Progress. }
begin
  HandleFilterProgress(Sender, per);
end;

procedure TForm1.ImageEnView1LayerNotify(Sender: TObject; layer: integer;
  event: TIELayerEvent);
{ ImageEnView1LayerNotify. }
begin
  if (event = ielSelected) then
  begin
      RGBCurves1.GetHistogramfromIEBMP(imageenview1.IEBitmap);
      SetCustomFilterWithPAramMax;
      UpdateGUI;
  end;

end;

procedure  TForm1.SetCustomFilterWithPAramMax;
begin
  fFilterList.FilterById(CUSTOMFILTER_WITHPARAM).Params.Param_Byname(CUSTOMPARAM_X).SetMax(imageenview1.IEBitmap.Width);
  fFilterList.FilterById(CUSTOMFILTER_WITHPARAM).Params.Param_Byname(CUSTOMPARAM_Y).SetMax(imageenview1.IEBitmap.Height);
  FiltersPanel1.UpdateFromFilters;
end;

procedure TForm1.ImageEnView1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if miSelectMagicWand in ImageEnView1.MouseInteract then
    IEProcEX1.Preview_Toggle(false);
end;

procedure TForm1.ImageEnView1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  UpdateGUI;
end;

procedure TForm1.ImageEnView1SelectionChange(Sender: TObject);
begin
   if miSelectMagicWand in ImageEnView1.MouseInteract then
    IEProcEX1.Preview_Toggle(true);
end;

procedure TForm1.Redo1Click(Sender: TObject);
{ Redo A last undo. }
begin
  Redo;
end;

procedure TForm1.RemoveLayer1Click(Sender: TObject);
{ Remove Current Layer. }
begin
    IEProcEX1.Preview_Lock;
    try
      ImageEnView1.LayersRemove(ImageEnView1.LayersCurrent);
    finally
      IEProcEX1.Preview_Unlock;
    end;
  
  UpdateGUI;
end;

procedure TForm1.Undo1Click(Sender: TObject);
{ Undo A last edit. }
begin
  Undo;
end;

procedure TForm1.Apply1Click(Sender: TObject);
{ Apply changes. }
begin
    screen.Cursor := crHourGlass;
    IEProcEX1.Preview_Lock;
    try

       imageenview1.Proc.SaveUndo;
       imageenview1.Proc.ClearAllRedo;


      IEProcEX1.Preview_Apply;
      RGBCurves1.GetHistogramfromIEBMP(imageenview1.IEBitmap);
      ResetFiltersToDefault;
    finally
      IEProcEX1.Preview_Unlock;
      Screen.Cursor := crDefault;
    end;

  UpdateGUI;
end;

procedure TForm1.btnResetSlidersClick(Sender: TObject);
begin
  ResetFiltersToDefault;
end;

procedure TForm1.Deselect1Click(Sender: TObject);
begin
  ImageEnView1.DeSelect;
  ImageEnView1.Update;
  UpdateGUI;
end;

procedure TForm1.CheckBox_MTClick(Sender: TObject);
begin
  SetMultiThread;
end;

procedure TForm1.Open1Click(Sender: TObject);
{ Open image. }
begin
  if OpenImageEnDialog1.Execute then
  begin
    Screen.Cursor := crHourGlass;
    try

      IEProcEX1.Preview_Lock;
      try
        { Load image into A current layer }
      ImageEnView1.LayersCurrent := 0;
      ImageEnView1.IO.LoadFromFile(OpenImageEnDialog1.FileName);
      RGBCurves1.GetHistogramfromIEBMP(ImageEnView1.IEBitmap);
      SetCustomFilterWithPAramMax;
      ResetFiltersToDefault;
      finally
         IEProcEX1.Preview_Unlock;

      end;

      ImageEnView1.Fit;

      UpdateGUI;
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

 initialization

 finalization
 //ReportMemoryLeaksOnShutdown := true;
end.
