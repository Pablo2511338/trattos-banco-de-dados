# Levantamento de Campo — Trattos

Este documento apresenta as informações obtidas durante o levantamento realizado com a Trattos para compreender seus processos, regras de negócio e necessidades relacionadas ao sistema.

O texto foi organizado a partir da entrevista com o responsável pela organização. Quando alguma informação foi criada pelo grupo apenas para completar a modelagem acadêmica, isso é indicado separadamente.

---

## Identificação da organização

- **Nome utilizado no projeto:** Trattos
- **Razão social:** Trattos Laboratório Farmacêutico Ltda.
- **CNPJ:** 20.712.942/0001-00
- **Porte:** Empresa de Pequeno Porte (EPP)
- **Endereço cadastral utilizado no projeto:** Avenida Dona Charlote Szimai, 1465 — Parque Bariloche — Mairiporã/SP — CEP 07600-000
- **Atividade principal:** fabricação de alimentos dietéticos e complementos alimentares
- **Sócio-administrador:** Sergio Milton Troilo

---

## Informações da entrevista

- **Responsável entrevistado:** Sergio Milton Troilo
- **Função do entrevistado na Trattos:** proprietário e sócio-administrador
- **Telefone do responsável:** (11) 3351-1200
- **Data da entrevista:** 24 de setembro de 2026
- **Local onde a entrevista aconteceu:** escritório localizado na Rua Afonso Henriques, 123 — Tatuapé — São Paulo/SP
- **Integrantes do grupo que participaram:** todos os integrantes do grupo
- **Vínculo familiar informado:** o integrante Breno é sobrinho de Sergio Milton Troilo

A entrevista foi utilizada para entender o funcionamento da organização sem utilizar dados pessoais reais de clientes ou representantes.

---

## Produtos e serviços

A Trattos trabalha com suplementos alimentares funcionais voltados aos cuidados com a saúde e qualidade de vida, incluindo produtos como:

- colágeno hidrolisado;
- cálcio e magnésio;
- levedo de cerveja;
- Allium;
- pólen apícola;
- outros suplementos alimentares.

---

## Estrutura da operação

Durante a entrevista foi informado que atualmente existem **duas pessoas atuando diretamente na operação interna da Trattos**.

Uma delas atua nas funções operacionais, técnicas e administrativas.

A outra atua no atendimento aos representantes e nas vendas, além de participar da conferência e entrega ou envio dos pedidos.

A entrevista não informou a quantidade oficial de representantes ativos, clientes cadastrados ou pedidos realizados por mês.

Por esse motivo, o grupo não utilizou esses números como dados reais da organização.

A massa de dados do SQL possui **60 clientes fictícios apenas para testes acadêmicos**. Esse número não representa a quantidade real de clientes da Trattos.

---

## Representantes

A empresa trabalha com representantes através de um sistema multinível.

O representante ingressa no sistema através da aquisição de um kit inicial, atualmente no valor de **R$ 500,00**, convertido em produtos.

Nas compras seguintes, o representante possui **30% de desconto**. Ao atingir a condição definida pela empresa, pode passar a ter **40% de desconto**.

Os representantes fazem a ligação entre a Trattos e seus clientes.

No cadastro do representante são utilizadas informações como:

- documentos pessoais;
- endereço;
- estado civil;
- idade;
- informações sobre filhos;
- apresentador;
- treinador;
- última compra;
- maior compra;
- nível no sistema;
- valor do plano;
- data de passagem;
- percentual de comissão.

No modelo do grupo, as condições de 30% e 40% foram representadas como **R30** e **R40**.

O campo informado na entrevista como “apresentador” foi representado no modelo como patrocinador direto. O treinador foi mantido separadamente.

---

## Pedidos

Os pedidos são emitidos através de um sistema interno.

Após a emissão, os produtos são separados e o representante pode realizar a retirada ou receber o pedido através de envio.

Entre as informações registradas em um pedido estão:

- código do representante;
- número do pedido;
- item;
- quantidade;
- valor unitário;
- lote;
- validade;
- desconto do item;
- percentual de comissão;
- frete;
- data.

---

## Estoque

A empresa controla a entrada dos produtos e os respectivos lotes.

Na entrada são registrados dados como:

- número do lote;
- data de fabricação;
- data de validade.

Os lotes mais antigos possuem prioridade de saída.

A emissão do pedido realiza a baixa correspondente no estoque.

A entrada é registrada através do recebimento dos produtos e a saída ocorre através do pedido.

No projeto acadêmico, o grupo registrou lotes e quantidades utilizadas nos pedidos.

O saldo completo de estoque atual não foi usado como KPI porque o modelo precisaria de um controle mais detalhado de todas as entradas de estoque.

---

## Fornecedores

A compra de produtos é apoiada por um relatório semanal de estoque ou por alertas de estoque baixo.

Com base nas saídas dos produtos, a empresa realiza uma estimativa mensal para fazer pedidos aos fornecedores.

Durante a entrevista foi informado que a Trattos trabalha com fornecedores parceiros e qualificados.

No modelo foram incluídos:

- cadastro de fornecedores;
- produtos fornecidos;
- formas de pagamento;
- histórico de qualificação dos fornecedores.

---

## Conferência e entrega

Na operação interna, uma pessoa atua no recebimento e pedido de produtos e outra no atendimento e entrega dos pedidos ou envio.

Também foi informado que existe uma pessoa responsável pela conferência do pedido no momento da retirada pelo representante.

---

## Sistemas utilizados

A Trattos possui um sistema interno para pedidos e estoque.

Também utiliza:

- **Bling** para emissão de notas fiscais;
- **WhatsApp** para comunicação com representantes;
- WhatsApp para pedidos;
- WhatsApp para recebimento de comprovantes de pagamento.

---

## Principal dificuldade identificada

A principal dificuldade relatada atualmente está relacionada ao **pagamento das comissões**, que ocorre de forma semiautomatizada.

No trabalho, esse problema foi identificado como:

**P1 — Controle e pagamento de comissões.**

A entrevista não informou todas as fórmulas e percentuais utilizados para calcular as comissões.

Por isso, os percentuais utilizados na massa de testes do SQL são fictícios e servem apenas para demonstrar o funcionamento do banco.

---

## Solução desejada

A empresa demonstrou interesse em um **Escritório Virtual para os representantes**.

A ideia apresentada inclui recursos para:

- cadastrar clientes pessoais;
- emitir pedidos para clientes;
- emitir pedidos para a Trattos;
- controlar pedidos;
- controlar pagamentos;
- acompanhar comissões a receber;
- visualizar comissões do grupo;
- acompanhar a equipe;
- acompanhar produção;
- visualizar comissões;
- permitir que valores de comissão possam ser utilizados na compra de produtos.

Essa necessidade foi registrada no trabalho como:

**P2 — Centralização das informações operacionais.**

---

## Decisões de modelagem do grupo

Alguns detalhes do banco não foram informados diretamente na entrevista e foram definidos pelo grupo para completar o trabalho acadêmico.

Entre eles estão:

- uso dos nomes R30 e R40 para representar as condições de 30% e 40% de desconto;
- representação do apresentador como patrocinador direto;
- separação entre patrocinador e treinador;
- criação de atividade mensal;
- histórico de qualificações;
- registro de visitas e previsão de próximo contato;
- registro de condições de saúde no acompanhamento dos clientes;
- separação de pagamentos de pedidos e vendas;
- possibilidade de mais de um pagamento para uma mesma operação;
- criação das tabelas associativas necessárias no modelo lógico;
- utilização de massa de dados fictícia para testes.

Essas decisões fazem parte da solução acadêmica e não devem ser tratadas como regras comerciais confirmadas pela empresa quando a entrevista não informou esses detalhes.

---

## Observações feitas presencialmente

A entrevista aconteceu presencialmente em um **escritório localizado na Rua Afonso Henriques, 123 — Tatuapé — São Paulo/SP**.

O grupo observou o ambiente de escritório onde a entrevista foi realizada.

Como não foram registradas no material utilizado outras observações presenciais detalhadas sobre estoque, separação de pedidos ou uso dos sistemas, o grupo não acrescentou informações que não pudesse confirmar.

---

## Evidências da visita

A foto da visita/entrevista já foi adicionada ao repositório GitHub como evidência do levantamento.

Ela deve permanecer dentro da pasta de evidências do levantamento, em formato JPG ou PNG.

Estrutura recomendada:

- `levantamento/levantamento.md`
- `levantamento/evidencias/` — foto da visita/entrevista

As fotos não devem mostrar dados pessoais ou confidenciais de clientes.

---

## Conclusão

O levantamento mostrou que a Trattos já utiliza sistemas em parte da operação, principalmente para pedidos, estoque e emissão de notas fiscais.

A principal dificuldade relatada está no controle e pagamento das comissões.

Também existe o interesse em centralizar informações de representantes, clientes, pedidos, pagamentos, produção, equipe e comissões em um escritório virtual.

As informações levantadas serviram de base para o DER, o modelo lógico, o dicionário de dados e o script SQL.

O grupo procurou separar aquilo que foi confirmado na entrevista das decisões tomadas durante a modelagem, evitando apresentar como regra da empresa algo que não foi informado pelo responsável.
