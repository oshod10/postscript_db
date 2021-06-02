CREATE OR REPLACE PROCEDURE FOUNDATION.SP_POST_DB_SCRIPT (iDB IN VARCHAR2 :=null, iDM01 IN VARCHAR2 := null, iDM02 IN VARCHAR2 := null,
   iDM03 IN VARCHAR2 := null,
   iDM04 IN VARCHAR2 :=  null,
   iOC01 IN VARCHAR2 :=  null,
   iOC02 IN VARCHAR2 :=  null,
   iOC03 IN VARCHAR2 :=  null,
   iOC04 IN VARCHAR2 :=  null,
   iDMSW IN VARCHAR2 :=  null,
   iSSRS IN VARCHAR2 :=  null,
   iWD IN VARCHAR :=  null)
   
AS
   vold_DB_val   VARCHAR (50);
   vDMSA         VARCHAR (20);
   vDMSB         VARCHAR (20);      
   vDMSC         VARCHAR (20);
   vDMSD         VARCHAR (20);
   vOCSA         VARCHAR (20);
   vOCSB         VARCHAR (20);
   vOCSC         VARCHAR (20);
   vOCSD         VARCHAR (20);
   vDMSW         VARCHAR (20);
   vcount        NUMBER;
   vmax          NUMBER;
   vSSRS         VARCHAR (20);
   vWD           VARCHAR (20);
   vEnv          NUMBER;
   vExtern       NUMBER;
   
BEGIN
 

/* Update EV */

select param_value_1 into vEnv from params where param_name like 'CurrentEnv%';

update EXTERN_VALUES_PER_ENV
set extern_values_value = '/amdocs-addresslookup'
where EXTERN_VALUES_ID in  (select EXTERN_VALUES_ID from extern_values  where
object_id in (5)
and
extern_values_group_members_id in (select extern_values_group_members_id from EXTERN_VALUES_GROUP_MEMBERS
where extern_value_names_id in (select extern_value_names_id from EXTERN_VALUE_NAMES where extern_value_names_name like '%Remote System URL%')))and env_number = vEnv;
if sql%rowcount > 0 
then 
dbms_output.put_line ('EV for Capita_remote_system_params, custom_type 5 has been updated!');
else 
dbms_output.put_line ('EV for Capita_remote_system_params, custom_type 5 could not be updated!');
end if;

update EXTERN_VALUES_PER_ENV
set extern_values_value = '/amdocs-zonechecker'
where EXTERN_VALUES_ID in  (select EXTERN_VALUES_ID from extern_values  where
object_id in (4)
and
extern_values_group_members_id in (select extern_values_group_members_id from EXTERN_VALUES_GROUP_MEMBERS
where extern_value_names_id in (select extern_value_names_id from EXTERN_VALUE_NAMES where extern_value_names_name like '%Remote System URL%')))and env_number = vEnv;
if sql%rowcount > 0 
then 
dbms_output.put_line ('EV for Capita_remote_system_params, custom_type 4 has been updated!');
else 
dbms_output.put_line ('EV for Capita_remote_system_params, custom_type 4 could not be updated!');
end if;

select EXTERN_VALUES_ID into vExtern from extern_values where
object_id in (7)
and extern_values_group_members_id in 
(select extern_values_group_members_id from EXTERN_VALUES_GROUP_MEMBERS
where extern_value_names_id in (select extern_value_names_id from EXTERN_VALUE_NAMES where extern_value_names_name like '%Remote System URL%'));

update EXTERN_VALUES_PER_ENV
set extern_values_value = '/Capita.TfL.SMS.SendSMSToSingleRecipient/SendSMSToSingleRecipientService.svc'
where EXTERN_VALUES_ID = vExtern and env_number = vEnv;
if sql%rowcount = 0 
then 
insert into EXTERN_VALUES_PER_ENV (env_number, extern_values_id, extern_values_value)values (vEnv, vExtern, '/Capita.TfL.SMS.SendSMSToSingleRecipient/SendSMSToSingleRecipientService.svc') ;
dbms_output.put_line ('EV for Capita_remote_system_params, custom_type 7 has been updated!');
end if;


   /* Update servers table records */

   SELECT server_IP INTO vold_db_val FROM servers WHERE server_name LIKE 'OracleDB';

   IF vold_db_val <> iDB
   THEN
      UPDATE servers
         SET server_ip = iDB
       WHERE server_name LIKE '%DB';

      DBMS_OUTPUT.put_line ('Number of DB records updated: '|| SQL%ROWCOUNT);
   ELSE
      DBMS_OUTPUT.put_line ('No updates done to DB server records!');
   END IF;


   SELECT server_ip INTO vDMSA FROM servers WHERE server_name = 'DMS-A';

   IF vDMSA <> iDM01
   THEN
      UPDATE servers
         SET server_ip = iDM01
       WHERE server_ip = vDMSA;
      

      DBMS_OUTPUT.put_line ('Number of DMS01 records updated: '|| SQL%ROWCOUNT);
   ELSE
      DBMS_OUTPUT.put_line ('No updates done to DMS01 server records!');
   END IF;
   
   IF iDM01 is not null
   then
   update params 
   set param_value_1 = iDM01, param_value_2 = iDM02 
   where param_family = 'AR'
   and param_name like 'FtpConnectionDeta%';
   if sql%rowcount > 0 
   then 
   DBMS_output.put_line ('Param for AR family updated to use new DMS server!');
   else 
   dbms_output.put_line('Param for AR family could not be updated!');
   end if;
   END IF;

   IF iDM02 is not null 
   THEN
   SELECT server_ip INTO vDMSB FROM servers WHERE server_name = 'DMS-B';
   IF vDMSB <> iDM02
   THEN
      UPDATE servers
         SET server_ip = iDM02
       WHERE server_ip = vDMSB;

      DBMS_OUTPUT.put_line ('Number of DMS02 records updated:'|| SQL%ROWCOUNT);
   ELSE
      DBMS_OUTPUT.put_line ('No updates done to DMS02 server records!');
   END IF;
   END IF;

  IF iDM03 is not null
  THEN 
  SELECT server_ip INTO vDMSC FROM servers WHERE server_name = 'DMS-C';
   IF vDMSC <> iDM03
   THEN
      UPDATE servers
         SET server_ip = iDM03
       WHERE server_ip = vDMSC;

      DBMS_OUTPUT.put_line ('Number of DMS03 records updated:'|| SQL%ROWCOUNT);
   ELSE
      DBMS_OUTPUT.put_line ('No updates done to DMS03 server records!');
   END IF;
   END IF;

   
   IF iDM04 is not null 
   THEN
   SELECT server_ip INTO vDMSD FROM servers WHERE server_name = 'DMS-D';
   IF vDMSD <> iDM04
   THEN
      UPDATE servers
         SET server_ip = iDM04
       WHERE server_ip = vDMSD;

      DBMS_OUTPUT.put_line ('Number of DMS04 records updated:'|| SQL%ROWCOUNT);
   ELSE
      DBMS_OUTPUT.put_line ('No updates done to DMS04 server records!');
   END IF;
   END IF;

   
   SELECT server_ip INTO vOCSA FROM servers WHERE server_name = 'OCS-1A';

   IF vOCSA <> iOC01
   THEN
      UPDATE servers
         SET server_ip = iOC01
       WHERE server_ip = vOCSA;

      DBMS_OUTPUT.put_line ('Number of OCS01 records updated:'|| SQL%ROWCOUNT);
   ELSE
      DBMS_OUTPUT.put_line ('No updates done to OCS01 server records!');
   END IF;


   IF iOC02 is not null
   THEN
   SELECT server_ip INTO vOCSB FROM servers WHERE server_name = 'OCS-1B';

   IF vOCSB <> iOC02
   THEN
      UPDATE servers
         SET server_ip = iOC02
       WHERE server_ip = vOCSB;

      DBMS_OUTPUT.put_line ('Number of OCS02 records updated:'|| SQL%ROWCOUNT);
   ELSE
      DBMS_OUTPUT.put_line ('No updates done to OCS02 server records!');
   END IF;
   END IF;
   
   
   IF iOC03 is not null
   THEN 
   SELECT server_ip INTO vOCSC FROM servers WHERE server_name = 'OCS-3A';
   IF vOCSC <> iOC03
   THEN
      UPDATE servers
         SET server_ip = iOC03
       WHERE server_ip = vOCSC;

      DBMS_OUTPUT.put_line ('Number of OCS03 records updated:'|| SQL%ROWCOUNT);
   ELSE
      DBMS_OUTPUT.put_line ('No updates done to OCS03 server records!');
   END IF;
   END IF;
   
    
   IF iOC04 is not null
   THEN
   SELECT server_ip INTO vOCSD FROM servers WHERE server_name = 'OCS-3B';
   IF vOCSD <> iOC04
   THEN
      UPDATE servers
         SET server_ip = iOC04
       WHERE server_ip = vOCSD;

      DBMS_OUTPUT.put_line ('Number of OCS04 records updated:'|| SQL%ROWCOUNT);
   ELSE
      DBMS_OUTPUT.put_line ('No updates done to OCS04 server records!');
   END IF;
   END IF;

   
   IF iDMSW is not null
   THEN
   SELECT server_ip INTO vDMSW FROM servers WHERE server_name = 'DMS-W';
   IF vDMSW <> iDMSW
   THEN
      UPDATE servers
         SET server_ip = iDMSW
       WHERE server_ip = vDMSW;

      DBMS_OUTPUT.put_line ('DMSW record updated!');
   ELSE
      DBMS_OUTPUT.put_line ('No updates done to DMSW server!');
   END IF;
   END iF;
   
 IF iWD is not null
   THEN
   SELECT server_ip INTO vWD FROM servers WHERE server_name = 'Watchdog';
   IF vWD <> iWD
   THEN
      UPDATE servers
         SET server_ip = iWD
       WHERE server_ip = vWD;
   END IF;
   END iF;
   /*update params for ODBC family*/

   SELECT param_value_1 INTO vold_DB_val FROM params WHERE param_family = 'ODBC'
    AND param_name = 'ODBCOracleServerName'  AND ROWNUM <= 1;
    
    if vold_DB_val <> iDB
    then 
       UPDATE params
       SET param_value_1 =  REPLACE (REPLACE (param_value_1, vold_DB_val, iDB),'SID','SERVCIE_NAME')
       WHERE param_family LIKE 'ODBC'
       AND (param_name LIKE 'ODBCOracleServerName' OR param_name LIKE 'ODBCOracleProvider') and cluster_id iS not null;
       if sql%rowcount > 0 
       then
    DBMS_OUTPUT.put_line('ODBC params updated to use new DB server and service name instead of SID.');
       else 
    DBMS_OUTPUT.put_line('ODBC params could not be updated!');
    end if; 
    
    DBMS_OUTPUT.put_line('No changes made to ODBC params family!');
   end if;
   
   
   /* Update usage.dr_ftp_sources, make sure that grant update/insert on usage.dr_ftp_sources exists to foundation
    from admuser@magnolia, grant update on usage.dr_ftp_sources to foundation
    grant insert on usage.dr_ftp_sources to foundation */

   vcount := 0;

   SELECT COUNT (*) INTO vcount FROM usage.dr_ftp_sources;

   SELECT MAX (server_id) INTO vmax FROM usage.dr_ftp_sources;

   IF  iDM02 is null and vcount = 2  /* data is copied from full scale to reduced scale assuming that iDM01 cannot be null */
   THEN
      UPDATE usage.dr_ftp_sources
       SET server_name = iDM01
       WHERE server_id < vmax;
      delete from usage.dr_ftp_sources where server_id = vmax;   
   
   ELSIF iDM02 is not null and vcount = 1  /* data is copied from reduced scale to full scale */
   THEN
      vmax := vmax + 1;
      INSERT INTO usage.dr_ftp_sources (server_id, server_name, use_ftp, description) VALUES (vmax, iDM02, 0, 'ftp');
      UPDATE usage.dr_ftp_sources
      SET server_name = iDM01
      WHERE server_id < vmax;
	   
   ELSIF vcount = 1 and iDM02 is null /* data is copied from reduced scale to reduced scale */
   then 
      UPDATE usage.dr_ftp_sources
      SET server_name = iDM01
      WHERE server_id = vmax;
   
   ELSIF iDM02 is not null and vcount = 2  /* data is copied from full scale to full scale */
   THEN
      update usage.dr_ftp_sources 
	  set server_name = iDM01 where server_id < vmax;
	  update usage.dr_ftp_sources 
	  set server_name = iDM02 where server_id = vmax;
   dbms_output.put_line ('values changed in usage.DR_FTP_SOURCES!');
   END IF;
      
   
   UPDATE usage.dr_ftp_sources
   SET local_mount_dir = '/oracle/data/exportcdr', use_ftp = 0, port = NULL, username = NULL, password = NULL;
   
  
 
   /* update dr_ftp_sources@usage*/




   If iDM01 is not null 
   then 
   
      MERGE INTO dr_ftp_sources@usage_link a
           USING usage.dr_ftp_sources b
              ON (a.server_id = b.server_id)
      WHEN MATCHED
      THEN
         UPDATE SET a.server_name = b.server_name, a.local_mount_dir = b.local_mount_dir,
                    port = NULL, username = NULL, password = NULL, use_ftp = 0
      WHEN NOT MATCHED
      THEN
         INSERT     (server_id, server_name, description, port, username, password, local_mount_dir, use_ftp)
             VALUES (vmax, iDM02,'ftp', NULL, NULL, NULL, '/oracle/data/exportcdr', 0);

      IF SQL%ROWCOUNT <> 0
      THEN
         DBMS_OUTPUT.put_line ('Changes made to the DR_FTP_SOURCES@usage!');
         else 
     DBMS_OUTPUT.put_line('No changes made to DR_FTP_SOURCES@usage!');
    
      END IF;
    
   delete from dr_ftp_sources@usage_link where server_id not in (select server_id from usage.dr_ftp_sources);
     
/* revoke the grants on usage.dr_ftp_sources
 from admuse@magnolia,revoke update on usage.dr_ftp_sources from foundation
 revoke insert on usage.dr_ftp_sources from foundation */
    END IF;
    
    
    /* update dr_sync_sources on usage@magnolia and usage@usage */
    
    
vcount:=0;
select server_name into vold_DB_val from usage.dr_sync_sources;
if vold_DB_val <> iDB
then
update usage.dr_sync_sources
set server_name = iDB;
DBMS_OUTPUT.put_line('DB server updated in usage.dr_sync_sources.');
else
DBMS_OUTPUT.put_line('No record updated in usage.dr_sync_sources!');
end if;

 
   select server_name into vold_DB_val from dr_sync_sources@usage_link;
    if vold_DB_val <> iDB 
     then
     update dr_sync_sources@usage_link
     set server_name = iDB;
     dbms_output.put_line('DB server updated in dr_sync_sources@usage.');
   else 
     dbms_output.put_line('No record updated in dr_sync_sources@usage!');
   end if;
   
  select NET_ELEM_SERVER_IP into vSSRS from PROV_NETWORK_ELEMENT_PRIORITY
  where NET_ELEM_ID in ( select NET_ELEM_ID from PROV_NETWORK_ELEMENTS where NET_ELEM_NAME = 'SSRS');
  

  
  vcount:=0;
  
  if iDM01 is not null
  then
  update PROV_NETWORK_ELEMENT_PRIORITY
  SET NET_ELEM_SERVER_IP = iDM01 where NET_ELEM_SERVER_IP = vDMSA;
  vcount:=vcount+sql%rowcount;
  end if;
  
  if iDM02 is not null
  then
  update PROV_NETWORK_ELEMENT_PRIORITY
  SET NET_ELEM_SERVER_IP = iDM02 where NET_ELEM_SERVER_IP = vDMSB;
  vcount:=vcount+sql%rowcount;
  end if;
  
  if iDM03 is not null
  then
  update PROV_NETWORK_ELEMENT_PRIORITY
  SET NET_ELEM_SERVER_IP = iDM03 where NET_ELEM_SERVER_IP = vDMSC;
  vcount:=vcount+sql%rowcount;
  end if;
  
  if iDM04 is not null
  then
  update PROV_NETWORK_ELEMENT_PRIORITY
  SET NET_ELEM_SERVER_IP = iDM04 where NET_ELEM_SERVER_IP = vDMSD;
  vcount:=vcount+sql%rowcount;
  end if;
  
  if iOC01 is not null
  then
  update PROV_NETWORK_ELEMENT_PRIORITY
  SET NET_ELEM_SERVER_IP = iOC01 where NET_ELEM_SERVER_IP = vOCSA;
  vcount:=vcount+sql%rowcount;
  end if;   
  
  if iOC02 is not null
  then
  update PROV_NETWORK_ELEMENT_PRIORITY
  SET NET_ELEM_SERVER_IP = iOC02 where NET_ELEM_SERVER_IP = vOCSB;
  vcount:=vcount+sql%rowcount;
  end if;   
  
  if iOC03 is not null
  then
  update PROV_NETWORK_ELEMENT_PRIORITY
  SET NET_ELEM_SERVER_IP = iOC03 where NET_ELEM_SERVER_IP = vOCSC;
  vcount:=vcount+sql%rowcount;
  end if; 
  
  if iOC04 is not null
  then
  update PROV_NETWORK_ELEMENT_PRIORITY
  SET NET_ELEM_SERVER_IP = iOC04 where NET_ELEM_SERVER_IP = vOCSD;
  vcount:=vcount+sql%rowcount;
  end if;
  
  if iSSRS is not null
  then
  update PROV_NETWORK_ELEMENT_PRIORITY
  SET NET_ELEM_SERVER_IP = iSSRS where NET_ELEM_SERVER_IP = vSSRS;
  vcount:=vcount+sql%rowcount;
  end if;
  
     
  dbms_output.put_line('Number of NE rows updated: '|| vcount);

COMMIT;
END;
/
