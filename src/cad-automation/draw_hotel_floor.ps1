Add-Type -AssemblyName System.Drawing
$S=62; $Wm=42.0; $Hm=18.0; $Ox=280; $Oy=180
$Wpx=[int]($Wm*$S); $Hpx=[int]($Hm*$S); $CW=3400; $CH=2900
$bmp=New-Object System.Drawing.Bitmap $CW,$CH
$g=[System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode=[System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g.TextRenderingHint=[System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
$g.Clear([System.Drawing.Color]::White)
function Get-PX{param([double]$X)return [int]($Ox+$X*$S)}
function Get-PY{param([double]$Y)return [int]($Oy+$Y*$S)}
function New-Rect2{param([double]$X,[double]$Y,[double]$W,[double]$H)return New-Object System.Drawing.Rectangle ((Get-PX -X $X)),((Get-PY -Y $Y)),([int]($W*$S)),([int]($H*$S))}
$black=[System.Drawing.Color]::Black
$wallExt=New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(45,45,45))
$wallInt=New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(90,90,90))
$penThin=New-Object System.Drawing.Pen $black,2
$penMed=New-Object System.Drawing.Pen $black,3
$penDoor=New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(0,140,0)),2
$penWin=New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(0,90,180)),2
$penFire=New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(0,160,60)),3
$penDim=New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(0,90,160)),1
$brushTxt=New-Object System.Drawing.SolidBrush $black
$brushGray=New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(70,70,70))
$brushLight=New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(100,100,100))
$fontTitle=New-Object System.Drawing.Font "Arial",20,([System.Drawing.FontStyle]::Bold)
$fontSub=New-Object System.Drawing.Font "Arial",11,([System.Drawing.FontStyle]::Regular)
$fontRoom=New-Object System.Drawing.Font "Arial",10,([System.Drawing.FontStyle]::Bold)
$fontRoomS=New-Object System.Drawing.Font "Arial",8,([System.Drawing.FontStyle]::Regular)
$fontCorr=New-Object System.Drawing.Font "Arial",9,([System.Drawing.FontStyle]::Bold)
$fontSched=New-Object System.Drawing.Font "Consolas",8,([System.Drawing.FontStyle]::Regular)
$fontSchedB=New-Object System.Drawing.Font "Consolas",8,([System.Drawing.FontStyle]::Bold)
function Add-WallE{param([double]$X,[double]$Y,[double]$W,[double]$H)$g.FillRectangle($wallExt,(Get-PX -X $X),(Get-PY -Y $Y),([int]($W*$S)),([int]($H*$S)))}
function Add-WallI{param([double]$X,[double]$Y,[double]$W,[double]$H)$g.FillRectangle($wallInt,(Get-PX -X $X),(Get-PY -Y $Y),([int]($W*$S)),([int]($H*$S)))}
# room fills
$bedC=[System.Drawing.Color]::FromArgb(235,242,255); $bathC=[System.Drawing.Color]::FromArgb(220,245,255); $corrC=[System.Drawing.Color]::FromArgb(245,245,245); $lobbyC=[System.Drawing.Color]::FromArgb(255,248,230); $servC=[System.Drawing.Color]::FromArgb(240,240,240)
# corridor
$g.FillRectangle((New-Object System.Drawing.SolidBrush $corrC),(New-Rect2 -X 6 -Y 8 -W 30 -H 2.0))
# lobby west + service east fills
$g.FillRectangle((New-Object System.Drawing.SolidBrush $lobbyC),(New-Rect2 -X 0.3 -Y 0.3 -W 5.7 -H 17.4))
$g.FillRectangle((New-Object System.Drawing.SolidBrush $servC),(New-Rect2 -X 36 -Y 0.3 -W 5.7 -H 17.4))
# guest rooms fills north (y 0.3-8) and south (y 10-17.7)
for($i=0;$i -lt 8;$i++){ $x=6+$i*3.75
  $fc=$bedC; if($i -eq 0){ $fc=[System.Drawing.Color]::FromArgb(255,244,220) }; if($i -eq 7){ $fc=[System.Drawing.Color]::FromArgb(240,235,255) }
  $g.FillRectangle((New-Object System.Drawing.SolidBrush $fc),(New-Rect2 -X $x -Y 0.3 -W 3.75 -H 7.7))
  $g.FillRectangle((New-Object System.Drawing.SolidBrush $fc),(New-Rect2 -X $x -Y 10 -W 3.75 -H 7.7))
  $g.FillRectangle((New-Object System.Drawing.SolidBrush $bathC),(New-Rect2 -X ([double]$x+1.85) -Y 6.0 -W 1.8 -H 1.9))
  $g.FillRectangle((New-Object System.Drawing.SolidBrush $bathC),(New-Rect2 -X ([double]$x+1.85) -Y 10.1 -W 1.8 -H 1.9))
}
# PRO grids A-K vertical (0,6,9.75...42) + bubbles
$penGrid=New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(0,120,200)),1
$fontGrid=New-Object System.Drawing.Font "Arial",9,([System.Drawing.FontStyle]::Bold)
$grA=@(0,6,9.75,13.5,17.25,21,24.75,28.5,32.25,36,42); $grN=@("A","B","C","D","E","F","G","H","I","J","K")
for($gi=0;$gi -lt $grA.Count;$gi++){ $gx=$grA[$gi]; $g.DrawLine($penGrid,(Get-PX -X $gx),(Get-PY -Y -1.4),(Get-PX -X $gx),(Get-PY -Y 18.8)); $g.DrawEllipse($penGrid,(Get-PX -X $gx)-14,(Get-PY -Y -1.9),28,28); $g.DrawString($grN[$gi],$fontGrid,$brushTxt,(Get-PX -X $gx)-8,(Get-PY -Y -1.88)) }
# exterior 0.3m
Add-WallE -X 0 -Y 0 -W 42 -H 0.3; Add-WallE -X 0 -Y 17.7 -W 42 -H 0.3; Add-WallE -X 0 -Y 0 -W 0.3 -H 18; Add-WallE -X 41.7 -Y 0 -W 0.3 -H 18
$g.DrawRectangle($penMed,(Get-PX -X 0),(Get-PY -Y 0),$Wpx,$Hpx)
# corridor walls 0.2m
Add-WallE -X 6 -Y 7.8 -W 30 -H 0.2; Add-WallE -X 6 -Y 10 -W 30 -H 0.2
# partitions 0.15m north/south + core walls
for($i=0;$i -le 8;$i++){ $x=6+$i*3.75; Add-WallI -X ([double]$x-0.075) -Y 0.3 -W 0.15 -H 7.7; Add-WallI -X ([double]$x-0.075) -Y 10 -W 0.15 -H 7.7 }
Add-WallE -X 6 -Y 0.3 -W 0.2 -H 17.4; Add-WallE -X 35.8 -Y 0.3 -W 0.2 -H 17.4
# bathroom partitions
for($i=0;$i -lt 8;$i++){ $x=6+$i*3.75; Add-WallI -X ([double]$x+1.85) -Y 6.0 -W 0.1 -H 1.9; Add-WallI -X ([double]$x+1.85) -Y 10.1 -W 0.1 -H 1.9 }
# lobby core: elevators stairs
Add-WallI -X 0.5 -Y 5 -W 5.0 -H 0.15; Add-WallI -X 0.5 -Y 12 -W 5.0 -H 0.15
Add-WallI -X 2.5 -Y 5 -W 0.15 -H 7; Add-WallI -X 0.5 -Y 8 -W 2.0 -H 0.15
# service core walls
Add-WallI -X 36.2 -Y 5 -W 5.5 -H 0.15; Add-WallI -X 36.2 -Y 12 -W 5.5 -H 0.15; Add-WallI -X 38.8 -Y 5 -W 0.15 -H 7
# windows north/south per room 2.2m centered
for($i=0;$i -lt 8;$i++){ $x=6+$i*3.75+0.77
  $g.FillRectangle([System.Drawing.Brushes]::White,(Get-PX -X $x),(Get-PY -Y (0-0.02)),([int](2.2*$S)),([int](0.34*$S)))
  $g.DrawRectangle($penWin,(Get-PX -X $x),(Get-PY -Y 0.03),([int](2.2*$S)),([int](0.24*$S)))
  $g.FillRectangle([System.Drawing.Brushes]::White,(Get-PX -X $x),(Get-PY -Y (17.68)),([int](2.2*$S)),([int](0.34*$S)))
  $g.DrawRectangle($penWin,(Get-PX -X $x),(Get-PY -Y 17.73),([int](2.2*$S)),([int](0.24*$S)))
}
# doors helpers
function DoorGapH{param([double]$X,[double]$Y,[double]$W)$g.FillRectangle([System.Drawing.Brushes]::White,(Get-PX -X $X),(Get-PY -Y ([double]$Y-0.03)),([int]($W*$S)),([int](0.26*$S)))}
function DoorLeaf{param([double]$X1,[double]$Y1,[double]$X2,[double]$Y2)$g.DrawLine($penDoor,(Get-PX -X $X1),(Get-PY -Y $Y1),(Get-PX -X $X2),(Get-PY -Y $Y2))}
function DoorArc{param([double]$HX,[double]$HY,[double]$RR,[double]$A1,[double]$A2)$rpx=[int]($RR*$S); $g.DrawArc($penDoor,(Get-PX -X $HX)-$rpx,(Get-PY -Y $HY)-$rpx,$rpx*2,$rpx*2,$A1,(($A2-$A1)))}
# room entry doors 0.9 corridor side + bath doors 0.7
for($i=0;$i -lt 8;$i++){ $x=6+$i*3.75+0.4
  DoorGapH -X $x -Y 7.8 -W 0.9; DoorLeaf -X1 $x -Y1 7.8 -X2 ([double]$x+0.9) -Y2 7.0; DoorArc -HX $x -HY 7.8 -RR 0.9 -A1 270 -A2 360
  DoorGapH -X $x -Y 10 -W 0.9; DoorLeaf -X1 $x -Y1 10.2 -X2 ([double]$x+0.9) -Y2 11.0; DoorArc -HX $x -HY 10.2 -RR 0.9 -A1 0 -A2 90
  DoorGapH -X ([double]$x+1.9) -Y 6.9 -W 0.7; DoorLeaf -X1 ([double]$x+1.9) -Y1 6.9 -X2 ([double]$x+1.9) -Y2 6.2; DoorArc -HX ([double]$x+1.9) -HY 6.9 -RR 0.7 -A1 270 -A2 360
  DoorGapH -X ([double]$x+1.9) -Y 11.1 -W 0.7; DoorLeaf -X1 ([double]$x+1.9) -Y1 11.1 -X2 ([double]$x+1.9) -Y2 11.8; DoorArc -HX ([double]$x+1.9) -HY 11.1 -RR 0.7 -A1 0 -A2 90
}
# furniture: bed 1.8x2.0 north near window, desk, wardrobe, bath fixtures
$penF=New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(110,110,110)),1
function FixR{param([double]$X,[double]$Y,[double]$W,[double]$H)$rr=New-Rect2 -X $X -Y $Y -W $W -H $H; $g.FillRectangle([System.Drawing.Brushes]::White,$rr); $g.DrawRectangle($penF,$rr.X,$rr.Y,$rr.Width,$rr.Height)}
for($i=0;$i -lt 8;$i++){ $x=6+$i*3.75
  $isTwin=(($i%3)-eq 2)
  if($isTwin){ FixR -X ([double]$x+0.4) -Y 1.0 -W 1.0 -H 2.0; FixR -X ([double]$x+1.6) -Y 1.0 -W 1.0 -H 2.0 } else { FixR -X ([double]$x+0.5) -Y 1.0 -W 1.8 -H 2.1 }
  FixR -X ([double]$x+0.4) -Y 3.5 -W 1.2 -H 0.6; FixR -X ([double]$x+2.7) -Y 1.0 -W 0.6 -H 1.5
  FixR -X ([double]$x+2.0) -Y 6.2 -W 0.6 -H 0.5; FixR -X ([double]$x+2.8) -Y 6.2 -W 0.7 -H 1.4
  if($isTwin){ FixR -X ([double]$x+0.4) -Y 14.6 -W 1.0 -H 2.0; FixR -X ([double]$x+1.6) -Y 14.6 -W 1.0 -H 2.0 } else { FixR -X ([double]$x+0.5) -Y 14.7 -W 1.8 -H 2.1 }
  FixR -X ([double]$x+0.4) -Y 13.9 -W 1.2 -H 0.6; FixR -X ([double]$x+2.7) -Y 15.2 -W 0.6 -H 1.5
  FixR -X ([double]$x+2.0) -Y 11.4 -W 0.6 -H 0.5; FixR -X ([double]$x+2.8) -Y 10.4 -W 0.7 -H 1.4
}
# lobby furniture: reception desk, elevators, stairs steps
FixR -X 0.6 -Y 1.0 -W 2.0 -H 0.8; FixR -X 0.6 -Y 13.0 -W 2.0 -H 0.8
FixR -X 0.7 -Y 5.5 -W 1.5 -H 2.0; FixR -X 2.9 -Y 5.5 -W 1.5 -H 2.0
FixR -X 0.7 -Y 10.5 -W 3.7 -H 1.2
for($ss=0;$ss -lt 10;$ss++){ $g.DrawLine($penThin,(Get-PX -X 0.7),(Get-PY -Y (12.3+($ss*0.28))),(Get-PX -X 4.6),(Get-PY -Y (12.3+($ss*0.28)))) }
FixR -X 37.0 -Y 1.0 -W 1.4 -H 2.0; FixR -X 39.5 -Y 1.0 -W 1.6 -H 1.2; FixR -X 37.0 -Y 13.5 -W 1.5 -H 1.5
for($ss2=0;$ss2 -lt 8;$ss2++){ $g.DrawLine($penThin,(Get-PX -X 37.0),(Get-PY -Y (5.5+($ss2*0.28))),(Get-PX -X 38.6),(Get-PY -Y (5.5+($ss2*0.28)))) }
$S=62
# labels room numbers centered near corridor (avoid bed) - ACC 101/109, SUITE 108/116
for($i=0;$i -lt 8;$i++){ $x=6+$i*3.75; $nN=101+$i; $nS=109+$i; $type="KING"; if(($i%3)-eq 2){ $type="TWIN" }; if($i -eq 0){ $type="ACC KING 950" }; if($i -eq 7){ $type="SUITE LIV+SLEEP" }
  $cx=(Get-PX -X $x)+([int](3.75*$S/2)); $cyN=(Get-PY -Y 4.6); $cyS=(Get-PY -Y 13.0)
  $sf=New-Object System.Drawing.StringFormat; $sf.Alignment=[System.Drawing.StringAlignment]::Center
  $g.DrawString("$nN $type",$fontRoom,$brushTxt,$cx,($cyN-10),$sf); $g.DrawString("3.75x7.7 22m2",$fontRoomS,$brushGray,$cx,($cyN+10),$sf)
  $g.DrawString("$nS $type",$fontRoom,$brushTxt,$cx,($cyS-10),$sf); $g.DrawString("3.75x7.7 22m2",$fontRoomS,$brushGray,$cx,($cyS+10),$sf)
}
$g.DrawString("CORRIDOR 2.0m",$fontCorr,$brushGray,(Get-PX -X 19),(Get-PY -Y 8.55))
$g.DrawString("LOBBY",$fontCorr,$brushGray,(Get-PX -X 1.8),(Get-PY -Y 8.35))
$g.DrawString("LIFT",$fontRoomS,$brushGray,(Get-PX -X 1.0),(Get-PY -Y 6.2)); $g.DrawString("LIFT",$fontRoomS,$brushGray,(Get-PX -X 3.2),(Get-PY -Y 6.2))
$g.DrawString("STAIR A",$fontRoomS,$brushGray,(Get-PX -X 1.8),(Get-PY -Y 15.9))
$g.DrawString("SERVICE / LINEN",$fontRoomS,$brushGray,(Get-PX -X 38.2),(Get-PY -Y 8.35))
$g.DrawString("STAIR B FIRE",$fontRoomS,$brushGray,(Get-PX -X 37.2),(Get-PY -Y 7.9))
# fire arrows
for($i=0;$i -lt 4;$i++){ $ax=12+$i*7; $g.DrawLine($penFire,(Get-PX -X $ax),(Get-PY -Y 9),(Get-PX -X ([double]$ax-2)),(Get-PY -Y 9)); $g.DrawLine($penFire,(Get-PX -X ([double]$ax-2)),(Get-PY -Y 9),(Get-PX -X ([double]$ax-1.6)),(Get-PY -Y 8.8)); $g.DrawLine($penFire,(Get-PX -X ([double]$ax-2)),(Get-PY -Y 9),(Get-PX -X ([double]$ax-1.6)),(Get-PY -Y 9.2)) }
$g.DrawLine($penFire,(Get-PX -X 8),(Get-PY -Y 9),(Get-PX -X 3),(Get-PY -Y 9))
$g.DrawLine($penFire,(Get-PX -X 34),(Get-PY -Y 9),(Get-PX -X 39),(Get-PY -Y 9))
# title dims grid PRO
$g.DrawString("H-201 PRO - HOTEL FLOOR 42x18 - 16 ROOMS FULL DETAIL + GRIDS A-K - ACC/SUITE - 1:100",$fontTitle,$brushTxt,($Ox-20),12)
$g.DrawString("Ext300 Int150/200 Doors 900/950acc Bath ensuite. ACC 101/109 grab + 950. SUITE 108/116 liv+sleep. Grids A-K. BOH linen. Fire A+B.",$fontSub,$brushGray,($Ox-10),46)
function DimHH{param([double]$Yoff,[double]$X1,[double]$X2,[string]$T)$yy=(Get-PY -Y 0)-$Yoff; $g.DrawLine($penDim,(Get-PX -X $X1),$yy,(Get-PX -X $X2),$yy); $sf=New-Object System.Drawing.StringFormat; $sf.Alignment=[System.Drawing.StringAlignment]::Center; $g.DrawString($T,$fontRoomS,$brushGray,(((Get-PX -X $X1)+(Get-PX -X $X2))/2),($yy-16),$sf)}
DimHH -Yoff 90 -X1 0 -X2 42 -T "42.00 OVERALL"
DimHH -Yoff 55 -X1 0 -X2 6 -T "6.0 CORE"; DimHH -Yoff 55 -X1 6 -X2 36 -T "30.0 8x3.75"; DimHH -Yoff 55 -X1 36 -X2 42 -T "6.0 CORE"
$nx=(Get-PX -X 42)+40; $ny=(Get-PY -Y 0); $g.DrawEllipse($penMed,$nx,$ny,60,60); $fN=New-Object System.Drawing.Font "Arial",20,([System.Drawing.FontStyle]::Bold); $g.DrawString("N",$fN,$brushTxt,($nx+16),($ny+10))
# schedule bottom
$sx=100; $sy=(Get-PY -Y 18)+80; $sw=$CW-200; $cols=@(80,260,460,640,880,1120)
$rows=@()
$rows+=,@("RM","TYPE / SIZE","BED BATH","OCC","AREA","DOOR WIN","NOTES")
for($i=0;$i -lt 8;$i++){ $nN=101+$i; $t="KING 1800"; $nt="N ensuite 1.8x1.9"; $dw="900 2200"; if(($i%3)-eq 2){ $t="TWIN 2x900" }; if($i -eq 0){ $t="ACC KING 1800"; $dw="950 2200"; $nt="N ACC grab + 950" }; if($i -eq 7){ $t="SUITE KING"; $nt="N suite liv+sleep" }; $rows+=,@("$nN","3.75x7.7 N","$t SHR","2","22.0",$dw,$nt) }
for($i=0;$i -lt 8;$i++){ $nS=109+$i; $t="KING 1800"; $nt="S ensuite 1.8x1.9"; $dw="900 2200"; if(($i%3)-eq 2){ $t="TWIN 2x900" }; if($i -eq 0){ $t="ACC KING 1800"; $dw="950 2200"; $nt="S ACC grab + 950" }; if($i -eq 7){ $t="SUITE KING"; $nt="S suite liv+sleep" }; $rows+=,@("$nS","3.75x7.7 S","$t SHR","2","22.0",$dw,$nt) }
$rows+=,@("LBY","LOBBY 5.7x17.4","-","-","99.0","-","reception lifts stair A")
$rows+=,@("SRV","SERVICE 5.7x17.4","-","-","99.0","-","linen stair B fire")
$rh2=24; $g.FillRectangle($wallExt,$sx,$sy,$sw,$rh2)
for($r=0;$r -lt $rows.Count;$r++){ $yy=$sy+$r*$rh2; if($r -gt 0){ $g.DrawRectangle($penThin,$sx,$yy,$sw,$rh2) }
  for($c=0;$c -lt 7;$c++){ $xx=$sx; if($c -gt 0){ $xx=$sx+$cols[$c-1] }; $ww=$cols[0]; if($c -gt 0 -and $c -lt 6){ $ww=$cols[$c]-$cols[$c-1] } elseif($c -eq 0){ $ww=$cols[0] }; if($c -eq 6){ $ww=$sw-$cols[5] }
    if($c -gt 0){ $g.DrawLine($penThin,$xx,$yy,$xx,($yy+$rh2)) }
    $f=$fontSched; $br=$brushTxt; if($r -eq 0){ $f=$fontSchedB; $br=[System.Drawing.Brushes]::White }
    $g.DrawString($rows[$r][$c],$f,$br,($xx+4),($yy+6))
  }
}
$out=Join-Path (Get-Location) "hotel_floor.png"
$bmp.Save($out,[System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $bmp.Dispose()
Write-Output "saved $out"
