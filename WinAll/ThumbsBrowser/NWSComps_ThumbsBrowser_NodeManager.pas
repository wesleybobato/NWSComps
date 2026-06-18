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
unit NWSComps_ThumbsBrowser_NodeManager;
{$R-}
{$Q-}
interface

{$I ..\_inc\NWSComps_ThumbsBrowser.inc}
uses
  Windows, Messages, SysUtils, Classes,
  Graphics, Controls, contnrs,
  hyieutils, hyiedefs, imageenio, imageenproc,ieWIA
  ,NWSComps_ThumbsBrowser,NWSComps_ThumbsBrowser_Shell, NWSComps_ThumbsBrowser_Thumbs,
   NWSComps_ThumbsBrowser_const,
   NWSComps_ThumbsBrowser_Shell_Utils,
   NWSComps_ThumbsBrowser_Utils_Types;



type


  TThumbsBrowserNodeManager = class(TComponent)
  private
    fattachedShellProcessor: TThumbsBrowserShellProcessor;
    fAborted: boolean;

    function NM_Init: boolean;

    procedure SetAborted(value: boolean);


    public



    OnProgress: TTB_Browser_ProgressEvent_Perc;


    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property Aborted: boolean read fAborted write SetAborted;

    procedure AbortProcess;




    procedure NM_GetTreeNodes_byDate(var dl: TTB_Shell_Tree_Folders_NodeArray; mode: TTB_Shell_FolderNodes_PickMode; const IgnoreExif: boolean; condition: TTB_Browser_PickCondition);

    function NM_Node_Folder_DefineNew(const theRelativePAth:string): TTB_Shell_Tree_Folder_Node;

    procedure NM_Node_Folder_SetInfo_Date(var aItem: TTB_Shell_Tree_Folder_Node; theDate: Tdatetime; bDateIsExif: boolean);
    procedure NM_Node_File_SetInfo_Date(var aItem: TTB_Shell_Tree_File_Node; theDate: Tdatetime; bDateIsExif: boolean);


    function NM_Nodes_CompareDate(node1, node2: TTB_Shell_Tree_Folder_Node; checkmode: TTB_Shell_FolderNodes_PickMode): boolean;
    function NM_Nodes_CheckAddFolder(var dl: TTB_Shell_Tree_Folders_NodeArray;
                                      theCandidateNode: TTB_Shell_Tree_Folder_Node;
                                      checkmode: TTB_Shell_FolderNodes_PickMode): integer;



    published

    property AttachedShellProcessor: TThumbsBrowserShellProcessor read fattachedShellProcessor write fattachedShellProcessor;
  end;

implementation

uses  math,  NWSComps_ThumbsBrowser_utils;





//Class TThumbsBrowserNodeManager

constructor TThumbsBrowserNodeManager.Create(AOwner: TComponent);
begin
  inherited;

   fAborted := true;
end;

destructor TThumbsBrowserNodeManager.Destroy;
begin

  inherited;
end;


function TThumbsBrowserNodeManager.NM_Init: boolean;
begin
  result := (assigned(fattachedShellProcessor) and (assigned(fattachedShellProcessor.AttachedBrowser)));
end;

procedure TThumbsBrowserNodeManager.SetAborted(value: boolean);
begin
  faborted := value;
  if faborted = false then exit;

 // showmessage('aborted');
end;




procedure TThumbsBrowserNodeManager.AbortProcess;
begin
  Aborted := true;
end;






procedure TThumbsBrowserNodeManager.NM_GetTreeNodes_byDate(var dl: TTB_Shell_Tree_Folders_NodeArray; mode: TTB_Shell_FolderNodes_PickMode; const IgnoreExif: boolean; condition: TTB_Browser_PickCondition);


  procedure AddChild_File(var parent: TTB_Shell_Tree_Folder_Node;
                     thedate: Tdatetime;
                     bDateIsExif: boolean;
                     thethumb: tthumbex;
                     const theThumbIdx: integer);
  var test_canadd: boolean;
  begin
    test_canadd := false;

    case condition of
      IfNo_condition: test_canadd := true;
      IfSelected: test_canadd := thethumb.selected;
      IfChecked: test_canadd := thethumb.Checked;
    end;

    if not test_canadd then exit;

    inc(parent.FilesCount);
    if length(parent.files) < parent.FilesCount then
      setlength(parent.files, parent.FilesCount + 10);


    NM_Node_File_SetInfo_Date(parent.files[parent.FilesCount - 1], theDate, bDateIsExif);

     //------Save theThumb Index of the node---------------------------------------
      parent.files[parent.FilesCount - 1].idx := theThumbIdx;
     //------Save theThumb Index of the node---------------------------------------

  end;



var i: integer;
  athumb: tthumbex;
  adate: Tdatetime;
  bDateIsExif: boolean;

  aCandidateNode: TTB_Shell_Tree_Folder_Node;
  currentFolder: integer;
begin
  if not NM_Init then EXIT;

  if fAttachedShellProcessor.AttachedBrowser.ThumbsCount = 0 then
  begin
    setlength(dl, 0);
    exit; //EXIT
  end;

  setlength(dl, 0);

  for i := 0 to fAttachedShellProcessor.AttachedBrowser.ThumbsCount - 1 do
  begin
    athumb := tthumbex(fAttachedShellProcessor.AttachedBrowser.ThumbAt(i));

    if IgnoreExif then
    begin
      adate := athumb.SourceFileDate;
      bDateIsExif := False;
    end
    else
    begin
      adate := athumb.SourceExifFileDate;
      if not tbs_ExifDateisValid(adate, fAttachedShellProcessor.MinExifYear) then
      begin
        bDateIsExif := False;
        adate := athumb.SourceFileDate;
      end
      else
        bDateIsExif := True;
        // adate := athumb.SourceFileDate;
    end;


    aCandidateNode := NM_Node_Folder_DefineNew('');
    NM_Node_Folder_SetInfo_Date(aCandidateNode, aDate, bDateIsExif);
    currentFolder := NM_Nodes_CheckAddFolder(dl, aCandidateNode, mode);
    if currentFolder >= 0 then
    begin
      AddChild_File(dl[currentFolder], adate, bDateIsExif, athumb, i);
    end;
  end;

end;




function TThumbsBrowserNodeManager.NM_Node_Folder_DefineNew(const theRelativePAth:string): TTB_Shell_Tree_Folder_Node;
begin
  with result do
  begin
    node_name := '';
    node_relativepath := theRelativePath;
    with node_info do
    begin
      Date := Now;
      Date_EXIF := Date;
      Date_Used := Date;
    end;
    FilesCount := 0;
    Files := nil;
    FolderIdx := -1;

  end;
end;


procedure TThumbsBrowserNodeManager.NM_Node_Folder_SetInfo_Date(var aItem: TTB_Shell_Tree_Folder_Node; theDate: Tdatetime; bDateIsExif: boolean);
begin
    aItem.node_info.Date_Used := thedate;

    if bDateIsExif then
    begin
      aItem.node_info.Date_EXIF := thedate;
    end
    else
    begin
      aItem.node_info.date := thedate;
    end;
end;

procedure TThumbsBrowserNodeManager.NM_Node_File_SetInfo_Date(var aItem: TTB_Shell_Tree_File_Node; theDate: Tdatetime; bDateIsExif: boolean);
begin
    aItem.node_info.Date_Used := thedate;

    if bDateIsExif then
    begin
      aItem.node_info.Date_EXIF := thedate;
    end
    else
    begin
      aItem.node_info.date := thedate;
    end;
end;

function TThumbsBrowserNodeManager.NM_Nodes_CompareDate(node1, node2: TTB_Shell_Tree_Folder_Node; checkmode: TTB_Shell_FolderNodes_PickMode): boolean;
var
  yy1, mm1, dd1: word;
  yy2, mm2, dd2: word;
begin
  DecodeDate(node1.node_info.Date_Used, yy1, mm1, dd1);
  DecodeDate(node2.node_info.Date_Used, yy2, mm2, dd2);

  //Establish if date is new or it is duplicate
      case checkmode of
        fn_PickSameDate: result := ((dd1 = dd2) and (mm1 = mm2) and (yy1 = yy2));
        fn_PicksameYear: result := (yy1 = yy2);
        fn_PicksameMonth: result := (mm1 = mm2) ;
        fn_PicksameDay: result := (dd1 = dd2);
        fn_PicksameYearMonth: result := ((mm1 = mm2) and (yy1 = yy2));
        else result := false;
      end;
end;

function TThumbsBrowserNodeManager.NM_Nodes_CheckAddFolder(var dl: TTB_Shell_Tree_Folders_NodeArray;
                                                               theCandidateNode: TTB_Shell_Tree_Folder_Node;
                                                               checkmode: TTB_Shell_FolderNodes_PickMode): integer;
var
  j: integer;
  bFoundNew: boolean;

  FirstFound: integer;
begin

  if length(dl) = 0 then
  begin
    setlength(dl, 1);
    dl[0] := theCandidateNode;
    result := 0;
    EXIT;
  end;

  //Loop on previous nodes to check if there is already a node folder that matches the node criteria
    bFoundNew := true;
    j := high(dl);
    FirstFound := -1;
    while (bFoundNew = true) and (j >= 0) do
    begin

      //Establish if date is new or it is duplicate
      case checkmode of
        fn_PickSameDate, fn_PicksameYear, fn_PicksameMonth,
        fn_PicksameDay, fn_PicksameYearMonth:
         begin
           bFoundNew := not NM_Nodes_CompareDate(theCandidateNode, dl[j], checkmode);
         end;
      end;

      if not bFoundNew then  //if folder match is found then stop searching
      begin
        FirstFound := j;
        Break;
      end;

      dec(j);
    end;

    //if folder date is new then first create the folder
    if bFoundNew then
    begin
      setlength(dl, length(dl) + 1);
      dl[high(dl)] := theCandidateNode;
      result := high(dl);
    end
    else
    begin
     // dl[FirstFound] := theCandidateNode;
      result := FirstFound;
    end;

end;



end.
