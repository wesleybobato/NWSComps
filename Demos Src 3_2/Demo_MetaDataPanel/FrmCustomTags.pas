unit FrmCustomTags;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls,
  Vcl.Grids, Vcl.ExtCtrls, NWSComps_ThumbsBrowser_Utils_Types;

type
  TFormCustomTags = class(TForm)
    Panel_CustomTags: TPanel;
    GridCustomTags: TStringGrid;
    PageControl_CustomTags: TPageControl;
    TabCustomExif: TTabSheet;
    TabCustomIptc: TTabSheet;
    TabCustomXMP: TTabSheet;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Panel1: TPanel;
    ListBox1: TListBox;
    btnDel: TBitBtn;
    btnAdd: TBitBtn;
    TabCommon: TTabSheet;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure PageControl_CustomTagsChanging(Sender: TObject;
      var AllowChange: Boolean);
    procedure PageControl_CustomTagsChange(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure btnDelClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
  private
    { Private declarations }
    fTempTags: TThumbsbrowser_MetaTags;
    procedure LoadGrid;
    procedure SaveGrid;
  public
    { Public declarations }
    Constructor Create(aOwner:TComponent; theCustomTags: TThumbsbrowser_MetaTags);
    destructor Destroy; override;

    procedure GivemeTags(theTags: TThumbsbrowser_MetaTags);
  end;

var
  FormCustomTags: TFormCustomTags;

implementation
 uses NWSComps_ThumbsBrowser_MetaHelpers;
{$R *.dfm}

procedure DeleteRow(Grid: TStringGrid; ARow: Integer);
var
  i: Integer;
begin
  for i := ARow to Grid.RowCount - 2 do
    Grid.Rows[i].Assign(Grid.Rows[i + 1]);
  Grid.RowCount := Grid.RowCount - 1;
end;

procedure TFormCustomTags.BitBtn1Click(Sender: TObject);
begin
  SaveGrid;
  ModalResult := mrok;
end;

procedure TFormCustomTags.BitBtn2Click(Sender: TObject);
begin
  ModalResult := mrcancel;
end;

procedure TFormCustomTags.btnAddClick(Sender: TObject);
begin
  GridCustomTags.RowCount := GridCustomTags.RowCount + 1;
  GridCustomTags.Row := GridCustomTags.RowCount - 1;

  GridCustomTags.Cells[0, GridCustomTags.RowCount - 1] := inttostr(strtoint(GridCustomTags.Cells[0, GridCustomTags.RowCount - 2])+ 1) ;
end;

procedure TFormCustomTags.btnDelClick(Sender: TObject);
begin
  if GridCustomTags.row >= 0 then
    DeleteRow(GridCustomTags, GridCustomTags.Row);
end;

constructor TFormCustomTags.Create(aOwner:TComponent; theCustomTags: TThumbsbrowser_MetaTags);
begin
  inherited Create(aOwner);
  fTempTags := TThumbsbrowser_MetaTags.Create(false);
  fTempTags.assign(theCustomTags);
end;

destructor TFormCustomTags.Destroy;
begin
  fTempTags.free;
  inherited;
end;

procedure TFormCustomTags.FormActivate(Sender: TObject);
begin
    if (fsModal in FormState) then
    LoadGrid;
end;

procedure TFormCustomTags.FormShow(Sender: TObject);
begin
  if not( fsModal in FormState) then
    LoadGrid;

end;

procedure TFormCustomTags.PageControl_CustomTagsChange(Sender: TObject);
begin
 LoadGrid;
end;

procedure TFormCustomTags.PageControl_CustomTagsChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  SaveGrid;
end;

procedure TFormCustomTags.GivemeTags(theTags: TThumbsbrowser_MetaTags);
begin
  theTags.assign(fTempTags);
end;

procedure TFormCustomTags.LoadGrid;
begin
  if PageControl_CustomTags.ActivePage = TabCustomExif then
    GridCustomTags.LoadExifTags(fTempTags)
  else if PageControl_CustomTags.ActivePage = TabCustomIptc then
    GridCustomTags.LoadIptcTags(fTempTags)
  else if PageControl_CustomTags.ActivePage = TabCustomXmp then
    GridCustomTags.LoadXmpTags(fTempTags)
  else if PageControl_CustomTags.ActivePage = TabCommon then
    GridCustomTags.LoadCommonTags(fTempTags);
end;

procedure TFormCustomTags.SaveGrid;
begin
  if PageControl_CustomTags.ActivePage = TabCustomExif then
    GridCustomTags.SaveExifTags(fTempTags)
  else if PageControl_CustomTags.ActivePage = TabCustomIptc then
    GridCustomTags.SaveIptcTags(fTempTags)
  else if PageControl_CustomTags.ActivePage = TabCustomXmp then
    GridCustomTags.SaveXmpTags(fTempTags)
  else if PageControl_CustomTags.ActivePage = TabCommon then
    GridCustomTags.SaveCommonTags(fTempTags);
end;

end.
