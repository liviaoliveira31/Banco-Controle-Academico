# Banco-Controle-Academico
O banco de dados do controle academico contem:
10 disciplinas registradas em diferentes semestres no ano de 2021, 10 alunos matriculados nessas disciplinas, todos com nota 1, nota 2 e faltas ja previamente cadastradas. Existe uma trigger que controla a reprovação pela quantidade de faltas (caso a quantidade seja maior que 25% da carga horaria da disciplina em que o aluno esta matriculado), e outra trigger que é executava caso o aluno esteja com as faltas ok, ela é responsavel por calcular a media com base na nota 1 e nota 2, atualizando a situação (aprovado/reprovado).

Não contem: trigger para calcular a media de acordo com a prova sub, trigger para rematricular alunos reprovados no segundo semestre.
faltam tambem as especificações da disciplina na hora de inserir as notas, para qque quando um aluno for matriculado em mais de uma disciplina, não de erro no calculo da media
