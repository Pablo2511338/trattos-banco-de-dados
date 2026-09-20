# Entrega 1 — Modelo Conceitual (DER)

## Metadados

## 1. Caracterização da Organização

### Nome e natureza da organização

A organização escolhida pelo grupo é a **Trattos**, empresa que atua com suplementos alimentares funcionais voltados aos cuidados com a saúde e qualidade de vida.

Entre os produtos comercializados estão colágeno hidrolisado, cálcio e magnésio, levedo de cerveja, Allium e pólen apícola, entre outros.

A empresa trabalha comercialmente com **representantes em sistema multinível**, que fazem a ligação entre a Trattos e seus respectivos clientes.

### Contexto e porte

Segundo o levantamento realizado diretamente com a organização, atualmente a operação conta com aproximadamente **duas pessoas**, sendo uma responsável pelas atividades operacionais, técnicas e administrativas e outra voltada ao atendimento aos representantes e às vendas.

O representante ingressa no sistema através da aquisição de um kit inicial convertido em produtos. Nas compras posteriores, possui uma faixa de desconto definida e pode avançar de nível conforme metas estabelecidas pela organização.

### Problemas e necessidades identificados

A principal dificuldade identificada durante a pesquisa de campo está relacionada ao **pagamento das comissões**, que atualmente ocorre de forma semiautomatizada.

A empresa demonstrou interesse na criação de um **Escritório Virtual para os representantes**, permitindo cadastrar clientes, emitir e acompanhar pedidos, consultar pagamentos, acompanhar comissões próprias e da equipe, visualizar produção e utilizar saldo de comissão na compra de produtos.

### Justificativa da escolha

A Trattos foi escolhida por ser uma organização real à qual o grupo possui acesso direto para levantamento de informações.

Além disso, sua operação envolve diferentes processos e informações relacionadas a representantes, clientes, pedidos, produtos, estoque, lotes, pagamentos, fornecedores e comissões, tornando a organização adequada para aplicação dos conceitos de modelagem de banco de dados.

### Evidências da organização

As evidências da organização serão complementadas com registros da pesquisa de campo, endereço, forma de contato e demais informações públicas ou obtidas diretamente com a empresa.
## 2. Processos de Negócio

### 2.1 Cadastro e ingresso de representantes

A Trattos trabalha com representantes em sistema multinível. O ingresso do representante ocorre por meio da aquisição de um kit inicial convertido em produtos.

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
## 4. Regras de Negócio

## 5. Dicionário de Dados Conceitual

## 6. Modelagem Conceitual

## 7. Diagrama Entidade-Relacionamento (DER)

## 8. Justificativa Técnica

## 9. Uso de Inteligência Artificial
