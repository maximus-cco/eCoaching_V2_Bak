using eCLAdmin.Models;
using System.Collections.Generic;

namespace eCLAdmin.Services
{
    public interface IEmailService
    {
        void Send(Email email);

        void Send(Email email, List<string> logNames, string webServerName);
    }
}
