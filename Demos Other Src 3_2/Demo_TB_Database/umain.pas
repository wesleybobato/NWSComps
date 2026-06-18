unit umain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, ieview, iemview,
  Db, Grids, DBGrids, DBTables, hyieutils, imageenview, ImageEnIO, iexwindowsfunctions, StdCtrls, ExtCtrls, ComCtrls,
  ieopensavedlg, iexBitmaps, hyiedefs, iesettings, syncobjs, NWSComps_StyleEngine,
  NWSComps_ThumbsBrowser, NWSComps_ThumbsBrowser_Thumbs, NWSComps_ThumbsBrowser_Utils_Types, Vcl.Buttons,
  iexLayers, iexRulers;

type
  TMainForm = class(TForm)
    Table1: TTable;
    Panel1: TPanel;
    TB1: TThumbsBrowser;
    BitBtn1: TBitBtn;
    EditDBPath: TEdit;
    Label1: TLabel;
    Label4: TLabel;
    EditTableName: TEdit;
    Session1: TSession;
    Panel2: TPanel;
    btnDeleteRec: TBitBtn;
    btnInsertRecord: TBitBtn;
    OpenImageEnDialog1: TOpenImageEnDialog;
    Edit1: TEdit;
    Label5: TLabel;
    rgpAsync: TRadioGroup;
    procedure FormCreate(Sender: TObject);
    procedure TB1ThumbLoadDemand(theThumb: TThumbEx; const Idx: Integer);
    procedure TB1ThumbLoadDemandAsync(sender: TThread; theThumb: TThumbEx);
    procedure BitBtn1Click(Sender: TObject);
    procedure btnInsertRecordClick(Sender: TObject);
    procedure btnDeleteRecClick(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure rgpAsyncClick(Sender: TObject);
   // procedure TB1ThumbLoadDemandTest(theThumb: TThumbEx; const Idx: Integer);
  private
    fTableCS: TCriticalSection;
    procedure FillTB;
    procedure GetThumb(theThumb: TThumbEX;  bWithPic: boolean);
    procedure SetAsyncMode;
   // procedure FillTBTest;
    { Private declarations }

  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation
   uses NWSComps_Thumbsbrowser_Shell_Utils, shlobj;

const
 CONST_FIELDNAME_TITLE = 'Name';
 CONST_FIELDNAME_PIC = 'Photo';


{$R *.DFM}



procedure TMainForm.FormCreate(Sender: TObject);
begin
  SetAsyncMode;
  fTableCS := TCriticalSection.create;
  EditDBPath.Text := ExtractFilePath(application.exename);
  Session1.netfiledir := tbs_GetSpecialFolderPath(CSIDL_MYDOCUMENTS);
  Session1.active := true;
end;

procedure TMainForm.FillTB;
var
  Idx : integer;
  aThumb: TBrowserThumb;
begin

  if not table1.Active then
  begin
    Table1.DatabaseName := EditDBPath.Text;
    table1.TableName := EditTableName.Text;
    Table1.Open;
  end;

  tb1.ClearThumbs;
  tb1.LockUpdate; //lock update otherwise adding thousands of thumbs will be very slow
  try
    Table1.First;
    while not Table1.Eof do
    begin
      aThumb := tb1.Add_a_Thumb;
      aThumb.UserTag := Table1.RecNo;
      GetThumb(aThumb, FALSE); //assign captions to the thumb
      Table1.Next;
    end;
  finally
    tb1.UnlockUpdate;
  end;

  tb1.ReloadThumbs;
end;

procedure TMainForm.GetThumb(theThumb: TThumbEX; bWithPic: boolean);
var
  ms:TMemoryStream;
begin
  if theThumb.Adjourned then EXIT;

  if bWithPic then
    ms := TMemoryStream.Create;

  try
    // Go to the record of this ID
    Table1.RecNo := theThumb.UserTag;

    if bWithPic then
    begin       // Load the blob content into the thumb
      TBlobField(Table1.FieldByName(CONST_FIELDNAME_PIC)).SaveToStream(ms);
      ms.seek(0,0); //go to first position of stream
      theThumb.RetrieveFromStream(ms);
    end;

    theThumb.Captions.SetCaption(Table1.FieldByName(CONST_FIELDNAME_TITLE).AsString, cap_General);
    theThumb.Captions.SetCaption('Rec. Nr. ' + inttostr(Table1.RecNo), cap_other1);
  finally
    if bWithPic then
      ms.free;
  end;
end;


procedure TMainForm.SetAsyncMode;
begin
  tb1.StopBrowsing;
  tb1.OnThumbLoadDemandAsync := nil;
  tb1.OnThumbLoadDemand := nil;
  if rgpAsync.itemindex = 0 then
  begin
    tb1.OnThumbLoadDemand := TB1ThumbLoadDemand;
    tb1.RefreshDisplay;
  end
  else
  begin
    tb1.OnThumbLoadDemandAsync := TB1ThumbLoadDemandAsync;
    tb1.ReLoadThumbs;
  end;
end;

procedure TMainForm.rgpAsyncClick(Sender: TObject);
begin
  SetAsyncMode;
end;

procedure TMainForm.TB1ThumbLoadDemand(theThumb: TThumbEx; const Idx: Integer);
begin
  GetThumb(theThumb, TRUE);
end;

procedure TMainForm.TB1ThumbLoadDemandAsync(sender: TThread;
  theThumb: TThumbEx);
begin
  fTableCS.enter; //enter critical section: table is accessed from thread
  try
    GetThumb(theThumb, TRUE);
  finally
    fTableCS.leave;  //leave critical section
  end;
end;

procedure TMainForm.BitBtn1Click(Sender: TObject);
begin
  if table1.active then
    table1.close;

  FillTB;  //fill thumbsbrowser with images from db
end;

procedure TMainForm.btnDeleteRecClick(Sender: TObject);
var
  aThumb: TThumbEX;
  I: Integer;
begin
  if not (Table1.active) then
    raise Exception.Create('Table is not active');
  if tb1.SelectedCount = 0 then
     raise Exception.Create('No Thumb is Selected');

  tb1.LockUpdate;
  fTableCS.enter;   //enter critical section to avoid conflict with async loading
                     // (you don't need this if Loading is Synchronized)
  try
    for I := tb1.selectedcount-1 downto 0 do //in delete it is always necessary a downto loop
    begin
      aThumb := tb1.GetSelected(i);
      Table1.RecNo := aThumb.UserTag;
      table1.Edit;
      table1.FieldByName(CONST_FIELDNAME_TITLE).AsString:='xxxxTODELETExxxx';
      table1.Post;
      tb1.Delete_a_Thumb(aThumb);
    end;

    while table1.Locate(CONST_FIELDNAME_TITLE, 'xxxxTODELETExxxx', []) do
      table1.delete;

  finally
    fTableCS.leave;  // (you don't need this if Loading is Synchronized)
    tb1.UnlockUpdate;
  end;
  fillTB;  //reload after deletion because record numbers have changed
end;

procedure TMainForm.btnInsertRecordClick(Sender: TObject);
var
  aMemStream: TMemoryStream;
  aBlobStream: TBlobStream;
  sName: string;
  Idx: Integer;
  aThumb: TBrowserThumb;
  I: Integer;
begin
  if not (Table1.active) then
    raise Exception.Create('Table is not active');

  if OpenImageEnDialog1.Execute = False then
    exit;


  tb1.LockUpdate;
  fTableCS.enter;   //enter critical section to avoid conflict with async loading
                    // (you don't need this if Loading is Synchronized)
  try
    for I := 0 to OpenImageEnDialog1.Files.count-1 do
    begin
      try
        Table1.Append;

        aMemStream := TMemoryStream.Create;
        try
          // Transfer the image from file to our memory stream
          aMemStream.LoadFromFile(OpenImageEnDialog1.files[i]);
          aMemStream.Position := 0;

          // Transfer from the memory stream to the blobstream
          aBlobStream := TBlobStream.create(TBlobField(Table1.FieldByName(CONST_FIELDNAME_PIC)), bmWrite);
          try
            aMemStream.SaveToStream(aBlobStream);
          finally
            aBlobStream.Free;
          end;

          // Assign a name
          sName := ChangeFileExt(ExtractFilename(OpenImageEnDialog1.files[i]), '');
          Table1.FieldByName(CONST_FIELDNAME_TITLE).AsString := sName;

          Table1.Post;

          // Add thumb to Browser
          aThumb := tb1.Add_a_Thumb;
          aThumb.UserTag := Table1.RecNo; //set record id as UserTag to identify record

          if i = OpenImageEnDialog1.Files.count-1 then
            tb1.GotoThumb(aThumb, false);  //goto last inserted thumb
        finally
          aMemStream.free;
        end;
      except
        Table1.Cancel;
        raise;
      end;
    end;
  finally
    fTableCS.leave;  // (you don't need this if Loading is Synchronized)
    tb1.UnLockUpdate;
  end;

  tb1.ReloadThumbs;  //this starts loading the thumb just added: this is only need in async mode
end;

procedure TMainForm.Edit1Change(Sender: TObject);
begin
 if not (Table1.active) then
    raise Exception.Create('Table is not active');


  fTableCS.enter;   //enter critical section to avoid conflict with async loading
                    // (you don't need this if Loading is Synchronized)
  try
      if Edit1.Text <> '' then
      begin
        Table1.FilterOptions := [foCaseInsensitive];
        Table1.Filter := CONST_FIELDNAME_TITLE + '='''+Edit1.text+'*''';
        Table1.Filtered := true;
      end
      else
        Table1.Filtered := false;

  finally
    fTableCS.leave;  // (you don't need this if Loading is Synchronized)
  end;
  FillTB;
end;

end.
