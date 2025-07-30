class_name BattleActor extends Resource

signal hp_changed(hp, hp_max, amount_change)

@export var name: String = ""
@export var hp_max: int = 1
@export var ca: int = 10


var defense := false
var hp: int = hp_max

func init() -> void:
	hp = hp_max

func copy() -> BattleActor:
	var dup: BattleActor = duplicate()
	dup.init()
	return dup

func change_defense(value: bool) -> void:
	defense = value

func log(msg: String) -> void:
	print(msg)
	if Globals.log_func:
		Globals.log_func.call(msg)

func healhurt(value: int, is_npc: bool = false) -> void:
	var rng := RandomNumberGenerator.new()
	var coeficiente = rng.randi_range(1, 20) # aleatoriedade de um dado de 20 lados
	
	var ataque_valido := false
	if is_npc:
		var npc_threshold = Globals.npc_threshold if Globals.npc_threshold > 0 else self.ca
		print("NPC rolou: %d (precisa ser maior ou igual a %d)" % [coeficiente, npc_threshold])
		Globals.log_message("NPC rolou: %d (precisa ser maior ou igual a %d)" % [coeficiente, npc_threshold])
		if coeficiente >= npc_threshold:
			ataque_valido = true
		else:
			print(("NPC errou o ataque!"))
			Globals.log_message("NPC errou o ataque!")
	else:
		if coeficiente % 2 == 0:
			ataque_valido = true
		else:
			print("Player errou o ataque!")
			Globals.log_message("Player errou o ataque!")

	if ataque_valido:
		if not defense:
			var previous_hp: int = hp
			hp += value
			hp = clampi(hp, 0, hp_max)
			hp_changed.emit(hp, hp_max, previous_hp - hp)
			print("%s sofreu dano! HP agora: %d" % [name, hp])
			Globals.log_message("%s sofreu dano! HP agora: %d" % [name, hp])
		else:
			print("%s está protegido! Nenhum dano recebido" % name)
			Globals.log_message("%s está protegido! Nenhum dano recebido" % name)
