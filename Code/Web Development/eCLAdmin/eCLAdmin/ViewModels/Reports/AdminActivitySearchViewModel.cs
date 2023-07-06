using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace eCLAdmin.ViewModels.Reports
{
    public class AdminActivitySearchViewModel : BaseViewModel, IValidatableObject
    {
        public IEnumerable<ValidationResult> Validate(ValidationContext validationContext)
        {
            if (String.IsNullOrEmpty(this.StartDate))
            {
                var temp = new[] { "StartDate" };
                yield return new ValidationResult("Start Date is required.", temp);
            }

            if (String.IsNullOrEmpty(this.EndDate))
            {
                var temp = new[] { "EndDate" };
                yield return new ValidationResult("End Date is required.", temp);
            }

            if (this.SelectedTypeId == -2)
            {
                var temp = new[] { "SelectedTypeId" };
                yield return new ValidationResult("Log Type is required.", temp);
            }

            if (String.Equals(this.SelectedAction, "Select Action"))
            {
                var temp = new[] { "SelectedAction" };
                yield return new ValidationResult("Action is required.", temp);
            }

            if (String.Equals(this.SelectedLog, "Select Log"))
            {
                var temp = new[] { "SelectedLog" };
                yield return new ValidationResult("Log is required.", temp);
            }
        }
    }
}