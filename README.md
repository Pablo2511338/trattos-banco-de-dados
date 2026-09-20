# Entrega 1 — Modelo Conceitual (DER)

## Metadados

- **Nomes dos alunos e RGM:** [PREENCHER]

---

## 1. Caracterização da Organização

### Nome e natureza da organização

A organização escolhida pelo grupo é a **Trattos**, empresa que atua com suplementos alimentares funcionais voltados aos cuidados com a saúde e qualidade de vida.

Entre os produtos comercializados estão colágeno hidrolisado, cálcio e magnésio, levedo de cerveja, Allium e pólen apícola, entre outros.

A empresa trabalha comercialmente com **representantes em sistema multinível**, que fazem a ligação entre a Trattos e seus respectivos clientes.

### Contexto e porte

Segundo o levantamento realizado diretamente com a organização, atualmente a operação conta com aproximadamente **duas pessoas**, sendo uma responsável pelas atividades operacionais, técnicas e administrativas e outra voltada ao atendimento aos representantes e às vendas.

O representante ingressa no sistema por meio da aquisição de um kit inicial convertido em produtos.

Nas compras posteriores, o representante possui uma faixa de desconto definida e pode avançar de nível conforme metas estabelecidas pela organização.

### Problemas e necessidades identificados

A principal dificuldade identificada durante a pesquisa de campo está relacionada ao **pagamento das comissões**, que atualmente ocorre de forma semiautomatizada.

A empresa demonstrou interesse na criação de um **Escritório Virtual para os representantes**, permitindo cadastrar clientes, emitir e acompanhar pedidos, consultar pagamentos, acompanhar comissões próprias e da equipe, visualizar produção e utilizar saldo de comissão na compra de produtos.

### Justificativa da escolha

A Trattos foi escolhida por ser uma organização real à qual o grupo possui acesso direto para levantamento de informações.

Além disso, sua operação envolve diferentes processos e informações relacionadas a representantes, clientes, pedidos, produtos, estoque, lotes, pagamentos, fornecedores e comissões, tornando a organização adequada para aplicação dos conceitos de modelagem de banco de dados.

### Evidências da organização

As evidências da organização serão complementadas com:

- Fotos da organização e/ou da visita;
- Endereço;
- Forma de contato;
- Registro da pesquisa de campo;
- Links públicos da organização, quando aplicáveis.

---

## 2. Processos de Negócio

### 2.1 Cadastro e ingresso de representantes

A Trattos trabalha com representantes em sistema multinível.

O ingresso do representante ocorre por meio da aquisição de um kit inicial convertido em produtos.

Após o cadastro, o representante passa a possuir informações associadas ao seu nível, plano, percentual de comissão e condições comerciais.

### 2.2 Emissão e acompanhamento de pedidos

Os pedidos são emitidos por meio do sistema interno da empresa.

Após a emissão, os produtos são separados e podem ser retirados pelo representante ou enviados.

Cada pedido registra informações como número do pedido, código do representante, itens, quantidade, valor unitário, lote, validade, desconto, percentual de comissão, frete e data.

### 2.3 Controle de estoque e lotes

A entrada de produtos é registrada no estoque da empresa.

Cada lote possui informações como número do lote, data de fabricação e data de validade.

A Trattos utiliza o princípio de priorizar a saída dos lotes mais antigos.

Quando um pedido é emitido, ocorre a baixa correspondente no estoque.

### 2.4 Reposição de estoque e fornecedores

A necessidade de reposição é identificada por relatórios semanais ou alertas de estoque baixo.

Com base nas saídas dos produtos, a empresa realiza pedidos aos fornecedores e faz estimativas mensais para reposição.

### 2.5 Pagamentos e comunicação

A Trattos utiliza um sistema interno para controle de pedidos e estoque.

Também utiliza a plataforma Bling para emissão de notas fiscais e WhatsApp para comunicação com representantes, pedidos e envio de comprovantes de pagamento.

### 2.6 Gestão de comissões

A gestão de comissões é um dos principais processos da empresa.

Atualmente, o pagamento de comissões ocorre de forma semiautomatizada.

A proposta de melhoria envolve permitir que o representante acompanhe suas comissões, as comissões de sua equipe, sua produção e utilize o saldo de comissões para compra de produtos.

---

## 3. Requisitos do Sistema

### 3.1 Requisitos Funcionais

- **RF01 — Cadastrar clientes:** o sistema deve permitir que representantes cadastrem clientes.

- **RF02 — Consultar clientes:** o sistema deve permitir consultar os clientes cadastrados.

- **RF03 — Pesquisar e filtrar clientes:** o sistema deve permitir localizar clientes utilizando diferentes critérios de busca.

- **RF04 — Editar dados de clientes:** o sistema deve permitir alterar informações dos clientes cadastrados.

- **RF05 — Registrar pedidos:** o sistema deve permitir criar pedidos.

- **RF06 — Adicionar e remover itens do pedido:** o sistema deve permitir incluir ou retirar produtos durante a criação do pedido.

- **RF07 — Consultar pedidos:** o sistema deve permitir acompanhar os pedidos realizados.

- **RF08 — Consultar estoque:** o sistema deve permitir consultar a disponibilidade dos produtos.

- **RF09 — Registrar pagamentos:** o sistema deve permitir registrar pagamentos relacionados às operações realizadas.

- **RF10 — Consultar histórico de pagamentos:** o sistema deve manter e permitir consultar o histórico dos pagamentos.

- **RF11 — Consultar comissões:** o representante deve conseguir visualizar suas comissões.

- **RF12 — Consultar desempenho da equipe:** o sistema deve permitir visualizar informações de produção e desempenho da equipe.

- **RF13 — Consultar comissões da equipe:** o sistema deve permitir ao representante acompanhar comissões relacionadas ao seu grupo.

- **RF14 — Utilizar comissões em compras:** o sistema deve permitir utilizar saldo de comissão na aquisição de produtos.

### 3.2 Requisitos Não Funcionais

- **RNF01 — Segurança:** os dados de clientes, representantes e pagamentos devem ser protegidos contra acessos não autorizados.

- **RNF02 — Controle de acesso:** cada usuário deve acessar somente as informações e funções permitidas ao seu perfil.

- **RNF03 — Desempenho:** consultas, buscas e operações comuns devem possuir tempo de resposta adequado para uso diário.

- **RNF04 — Usabilidade:** buscas, filtros e funções principais devem possuir interface simples e intuitiva.

- **RNF05 — Integridade dos dados:** alterações realizadas no sistema devem ser armazenadas corretamente e refletidas nas consultas.

- **RNF06 — Consistência do estoque:** as informações de estoque devem permanecer atualizadas após entradas e saídas.

- **RNF07 — Precisão financeira:** valores de pagamentos e comissões devem ser apresentados corretamente.

- **RNF08 — Persistência do histórico:** registros financeiros necessários para consulta e controle não devem ser perdidos indevidamente.

---

## 4. Regras de Negócio

### Regras operacionais

- **RN01 — Ingresso de representantes:** o ingresso de um representante no sistema ocorre por meio da aquisição de um kit inicial convertido em produtos.

- **RN02 — Condição de desconto:** após o ingresso, o representante possui uma faixa inicial de desconto nas compras e pode alcançar uma faixa maior ao atingir a meta estabelecida pela empresa.

- **RN03 — Identificação dos pedidos:** cada pedido deve estar associado ao representante responsável pela operação.

- **RN04 — Composição do pedido:** um pedido pode conter diferentes produtos, sendo necessário registrar a quantidade, valor unitário, desconto e percentual de comissão de cada item.

- **RN05 — Baixa de estoque:** a emissão de um pedido provoca a baixa correspondente dos produtos no estoque.

- **RN06 — Controle por lote:** os produtos em estoque devem ser controlados por lote, incluindo número do lote, data de fabricação e data de validade.

- **RN07 — Prioridade de saída:** durante a separação dos produtos, devem ser priorizados os lotes mais antigos disponíveis.

- **RN08 — Reposição de estoque:** a necessidade de reposição pode ser identificada por relatórios semanais ou alertas de estoque baixo, utilizando as saídas dos produtos como referência para a compra.

- **RN09 — Retirada ou envio:** após a separação, o pedido pode ser retirado pelo representante ou encaminhado para envio.

- **RN10 — Gestão de comissões:** o representante deve possuir informações relacionadas às suas comissões e à produção de sua equipe.

- **RN11 — Utilização de comissão:** o saldo de comissão poderá ser utilizado na compra de produtos, conforme o funcionamento definido pela empresa.

### Restrições organizacionais

- A empresa trabalha com representantes em sistema multinível.
- O estoque possui controle por lotes e validade.
- A operação de pedidos e estoque utiliza sistema interno.
- A emissão de notas fiscais é realizada por meio da plataforma Bling.
- O WhatsApp também é utilizado na comunicação com representantes e no envio de comprovantes de pagamento.
- O processo de pagamento de comissões é atualmente semiautomatizado e foi identificado como uma das principais necessidades de melhoria.

---

## 5. Dicionário de Dados Conceitual

O Dicionário de Dados Conceitual está em desenvolvimento com base nas entidades identificadas no DER.

Até o momento, foram identificadas as seguintes entidades:

- REPRESENTANTE
- CLIENTE
- PEDIDO
- ITEM_PEDIDO
- PRODUTO
- LOTE
- PAGAMENTO
- COMISSAO
- FORNECEDOR

O documento completo será disponibilizado também em HTML na pasta `dicionario` do repositório.

---

## 6. Modelagem Conceitual

### Entidades reconhecidas

Até o momento, o modelo conceitual apresenta as seguintes entidades:

#### REPRESENTANTE

Representa as pessoas que fazem parte do sistema comercial multinível da Trattos.

Atributos atualmente identificados:

- id_representante
- codigo_representante
- endereco
- estado_civil
- idade
- nivel
- plano
- percentual_comissao

#### CLIENTE

Representa os clientes cadastrados pelos representantes.

Atributo atualmente identificado:

- id_cliente

Outros atributos serão definidos após validação com a organização.

#### PEDIDO

Representa os pedidos realizados no sistema.

Atributos atualmente identificados:

- id_pedido
- numero_pedido
- data
- frete

#### ITEM_PEDIDO

Representa cada produto presente em um pedido.

Atributos atualmente identificados:

- id_item
- quantidade
- valor_unitario
- desconto_item
- percentual_comissao

#### PRODUTO

Representa os produtos comercializados pela Trattos.

Atributos atualmente identificados:

- id_produto
- nome

#### LOTE

Representa os lotes dos produtos armazenados pela empresa.

Atributos atualmente identificados:

- id_lote
- numero_lote
- data_fabricacao
- data_validade

#### PAGAMENTO

Representa os pagamentos registrados no sistema.

Atributo inicialmente identificado:

- id_pagamento

A estrutura será complementada após validação das regras relacionadas aos pagamentos.

#### COMISSAO

Representa as comissões geradas para os representantes.

Atributo inicialmente identificado:

- id_comissao

A estrutura será complementada após validação do funcionamento das comissões no sistema multinível.

#### FORNECEDOR

Representa os fornecedores utilizados pela Trattos.

Atributo inicialmente identificado:

- id_fornecedor

A relação entre fornecedores e produtos será finalizada após validação com a organização.

### Relacionamentos atualmente definidos

- **REPRESENTANTE realiza PEDIDO**
  - Um representante pode realizar nenhum ou vários pedidos.
  - Cada pedido está associado a exatamente um representante.

- **PEDIDO possui ITEM_PEDIDO**
  - Um pedido possui um ou vários itens.
  - Cada item pertence a exatamente um pedido.

- **ITEM_PEDIDO refere-se a PRODUTO**
  - Cada item refere-se a exatamente um produto.
  - Um produto pode aparecer em nenhum ou vários itens de pedidos.

- **PRODUTO possui LOTE**
  - Um produto pode possuir nenhum ou vários lotes.
  - Cada lote pertence a exatamente um produto.

Alguns relacionamentos permanecem em validação com a organização antes da finalização do DER.

---

## 7. Diagrama Entidade-Relacionamento (DER)

O Diagrama Entidade-Relacionamento está sendo desenvolvido utilizando o BRModelo Web.

A versão atual apresenta as entidades, atributos, relacionamentos e cardinalidades já confirmados durante o levantamento de requisitos.

O arquivo final do DER será anexado em imagem na pasta `diagramas` do repositório.

Relacionamentos já modelados:

- REPRESENTANTE `(0,N)` — REALIZA — `(1,1)` PEDIDO
- PEDIDO `(1,N)` — POSSUI — `(1,1)` ITEM_PEDIDO
- ITEM_PEDIDO `(1,1)` — REFERE_SE — `(0,N)` PRODUTO
- PRODUTO `(0,N)` — POSSUI — `(1,1)` LOTE

As relações envolvendo CLIENTE, PAGAMENTO, COMISSAO e FORNECEDOR permanecem em validação antes da versão final.

---

## 8. Justificativa Técnica

A modelagem conceitual foi desenvolvida com base nas informações coletadas diretamente junto à Trattos.

A entidade **REPRESENTANTE** foi criada porque os representantes são elementos centrais da operação comercial da organização.

A entidade **PEDIDO** foi separada de REPRESENTANTE porque um mesmo representante pode realizar diversos pedidos ao longo do tempo.

A entidade **ITEM_PEDIDO** foi utilizada para representar os diferentes produtos que podem compor um mesmo pedido. Essa estrutura evita a criação de atributos repetitivos como produto1, produto2 e produto3 e permite representar adequadamente pedidos com quantidades variáveis de produtos.

A entidade **PRODUTO** foi separada de ITEM_PEDIDO porque um mesmo produto pode aparecer em diferentes pedidos.

A entidade **LOTE** foi separada de PRODUTO porque um mesmo produto pode possuir diferentes lotes, cada um com sua própria data de fabricação e validade.

Foram utilizados identificadores próprios, como `id_representante`, `id_pedido`, `id_produto` e `id_lote`, para evitar a utilização de atributos como nome como identificadores únicos.

Algumas relações ainda não foram definidas de forma definitiva porque dependem de validação adicional com a organização. Essa decisão evita que o modelo represente regras que não fazem parte da realidade da empresa.

---

## 9. Uso de Inteligência Artificial

O grupo utilizou ferramenta de Inteligência Artificial como apoio durante a organização e desenvolvimento inicial do projeto.

| Item | Registro |
|------|----------|
| **Ferramenta e etapa** | ChatGPT, da OpenAI, utilizado na interpretação do enunciado, organização da pesquisa de campo, revisão dos requisitos e apoio à modelagem conceitual. |
| **Motivação** | Auxiliar na organização das informações coletadas e na aplicação dos conceitos estudados em Banco de Dados. |
| **Prompts utilizados** | Foram utilizados prompts solicitando explicações sobre a Entrega 1, elaboração de perguntas para pesquisa de campo, organização de requisitos e apoio na construção do DER. |
| **Resposta recebida** | A ferramenta apresentou sugestões de organização, possíveis entidades, relacionamentos e formas de estruturar a documentação. |
| **Fontes consultadas e verificadas** | As sugestões relacionadas ao funcionamento da organização foram comparadas com as respostas obtidas diretamente junto ao responsável pela Trattos. |
| **Trechos rejeitados ou corrigidos** | Hipóteses inicialmente sugeridas, como existência de manipulação de fórmulas, foram descartadas após a empresa informar que não trabalha com esse processo. Algumas classificações de requisitos também foram revisadas manualmente. |
| **Justificativa da escolha final** | Foram mantidas apenas sugestões consideradas coerentes com a pesquisa de campo e com os conceitos trabalhados na disciplina. |
| **Reflexão crítica** | A IA não possui conhecimento direto dos processos internos da organização e pode sugerir entidades, regras ou relações inexistentes. Por isso, as decisões finais do modelo dependem da validação do grupo e das informações obtidas diretamente com a Trattos. |

---

## Observações para finalização

Antes da entrega final, ainda serão complementados:

- Dados dos alunos e RGM;
- Evidências da organização;
- Respostas das perguntas adicionais de validação;
- Atributos restantes;
- Relacionamentos restantes;
- Cardinalidades restantes;
- Dicionário de Dados completo em HTML;
- Imagem final do DER;
- Revisão da justificativa técnica;
- Registro completo dos usos de Inteligência Artificial.
