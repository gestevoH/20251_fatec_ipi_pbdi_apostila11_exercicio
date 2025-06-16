-- 1.1 Adicione uma tabela de log ao sistema do restaurante. Ajuste cada procedimento para
-- que ele registre
-- - a data em que a operação aconteceu
-- - o nome do procedimento executado
CREATE TABLE tb_log_operacao(
    cod_log SERIAL PRIMARY KEY,
    data_operacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    nome_procedimento VARCHAR(200) NOT NULL
);