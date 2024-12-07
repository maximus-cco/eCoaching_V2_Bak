﻿using eCLAdmin.Services;
using log4net;
using System.Web.Mvc;

namespace eCLAdmin.Controllers
{
    public class EmployeeLogBaseController : BaseController
    {
        private readonly ILog logger = LogManager.GetLogger(typeof(EmployeeLogBaseController));

        public EmployeeLogBaseController(IEmployeeLogService employeeLogService, ISiteService siteService) : base(employeeLogService, siteService)
        {
            logger.Debug("Entered EmployeeLogBaseController(IEmployeeLogService, ISiteService)");
        }

        protected ActionResult GetLogDetail(int logId, bool isCoaching)
        {
            logger.Debug("Entered GetLogDetail");

            string partialView = "_CoachingDetail";

            if (!isCoaching)
            {
                partialView = "_WarningDetail";
            }

            return PartialView(partialView, employeeLogService.GetLogDetail(logId, isCoaching));
        }
    }
}