import httpclient, tables, sequtils

runnableExamples:
  setAuthToken()
  setAuthBasic()

proc argstest(a, b, c: string) =
  echo a
  echo b
  echo c




echo $( toSeq(initTable[string, string]().pairs) == @[] )

echo $( newHttpHeaders() == newHttpHeaders(@[]) )

var
  client = newHttpClient()
  h1 = newHttpHeaders()
  h2 = newHttpHeaders(@[])

client.headers = h1
var res1 = client.get("http://www.google.com")
client.headers = h2
var res2 = client.get("http://www.google.com")


echo $(res1==res2)