##[
  Utils of Authentication
]##

import httpclient, net, base64, strformat, tables
import core

proc setCertDiscard* ()

proc setAuthBasic* (id, pass: string)

proc setAuthDigest* (id, pass: string)

proc setAuthBearer* ()

proc setAuthOauth* ()

proc setAuthKey* (token: string, key="key")

proc setAuthToken* ()

proc clearAuth* ()

# --

proc setCertDiscard() =
  clientArg.sslContext = newContext(verifyMode=CVerifyNone)

proc setAuthBasic(id, pass: string) =
  generalHeader["Authorization"] = "Basic "&encode(fmt"{id}:{pass}")
  generalHeader["Access"] = "*/*"
  useGeneralHeader = true

proc setAuthDigest(id, pass: string) =
  discard
proc setAuthBearer* () =
  discard
proc setAuthOauth* () =
  discard
proc setAuthKey* (token: string, key="key") =
  generalHeader[key] = token
  useGeneralHeader = true
proc setAuthToken* () =
  discard
proc clearAuth() =
  useGeneralHeader = false
  useGeneralBody = false
  generalHeader = initTable[string, string]()
  generalBody = initTable[string, string]()
  clientArg = initClientArg()
