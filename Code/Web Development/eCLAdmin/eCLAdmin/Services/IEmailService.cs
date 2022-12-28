using eCLAdmin.Models;
using System.Collections.Generic;

namespace eCLAdmin.Services
{
    public interface IEmailService
    {
        void StoreEmail(Email email, List<string> logNames, string webServerName, string emailSource, string userId);
    }
}
