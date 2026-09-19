Add-Type -AssemblyName System.Drawing
$Scale=58; $OXx=260; $OYy=170; $Wm=42.0; $Hm=18.0
$Wpx=[int]($Wm*$Scale); $Hpx=[int]($Hm*$Scale); $CW=3400; $CH=3400
$bmp=New-Object System.Drawing.Bitmap $CW,$CH
$g=[System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode=[System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g.TextRenderingHint=[System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
$g.Clear([System.Drawing.Color]::White)
function Get-PX{param([double]$QX)return [int]($OXx+$QX*$Scale)}
function Get-PY{param([double]$QY)return [int]($OYy+$QY*$Scale)}
function New-Rect2{param([double]$QX,[double]$QY,[double]$QW,[double]$QH)return New-Object System.Drawing.Rectangle ((Get-PX -QX $QX)),((Get-PY -QY $QY)),([int]($QW*$Scale)),([int]($QH*$Scale))}
$black=[System.Drawing.Color]::Black
$wallExt=New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(50,50,50))
$wallInt=New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(95,95,95))
$penThin=New-Object System.Drawing.Pen $black,2
$penMed=New-Object System.Drawing.Pen $black,3
$penDoor=New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(0,140,0)),1
$penWin=New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(0,90,180)),1
$brushTxt=New-Object System.Drawing.SolidBrush $black
$brushGray=New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(75,75,75))
$fontTitle=New-Object System.Drawing.Font "Arial",19,([System.Drawing.FontStyle]::Bold)
$fontSub=New-Object System.Drawing.Font "Arial",10,([System.Drawing.FontStyle]::Regular)
$fontRm=New-Object System.Drawing.Font "Arial",8,([System.Drawing.FontStyle]::Bold)
$fontSm=New-Object System.Drawing.Font "Arial",7,([System.Drawing.FontStyle]::Regular)
$fontTag=New-Object System.Drawing.Font "Arial",7,([System.Drawing.FontStyle]::Bold)
$fontSch=New-Object System.Drawing.Font "Consolas",8,([System.Drawing.FontStyle]::Regular)
$fontSchB=New-Object System.Drawing.Font "Consolas",8,([System.Drawing.FontStyle]::Bold)
$bedC=[System.Drawing.Color]::FromArgb(238,244,255); $bathC=[System.Drawing.Color]::FromArgb(225,246,255); $corrC=[System.Drawing.Color]::FromArgb(247,247,247); $lobC=[System.Drawing.Color]::FromArgb(255,249,232); $srvC=[System.Drawing.Color]::FromArgb(242,242,242)
$g.FillRectangle((New-Object System.Drawing.SolidBrush $corrC),(New-Rect2 -QX 6 -QY 8 -QW 30 -QH 2.0))
$g.FillRectangle((New-Object System.Drawing.SolidBrush $lobC),(New-Rect2 -QX 0.3 -QY 0.3 -QW 5.7 -QH 17.4))
$g.FillRectangle((New-Object System.Drawing.SolidBrush $srvC),(New-Rect2 -QX 36 -QY 0.3 -QW 5.7 -QH 17.4))
for($ii=0;$ii -lt 8;$ii++){ $qx=6+$ii*3.75
  $g.FillRectangle((New-Object System.Drawing.SolidBrush $bedC),(New-Rect2 -QX $qx -QY 0.3 -QW 3.75 -QH 7.7))
  $g.FillRectangle((New-Object System.Drawing.SolidBrush $bedC),(New-Rect2 -QX $qx -QY 10 -QW 3.75 -QH 7.7))
  $g.FillRectangle((New-Object System.Drawing.SolidBrush $bathC),(New-Rect2 -QX ([double]$qx+1.85) -QY 6.0 -QW 1.8 -QH 1.9))
  $g.FillRectangle((New-Object System.Drawing.SolidBrush $bathC),(New-Rect2 -QX ([double]$qx+1.85) -QY 10.1 -QW 1.8 -QH 1.9))
}
function Add-WE{param([double]$QX,[double]$QY,[double]$QW,[double]$QH)$g.FillRectangle($wallExt,(Get-PX -QX $QX),(Get-PY -QY $QY),([int]($QW*$Scale)),([int]($QH*$Scale)))}
function Add-WI{param([double]$QX,[double]$QY,[double]$QW,[double]$QH)$g.FillRectangle($wallInt,(Get-PX -QX $QX),(Get-PY -QY $QY),([int]($QW*$Scale)),([int]($QH*$Scale)))}
Add-WE -QX 0 -QY 0 -QW 42 -QH 0.3; Add-WE -QX 0 -QY 17.7 -QW 42 -QH 0.3; Add-WE -QX 0 -QY 0 -QW 0.3 -QH 18; Add-WE -QX 41.7 -QY 0 -QW 0.3 -QH 18
$g.DrawRectangle($penMed,(Get-PX -QX 0),(Get-PY -QY 0),$Wpx,$Hpx)
Add-WE -QX 6 -QY 7.8 -QW 30 -QH 0.2; Add-WE -QX 6 -QY 10 -QW 30 -QH 0.2
for($ii=0;$ii -le 8;$ii++){ $qx=6+$ii*3.75; Add-WI -QX ([double]$qx-0.075) -QY 0.3 -QW 0.15 -QH 7.7; Add-WI -QX ([double]$qx-0.075) -QY 10 -QW 0.15 -QH 7.7 }
Add-WE -QX 6 -QY 0.3 -QW 0.2 -QH 17.4; Add-WE -QX 35.8 -QY 0.3 -QW 0.2 -QH 17.4
$g.DrawString("E+U HOTEL FLOOR 42x18 - POWER LIGHT FIRE DATA + WATER HVAC DRAIN - E201",$fontTitle,$brushTxt,($OXx-20),10)
$g.DrawString("MDB-F1 160A service E. DB-LOB DB-N DB-S DB-SRV. Key-card KS each room. FCU + BH + CHGx2/room. CW/HW spine corridor. 230/400V TN-S.",$fontSub,$brushGray,($OXx-10),42)
function DashP($cc,$ww){ $pp=New-Object System.Drawing.Pen $cc,$ww; $pp.DashStyle=[System.Drawing.Drawing2D.DashStyle]::Dash; return $pp }
function SolP($cc,$ww){ return New-Object System.Drawing.Pen $cc,$ww }
$penEL=DashP ([System.Drawing.Color]::FromArgb(190,140,0)) 1
$penPW=DashP ([System.Drawing.Color]::FromArgb(190,30,30)) 1
$penCW=SolP ([System.Drawing.Color]::FromArgb(0,90,220)) 3
$penHW=SolP ([System.Drawing.Color]::FromArgb(220,40,40)) 3
$penDR=DashP ([System.Drawing.Color]::FromArgb(120,70,20)) 2
$penHV=SolP ([System.Drawing.Color]::FromArgb(0,150,80)) 2
$penFA=SolP ([System.Drawing.Color]::FromArgb(200,0,0)) 1
function Ortho2($pp,$pts){ for($kk=0;$kk -lt ($pts.Count-1);$kk++){ $g.DrawLine($pp,(Get-PX -QX $pts[$kk][0]),(Get-PY -QY $pts[$kk][1]),(Get-PX -QX $pts[$kk+1][0]),(Get-PY -QY $pts[$kk+1][1])) } }
function TagU($qx,$qy,$tt,$bg){ $px=(Get-PX -QX $qx); $py=(Get-PY -QY $qy); $bb=New-Object System.Drawing.SolidBrush $bg; $g.FillEllipse($bb,$px-24,$py-10,48,18); $g.DrawEllipse($penThin,$px-24,$py-10,48,18); $sff=New-Object System.Drawing.StringFormat; $sff.Alignment=[System.Drawing.StringAlignment]::Center; $g.DrawString($tt,$fontTag,$brushTxt,$px,$py-8,$sff); $bb.Dispose() }
function SymL($qx,$qy,$tt){ $px=(Get-PX -QX $qx); $py=(Get-PY -QY $qy); $g.DrawEllipse($penThin,$px-10,$py-10,20,20); $g.DrawLine($penThin,$px-7,$py-7,$px+7,$py+7); $g.DrawLine($penThin,$px-7,$py+7,$px+7,$py-7); TagU -qx $qx -qy ([double]$qy+0.42) -tt $tt -bg ([System.Drawing.Color]::FromArgb(255,236,150)) }
function SymK($qx,$qy){ $px=(Get-PX -QX $qx); $py=(Get-PY -QY $qy); $g.FillRectangle([System.Drawing.Brushes]::White,$px-7,$py-9,14,18); $g.DrawRectangle($penThin,$px-7,$py-9,14,18); $g.DrawString("KS",$fontTag,$brushTxt,$px-8,$py-8) }
function SymF($qx,$qy,$tt){ $px=(Get-PX -QX $qx); $py=(Get-PY -QY $qy); $g.FillRectangle([System.Drawing.Brushes]::White,$px-12,$py-8,40,16); $g.DrawRectangle($penThin,$px-12,$py-8,40,16); $g.DrawString($tt,$fontSm,$brushTxt,$px-10,$py-7) }
function SymW($qx,$qy,$tt){ $px=(Get-PX -QX $qx); $py=(Get-PY -QY $qy); $bq=New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(205,235,255)); $g.FillEllipse($bq,$px-9,$py-9,18,18); $g.DrawEllipse($penThin,$px-9,$py-9,18,18); $bq.Dispose(); TagU -qx $qx -qy ([double]$qy+0.4) -tt $tt -bg ([System.Drawing.Color]::FromArgb(185,215,255)) }
# MDB + DBs
$mdbR=New-Rect2 -QX 36.4 -QY 8.3 -QW 1.4 -QH 0.7; $g.FillRectangle([System.Drawing.Brushes]::White,$mdbR); $g.DrawRectangle($penMed,$mdbR.X,$mdbR.Y,$mdbR.Width,$mdbR.Height); $g.DrawString("MDB-F1 160A",$fontRm,$brushTxt,(Get-PX -QX 36.5),(Get-PY -QY 8.4))
$dbLR=New-Rect2 -QX 0.6 -QY 8.3 -QW 1.2 -QH 0.7; $g.FillRectangle([System.Drawing.Brushes]::White,$dbLR); $g.DrawRectangle($penMed,$dbLR.X,$dbLR.Y,$dbLR.Width,$dbLR.Height); $g.DrawString("DB-LOB",$fontSm,$brushTxt,(Get-PX -QX 0.65),(Get-PY -QY 8.45))
$g.DrawString("DB-N",(New-Object System.Drawing.Font "Arial",7,([System.Drawing.FontStyle]::Bold)),$brushTxt,(Get-PX -QX 19.6),(Get-PY -QY 7.55))
$g.DrawString("DB-S",(New-Object System.Drawing.Font "Arial",7,([System.Drawing.FontStyle]::Bold)),$brushTxt,(Get-PX -QX 19.6),(Get-PY -QY 10.25))
# per room symbols 101-116
for($ii=0;$ii -lt 8;$ii++){ $qx=6+$ii*3.75; $rnN=101+$ii; $rnS=109+$ii
  SymL ([double]$qx+1.8) 4.0 "L$rnN"; SymK ([double]$qx+0.35) 7.6; SymF ([double]$qx+0.6) 3.0 "CHGx2"; SymF ([double]$qx+2.6) 4.8 "FCU"; SymW ([double]$qx+2.7) 6.9 "BH"
  SymL ([double]$qx+1.8) 14.0 "L$rnS"; SymK ([double]$qx+0.35) 10.4; SymF ([double]$qx+0.6) 15.0 "CHGx2"; SymF ([double]$qx+2.6) 13.2 "FCU"; SymW ([double]$qx+2.7) 11.1 "BH"
  $cx=(Get-PX -QX $qx)+([int](3.75*$Scale/2)); $g.DrawString("$rnN / $rnS",$fontRm,$brushGray,$cx-28,(Get-PY -QY 8.65))
}
# corridor emergency + exit + smoke
for($ii=0;$ii -lt 5;$ii++){ $qx=9+$ii*6; SymL $qx 9.0 "EM"; $g.DrawString("EXIT",$fontSm,$brushGray,(Get-PX -QX 6.4),(Get-PY -QY 8.6)); $g.DrawString("EXIT",$fontSm,$brushGray,(Get-PX -QX 34.8),(Get-PY -QY 8.6)) }
# power homeruns orthogonal via spine
Ortho2 $penEL @(@(20,7.8),@(20,4.0),@(10,4.0))
Ortho2 $penEL @(@(20,10.2),@(20,14.0),@(30,14.0))
Ortho2 $penPW @(@(20,7.8),@(20,3.0),@(8,3.0))
Ortho2 $penPW @(@(36.8,8.6),@(20,8.6),@(20,7.8))
# water CW/HW spines + drops per 2 rooms
Ortho2 $penCW @(@(36.5,8.55),@(6,8.55))
Ortho2 $penHW @(@(36.5,8.75),@(6,8.75))
for($ii=0;$ii -lt 8;$ii++){ $qx=6+$ii*3.75+2.7; Ortho2 $penCW @(@($qx,8.55),@($qx,6.9)); Ortho2 $penHW @(@($qx,8.75),@($qx,6.9)); Ortho2 $penCW @(@($qx,9.45),@($qx,11.1)); Ortho2 $penHW @(@($qx,9.25),@($qx,11.1)) }
# drainage + HVAC
Ortho2 $penDR @(@(8,7.0),@(8,6.0),@(34,6.0),@(34,7.0))
Ortho2 $penHV @(@(6,9.0),@(36,9.0))
for($ii=0;$ii -lt 8;$ii++){ $qx=6+$ii*3.75+1.8; Ortho2 $penHV @(@($qx,9.0),@($qx,4.8)); Ortho2 $penHV @(@($qx,9.0),@($qx,13.2)) }
# legend
$lx=(Get-PX -QX 42)+20; $ly=(Get-PY -QY 1.0)
foreach($tt in @("LEGEND E+U","gold dash=light 10A","red dash=power 16A","blue thick=CW red=HW","brown dash=drain 110","green=HVAC fresh/FCU","KS=keycard FCU=fan","BH=bath heater CHG=USB","EM=emerg EXIT SD","MDB160 DB-LOB/N/S")){ $g.DrawString($tt,$fontSub,$brushTxt,$lx,$ly); $ly+=22 }
# single-line + schedules bottom
$slY=(Get-PY -QY 18)+70; $slX=(Get-PX -QX 0)
$g.DrawString("SINGLE-LINE: GRID 400V > MDB-F1 160A + SPD > DB-LOB 40A / DB-N 63A / DB-S 63A / DB-SRV 40A. Each room KS contactor + L6A/P16A/FCU16A/BH16A. PM sheds FCU>BH>CHG.",$fontRm,$brushTxt,$slX,$slY)
$slY+=24
$g.DrawRectangle($penThin,$slX,$slY,2900,150)
$g.DrawString("ELEC: 400/230V TN-S 50Hz. Rooms: light 8x12W LED 10A shared /4 rooms. Sockets 2x double+2x USB-C 65W 16A /2 rooms. FCU 800W 16A each. BH 1000W. Corridor EM 3h battery + EXIT LED + SD addressable + MCP stairs.",$fontSch,$brushTxt,($slX+8),($slY+8))
$g.DrawString("WATER: CW 32mm PPR spine 8.55 + HW 32mm 8.75 + circ. Drops 20mm to bath + WC + basin + shower mixer thermostatic. Stacks ST1 x=9 ST2 x=20 ST3 x=31 soil 110 vented. Pressure 3bar + booster + TMV 43C baths.",$fontSch,$brushTxt,($slX+8),($slY+32))
$g.DrawString("HVAC/DRAIN: FCU 4-pipe above entry corridor side + fresh 120m3/h/room + bath extract 60m3/h to roof. Drain 110 soil + 50 waste fall 2%. Condensate 25 to waste trapped. Fire: SD/room+corridor/7m MCP lobby/stairs sounder + strobe.",$fontSch,$brushTxt,($slX+8),($slY+56))
$g.DrawString("LOADS: 16x (0.1L+0.5P+0.8FCU+1.0BH)=38kW div 0.5=19kW + corridor 3 + lobby 8 + srv 6 =36kW div ~22kW. MDB 160A spare 30%. Meter per DB + key-card saver saves 40%.",$fontSch,$brushTxt,($slX+8),($slY+80))
$g.DrawString("HOOKS: L101>C N-01 CHG101-1/2>C N-P2 FCU101>C N-F3 BH101>C N-B4 KS101>contactor WM n/a hotel laundry central. CW101>CW-01 HW101>HW-01 DR101>ST1. Same S side 109-116.",$fontSch,$brushTxt,($slX+8),($slY+104))
$tx=80; $ty=$slY+190; $tw=$CW-160; $cols=@(90,300,520,700,920,1150)
$rows=@()
$rows+=,@("CCT","POINT HOOK","BRKR","CABLE PIPE","LOAD","NOTES")
$rows+=,@("LN-01..04","Lights 101-104 + EM corr","10B","3x1.5 20mm","0.4kW","L101-104 homerun DB-N")
$rows+=,@("LP-01..04","Power+CHG 101-104 KS","16C RCD","3x2.5 20mm+CAT6","2.0kW","KS contactor CHG 2x65W TV LAN")
$rows+=,@("LF-01..04","FCU 101-104","16C","3x2.5 20mm+cond25","3.2kW","800W ea isol above door")
$rows+=,@("LB-01..04","Bath heater 101-104","16C RCD","3x2.5 20mm","4.0kW","1000W IP44 pullcord")
$rows+=,@("CW/HW","Water 101-116 spine+drops","-","PPR32 spine 20 drop","-","CW8.55 HW8.75 TMV43 ST1-3")
$rows+=,@("HVAC","FCU+fresh+extract 101-116","-","duct400+flex+50waste","-","120m3 fresh 60 extract")
$rows+=,@("FA","SD+MCP+sounder+EXIT","-","2x1.0 FP + loop","-","SD/room corr/7m MCP stairs")
$rh2=26; $g.FillRectangle($wallExt,$tx,$ty,$tw,$rh2)
for($rr=0;$rr -lt $rows.Count;$rr++){ $yy=$ty+$rr*$rh2; if($rr -gt 0){ $g.DrawRectangle($penThin,$tx,$yy,$tw,$rh2) }
  for($cc=0;$cc -lt 6;$cc++){ $xx=$tx; if($cc -gt 0){ $xx=$tx+$cols[$cc-1] }; $ww=$cols[0]; if($cc -gt 0 -and $cc -lt 5){ $ww=$cols[$cc]-$cols[$cc-1] } elseif($cc -eq 0){ $ww=$cols[0] }; if($cc -eq 5){ $ww=$tw-$cols[4] }
    if($cc -gt 0){ $g.DrawLine($penThin,$xx,$yy,$xx,($yy+$rh2)) }
    $ff=$fontSch; $bb2=$brushTxt; if($rr -eq 0){ $ff=$fontSchB; $bb2=[System.Drawing.Brushes]::White }
    $g.DrawString($rows[$rr][$cc],$ff,$bb2,($xx+4),($yy+6))
  }
}
$out=Join-Path (Get-Location) "hotel_elec_utils.png"
$bmp.Save($out,[System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $bmp.Dispose()
Write-Output "saved $out"
