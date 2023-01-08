!z::

Clipboard := ""
Send, ^c
ClipWait
q = %Clipboard%
url := "https://udtaleordbog.dk/api_txt.php?q=" q

ComObjError(false)
http := ComObjCreate("WinHttp.WinHttpRequest.5.1")
( proxy && http.SetProxy(2, proxy) )
http.open( "GET", url, 1 )
http.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded;charset=utf-8")
http.SetRequestHeader("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:47.0) Gecko/20100101 Firefox/47.0")
http.send("q=" . URIEncode(str))
http.WaitForResponse(-1)

Send, ^i
Send ^{left}
Send, ^i
Send % http.responsetext
Send {space}

URIEncode(str, encoding := "UTF-8")  {
   VarSetCapacity(var, StrPut(str, encoding))
   StrPut(str, &var, encoding)

   While code := NumGet(Var, A_Index - 1, "UChar")  {
      bool := (code > 0x7F || code < 0x30 || code = 0x3D)
      UrlStr .= bool ? "%" . Format("{:02X}", code) : Chr(code)
   }
   Return UrlStr
}
