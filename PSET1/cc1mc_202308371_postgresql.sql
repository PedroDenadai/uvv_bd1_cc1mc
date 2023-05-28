--------Deleta o DATABASE, USER (pedro_denadai) e a ROLE. Por preocação caso tenha algum banco de dados ja existente

-- Verificar se o banco de dados (uvv) já existe e excluí-lo

DROP DATABASE IF EXISTS uvv;

-- Deletar a role (usuário) pedro_denadai se existir

DROP ROLE IF EXISTS pedro_denadai;

-- Deletar o usuário pedro_denadai se existir

DROP USER IF EXISTS pedro_denadai;






--Cria o usuário pedro_denadai
--OBS: O CREATEDB permite ao user criar banco de dados , e o ENCRYPTED cria uma senha criptografada

CREATE USER pedro_denadai WITH CREATEDB CREATEROLE ENCRYPTED PASSWORD 'senha01';

--Muda a ROLE para o user pedro_denadai

SET ROLE pedro_denadai;

-- Criar o Banco de Dados uvv com todos os parâmetros que o PSET passou.

CREATE DATABASE uvv 
    WITH OWNER        =         pedro_denadai
    TEMPLATE          =         template0
    ENCODING          =         'UTF8'
    LC_COLLATE        =         'pt_BR.UTF-8'
    LC_CTYPE          =         'pt_BR.UTF-8'
    ALLOW_CONNECTIONS =         true;

--Comentário no banco de dados uvv

COMMENT ON DATABASE uvv IS 'Esse é um banco de dados do sistema de lojas da uvv, com um schema (lojas)';

--Altera o dono do banco de dados uvv para o user pedro_denadai, com isso o user terá permissões para criar tabelas e altera-las

ALTER DATABASE uvv OWNER TO pedro_denadai;

-- Conectar ao banco de dados (uvv) com o user pedro_denadai

\c uvv pedro_denadai;

--Deleta o schema lojas se existir

DROP SCHEMA IF EXISTS lojas;

-- Criar Schema (lojas) com autorizacao para o user pedro_denadai

CREATE SCHEMA IF NOT EXISTS lojas AUTHORIZATION pedro_denadai;

--Altera o search_path do database uvv para o lojas, $user e public

ALTER DATABASE uvv SET search_path TO lojas, '$user', public;

--Altera o search_path para que seja lojas, $user e public

SET search_path TO lojas, '$user', public;

--Comentário do Schema

COMMENT ON SCHEMA lojas IS 'Esquema Lojas dentro do banco de dados UVV'

--Alterando o search_path do user para o search_path lojas

ALTER USER pedro_denadai SET search_path TO lojas, '$user', public;

-- Alterar o Schema (lojas) para o usuário (pedro_denadai)

ALTER SCHEMA lojas OWNER TO pedro_denadai;




                                            --------------------------------------
                                            ----------------PRODUTOS--------------
                                            --------------------------------------



--Cria a tabela produtos

CREATE TABLE lojas.produtos (
        produto_id                NUMERIC(38)       NOT NULL,
        nome                      VARCHAR(255)      NOT NULL,
        preco_unitario            NUMERIC(10,2),
        detalhes                  BYTEA,
        imagem                    BYTEA,
        imagem_mime_type          VARCHAR(512),
        imagem_arquivo            VARCHAR(512),
        imagem_charset            VARCHAR(512),
        imagem_ultima_atualizacao DATE
);

--Cria a PRIMARY KEY da tabela Produtos

ALTER TABLE             lojas.produtos
ADD CONSTRAINT          produto_id_pk
PRIMARY KEY             (produto_id);

--Comentario da Tabela

COMMENT ON TABLE lojas.produtos IS                             'Tabela de cadastro de produtos que tem nome, preco unitario, detalhes, e imagem do produto';

--Comentários das colunas da tabela Produtos

COMMENT ON COLUMN lojas.produtos.produto_id IS                 'Primary Key da tabela Produtos';

COMMENT ON COLUMN lojas.produtos.nome IS                       'Nome do Produto cadastrado';

COMMENT ON COLUMN lojas.produtos.preco_unitario IS             'Preço Unitário de cada produto, ou seja, não se aplica no conjunto';

COMMENT ON COLUMN lojas.produtos.detalhes IS                   'Detalhes sobre o produto';

COMMENT ON COLUMN lojas.produtos.imagem IS                     'Imagem do produto';

COMMENT ON COLUMN lojas.produtos.imagem_mime_type IS           'Imagem MIME_TYPE do produto';

COMMENT ON COLUMN lojas.produtos.imagem_arquivo IS             'Arquivo da Imagem';

COMMENT ON COLUMN lojas.produtos.imagem_charset IS             'Charset da imagem';

COMMENT ON COLUMN lojas.produtos.imagem_ultima_atualizacao IS  'Data da ultima atualização da imagem do produto';



                                            --------------------------------------
                                            ----------------LOJAS-----------------
                                            --------------------------------------




--Cria a tabela Lojas

CREATE TABLE lojas.lojas (
        loja_id                 NUMERIC(38)     NOT NULL,
        nome                    VARCHAR(255)    NOT NULL,
        endereco_web            VARCHAR(100),
        endereco_fisico         VARCHAR(512),
        latitude                NUMERIC,
        longitude               NUMERIC,
        logo                    BYTEA,
        logo_mime_type          VARCHAR(512),
        logo_arquivo            VARCHAR(512),
        logo_charset            VARCHAR(512),
        logo_ultima_atualizacao DATE
);

--Criar a PRIMARY KEY da tabela lojas

ALTER TABLE             lojas.lojas
ADD CONSTRAINT          lojas_id_pk
PRIMARY KEY             (loja_id);

--Comentario da Tabela

COMMENT ON TABLE lojas.lojas IS                            'Tabela do cadastro das lojas que possuem dados como: nome, enderecos, latitude, longitude e imagens da logos das lojas ';

--Cometarios das Colunas

COMMENT ON COLUMN lojas.lojas.loja_id IS                   'Primary Key da tabela Lojas';

COMMENT ON COLUMN lojas.lojas.nome IS                      'Nome da Loja, não pode ser nula';

COMMENT ON COLUMN lojas.lojas.endereco_web IS              'Endereco HTTP do site aonde o site da Loja está ospedado';

COMMENT ON COLUMN lojas.lojas.endereco_fisico IS           'Endereço de Entrega , podendo conter: Rua, Bairro, Cidade, Estado e CEP.';

COMMENT ON COLUMN lojas.lojas.latitude IS                  'Latitude da localização da Loja';

COMMENT ON COLUMN lojas.lojas.longitude IS                 'Longitude da localização da Loja';

COMMENT ON COLUMN lojas.lojas.logo IS                      'Logo da Loja.';

COMMENT ON COLUMN lojas.lojas.logo_mime_type IS            'Logo MIME_TYPE da Loja';

COMMENT ON COLUMN lojas.lojas.logo_arquivo IS              'Arquivo da Logo';

COMMENT ON COLUMN lojas.lojas.logo_charset IS              'Charset da Logo';

COMMENT ON COLUMN lojas.lojas.logo_ultima_atualizacao IS   'Data da ultima atualizacao da Logo';

                                            --------------------------------------
                                            ----------------ESTOQUES--------------
                                            --------------------------------------

--Criar a tabela Estoques

CREATE TABLE lojas.estoques (
        estoque_id      NUMERIC(38)     NOT NULL,
        quantidade      NUMERIC(38)     NOT NULL,
        loja_id         NUMERIC(38)     NOT NULL,
        produto_id      NUMERIC(38)     NOT NULL
);

--Criar a PRIMARY KEY da tabela Estoque 

ALTER TABLE             lojas.estoques
ADD CONSTRAINT          estoque_id_pk
PRIMARY KEY             (estoque_id);

--Comentario da Tabela

COMMENT ON TABLE lojas.estoques IS                     'Tabela de Estoques com dados de quantidade, foreign keys das tabelas lojas e produtos';

--Comentario das colunas na tabela Estoque

COMMENT ON COLUMN lojas.estoques.estoque_id IS         'Primary Key da tabela Estoques';

COMMENT ON COLUMN lojas.estoques.quantidade IS         'Quantidade de Produtos que estão armazenados no estoque, não pode ser nula';

COMMENT ON COLUMN lojas.estoques.loja_id IS            'Foreign Key da tabela Lojas, não pode ser nula';

COMMENT ON COLUMN lojas.estoques.produto_id IS         'Foreign Key da tabela Produtos, não pode ser nula';



                                            --------------------------------------
                                            ----------------CLIENTES--------------
                                            --------------------------------------



--Criar a tabela Clientes

CREATE TABLE lojas.clientes (
        cliente_id      NUMERIC(38)     NOT NULL,
        email           VARCHAR(255)    NOT NULL,
        nome            VARCHAR(255)    NOT NULL,
        telefone1       VARCHAR(20),
        telefone2       VARCHAR(20),
        telefone3       VARCHAR(20)
);

--Criar PRIMARY KEY da tabela Clientes

ALTER TABLE lojas.clientes 
ADD CONSTRAINT cliente_id_pk
PRIMARY KEY (cliente_id);

--Comentario da tabela Clientes

COMMENT ON TABLE lojas.clientes IS                     'Tabela de cadastro de Clientes, com telefone, email, nome do cliente';

--Comentario das colunas da tabela Clientes

COMMENT ON COLUMN lojas.clientes.cliente_id IS         'Primary Key da tabela Clientes';

COMMENT ON COLUMN lojas.clientes.email IS              'Email do Cliente, capacidade de 255 ';

COMMENT ON COLUMN lojas.clientes.nome IS               'Nome do CLiente, capacidade de 255';

COMMENT ON COLUMN lojas.clientes.telefone1 IS          'Primeiro telefone do Cliente';

COMMENT ON COLUMN lojas.clientes.telefone2 IS          'Segundo telefone do Cliente';

COMMENT ON COLUMN lojas.clientes.telefone3 IS          'Terceiro telefone do Cliente';



                                            --------------------------------------
                                            ----------------ENVIOS----------------
                                            --------------------------------------


--Criar a tabela Envios

CREATE TABLE lojas.envios (
        envio_id            NUMERIC(38)     NOT NULL,
        loja_id             NUMERIC(38)     NOT NULL,
        cliente_id          NUMERIC(38)     NOT NULL,
        endereco_entrega    VARCHAR(512)    NOT NULL,
        status              VARCHAR(15)     NOT NULL
);

--Criar PRIMARY KEY da tabela envios

ALTER TABLE             lojas.envios 
ADD CONSTRAINT          envio_id_pk
PRIMARY KEY             (envio_id);

--Comentario da tabela Envios

COMMENT ON TABLE lojas.envios IS                       'Tabela de Envios dos pedidos com o status, cliente, loja e endereço de entrega do envio';

--Comentario das colunas da tabela Envios

COMMENT ON COLUMN lojas.envios.envio_id IS             'Primary Key da tabela de Envios';

COMMENT ON COLUMN lojas.envios.loja_id IS              'Foreign Key da Tabela Lojas Relacionamento: ';

COMMENT ON COLUMN lojas.envios.cliente_id IS           'Foreign Key da tabela Clientes';

COMMENT ON COLUMN lojas.envios.endereco_entrega IS     'Endereço de Entrega , podendo conter: Rua, Bairro, Cidade, Estado e CEP.';

COMMENT ON COLUMN lojas.envios.status IS               'Situação do Envio opções (CRIADO , ENVIADO, TRANSITO, ENTREGUE)';





                                            --------------------------------------
                                            ----------------PEDIDOS---------------
                                            --------------------------------------


--Criar a tabela Pedidos

CREATE TABLE lojas.pedidos (
        pedido_id       NUMERIC(38)     NOT NULL,
        data_hora       TIMESTAMP       NOT NULL,
        cliente_id      NUMERIC(38)     NOT NULL,
        status          VARCHAR(15)     NOT NULL,
        loja_id         NUMERIC(38)     NOT NULL
);

--Criar Primary Key da tabela pedidos

ALTER TABLE             lojas.pedidos
ADD CONSTRAINT          pedido_id_pk
PRIMARY KEY             (pedido_id);

--Comentari da Tabela Pedidos

COMMENT ON TABLE lojas.pedidos IS                   'Tabela de pedidos com os dados de Data e Hora, Status do pedido e as FKs da tabela Pedidos, Clientes e Lojas';

--Comentarios das Colunas da tabela Pedidos

COMMENT ON COLUMN lojas.pedidos.pedido_id IS       'Primary Key da tabela pedidos';

COMMENT ON COLUMN lojas.pedidos.data_hora IS       'Data e Hora do momento em que foi feito o pedido, considerando o lançamento no banco de dados';

COMMENT ON COLUMN lojas.pedidos.cliente_id IS      'Foreign Key da tabela Clientes.';

COMMENT ON COLUMN lojas.pedidos.status IS          'Status do pedido opções (CANCELADO , COMPLETO, ABERTO, PAGO, REEMBOLSADO, ENVIADO)';

COMMENT ON COLUMN lojas.pedidos.loja_id IS         'Foreign Key da tabela Lojas.';



                                            --------------------------------------
                                            ----------ITENS DO PEDIDO-------------
                                            --------------------------------------


--Criar a tabela pedidos_itens

CREATE TABLE lojas.pedidos_itens (
        produto_id          NUMERIC(38)     NOT NULL,
        pedido_id           NUMERIC(38)     NOT NULL,
        numero_da_linha     NUMERIC(38)     NOT NULL,
        preco_unitario      NUMERIC(10,2)   NOT NULL,
        quantidade          NUMERIC(38)     NOT NULL,
        envio_id            NUMERIC(38)     NOT NULL
);

--Criar Primary Key da tabela pedidos_itens (composta)

ALTER TABLE ONLY lojas.pedidos_itens 
ADD CONSTRAINT pedido_id_produto_id_pk
PRIMARY KEY (produto_id, pedido_id);

--Comentario da tabela pedidos_itens

COMMENT ON TABLE lojas.pedidos_itens IS                    'Tabela de itens do pedido, aonde a PK é formada a partir de duas FK';

--Comentario da colunas da tabela pedidos_itens

COMMENT ON COLUMN lojas.pedidos_itens.produto_id IS        'Foreign Key da tabela Produtos que faz parte da Primary KEY da tabela pedidos_itens';

COMMENT ON COLUMN lojas.pedidos_itens.pedido_id IS         'Foreign Key da tabela Pedidos que faz parte da Primary KEY da tabela pedidos_itens';

COMMENT ON COLUMN lojas.pedidos_itens.numero_da_linha IS   'Numero da Linha';

COMMENT ON COLUMN lojas.pedidos_itens.preco_unitario IS    'Preco Unitario de cada Item dentro do Pedido';

COMMENT ON COLUMN lojas.pedidos_itens.quantidade IS        'Quantidade de cada produto dentro de cada Item';

COMMENT ON COLUMN lojas.pedidos_itens.envio_id IS          'Primary Key da tabela de Envios';




                                            --------------------------------------
                                            --------------CHECKOUT'S--------------
                                            --------------------------------------

--Restrição para preco unitário nao ser negativo (de todas as tabelas que possuem preco unitario)

        ---Na tabela PRODUTOS
ALTER TABLE lojas.produtos
ADD  CONSTRAINT cc_produtos_preco_unitario
CHECK (preco_unitario >= 0);

        --Na tabela ESTOQUES

ALTER TABLE lojas.pedidos_itens
ADD CONSTRAINT cc_pedidos_itens_preco_unitario
CHECK (preco_unitario >= 0);


--Restrição para que a quantidade do estoque não seja negativo

ALTER TABLE lojas.estoques
ADD CONSTRAINT cc_estoques_quantidade
CHECK (quantidade >= 0);



--Restricao para que o endreço WEB e o endereço fisíco não sejam os dois ao mesmo tempo nulos
-- , ou seja, somente um pode ser nulo

ALTER TABLE lojas.lojas
ADD CONSTRAINT cc_lojas_endereco
CHECK (endereco_fisico IS NOT NULL OR endereco_web IS NOT NULL);


--RESTRICAO DE STATUS

    --PEDIDOS

ALTER TABLE lojas.pedidos
ADD CONSTRAINT cc_pedidos_status
CHECK (status in ('CANCELADO' , 'COMPLETO', 'ABERTO', 'PAGO', 'REEMBOLSADO', 'ENVIADO'));

    --ENVIOS

ALTER TABLE lojas.envios
ADD CONSTRAINT cc_envios_status
CHECK (status in ('CRIADO' , 'ENVIADO', 'TRANSITO', 'ENTREGUE'));


--Restrição na Latitude e Longitude 

ALTER TABLE lojas.lojas
ADD CONSTRAINT cc_lojas_latitude
CHECK (latitude BETWEEN -90 AND 90);

ALTER TABLE lojas.lojas
ADD CONSTRAINT cc_lojas_longitude
CHECK (longitude BETWEEN -180 AND 180);


--Verifica se a coluna email da tabela clientes contém um @

ALTER TABLE lojas.clientes
ADD CONSTRAINT cc_clientes_email
CHECK (email LIKE '%@%');




                                            --------------------------------------
                                            -----------FOREIGN'S KEY'S------------
                                            --------------------------------------

--OBS:
        --    Estou usando o NOT DEFERRABLE para restringir ocasionais erros de relacionamento
        --    O comentário do relacionamento de FOREIGN KEY se le "a tabela X tem a PK da tabela Y"



-- PEDIDOS_ITENS FK --> PRODUTOS PK

ALTER TABLE         lojas.pedidos_itens 
ADD CONSTRAINT      produtos_pedidos_itens_fk
FOREIGN KEY         (produto_id)
REFERENCES          lojas.produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- PEDIDOS_ITENS FK --> PEDIDOS PK

ALTER TABLE         lojas.pedidos_itens 
ADD CONSTRAINT      pedidos_pedidos_itens_fk
FOREIGN KEY         (pedido_id)
REFERENCES          lojas.pedidos (pedido_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- ESTOQUES FK --> PRODUTOS PK 

ALTER TABLE         lojas.estoques 
ADD CONSTRAINT      produtos_estoques_fk
FOREIGN KEY         (produto_id)
REFERENCES          lojas.produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- PEDIDOS FK --> LOJAS PK

ALTER TABLE         lojas.pedidos 
ADD CONSTRAINT      lojas_pedidos_fk
FOREIGN KEY         (loja_id)
REFERENCES          lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- ENVIOS FK --> LOJAS PK

ALTER TABLE         lojas.envios 
ADD CONSTRAINT      lojas_envios_fk
FOREIGN KEY         (loja_id)
REFERENCES          lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- ESOTQUES FK --> LOJAS PK

ALTER TABLE         lojas.estoques 
ADD CONSTRAINT      lojas_estoques_fk
FOREIGN KEY         (loja_id)
REFERENCES          lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- PEDIDOS FK --> CLIENTES PK

ALTER TABLE         lojas.pedidos 
ADD CONSTRAINT      clientes_pedidos_fk
FOREIGN KEY         (cliente_id)
REFERENCES          lojas.clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- ENVIOS FK --> CLIENTES PK

ALTER TABLE         lojas.envios 
ADD CONSTRAINT      clientes_envios_fk
FOREIGN KEY         (cliente_id)
REFERENCES          lojas.clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- PEDIDOS_ITENS FK --> ENVIOS PK

ALTER TABLE         lojas.pedidos_itens 
ADD CONSTRAINT      envios_pedidos_itens_fk
FOREIGN KEY         (envio_id)
REFERENCES          lojas.envios (envio_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

