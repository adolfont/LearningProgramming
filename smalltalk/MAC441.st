<?xml version="1.0"?>

<st-source>



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
	umaDisciplina novaTurma: t.
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
<name>Disciplina</name>
<environment>Smalltalk</environment>
<super>Core.Object</super>
<private>false</private>
<indexed-type>none</indexed-type>
<inst-vars>programa nome codigo politicaDeMatricula preRequisitos turmas </inst-vars>
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
	d turmas: OrderedCollection new.
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

<methods>
<class-id>Disciplina</class-id> <category>printing</category>

<body>displayString
	^codigo displayString , '  ' , nome displayString</body>
</methods>

<methods>
<class-id>Disciplina</class-id> <category>accessing</category>

<body>novaTurma: umaTurma 
	turmas add: umaTurma</body>

<body>turmas
	^turmas</body>

<body>turmas: anObject
	turmas := anObject</body>
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

<body>novaTurmaComProfessor: umProfessor para: umaDisciplina horario: umHorario vagas: umasVagas 
	self halt.
	(self professores includes: umProfessor) 
		ifFalse: 
			[Dialog warn: 'Professor não faz parte do departamento! Turma não criada!'.
			^nil]
		ifTrue: 
			[self professores do: 
					[:umProf | 
					umProf = umProfessor 
						ifTrue: 
							[^umProf 
								novaTurmaPara: umaDisciplina
								horario: umHorario
								vagas: umasVagas]]]</body>

<body>professores

	^professores</body>

<body>professores: anObject

	professores := anObject</body>
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
						show: 'Turma notas: umDicionarioComNotasDosAlunos';
						cr;
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
	quantAlunos &gt; 0 
		ifTrue: [mediaAlunos := (mediaAlunos / quantAlunos) asFloat]
		ifFalse: [mediaAlunos := nil].
	iC := ItemDeCarreira 
				disciplina: self disciplina
				mediaAluno: mediaAlunos
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

<methods>
<class-id>Turma</class-id> <category>printing</category>

<body>displayString
	| strHorario |
	strHorario := String new.
	horario notNil 
		ifTrue: 
			[horario 
				do: [:umHorario | strHorario := strHorario , '  ' , umHorario displayString]].
	^disciplina nome , '  ' , docente nome displayString , strHorario</body>

<body>displayString2
	| strHorario |
	strHorario := String new.
	horario notNil 
		ifTrue: 
			[horario 
				do: [:umHorario | strHorario := strHorario , '  ' , umHorario displayString]].
	^disciplina nome displayString , strHorario</body>
</methods>
<new-page/>


<class>
<name>ControleAcademico</name>
<environment>Smalltalk</environment>
<super>UI.ApplicationModel</super>
<private>false</private>
<indexed-type>none</indexed-type>
<inst-vars>janelasAluno janelasProfessor depto </inst-vars>
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

<body>depto
	^depto</body>

<body>depto: anObject
	depto := anObject</body>

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

			umaJanelaAluno := JanelaAluno criaComAluno: oAluno.
			self janelasAluno add: umaJanelaAluno.
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
<name>Alunos</name>
<environment>Smalltalk</environment>
<super>UI.ApplicationModel</super>
<private>false</private>
<indexed-type>none</indexed-type>
<inst-vars>alunos </inst-vars>
<class-inst-vars></class-inst-vars>
<imports></imports>
<category>MAC441</category>
</class>

<!-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -   -->


<methods>
<class-id>Alunos class</class-id> <category>interface specs</category>

<body>windowSpec
	"UIPainter new openOnClass: self andSelector: #windowSpec"

	&lt;resource: #canvas&gt;
	^#(#{UI.FullSpec} 
		#window: 
		#(#{UI.WindowSpec} 
			#label: 'Alunos' 
			#bounds: #(#{Graphics.Rectangle} 512 384 890 615 ) 
			#colors: 
			#(#{UI.LookPreferences} 
				#setBackgroundColor: #(#{Graphics.ColorValue} 7167 7679 8191 ) ) ) 
		#component: 
		#(#{UI.SpecCollection} 
			#collection: #(
				#(#{UI.SequenceViewSpec} 
					#layout: #(#{Graphics.Rectangle} 80 42 342 173 ) 
					#name: #Alunos 
					#model: #Alunos 
					#useModifierKeys: true 
					#selectionType: #highlight ) 
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.Rectangle} 82 192 337 213 ) 
					#name: #atualizaAlunos 
					#model: #atualizaAlunos 
					#label: 'Atualiza a lista de alunos' 
					#defaultable: true ) ) ) )</body>
</methods>

<!-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -   -->


<methods>
<class-id>Alunos</class-id> <category>aspects</category>

<body>Alunos
	^alunos</body>

<body>Alunos2
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	| dadosAlunos strAluno |
	^alunos isNil 
		ifTrue: 
			[dadosAlunos := OrderedCollection new.
			Aluno allInstances do: 
					[:umAluno | 
					strAluno := umAluno nUSP displayString , '  ' , umAluno nome.
					dadosAlunos add: strAluno].
			alunos := SelectionInList with: dadosAlunos asList]
		ifFalse: [alunos]</body>

<body>atualizaAlunos
	(self builder componentAt: #Alunos) widget invalidate</body>
</methods>

<methods>
<class-id>Alunos</class-id> <category>initialize-release</category>

<body>initialize
	Aluno allInstances notNil 
		ifTrue: [alunos := SelectionInList with: Aluno allInstances asList]
		ifFalse: [alunos := SelectionInList new asList]

	"	| dadosAlunos strAluno |
	dadosAlunos := OrderedCollection new.
	Aluno allInstances do: 
			[:umAluno | 
			strAluno := umAluno displayString.
			dadosAlunos add: strAluno].
	alunos := SelectionInList with: dadosAlunos asList
"</body>
</methods>

<methods>
<class-id>Alunos</class-id> <category>accessing</category>

<body>alunos
	^alunos</body>

<body>alunos: anObject
	^alunos := anObject</body>
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
<name>JanelaProfessor</name>
<environment>Smalltalk</environment>
<super>UI.ApplicationModel</super>
<private>false</private>
<indexed-type>none</indexed-type>
<inst-vars>professor controleAcademico nomeProfessor turmasDoSemestre turmas </inst-vars>
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
			#min: #(#{Core.Point} 20 20 ) 
			#max: #(#{Core.Point} 1024 768 ) 
			#bounds: #(#{Graphics.Rectangle} 398 384 1024 683 ) 
			#colors: 
			#(#{UI.LookPreferences} 
				#setBackgroundColor: #(#{Graphics.ColorValue} 8191 8191 6143 ) ) ) 
		#component: 
		#(#{UI.SpecCollection} 
			#collection: #(
				#(#{UI.InputFieldSpec} 
					#layout: #(#{Graphics.Rectangle} 71 26 364 52 ) 
					#name: #InomeProfessor 
					#model: #nomeProfessor 
					#isReadOnly: true ) 
				#(#{UI.LabelSpec} 
					#layout: #(#{Core.Point} 23 29 ) 
					#name: #Label1 
					#label: 'Nome:' 
					#style: #default ) 
				#(#{UI.LabelSpec} 
					#layout: #(#{Core.Point} 23 64 ) 
					#name: #Label2 
					#label: 'Turmas' 
					#style: #default ) 
				#(#{UI.SequenceViewSpec} 
					#layout: #(#{Graphics.Rectangle} 24 90 589 254 ) 
					#name: #turmasDoSemestre 
					#model: #turmasDoSemestre 
					#useModifierKeys: true 
					#selectionType: #highlight ) 
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.Rectangle} 31 264 213 292 ) 
					#name: #novaTurma 
					#model: #novaTurma 
					#label: 'Nova Turma' 
					#defaultable: true ) ) ) )</body>
</methods>

<methods>
<class-id>JanelaProfessor class</class-id> <category>instance creation</category>

<body>criaCom: umProfessor ca: umControleAcademico 
	| jp |
	jp := super new.
	jp professor: umProfessor.
	jp controleAcademico: umControleAcademico.
	jp inicializaTurmas.
	^jp</body>
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

<body>turmas
	^turmas</body>

<body>turmas: anObject
	turmas := anObject</body>

<body>turmasDoSemestre
	^turmasDoSemestre</body>

<body>turmasDoSemestre: anObject
	turmasDoSemestre := anObject</body>
</methods>

<methods>
<class-id>JanelaProfessor</class-id> <category>actions</category>

<body>chamaJanelaProfessorNovaTurma
	| umaJanelaProfessorNovaTurma jm jm2 |
	umaJanelaProfessorNovaTurma := JanelaProfessorNovaTurma 
				criaCom: self professor
				ca: self controleAcademico.
	self controleAcademico janelasProfessor add: umaJanelaProfessorNovaTurma.

	"abre a janela e faz com que ela seja escrava da principal"
	jm := self controleAcademico builder window.
	jm
		application: self;
		beMaster.
	jm2 := umaJanelaProfessorNovaTurma open window.
	jm2
		application: self;
		beSlave.
	self closeRequest</body>

<body>changeRequest
	^super changeRequest 
		ifFalse: [false]
		ifTrue: 
			[controleAcademico notNil 
				ifTrue: [controleAcademico removeJanelaProfessor: self].
			true]</body>

<body>novaTurma
	^self chamaJanelaProfessorNovaTurma</body>

<body>turmaSelecionada: umaTurma</body>
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

<methods>
<class-id>JanelaProfessor</class-id> <category>interface open</category>

<body>inicializaTurmas
	self professor notNil 
		ifTrue: 
			[turmas := self professor turmasDoSemestre.
			turmasDoSemestre := SelectionInList 
						adapt: self
						aspect: #turmasDoSemestre
						list: #turmas
						selection: #turmaSelecionada:]</body>
</methods>
<new-page/>


<class>
<name>JanelaAluno</name>
<environment>Smalltalk</environment>
<super>UI.ApplicationModel</super>
<private>false</private>
<indexed-type>none</indexed-type>
<inst-vars>aluno nomeAluno controleAcademico interessesAluno alunoValor preMatriculas collectionModel pM interesses </inst-vars>
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
			#min: #(#{Core.Point} 10 10 ) 
			#max: #(#{Core.Point} 756 340 ) 
			#bounds: #(#{Graphics.Rectangle} 268 384 1024 724 ) 
			#colors: 
			#(#{UI.LookPreferences} 
				#setBackgroundColor: #(#{Graphics.ColorValue} 1024 1024 8191 ) ) ) 
		#component: 
		#(#{UI.SpecCollection} 
			#collection: #(
				#(#{UI.InputFieldSpec} 
					#layout: #(#{Graphics.Rectangle} 63 39 254 61 ) 
					#name: #nomeAluno 
					#model: #nomeAluno 
					#style: #'Arbor-14' 
					#isReadOnly: true ) 
				#(#{UI.LabelSpec} 
					#layout: #(#{Core.Point} 18 38 ) 
					#name: #Label1 
					#label: 'Nome:' 
					#style: #'Arbor-12' ) 
				#(#{UI.LabelSpec} 
					#layout: #(#{Core.Point} 18 79 ) 
					#name: #Label2 
					#label: 'Interesses' 
					#style: #'Arbor-14' ) 
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.Rectangle} 29 299 130 326 ) 
					#name: #ActionButton1 
					#colors: 
					#(#{UI.LookPreferences} 
						#setBackgroundColor: #(#{Graphics.ColorValue} 4096 6143 8191 ) ) 
					#model: #janelaMatriculaAluno 
					#label: 'Nova matrícula' 
					#defaultable: true ) 
				#(#{UI.SequenceViewSpec} 
					#layout: #(#{Graphics.Rectangle} 22 106 734 285 ) 
					#name: #interesses 
					#model: #interesses 
					#useModifierKeys: true 
					#selectionType: #highlight ) ) ) )</body>
</methods>

<methods>
<class-id>JanelaAluno class</class-id> <category>instance creation</category>

<body>criaComAluno: umAluno 
	| ja |
	ja := super new.
	ja aluno: umAluno.
	ja preMatriculas: SelectionInList new.
	ja pM: umAluno preMatriculas.
	ja initialize.
	^ja</body>

<body>new
	^super new</body>
</methods>

<!-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -   -->


<methods>
<class-id>JanelaAluno</class-id> <category>accessing</category>

<body>aluno
	^aluno</body>

<body>aluno: anObject
	aluno := anObject</body>

<body>alunoValor: anObject
	alunoValor := anObject</body>

<body>collectionModel
	^collectionModel</body>

<body>collectionModel: anObject
	collectionModel := anObject</body>

<body>controleAcademico
	^controleAcademico</body>

<body>controleAcademico: anObject
	controleAcademico := anObject</body>

<body>pM
	^pM</body>

<body>pM: anObject
	pM := anObject</body>

<body>preMatriculas
	^preMatriculas</body>

<body>preMatriculas: anObject
	preMatriculas := anObject</body>

<body>teste: anObject
	interesses := anObject</body>
</methods>

<methods>
<class-id>JanelaAluno</class-id> <category>aspects</category>

<body>alunoValorX
	"DESATUALIZADO"

	| adaptador |
	adaptador := AspectAdaptor accessWith: #nome assignWith: #nome:.
	adaptador subject: self aluno.
	aluno addDependent: adaptador.
	^adaptador

	"	adaptor := AspectAdaptor subjectChannel: self aluno.
	adaptor forAspect: #nome.
	^adaptor accessWith: #nome assignWith: #nome:"</body>

<body>interesses
	^interesses</body>

<body>interessesAluno

	^preMatriculas
	"
	| adaptador |
	self halt.
	adaptador := AspectAdaptor subject: self aluno preMatriculas.
	^adaptador
"
	"	adaptor := AspectAdaptor subjectChannel: self aluno.
	adaptor forAspect: #nome.
	^adaptor accessWith: #nome assignWith: #nome:"</body>

<body>interessesAlunoAntigo
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	| listaStringInteresses |
	^interessesAluno isNil 
		ifTrue: 
			[listaStringInteresses := OrderedCollection new.
			aluno notNil 
				ifTrue: 
					[aluno preMatriculas 
						do: [:pM | listaStringInteresses add: pM disciplina nome]].
			interessesAluno := SelectionInList with: listaStringInteresses asList]
		ifFalse: [interessesAluno]</body>

<body>nomeAluno
	| adaptador |
	adaptador := AspectAdaptor subjectChannel: self aluno.
	adaptador forAspect: #nome.
	"	adaptador onChangeSend: #atualizaAlunos to: (Alunos allInstances at: 1)."
	"	aluno addDependent: adaptador."
	^adaptador

	"	adaptor := AspectAdaptor subjectChannel: self aluno.
	adaptor forAspect: #nome.
	^adaptor accessWith: #nome assignWith: #nome:"</body>
</methods>

<methods>
<class-id>JanelaAluno</class-id> <category>actions</category>

<body>atualizaPreMatriculas
	(self builder componentAt: #interesses) widget invalidate

	"	self halt: 'atPM'.
	self 
		preMatriculas: (SelectionInList with: self aluno preMatriculas asList).
	(self builder componentAt: #interessesAluno) widget invalidate"</body>

<body>atualizaTurmas</body>

<body>changeRequest
	^super changeRequest 
		ifFalse: [false]
		ifTrue: 
			[controleAcademico notNil 
				ifTrue: [controleAcademico removeJanelaAluno: self].
			true]</body>

<body>janelaMatriculaAluno
	| umaJanelaMatriculaAluno jm jm2 |
	umaJanelaMatriculaAluno := JanelaMatriculaAluno criaComAluno: self aluno
				ca: self controleAcademico.
	self controleAcademico janelasAluno add: umaJanelaMatriculaAluno.
	"	umaJanelaMatriculaAluno controleAcademico: self controleAcademico."

	"abre a janela e faz com que ela seja escrava da principal"
	jm := self controleAcademico builder window.
	jm
		application: self controleAcademico;
		beMaster.
	jm2 := umaJanelaMatriculaAluno open window.
	jm2
		application: self controleAcademico;
		beSlave.
	self closeRequest</body>

<body>naoMuda
	^false</body>

<body>preMatriculas2: value 
	^false</body>

<body>preMatriculaSelecionada: value 
	^false</body>
</methods>

<methods>
<class-id>JanelaAluno</class-id> <category>initialize-release</category>

<body>initialize
	self aluno notNil 
		ifTrue: 
			[collectionModel := self.
			interesses := SelectionInList 
						adapt: collectionModel
						aspect: #pM
						list: #pM
						selection: #preMatriculaSelecionada:]</body>
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
	"confere a senha e chama (se OK) a outra janela"

	| umaJanelaProfessor jm jm2 |
	self senhaProfessor value = self professor senha 
		ifFalse: [Dialog warn: 'Senha incorreta']
		ifTrue: 
			["abre uma outra janela para o professor"

			umaJanelaProfessor := JanelaProfessor criaCom: self professor
						ca: self controleAcademico.
			self controleAcademico janelasProfessor add: umaJanelaProfessor.
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


<class>
<name>Usuario</name>
<environment>Smalltalk</environment>
<super>Core.Object</super>
<private>false</private>
<indexed-type>none</indexed-type>
<inst-vars>numeroUsp tipo email diasDeEmprestimo quantidadeMaximaDeEmprestimos pessoa </inst-vars>
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
	a pessoa: (Pessoa 
				nome: umNome
				rg: nil
				cpf: nil
				end: nil
				senha: nil).
	a
		numeroUsp: numeroUSP;
		email: umEmail;
		diasDeEmprestimo: 1;
		quantidadeMaximaDeEmprestimos: 1;
		tipo: #regular.
	^a</body>

<body>nome: umNome rg: umRG email: umEmail 
	| a |
	a := super new.
	a pessoa: (Pessoa 
				nome: umNome
				rg: umRG
				cpf: nil
				end: nil
				senha: nil).
	a
		email: umEmail;
		diasDeEmprestimo: 1;
		quantidadeMaximaDeEmprestimos: 1;
		tipo: #regular.
	^a</body>

<body>Xnome: umNome numeroUsp: numeroUSP email: umEmail 
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

<body>Xnome: umNome rg: umRG email: umEmail 

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



	^pessoa nome</body>

<body>nome: umNome 
	pessoa nome: umNome</body>

<body>numeroUsp



	^numeroUsp</body>

<body>numeroUsp: numeroUSP



	numeroUsp:=numeroUSP</body>

<body>pessoa
	^pessoa</body>

<body>pessoa: anObject
	pessoa := anObject</body>

<body>quantidadeMaximaDeEmprestimos

	^quantidadeMaximaDeEmprestimos</body>

<body>quantidadeMaximaDeEmprestimos: qtde

	quantidadeMaximaDeEmprestimos:=qtde</body>

<body>rg
	^pessoa rg</body>

<body>rg: umRG 
	pessoa rg: umRG</body>

<body>tipo

	^tipo</body>

<body>tipo: umTipo

	tipo:=umTipo</body>
</methods>

<methods>
<class-id>Usuario</class-id> <category>printing</category>

<body>imprime
	Transcript
		cr;
		show: pessoa nome;
		cr.
	numeroUsp = nil 
		ifTrue: 
			[Transcript
				show: 'RG: ';
				show: pessoa rg displayString;
				cr]
		ifFalse: 
			[Transcript
				show: 'No. USP: ';
				show: numeroUsp displayString;
				cr].
	Transcript
		show: 'email: ';
		show: email;
		cr;
		show: tipo displayString;
		cr;
		show: diasDeEmprestimo displayString;
		cr;
		show: quantidadeMaximaDeEmprestimos displayString;
		cr</body>
</methods>
<new-page/>


<class>
<name>JanelaMatriculaAluno</name>
<environment>Smalltalk</environment>
<super>UI.ApplicationModel</super>
<private>false</private>
<indexed-type>none</indexed-type>
<inst-vars>disciplinas turmas todasDisciplinas todasTurmas deptoAluno controleAcademico </inst-vars>
<class-inst-vars></class-inst-vars>
<imports></imports>
<category>MAC441</category>
</class>

<!-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -   -->


<methods>
<class-id>JanelaMatriculaAluno class</class-id> <category>interface specs</category>

<body>windowSpec
	"UIPainter new openOnClass: self andSelector: #windowSpec"

	&lt;resource: #canvas&gt;
	^#(#{UI.FullSpec} 
		#window: 
		#(#{UI.WindowSpec} 
			#properties: #(#{UI.PropertyListDictionary} #sizeType #specifiedSize #positionType #cascade #openType #advanced ) 
			#label: 'Matricula' 
			#min: #(#{Core.Point} 100 100 ) 
			#max: #(#{Core.Point} 1000 600 ) 
			#bounds: #(#{Graphics.Rectangle} 177 123 974 543 ) 
			#colors: 
			#(#{UI.LookPreferences} 
				#setBackgroundColor: #(#{Graphics.ColorValue} 2048 5119 8191 ) ) ) 
		#component: 
		#(#{UI.SpecCollection} 
			#collection: #(
				#(#{UI.InputFieldSpec} 
					#layout: #(#{Graphics.Rectangle} 63 39 254 61 ) 
					#name: #nomeAluno 
					#model: #nomeAluno 
					#style: #'Arbor-14' 
					#isReadOnly: true ) 
				#(#{UI.LabelSpec} 
					#layout: #(#{Core.Point} 18 38 ) 
					#name: #Label1 
					#label: 'Nome:' 
					#style: #'Arbor-12' ) 
				#(#{UI.LabelSpec} 
					#layout: #(#{Core.Point} 22 79 ) 
					#name: #Label2 
					#label: 'Disciplinas' 
					#style: #'Arbor-14' ) 
				#(#{UI.LabelSpec} 
					#layout: #(#{Core.Point} 224 76 ) 
					#name: #Label3 
					#label: 'Turmas' 
					#style: #default ) 
				#(#{UI.SequenceViewSpec} 
					#layout: #(#{Graphics.Rectangle} 23 111 197 311 ) 
					#name: #disciplinas 
					#model: #disciplinas 
					#useModifierKeys: true 
					#selectionType: #highlight ) 
				#(#{UI.SequenceViewSpec} 
					#layout: #(#{Graphics.Rectangle} 223 111 754 311 ) 
					#name: #turmas 
					#model: #turmas 
					#useModifierKeys: true 
					#selectionType: #highlight ) 
				#(#{UI.LabelSpec} 
					#layout: #(#{Core.Point} 22 79 ) 
					#name: #Label4 
					#label: 'Disciplinas' 
					#style: #'Arbor-14' ) 
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.Rectangle} 244 362 382 404 ) 
					#name: #ActionButton1 
					#model: #fazPreMatricula 
					#label: 'Fazer Pre-Matricula' 
					#defaultable: true ) ) ) )</body>
</methods>

<methods>
<class-id>JanelaMatriculaAluno class</class-id> <category>instance creation</category>

<body>criaComAluno: umAluno 

	| jm |
self halt.
	jm := super new.
	jm aluno: umAluno.
	jm inicializaDisciplinas.
	jm inicializaTurmas.
	jm initialize.
	^jm</body>

<body>criaComAluno: umAluno ca: umControleAcademico 
	| jm |
	jm := super new.
	jm aluno: umAluno.
	jm controleAcademico: umControleAcademico.
	jm inicializaDisciplinas.
	jm inicializaTurmas.
	jm initialize.
	^jm</body>

<body>new
	^super new</body>
</methods>

<!-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -   -->


<methods>
<class-id>JanelaMatriculaAluno</class-id> <category>accessing</category>

<body>aluno
	^aluno</body>

<body>aluno: anObject
	aluno := anObject</body>

<body>controleAcademico
	^controleAcademico</body>

<body>controleAcademico: anObject
	controleAcademico := anObject</body>

<body>deptoAluno
	^deptoAluno</body>

<body>deptoAluno: anObject
	deptoAluno := anObject</body>

<body>deptosAluno
	^deptosAluno</body>

<body>deptosAluno: anObject
	deptosAluno := anObject</body>

<body>disciplinas: anObject
	^disciplinas := anObject</body>

<body>todasDisciplinas
	^todasDisciplinas</body>

<body>todasDisciplinas: anObject
	todasDisciplinas := anObject</body>

<body>todasTurmas
	^todasTurmas</body>

<body>todasTurmas: anObject
	todasTurmas := anObject</body>

<body>turmas: anObject
	turmas := anObject</body>
</methods>

<methods>
<class-id>JanelaMatriculaAluno</class-id> <category>initialize-release</category>

<body>atualizaTurmas
	(self aluno notNil and: [self disciplinas selection notNil]) 
		ifTrue: [todasTurmas := self disciplinas selection turmas]
		ifFalse: [todasTurmas := OrderedCollection new].
	turmas setList: todasTurmas asList selecting: 1</body>

<body>inicializaDisciplinas
	| umDepto |
	self aluno notNil 
		ifTrue: 
			[umDepto := self controleAcademico depto.
			todasDisciplinas := umDepto disciplinas.

"	todasDisciplinas := OrderedCollection new."


	disciplinas := SelectionInList 
				adapt: self
				aspect: #disciplinas
				list: #todasDisciplinas
				selection: #disciplinaSelecionada:.
	disciplinas selectionIndexHolder onChangeSend: #disciplinaMudada to: self.

"			disciplinas list: todasDisciplinas"

]</body>

<body>inicializaDisciplinasETurmas
	| umDepto |
	self halt.
	self aluno notNil 
		ifTrue: 
			[umDepto := self controleAcademico depto.
			todasDisciplinas := umDepto disciplinas.
			self deptoAluno: umDepto.
			todasDisciplinas do: [:umaDisc | todasTurmas addAll: umaDisc turmas].
			disciplinas list: todasDisciplinas.
			turmas list: todasTurmas]</body>

<body>inicializaDisciplinasETurmasOld
	| todosDepartamentos deptos |
	self halt.
	self aluno notNil 
		ifTrue: 
			["procura todos os departamentos dos quais o aluno faça parte"

			todosDepartamentos := Departamento allInstances.
			deptos := OrderedCollection new.
			todosDepartamentos isNil 
				ifTrue: 
					[Transcript
						show: 'Janela Matricula Aluno - initialize';
						cr;
						show: 'Não há departamento';
						cr.
					^nil]
				ifFalse: 
					["procura os cursos daquele departamento para encontrar o aluno	"

					todosDepartamentos do: 
							[:umDepto | 
							umDepto cursos 
								do: [:umCurso | (umCurso alunos includes: aluno) ifTrue: [deptos add: umDepto]]].
					deptos isNil 
						ifTrue: 
							[Transcript
								show: 'Janela Matricula Aluno - initialize';
								cr;
								show: 'Não há departamento para este aluno';
								cr.
							^nil]
						ifFalse: 
							[deptos do: [:umDepto | todasDisciplinas addAll: umDepto disciplinas].
							self deptosAluno: deptos.
							disciplinas list: todasDisciplinas.
							todasDisciplinas do: [:umaDisc | todasTurmas addAll: umaDisc turmas].
							turmas list: todasTurmas]]]</body>

<body>inicializaTurmas
	(self aluno notNil and: [self disciplinas selection notNil]) 
		ifTrue: [todasTurmas := self disciplinas selection turmas]
		ifFalse: [todasTurmas := OrderedCollection new].
	turmas := SelectionInList 
				adapt: self
				aspect: #turmas
				list: #todasTurmas
				selection: #turmaSelecionada:.
	turmas selectionIndexHolder onChangeSend: #turmaMudada to: self</body>

<body>initialize2
	| disciplinas collectionModel turmas procura |
	super initialize.
	disciplinas := SelectionInList 
				adapt: self
				aspect: #disciplinas
				list: #todasDisciplinas
				selection: #disciplinaSelecionada:.
	disciplinas selectionIndexHolder onChangeSend: #disciplinaMudada to: self.
	turmas := SelectionInList 
				adapt: self
				aspect: #turmas
				list: #todasTurmas
				selection: #turmaSelecionada:.
	turmas selectionIndexHolder onChangeSend: #turmaMudada to: self.





	"
	
	| todosDepartamentos deptos |
	self aluno notNil 
		ifTrue: 
			[todosDepartamentos := Departamento allInstances.
			deptos := OrderedCollection new.
			todosDepartamentos isNil 
				ifTrue: 
					[Transcript
						show: 'Janela Matricula Aluno - initialize';
						cr;
						show: 'Não há departamento';
						cr.
					^nil]
				ifFalse: 
					["
	procura os cursos daquele departamento para encontrar o aluno	"

					todosDepartamentos do: 
							[:umDepto | 
							umDepto cursos 
								do: [:umCurso | (umCurso alunos includes: aluno) ifTrue: [deptos add: umDepto]]].
					todasDisciplinas := OrderedCollection new.
					deptos isNil 
						ifTrue: 
							[Transcript
								show: 'Janela Matricula Aluno - initialize';
								cr;
								show: 'Não há departamento para este aluno';
								cr.
							^nil]
						ifFalse: 
							[deptos do: [:umDepto | todasDisciplinas addAll: umDepto disciplinas].
							self deptosAluno: deptos.
							collectionModel := self.
							self disciplinas: (SelectionInList 
										adapt: collectionModel
										aspect: #disciplinas
										list: #todasDisciplinas
										selection: #disciplinaSelecionada:).
							self disciplinas selectionIndexHolder onChangeSend: #disciplinaMudada
								to: self.
							self turmas: OrderedCollection new.
							self todasTurmas: OrderedCollection new.
							self todasTurmas add: 'turmas'.
							self turmas: (SelectionInList 
										adapt: self
										aspect: #turmas
										list: #todasTurmas
										selection: #turmaSelecionada:).
							self turmas selectionIndexHolder onChangeSend: #turmaMudada to: self]]]
"</body>

<body>initializeX
	todasDisciplinas := OrderedCollection new.
	disciplinas := SelectionInList 
				adapt: self
				aspect: #disciplinas
				list: #todasDisciplinas
				selection: #disciplinaSelecionada:.
	disciplinas selectionIndexHolder onChangeSend: #disciplinaMudada to: self.
	todasTurmas := OrderedCollection new.
	turmas := SelectionInList 
				adapt: self
				aspect: #turmas
				list: #todasTurmas
				selection: #turmaSelecionada:.
	turmas selectionIndexHolder onChangeSend: #turmaMudada to: self</body>
</methods>

<methods>
<class-id>JanelaMatriculaAluno</class-id> <category>aspects</category>

<body>disciplinas
	^disciplinas</body>

<body>nomeAluno
	| adaptador |
	adaptador := AspectAdaptor subjectChannel: self aluno.
	adaptador forAspect: #nome.
	^adaptador</body>

<body>turmas
	^turmas</body>
</methods>

<methods>
<class-id>JanelaMatriculaAluno</class-id> <category>actions</category>

<body>atualizaTurmas: listaDepartamentos 
	| professores |
	self disciplinas selection isNil 
		ifTrue: [(self builder componentAt: #turmas) perform: #disable]
		ifFalse: 
			[self builder notNil 
				ifTrue: 
					[(self builder componentAt: #turmas) perform: #enable.
					todasTurmas := Set new.
					professores := Set new.
					listaDepartamentos 
						do: [:umDepto | professores addAll: umDepto professores].
					professores := professores asOrderedCollection.
					professores do: [:umProf | todasTurmas addAll: umProf turmasDoSem].
					todasTurmas := todasTurmas asOrderedCollection.
					self turmas value: (SelectionInList 
								adapt: self
								aspect: #turmas
								list: #todasTurmas
								selection: #turmaSelecionada:).
					self turmas selectionIndexHolder onChangeSend: #turmaMudade to: self.
					(self builder componentAt: #turmas) widget invalidate]]</body>

<body>changeRequest
	^super changeRequest 
		ifFalse: [false]
		ifTrue: 
			[controleAcademico notNil 
				ifTrue: [controleAcademico removeJanelaAluno: self].
			true]</body>

<body>disciplinaMudadaOld
	self halt: 'disc Mudada'.
	(self builder componentAt: #turmasDaDisciplina) widget invalidate</body>

<body>disciplinaSelecionada: umaDisciplina 
	"
	self atualizaTurmas: self deptosAluno
"</body>

<body>fazPreMatricula
	turmas selection isNil 
		ifTrue: [Dialog warn: 'Selecione alguma turma!']
		ifFalse: 
			[turmas selection preMatricula: aluno.
			self closeRequest]</body>

<body>turmaSelecionada: umaTurma 
	"	self halt: 'turma selecionada'"</body>
</methods>

<methods>
<class-id>JanelaMatriculaAluno</class-id> <category>interface opening</category>

<body>postOpenWith: aBuilder 
	super postOpenWith: aBuilder.
	"	self inicializaDisciplinas."
	self todasDisciplinas notEmpty 
		ifTrue: [self disciplinas selectionIndex: 1]
	"	(self builder componentAt: #disciplinas) widget invalidate.
	(self builder componentAt: #turmas) widget invalidate
"</body>
</methods>

<methods>
<class-id>JanelaMatriculaAluno</class-id> <category>change messages</category>

<body>disciplinaMudada
	self disciplinas selection isNil 
		ifTrue: [self turmas setList: List new selecting: 0]
		ifFalse: [self atualizaTurmas]</body>

<body>turmaMudada</body>
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
<name>Docentes</name>
<environment>Smalltalk</environment>
<super>UI.ApplicationModel</super>
<private>false</private>
<indexed-type>none</indexed-type>
<inst-vars>Docentes </inst-vars>
<class-inst-vars></class-inst-vars>
<imports></imports>
<category>MAC441</category>
</class>

<!-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -   -->


<methods>
<class-id>Docentes class</class-id> <category>interface specs</category>

<body>windowSpec
	"UIPainter new openOnClass: self andSelector: #windowSpec"

	&lt;resource: #canvas&gt;
	^#(#{UI.FullSpec} 
		#window: 
		#(#{UI.WindowSpec} 
			#label: 'Docentes' 
			#bounds: #(#{Graphics.Rectangle} 512 384 890 615 ) 
			#colors: 
			#(#{UI.LookPreferences} 
				#setForegroundColor: nil 
				#setBackgroundColor: #(#{Graphics.ColorValue} 8191 7167 7679 ) 
				#setSelectionForegroundColor: nil 
				#setSelectionBackgroundColor: nil 
				#setBorderColor: nil ) ) 
		#component: 
		#(#{UI.SpecCollection} 
			#collection: #(
				#(#{UI.SequenceViewSpec} 
					#layout: #(#{Graphics.Rectangle} 80 42 257 174 ) 
					#name: #List1 
					#model: #Docentes 
					#useModifierKeys: true 
					#selectionType: #highlight ) ) ) )</body>
</methods>

<!-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -   -->


<methods>
<class-id>Docentes</class-id> <category>aspects</category>

<body>Docentes
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	| dadosDocentes strDocente |
	^Docentes isNil 
		ifTrue: 
			[dadosDocentes := OrderedCollection new.
			Docente allInstances do: 
					[:umDocente | 
					strDocente := umDocente nUSP displayString , '  ' , umDocente nome , '  ' 
								, umDocente senha.
					dadosDocentes add: strDocente].
			Docentes := SelectionInList with: dadosDocentes asList]
		ifFalse: [Docentes]</body>
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

<methods>
<class-id>Horario</class-id> <category>printing</category>

<body>displayString
	^diaDaSemana displayString , '  ' , inicio displayString , ' a ' 
		, final displayString</body>
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


<class>
<name>Sistema</name>
<environment>Smalltalk</environment>
<super>Core.Object</super>
<private>false</private>
<indexed-type>none</indexed-type>
<inst-vars>dep disc1 pReq2 disc2 pReq3 disc3 pReq4 disc4 pReq5 disc5 pReq6 disc6 disc7 disc8 discObrigatCur1 discOptativasCur1 discObrigatCur2 discObrigatCur3 doc1 doc2 doc3 doc4 doc5 doc6 cur1 cur2 cur3 alun1 alun2 alun3 alun4 alun5 alun6 pM1 pM2 in fi in2 fi2 in3 fi3 in4 fi4 h1 h2 h3 h4 cH tu11 tu12 tu13 tu17 tu18 cH2 tu21 tu24 oc resultado tu7x tu71 ca </inst-vars>
<class-inst-vars></class-inst-vars>
<imports></imports>
<category>MAC441</category>
</class>

<!-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -   -->


<methods>
<class-id>Sistema class</class-id> <category>instance creation</category>

<body>inicia
	| s |
	s := super new.
	s iniciaVars.
	^s</body>
</methods>

<!-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -   -->


<methods>
<class-id>Sistema</class-id> <category>accessing</category>

<body>alun1
	^alun1</body>

<body>alun1: anObject
	alun1 := anObject</body>

<body>alun2
	^alun2</body>

<body>alun2: anObject
	alun2 := anObject</body>

<body>alun3
	^alun3</body>

<body>alun3: anObject
	alun3 := anObject</body>

<body>alun4
	^alun4</body>

<body>alun4: anObject
	alun4 := anObject</body>

<body>alun5
	^alun5</body>

<body>alun5: anObject
	alun5 := anObject</body>

<body>alun6
	^alun6</body>

<body>alun6: anObject
	alun6 := anObject</body>

<body>ca
	^ca</body>

<body>ca: anObject
	ca := anObject</body>

<body>cH
	^cH</body>

<body>cH2
	^cH2</body>

<body>cH2: anObject
	cH2 := anObject</body>

<body>cH: anObject
	cH := anObject</body>

<body>cur1
	^cur1</body>

<body>cur1: anObject
	cur1 := anObject</body>

<body>cur2
	^cur2</body>

<body>cur2: anObject
	cur2 := anObject</body>

<body>cur3
	^cur3</body>

<body>cur3: anObject
	cur3 := anObject</body>

<body>dep
	^dep</body>

<body>dep: anObject
	dep := anObject</body>

<body>disc1
	^disc1</body>

<body>disc1: anObject
	disc1 := anObject</body>

<body>disc2
	^disc2</body>

<body>disc2: anObject
	disc2 := anObject</body>

<body>disc3
	^disc3</body>

<body>disc3: anObject
	disc3 := anObject</body>

<body>disc4
	^disc4</body>

<body>disc4: anObject
	disc4 := anObject</body>

<body>disc5
	^disc5</body>

<body>disc5: anObject
	disc5 := anObject</body>

<body>disc6
	^disc6</body>

<body>disc6: anObject
	disc6 := anObject</body>

<body>disc7
	^disc7</body>

<body>disc7: anObject
	disc7 := anObject</body>

<body>disc8
	^disc8</body>

<body>disc8: anObject
	disc8 := anObject</body>

<body>discObrigatCur1
	^discObrigatCur1</body>

<body>discObrigatCur1: anObject
	discObrigatCur1 := anObject</body>

<body>discObrigatCur2
	^discObrigatCur2</body>

<body>discObrigatCur2: anObject
	discObrigatCur2 := anObject</body>

<body>discObrigatCur3
	^discObrigatCur3</body>

<body>discObrigatCur3: anObject
	discObrigatCur3 := anObject</body>

<body>discOptativasCur1
	^discOptativasCur1</body>

<body>discOptativasCur1: anObject
	discOptativasCur1 := anObject</body>

<body>doc1
	^doc1</body>

<body>doc1: anObject
	doc1 := anObject</body>

<body>doc2
	^doc2</body>

<body>doc2: anObject
	doc2 := anObject</body>

<body>doc3
	^doc3</body>

<body>doc3: anObject
	doc3 := anObject</body>

<body>doc4
	^doc4</body>

<body>doc4: anObject
	doc4 := anObject</body>

<body>doc5
	^doc5</body>

<body>doc5: anObject
	doc5 := anObject</body>

<body>doc6
	^doc6</body>

<body>doc6: anObject
	doc6 := anObject</body>

<body>fi
	^fi</body>

<body>fi2
	^fi2</body>

<body>fi2: anObject
	fi2 := anObject</body>

<body>fi3
	^fi3</body>

<body>fi3: anObject
	fi3 := anObject</body>

<body>fi4
	^fi4</body>

<body>fi4: anObject
	fi4 := anObject</body>

<body>fi: anObject
	fi := anObject</body>

<body>h1
	^h1</body>

<body>h1: anObject
	h1 := anObject</body>

<body>h2
	^h2</body>

<body>h2: anObject
	h2 := anObject</body>

<body>h3
	^h3</body>

<body>h3: anObject
	h3 := anObject</body>

<body>h4
	^h4</body>

<body>h4: anObject
	h4 := anObject</body>

<body>in
	^in</body>

<body>in2
	^in2</body>

<body>in2: anObject
	in2 := anObject</body>

<body>in3
	^in3</body>

<body>in3: anObject
	in3 := anObject</body>

<body>in4
	^in4</body>

<body>in4: anObject
	in4 := anObject</body>

<body>in: anObject
	in := anObject</body>

<body>iniciaVars
	dep := Departamento new.

	"Criação de disciplinas"
	disc1 := dep 
				novaDisciplina: 'POO'
				programa: 'texto'
				codigo: 'MAC441'
				preRequisitos: nil.
	pReq2 := OrderedCollection new.
	pReq2 add: disc1.
	disc2 := dep 
				novaDisciplina: 'TPOO'
				programa: 'texto'
				codigo: 'MAC5754'
				preRequisitos: pReq2.
	pReq3 := OrderedCollection new.
	pReq3 add: disc1.
	pReq3 add: disc2.
	disc3 := dep 
				novaDisciplina: 'SOD'
				programa: 'texto'
				codigo: 'MAC5788'
				preRequisitos: pReq3.
	pReq4 := OrderedCollection new.
	pReq4 add: disc1.
	disc4 := dep 
				novaDisciplina: 'AA'
				programa: 'texto'
				codigo: 'MAC5711'
				preRequisitos: pReq4.
	pReq5 := OrderedCollection new.
	disc5 := dep 
				novaDisciplina: 'Calculo'
				programa: 'texto'
				codigo: 'MAT1111'
				preRequisitos: pReq5.
	pReq6 := OrderedCollection new.
	disc6 := dep 
				novaDisciplina: 'Estatistica'
				programa: 'texto'
				codigo: 'MAE1111'
				preRequisitos: pReq6.
	disc7 := dep 
				novaDisciplina: 'Leitura Dramática'
				programa: 'Ler e Atuar'
				codigo: 'MAC500'
				preRequisitos: nil.
	disc8 := dep 
				novaDisciplina: 'Seminários'
				programa: 'Ler e Atuar'
				codigo: 'MAC5700'
				preRequisitos: nil.
	discObrigatCur1 := OrderedCollection new.
	discObrigatCur1 add: disc1.
	discObrigatCur1 add: disc2.
	discOptativasCur1 := OrderedCollection new.
	discOptativasCur1 add: disc3.
	discOptativasCur1 add: disc4.
	discObrigatCur2 := OrderedCollection new.
	discObrigatCur2 add: disc5.
	discObrigatCur3 := OrderedCollection new.
	discObrigatCur3 add: disc6.

	"Criação de docentes"
	doc1 := dep 
				novoProfessor: 'Alan'
				cpf: 1
				rg: 11
				endereco: 'rua x'
				senha: 'jooo'
				numeroUsp: 4960471.
	doc2 := dep 
				novoProfessor: 'Finger'
				cpf: 2
				rg: 22
				endereco: 'rua x'
				senha: 'jooo'
				numeroUsp: 4960472.
	doc3 := dep 
				novoProfessor: 'Carlos'
				cpf: 3
				rg: 33
				endereco: 'rua x'
				senha: 'jooo'
				numeroUsp: 4960473.
	doc4 := dep 
				novoProfessor: 'Gubi'
				cpf: 4
				rg: 44
				endereco: 'rua x'
				senha: 'jooo'
				numeroUsp: 4960474.
	doc5 := dep 
				novoProfessor: 'Coelho'
				cpf: 5
				rg: 55
				endereco: 'rua x'
				senha: 'jooo'
				numeroUsp: 4960475.
	doc6 := dep 
				novoProfessor: 'José'
				cpf: 12
				rg: 134
				endereco: 'rua x'
				senha: 'jooo'
				numeroUsp: 4960476.


	"Craição de cursos"
	cur1 := dep 
				novoCurso: 'Computacao'
				obrigatorias: discObrigatCur1
				optativas: discOptativasCur1
				numMinimoOptativas: 1
				numMinimoForaDeArea: 1.
	cur2 := dep 
				novoCurso: 'Matematica'
				obrigatorias: discObrigatCur2
				optativas: nil
				numMinimoOptativas: 0
				numMinimoForaDeArea: 2.
	cur3 := dep 
				novoCurso: 'Estatistica'
				obrigatorias: discObrigatCur3
				optativas: nil
				numMinimoOptativas: 1
				numMinimoForaDeArea: 2.
	"Criação de alunos"
	alun1 := dep 
				novoAluno: 'Pedro'
				cpf: 123
				rg: 234
				endereco: 'yyy'
				senha: 'ggg'
				curso: 'Computacao'
				numeroUsp: 18970.
	alun2 := dep 
				novoAluno: 'Pito'
				cpf: 456
				rg: 11234
				endereco: 'yyy'
				senha: 'ggg'
				curso: 'Computacao'
				numeroUsp: 18971.
	alun3 := dep 
				novoAluno: 'Paulo'
				cpf: 789
				rg: 2342
				endereco: 'yyy'
				senha: 'ggg'
				curso: 'Computacao'
				numeroUsp: 18972.
	alun4 := dep 
				novoAluno: 'Sitônio'
				cpf: 101
				rg: 112345
				endereco: 'yyy'
				senha: 'ggg'
				curso: 'Computacao'
				numeroUsp: 18973.
	alun5 := dep 
				novoAluno: 'Henrique'
				cpf: 989
				rg: 2341
				endereco: 'yyy'
				senha: 'ggg'
				curso: 'Matematica'
				numeroUsp: 18974.
	alun6 := dep 
				novoAluno: 'Coelho'
				cpf: 5
				rg: 55
				endereco: 'rua x'
				senha: 'jooo'
				curso: 'Estatistica'
				numeroUsp: 18957.
	pM1 := MatriculaPorOrdem new.
	pM2 := MatriculaPorSorteio new.
	dep politicaDeMatricula: pM1 para: disc1.
	dep politicaDeMatricula: pM2 para: disc2.
	dep politicaDeMatricula: pM2 para: disc3.
	dep politicaDeMatricula: pM2 para: disc4.
	dep politicaDeMatricula: pM2 para: disc5.
	dep politicaDeMatricula: pM2 para: disc6.
	dep politicaDeMatricula: pM2 para: disc7.
	dep politicaDeMatricula: pM2 para: disc8.
	dep disciplinas includes: disc1.
	dep disciplinas includes: disc6.
	dep disciplinas includes: disc7.
	dep disciplinas includes: disc8.
	in := Time readFrom: (ReadStream on: '15:00').
	fi := Time readFrom: (ReadStream on: '19:00').
	in2 := Time readFrom: (ReadStream on: '20:00').
	fi2 := Time readFrom: (ReadStream on: '22:00').
	in3 := Time readFrom: (ReadStream on: '15:00').
	fi3 := Time readFrom: (ReadStream on: '16:00').
	in4 := Time readFrom: (ReadStream on: '19:00').
	fi4 := Time readFrom: (ReadStream on: '20:00').
	fi &lt;= fi2.
	h1 := Horario 
				diaDaSemana: #segunda
				inicio: in
				final: fi.
	h2 := Horario 
				diaDaSemana: #segunda
				inicio: in2
				final: fi2.
	h3 := Horario 
				diaDaSemana: #segunda
				inicio: in3
				final: fi3.
	h4 := Horario 
				diaDaSemana: #segunda
				inicio: in4
				final: fi4.
	"result:= h1 chocaCom: h2. "
	"result:= h2 chocaCom: h1. "
	cH := OrderedCollection new.
	cH add: h1.
	cH add: h2.
	tu11 := doc1 
				novaTurmaPara: disc1
				horario: cH
				vagas: 4.
	tu12 := doc2 
				novaTurmaPara: disc1
				horario: cH
				vagas: 4.
	tu13 := doc3 
				novaTurmaPara: disc1
				horario: cH
				vagas: 20.
	tu17 := doc5 
				novaTurmaPara: disc7
				horario: cH
				vagas: 4.
	tu18 := doc6 
				novaTurmaPara: disc8
				horario: cH
				vagas: 4.
	cH2 := OrderedCollection new.
	cH2 add: h4.
	tu21 := doc1 
				novaTurmaPara: disc2
				horario: cH2
				vagas: 2.
	tu24 := doc4 
				novaTurmaPara: disc2
				horario: cH
				vagas: 2.
	"cria disciplina sem vincular a departamento"
"	disc7 := Disciplina 
				nome: 'erro'
				programa: 'erro'
				codigo: 'ERR890'
				preRequisitos: nil."
	oc := OrderedCollection new.
	oc add: h1.
	oc add: h2.
	"oc add: h3."	"se adicionar cria choque de horários"
	oc add: h4.
"	h3 chocaComColecao: oc.
	resultado := Horario choca: oc.
"
	tu7x := Turma 
				disciplina: disc7
				horario: oc
				vagas: 50.

	"esse vai dar erro pois não é disciplina do departamento"
"	tu71 := doc1 
				novaTurmaPara: disc7
				horario: oc
				vagas: 20.
"
	"doc1 novaTurmaPara: disc1 horario: oc vagas: 20."
"	doc1 disciplinasDoSemestre.
	doc2 disciplinasDoSemestre.
	resultado := Horario choca: oc.
"
	"preMatricula um aluno"
	"tu1 preMatricula: alun1."
"	alun1 historicoEscolar.
"
	"alun1 listaItensHistorico asSortedCollection: 
 					[:iH1 :iH2 | 
					iH1 ano &lt; iH2 ano | (iH1 ano = iH2 ano &amp; (iH1 semestre &lt; iH2 semestre))]"
	tu11 preMatricula: alun1.
	tu11 matricula.
	tu11 preMatricula: alun3.
	tu11 preMatricula: alun5.
	tu11 preMatricula: alun6.


	ca := ControleAcademico new.
	ca depto: dep.
	ca open</body>

<body>oc
	^oc</body>

<body>oc: anObject
	oc := anObject</body>

<body>pM1
	^pM1</body>

<body>pM1: anObject
	pM1 := anObject</body>

<body>pM2
	^pM2</body>

<body>pM2: anObject
	pM2 := anObject</body>

<body>pReq2
	^pReq2</body>

<body>pReq2: anObject
	pReq2 := anObject</body>

<body>pReq3
	^pReq3</body>

<body>pReq3: anObject
	pReq3 := anObject</body>

<body>pReq4
	^pReq4</body>

<body>pReq4: anObject
	pReq4 := anObject</body>

<body>pReq5
	^pReq5</body>

<body>pReq5: anObject
	pReq5 := anObject</body>

<body>pReq6
	^pReq6</body>

<body>pReq6: anObject
	pReq6 := anObject</body>

<body>resultado
	^resultado</body>

<body>resultado: anObject
	resultado := anObject</body>

<body>tu11
	^tu11</body>

<body>tu11: anObject
	tu11 := anObject</body>

<body>tu12
	^tu12</body>

<body>tu12: anObject
	tu12 := anObject</body>

<body>tu13
	^tu13</body>

<body>tu13: anObject
	tu13 := anObject</body>

<body>tu17
	^tu17</body>

<body>tu17: anObject
	tu17 := anObject</body>

<body>tu18
	^tu18</body>

<body>tu18: anObject
	tu18 := anObject</body>

<body>tu21
	^tu21</body>

<body>tu21: anObject
	tu21 := anObject</body>

<body>tu24
	^tu24</body>

<body>tu24: anObject
	tu24 := anObject</body>

<body>tu71
	^tu71</body>

<body>tu71: anObject
	tu71 := anObject</body>

<body>tu7x
	^tu7x</body>

<body>tu7x: anObject
	tu7x := anObject</body>
</methods>
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

<body>nome: umNome
	^self pessoa nome: umNome</body>

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

<body>senha
	^self pessoa senha</body>

<body>value
	^self</body>
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

<methods>
<class-id>Aluno</class-id> <category>printing</category>

<body>displayString
	^'Número USP: ' , self nUSP displayString , ' -- ' , self nome</body>
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
<new-page/>


<class>
<name>JanelaProfessorNovaTurma</name>
<environment>Smalltalk</environment>
<super>UI.ApplicationModel</super>
<private>false</private>
<indexed-type>none</indexed-type>
<inst-vars>controleAcademico disciplinas horarios diasDaSemana dia2 vagas nomeProfessor discsDepto professor horario1 horario2 dia1 </inst-vars>
<class-inst-vars></class-inst-vars>
<imports></imports>
<category>MAC441</category>
</class>

<!-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -   -->


<methods>
<class-id>JanelaProfessorNovaTurma class</class-id> <category>interface specs</category>

<body>windowSpec
	"UIPainter new openOnClass: self andSelector: #windowSpec"

	&lt;resource: #canvas&gt;
	^#(#{UI.FullSpec} 
		#window: 
		#(#{UI.WindowSpec} 
			#label: 'Nova Turma' 
			#min: #(#{Core.Point} 20 20 ) 
			#max: #(#{Core.Point} 1024 768 ) 
			#bounds: #(#{Graphics.Rectangle} 595 182 994 623 ) 
			#colors: 
			#(#{UI.LookPreferences} 
				#setBackgroundColor: #(#{Graphics.ColorValue} #white ) ) ) 
		#component: 
		#(#{UI.SpecCollection} 
			#collection: #(
				#(#{UI.LabelSpec} 
					#layout: #(#{Core.Point} 24 44 ) 
					#name: #Label1 
					#label: 'Matérias' 
					#style: #default ) 
				#(#{UI.SequenceViewSpec} 
					#layout: #(#{Graphics.Rectangle} 25 76 264 252 ) 
					#name: #disciplinas 
					#model: #disciplinas 
					#useModifierKeys: true 
					#selectionType: #highlight ) 
				#(#{UI.LabelSpec} 
					#layout: #(#{Core.Point} 30 273 ) 
					#name: #Label2 
					#label: 'Vagas:' 
					#style: #default ) 
				#(#{UI.InputFieldSpec} 
					#layout: #(#{Graphics.Rectangle} 80 273 154 296 ) 
					#name: #vagas 
					#model: #vagas ) 
				#(#{UI.ComboBoxSpec} 
					#layout: #(#{Graphics.Rectangle} 31 342 131 365 ) 
					#name: #dia1 
					#model: #dia1 
					#type: #string 
					#comboList: #diasDaSemana ) 
				#(#{UI.LabelSpec} 
					#layout: #(#{Core.Point} 35 310 ) 
					#name: #Label3 
					#label: 'Dia 1' ) 
				#(#{UI.LabelSpec} 
					#layout: #(#{Core.Point} 150 315 ) 
					#name: #Label4 
					#label: 'Horário 1' ) 
				#(#{UI.ComboBoxSpec} 
					#layout: #(#{Graphics.Rectangle} 145 341 245 364 ) 
					#name: #horario1 
					#model: #horario1 
					#comboList: #horarios ) 
				#(#{UI.ComboBoxSpec} 
					#layout: #(#{Graphics.Rectangle} 32 403 132 426 ) 
					#name: #dia2 
					#model: #dia2 
					#type: #string 
					#comboList: #diasDaSemana ) 
				#(#{UI.LabelSpec} 
					#layout: #(#{Core.Point} 36 371 ) 
					#name: #Label5 
					#label: 'Dia 2' ) 
				#(#{UI.LabelSpec} 
					#layout: #(#{Core.Point} 151 376 ) 
					#name: #Label6 
					#label: 'Horário 2' ) 
				#(#{UI.ComboBoxSpec} 
					#layout: #(#{Graphics.Rectangle} 146 402 246 425 ) 
					#name: #horario2 
					#model: #horario2 
					#comboList: #horarios ) 
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.Rectangle} 288 383 372 426 ) 
					#name: #ActionButton1 
					#model: #criarNovaTurma 
					#label: 'Criar Turma' 
					#defaultable: true ) 
				#(#{UI.LabelSpec} 
					#layout: #(#{Core.Point} 23 16 ) 
					#name: #Label7 
					#label: 'Professor: ' 
					#style: #default ) 
				#(#{UI.InputFieldSpec} 
					#layout: #(#{Graphics.Rectangle} 92 17 325 41 ) 
					#name: #nomeProfessor 
					#model: #nomeProfessor 
					#isReadOnly: true ) ) ) )</body>
</methods>

<methods>
<class-id>JanelaProfessorNovaTurma class</class-id> <category>instance creation</category>

<body>criaCom: umProfessor ca: umControleAcademico 
	| jp |
	jp := super new.
	jp professor: umProfessor.
	jp controleAcademico: umControleAcademico.
	jp inicializaDisciplinas.
	^jp</body>
</methods>

<!-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -   -->


<methods>
<class-id>JanelaProfessorNovaTurma</class-id> <category>accessing</category>

<body>controleAcademico
	^controleAcademico</body>

<body>controleAcademico: anObject
	controleAcademico := anObject</body>

<body>disciplinas: anObject
	disciplinas := anObject</body>

<body>discsDepto
	^discsDepto</body>

<body>discsDepto: anObject
	discsDepto := anObject</body>

<body>professor
	^professor</body>

<body>professor: anObject
	professor := anObject</body>
</methods>

<methods>
<class-id>JanelaProfessorNovaTurma</class-id> <category>initialize-release</category>

<body>inicializaDisciplinas
	self professor notNil 
		ifTrue: 
			[discsDepto := self professor departamento disciplinas.
			disciplinas := SelectionInList 
						adapt: self
						aspect: #disciplinas
						list: #discsDepto
						selection: #disciplinaSelecionada:]</body>
</methods>

<methods>
<class-id>JanelaProfessorNovaTurma</class-id> <category>actions</category>

<body>changeRequest
	^super changeRequest 
		ifFalse: [false]
		ifTrue: 
			[controleAcademico notNil 
				ifTrue: [controleAcademico removeJanelaProfessor: self].
			true]</body>

<body>criarNovaTurma
	| disciplina cH duasHoras aula1 aula2 turma |
	self disciplinas selection isNil 
		ifTrue: 
			[Dialog warn: 'Não há disciplina selecionada. Selecione alguma disciplina.'.
			^nil].
	((diasDaSemana value includes: dia1 value asSymbol) 
		and: [diasDaSemana value includes: dia2 value asSymbol]) 
			ifFalse: 
				[Dialog warn: 'Dias não preenchidos corretamente.'.
				^nil].
	((horarios value includes: horario1 value) 
		and: [horarios value includes: horario2 value]) 
			ifFalse: 
				[Dialog warn: 'Horários não preenchidos corretamente.'.
				^nil].
	vagas value asNumber &gt; 0 
		ifFalse: 
			[Dialog warn: 'Número de vagas incorreto.'.
			^nil].
	disciplina := self disciplinas selection.
	cH := OrderedCollection new.
	duasHoras := Time readFrom: (ReadStream on: '2:00').
	aula1 := Horario 
				diaDaSemana: dia1 value asSymbol
				inicio: (Time readFrom: (ReadStream on: horario1 value))
				final: ((Time readFrom: (ReadStream on: horario1 value)) addTime: duasHoras).
	aula2 := Horario 
				diaDaSemana: dia2 value asSymbol
				inicio: (Time readFrom: (ReadStream on: horario2 value))
				final: ((Time readFrom: (ReadStream on: horario2 value)) addTime: duasHoras).
	cH add: aula1.
	cH add: aula2.
	(aula1 chocaCom: aula2) 
		ifTrue: 
			[Dialog warn: 'Os dois horários chocam.'.
			^nil].
	"	self halt."
	"	turma := self controleAcademico depto 
				novaTurmaComProfessor: professor
				para: disciplina
				horario: cH
				vagas: vagas value asNumber.
"
	turma := professor 
				novaTurmaPara: disciplina
				horario: cH
				vagas: vagas value asNumber.
	turma notNil 
		ifTrue: [Dialog warn: 'Turma criada com sucesso']
		ifFalse: 
			[Dialog 
				warn: 'Não foi possível criar a turma. Leia mensagem no Transcript.'].
	self controleAcademico janelasAluno do: [:uJA | uJA atualizaTurmas].
	self closeRequest</body>

<body>disciplinaSelecionada: umaDisciplina</body>
</methods>

<methods>
<class-id>JanelaProfessorNovaTurma</class-id> <category>aspects</category>

<body>dia1
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^dia1 isNil ifTrue: [dia1 := String new asValue] ifFalse: [dia1]</body>

<body>dia2
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^dia2 isNil
		ifTrue:
			[dia2 := String new asValue]
		ifFalse:
			[dia2]</body>

<body>diasDaSemana
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^diasDaSemana isNil 
		ifTrue: 
			[diasDaSemana := #(#segunda #terca #quarta #quinta #sexta #sabado #domingo) 
						asList asValue]
		ifFalse: [diasDaSemana]</body>

<body>disciplinas
	^disciplinas</body>

<body>horario1
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^horario1 isNil 
		ifTrue: [horario1 := String new asValue]
		ifFalse: [horario1]</body>

<body>horario2
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^horario2 isNil 
		ifTrue: [horario2 := String new asValue]
		ifFalse: [horario2]</body>

<body>horarios
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	| meiaHora umaHora |
	^horarios isNil 
		ifTrue: 
			[horarios := List new.
			meiaHora := Time readFrom: (ReadStream on: '0:30').
			umaHora := Time readFrom: (ReadStream on: '7:00').
			30 timesRepeat: 
					[horarios add: umaHora displayString.
					umaHora := umaHora addTime: meiaHora].
			horarios := horarios asValue]
		ifFalse: [horarios]</body>

<body>nomeProfessor
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^nomeProfessor isNil 
		ifTrue: [nomeProfessor := self professor nome asValue]
		ifFalse: [nomeProfessor]</body>

<body>vagas
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^vagas isNil
		ifTrue:
			[vagas := String new asValue]
		ifFalse:
			[vagas]</body>
</methods>
<new-page/>


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
