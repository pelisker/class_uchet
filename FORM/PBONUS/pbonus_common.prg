*
* PBONUS_COMMON
*

**********************************************************************************************************************
*	������� RecordsCount  -  ���������� ����� ������� � ����� � ������ ������������� ��������, � ��������������� RECNO
**********************************************************************************************************************
FUNCTION RecordsCount
	PARAMETERS pnRecPosition
*	=0 - �������� � ����� �����
*	=1 - ������� � ������ ����� GO TOP
*	=2 - ��������� ������� ������ 
	PRIVATE n_records
	svRECNO=IIF( EOF().OR.BOF(), -1, RECNO() )
	COUNT TO n_records
	DO CASE
		CASE pnRecPosition = 0			
		CASE pnRecPosition = 1
				GO TOP
		CASE pnRecPosition = 2
				IF svRECNO > 0
					GO svRECNO	
				ENDIF
	ENDCASE
RETURN n_records

*======================================================================================================================
*	��������� ErrHand - ���������� ������
*======================================================================================================================
PROCEDURE errhand
PARAMETER merror, xmess, mess1, mprog, mlineno

WAIT WINDOWS STR(merror)+' '+xmess
pnLastError=merror

*	CLEAR
* ? 'Error number: ' + LTRIM(STR(merror))
* ? 'Error message: ' + mess
* ? 'Line of code with error: ' + mess1
* ? 'Line number of error: ' + LTRIM(STR(mlineno))
* ? 'Program with error: ' + mprog


*======================================================================================================================
*	������� ��� ��������������� ���������� �������
*======================================================================================================================
FUNCTION fSBRefresh
	svRECNO=IIF( EOF().OR.BOF(), -1, RECNO() )
	GO TOP	
	IF svRECNO > 0
		GO svRECNO	
	ENDIF
RETURN .T.

*======================================================================================================================
*	������� MyCheckRLock ��� �������� ���������� ������
*======================================================================================================================
FUNCTION MyCheckRLock
	PARAMETERS pcTname, pnRCode
	LOCAL lnLockedCode
	lnLockedCode = 0
	
*	���� ����� ����� - ��� ������������, �� ������� ����� ����������
*	����������:	pnLockUserCode, � �� �������� ��� ������������	�
	
*	�������� ������� ������� �������
	svdLAlias=ALIAS()
	
*	��������� �� ����������� �� ������, ����  �����������, �� ��� ���� - ��� ����������
	=RunSQL("SELECT * FROM pbonus_lock WHERE tname= ?pcTname AND reccode = ?pnRCode",CursorLockName) 
	lnrc=RECCOUNT()
	IF lnrc > 0
		pnLockUserCode = lockuser
		lnLockedCode  = code
	ENDIF	
*	���������� ������
	SELECT &CursorLockName	
	USE

*	�������������� ������� �������	
	IF .NOT. EMPTY(svdLAlias)
		SELECT &svdLAlias
	ENDIF	
	
RETURN lnLockedCode

*======================================================================================================================
*	������� MyRLock ��� ���������� ������ ��� ���������
*======================================================================================================================
FUNCTION MyRLock
	PARAMETERS pcTname, pnRCode
	LOCAL lnLockedCode
	
*	�������� ������� ������� �������
	svdLAlias=ALIAS()

*	��������
	= RunSQL("INSERT INTO pbonus_lock (tname, reccode, lockuser) VALUES(?pcTname, ?pnRCode, ?M.CUser_Code)")

*	������� ��� ����������� ������	
	= RunSQL("SELECT code AS lockcode FROM pbonus_lock WHERE tname= ?pcTname AND reccode = ?pnRCode",CursorLockName) 
	lnLockedCode=lockcode
	
*	���������� ������
	SELECT &CursorLockName	
	USE

*	�������������� ������� �������	
	IF .NOT. EMPTY(svdLAlias)
		SELECT &svdLAlias
	ENDIF	
	
RETURN lnLockedCode

*======================================================================================================================
*	������� ��� ������������� ������ ��� ���������
*======================================================================================================================
FUNCTION MyRUnLock
	PARAMETERS pnUnlockRecCode
	= RunSQL("DELETE FROM pbonus_lock WHERE code=?pnUnlockRecCode")
RETURN .T.


*======================================================================================================================
*	������� ��������� ��������� ��� ��� �������
*======================================================================================================================
FUNCTION fCreateCursorName
	PARAMETERS pcFPrefix
	LOCAL lcFName
	=RAND(-1)
	nv=STR(RAND()*100)
	lcFName=pcFPrefix+ALLTRIM(nv)	
RETURN lcFName


*======================================================================================================================
*	������� GetUserData	- �������� ���� �� ������� �������� 
*	pncU	   - �������� �� �������� ������ ������������ �������� 	
*	pnVariant  - ��� �������� pncU: =1(ID); =2(SVKOD); =3(NAME)
*	plShowGrid - ���� TRUE: ���������� ���� � ������� ������������/���������
*======================================================================================================================
FUNCTION GetUserData
	PARAMETERS pncU, pnVariant, plShowGrid
	pcRetValue=''
	svdXAlias=ALIAS()	
	plemcUsed=.F.

	CursorUserName=fCreateCursorName('_user')
*	=RunSQL("SELECT code, name FROM password ORDER code",CursorUserName) 
	=RunSQL("SELECT * FROM password ORDER BY code",CursorUserName) 
	SELECT &CursorUserName
	INDEX ON code TAG code
	INDEX ON name TAG name ADDITIVE
	DO CASE
		CASE pnVariant = 1  && �� ID
									SET ORDER TO TAG code
		CASE pnVariant = 2  && �� NAME
									SET ORDER TO TAG name
	ENDCASE	
	xSeek=IIF(pncU>0,SEEK(pncU),.F.)
*	BROWSE

	plOk=IIF(xSeek,.T.,.F.)
	IF plShowGrid
		SET ORDER TO TAG NAME
		IF .NOT.xSeek
			GO TOP
		ENDIF
		DO FORM pb_getuser TO plOk
	ENDIF	
	IF plOk
		pcRetValue=STR(code,8)+name
	ENDIF	
	USE

	IF .NOT. EMPTY(svdXAlias)
		SELECT &svdXAlias
	ENDIF	
	
RETURN pcRetValue

*======================================================================================================================
*	������� GetUserPresets	- �������� �� ����� �������� ������������� ��������� ���������
*	pncU	   - ��� ������������
*	pnVariant  - ��� ������ ������ ������
*======================================================================================================================
FUNCTION GetUserPresets
	PARAMETERS pncU, pnVariant
	plRetValue=.F.

	svdXAlias=ALIAS()	
	CursorUserName=fCreateCursorName('_user')
	=RunSQL("SELECT * FROM pbonus_user WHERE pbonus_user.upcode=?pncU",CursorUserName) 
	SELECT &CursorUserName
	IF RECCOUNT() > 0
		SCATTER MEMVAR
		plRetValue=.T.
		DO CASE
			CASE pnVariant = '������'	&& ������ ���������� 
										pnFltPri     = m.pau_fpri
										pnFltOtm     = m.pau_fotm
										plFltDraft   = m.pau_fdra
										M.CUser_Co   = m.pau_isco
										M.CUser_DZ   = m.pau_isdz
										M.CUser_ZKD  = m.pau_iszkd
										M.CUser_KD   = m.pau_iskd
										M.CUser_IT   = m.pau_isit
										M.CUser_MN   = m.pau_ismn
										M.CUser_SAVE = m.pau_save
										M.CUser_SAVE2= m.pau_save2
										M.CUser_CHUS = m.pau_chus
										M.CUser_ISMM = m.pau_ismm
										
			CASE pnVariant = '������'	&& �������� ������� 
										M.CUser_SV = m.pbu_svi
			CASE pnVariant = '����'		&& ��������
										M.CUser_SV = m.pbu_svi
			OTHERWISE							
		ENDCASE
	ENDIF
	USE

	IF .NOT. EMPTY(svdXAlias)
		SELECT &svdXAlias
	ENDIF	
	
RETURN plRetValue


*======================================================================================================================
*	������� CheckPBonusUser	- ��������� ����� ������������
*	pncU	   - ��� ������������
*	pnVariant  - ������� ����� ����� ���������
*======================================================================================================================
FUNCTION CheckPBonusUser
	PARAMETERS pncU, pnVariant
	LOCAL pnRetValue
	pnRetValue=0

	svdXAlias=ALIAS()	
	CursorUserName=fCreateCursorName('_user')
	=RunSQL("SELECT * FROM pbonus_user WHERE upcode=?pncU",CursorUserName) 
	SELECT &CursorUserName
*	BROWSE
	IF RECCOUNT() <= 0 
		pnRetValue=-1	&& ������ ��� ������� � ������ (������ ��� � �������)
	ELSE
		SCATTER MEMVAR		
		DO CASE
			CASE pnVariant='PBonusType'
								pnRetValue=IIF(m.pbu_isbt,1,IIF(M.CUser_Code=100,1,0))
			CASE pnVariant='PBonusUser'
								pnRetValue=IIF(m.pbu_isbu,1,IIF(M.CUser_Code=100,1,0))
			CASE pnVariant='PBonus'
								pnRetValue=IIF(m.pbu_isbn,1,IIF(M.CUser_Code=100,1,0))
			CASE pnVariant='SB'
								pnRetValue=IIF(m.pbu_issb,1,0)
			CASE pnVariant='PB'
								pnRetValue=IIF(m.pbu_ispb,1,0)
			CASE pnVariant='SV'
								pnRetValue=IIF(m.pbu_svi ,1,IIF(M.CUser_Code=100,1,0))
			CASE pnVariant='PAnketa'
								pnRetValue=IIF(m.pau_isan,1,IIF(M.CUser_Code=100,1,0))
			CASE pnVariant='DZ'
								pnRetValue=IIF(m.pau_isdz,1,0)
			CASE pnVariant='KD'
								pnRetValue=IIF(m.pau_iskd,1,0)
			CASE pnVariant='ZKD'
								pnRetValue=IIF(m.pau_iszkd,1,0)
			CASE pnVariant='MN'
								pnRetValue=IIF(m.pau_ismn,1,0)
			CASE pnVariant='CO'
								pnRetValue=IIF(m.pau_isco,1,IIF(M.CUser_Code=100,1,0))
			CASE pnVariant='ITOG'
								pnRetValue=IIF(m.pau_isit,1,0)
			CASE pnVariant='PEmail'
								pnRetValue=IIF(m.pbu_svi,1,IIF(M.CUser_Code=100,1,0))
			CASE pnVariant='Sobr'
*								pnRetValue=IIF(m.psu_issbr,1,0)
								pnRetValue=1
		ENDCASE
	ENDIF
	USE
	IF .NOT. EMPTY(svdXAlias)
		SELECT &svdXAlias
	ENDIF
RETURN pnRetValue	


*======================================================================================================================
*	������� fYNO - ���������� "��, ���, ��������"
*	pnQcode  - ��� �������
*======================================================================================================================
FUNCTION fYno
	PARAMETERS pnQcode
RETURN IIF(pnQcode=1,'��',IIF(pnQcode=2,'���',IIF(pnQcode=3,'��������',IIF(pnQcode=4,'����������',''))))	

*======================================================================================================================
*	������� fYnoDBC - ������ ���� ��� �������� ����
*	pnQcode  - ��� �������
*======================================================================================================================
FUNCTION fYnoDBC
	PARAMETERS pnQcode
RETURN IIF(pnQcode=1,&pcGridBackGreen,IIF(pnQcode=2,&pcGridBackRed,IIF(pnQcode=3,&pcGridBackBlue,IIF(pnQcode=4,&pcGridBackYellow,&pcGridBackWhite))))	

*IIF(a_it_yno=1,&pcGridBackGreen,IIF(a_it_yno=2,&pcGridBackRed,IIF(a_it_yno=3,&pcGridBackBlue,IIF(a_it_yno=4,&pcGridBackYellow,&pcGridBackWhite))))

*======================================================================================================================
*	�� ������������ !!!
*	������� fNapr - ���������� �������� �����������
*	pnQcode  - ��� �������
*======================================================================================================================
*FUNCTION fNapr
*	PARAMETERS pnQcode
*RETURN IIF(pnQcode=1,'������',IIF(pnQcode=2,'����������� �����',IIF(pnQcode=3,'������','')))	

*======================================================================================================================
*	������� fAim - ���������� �������� ���� ������
*	pnQcode  - ��� �������
*======================================================================================================================
FUNCTION fAim
	PARAMETERS pnQcode
RETURN IIF(pnQcode=1,'����� ���������',IIF(pnQcode=2,'��������� �������',IIF(pnQcode=3,'���. �� ����','')))	

*********************************************************************************
* ������� fGetIntEmail - ��������� ����� ���������� ����� �� ����� ������������
*********************************************************************************
FUNCTION fGetIntEmail
	PARAMETERS pcUserName, plAddTail
	LOCAL lcMngName, lcMailPrefix
	lcMailPrefix=''
	lcMngName=ALLTRIM(pcUserName)
	nSkobkaO=AT('(',lcMngName)
								*	WAIT WINDOW 'nSkobkaO='+STR(nSkobkaO)
	IF nSkobkaO > 0
 		nSkobkaZ=AT(')',lcMngName)
								*	WAIT WINDOW 'nSkobkaZ='+STR(nSkobkaZ)
		IF nSkobkaZ >0 .AND. nSkobkaZ > nSkobkaO
				lcMailPrefix=CHRTRAN(SUBSTR(lcMngName,nSkobkaO+1,nSkobkaZ-nSkobkaO-1),"����������������������","etopahkcbmxETOPAHKCBMX")
								*	WAIT WINDOW 'lcMngMailPrefix='+lcMngMailPrefix
		ENDIF		
	ENDIF
RETURN LOWER(lcMailPrefix)+IIF(plAddTail,"@baltcllc.net","")

*********************************************************************************
* ������� ffPri - ������������ ��� ������������ � pbonus_user
*********************************************************************************
FUNCTION ffPri
	PARAMETERS pnValue
RETURN IIF(pnValue=1,'���','������ ����')

*********************************************************************************
* ������� ffOtm - ������������ ��� ������������ � pbonus_user
*********************************************************************************
FUNCTION ffOtm
	PARAMETERS pnValue
	LOCAL pcRetVal 	
	DO CASE
		CASE pnValue = 1
							pcRetVal='���'
		CASE pnValue = 2
							pcRetVal='��� ������� ��� ��'
		CASE pnValue = 3
							pcRetVal='��� ������� ���'
		CASE pnValue = 4
							pcRetVal='��� ������� ��'
		CASE pnValue = 5
							pcRetVal='��� ������� ����'
		OTHERWISE					
							pcRetVal=''
	ENDCASE
RETURN pcRetVal	

*********************************************************************************
* ������� fPSave2 - ������������ ��� ������������ � pbonus_user
*********************************************************************************
FUNCTION fPSave2
	PARAMETERS pnValue
RETURN IIF(pnValue=1,'���',IIF(pnValue=2,'���� ��� �������� �������','���� ��� �� ����� �������'))




*======================================================================================================================
*	������� GetNc	- �������� ���� �� ������� �����������
*	pncU	   - �������� �� �������� ������ ������������ �������� 	
*	pnVariant  - ��� �������� pncU: =1(ID); =2(PBT_NAME)
*	plShowGrid - ���� TRUE: ���������� ���� � ������� ���� ������
*	pcVar - �� ������ ����������� �����
*======================================================================================================================
FUNCTION GetNC
	PARAMETERS pncU, pnVariant, plShowGrid, pcVar
	LOCAL lcTmpCursorName, pcRetValue
	pcRetValue=''
	svdXAlias=ALIAS()	

	lcTmpCursorName=fCreateCursorName('_nc')
	DO CASE 
		CASE pcVar='USER'
				=RunSQL("SELECT code, name FROM password",lcTmpCursorName) 
		CASE pcVar='POST'
				=RunSQL("SELECT code, name FROM company WHERE upcode IN (SELECT code FROM company WHERE upcode=?PostFolderCode) OR upcode=?PostFolderCode ",lcTmpCursorName) 
		CASE pcVar='VID'
				=RunSQL("SELECT code, name FROM complect WHERE upcode IN (SELECT code FROM complect WHERE upcode=?VidFolderCode) OR upcode=?VidFolderCode ",lcTmpCursorName) 
			CASE pcVar='NAPR'
				=RunSQL("SELECT code, name FROM region WHERE upcode IN (SELECT code FROM region WHERE upcode=?NaprFolderCode) OR upcode=?NaprFolderCode ",lcTmpCursorName) 
			CASE pcVar='BRAND'
				=RunSQL("SELECT code, name FROM region WHERE upcode IN (SELECT code FROM region WHERE upcode=?BrandFolderCode) OR upcode=?BrandFolderCode ",lcTmpCursorName) 
			CASE pcVar='PBT'
				=RunSQL("SELECT code, pbt_name AS name, pbt_comm FROM pbonus_type WHERE DELETED=0",lcTmpCursorName) 
		CASE pcVar='TIP'
				=RunSQL("SELECT code, name FROM complect WHERE upcode IN (SELECT code FROM complect WHERE upcode=?TipFolderCode) OR upcode=?TipFolderCode ",lcTmpCursorName) 
		CASE pcVar='SOBR_GROUP'		
				=RunSQL("SELECT code, name FROM sobr_group WHERE DELETED=0",lcTmpCursorName) 
		CASE pcVar='SOBR_TGROUP'		
				=RunSQL("SELECT code, name FROM sobr_tgroup WHERE DELETED=0",lcTmpCursorName) 
	ENDCASE
	SELECT &lcTmpCursorName
	INDEX ON code TAG code
	INDEX ON UPPER(name) TAG name ADDITIVE
	DO CASE
		CASE pnVariant = 1  && �� ID
									SET ORDER TO TAG code
		CASE pnVariant = 2  && �� NAME
									SET ORDER TO TAG name
	ENDCASE	
	xSeek=IIF(pncU>0,SEEK(pncU),.F.)
	plOk=IIF(xSeek,.T.,.F.)
	IF plShowGrid
		SET ORDER TO TAG name
		IF .NOT.xSeek
			GO TOP
		ENDIF
		DO CASE 
			CASE pcVar='USER'
				DO FORM pb_getnc WITH lcTmpCursorName, "������ ���������", "��� ������������"  TO plOk
			CASE pcVar='POST'
				DO FORM pb_getnc WITH lcTmpCursorName, "������ �����������", "������������ ����������"  TO plOk
			CASE pcVar='VID'
				DO FORM pb_getnc WITH lcTmpCursorName, "������ ��������� � ����������", "������������ ���������"  TO plOk
			CASE pcVar='NAPR'
				SET FILTER TO code >= 23800   && �������� ������ ��, ������� � ����������� ����� ����������
				DO FORM pb_getnc WITH lcTmpCursorName, "������ �����������", "������������ �����������"  TO plOk
			CASE pcVar='BRAND'
				DO FORM pb_getnc WITH lcTmpCursorName, "������ �������", "������������ ������"  TO plOk
			CASE pcVar='PBT'
				DO FORM pb_getpbt WITH lcTmpCursorName TO plOk
			CASE pcVar='TIP'
				DO FORM pb_getnc WITH lcTmpCursorName, "������ �������� ����� � ����������", "������������ ������"  TO plOk
			CASE pcVar='SOBR_GROUP'
				DO FORM pb_getnc WITH lcTmpCursorName, "������ ����� ��������", "������������ ������"  TO plOk
			CASE pcVar='SOBR_TGROUP'
				DO FORM pb_getnc WITH lcTmpCursorName, "������ ����� ���", "������������ ������"  TO plOk
		ENDCASE	
	ENDIF	
	IF plOk
		pcRetValue=STR(code,8)+name
	ENDIF	
	USE

	IF .NOT. EMPTY(svdXAlias)
		SELECT &svdXAlias
	ENDIF	
	
RETURN pcRetValue


FUNCTION GetLastCode
	PARAMETERS pnBa
	LOCAL pnXCode
	svdXAlias=ALIAS()	
	lcTmpCursorName=fCreateCursorName('_glc')
*	=RunSQL("SELECT MAX(code) AS maxcode FROM "+MainTableName+" WHERE pb_avtor=?pnBa",lcTmpCursorName) 
	=RunSQL("SELECT @@IDENTITY AS maxcode FROM "+MainTableName,lcTmpCursorName) 
*	=RunSQL("SELECT SCOPE_IDENTITY() AS maxcode FROM "+MainTableName,lcTmpCursorName) 
	pnXCode=maxcode	
*	BROWSE
	USE
	IF .NOT. EMPTY(svdXAlias)
		SELECT &svdXAlias
	ENDIF	
RETURN pnXCode


*======================================================================================================================
*	������� fIPI - ���������� ������/����������
*	pnQcode  - ��� �������
*======================================================================================================================
FUNCTION fIPI
	PARAMETERS pnQcode,pnVar
RETURN IIF(pnQcode=1,'����������',IIF(pnQcode=2,IIF(pnVar=1,'������',''),IIF(pnQcode=3,IIF(pnVar=1,'�������� � ������',''),'')))	

*======================================================================================================================
*	������� fRedDBC - ������ ������� ���� ��� �������� ����
*	plQcode  - ��� �������
*======================================================================================================================
FUNCTION fRedDBC
	PARAMETERS plQcode
RETURN IIF(plQcode,&pcGridBackRed,&pcGridBackWhite)

*======================================================================================================================
*	������� ftnpp - ���������� ������ ���
*	pnQcode  - ��� �������
*======================================================================================================================
FUNCTION ftnpp
	PARAMETERS pnQcode
RETURN IIF(pnQcode=1,'�����',IIF(pnQcode=2,'������������',IIF(pnQcode=3,'�����������','')))

*======================================================================================================================
*	������� ftitog - ���������� ����
*	pnQcode  - ��� �������
*======================================================================================================================
FUNCTION ftitog
	PARAMETERS pnQcode
RETURN IIF(pnQcode=1,'��',IIF(pnQcode=2,'���',IIF(pnQcode=3,'���������','')))


