import bpy, math
def cube(name,loc,scale,mat,rot=(0,0,0)):
    bpy.ops.mesh.primitive_cube_add(location=loc,rotation=rot)
    o=bpy.context.active_object; o.name=name; o.scale=scale
    o.data.materials.append(bpy.data.materials[mat]); return o
def cyl(name,loc,r,d,rot,mat):
    bpy.ops.mesh.primitive_cylinder_add(radius=r,depth=d,location=loc,rotation=rot,vertices=32)
    o=bpy.context.active_object; o.name=name
    o.data.materials.append(bpy.data.materials[mat]); return o
def sph(name,loc,scale,mat):
    bpy.ops.mesh.primitive_uv_sphere_add(segments=24,ring_count=12,radius=1,location=loc)
    o=bpy.context.active_object; o.name=name; o.scale=scale
    o.data.materials.append(bpy.data.materials[mat]); return o
# tank top over torso - slightly larger white shell
top=cyl("Top",(0,0,0.48),0.45,0.85,(0,0,0),"Top_White"); top.scale.x=1.18
# keyhole illusion
sph("Keyhole",(0,-0.40,0.65),(0.14,0.05,0.18),"Skin")
# choker + strap + buckle
cyl("Choker",(0,0,1.02),0.185,0.09,(0,0,0),"Black")
cube("Strap",(-0.18,-0.42,0.60),(0.05,0.04,0.36),"Black")
cube("Buckle",(-0.18,-0.45,0.60),(0.075,0.025,0.095),"Black")
# belt hint at waist
cyl("Belt",(0,0,0.02),0.43,0.12,(0,0,0),"Black")
# right hand peace
cube("Hand_R",(0.85,-0.55,1.10),(0.12,0.14,0.12),"Skin")
# V fingers
f1=cyl("Finger_V1",(0.78,-0.60,1.45),0.035,0.42,(0.2,0,0.1),"Skin")
f2=cyl("Finger_V2",(0.95,-0.60,1.45),0.035,0.42,(0.2,0,-0.1),"Skin")
# folded fingers
cube("Fold_R",(0.86,-0.52,1.02),(0.10,0.08,0.08),"Skin")
sph("Nail1",(0.78,-0.60,1.68),(0.042,0.042,0.055),"Nail")
sph("Nail2",(0.95,-0.60,1.68),(0.042,0.042,0.055),"Nail")
sph("Nail3",(0.86,-0.62,1.28),(0.04,0.04,0.05),"Nail")
# fingerless glove
cube("Glove",(0.85,-0.55,1.03),(0.145,0.155,0.19),"Black")
# left hand relaxed (off-screen lower)
cube("Hand_L",(-0.78,0, -0.05),(0.11,0.13,0.11),"Skin")
print("STEP4_DONE")
