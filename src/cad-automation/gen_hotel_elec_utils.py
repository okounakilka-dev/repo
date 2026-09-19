# Hotel elec+utils generator: 42x18m, 16 rooms 101-116 + lobby + service
# DXF R12 meters origin SW Y up, y_cad = 18 - y_img
import csv, os
W, H = 42.0, 18.0
def Yc(y_img): return H - y_img

out_dir = r"C:\Users\Administrator\Documents\Default Project"
csv_path = os.path.join(out_dir, "hotel_elec_utils_schedule.csv")
dxf_path = os.path.join(out_dir, "hotel_elec_utils.dxf")

# ---------- CSV ----------
header = ["CCT","POINT_HOOK","BRKR","CABLE_PIPE","LOAD","NOTES"]
rows = []
# Mains / DBs
rows.append(["MDB-F1","160A incomer + SPD + meter / lobby riser 0-6m","160A 3P MCCB","4x50+25mm2 Cu / CT100","68kW max demand","Main board lobby, TN-S, RCD 300mA"])
rows.append(["DB-LOB","Lobby submain from MDB-F1 / riser","63A 3P","5x16mm2 Cu / CT50","18kW","Lobby+corridor west board"])
rows.append(["DB-N","North rooms 101-108 submain / corridor","63A 3P","5x16mm2 Cu / CT50","28kW","Rooms 101-108 lighting+power+FCU+bath"])
rows.append(["DB-S","South rooms 109-116 submain / corridor","63A 3P","5x16mm2 Cu / CT50","28kW","Rooms 109-116 lighting+power+FCU+bath"])
# Per-room circuits: 101-108 North, 109-116 South
for i in range(8):
    rn = 101+i
    rs = 109+i
    for r in (rn, rs):
        side = "N" if r < 109 else "S"
        db = "DB-N" if r < 109 else "DB-S"
        rows.append([f"LN-{r}", f"6x LED downlight 7W + 2x wall lamp / ceiling+wall {r}", "10A 1P", "3x1.5mm2 Cu / PVC20", "0.35kW", f"{db} lighting, bedhead + door switch"])
        rows.append([f"LP-{r}", f"4x 16A socket + 2x USB-C 45W charger / wall 0.3m {r}", "16A 1P", "3x2.5mm2 Cu / PVC25", "2.5kW", f"{db} KS key-card master cut-off, fridge stays on"])
        rows.append([f"LF-{r}", f"1x FCU 3-speed + wired thermostat / high wall {r}", "16A 1P", "3x2.5mm2 Cu / PVC25", "0.35kW", f"{db} FCU, not via KS, cond drain to shaft"])
        rows.append([f"LB-{r}", f"1x bath heater 2050W + exhaust fan / ceiling IPX4 {r}", "16A 1P", "3x2.5mm2 Cu / PVC20", "2.05kW", f"{db} bath, RCD 30mA, timer+humidistat"])
# Lobby / corridor / service lighting & power
rows.append(["LN-LOB","12x LED panel 600x600 + cove strip / lobby ceiling 0-6m","10A 1P","3x1.5mm2 Cu / PVC20","0.80kW","DB-LOB, DALI dim, EM maintained"])
rows.append(["LP-LOB","6x 16A socket + reception desk UPS feed / wall","16A 1P","3x2.5mm2 Cu / PVC25","3.0kW","DB-LOB, KS override for staff"])
rows.append(["LF-LOB","2x FCU cassette + fresh-air fan / lobby ceiling","16A 1P","3x2.5mm2 Cu / PVC25","1.20kW","DB-LOB, central controller"])
rows.append(["LN-CORR-1","14x LED downlight + 4x EXIT sign / corridor 6-36m ceiling","10A 1P","3x1.5mm2 Cu / PVC20","0.40kW","DB-LOB, EM battery 3h, PIR+timed"])
rows.append(["LN-CORR-2","14x LED wall washer / corridor + stair A/B","10A 1P","3x1.5mm2 Cu / PVC20","0.35kW","DB-LOB, night setback"])
rows.append(["LN-SERV","8x LED batten 18W / service 36-42m ceiling","10A 1P","3x1.5mm2 Cu / PVC20","0.30kW","DB-S, linen/housekeeping"])
rows.append(["LP-SERV","4x 16A washer+dryer + linen press / service wall","16A 1P","3x2.5mm2 Cu / PVC25","3.5kW","DB-S, dedicated RCD 30mA"])
rows.append(["LF-SERV","1x FCU + toilet exhaust / service","16A 1P","3x2.5mm2 Cu / PVC25","0.40kW","DB-S"])
rows.append(["KS-101-116","16x key-card switch 16A / room entrance","16A 1P","3x2.5mm2 Cu / PVC20","-","LP cut-off, LF+fridge bypass"])
# Water / HVAC / Fire
rows.append(["CW-SPINE","PPR32 cold spine 6-36m + 16x PPR20 branches to baths / corridor clg y=8.6","N/A water","PPR32 PN20 / shaft+sleeve","DN32 1.2L/s","CW spine, isolation valve each room, drain"])
rows.append(["HW-SPINE","PPR32 hot spine 6-36m + recirc PPR25 + 16x branches / clg y=9.4","N/A water","PPR32 PN20 insulated / shaft","DN32 0.9L/s 55C","HW spine with recirc pump, TMV at bath"])
rows.append(["HVAC-SUP","Galv duct 600x200 supply spine 6-36m + 150dia branches to FCU / ceiling","N/A air","600x200 GI + 25mm insulation","4500m3/h","Supply air, fire damper at lobby/service walls"])
rows.append(["HVAC-RET","Galv duct 600x200 return spine 6-36m + grilles / corridor ceiling","N/A air","600x200 GI","3800m3/h","Return air, transfer grilles room doors"])
rows.append(["FA-LOOP-1","Addressable loop 16x smoke + 4x MCP + 4x sounder + 2x I/O / rooms+corridor","6A 1P","2x1.5mm2 FR / PVC20 red","24V DC 1.5A","Fire loop DB-LOB panel, return loop, cause-effect to FCU+doors"])
rows.append(["FA-PWR","Fire panel PSU + battery 72h / lobby","10A 1P","3x2.5mm2 Cu / PVC20","0.20kW","EN54 panel in lobby riser"])

with open(csv_path, "w", newline="", encoding="utf-8") as f:
    w = csv.writer(f)
    w.writerow(header)
    w.writerows(rows)
print(f"wrote {csv_path} {len(rows)} rows")

# ---------- DXF R12 ----------
ents = []
def line(x1_yimg, y1_yimg, x2_yimg, y2_yimg, layer):
    ents.append(f"0\nLINE\n8\n{layer}\n10\n{x1_yimg:.3f}\n20\n{Yc(y1_yimg):.3f}\n30\n0.0\n11\n{x2_yimg:.3f}\n21\n{Yc(y2_yimg):.3f}\n31\n0.0\n")
def text(x_yimg, y_yimg, h, s, layer):
    s = str(s).replace("\n"," ")
    ents.append(f"0\nTEXT\n8\n{layer}\n10\n{x_yimg:.3f}\n20\n{Yc(y_yimg):.3f}\n30\n0.0\n40\n{h:.3f}\n1\n{s}\n50\n0\n")
def circ(x_yimg, y_yimg, r, layer):
    ents.append(f"0\nCIRCLE\n8\n{layer}\n10\n{x_yimg:.3f}\n20\n{Yc(y_yimg):.3f}\n30\n0.0\n40\n{r:.3f}\n")

# H_WALLS: outline 0,0,42,18 + corridor 6,8,36,10 (y_img coords, Yc flips but rect same)
for (x1,y1,x2,y2) in [(0,0,42,0),(0,18,42,18),(0,0,0,18),(42,0,42,18),(6,8,36,8),(6,10,36,10),(6,8,6,10),(36,8,36,10)]:
    line(x1,y1,x2,y2,"H_WALLS")
# lobby/service dividers + room partitions
line(6,0,6,18,"H_WALLS")
line(36,0,36,18,"H_WALLS")
for i in range(9):
    x = 6+i*3.75
    line(x,0.3,x,8,"H_WALLS")      # north rooms top strip y_img 0-8
    line(x,10,x,17.7,"H_WALLS")    # south rooms bottom strip y_img 10-18

# Room tags 101-116 (y_img: north 4.6 -> CAD 13.4, south 13.0 -> CAD 5.0)
for i in range(8):
    x = 6+i*3.75
    xc = x+1.875
    text(xc-0.6,4.6,0.35,f"{101+i}","H_WALLS")
    text(xc-0.6,13.0,0.35,f"{109+i}","H_WALLS")
    # bath boxes (1.8x1.9) at corridor side
    # north bath near corridor: y_img 6.1-8.0
    line(x+0.2,6.1,x+2.0,6.1,"H_WALLS"); line(x+0.2,8.0,x+2.0,8.0,"H_WALLS")
    line(x+0.2,6.1,x+0.2,8.0,"H_WALLS"); line(x+2.0,6.1,x+2.0,8.0,"H_WALLS")
    # south bath: y_img 10.0-11.9
    line(x+0.2,10.0,x+2.0,10.0,"H_WALLS"); line(x+0.2,11.9,x+2.0,11.9,"H_WALLS")
    line(x+0.2,10.0,x+0.2,11.9,"H_WALLS"); line(x+2.0,10.0,x+2.0,11.9,"H_WALLS")

# E_LIGHT: corridor spine + per-room lights
line(6,9,36,9,"E_LIGHT")
for x in [8,12,16,20,24,28,32,34]:
    circ(x,9,0.12,"E_LIGHT")
    text(x+0.2,9.25,0.18,f"LN-CORR","E_LIGHT")
for i in range(8):
    x = 6+i*3.75+1.875
    circ(x,4.0,0.15,"E_LIGHT"); text(x+0.25,4.0,0.20,f"LN-{101+i} 10A","E_LIGHT")
    circ(x,14.0,0.15,"E_LIGHT"); text(x+0.25,14.0,0.20,f"LN-{109+i} 10A","E_LIGHT")

# E_POWER: ring + sockets + KS + DB texts
line(6,9.3,36,9.3,"E_POWER")
for i in range(8):
    x = 6+i*3.75+1.875
    # KS at door (corridor side)
    circ(x+1.2,8.3,0.10,"E_POWER"); text(x+1.35,8.3,0.18,f"KS-{101+i}","E_POWER")
    circ(x+1.2,11.7,0.10,"E_POWER"); text(x+1.35,11.7,0.18,f"KS-{109+i}","E_POWER")
    text(x-1.2,3.0,0.20,f"LP-{101+i} 16A","E_POWER")
    text(x-1.2,15.0,0.20,f"LP-{109+i} 16A","E_POWER")
text(1.0,2.0,0.40,"MDB-F1 160A","E_POWER")
text(1.0,9.0,0.35,"DB-LOB","E_POWER")
text(19.5,8.5,0.35,"DB-N 63A","E_POWER")
text(19.5,11.5,0.35,"DB-S 63A","E_POWER")
text(0.5,18.7,0.35,"ELEC 42x18 MDB-F1 160A DB-LOB/N/S LN/LP/LF/LB KS M","E_POWER")

# E_FCU: per-room FCU boxes 1.0x0.6 at facade side + labels
for i in range(8):
    x0 = 6+i*3.75+1.3
    # north FCU y_img 0.5-1.1
    line(x0,0.5,x0+1.0,0.5,"E_FCU"); line(x0,1.1,x0+1.0,1.1,"E_FCU")
    line(x0,0.5,x0,1.1,"E_FCU"); line(x0+1.0,0.5,x0+1.0,1.1,"E_FCU")
    text(x0,1.35,0.20,f"LF-{101+i} 16A","E_FCU")
    # south FCU y_img 16.9-17.5
    line(x0,16.9,x0+1.0,16.9,"E_FCU"); line(x0,17.5,x0+1.0,17.5,"E_FCU")
    line(x0,16.9,x0,17.5,"E_FCU"); line(x0+1.0,16.9,x0+1.0,17.5,"E_FCU")
    text(x0,16.5,0.20,f"LF-{109+i} 16A","E_FCU")
    # bath heater circles
    circ(x0+0.5,7.0,0.18,"E_FCU"); text(x0+0.75,7.0,0.18,f"LB-{101+i}","E_FCU")
    circ(x0+0.5,11.0,0.18,"E_FCU"); text(x0+0.75,11.0,0.18,f"LB-{109+i}","E_FCU")

# W_CW spine y_img 9.4 -> CAD 8.6, branches
line(6,9.4,36,9.4,"W_CW")
for i in range(8):
    x = 6+i*3.75+1.0
    line(x,9.4,x,7.0,"W_CW")
    line(x,9.4,x,11.0,"W_CW")
text(6.2,9.65,0.22,"CW PPR32 spine","W_CW")

# W_HW spine y_img 8.6 -> CAD 9.4
line(6,8.6,36,8.6,"W_HW")
for i in range(8):
    x = 6+i*3.75+1.4
    line(x,8.6,x,7.0,"W_HW")
    line(x,8.6,x,11.0,"W_HW")
text(6.2,8.35,0.22,"HW PPR32 spine+recirc","W_HW")

# H_HVAC ducts y_img 9.7 and 8.3
line(6,9.7,36,9.7,"H_HVAC")
line(6,8.3,36,8.3,"H_HVAC")
for i in range(8):
    x = 6+i*3.75+1.875
    line(x,9.7,x,1.0,"H_HVAC")
    line(x,8.3,x,17.0,"H_HVAC")
text(28.0,9.95,0.22,"SUP 600x200","H_HVAC")
text(28.0,8.05,0.22,"RET 600x200","H_HVAC")

# FA loop + detectors
line(6,9.15,36,9.15,"FA")
line(6,8.85,36,8.85,"FA")
for x in [7,11,15,19,23,27,31,35]:
    circ(x,9.0,0.14,"FA")
text(6.2,8.0,0.22,"FA LOOP addressable","FA")
text(30.0,9.4,0.22,"SMK/MCP/SND","FA")

# LAYER table
layers = [("H_WALLS",7),("E_LIGHT",2),("E_POWER",1),("E_FCU",4),("W_CW",5),("W_HW",6),("H_HVAC",3),("FA",1)]
tbl = ["0\nSECTION\n2\nTABLES\n0\nTABLE\n2\nLAYER\n70\n9\n"]
tbl.append("0\nLAYER\n2\n0\n70\n0\n62\n7\n6\nCONTINUOUS\n")
for name,col in layers:
    tbl.append(f"0\nLAYER\n2\n{name}\n70\n0\n62\n{col}\n6\nCONTINUOUS\n")
tbl.append("0\nENDTAB\n0\nENDSEC\n")
header_sec = "0\nSECTION\n2\nHEADER\n9\n$ACADVER\n1\nAC1009\n0\nENDSEC\n"
ent_sec = "0\nSECTION\n2\nENTITIES\n"+"".join(ents)+"0\nENDSEC\n0\nEOF\n"
dxf = header_sec+"".join(tbl)+ent_sec
with open(dxf_path,"w",encoding="utf-8") as f:
    f.write(dxf)
print(f"wrote {dxf_path} {len(ents)} ents")
