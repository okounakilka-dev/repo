Add-Type -AssemblyName System.Drawing
$Scale=58
$OXx=250
$OYy=150
$Wm=42.0
$Hm=18.0
$Wpx=[int]($Wm*$Scale)
$Hpx=[int]($Hm*$Scale)
$CW=3400
$CH=3000
$bmp=New-Object System.Drawing.Bitmap $CW,$CH
$g=[System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode=[System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g.TextRenderingHint=[System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
$g.Clear([System.Drawing.Color]::White)
function Get-PX{param([double]$QX)return [int]($OXx+$QX*$Scale)}
function Get-PY{param([double]$QY)return [int]($OYy+$QY*$Scale)}
function New-Rect2{param([double]$QX,[double]$QY,[double]$QW,[double]$QH)return New-Object System.Drawing.Rectangle ((Get-PX -QX $QX)),((Get-PY -QY $QY)),([int]($QW*$Scale)),([int]($QH*$Scale))}
$black=[System.Drawing.Color]::Black
$wallExt=New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(48,48,48))
$wallInt=New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(96,96,96))
$penThin=New-Object System.Drawing.Pen $black,2
$penMed=New-Object System.Drawing.Pen $black,3
$penPowDash=New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(200,20,20)),2
$penPowDash.DashStyle=[System.Drawing.Drawing2D.DashStyle]::Dash
$penBranch=New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(200,20,20)),1
$penBranch.DashStyle=[System.Drawing.Drawing2D.DashStyle]::Dash
$penTv=New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(0,90,180)),1
$brushTxt=New-Object System.Drawing.SolidBrush $black
$brushGray=New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(72,72,72))
$brushRed=New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(200,20,20))
$brushBlue=New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(0,90,180))
$fontTitle=New-Object System.Drawing.Font "Arial",19,([System.Drawing.FontStyle]::Bold)
$fontSub=New-Object System.Drawing.Font "Arial",10,([System.Drawing.FontStyle]::Regular)
$fontRm=New-Object System.Drawing.Font "Arial",9,([System.Drawing.FontStyle]::Bold)
$fontSm=New-Object System.Drawing.Font "Arial",7,([System.Drawing.FontStyle]::Regular)
$fontTag=New-Object System.Drawing.Font "Arial",6,([System.Drawing.FontStyle]::Bold)
$fontSch=New-Object System.Drawing.Font "Consolas",8,([System.Drawing.FontStyle]::Regular)
$fontSchB=New-Object System.Drawing.Font "Consolas",8,([System.Drawing.FontStyle]::Bold)
$bedC=[System.Drawing.Color]::FromArgb(238,244,255)
$bathC=[System.Drawing.Color]::FromArgb(224,246,255)
$corrC=[System.Drawing.Color]::FromArgb(247,247,247)
$lobC=[System.Drawing.Color]::FromArgb(255,249,232)
$srvC=[System.Drawing.Color]::FromArgb(242,242,242)
$g.FillRectangle((New-Object System.Drawing.SolidBrush $corrC),(New-Rect2 -QX 6 -QY 8 -QW 30 -QH 2.0))
$g.FillRectangle((New-Object System.Drawing.SolidBrush $lobC),(New-Rect2 -QX 0.3 -QY 0.3 -QW 5.7 -QH 17.4))
$g.FillRectangle((New-Object System.Drawing.SolidBrush $srvC),(New-Rect2 -QX 36 -QY 0.3 -QW 5.7 -QH 17.4))
for($ii=0;$ii -lt 8;$ii++){
  $qx=6+$ii*3.75
  $g.FillRectangle((New-Object System.Drawing.SolidBrush $bedC),(New-Rect2 -QX $qx -QY 0.3 -QW 3.75 -QH 7.7))
  $g.FillRectangle((New-Object System.Drawing.SolidBrush $bedC),(New-Rect2 -QX $qx -QY 10 -QW 3.75 -QH 7.7))
  $g.FillRectangle((New-Object System.Drawing.SolidBrush $bathC),(New-Rect2 -QX ([double]$qx+1.85) -QY 6.0 -QW 1.8 -QH 1.9))
  $g.FillRectangle((New-Object System.Drawing.SolidBrush $bathC),(New-Rect2 -QX ([double]$qx+1.85) -QY 10.1 -QW 1.8 -QH 1.9))
}
function Add-WallExt{param([double]$QX,[double]$QY,[double]$QW,[double]$QH)$g.FillRectangle($wallExt,(Get-PX -QX $QX),(Get-PY -QY $QY),([int]($QW*$Scale)),([int]($QH*$Scale)))}
function Add-WallInt{param([double]$QX,[double]$QY,[double]$QW,[double]$QH)$g.FillRectangle($wallInt,(Get-PX -QX $QX),(Get-PY -QY $QY),([int]($QW*$Scale)),([int]($QH*$Scale)))}
Add-WallExt -QX 0 -QY 0 -QW 42 -QH 0.3
Add-WallExt -QX 0 -QY 17.7 -QW 42 -QH 0.3
Add-WallExt -QX 0 -QY 0 -QW 0.3 -QH 18
Add-WallExt -QX 41.7 -QY 0 -QW 0.3 -QH 18
$g.DrawRectangle($penMed,(Get-PX -QX 0),(Get-PY -QY 0),$Wpx,$Hpx)
Add-WallExt -QX 6 -QY 7.8 -QW 30 -QH 0.2
Add-WallExt -QX 6 -QY 10 -QW 30 -QH 0.2
for($ii=0;$ii -le 8;$ii++){
  $qx=6+$ii*3.75
  Add-WallInt -QX ([double]$qx-0.075) -QY 0.3 -QW 0.15 -QH 7.7
  Add-WallInt -QX ([double]$qx-0.075) -QY 10 -QW 0.15 -QH 7.7
}
Add-WallExt -QX 6 -QY 0.3 -QW 0.2 -QH 17.4
Add-WallExt -QX 35.8 -QY 0.3 -QW 0.2 -QH 17.4
$g.DrawString("E-101 POWER LAYOUT - 42x18m HOTEL 16 ROOMS 101-116 - 1:100 @A3",$fontTitle,$brushTxt,($OXx-20),10)
$g.DrawString("120/240V 1Ph 3W. AFCI / GFCI per NEC 210.12 / 210.8. Conduit 20mm. Power spine corridor only.",$fontSub,$brushGray,($OXx-10),42)
function Draw-OrthoSeg{param([System.Drawing.Pen]$PP,[object[]]$PT)
  for($jj=0;$jj -lt ($PT.Count-1);$jj++){
    $g.DrawLine($PP,(Get-PX -QX $PT[$jj][0]),(Get-PY -QY $PT[$jj][1]),(Get-PX -QX $PT[$jj+1][0]),(Get-PY -QY $PT[$jj+1][1]))
  }
}
function Draw-SockDbl{param([double]$QX,[double]$QY,[string]$TT)
  $px=(Get-PX -QX $QX)
  $py=(Get-PY -QY $QY)
  $g.FillRectangle([System.Drawing.Brushes]::White,($px-9),($py-9),18,18)
  $g.DrawRectangle($penThin,($px-9),($py-9),18,18)
  $g.DrawEllipse($penThin,($px-7),($py-6),6,6)
  $g.DrawEllipse($penThin,($px+1),($py-6),6,6)
  $g.DrawLine($penThin,($px-9),($py+3),($px+9),($py+3))
  $g.DrawString($TT,$fontTag,$brushTxt,($px-22),($py+10))
}
function Draw-UsbC65{param([double]$QX,[double]$QY,[string]$TT)
  $px=(Get-PX -QX $QX)
  $py=(Get-PY -QY $QY)
  $bb=New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(210,235,255))
  $g.FillRectangle($bb,($px-11),($py-8),22,16)
  $g.DrawRectangle($penTv,($px-11),($py-8),22,16)
  $g.DrawString("USB",$fontTag,$brushTxt,($px-10),($py-7))
  $g.DrawString($TT,$fontTag,$brushTxt,($px-22),($py+10))
  $bb.Dispose()
}
function Draw-TvLan{param([double]$QX,[double]$QY,[string]$TT)
  $px=(Get-PX -QX $QX)
  $py=(Get-PY -QY $QY)
  $g.FillRectangle([System.Drawing.Brushes]::White,($px-13),($py-8),26,16)
  $g.DrawRectangle($penTv,($px-13),($py-8),26,16)
  $g.DrawString("TV/LAN",$fontTag,$brushTxt,($px-12),($py-6))
  $g.DrawString($TT,$fontTag,$brushTxt,($px-22),($py+10))
}
function Draw-FcuIsol{param([double]$QX,[double]$QY,[string]$TT)
  $px=(Get-PX -QX $QX)
  $py=(Get-PY -QY $QY)
  $g.FillRectangle([System.Drawing.Brushes]::White,($px-12),($py-8),36,16)
  $g.DrawRectangle($penThin,($px-12),($py-8),36,16)
  $g.DrawString("FCU-ISOL",$fontTag,$brushTxt,($px-11),($py-6))
  $g.DrawString($TT,$fontTag,$brushTxt,($px-22),($py+10))
}
function Draw-BathIsol{param([double]$QX,[double]$QY,[string]$TT)
  $px=(Get-PX -QX $QX)
  $py=(Get-PY -QY $QY)
  $bb=New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255,235,200))
  $g.FillEllipse($bb,($px-10),($py-10),20,20)
  $g.DrawEllipse($penThin,($px-10),($py-10),20,20)
  $g.DrawString("BH",$fontTag,$brushTxt,($px-6),($py-7))
  $g.DrawString($TT,$fontTag,$brushTxt,($px-22),($py+10))
  $bb.Dispose()
}
function Draw-KeyCard{param([double]$QX,[double]$QY,[string]$TT)
  $px=(Get-PX -QX $QX)
  $py=(Get-PY -QY $QY)
  $g.FillRectangle([System.Drawing.Brushes]::White,($px-7),($py-10),14,20)
  $g.DrawRectangle($penThin,($px-7),($py-10),14,20)
  $g.DrawString("KS",$fontTag,$brushTxt,($px-6),($py-7))
  $g.DrawString($TT,$fontTag,$brushTxt,($px-22),($py+12))
}
for($ii=0;$ii -lt 8;$ii++){
  $qx=6+$ii*3.75
  $rnN=101+$ii
  $rnS=109+$ii
  Draw-KeyCard ([double]$qx+0.35) 7.55 ("KS"+$rnN)
  Draw-SockDbl ([double]$qx+0.55) 5.6 ("P"+$rnN+"-1 AFCI")
  Draw-SockDbl ([double]$qx+2.95) 2.2 ("P"+$rnN+"-2 GFCI")
  Draw-UsbC65 ([double]$qx+0.55) 3.6 ("P"+$rnN+"-U1 AFCI")
  Draw-UsbC65 ([double]$qx+2.95) 5.2 ("P"+$rnN+"-U2 AFCI")
  Draw-TvLan ([double]$qx+1.85) 1.05 ("TV"+$rnN+" CAT6")
  Draw-FcuIsol ([double]$qx+2.35) 7.15 ("FCU"+$rnN)
  Draw-BathIsol ([double]$qx+2.75) 6.45 ("BH"+$rnN+" GFCI")
  Draw-KeyCard ([double]$qx+0.35) 10.45 ("KS"+$rnS)
  Draw-SockDbl ([double]$qx+0.55) 12.4 ("P"+$rnS+"-1 AFCI")
  Draw-SockDbl ([double]$qx+2.95) 15.8 ("P"+$rnS+"-2 GFCI")
  Draw-UsbC65 ([double]$qx+0.55) 14.4 ("P"+$rnS+"-U1 AFCI")
  Draw-UsbC65 ([double]$qx+2.95) 12.8 ("P"+$rnS+"-U2 AFCI")
  Draw-TvLan ([double]$qx+1.85) 16.95 ("TV"+$rnS+" CAT6")
  Draw-FcuIsol ([double]$qx+2.35) 10.85 ("FCU"+$rnS)
  Draw-BathIsol ([double]$qx+2.75) 11.55 ("BH"+$rnS+" GFCI")
  $cx=(Get-PX -QX $qx)+([int](3.75*$Scale/2))
  $g.DrawString(("$rnN"),$fontRm,$brushGray,($cx-30),(Get-PY -QY 8.55))
  $g.DrawString(("$rnS"),$fontRm,$brushGray,($cx+8),(Get-PY -QY 8.55))
}
$dbNR=New-Rect2 -QX 18.2 -QY 8.25 -QW 1.6 -QH 0.7
$g.FillRectangle([System.Drawing.Brushes]::White,$dbNR)
$g.DrawRectangle($penMed,$dbNR.X,$dbNR.Y,$dbNR.Width,$dbNR.Height)
$g.DrawString("DB-N",$fontRm,$brushTxt,(Get-PX -QX 18.55),(Get-PY -QY 8.35))
$dbSR=New-Rect2 -QX 22.2 -QY 8.25 -QW 1.6 -QH 0.7
$g.FillRectangle([System.Drawing.Brushes]::White,$dbSR)
$g.DrawRectangle($penMed,$dbSR.X,$dbSR.Y,$dbSR.Width,$dbSR.Height)
$g.DrawString("DB-S",$fontRm,$brushTxt,(Get-PX -QX 22.55),(Get-PY -QY 8.35))
Draw-OrthoSeg $penPowDash @(@(6,9.0),@(36,9.0))
for($ii=0;$ii -lt 8;$ii++){
  $qx=6+$ii*3.75+1.875
  Draw-OrthoSeg $penBranch @(@($qx,7.9),@($qx,9.0))
  Draw-OrthoSeg $penBranch @(@($qx,10.1),@($qx,9.0))
}
Draw-OrthoSeg $penPowDash @(@(19.0,9.0),@(19.0,8.95),@(19.0,8.25))
Draw-OrthoSeg $penPowDash @(@(23.0,9.0),@(23.0,8.95),@(23.0,8.25))
$g.DrawString("2x2.5/20mm",$fontSm,$brushRed,(Get-PX -QX 10),(Get-PY -QY 9.1))
$g.DrawString("2x2.5/20mm",$fontSm,$brushRed,(Get-PX -QX 26),(Get-PY -QY 9.1))
$g.DrawString("PWR SPINE RED DASH - ORTHO HALLWAY ONLY",$fontSm,$brushRed,(Get-PX -QX 12),(Get-PY -QY 8.15))
$lx=(Get-PX -QX 42)+20
$ly=(Get-PY -QY 0.6)
$legList=@("LEGEND E-101 POWER","SQUARE 2DOT = DOUBLE SOCKET 15A","BLUE USB = USB-C 65W 2/ROOM","TV/LAN = TV + CAT6 DATA","FCU-ISOL = FAN COIL ISOLATOR","BH = BATH HEATER ISOL GFCI","KS = KEY-CARD SWITCH ENTRY","RED DASH = POWER SPINE/HOMERUN","TAG P101-1 AFCI / P101-2 GFCI","CONDUIT 2x2.5/20mm Cu","NEC 210.12 AFCI BED/LIVING","NEC 210.8 GFCI BATH/KITCHEN","DB-N NORTH 101-108 DB-S 109-116")
for($ii=0;$ii -lt $legList.Count;$ii++){
  $g.DrawString($legList[$ii],$fontSub,$brushTxt,$lx,($ly+$ii*22))
}
$nx=(Get-PX -QX 42)+60
$ny=(Get-PY -QY 5.2)
$g.DrawEllipse($penMed,$nx,$ny,60,60)
$fN=New-Object System.Drawing.Font "Arial",20,([System.Drawing.FontStyle]::Bold)
$g.DrawString("N",$fN,$brushTxt,($nx+16),($ny+10))
$g.DrawLine($penMed,($nx+30),($ny+42),($nx+30),($ny+14))
$barX=(Get-PX -QX 0)
$barY=(Get-PY -QY 18)+28
$g.DrawString("SCALE 1:100  0  1  2  3  4  5m",$fontSm,$brushTxt,$barX,$barY)
for($ii=0;$ii -lt 5;$ii++){
  $px=(Get-PX -QX 0)+($ii*[int](1*$Scale))
  $py=$barY+18
  $ww=[int](1*$Scale)
  if(($ii%2) -eq 0){
    $g.FillRectangle([System.Drawing.Brushes]::Black,$px,$py,$ww,8)
  }
  $g.DrawRectangle($penThin,$px,$py,$ww,8)
}
$tx=80
$ty=(Get-PY -QY 18)+70
$tw=$CW-160
$colList=@(70,260,760,980,1140)
$rowList=@()
$rowList+=,@("CKT","DESCRIPTION","WIRE CONDUIT","BRK","LOAD")
$rowList+=,@("B-1","LIGHTS+NORTH 101-104 BED AFCI","2x1.5/20mm","15A AFCI","0.4kW")
$rowList+=,@("B-2","SOCKETS P101..104-1 DOUBLE AFCI","2x2.5/20mm","20A AFCI","1.8kW")
$rowList+=,@("B-3","USB-C 65W + TV/LAN 101-104 AFCI","2x2.5/20mm+CAT6","20A AFCI","0.6kW")
$rowList+=,@("B-4","FCU ISOLATORS 101-104","2x2.5/20mm","20A","3.2kW")
$rowList+=,@("B-5","BATH HEATERS BH101-104 GFCI","2x2.5/20mm","20A GFCI","4.0kW")
$rowList+=,@("B-6","LIGHTS+SOUTH 109-112 BED AFCI","2x1.5/20mm","15A AFCI","0.4kW")
$rowList+=,@("B-7","SOCKETS P109..112-1 DOUBLE AFCI","2x2.5/20mm","20A AFCI","1.8kW")
$rowList+=,@("B-8","USB-C 65W + TV/LAN 109-112 AFCI","2x2.5/20mm+CAT6","20A AFCI","0.6kW")
$rowList+=,@("B-9","FCU 105-108+113-116 + KS CONTACTOR","2x2.5/20mm","20A","6.4kW")
$rowList+=,@("B-10","BH105-108+113-116 + CORR DB-N/DB-S","2x2.5/20mm","20A GFCI","8.0kW")
$rowList+=,@("MAIN","PANEL A 120/240V 1Ph 3W MAIN","-","100A","28kW div")
$g.DrawString("PANEL A 120/240V SCHEDULE - E-101 POWER",$fontRm,$brushTxt,$tx,($ty-22))
$rh=[int]26
$g.FillRectangle($wallExt,$tx,$ty,$tw,$rh)
for($ii=0;$ii -lt $rowList.Count;$ii++){
  $yy=$ty+$ii*$rh
  if($ii -gt 0){
    $g.DrawRectangle($penThin,$tx,$yy,$tw,$rh)
  }
  for($jj=0;$jj -lt 5;$jj++){
    $xx=$tx
    if($jj -gt 0){
      $xx=$tx+$colList[$jj-1]
    }
    $ww=$colList[0]
    if($jj -gt 0 -and $jj -lt 4){
      $ww=$colList[$jj]-$colList[$jj-1]
    }
    if($jj -eq 0){
      $ww=$colList[0]
    }
    if($jj -eq 4){
      $ww=$tw-$colList[3]
    }
    if($jj -gt 0){
      $g.DrawLine($penThin,$xx,$yy,$xx,($yy+$rh))
    }
    $ff=$fontSch
    $bb2=$brushTxt
    if($ii -eq 0){
      $ff=$fontSchB
      $bb2=[System.Drawing.Brushes]::White
    }
    $g.DrawString($rowList[$ii][$jj],$ff,$bb2,($xx+4),($yy+6))
  }
}
$g.DrawString("NOTES: AFCI per NEC 210.12 bedrooms/living. GFCI per NEC 210.8 bath/kitchen. KS key-card contactor drops power on exit. FCU/BH isolators above entry. TV/LAN CAT6 homerun to DB. All homeruns orthogonal via corridor spine - no diagonals.",$fontSm,$brushGray,$tx,($ty+$rowList.Count*$rh+8))
$out=Join-Path (Get-Location) "hotel_E101_power.png"
$bmp.Save($out,[System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose()
$bmp.Dispose()
Write-Output ("saved "+$out)
