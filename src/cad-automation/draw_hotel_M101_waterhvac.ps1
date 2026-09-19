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
$penCW=New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(0,120,215)),4
$penHW=New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(215,20,20)),4
$penREC=New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(230,120,0)),2
$penREC.DashStyle=[System.Drawing.Drawing2D.DashStyle]::Dash
$penCW20=New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(0,120,215)),2
$penHW20=New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(215,20,20)),2
$penSoil=New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(20,20,20)),4
$penVent=New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(90,90,90)),2
$penVent.DashStyle=[System.Drawing.Drawing2D.DashStyle]::Dash
$penDuct=New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(0,160,60)),7
$penFlex=New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(0,160,60)),1
$penFlex.DashStyle=[System.Drawing.Drawing2D.DashStyle]::Dash
$penExt=New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(128,0,160)),2
$penDim=New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(0,90,160)),1
$brushTxt=New-Object System.Drawing.SolidBrush $black
$brushGray=New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(72,72,72))
$brushBlue=New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(0,120,215))
$brushRed=New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(215,20,20))
$brushGreen=New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(0,140,60))
$brushPurp=New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(128,0,160))
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
for($ii=0;$ii -lt 8;$ii++){
  $qx=6+$ii*3.75
  Add-WallInt -QX ([double]$qx+1.85) -QY 6.0 -QW 0.1 -QH 1.9
  Add-WallInt -QX ([double]$qx+1.85) -QY 10.1 -QW 0.1 -QH 1.9
}
$g.DrawString("M-101 WATER / HVAC - 42x18m HOTEL 16 ROOMS 101-116 - 1:100 @A3",$fontTitle,$brushTxt,($OXx-20),10)
$g.DrawString("CW/HW PPR spine corridor. Soil 110 stacks ST1-ST3. Fresh duct 600x200 + FCU + bath extract. TMV43 at baths.",$fontSub,$brushGray,($OXx-10),42)
function Draw-OrthoSeg{param([System.Drawing.Pen]$PP,[object[]]$PT)
  for($jj=0;$jj -lt ($PT.Count-1);$jj++){
    $g.DrawLine($PP,(Get-PX -QX $PT[$jj][0]),(Get-PY -QY $PT[$jj][1]),(Get-PX -QX $PT[$jj+1][0]),(Get-PY -QY $PT[$jj+1][1]))
  }
}
function Draw-FCU{param([double]$QX,[double]$QY,[string]$TT)
  $px=(Get-PX -QX $QX)
  $py=(Get-PY -QY $QY)
  $rr=New-Object System.Drawing.Rectangle ($px-30),($py-9),60,18
  $g.FillRectangle([System.Drawing.Brushes]::White,$rr)
  $g.DrawRectangle($penFlex,$rr.X,$rr.Y,$rr.Width,$rr.Height)
  $g.FillRectangle((New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(220,245,225))),($px-30),($py-9),60,7)
  $g.DrawString("FCU",$fontTag,$brushGreen,($px-11),($py-9))
  $g.DrawString($TT,$fontTag,$brushTxt,($px-24),($py+10))
}
function Draw-FD{param([double]$QX,[double]$QY)
  $px=(Get-PX -QX $QX)
  $py=(Get-PY -QY $QY)
  $g.FillRectangle([System.Drawing.Brushes]::White,($px-7),($py-7),14,14)
  $g.DrawRectangle($penThin,($px-7),($py-7),14,14)
  $g.DrawLine($penThin,($px-7),($py-7),($px+7),($py+7))
  $g.DrawLine($penThin,($px+7),($py-7),($px-7),($py+7))
  $g.DrawString("FD",$fontTag,$brushTxt,($px-7),($py+8))
}
function Draw-Stack{param([double]$QX,[string]$TT)
  $px=(Get-PX -QX $QX)
  $py=(Get-PY -QY 9.0)
  $g.FillEllipse([System.Drawing.Brushes]::Black,($px-11),($py-11),22,22)
  $g.FillEllipse([System.Drawing.Brushes]::White,($px-7),($py-7),14,14)
  $g.DrawEllipse($penThin,($px-11),($py-11),22,22)
  $g.DrawString($TT,$fontTag,$brushTxt,($px-14),($py+12))
}
for($ii=0;$ii -lt 8;$ii++){
  $qx=6+$ii*3.75
  $rnN=101+$ii
  $rnS=109+$ii
  Draw-FCU ([double]$qx+1.2) 7.3 ("FCU"+$rnN)
  Draw-FCU ([double]$qx+1.2) 10.7 ("FCU"+$rnS)
  Draw-FD ([double]$qx+3.25) 7.5
  Draw-FD ([double]$qx+3.25) 10.6
  $cx=(Get-PX -QX $qx)+([int](3.75*$Scale/2))
  $g.DrawString(("$rnN"),$fontRm,$brushGray,($cx-30),(Get-PY -QY 8.55))
  $g.DrawString(("$rnS"),$fontRm,$brushGray,($cx+8),(Get-PY -QY 8.55))
}
Draw-OrthoSeg $penDuct @(@(6,9.0),@(36,9.0))
Draw-OrthoSeg $penCW @(@(6,8.55),@(36,8.55))
Draw-OrthoSeg $penHW @(@(6,8.75),@(36,8.75))
Draw-OrthoSeg $penREC @(@(6,8.90),@(36,8.90))
Draw-OrthoSeg $penSoil @(@(6,7.30),@(36,7.30))
Draw-OrthoSeg $penSoil @(@(6,10.70),@(36,10.70))
Draw-OrthoSeg $penVent @(@(6,7.05),@(36,7.05))
Draw-OrthoSeg $penVent @(@(6,10.95),@(36,10.95))
Draw-OrthoSeg $penExt @(@(6,7.55),@(36,7.55))
Draw-OrthoSeg $penExt @(@(6,10.45),@(36,10.45))
for($ii=0;$ii -lt 8;$ii++){
  $qx=6+$ii*3.75
  $bx=[double]$qx+2.7
  Draw-OrthoSeg $penCW20 @(@($bx,8.55),@($bx,6.9))
  Draw-OrthoSeg $penHW20 @(@(([double]$bx+0.18),8.75),@(([double]$bx+0.18),6.9))
  Draw-OrthoSeg $penCW20 @(@($bx,8.55),@($bx,11.1))
  Draw-OrthoSeg $penHW20 @(@(([double]$bx+0.18),8.75),@(([double]$bx+0.18),11.1))
  Draw-OrthoSeg $penSoil @(@($bx,7.30),@($bx,6.9))
  Draw-OrthoSeg $penSoil @(@($bx,10.70),@($bx,11.1))
  Draw-OrthoSeg $penFlex @(@(([double]$qx+1.2),9.0),@(([double]$qx+1.2),7.3))
  Draw-OrthoSeg $penFlex @(@(([double]$qx+1.2),9.0),@(([double]$qx+1.2),10.7))
  $px=(Get-PX -QX $bx)
  $pyN=(Get-PY -QY 6.9)
  $pyS=(Get-PY -QY 11.1)
  $g.FillRectangle([System.Drawing.Brushes]::White,($px-6),($pyN-6),26,12)
  $g.DrawRectangle($penThin,($px-6),($pyN-6),26,12)
  $g.DrawString("TMV43",$fontTag,$brushRed,($px-5),($pyN-5))
  $g.FillRectangle([System.Drawing.Brushes]::White,($px-6),($pyS-6),26,12)
  $g.DrawRectangle($penThin,($px-6),($pyS-6),26,12)
  $g.DrawString("TMV43",$fontTag,$brushRed,($px-5),($pyS-5))
}
Draw-Stack 9 "ST1 110"
Draw-Stack 20 "ST2 110"
Draw-Stack 31 "ST3 110"
for($ii=0;$ii -lt 3;$ii++){
  $stx=9+$ii*11
  if($ii -eq 1){ $stx=20 }
  if($ii -eq 2){ $stx=31 }
  $g.DrawString("V",$fontTag,$brushGray,(Get-PX -QX $stx),(Get-PY -QY 9.35))
}
$g.DrawString("CW 32 PPR BLUE y=8.55 6-36",$fontSm,$brushBlue,(Get-PX -QX 10),(Get-PY -QY 8.25))
$g.DrawString("HW 32 RED y=8.75 + RECIRC DASH y=8.90",$fontSm,$brushRed,(Get-PX -QX 22),(Get-PY -QY 8.25))
$g.DrawString("FRESH 600x200 GREEN y=9.0 6-36 + FLEX TO FCU",$fontSm,$brushGreen,(Get-PX -QX 11),(Get-PY -QY 9.15))
$g.DrawString("SOIL 110 BLACK y=7.3/10.7 VENT DASH EXTRACT PURPLE",$fontSm,$brushTxt,(Get-PX -QX 10),(Get-PY -QY 10.15))
$g.DrawString("20mm DROPS TO EACH BATH x+2.7 TMV43 43C FD FLOOR DRAIN",$fontSm,$brushTxt,(Get-PX -QX 10),(Get-PY -QY 6.35))
$lx=(Get-PX -QX 42)+20
$ly=(Get-PY -QY 0.6)
$legList=@("LEGEND M-101 WATER/HVAC","BLUE 4px = CW 32mm PPR 3.5bar","RED 4px = HW 32mm PPR 3.0bar","ORANGE DASH = RECIRC 20mm","BLUE/RED 2px = 20mm BATH DROP","TMV43 = MIXER 43C EACH BATH","BLACK 4px = SOIL 110 @1:60","GRAY DASH = VENT 75 TO ROOF","ST1 x=9 ST2 x=20 ST3 x=31","FD X-BOX = FLOOR DRAIN 75","GREEN 7px = FRESH 600x200","GREEN DASH = FLEX 150 TO FCU","PURPLE = BATH EXTRACT TO ROOF","FCU = FAN COIL ABOVE ENTRY")
for($ii=0;$ii -lt $legList.Count;$ii++){
  $g.DrawString($legList[$ii],$fontSub,$brushTxt,$lx,($ly+$ii*22))
}
$nx=(Get-PX -QX 42)+60
$ny=(Get-PY -QY 5.6)
$g.DrawEllipse($penMed,$nx,$ny,60,60)
$fN=New-Object System.Drawing.Font "Arial",20,([System.Drawing.FontStyle]::Bold)
$g.DrawString("N",$fN,$brushTxt,($nx+16),($ny+10))
$g.DrawLine($penMed,($nx+30),($ny+42),($nx+30),($ny+14))
$barX=(Get-PX -QX 0)
$barY=(Get-PY -QY 18)+28
$g.DrawString("SCALE 1:100  0  1  2  3  4  5m  NORTH UP - PLAN TOP = NORTH",$fontSm,$brushTxt,$barX,$barY)
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
$ty=(Get-PY -QY 18)+80
$tw=1560
$colList=@(110,420,760,990,1230)
$rowList=@()
$rowList+=,@("FCU","LOCATION","AIRFLOW","COOL/HEAT","WATER/HW")
$rowList+=,@("FCU101","101 ABOVE ENTRY","120 L/s","2.2/2.8kW","20/20mm")
$rowList+=,@("FCU102","102 ABOVE ENTRY","120 L/s","2.2/2.8kW","20/20mm")
$rowList+=,@("FCU103","103 ABOVE ENTRY","120 L/s","2.2/2.8kW","20/20mm")
$rowList+=,@("FCU104","104 ABOVE ENTRY","120 L/s","2.2/2.8kW","20/20mm")
$rowList+=,@("FCU105","105 ABOVE ENTRY","120 L/s","2.2/2.8kW","20/20mm")
$rowList+=,@("FCU106","106 ABOVE ENTRY","120 L/s","2.2/2.8kW","20/20mm")
$rowList+=,@("FCU107","107 ABOVE ENTRY","120 L/s","2.2/2.8kW","20/20mm")
$rowList+=,@("FCU108","108 ABOVE ENTRY","120 L/s","2.2/2.8kW","20/20mm")
$rowList+=,@("FCU109","109 ABOVE ENTRY","120 L/s","2.2/2.8kW","20/20mm")
$g.DrawString("FCU SCHEDULE - 4-PIPE FAN COIL ABOVE EACH ENTRY FLEX 150 FROM 600x200",$fontRm,$brushTxt,$tx,($ty-22))
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
$tx2=1720
$tw2=1560
$col2=@(140,520,830,1100)
$prow=@()
$prow+=,@("SYS","SIZE / ROUTE","PRESS/FLOW","NOTE")
$prow+=,@("CW","32mm PPR 6-36 y=8.55","3.5bar 0.45L/s","spine + 20mm drops bath")
$prow+=,@("HW","32mm PPR 6-36 y=8.75","3.0bar 0.40L/s","+ recirc 20mm y=8.90")
$prow+=,@("DROP","20mm PPR x+2.7-6.9/11.1","2.0bar 0.15L/s","TMV43 43C each bath")
$prow+=,@("SOIL","110uPVC y=7.3/10.7","@1:60 2.5L/s","ST1 x=9 ST2 x=20 ST3 x=31")
$prow+=,@("VENT","75uPVC y=7.05/10.95","vent to roof","3 stacks to roof cowl")
$prow+=,@("FD","75 floor drain baths","trap 50mm","1 per bath + fall 1:80")
$prow+=,@("FRESH","600x200 GIS y=9.0 6-36","1200L/s 1.8m/s","corridor + flex 150 FCU")
$prow+=,@("EXT","150 purple baths-roof","40L/s/bath","interlocked light + run-on")
$prow+=,@("FCU","110-116 same as 101-109","120L/s ea","total 16x120=1920L/s")
$g.DrawString("PLUMBING PRESSURES / FLOWS + SOIL/VENT + DUCT SIZES",$fontRm,$brushTxt,$tx2,($ty-22))
$g.FillRectangle($wallExt,$tx2,$ty,$tw2,$rh)
for($ii=0;$ii -lt $prow.Count;$ii++){
  $yy=$ty+$ii*$rh
  if($ii -gt 0){
    $g.DrawRectangle($penThin,$tx2,$yy,$tw2,$rh)
  }
  for($jj=0;$jj -lt 4;$jj++){
    $xx=$tx2
    if($jj -gt 0){
      $xx=$tx2+$col2[$jj-1]
    }
    $ww=$col2[0]
    if($jj -gt 0 -and $jj -lt 3){
      $ww=$col2[$jj]-$col2[$jj-1]
    }
    if($jj -eq 0){
      $ww=$col2[0]
    }
    if($jj -eq 3){
      $ww=$tw2-$col2[2]
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
    $g.DrawString($prow[$ii][$jj],$ff,$bb2,($xx+4),($yy+6))
  }
}
$g.DrawString("NOTES: CW 32/HW32 PPR PN20 spine corridor only all drops ortho. TMV43C anti-scald each bath. Soil 110 @1:60 to ST1/ST2/ST3 vent 75 to roof. FD 75 trapped falls 1:80. Fresh 600x200 GIS corridor flex 150 to FCU above entry. Bath extract 150 purple to roof 40L/s. Pressures test CW 10bar/1h. No diagonals.",$fontSm,$brushGray,$tx,($ty+$rowList.Count*$rh+10))
$out=Join-Path (Get-Location) "hotel_M101_waterhvac.png"
$bmp.Save($out,[System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose()
$bmp.Dispose()
Write-Output ("saved "+$out)
