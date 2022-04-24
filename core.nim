import httpclient, net, tables, sequtils

type
  ClientArg = ref object
    userAgent* : string
    maxRedirects* : int
    sslContext* : SslContext
    proxy* : Proxy
    timeout* : int
    headers* : HttpHeaders

proc initClientArg* (): ClientArg

var
  useGeneralHeader* = false
  useGeneralBody* = false
  generalHeader* = initTable[string, string]()
  generalBody* = initTable[string, string]()
  clientArg* = initClientArg()

proc newClient(): HttpClient

proc get* (url: string, header: openArray[(string, string)] = []): Response
proc get* (url: string, header: Table[string, string]): Response

proc post* (url: string, header: openArray[(string, string)] = [], body="", multipart: MultipartData = nil): Response
proc post* (url: string, header: Table[string, string], body="", multipart: MultipartData = nil): Response

proc put* (url: string, header: openArray[(string, string)] = [], body="", multipart: MultipartData = nil): Response
proc put* (url: string, header: Table[string, string], body="", multipart: MultipartData = nil): Response

proc delete* (url: string, header: openArray[(string, string)] = []): Response
proc delete* (url: string, header: Table[string, string]): Response

proc patch* (url: string, header: openArray[(string, string)] = [], body = "", multipart: MultipartData = nil): Response
proc patch* (url: string, header: Table[string, string], body = "", multipart: MultipartData = nil): Response

proc calcHeader(header: Table[string, string]): Table[string, string]
proc merge[A, B](h1, h2: Table[A, B]): Table[A, B]

# --

proc get(url: string, header: openArray[(string, string)] = []): Response =
  get(url, header.toTable)

proc post(url: string, header: openArray[(string, string)] = [], body="", multipart: MultipartData = nil): Response =
  post(url, header.toTable, body, multipart)

proc put(url: string, header: openArray[(string, string)] = [], body="", multipart: MultipartData = nil): Response =
  put(url, header.toTable, body, multipart)

proc delete(url: string, header: openArray[(string, string)] = []): Response =
  delete(url, header.toTable)

proc patch(url: string, header: openArray[(string, string)] = [], body = "", multipart: MultipartData = nil): Response =
  patch(url, header.toTable, body, multipart)


proc get(url: string, header: Table[string, string]): Response =
  let
    client = newClient()
    headerArg = calcHeader(header)
  if headerArg.len!=0:
    client.headers = newHttpHeaders(toSeq(headerArg.pairs))
  result = client.get(url)


proc post(url: string, header: Table[string, string], body="", multipart: MultipartData = nil): Response =
  discard
proc put(url: string, header: Table[string, string], body="", multipart: MultipartData = nil): Response =
  discard
proc delete(url: string, header: Table[string, string]): Response =
  discard
proc patch(url: string, header: Table[string, string], body = "", multipart: MultipartData = nil): Response =
  discard



proc initClientArg(): ClientArg =
  result = ClientArg()
  result.userAgent = defUserAgent
  result.maxRedirects = 5
  result.sslContext = newContext()
  result.timeout = -1
  result.headers = newHttpHeaders()

proc newClient(): HttpClient =
  result = newHttpClient(
    userAgent = clientArg.userAgent,
    maxRedirects = clientArg.maxRedirects,
    sslContext = clientArg.sslContext,
    timeout = clientArg.timeout,
    headers = clientArg.headers
  )

proc calcHeader(header: Table[string, string]): Table[string, string] =
  result = block:
    let state = (useGeneralHeader, header.len!=0)
    if state==(true, true): merge(generalHeader, header)
    elif state==(true, true): generalHeader
    elif state==(false, true): header
    else: initTable[string, string]()


proc merge[A, B](h1, h2: Table[A, B]): Table[A, B] =
  result = h1
  for key, val in h2:
    result[key] = val



when isMainModule:
  generalHeader["a"] = "T"
  useGeneralHeader = true
  echo get("http://www.google.com", header={"s": "D"}).body