import bpy, math
M=lambda n: bpy.data.materials.get(n)
def sph(name,loc,scale,mat):
    bpy.ops.mesh.primitive_uv_sphere_add(segments=32,ring_count=16,radius=1,location=loc)
    o=bpy.context.active_object; o.name=name; o.scale=scale
    if mat: o.data.materials.append(bpy.data.materials[mat])
    return o
def cube(name,loc,scale,mat):
    bpy.ops.mesh.primitive_cube_add(location=loc)
    o=bpy.context.active_object; o.name=name; o.scale=scale
    if mat: o.data.materials.append(bpy.data.materials[mat])
    return o
def cyl(name,loc,r,d,rot,mat):
    bpy.ops.mesh.primitive_cylinder_add(radius=r,depth=d,location=loc,rotation=rot,vertices=32)
    o=bpy.context.active_object; o.name=name
    if mat: o.data.materials.append(bpy.data.materials[mat])
    return o
# head - anime shape: wider top, narrow chin via scaling vertices later, keep simple for now
head=sph("Head",(0,0,1.6),(0.55,0.5,0.6),"Skin")
# jaw taper: scale bottom verts
import bmesh
bm=bmesh.new(); bm.from_mesh(head.data)
for v in bm.verts:
    if v.co.z<-0.3:
        f=1.0-(-0.3-v.co.z)*0.55
        v.co.x*=max(0.55,f); v.co.y*=max(0.6,f)
bm.to_mesh(head.data); bm.free()
# eyes large
eyeL=sph("Eye_L",(-0.22,-0.42,1.62),(0.17,0.08,0.21),"Eye")
eyeR=sph("Eye_R",(0.22,-0.42,1.62),(0.17,0.08,0.21),"Eye")
sph("HL_L",(-0.17,-0.49,1.68),(0.045,0.03,0.045),"Highlight")
sph("HL_R",(0.27,-0.49,1.68),(0.045,0.03,0.045),"Highlight")
# upper lash - flattened cubes angled
lashL=cube("Lash_L",(-0.22,-0.46,1.78),(0.18,0.03,0.04),"Black")
lashL.rotation_euler=(math.radians(10),0,math.radians(-8))
lashR=cube("Lash_R",(0.22,-0.46,1.78),(0.18,0.03,0.04),"Black")
lashR.rotation_euler=(math.radians(10),0,math.radians(8))
# blush
cube("Blush_L",(-0.33,-0.41,1.45),(0.12,0.02,0.08),"Blush")
cube("Blush_R",(0.33,-0.41,1.45),(0.12,0.02,0.08),"Blush")
# small mouth
mouth=cube("Mouth",(0.02,-0.48,1.32),(0.07,0.02,0.02),"Blush")
# brows
browL=cube("Brow_L",(-0.22,-0.48,1.88),(0.14,0.02,0.025),"Hair_Dark")
browR=cube("Brow_R",(0.22,-0.48,1.88),(0.14,0.02,0.025),"Hair_Dark")
# neck torso
cyl("Neck",(0,0,1.05),0.15,0.3,(0,0,0),"Skin")
torso=cyl("Torso",(0,0,0.45),0.42,0.9,(0,0,0),"Skin")
torso.scale.x=1.15
# shoulders arms - lean pose: left down, right up toward cam
sph("Shoulder_L",(-0.55,0,0.75),(0.22,0.22,0.25),"Skin")
cyl("Arm_L",(-0.7,0,0.3),0.14,0.8,(0,0,0.3),"Skin")
sph("Shoulder_R",(0.55,0,0.75),(0.22,0.22,0.25),"Skin")
cyl("Arm_R_Up",(0.7,-0.2,0.7),0.13,0.9,(0.6,0,-0.3),"Skin")
for o in bpy.data.objects:
    if o.type=='MESH':
        try: 
            for p in o.data.polygons: p.use_smooth=True
        except: pass
print("STEP2_DONE")
