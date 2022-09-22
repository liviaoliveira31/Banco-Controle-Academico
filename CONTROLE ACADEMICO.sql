/*CRIAÇÃO DO BANCO*/
CREATE DATABASE Controle_Academico;
USE Controle_Academico;

/* CRAIAÇÃO DAS TBELAS*/
CREATE TABLE Aluno(
RA int NOT NULL PRIMARY KEY,
Nome varchar (50) NOT NULL,
);

CREATE TABLE Disciplina(
Sigla char (3) NOT NULL PRIMARY KEY,
Nome varchar (20) NOT NULL,
Carga_Horaria  int NOT NULL
);

/*alterando o tamanho do nome da disciplina pq esqueci de mudar quando criei*/
ALTER TABLE Disciplina ALTER COLUMN Nome
VARCHAR (40);

CREATE TABLE Matricula(
RA int NOT NULL,
Sigla char (3) NOT NULL,
Data_Ano int PRIMARY KEY NOT NULL,
Data_Semestre int UNIQUE NOT NULL,
Falta int NULL,
Nota_N1 float NULL,
Nota_N2 float NULL,
Nota_Sub float NULL,
Nota_Media float NULL,
Situacao bit,
FOREIGN KEY (RA) REFERENCES Aluno (RA),
FOREIGN KEY (Sigla) REFERENCES Disciplina (Sigla)
);

ALTER TABLE Matricula ALTER COLUMN Situacao
VARCHAR (40);


/*EXCLUINDO O PARAMETRO PRIMARY KEY E UNIQUE DAS CHAVES DE Data_Ano e Data_Semestre na tabela Matricula*/
ALTER TABLE Matricula DROP CONSTRAINT PK__Matricul__D602F7C59801CBD4;
ALTER TABLE Matricula DROP CONSTRAINT UQ__Matricul__B282AF15C1303724;

/*ADICIONANDO PRIMARY KEY COMPOSTA: */
ALTER TABLE Matricula ADD CONSTRAINT PK_Matricula PRIMARY KEY (RA, Sigla, Data_Ano, Data_Semestre);

/*CRIANDO AS TRIGGER*/
go

CREATE TRIGGER TRIGGER_REP_FALTA
ON Matricula
AFTER UPDATE 
AS
BEGIN
	
DECLARE
	@Falta int,
	@Carga_Horaria int,
	@RA  INT,
	@Nota_N1 float,
	@Nota_N2 float
	
	SELECT @Nota_N1 = Nota_N1, @Nota_N2 = Nota_N2, @Falta = Falta, @RA = RA FROM INSERTED
	
	SELECT @Carga_Horaria = Carga_Horaria FROM Disciplina
	
	
    IF(@Falta>(@Carga_Horaria*0.25))
	BEGIN
	
	UPDATE Matricula set Situacao = 'REPROVADO POR FALTA'
	WHERE RA = @RA
	END
	else
	begin
	UPDATE Matricula SET Nota_Media = (Nota_N1 + Nota_N2)/2
	WHERE RA = @RA
	end

END 
GO
DROP TRIGGER TRIGGER_REP_FALTA
go

CREATE TRIGGER TRIGGER_AP_REP_MEDIA
ON Matricula
AFTER UPDATE
AS
BEGIN

DECLARE
	@Nota_N1 float,
	@Nota_N2 float,
	@Nota_Media float,
	@Situacao varchar,
	@RA INT

	SELECT @RA = RA, @Nota_N1 = Nota_N1, @Nota_N2 = Nota_N2 FROM INSERTED
	SELECT  @Situacao = Situacao FROM Matricula
	where ra = @ra
	
	
	IF(@Situacao IS NULL )

		BEGIN
			SELECT @Nota_Media = Nota_Media FROM INSERTED
			IF (@Nota_Media >=(5))
				BEGIN
					UPDATE Matricula SET Situacao = 'APROVADO POR NOTA'
					WHERE RA = @RA
				END
			ELSE if (@Nota_Media <(5))
				BEGIN
					UPDATE Matricula SET Situacao = 'REPROVADO POR NOTA'
					WHERE RA = @RA
	END
	
end
	
	

END
GO

DROP TRIGGER TRIGGER_AP_REP_MEDIA
GO


--CREATE TRIGGER TRIGGER_PROVA_SUB
--ON MATRICULA
--AFTER UPDATE
--AS
--BEGIN
--DECLARE
--@Nota_N1 float,
--	@Nota_N2 float,
--	@Nota_Media float,
--	@Nota_Sub float,
--	@Situacao varchar,
--	@RA INT

--	SELECT @RA = RA,  @Nota_N1 = Nota_N1, @Nota_N2 = Nota_N2, @Nota_Sub = Nota_Sub FROM INSERTED
--	SELECT @Nota_Media = Nota_Media, @Situacao = Situacao from Matricula
--	where ra = @ra
--	IF (@Situacao = 'REPROVADO POR NOTA')
--	BEGIN
--	IF (@Nota_Sub > @Nota_N1)
--	BEGIN
--	UPDATE Matricula set Nota_Media = (Nota_Sub+Nota_N2)/2
--	WHERE RA = @RA
--	END
--	ELSE IF (@Nota_Sub > @Nota_N2)
--	UPDATE Matricula set Nota_Media = (Nota_Sub+Nota_N1)/2
--	WHERE RA = @RA
--	END
	

--END
--drop trigger trigger_prova_sub
/*------------------------------------------------------------------------------------------------------*/

/*INSERÇÕES DOS REGISTROS*/

INSERT INTO Aluno (RA, Nome)
VALUES(1, 'Ana'),
	  (2, 'Barbara'),
	  (3, 'Caio'),
	  (4, 'Daniela'),
	  (5, 'Emanuele'),
	  (6, 'Felipe'),
	  (7, 'Gabriel'),
	  (8, 'Helio'),
	  (9, 'Italo'),
	  (10,'Joao');



INSERT INTO Disciplina(Sigla, Nome, Carga_Horaria)
VALUES ('AC', 'Arquitetura de Computadores', 50),
	   ('BD1', 'Banco de dados', 60),
	   ('FI', 'Fundamentos da informatica', 30),
	   ('FC', 'Fisica computacinal', 30),
	   ('IHC', 'Interacao humano computador', 50),
	   ('LP1', 'Logica de programacao 1', 70),
	   ('PW1', 'Programacao Web 1', 80),
	   ('RC', 'Rede de computadores', 50),
	   ('SI', 'Sistemas Embarcados', 50),
	   ('SO', 'Sistemas operacionais', 50);
	  
INSERT INTO Matricula(RA, Sigla, Data_Ano, Data_Semestre)
VALUES (1, 'bd1', 2021, 1),
	  (2, 'BD1', 2021, 1),
	  (3, 'FC', 2021, 2),
	  (4, 'FI', 2021, 2),
	  (5, 'IHC', 2021, 1 ),
	  (6, 'LP1', 2021, 1),
	  (7, 'PW1', 2021, 2),
	  (8, 'RC', 2021, 1),
      (9, 'SI', 2021, 1),
	  (10, 'SO', 2021, 1)


--ALUNO 1
UPDATE Matricula
SET  Nota_N1 = 6, Nota_N2 = 1, Nota_Sub = 3
WHERE RA = 1;
UPDATE Matricula
SET Nota_N2 = 1
WHERE RA = 1;
UPDATE Matricula
SET Falta = 4
where RA = 1;





--ALUNO 2
UPDATE Matricula
SET  Nota_N1 = 8
WHERE RA = 2;
UPDATE Matricula
SET Nota_N2 = 3
WHERE RA = 2;
UPDATE Matricula
SET Falta = 9
where RA = 2;


--ALUNO 3
UPDATE Matricula
SET  Nota_N1 = 4
WHERE RA = 3;
UPDATE Matricula
SET Nota_N2 = 6
WHERE RA = 3;
UPDATE Matricula
SET Falta = 19
where RA = 3;


--ALUNO 4
UPDATE Matricula
SET  Nota_N1 = 6
WHERE RA = 4;
UPDATE Matricula
SET Nota_N2 = 1
WHERE RA = 4;
UPDATE Matricula
SET Falta = 4
where RA = 4;


--ALUNO 5
UPDATE Matricula
SET  Nota_N1 = 10
WHERE RA = 5;
UPDATE Matricula
SET Nota_N2 = 9
WHERE RA = 5
UPDATE Matricula
SET Falta = 3
where RA = 5;


--ALUNO 6
UPDATE Matricula
SET  Nota_N1 = 1
WHERE RA = 6;
UPDATE Matricula
SET Nota_N2 = 1
WHERE RA = 6
UPDATE Matricula
SET Falta = 28
where RA = 6;


--ALUNO 7
UPDATE Matricula
SET  Nota_N1 = 7
WHERE RA = 7;
UPDATE Matricula
SET Nota_N2 = 3
WHERE RA = 7
UPDATE Matricula
SET Falta = 4
where RA = 7;


--ALUNO 8
UPDATE Matricula
SET  Nota_N1 = 9
WHERE RA = 8;
UPDATE Matricula
SET Nota_N2 = 10
WHERE RA = 8
UPDATE Matricula
SET Falta = 29
where RA = 8;


--ALUNO 9
UPDATE Matricula
SET  Nota_N1 = 6
WHERE RA = 9;
UPDATE Matricula
SET Nota_N2 = 5
WHERE RA = 9
UPDATE Matricula
SET Falta = 0
where RA = 9;


-- ALUNO 10
UPDATE Matricula
SET  Nota_N1 = 4
WHERE RA = 10 
UPDATE Matricula
SET Nota_N2 = 9
WHERE RA = 10 
UPDATE Matricula
SET Falta = 40
where RA = 10 ;




--select * from matricula;
--delete from matricula where ra=1 ;
--delete from matricula where ra=2;
--delete from matricula where ra=3;
--delete from matricula where ra=4;
--delete from matricula where ra=5;
--delete from matricula where ra=6;
--delete from matricula where ra=7;
--delete from matricula where ra=8;
--delete from matricula where ra=9;
--delete from matricula where ra=10 and sigla = 'ac';

--select * from aluno

--select * from disciplina

--select * from Matricula

SELECT RA, Sigla, Data_Ano, Data_Semestre, Falta, Nota_N1, Nota_N2, Nota_Sub, Nota_Media, Situacao FROM Matricula where sigla = 'ac' and Data_Ano = 2021 

SELECT RA, Sigla, Falta, Nota_N1, Nota_N2, Nota_Sub, Nota_Media, Situacao FROM Matricula where Data_Ano = 2021  and Data_Semestre = 1 and ra =10

SELECT Ra, Sigla, Data_Ano,  Nota_N1, Nota_N2, Nota_Sub, Nota_Media, Situacao from matricula where Situacao != 'APROVADO POR NOTA'