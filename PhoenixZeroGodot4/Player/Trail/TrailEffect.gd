extends MeshInstance3D
class_name Trail3D

var _points = []
var _widths = []
var _lifePoints = []

var test = 0

@export var _enabled : bool = true

@export var _fromWidth : float = 0.5
@export var _toWidth : float = 0.0
@export_range(0.5, 1.5) var _scaleAcceleration : float = 1.0

@export var _motionDelta : float = 0.1
@export var _lifespan : float = 1.0

@export_enum("DEFAULT", "TRIANGLE", "LINES", "LINE_STRIP", "POINTS") var type : int = 0

@export var scaleTexture : bool = false

@export var _startColor : Color = Color(1.0, 1.0, 1.0, 1.0)
@export var _endColor : Color = Color(1.0, 1.0, 1.0, 0.0)

var _oldPos : Vector3

func _ready():
	_oldPos = get_global_transform().origin
	mesh = ImmediateMesh.new()

func AppendPoint():
	_points.append(get_global_transform().origin)
	_widths.append([
		get_global_transform().basis.y * _fromWidth,
		get_global_transform().basis.y * _fromWidth - get_global_transform().basis.y * _toWidth
	])
	_lifePoints.append(0.0)
	
func RemovePoint(i):
	_points.remove_at(i)
	_widths.remove_at(i)
	_lifePoints.remove_at(i)
	
func _physics_process(delta):
	test+=0.006
	
	
#	if not get_parent().visible:
#		visible = false
#	else:
#		visible = true
	
	if (_oldPos - get_global_transform().origin).length() > _motionDelta and _enabled:
		AppendPoint()
		_oldPos = get_global_transform().origin
		
	var p = 0
	var max_points = _points.size()
	while p < max_points:
		_lifePoints[p] += delta
		if _lifePoints[p] > _lifespan:
			RemovePoint(p)
			p -= 1
			if (p < 0): p = 0
		
		max_points = _points.size()
		p += 1
	
	mesh.clear_surfaces()
	
	if _points.size() < 2:
		return
	
	if type == 1:
		mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLES)
	elif type == 2:
		mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	elif type == 3:
		mesh.surface_begin(Mesh.PRIMITIVE_LINE_STRIP)
	elif type == 4:
		mesh.surface_begin(Mesh.PRIMITIVE_POINTS)
	else:
		mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLE_STRIP)
#	mesh.surface_begin(Mesh.PRIMITIVE_POINTS)
#	mesh.surface_begin(Mesh.PRIMITIVE_LINES)
#	mesh.surface_begin(Mesh.PRIMITIVE_LINE_STRIP)
#	mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLES)
#	mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLE_STRIP)
	for i in range(_points.size()):
		var t = float(i) / (_points.size() - 1.0)
		var currColor = _startColor.lerp(_endColor, 1 - t)
		mesh.surface_set_color(currColor)
		
		var currWidth = _widths[i][0] - pow(1 - t, _scaleAcceleration) * _widths[i][1]
		
		var t0
		var t1
		if scaleTexture:
#			t0 = _motionDelta * test*5
#			t1 = _motionDelta * (test)*10
			t0 = _motionDelta * i * test
			t1 = _motionDelta * (i + 1) * test
			if test > 0.19:
				test = 0
			mesh.surface_set_uv(Vector2(t0, 0))
			mesh.surface_add_vertex(to_local(_points[i] + currWidth))
			mesh.surface_set_uv(Vector2(t1, 1))
			mesh.surface_add_vertex(to_local(_points[i] - currWidth))
		else:
			t0 = i / _points.size()
			t1 = t
			mesh.surface_set_uv(Vector2(t0, 0))
			mesh.surface_add_vertex(to_local(_points[i] + currWidth))
			mesh.surface_set_uv(Vector2(t1, 1))
			mesh.surface_add_vertex(to_local(_points[i] - currWidth))
			
		
	mesh.surface_end()







