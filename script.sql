-- 1.1 Adicione uma tabela de log ao sistema do restaurante. Ajuste cada procedimento para
-- que ele registre
-- - a data em que a operação aconteceu
-- - o nome do procedimento executado
CREATE TABLE tb_log_operacao(
    cod_log SERIAL PRIMARY KEY,
    data_operacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    nome_procedimento VARCHAR(200) NOT NULL
);
-----------------------------------------------------------------------------------------------------------------------------------
-- 1.2 Adicione um procedimento ao sistema do restaurante. Ele deve
-- - receber um parâmetro de entrada (IN) que representa o código de um cliente
-- - exibir, com RAISE NOTICE, o total de pedidos que o cliente tem
CREATE OR REPLACE PROCEDURE sp_exibir_total_pedidos_cliente(IN p_cod_cliente INT)
LANGUAGE plpgsql
AS $$
DECLARE
    v_total_pedidos INT;
BEGIN
    SELECT COUNT(*) FROM tb_pedido
    WHERE cod_cliente = p_cod_cliente
    INTO v_total_pedidos;
    RAISE NOTICE "O cliente % tem % pedidos", p_cod_cliente, v_total_pedidos
    INSERT INTO tb_log_operacao (nome_procedimento) VALUES ('sp_exibir_total_pedidos_cliente');
END;
$$
-----------------------------------------------------------------------------------------------------------------------------------
-- 1.3 Reescreva o exercício 1.2 de modo que o total de pedidos seja armazenado em uma
-- variável de saída (OUT).

CREATE OR REPLACE PROCEDURE sp_exibir_total_pedidos_cliente_out(IN p_cod_cliente INT, OUT p_total_pedidos)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT COUNT(*) FROM tb_pedido
    WHERE cod_cliente = p_cod_cliente
    INTO p_total_pedidos;
    RAISE NOTICE "O cliente % tem % pedidos", p_cod_cliente, v_total_pedidos
    INSERT INTO tb_log_operacao (nome_procedimento) VALUES ('sp_exibir_total_pedidos_cliente_out');
END;
$$

-----------------------------------------------------------------------------------------------------------------------------------
-- 1.4 Adicione um procedimento ao sistema do restaurante. Ele deve
-- - Receber um parâmetro de entrada e saída (INOUT)
-- - Na entrada, o parâmetro possui o código de um cliente
-- - Na saída, o parâmetro deve possuir o número total de pedidos realizados pelo cliente
CREATE OR REPLACE PROCEDURE sp_exibir_total_pedidos_cliente_inout(INOUT p_cod_cliente_e_total_pedido)
LANGUAGE plpgsql
AS $$
DECLARE
    v_cod_cliente := p_cod_cliente_e_total_pedido;
BEGIN
    SELECT COUNT(*) FROM tb_pedido
    WHERE cod_cliente = v_cod_cliente
    INTO p_cod_cliente_e_total_pedido;
    INSERT INTO tb_log_operacao (nome_procedimento) VALUES ('sp_exibir_total_pedidos_cliente_inout');
END;
$$

-----------------------------------------------------------------------------------------------------------------------------------
-- 1.5 Adicione um procedimento ao sistema do restaurante. Ele deve
-- - Receber um parâmetro VARIADIC contendo nomes de pessoas
-- - Fazer uma inserção na tabela de clientes para cada nome recebido
-- - Receber um parâmetro de saída que contém o seguinte texto:
-- “Os clientes: Pedro, Ana, João etc foram cadastrados”
-- Evidentemente, o resultado deve conter os nomes que de fato foram enviados por meio do
-- parâmetro VARIADIC.
CREATE OR REPLACE PROCEDURE sp_cadastrar_varios_clientes(OUT p_mensagem_saida VARCHAR(500), VARIADIC p_nomes_clientes TEXT[])
LANGUAGE plpgsql
AS $$
DECLARE
    v_nome_cliente VARCHAR(200);
    v_nomes_cadastrados TEXT := '';
BEGIN
    FOR EACH v_nome_cliente IN ARRAY p_nomes_clientes LOOP
        INSERT INTO tb_cliente (nome) VALUES (v_nome_cliente);
        IF v_nomes_cadastrados = '' THEN
            v_nomes_cadastrados := v_nome_cliente;
        ELSE
            v_nomes_cadastrados := v_nomes_cadastrados || ', ' || v_nome_cliente;
        END IF;
    END LOOP;
    p_mensagem_saida := 'Os clientes: ' || v_nomes_cadastrados || ' foram cadastrados.';
    INSERT INTO tb_log_operacao (nome_procedimento) VALUES ('sp_cadastrar_varios_clientes');
END;
$$
 