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