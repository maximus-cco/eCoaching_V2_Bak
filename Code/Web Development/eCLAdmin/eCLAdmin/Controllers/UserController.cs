using eCLAdmin.Extensions;
using eCLAdmin.Filters;
using eCLAdmin.Models.User;
using eCLAdmin.Services;
using eCLAdmin.ViewModels;
using log4net;
using System.Collections.Generic;
using System.Web.Mvc;

namespace eCLAdmin.Controllers
{
    [SessionCheck]
    public class UserController : BaseController
    {
        private readonly ILog logger = LogManager.GetLogger(typeof(UserController));

        private readonly IUserService userService;

        public UserController(IUserService userService, ISiteService siteService) : base(siteService)
        {
            logger.Debug("Entered UserController(IUserService, ISiteService)");
            this.userService = userService;
        }

        //
        // GET: /ManageAccessControl/
        [EclAuthorize]
        public ActionResult Index()
        {
            return View();
        }

        [EclAuthorize]
        public ActionResult eCoachingAccessControlList()
        {
            logger.Debug("Entered eCoachingAccessControlList");

            return View();
        }

        public JsonResult GetEcoachingAccessControlList()
        {
            List<eCoachingAccessControl> users = userService.GetEcoachingAccessControlList();
            int  totalRecords = users.Count;

            return Json(new { recordsFiltered = totalRecords, recordsTotal = totalRecords, data = users }, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public ActionResult InitEcoachingAccessControlDelete(int rowId)
        {
            eCoachingAccessControlViewModel aclVM = userService.GetEcoachingAccessControl(rowId);
            return PartialView("_DeleteEcoachingAccessControl", aclVM);
        }

        [HttpPost]
        public JsonResult DeleteEcoachingAccessControl(int rowId)
        {
            bool success = userService.DeleteEcoachingAccessControl(rowId, GetUserFromSession().LanId);
            return Json(new { success = success });
        }

        [HttpPost]
        public ActionResult InitEcoachingAccessControlEdit(int rowId)
        {
            eCoachingAccessControlViewModel userVM = userService.GetEcoachingAccessControl(rowId);
            logger.Debug("**** role=" + userVM.Role);
            if (userVM.Role == "DIRPM" || userVM.Role == "DIRPMA")
            {
                userVM.SubcontractorDataAccess = GetSubcontractorDataAccess(userVM.Role);
                userVM.Role = "DIR"; // trick role dropdown to default to "Director"
            }
            userVM.RoleList = userService.GetEcoachingAccessControlRoles().ToSelectListItems(userVM.Role);
            return PartialView("_EditEcoachingAccessControl", userVM);
        }

        private string GetSubcontractorDataAccess(string role)
        {
            var subcontractorDataAccess = "N";
            if (role == "DIRPM")
            {
                subcontractorDataAccess = "V";
            }
            if (role == "DIRPMA")
            {
                subcontractorDataAccess = "SV";
            }

            return subcontractorDataAccess;
        }

        [HttpPost]
        public JsonResult UpdateEcoachingAccessControl(eCoachingAccessControlViewModel userVM)
        {
            logger.Debug("%%%%%%%%%%%%%%%%%%%% Entered UpdateeCoachingAccessControl: " + userVM.LanId + "," + userVM.Role + "," + userVM.SubcontractorDataAccess);

            string result = "datainvalid";
            if (ModelState.IsValid)
            {
                userVM.UpdatedBy = GetUserFromSession().LanId;
                userVM.Role = GetRole(userVM.Role, userVM.SubcontractorDataAccess);
                bool success = userService.UpdateEcoachingAccessControl(userVM);
                result = success ? "success" : "fail";
            }

            return Json(new { result = result, user = userVM }, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public ActionResult InitEcoachingAccessControlAdd()
        {
            logger.Debug("@@@@@@@@@@@@ Entered InitEcoachingAccessControlAdd: ");
            eCoachingAccessControlAddViewModel userVM = new ViewModels.eCoachingAccessControlAddViewModel();
            var siteList = siteService.GetAllActiveSites();
            var defaultSiteIdSelected = siteList[0].Id;
            var roleList = userService.GetEcoachingAccessControlRoles();
            userVM.SiteList = (siteList).ToSelectListItems(defaultSiteIdSelected);
            userVM.NameList = (userService.GetEcoachingAccessControlsToAdd(defaultSiteIdSelected)).ToSelectListItems("");
            userVM.RoleList = userService.GetEcoachingAccessControlRoles().ToSelectListItems(roleList[0].Value);

            return PartialView("_AddEcoachingAccessControl", userVM);
        }

        [HttpPost]
        public JsonResult AddEcoachingAccessControl(eCoachingAccessControlAddViewModel userVM)
        {
            logger.Debug("####################### Entered AddeCoachingAccessControl: " + userVM.LanId + ", " + userVM.SubcontractorDataAccess + ", " + userVM.Role);

            string result = "datainvalid";
            string message = "";
            int rowId = -1;
            if (ModelState.IsValid)
            {
                userVM.UpdatedBy = GetUserFromSession().LanId;
                userVM.Role = GetRole(userVM.Role, userVM.SubcontractorDataAccess);
                rowId = userService.AddEcoachingAccessControl(userVM);
                userVM.RowId = rowId;

                logger.Debug("%%%%%%%%%userVM.Role=" + userVM.Role);

                if (rowId > 0)
                {
                    result = "success";
                    message = "User " + userVM.Name + " has been successfully added.";
                }
                else
                {
                    result = "fail";
                    message = "Failed to add user " + userVM.Name + ".";
                    if (rowId == Constants.DUPLICATE_RECORD)
                    {
                        message = "Requested user " + userVM.Name + " already exists in the system. You may select the existing record and update the Role.";
                    }
                }
            }

            return Json(new { result = result, user = userVM,  msg = message}, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public JsonResult LoadUsersBySite(string siteId)
        {
            logger.Debug("Entered LoadUsersBySite: " + siteId);

            List<NameLanId> userList = userService.GetEcoachingAccessControlsToAdd(siteId);

            // put this in service
            if (userList.Capacity == 0)
            {
                userList.Insert(0, new NameLanId { LanId = "Not.Found", Name = "Nothing found" });
            }

            IEnumerable<SelectListItem> nameLanIds = userList.ToSelectListItems(userList[0].LanId);
            return Json(new SelectList(nameLanIds, "Value", "Text"));
        }

        private string GetRole(string role, string subcontractorDataAccess)
        {
            if (role != "DIR")
            {
                return role;
            }

            if (subcontractorDataAccess == "V")
            {
                role = "DIRPM";
            }
            else if (subcontractorDataAccess == "SV")
            {
                role = "DIRPMA";
            }

            return role;
        }
    }
}