extends Control

const NAME_GROUP_botao := "botão"
const NAME_GROUP_DISPLAY := "display"
const NOME_SINAL_BOTAO_PRESSIONADO := "pressed"
const NAME_FUNC_BOTAO_PRESSIONADO := "_botao_pressionado"

var display: Label

enum IdNumero { Primeiro, Segundo}

var id_numero_atual := IdNumero.Primeiro

var lista_numeros: Array[String] = ["0", "0"]
var operador_binario := ""
var apagar_numero := false

func _atualizar_numero(novo_numero: String, id: IdNumero) ->  void:
	lista_numeros[id] = novo_numero
	display.text = novo_numero

func _add_digito(digito: String) -> void:
	if lista_numeros[id_numero_atual] == "0" or apagar_numero == true:
		_atualizar_numero(digito, id_numero_atual)
		apagar_numero = false
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

func _executar_operacao_binaria_salva() -> String:
	var resultado := 0.0
	match operador_binario:
		"Somar":
			resultado = lista_numeros[0].to_float() + lista_numeros[1].to_float()
		"Subtrair":
			resultado = lista_numeros[0].to_float() - lista_numeros[1].to_float()
		"Multiplicar":
			resultado = lista_numeros[0].to_float() * lista_numeros[1].to_float()
		"Dividir":
			resultado = lista_numeros[0].to_float() / lista_numeros[1].to_float()
	return str(resultado)

func _executar_operador_binario(operador: String) -> void:
	if id_numero_atual == IdNumero.Primeiro:
		id_numero_atual = IdNumero.Segundo
		operador_binario = operador
	else:
		var resultado := _executar_operacao_binaria_salva()
		operador_binario = operador
		apagar_numero = true
		lista_numeros[0] = resultado
		_atualizar_numero(resultado, id_numero_atual)

func _executar_igualdade() -> void:
	if operador_binario != "":
		var resultado := _executar_operacao_binaria_salva()
		operador_binario = ""
		apagar_numero = true
		id_numero_atual = IdNumero.Primeiro
		_atualizar_numero(resultado, id_numero_atual)

func _botao_pressionado(botao_name: String) -> void:
	match botao_name:
		"0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
			_add_digito(botao_name)
		"Backspace":
			_apagar_digito()
		"Ponto":
			_add_ponto()
		"Dividir", "Multiplicar", "Subtrair", "Somar":
			_executar_operador_binario(botao_name)
		"Igual":
			_executar_igualdade()

func _ready() -> void:
	display = get_tree().get_first_node_in_group(NAME_GROUP_DISPLAY)
	for botao in get_tree().get_nodes_in_group(NAME_GROUP_botao):
		var callable := Callable(self, NAME_FUNC_BOTAO_PRESSIONADO).bind(botao.name)
		botao.connect(NOME_SINAL_BOTAO_PRESSIONADO, callable)

