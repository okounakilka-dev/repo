# DXF R12 generator - meters, origin SW (south-west), Y up = north
# PNG y_img 0=north(top) -> CAD y = 9 - y_img
W, H = 12.0, 9.0
def Yc(y_img): return H - y_img

ents = []
def line(x1,y1,x2,y2,layer="WALLS"):
    # y1,y2 in img coords
    ents.append(f"0\nLINE\n8\n{layer}\n10\n{x1:.3f}\n20\n{Yc(y1):.3f}\n30\n0.0\n11\n{x2:.3f}\n21\n{Yc(y2):.3f}\n31\n0.0\n")
def text(x,y,h,s,layer="TEXT",rot=0):
    s=s.replace("\n"," ")
    ents.append(f"0\nTEXT\n8\n{layer}\n10\n{x:.3f}\n20\n{Yc(y):.3f}\n30\n0.0\n40\n{h:.3f}\n1\n{s}\n50\n{rot}\n")
def arc(cx,cy,r,a1,a2,layer="DOORS"):
    # CAD angles: 0=east, CCW. img y down flips angles. approximate: convert
    # img arc drawn with GDI+ clockwise from x-axis. For CAD, mirror Y: angle_cad = 360-a_img
    # swap start/end
    na1 = (360-a2)%360
    na2 = (360-a1)%360
    ents.append(f"0\nARC\n8\n{layer}\n10\n{cx:.3f}\n20\n{Yc(cy):.3f}\n30\n0.0\n40\n{r:.3f}\n50\n{na1:.1f}\n51\n{na2:.1f}\n")

# outer double lines (200mm walls) - outer + inner face
t=0.2
for (x1,y1,x2,y2) in [(0,0,12,0),(0,9,12,9),(0,0,0,9),(12,0,12,9),(t,t,12-t,t),(t,H-t,12-t,H-t),(t,t,t,H-t),(W-t,t,W-t,H-t)]:
    line(x1,y1,x2,y2,"WALLS")
# interior 100mm approximated as single centerline + note thickness in layer
# west hallway walls
line(5.05,0.2,5.05,8.8,"WALLS_INT")
line(6.25,0.2,6.25,8.8,"WALLS_INT")
line(0.2,4.15,5.0,4.15,"WALLS_INT")
line(6.3,4.15,11.8,4.15,"WALLS_INT")
line(8.75,0.2,8.75,4.1,"WALLS_INT")
line(6.4,2.25,8.7,2.25,"WALLS_INT")
line(9.35,4.15,9.35,8.1,"WALLS_INT")
line(9.5,6.25,11.8,6.25,"WALLS_INT")
# windows (gaps noted)
text(1.0,0.1,0.25,"WIN 1800","WINDOWS")
text(6.7,0.1,0.25,"WIN 1500","WINDOWS")
text(9.3,0.1,0.25,"WIN 1800","WINDOWS")
text(1.0,8.7,0.25,"WIN 1800","WINDOWS")
# doors + swings
doors=[(5.2,8.8,0.9,270,360),(1.8,4.1,0.8,270,360),(5.0,3.8,0.8,0,90),(6.2,2.0,0.8,270,360),(6.2,6.3,0.8,270,360),(7.0,4.1,0.8,90,180),(10.2,4.1,0.8,180,270),(8.7,3.6,0.8,180,270),(9.3,5.9,0.7,270,360)]
for hx,hy,r,a1,a2 in doors:
    arc(hx,hy,r,a1,a2,"DOORS")
    # leaf approx: line from hinge outward (use end angle)
    import math
    ae=math.radians(a2)
    # GDI+ 0deg=east, clockwise (y down). CAD mirrored, but leaf visual approx:
    x2=hx+r*math.cos(ae); y2=hy+r*math.sin(ae)  # in img coords with y down = sin positive down, matches GDI+
    line(hx,hy,x2,y2,"DOORS")
# room labels
labels=[(2.5,2.0,"KITCHEN / DINING 5.00x4.20"),(7.5,1.2,"BED 3 2.60x2.20"),(7.5,3.2,"BATH 2.60x1.90"),(10.3,2.0,"BEDROOM 2 3.20x4.00"),(2.5,6.2,"LIVING 4.80x4.00"),(5.6,4.5,"HALLWAY"),(7.8,6.2,"MASTER 3.10x4.00"),(10.6,5.2,"ENSUITE"),(10.6,7.2,"WIR")]
for x,y,s in labels:
    text(x,y,0.25,s,"ROOM_NAMES")
# dims overall
text(0, -0.6, 0.3, "12.00 m OVERALL", "DIMS")
text(-1.0, 4.5, 0.3, "9.00 m OVERALL", "DIMS", rot=90)
text(0.1,9.4,0.25,"Ext 200mm Int 100mm Doors 800-900 Scale 1:50 DWG A-101","TITLE")

dxf="0\nSECTION\n2\nENTITIES\n"+"".join(ents)+"0\nENDSEC\n0\nEOF\n"
open("house_plan.dxf","w").write(dxf)
print(f"wrote house_plan.dxf {len(ents)} entities {len(dxf)} bytes")
