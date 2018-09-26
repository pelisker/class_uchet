**************************************************************************
* PBONUS_EMAIL.PRG - работа с анкетами поставщиков
* Создано: 08.03.2011
* Последнее изменение: 08.03.2011
* Автор: Бринк С.
**************************************************************************
PUBLIC MySubDir
MySubDir="PBONUS"

* задаю относительные места "лежания" компонент программы
SET PATH TO MySubDir+"\" ADDITIVE
SET PATH TO MySubDir+"\VCL\" ADDITIVE
SET PATH TO MySubDir+"\ICONS\" ADDITIVE

* подключаю файдик со списком общих для всей проги процедур и функций
SET PROCEDURE TO MySubDir+"\pbonus_common.prg" ADDITIVE
*SET CLASSLIB TO MySubDir+"\VCL\SendEmail" ADDITIVE

* имена и псевдонимы курсоров
PUBLIC CursorName, CursorTmpName, CursorLockName, CursorUserName
CursorName=fCreateCursorName('pe')
CursorTmpName=fCreateCursorName('_pe')
CursorLockName=fCreateCursorName('_lock')
CursorUserName=fCreateCursorName('_user')

* имя основной таблицы
* используется при идентификации в функциях MyCheckRLOCK, MyRLock, MyRUnLock
* и при удалении строк в pbonus_del.scx 
PUBLIC MainTableName
MainTableName="pbonus_email"

* цвета раскраски Grida
*PUBLIC pcGridBackRed, pcGridBackGreen, pcGridBackBlue, pcGridBackYellow, pcGridBackWhite
*pcGridBackRed	= "RGB(255,190,190)"
*pcGridBackGreen = "RGB(190,255,190)"
*pcGridBackBlue 	= "RGB(190,190,255)"
*pcGridBackYellow= "RGB(255,255,190)"
*pcGridBackWhite = "RGB(255,255,255)"

* имя и код текущего пользователя
PUBLIC M.CUser_Name, M.CUser_Code
M.CUser_Code=gnuser						&& переменная идентификатор кода текущего пользователя из СВ, для надежности (вдруг поменяют ...) сохраняю в своей переменной
M.CUser_Name=ALLTRIM(SUBSTR(GetUserData(M.CUser_Code,1,.F.),9))

* команды для выборки, добавления и обновления строки в основную таблицу, для удаления строк
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
				 
					 	  
**** добавляю поля при разработке *********************************
* =RunSQL("ALTER TABLE panketa ADD Deleted BIT NULL", CursorName)
*=RunSQL("SELECT * FROM pbonus_email", CursorName)
*DISPLAY STRUCTURE
*BROWSE
*USE
*RETURN
*******************************************************************

* проверяю права на доступ
pnUserCheck=0
pnUserCheck=CheckPBonusUser(M.CUser_Code,'PEmail')
IF  pnUserCheck = 1
	DO FORM PE_LST.scx 	&& вызываю экранную форму
ELSE
	WAIT WINDOW 'У вас нет доступа в данный раздел!'	
ENDIF	

RELEASE MySubDir
RELEASE CursorName, CursorTmpName, CursorLockName, CursorUserName
RELEASE MainTableName
*RELEASE pcGridBackRed, pcGridBackGreen, pcGridBackBlue, pcGridBackYellow, pcGridBackWhite
RELEASE M.CUser_Name, M.CUser_Code
RELEASE sqlSelectStatement, sqlLineSelectStatement, sqlInsertStatement, sqlUpdateStatement, sqlManyDeleteStatement, sqlOneDeleteStatement, sqlUnDeleteStatement



