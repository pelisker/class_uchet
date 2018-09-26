**************************************************************************
* PBONUS.PRG - ������ � ���������� �������
* �������: 10.02.2011
* ��������� ���������: 19.03.2011
* �����: ����� �.
**************************************************************************

*WAIT WINDOW '���� �� �������'
*RETURN

SET CENTURY ON

* ������ �������� ��� ������
PUBLIC cValidString
cValidString="abcdefghijklmnopqrstuvwxyz��������������������������������1234567890 '"+'!@#$%^&*()_+�;%:?*()/|\,.[]{}-=-"' 

* �������  ����� � �����������
PUBLIC MySubDir
MySubDir="PBONUS"

* ����� ������������� ����� "�������" ��������� ���������
SET PATH TO MySubDir+"\" ADDITIVE
SET PATH TO MySubDir+"\VCL\" ADDITIVE
SET PATH TO MySubDir+"\ICONS\" ADDITIVE

* ��������� ������ �� ������� ����� ��� ���� ����� �������� � �������
SET PROCEDURE TO MySubDir+"\pbonus_common.prg" ADDITIVE
SET CLASSLIB TO MySubDir+"\VCL\SendEmail" ADDITIVE

PUBLIC CursorName, CursorTmpName, CursorLockName
CursorName=fCreateCursorName('pb')
CursorTmpName=fCreateCursorName('_pb')
CursorLockName=fCreateCursorName('_lock')

PUBLIC PostFolderCode, BrandFolderCode, VidFolderCode, TipFolderCode
PostFolderCode 	= 5		&& ��� ����� � ������� ����� ���������� 
BrandFolderCode	= 60	&& ��� ����� � ������� ����� ������ 
VidFolderCode	= 1 	&& ��� ����� � ������� ����� ���� 
*TipFolderCode	= 2 	&& ��� ����� � ������� ����� ���� 
TipFolderCode	= 3 	&& ��� ����� � ������� ����� ������� 

* ��� �������� �������
* ������������ ��� ������������� � �������� MyCheckRLOCK, MyRLock, MyRUnLock
* � ��� �������� ����� � pbonus_del.scx 
PUBLIC MainTableName, ExtTableName
MainTableName="pbonus"
ExtTableName=MainTableName+'_ex'

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
*M.CUser_Name=ALLTRIM(SUBSTR(GetUserData(M.CUser_Code,1,.F.),9))
M.CUser_Name=ALLTRIM(SUBSTR(GetNC(M.CUser_Code,1,.F.,'USER'),9))

* ������� �� ����� �������� ������������ ��� ��������� � �����
PUBLIC M.CUser_SV
=GetUserPresets(M.CUser_Code,'������')

* ������� ��� �������, ���������� � ���������� ������ � �������� �������
PUBLIC sqlSelectStatement, sqlLineSelectStatement, sqlInsertStatement, sqlUpdateStatement, sqlManyDeleteStatement, sqlOneDeleteStatement, sqlUnDeleteStatement

sqlSelectStatement="SELECT "+MainTableName+".*,c1.name AS tip_name,c2.name AS vid_name,password.name AS user_name,pbonus_type.pbt_name,"+;
				   "company.name AS post_name,region.name AS brand_name "+;
				   "FROM "+MainTableName+" "+;
				   "LEFT JOIN password ON "+MainTableName+".pb_avtor=password.code "+;
				   "LEFT JOIN pbonus_type ON "+MainTableName+".pbt_code=pbonus_type.code "+;
				   "LEFT JOIN company ON "+MainTableName+".post_code=company.code "+;
				   "LEFT JOIN complect AS c1 (NOLOCK) ON "+MainTableName+".tip_code=c1.code "+;
				   "LEFT JOIN complect AS c2 (NOLOCK) ON "+MainTableName+".vid_code=c2.code "+;
				   "LEFT JOIN region ON "+MainTableName+".brand_code=region.code "

*				   "LEFT JOIN complect ON "+MainTableName+".vid_code=complect.code "+;
* SELECT pbonus.*, �1.name AS tip_name, c2.name AS vid_name FROM pbonus LEFT JOIN complect as �1 (NOLOCK) ON pbonus.tid_code=c1.code LEFT JOIN complect as �2 (NOLOCK) ON pbonus.vid_code=c2.code  
** ��������� !!! ������ brand_code=
* where upcode=5 or  upcode IN (SELECT code FROM company (NOLOCK) WHERE upcode=5)			
* SELECT np.upcode,ltrim(rtrim(str(complect.code)+':'+complect.name)) vid FROM complect (NOLOCK) LEFT JOIN nomparam np (NOLOCK) on complect.code=np.vid WHERE np.upcode=30387 	 
				   
sqlLineSelectStatement=sqlSelectStatement+" WHERE "+MainTableName+".code=?m.code"

* ���������!					 
sqlInsertStatement="INSERT INTO "+MainTableName+;
						  " (pb_name,pb_date,pb_sdate,pb_edate,pb_ndate,post_code,pbt_code,pb_nds,pb_pors,"+;
						  	"pb_opis,pb_primer,pb_doc,pb_doctxt,pb_contact,pb_nuans,"+;
							"brand_code,pb_avtor,pb_ipi,vid_code,tip_code,pb_sb,pb_scale,pb_edizm,pb_edizms,pb_hands,pb_noozhbn,pb_inprice,deleted) "+;
			  	   "VALUES(?m.pb_name,?m.pb_date,?m.pb_sdate,?m.pb_edate,?m.pb_ndate,?m.post_code,?m.pbt_code,?m.pb_nds,?m.pb_pors,"+;
 					  	  "?m.pb_opis,?m.pb_primer,?m.pb_doc,?m.pb_doctxt,?m.pb_contact,?m.pb_nuans,"+;
			  	   		  "?m.brand_code,?m.pb_avtor,?m.pb_ipi,?m.vid_code,?m.tip_code,?m.pb_sb,?m.pb_scale,?m.pb_edizm,?m.pb_edizms,?m.pb_hands,?m.pb_noozhbn,?m.pb_inprice,?m.deleted)"
		 	  
* ���������!					 
sqlUpdateStatement="UPDATE "+MainTableName+" "+;
				   "SET pb_name=?m.pb_name,pb_date=?m.pb_date,pb_sdate=?m.pb_sdate,pb_edate=?m.pb_edate,pb_ndate=?m.pb_ndate,post_code=?m.post_code,"+;
				 	   "pbt_code=?m.pbt_code,pb_nds=?m.pb_nds,pb_pors=?m.pb_pors,"+;
 				  	   "pb_opis=?m.pb_opis,pb_primer=?m.pb_primer,pb_doc=?m.pb_doc,pb_doctxt=?m.pb_doctxt,pb_contact=?m.pb_contact,pb_nuans=?m.pb_nuans,"+;
				 	   "brand_code=?m.brand_code,pb_avtor=?m.pb_avtor,pb_ipi=?m.pb_ipi,vid_code=?m.vid_code,tip_code=?m.tip_code,pb_sb=?m.pb_sb,pb_scale=?m.pb_scale,"+;
				 	   "pb_edizm=?m.pb_edizm,pb_edizms=?m.pb_edizms,pb_hands=?m.pb_hands,pb_noozhbn=?m.pb_noozhbn,pb_inprice=?m.pb_inprice "+;
				   "WHERE code=?m.code"
			 	  
sqlManyDeleteStatement="UPDATE "+MainTableName+" SET DELETED=1"

sqlOneDeleteStatement=sqlManyDeleteStatement+" WHERE code=?m.code"

sqlUnDeleteStatement="UPDATE "+MainTableName+" SET DELETED=0 WHERE code=?m.code"

sqlKillDeletedStatement="DELETE FROM "+MainTableName+" WHERE DELETED=1"

* ���������� - �������� ����
PUBLIC sqlExSelectStatement,sqlExInsertStatement,sqlExDeleteStatement
PUBLIC CursorExName
CursorExName=fCreateCursorName('_pbe')
sqlExSelectStatement="SELECT * FROM "+ExtTableName+" WHERE upcode=?m.code AND upcode>0 AND DELETED=0"
sqlExInsertStatement="INSERT INTO "+ExtTableName+" (upcode,pbe_name,pbe_usl,pbe_proc,pbe_mcode,deleted) VALUES (?m.code,?m.pbe_name,?m.pbe_usl,?m.pbe_proc,?m.pbe_mcode,0)"

sqlExDeleteStatement="UPDATE "+ExtTableName+" SET DELETED=1 WHERE upcode=?m.code"
sqlExUnDeleteStatement="UPDATE "+ExtTableName+" SET DELETED=0 WHERE upcode=?m.code"
sqlKillExDeletedStatement="DELETE FROM "+ExtTableName+" WHERE DELETED=1"

**** �������� ���� ��� ���������� *********************************
*=RunSQL("ALTER TABLE pbonus_ex DROP COLUMN code AUTOINC", CursorExName)
*=RunSQL("ALTER TABLE pbonus_ex ALTER COLUMN code CHAR", CursorName)

*=RunSQL("ALTER TABLE pbonus_ex ADD pbe_name CHAR(200) NULL", CursorExName)
*=RunSQL("ALTER TABLE pbonus_ex ADD upcode INT NULL", CursorExName)
*=RunSQL("ALTER TABLE pbonus_ex DROP COLUMN code", CursorExName)
*=RunSQL("ALTER TABLE pbonus_ex ADD pbe_mcode INT NULL", CursorExName)
*=RunSQL("ALTER TABLE pbonus ADD pb_scale INT NULL", CursorName)
*=RunSQL("ALTER TABLE pbonus ADD pb_sb INT NULL", CursorName)
*=RunSQL("ALTER TABLE pbonus ADD pb_edizm INT NULL", CursorName)
*=RunSQL("ALTER TABLE pbonus ADD pb_edizms INT NULL", CursorName)
*=RunSQL("ALTER TABLE pbonus ADD pb_hands BIT NULL", CursorName)
*=RunSQL("ALTER TABLE pbonus ADD pb_noozhbn BIT NULL", CursorName)
* =RunSQL("ALTER TABLE pbonus ADD pb_inprice BIT NULL", CursorName)
*lnRunResult = RunSQL("SELECT * FROM pbonus_ex",CursorExName)
*lnRunResult = RunSQL("SELECT * FROM pbonus",CursorExName)
*=RunSQL("ALTER TABLE pbonus ALTER COLUMN pb_inprice DECIMAL (6,2)", CursorName)

*=RunSQL("ALTER TABLE pbonus ALTER COLUMN pb_sb BIT NULL", CursorName)
*=RunSQL("ALTER TABLE pbonus ALTER COLUMN pb_procu DECIMAL (6,2)", CursorName)

*=RunSQL("ALTER TABLE pbonus ALTER COLUMN pb_sdate DATETIME NULL", CursorName)

*=RunSQL("ALTER TABLE pbonus DROP COLUMN pb_proc", CursorName)
*lnRunResult = RunSQL("SELECT * FROM pbonus_ex",CursorExName)

*=RunSQL("DELETE FROM pbonus_ex WHERE upcode=0", CursorName)
*=RunSQL("ALTER TABLE pbonus_ex ADD deleted BIT NULL", CursorName)

**=RunSQL("ALTER TABLE pbonus ADD tip_code INT NULL", CursorName)
*aa=''
*=RunSQL("UPDATE pbonus SET pb_opis=?aa", CursorName)
*=RunSQL("UPDATE pbonus SET pb_primer=?aa", CursorName)
*=RunSQL("UPDATE pbonus SET pb_doctxt=?aa", CursorName)
*=RunSQL("UPDATE pbonus SET pb_contact=?aa", CursorName)
*=RunSQL("UPDATE pbonus SET pb_nuans=?aa", CursorName)
*DISPLAY STRUCTURE TO b:\uchet.tst\pbonus\old\pbonus.txt NOCONSOLE
*DISPLAY STRUCTURE TO b:\uchet.tst\pbonus\old\pbonus_ex.txt NOCONSOLE
*
*BROWSE
*USE
*
* �������� ����� �� ������
pnUserCheck=0
pnUserCheck=CheckPBonusUser(M.CUser_Code,'PBonus')
IF  pnUserCheck = 1
	DO FORM PB_LST.scx 	&& ������� �������� �����
ELSE
	WAIT WINDOW '� ��� ��� ������� � ������ ������!'	
ENDIF	

RELEASE cValidString
RELEASE MySubDir
RELEASE CursorName, CursorTmpName, CursorLockName
RELEASE MainTableName, ExtTableName
RELEASE pcGridBackRed, pcGridBackGreen, pcGridBackBlue, pcGridBackYellow, pcGridBackWhite
RELEASE M.CUser_Name, M.CUser_Code
*RELEASE pnFltPri, pnFltOtm, plFltDraft, M.CUser_Co
RELEASE PostFolderCode, BrandFolderCode, VidFolderCode, TipFolderCode
RELEASE sqlSelectStatement, sqlLineSelectStatement, sqlInsertStatement, sqlUpdateStatement, sqlManyDeleteStatement, sqlOneDeleteStatement, sqlUnDeleteStatement
RELEASE sqlExSelectStatement,sqlExInsertStatement,sqlExDeleteStatement
RELEASE CursorExName




