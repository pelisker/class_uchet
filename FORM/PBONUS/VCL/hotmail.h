#DEFINE CRLF  CHR(13)+CHR(10)
#DEFINE DCRLF CRLF+CRLF

#DEFINE urlMsn     "http://oe.msn.msnmail.hotmail.com/cgi-bin/hmdata"
#DEFINE urlHotmail "http://services.msn.com/svcs/hotmail/httpmail.asp"
#DEFINE ccSendmsgNode '/D:multistatus/D:response/D:propstat/D:prop/hm:sendmsg'

#DEFINE ccXmlFolders '<?xml version="1.0"?>' + CRLF +;
'<D:propfind xmlns:D="DAV:" xmlns:h="http://schemas.microsoft.com/hotmail/" ' +;
'xmlns:hm="urn:schemas:httpmail:">' + CRLF +;
'	<D:prop>' + CRLF +;
'		<h:adbar/>' + CRLF +;
'		<hm:contacts/>' + CRLF +;
'		<hm:inbox/>' + CRLF +;
'		<hm:outbox/>' + CRLF +;
'		<hm:sendmsg/>' + CRLF +;
'		<hm:sentitems/>' + CRLF +;
'		<hm:deleteditems/>' + CRLF +;
'		<hm:drafts/>' + CRLF +;
'		<hm:msgfolderroot/>' + CRLF +;
'		<h:maxpoll/>' + CRLF +;
'		<h:sig/>' + CRLF +;
'	</D:prop>' + CRLF +;
'</D:propfind>'
