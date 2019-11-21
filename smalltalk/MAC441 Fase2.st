<?xml version="1.0"?>

<st-source>



<class>
<name>ControleDeEstoque</name>
<environment>Smalltalk</environment>
<super>Core.Object</super>
<private>false</private>
<indexed-type>none</indexed-type>
<inst-vars>emprestimos tiposDeItens usuarios usuariosSuspensos hoje </inst-vars>
<class-inst-vars></class-inst-vars>
<imports></imports>
<category>MAC441</category>
</class>

<!-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -   -->


<methods>
<class-id>ControleDeEstoque class</class-id> <category>instance creation</category>

<body>new

	| a |

	a := super new.

	a criaListaEmprestimos.

	a criaListaUsuarios.

	a criaListaTiposDeItens.

	a criaListaUsuariosSuspensos.

	a hoje: Date today.

	^a</body>
</methods>

<!-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -   -->


<methods>
<class-id>ControleDeEstoque</class-id> <category>accessing</category>

<body>consertaItem: numeroItem 

	"registra o item como indisponivel, indicando que esta em conserto"



	"para cada tipo de item varrer sua lista de itens"



	"para cada item dessa lista, verificar se é o item procurado. Se for, colocar como indisponivel"



	tiposDeItens do: 

			[:cada | 

			cada itens do: 

					[:cada2 | 

					cada2 numero = numeroItem &amp; (cada2 status = #disponivel) 

						ifTrue: [cada2 status: #noconserto]]]</body>

<body>devolve: numeroItem 

	"realiza a devolucao de um item, indicado pelo seu numero unico. Se um usuario

devolve um item atrasado, ele deve entrar na lista negra por um numero de dias 

igual ao do atraso"



	"recupera o emprestimo do item em questao"



	| listaAtrasados data oEmprestimo ident |

	oEmprestimo := emprestimos detect: [:each | each item numero = numeroItem]

				ifNone: 

					[Dialog warn: 'Emprestimo nao encontrado'.

					^nil].



	"coloca todos os numeros dos itens atrasados numa lista"

	data := self hoje.	"PARA TESTAR Date today addDays: 3"

	listaAtrasados := OrderedCollection new.

	emprestimos do: 

			[:cada | 

			cada dataDeDevolucao &lt; data ifTrue: [listaAtrasados add: cada item numero]].

	ident := oEmprestimo usuario numeroUsp = nil 

				ifTrue: [oEmprestimo usuario rg]

				ifFalse: [oEmprestimo usuario numeroUsp].





	"sai se nao ha emprestimo desse numero de item"

	"se houver, remove o emprestimo da lista de emprestimos"

	oEmprestimo = nil 

		ifTrue: 

			[Dialog warn: 'Nao ha emprestimo com esse numero de item'.

			^nil]

		ifFalse: 

			["remove o emprestimo da lista de emprestimos"



			emprestimos remove: oEmprestimo ifAbsent: [^nil]].





	"se o item esta atrasado, coloca o usuario na lista negra"

	(listaAtrasados includes: numeroItem) 

		ifTrue: 

			[self 

				poeNaListaNegra: oEmprestimo usuario nome

				identificador: ident

				dataLimite: (data addDays: (data subtractDate: oEmprestimo dataDeDevolucao))].

	oEmprestimo item status: #disponivel.

	^nil</body>

<body>empresta: nomeItem paraNUSP: umNumeroUSP 

	"pega o usuario na lista de usuarios a partir do numeroUsp"



	| user |

	user := usuarios detect: [:x | x numeroUsp = umNumeroUSP]

				ifNone: 

					[Dialog warn: 'Usuario inexistente'.

					^nil].

	^self empresta: nomeItem paraUsuario: user</body>

<body>empresta: nomeItem paraRG: umRG 

	"pega o usuario na lista de usuarios a partir do numeroUsp"



	| user |

	user := usuarios detect: [:x | x rg = umRG]

				ifNone: 

					[Dialog warn: 'Usuario inexistente'.

					^nil].

	^self empresta: nomeItem paraUsuario: user</body>

<body>itemConsertado: numeroItem 

	"indica que um item voltou do conserto"



	"para cada tipo de item varrer sua lista de itens"



	"para cada item dessa lista, verificar se é o item procurado. Se for e estava no conserto, colocar como disponivel"



	tiposDeItens do: 

			[:cada | 

			cada itens do: 

					[:cada2 | 

					cada2 numero = numeroItem &amp; (cada2 status = #noconserto) 

						ifTrue: 

							[cada2 status: #disponivel.

							^cada2 numero]]].

	^nil</body>

<body>itensEmAtraso

	"retorna uma lista com todos os itens que estao atrasados e os nomes dos usuarios que estao

	com estes itens"



	| listaDeItens |

	listaDeItens := OrderedCollection new.

	emprestimos do: 

			[:cada | 

			cada dataDeDevolucao &lt; self hoje 

				ifTrue: 

					[listaDeItens add: cada item numero printString , '  ' , cada usuario nome]].

	^listaDeItens</body>

<body>itensEmprestados

	"retorna uma lista com todos os itens que estao emprestados"



	| listaDeItens |

	listaDeItens := OrderedCollection new.

	emprestimos do: [:cada | listaDeItens add: cada item].

	^listaDeItens</body>

<body>itensNoConserto

	"retorna uma lista com todos os itens que estao no conserto"



	| listaDeItens todosOsItens itensConserto |

	listaDeItens := OrderedCollection new.

	tiposDeItens do: 

			[:cada | 

			"conta quantos itens no conserto cada tipo tem"



			todosOsItens := cada itens.

			itensConserto := todosOsItens 

						select: [:cada2 | cada2 status = #noconserto].

			listaDeItens add: cada nome , '  ' , itensConserto size printString].

	^listaDeItens</body>

<body>listaNegra

	"retorna uma lista com os nomes e identificadores (RG/NUsp) de todos os usuarios

	 que estao suspensos do sistema"



	| data |

	data := self hoje.

	usuariosSuspensos := usuariosSuspensos select: [:cada | cada last &gt;= data].

	^usuariosSuspensos</body>

<body>usuariosEmAtraso

	"retorna uma OrderedCollection em ordem alfabética dos usuarios em atraso

	 indicando quantos dias o item esta atrasado"



	"um usuario pode aparecer mais de uma vez na lista"



	| data emprestimosAtrasados usuariosAtrasados |

	data := self hoje.

	emprestimosAtrasados := emprestimos 

				select: [:each | each dataDeDevolucao &lt; data].

	usuariosAtrasados := OrderedCollection new.

	emprestimosAtrasados do: 

			[:cada | 

			| par |

			par := OrderedCollection new.

			par add: cada usuario.

			par add: (data subtractDate: cada dataDeDevolucao).

			usuariosAtrasados add: par].

	usuariosAtrasados := usuariosAtrasados 

				asSortedCollection: [:a :b | a first nome &lt; b first nome].

	^usuariosAtrasados</body>
</methods>

<methods>
<class-id>ControleDeEstoque</class-id> <category>adding</category>

<body>novoTipo: umTipoDeItem 

	"inclui um tipo de item"



	tiposDeItens add: umTipoDeItem</body>

<body>novoUsuario: umUsuario 

	"inclui um Usuario"



	usuarios add: umUsuario</body>
</methods>

<methods>
<class-id>ControleDeEstoque</class-id> <category>removing</category>

<body>retiraItem: numeroItem 

	"retira um item do sistema"



	"para cada tipo de item varrer sua lista de itens"



	"para cada item dessa lista, verificar se é o item procurado. Se for, retira-lo do sistema"



	tiposDeItens do: [:cada | cada retiraItem: numeroItem]</body>

<body>retiraItem: numeroItem tipo: nomeTipo 

	"retira um item do sistema"



	"para cada tipo de item varrer sua lista de itens"



	"para cada item dessa lista, verificar se é o item procurado. Se for, retira-lo do sistema"



	tiposDeItens do: 

			[:cada | 

			cada nome = nomeTipo 

				ifTrue: [cada retiraItem: numeroItem]]</body>
</methods>

<methods>
<class-id>ControleDeEstoque</class-id> <category>private</category>

<body>criaListaEmprestimos

	emprestimos := OrderedCollection new.</body>

<body>criaListaTiposDeItens

	tiposDeItens := OrderedCollection new.</body>

<body>criaListaUsuarios

	usuarios := OrderedCollection new.</body>

<body>criaListaUsuariosSuspensos

	"cria uma lista vazia de usuários suspensos"



	usuariosSuspensos := OrderedCollection new</body>

<body>empresta: nomeItem paraUsuario: umUsuario 

	| user tipoDeItem umItem data a |

	data := self hoje.

	user := umUsuario.



	"sai se o usuario estiver na lista negra"

	(self verificaSeEstaNaListaNegra: user) 

		ifTrue: [Dialog warn: 'O usuario esta na lista negra! Emprestimo cancelado!'].



	"sai se o usuario nao puder pegar nada mais emprestado"

	(self verificaQuantidade: user) &gt;= user quantidadeMaximaDeEmprestimos 

		ifTrue: 

			[Dialog 

				warn: 'O usuario nao pode pegar nada mais emprestado! Emprestimo cancelado!'.

			^nil].



	"pega um item na lista de itens do tipo de item"

	tipoDeItem := tiposDeItens detect: [:y | y nome = nomeItem]

				ifNone: 

					[Dialog warn: 'Tipo de item inexistente'.

					^nil].

	umItem := tipoDeItem itens detect: [:it | it status = #disponivel]

				ifNone: 

					[Dialog warn: 'Nenhum item deste tipo esta disponivel'.

					^nil].

	umItem status: #emprestado.

	a := Emprestimo 

				usuario: user

				item: umItem

				devolucao: (data addDays: user diasDeEmprestimo).

	emprestimos add: a.

	^umItem</body>

<body>hoje

	^hoje</body>

<body>hoje: anObject

	hoje := anObject</body>

<body>poeNaListaNegra: nomeUsuario identificador: umIdentificador dataLimite: umaData 

	"coloca o usuario na lista negra até a data limite"



	| trio |

	trio := OrderedCollection new.

	trio add: nomeUsuario.

	trio add: umIdentificador.

	trio add: umaData.

	usuariosSuspensos add: trio</body>

<body>tiposDeItens

	^tiposDeItens</body>

<body>usuarios

	^usuarios</body>

<body>usuariosSuspensos

	^usuariosSuspensos</body>

<body>verificaQuantidade: UmUsuario 

	"conta quantos emprestimos este usuario tem"



	| emprestimosUsuario totalEmpUsu |

	emprestimosUsuario := OrderedCollection new.

	emprestimos 

		do: [:each | each usuario = UmUsuario ifTrue: [emprestimosUsuario add: each]].

	totalEmpUsu := emprestimosUsuario size.

	^totalEmpUsu</body>

<body>verificaSeEstaNaListaNegra: umUsuario 

	"Verifica se um usuario esta na lista negra"



	"atualiza a lista negra (usuariosSuspensos)"



	| usuario |

	self listaNegra.

	usuario := usuariosSuspensos select: 

					[:each | 

					| identificador |

					identificador := each at: 2.

					each first = umUsuario nome 

						&amp; (identificador = umUsuario rg | (identificador = umUsuario numeroUsp))].

	^usuario notEmpty</body>
</methods>
<new-page/>


<class>
<name>PoliticaDeMatricula</name>
<environment>Smalltalk</environment>
<super>Core.Object</super>
<private>false</private>
<indexed-type>none</indexed-type>
<inst-vars></inst-vars>
<class-inst-vars></class-inst-vars>
<imports></imports>
<category>MAC441</category>
</class>

<methods>
<class-id>PoliticaDeMatricula</class-id> <category>accessing</category>

<body>preMatriculaPara: umAluno em: umaDisciplina 
	"volta True se o aluno pode se pre-matricular, falso se não pode."

	^umAluno cumpriu: umaDisciplina preRequisitos</body>

<body>selecionePrimeiros: n dentre: colecaoDeAlunos disciplina: umaDisciplina 
	"ordena os alunos conforme seu critério interno e retorna os  primeiros n"

	^self subclassResponsibility

	"NOTA: voce deve implementar duas politicas de matricula, uma
que faz a matricula por ordem de realizaçao da pre-matricula e uma que
favorece os alunos de cursos para os quais a disciplina é obrigatória
e, dentre estes, por sorteio.
	Em ambos os casos, voce deve exigir que os pre-requisitos tenham sido cumpridos.
	Em ambas as classes, a pre-matricula é autorizada se o aluno cursou ou esta cursando
todos os pre-requisitos da materia"</body>
</methods>
<new-page/>


<class>
<name>MatriculaPorSorteio</name>
<environment>Smalltalk</environment>
<super>PoliticaDeMatricula</super>
<private>false</private>
<indexed-type>none</indexed-type>
<inst-vars></inst-vars>
<class-inst-vars></class-inst-vars>
<imports></imports>
<category>MAC441</category>
</class>

<!-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -   -->


<methods>
<class-id>MatriculaPorSorteio class</class-id> <category>instance creation</category>

<body>new
	^super new</body>
</methods>

<!-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -   -->


<methods>
<class-id>MatriculaPorSorteio</class-id> <category>accessing</category>

<body>selecionePrimeiros: n dentre: colecaoDeAlunos disciplina: umaDisciplina 
	"ordena os alunos conforme seu critério interno e retorna os  primeiros n"

	| interessados interessadosPreferenciais restoInteressados vagasRestantes restoInteressadosSelecionados i selecionados |
	interessados := colecaoDeAlunos copy.


	"checa se esta faltando vaga"
	"se não estiver, retorna todos os interessados"
	n &gt; interessados size 
		ifTrue: [^interessados]
		ifFalse: 
			[interessados notEmpty 
				ifTrue: 
					["faz uma colecao de interessados preferenciais"

					interessadosPreferenciais := OrderedCollection new.
					interessados do: 
							[:umAluno | 
							(umAluno curso discObrigat includes: umaDisciplina) 
								ifTrue: [interessadosPreferenciais add: umAluno]]].

			"se faltar vaga, sorteia entre eles"
			interessadosPreferenciais size &gt; n 
				ifTrue: [^self sorteia: n entre: interessadosPreferenciais]
				ifFalse: 
					["se ainda sobrar vaga, aloca o resto das vagas entre os outros por
						ordem de pre matricula"

					"restoInteressados := int removeAll: interessadosPreferenciais."

					restoInteressados := OrderedCollection new.
					interessados do: 
							[:umAluno | 
							(interessadosPreferenciais includes: umAluno) 
								ifFalse: [restoInteressados add: umAluno]].
					vagasRestantes := n - interessadosPreferenciais size 
								min: restoInteressados size.
					restoInteressadosSelecionados := OrderedCollection new.
					i := 1.
					[i &lt;= vagasRestantes] whileTrue: 
							[restoInteressadosSelecionados add: (restoInteressados at: i).
							i := i + 1].
					selecionados := OrderedCollection new.
					interessadosPreferenciais do: [:umAluno | selecionados add: umAluno].
					restoInteressadosSelecionados do: [:umAluno | selecionados add: umAluno].
					^selecionados]]</body>

<body>sorteia: n entre: colecaoDeAlunos 
	| col escolhidos indice escolhido |
	col := colecaoDeAlunos copy.
	escolhidos := OrderedCollection new.
	n timesRepeat: 
			[indice := Random new next * col size.
			escolhido := col at: indice truncated + 1.
			col remove: escolhido.
			escolhidos add: escolhido].
	^escolhidos</body>
</methods>
<new-page/>


<class>
<name>JanelaAluno</name>
<environment>Smalltalk</environment>
<super>UI.ApplicationModel</super>
<private>false</private>
<indexed-type>none</indexed-type>
<inst-vars>aluno nomeAluno controleAcademico </inst-vars>
<class-inst-vars></class-inst-vars>
<imports></imports>
<category>MAC441</category>
</class>

<!-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -   -->


<methods>
<class-id>JanelaAluno class</class-id> <category>interface specs</category>

<body>windowSpec
	"UIPainter new openOnClass: self andSelector: #windowSpec"

	&lt;resource: #canvas&gt;
	^#(#{UI.FullSpec} 
		#window: 
		#(#{UI.WindowSpec} 
			#properties: #(#{UI.PropertyListDictionary} #sizeType #specifiedSize #positionType #cascade #openType #advanced ) 
			#label: 'Aluno' 
			#min: #(#{Core.Point} 200 200 ) 
			#max: #(#{Core.Point} 200 200 ) 
			#bounds: #(#{Graphics.Rectangle} 512 384 712 584 ) 
			#colors: 
			#(#{UI.LookPreferences} 
				#setBackgroundColor: #(#{Graphics.ColorValue} 1024 1024 8191 ) ) ) 
		#component: 
		#(#{UI.SpecCollection} 
			#collection: #(
				#(#{UI.InputFieldSpec} 
					#layout: #(#{Graphics.Rectangle} 51 50 151 73 ) 
					#name: #nomeAluno 
					#model: #nomeAluno ) ) ) )</body>
</methods>

<!-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -   -->


<methods>
<class-id>JanelaAluno</class-id> <category>accessing</category>

<body>aluno
	^aluno</body>

<body>aluno: anObject
	aluno := anObject</body>

<body>controleAcademico
	^controleAcademico</body>

<body>controleAcademico: anObject
	controleAcademico := anObject</body>
</methods>

<methods>
<class-id>JanelaAluno</class-id> <category>aspects</category>

<body>nomeAluno
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^nomeAluno isNil 
		ifTrue: 
			[(aluno isNil or: [aluno nome isNil]) 
				ifTrue: [nomeAluno := String new asValue]
				ifFalse: [nomeAluno := aluno nome asValue]]
		ifFalse: [nomeAluno]</body>
</methods>

<methods>
<class-id>JanelaAluno</class-id> <category>actions</category>

<body>changeRequest
	^super changeRequest 
		ifFalse: [false]
		ifTrue: 
			[controleAcademico notNil 
				ifTrue: [controleAcademico removeJanelaAluno: self].
			true]
	"				ifTrue: 
					[Dialog 
						confirm: 'The image has been altered, but not installed.
Do you wish to discard the changes?']
				ifFalse: [true]]"</body>
</methods>
<new-page/>


<class>
<name>ItemDeCarreira</name>
<environment>Smalltalk</environment>
<super>Core.Object</super>
<private>false</private>
<indexed-type>none</indexed-type>
<inst-vars>disciplina mediaAluno ano semestre numAlunos </inst-vars>
<class-inst-vars></class-inst-vars>
<imports></imports>
<category>MAC441</category>
</class>

<!-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -   -->


<methods>
<class-id>ItemDeCarreira class</class-id> <category>instance creation</category>

<body>disciplina: umaDisciplina mediaAluno: umaMediaAluno ano: umAno semestre: umSemestre 

	| i |

	i := ItemDeCarreira new.

	i

		disciplina: umaDisciplina;

		mediaAluno: umaMediaAluno;

		ano: umAno;

		semestre: umSemestre.

	^i</body>

<body>disciplina: umaDisciplina mediaAluno: umaMediaAluno ano: umAno semestre: umSemestre numAlunos: umNumAlunos 
	| i |
	i := ItemDeCarreira new.
	i
		disciplina: umaDisciplina;
		mediaAluno: umaMediaAluno;
		ano: umAno;
		semestre: umSemestre;
		numAlunos: umNumAlunos.
	^i</body>

<body>new
	| i |
	i := super new.
	^i</body>
</methods>

<!-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -   -->


<methods>
<class-id>ItemDeCarreira</class-id> <category>private</category>

<body>ano

	^ano</body>

<body>ano: anObject

	ano := anObject</body>

<body>disciplina

	^disciplina</body>

<body>disciplina: anObject

	disciplina := anObject</body>

<body>mediaAluno

	^mediaAluno</body>

<body>mediaAluno: anObject

	mediaAluno := anObject</body>

<body>numAlunos
	^numAlunos</body>

<body>numAlunos: anObject
	numAlunos := anObject</body>

<body>semestre

	^semestre</body>

<body>semestre: anObject

	semestre := anObject</body>
</methods>
<new-page/>


<class>
<name>Curso</name>
<environment>Smalltalk</environment>
<super>Core.Object</super>
<private>false</private>
<indexed-type>none</indexed-type>
<inst-vars>discObrigat discOptativa numeroOptativas numeroForaDeArea alunos nome </inst-vars>
<class-inst-vars></class-inst-vars>
<imports></imports>
<category>MAC441</category>
</class>

<!-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -   -->


<methods>
<class-id>Curso class</class-id> <category>instance creation</category>

<body>new
	| c |
	c := super new.
	c criaListaAlunos.
	^c</body>

<body>nome: umNomeDeCurso discObrigat: listaDiscObrigat discOptativa: listaDiscOptativa numeroOptativas: umNumeroOptativas numeroForaDeArea: umNumeroForaDeArea 

	| c |

	c := Curso new.

	c

		nome: umNomeDeCurso;

		discObrigat: listaDiscObrigat;

		discOptativa: listaDiscOptativa;

		numeroOptativas: umNumeroOptativas;

		numeroForaDeArea: umNumeroForaDeArea.

	^c</body>
</methods>

<!-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -   -->


<methods>
<class-id>Curso</class-id> <category>accessing</category>

<body>incluiAluno: umAluno 

	self alunos add: umAluno</body>
</methods>

<methods>
<class-id>Curso</class-id> <category>private</category>

<body>alunos

	^alunos</body>

<body>alunos: anObject

	alunos := anObject</body>

<body>criaListaAlunos
	alunos := OrderedCollection new</body>

<body>discObrigat

	^discObrigat</body>

<body>discObrigat: anObject

	discObrigat := anObject</body>

<body>discOptativa

	^discOptativa</body>

<body>discOptativa: anObject

	discOptativa := anObject</body>

<body>nome

	^nome</body>

<body>nome: anObject

	nome := anObject</body>

<body>numeroForaDeArea

	^numeroForaDeArea</body>

<body>numeroForaDeArea: anObject

	numeroForaDeArea := anObject</body>

<body>numeroOptativas

	^numeroOptativas</body>

<body>numeroOptativas: anObject

	numeroOptativas := anObject</body>
</methods>
<new-page/>


<class>
<name>Docente</name>
<environment>Smalltalk</environment>
<super>Core.Object</super>
<private>false</private>
<indexed-type>none</indexed-type>
<inst-vars>nUSP pessoa listaItensDeCarreira turmasDoSem departamento </inst-vars>
<class-inst-vars></class-inst-vars>
<imports></imports>
<category>MAC441</category>
</class>

<!-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -   -->


<methods>
<class-id>Docente class</class-id> <category>instance creation</category>

<body>new
	| d |
	d := super new.
	d criaListaItensDeCarreira.
	d criaListaTurmasDoSem.
	^d</body>

<body>nome: umNome rg: umRg cpf: umCPF end: umEnd senha: umaSenha nUSP: umNUSP departamento: umDepartamento 
	| d p |
	d := Docente new.

	"procura pessoa com mesmo rg ou mesmo cpf"
	p := Pessoa existeComRg: umRg ouCpf: umCPF.
	"se não existir tal pessoa, criar uma nova pessoa"
	p = nil 
		ifTrue: 
			[p := Pessoa 
						nome: umNome
						rg: umRg
						cpf: umCPF
						end: umEnd
						senha: umaSenha].
	d pessoa: p.
	d nUSP: umNUSP.
	d departamento: umDepartamento.
	^d</body>
</methods>

<methods>
<class-id>Docente class</class-id> <category>acessing</category>

<body>comNumeroUsp: umNumeroUsp 
	"retorna um docente com numero USP igual a umNumeroUsp"

	Docente allInstances notNil &amp; Docente allInstances notEmpty 
		ifTrue: 
			[^Docente allInstances 
				detect: [:umDocente | umDocente nUSP printString = umNumeroUsp]
				ifNone: [^nil]]
		ifFalse: [^nil]</body>
</methods>

<!-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -   -->


<methods>
<class-id>Docente</class-id> <category>private</category>

<body>criaListaItensDeCarreira
	listaItensDeCarreira := OrderedCollection new</body>

<body>criaListaTurmasDoSem
	turmasDoSem := OrderedCollection new</body>

<body>departamento
	^departamento</body>

<body>departamento: anObject
	departamento := anObject</body>

<body>listaItensDeCarreira

	^listaItensDeCarreira</body>

<body>listaItensDeCarreira: anObject

	listaItensDeCarreira := anObject</body>

<body>numAlunos: umaDisciplina 
	"retorna o numero de alunos nas turmas ministradas pelo professor para esta disciplina"

	| contador |
	contador := 0.
	listaItensDeCarreira isEmpty 
		ifFalse: 
			[listaItensDeCarreira do: 
					[:iC | 
					iC disciplina = umaDisciplina 
						ifTrue: [contador := contador + iC numAlunos]]].
	^contador</body>

<body>numTurmas: umaDisciplina 
	"retorna o numero de turmas minstradas pelo professor para esta disciplina"

	| contador |
	contador := 0.
	listaItensDeCarreira isEmpty 
		ifFalse: 
			[listaItensDeCarreira 
				do: [:iC | iC disciplina = umaDisciplina ifTrue: [contador := contador + 1]]].
	^contador</body>

<body>nUSP

	^nUSP</body>

<body>nUSP: anObject

	nUSP := anObject</body>

<body>pessoa

	^pessoa</body>

<body>pessoa: anObject

	pessoa := anObject</body>

<body>turmasDoSem
	^turmasDoSem</body>

<body>turmasDoSem: anObject
	turmasDoSem := anObject</body>
</methods>

<methods>
<class-id>Docente</class-id> <category>testing</category>

<body>choca: umaColecaoDeHorarios 
	"para cada horário da coleção de horários, 
	  verifica se choca com cada horário de cada disciplina do professor"

	umaColecaoDeHorarios isNil 
		ifFalse: 
			[umaColecaoDeHorarios isEmpty 
				ifFalse: 
					[umaColecaoDeHorarios do: 
							[:umHorario | 
							self turmasDoSem 
								do: [:umaTurma | (umHorario chocaComColecao: umaTurma horario) ifTrue: [^true]]]]].
	^false</body>
</methods>

<methods>
<class-id>Docente</class-id> <category>accessing</category>

<body>disciplinasDoSemestre
	"retorna uma colecao com as disciplinas que estao sendo lecionadas neste semestre"

	| disciplinasSemestre |
	disciplinasSemestre := Set new.
	self turmasDoSem 
		do: [:cadaTurma | disciplinasSemestre add: cadaTurma disciplina].
	^disciplinasSemestre asOrderedCollection</body>

<body>historicoAcademico
	"retorna uma string com o nome do professor, as discipinas lecionadas, quantas turmas e o total de alunos por disciplina. A saida deve estar identada"

	| nome tab cr historico listaDisciplinasMinistradas |
	tab := String with: Character tab.
	cr := String with: Character cr.
	nome := self pessoa nome asString.
	historico := cr , 'Historico academico' , cr.
	historico := historico , 'Nome do professor: ' , nome , cr.
	listaItensDeCarreira isEmpty 
		ifTrue: 
			[historico := historico 
						, 'Nenhuma disciplina foi ministrada pelo professor ate o momento' , cr]
		ifFalse: 
			[historico := historico , 'Disciplinas ministradas: ' , cr.
			listaDisciplinasMinistradas := OrderedCollection new.
			listaItensDeCarreira do: 
					[:iC | 
					(listaDisciplinasMinistradas includes: iC disciplina) 
						ifFalse: [listaDisciplinasMinistradas add: iC disciplina]].
			listaDisciplinasMinistradas do: 
					[:dM | 
					historico := historico , ' Disciplina: ' , dM nome , tab 
								, ' Numero de Turmas: ' , (self numTurmas: dM) printString 
								, tab , ' Total de Alunos: ' 
								, (self numAlunos: dM) printString , cr]].
	^historico</body>

<body>nome
	^self pessoa nome</body>

<body>novaTurmaPara: umaDisciplina horario: umaColecaoDeHorarios vagas: numVagas 
	"este método deve retornar a turma se a criação for bem sucedida, e nulo
 	 se a disciplina não for do departamento ou se o professor já tem outra turma em
       algum dos horarios. Em caso de erro, voce deve imprimir uma aviso no Transcript"

	"se a disciplina não for do departamento, exibe mensagem de erro"

	| disciplinasDepto t |
	disciplinasDepto := self departamento disciplinas.
	(disciplinasDepto includes: umaDisciplina) 
		ifFalse: 
			[Transcript
				cr;
				show: 'Docente novaTurmaPara: umaDisciplina horario: umaColecaoDeHorarios vagas: numVagas';
				cr;
				show: 'Disciplina não faz parte do conjunto de disciplinas do departamento'.
			^nil].

	"se o professor já tem outra turma em algum dos horários, exibe mensagem de erro"
	(self choca: umaColecaoDeHorarios) 
		ifTrue: 
			[Transcript
				cr;
				show: 'Docente novaTurmaPara: umaDisciplina horario: umaColecaoDeHorarios vagas: numVagas';
				cr;
				show: 'O professor já tem outra turma em algum dos horários.'.
			^nil].

	"caso tudo esteja OK, cria a turma e a retorna"
	t := Turma 
				disciplina: umaDisciplina
				horario: umaColecaoDeHorarios
				vagas: numVagas.
	t
		ano: 2003;
		semestre: 1;
		docente: self.
	self turmasDoSem add: t.
	^t</body>

<body>novoItemDeCarreira: umItemDeCarreira 
	listaItensDeCarreira add: umItemDeCarreira</body>

<body>senha
	^self pessoa senha</body>

<body>turmasDoSemestre
	"retorna uma coleção com as turmas deste semestre"

	^self turmasDoSem</body>
</methods>
<new-page/>


<class>
<name>JanelaSenhaProfessor</name>
<environment>Smalltalk</environment>
<super>UI.ApplicationModel</super>
<private>false</private>
<indexed-type>none</indexed-type>
<inst-vars>senhaProfessor janelaProfessor professor controleAcademico </inst-vars>
<class-inst-vars></class-inst-vars>
<imports></imports>
<category>MAC441</category>
</class>

<!-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -   -->


<methods>
<class-id>JanelaSenhaProfessor class</class-id> <category>interface specs</category>

<body>windowSpec
	"UIPainter new openOnClass: self andSelector: #windowSpec"

	&lt;resource: #canvas&gt;
	^#(#{UI.FullSpec} 
		#window: 
		#(#{UI.WindowSpec} 
			#label: 'Professor - Solicitação de Senha' 
			#min: #(#{Core.Point} 444 106 ) 
			#max: #(#{Core.Point} 444 106 ) 
			#bounds: #(#{Graphics.Rectangle} 512 384 956 490 ) 
			#colors: 
			#(#{UI.LookPreferences} 
				#setBackgroundColor: #(#{Graphics.ColorValue} 8191 7679 7167 ) ) ) 
		#component: 
		#(#{UI.SpecCollection} 
			#collection: #(
				#(#{UI.LabelSpec} 
					#layout: #(#{Core.Point} 126 30 ) 
					#name: #Label1 
					#label: 'Senha' ) 
				#(#{UI.InputFieldSpec} 
					#layout: #(#{Graphics.Rectangle} 187 29 287 52 ) 
					#name: #senhaProfessor 
					#model: #senhaProfessor 
					#type: #password ) 
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.Rectangle} 177 68 258 91 ) 
					#name: #botaoOK 
					#model: #chamaJanelaProfessor 
					#label: 'OK' 
					#defaultable: true ) ) ) )</body>
</methods>

<!-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -   -->


<methods>
<class-id>JanelaSenhaProfessor</class-id> <category>aspects</category>

<body>senhaProfessor
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^senhaProfessor isNil
		ifTrue:
			[senhaProfessor := String new asValue]
		ifFalse:
			[senhaProfessor]</body>
</methods>

<methods>
<class-id>JanelaSenhaProfessor</class-id> <category>actions</category>

<body>chamaJanelaProfessor
	"confere a senha"

	| umaJanelaProfessor jm jm2 |
	self senhaProfessor value = self professor senha 
		ifFalse: [Dialog warn: 'Senha incorreta']
		ifTrue: 
			["abre uma outra janela para o professor"

			umaJanelaProfessor := JanelaProfessor new.
			self controleAcademico janelasProfessor add: umaJanelaProfessor.
			umaJanelaProfessor professor: self professor.
			umaJanelaProfessor controleAcademico: self controleAcademico.
			"			umaJanelaProfessor open."

			"abre a janela e faz com que ela seja escrava da principal"
			jm := self controleAcademico builder window.
			jm
				application: self controleAcademico;
				beMaster.
			jm2 := umaJanelaProfessor open window.
			jm2
				application: self controleAcademico;
				beSlave.

			"fecha a janela anterior"
			self closeRequest]</body>

<body>changeRequest
	^super changeRequest 
		ifFalse: [false]
		ifTrue: 
			[controleAcademico notNil 
				ifTrue: [controleAcademico removeJanelaProfessor: self].
			true]</body>
</methods>

<methods>
<class-id>JanelaSenhaProfessor</class-id> <category>accessing</category>

<body>controleAcademico
	^controleAcademico</body>

<body>controleAcademico: anObject
	controleAcademico := anObject</body>

<body>janelaProfessor
	^janelaProfessor</body>

<body>janelaProfessor: anObject
	janelaProfessor := anObject</body>

<body>professor
	^professor</body>

<body>professor: anObject
	professor := anObject</body>
</methods>
<new-page/>


<class>
<name>ItemHistorico</name>
<environment>Smalltalk</environment>
<super>Core.Object</super>
<private>false</private>
<indexed-type>none</indexed-type>
<inst-vars>nota frequencia disciplina ano semestre </inst-vars>
<class-inst-vars></class-inst-vars>
<imports></imports>
<category>MAC441</category>
</class>

<!-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -   -->


<methods>
<class-id>ItemHistorico class</class-id> <category>instance creation</category>

<body>new

	| i |

	i := super new.

	^i</body>

<body>nota: umaNota frequencia: umaFrequencia disciplina: umaDisciplina ano: umAno semestre: umSemestre 
	| i |
	i := ItemHistorico new.
	i
		nota: umaNota;
		frequencia: umaFrequencia;
		disciplina: umaDisciplina;
		ano: umAno;
		semestre: umSemestre.
	^i</body>
</methods>

<!-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -   -->


<methods>
<class-id>ItemHistorico</class-id> <category>private</category>

<body>ano

	^ano</body>

<body>ano: anObject

	ano := anObject</body>

<body>disciplina

	^disciplina</body>

<body>disciplina: anObject

	disciplina := anObject</body>

<body>frequencia

	^frequencia</body>

<body>frequencia: anObject

	frequencia := anObject</body>

<body>nota

	^nota</body>

<body>nota: anObject

	nota := anObject</body>

<body>semestre

	^semestre</body>

<body>semestre: anObject

	semestre := anObject</body>
</methods>
<new-page/>


<class>
<name>Usuario</name>
<environment>Smalltalk</environment>
<super>Core.Object</super>
<private>false</private>
<indexed-type>none</indexed-type>
<inst-vars>nome numeroUsp tipo email rg diasDeEmprestimo quantidadeMaximaDeEmprestimos </inst-vars>
<class-inst-vars></class-inst-vars>
<imports></imports>
<category>MAC441</category>
</class>

<!-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -   -->


<methods>
<class-id>Usuario class</class-id> <category>instance creation</category>

<body>nome: umNome numeroUsp: numeroUSP email: umEmail 

	| a |

	a := super new.

	a

		nome: umNome;

		numeroUsp: numeroUSP;

		email: umEmail;

		diasDeEmprestimo: 1;

		quantidadeMaximaDeEmprestimos: 1;

		rg: nil;

		tipo: #regular.

	^a</body>

<body>nome: umNome rg: umRG email: umEmail 

	| a |

	a := super new.

	a

		nome: umNome;

		numeroUsp: nil;

		email: umEmail;

		diasDeEmprestimo: 1;

		quantidadeMaximaDeEmprestimos: 1;

		rg: umRG;

		tipo: #regular.

	^a</body>
</methods>

<!-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -   -->


<methods>
<class-id>Usuario</class-id> <category>accessing</category>

<body>diasDeEmprestimo

	^diasDeEmprestimo</body>

<body>diasDeEmprestimo: dias

	diasDeEmprestimo:=dias</body>

<body>email



	^email</body>

<body>email: umEmail



	email:=umEmail</body>

<body>nome



	^nome</body>

<body>nome: umNome



	nome:=umNome</body>

<body>numeroUsp



	^numeroUsp</body>

<body>numeroUsp: numeroUSP



	numeroUsp:=numeroUSP</body>

<body>quantidadeMaximaDeEmprestimos

	^quantidadeMaximaDeEmprestimos</body>

<body>quantidadeMaximaDeEmprestimos: qtde

	quantidadeMaximaDeEmprestimos:=qtde</body>

<body>rg

	^rg</body>

<body>rg: umRG

	rg:=umRG</body>

<body>tipo

	^tipo</body>

<body>tipo: umTipo

	tipo:=umTipo</body>
</methods>

<methods>
<class-id>Usuario</class-id> <category>printing</category>

<body>imprime

	Transcript 	cr;

				show: nome;cr.

	(numeroUsp = nil)

		ifTrue: [Transcript show: 'RG: '; show: rg displayString;cr]

		ifFalse: [Transcript show: 'No. USP: '; show: numeroUsp displayString;cr].

	Transcript

				show: 'email: ';

				show: email;cr;

				show: tipo displayString;cr;

				show: diasDeEmprestimo displayString;cr;

				show: quantidadeMaximaDeEmprestimos displayString;cr.</body>
</methods>
<new-page/>


<class>
<name>Turma</name>
<environment>Smalltalk</environment>
<super>Core.Object</super>
<private>false</private>
<indexed-type>none</indexed-type>
<inst-vars>disciplina interesse horario vagas alunosMatriculados vagasDisponiveis ano semestre docente </inst-vars>
<class-inst-vars></class-inst-vars>
<imports></imports>
<category>MAC441</category>
</class>

<!-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -   -->


<methods>
<class-id>Turma class</class-id> <category>instance creation</category>

<body>disciplina: umaDisciplina horario: umaColecaoDeHorarios vagas: numVagas 
	| t |
	t := Turma new.
	t disciplina: umaDisciplina.
	(Horario choca: umaColecaoDeHorarios) 
		ifTrue: 
			[Transcript
				cr;
				show: 'Turma disciplina: umaDisciplina horario: umaColecaoDeHorarios vagas: numVagas';
				cr;
				show: 'Choque de horários - impossível criar disciplina'.
			^nil]
		ifFalse: [t horario: umaColecaoDeHorarios].
	t vagas: numVagas.
	t vagasDisponiveis: t vagas.
	^t</body>

<body>new
	| t |
	t := super new.
	t criaListaInteresse.
	t criaListaAlunosMatriculados.
	^t</body>
</methods>

<!-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -   -->


<methods>
<class-id>Turma</class-id> <category>accessing</category>

<body>listaDeChamada
	"retorna uma colecao com os alunos matriculados"

	^alunosMatriculados</body>

<body>matricula
	"efetua a matricula dos alunos indicados pela política de matrícula. Simule, escrevendo
no Transcript, o envio de email para todos os alunos pré-matriculados, confirmando a 
matrícula, ou indicando que esta foi negada."

	| alunosMatrAgora |
	interesse isEmpty 
		ifFalse: 
			[self disciplina isNil | self disciplina politicaDeMatricula isNil 
				ifTrue: 
					[Transcript
						cr;
						show: 'Turma matricula';
						cr;
						show: 'disciplina eh Nil ou politica de matricula eh nil'].
			alunosMatrAgora := self disciplina politicaDeMatricula 
						selecionePrimeiros: self vagasDisponiveis
						dentre: self interesse
						disciplina: self disciplina.

			"envia email para todos os alunos interessados"
			interesse do: 
					[:umAluno | 
					(alunosMatrAgora includes: umAluno) 
						ifTrue: 
							[Transcript
								cr;
								show: 'Enviando email para ' , umAluno nome;
								show: ' confirmando aceitacao da matricula';
								cr]
						ifFalse: 
							[Transcript
								cr;
								show: 'Enviando email para ' , umAluno nome;
								show: ' informando da negacao da matricula';
								cr]].

			"retirar a turma da lista de pre matriculas do aluno"
			alunosMatrAgora do: 
					[:umAluno | 
					(umAluno preMatriculas includes: self) ifTrue: [umAluno removeTurma: self]].

			"remover os selecionados de interesse"
			self interesse removeAll: alunosMatrAgora.

			"colocar os matriculados na lista de alunos matriculados"
			self alunosMatriculados addAll: alunosMatrAgora.

			"diminuir o numero de vagas disponiveis"
			self vagasDisponiveis: self vagasDisponiveis - alunosMatrAgora size]

	"NOTA: você pode mandar a mensagem matricula mais de uma vez. Devem ser
feitas listas separadas para pré-matrícula e matrícula. Toda vez que matrícula for re-editada, você deve selecionar candidatos apenas para o número de vagas ainda disponível."</body>

<body>notas: umDicionarioComNotasDosAlunos 
	"deve providenciar para que a nota seja incluida no histórico de cada aluno.
        retorna uma string com os numeros usp, nome e nota de cada aluno."

	"cria uma coleção com todos os numeros Usp dos alunos do dicionario"

	| numerosUsp umAluno str cr tab mediaAlunos quantAlunos iC |
	mediaAlunos := 0.
	quantAlunos := 0.
	str := String new.
	tab := String with: Character tab.
	cr := String with: Character cr.
	numerosUsp := umDicionarioComNotasDosAlunos keys.
	numerosUsp do: 
			[:umNumeroUsp | 
			"pega o aluno com aquele numero usp"

			umAluno := Aluno comNumeroUsp: umNumeroUsp.
			umAluno isNil 
				ifTrue: 
					[Transcript
						cr;
						show: 'Turma notas: umDicionarioComNotasDosAlunos' cr;
						show: 'Aluno com numero USP nao encontrado']
				ifFalse: 
					[umAluno 
						poeNota: (umDicionarioComNotasDosAlunos at: umNumeroUsp)
						disciplina: self disciplina
						semestre: 1
						ano: 2003
						frequencia: 100.
					mediaAlunos := mediaAlunos 
								+ (umDicionarioComNotasDosAlunos at: umNumeroUsp).
					quantAlunos := quantAlunos + 1.
					str := str , 'Numero USP: ' , umAluno nUSP printString , tab , 'Nome: ' 
								, umAluno nome , tab 
								, 'Nota:' , (umDicionarioComNotasDosAlunos at: umNumeroUsp) printString 
								, cr]].
	"cria item de Carreira e coloca no curriculo do professor"
	iC := ItemDeCarreira 
				disciplina: self disciplina
				mediaAluno: (mediaAlunos / quantAlunos) asFloat
				ano: self ano
				semestre: self semestre
				numAlunos: quantAlunos.
	self docente novoItemDeCarreira: iC.
	^str</body>

<body>preMatricula: umAluno 
	"se o aluno cumpriu os pré-requisitos, coloca-o na lista de interesses"

	self disciplina isNil &amp; self disciplina politicaDeMatricula isNil 
		ifTrue: 
			[Transcript
				cr;
				show: 'Turma preMatricula: umAluno';
				cr;
				show: 'disciplina eh Nil ou politica de matricula eh nil']
		ifFalse: 
			[(self disciplina politicaDeMatricula preMatriculaPara: umAluno
				em: self disciplina) &amp; (self interesse includes: umAluno) not 
				ifTrue: 
					[self interesse add: umAluno.
					umAluno preMatricula: self]]

	"	(umAluno cumpriu: self disciplina preRequisitos) 
		ifTrue: [self interesse add: umAluno]
		ifFalse: 
			[Transcript
				cr;
				show: 'Turma preMatricula: umAluno';
				cr;
				show: 'O aluno não cumpriu os pré-requisitos da disciplina'.
			^nil].
	^self
"</body>
</methods>

<methods>
<class-id>Turma</class-id> <category>private</category>

<body>alunosMatriculados
	^alunosMatriculados</body>

<body>alunosMatriculados: anObject
	alunosMatriculados := anObject</body>

<body>ano
	^ano</body>

<body>ano: anObject
	ano := anObject</body>

<body>criaListaAlunosMatriculados
	alunosMatriculados := OrderedCollection new</body>

<body>criaListaInteresse
	interesse := OrderedCollection new</body>

<body>disciplina
	^disciplina</body>

<body>disciplina: anObject
	disciplina := anObject</body>

<body>docente
	^docente</body>

<body>docente: anObject
	docente := anObject</body>

<body>horario
	^horario</body>

<body>horario: anObject
	horario := anObject</body>

<body>interesse
	^interesse</body>

<body>interesse: anObject
	interesse := anObject</body>

<body>semestre
	^semestre</body>

<body>semestre: anObject
	semestre := anObject</body>

<body>vagas
	^vagas</body>

<body>vagas: anObject
	vagas := anObject</body>

<body>vagasDisponiveis
	^vagasDisponiveis</body>

<body>vagasDisponiveis: anObject
	vagasDisponiveis := anObject</body>
</methods>
<new-page/>


<class>
<name>Horario</name>
<environment>Smalltalk</environment>
<super>Core.Object</super>
<private>false</private>
<indexed-type>none</indexed-type>
<inst-vars>diaDaSemana inicio final </inst-vars>
<class-inst-vars></class-inst-vars>
<imports></imports>
<category>MAC441</category>
</class>

<!-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -   -->


<methods>
<class-id>Horario class</class-id> <category>instance creation</category>

<body>diaDaSemana: umDiaDaSemana inicio: umaHora final: outraHora 
	"dia da semana deve ser um dos abaixo
	#segunda,#terca,#quarta,#quinta,#sexta,#sabado,#domingo
	horarios de inicio e final devem ser da classe Time"

	| h diasDaSemana |
	h := super new.
	diasDaSemana := #(#segunda #terca #quarta #quinta #sexta #sabado #domingo) 
				asOrderedCollection.
	(diasDaSemana includes: umDiaDaSemana) 
		ifFalse: 
			[Transcript show: 'Horário com dia incorreto'.
			^nil].
	h diaDaSemana: umDiaDaSemana.
	umaHora &gt; outraHora 
		ifTrue: 
			[Transcript show: 'Horário: início maior que final'.
			^nil].
	h inicio: umaHora.
	h final: outraHora.
	^h</body>

<body>new

	^nil</body>
</methods>

<methods>
<class-id>Horario class</class-id> <category>testing</category>

<body>choca: umaColecaoDeHorarios 
	"retorna true se algum horario choca com os outros"

	"se a coleção estiver vazia, retorna false"

	| cH umHorario |
	umaColecaoDeHorarios isNil | umaColecaoDeHorarios isEmpty ifTrue: [^false].
	cH := umaColecaoDeHorarios copy.
	"remove o primeiro horário"
	umHorario := cH removeFirst.
	"repete até que o resto esteja vazio"
	[cH isEmpty] whileFalse: 
			[(umHorario chocaComColecao: cH) ifTrue: [^true].
			umHorario := cH removeFirst].

	"	[cH isEmpty] whileFalse: 
			[cH do: [:cadaHorario | (umHorario chocaCom: cadaHorario) ifTrue: [^true]].
			umHorario := cH removeFirst].
"
	^false</body>

<body>choca: umaColecaoDeHorarios com: outraColecaoDeHorarios 
	"retorna true se algum horario de uma coleção com algum horário de outra coleção "

	| cH umHorario oCH |
	cH := umaColecaoDeHorarios copy.
	oCH := outraColecaoDeHorarios copy.
	"remove o primeiro horário da primeira colecao"
	umHorario := cH removeFirst.
	"repete até que o resto esteja vazio"
	[cH isEmpty] whileFalse: 
			[cH do: [:cadaHorario | (umHorario chocaComColecao: oCH) ifTrue: [^true]].
			umHorario := cH removeFirst].
	^false</body>
</methods>

<!-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -   -->


<methods>
<class-id>Horario</class-id> <category>private</category>

<body>diaDaSemana
	^diaDaSemana</body>

<body>diaDaSemana: anObject
	diaDaSemana := anObject</body>

<body>final
	^final</body>

<body>final: anObject
	final := anObject</body>

<body>inicio
	^inicio</body>

<body>inicio: anObject
	inicio := anObject</body>
</methods>

<methods>
<class-id>Horario</class-id> <category>testing</category>

<body>chocaCom: outroHorario 
	| cond1 i1 i2 f1 f2 cond2 cond3 |
	cond1 := self diaDaSemana = outroHorario diaDaSemana.
	i1 := self inicio.
	f1 := self final.
	i2 := outroHorario inicio.
	f2 := outroHorario final.
	cond2 := i1 &gt;= i2 &amp; (i1 &lt; f2).
	cond3 := i2 &gt; i1 &amp; (i2 &lt; f1).
	^cond1 &amp; (cond2 | cond3)
	" Não funcionou da forma abaixo. Por quê?
	^[self diaDaSemana = outroHorario diaDaSemana] and: 
			[[self inicio &gt;= outroHorario inicio and: [self final &lt;= outroHorario final]] 
				or: 
					[self inicio &lt;= outroHorario inicio and: [self final &gt;= outroHorario final]]]"</body>

<body>chocaComColecao: umaColecaoDeHorarios 
	"retorna true se algum horario choca com os outros"

	| cH umHorario |
	cH := umaColecaoDeHorarios copy.
	"remove o primeiro horário"
	umHorario := self.
	cH do: [:cadaHorario | (umHorario chocaCom: cadaHorario) ifTrue: [^true]].
	^false</body>
</methods>
<new-page/>


<class>
<name>Aluno</name>
<environment>Smalltalk</environment>
<super>Core.Object</super>
<private>false</private>
<indexed-type>none</indexed-type>
<inst-vars>nUSP pessoa curso listaItensHistorico preMatriculas </inst-vars>
<class-inst-vars></class-inst-vars>
<imports></imports>
<category>MAC441</category>
</class>

<!-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -   -->


<methods>
<class-id>Aluno class</class-id> <category>instance creation</category>

<body>new
	| a |
	a := super new.
	a criaListaItensHistorico.
	a criaListaPreMatriculas.
	^a</body>

<body>nome: umNome rg: umRg cpf: umCPF end: umEnd senha: umaSenha nUSP: umNUSP 
	| a p |
	a := Aluno new.

	"procura pessoa com mesmo rg ou mesmo cpf"
	p := Pessoa existeComRg: umRg ouCpf: umCPF.
	"se não existir tal pessoa, criar uma nova pessoa"
	p = nil 
		ifTrue: 
			[p := Pessoa 
						nome: umNome
						rg: umRg
						cpf: umCPF
						end: umEnd
						senha: umaSenha].
	a pessoa: p.
	a nUSP: umNUSP.
	^a</body>

<body>nome: umNome rg: umRg cpf: umCPF end: umEnd senha: umaSenha nUSP: umNUSP curso: umCurso 
	| a |
	a := Aluno 
				nome: umNome
				rg: umRg
				cpf: umCPF
				end: umEnd
				senha: umaSenha
				nUSP: umNUSP.
	a curso: umCurso.
	^a</body>
</methods>

<methods>
<class-id>Aluno class</class-id> <category>acessing</category>

<body>comNumeroUsp: umNumeroUsp 
	"retorna um aluno com numero USP igual a umNumeroUsp"

	Aluno allInstances notNil &amp; Aluno allInstances notEmpty 
		ifTrue: 
			[^Aluno allInstances 
				detect: [:umAluno | umAluno nUSP printString = umNumeroUsp]
				ifNone: [^nil]]
		ifFalse: [^nil]</body>
</methods>

<!-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -   -->


<methods>
<class-id>Aluno</class-id> <category>accessing</category>

<body>historicoEscolar
	"retorna uma string com o nome do aluno, seu número USP, as matérias lecionadas (ordenadas por data) e a nota obtida"

	| nome numUSP tab cr historico colOrdIH |
	tab := String with: Character tab.
	cr := String with: Character cr.
	nome := self pessoa nome asString.
	numUSP := self nUSP printString.
	historico := cr , 'Historico escolar' , cr.
	historico := historico , 'Nome do aluno: ' , nome , tab , ' Numero USP:  ' 
				, numUSP , cr.
	listaItensHistorico isEmpty 
		ifTrue: 
			[historico := historico 
						, 'Nenhuma disciplina foi concluida pelo aluno ate o momento' , cr]
		ifFalse: 
			[historico := historico , 'Disciplinas concluídas: ' , cr.
			"Ordenar as disciplinas pagas (itens de histórico) por data"
			colOrdIH := listaItensHistorico copy asSortedCollection: 
							[:iH1 :iH2 | 
							iH1 ano &lt; iH2 ano | (iH1 ano = iH2 ano &amp; (iH1 semestre &lt; iH2 semestre))].
			"			colOrdIH := colOrdIH asOrderedCollection."
			colOrdIH do: 
					[:iH | 
					historico := historico , ' Disciplina: ' , iH disciplina nome , tab 
								, ' Ano: ' , iH ano printString 
								, tab , ' Semestre: ' 
								, iH semestre printString , tab 
								, ' Nota: ' , iH nota printString 
								, cr]

			"para cada matéria paga, mostrar seu nome e sua nota"].
	^historico</body>

<body>nome
	^self pessoa nome</body>

<body>poeNota: umaNota disciplina: umaDisciplina semestre: umSemestre ano: umAno frequencia: umaFrequencia 
	"coloca um item de historico no historico do aluno"

	| iH iH2 oc |
	iH := ItemHistorico 
				nota: umaNota
				frequencia: umaFrequencia
				disciplina: umaDisciplina
				ano: umAno
				semestre: umSemestre.
	"verifica se o item de historico ja esta na lista - se estiver, nao adiciona"
	iH2 := listaItensHistorico detect: 
					[:umItem | 
					((umItem disciplina = umaDisciplina &amp; umItem ano) = umAno 
						&amp; umItem semestre) = umSemestre]
				ifNone: [nil].
	iH2 isNil 
		ifTrue: 
			[oc := OrderedCollection new.
			listaItensHistorico do: [:umItem | oc add: umItem].
			oc add: iH.
			self listaItensHistorico: oc].
	^iH</body>

<body>preMatricula: umaTurma 
	"	turma := umaTurma preMatricula: self."

	umaTurma isNil ifFalse: [self preMatriculas add: umaTurma].
	^self preMatriculas</body>
</methods>

<methods>
<class-id>Aluno</class-id> <category>testing</category>

<body>cumpriu: umaColecaoComDisciplinas 
	"verifica se o aluno já pagou todas as disciplinas da coleção"

	| cD uD |
	umaColecaoComDisciplinas isNil ifTrue: [^true].
	cD := umaColecaoComDisciplinas copy.
	[cD isEmpty] whileFalse: 
			["pega uma disciplina da coleção"

			uD := cD removeFirst.
			"vê se ela está na coleção de disciplinas já pagas pelo aluno"
			(self foiPaga: uD) ifFalse: [^false]
			"se não estiver, retorna false - caso contrário, continua"].
	^true</body>

<body>foiPaga: umaDisciplina 
	"verifica se uma disciplina já foi paga (isto é, está na lista de itens do histórico"

	listaItensHistorico 
		do: [:umItem | umItem disciplina = umaDisciplina &amp; (umItem nota &gt;= 5) ifTrue: [^true]].
	^false</body>
</methods>

<methods>
<class-id>Aluno</class-id> <category>removing</category>

<body>removeTurma: umaTurma 
	self preMatriculas remove: umaTurma.
	^self</body>
</methods>

<methods>
<class-id>Aluno</class-id> <category>private</category>

<body>criaListaItensHistorico
	listaItensHistorico := OrderedCollection new</body>

<body>criaListaPreMatriculas
	preMatriculas := OrderedCollection new</body>

<body>curso

	^curso</body>

<body>curso: anObject

	curso := anObject</body>

<body>listaItensHistorico: anObject
	listaItensHistorico := anObject</body>

<body>nUSP

	^nUSP</body>

<body>nUSP: anObject

	nUSP := anObject</body>

<body>pessoa

	^pessoa</body>

<body>pessoa: anObject

	pessoa := anObject</body>

<body>preMatriculas
	^preMatriculas</body>

<body>preMatriculas: anObject
	preMatriculas := anObject</body>
</methods>
<new-page/>


<class>
<name>Departamento</name>
<environment>Smalltalk</environment>
<super>Core.Object</super>
<private>false</private>
<indexed-type>none</indexed-type>
<inst-vars>professores disciplinas cursos </inst-vars>
<class-inst-vars></class-inst-vars>
<imports></imports>
<category>MAC441</category>
</class>

<!-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -   -->


<methods>
<class-id>Departamento class</class-id> <category>instance creation</category>

<body>new
	| dep |
	dep := super new.
	dep
		criaListaProfessores;
		criaListaDisciplinas;
		criaListaCursos.
	^dep</body>
</methods>

<!-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -   -->


<methods>
<class-id>Departamento</class-id> <category>accessing</category>

<body>novaDisciplina: umNome programa: umPrograma codigo: umCodigo preRequisitos: umaColecaoDePreRequisitos 
	| d |
	d := Disciplina 
				nome: umNome
				programa: umPrograma
				codigo: umCodigo
				preRequisitos: umaColecaoDePreRequisitos.
	self disciplinas add: d.
	^d</body>

<body>novoAluno: umNome cpf: umCPF rg: umRG endereco: umEnd senha: umaSenha curso: umNomeDeCurso numeroUsp: umNumUsp 
	"retorna o novo objeto aluno."

	"procura o curso do aluno na lista de cursos do departamento"

	| a oCurso |
	oCurso := self cursos detect: [:each | each nome = umNomeDeCurso]
				ifNone: 
					[Transcript
						cr;
						show: 'Departamento novoAluno: umNome cpf: umCPF rg: umRG endereco: umEnd senha: umaSenha curso: umNomeDeCurso numeroUsp: umNumUsp 
' 
									cr;
						show: 'Curso nao encontrado'.
					^nil].
	a := Aluno 
				nome: umNome
				rg: umRG
				cpf: umCPF
				end: umEnd
				senha: umaSenha
				nUSP: umNumUsp
				curso: oCurso.

	"inclui o aluno na lista de alunos do curso"
	oCurso incluiAluno: a.
	^a</body>

<body>novoCurso: umNomeDeCurso obrigatorias: listaDiscObrigat optativas: listaDiscOptativa numMinimoOptativas: umNumeroOptativas numMinimoForaDeArea: umNumeroForaDeArea 

	| c |

	c := Curso 

				nome: umNomeDeCurso

				discObrigat: listaDiscObrigat

				discOptativa: listaDiscOptativa

				numeroOptativas: umNumeroOptativas

				numeroForaDeArea: umNumeroForaDeArea.

	self cursos add: c.

	^c</body>

<body>novoProfessor: umNome cpf: umCPF rg: umRG endereco: umEnd senha: umaSenha numeroUsp: umNumUsp 
	"retorna o novo objeto professor"

	| d |
	d := Docente 
				nome: umNome
				rg: umRG
				cpf: umCPF
				end: umEnd
				senha: umaSenha
				nUSP: umNumUsp
				departamento: self.
	self professores add: d.
	^d</body>

<body>politicaDeMatricula: umaPolitica para: umaDisciplina 
	"confirmar se a disciplina está na lista de disciplinas do departamento"

	(self disciplinas includes: umaDisciplina) 
		ifTrue: [umaDisciplina politicaDeMatricula: umaPolitica]
		ifFalse: 
			[Transcript
				show: 'politicaDeMatricula: umaPolitica para: umaDisciplina';
				cr;
				show: 'Disciplina não existente']</body>

<body>politicaDeMatricula: umaPolitica paraDisciplina: umNomeDeDisciplina 
	"procurar a disciplina na lista de disciplinas"

	| aDisciplina |
	aDisciplina := self disciplinas 
				detect: [:uD | uD nome = umNomeDeDisciplina]
				ifNone: nil.
	"associar a politica de matricula à disciplina"
	aDisciplina = nil 
		ifTrue: 
			[Transcript
				show: 'politicaDeMatricula: umaPolitica paraDisciplina: umNomeDeDisciplina';
				cr;
				show: 'Disciplina não existente']
		ifFalse: [aDisciplina politicaDeMatricula: umaPolitica]</body>
</methods>

<methods>
<class-id>Departamento</class-id> <category>private</category>

<body>criaListaCursos
	cursos := OrderedCollection new</body>

<body>criaListaDisciplinas
	disciplinas := OrderedCollection new</body>

<body>criaListaProfessores
	professores := OrderedCollection new.</body>

<body>cursos

	^cursos</body>

<body>cursos: anObject

	cursos := anObject</body>

<body>disciplinas

	^disciplinas</body>

<body>disciplinas: anObject

	disciplinas := anObject</body>

<body>professores

	^professores</body>

<body>professores: anObject

	professores := anObject</body>
</methods>
<new-page/>


<class>
<name>Pessoa</name>
<environment>Smalltalk</environment>
<super>Core.Object</super>
<private>false</private>
<indexed-type>none</indexed-type>
<inst-vars>nome rg cpf end senha </inst-vars>
<class-inst-vars></class-inst-vars>
<imports></imports>
<category>MAC441</category>
</class>

<!-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -   -->


<methods>
<class-id>Pessoa class</class-id> <category>instance creation</category>

<body>new

	"cria uma nova pessoa"



	| p |

	p := super new.

	^p</body>

<body>nome: umNome rg: umRg cpf: umCpf end: umEnd senha: umaSenha 

	"cria uma nova pessoa"



	| p |

	p := super new.

	p nome: umNome.

	p rg: umRg.

	p cpf: umCpf.

	p end: umEnd.

	p senha: umaSenha.

	^p</body>
</methods>

<methods>
<class-id>Pessoa class</class-id> <category>accessing</category>

<body>existeComRg: umRg ouCpf: umCPF 
	"se já existe uma pessoa com o RG ou o CPF indicado, retorna a pessoa"

	^Pessoa allInstances 
		detect: [:umaPessoa | umaPessoa rg = umRg or: [umaPessoa cpf = umCPF]]
		ifNone: nil</body>
</methods>

<!-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -   -->


<methods>
<class-id>Pessoa</class-id> <category>private</category>

<body>cpf

	^cpf</body>

<body>cpf: anObject

	cpf := anObject</body>

<body>end

	^end</body>

<body>end: anObject

	end := anObject</body>

<body>nome

	^nome</body>

<body>nome: anObject

	nome := anObject</body>

<body>rg

	^rg</body>

<body>rg: anObject

	rg := anObject</body>

<body>senha

	^senha</body>

<body>senha: anObject

	senha := anObject</body>
</methods>
<new-page/>


<shared-variable>
<name>NUM</name>
<environment>Smalltalk</environment>
<private>false</private>
<constant>false</constant>
<category>MAC441</category>
<initializer>1</initializer>
</shared-variable>
<new-page/>


<class>
<name>JanelaProfessor</name>
<environment>Smalltalk</environment>
<super>UI.ApplicationModel</super>
<private>false</private>
<indexed-type>none</indexed-type>
<inst-vars>professor controleAcademico nomeProfessor </inst-vars>
<class-inst-vars></class-inst-vars>
<imports></imports>
<category>MAC441</category>
</class>

<!-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -   -->


<methods>
<class-id>JanelaProfessor class</class-id> <category>interface specs</category>

<body>windowSpec
	"UIPainter new openOnClass: self andSelector: #windowSpec"

	&lt;resource: #canvas&gt;
	^#(#{UI.FullSpec} 
		#window: 
		#(#{UI.WindowSpec} 
			#label: 'Professor' 
			#bounds: #(#{Graphics.Rectangle} 512 384 712 584 ) 
			#colors: 
			#(#{UI.LookPreferences} 
				#setBackgroundColor: #(#{Graphics.ColorValue} 5119 8191 8191 ) ) ) 
		#component: 
		#(#{UI.SpecCollection} 
			#collection: #(
				#(#{UI.InputFieldSpec} 
					#layout: #(#{Graphics.Rectangle} 52 58 152 81 ) 
					#name: #InomeProfessor 
					#model: #nomeProfessor ) ) ) )</body>
</methods>

<!-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -   -->


<methods>
<class-id>JanelaProfessor</class-id> <category>accessing</category>

<body>controleAcademico
	^controleAcademico</body>

<body>controleAcademico: anObject
	controleAcademico := anObject</body>

<body>professor
	^professor</body>

<body>professor: anObject
	professor := anObject</body>
</methods>

<methods>
<class-id>JanelaProfessor</class-id> <category>actions</category>

<body>changeRequest
	^super changeRequest 
		ifFalse: [false]
		ifTrue: 
			[controleAcademico notNil 
				ifTrue: [controleAcademico removeJanelaProfessor: self].
			true]</body>
</methods>

<methods>
<class-id>JanelaProfessor</class-id> <category>aspects</category>

<body>nomeProfessor
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^nomeProfessor isNil 
		ifTrue: 
			[(professor isNil or: [professor nome isNil]) 
				ifTrue: [nomeProfessor := String new asValue]
				ifFalse: [nomeProfessor := professor nome asValue]]
		ifFalse: [nomeProfessor]</body>
</methods>
<new-page/>


<class>
<name>Instrutor</name>
<environment>Smalltalk</environment>
<super>Usuario</super>
<private>false</private>
<indexed-type>none</indexed-type>
<inst-vars></inst-vars>
<class-inst-vars></class-inst-vars>
<imports></imports>
<category>MAC441</category>
</class>

<!-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -   -->


<methods>
<class-id>Instrutor class</class-id> <category>instance creation</category>

<body>nome: umNome numeroUsp: numeroUSP email:umEmail

	|a|

	a:=super nome: umNome numeroUsp: numeroUSP email:umEmail.

	a quantidadeMaximaDeEmprestimos: 50.

	a diasDeEmprestimo: 7.

	a tipo:#instrutor.

	^ a</body>

<body>nome: umNome rg:umRG email:umEmail

	Transcript show: 'Instrutores devem ter numero USP'.</body>
</methods>

<!-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -   -->

<new-page/>


<class>
<name>Disciplina</name>
<environment>Smalltalk</environment>
<super>Core.Object</super>
<private>false</private>
<indexed-type>none</indexed-type>
<inst-vars>programa nome codigo politicaDeMatricula preRequisitos </inst-vars>
<class-inst-vars></class-inst-vars>
<imports></imports>
<category>MAC441</category>
</class>

<!-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -   -->


<methods>
<class-id>Disciplina class</class-id> <category>instance creation</category>

<body>new
	| d |
	d := super new.
	^d</body>

<body>nome: umNome programa: umPrograma codigo: umCodigo preRequisitos: umaColecaoDePreRequisitos 
	| d |
	d := Disciplina new.
	d
		nome: umNome;
		programa: umPrograma;
		codigo: umCodigo;
		preRequisitos: umaColecaoDePreRequisitos.
	^d</body>
</methods>

<!-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -   -->


<methods>
<class-id>Disciplina</class-id> <category>private</category>

<body>codigo
	^codigo</body>

<body>codigo: anObject
	codigo := anObject</body>

<body>nome
	^nome</body>

<body>nome: anObject
	nome := anObject</body>

<body>politicaDeMatricula
	^politicaDeMatricula</body>

<body>politicaDeMatricula: anObject
	politicaDeMatricula := anObject</body>

<body>preRequisitos
	^preRequisitos</body>

<body>preRequisitos: anObject
	preRequisitos := anObject</body>

<body>programa
	^programa</body>

<body>programa: anObject
	programa := anObject</body>
</methods>
<new-page/>


<class>
<name>MatriculaPorOrdem</name>
<environment>Smalltalk</environment>
<super>PoliticaDeMatricula</super>
<private>false</private>
<indexed-type>none</indexed-type>
<inst-vars></inst-vars>
<class-inst-vars></class-inst-vars>
<imports></imports>
<category>MAC441</category>
</class>

<!-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -   -->


<methods>
<class-id>MatriculaPorOrdem class</class-id> <category>instance creation</category>

<body>new
	^super new</body>
</methods>

<!-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -   -->


<methods>
<class-id>MatriculaPorOrdem</class-id> <category>accessing</category>

<body>selecionePrimeiros: n dentre: colecaoDeAlunos disciplina: umaDisciplina 
	"ordena os alunos conforme seu critério interno e retorna os  primeiros n"

	| interessados selecionados i |
	interessados := colecaoDeAlunos copy.
	interessados notEmpty 
		ifTrue: 
			[" fazendo o mesmo que 	^(interessados removeFirst: (interessados size min: n))  asOrderedCollection"

			selecionados := OrderedCollection new.
			i := 1.
			[i &lt;= (interessados size min: n)] whileTrue: 
					[selecionados add: (interessados at: i).
					i := i + 1].
			^selecionados]
		ifFalse: [^interessados]</body>
</methods>
<new-page/>


<name-space>
<name>MAC441</name>
<environment>Smalltalk</environment>
<private>false</private>
<imports>
			private Smalltalk.*
			</imports>
<category>MAC441</category>
</name-space>

<comment>
<name-space-id>MAC441</name-space-id>
<body>Missing comment</body>
</comment>
<new-page/>


<class>
<name>Item</name>
<environment>Smalltalk</environment>
<super>Core.Object</super>
<private>false</private>
<indexed-type>none</indexed-type>
<inst-vars>numero status </inst-vars>
<class-inst-vars>NUM </class-inst-vars>
<imports></imports>
<category>MAC441</category>
</class>

<!-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -   -->


<methods>
<class-id>Item class</class-id> <category>class initialization</category>

<body>initialize

	"inicia o valor da variável de classe NUM"



	NUM := 0.

	^NUM</body>
</methods>

<methods>
<class-id>Item class</class-id> <category>acessing</category>

<body>devolveNUM

	"devolve o valor da variável de classe NUM"



	^NUM</body>

<body>incrementaNUM

	"incrementa o valor da variável de classe NUM"



	NUM := NUM + 1.

	^NUM</body>
</methods>

<methods>
<class-id>Item class</class-id> <category>instance creation</category>

<body>new

	"cria um Item com um número único"



	| it |

	it := super new.

	Item incrementaNUM.

	it numero: Item devolveNUM.

	it status: #disponivel.

	^it</body>
</methods>

<!-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -   -->


<methods>
<class-id>Item</class-id> <category>accessing</category>

<body>numero

	^numero</body>

<body>numero: anObject

	numero := anObject</body>

<body>status

	^status</body>

<body>status: anObject

	status := anObject</body>
</methods>
<new-page/>


<class>
<name>ControleAcademico</name>
<environment>Smalltalk</environment>
<super>UI.ApplicationModel</super>
<private>false</private>
<indexed-type>none</indexed-type>
<inst-vars>janelasAluno janelasProfessor </inst-vars>
<class-inst-vars></class-inst-vars>
<imports></imports>
<category>MAC441</category>
</class>

<!-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -   -->


<methods>
<class-id>ControleAcademico class</class-id> <category>interface specs</category>

<body>windowSpec
	"UIPainter new openOnClass: self andSelector: #windowSpec"

	&lt;resource: #canvas&gt;
	^#(#{UI.FullSpec} 
		#window: 
		#(#{UI.WindowSpec} 
			#label: 'Sistema de Controle Acadêmico' 
			#min: #(#{Core.Point} 349 139 ) 
			#max: #(#{Core.Point} 349 139 ) 
			#bounds: #(#{Graphics.Rectangle} 512 384 861 523 ) 
			#colors: 
			#(#{UI.LookPreferences} 
				#setBackgroundColor: #(#{Graphics.ColorValue} 7167 8191 7167 ) ) ) 
		#component: 
		#(#{UI.SpecCollection} 
			#collection: #(
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.Rectangle} 129 29 207 56 ) 
					#name: #BotaoAluno 
					#colors: 
					#(#{UI.LookPreferences} 
						#setForegroundColor: #(#{Graphics.ColorValue} #blue ) 
						#setBackgroundColor: #(#{Graphics.ColorValue} 8191 8191 5119 ) ) 
					#model: #chamaJanelaAluno 
					#label: 'Aluno' 
					#style: #pixelLarge 
					#defaultable: true ) 
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.Rectangle} 129 70 209 96 ) 
					#name: #BotaoProfessor 
					#colors: 
					#(#{UI.LookPreferences} 
						#setForegroundColor: #(#{Graphics.ColorValue} #blue ) 
						#setBackgroundColor: #(#{Graphics.ColorValue} 8191 8191 5119 ) ) 
					#model: #chamaJanelaSenhaProfessor 
					#label: 'Professor' 
					#defaultable: true ) ) ) )</body>
</methods>

<methods>
<class-id>ControleAcademico class</class-id> <category>instance creation</category>

<body>new
	| ca |
	ca := super new.
	ca janelasAluno: OrderedCollection new.
	ca janelasProfessor: OrderedCollection new.
	^ca</body>
</methods>

<!-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -   -->


<methods>
<class-id>ControleAcademico</class-id> <category>accessing</category>

<body>janelasAluno
	^janelasAluno</body>

<body>janelasAluno: anObject
	janelasAluno := anObject</body>

<body>janelasProfessor
	^janelasProfessor</body>

<body>janelasProfessor: anObject
	janelasProfessor := anObject</body>
</methods>

<methods>
<class-id>ControleAcademico</class-id> <category>actions</category>

<body>chamaJanelaAluno
	"permite abrir várias janelas de alunos"

	| numUSP oAluno umaJanelaAluno jm jm2 |
	numUSP := Dialog 
				request: 'Número USP'
				initialAnswer: ''
				onCancel: [^nil]
				windowLabel: 'Digite seu número USP'
				for: nil.

	"Procura o aluno com este numero usp"
	oAluno := Aluno comNumeroUsp: numUSP.

	"Se não existir o aluno, mostra mensagem"
	oAluno isNil 
		ifTrue: 
			[Dialog warn: 'Não existe aluno com este número USP'.
			^nil].
	(self existeJanelaParaAluno: oAluno) 
		ifTrue: [Dialog warn: 'Já existe uma janela aberta para este aluno!']
		ifFalse: 
			["cria uma nova janela para o aluno"

			umaJanelaAluno := JanelaAluno new.
			self janelasAluno add: umaJanelaAluno.
			umaJanelaAluno aluno: oAluno.
			umaJanelaAluno controleAcademico: self.

			"abre a janela e faz com que ela seja escrava da principal"
			jm := self builder window.
			jm
				application: self;
				beMaster.
			jm2 := umaJanelaAluno open window.
			jm2
				application: self;
				beSlave]</body>

<body>chamaJanelaSenhaProfessor
	| numUSP oProfessor umaJanelaSenhaProfessor jm jm2 |
	numUSP := Dialog 
				request: 'Número USP'
				initialAnswer: ''
				onCancel: [^nil]
				windowLabel: 'Digite seu número USP'
				for: nil.

	"Procura o professor com este numero usp"
	oProfessor := Docente comNumeroUsp: numUSP.

	"Se não existir o professor, mostra mensagem"
	oProfessor isNil 
		ifTrue: 
			[Dialog warn: 'Não existe professor com este número USP'.
			^nil].
	(self existeJanelaParaProfessor: oProfessor) 
		ifTrue: [Dialog warn: 'Já existe uma janela aberta para este professor!']
		ifFalse: 
			["cria uma nova janela receber a senha do professor"

			"cria uma nova janela para receber a senha do professor"

			umaJanelaSenhaProfessor := JanelaSenhaProfessor new.
			self janelasProfessor add: umaJanelaSenhaProfessor.
			umaJanelaSenhaProfessor professor: oProfessor.
			umaJanelaSenhaProfessor controleAcademico: self.
			"abre a janela e faz com que ela seja escrava da principal"
			jm := self builder window.
			jm
				application: self;
				beMaster.
			jm2 := umaJanelaSenhaProfessor open window.
			jm2
				application: self;
				beSlave]</body>
</methods>

<methods>
<class-id>ControleAcademico</class-id> <category>testing</category>

<body>existeJanelaParaAluno: umAluno 
	self janelasAluno 
		do: [:janelaAluno | janelaAluno aluno = umAluno ifTrue: [^true]].
	^false</body>

<body>existeJanelaParaProfessor: umProfessor 
	self janelasProfessor 
		do: [:janelaProfessor | janelaProfessor professor = umProfessor ifTrue: [^true]].
	^false</body>
</methods>

<methods>
<class-id>ControleAcademico</class-id> <category>removing</category>

<body>removeJanelaAluno: umaJanelaAluno 
	^self janelasAluno remove: umaJanelaAluno</body>

<body>removeJanelaProfessor: umaJanelaProfessor 
	^self janelasProfessor remove: umaJanelaProfessor</body>
</methods>
<new-page/>


<class>
<name>Emprestimo</name>
<environment>Smalltalk</environment>
<super>Core.Object</super>
<private>false</private>
<indexed-type>none</indexed-type>
<inst-vars>usuario item devolucao </inst-vars>
<class-inst-vars></class-inst-vars>
<imports></imports>
<category>MAC441</category>
</class>

<!-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -   -->


<methods>
<class-id>Emprestimo class</class-id> <category>instance creation</category>

<body>usuario:umUsuario item:umItem devolucao:umaData

|a |

a:=(super new).

a usuario:umUsuario.

a item:umItem.

a dataDeDevolucao: umaData.

^a.</body>
</methods>

<!-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -   -->


<methods>
<class-id>Emprestimo</class-id> <category>accessing</category>

<body>dataDeDevolucao

	^devolucao.</body>

<body>dataDeDevolucao:data

	devolucao:=data.</body>

<body>item

	^item.</body>

<body>item: umItem

	item:=umItem.</body>

<body>usuario

	^usuario.</body>

<body>usuario: umUsuario

	usuario := umUsuario.</body>
</methods>
<new-page/>


<class>
<name>TipoDeItem</name>
<environment>Smalltalk</environment>
<super>Core.Object</super>
<private>false</private>
<indexed-type>none</indexed-type>
<inst-vars>nome itens </inst-vars>
<class-inst-vars></class-inst-vars>
<imports></imports>
<category>MAC441</category>
</class>

<shared-variable>
<name>Itens</name>
<environment>TipoDeItem</environment>
<private>false</private>
<constant>false</constant>
<category>As yet unclassified</category>
</shared-variable>

<!-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -   -->


<methods>
<class-id>TipoDeItem class</class-id> <category>instance creation</category>

<body>new

	|a|

	a:=(super new).

	a criaListaItens.

	^a.</body>

<body>new: novoTipo 

	| a |

	a := super new.

	a nome: novoTipo.

	a criaListaItens.

	^a</body>
</methods>

<!-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -   -->


<methods>
<class-id>TipoDeItem</class-id> <category>accessing</category>

<body>itens

	^itens.</body>

<body>nome

	^nome.</body>

<body>nome: umNome

	nome:= umNome</body>
</methods>

<methods>
<class-id>TipoDeItem</class-id> <category>removing</category>

<body>retiraItem: umNumeroDeItem 

	"indica que um item saiu do estoque definitivamente"



	"Procura um item na lista de itens"



	| it |

	it := itens detect: 

					[:cada | 

					cada numero = umNumeroDeItem 

						&amp; (cada status = #noconserto | (cada status = #disponivel))]

				ifNone: 

					[Transcript

						show: 'numero de Item nao encontrado';

						cr.

					^nil].

	itens remove: it

		ifAbsent: 

			[Transcript

				show: 'Classe TipoDeItem - Método retiraItem - Item não está na lista';

				cr]</body>
</methods>

<methods>
<class-id>TipoDeItem</class-id> <category>private</category>

<body>criaListaItens

	"Cria uma lista de itens vazia"



	itens := OrderedCollection new</body>
</methods>

<methods>
<class-id>TipoDeItem</class-id> <category>adding</category>

<body>novoItem

	|a|

	a := Item new.

	itens add: a.

	^ a</body>
</methods>

<initialize>
<variable-id>NUM</variable-id>
</initialize>

<initialize>
<class-id>Item</class-id>
</initialize>














<class>
<name>TesteGUI</name>
<environment>MAC441</environment>
<super>UI.ApplicationModel</super>
<private>false</private>
<indexed-type>none</indexed-type>
<inst-vars></inst-vars>
<class-inst-vars></class-inst-vars>
<imports></imports>
<category>MAC441</category>
</class>

<!-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -   -->


<methods>
<class-id>MAC441.TesteGUI class</class-id> <category>interface specs</category>

<body>windowSpec
	"UIPainter new openOnClass: self andSelector: #windowSpec"

	&lt;resource: #canvas&gt;
	^#(#{UI.FullSpec} 
		#window: 
		#(#{UI.WindowSpec} 
			#label: 'Unlabeled Canvas' 
			#min: #(#{Core.Point} 20 20 ) 
			#max: #(#{Core.Point} 200 200 ) 
			#bounds: #(#{Graphics.Rectangle} 512 384 712 584 ) ) 
		#component: 
		#(#{UI.SpecCollection} 
			#collection: #(
				#(#{UI.LabelSpec} 
					#layout: #(#{Graphics.Rectangle} 54 74 84 95 ) 
					#name: #Label1 
					#flags: 32 
					#label: #Label ) 
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.Rectangle} 53 139 134 162 ) 
					#name: #ActionButton1 
					#model: #USP 
					#label: 'USP' 
					#defaultable: true ) ) ) )</body>
</methods>

<!-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -   -->


<methods>
<class-id>MAC441.TesteGUI</class-id> <category>accessing</category>

<body>USP
	Transcript
		show: 'Adolfo';
		cr</body>
</methods>














</st-source>
