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
$penGold=New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(184,134,11)),2
$penGold.DashStyle=[System.Drawing.Drawing2D.DashStyle]::Dash
$penGreen=New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(0,140,60)),2
$penGreen.DashStyle=[System.Drawing.Drawing2D.DashStyle]::Dash
$penBlue=New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(0,90,180)),1
$penBlue.DashStyle=[System.Drawing.Drawing2D.DashStyle]::Dash
$penRed=New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(200,20,20)),2
$brushTxt=New-Object System.Drawing.SolidBrush $black
$brushGray=New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(72,72,72))
$brushGold=New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(140,100,0))
$brushGreen=New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(0,130,55))
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
$utC=[System.Drawing.Color]::FromArgb(242,242,242)
$g.FillRectangle((New-Object System.Drawing.SolidBrush $corrC),(New-Rect2 -QX 6 -QY 8 -QW 30 -QH 2.0))
$g.FillRectangle((New-Object System.Drawing.SolidBrush $lobC),(New-Rect2 -QX 0.3 -QY 0.3 -QW 5.7 -QH 17.4))
$g.FillRectangle((New-Object System.Drawing.SolidBrush $utC),(New-Rect2 -QX 36 -QY 0.3 -QW 5.7 -QH 17.4))
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
$g.DrawString("E-102 LIGHTING LAYOUT - 42x18m HOTEL 16 ROOMS 101-116 - 1:100 @A3",$fontTitle,$brushTxt,($OXx-20),10)
$g.DrawString("Lighting only. 12W LED per room + vanity. Gold dash = switch-leg ortho. Green = EM. Blue dash = addressable FA loop.",$fontSub,$brushGray,($OXx-10),42)
function Draw-OrthoSeg{param([System.Drawing.Pen]$PP,[object[]]$PT)
  for($jj=0;$jj -lt ($PT.Count-1);$jj++){
    $g.DrawLine($PP,(Get-PX -QX $PT[$jj][0]),(Get-PY -QY $PT[$jj][1]),(Get-PX -QX $PT[$jj+1][0]),(Get-PY -QY $PT[$jj+1][1]))
  }
}
function Draw-Ceil12{param([double]$QX,[double]$QY,[string]$TT)
  $px=(Get-PX -QX $QX)
  $py=(Get-PY -QY $QY)
  $bb=New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255,246,200))
  $g.FillEllipse($bb,($px-11),($py-11),22,22)
  $g.DrawEllipse($penThin,($px-11),($py-11),22,22)
  $g.DrawLine($penThin,($px-8),($py-8),($px+8),($py+8))
  $g.DrawLine($penThin,($px+8),($py-8),($px-8),($py+8))
  $g.DrawString($TT,$fontTag,$brushTxt,($px-14),($py+12))
  $bb.Dispose()
}
function Draw-Vanity{param([double]$QX,[double]$QY,[string]$TT)
  $px=(Get-PX -QX $QX)
  $py=(Get-PY -QY $QY)
  $bb=New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255,238,180))
  $g.FillRectangle($bb,($px-14),($py-5),28,10)
  $g.DrawRectangle($penThin,($px-14),($py-5),28,10)
  $g.DrawString("V",$fontTag,$brushTxt,($px-4),($py-6))
  $g.DrawString($TT,$fontTag,$brushTxt,($px-22),($py+7))
  $bb.Dispose()
}
function Draw-Sw1{param([double]$QX,[double]$QY,[string]$TT)
  $px=(Get-PX -QX $QX)
  $py=(Get-PY -QY $QY)
  $g.FillRectangle([System.Drawing.Brushes]::White,($px-8),($py-8),16,16)
  $g.DrawRectangle($penThin,($px-8),($py-8),16,16)
  $g.DrawString("S",$fontTag,$brushTxt,($px-5),($py-7))
  $g.DrawString($TT,$fontTag,$brushTxt,($px-22),($py+10))
}
function Draw-Sw2{param([double]$QX,[double]$QY,[string]$TT)
  $px=(Get-PX -QX $QX)
  $py=(Get-PY -QY $QY)
  $g.FillRectangle([System.Drawing.Brushes]::White,($px-9),($py-8),18,16)
  $g.DrawRectangle($penThin,($px-9),($py-8),18,16)
  $g.DrawString("S2",$fontTag,$brushTxt,($px-7),($py-7))
  $g.DrawString($TT,$fontTag,$brushTxt,($px-22),($py+10))
}
function Draw-EMBat{param([double]$QX,[double]$QY,[string]$TT)
  $px=(Get-PX -QX $QX)
  $py=(Get-PY -QY $QY)
  $bb=New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(0,150,65))
  $g.FillRectangle($bb,($px-18),($py-9),36,18)
  $g.DrawRectangle($penThin,($px-18),($py-9),36,18)
  $g.DrawString("EM",$fontTag,[System.Drawing.Brushes]::White,($px-8),($py-7))
  $g.DrawString($TT,$fontTag,$brushGreen,($px-22),($py+10))
  $bb.Dispose()
}
function Draw-ExitLed{param([double]$QX,[double]$QY,[string]$TT)
  $px=(Get-PX -QX $QX)
  $py=(Get-PY -QY $QY)
  $bb=New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(200,20,20))
  $g.FillRectangle($bb,($px-22),($py-9),44,18)
  $g.DrawRectangle($penThin,($px-22),($py-9),44,18)
  $g.DrawString("EXIT",$fontTag,[System.Drawing.Brushes]::White,($px-12),($py-7))
  $g.DrawString($TT,$fontTag,$brushRed,($px-22),($py+10))
  $bb.Dispose()
}
function Draw-Smok{param([double]$QX,[double]$QY,[string]$TT)
  $px=(Get-PX -QX $QX)
  $py=(Get-PY -QY $QY)
  $g.FillRectangle([System.Drawing.Brushes]::White,($px-10),($py-10),20,20)
  $g.DrawRectangle($penBlue,($px-10),($py-10),20,20)
  $g.DrawEllipse($penBlue,($px-6),($py-6),12,12)
  $g.DrawString($TT,$fontTag,$brushBlue,($px-24),($py+11))
}
function Draw-Mcp{param([double]$QX,[double]$QY,[string]$TT)
  $px=(Get-PX -QX $QX)
  $py=(Get-PY -QY $QY)
  $bb=New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255,210,210))
  $g.FillRectangle($bb,($px-8),($py-8),16,16)
  $g.DrawRectangle($penRed,($px-8),($py-8),16,16)
  $g.DrawString("M",$fontTag,$brushRed,($px-5),($py-7))
  $g.DrawString($TT,$fontTag,$brushRed,($px-24),($py+10))
  $bb.Dispose()
}
for($ii=0;$ii -lt 8;$ii++){
  $qx=6+$ii*3.75
  $rnN=101+$ii
  $rnS=109+$ii
  Draw-Ceil12 ([double]$qx+1.875) 4.0 ("L"+$rnN+" 12W")
  Draw-Vanity ([double]$qx+2.75) 6.3 ("V"+$rnN+" 6W")
  Draw-Sw1 ([double]$qx+0.35) 7.45 ("S"+$rnN)
  Draw-Smok ([double]$qx+1.0) 7.0 ("SD"+$rnN)
  Draw-OrthoSeg $penGold @(@(([double]$qx+0.35),7.45),@(([double]$qx+0.35),4.0),@(([double]$qx+1.875),4.0))
  Draw-OrthoSeg $penGold @(@(([double]$qx+2.75),6.3),@(([double]$qx+2.75),5.15),@(([double]$qx+1.875),5.15))
  $g.DrawString(("$rnN"),$fontRm,$brushGray,((Get-PX -QX $qx)+([int](3.75*$Scale/2))-30),(Get-PY -QY 8.55))
  Draw-Ceil12 ([double]$qx+1.875) 14.0 ("L"+$rnS+" 12W")
  Draw-Vanity ([double]$qx+2.75) 10.4 ("V"+$rnS+" 6W")
  Draw-Sw1 ([double]$qx+0.35) 10.55 ("S"+$rnS)
  Draw-Smok ([double]$qx+1.0) 11.0 ("SD"+$rnS)
  Draw-OrthoSeg $penGold @(@(([double]$qx+0.35),10.55),@(([double]$qx+0.35),14.0),@(([double]$qx+1.875),14.0))
  Draw-OrthoSeg $penGold @(@(([double]$qx+2.75),10.4),@(([double]$qx+2.75),12.85),@(([double]$qx+1.875),12.85))
  $g.DrawString(("$rnS"),$fontRm,$brushGray,((Get-PX -QX $qx)+([int](3.75*$Scale/2))+8),(Get-PY -QY 8.55))
  if(($ii -eq 0) -or ($ii -eq 7)){
    Draw-Sw2 ([double]$qx+3.3) 3.0 ("S2-"+$rnN)
    Draw-OrthoSeg $penGold @(@(([double]$qx+3.3),3.0),@(([double]$qx+3.3),4.0),@(([double]$qx+1.875),4.0))
    Draw-Sw2 ([double]$qx+3.3) 15.0 ("S2-"+$rnS)
    Draw-OrthoSeg $penGold @(@(([double]$qx+3.3),15.0),@(([double]$qx+3.3),14.0),@(([double]$qx+1.875),14.0))
  }
}
Draw-EMBat 9.0 9.0 "EM1 BATT"
Draw-EMBat 16.0 9.0 "EM2 BATT"
Draw-EMBat 23.0 9.0 "EM3 BATT"
Draw-EMBat 30.0 9.0 "EM4 BATT"
Draw-OrthoSeg $penGreen @(@(6.5,9.0),@(35.5,9.0))
Draw-ExitLed 6.6 8.55 "EX-W"
Draw-ExitLed 35.4 9.45 "EX-E"
Draw-ExitLed 3.0 8.6 "EX-L"
Draw-ExitLed 39.0 9.4 "EX-R"
Draw-Smok 7.0 9.55 "SD-C1"
Draw-Smok 14.0 9.55 "SD-C2"
Draw-Smok 21.0 9.55 "SD-C3"
Draw-Smok 28.0 9.55 "SD-C4"
Draw-Smok 35.0 9.55 "SD-C5"
Draw-Mcp 6.3 9.35 "MCP-W"
Draw-Mcp 35.7 8.65 "MCP-E"
Draw-Mcp 5.7 9.0 "MCP-L"
Draw-Mcp 36.3 9.0 "MCP-R"
Draw-OrthoSeg $penBlue @(@(5.7,9.7),@(36.3,9.7))
for($ii=0;$ii -lt 5;$ii++){
  $qx=7+$ii*7
  Draw-OrthoSeg $penBlue @(@($qx,9.55),@($qx,9.7))
}
Draw-OrthoSeg $penBlue @(@(6.3,9.35),@(6.3,9.7))
Draw-OrthoSeg $penBlue @(@(35.7,8.65),@(35.7,9.7))
$g.DrawString("GOLD DASH = SWITCH-LEG ORTHO ONLY",$fontSm,$brushGold,(Get-PX -QX 12),(Get-PY -QY 8.15))
$g.DrawString("GREEN DASH = EM CKT  EM-1   BLUE DASH = ADDRESSABLE FA LOOP",$fontSm,$brushGreen,(Get-PX -QX 12),(Get-PY -QY 9.15))
$lx=(Get-PX -QX 42)+20
$ly=(Get-PY -QY 0.6)
$legList=@("LEGEND E-102 LIGHTING","CIRCLE-X = CEILING 12W LED L101..","RECT V = VANITY 6W LED V101..","S = SINGLE-POLE ENTRY SWITCH","S2 = 2-WAY SUITES 101/108/109/116","GREEN EM = EMERG + BATTERY 90MIN","RED EXIT = EXIT LED ENDS/STAIRS","SQUARE SD = SMOKE ADDRESSABLE","M = MCP MANUAL CALL STAIRS","GOLD DASH = SWITCH-LEG ORTHO","GREEN DASH = EM CIRCUIT EM-1","BLUE DASH = FA LOOP TO FACP","TAG L101 12W / V101 6W","NEC 700.12 EM 90MIN BATT","NEC EM CKT MAX 12A CONT")
for($ii=0;$ii -lt $legList.Count;$ii++){
  $g.DrawString($legList[$ii],$fontSub,$brushTxt,$lx,($ly+$ii*22))
}
$nx=(Get-PX -QX 42)+60
$ny=(Get-PY -QY 6.2)
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
$colList=@(90,460,700,960,1140)
$rowList=@()
$rowList+=,@("TAG","TYPE","W","CIRCUIT","LOCATION")
$rowList+=,@("L101-L108","CEILING LED 3000K","12W","C-L1 15A","NORTH BED 101-108")
$rowList+=,@("L109-L116","CEILING LED 3000K","12W","C-L2 15A","SOUTH BED 109-116")
$rowList+=,@("V101-V108","VANITY LED IP44","6W","C-L1 15A","NORTH BATH 101-108")
$rowList+=,@("V109-V116","VANITY LED IP44","6W","C-L2 15A","SOUTH BATH 109-116")
$rowList+=,@("S101-S116","SINGLE-POLE ENTRY","-","C-L1/C-L2","ENTRY 1.2M AFF")
$rowList+=,@("S2-101/108/109/116","2-WAY SUITE","-","C-L1/C-L2","BEDHEAD + ENTRY")
$rowList+=,@("EM1-EM4","EMERG + BATT 90MIN","3W","EM-1 10A","CORRIDOR 7M SPACE")
$rowList+=,@("EX-W/E/L/R","EXIT LED RED","2W","EM-1 10A","ENDS + STAIRS LOB/SRV")
$rowList+=,@("SD101-116+C1-C5","SMOKE ADDRESSABLE","0.5W","FA-LOOP 24V","PER ROOM + CORR 7M")
$rowList+=,@("MCP-W/E/L/R","MANUAL CALL POINT","-","FA-LOOP 24V","STAIRS + CORR ENDS")
$rowList+=,@("FACP","FA PANEL LOBBY","-","DEDICATED","LOBBY CORE")
$g.DrawString("LUMINAIRE SCHEDULE - E-102 LIGHTING",$fontRm,$brushTxt,$tx,($ty-22))
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
$g.DrawString("NOTES: Switch-leg gold dash orthogonal only - no diagonals. EM per NEC 700.12 battery 90min, EM ckt max 12A continuous. SD addressable per room + corridor 7m to FACP lobby. MCP at stairs/corridor ends. Vanity IP44 GFCI-adjacent. Suites 101/108/109/116 2-way S2 bedhead.",$fontSm,$brushGray,$tx,($ty+$rowList.Count*$rh+8))
$out=Join-Path (Get-Location) "hotel_E102_lighting.png"
$bmp.Save($out,[System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose()
$bmp.Dispose()
Write-Output ("saved "+$out)
