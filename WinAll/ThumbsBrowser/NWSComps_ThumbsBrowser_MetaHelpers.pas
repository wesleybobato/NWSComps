unit NWSComps_ThumbsBrowser_MetaHelpers;

interface

  {$I ..\_inc\NWSComps_Shared.inc}
uses
  dialogs, Sysutils, math, Graphics, Classes,
  grids,
  ComCtrls,
  NWSComps_ThumbsBrowser_Utils_Types;

type

  {$IFDEF NWSCOMPS_DELPHI2005_UPPER}
  TStringGridHelper = class helper for TStringGrid
  private

  public
    procedure InitGridForTags;

    procedure LoadExifTags(theTags:TThumbsBrowser_MetaTags);
    procedure SaveExifTags(theTags:TThumbsBrowser_MetaTags);

    procedure LoadIptcTags(theTags:TThumbsBrowser_MetaTags);
    procedure SaveIptcTags(theTags:TThumbsBrowser_MetaTags);

    procedure LoadXmpTags(theTags:TThumbsBrowser_MetaTags);
    procedure SaveXmpTags(theTags:TThumbsBrowser_MetaTags);

    procedure LoadCommonTags(theTags:TThumbsBrowser_MetaTags);
    procedure SaveCommonTags(theTags:TThumbsBrowser_MetaTags);
  end;
  {$ENDIF}


implementation
 uses NWSComps_ThumbsBrowser_RES, NWSComps_ThumbsBrowser_RES_CONST;


procedure CheckCommonTagsConsistency(theTags: TThumbsbrowser_MetaTags);
var
i:integer;
idx: integer;
aCommonTag: TTBCommonTag;
  j: Integer;
  bWrong: boolean;
begin
  for I := theTags.CommonTags.Count-1 downto 0 do
  begin
    aCommonTag := theTags.CommonTags[i];
    bWrong := false;

    for j := 0 to aCommonTag.LinkedEXIFTags.count-1 do
    begin
      if bWrong then break;
      idx := theTags.ExifTags.GetTagIdx(aCommonTag.LinkedEXIFTags[j]);
      if idx = -1 then
      begin
        bWrong := true;
        break;
      end;
    end;
    for j := 0 to aCommonTag.LinkedIptcTags.count-1 do
    begin
      if bWrong then break;
      idx := theTags.IptcTags.GetTagIdx(aCommonTag.LinkedIptcTags[j]);
      if idx = -1 then
      begin
        bWrong := true;
        break;
      end;
    end;
    for j := 0 to aCommonTag.LinkedXmpTags.count-1 do
    begin
      if bWrong then break;
      idx := theTags.XmpTags.GetTagIdx(aCommonTag.LinkedXmpTags[j]);
      if idx = -1 then
      begin
        bWrong := true;
        break;
      end;
    end;

    if bWrong then
      theTags.CommonTags.delete(i);
  end;
end;

{$IFDEF NWSCOMPS_DELPHI2005_UPPER}

{ TStringGridHelper }
procedure TStringGridHelper.InitGridForTags;
begin
  RowCount := 2;
  ColCount := 2;
  FixedRows := 1;
  FixedCols := 1;
  Cells[0,0] := TBResStr[IDRS_METAHLP_Index];
  Cells[1,0] := TBResStr[IDRS_METAHLP_Field];
  Cells[0,1] := '';
  Cells[1,1] := '';
  ColWidths[0] := 30;
  ColWidths[1] := max(80, width - ColWidths[0] - 20);

end;

procedure TStringGridHelper.LoadCommonTags(theTags: TThumbsBrowser_MetaTags);
var
  I, r: Integer;
begin
  InitGridForTags;

  RowCount := theTags.CommonTags.count + 1;

  r := 0;
  for I := 0 to theTags.CommonTags.count - 1 do
  begin
    inc(r);
    cells[0, r] := inttostr(i);
    cells[1, r] := theTags.CommonTags.TagAsStr[i];
  end;
end;

procedure TStringGridHelper.LoadExifTags(theTags:TThumbsBrowser_MetaTags);
var
  I, r: Integer;
begin
  InitGridForTags;

  RowCount := theTags.ExifTags.count + 1;
  r := 0;
  for I := 0 to theTags.ExifTags.count -1 do
  begin
    inc(r);
    cells[0, r] := inttostr(i);
    cells[1, r] := theTags.ExifTags.TagAsStr[i];
  end;
end;

procedure TStringGridHelper.LoadIptcTags(theTags:TThumbsBrowser_MetaTags);
var
  I, r: Integer;
begin
  InitGridForTags;

  RowCount := theTags.IptcTags.count + 1;

  r := 0;
  for I := 0 to theTags.IptcTags.count -1 do
  begin
    inc(r);
    cells[0, r] := inttostr(i);
    cells[1, r] := theTags.IptcTags.TagAsStr[i];
  end;
end;

procedure TStringGridHelper.LoadXmpTags(theTags:TThumbsBrowser_MetaTags);
var
  I, r: Integer;
begin
  InitGridForTags;

  RowCount := theTags.XmpTags.count + 1;

  r := 0;
  for I := 0 to theTags.XmpTags.count -1 do
  begin
    inc(r);
    cells[0, r] := inttostr(i);
    cells[1, r] := theTags.XmpTags.TagAsStr[i];
  end;
end;

procedure TStringGridHelper.SaveCommonTags(theTags:TThumbsBrowser_MetaTags);
var
  r: Integer;
begin
  if (ColCount<2) then
    raise Exception.Create(TBResStr[IDRS_METAHLP_ErrorParsingWrongGridFormat]);

  theTags.CommonTags.Clear;
  for r := 1 to RowCount -1 do
  begin
    theTags.CommonTags.Add(cells[1, r]);
  end;
  CheckCommonTagsConsistency(theTags);

end;

procedure TStringGridHelper.SaveExifTags(theTags:TThumbsBrowser_MetaTags);
var
  r: Integer;
begin
  if (ColCount<2) then
    raise Exception.Create(TBResStr[IDRS_METAHLP_ErrorParsingWrongGridFormat]);

  theTags.ExifTags.Clear;
  for r := 1 to RowCount -1 do
  begin
    theTags.ExifTags.Add(cells[1, r]);
  end;
  CheckCommonTagsConsistency(theTags);
end;

procedure TStringGridHelper.SaveIptcTags(theTags:TThumbsBrowser_MetaTags);
var
  r: Integer;
begin
  if (ColCount<2) then
    raise Exception.Create(TBResStr[IDRS_METAHLP_ErrorParsingWrongGridFormat]);

  theTags.IptcTags.Clear;
  for r := 1 to RowCount -1 do
  begin
    theTags.IptcTags.Add(cells[1, r]);
  end;
  CheckCommonTagsConsistency(theTags);
end;

procedure TStringGridHelper.SaveXmpTags(theTags:TThumbsBrowser_MetaTags);
var
  r: Integer;
begin
  if (ColCount<2) then
    raise Exception.Create(TBResStr[IDRS_METAHLP_ErrorParsingWrongGridFormat]);

  theTags.XmpTags.Clear;
  for r := 1 to RowCount -1 do
  begin
    theTags.XmpTags.Add(cells[1, r]);
  end;
  CheckCommonTagsConsistency(theTags);
end;


{$ENDIF}


end.


