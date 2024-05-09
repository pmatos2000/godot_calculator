extends Control

const NAME_GROUP_botao := "botão"
const NAME_GROUP_DISPLAY := "display"
const NOME_SINAL_BOTAO_PRESSIONADO := "pressed"
const NAME_FUNC_BOTAO_PRESSIONADO := "_botao_pressionado"

var display: Label

enum IdNumero { Primeiro, Segundo}
var id_numero_atual := IdNumero.Primeiro

var lista_numeros: Array[String] = ["0", "0"]

func _atualizar_numero(novo_numero: String, id: IdNumero) ->  void:
	lista_numeros[id] = novo_numero
	display.text = novo_numero

func _add_digito(digito: String) -> void:
	if lista_numeros[id_numero_atual] == "0":
		_atualizar_numero(digito, id_numero_atual)
	else:
		var novo_numero := lista_numeros[id_numero_atual] + digito
		_atualizar_numero(novo_numero, id_numero_atual)

func _apagar_digito() -> void:
	lista_numeros[id_numero_atual] = lista_numeros[id_numero_atual].left(-1)
	if lista_numeros[id_numero_atual].is_empty():
		lista_numeros[id_numero_atual] = "0"

func _add_ponto() -> void:
	if not lista_numeros[id_numero_atual].contains("."):
		var novo_numero = lista_numeros[id_numero_atual] + "."
		_atualizar_numero(novo_numero, id_numero_atual)

func _botao_pressionado(botao_name: String) -> void:
	match botao_name:
		"0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
			_add_digito(botao_name)
		"Backspace":
			_apagar_digito()
		"Ponto":
			_add_ponto()

func _ready() -> void:
	display = get_tree().get_first_node_in_group(NAME_GROUP_DISPLAY)
	for botao in get_tree().get_nodes_in_group(NAME_GROUP_botao):
		var callable := Callable(self, NAME_FUNC_BOTAO_PRESSIONADO).bind(botao.name)
		botao.connect(NOME_SINAL_BOTAO_PRESSIONADO, callable)

