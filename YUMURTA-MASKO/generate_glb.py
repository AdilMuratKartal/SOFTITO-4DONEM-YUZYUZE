#!/usr/bin/env python3
"""
Yumurta Maskot (Egg Mascot) 3D GLB Model Generator
Cross-platform glTF 2.0 Binary (.glb) generator using pure Python standard library.
Produces a ready-to-use 3D model compatible with Flutter (iOS, Android, macOS, Windows).
"""

import json
import math
import struct
import zlib


def create_png_texture(width=512, height=512):
    """Generates an uncompressed/deflated RGBA PNG in pure Python with face details."""
    raw_rows = []
    
    # Precompute center and features
    cx, cy = width / 2.0, height / 2.0
    
    for y in range(height):
        row = bytearray([0]) # Filter type 0 (None)
        for x in range(width):
            # Base yolk yellow
            r, g, b, a = 255, 195, 46, 255
            
            # Distance from center for radial gradient
            dx = (x - cx) / cx
            dy = (y - cy) / cy
            dist = math.sqrt(dx * dx + dy * dy)
            if dist < 1.0:
                shade = 1.0 - 0.15 * dist
                r = int(255 * shade)
                g = int(195 * shade)
                b = int(46 * shade)
                
            # Rosy Blushing Cheeks
            # Left cheek ~ (0.28*width, 0.58*height), Right cheek ~ (0.72*width, 0.58*height)
            for cheek_x, cheek_y in [(width * 0.28, height * 0.58), (width * 0.72, height * 0.58)]:
                cdist = math.hypot(x - cheek_x, y - cheek_y) / (width * 0.12)
                if cdist < 1.0:
                    alpha_blush = (1.0 - cdist) * 0.65
                    r = int(r * (1 - alpha_blush) + 255 * alpha_blush)
                    g = int(g * (1 - alpha_blush) + 95 * alpha_blush)
                    b = int(b * (1 - alpha_blush) + 125 * alpha_blush)
            
            # Heart Eyes
            # Left eye ~ (0.36*width, 0.46*height), Right eye ~ (0.64*width, 0.46*height)
            eye_color = (46, 25, 21) # Dark chocolate
            for ex, ey in [(width * 0.36, height * 0.46), (width * 0.64, height * 0.46)]:
                # Parametric heart coordinate check
                hx = (x - ex) / (width * 0.055)
                hy = -(y - ey) / (height * 0.055) # inverted Y
                # Heart equation: (x^2 + y^2 - 1)^3 - x^2 * y^3 <= 0
                val = (hx*hx + hy*hy - 0.7)**3 - (hx*hx)*(hy*hy*hy)
                if val <= 0.0:
                    # Eye highlight
                    if math.hypot(hx + 0.25, hy - 0.25) < 0.2:
                        r, g, b = 255, 255, 255
                    else:
                        r, g, b = eye_color

            # Cute smiling mouth: Arc near center bottom
            mx = (x - cx) / (width * 0.08)
            my = (y - height * 0.50) / (height * 0.06)
            # circle arc y = mx^2
            if abs(my - mx*mx) < 0.18 and abs(mx) < 0.8 and my >= 0:
                r, g, b = eye_color

            row.extend([r, g, b, a])
        raw_rows.append(bytes(row))
        
    raw_data = b"".join(raw_rows)
    compressed = zlib.compress(raw_data)
    
    def png_chunk(chunk_type, data):
        c = chunk_type + data
        crc = zlib.crc32(c) & 0xffffffff
        return struct.pack(">I", len(data)) + c + struct.pack(">I", crc)
    
    png_header = b"\x89PNG\r\n\x1a\n"
    ihdr_data = struct.pack(">IIBBBBB", width, height, 8, 6, 0, 0, 0)
    ihdr = png_chunk(b"IHDR", ihdr_data)
    idat = png_chunk(b"IDAT", compressed)
    iend = png_chunk(b"IEND", b"")
    
    return png_header + ihdr + idat + iend


class MeshBuilder:
    def __init__(self):
        self.vertices = []
        self.normals = []
        self.uvs = []
        self.indices = []
        
    def add_vertex(self, x, y, z, nx=0.0, ny=1.0, nz=0.0, u=0.0, v=0.0):
        idx = len(self.vertices)
        self.vertices.append((x, y, z))
        self.normals.append((nx, ny, nz))
        self.uvs.append((u, v))
        return idx

    def add_triangle(self, i1, i2, i3):
        self.indices.extend([i1, i2, i3])

    def add_sphere(self, radius, rings, sectors, cx=0, cy=0, cz=0, scale_x=1.0, scale_y=1.0, scale_z=1.0, egg_taper=0.0):
        start_idx = len(self.vertices)
        for r in range(rings + 1):
            theta = r * math.pi / rings
            sin_t = math.sin(theta)
            cos_t = math.cos(theta)
            
            for s in range(sectors + 1):
                phi = s * 2 * math.pi / sectors
                sin_p = math.sin(phi)
                cos_p = math.cos(phi)
                
                # Base sphere coordinate
                vx = cos_p * sin_t
                vy = cos_t
                vz = sin_p * sin_t
                
                # Egg taper: narrower at top (vy > 0), wider at bottom (vy < 0)
                taper = 1.0 - egg_taper * vy
                
                x = cx + vx * radius * scale_x * taper
                y = cy + vy * radius * scale_y
                z = cz + vz * radius * scale_z * taper
                
                u = s / sectors
                v = r / rings
                
                # Approximate normal
                nx = vx * taper
                ny = vy
                nz = vz * taper
                nlen = math.hypot(nx, ny, nz) or 1.0
                
                self.add_vertex(x, y, z, nx/nlen, ny/nlen, nz/nlen, u, v)
                
        for r in range(rings):
            for s in range(sectors):
                i1 = start_idx + r * (sectors + 1) + s
                i2 = start_idx + (r + 1) * (sectors + 1) + s
                i3 = start_idx + (r + 1) * (sectors + 1) + (s + 1)
                i4 = start_idx + r * (sectors + 1) + (s + 1)
                self.add_triangle(i1, i2, i3)
                self.add_triangle(i1, i3, i4)

    def add_cylinder(self, r_top, r_bottom, height, segments, cx=0, cy=0, cz=0):
        start_idx = len(self.vertices)
        half_h = height / 2.0
        
        # Rings around cylinder
        for s in range(segments + 1):
            phi = s * 2 * math.pi / segments
            cp = math.cos(phi)
            sp = math.sin(phi)
            u = s / segments
            
            # Bottom vertex
            self.add_vertex(cx + cp * r_bottom, cy - half_h, cz + sp * r_bottom, cp, 0.0, sp, u, 0.0)
            # Top vertex
            self.add_vertex(cx + cp * r_top, cy + half_h, cz + sp * r_top, cp, 0.0, sp, u, 1.0)
            
        for s in range(segments):
            b1 = start_idx + s * 2
            t1 = start_idx + s * 2 + 1
            b2 = start_idx + (s + 1) * 2
            t2 = start_idx + (s + 1) * 2 + 1
            self.add_triangle(b1, b2, t2)
            self.add_triangle(b1, t2, t1)

    def add_horn(self, is_left, segments=16):
        """Constructs a curved cute horn."""
        curve_pts = [
            (0.0, 0.0, 0.0, 0.08),
            ((-0.04 if is_left else 0.04), 0.10, -0.01, 0.065),
            ((-0.09 if is_left else 0.09), 0.20, -0.03, 0.045),
            ((-0.13 if is_left else 0.13), 0.30, -0.06, 0.015),
        ]
        base_x = -0.26 if is_left else 0.26
        base_y = 0.95
        base_z = 0.02
        
        for k in range(len(curve_pts) - 1):
            p1 = curve_pts[k]
            p2 = curve_pts[k+1]
            self.add_cylinder(
                r_bottom=p1[3], r_top=p2[3],
                height=p2[1] - p1[1], segments=segments,
                cx=base_x + (p1[0] + p2[0])/2,
                cy=base_y + (p1[1] + p2[1])/2,
                cz=base_z + (p1[2] + p2[2])/2
            )

    def add_heart(self, cx=0, cy=1.45, cz=0, scale=0.32):
        """Parametric 3D red heart above head."""
        steps = 28
        pts_front = []
        pts_back = []
        start_idx = len(self.vertices)
        
        for i in range(steps):
            t = i * 2 * math.pi / steps
            # 2D heart curve
            hx = 16 * (math.sin(t) ** 3)
            hy = 13 * math.cos(t) - 5 * math.cos(2*t) - 2 * math.cos(3*t) - math.cos(4*t)
            hx *= (scale / 17.0)
            hy *= (scale / 17.0)
            
            # Front face ring
            self.add_vertex(cx + hx, cy + hy, cz + 0.04, 0.0, 0.0, 1.0, 0.5, 0.5)
            # Back face ring
            self.add_vertex(cx + hx, cy + hy, cz - 0.04, 0.0, 0.0, -1.0, 0.5, 0.5)
            
        # Center front & back
        c_front = self.add_vertex(cx, cy, cz + 0.07, 0.0, 0.0, 1.0, 0.5, 0.5)
        c_back = self.add_vertex(cx, cy, cz - 0.07, 0.0, 0.0, -1.0, 0.5, 0.5)
        
        for i in range(steps):
            next_i = (i + 1) % steps
            f1 = start_idx + i * 2
            b1 = start_idx + i * 2 + 1
            f2 = start_idx + next_i * 2
            b2 = start_idx + next_i * 2 + 1
            
            # Front fan
            self.add_triangle(c_front, f1, f2)
            # Back fan
            self.add_triangle(c_back, b2, b1)
            # Side bridge
            self.add_triangle(f1, b1, b2)
            self.add_triangle(f1, b2, f2)


def build_mascot_glb(output_path="yumurta_maskot.glb"):
    print("🥚 Yumurta Maskot 3D GLB modeli oluşturuluyor...")
    
    # 1. Meshes
    # Part 1: White Body (Egg body, horns, arms, legs)
    white_mesh = MeshBuilder()
    # Main egg body
    white_mesh.add_sphere(radius=0.72, rings=36, sectors=44, cy=0.28, scale_x=1.02, scale_y=1.22, scale_z=0.96, egg_taper=0.22)
    # Horns
    white_mesh.add_horn(is_left=True)
    white_mesh.add_horn(is_left=False)
    # Arms (marshmallow style)
    for is_left in [True, False]:
        ax = -0.58 if is_left else 0.58
        white_mesh.add_sphere(0.12, 16, 16, cx=ax, cy=0.28, cz=0.05)
        white_mesh.add_cylinder(0.12, 0.13, 0.38, 16, cx=ax, cy=0.10, cz=0.05)
        white_mesh.add_sphere(0.13, 16, 16, cx=ax, cy=-0.08, cz=0.05)
    # Legs (short stubby pillar legs)
    for is_left in [True, False]:
        lx = -0.22 if is_left else 0.22
        white_mesh.add_cylinder(0.15, 0.16, 0.36, 20, cx=lx, cy=-0.65, cz=0.0)
        white_mesh.add_sphere(0.16, 16, 20, cx=lx, cy=-0.80, cz=0.02, scale_y=0.6, scale_z=1.1)

    # Part 2: Yolk Face with texture mapping
    yolk_mesh = MeshBuilder()
    yolk_mesh.add_sphere(radius=0.42, rings=28, sectors=36, cy=0.38, cz=0.30, scale_x=0.98, scale_y=0.98, scale_z=0.60)

    # Part 3: Floating Red Heart
    heart_mesh = MeshBuilder()
    heart_mesh.add_heart(cy=1.46, scale=0.35)

    # 2. Textures
    png_data = create_png_texture(512, 512)

    # 3. Pack binary buffer
    bin_buffer = bytearray()
    
    def append_data(data, alignment=4):
        offset = len(bin_buffer)
        bin_buffer.extend(data)
        pad = (alignment - (len(bin_buffer) % alignment)) % alignment
        bin_buffer.extend(b"\x00" * pad)
        return offset, len(data)

    buffer_views = []
    accessors = []

    def register_mesh(mb):
        # Positions
        pos_bytes = struct.pack(f"<{len(mb.vertices)*3}f", *[coord for v in mb.vertices for coord in v])
        min_pos = [min(v[i] for v in mb.vertices) for i in range(3)]
        max_pos = [max(v[i] for v in mb.vertices) for i in range(3)]
        offset, length = append_data(pos_bytes)
        bv_pos = len(buffer_views)
        buffer_views.append({"buffer": 0, "byteOffset": offset, "byteLength": length, "target": 34962})
        acc_pos = len(accessors)
        accessors.append({
            "bufferView": bv_pos, "byteOffset": 0, "componentType": 5126, # FLOAT
            "count": len(mb.vertices), "type": "VEC3", "min": min_pos, "max": max_pos
        })

        # Normals
        norm_bytes = struct.pack(f"<{len(mb.normals)*3}f", *[coord for n in mb.normals for coord in n])
        offset, length = append_data(norm_bytes)
        bv_norm = len(buffer_views)
        buffer_views.append({"buffer": 0, "byteOffset": offset, "byteLength": length, "target": 34962})
        acc_norm = len(accessors)
        accessors.append({
            "bufferView": bv_norm, "byteOffset": 0, "componentType": 5126,
            "count": len(mb.normals), "type": "VEC3"
        })

        # UVs
        uv_bytes = struct.pack(f"<{len(mb.uvs)*2}f", *[coord for uv in mb.uvs for coord in uv])
        offset, length = append_data(uv_bytes)
        bv_uv = len(buffer_views)
        buffer_views.append({"buffer": 0, "byteOffset": offset, "byteLength": length, "target": 34962})
        acc_uv = len(accessors)
        accessors.append({
            "bufferView": bv_uv, "byteOffset": 0, "componentType": 5126,
            "count": len(mb.uvs), "type": "VEC2"
        })

        # Indices
        ind_bytes = struct.pack(f"<{len(mb.indices)}H", *mb.indices)
        offset, length = append_data(ind_bytes)
        bv_ind = len(buffer_views)
        buffer_views.append({"buffer": 0, "byteOffset": offset, "byteLength": length, "target": 34963})
        acc_ind = len(accessors)
        accessors.append({
            "bufferView": bv_ind, "byteOffset": 0, "componentType": 5123, # UNSIGNED_SHORT
            "count": len(mb.indices), "type": "SCALAR"
        })

        return acc_pos, acc_norm, acc_uv, acc_ind

    white_pos, white_norm, white_uv, white_ind = register_mesh(white_mesh)
    yolk_pos, yolk_norm, yolk_uv, yolk_ind = register_mesh(yolk_mesh)
    heart_pos, heart_norm, heart_uv, heart_ind = register_mesh(heart_mesh)

    # Texture buffer view
    tex_offset, tex_length = append_data(png_data)
    bv_tex = len(buffer_views)
    buffer_views.append({"buffer": 0, "byteOffset": tex_offset, "byteLength": tex_length})

    # GLTF JSON Structure
    gltf = {
        "asset": {"version": "2.0", "generator": "YumurtaMaskot GLB Generator"},
        "scene": 0,
        "scenes": [{"name": "Scene", "nodes": [0]}],
        "nodes": [
            {
                "name": "YumurtaMaskot_Root",
                "children": [1, 2, 3]
            },
            {"name": "Body_White", "mesh": 0},
            {"name": "Face_Yolk", "mesh": 1},
            {"name": "Heart_Accessory", "mesh": 2}
        ],
        "meshes": [
            {
                "name": "Mesh_WhiteBody",
                "primitives": [{
                    "attributes": {"POSITION": white_pos, "NORMAL": white_norm, "TEXCOORD_0": white_uv},
                    "indices": white_ind,
                    "material": 0
                }]
            },
            {
                "name": "Mesh_YolkFace",
                "primitives": [{
                    "attributes": {"POSITION": yolk_pos, "NORMAL": yolk_norm, "TEXCOORD_0": yolk_uv},
                    "indices": yolk_ind,
                    "material": 1
                }]
            },
            {
                "name": "Mesh_FloatingHeart",
                "primitives": [{
                    "attributes": {"POSITION": heart_pos, "NORMAL": heart_norm, "TEXCOORD_0": heart_uv},
                    "indices": heart_ind,
                    "material": 2
                }]
            }
        ],
        "materials": [
            {
                "name": "Material_WhiteEgg",
                "pbrMetallicRoughness": {
                    "baseColorFactor": [0.98, 0.97, 0.95, 1.0],
                    "metallicFactor": 0.04,
                    "roughnessFactor": 0.42
                }
            },
            {
                "name": "Material_YolkFace",
                "pbrMetallicRoughness": {
                    "baseColorTexture": {"index": 0},
                    "metallicFactor": 0.02,
                    "roughnessFactor": 0.35
                }
            },
            {
                "name": "Material_Heart",
                "pbrMetallicRoughness": {
                    "baseColorFactor": [1.0, 0.16, 0.33, 1.0],
                    "metallicFactor": 0.1,
                    "roughnessFactor": 0.22
                }
            }
        ],
        "textures": [{"sampler": 0, "source": 0}],
        "images": [{"bufferView": bv_tex, "mimeType": "image/png"}],
        "samplers": [{"magFilter": 9729, "minFilter": 9987, "wrapS": 10497, "wrapT": 10497}],
        "accessors": accessors,
        "bufferViews": buffer_views,
        "buffers": [{"byteLength": len(bin_buffer)}]
    }

    # GLB Packing
    json_bytes = json.dumps(gltf, separators=(',', ':')).encode('utf-8')
    # Pad JSON to 4-byte boundary with spaces
    json_pad = (4 - (len(json_bytes) % 4)) % 4
    json_bytes += b" " * json_pad

    # Pad BIN buffer to 4-byte boundary with zeros
    bin_pad = (4 - (len(bin_buffer) % 4)) % 4
    bin_buffer += b"\x00" * bin_pad

    total_length = 12 + (8 + len(json_bytes)) + (8 + len(bin_buffer))
    
    header = struct.pack("<4sII", b"glTF", 2, total_length)
    chunk0_header = struct.pack("<II", len(json_bytes), 0x4E4F534A) # JSON
    chunk1_header = struct.pack("<II", len(bin_buffer), 0x004E4942) # BIN

    with open(output_path, "wb") as f:
        f.write(header)
        f.write(chunk0_header)
        f.write(json_bytes)
        f.write(chunk1_header)
        f.write(bin_buffer)

    print(f"✅ Harika! '{output_path}' başarıyla oluşturuldu! ({len(json_bytes) + len(bin_buffer)} bayt)")


if __name__ == "__main__":
    build_mascot_glb("yumurta_maskot.glb")

