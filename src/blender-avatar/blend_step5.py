import bpy, math, os
# lights
bpy.ops.object.light_add(type='SUN',location=(2,-2,4)); bpy.context.active_object.data.energy=3.0
bpy.ops.object.light_add(type='AREA',location=(-2,-2,2.5)); a=bpy.context.active_object; a.data.energy=250; a.data.color=(1,0.8,0.9)
bpy.ops.object.light_add(type='AREA',location=(2,1,1.5)); b=bpy.context.active_object; b.data.energy=120; b.data.color=(0.6,0.8,1.0)
# camera matching ref: front slightly below, closeup
bpy.ops.object.camera_add(location=(0,-3.1,1.35),rotation=(math.radians(82),0,0))
cam=bpy.context.active_object; bpy.context.scene.camera=cam; cam.data.lens=50
# world dark purple like ref
w=bpy.context.scene.world; w.use_nodes=True; bg=w.node_tree.nodes.get('Background')
bg.inputs['Color'].default_value=(0.18,0.16,0.28,1); bg.inputs['Strength'].default_value=1.0
bpy.context.scene.render.engine='BLENDER_EEVEE'; bpy.context.scene.render.resolution_x=1024; bpy.context.scene.render.resolution_y=1024
bpy.context.scene.render.film_transparent=False
out=r"C:\Users\Administrator\Documents\Default Project\anime_girl_render.png"
bpy.context.scene.render.filepath=out; bpy.ops.render.render(write_still=True)
blend=r"C:\Users\Administrator\Documents\Default Project\anime_girl.blend"
bpy.ops.wm.save_as_mainfile(filepath=blend)
print(f"DONE_RENDER {out} {blend}")
