#! /bin/bash 

#read  -p "please set the oracle_home environment variable:" orahome
export ORACLE_HOME=/oracle/app/oracle/product/19.0.0/dbhome_1
#export ORACLE_HOME=$orahome
export PATH=$PATH:/oracle/app/oracle/product/19.0.0/dbhome_1/bin
#export PATH=$PATH:$orahome/bin
FOLDER=/home/oracle/automation/postscript_db
ACL=acl.txt
HTTP=http.txt

ACL()
{
for j in MAGNOLIA USAGE
 do
   for i in `cat $FOLDER/$ACL`
    do
     sqlplus -s admuser/housekeeping@$j << !
      declare
      rc sys_refcursor;
      begin
      configure_ftp_acl ('$i', 30550, rc);
      end;
      /
!
   done
 done
}


HTTP()
{
 for i in `cat $FOLDER/$HTTP`
  do
    sqlplus -s foundation/foundation@magnolia << !
     insert into http_dr_source_ip(source_ip, create_dr) values ('$i', 1);
     commit;
!
  done
}




ACL
HTTP

