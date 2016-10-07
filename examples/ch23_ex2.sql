 -- Listing hoex1.sql
variable t_id1 char(9);
execute :t_id1 := '01-JAN-98';
variable t_id2 char(9);
execute :t_id2 := '31-JAN-98';
variable pname1 varchar2(50);
execute :pname1 := '5MP Telephoto Digital Camera';
variable pname2 varchar2(50);
execute :pname2 := '17" LCD w/built-in HDTV Tuner';
variable pname3 varchar2(50);
execute :pname3 := 'Envoy 256MB - 40GB';
variable pname4 varchar2(50);
execute :pname4 := 'Y Box';
variable pname5 varchar2(50);
execute :pname5 := 'Mini DV Camcorder with 3.5" Swivel LCD';
ALTER SESSION SET EVENTS '10046 trace name context forever, level 4';
SELECT time_id, channel_id, prod_id, ROUND (SUM(amount_sold)) AS TOTAL FROM SALES WHERE time_id BETWEEN TO_DATE(:t_id1) AND TO_DATE(:t_id2) AND prod_id IN (SELECT prod_id FROM products WHERE prod_name IN (:pname1,:pname2,:pname3,:pname4,:pname5)) GROUP BY ROLLUP (time_id, (channel_id, prod_id));
ALTER SESSION SET EVENTS '10046 trace name context off';

