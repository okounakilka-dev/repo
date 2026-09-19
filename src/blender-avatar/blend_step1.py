import bpy
# clear
bpy.ops.object.select_all(action='SELECT')
bpy.ops.object.delete()
# materials
def mkmat(name, col, rough=0.6, metal=0.0):
    m=bpy.data.materials.new(name)
    m.use_nodes=True
    b=m.node_tree.nodes.get('Principled BSDF')
    b.inputs['Base Color'].default_value=(*col,1)
    b.inputs['Roughness'].default_value=rough
    try: b.inputs['Metallic'].default_value=metal
    except: pass
    return m
mkmat("Skin",(0.96,0.76,0.77),0.55)
mkmat("Blush",(0.95,0.42,0.55),0.8)
mkmat("Hair_Dark",(0.10,0.17,0.22),0.45)
mkmat("Hair_White",(0.88,0.88,0.95),0.5)
mkmat("Eye",(0.07,0.11,0.15),0.15)
mkmat("Highlight",(1,1,1),0.1)
mkmat("Top_White",(0.90,0.90,0.95),0.7)
mkmat("Black",(0.05,0.06,0.07),0.4)
mkmat("Nail",(0.02,0.02,0.03),0.3)
print("STEP1_DONE")
