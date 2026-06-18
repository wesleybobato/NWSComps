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
unit NWSComps_ThumbsBrowser_Sorting_Utils;
{$R-}
{$Q-}
interface
uses NWSComps_ThumbsBrowser_Thumbs, NWSComps_ThumbsBrowser_Utils_Types;

type
 TCompType = (compAscending, compDescending);
 TCompFunction =  function(p1,p2:pointer): integer;
 TCompMethod =  function(p1,p2:pointer): integer of object;



function ThumbSort_TopTitleAsc(p1,p2:pointer): integer;
function ThumbSort_BottomTitleAsc(p1,p2:pointer): integer;

function ThumbSort_NotSortedAsc(p1,p2:pointer): integer;
function ThumbSort_NameAsc(p1,p2:pointer): integer;
function ThumbSort_NameWithPathAsc(p1,p2:pointer): integer;
function ThumbSort_NameNaturalAsc(p1,p2:pointer): integer;
function ThumbSort_NameWithPathNaturalAsc(p1,p2:pointer): integer;
function ThumbSort_FolderAsc(p1,p2:pointer): integer;
function ThumbSort_FolderNaturalAsc(p1,p2:pointer): integer;
function ThumbSort_FileTypeAsc(p1,p2:pointer): integer;
function ThumbSort_DateAsc(p1,p2:pointer): integer;
function ThumbSort_ExifDateAsc(p1,p2:pointer): integer;
function ThumbSort_SizeAsc(p1,p2:pointer): integer;


function ThumbSort_TopTitleDesc(p1,p2:pointer): integer;
function ThumbSort_BottomTitleDesc(p1,p2:pointer): integer;
function ThumbSort_NotSortedDesc(p1,p2:pointer): integer;
function ThumbSort_NameDesc(p1,p2:pointer): integer;
function ThumbSort_NameWithPathDesc(p1,p2:pointer): integer;
function ThumbSort_NameNaturalDesc(p1,p2:pointer): integer;
function ThumbSort_NameWithPathNaturalDesc(p1,p2:pointer): integer;
function ThumbSort_FolderDesc(p1,p2:pointer): integer;
function ThumbSort_FolderNaturalDesc(p1,p2:pointer): integer;
function ThumbSort_FileTypeDesc(p1,p2:pointer): integer;
function ThumbSort_DateDesc(p1,p2:pointer): integer;
function ThumbSort_ExifDateDesc(p1,p2:pointer): integer;
function ThumbSort_SizeDesc(p1,p2:pointer): integer;


implementation
uses  classes, sysutils, math,NWSComps_ThumbsBrowser_utils;


function ThumbSort_NotSortedAsc(p1,p2:pointer): integer;
begin
  result := 0;
end;

function ThumbSort_TopTitleAsc(p1,p2:pointer): integer;
begin
  result := compareText(TThumbEX(p1).TopTitle, TThumbEX(p2).TopTitle);
end;

function ThumbSort_BottomTitleAsc(p1,p2:pointer): integer;
begin
  result := compareText(TThumbEX(p1).BottomTitle, TThumbEX(p2).BottomTitle);
end;

function ThumbSort_NameAsc(p1,p2:pointer): integer;
begin
  result := compareText(TThumbEX(p1).SourceFileNameShort, TThumbEX(p2).SourceFileNameShort);
end;

function ThumbSort_NameWithPathAsc(p1,p2:pointer): integer;
begin
  result := compareText(TThumbEX(p1).SourceFileName, TThumbEX(p2).SourceFileName);
end;

function ThumbSort_NameNaturalAsc(p1,p2:pointer): integer;
begin
  result := TBCompareNatural(TThumbEX(p1).SourceFileNameShort, TThumbEX(p2).SourceFileNameShort, true);
end;

function ThumbSort_NameWithPathNaturalAsc(p1,p2:pointer): integer;
begin
  result := TBCompareNatural(TThumbEX(p1).SourceFileName, TThumbEX(p2).SourceFileName, true);
end;

function ThumbSort_FolderAsc(p1,p2:pointer): integer;
begin
  result := compareText(TThumbEX(p1).SourceFilePath, TThumbEX(p2).SourceFilePath);
end;

function ThumbSort_FolderNaturalAsc(p1,p2:pointer): integer;
begin
  result := TBCompareNatural(TThumbEX(p1).SourceFilePath, TThumbEX(p2).SourceFilePath);
end;

function ThumbSort_FileTypeAsc(p1,p2:pointer): integer;
begin
  result := compareStr(TThumbEX(p1).SourceFileExtension, TThumbEX(p2).SourceFileExtension);
end;

function ThumbSort_DateAsc(p1,p2:pointer): integer;
var
d1,d2: TDatetime;
begin
d1 := TThumbEX(p1).SourceFileDate;
d2 := TThumbEX(p2).SourceFileDate;

  if d1>d2 then
    result := 1
  else if d1<d2 then
       result := -1
       else
       result := 0;

end;

function ThumbSort_ExifDateAsc(p1,p2:pointer): integer;
var
d1,d2: TDatetime;
begin
d1 := TThumbEX(p1).SourceExifFileDate;
d2 := TThumbEX(p2).SourceExifFileDate;

  if d1>d2 then
    result := 1
  else if d1<d2 then
       result := -1
       else
       result := 0;

end;

function ThumbSort_SizeAsc(p1,p2:pointer): integer;
begin
  result := TThumbEX(p1).SourceFileSize - TThumbEX(p2).SourceFileSize;
end;

function ThumbSort_TopTitleDesc(p1,p2:pointer): integer;
begin
  result := - ThumbSort_TopTitleAsc(p1, p2);
end;

function ThumbSort_BottomTitleDesc(p1,p2:pointer): integer;
   begin
  result := - ThumbSort_BottomTitleAsc(p1, p2);
end;

function ThumbSort_NotSortedDesc(p1,p2:pointer): integer;
     begin
  result := - ThumbSort_NotSortedAsc(p1, p2);
     end;

function ThumbSort_NameDesc(p1,p2:pointer): integer;
begin
  result := - ThumbSort_NameAsc(p1, p2);
   end;

function ThumbSort_NameWithPathDesc(p1,p2:pointer): integer;
begin
  result := - ThumbSort_NameWithPathAsc(p1, p2);
  end;

function ThumbSort_NameNaturalDesc(p1,p2:pointer): integer;
begin
  result := - ThumbSort_NameNaturalAsc(p1, p2);
end;

function ThumbSort_NameWithPathNaturalDesc(p1,p2:pointer): integer;
begin
  result := - ThumbSort_NameWithPathNaturalAsc(p1, p2);
end;

function ThumbSort_FolderDesc(p1,p2:pointer): integer;
begin
  result := - ThumbSort_FolderAsc(p1, p2);
end;

function ThumbSort_FolderNaturalDesc(p1,p2:pointer): integer;
begin
  result := - ThumbSort_FolderNaturalAsc(p1, p2);
end;

function ThumbSort_FileTypeDesc(p1,p2:pointer): integer;
begin
  result := - ThumbSort_FileTypeAsc(p1, p2);
end;

function ThumbSort_DateDesc(p1,p2:pointer): integer;
begin
  result := - ThumbSort_DateAsc(p1, p2);
end;

function ThumbSort_ExifDateDesc(p1,p2:pointer): integer;
begin
  result := - ThumbSort_ExifDateAsc(p1, p2);
end;

function ThumbSort_SizeDesc(p1,p2:pointer): integer;
begin
  result := - ThumbSort_SizeAsc(p1, p2);
end;





initialization

finalization

end.
