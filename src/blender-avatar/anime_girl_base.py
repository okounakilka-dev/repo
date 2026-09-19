"""
Anime Girl Base - from reference image
Run in Blender: Scripting workspace > Open > Run Script
Blender 3.6+ / 4.x

Creates a blockout matching the reference:
- short wavy bob, dark teal-black + white front streak
- pale pink skin, blush, large dark eyes
- white ribbed tank + keyhole + black strap/buckle + choker
- black fingerless glove + peace-sign hand + black nails

This is a BASE, not a final sculpt. Sculpt/proportion after running.
"""

import bpy
import math

# ---------- utils ----------
def clear_scene():
    bpy.ops.object.select_all(action='SELECT')
    bpy.ops.object.delete(use_global=False)
    for coll in [bpy.data.meshes, bpy.data.materials, bpy.data.curves]:
        for x in list(coll):
            try:
                coll.remove(x)
            except:
                pass

def mat(name, color, roughness=0.6, metallic=0.0):
    m = bpy.data.materials.new(name)
    m.use_nodes = True
    bsdf = m.node_tree.nodes.get('Principled BSDF')
    bsdf.inputs['Base Color'].default_value = (*color, 1)
    bsdf.inputs['Roughness'].default_value = roughness
    if 'Metallic' in bsdf.inputs:
        bsdf.inputs['Metallic'].default_value = metallic
    return m

def prim_uv(name, loc, scale, material=None):
    bpy.ops.mesh.primitive_uv_sphere_add(radius=1, location=loc)
    o = bpy.context.active_object
    o.name = name
    o.scale = scale
    if material:
        o.data.materials.append(material)
    return o

def prim_cube(name, loc, scale, material=None):
    bpy.ops.mesh.primitive_cube_add(location=loc)
    o = bpy.context.active_object
    o.name = name
    o.scale = scale
    if material:
        o.data.materials.append(material)
    return o

def prim_cyl(name, loc, radius, depth, rot=(0,0,0), material=None):
    bpy.ops.mesh.primitive_cylinder_add(radius=radius, depth=depth, location=loc, rotation=rot)
    o = bpy.context.active_object
    o.name = name
    if material:
        o.data.materials.append(material)
    return o

def hair_curve(name, points, radius, material):
    curve_data = bpy.data.curves.new(name+'_data', type='CURVE')
    curve_data.dimensions = '3D'
    curve_data.resolution_u = 6
    spline = curve_data.splines.new('BEZIER')
    spline.bezier_points.add(len(points)-1)
    for i, pt in enumerate(points):
        bp = spline.bezier_points[i]
        bp.co = pt
        bp.handle_left_type = 'AUTO'
        bp.handle_right_type = 'AUTO'
    curve_data.bevel_depth = radius
    curve_data.bevel_resolution = 4
    obj = bpy.data.objects.new(name, curve_data)
    bpy.context.collection.objects.link(obj)
    obj.data.materials.append(material)
    return obj

clear_scene()

# ---------- materials ----------
skin = mat("Skin", (0.96, 0.78, 0.78), 0.55)
blush = mat("Blush", (0.95, 0.45, 0.55), 0.8)
hair_dark = mat("Hair_Dark", (0.12, 0.19, 0.24), 0.45)
hair_streak = mat("Hair_White", (0.88, 0.88, 0.95), 0.5)
eye_dark = mat("Eye", (0.08, 0.12, 0.16), 0.15)
top_white = mat("Top_White", (0.9, 0.9, 0.95), 0.7)
black_leather = mat("Black_Leather", (0.05, 0.06, 0.07), 0.4, 0.1)
nail_mat = mat("Nail", (0.02, 0.02, 0.03), 0.3)

# ---------- head / torso blockout ----------
head = prim_uv("Head", (0, 0, 1.6), (0.55, 0.5, 0.6), skin)

# eyes - large anime, flattened spheres slightly forward
eye_L = prim_uv("Eye_L", (-0.22, -0.42, 1.62), (0.16, 0.08, 0.2), eye_dark)
eye_R = prim_uv("Eye_R", (0.22, -0.42, 1.62), (0.16, 0.08, 0.2), eye_dark)

# eye highlights
hl_mat = mat("Highlight", (1,1,1), 0.1)
hl_L = prim_uv("HL_L", (-0.18, -0.5, 1.68), (0.04,0.03,0.04), hl_mat)
hl_R = prim_uv("HL_R", (0.26, -0.5, 1.68), (0.04,0.03,0.04), hl_mat)

# blush planes
blush_L = prim_cube("Blush_L", (-0.32, -0.42, 1.45), (0.12,0.02,0.08), blush)
blush_R = prim_cube("Blush_R", (0.32, -0.42, 1.45), (0.12,0.02,0.08), blush)

# neck + torso
neck = prim_cyl("Neck", (0,0,1.05), 0.15, 0.3, material=skin)
torso = prim_cyl("Torso", (0,0,0.45), 0.42, 0.9, material=top_white)
torso.scale.x = 1.15

# keyhole cutout illusion - dark inset + white rim
hole = prim_uv("Keyhole", (0,-0.38,0.65), (0.14,0.05,0.18), skin)

# choker + strap + buckle
choker = prim_cyl("Choker", (0,0,1.02), 0.18, 0.08, material=black_leather)
strap = prim_cube("Strap", (-0.18,-0.4,0.6), (0.05,0.03,0.35), black_leather)
buckle = prim_cube("Buckle", (-0.18,-0.43,0.6), (0.07,0.02,0.09), black_leather)

# shoulders / arms - left arm down, right arm up for peace sign
shoulder_L = prim_uv("Shoulder_L", (-0.55,0,0.75), (0.22,0.22,0.25), skin)
arm_L = prim_cyl("Arm_L", (-0.7,0,0.3), 0.14, 0.8, rot=(0,0,0.3), material=skin)

shoulder_R = prim_uv("Shoulder_R", (0.55,0,0.75), (0.22,0.22,0.25), skin)
# right forearm raised toward camera
arm_R_up = prim_cyl("Arm_R_Up", (0.7,-0.2,0.7), 0.13, 0.9, rot=(0.6,0,-0.3), material=skin)

# hand + peace fingers
hand = prim_cube("Hand_R", (0.85,-0.55,1.1), (0.12,0.14,0.12), skin)
finger1 = prim_cyl("Finger_V1", (0.78,-0.6,1.45), 0.035, 0.4, rot=(0.2,0,0.1), material=skin)
finger2 = prim_cyl("Finger_V2", (0.95,-0.6,1.45), 0.035, 0.4, rot=(0.2,0,-0.1), material=skin)
# black nails tips
nail1 = prim_uv("Nail1", (0.78,-0.6,1.67), (0.04,0.04,0.05), nail_mat)
nail2 = prim_uv("Nail2", (0.95,-0.6,1.67), (0.04,0.04,0.05), nail_mat)

# fingerless glove
glove = prim_cube("Glove", (0.85,-0.55,1.05), (0.14,0.15,0.18), black_leather)

# ---------- hair - bob volume + bangs curves ----------
hair_main = prim_uv("Hair_Main", (0,0.1,1.75), (0.72,0.68,0.7), hair_dark)

# side bobs
hair_L = prim_uv("Hair_Side_L", (-0.6,0.05,1.45), (0.3,0.32,0.45), hair_dark)
hair_R = prim_uv("Hair_Side_R", (0.6,0.05,1.45), (0.3,0.32,0.45), hair_dark)
back_hair = prim_uv("Hair_Back", (0,0.35,1.5), (0.65,0.4,0.55), hair_dark)

# bangs strands with curves - front covering eye like ref
hair_curve("Bang_1", [(-0.4,-0.45,2.0), (-0.3,-0.55,1.6), (-0.25,-0.5,1.35)], 0.09, hair_dark)
hair_curve("Bang_2", [(-0.1,-0.5,2.05), (0.0,-0.58,1.6), (0.1,-0.52,1.4)], 0.08, hair_dark)
# white streak - signature left streak
hair_curve("Streak", [(0.15,-0.48,2.05), (0.25,-0.55,1.65), (0.35,-0.5,1.4)], 0.1, hair_streak)
hair_curve("SideWavy_L", [(-0.65,-0.1,1.9), (-0.75,-0.2,1.5), (-0.6,-0.15,1.1)], 0.11, hair_dark)
hair_curve("SideWavy_R", [(0.65,-0.1,1.9), (0.75,-0.2,1.5), (0.6,-0.15,1.1)], 0.11, hair_dark)

# ---------- toon look + light ----------
# Eevee toon-ish: add Shader to RGB would need manual, set render to Eevee
for o in [head, hair_main, hair_L, hair_R]:
    o.data.polygons.foreach_set('use_smooth', [True]*len(o.data.polygons))

# camera + light
bpy.ops.object.camera_add(location=(0,-3.2,1.4), rotation=(math.radians(80),0,0))
bpy.context.scene.camera = bpy.context.active_object
bpy.ops.object.light_add(type='SUN', location=(2,-2,4))
sun = bpy.context.active_object
sun.data.energy = 3.0
bpy.ops.object.light_add(type='AREA', location=(-2,-2,2))
fill = bpy.context.active_object
fill.data.energy = 200
fill.data.color = (1,0.8,0.9)

bpy.context.scene.render.engine = 'BLENDER_EEVEE'
bpy.context.scene.render.resolution_x = 1024
bpy.context.scene.render.resolution_y = 1024

print("DONE: base blockout created. Next: Sculpt mode for face/hair, add Subdiv + Solidify for top, weight paint streak.")
