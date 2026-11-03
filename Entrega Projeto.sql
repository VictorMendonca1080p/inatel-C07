DROP DATABASE IF EXISTS entregaFinal;
CREATE DATABASE entregaFinal;
USE entregaFinal;

create table Marca (
CNPJ char(30) primary key not null unique,
nome varchar (100) not null,
data_de_fundacao date not null
);

insert into Marca(CNPJ, nome, data_de_fundacao) values 
(100200300, 'Haeins', '1986-04-10'),
(400500600, 'Helmans', '1990-08-14'),
(700800900, 'Costa', '2001-08-15'),
(102030405, 'Nestle', '1975-04-07'),
(607080901, 'Elma chips', '2003-09-16');


create table Produto (
idProduto int primary key auto_increment not null unique,
nome varchar (100) not null,
data_de_validade date not null,
marca_CNPJ char(30) not null,
quantidade int not null,
foreign key (marca_CNPJ) references Marca(CNPJ)
);

insert into Produto(nome, data_de_validade, marca_CNPJ,quantidade) values 
('molho de tomate', '2026-12-03', 100200300,5),
('maionese', '2026-08-14', 400500600,6),
('atum', '2027-10-15', 700800900,10),
('chocolate', '2026-12-07', 102030405,8),
('salgadinho', '2026-11-16', 607080901,9);


create table Funcionario (
ID int not null unique auto_increment primary key,
nome varchar(100) not null,
funcao varchar(100) not null,
salario decimal(7,2) not null
);

insert into Funcionario(nome, funcao, salario) values 
('Antonio', 'caixa', 1500),
('Maria', 'caixa', 1500),
('Jose', 'acougueiro', 2500),
('Marcos', 'repositor', 2000),
('Rafael', 'limpeza', 1500);


create table Dono (
CPF char(20) not null unique primary key,
nome varchar(100) not null
);

insert into Dono(CPF, nome) values 
(123850584, 'Seu Zé'),
(375068475, 'Seu Arlindo'),
(495037596, 'Seu Marcos'),
(465839475, 'Seu Reginaldo'),
(088795758, 'Seu Antonio');


create table Supermercado(
CNPJ char(30) not null unique,
nome varchar(100) not null,
funcionario_id int not null,
dono_cpf char(20) not null,

foreign key(funcionario_id) references Funcionario(ID),
foreign key(dono_cpf) references Dono(CPF),
primary key(CNPJ, funcionario_id, dono_cpf)

);

insert into Supermercado(CNPJ, nome, funcionario_id, dono_cpf) values 
(475869785, 'Compre Já', 1, 123850584),
(088695657, 'Center box', 3, 495037596),
(476980797, 'Super Max', 2, 375068475),
(687759685, 'Super box', 4, 465839475),
(132439650, 'Compre mais', 5, 088795758);


create table Prateleiras (
produto_id int not null unique,
supermercado_cnpj char(30) not null unique,

foreign key(produto_id) references Produto(idProduto),
foreign key(supermercado_cnpj) references Supermercado(CNPJ),

primary key (produto_id, supermercado_cnpj)

);

insert into Prateleiras(produto_id, supermercado_cnpj) values 
(1, 475869785),
(2, 476980797),
(3, 088695657),
(4, 687759685),
(5, 132439650);

select * from Marca;
select * from Produto;
select * from Funcionario;
select * from Dono;
select * from Supermercado;
select * from Prateleiras;

drop user if exists 'Funcionario_Antonio'@'%';
create user 'Funcionario_Antonio'@'%' identified by '1234';
drop user if exists 'Funcionario_Maria'@'%';
create user 'Funcionario_Maria'@'%' identified by '4567';

drop role if exists 'privilegio_funcionario';
create role 'privilegio_funcionario';
grant update on entregaFinal.Produto to 'privilegio_funcionario';
grant 'privilegio_funcionario' to 'Funcionario_Antonio'@'%';
grant 'privilegio_funcionario' to 'Funcionario_Maria'@'%';
set default role 'privilegio_funcionario' to 'Funcionario_Antonio'@'%';
set default role 'privilegio_funcionario' to 'Funcionario_Maria'@'%';

-- relação 1:1
select 
	Supermercado.nome as NomeSupermercado,
    Dono.nome as NomeDono
from Supermercado
inner join Dono on Supermercado.dono_cpf = Dono.CPF;

-- relação 1:N 
select
	Supermercado.nome as NomeSupermercado,
    Funcionario.nome as NomeFuncionario,
    Funcionario.funcao as FuncaoFuncionario
from Supermercado
inner join Funcionario on Supermercado.funcionario_id = Funcionario.ID;

-- relação N:M
select 
	Produto.nome as NomeProduto,
	Supermercado.nome as NomeSupermercado
from Produto
inner join Prateleiras on Produto.idProduto = Prateleiras.produto_id
inner join Supermercado on Prateleiras.supermercado_cnpj = Supermercado.CNPJ;

-- procedure
delimiter $$ 
drop procedure if exists descontoSalarioFalta$$
create procedure descontoSalarioFalta(
	in funcionario_id int,
    in desconto varchar(2)
)
begin 
	update Funcionario
    set salario = salario * (1 - desconto/100)
    where ID = funcionario_id;
end $$
delimiter ;
call descontoSalarioFalta(2,5);
select * from Funcionario;

-- function
delimiter $$
drop function if exists acrescimoSalario$$
create function acrescimoSalario(salario decimal(7,2),percentSalario varchar(2))
returns decimal(7,2)
deterministic
begin
	return salario * (1 + percentSalario / 100);
end $$
delimiter ;
select nome,acrescimoSalario(salario,10) as SalarioReajustado from Funcionario;

-- trigger
delimiter $$
drop trigger if exists corrige_quantidade$$
create trigger corrige_quantidade before insert 
on Produto
for each row
begin
    if new.quantidade < 0 then
        set new.quantidade = 0;
    end if;
end $$
delimiter ;
insert into Produto(nome, data_de_validade, marca_CNPJ,quantidade) values ('leite condensado', '2026-12-10', 100200300, -2);
select * from Produto;

-- view
drop view if exists produtoMarcas;
create view produtoMarcas as
select
    Produto.idProduto as idProduto,
    Produto.nome as NomeProduto,
    Produto.data_de_validade as DataValidade,
    Marca.nome as NomeMarca
from Produto
inner join Marca on Produto.marca_CNPJ = Marca.CNPJ;

select * from produtoMarcas;

-- apagando todas procedures,views,function,trigger
drop procedure descontoSalarioFalta;
drop function acrescimoSalario;
drop trigger corrige_quantidade;
drop view produtoMarcas;