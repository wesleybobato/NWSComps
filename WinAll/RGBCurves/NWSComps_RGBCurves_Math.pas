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
unit NWSComps_RGBCurves_Math;
{$R-}
{$Q-}

interface

uses windows, sysutils, math, NWSComps_RGBCurves_Types, NWSComps_RGBCurves_Const;

type


  TRGBCurves_SplineCoefficients = record //Spline coefficient type
    c0: Double;
    c1: Double;
    c2: Double;
    c3: Double;
    c4: Double;
  end;



  TRGBCurves_Dvector = array of double;
  TRGBCurves_DMatrix = array of array of double;

  TRGBCurves_DSplinevector = array of TRGBCurves_SplineCoefficients;

  var RGBCurves_InterpAlgorithm: string;

(*
procedure CalculatePolynomialCoefs(var coefs: TRGBCurves_Dvector; points: TRGBCurves_DoublePointsarray);
function GetPolynomialCurveValue_INT(coefs: TRGBCurves_dvector; x: double): integer;
*)

procedure CalculateBSplineCoefs(var coefs: TRGBCurves_DSplinevector; points: TRGBCurves_DoublePointsarray); overload;
procedure CalculateBSplineCoefs(var coefs: TRGBCurves_DSplinevector; points: TRGBCurves_PointList); overload;

function GetSplineCurveValue_INT(spcoefs: TRGBCurves_DSplinevector; x: double): integer;
function GetSplineCurveValue(spcoefs: TRGBCurves_DSplinevector; x: double): double;

Function GetCombinedCurveValue(spcoefs: TRGBCurves_DSplinevector;
                               x: double;
                               const nearestPt1, nearestPt2: TRGBCurves_doublePoint;
                               const Points_Range: double;
                               const InterpLin_Min, InterpLin_Max: single): double; overload;
                               


Function GetCombinedCurveValue(spcoefs: TRGBCurves_DSplinevector;
                               x: double;
                               thePoints: TRGBCurves_DoublePointsarray;
                               const InterpLin_Min, InterpLin_Max: single): double; overload;

Function GetCombinedCurveValue(spcoefs: TRGBCurves_DSplinevector;
                               x: double;
                               thePoints: TRGBCurves_PointList;
                               const InterpLin_Min, InterpLin_Max: single): double; overload;


function GetCombinedCurveValue_INT(spcoefs: TRGBCurves_DSplinevector;
                                   x: double;
                                   const nearestPt1, nearestPt2: TRGBCurves_doublePoint;
                                   const Points_Range: double;
                                   const InterpLin_Min, InterpLin_Max: single): integer; overload;

function GetCombinedCurveValue_INT(spcoefs: TRGBCurves_DSplinevector;
                                   x: double;
                                   thePoints: TRGBCurves_DoublePointsarray;
                                   const InterpLin_Min, InterpLin_Max: single): integer; overload;

Function GetCombinedCurveValue_INT(spcoefs: TRGBCurves_DSplinevector;
                                   x: double;
                                   thePoints: TRGBCurves_PointList;
                                   const InterpLin_Min, InterpLin_Max: single): integer; overload;



implementation



procedure CalculateBSplineCoefs(var coefs: TRGBCurves_DSplinevector; points: TRGBCurves_DoublePointsarray);
var
  hi: Integer;
  dxi, dyi: Double;
  dxp: Double;
  dxip, dyip: Double;
  yppa, yppb: Double;
  pi: Double;
  dx: Double;
  i: Integer;
begin
  hi := High(Points);
  SetLength(coefs, hi + 1);

  if hi >= 1 then
  begin
    if hi > 1 then
    begin
      dxi := Points[1].X - Points[0].X;
      dyi := Points[1].Y - Points[0].Y;

      for i := 2 to hi do
      begin
        dxip := Points[i].X - Points[i - 1].X;
        dyip := Points[i].Y - Points[i - 1].Y;
        dxp := dxi + dxip;

        coefs[i - 1].c1 := dxip / dxp;
        coefs[i - 1].c2 := 1 - coefs[i - 1].c1;
        coefs[i - 1].c3 := 6 * (dyip / dxip - dyi / dxi) / dxp;
        dxi := dxip;
        dyi := dyip;
      end;
    end;

    coefs[0].c1 := 0;
    coefs[0].c2 := 0;

    for i := 2 to hi do
    begin
      pi := coefs[i - 1].c2 * coefs[i - 2].c1 + 2;
      coefs[i - 1].c1 := -coefs[i - 1].c1 / pi;
      coefs[i - 1].c2 := (coefs[i - 1].c3 - coefs[i - 1].c2 * coefs[i - 2].c2) / pi;
    end;

    yppb := 0;

    for i := hi downto 1 do
    begin
      yppa := coefs[i - 1].c1 * yppb + coefs[i - 1].c2;
      dx := Points[i].X - Points[i - 1].X;
      coefs[i - 1].c3 := (yppb - yppa) / dx / 6;
      coefs[i - 1].c2 := yppa / 2;
      coefs[i - 1].c1 := (Points[i].Y - Points[i - 1].Y) / dx -
        (coefs[i - 1].c2 + coefs[i - 1].c3 * dx) * dx;
      yppb := yppa;
    end;

    for i := 0 to hi do
    begin
      coefs[i].c0 := Points[i].Y;
      coefs[i].c4 := Points[i].X;
    end;
  end;

end;

procedure CalculateBSplineCoefs(var coefs: TRGBCurves_DSplinevector; points: TRGBCurves_PointList);
var
  hi: Integer;
  dxi, dyi: Double;
  dxp: Double;
  dxip, dyip: Double;
  yppa, yppb: Double;
  pi: Double;
  dx: Double;
  i: Integer;
begin
  hi := Points.Count - 1;
  SetLength(coefs, hi + 1);

  if hi >= 1 then
  begin
    if hi > 1 then
    begin
      dxi := Points.Data[1].X - Points.Data[0].X;
      dyi := Points.Data[1].Y - Points.Data[0].Y;

      for i := 2 to hi do
      begin
        dxip := Points.Data[i].X - Points.Data[i - 1].X;
        dyip := Points.Data[i].Y - Points.Data[i - 1].Y;
        dxp := dxi + dxip;

        coefs[i - 1].c1 := dxip / dxp;
        coefs[i - 1].c2 := 1 - coefs[i - 1].c1;
        coefs[i - 1].c3 := 6 * (dyip / dxip - dyi / dxi) / dxp;
        dxi := dxip;
        dyi := dyip;
      end;
    end;

    coefs[0].c1 := 0;
    coefs[0].c2 := 0;

    for i := 2 to hi do
    begin
      pi := coefs[i - 1].c2 * coefs[i - 2].c1 + 2;
      coefs[i - 1].c1 := -coefs[i - 1].c1 / pi;
      coefs[i - 1].c2 := (coefs[i - 1].c3 - coefs[i - 1].c2 * coefs[i - 2].c2) / pi;
    end;

    yppb := 0;

    for i := hi downto 1 do
    begin
      yppa := coefs[i - 1].c1 * yppb + coefs[i - 1].c2;
      dx := Points.Data[i].X - Points.Data[i - 1].X;
      coefs[i - 1].c3 := (yppb - yppa) / dx / 6;
      coefs[i - 1].c2 := yppa / 2;
      coefs[i - 1].c1 := (Points.Data[i].Y - Points.Data[i - 1].Y) / dx -
        (coefs[i - 1].c2 + coefs[i - 1].c3 * dx) * dx;
      yppb := yppa;
    end;

    for i := 0 to hi do
    begin
      coefs[i].c0 := Points.Data[i].Y;
      coefs[i].c4 := Points.Data[i].X;
    end;
  end;



end;


function GetSplineCurveValue(spcoefs: TRGBCurves_DSplinevector; x: double): double;
var
  i: Integer;
  First, Len, Half, Middle: integer;
  dx: Double;
begin
  if X <= spcoefs[0].c4 then
  begin
    Result := spcoefs[0].c0;
    Exit;
  end;

  Len := High(spcoefs);

  if X >= spcoefs[Len].c4 then
  begin
    Result := spcoefs[Len].c0;
    Exit;
  end;

  First := 0;

  while Len > 0 do
  begin
    Half := Len shr 1;
    Middle := First + Half;
    if spcoefs[Middle].c4 < X then
    begin
      First := Middle + 1;
      Len := Len - Half - 1;
    end
    else
      Len := Half;
  end;

  i := First - 1;

  dx := X - spcoefs[i].c4;
  Result := spcoefs[i].c0 + dx * (spcoefs[i].c1 + dx * (spcoefs[i].c2 + spcoefs[i].c3 * dx));
end;



function GetSplineCurveValue_INT(spcoefs: TRGBCurves_DSplinevector; x: double): integer;
begin
  result := round(GetSplineCurveValue(spcoefs, x));

  if result > 255 then
    result := 255
  else
    if result < 0 then result := 0;
end;



 //algorithm: ALG_2000_1
Function GetCombinedCurveValue_ALG_2000_1(spcoefs: TRGBCurves_DSplinevector;
                               x: double;
                               const nearestPt1, nearestPt2: TRGBCurves_doublePoint;
                               const Points_Range: double;
                               const InterpLin_Min, InterpLin_Max: single): double;


var
  v_sp: double;
  v_l: double;

  r_Lin_dist: double;
  r_Lin: double;
  r_Spline: double;

   minR, maxR: double;

begin

 minR := 1 - InterpLin_Max;
 maxR := 1 - InterpLin_Min;

 //value from spline curve
 v_sp := GetSplineCurveValue(spcoefs, x);

 //linear value
 if (nearestPt2.x - nearestPt1.x) <> 0 then
   v_l := nearestPt1.y + (x - nearestPt1.x) * (nearestPt2.y - nearestPt1.y)/(nearestPt2.x - nearestPt1.x)
 else
   v_l := (nearestPt2.y + nearestPt1.y) / 2;

 //evaluate a coefficient from distance to assess how much linear value should be mixed into the spline
 r_Lin_dist := min(1, sqrt(sqr(nearestPt2.y - nearestPt1.y) + sqr(nearestPt2.x - nearestPt1.x))
             / points_Range
          );

 r_Lin := R_Lin_Dist;
 r_Spline := maxR * r_Lin + minR * (1 - r_Lin);

 result := r_Spline * v_sp + (1 - r_Spline) * v_l;
end;


 //algorithm: ALG_3200_1
Function GetCombinedCurveValue_ALG_3200_1(spcoefs: TRGBCurves_DSplinevector;
                               x: double;
                               const nearestPt1, nearestPt2: TRGBCurves_doublePoint;
                               const Points_Range: double;
                               const InterpLin_Min, InterpLin_Max: single): double;


var
  v_sp: double;
  v_l: double;

  dist_NPTS, Dist_Tot_SP, dist_X: double;
  r_Lin_dist, r_Lin_x: single;

  r_Lin: double;
  r_Spline: single;


 {
 function EvalTan(npt: TRGBCurves_doublePoint): double;
  begin
     if abs(npt.x - x) <= 0.01 then
     begin
       if ((npt.y - v_sp > 0) and (npt.x - x > 0)) or
          ((npt.y - v_sp < 0) and (npt.x - x < 0))then
         result := 100
       else
         result := -100
     end
     else
     begin
       result := (npt.y - v_sp)/(npt.x - x);
       if result < -100 then
         result := -100
       else if result > 100 then
         result := 100;
     end;
 end;
}
begin
 //value from spline curve
 v_sp := GetSplineCurveValue(spcoefs, x);

 //linear value
 if (nearestPt2.x - nearestPt1.x) <> 0 then
   v_l := nearestPt1.y + (x - nearestPt1.x) * (nearestPt2.y - nearestPt1.y)/(nearestPt2.x - nearestPt1.x)
 else
   v_l := (nearestPt2.y + nearestPt1.y) / 2;

 dist_X := abs(nearestPt1.x - nearestPt2.x);
 dist_NPTS := sqrt(sqr(nearestPt2.y - nearestPt1.y) + sqr(nearestPt2.x - nearestPt1.x));
 Dist_Tot_SP := sqrt(sqr(v_sp - nearestPt1.y) + sqr(x - nearestPt1.x)) +
                sqrt(sqr(v_sp - nearestPt2.y) + sqr(x - nearestPt2.x));

 dist_NPTS := min(dist_NPTS, Dist_Tot_SP);
// assert((Dist_Tot_SP - dist_NPTS >= 0), floattostr(dist_NPTS) + '   ' + floattostr(Dist_Tot_SP));


 //evaluate a coefficient from distance to assess how much linear value should be mixed into the spline
 if Dist_Tot_SP = 0 then
  r_lin_dist := 0
 else
 begin
//  r_lin_dist := 1 - dist_NPTS / Dist_Tot_SP;
  r_lin_dist := InterpLin_Min + (InterpLin_Max - InterpLin_Min) * (1 - dist_NPTS / Dist_Tot_SP);
 end;

 r_Lin_x := InterpLin_Min + (InterpLin_Max - InterpLin_Min) * (1 - dist_X / Points_range);
 r_Lin := (0.7 * r_lin_dist + 0.3 * r_lin_x);


 r_spline := 1 - r_Lin;
 result := r_Spline * v_sp + (1 - r_Spline) * v_l;
end;


Function GetCombinedCurveValue(spcoefs: TRGBCurves_DSplinevector;
                               x: double;
                               const nearestPt1, nearestPt2: TRGBCurves_doublePoint;
                               const Points_Range: double;
                               const InterpLin_Min, InterpLin_Max: single): double;
begin
  if RGBCurves_InterpAlgorithm = G_CONST_RGBCURVES_ALG_2000_1 then
    result := GetCombinedCurveValue_ALG_2000_1(spcoefs, x, nearestpt1, nearestpt2,
                                               Points_Range,
                                               InterpLin_Min,
                                               InterpLin_Max)
  else if RGBCurves_InterpAlgorithm = G_CONST_RGBCURVES_ALG_3200_1 then
    result := GetCombinedCurveValue_ALG_3200_1(spcoefs, x, nearestpt1, nearestpt2,
                                               Points_Range,
                                               InterpLin_Min,
                                               InterpLin_Max)
  else
  result := 0;//never the case
end;



function GetCombinedCurveValue_INT(spcoefs: TRGBCurves_DSplinevector;
                                   x: double;
                                   const nearestPt1, nearestPt2: TRGBCurves_doublePoint;
                                   const Points_Range: double;
                                   const InterpLin_Min, InterpLin_Max: single): integer;
begin
  result := round(GetCombinedCurveValue(spcoefs, x, nearestPt1, nearestPt2, Points_Range, interpLin_Min, InterpLin_Max));

  if result > 255 then result := 255
  else
    if result < 0 then result := 0;
end;


Function GetCombinedCurveValue(spcoefs: TRGBCurves_DSplinevector;
                               x: double;
                               thePoints: TRGBCurves_DoublePointsarray;
                               const InterpLin_Min, InterpLin_Max: single): double; overload;
var
  lo, hi: integer;
  pt1, pt2: TRGBCurves_DoublePoint;
  k: integer;
begin
  lo := low(thePoints);
  hi := high(thePoints);

  pt1 := thePoints[lo];
  pt2 := thePoints[hi];

  if length(thePoints) < 2 then
  begin
    result := GetSplineCurveValue(spcoefs, x);
    EXIT; //>>>>EXIT
  end;

  if x<= thePoints[lo].x then
  begin
    result := GetSplineCurveValue(spcoefs, x);
    EXIT; //>>>>EXIT
  end
  else
  if x>= thePoints[hi].x then
  begin
    result := GetSplineCurveValue(spcoefs, x);
    EXIT; //>>>>EXIT
  end
  else
  begin

    for k := lo to hi -1 do
    begin
      if (x >= thePoints[k].x) and (x <= thePoints[k + 1].x) then
      begin
        pt1 := thePoints[k];
        pt2 := thePoints[k + 1];
        Break;
      end;
    end;


  end;

  result := GetCombinedCurveValue(spcoefs, x, pt1, pt2, 255, interpLin_Min, InterpLin_Max);
end;



Function GetCombinedCurveValue(spcoefs: TRGBCurves_DSplinevector;
                               x: double;
                               thePoints: TRGBCurves_PointList;
                               const InterpLin_Min, InterpLin_Max: single): double; overload;
var
  lo, hi: integer;
  pt1, pt2: TRGBCurves_DoublePoint;
  k: integer;
begin
  lo := 0;
  hi := thePoints.Count - 1;

  pt1 := thePoints.Data[lo];
  pt2 := thePoints.Data[hi];

  if thePoints.Count < 2 then
  begin
    result := GetSplineCurveValue(spcoefs, x);
    EXIT; //>>>>EXIT
  end;

  if x<= pt1.x then
  begin
    result := GetSplineCurveValue(spcoefs, x);
    EXIT; //>>>>EXIT
  end
  else
  if x>= pt2.x then
  begin
    result := GetSplineCurveValue(spcoefs, x);
    EXIT; //>>>>EXIT
  end
  else
  begin

    for k := lo to hi -1 do
    begin
      if (x >= thePoints.Data[k].x) and (x <= thePoints.Data[k + 1].x) then
      begin
        pt1 := thePoints.Data[k];
        pt2 := thePoints.Data[k + 1];
        Break;
      end;
    end;


  end;

  result := GetCombinedCurveValue(spcoefs, x, pt1, pt2, 255, interpLin_Min, InterpLin_Max);

end;



function GetCombinedCurveValue_INT(spcoefs: TRGBCurves_DSplinevector;
                                   x: double;
                                   thePoints: TRGBCurves_DoublePointsarray;
                                   const InterpLin_Min, InterpLin_Max: single): integer; overload;
begin
  result := round(GetCombinedCurveValue(spcoefs, x, thePoints, interpLin_Min, InterpLin_Max));

  if result > 255 then
   result := 255
  else if result < 0 then result := 0;
end;


Function GetCombinedCurveValue_INT(spcoefs: TRGBCurves_DSplinevector;
                                   x: double;
                                   thePoints: TRGBCurves_PointList;
                                   const InterpLin_Min, InterpLin_Max: single): integer; overload;
begin
  result := round(GetCombinedCurveValue(spcoefs, x, thePoints, interpLin_Min, InterpLin_Max));

  if result > 255 then
   result := 255
  else if result < 0 then
   result := 0;

end;


initialization

RGBCurves_InterpAlgorithm := G_CONST_RGBCURVES_ALG_3200_1;

finalization


end.
