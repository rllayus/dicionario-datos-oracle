--Diccionario Datos (ORACLE) (modificar t.owner con el esquema que corresponda)
SELECT UC.table_name, UC.column_name, UC.data_type||
                                      CASE
                                          WHEN data_type='TIMESTAMP(6)' THEN ''
                                          WHEN data_precision is not null AND nvl(data_scale,0)>0 THEN '('||data_precision||','||data_scale||')'
                                          WHEN data_precision is not null AND nvl(data_scale,0)=0 THEN '('||data_precision||')'
                                          WHEN data_precision is null AND data_scale is not null THEN '(*,'||data_scale||')'
                                          WHEN char_length>0 THEN '('||char_length|| case char_used
                                                                                         when 'B' then ' Byte'
                                                                                         when 'C' then ' Char'
                                                                                         else null
                                              end||')'
                                          END||decode(nullable, 'N', ' NOT NULL') as data_type
     , U.COMMENTS
FROM USER_TAB_COLUMNS UC
         LEFT JOIN user_col_comments U  ON (UC.TABLE_NAME = U.TABLE_NAME AND UC.COLUMN_NAME = U.COLUMN_NAME)
WHERE UC.table_name IN (SELECT t.table_name FROM dba_tables t WHERE t.owner = 'DBCLICFE')
  AND UC.table_name NOT LIKE 'REP_%' AND UC.table_name NOT LIKE 'VW_%' AND UC.table_name NOT LIKE 'VIEW_%'
ORDER BY UC.table_name ASC,
         case when column_name = 'ID' then 1
              when (column_name = 'USUARIO_REGISTRO' OR column_name = 'CREATEDBY' OR column_name = 'CREATED_BY') then 2
              when (column_name = 'FECHA_REGISTRO' OR column_name = 'CREATEDDATE' OR column_name = 'CREATED_DATE') then 3
              when (column_name = 'USUARIO_ACTUALIZACION' OR column_name = 'MODIFIEDBY' OR column_name = 'LAST_MODIFIED_BY') then 4
              when (column_name = 'FECHA_ACTUALIZACION' OR column_name = 'MODIFIEDDATE' OR column_name = 'LAST_MODIFIED_DATE') then 5
              when (column_name = 'ESTADO') then 6
              when (column_name = 'VERSION') then 7
              else 8
             end,
         UC.column_name ASC;
