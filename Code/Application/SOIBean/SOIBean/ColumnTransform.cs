using System.Collections.Generic;

namespace SOIBean
{
    public class ColumnTransform
    {
        public string ColumnName { get; set; }
        public string Find { get; set; }
        public string Replace { get; set; }

        /// <summary>
        /// Checks the given column value to see if it needs to be transformed.
        /// should this be a method on ColumnTransform?
        /// </summary>
        /// <param name="transforms">List of transforms that need to occur</param>
        /// <param name="colName">Column name to check</param>
        /// <param name="colValue">Value of that column that may need to be transformed</param>
        /// <returns>Transformed value if applicable; else original column value</returns>
        public static string TransformValue(List<ColumnTransform> transforms, string colName, string colValue)
        {
            string transformValue = colValue;
            foreach (var t in transforms)
            {
                if (colName == t.ColumnName)
                {
                    if (colValue == t.Find)
                    {
                        transformValue = t.Replace;
                        break;
                    }
                }
            }
            return transformValue;
        }
    }
}
