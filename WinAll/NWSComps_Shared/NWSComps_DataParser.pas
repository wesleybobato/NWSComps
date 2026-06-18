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
unit NWSComps_DataParser;
{$R-}
{$Q-}
interface

uses
Windows, Messages, SysUtils, Classes, Graphics, contnrs, inifiles;

Function DataParser_GetDecimalSeparator: char;
procedure DataParser_SetSysDecimalSeparator(value:char);

const
   G_CONST_NWSCOMPS_PARSER_DATANOTFOUND: integer = -1234;
   G_CONST_NWSCOMPS_PARSER_INIFILE_DATA_MARKER = 'data_';
   G_CONST_NWSCOMPS_PARSER_FILE_TAG_START = '_TAG_START';
   G_CONST_NWSCOMPS_PARSER_FILE_TAG_END = '_TAG_END';

   G_CONST_NWSCOMPS_PARSER_FILE_TAG_TYPE_FLOAT = 'TYPEFLOAT';
   G_CONST_NWSCOMPS_PARSER_FILE_TAG_TYPE_BOOL = 'TYPEBOOL';
   G_CONST_NWSCOMPS_PARSER_FILE_TAG_TYPE_INT = 'TYPEINT';

   G_CONST_NWSCOMPS_PARSER_FILE_TAG_SIZE_STRING = 1;
   G_CONST_NWSCOMPS_PARSER_FILE_TAG_SIZE_FLOAT = 3;
   G_CONST_NWSCOMPS_PARSER_FILE_TAG_SIZE_BOOL = 2;
   G_CONST_NWSCOMPS_PARSER_FILE_TAG_SIZE_INT = 2;

type


  TNWSComps_DataParserTag = record
    StartIdx: integer;
    EndIdx: integer;
    Name: string;
  end;



  TNWSComps_DataParser = Class(TPersistent)
     private

        fSl: TStringList;
        fCurrentIdx: integer;
        fCurrentTag: TNWSComps_DataParserTag;
        fbSequentialFindTag: boolean;

        function GetTagNameStart(const Tagname: string): string;
        function GetTagNameEnd(const Tagname: string): string;


        function FindTag_Generic(const TagName: string): integer;
        function FindTag_Start(const TagName: string): integer;
        function FindTag_End(const TagName: string): integer;

        function ReadElement(firstIdx, DataIdx: integer; var value: string): boolean;
        function ReadElementF(firstIdx, DataIdx: integer; var value: double): boolean;
        function ReadElementB(firstIdx, DataIdx: integer; var value: boolean): boolean;
        function ReadElementI(firstIdx, DataIdx: integer; var value: integer): boolean;
     public
       function TagExists(const TagName: string): boolean;
       function GetNextString: string;
       function GetNextTagStart: string;
       function GetNextTagEnd: string;

       function ReadTags_FromIniFile(theIniFile: TInifile; theSection: string): boolean;
       function ReadTags_FromTextFile(const theFilename: string): boolean;
       function ReadTags_FromStream(const thestream: TStream): boolean;

       function WriteTags_ToIniFile(theIniFile: TInifile; theSection: string): boolean;
       function WriteTags_ToTextFile(const theFilename: string): boolean;
       function WriteTags_ToStream(const thestream: TStream): boolean;


       procedure AddTag(const TagName: string; const Value: string);
       procedure AddOpenTag(const TagName: string);
       procedure AddValue(const Value: string);
       procedure AddValueF(const Value: double);
       procedure AddValueB(const Value: boolean);
       procedure AddValueI(const Value: integer);
       procedure AddCloseTag(const TagName: string);

       constructor Create(const bSequentialFindTag: boolean); reintroduce;
       Destructor Destroy; override;

       Function ParseTag(const TagName: string; var Value: string): boolean;
       Function ParseTagF(const TagName: string; var Value: double): boolean;
       Function ParseTagB(const TagName: string; var Value: boolean): boolean;
       Function ParseTagI(const TagName: string; var Value: integer): boolean;

       Function ParseTag_Element(const TagName: string; const DataIdx: integer; var Value: string): boolean;
       Function ParseTag_ElementF(const TagName: string; const DataIdx: integer; var Value: double): boolean;
       Function ParseTag_ElementB(const TagName: string; const DataIdx: integer; var Value: boolean): boolean;
       Function ParseTag_ElementI(const TagName: string; const DataIdx: integer; var Value: integer): boolean;

       Function IsValid: boolean;
  End;


implementation

   uses math;
   {$I ..\_inc\NWSComps_Shared.inc}
   Function DataParser_GetDecimalSeparator: char;
   begin
 {$IfDef NWSCOMPS_DXE2_UPPER}
      result := sysutils.FormatSettings.DecimalSeparator;
 {$ELSE}
      result := sysutils.DecimalSeparator;
 {$EndIf}

   end;


   procedure DataParser_SetSysDecimalSeparator(value:char);
   begin
    {$IfDef NWSCOMPS_DXE2_UPPER}
      sysutils.FormatSettings.DecimalSeparator := value;
 {$ELSE}
      sysutils.DecimalSeparator := value;
 {$EndIf}

   end;

   constructor TNWSComps_DataParser.Create(const bSequentialFindTag: boolean);
   begin
     fsl := TStringlist.Create;

     fCurrentIdx := 0;
     fCurrentTag.StartIdx := 0;
     fCurrentTag.EndIdx := 0;
     fCurrentTag.Name := '';
     fbSequentialFindTag := bSequentialFindTag;

   end;

   Destructor TNWSComps_DataParser.Destroy;
   begin
     fsl.Free;
   end;

   function TNWSComps_DataParser.ReadTags_FromIniFile(theIniFile: TInifile; theSection: string): boolean;
     procedure purifyImportList(var list: Tstringlist);
     var
      k, m: integer;
      s: string;
    begin
      for k := 0 to list.Count - 1 do
      begin
        for m := 1 to length(list.strings[k]) do
        begin
          if list.strings[k][m] = '=' then
            break;
        end;
        if m < length(list.strings[k]) then
        begin
          s := list.strings[k];
          delete(s, 1, m);
          list.strings[k] := s;
        end;
      end;
    end;

   begin
     result := true;
     try
       theIniFile.ReadSectionvalues(theSection, fsl);
       purifyImportList(fsl);
     Except
       result := False;
     end;
   end;

   function TNWSComps_DataParser.ReadTags_FromTextFile(const theFilename: string): boolean;
   begin
     result := true;
     try
       fsl.loadfromFile(thefilename);

     Except
       result := False;
     end;
   end;
 
   function TNWSComps_DataParser.ReadTags_FromStream(const theStream: TStream): boolean;
   begin
     result := true;
     try
       fsl.loadfromStream(theStream);

     Except
       result := False;
     end;
   end;

   function TNWSComps_DataParser.WriteTags_ToIniFile(theIniFile: TInifile; theSection: string): boolean;
   var
   i: integer;
   begin
     result := true;
     try
       for i := 0 to fsl.Count - 1 do
        theIniFile.WriteString(theSection, G_CONST_NWSCOMPS_PARSER_INIFILE_DATA_MARKER + inttostr(i), fsl.strings[i]);

     Except
       result := False;
     end;
   end;

   function TNWSComps_DataParser.WriteTags_ToTextFile(const theFilename: string): boolean;
   begin
     result := true;
     try
       fsl.SaveToFile(thefilename);
     Except
       result := False;
     end;
   end;

   function TNWSComps_DataParser.WriteTags_ToStream(const thestream: TStream): boolean;
   begin
     result := true;
     try
       fsl.SaveToStream(thestream);
     Except
       result := False;
     end;
   end;


   procedure TNWSComps_DataParser.AddTag(const TagName: string; const Value: string);
   begin
      AddOpenTag(TagName);
      fsl.Add(Value);
      AddCloseTag(TagName);
   end;

   procedure TNWSComps_DataParser.AddOpenTag(const TagName: string);
   begin
     fsl.Add(GetTagNameStart(TagName));
   end;

   procedure TNWSComps_DataParser.AddValue(const Value: string);
   begin
     fsl.Add(Value);
   end;

   procedure TNWSComps_DataParser.AddValueF(const Value: double);
   begin
     fsl.Add(G_CONST_NWSCOMPS_PARSER_FILE_TAG_TYPE_FLOAT);
     fsl.Add(DataParser_GetDecimalSeparator);
     fsl.Add(floattoStr(Value));
   end;

   procedure TNWSComps_DataParser.AddValueB(const Value: boolean);
   begin
     fsl.Add(G_CONST_NWSCOMPS_PARSER_FILE_TAG_TYPE_BOOL);
     if Value then
       fsl.add('1')
     else
       fsl.add('0');
   end;

   procedure TNWSComps_DataParser.AddValueI(const Value: integer);
   begin
     fsl.Add(G_CONST_NWSCOMPS_PARSER_FILE_TAG_TYPE_INT);
     fsl.Add(inttoStr(Value));
   end;

   procedure TNWSComps_DataParser.AddCloseTag(const TagName: string);
   begin
     fsl.Add(GetTagNameEnd(TagName));
   end;


   function TNWSComps_DataParser.GetTagNameStart(const Tagname: string): string;
   begin
     result := Tagname + G_CONST_NWSCOMPS_PARSER_FILE_TAG_START;
   end;

   function TNWSComps_DataParser.GetTagNameEnd(const Tagname: string): string;
   begin
     result := Tagname + G_CONST_NWSCOMPS_PARSER_FILE_TAG_END;
   end;


   function TNWSComps_DataParser.TagExists(const TagName: string): boolean;
   begin
      result := (FindTag_Start(tagname) <> G_CONST_NWSCOMPS_PARSER_DATANOTFOUND) and
                 (FindTag_End(tagname) <> G_CONST_NWSCOMPS_PARSER_DATANOTFOUND);
   end;


   function TNWSComps_DataParser.GetNextString: string;
   begin
     result := '';
     if fCurrentIdx > fSl.count-1 then EXIT;


     result := fsl[fCurrentIdx + 1];
   end;

   function TNWSComps_DataParser.GetNextTagStart: string;
   var
     i: integer;
     bFound: boolean;
   begin
     result := '';
     if fCurrentIdx > fSl.count-1 then EXIT;

     bFound := False;
     i := fCurrentIdx;
     while (i < fsl.count) and (not bFound) do
     begin
       if pos(G_CONST_NWSCOMPS_PARSER_FILE_TAG_START, fsl[i]) > 0 then
       begin
         result := fsl[i];
         bFound := True;
       end;
     end;

   end;

   function TNWSComps_DataParser.GetNextTagEnd: string;
   var
     i: integer;
     bFound: boolean;
   begin
     result := '';
     if fCurrentIdx > fSl.count-1 then EXIT;

     bFound := False;
     i := fCurrentIdx;
     while (i < fsl.count) and (not bFound) do
     begin
       if pos(G_CONST_NWSCOMPS_PARSER_FILE_TAG_END, fsl[i]) > 0 then
       begin
         result := fsl[i];
         bFound := True;
       end;
     end;
   end;

   function TNWSComps_DataParser.FindTag_Generic(const TagName: string): integer;
   //--------------------------------------------------------------
   procedure Gofind(var Found: boolean; var FoundIdx: integer; fromIdx, ToIdx: integer);
   var
     i: integer;
   begin
     Found := False;
     FoundIdx := G_CONST_NWSCOMPS_PARSER_DATANOTFOUND;
     i:=0;
     while (i<= ToIdx) and (not Found) do
     begin
       if comparetext(fsl[i], Tagname) = 0 then
       begin
         Found := True;
         FoundIdx := i;
       end
       else
         inc(i);
     end;
   end;
   //--------------------------------------------------------------

   var
   bFound: boolean;
   fromIdx, ToIdx: integer;
   begin
     ToIdx := fsl.Count-1;
     if fbSequentialFindTag then
      fromIdx := 0
     else
      fromIdx := fCurrentIdx;


     GoFind(bFound, result, fromIdx, ToIdx);

     if (not bFound) and fbSequentialFindTag and (fCurrentIdx >0) then
     begin  //if not found and we started search from current index make another search from start
       ToIdx := fCurrentIdx;
       fromIdx := 0;
       GoFind(bFound, result, fromIdx, ToIdx);
     end;

   end;

   function TNWSComps_DataParser.FindTag_Start(const TagName: string): integer;
   begin
     result := FindTag_Generic(GetTagNameStart(TagName));
   end;

   function TNWSComps_DataParser.FindTag_End(const TagName: string): integer;
   begin
     result := FindTag_Generic(GetTagNameEnd(TagName));
   end;


   function TNWSComps_DataParser.ReadElement(firstIdx, DataIdx: integer; var value: string): boolean;
   var
     idx: integer;
   begin
     try
     idx := firstIdx + DataIdx * G_CONST_NWSCOMPS_PARSER_FILE_TAG_SIZE_STRING;
     value := fsl[idx];
     result := True;
     except
       result := False;
     end;
   end;

   function TNWSComps_DataParser.ReadElementF(firstIdx, DataIdx: integer; var value: double): boolean;
   var
   sep, valueType: string;
   aFormat: TFormatSettings;
   idx: integer;
   begin
     result := False;
     idx := firstIdx + DataIdx * G_CONST_NWSCOMPS_PARSER_FILE_TAG_SIZE_FLOAT;
      ValueType := fsl[idx];           //read type of value
           if ValueType = G_CONST_NWSCOMPS_PARSER_FILE_TAG_TYPE_FLOAT then
           begin
             try
               sep := fsl[idx + 1]; //read decimal separator
               aFormat.DecimalSeparator := sep[1];
               value := strtofloat(fsl[idx + 2], aFormat);   //read and convert float value
               result := True;


             finally

             end;


           end;
   end;

   function TNWSComps_DataParser.ReadElementB(firstIdx, DataIdx: integer; var value: boolean): boolean;
   var
    valueType: string;
    s: string;
    idx: integer;
   begin
     result := False;

     idx := firstIdx + DataIdx * G_CONST_NWSCOMPS_PARSER_FILE_TAG_SIZE_BOOL;
     ValueType := fsl[idx];           //read type of value
     if ValueType = G_CONST_NWSCOMPS_PARSER_FILE_TAG_TYPE_BOOL then
     begin
         s := fsl[idx + 1];   //read string value
         if s='0' then
         begin
           value := False;
           result := True;
         end
         else if s='1' then
         begin
           value := True;
           result := True;
         end;
     end;
   end;

   function TNWSComps_DataParser.ReadElementI(firstIdx, DataIdx: integer; var value: integer): boolean;
   var
   valueType: string;
   idx: integer;
   begin
     result := False;

     idx := firstIdx + DataIdx * G_CONST_NWSCOMPS_PARSER_FILE_TAG_SIZE_INT;
     ValueType := fsl[idx];           //read type of value
     if ValueType = G_CONST_NWSCOMPS_PARSER_FILE_TAG_TYPE_INT then
     begin
       try
         value := strtoint(fsl[idx + 1]);    //read and convert value
         result := True;
       finally

       end;

     end;
   end;

   Function TNWSComps_DataParser.ParseTag(const TagName: string; var Value: string): boolean;
   var
     istartTag, iEndTag: integer;
   begin
     result := False;

     istartTag := FindTag_Start(Tagname);
     if istartTag <> G_CONST_NWSCOMPS_PARSER_DATANOTFOUND then
     begin
       iEndTag := FindTag_End(Tagname);
       if iEndTag <> G_CONST_NWSCOMPS_PARSER_DATANOTFOUND then
       begin


         if iEndTag - istartTag > G_CONST_NWSCOMPS_PARSER_FILE_TAG_SIZE_STRING  then  //else error
         begin
           Value := fsl[istartTag + 1];
           result := True;

           with fCurrentTag do
           begin
             StartIdx := istartTag;
             EndIdx := iEndTag;
             Name := Tagname;
           end;
           if fbSequentialFindTag then
             fCurrentIdx := iEndTag;
         end;

       end;
     end;

   end;



   Function TNWSComps_DataParser.ParseTagF(const TagName: string; var Value: double): boolean;
   var
     istartTag, iEndTag: integer;

   begin
     result := False;

     istartTag := FindTag_Start(Tagname);
     if istartTag <> G_CONST_NWSCOMPS_PARSER_DATANOTFOUND then
     begin
       iEndTag := FindTag_End(Tagname);
       if iEndTag <> G_CONST_NWSCOMPS_PARSER_DATANOTFOUND then
       begin


         if iEndTag - istartTag > G_CONST_NWSCOMPS_PARSER_FILE_TAG_SIZE_FLOAT  then  //else error
         begin
           result := ReadElementF(istartTag+1, 0, value);

           if result then
           begin
             with fCurrentTag do
             begin
               StartIdx := istartTag;
               EndIdx := iEndTag;
               Name := Tagname;
             end;
             if fbSequentialFindTag then
               fCurrentIdx := iEndTag;
           end;


         end;

       end;
     end;

   end;



   Function TNWSComps_DataParser.ParseTagB(const TagName: string; var Value: boolean): boolean;
   var
     istartTag, iEndTag: integer;

   begin
     result := False;

     istartTag := FindTag_Start(Tagname);
     if istartTag <> G_CONST_NWSCOMPS_PARSER_DATANOTFOUND then
     begin
       iEndTag := FindTag_End(Tagname);
       if iEndTag <> G_CONST_NWSCOMPS_PARSER_DATANOTFOUND then
       begin


         if iEndTag - istartTag > G_CONST_NWSCOMPS_PARSER_FILE_TAG_SIZE_BOOL then  //else error
         begin
           result := ReadElementB(istartTag+1, 0, value);

           if result then
           begin
             with fCurrentTag do
             begin
               StartIdx := istartTag;
               EndIdx := iEndTag;
               Name := Tagname;
             end;
             if fbSequentialFindTag then
               fCurrentIdx := iEndTag;
           end;
         end;


       end;


     end;

   end;

   Function TNWSComps_DataParser.ParseTagI(const TagName: string; var Value: integer): boolean;
   var
     istartTag, iEndTag: integer;

   begin
     result := False;

     istartTag := FindTag_Start(Tagname);
     if istartTag <> G_CONST_NWSCOMPS_PARSER_DATANOTFOUND then
     begin
       iEndTag := FindTag_End(Tagname);
       if iEndTag <> G_CONST_NWSCOMPS_PARSER_DATANOTFOUND then
       begin


         if iEndTag - istartTag > G_CONST_NWSCOMPS_PARSER_FILE_TAG_SIZE_INT then  //else error
         begin
           result := ReadElementI(istartTag + 1, 0, value);

           if result then
           begin
             with fCurrentTag do
             begin
               StartIdx := istartTag;
               EndIdx := iEndTag;
               Name := Tagname;
             end;
             if fbSequentialFindTag then
               fCurrentIdx := iEndTag;
           end;


         end;

       end;
     end;


   end;

   Function TNWSComps_DataParser.ParseTag_Element(const TagName: string; const DataIdx: integer; var Value: string): boolean;
   begin
     result := fCurrentTag.Name = tagname;
     if result then //the last tag is compatible
     begin
       result := fcurrenttag.StartIdx + 1 + dataidx * G_CONST_NWSCOMPS_PARSER_FILE_TAG_SIZE_STRING < fcurrenttag.EndIdx;
       if result then
         result := readelement(fcurrenttag.StartIdx + 1, dataidx, value);

     end
     else   //the last tag explored is not compatible
     begin
       if ParseTag(tagname, Value) then   //this  sets the last tag
         result := ParseTag_Element(tagname, dataIdx, value) //recalls itself
       else
         result := false;
     end;

   end;



   Function TNWSComps_DataParser.ParseTag_ElementF(const TagName: string; const DataIdx: integer; var Value: double): boolean;
   begin
     result := fCurrentTag.Name = tagname;
     if result then //the last tag is compatible
     begin
       result := fcurrenttag.StartIdx + 1 + dataidx * G_CONST_NWSCOMPS_PARSER_FILE_TAG_SIZE_FLOAT< fcurrenttag.EndIdx;
       if result then
         result := readelementF(fcurrenttag.StartIdx + 1, dataidx, value);
     end
     else   //the last tag explored is not compatible
     begin
       if ParseTagF(tagname, Value) then   //this  sets the last tag
         result := ParseTag_ElementF(tagname, dataIdx, value) //recalls itself
       else
         result := false;
     end;

   end;


   Function TNWSComps_DataParser.ParseTag_ElementB(const TagName: string; const DataIdx: integer; var Value: boolean): boolean;
   begin
     result := fCurrentTag.Name = tagname;
     if result then //the last tag is compatible
     begin
       result := fcurrenttag.StartIdx + 1 + dataidx * G_CONST_NWSCOMPS_PARSER_FILE_TAG_SIZE_BOOL< fcurrenttag.EndIdx;
       if result then
         result := readelementB(fcurrenttag.StartIdx + 1, dataidx, value);
     end
     else   //the last tag explored is not compatible
     begin
       if ParseTagB(tagname, Value) then   //this  sets the last tag
         result := ParseTag_ElementB(tagname, dataIdx, value) //recalls itself
       else
         result := false;
     end;

   end;


   Function TNWSComps_DataParser.ParseTag_ElementI(const TagName: string; const DataIdx: integer; var Value: integer): boolean;
   begin
     result := fCurrentTag.Name = tagname;
     if result then //the last tag is compatible
     begin
       result := fcurrenttag.StartIdx + 1 + dataidx * G_CONST_NWSCOMPS_PARSER_FILE_TAG_SIZE_INT< fcurrenttag.EndIdx;
       if result then
         result := readelementI(fcurrenttag.StartIdx + 1, dataidx, value);
     end
     else   //the last tag explored is not compatible
     begin
       if ParseTagI(tagname, Value) then   //this  sets the last tag
         result := ParseTag_ElementI(tagname, dataIdx, value) //recalls itself
       else
         result := false;
     end;

   end;


   Function TNWSComps_DataParser.IsValid: boolean;
   begin
     result := True;
   end;


end.
