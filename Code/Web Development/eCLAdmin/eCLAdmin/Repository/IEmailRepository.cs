using eCLAdmin.Models;
using System.Collections.Generic;

namespace eCLAdmin.Repository
{
    public interface IEmailRepository
    {
        void Store(List<Email> mailList, string mailSource, string userId);
    }
}