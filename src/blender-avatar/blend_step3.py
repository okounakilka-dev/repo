import bpy
def sph(name,loc,scale,mat):
    bpy.ops.mesh.primitive_uv_sphere_add(segments=32,ring_count=16,radius=1,location=loc)
    o=bpy.context.active_object; o.name=name; o.scale=scale
    o.data.materials.append(bpy.data.materials[mat])
    for p in o.data.polygons: p.use_smooth=True
    return o
def hcurve(name,pts,radius,mat):
    cd=bpy.data.curves.new(name+'_d','CURVE'); cd.dimensions='3D'; cd.resolution_u=6; cd.bevel_depth=radius; cd.bevel_resolution=4
    sp=cd.splines.new('BEZIER'); sp.bezier_points.add(len(pts)-1)
    for i,pt in enumerate(pts):
        bp=sp.bezier_points[i]; bp.co=pt; bp.handle_left_type='AUTO'; bp.handle_right_type='AUTO'
    o=bpy.data.objects.new(name,cd); bpy.context.collection.objects.link(o)
    o.data.materials.append(bpy.data.materials[mat])
    return o
# main bob volumes
sph("Hair_Main",(0,0.1,1.78),(0.73,0.68,0.70),"Hair_Dark")
sph("Hair_Side_L",(-0.60,0.05,1.45),(0.30,0.32,0.46),"Hair_Dark")
sph("Hair_Side_R",(0.60,0.05,1.45),(0.30,0.32,0.46),"Hair_Dark")
sph("Hair_Back",(0,0.38,1.50),(0.66,0.42,0.56),"Hair_Dark")
sph("Hair_Top",(0,0.05,2.05),(0.55,0.55,0.35),"Hair_Dark")
# bangs covering right eye like ref, wavy ends
hcurve("Bang_1",[(-0.42,-0.45,2.02),(-0.32,-0.56,1.62),(-0.25,-0.50,1.33)],0.09,"Hair_Dark")
hcurve("Bang_2",[(-0.12,-0.50,2.06),(-0.02,-0.58,1.62),(0.08,-0.52,1.40)],0.08,"Hair_Dark")
hcurve("Bang_3",[(0.35,-0.46,2.0),(0.42,-0.52,1.65),(0.40,-0.45,1.38)],0.075,"Hair_Dark")
# signature white streak front-left
hcurve("Streak_Main",[(0.12,-0.50,2.08),(0.24,-0.57,1.68),(0.34,-0.51,1.38)],0.105,"Hair_White")
hcurve("Streak_Baby",[(0.02,-0.52,2.05),(0.12,-0.58,1.70)],0.05,"Hair_White")
# wavy sides
hcurve("Wavy_L",[(-0.65,-0.10,1.92),(-0.77,-0.20,1.52),(-0.60,-0.15,1.08)],0.11,"Hair_Dark")
hcurve("Wavy_R",[(0.65,-0.10,1.92),(0.77,-0.20,1.52),(0.60,-0.15,1.08)],0.11,"Hair_Dark")
hcurve("Wavy_L2",[(-0.55,0.15,1.85),(-0.68,0.10,1.45),(-0.55,0.15,1.10)],0.08,"Hair_Dark")
print("STEP3_DONE")
