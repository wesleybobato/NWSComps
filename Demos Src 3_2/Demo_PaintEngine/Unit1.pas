unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ieopensavedlg,hyieutils, hyiedefs, imageenproc, ieview, imageenview, imageen, StdCtrls, ComCtrls, ExtCtrls, //   iexbitmaps,
  HSVBox, jpeg, Spin, ToolWin, ImgList, Buttons, JH_WinTab, JH_WinTab_Const,
  XPMan,NWSComps_IEPaintEngine_manager, NWSComps_IEPaintEngine,
  NWSComps_IEPaintEngine_Types, NWSComps_IEPaintEngine_utils, iesettings,
  iexBitmaps, iexLayers, iexRulers;

type
  TbeBGRAByteArray = NWSComps_IEPaintEngine_utils.TbeBGRAByteArray;
  TEditmode = (emzoom, empaint, emselect, emmovelayer);

  TSimple_PE_Editor = class(TForm)
    Panel1: TPanel;
    PageControl1: TPageControl;
    TabColor: TTabSheet;
    TabTexture: TTabSheet;
    TabRetouch: TTabSheet;
    TabClone: TTabSheet;
    Shape1: TShape;
    Label1: TLabel;
    HSVBox1: THSVBox;
    Panel3: TPanel;
    SpinEdit_BrushOpacity: TSpinEdit;
    Label3: TLabel;
    SpinEdit_BrushRadius: TSpinEdit;
    Label4: TLabel;
    Label5: TLabel;
    SpinEdit_BrushFeather: TSpinEdit;
    Panel4: TPanel;
    Panel5: TPanel;
    ToolBar1: TToolBar;
    ToolButton_paint: TToolButton;
    ToolButton_zoom: TToolButton;
    ToolButton_Select: TToolButton;
    ImageList1: TImageList;
    ToolButton_MoveLayer: TToolButton;
    RadioGroup_Retouch: TRadioGroup;
    Label6: TLabel;
    Label_srcpoint: TLabel;
    TabHistory: TTabSheet;
    ComboBox_BlendMode_Color: TComboBox;
    Label7: TLabel;
    Label8: TLabel;
    ComboBox_BlendMode_Texture: TComboBox;
    ImageEnView2: TImageEnView;
    RadioGroup_BrushKind: TRadioGroup;
    btn_LoadBrush: TSpeedButton;
    ImageEnView3: TImageEnView;
    ImageEnView4: TImageEnView;
    Button5: TButton;
    Panel6: TPanel;
    Tab_EraseLayer: TTabSheet;
    RadioGroup_LayerEditMode: TRadioGroup;
    Panel2: TPanel;
    Label2: TLabel;
    Button_NewBackgroundFomFile: TButton;
    SpinEdit_zoom: TSpinEdit;
    Button_NewLayerFromFile: TButton;
    Button_DeleteLayer: TButton;
    Button_NewBlankTransparentLayer: TButton;
    btn_undo: TSpeedButton;
    btn_redo: TSpeedButton;
    CheckBox_LargeSteps: TCheckBox;
    Button7: TButton;
    ListBox1: TListBox;
    ImageEnView5: TImageEnView;
    JanHWinTab1: TJanHWinTab;
    Panel7: TPanel;
    Image1: TImage;
    Label9: TLabel;
    SpinEdit_TabletSensitivity: TSpinEdit;
    checkbox_Sensitive: TCheckBox;
    ImageList2: TImageList;
    Label10: TLabel;
    Panel8: TPanel;
    RadioGroup_CloneType: TRadioGroup;
    Button_LoadCloneSource: TButton;
    Panel9: TPanel;
    ButtonCloneResetTarget: TButton;
    ComboBox_BlendMode_Clone: TComboBox;

    Tab_Deformations: TTabSheet;
    RadioGroup_Deformations: TRadioGroup;
    PE_MANAGER: TImageEnPaintEngineManager;
    Memo1: TMemo;
    Memo2: TMemo;
    ImageEnView1: TImageEnView;
    OpenImageEnDialog1: TOpenImageEnDialog;
    GroupBox1: TGroupBox;
    Button_ResetSession: TButton;
    Label11: TLabel;
    SpinEdit_Step: TSpinEdit;
    Label12: TLabel;
    SpinEdit_Precision: TSpinEdit;
    CheckBox_RotateBrush: TCheckBox;
    Label13: TLabel;
    SpinEdit_WarpAmt: TSpinEdit;
    btn_Handwriting: TButton;
    btn_NormalPainting: TButton;
    RadioGroup_SessionMode: TRadioGroup;
    CheckBox_EnableAlpha: TCheckBox;
    CheckBox_DynOpacity: TCheckBox;
    CheckBox_DynRadius: TCheckBox;
    CheckBox_Spray: TCheckBox;
    procedure ImageEnView1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImageEnView1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button_NewBackgroundFomFileClick(Sender: TObject);

    procedure HSVBox1Change(Sender: TObject);

    procedure SpinEdit_zoomChange(Sender: TObject);
    procedure Button_NewLayerFromFileClick(Sender: TObject);
    procedure ToolButton_paintClick(Sender: TObject);
    procedure Button_DeleteLayerClick(Sender: TObject);
    procedure ImageEnView1ImageChange(Sender: TObject);
    procedure ImageEnView2MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button_LoadCloneSourceClick(Sender: TObject);
    procedure btn_undoClick(Sender: TObject);
    procedure btn_redoClick(Sender: TObject);
    procedure btn_LoadBrushClick(Sender: TObject);
    procedure RadioGroup_BrushKindClick(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button_NewBlankTransparentLayerClick(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure ImageEnView1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ImageEnView1ViewChange(Sender: TObject; Change: Integer);

    procedure ImageEnView2Paint(Sender: TObject);
    procedure ButtonCloneResetTargetClick(Sender: TObject);
    procedure ImageEnView1MouseLeave(Sender: TObject);
    procedure RadioGroup_CloneTypeClick(Sender: TObject);
    procedure PE_MANAGERStartedPainting(Sender: TObject);
    procedure PE_MANAGERFinishedPainting(Sender: TObject);


    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button_ResetSessionClick(Sender: TObject);
    procedure SpinEdit_StepChange(Sender: TObject);
    procedure CheckBox_LargeStepsClick(Sender: TObject);
    procedure btn_HandwritingClick(Sender: TObject);
    procedure btn_NormalPaintingClick(Sender: TObject);
    procedure SpinEdit_BrushRadiusChange(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
  private
    { Private declarations }


    fEditMode: Teditmode;
    fpeMode: tPeMode;



    fpeTextureBmp: TIebitmap;
    fpeHistoryBMP, fpeBrushBmp: TIebitmap;
    fpeBrushRadius: integer;

    fpe_Cloning_SrcPoint: tpoint;
    fpe_Cloning_TgtPoint: tpoint;
    fpe_Cloning_ResetTarget: boolean;


    fCursorRadius: integer;

    function CustomRetouch(const inputBGRA: TbeBGRAbytearray): TbeBGRAbytearray;


    procedure PeSet_HistoryBMP(theIEBitmap: TIEBitmap);
    procedure PeSet_CloningBMP(theIEView: TImageenView);
    procedure PeSet_TextureBMP(theIEBitmap: TIEBitmap);


    procedure PeSet_GraphicTabletSettings;
    procedure PeSet_GeneralSettings;
    procedure PeSet_BrushSettings;
    procedure PeSet_ModeSettings;

    procedure PE_StartPaintFrom(x, y: integer);
    procedure PE_StopPainting;


    procedure IEView_SetEditMode(sender: Tobject);
    procedure IEView_SetCurrentLayer(idx: integer);
    procedure IEView_ContentChanged(sender:TObject);

    procedure SaveUndo;
    procedure Undo;
    procedure Redo;

    function Convert_LayerIDXtoListIDX(LayIDX:integer):integer;
    function Convert_ListIDXtoLayerIDX(ListIDX:integer):integer;

    procedure RefreshUndoButtons;
    procedure Refresh_layerlist;
    procedure Refresh_LayerPreview(idx:integer);
    procedure CheckCloneType;
    function GetPeMode: TPeMode;

  public
    { Public declarations }
  end;

var
  Simple_PE_Editor: TSimple_PE_Editor;

implementation
uses  math,  NWSComps_IEPaintEngine_Const;

{$R *.DFM}

const
C_PTNOTDEF = -12345;

procedure AlphaChannelFill(ac:TIebitmap);
begin
  ac.PixelFormat := ie8g;
  ac.Fill(255);
 //trick to avoid ImageEn removing the alpha channel again after filling
 ac.Pixels_ie8[0,0] := 0;
 ac.Pixels_ie8[0,0] := 255;
end;

function Get_aLayerName(idx:integer): string;
begin
  result := 'Layer'+inttostr(idx);
end;
function TSimple_PE_Editor.CustomRetouch(const inputBGRA: TbeBGRAbytearray): TbeBGRAbytearray;
begin
  result[0] := min(255, inputBGRA[0] + PE_MANAGER.Params_Retouch.Amount);
  result[1] := InputBGRA[1];
  result[2] := InputBGRA[2];
end;


procedure TSimple_PE_Editor.PeSet_ModeSettings;
var
  di: TpeDeformationParams;
begin
  with PE_MANAGER do
  begin
    case PE_MANAGER.Params_Paint.mode of
      pemcolor: Params_Paint.Blendmode := Tbeblendmode(max(0, ComboBox_BlendMode_Color.itemindex));
      pemtexture: Params_Paint.Blendmode := Tbeblendmode(max(0, ComboBox_BlendMode_Texture.itemindex));
      pemclone: Params_Paint.Blendmode := Tbeblendmode(max(0, ComboBox_BlendMode_Clone.itemindex));
    else
      Params_Paint.Blendmode := blmnormal;
    end;

    Params_Color.Color := shape1.Brush.color;
    Params_Texture.Texturebitmap := fpeTextureBmp;

    Params_Cloning.srcPoint := fpe_Cloning_SrcPoint;
    if fpe_Cloning_ResetTarget then  //set the current point as the target clone point
      Params_Cloning.TgtPoint := fpe_Cloning_TgtPoint;

    case RadioGroup_Deformations.ItemIndex of
      0: Params_Warp.Kind := dk_WhirlCW;
      1: Params_Warp.Kind := dk_WhirlACW;
      2: Params_Warp.Kind := dk_Pinch;
      3: Params_Warp.Kind := dk_Bulge;
    end;

    Params_Warp.Amount := SpinEdit_WarpAmt.Value;

   case radiogroup_retouch.ItemIndex of
     0: Params_Retouch.Kind := rk_blur;
     1: Params_Retouch.Kind := rk_Sharpen;
     2: Params_Retouch.Kind := rk_dodge;
     3: Params_Retouch.Kind := rk_burn;
     4: Params_Retouch.Kind := rk_Lighten;
     5: Params_Retouch.Kind := rk_Darken;
     6: Params_Retouch.Kind := rk_Saturate;
     7: Params_Retouch.Kind := rk_Desaturate;
     8: Params_Retouch.Kind := rk_Custom;
   end;
   Params_Retouch.Amount := 100;
   Params_Retouch.RetouchCustom := CustomRetouch;
  end;
end;

procedure TSimple_PE_Editor.PeSet_GeneralSettings;
begin

  PE_MANAGER.Params_Paint.EnableAutoScroll := true;
  PE_MANAGER.Params_Paint.ShowBrushShape := true;
  PE_MANAGER.Params_Cloning.ShowBrush := True;
  PE_MANAGER.Params_Paint.SessionMode := tPeSessionMode(RadioGroup_SessionMode.ItemIndex);
  PE_MANAGER.Params_Paint.ContinuousPainting := false;  //paint even when the mouse does not move
  PE_MANAGER.Params_Paint.Selective := false; //here you can enable selectivity mode
  PE_MANAGER.Params_Paint.SelTolerance := 40;
  if CheckBox_Spray.Checked then
    PE_MANAGER.Params_Paint.SprayEffect := 100
  else
     PE_MANAGER.Params_Paint.SprayEffect := 0;
  //when this option is set to TRUE the alpha channel of the current layer will be also
  //affected by the painting (the "erase layer" mode is not affected by this parameter)
  PE_MANAGER.Params_Paint.EnableEditAlphaChannel := CheckBox_EnableAlpha.checked;

  //LargeSteps is used when you want to paint in a stamp-like fashion
  PE_MANAGER.Params_Paint.LargeSteps := CheckBox_LargeSteps.checked;
end;

procedure TSimple_PE_Editor.PageControl1Change(Sender: TObject);
begin
  fPeMode := GetPeMode; //read current painting mode from currently selected Tab
end;

procedure TSimple_PE_Editor.PeSet_BrushSettings;
var ieproc: Timageenproc;
begin
  PE_MANAGER.Params_Paint.Radius := SpinEdit_BrushRadius.value;

  if RadioGroup_BrushKind.itemindex = 0 then  // Use default round brush
    PE_MANAGER.Params_Paint.Brushbitmap := nil
  else
  begin // Create a brush from a TieBitmap
    fpeBrushBmp.AssignImage(Imageenview3.IEBitmap);
    ieproc := TImageEnProc.Create(nil);
    try
      ieproc.AttachedIEBitmap := fpeBrushBmp;
      ieproc.Resample(PE_MANAGER.Params_Paint.Radius * 2, PE_MANAGER.Params_Paint.Radius * 2, rflanczos3);
      PE_MANAGER.Params_Paint.Brushbitmap := fpeBrushBmp;
    finally
      ieproc.free;
    end;
  end;

  PE_MANAGER.Params_Paint.Step := max(1, round(SpinEdit_Step.Value / 100 * PE_MANAGER.Params_Paint.Radius));

  PE_MANAGER.Params_Paint.RotateBrush := CheckBox_RotateBrush.checked;
  PE_MANAGER.Params_Paint.Transparence := 255 - SpinEdit_BrushOpacity.value;
  PE_MANAGER.Params_Paint.Feather := SpinEdit_BrushFeather.Value;
//  PE_MANAGER.Params_Paint.Precision := 0;
  if(JanHWinTab1.active and JanHWinTab1.InProximity)   then
     PE_MANAGER.Params_Paint.Precision := 0
  else
     PE_MANAGER.Params_Paint.Precision := SpinEdit_Precision.Value;
end;


procedure TSimple_PE_Editor.PeSet_GraphicTabletSettings;
begin
  // Set the graphic tablet if any
  //JanHWinTab1 active property must be set to true in order to work
  PE_MANAGER.Params_Tablet.Tablet := JanHWinTab1;
  PE_MANAGER.Params_Tablet.PressureVar := SpinEdit_TabletSensitivity.value;
  PE_MANAGER.Params_Tablet.PressureSensitive := checkbox_Sensitive.checked;

  PE_MANAGER.Params_Tablet.PressureDynamics := [];
  if CheckBox_DynOpacity.checked then
    PE_MANAGER.Params_Tablet.PressureDynamics := PE_MANAGER.Params_Tablet.PressureDynamics + [pdBrushOpacity];

  if CheckBox_DynRadius.checked then
    PE_MANAGER.Params_Tablet.PressureDynamics := PE_MANAGER.Params_Tablet.PressureDynamics + [pdBrushRadius];


end;

procedure TSimple_PE_Editor.PeSet_HistoryBMP(theIEBitmap: TIEBitmap);
begin
  fpeHistoryBMP.Assign(theIEBitmap);
  PE_MANAGER.Params_History.Historybitmap := fpeHistoryBMP;
  if PE_Manager.Params_Paint.Mode = pemHistory then
    PE_MANAGER.Session_Reset;
end;

procedure TSimple_PE_Editor.PeSet_CloningBMP(theIEView: TImageenView);
begin
  PE_MANAGER.Params_Cloning.SrcImageEn := theIEView;
  if PE_Manager.Params_Paint.Mode = pemClone then
    PE_MANAGER.Session_Reset;
end;

procedure  TSimple_PE_Editor.PeSet_TextureBMP(theIEBitmap: TIEBitmap);
begin
    fpeTextureBmp.Assign(theIEBitmap);
    fpeTextureBmp.PixelFormat := ie24RGB;
    PE_MANAGER.Params_Texture.TextureBitmap := fpeTextureBmp;
    if PE_Manager.Params_Paint.Mode = pemTexture then
      PE_MANAGER.Session_Reset;
end;


procedure TSimple_PE_Editor.PE_StartPaintFrom(x, y: integer);
begin

  if PE_MANAGER.IsRunning then exit; // in case there is still some painting on we must exit

  if fpe_Cloning_ResetTarget then  //set the current point as the target clone point
    fpe_Cloning_TgtPoint := point(imageenview1.XScr2Bmp(x), imageenview1.YScr2Bmp(y));


  //*STEP1* Initialize the Engine
  // It is important to always Initialize the engine: some internal check
  // on imageenview and the painting mode needs to be performed
   //-----------------------------------------
  PE_MANAGER.Init(imageenview1, fpeMode);
  //-----------------------------------------

  //*STEP2* Setup the engine parameters
  PeSet_GraphicTabletSettings;
  PeSet_GeneralSettings;
  PeSet_BrushSettings; //Set all brush related parameters
  PeSet_ModeSettings;  //Set Painting Mode related parameters

  //*STEP3*  start paint engine! the painting process will start.
  PE_MANAGER.StartPainting;
end;


procedure TSimple_PE_Editor.PE_StopPainting;
begin
  //here we Stop the paint engine
  if PE_MANAGER.IsRunning then
    PE_MANAGER.stoppainting;
end;

procedure TSimple_PE_Editor.PE_MANAGERFinishedPainting(Sender: TObject);
begin
  // Here painting has really stopped

  ImageEnView1.Refresh;
  self.caption := 'Edited Rect: Rect(' + 'Left ' + inttostr(PE_MANAGER.EditedRect.Left) + ',' + 'Right ' + inttostr(PE_MANAGER.EditedRect.Right) + ','
    + 'Top ' + inttostr(PE_MANAGER.EditedRect.top) + ',' + 'Bottom ' + inttostr(PE_MANAGER.EditedRect.Bottom) + ')';

 IEView_ContentChanged(PE_Manager);

end;


procedure TSimple_PE_Editor.PE_MANAGERStartedPainting(Sender: TObject);
begin
  // painting has really started
  SaveUndo; // we save undo here

  fpe_Cloning_ResetTarget := false;
end;






procedure TSimple_PE_Editor.IEView_SetEditMode(sender: Tobject);
begin

  if sender = ToolButton_paint then fEditMode := empaint
  else
    if sender = ToolButton_zoom then fEditMode := emzoom
    else
      if sender = ToolButton_Select then
        fEditMode := emselect
      else
        if sender = ToolButton_MoveLayer then fEditMode := emmovelayer;

  case fEditMode of
    empaint:
      begin
        imageenview1.MouseInteractGeneral := [];
        imageenview1.MouseInteractLayers := [];
        imageenview1.cursor := crcross;

      end;
    emzoom:
    begin
      imageenview1.MouseInteractGeneral := [miZoom, miscroll];
      imageenview1.MouseInteractLayers := [];
    end;
    emselect:
    begin
      imageenview1.MouseInteractGeneral := [miSelectLasso];
      imageenview1.MouseInteractLayers := [];
    end;
    emmovelayer:
    begin
       imageenview1.MouseInteractGeneral := [];
       imageenview1.MouseInteractLayers := [miMoveLayers, miResizeLayers];
    end;
  end;

  if fEditMode = empaint then
    PE_MANAGER.StartCursorNoPaint(imageenview1, SpinEdit_BrushRadius.Value)
  else
    PE_MANAGER.StopCursorNoPaint;

  ImageEnView1.Update;
end;

procedure TSimple_PE_Editor.IEView_SetCurrentLayer(idx: integer);
begin
  imageenview1.LayersCurrent := idx;
  listbox1.itemindex := Convert_LayerIDXtoListIDX(idx);

  if PE_MANAGER.Params_Paint.Mode = pemClone then
  begin
    fpe_Cloning_ResetTarget := True;
    CheckCloneType;
  end;

  Refresh_LayerPreview(idx);
  PE_MANAGER.Session_Reset;
end;

procedure TSimple_PE_Editor.SaveUndo;
begin
  imageenview1.Proc.SaveUndo;
  imageenview1.Proc.ClearAllRedo;
  RefreshUndoButtons;
end;


procedure TSimple_PE_Editor.Undo;
begin
  imageenview1.Proc.SaveRedo;
  imageenview1.Proc.Undo;
  imageenview1.Proc.ClearUndo;

  RefreshUndoButtons;
end;


procedure TSimple_PE_Editor.Redo;
begin
  imageenview1.Proc.SaveUndo;
  imageenview1.Proc.Redo;
  imageenview1.Proc.ClearRedo;

  RefreshUndoButtons;
end;



procedure TSimple_PE_Editor.FormCreate(Sender: TObject);
var
  appdir: string;
  tempbmp: tiebitmap;
begin
  pagecontrol1.ActivePageIndex := 0;

  fpeTextureBmp := tIebitmap.create;
  fpeHistoryBMP := tIEbitmap.create;
  fpeBrushBmp := TIEBitmap.Create;

  feditmode := empaint;

  fpe_Cloning_ResetTarget:= true;
  fpe_Cloning_SrcPoint := point(C_PTNOTDEF, C_PTNOTDEF);

  //imageenview1.LayersSync := false;
  Imageenview1.Proc.UndoLocation := ieMemory;
  Imageenview1.Proc.UndoLimit := 20;
  ImageEnView1.IEBitmap.width := 1250;
  ImageEnView1.IEBitmap.height := 1250;
  imageenview1.IEBitmap.FillRect(0,0, 1250, 1250, rgb(255, 255, 255));
  imageenview1.IEBitmap.AlphaChannel.FillRect(0,0, 1250, 1250, rgb(0, 0, 0));

  appdir := extractfilepath(paramstr(0));
  if fileexists(appdir + 'sampletexture.jpg') then
    imageenview4.IO.LoadFromFile(appdir + 'sampletexture.jpg');
  if fileexists(appdir + 'sampleClone.jpg') then
    imageenview2.IO.LoadFromFile(appdir + 'sampleclone.jpg');


  ComboBox_BlendMode_Color.ItemIndex := 0;
  ComboBox_BlendMode_Texture.ItemIndex := 0;
  ComboBox_BlendMode_Clone.ItemIndex := 0;

  RefreshUndoButtons;
  IEView_SetEditMode(ToolButton_paint);
end;


procedure TSimple_PE_Editor.FormDestroy(Sender: TObject);
begin
  PE_MANAGER.StopCursorNoPaint;
  fpeHistoryBMP.free;

  fpeTextureBmp.free;
  fpeBrushBmp.free;
end;

function TSimple_PE_Editor.GetPeMode: TPeMode;
begin
  case pagecontrol1.ActivePageIndex of
    0: result := pemcolor;
    1: result := pemtexture;
    2: result := pemRetouch;
    3: result := pemclone;
    4: result := pemhistory;
    5:
       begin
         if RadioGroup_LayerEditMode.ItemIndex = 1 then
           result := pemRestoreLayer
         else
           result := pemEraseLayer;
       end;

    6: result := pemDeformations;
  end;
end;

procedure TSimple_PE_Editor.ImageEnView1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

  if button = mbright then
    exit; //>>>>EXIT

  fPeMode := GetPeMode; //read current painting mode from currently selected Tab


  if ssshift in shift then     //set the clone source point
  begin
    PeSet_CloningBMP(Imageenview1);
    RadioGroup_CloneType.OnClick := nil;  //disable the warning from the radiogroup
    try
      RadioGroup_CloneType.ItemIndex := 0;
    finally
      RadioGroup_CloneType.OnClick := RadioGroup_CloneTypeClick;
    end;

    fpe_Cloning_SrcPoint := point(imageenview1.XScr2Bmp(x), imageenview1.YScr2Bmp(y));
    Label_srcpoint.caption := 'Source Point: ' + inttostr(fpe_Cloning_SrcPoint.x) + ',' + inttostr(fpe_Cloning_SrcPoint.y);
    fpe_Cloning_ResetTarget := true;  //set this flag to tell we require a new target point

    EXIT; //>>>>EXIT
  end;

  //now follow some preliminary checks
  if (fEditMode = empaint) and
    (fpeMode = pemclone) and    //cloning
    (fpe_Cloning_SrcPoint.x = C_PTNOTDEF) then //make sure we have a source point
  begin
    messagedlg('Select Source Point first (Shift + Click on current picture or click on source image', mtinformation, [mbok], 0);
    exit; //>>>>EXIT
  end;

  if (fEditMode = empaint) and
    ((fpeMode = pemEraseLayer) or (fpeMode = pemRestoreLayer)) and // modify layer alpha channel
    (not imageenview1.IEBitmap.HasAlphaChannel) then //make sure we have alpha channel
  begin
    AlphaChannelFill(imageenview1.IEBitmap.AlphaChannel);
  end;
 
  //checks were all performed we can launch paint engine
  //--------------------------------------------------------
  if (fEditMode = empaint) then
    PE_StartPaintFrom(x, y);   //go for the painting now
  //--------------------------------------------------------
end;

procedure TSimple_PE_Editor.ImageEnView1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if PE_MANAGER.IsRunning then
  begin
     EXIT; //>>>>EXIT
  end;

  
end;

procedure TSimple_PE_Editor.ImageEnView1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if button = mbright then exit;

//here we Stop the paint engine
 if fEditMode = empaint then
   Pe_StopPainting;
end;



procedure TSimple_PE_Editor.ImageEnView1ImageChange(Sender: TObject);
begin
   IEView_ContentChanged(sender);
end;

procedure TSimple_PE_Editor.IEView_ContentChanged(sender:TObject);
var
  aTempHistoryBmp: TIEBitmap;
begin
  if sender <> PE_MANAGER then
     PE_MANAGER.Session_Reset;

  Refresh_LayerPreview(imageenview1.LayersCurrent);

  if PE_MANAGER.Params_Paint.Mode<> pemHistory then  //only get new a new history bitmap if the paint engine is
                                                      //not already in history mode
  begin
    if (ImageEnView1.Proc.UndoCount=0) then
     PeSet_HistoryBMP(ImageEnView1.IEBitmap)
    else
    begin
      aTempHistoryBmp := TIEBitmap.Create;
      try
        ImageEnView1.Proc.AttachedIEBitmap := aTempHistoryBmp;
        ImageEnView1.Proc.UndoAt(0);
        //Call UndoAt(0) if you wish to restore only the last undo step
        //or UndoAt(Imageenview1.proc.UndoCount-1);
        //if you wish to restore always the first undo, that is the original picture

        PeSet_HistoryBMP(aTempHistoryBmp);
      finally
        ImageEnView1.Proc.AttachedImageEn := ImageEnView1;
        aTempHistoryBmp.Free;
      end;
    end;
  end;

end;

procedure TSimple_PE_Editor.ToolButton_paintClick(Sender: TObject);
begin
  IEView_SetEditMode(sender);
end;


procedure TSimple_PE_Editor.Button_NewBackgroundFomFileClick(Sender: TObject);
begin
  if OpenImageEnDialog1.Execute then
  begin
    imageenview1.LayersCurrent := 0;
    imageenview1.IO.LoadFromFile(OpenImageEnDialog1.filename);
    imageenview1.Fit(false);
    PeSet_HistoryBMP(imageenview1.IEBitmap);
  end;
end;


procedure TSimple_PE_Editor.HSVBox1Change(Sender: TObject);
begin
  shape1.brush.color := hsvbox1.Color;
end;



procedure TSimple_PE_Editor.SpinEdit_zoomChange(Sender: TObject);
begin
  {
  if (SpinEdit_zoom.Value mod SpinEdit_zoom.Increment) <> 0 then
  begin
    SpinEdit_zoom.Value := (SpinEdit_zoom.Value div SpinEdit_zoom.Increment) * SpinEdit_zoom.Increment;
    EXIT;
  end;
  }

  imageenview1.Zoom := SpinEdit_zoom.Value;
end;


procedure TSimple_PE_Editor.Button_NewBlankTransparentLayerClick(Sender: TObject);
var
  alayer: TIELayer;
  bmp: tbitmap;
begin

  imageenview1.LayersAdd;
  Refresh_layerlist;

  IEView_SetCurrentLayer(imageenview1.LayersCount - 1);

  alayer := imageenview1.layers[imageenview1.Layerscurrent];

  with alayer do
  begin
    Locked := false;
    //Transparency := 255;
    alayer.Bitmap.AlphaChannel.Fill(0);
  end;
  imageenview1.update;


  ToolButton_paint.down := true;
  IEView_SetEditMode(ToolButton_paint);

  PeSet_HistoryBMP(imageenview1.IEBitmap);
end;



procedure TSimple_PE_Editor.Button_NewLayerFromFileClick(Sender: TObject);
var
  alayer: TIELayer;
begin
  if OpenImageEnDialog1.execute then
  begin
    imageenview1.LayersAdd;
    Refresh_layerlist;

    IEView_SetCurrentLayer(imageenview1.LayersCount - 1);
    alayer := imageenview1.layers[imageenview1.Layerscurrent];
    alayer.Locked := false;

    imageenview1.IO.LoadFromFile(openimageendialog1.filename);

    if (not alayer.bitmap.HasAlphaChannel)  then
    begin
       AlphaChannelFill(alayer.Bitmap.AlphaChannel);
    end;

    imageenview1.update;


    ToolButton_paint.down := true;
    IEView_SetEditMode(ToolButton_paint);

    PeSet_HistoryBMP(imageenview1.IEBitmap);
  end;
end;


procedure TSimple_PE_Editor.Button_DeleteLayerClick(Sender: TObject);
begin
  if imageenview1.LayersCurrent > 0 then
      imageenview1.LayersRemove(imageenview1.layerscurrent );

  Refresh_layerlist;
end;



procedure TSimple_PE_Editor.ImageEnView2MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  fpe_Cloning_SrcPoint := point(imageenview2.XScr2Bmp(x), imageenview2.YScr2Bmp(y));
  Label_srcpoint.caption := 'Source Point: ' + inttostr(fpe_Cloning_SrcPoint.x) + ',' + inttostr(fpe_Cloning_SrcPoint.y);
  fpe_Cloning_ResetTarget := true;

  imageenview2.Repaint;
end;







procedure TSimple_PE_Editor.Button_LoadCloneSourceClick(Sender: TObject);
begin
  if OpenImageEnDialog1.Execute then
  begin
    imageenview2.IO.LoadFromFile(OpenImageEnDialog1.filename);
    imageenview2.Fit;

    PeSet_CloningBMP(imageenview2);
    CheckCloneType;
  end;
end;

procedure TSimple_PE_Editor.btn_undoClick(Sender: TObject);
begin
  Undo;
end;

procedure TSimple_PE_Editor.btn_redoClick(Sender: TObject);
begin
  Redo;
end;

procedure TSimple_PE_Editor.btn_HandwritingClick(Sender: TObject);
begin
  SpinEdit_BrushFeather.Value := 20;
  SpinEdit_BrushOpacity.Value := 255;
  SpinEdit_BrushRadius.Value := min(7, SpinEdit_BrushRadius.Value);
  CheckBox_LargeSteps.Checked := false;
  CheckBox_RotateBrush.Checked := false;
  SpinEdit_Precision.Value := 50;
  SpinEdit_Step.Value := 10;
  PE_MANAGER.UpdatePriority := upmedium;
end;

procedure TSimple_PE_Editor.btn_NormalPaintingClick(Sender: TObject);
begin
  SpinEdit_BrushFeather.Value := 50;
  SpinEdit_BrushOpacity.Value := 200;
//  SpinEdit_BrushRadius.Value := 15;
  CheckBox_LargeSteps.Checked := false;
  CheckBox_RotateBrush.Checked := false;
  SpinEdit_Precision.Value := 0;
  SpinEdit_Step.Value := 18;
  PE_MANAGER.UpdatePriority := upHigh;
end;

procedure TSimple_PE_Editor.btn_LoadBrushClick(Sender: TObject);
begin
  OpenImageEnDialog1.InitialDir := ParamStr(0);
  if OpenImageEnDialog1.Execute then
    ImageEnView3.IO.LoadFromFile(OpenImageEnDialog1.filename);
end;



procedure TSimple_PE_Editor.RadioGroup_BrushKindClick(Sender: TObject);
begin
  if RadioGroup_BrushKind.ItemIndex = 1 then
    btn_LoadBrush.Enabled := true
  else
    btn_LoadBrush.Enabled := false;
end;

procedure TSimple_PE_Editor.Button_ResetSessionClick(Sender: TObject);
begin
  PE_MANAGER.Session_Reset;
  //manually reset the session
  //the session indicates whether the paint engine should
  //reset or keep the memory of the previous painting operation
  //this memory is needed in these two cases
  // when the Session Mode is set to: sm_KeepSessionMemory_UntilManualReset
  // when the Session Mode is set to: sm_KeepSessionMemory_UntilNext
  //but you need to care about resetting the session only with the mode: sm_KeepSessionMemory_UntilManualReset
  // in the other case the reset is automatically handled at each new painting operation
end;

procedure TSimple_PE_Editor.Button5Click(Sender: TObject);
begin
  if OpenImageEnDialog1.Execute then
  begin
    imageenview4.IO.LoadFromFile(OpenImageEnDialog1.filename);
    PeSet_TextureBMP(imageenview4.IEBitmap);
  end;
end;




procedure TSimple_PE_Editor.Button7Click(Sender: TObject);
begin
  ImageEnView1.deselect;
end;

 procedure TSimple_PE_Editor.ListBox1Click(Sender: TObject);
begin
  IEView_SetCurrentLayer( ListBox1.Items.count - 1 - listbox1.itemindex);
end;

procedure TSimple_PE_Editor.CheckBox_LargeStepsClick(Sender: TObject);
begin
{
  if not CheckBox_LargeSteps.Checked then
    SpinEdit_Step.Value := SpinEdit_Step.Tag
  else
    SpinEdit_Step.Value := 200;
    }
end;

function TSimple_PE_Editor.Convert_LayerIDXtoListIDX(LayIDX:integer):integer;
begin
  result := imageenview1.layerscount - 1 - layIDX;
end;

function TSimple_PE_Editor.Convert_ListIDXtoLayerIDX(ListIDX:integer):integer;
begin
  result := ListBox1.Items.count - 1 - listIDX;
end;





procedure TSimple_PE_Editor.RefreshUndoButtons;
begin

  if imageenview1.Proc.RedoCount > 0 then
    btn_redo.Enabled := true
  else
    btn_redo.Enabled := false;

  if imageenview1.Proc.UndoCount > 0 then
    btn_undo.Enabled := true
  else
    btn_undo.Enabled := false;
end;

procedure TSimple_PE_Editor.Refresh_LayerPreview(idx:integer);
begin
  ImageEnView5.IEBitmap.Assign(ImageEnView1.Layers[idx].Bitmap);
  ImageEnView5.Layers[0].Transparency := ImageEnView1.Layers[idx].Transparency;
  ImageEnView5.repaint;
end;


procedure TSimple_PE_Editor.Refresh_layerlist;
var
i:integer;
begin

  ListBox1.clear;
  for i := ImageEnView1.layerscount-1 downto 0 do
    ListBox1.Items.Add(Get_aLayerName(i));

  Refresh_LayerPreview(ImageEnView1.LayersCurrent);
end;




procedure TSimple_PE_Editor.SpinEdit_BrushRadiusChange(Sender: TObject);
begin
  PE_MANAGER.StartCursorNoPaint(imageenview1, SpinEdit_BrushRadius.Value);
end;

procedure TSimple_PE_Editor.SpinEdit_StepChange(Sender: TObject);
begin
  {if not CheckBox_LargeSteps.Checked then
     SpinEdit_Step.Tag := SpinEdit_Step.Value;}
end;

procedure TSimple_PE_Editor.ImageEnView1ViewChange(Sender: TObject; Change: Integer);
begin
   SpinEdit_zoom.OnChange := nil;
  try
    SpinEdit_zoom.Value := round(ImageEnView1.zoom);
  finally
    SpinEdit_zoom.OnChange := SpinEdit_zoomChange;
  end;
end;



procedure TSimple_PE_Editor.ImageEnView2Paint(Sender: TObject);
var
 scrRect: TRect;
begin
  scrRect.left := imageenview2.XBmp2Scr(fpe_Cloning_SrcPoint.x) -5;
  scrRect.Top := imageenview2.YBmp2Scr(fpe_Cloning_SrcPoint.y) - 5;
  scrRect.Right := imageenview2.XBmp2Scr(fpe_Cloning_SrcPoint.x) + 5;
  scrRect.Bottom := imageenview2.YBmp2Scr(fpe_Cloning_SrcPoint.y) + 5;

  with imageenview2.GetCanvas do
  begin
    pen.Mode := pmnot;
    brush.style := bsclear;

    rectangle(scrRect.left, scrRect.top, scrRect.right, scrRect.bottom);
  end;
end;

procedure TSimple_PE_Editor.ButtonCloneResetTargetClick(Sender: TObject);
begin
  fpe_Cloning_ResetTarget := True;
  CheckCloneType;
end;



procedure TSimple_PE_Editor.ImageEnView1MouseLeave(Sender: TObject);
begin
  ImageEnView1.Update;
end;

procedure TSimple_PE_Editor.RadioGroup_CloneTypeClick(Sender: TObject);
begin
  CheckCloneType;

end;

procedure TSimple_PE_Editor.CheckCloneType;
begin
  Button_LoadCloneSource.Enabled := radiogroup_Clonetype.ItemIndex = 1;
  Imageenview2.visible := radiogroup_Clonetype.ItemIndex = 1;
  if radiogroup_Clonetype.ItemIndex = 0 then
  begin
    PeSet_CloningBMP(Imageenview1);
    showmessage('Shift+click on the Editor to choose the source point and to start cloning.');
  end
  else
  begin
    PeSet_CloningBMP(Imageenview2);
    showmessage('Shift+click on the Source Picture to choose the source point. Then click on the Editor to start cloning.');
  end;
end;


end.
