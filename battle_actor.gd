class_name BattleActor extends Resource

signal hp_changed(hp, hp_max, amount_change)

@export var name: String = ""
@export var hp_max: int = 1
@export var mp_max: int = 0

var defense := false
 
var hp: int = hp_max
var mp: int = mp_max


func init() -> void:
	hp = hp_max
	mp = mp_max

func copy() -> BattleActor:
	var dup: BattleActor = duplicate()
	dup.init()
	return dup

func change_defense(value: bool) -> void:
	defense = value

func healhurt(value: int, is_npc:bool = false) -> void:
	var rng := RandomNumberGenerator.new()
	var coeficiente = rng.randi_range(1,20) #aleatoriedade de um dado de 20 lados
	
	var ataque_valido := false
	if is_npc:
		const NPC_DIFFICULTY_THRESHOLD = 10
		var npc_threshold := NPC_DIFFICULTY_THRESHOLD
		print("NPC rolou: ", coeficiente, " (precisa ser PAR e < ", npc_threshold, ")")
		# NPC só acerta se for PAR e < 10
		if coeficiente % 2 == 0 and coeficiente < npc_threshold:
			ataque_valido = true
		else:
			print("NPC errou o ataque!")
	else:
		# Jogador acerta se for PAR
		if coeficiente % 2 == 0:
			ataque_valido = true
		else:
			print("Jogador errou o ataque!")

	if ataque_valido:
		if not defense:
			var previous_hp: int = hp
			hp += value
			hp = clampi(hp, 0, hp_max)
			hp_changed.emit(hp, hp_max, previous_hp - hp)
			print(name, " sofreu dano! HP agora: ", hp)
		else:
			print(name, " está protegido! Nenhum dano recebido")
	
