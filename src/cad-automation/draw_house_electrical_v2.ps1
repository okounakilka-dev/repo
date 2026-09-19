Add-Type -AssemblyName System.Drawing
$S=160; $Ox=300; $Oy=200; $Wm=12.0; $Hm=9.0
$Wpx=[int]($Wm*$S); $Hpx=[int]($Hm*$S); $CW=3200; $CH=3600
$bmp=New-Object System.Drawing.Bitmap $CW,$CH
$g=[System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode=[System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g.TextRenderingHint=[System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
$g.Clear([System.Drawing.Color]::White)
function Get-PX{param([double]$X)return [int]($Ox+$X*$S)}
function Get-PY{param([double]$Y)return [int]($Oy+$Y*$S)}
function New-Rect2{param([double]$X,[double]$Y,[double]$W,[double]$H)return New-Object System.Drawing.Rectangle ((Get-PX -X $X)),((Get-PY -Y $Y)),([int]($W*$S)),([int]($H*$S))}
$black=[System.Drawing.Color]::Black
$wallBrush=New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(55,55,55))
$penThin=New-Object System.Drawing.Pen $black,2
$penMed=New-Object System.Drawing.Pen $black,3
$brushTxt=New-Object System.Drawing.SolidBrush $black
$brushGray=New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(80,80,80))
$fontTitle=New-Object System.Drawing.Font "Arial",22,([System.Drawing.FontStyle]::Bold)
$fontSub=New-Object System.Drawing.Font "Arial",12,([System.Drawing.FontStyle]::Regular)
$fontRoom=New-Object System.Drawing.Font "Arial",11,([System.Drawing.FontStyle]::Bold)
$fontSym=New-Object System.Drawing.Font "Arial",10,([System.Drawing.FontStyle]::Bold)
$fontTag=New-Object System.Drawing.Font "Arial",8,([System.Drawing.FontStyle]::Bold)
$fontSched=New-Object System.Drawing.Font "Consolas",9,([System.Drawing.FontStyle]::Regular)
$fontSchedB=New-Object System.Drawing.Font "Consolas",9,([System.Drawing.FontStyle]::Bold)
$rx=@(0.2,6.4,6.4,8.8,0.2,5.0,6.4,9.5,9.5); $ry=@(0.2,0.2,2.4,0.2,4.3,0.2,4.3,4.3,6.4); $rw=@(4.6,2.2,2.2,3.0,4.6,1.2,2.9,2.3,2.3); $rh=@(3.9,2.0,1.7,3.9,3.8,8.6,3.8,1.9,1.7)
$rn=@("KITCHEN","BED3","BATH","BED2","LIVING","HALL","MASTER","ENSUITE","WIR")
$rc=@([System.Drawing.Color]::FromArgb(255,252,235),[System.Drawing.Color]::FromArgb(240,245,255),[System.Drawing.Color]::FromArgb(235,248,255),[System.Drawing.Color]::FromArgb(240,245,255),[System.Drawing.Color]::FromArgb(240,250,240),[System.Drawing.Color]::FromArgb(248,248,248),[System.Drawing.Color]::FromArgb(255,242,245),[System.Drawing.Color]::FromArgb(235,248,255),[System.Drawing.Color]::FromArgb(245,242,255))
for($i=0;$i -lt $rx.Count;$i++){ $bb=New-Object System.Drawing.SolidBrush $rc[$i]; $g.FillRectangle($bb,(New-Rect2 -X $rx[$i] -Y $ry[$i] -W $rw[$i] -H $rh[$i])); $bb.Dispose() }
function Add-Wall2{param([double]$X,[double]$Y,[double]$W,[double]$H)$g.FillRectangle($wallBrush,(Get-PX -X $X),(Get-PY -Y $Y),([int]($W*$S)),([int]($H*$S)))}
Add-Wall2 -X 0 -Y 0 -W 12.0 -H 0.2; Add-Wall2 -X 0 -Y 8.8 -W 12.0 -H 0.2; Add-Wall2 -X 0 -Y 0 -W 0.2 -H 9.0; Add-Wall2 -X 11.8 -Y 0 -W 0.2 -H 9.0
$g.DrawRectangle($penMed,(Get-PX -X 0),(Get-PY -Y 0),$Wpx,$Hpx)
Add-Wall2 -X 5.0 -Y 0.2 -W 0.1 -H 8.6; Add-Wall2 -X 6.2 -Y 0.2 -W 0.1 -H 8.6; Add-Wall2 -X 0.2 -Y 4.1 -W 4.8 -H 0.1; Add-Wall2 -X 6.3 -Y 4.1 -W 5.5 -H 0.1; Add-Wall2 -X 8.7 -Y 0.2 -W 0.1 -H 3.9; Add-Wall2 -X 6.4 -Y 2.2 -W 2.3 -H 0.1; Add-Wall2 -X 9.3 -Y 4.1 -W 0.1 -H 4.0; Add-Wall2 -X 9.5 -Y 6.2 -W 2.3 -H 0.1
foreach($k in 0..($rn.Count-1)){ $cx=(Get-PX -X $rx[$k])+([int]($rw[$k]*$S/2)); $cy=(Get-PY -Y $ry[$k])+8; $sf=New-Object System.Drawing.StringFormat; $sf.Alignment=[System.Drawing.StringAlignment]::Center; $g.DrawString($rn[$k],$fontRoom,$brushGray,$cx,$cy,$sf) }
$g.DrawString("E-102 ELECTRICAL DETAIL - 12x9m HOUSE - LIGHTING / POWER / CHARGERS / PM + SINGLE-LINE + CABLE SCHEDULE",$fontTitle,$brushTxt,($Ox-20),12)
$g.DrawString("230V 50Hz TN-S. Sockets 300mm, kitchen 1100mm, switches 1200mm, USB chargers 500/1200mm 65W, isolators 1200-1500mm. IP44 bath/ensuite. Conduit 20/25/32mm.",$fontSub,$brushGray,($Ox-10),48)
function SolidPen($c,$w){ return New-Object System.Drawing.Pen $c,$w }
function DashPen2($c,$w){ $p=New-Object System.Drawing.Pen $c,$w; $p.DashStyle=[System.Drawing.Drawing2D.DashStyle]::Dash; return $p }
$penL=DashPen2 ([System.Drawing.Color]::FromArgb(190,140,0)) 2
$penP=DashPen2 ([System.Drawing.Color]::FromArgb(190,30,30)) 2
$penK=SolidPen ([System.Drawing.Color]::FromArgb(220,110,0)) 2
$penD=SolidPen ([System.Drawing.Color]::FromArgb(0,60,180)) 3
$penC=SolidPen ([System.Drawing.Color]::FromArgb(0,140,60)) 2
$penSLD=SolidPen ([System.Drawing.Color]::Black) 2
function Ortho($pen,$pts){ for($i=0;$i -lt ($pts.Count-1);$i++){ $g.DrawLine($pen,(Get-PX -X $pts[$i][0]),(Get-PY -Y $pts[$i][1]),(Get-PX -X $pts[$i+1][0]),(Get-PY -Y $pts[$i+1][1])) } }
function Tag2($x,$y,$t,$bg){ $px=(Get-PX -X $x); $py=(Get-PY -Y $y); $b=New-Object System.Drawing.SolidBrush $bg; $g.FillEllipse($b,$px-26,$py-12,52,22); $g.DrawEllipse($penThin,$px-26,$py-12,52,22); $sf=New-Object System.Drawing.StringFormat; $sf.Alignment=[System.Drawing.StringAlignment]::Center; $sf.LineAlignment=[System.Drawing.StringAlignment]::Center; $g.DrawString($t,$fontTag,$brushTxt,$px,$py-9,$sf); $b.Dispose() }
function SymLight($x,$y,$tag){ $px=(Get-PX -X $x); $py=(Get-PY -Y $y); $g.DrawEllipse($penThin,$px-13,$py-13,26,26); $g.DrawLine($penThin,$px-9,$py-9,$px+9,$py+9); $g.DrawLine($penThin,$px-9,$py+9,$px+9,$py-9); Tag2 -x $x -y ([double]$y+0.35) -t $tag -bg ([System.Drawing.Color]::FromArgb(255,235,150)) }
function SymSock($x,$y,$tag){ $px=(Get-PX -X $x); $py=(Get-PY -Y $y); $g.FillRectangle([System.Drawing.Brushes]::White,$px-9,$py-9,18,18); $g.DrawRectangle($penThin,$px-9,$py-9,18,18); $g.DrawLine($penThin,$px-9,$py,$px+9,$py); Tag2 -x $x -y ([double]$y+0.34) -t $tag -bg ([System.Drawing.Color]::FromArgb(255,200,200)) }
function SymChg($x,$y,$tag){ $px=(Get-PX -X $x); $py=(Get-PY -Y $y); $b=New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(205,255,215)); $g.FillRectangle($b,$px-10,$py-10,20,20); $g.DrawRectangle($penThin,$px-10,$py-10,20,20); $g.DrawString("U",$fontTag,$brushTxt,$px-6,$py-9); $b.Dispose(); Tag2 -x $x -y ([double]$y+0.35) -t $tag -bg ([System.Drawing.Color]::FromArgb(180,240,190)) }
function SymDed($x,$y,$lbl,$tag){ $px=(Get-PX -X $x); $py=(Get-PY -Y $y); $g.FillRectangle([System.Drawing.Brushes]::White,$px-14,$py-11,48,22); $g.DrawRectangle($penMed,$px-14,$py-11,48,22); $g.DrawString($lbl,$fontSym,$brushTxt,$px-10,$py-8); Tag2 -x ([double]$x+0.20) -y ([double]$y+0.38) -t $tag -bg ([System.Drawing.Color]::FromArgb(185,212,255)) }
function SymSw($x,$y,$t){ $px=(Get-PX -X $x); $py=(Get-PY -Y $y); $g.DrawString("S$t",$fontSym,$brushTxt,$px-8,$py-10) }
function SymDet($x,$y,$t){ $px=(Get-PX -X $x); $py=(Get-PY -Y $y); $g.DrawEllipse($penThin,$px-10,$py-10,20,20); $g.DrawString("SD",$fontTag,$brushTxt,$px-9,$py-8); Tag2 -x $x -y ([double]$y+0.34) -t $t -bg ([System.Drawing.Color]::White) }
# DB + PM
$dbX=5.6; $dbY=8.3
$dbR=New-Rect2 -X 5.15 -Y 8.05 -W 1.0 -H 0.55; $g.FillRectangle([System.Drawing.Brushes]::White,$dbR); $g.DrawRectangle($penMed,$dbR.X,$dbR.Y,$dbR.Width,$dbR.Height)
$g.DrawString("DB 12W 40A",$fontSym,$brushTxt,(Get-PX -X 5.22),(Get-PY -Y 8.1)); $g.DrawString("SPD+2xRCD",$fontTag,$brushGray,(Get-PX -X 5.22),(Get-PY -Y 8.32))
$pmR=New-Rect2 -X 4.2 -Y 8.05 -W 0.8 -H 0.55; $g.FillRectangle([System.Drawing.Brushes]::White,$pmR); $g.DrawRectangle($penMed,$pmR.X,$pmR.Y,$pmR.Width,$pmR.Height)
$g.DrawString("PM-01",$fontSym,$brushTxt,(Get-PX -X 4.27),(Get-PY -Y 8.1)); $g.DrawString("MGR+6xUSB",$fontTag,$brushGray,(Get-PX -X 4.27),(Get-PY -Y 8.32))
# Lights + detectors + switches
SymLight 2.5 2.0 "C1-01"; SymLight 2.5 6.2 "C1-03"; SymLight 5.6 4.5 "C1-05"; SymSw 4.75 4.45 "1"; SymSw 5.15 7.8 "1"
SymLight 7.5 1.2 "C2-01"; SymLight 10.2 2.0 "C2-02"; SymLight 7.5 3.2 "C2-03"; SymLight 7.8 6.0 "C2-04"; SymLight 10.6 5.2 "C2-05"; SymSw 6.35 5.4 "2"
SymDet 5.6 2.2 "SD1"; SymDet 5.6 6.8 "SD2"; SymDet 10.0 4.0 "SD3"
# Sockets C3 C4
SymSock 0.4 5.0 "C3-01"; SymSock 0.4 7.5 "C3-02"; SymSock 2.8 8.5 "C3-03"; SymSock 5.15 5.2 "C3-04"
SymSock 6.7 0.45 "C4-01"; SymSock 9.2 0.45 "C4-02"; SymSock 11.55 2.8 "C4-03"; SymSock 6.7 7.8 "C4-04"; SymSock 10.2 7.8 "C4-05"
SymSock 1.2 0.55 "C5-01"; SymSock 2.6 0.55 "C5-02"; SymSock 4.0 0.55 "C5-03"; SymSock 0.5 1.8 "C5-FR"
# Dedicated with isolator heights
SymDed 2.2 1.0 "CK C6" "C6-01 32A"; SymDed 0.6 3.3 "WM C7" "C7-01 20A"; SymDed 1.6 3.3 "DW C8" "C8-01 20A"; SymDed 7.6 2.6 "WH C9" "C9-01 20A"; SymDed 3.2 8.4 "AC1" "C10-1"; SymDed 8.2 7.6 "AC2" "C10-2"; SymDed 4.6 8.55 "EV" "C12-01"
# Chargers USB 65W
SymChg 4.6 7.0 "C11-1"; SymChg 1.8 8.5 "C11-2"; SymChg 6.9 7.3 "C11-3"; SymChg 9.4 1.2 "C11-4"; SymChg 6.9 1.0 "C11-5"; SymChg 4.6 8.2 "C11-6"
# LAN/TV/outdoor/doorbell small
$g.DrawString("LAN",$fontTag,$brushGray,(Get-PX -X 0.35),(Get-PY -Y 6.8)); $g.DrawString("TV",$fontTag,$brushGray,(Get-PX -X 2.7),(Get-PY -Y 8.4)); $g.DrawString("DBELL",$fontTag,$brushGray,(Get-PX -X 5.9),(Get-PY -Y 8.75)); $g.DrawString("E1",$fontTag,$brushGray,(Get-PX -X 5.0),(Get-PY -Y 8.95)); $g.DrawString("E2",$fontTag,$brushGray,(Get-PX -X 9.0),(Get-PY -Y 8.95))
# Clean orthogonal homeruns via hallway spine x=5.6
Ortho $penL @(@($dbX,$dbY),@($dbX,6.2),@(2.5,6.2))
Ortho $penL @(@($dbX,$dbY),@($dbX,2.0),@(2.5,2.0))
Ortho $penL @(@($dbX,$dbY),@($dbX,3.2),@(7.5,3.2),@(7.5,1.2))
Ortho $penL @(@($dbX,$dbY),@($dbX,6.0),@(7.8,6.0))
Ortho $penP @(@($dbX,$dbY),@($dbX,5.2),@(0.4,5.2))
Ortho $penP @(@($dbX,$dbY),@($dbX,7.8),@(6.7,7.8))
Ortho $penK @(@($dbX,$dbY),@($dbX,0.55),@(1.2,0.55))
Ortho $penD @(@($dbX,$dbY),@($dbX,1.0),@(2.2,1.0))
Ortho $penD @(@($dbX,$dbY),@($dbX,3.3),@(0.6,3.3))
Ortho $penD @(@($dbX,$dbY),@($dbX,2.6),@(7.6,2.6))
Ortho $penC @(@($dbX,$dbY),@($dbX,7.0),@(4.6,7.0))
Ortho $penC @(@($dbX,$dbY),@($dbX,8.2),@(4.6,8.2))
# Legend
$lx=(Get-PX -X 12)+25; $ly=(Get-PY -Y 1.2)
$g.DrawString("LEGEND / HEIGHTS",$fontSym,$brushTxt,$lx,$ly); $ly+=26
foreach($t in @("X-circle=light C1/C2 10A 1.5","square=socket C3-C5 20A 2.5","U=USB charger C11 16A","CK/WM/DW/WH/AC/EV=dedicated","S=switch 1200 SD=smoke","DB 40A SPD RCD PM-01 mgr","dash=gold/red/blue/green","heights:300/1100/1200/1500")){
  $g.DrawString($t,$fontSub,$brushTxt,$lx,$ly); $ly+=22
}
# SINGLE-LINE DIAGRAM
$sldY=(Get-PY -Y 9)+90; $sldX=(Get-PX -X 0)
$g.DrawString("SINGLE-LINE DB 40A 230V - GRID > MAIN > SPD > 2xRCD > C1-C12 - PM-01 sheds EV>AC>WH",$fontSym,$brushTxt,$sldX,$sldY)
$sldY+=30
$g.DrawRectangle($penSLD,$sldX,$sldY,2200,190)
$g.DrawString("GRID 230V",$fontSchedB,$brushTxt,($sldX+10),($sldY+10))
$g.DrawString("40A MAIN",$fontSchedB,$brushTxt,($sldX+180),($sldY+10))
$g.DrawString("SPD T2",$fontSchedB,$brushTxt,($sldX+360),($sldY+10))
$g.DrawString("RCD1 40A 30mA : C1 C3 C5 C6 C7 C11",$fontSched,$brushTxt,($sldX+520),($sldY+10))
$g.DrawString("RCD2 40A 30mA : C2 C4 C8 C9 C10 C12",$fontSched,$brushTxt,($sldX+520),($sldY+32))
$g.DrawString("C1 10B 1.5  C3 20C 2.5  C5 20C 2.5  C6 32C 6.0  C7 20C 2.5  C11 16B 2.5",$fontSched,$brushTxt,($sldX+520),($sldY+60))
$g.DrawString("C2 10B 1.5  C4 20C 2.5  C8 20C 2.5  C9 20C 2.5  C10 25C 4.0  C12 32C 6.0",$fontSched,$brushTxt,($sldX+520),($sldY+82))
$g.DrawString("PM-01: CT on MAIN. If >35A 60s shed C12, then C10, then C9. 6x USB-C 65W on C11. Earth: 10mm2 main bond water/gas + rods <100ohm.",$fontSched,$brushTxt,($sldX+10),($sldY+115))
$g.DrawString("LOAD: connected 35.6kW diversified 13.8kW. Cooker 7 + EV 7 + AC 5 + WM 2.3 + DW 2.2 + WH 2 + sockets 8 + light 1.1. Recommend 40A min, check utility.",$fontSched,$brushTxt,($sldX+10),($sldY+137))
$g.DrawString("CABLES: NYM-J Cu. Drops 20mm conduit, spine 25mm, EV 32mm + CAT6 spare. Bath IP44 Zone1 no sockets except shaver. Isolate CK/AC/WH/EV.",$fontSched,$brushTxt,($sldX+10),($sldY+159))
# DETAILED SCHEDULE
$tx=100; $ty=$sldY+230; $tw=$CW-200
$cols=@(70,300,560,700,860,1020,1250,1600)
$rows=@(
@("CCT","POINT / HOOK","BRKR RCD","CABLE CONDUIT","LOAD","HT mm","ROUTE m","DESTINATION + NOTES"),
@("C1-01..06","L1-L6 lights + S1 hall/kit/live","10B RCD1","3x1.5 20mm","0.6kW","2500","+12+8+6","Ceiling LED 12W daisy C1-01>02>.. homerun hall"),
@("C2-01..06","L7-L12 beds/bath + S2 + SD1-3","10B RCD2","3x1.5 20mm","0.5kW","2500","+14+9","LED + smoke interlinked battery backup"),
@("C3-01..04","Socks living+hall 4x double","20C RCD1","3x2.5 20mm","2.5kW","300","+10+7","Daisy S01>S02>S03>S04 surge one point"),
@("C4-01..05","Socks bedrooms 5x double","20C RCD2","3x2.5 20mm","2.5kW","300","+13+8","No sockets <600 from shower for bed-bath wall"),
@("C5-01..04+FR","Kitchen 4x + fridge FR1","20C RCD1","3x2.5 20/25mm","3.0kW","1100/300","+11","1100 splash + FR separate spur C5-05"),
@("C6-01 CK","Cooker CK-01 600 oven+hub","32C RCD1","3x6.0 25mm","7.0kW","600/1500","+10","45A cooker switch+isol 1500 north wall"),
@("C7-01 WM","Washing WM-01 600x600","20C RCD1","3x2.5 20mm","2.3kW","600","+9","Unswitched spur + single + water tap + waste U-bend"),
@("C8-01 DW","Dishwasher DW-01","20C RCD2","3x2.5 20mm","2.2kW","600","+9.5","Next WM shared waste air-gap"),
@("C9-01 WH","Heater WH-01 80L bath loft","20C RCD2","3x2.5 20mm","2.0kW","2100","+8","20A DP pull-cord + 16A rotary isol outside bath"),
@("C10-1/2 AC","AC1 living AC2 master 2.5kW ea","25C RCD2","3x4.0 25mm","5.0kW","2200","+12/+13","Rotary isol each indoor+outdoor condensate drain"),
@("C11-1..6","CHG-01..06 USB-C 65W + PM","16B RCD1","3x2.5 20mm + CAT6","1.0kW","500/1200","+7..12","CHG1 live CHG2 kit CHG3 mast CHG4 B2 CHG5 B3 CHG6 hall PM feed"),
@("C12-01 EV","EV/outdoor E1 E2 + spare","32C RCD2","3x6.0 32mm + CAT6","7.0kW","500","+6","32A isol south + 32mm empty to boundary + earth spike"),
@("PM-01","Power mgr 6-port monitor","fed C11","CAT6 CT clamps","-","1200","2","CT MAIN sheds C12>C10>C9 app + manual bypass")
)
$rh2=28; $g.FillRectangle($wallBrush,$tx,$ty,$tw,$rh2)
for($r=0;$r -lt $rows.Count;$r++){ $yy=$ty+$r*$rh2; if($r -gt 0){ $g.DrawRectangle($penThin,$tx,$yy,$tw,$rh2) }
  for($c=0;$c -lt 8;$c++){ $xx=$tx; if($c -gt 0){ $xx=$tx+$cols[$c-1] }; $ww=$cols[0]; if($c -gt 0 -and $c -lt 7){ $ww=$cols[$c]-$cols[$c-1] } elseif($c -eq 0){ $ww=$cols[0] }; if($c -eq 7){ $ww=$tw-$cols[6] }
    if($c -gt 0){ $g.DrawLine($penThin,$xx,$yy,$xx,($yy+$rh2)) }
    $f=$fontSched; $br=$brushTxt; if($r -eq 0){ $f=$fontSchedB; $br=[System.Drawing.Brushes]::White }
    $rect=New-Object System.Drawing.RectangleF ($xx+4),($yy+5),($ww-8),($rh2-6)
    $g.DrawString($rows[$r][$c],$f,$br,$rect)
  }
}
$out=Join-Path (Get-Location) "house_electrical_v2.png"
$bmp.Save($out,[System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $bmp.Dispose()
Write-Output "saved $out"
