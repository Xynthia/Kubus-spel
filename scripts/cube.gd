class_name Cube
extends Node3D

@export var xSize : int
@export var ySize : int
@export var zSize : int

var mesh := ArrayMesh.new()
var vertices : Array[Vector3]

var cornerVertices : int = 8;
var edgeVertices : int = (xSize + ySize + zSize - 3) * 4;



func generate() -> void:
	mesh.name = "Procedural Cube";
	
	var faceVertices : int = (
		(xSize - 1) * (ySize - 1) +
		(xSize - 1) * (zSize - 1) +
		(ySize - 1) * (zSize - 1)
	) * 2
	
	vertices.append(Vector3(cornerVertices, edgeVertices, faceVertices))
	
	for v in vertices.size():
		for x in xSize:
			vertices[v] = Vector3(x, 0, 0)



func OnDrawGizmos (size) -> void:
	if (vertices == null): 
		return;
	
	for vertice in vertices: 
		var sphere = SphereMesh.new()
		sphere.radial_segments = 4
		sphere.rings = 4
		sphere.radius = size
		sphere.height = size * 2
		
		var material := Material.new()
		material.albedo_color = Color(1, 0, 0)
		material.flags_unshaded = true
		sphere.surface_set_material(0, material)
		
		sphere.position = vertice
