# Projeto Banco de Dados – Supermercado

Grupo: Victor dos Anjos Mendonça / Layla Victória Sousa Teles

## 1. Sobre o Projeto

O projeto consiste na criação de um banco de dados para um sistema de supermercados, utilizando MySQL. O objetivo é armazenar e relacionar informações referentes às marcas, produtos, funcionários, donos dos estabelecimentos, supermercados e produtos disponíveis em cada supermercado.

## 2. Inserção e Consulta de Dados (DML)

Utilizamos o comando `INSERT` para inserir os dados nas tabelas, realizando o cadastro de pelo menos cinco registros em cada uma delas.

Foi utilizado o comando `SELECT` para visualizar como ficaram as tabelas após a inserção dos dados. Dessa forma, conseguimos conferir se os registros foram armazenados corretamente.

Também utilizamos o comando `UPDATE`, para atualizar dados ja inseridos nas tabelas.

As consultas com `SELECT` também foram utilizadas para visualizar informações que estão nas tabelas.

## 3. Criação de Usuários e ROLE

A ROLE funciona como um agrupador de permissões. Em vez de conceder privilégios individualmente para cada usuário, podemos conceder as permissões à ROLE e depois associar os usuários a ela.

No nosso projeto, criamos uma ROLE chamada `privilegio_funcionario`, destinada a agrupar as permissões dos funcionários. Como criamos dois usuários com responsabilidades semelhantes, foi mais prático criar uma única ROLE para atribuir os privilégios a ambos.

Foi concedida à ROLE a permissão de `UPDATE` na tabela `Produto`, permitindo que os usuários associados possam atualizar os registros dessa tabela.

## 4. Consultas Utilizando JOIN

Foram desenvolvidas consultas utilizando `INNER JOIN` para relacionar informações de diferentes tabelas:

- **Relacionamento 1:1:** consulta relacionando as tabelas `Supermercado` e `Dono`, permitindo visualizar o nome do supermercado e o nome do seu proprietário.
- **Relacionamento 1:N:** consulta relacionando `Supermercado` e `Funcionario`, permitindo visualizar o estabelecimento e o funcionário associado e sua função.
- **Relacionamento N:M:** consulta entre `Produto` e `Supermercado`, utilizando a tabela intermediária `Prateleiras` para relacionar quais produtos estão associados a cada estabelecimento.

A utilização dos JOINs permite reunir informações de diferentes tabelas em uma única consulta, evitando a necessidade de armazenar informações repetidas.

## 5. Procedure

Foi criada a procedure `descontoSalarioFalta`, responsável por aplicar um desconto percentual no salário de um funcionário. Isso foi feito para caso o funcionário falte, seja mais fácil para o Dono fazer sua redução salarial.

A procedure recebe dois parâmetros: o ID do funcionário e o percentual de desconto que será aplicado.

Utilizamos o comando `UPDATE` para atualizar o salário na tabela `Funcionario`, enquanto o `WHERE` garante que somente o funcionário correspondente ao ID informado seja alterado.

A escolha de uma procedure permite reutilizar essa operação sempre que necessário, bastando informar os parâmetros desejados por meio do comando `CALL`.

## 6. Function

Foi criada a function `acrescimoSalario`, responsável por calcular um reajuste percentual no salário de um funcionário.

A função recebe dois parâmetros: o salário atual e o percentual de aumento desejado. Por meio de uma operação matemática, calcula o novo salário e retorna o resultado utilizando `RETURN`.

Diferentemente da procedure, essa função apenas realiza o cálculo e retorna o valor, sem alterar diretamente o salário armazenado na tabela.

## 7. View

Foi criada a view `produtoMarcas`, com o objetivo de facilitar a consulta dos produtos e de suas respectivas marcas. Para isso, utilizamos um `INNER JOIN` entre as tabelas `Produto` e `Marca`.

A VIEW permite reutilizar essa consulta sem precisar escrever novamente todo o comando JOIN sempre que quisermos visualizar essas informações.

## 8. Trigger

Foi criado um trigger para realizar automaticamente uma verificação na quantidade de produtos antes de uma nova inserção na tabela `Produto`.

A utilização do trigger permite corrigir automaticamente quantidades negativas, atribuindo o valor zero antes que o registro seja inserido. Foi utilizado `BEFORE INSERT` porque a verificação precisa acontecer antes da inserção do registro.

Também utilizamos `NEW` para acessar o valor da quantidade que está sendo informado no novo cadastro. Dessa maneira, conseguimos aplicar uma regra de validação diretamente no banco de dados, sem precisar realizar essa verificação manualmente em cada inserção.

## 9. Utilização do DROP

Utilizamos comandos `DROP IF EXISTS` antes da criação de alguns objetos, como procedures, functions, views e triggers. Isso foi feito porque durante o desenvolvimento, executamos várias vezes o script para testar as funcionalidades implementadas.

Como os objetos criados permanecem armazenados no banco de dados, uma nova execução poderia gerar erros informando que determinado objeto já existe. Com o `DROP IF EXISTS`, verificamos se o objeto já existe e caso exista, ele é removido antes de ser criado novamente. Dessa forma, conseguimos executar o script repetidas vezes durante os testes evitando conflitos de duplicidade.

Também utilizamos `DROP DATABASE IF EXISTS` no início do script para recriar o banco de dados durante os testes, garantindo que a execução começasse com uma estrutura limpa.
