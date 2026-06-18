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
unit NWSComps_WIA;
{$R-}
{$Q-}

interface


uses
  Windows, Classes, Sysutils, Graphics, comctrls, hyieutils, hyiedefs, ieWIA;





type
 // TIEWIAItem = iewia.TIEWiaItem;

  TNWSComps_WIA = class(TIEWia)
  private

  protected

  public

  procedure FillList(Items:TList; IncludeDescription:boolean);
  procedure List_AddChildsOf(WIA:TNWSComps_WIA; Items:TList; ItemsParent: TIEWiaItem; IncludeDescription:boolean);

  end;


implementation

//Francesco Savastano
procedure TNWSComps_WIA.FillList(Items:TList; IncludeDescription:boolean);
begin
 // CheckConnectToDefault;
  if not assigned(Device) then
    ConnectTo(0);
  if assigned(Device) then
  begin
    List_AddChildsOf(self, Items, Device, IncludeDescription);
  end;
end;

procedure TNWSComps_WIA.List_AddChildsOf(WIA:TNWSComps_WIA; Items:TList; ItemsParent: TIEWiaItem; IncludeDescription:boolean);
var
  i: integer;
begin
  if assigned(ItemsParent) then
    for i := 0 to ItemsParent.Children.Count - 1 do
    begin
      if not WIA.IsItemDeleted(ItemsParent.Children[i]) then
      begin
      //  showmessage(BuildItemName(WIA, ItemsParent.Children[i],IncludeDescription));
        Items.Add(ItemsParent.Children[i]);

        List_AddChildsOf(WIA, Items, ItemsParent.Children[i], IncludeDescription);
      end;
    end;
end;
//Francesco Savastano
end.
