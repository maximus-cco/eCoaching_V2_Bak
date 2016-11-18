using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace eCLAdmin.Models.Dashboard
{
    // http://morrisjs.github.io/morris.js/bars.html
    // The data to plot. This is an array of objects, containing x and y
    // attributes as described by the xkey and ykeys options.
    // Note: the order in which you  provide the data is the order in which 
    // the bars are displayed.
    public class ChartBase
    {
        // X labels, such as 'Week1', 'Week2', ... 
        public string x { get; set; }
    }
}