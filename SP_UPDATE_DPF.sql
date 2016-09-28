-- USAGE - create: db2 -td@ -vf /innova/isis/Scripts/SP_UPDATE_DPF.sql
-- USAGE - call: db2 "call UPDATE_DPF(90,300,10000)"

drop PROCEDURE UPDATE_DPF@

CREATE PROCEDURE UPDATE_DPF(IN PLAZO_I INTEGER, IN MONTO_I FLOAT,IN MONTO_F FLOAT )
LANGUAGE SQL
BEGIN
    declare v_CNT_BLOCK     bigint;

    set v_CNT_BLOCK   = 0;

    FOR r_cur as c_cur cursor with hold for
        SELECT INTERES_ID FROM INTERES_AHORRO_DPF 
        WHERE PLAZO_DESDE= PLAZO_I AND MONTO_DESDE >= MONTO_I AND  MONTO_DESDE <= MONTO_F
        for read only
    DO
            UPDATE DEPOSITO_PLAZO_FIJO_TMP  SET INTERES_ID=r_cur.INTERES_ID  WHERE PLAZO BETWEEN PLAZO_I AND PLAZO_I + 5 AND MONTO BETWEEN MONTO_I AND MONTO_F;

            set v_CNT_BLOCK=v_CNT_BLOCK+1;

            if v_CNT_BLOCK >= 5000 then
                set v_CNT_BLOCK = 0;
                commit;
            end if;
    END FOR;

    commit;
END@