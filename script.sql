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