unit NWSComps_RGBCurves_Reg_Valid;

// TRGBCurves v. 3.0
// Current Version Release Date: September 2005
// CopyRight (C) 2003-2005 Francesco Savastano All Rights Reserved

// Description:
// Component to edit RGB channels in 32, 24 bits TBitmap and in 24 bits TIEBitmap.
// The channels (R,G,B and Luminance) are manipulated using a "Curves" interface like the one in Photoshop

// To support TIEBitmap you have to download and install the ImageEn component suite that
// is a powerful graphics library for Delphi and can be downloaded at www.hicomponents.com
// If you don't wish support for TIEBitmap just undefine the compile directive  USEIMAGEEN


// Email of the author: nws@centurybyte.com
// Web Site http://new-world-software.com/Components.htm

//This software comes without any warranty either implied or expressed.
//In no case shall the author be liable for any damage or unwanted behavior
// of any computer hardware and/or software. Bug reports or fixes may be sent
// to the author, who may or may not act on them as he desires.

//You cannot DISTRIBUTE THIS SOURCE CODE OR ITS COMPILED .DCU IN ANY FORM.

//This unit cannot be included in any commercial, shareware or freeware DELPHI
//libraries or components.

// You can change the code for personal use only: you cannot remove this
// header and the changes you make to the code do not entitle you to distribute it.

interface

uses classes;



function RegCode: integer;

implementation



const
  cifr = 797256513;

function Regcode: integer;
begin
  result := cifr;

end;




end.
