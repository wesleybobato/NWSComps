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
unit NWSComps_IEPaintEngine_Color;
{$R-}
{$Q-}
//TImageEnPaintEngine v. 4
// Color Conversions and utilities for ImageEn Paint Engine
// Copyright (c) 2003-2011 Francesco Savastano
// You cannot distribute this unit in any form!

interface
uses

  Windows, SysUtils, Classes, Graphics, math;


function RGBtoRGBTriple(red, green, blue: integer): TRGBTriple;
function HSVToRGBTriple(H, S, V: single): TRGBTriple;
procedure RGBTripleToHSV(RGBTriple: TRGBTriple;
  var H, S, V: single);
procedure rgb2hls(c1, c2, c3: single; var h, l, s: single);
procedure hls2rgb(h, l, s: single; var c1, c2, c3: single);

procedure RGBtoLum(const r,g,b: byte; var Lum: byte);
procedure LumRGBToLumRGB(const r_old, g_old, b_old, Lum_old, Lum: byte; var r, g, b: byte);


implementation



function RGBtoRGBTriple(red, green, blue: integer): TRGBTriple;
begin
  with RESULT do
  begin
    rgbtRed := red;
    rgbtGreen := green;
    rgbtBlue := blue
  end
end {RGBTriple};


function HSVToRGBTriple(H, S, V: single): TRGBTriple;
var
  f, i, p, q, t: single;
begin
  if S = 0
    then RESULT := RGBtoRGBTriple(round(V * 255), round(V * 255), round(V * 255)) // achromatic:  shades of gray
  else begin // chromatic color
    if H = 360
      then h := 0
    else h := h / 60;

    i := floor(h);
    f := h - i;
    p := V * (1 - s);
    q := V * (1 - s * f);
    t := v * (1 - s * (1 - f));

    if i = 0 then RESULT := RGBtoRGBTriple(round(V * 255), round(t * 255), round(p * 255)) else
      if i = 1 then RESULT := RGBtoRGBTriple(round(q * 255), round(V * 255), round(p * 255)) else
        if i = 2 then RESULT := RGBtoRGBTriple(round(p * 255), round(V * 255), round(t * 255)) else
          if i = 3 then RESULT := RGBtoRGBTriple(round(p * 255), round(q * 255), round(V * 255)) else
            if i = 4 then RESULT := RGBtoRGBTriple(round(t * 255), round(p * 255), round(V * 255)) else
              if i = 5 then RESULT := RGBtoRGBTriple(round(V * 255), round(p * 255), round(q * 255));


  end

end;


procedure RGBTripleToHSV(RGBTriple: TRGBTriple;
  var H, S, V: single);

var
  Delta: single;
  kMin, r, g, b: single;
begin
  with RGBTriple do
  begin
    r := rgbtRed / 255;
    g := rgbtGreen / 255;
    b := rgbtBlue / 255;
    kMin := min(r, min(g, b));
    V := max(r, max(g, b));
  end;

  Delta := V - kMin;

    // Calculate saturation:  saturation is 0 if r, g and b are all 0
  if V = 0 then S := 0
  else S := delta / v;

  if S = 0 then H := 0
  else
  begin

    if r = V
      then // degrees -- between yellow and magenta
      H := (g - b) / delta * 60
    else
      if g = V
        then // between cyan and yellow
        H := 120 + (b - r) / Delta * 60
      else
        if b = V
          then // between magenta and cyan
          H := 240 + (r - g) / Delta * 60;


    if H < 0
      then H := H + 360;

  end

end;


procedure rgb2hls(c1, c2, c3: single; var h, l, s: single);
var
  delta, kmin, kmax: single;
begin
  kmax := Max(c1, Max(c2, c3));
  kmin := Min(c1, Min(c2, c3));
  {Valuta la luminosità }
  l := (kmax + kmin) / 2;
  {Valuta la saturazione}
  if kmax = kmin then
  begin
    s := 0;
    h := 0;
  end
  else
  begin
    if l < 0.5 then
      s := (kmax - kmin) / (kmax + kmin)
    else
      s := (kmax - kmin) / (2 - kmax - kmin);
     {Valuta il valore di hue}
    delta := kmax - kmin;
    if kmax = c1 then
      h := (c2 - c3) / delta
    else
      if kmax = c2 then
        h := 2 + (c3 - c1) / delta
      else
        if kmax = c3 then
          h := 4 + (c1 - c2) / delta;
    h := h * 60;
    if h < 0 then
      h := h + 360;
  end;
end;


procedure hls2rgb(h, l, s: single; var c1, c2, c3: single);
var
  m1, m2: single;
  function valore(n1, n2, hue: single): single;
  begin
    if hue >= 360 then
      hue := hue - 360
    else
      if hue < 0 then
        hue := hue + 360;
    if hue >= 240 then
      result := n1
    else if hue < 60 then
      result := n1 + (n2 - n1) * hue / 60
     else if hue < 180 then
      result := n2
     else
      result := n1 + (n2 - n1) * (240 - hue) / 60;
  end;
begin
  if (s = 0) then
  begin
    c1 := l;
    c2 := l;
    c3 := l;
  end
  else
  begin
    if l <= 0.5 then
      m2 := l * (1 + s)
    else
      m2 := l + s * (1 - l);
    m1 := 2 * l - m2;
    c1 := valore(m1, m2, h + 120);
    c2 := valore(m1, m2, h);
    c3 := valore(m1, m2, h - 120);
  end;
end;



procedure RGBtoLum(const r,g,b: byte; var Lum: byte);
begin
   Lum := round(0.3 * r + 0.6 * g + 0.1 * b);

end;


procedure LumRGBToLumRGB(const r_old, g_old, b_old, Lum_old, Lum: byte; var r, g, b: byte);
begin

  r := min(255, round(r_old/max(1,Lum_old) * Lum));
  g := min(255, round(g_old/max(1,Lum_old) * Lum));
  b := min(255, round(b_old/max(1,Lum_old) * Lum));
end;



end.
