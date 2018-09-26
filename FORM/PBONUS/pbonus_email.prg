**************************************************************************
* PBONUS_EMAIL.PRG - ������ � �������� �����������
* �������: 08.03.2011
* ��������� ���������: 08.03.2011
* �����: ����� �.
**************************************************************************
PUBLIC MySubDir
MySubDir="PBONUS"

* ����� ������������� ����� "�������" ��������� ���������
SET PATH TO MySubDir+"\" ADDITIVE
SET PATH TO MySubDir+"\VCL\" ADDITIVE
SET PATH TO MySubDir+"\ICONS\" ADDITIVE

* ��������� ������ �� ������� ����� ��� ���� ����� �������� � �������
SET PROCEDURE TO MySubDir+"\pbonus_common.prg" ADDITIVE
*SET CLASSLIB TO MySubDir+"\VCL\SendEmail" ADDITIVE

* ����� � ���������� ��������
PUBLIC CursorName, CursorTmpName, CursorLockName, CursorUserName
CursorName=fCreateCursorName('pe')
CursorTmpName=fCreateCursorName('_pe')
CursorLockName=fCreateCursorName('_lock')
CursorUserName=fCreateCursorName('_user')

* ��� �������� �������
* ������������ ��� ������������� � �������� MyCheckRLOCK, MyRLock, MyRUnLock
* � ��� �������� ����� � pbonus_del.scx 
PUBLIC MainTableName
MainTableName="pbonus_email"

* ����� ��������� Grida
*PUBLIC pcGridBackRed, pcGridBackGreen, pcGridBackBlue, pcGridBackYellow, pcGridBackWhite
*pcGridBackRed	= "RGB(255,190,190)"
*pcGridBackGreen = "RGB(190,255,190)"
*pcGridBackBlue 	= "RGB(190,190,255)"
*pcGridBackYellow= "RGB(255,255,190)"
*pcGridBackWhite = "RGB(255,255,255)"

* ��� � ��� �������� ������������
PUBLIC M.CUser_Name, M.CUser_Code
M.CUser_Code=gnuser						&& ���������� ������������� ���� �������� ������������ �� ��, ��� ���������� (����� �������� ...) �������� � ����� ����������
M.CUser_Name=ALLTRIM(SUBSTR(GetUserData(M.CUser_Code,1,.F.),9))

* ������� ��� �������, ���������� � ���������� ������ � �������� �������, ��� �������� �����
PUBLIC sqlSelectStatement, sqlLineSelectStatement, sqlInsertStatement, sqlUpdateStatement, sqlManyDeleteStatement, sqlOneDeleteStatement, sqlUnDeleteStatement

sqlSelectStatement="SELECT * FROM "+MainTableName

sqlLineSelectStatement=sqlSelectStatement+" WHERE "+MainTableName+".code=?m.code"

sqlInsertStatement="INSERT INTO "+MainTableName+" (smail_name,smail_addr,deleted) "+;
			  	   "VALUES(?m.smail_name,?m.smail_addr,?m.deleted)"
		 	  
sqlUpdateStatement="UPDATE "+MainTableName+" "+;
				 "SET smail_name=?m.smail_name,smail_addr=?m.smail_addr "+;
				 "WHERE code=?m.code"
				 
sqlManyDeleteStatement="UPDATE "+MainTableName+" SET DELETED=1"

sqlOneDeleteStatement=sqlManyDeleteStatement+" WHERE code=?m.code"

sqlUnDeleteStatement="UPDATE "+MainTableName+" SET DELETED=0 WHERE code=?m.code"
				 
					 	  
**** �������� ���� ��� ���������� *********************************
* =RunSQL("ALTER TABLE panketa ADD Deleted BIT NULL", CursorName)
*=RunSQL("SELECT * FROM pbonus_email", CursorName)
*DISPLAY STRUCTURE
*BROWSE
*USE
*RETURN
*******************************************************************

* �������� ����� �� ������
pnUserCheck=0
pnUserCheck=CheckPBonusUser(M.CUser_Code,'PEmail')
IF  pnUserCheck = 1
	DO FORM PE_LST.scx 	&& ������� �������� �����
ELSE
	WAIT WINDOW '� ��� ��� ������� � ������ ������!'	
ENDIF	

RELEASE MySubDir
RELEASE CursorName, CursorTmpName, CursorLockName, CursorUserName
RELEASE MainTableName
*RELEASE pcGridBackRed, pcGridBackGreen, pcGridBackBlue, pcGridBackYellow, pcGridBackWhite
RELEASE M.CUser_Name, M.CUser_Code
RELEASE sqlSelectStatement, sqlLineSelectStatement, sqlInsertStatement, sqlUpdateStatement, sqlManyDeleteStatement, sqlOneDeleteStatement, sqlUnDeleteStatement



