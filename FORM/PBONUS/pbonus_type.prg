**************************************************************************
* PBONUS_TYPE.PRG - ���������� ����� ������� �� �����������
* �������: 10.02.2011
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
*SET CLASSLIB TO MySubDir+"\VCL\SendEmail" ADDITIVE

PUBLIC CursorName, CursorTmpName, CursorLockName, CursorUserName
CursorName=fCreateCursorName('pbt')
CursorTmpName=fCreateCursorName('_pbt')
CursorLockName=fCreateCursorName('_lock')
CursorUserName=fCreateCursorName('_user')

* ��� �������� �������
* ������������ ��� ������������� � �������� MyCheckRLOCK, MyRLock, MyRUnLock
* � ��� �������� ����� � pbonus_del.scx 
PUBLIC MainTableName
MainTableName="pbonus_type"

* ��� � ��� �������� ������������
PUBLIC M.CUser_Name, M.CUser_Code
M.CUser_Code=gnuser						&& ���������� ������������� ���� �������� ������������ �� ��, ��� ���������� (����� �������� ...) �������� � ����� ����������
M.CUser_Name=ALLTRIM(SUBSTR(GetUserData(M.CUser_Code,1,.F.),9))

* ������� �� ����� �������� ������������ ��� ��������� � �����
*PUBLIC pnFltPri, pnFltOtm, plFltDraft, M.CUser_Co
*=GetUserPresets(M.CUser_Code,'USER')

* ������� ��� �������, ���������� � ���������� ������ � �������� �������
PUBLIC sqlSelectStatement, sqlLineSelectStatement, sqlInsertStatement, sqlUpdateStatement, sqlManyDeleteStatement, sqlOneDeleteStatement, sqlUnDeleteStatement

sqlSelectStatement="SELECT * FROM "+MainTableName
				   
sqlLineSelectStatement=sqlSelectStatement+" WHERE "+MainTableName+".code=?m.code"
					 
sqlInsertStatement="INSERT INTO "+MainTableName+;
						  " (pbt_name,pbt_sb,pbt_pb,pbt_comm,deleted) "+;
			  	   "VALUES(?m.pbt_name,?m.pbt_sb,?m.pbt_pb,?m.pbt_comm,?m.deleted)"
		 	  
sqlUpdateStatement="UPDATE "+MainTableName+" "+;
				   "SET pbt_name=?m.pbt_name,pbt_sb=?m.pbt_sb,pbt_pb=?m.pbt_pb,pbt_comm=?m.pbt_comm "+;
				   "WHERE code=?m.code"
			 	  
sqlManyDeleteStatement="UPDATE "+MainTableName+" SET DELETED=1"

sqlOneDeleteStatement=sqlManyDeleteStatement+" WHERE code=?m.code"

sqlUnDeleteStatement="UPDATE "+MainTableName+" SET DELETED=0 WHERE code=?m.code"

**** �������� ���� ��� ���������� *********************************
*=RunSQL("ALTER TABLE pbonus_type ADD pbt_comm CHAR (150) ", CursorName)
*=RunSQL("ALTER TABLE pbonus_type ALTER COLUMN pbt_comm CHAR (150) ", CursorName)
*=RunSQL("ALTER TABLE pbonus_user ADD pau_fotm INT ", CursorName)
*=RunSQL("ALTER TABLE pbonus_user ADD pau_fdra BIT NULL", CursorName)
*lnRunResult = RunSQL("SELECT pbonus_user.*, password.name FROM pbonus_user LEFT JOIN password ON pbonus_user.upcode= password.code", CursorName)
*DISPLAY STRUCTURE
*BROWSE
*USE
*******************************************************************

* �������� ����� �� ������
pnUserCheck=0
pnUserCheck=CheckPBonusUser(M.CUser_Code,'PBonusType')
IF  pnUserCheck = 1
	DO FORM PBT_LST.scx 	&& ������� �������� �����
ELSE
	WAIT WINDOW '� ��� ��� ������� � ������ ������!'	
ENDIF	




