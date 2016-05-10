using eCLAdmin.Services;
using System.Web.Mvc;

namespace eCLAdmin.Controllers
{
    public class UserController : BaseController
    {

        private readonly IUserService userService = new UserService();

        //
        // GET: /ManageAccessControl/
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult List()
        {
            return View(userService.GetAllUsers());
        }
	}
}