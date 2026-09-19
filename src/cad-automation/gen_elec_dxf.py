# Electrical DXF R12 - meters, Y up, origin SW. y_cad = 9 - y_img
W,H=12.0,9.0
def Yc(y): return H-y
ents=[]
def line(x1,y1,x2,y2,layer):
    ents.append(f"0\nLINE\n8\n{layer}\n10\n{x1:.3f}\n20\n{Yc(y1):.3f}\n30\n0.0\n11\n{x2:.3f}\n21\n{Yc(y2):.3f}\n31\n0.0\n")
def text(x,y,h,s,layer="E_TEXT",rot=0):
    s=str(s).replace("\n"," ")
    ents.append(f"0\nTEXT\n8\n{layer}\n10\n{x:.3f}\n20\n{Yc(y):.3f}\n30\n0.0\n40\n{h:.3f}\n1\n{s}\n50\n{rot}\n")
def circ(x,y,r,layer):
    ents.append(f"0\nCIRCLE\n8\n{layer}\n10\n{x:.3f}\n20\n{Yc(y):.3f}\n30\n0.0\n40\n{r:.3f}\n")
# walls outline
for (x1,y1,x2,y2) in [(0,0,12,0),(0,9,12,9),(0,0,0,9),(12,0,12,9)]:
    line(x1,y1,x2,y2,"A_WALLS")
# DB + PM
text(5.55,8.35,0.25,"DB 12-WAY 40A","E_DB")
circ(5.55,8.35,0.15,"E_DB")
text(4.5,8.35,0.2,"PM-01 POWER MANAGER","E_CHG")
# lights C1 C2
lights=[(1.5,2.0,"C1 L1"),(3.5,2.0,"C1 L2"),(1.5,6.0,"C1 L3"),(3.5,6.0,"C1 L4"),(5.6,2.0,"C1 L5"),(5.6,6.5,"C1 L6"),(7.5,1.2,"C2 L7"),(10.3,2.0,"C2 L8"),(7.5,3.2,"C2 L9"),(7.8,6.0,"C2 L10"),(10.6,5.2,"C2 L11"),(10.6,7.2,"C2 L12")]
for x,y,s in lights:
    circ(x,y,0.12,"E_LIGHT"); text(x+0.18,y,0.18,s,"E_LIGHT")
# sockets C3 C4 C5
socks=[(0.4,4.5,"C3-01"),(0.4,7.8,"C3-02"),(2.5,8.5,"C3-03"),(4.7,6.5,"C3-04"),(6.5,0.4,"C4-01"),(8.5,0.4,"C4-02"),(11.6,2.5,"C4-03"),(6.5,7.9,"C4-04"),(1.0,0.45,"C5-01"),(2.5,0.45,"C5-02"),(4.0,0.45,"C5-03")]
for x,y,s in socks:
    text(x,y,0.18,f"SOCK {s}","E_POWER")
# dedicated
deds=[(2.0,0.7,"CK-01 C6-01 32A 6mm"),(0.55,3.4,"WM-01 C7-01 20A"),(1.4,3.4,"DW-01 C8-01 20A"),(7.0,2.5,"WH-01 C9-01"),(3.0,8.3,"AC-01 C10-01"),(8.0,7.7,"AC-02 C10-02"),(4.5,8.6,"EV-01 C12-01")]
for x,y,s in deds:
    text(x,y,0.22,s,"E_DED")
# chargers C11
chgs=[(4.7,7.2,"CHG-01 C11-01"),(2.0,8.5,"CHG-02 C11-02"),(6.8,7.5,"CHG-03 C11-03"),(9.2,1.0,"CHG-04 C11-04"),(6.7,0.8,"CHG-05 C11-05"),(4.5,8.3,"CHG-06 C11-06")]
for x,y,s in chgs:
    circ(x,y,0.1,"E_CHG"); text(x+0.15,y,0.18,s,"E_CHG")
text(0.2,9.4,0.25,"ELECTRICAL DWG E-101 DB+CIRCUITS C1-C12 PM-01 UNITS METERS","E_TITLE")
dxf="0\nSECTION\n2\nENTITIES\n"+"".join(ents)+"0\nENDSEC\n0\nEOF\n"
open("house_electrical.dxf","w").write(dxf)
print(f"wrote house_electrical.dxf {len(ents)} ents")
