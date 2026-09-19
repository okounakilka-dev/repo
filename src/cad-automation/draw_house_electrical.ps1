Add-Type -AssemblyName System.Drawing
$S=170; $Wm=12.0; $Hm=9.0; $Ox=350; $Oy=220
$Wpx=[int]($Wm*$S); $Hpx=[int]($Hm*$S); $CW=3000; $CH=2750
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
$penDim=New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(0,90,160)),2
$brushTxt=New-Object System.Drawing.SolidBrush $black
$brushGray=New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(80,80,80))
$brushWhite=New-Object System.Drawing.Brushes::White
$fontTitle=New-Object System.Drawing.Font "Arial",24,([System.Drawing.FontStyle]::Bold)
$fontSub=New-Object System.Drawing.Font "Arial",13,([System.Drawing.FontStyle]::Regular)
$fontRoom=New-Object System.Drawing.Font "Arial",13,([System.Drawing.FontStyle]::Bold)
$fontSym=New-Object System.Drawing.Font "Arial",10,([System.Drawing.FontStyle]::Bold)
$fontTag=New-Object System.Drawing.Font "Arial",9,([System.Drawing.FontStyle]::Bold)
$fontSched=New-Object System.Drawing.Font "Consolas",10,([System.Drawing.FontStyle]::Regular)
$fontSchedB=New-Object System.Drawing.Font "Consolas",10,([System.Drawing.FontStyle]::Bold)
# room fills light
$rx=@(0.2,6.4,6.4,8.8,0.2,5.0,6.4,9.5,9.5); $ry=@(0.2,0.2,2.4,0.2,4.3,0.2,4.3,4.3,6.4); $rw=@(4.6,2.2,2.2,3.0,4.6,1.2,2.9,2.3,2.3); $rh=@(3.9,2.0,1.7,3.9,3.8,8.6,3.8,1.9,1.7)
$rn=@("KITCHEN / DINING","BED 3","BATH","BEDROOM 2","LIVING","HALL","MASTER","ENSUITE","WIR")
$rc=@([System.Drawing.Color]::FromArgb(255,252,235),[System.Drawing.Color]::FromArgb(240,245,255),[System.Drawing.Color]::FromArgb(235,248,255),[System.Drawing.Color]::FromArgb(240,245,255),[System.Drawing.Color]::FromArgb(240,250,240),[System.Drawing.Color]::FromArgb(248,248,248),[System.Drawing.Color]::FromArgb(255,242,245),[System.Drawing.Color]::FromArgb(235,248,255),[System.Drawing.Color]::FromArgb(245,242,255))
for($i=0;$i -lt $rx.Count;$i++){ $bb=New-Object System.Drawing.SolidBrush $rc[$i]; $g.FillRectangle($bb,(New-Rect2 -X $rx[$i] -Y $ry[$i] -W $rw[$i] -H $rh[$i])); $bb.Dispose() }
function Add-Wall2{param([double]$X,[double]$Y,[double]$W,[double]$H)$g.FillRectangle($wallBrush,(Get-PX -X $X),(Get-PY -Y $Y),([int]($W*$S)),([int]($H*$S)))}
Add-Wall2 -X 0 -Y 0 -W 12.0 -H 0.2; Add-Wall2 -X 0 -Y 8.8 -W 12.0 -H 0.2; Add-Wall2 -X 0 -Y 0 -W 0.2 -H 9.0; Add-Wall2 -X 11.8 -Y 0 -W 0.2 -H 9.0
$g.DrawRectangle($penMed,(Get-PX -X 0),(Get-PY -Y 0),$Wpx,$Hpx)
Add-Wall2 -X 5.0 -Y 0.2 -W 0.1 -H 8.6; Add-Wall2 -X 6.2 -Y 0.2 -W 0.1 -H 8.6; Add-Wall2 -X 0.2 -Y 4.1 -W 4.8 -H 0.1; Add-Wall2 -X 6.3 -Y 4.1 -W 5.5 -H 0.1; Add-Wall2 -X 8.7 -Y 0.2 -W 0.1 -H 3.9; Add-Wall2 -X 6.4 -Y 2.2 -W 2.3 -H 0.1; Add-Wall2 -X 9.3 -Y 4.1 -W 0.1 -H 4.0; Add-Wall2 -X 9.5 -Y 6.2 -W 2.3 -H 0.1
foreach($k in 0..($rn.Count-1)){ $cx=(Get-PX -X $rx[$k])+([int]($rw[$k]*$S/2)); $cy=(Get-PY -Y $ry[$k])+20; $sf=New-Object System.Drawing.StringFormat; $sf.Alignment=[System.Drawing.StringAlignment]::Center; $g.DrawString($rn[$k],$fontRoom,$brushGray,$cx,$cy,$sf) }
$g.DrawString("ELECTRICAL PLAN 12x9m - CIRCUITS, CHARGERS, POWER MANAGER + SCHEDULE",$fontTitle,$brushTxt,($Ox-40),15)
$g.DrawString("DB 12-way in Hall south. All heights: sockets 300mm, switches 1200mm, chargers 500/1200mm. Cables NYM-J copper. 230V/50Hz TN-S.",$fontSub,$brushGray,($Ox-30),52)
# pens per system
function DashPen($c,$w){ $p=New-Object System.Drawing.Pen $c,$w; $p.DashStyle=[System.Drawing.Drawing2D.DashStyle]::Dash; return $p }
$penLight=DashPen ([System.Drawing.Color]::FromArgb(200,150,0)) 2
$penPower=DashPen ([System.Drawing.Color]::FromArgb(200,30,30)) 2
$penKitchen=DashPen ([System.Drawing.Color]::FromArgb(230,120,0)) 2
$penDed=DashPen ([System.Drawing.Color]::FromArgb(0,60,180)) 3
$penChg=DashPen ([System.Drawing.Color]::FromArgb(0,150,60)) 2
$penSw=New-Object System.Drawing.Pen ([System.Drawing.Color]::Black),2
$dbX=5.55; $dbY=8.35
function LineE($pen,$x1,$y1,$x2,$y2){ $g.DrawLine($pen,(Get-PX -X $x1),(Get-PY -Y $y1),(Get-PX -X $x2),(Get-PY -Y $y2)) }
function Tag($x,$y,$t,$bg){ $px=(Get-PX -X $x); $py=(Get-PY -Y $y); $b=New-Object System.Drawing.SolidBrush $bg; $g.FillEllipse($b,$px-22,$py-14,44,24); $g.DrawEllipse($penThin,$px-22,$py-14,44,24); $sf=New-Object System.Drawing.StringFormat; $sf.Alignment=[System.Drawing.StringAlignment]::Center; $sf.LineAlignment=[System.Drawing.StringAlignment]::Center; $g.DrawString($t,$fontTag,$brushTxt,$px,$py-10,$sf); $b.Dispose() }
function LightPt($x,$y,$c){ $px=(Get-PX -X $x); $py=(Get-PY -Y $y); $g.DrawEllipse($penThin,$px-14,$py-14,28,28); $g.DrawLine($penThin,$px-10,$py-10,$px+10,$py+10); $g.DrawLine($penThin,$px-10,$py+10,$px+10,$py-10); Tag -x $x -y ([double]$y+0.32) -t $c -bg ([System.Drawing.Color]::FromArgb(255,235,150)) }
function SocketPt($x,$y,$c){ $px=(Get-PX -X $x); $py=(Get-PY -Y $y); $g.FillRectangle([System.Drawing.Brushes]::White,$px-10,$py-10,20,20); $g.DrawRectangle($penThin,$px-10,$py-10,20,20); $g.DrawLine($penThin,$px-10,$py,$px+10,$py); Tag -x $x -y ([double]$y+0.32) -t $c -bg ([System.Drawing.Color]::FromArgb(255,200,200)) }
function ChgPt($x,$y,$c){ $px=(Get-PX -X $x); $py=(Get-PY -Y $y); $b=New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(200,255,210)); $g.FillRectangle($b,$px-11,$py-11,22,22); $g.DrawRectangle($penThin,$px-11,$py-11,22,22); $g.DrawString("USB",$fontTag,$brushTxt,$px-13,$py-8); $b.Dispose(); Tag -x $x -y ([double]$y+0.34) -t $c -bg ([System.Drawing.Color]::FromArgb(180,240,190)) }
function DedPt($x,$y,$lbl,$c){ $px=(Get-PX -X $x); $py=(Get-PY -Y $y); $b=New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(200,220,255)); $g.FillRectangle($b,$px-16,$py-12,52,24); $g.DrawRectangle($penMed,$px-16,$py-12,52,24); $g.DrawString($lbl,$fontSym,$brushTxt,$px-12,$py-9); Tag -x ([double]$x+0.22) -y ([double]$y+0.36) -t $c -bg ([System.Drawing.Color]::FromArgb(180,210,255)) }
function SwPt($x,$y){ $px=(Get-PX -X $x); $py=(Get-PY -Y $y); $g.DrawString("S",$fontSym,$brushTxt,$px-6,$py-10) }
# DB + Power manager
$dbR=New-Rect2 -X 5.15 -Y 8.15 -W 1.0 -H 0.55; $g.FillRectangle([System.Drawing.Brushes]::White,$dbR); $g.DrawRectangle($penMed,$dbR.X,$dbR.Y,$dbR.Width,$dbR.Height)
$g.DrawString("DB 12-WAY",$fontSym,$brushTxt,(Get-PX -X 5.22),(Get-PY -Y 8.2)); $g.DrawString("40A+RCD+SPD",$fontTag,$brushGray,(Get-PX -X 5.22),(Get-PY -Y 8.4))
$pmR=New-Rect2 -X 4.15 -Y 8.15 -W 0.8 -H 0.55; $g.FillRectangle([System.Drawing.Brushes]::White,$pmR); $g.DrawRectangle($penMed,$pmR.X,$pmR.Y,$pmR.Width,$pmR.Height)
$g.DrawString("PM-01",$fontSym,$brushTxt,(Get-PX -X 4.22),(Get-PY -Y 8.2)); $g.DrawString("CHG MGR",$fontTag,$brushGray,(Get-PX -X 4.22),(Get-PY -Y 8.4))
# LIGHTING C1 living/kitchen/hall
LightPt 1.5 2.0 "C1"; LightPt 3.5 2.0 "C1"; LightPt 1.5 6.0 "C1"; LightPt 3.5 6.0 "C1"; LightPt 5.6 2.0 "C1"; LightPt 5.6 6.5 "C1"
SwPt 4.7 4.4; SwPt 5.15 7.9; SwPt 6.05 7.9
LineE $penLight $dbX $dbY 5.6 6.5; LineE $penLight 5.6 6.5 3.5 6.0; LineE $penLight 3.5 6.0 1.5 6.0; LineE $penLight 5.6 2.0 3.5 2.0; LineE $penLight 3.5 2.0 1.5 2.0
# LIGHTING C2 bedrooms/bath
LightPt 7.5 1.2 "C2"; LightPt 10.3 2.0 "C2"; LightPt 7.5 3.2 "C2"; LightPt 7.8 6.0 "C2"; LightPt 10.6 5.2 "C2"; LightPt 10.6 7.2 "C2"
LineE $penLight $dbX $dbY 7.8 6.0; LineE $penLight 7.8 6.0 7.5 3.2; LineE $penLight 7.5 3.2 7.5 1.2; LineE $penLight 7.5 1.2 10.3 2.0
# POWER C3 living+hall
SocketPt 0.4 4.5 "C3"; SocketPt 0.4 7.8 "C3"; SocketPt 2.5 8.5 "C3"; SocketPt 4.7 6.5 "C3"; SocketPt 5.15 5.0 "C3"
LineE $penPower $dbX $dbY 5.15 5.0; LineE $penPower 5.15 5.0 4.7 6.5; LineE $penPower 4.7 6.5 2.5 8.5
# POWER C4 bedrooms
SocketPt 6.5 0.4 "C4"; SocketPt 8.5 0.4 "C4"; SocketPt 11.6 2.5 "C4"; SocketPt 6.5 7.9 "C4"; SocketPt 8.9 7.9 "C4"; SocketPt 11.6 6.8 "C4"
LineE $penPower $dbX $dbY 6.5 7.9; LineE $penPower 6.5 7.9 8.9 7.9; LineE $penPower 8.9 7.9 11.6 6.8
# KITCHEN C5
SocketPt 1.0 0.45 "C5"; SocketPt 2.5 0.45 "C5"; SocketPt 4.0 0.45 "C5"; SocketPt 0.45 2.5 "C5"
LineE $penKitchen $dbX $dbY 4.0 0.45; LineE $penKitchen 4.0 0.45 1.0 0.45
# DEDICATED
DedPt 2.0 0.7 "CK" "C6"; DedPt 0.55 3.4 "WM" "C7"; DedPt 1.4 3.4 "DW" "C8"; DedPt 7.0 2.5 "WH" "C9"; DedPt 3.0 8.3 "AC" "C10"; DedPt 8.0 7.7 "AC" "C10"; DedPt 4.5 8.6 "EV" "C12"
LineE $penDed $dbX $dbY 2.0 0.7; LineE $penDed $dbX $dbY 0.55 3.4; LineE $penDed $dbX $dbY 7.0 2.5; LineE $penDed $dbX $dbY 8.0 7.7
# CHARGERS C11 green
ChgPt 4.7 7.2 "C11"; ChgPt 2.0 8.5 "C11"; ChgPt 6.8 7.5 "C11"; ChgPt 9.2 1.0 "C11"; ChgPt 6.7 0.8 "C11"; ChgPt 4.5 8.3 "C11"
LineE $penChg $dbX $dbY 4.5 8.3; LineE $penChg 4.5 8.3 2.0 8.5; LineE $penChg $dbX $dbY 6.8 7.5
# legend top-right
$lx=(Get-PX -X 12)+30; $ly=(Get-PY -Y 1.5)
$g.DrawString("LEGEND IEC 60617",$fontSym,$brushTxt,$lx,$ly); $ly+=28
foreach($e in @(@($penLight,"C1/C2 Lighting 10A 3x1.5"),@($penPower,"C3/C4 Sockets 20A 3x2.5"),@($penKitchen,"C5 Kitchen 20A 3x2.5"),@($penDed,"C6-C10 Dedicated 20-32A"),@($penChg,"C11 Chargers USB 16A"))){
  $g.DrawLine($e[0],$lx,$ly+8,($lx+70),($ly+8)); $g.DrawString($e[1],$fontSub,$brushTxt,($lx+80),$ly); $ly+=26
}
$g.DrawString("Circle=CCT no.  USB=charger", $fontSub,$brushGray,$lx,$ly); $ly+=24
$g.DrawString("S=switch  DB=board", $fontSub,$brushGray,$lx,$ly)
# schedule table bottom
$sx=120; $sy=(Get-PY -Y 9)+110; $sw=$CW-240; $col=@(90,340,580,760,980,1220)
$rows=@(
@("CCT","DESCRIPTION / POINT","BRKR","CABLE","LOAD","HOOKS TO"),
@("C1","Lighting Living/Kitchen/Hall 6pts","10A B","NYM-J 3x1.5","0.6kW","L1-L6 + S1-S3"),
@("C2","Lighting Beds/Bath/Ensuite 6pts","10A B","NYM-J 3x1.5","0.5kW","L7-L12"),
@("C3","Sockets Living+Hall 5x double","20A C / RCD","NYM-J 3x2.5","2.5kW","S01-S05"),
@("C4","Sockets Bedrooms 6x double","20A C / RCD","NYM-J 3x2.5","2.5kW","S06-S11"),
@("C5","Sockets Kitchen counter 4x + fridge","20A C / RCD","NYM-J 3x2.5","3.0kW","K01-K04 + FR1"),
@("C6","Cooker / Oven CK-01 dedicated","32A C","NYM-J 3x6.0","7.0kW","CK-01 north wall"),
@("C7","Washing Machine WM-01","20A C / RCD","NYM-J 3x2.5","2.3kW","WM-01 600x600"),
@("C8","Dishwasher / Dryer DW-01","20A C / RCD","NYM-J 3x2.5","2.2kW","DW-01 kitchen"),
@("C9","Water Heater WH-01 Bath","20A C","NYM-J 3x2.5","2.0kW","WH-01 + isolator"),
@("C10","Split AC 2x 2.5kW Living+Master","25A C","NYM-J 3x4.0","5.0kW","AC-01 AC-02 + isol."),
@("C11","Chargers USB-C x6 + PM-01 manager","16A B / RCD","NYM-J 3x2.5","1.0kW","CHG01-06 + PM-01"),
@("C12","Outdoor / EV ready spare conduit","32A C","NYM-J 3x6.0 + CAT6","7.0kW","EV-01 south wall")
)
$rh2=30; $g.FillRectangle($wallBrush,$sx,$sy,$sw,$rh2)
for($r=0;$r -lt $rows.Count;$r++){
  $yy=$sy+$r*$rh2
  if($r -gt 0){ $g.DrawRectangle($penThin,$sx,$yy,$sw,$rh2) }
  for($c=0;$c -lt 6;$c++){
    $xx=$sx; if($c -gt 0){ $xx=$sx+$col[$c-1] }
    $ww=$col[0]; if($c -gt 0 -and $c -lt 6){ $ww=$col[$c]-$col[$c-1] } elseif($c -eq 0){ $ww=$col[0] }
    if($c -eq 5){ $ww=$sw-$col[4] }
    if($c -gt 0){ $g.DrawLine($penThin,$xx,$yy,$xx,($yy+$rh2)) }
    $f=$fontSched; $br=$brushTxt; if($r -eq 0){ $f=$fontSchedB; $br=[System.Drawing.Brushes]::White }
    $g.DrawString($rows[$r][$c],$f,$br,($xx+6),($yy+7))
  }
}
$by2=$sy+$rows.Count*$rh2+30; $g.DrawString("POWER MANAGER PM-01: 40A main + SPD + 30mA RCDs. Monitor C6/C7/C10. Chargers: 6x 65W USB-C wall modules on C11, each labelled CHG-01..06 hooks to cable C11-01..06. WM hooks to C7-01, Cooker to C6-01, AC to C10-01/02, EV to C12-01. Verify earth loop + insulation before energize. For AutoCAD use DXF.",$fontSub,$brushGray,$sx,$by2)
$out=Join-Path (Get-Location) "house_electrical.png"
$bmp.Save($out,[System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $bmp.Dispose()
Write-Output "saved $out"
