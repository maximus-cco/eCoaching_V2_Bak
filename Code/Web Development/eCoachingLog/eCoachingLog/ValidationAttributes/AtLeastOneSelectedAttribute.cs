using eCoachingLog.ViewModels;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace eCoachingLog.ValidationAttributes
{
    //[AttributeUsage(AttributeTargets.Class, AllowMultiple = true)]
    public class AtLeastOneSelectedAttribute : ValidationAttribute//, IClientValidatable
    {
        protected override ValidationResult IsValid(object value, ValidationContext validationContext)
        {
            NewSubmissionViewModel vm = (NewSubmissionViewModel)validationContext.ObjectInstance;
            //int mId = vm.ModuleId;

            if (value != null)
            {
                DateTime _birthJoin = Convert.ToDateTime(value);
                if (_birthJoin > DateTime.Now)
                {
                    return new ValidationResult("Birth date can not be greater than current date.");
                }
            }

            return ValidationResult.Success;
        }

        //public IEnumerable<ModelClientValidationRule> GetClientValidationRules(ModelMetadata metadata, ControllerContext context)
        //{
        //    ModelClientValidationRule mvr = new ModelClientValidationRule();
        //    mvr.ErrorMessage = "Birth Date can not be greater than current date";
        //    mvr.ValidationType = "validbirthdate";

        //    return new[] { mvr };
        //}
    }
}