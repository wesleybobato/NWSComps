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
unit NWSComps_IEPaintEngine_Reg;
{$R-}
{$Q-}
{$R '..\_res\NWSComps_Bundle.DCR'}

interface

uses classes;

procedure Register;

implementation
uses NWSComps_IEPaintEngine_manager;

procedure Register;
begin
  RegisterComponents('NWSComps', [TImageEnPaintEngineManager]);
end;




end.
