# Hotel DXF R12 meters origin SW Y up. y_cad = 18 - y_img
W,H=42.0,18.0
def Yc(y): return H-y
ents=[]
def line(x1,y1,x2,y2,layer):
    ents.append(f"0\nLINE\n8\n{layer}\n10\n{x1:.3f}\n20\n{Yc(y1):.3f}\n30\n0.0\n11\n{x2:.3f}\n21\n{Yc(y2):.3f}\n31\n0.0\n")
def text(x,y,h,s,layer="H_TEXT"):
    ents.append(f"0\nTEXT\n8\n{layer}\n10\n{x:.3f}\n20\n{Yc(y):.3f}\n30\n0.0\n40\n{h:.3f}\n1\n{s}\n50\n0\n")
for (x1,y1,x2,y2) in [(0,0,42,0),(0,18,42,18),(0,0,0,18),(42,0,42,18),(6,8,36,8),(6,10,36,10)]:
    line(x1,y1,x2,y2,"H_WALLS")
for i in range(9):
    x=6+i*3.75
    line(x,0.3,x,8,"H_PART"); line(x,10,x,17.7,"H_PART")
    if i<8:
        text(x+1.0,4.6,0.3,f"{101+i} KING/TWIN N","H_ROOMS")
        text(x+1.0,13.0,0.3,f"{109+i} KING/TWIN S","H_ROOMS")
        line(x+0.77,0,x+2.97,0,"H_WINDOWS"); line(x+0.77,18,x+2.97,18,"H_WINDOWS")
text(1.0,9,0.4,"LOBBY LIFTS STAIR A","H_CORE")
text(37.0,9,0.4,"SERVICE STAIR B FIRE","H_CORE")
text(0.5,-1.0,0.4,"HOTEL FLOOR 42x18 16 ROOMS H-201 METERS","H_TITLE")
dxf="0\nSECTION\n2\nENTITIES\n"+"".join(ents)+"0\nENDSEC\n0\nEOF\n"
open("hotel_floor.dxf","w").write(dxf)
print(f"wrote hotel_floor.dxf {len(ents)} ents")
