extends Control

const NAME_GROUP_botao := "botão"
const NAME_GROUP_DISPLAY := "display"
const NOME_SINAL_BOTAO_PRESSIONADO := "pressed"
const NOME_FUNC_BOTAO_PRESSIONADO := "_botao_pressionado"

var _display: Label

enum _IdNumero { Primeiro, Segundo}
var _id_numero_atual := _IdNumero.Primeiro
var _lista_numeros: Array[String] = ["0", "0"]
var _operador_binario := ""
var _apagar_numero := false
var _erro := false



func _atualizar_numero(novo_numero: String, id: _IdNumero) ->  void:
	_lista_numeros[id] = novo_numero
	_display.text = novo_numero

func _add_digito(digito: String) -> void:
	if _lista_numeros[_id_numero_atual] == "0" or _apagar_numero == true:
		_atualizar_numero(digito, _id_numero_atual)
		_apagar_numero = false
	else:
		var novo_numero := _lista_numeros[_id_numero_atual] + digito
		_atualizar_numero(novo_numero, _id_numero_atual)

func _apagar_digito() -> void:
	_lista_numeros[_id_numero_atual] = _lista_numeros[_id_numero_atual].left(-1)
	if _lista_numeros[_id_numero_atual].is_empty():
		_lista_numeros[_id_numero_atual] = "0"

func _add_ponto() -> void:
	if not _lista_numeros[_id_numero_atual].contains("."):
		var novo_numero = _lista_numeros[_id_numero_atual] + "."
		_atualizar_numero(novo_numero, _id_numero_atual)

class _Resultado:
	var valor := 0.0
	var erro := false

func _executar_operacao_binaria_salva() -> _Resultado:
	var resultado := _Resultado.new();
	match _operador_binario:
		"Somar":
			resultado.valor = _lista_numeros[0].to_float() + _lista_numeros[1].to_float()
		"Subtrair":
			resultado.valor = _lista_numeros[0].to_float() - _lista_numeros[1].to_float()
		"Multiplicar":
			resultado.valor = _lista_numeros[0].to_float() * _lista_numeros[1].to_float()
		"Dividir":
			if _lista_numeros[1].to_float() == 0 :
				resultado.erro = true
				return resultado
			resultado.valor = _lista_numeros[0].to_float() / _lista_numeros[1].to_float()
	return resultado

func _exibir_erro() -> void:
	_erro = true
	_display.text = "ERRO"
	
func _executar_operador_binario(operador: String) -> void:
	if _id_numero_atual == _IdNumero.Primeiro:
		_id_numero_atual = _IdNumero.Segundo
		_operador_binario = operador
	else:
		var resultado := _executar_operacao_binaria_salva()
		if not resultado.erro:
			_operador_binario = operador
			_apagar_numero = true
			var str_resultado := str(resultado.valor)
			_lista_numeros[0] = str_resultado
			_atualizar_numero(str_resultado, _id_numero_atual)
		else:
			_exibir_erro()

func _executar_igualdade() -> void:
	if _operador_binario != "":
		var resultado := _executar_operacao_binaria_salva()
		if not resultado.erro:
			_operador_binario = ""
			_apagar_numero = true
			_id_numero_atual = _IdNumero.Primeiro
			_lista_numeros[_IdNumero.Segundo] = "0"
			_atualizar_numero(str(resultado.valor), _id_numero_atual)
		else:
			_exibir_erro()

func _limpar() -> void:
	_erro = false
	_id_numero_atual = _IdNumero.Primeiro
	_lista_numeros = ["0", "0"]
	_operador_binario = ""
	_display.text = "0"

func _botao_pressionado(botao_name: String) -> void:
	if not _erro:
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
	elif botao_name == 'C':
		_limpar()


func _ready() -> void:
	_display = get_tree().get_first_node_in_group(NAME_GROUP_DISPLAY)
	for botao in get_tree().get_nodes_in_group(NAME_GROUP_botao):
		var callable := Callable(self, NOME_FUNC_BOTAO_PRESSIONADO).bind(botao.name)
		botao.connect(NOME_SINAL_BOTAO_PRESSIONADO, callable)
