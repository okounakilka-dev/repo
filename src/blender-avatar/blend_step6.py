import bpy, math
cam=bpy.data.objects.get("Camera")
if cam:
    cam.location=(0,-4.5,1.6)
    cam.rotation_euler=(math.radians(82),0,0)
    cam.data.lens=70
    bpy.context.scene.camera=cam
# lift bangs slightly forward to reveal eyes
for n,dz,dy in [("Bang_1",0.05, -0.05),("Bang_2",0.05,-0.05),("Streak_Main",0.08,-0.08)]:
    o=bpy.data.objects.get(n)
    if o: o.location.z+=dz; o.location.y+=dy
# shrink hair tubes a bit
for n in ["Bang_1","Bang_2","Bang_3","Streak_Main","Wavy_L","Wavy_R"]:
    o=bpy.data.objects.get(n)
    if o and o.type=='CURVE': o.data.bevel_depth*=0.85
bpy.context.scene.render.filepath=r"C:\Users\Administrator\Documents\Default Project\anime_girl_render2.png"
bpy.ops.render.render(write_still=True)
bpy.ops.wm.save_as_mainfile(filepath=r"C:\Users\Administrator\Documents\Default Project\anime_girl.blend")
print("REFINE_DONE")
