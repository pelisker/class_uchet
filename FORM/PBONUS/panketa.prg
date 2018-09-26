**************************************************************************
* PANKETA.PRG - ������ � �������� �����������
* �������: 01.03.2011
* ��������� ���������: 08.03.2011
* �����: ����� �.
**************************************************************************

* ������ �������� ��� ������
PUBLIC cValidString
cValidString="abcdefghijklmnopqrstuvwxyz��������������������������������1234567890 '"+'!@#$%^&*()_+�;%:?*()/|\,.[]{}-=-"' 

PUBLIC MySubDir
MySubDir="PBONUS"

* ����� ������������� ����� "�������" ��������� ���������
SET PATH TO MySubDir+"\" ADDITIVE
SET PATH TO MySubDir+"\VCL\" ADDITIVE
SET PATH TO MySubDir+"\ICONS\" ADDITIVE

* ��������� ������ �� ������� ����� ��� ���� ����� �������� � �������
SET PROCEDURE TO MySubDir+"\pbonus_common.prg" ADDITIVE
SET CLASSLIB TO MySubDir+"\VCL\SendEmail" ADDITIVE

* ����� � ���������� ��������
PUBLIC CursorName, CursorTmpName, CursorLockName, CursorUserName, CursorNaprName
CursorName=fCreateCursorName('pa')
CursorTmpName=fCreateCursorName('_pa')
CursorLockName=fCreateCursorName('_lock')
CursorUserName=fCreateCursorName('_user')
CursorNaprName=fCreateCursorName('_napr')

* ��� �����, ��� ������� �����������
PUBLIC NaprFolderCode
NaprFolderCode=2000

* ��� �������� �������
* ������������ ��� ������������� � �������� MyCheckRLOCK, MyRLock, MyRUnLock
* � ��� �������� ����� � pbonus_del.scx 
PUBLIC MainTableName
MainTableName="pbonus_anketa"

* ����� ��������� Grida
PUBLIC pcGridBackRed, pcGridBackGreen, pcGridBackBlue, pcGridBackYellow, pcGridBackWhite
pcGridBackRed	= "RGB(255,190,190)"
pcGridBackGreen = "RGB(190,255,190)"
pcGridBackBlue 	= "RGB(190,190,255)"
pcGridBackYellow= "RGB(255,255,190)"
pcGridBackWhite = "RGB(255,255,255)"

* ��� � ��� �������� ������������
PUBLIC M.CUser_Name, M.CUser_Code
M.CUser_Code=gnuser						&& ���������� ������������� ���� �������� ������������ �� ��, ��� ���������� (����� �������� ...) �������� � ����� ����������
M.CUser_Name=ALLTRIM(SUBSTR(GetUserData(M.CUser_Code,1,.F.),9))

* ������� �� ����� �������� ������������ ��� ��������� � �����
PUBLIC pnFltPri, pnFltOtm, plFltDraft, M.CUser_Co, M.CUser_DZ, M.CUser_ZKD, M.CUser_KD, M.CUser_IT, M.CUser_MN, M.CUser_SAVE, M.CUser_SAVE2, M.CUser_CHUS, M.CUser_ISMM
=GetUserPresets(M.CUser_Code,'������')

*WAIT WINDOW 'pnFltPri='+STR(pnFltPri)+'  pnFltOtm='+STR(pnFltOtm)+'  plFltDraft='+IIF(plFltDraft,'TRUE','FALSE')+'  M.CUser_Co='+IIF(M.CUser_Co,'TRUE','FALSE')


* ������� ��� �������, ���������� � ���������� ������ � �������� �������
PUBLIC sqlSelectStatement, sqlLineSelectStatement, sqlInsertStatement, sqlUpdateStatement, sqlManyDeleteStatement, sqlOneDeleteStatement, sqlUnDeleteStatement

*sqlSelectStatement="SELECT "+MainTableName+".*, password.name AS a_uname, region.name AS napr_name FROM "+MainTableName+" "+;
*				   "LEFT JOIN password ON "+MainTableName+".a_uupcode= password.code "+;
*				   "LEFT JOIN region ON "+MainTableName+".a_nupcode= region.code"

sqlSelectStatement="SELECT "+MainTableName+".*, c1.name AS a_uname, c2.name AS a_lname, c3.name AS a_bname, region.name AS napr_name FROM "+MainTableName+" "+;
				   "LEFT JOIN password AS c1 ON "+MainTableName+".a_uupcode= c1.code "+;
				   "LEFT JOIN password AS c2 ON "+MainTableName+".a_lcode= c2.code "+;
				   "LEFT JOIN password AS c3 ON "+MainTableName+".a_bcode= c3.code "+;
				   "LEFT JOIN region ON "+MainTableName+".a_nupcode= region.code"
				   
sqlLineSelectStatement=sqlSelectStatement+" WHERE "+MainTableName+".code=?m.code"
					 
sqlInsertStatement="INSERT INTO "+MainTableName+" (a_name,a_pupcode,a_aimupcode,a_opisanie,a_addr,a_tel,a_cont,a_isdraft,a_date,a_uupcode,a_nupcode,"+;
											"a_dz,a_dz_yno,a_zkd,a_zkd_yno,a_kd,a_kd_yno,a_it,a_it_yno,a_it_date,"+;
											"a_ulname,a_ulupcode,a_uladdr,a_ulinn,a_ulkpp,a_ulrs,a_ulbank,a_ulks,a_ulbik,"+;
											"a_known,a_tov,a_tm,a_info,a_oborot,a_kl,a_srok,a_ulnonres,a_lcode,a_bcode,a_otlusl,deleted) "+;
			  	   "VALUES(?m.a_name,?m.a_pupcode,?m.a_aimupcode,?m.a_opisanie,?m.a_addr,?m.a_tel,?m.a_cont,?m.a_isdraft,?m.a_date,?m.a_uupcode,?m.a_nupcode,"+;
					 	  "?m.a_dz,?m.a_dz_yno,?m.a_zkd,?m.a_zkd_yno,?m.a_kd,?m.a_kd_yno,?m.a_it,?m.a_it_yno,?m.a_it_date,"+;
					 	  "?m.a_ulname,?m.a_ulupcode,?m.a_uladdr,?m.a_ulinn,?m.a_ulkpp,?m.a_ulrs,?m.a_ulbank,?m.a_ulks,?m.a_ulbik,"+;
					 	  "?m.a_known,?m.a_tov,?m.a_tm,?m.a_info,?m.a_oborot,?m.a_kl,?m.a_srok,?m.a_ulnonres,?m.a_lcode,?m.a_bcode,?m.a_otlusl,?m.deleted)"
		 	  
sqlUpdateStatement="UPDATE "+MainTableName+" "+;
				 "SET a_name=?m.a_name,a_pupcode=?m.a_pupcode,a_aimupcode=?m.a_aimupcode,a_opisanie=?m.a_opisanie,"+;
				 	 "a_addr=?m.a_addr,a_tel=?m.a_tel,a_cont=?m.a_cont,a_isdraft=?m.a_isdraft,a_date=?m.a_date,a_uupcode=?m.a_uupcode,a_nupcode=?m.a_nupcode,"+;
					 "a_dz=?m.a_dz,a_dz_yno=?m.a_dz_yno,a_zkd=?m.a_zkd,a_zkd_yno=?m.a_zkd_yno,a_kd=?m.a_kd,a_kd_yno=?m.a_kd_yno,"+;
					 "a_it=?m.a_it,a_it_yno=?m.a_it_yno,a_it_date=?m.a_it_date,"+;
					 "a_ulname=?m.a_ulname,a_ulupcode=?m.a_ulupcode,a_uladdr=?m.a_uladdr,a_ulinn=?m.a_ulinn,a_ulkpp=?m.a_ulkpp,"+;
					 "a_ulrs=?m.a_ulrs,a_ulbank=?m.a_ulbank,a_ulks=?m.a_ulks,a_ulbik=?m.a_ulbik,"+;
					 "a_known=?m.a_known,a_tov=?m.a_tov,a_tm=?m.a_tm,a_info=?m.a_info,a_oborot=?m.a_oborot,a_kl=?m.a_kl,a_srok=?m.a_srok,"+;
					 "a_ulnonres=?m.a_ulnonres, a_lcode=?m.a_lcode, a_bcode=?m.a_bcode, a_otlusl=?m.a_otlusl "+;
				 "WHERE code=?m.code"
					 	  
sqlManyDeleteStatement="UPDATE "+MainTableName+" SET DELETED=1"

sqlOneDeleteStatement=sqlManyDeleteStatement+" WHERE code=?m.code"

sqlUnDeleteStatement="UPDATE "+MainTableName+" SET DELETED=0 WHERE code=?m.code"
				 

**** �������� ���� ��� ���������� *********************************
*=RunSQL("ALTER TABLE pbonus_anketa ALTER COLUMN a_kl FLOAT ", CursorName)
*=RunSQL("ALTER TABLE pbonus_anketa ADD a_otlusl CHAR(250) NULL", CursorName)
*=RunSQL("ALTER TABLE pbonus_anketa ADD a_info    TEXT NULL", CursorName)
*=RunSQL("ALTER TABLE pbonus_anketa ADD a_oborot FLOAT NULL", CursorName)
*=RunSQL("ALTER TABLE pbonus_anketa ADD a_srok	  INT NULL", CursorName)
*aa=''
*=RunSQL("UPDATE pbonus_anketa SET a_ulnonres=?aa", CursorName)
*=RunSQL("UPDATE pbonus_anketa SET a_tov=?aa", CursorName)
*=RunSQL("UPDATE pbonus_anketa SET a_tm=?aa", CursorName)
*=RunSQL("UPDATE pbonus_anketa SET a_info=?aa", CursorName)

*=RunSQL("SELECT * FROM pbonus_anketa", CursorName)
*DISPLAY STRUCTURE
*BROWSE
*USE
*RETURN
*******************************************************************

* �������� ����� �� ������
pnUserCheck=0
pnUserCheck=CheckPBonusUser(M.CUser_Code,'PAnketa')
IF  pnUserCheck = 1
	DO FORM PA_LST.scx 	&& ������� �������� �����
ELSE
	WAIT WINDOW '� ��� ��� ������� � ������ ������!'	
ENDIF	

RELEASE cValidString
RELEASE MySubDir
RELEASE CursorName, CursorTmpName, CursorLockName, CursorUserName, CursorNaprName
RELEASE NaprFolderCode
RELEASE MainTableName
RELEASE pcGridBackRed, pcGridBackGreen, pcGridBackBlue, pcGridBackYellow, pcGridBackWhite
RELEASE M.CUser_Name, M.CUser_Code
RELEASE pnFltPri, pnFltOtm, plFltDraft, M.CUser_Co, M.CUser_DZ, M.CUser_ZKD, M.CUser_KD, M.CUser_IT, M.CUser_MN, M.CUser_SAVE, M.CUser_SAVE2, M.CUser_CHUS
RELEASE sqlSelectStatement, sqlLineSelectStatement, sqlInsertStatement, sqlUpdateStatement, sqlManyDeleteStatement, sqlOneDeleteStatement, sqlUnDeleteStatement



