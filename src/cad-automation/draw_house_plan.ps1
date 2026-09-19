Add-Type -AssemblyName System.Drawing
$S = 180
$Wm = 12.0; $Hm = 9.0
$Ox = 350; $Oy = 250
$Wpx = [int]($Wm*$S); $Hpx = [int]($Hm*$S)
$CW = 3000; $CH = 2300
$bmp = New-Object System.Drawing.Bitmap $CW,$CH
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
$g.Clear([System.Drawing.Color]::White)

function Get-PX { param([double]$X) return [int]($Ox + $X*$S) }
function Get-PY { param([double]$Y) return [int]($Oy + $Y*$S) }
function New-Rect2 { param([double]$X,[double]$Y,[double]$W,[double]$H)
  return New-Object System.Drawing.Rectangle ((Get-PX -X $X)),((Get-PY -Y $Y)),([int]($W*$S)),([int]($H*$S))
}

$black = [System.Drawing.Color]::Black
$wallBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(50,50,50))
$penThin = New-Object System.Drawing.Pen $black, 2
$penMed = New-Object System.Drawing.Pen $black, 3
$penDim = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(0,90,160)), 2
$penDoor = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(0,150,0)), 3
$penWindow = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(0,100,200)), 3
$brushDim = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(0,90,160))
$brushTxt = New-Object System.Drawing.SolidBrush $black
$brushGrayTxt = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(80,80,80))
$fontTitle = New-Object System.Drawing.Font "Arial", 26, ([System.Drawing.FontStyle]::Bold)
$fontRoom = New-Object System.Drawing.Font "Arial", 18, ([System.Drawing.FontStyle]::Bold)
$fontSub = New-Object System.Drawing.Font "Arial", 14, ([System.Drawing.FontStyle]::Regular)
$fontDim = New-Object System.Drawing.Font "Arial", 13, ([System.Drawing.FontStyle]::Regular)
$fontSmall = New-Object System.Drawing.Font "Arial", 12, ([System.Drawing.FontStyle]::Regular)
$fontBlock = New-Object System.Drawing.Font "Consolas", 12, ([System.Drawing.FontStyle]::Regular)

# Room data parallel arrays to avoid hashtable property issues
$rx = @(0.2, 6.4, 6.4, 8.8, 0.2, 5.0, 6.4, 9.5, 9.5)
$ry = @(0.2, 0.2, 2.4, 0.2, 4.3, 0.2, 4.3, 4.3, 6.4)
$rw = @(4.6, 2.2, 2.2, 3.0, 4.6, 1.2, 2.9, 2.3, 2.3)
$rh = @(3.9, 2.0, 1.7, 3.9, 3.8, 8.6, 3.8, 1.9, 1.7)
$rn = @("KITCHEN / DINING","BED 3","BATH","BEDROOM 2","LIVING ROOM","HALLWAY","MASTER","ENSUITE","W.I.R.")
$rs = @("5.00 x 4.20m","2.60 x 2.20m","2.60 x 1.90m","3.20 x 4.00m","4.80 x 4.00m","1.20m wide","3.10 x 4.00m","2.50 x 2.10m","2.50 x 1.70m")
$rc = @(
  [System.Drawing.Color]::FromArgb(255,248,225),
  [System.Drawing.Color]::FromArgb(232,240,255),
  [System.Drawing.Color]::FromArgb(225,245,255),
  [System.Drawing.Color]::FromArgb(232,240,255),
  [System.Drawing.Color]::FromArgb(235,250,235),
  [System.Drawing.Color]::FromArgb(245,245,245),
  [System.Drawing.Color]::FromArgb(255,235,240),
  [System.Drawing.Color]::FromArgb(225,245,255),
  [System.Drawing.Color]::FromArgb(240,235,255)
)
for($i=0;$i -lt $rx.Count;$i++){
  $bb = New-Object System.Drawing.SolidBrush $rc[$i]
  $rr = New-Rect2 -X $rx[$i] -Y $ry[$i] -W $rw[$i] -H $rh[$i]
  $g.FillRectangle($bb, $rr)
  $bb.Dispose()
}

function Add-Wall2 { param([double]$X,[double]$Y,[double]$W,[double]$H)
  $g.FillRectangle($wallBrush, (Get-PX -X $X),(Get-PY -Y $Y),([int]($W*$S)),([int]($H*$S)))
}
# Exterior 0.2m
Add-Wall2 -X 0 -Y 0 -W 12.0 -H 0.2
Add-Wall2 -X 0 -Y 8.8 -W 12.0 -H 0.2
Add-Wall2 -X 0 -Y 0 -W 0.2 -H 9.0
Add-Wall2 -X 11.8 -Y 0 -W 0.2 -H 9.0
$g.DrawRectangle($penMed, (Get-PX -X 0),(Get-PY -Y 0),$Wpx,$Hpx)
# Interior 0.1m
Add-Wall2 -X 5.0 -Y 0.2 -W 0.1 -H 8.6
Add-Wall2 -X 6.2 -Y 0.2 -W 0.1 -H 8.6
Add-Wall2 -X 0.2 -Y 4.1 -W 4.8 -H 0.1
Add-Wall2 -X 6.3 -Y 4.1 -W 5.5 -H 0.1
Add-Wall2 -X 8.7 -Y 0.2 -W 0.1 -H 3.9
Add-Wall2 -X 6.4 -Y 2.2 -W 2.3 -H 0.1
Add-Wall2 -X 9.3 -Y 4.1 -W 0.1 -H 4.0
Add-Wall2 -X 9.5 -Y 6.2 -W 2.3 -H 0.1

function GapH2 { param([double]$X,[double]$Y,[double]$W)
  $g.FillRectangle([System.Drawing.Brushes]::White, (Get-PX -X $X),(Get-PY -Y (0+$Y-0.02)),([int]($W*$S)),([int](0.14*$S)))
}
function GapV2 { param([double]$X,[double]$Y,[double]$H)
  $g.FillRectangle([System.Drawing.Brushes]::White, (Get-PX -X (0+$X-0.02)),(Get-PY -Y $Y),([int](0.14*$S)),([int]($H*$S)))
}
function WindowTop2 { param([double]$X,[double]$W)
  $g.FillRectangle([System.Drawing.Brushes]::White, (Get-PX -X $X),(Get-PY -Y (0-0.02)),([int]($W*$S)),([int](0.24*$S)))
  $g.DrawRectangle($penWindow, (Get-PX -X $X),(Get-PY -Y 0.02),([int]($W*$S)),([int](0.16*$S)))
  $g.DrawLine($penWindow, (Get-PX -X $X),(Get-PY -Y 0.10),(Get-PX -X (0+$X+$W)),(Get-PY -Y 0.10))
}
function WindowBottom2 { param([double]$X,[double]$W)
  $HM = 9.0
  $g.FillRectangle([System.Drawing.Brushes]::White, (Get-PX -X $X),(Get-PY -Y (0+$HM-0.22)),([int]($W*$S)),([int](0.24*$S)))
  $g.DrawRectangle($penWindow, (Get-PX -X $X),(Get-PY -Y (0+$HM-0.18)),([int]($W*$S)),([int](0.16*$S)))
  $g.DrawLine($penWindow, (Get-PX -X $X),(Get-PY -Y (0+$HM-0.10)),(Get-PX -X (0+$X+$W)),(Get-PY -Y (0+$HM-0.10)))
}
function WindowLeft2 { param([double]$Y,[double]$H)
  $g.FillRectangle([System.Drawing.Brushes]::White, (Get-PX -X (0-0.02)),(Get-PY -Y $Y),([int](0.24*$S)),([int]($H*$S)))
  $g.DrawRectangle($penWindow, (Get-PX -X 0.02),(Get-PY -Y $Y),([int](0.16*$S)),([int]($H*$S)))
}
function WindowRight2 { param([double]$Y,[double]$H)
  $WM = 12.0
  $g.FillRectangle([System.Drawing.Brushes]::White, (Get-PX -X (0+$WM-0.22)),(Get-PY -Y $Y),([int](0.24*$S)),([int]($H*$S)))
  $g.DrawRectangle($penWindow, (Get-PX -X (0+$WM-0.18)),(Get-PY -Y $Y),([int](0.16*$S)),([int]($H*$S)))
}
WindowTop2 -X 1.0 -W 1.8
WindowTop2 -X 6.7 -W 1.5
WindowTop2 -X 9.3 -W 1.8
WindowBottom2 -X 1.0 -W 1.8
WindowBottom2 -X 6.8 -W 1.5
WindowBottom2 -X 10.0 -W 1.2
WindowLeft2 -Y 1.2 -H 1.6
WindowLeft2 -Y 5.2 -H 1.8
WindowRight2 -Y 1.2 -H 1.6
WindowRight2 -Y 5.0 -H 1.2
WindowRight2 -Y 6.8 -H 1.0

function DoorSwing2 { param([double]$HX,[double]$HY,[double]$RR,[double]$A1,[double]$A2)
  $rpx=[int]($RR*$S)
  $g.DrawArc($penDoor, (Get-PX -X $HX)-$rpx,(Get-PY -Y $HY)-$rpx, $rpx*2,$rpx*2, $A1,($A2-$A1))
}
function DoorLeaf2 { param([double]$X1,[double]$Y1,[double]$X2,[double]$Y2)
  $g.DrawLine($penDoor, (Get-PX -X $X1),(Get-PY -Y $Y1),(Get-PX -X $X2),(Get-PY -Y $Y2))
}
GapH2 -X 5.2 -Y 8.8 -W 0.9
DoorLeaf2 -X1 5.2 -Y1 8.8 -X2 6.1 -Y2 7.9
DoorSwing2 -HX 5.2 -HY 8.8 -RR 0.9 -A1 270 -A2 360
GapH2 -X 1.8 -Y 4.1 -W 0.8
DoorLeaf2 -X1 1.8 -Y1 4.1 -X2 1.8 -Y2 3.3
DoorSwing2 -HX 1.8 -HY 4.1 -RR 0.8 -A1 270 -A2 360
GapV2 -X 5.0 -Y 3.0 -H 0.8
DoorLeaf2 -X1 5.0 -Y1 3.0 -X2 5.8 -Y2 3.0
DoorSwing2 -HX 5.0 -HY 3.8 -RR 0.8 -A1 0 -A2 90
GapV2 -X 6.2 -Y 1.2 -H 0.8
DoorLeaf2 -X1 6.2 -Y1 1.2 -X2 7.0 -Y2 1.2
DoorSwing2 -HX 6.2 -HY 2.0 -RR 0.8 -A1 270 -A2 360
GapV2 -X 6.2 -Y 5.5 -H 0.8
DoorLeaf2 -X1 6.2 -Y1 5.5 -X2 7.0 -Y2 5.5
DoorSwing2 -HX 6.2 -HY 6.3 -RR 0.8 -A1 270 -A2 360
GapH2 -X 7.0 -Y 4.1 -W 0.8
DoorLeaf2 -X1 7.0 -Y1 4.1 -X2 7.0 -Y2 4.9
DoorSwing2 -HX 7.0 -HY 4.1 -RR 0.8 -A1 90 -A2 180
GapH2 -X 10.2 -Y 4.1 -W 0.8
DoorLeaf2 -X1 10.2 -Y1 4.1 -X2 11.0 -Y2 4.1
DoorSwing2 -HX 10.2 -HY 4.1 -RR 0.8 -A1 180 -A2 270
GapV2 -X 8.7 -Y 2.8 -H 0.8
DoorLeaf2 -X1 8.7 -Y1 2.8 -X2 9.5 -Y2 2.8
DoorSwing2 -HX 8.7 -HY 3.6 -RR 0.8 -A1 180 -A2 270
GapV2 -X 9.3 -Y 5.2 -H 0.7
DoorLeaf2 -X1 9.3 -Y1 5.2 -X2 10.0 -Y2 5.2
DoorSwing2 -HX 9.3 -HY 5.9 -RR 0.7 -A1 270 -A2 360

$penFix = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(90,90,90)), 2
$brushFix = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::White)
function FixRect2 { param([double]$X,[double]$Y,[double]$W,[double]$H)
  $rr2 = New-Rect2 -X $X -Y $Y -W $W -H $H
  $g.FillRectangle($brushFix, $rr2)
  $g.DrawRectangle($penFix, (Get-PX -X $X),(Get-PY -Y $Y),([int]($W*$S)),([int]($H*$S)))
}
FixRect2 -X 0.3 -Y 0.3 -W 4.4 -H 0.6
FixRect2 -X 0.3 -Y 0.3 -W 0.6 -H 2.5
FixRect2 -X 2.0 -Y 2.2 -W 1.6 -H 0.8
FixRect2 -X 6.5 -Y 6.5 -W 1.6 -H 2.0
FixRect2 -X 9.0 -Y 0.5 -W 2.2 -H 1.6
FixRect2 -X 6.5 -Y 0.4 -W 1.2 -H 1.8
FixRect2 -X 0.5 -Y 7.2 -W 2.2 -H 0.9
FixRect2 -X 0.5 -Y 4.6 -W 0.9 -H 1.8
FixRect2 -X 2.2 -Y 5.8 -W 1.5 -H 0.8
FixRect2 -X 7.8 -Y 2.5 -W 0.7 -H 1.3
FixRect2 -X 9.7 -Y 4.5 -W 1.5 -H 0.9
FixRect2 -X 6.6 -Y 3.2 -W 0.6 -H 0.5
FixRect2 -X 11.0 -Y 5.3 -W 0.6 -H 0.5
FixRect2 -X 8.4 -Y 6.9 -W 0.6 -H 1.0
FixRect2 -X 10.8 -Y 6.5 -W 0.8 -H 1.4
$g.DrawEllipse($penFix, (Get-PX -X 10.8),(Get-PY -Y 4.5),([int](0.6*$S)),([int](0.6*$S)))
$g.DrawEllipse($penFix, (Get-PX -X 6.6),(Get-PY -Y 2.6),([int](0.5*$S)),([int](0.5*$S)))

function Add-RoomLabel2 { param([double]$X,[double]$Y,[double]$W,[double]$H,[string]$T,[string]$SS)
  $cx = (Get-PX -X $X)+([int]($W*$S/2)); $cy=(Get-PY -Y $Y)+([int]($H*$S/2))
  $sf = New-Object System.Drawing.StringFormat
  $sf.Alignment=[System.Drawing.StringAlignment]::Center
  $sf.LineAlignment=[System.Drawing.StringAlignment]::Center
  $g.DrawString($T,$fontRoom,$brushTxt,$cx,$cy-22,$sf)
  $g.DrawString($SS,$fontSub,$brushGrayTxt,$cx,$cy+18,$sf)
}
Add-RoomLabel2 -X 0.2 -Y 0.2 -W 4.6 -H 3.9 -T "KITCHEN / DINING" -SS "5.00 x 4.20m"
Add-RoomLabel2 -X 6.4 -Y 0.2 -W 2.2 -H 2.0 -T "BED 3" -SS "2.60 x 2.20m"
Add-RoomLabel2 -X 6.4 -Y 2.4 -W 2.2 -H 1.7 -T "BATH" -SS "2.60 x 1.90m"
Add-RoomLabel2 -X 8.8 -Y 0.2 -W 3.0 -H 3.9 -T "BEDROOM 2" -SS "3.20 x 4.00m"
Add-RoomLabel2 -X 0.2 -Y 4.3 -W 4.6 -H 3.8 -T "LIVING ROOM" -SS "4.80 x 4.00m"
Add-RoomLabel2 -X 6.4 -Y 4.3 -W 2.9 -H 3.8 -T "MASTER" -SS "3.10 x 4.00m"
Add-RoomLabel2 -X 9.5 -Y 4.3 -W 2.3 -H 1.9 -T "ENSUITE" -SS "2.50 x 2.10m"
Add-RoomLabel2 -X 9.5 -Y 6.4 -W 2.3 -H 1.7 -T "W.I.R." -SS "2.50 x 1.70m"
$g.TranslateTransform((Get-PX -X 5.6),(Get-PY -Y 4.5))
$g.RotateTransform(-90)
$sfH = New-Object System.Drawing.StringFormat
$sfH.Alignment=[System.Drawing.StringAlignment]::Center
$g.DrawString("HALLWAY  1.20m wide", $fontSub, $brushGrayTxt, 0,0, $sfH)
$g.ResetTransform()

function DimH2 { param([double]$Yoff,[double]$X1,[double]$X2,[string]$Txt)
  $yy=(Get-PY -Y 0)-$Yoff
  $g.DrawLine($penDim,(Get-PX -X $X1),$yy,(Get-PX -X $X2),$yy)
  $g.DrawLine($penDim,(Get-PX -X $X1),($yy-10),(Get-PX -X $X1),($yy+10))
  $g.DrawLine($penDim,(Get-PX -X $X2),($yy-10),(Get-PX -X $X2),($yy+10))
  $sf=New-Object System.Drawing.StringFormat; $sf.Alignment=[System.Drawing.StringAlignment]::Center
  $g.DrawString($Txt,$fontDim,$brushDim,(((Get-PX -X $X1)+(Get-PX -X $X2))/2),($yy-32),$sf)
}
function DimV2 { param([double]$Xoff,[double]$Y1,[double]$Y2,[string]$Txt)
  $xx=(Get-PX -X 0)-$Xoff
  $g.DrawLine($penDim,$xx,(Get-PY -Y $Y1),$xx,(Get-PY -Y $Y2))
  $g.DrawLine($penDim,($xx-10),(Get-PY -Y $Y1),($xx+10),(Get-PY -Y $Y1))
  $g.DrawLine($penDim,($xx-10),(Get-PY -Y $Y2),($xx+10),(Get-PY -Y $Y2))
  $g.TranslateTransform(($xx-28),(((Get-PY -Y $Y1)+(Get-PY -Y $Y2))/2))
  $g.RotateTransform(-90)
  $sf=New-Object System.Drawing.StringFormat; $sf.Alignment=[System.Drawing.StringAlignment]::Center
  $g.DrawString($Txt,$fontDim,$brushDim,0,0,$sf)
  $g.ResetTransform()
}
DimH2 -Yoff 110 -X1 0 -X2 12 -Txt "12.00 m OVERALL"
DimH2 -Yoff 55 -X1 0 -X2 5.0 -Txt "5.00"
DimH2 -Yoff 55 -X1 5.0 -X2 6.2 -Txt "1.20"
DimH2 -Yoff 55 -X1 6.2 -X2 12 -Txt "5.80"
DimV2 -Xoff 150 -Y1 0 -Y2 9 -Txt "9.00 m OVERALL"
DimV2 -Xoff 75 -Y1 0 -Y2 4.1 -Txt "4.10"
DimV2 -Xoff 75 -Y1 4.1 -Y2 9 -Txt "4.90"

$nx=(Get-PX -X 12)+120; $ny=(Get-PY -Y 0)+20
$g.DrawEllipse($penMed,$nx,$ny,80,80)
$fN=New-Object System.Drawing.Font "Arial",28,([System.Drawing.FontStyle]::Bold)
$g.DrawString("N",$fN,$brushTxt,($nx+18),($ny+12))
$penN=New-Object System.Drawing.Pen $black,4
$g.DrawLine($penN,($nx+40),($ny+70),($nx+40),($ny+25))
$sbY=(Get-PY -Y 9)+65; $sbX=(Get-PX -X 0)
$g.DrawString("SCALE 1:50  (printed)   0    1    2    3    4    5 m",$fontDim,$brushTxt,$sbX,($sbY-28))
for($i=0;$i -lt 5;$i++){
  $b2=$brushTxt
  if(($i%2)-eq 1){ $b2=[System.Drawing.Brushes]::White }
  $g.FillRectangle($b2,($sbX+$i*$S/2),($sbY+8),([int]($S/2)),12)
  $g.DrawRectangle($penThin,($sbX+$i*$S/2),($sbY+8),([int]($S/2)),12)
}
$g.DrawString("SINGLE-STOREY HOUSE - FLOOR PLAN  12.0 x 9.0m  (108 m2)",$fontTitle,$brushTxt,($Ox-40),15)
$g.DrawString("Ext walls 200mm, Int walls 100mm. Doors 800-900mm, Windows 1200-1800mm. All dims meters.",$fontSub,$brushGrayTxt,($Ox-30),58)
$bx=200; $by=($CH-260); $bw=($CW-400); $bh=180
$g.DrawRectangle($penMed,$bx,$by,$bw,$bh)
$g.DrawLine($penMed,($bx+($bw*0.6)),$by,($bx+($bw*0.6)),($by+$bh))
$lines=@("PROJECT: 3-BED HOUSE 108m2","SCALE: 1:50 @ A3  |  DATE: 2026-09-19","DWG: A-101  PLAN  |  DRAWN: Muse Spark","NOTE: Verify on site. For AutoCAD use DXF.")
for($li=0;$li -lt $lines.Count;$li++){ $g.DrawString($lines[$li],$fontBlock,$brushTxt,($bx+20),($by+18+$li*40)) }
$g.DrawString("WALLS", $fontSmall,$brushTxt,($bx+$bw*0.6+20),($by+18))
$g.FillRectangle($wallBrush,($bx+$bw*0.6+110),($by+20),60,18)
$g.DrawString("DOOR", $fontSmall,$brushTxt,($bx+$bw*0.6+200),($by+18))
$g.DrawLine($penDoor,($bx+$bw*0.6+270),($by+28),($bx+$bw*0.6+330),($by+28))
$g.DrawString("WINDOW", $fontSmall,$brushTxt,($bx+$bw*0.6+360),($by+18))
$g.DrawLine($penWindow,($bx+$bw*0.6+470),($by+28),($bx+$bw*0.6+540),($by+28))
$g.DrawString("DIM", $fontSmall,$brushTxt,($bx+$bw*0.6+570),($by+18))
$g.DrawLine($penDim,($bx+$bw*0.6+640),($by+28),($bx+$bw*0.6+710),($by+28))

$out=Join-Path (Get-Location) "house_plan.png"
$bmp.Save($out,[System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $bmp.Dispose()
Write-Output "saved $out"
