using System;
using System.Collections.Generic;
using System.Linq;
using System.Diagnostics;
using System.Configuration;
//using SP = Microsoft.SharePoint.Client;
using Microsoft.SharePoint.Client;
using SharePointToolBox;
using System.Data;
using System.ComponentModel;
using System.Data.SqlClient;

namespace SOIBean
{
    class SOIBean
    {
        protected static Log4NetTraceListener logTrace;

        // Standard SharePoint fields that cannot be written to
        protected static List<string> standardSharePointFields = new List<string> {"ID", "GUID", "Author", "Editor"};

        protected enum Direction { Upload, Download };
        protected enum UploadStatus
        {
            [Description("Loaded")]
            Loaded,
            [Description("Updated")]
            Updated,
            [Description("Duplicate")]
            Duplicate,
            [Description("Load Error")]
            LoadError
        };

        static void Main(string[] args)
        {
            // load configuration files provided at command line
            var appSettings = new AutoInitializingDictionary<string, string>(x => { return null; });
            var connectionSettings = new AutoInitializingDictionary<string, string>(x => { return null; });

            LoadConfiguration(args, appSettings, connectionSettings);
            UpdateLog4NetConfiguration(appSettings);

            // Initialize log4net 
            using (logTrace = new SharePointToolBox.Log4NetTraceListener())
            {
                try
                {
                    logTrace.Name = "SOIBean_EventLog";
                    Trace.Listeners.Add(logTrace);

                    if (appSettings.Count < 1 || connectionSettings.Count < 1)
                    {
                        throw new Exception(String.Format("Error loading application settings from: {0}", args.ToString()));
                    }
                    else
                    {
                        bool listFieldsOnly = bool.Parse(appSettings["ListFieldsOnly"] ?? "false");
                        Direction dir = (Direction)Enum.Parse(typeof(Direction), appSettings["Direction"], true);

                        if (listFieldsOnly)
                        {
                            PrintSharePointFields(appSettings);
                        }
                        else if (dir == Direction.Download)
                        {
                            var allItems = GetSharePointRecords(appSettings);
                            // Save fields to DB
                            WriteRecordsToDB(allItems, appSettings, connectionSettings);
                        }
                        else // upload
                        {
                            var records = GetRecordsFromDB(appSettings, connectionSettings);

                            if (records.Tables.Count > 0 && records.Tables[0].Rows.Count > 0)
                            {
                                bool dupCheck = bool.Parse(appSettings["Upload.CheckForDuplicates"] ?? "false");
                                UploadSharePointRecords(records.Tables[0], dupCheck, appSettings, connectionSettings);
                            }
                        }
                        logTrace.Logger.Info("Success!");
                    }
                }
                catch (Exception ex)
                {
                    logTrace.Logger.Error(ex);

                    logTrace.Logger.Error(String.Format("Failed on exception of type {0} with message {1}", ex.GetType().Name, ex.Message));
                    Environment.ExitCode = 1;

                    logTrace.Logger.Error(appSettings["FailureToken"]);
                }
            }
        }

        /// <summary>
        /// Loads the resulting configuration for the application based on the command arguments given
        /// </summary>
        /// <param name="args">Command line arguments</param>
        /// <param name="appSettings">List of application settings</param>
        /// <param name="connectionSettings">List of application connection strings</param>
        protected static void LoadConfiguration(string[] args, IDictionary<string, string> appSettings, IDictionary<string, string> connectionSettings)
        {
            foreach (var configFile in args)
            {
                if (System.IO.File.Exists(configFile))
                {
                    ExeConfigurationFileMap configMap = new ExeConfigurationFileMap();
                    configMap.ExeConfigFilename = configFile;
                    Configuration config = ConfigurationManager.OpenMappedExeConfiguration(configMap, ConfigurationUserLevel.None);

                    foreach (var cs in config.ConnectionStrings.ConnectionStrings)
                    {
                        if (cs is ConnectionStringSettings)
                        {
                            var css = cs as ConnectionStringSettings;

                            connectionSettings[css.Name] = css.ConnectionString;
                        }
                    }

                    foreach (var key in config.AppSettings.Settings.AllKeys)
                    {
                        appSettings[key] = config.AppSettings.Settings[key].Value;
                    }

                    // Add all credential settings that may be encrypted
                    var credentialSettings = config.GetSection("credentialAppSettings") as System.Configuration.AppSettingsSection;
                    if (credentialSettings != null)
                    {
                        foreach (string key in credentialSettings.Settings.AllKeys)
                        {
                            appSettings[key] = credentialSettings.Settings[key].Value;
                        }
                    }
                }
                else
                {
                    // logger trace not instantiated yet; write to console
                    //Console.Error.WriteLine(String.Format("Could not find specified configuration file {0}", configFile));

                    // Throw exception to avoid issues that can be caused by missing configurations
                    throw new ArgumentException(String.Format("Could not find specified configuration file {0}", configFile));
                }
            }

            // stuff dynamic app settings into main app config settings
            foreach (var k in appSettings.Keys)
            {
                ConfigurationManager.AppSettings[k] = appSettings[k];
            }
        }

        /// <summary>
        /// Updates the necessary log4net configurations based on the application config.
        /// </summary>
        /// <param name="appSettings">List of application settings</param>
        protected static void UpdateLog4NetConfiguration(IDictionary<string, string> appSettings)
        {
            // stuff dynamic app settings into log4net global context
            foreach (var k in appSettings.Keys)
            {
                log4net.GlobalContext.Properties[k] = appSettings[k];
            }

            // reparse log4net configuration
            log4net.Config.XmlConfigurator.Configure();

            // Assuming there isn't more than 1 SmtpAppender
            var appender = log4net.LogManager.GetRepository()
                                             .GetAppenders()
                                             .OfType<log4net.Appender.SmtpAppender>()
                                             .SingleOrDefault();

            if (appender != null && !string.IsNullOrEmpty(appSettings["EmailAuth"]))
            {
                log4net.Appender.SmtpAppender.SmtpAuthentication auth;
                if (Enum.TryParse<log4net.Appender.SmtpAppender.SmtpAuthentication>(appSettings["EmailAuth"], out auth))
                {
                    appender.Authentication = auth;

                    if (auth == log4net.Appender.SmtpAppender.SmtpAuthentication.Basic)
                    {
                        appender.Username = appSettings["EmailUsername"];
                        appender.Password = appSettings["EmailPass"];
                    }
                    appender.ActivateOptions();
                }
                else
                {
                    // logger trace not instantiated yet; write to console
                    Console.Error.WriteLine(String.Format("Could not set log4net email authentication to: {0}", appSettings["EmailAuth"]));
                }
            }
        }

        /// <summary>
        /// Retrieves and reports the fields in the SharePoint list.
        /// </summary>
        /// <param name="appSettings"></param>
        protected static void PrintSharePointFields(IDictionary<string, string> appSettings)
        {
            // Set the SiteURL variable to the value assigned to the ShareURL key in the App.Config file
            // The variable will be the base point to the SharePoint physical site URL, not an actual List -- e.g.:"https://cco.gdit.com/Support/QA-OPS/Leads/"
            var siteURL = appSettings["ShareURL"];
            var authMethod = appSettings["AuthMethod"]?.ToLower();
            ClientContext clientContext = null;

            try
            {
                clientContext = GetSharePointClientContext(authMethod, siteURL, appSettings);
                var site = clientContext.Web;

                /*
                // Retrieve all lists from the server. 
                // should be integrated into app somehow for research purposes.
                clientContext.Load(site.Lists,
                             lists => lists.Include(list => list.Title, // For each list, retrieve Title and Id. 
                                                    list => list.Id));

                // Execute query. 
                clientContext.ExecuteQuery();

                // Enumerate the web.Lists. 
                foreach (List list in site.Lists)
                {
                    Debug.WriteLine(list.Title);
                }
                */

                // Set the siteList variable to the value assigned to the ShareList key in the App.Config file
                // The variable will be the base point to the SharePoint physical site List, not a List 'view' -- "Quality Roster"
                var siteListName = appSettings["ShareList"];
                logTrace.Logger.Info(String.Format("Retrieving fields from SharePoint site {0}, list name \"{1}\".", siteURL, siteListName));
                var siteList = site.Lists.GetByTitle(siteListName);

                // Write out the list of Sharepoint Keys and associated display names for debugging / dev purposes
                FieldCollection collField = siteList.Fields;
                clientContext.Load(collField,
                                    fields => fields.Include(field => field.Title,
                                                            field => field.InternalName,
                                                            field => field.TypeAsString));
                clientContext.ExecuteQuery();

                string fieldFormat = "{0,-40} {1,-50}, {2}" + Environment.NewLine;
                string fieldListing = "The following fields are available in the list:" + Environment.NewLine +
                                        String.Format(fieldFormat, "SharePoint Key", "Display Name", "Field Type") +
                                        String.Format(fieldFormat, "==============", "============", "==========");

                fieldListing += String.Join(string.Empty, collField.ToList().Select(x => String.Format(fieldFormat, x.InternalName, x.Title, x.TypeAsString)).ToList());
                logTrace.Logger.Info(fieldListing);

                /*
                // You can use this code snippet to retrieve the CAML query behind a particular view, if you need to use a specific view
                // Get view query
                View view = siteList.Views.GetByTitle("All Documents");

                clientContext.Load(view);
                clientContext.ExecuteQuery();

                logTrace.Logger.Info("View CAML Query: " + view.ViewQuery);

                // Create a new CAML Query object and store the query from the custom view
                //
                //CamlQuery query = new CamlQuery();
                //query.ViewXml = view.ViewQuery;
                */
            } // end try
            finally
            {
                if (clientContext != null)
                {
                    clientContext.Dispose();
                }
            }
        }

        /// <summary>
        /// Gets all of the records from the SharePoint List URL in the application config file.
        /// </summary>
        /// <param name="appSettings">List of application settings</param>
        /// <returns>List of dictionary entries for key names and field values</returns>
        protected static List<ListItem> GetSharePointRecords(IDictionary<string, string> appSettings)
        {
            var allItems = new List<ListItem>();
            // Set the SiteURL variable to the value assigned to the ShareURL key in the App.Config file
            // The variable will be the base point to the SharePoint physical site URL, not an actual List -- e.g.:"https://cco.gdit.com/Support/QA-OPS/Leads/"
            var siteURL = appSettings["ShareURL"];
            var authMethod = appSettings["AuthMethod"]?.ToLower();
            ClientContext clientContext = null;

            try
            {
                clientContext = GetSharePointClientContext(authMethod, siteURL, appSettings);
                var site = clientContext.Web;

                // Set the siteList variable to the value assigned to the ShareList key in the App.Config file
                // The variable will be the base point to the SharePoint physical site List, not a List 'view' -- "Quality Roster"
                var siteListName = appSettings["ShareList"];
                logTrace.Logger.Info(String.Format("Pulling data from SharePoint site {0}, list name \"{1}\".", siteURL, siteListName));
                var siteList = site.Lists.GetByTitle(siteListName);

                // Actually get the desired records
                var query = new CamlQuery();
                //query.ViewXml = "<?xml version=\"1.0\" encoding=\"utf-8\" ?>\r\n<View>\r\n  <query>\r\n    <Where>\r\n      <Gt>\r\n        <FieldRef Name = \"Modified\" Nullable = \"True\" Type = \"DateTime\" />\r\n        <Value Type = \"DateTime\" >\r\n          <Today OffsetDays = \"-3650\" />\r\n        </Value>\r\n      </Gt>\r\n    </Where>\r\n  </query>\r\n  <RowLimit>500</RowLimit>\r\n</View>\r\n";
                //query.ViewXml = "<?xml version=\"1.0\" encoding=\"utf-8\" ?>\r\n<View>\r\n</View>\r\n";
                query.ViewXml = appSettings["ShareViewXml"];

                // Results may be paged; loop until there are no more pages.
                do
                {
                    ListItemCollection results = siteList.GetItems(query);

                    clientContext.Load(results);
                    clientContext.ExecuteQuery();

                    // Add the current set of ListItems to our master list
                    allItems.AddRange(results);

                    // Reset the current pagination info
                    query.ListItemCollectionPosition = results.ListItemCollectionPosition;
                }
                while (query.ListItemCollectionPosition != null);
            } // end try
            finally
            {
                if (clientContext != null)
                {
                    clientContext.Dispose();
                }
            }

            return allItems;
        }

        /// <summary>
        /// Gets all of the records from the SharePoint List URL in the application config file.
        /// </summary>
        /// <param name="appSettings">List of application settings</param>
        /// <returns>List of dictionary entries for key names and field values</returns>
        protected static void UploadSharePointRecords(DataTable dt, bool dupCheck, IDictionary<string, string> appSettings, IDictionary<string, string> connSettings)
        {
            List<ListItem> allItems = new List<ListItem>();
            if (dupCheck)
            {
                logTrace.Logger.Info("Duplicate record check requested.");
                allItems = GetSharePointRecords(appSettings);
            }

            Dictionary<int, ListItem> allFields = allItems.ToDictionary(Item => Item.Id, Item => Item);

            // Set the SiteURL variable to the value assigned to the ShareURL key in the App.Config file
            // The variable will be the base point to the SharePoint physical site URL, not an actual List -- e.g.:"https://cco.gdit.com/Support/QA-OPS/Leads/"
            var siteURL = appSettings["ShareURL"];
            var authMethod = appSettings["AuthMethod"]?.ToLower();
            ClientContext clientContext = null;
            int insertNum = 0, updateNum = 0, dupNum = 0, errorNum = 0;

            try
            {
                clientContext = GetSharePointClientContext(authMethod, siteURL, appSettings);
                var site = clientContext.Web;

                // Set the siteList variable to the value assigned to the ShareList key in the App.Config file
                // The variable will be the base point to the SharePoint physical site List, not a List 'view' -- "Quality Roster"
                var siteListName = appSettings["ShareList"];
                logTrace.Logger.Info(String.Format("Uploading data to SharePoint site {0}, list name \"{1}\".", siteURL, siteListName));
                var siteList = site.Lists.GetByTitle(siteListName);

                // From the config settings, get the column values that need to be transformed and the fields to extract
                var extractFields = Newtonsoft.Json.JsonConvert.DeserializeObject<List<ExtractField>>(appSettings["ExtractFields"]?.Replace('"', '\''));
                var transforms = Newtonsoft.Json.JsonConvert.DeserializeObject<List<ColumnTransform>>(appSettings["ColumnTransforms"]?.Replace('"', '\''));

                // For duplicate checking / updates, get key fields, unique fields, and updatable fields
                List<ExtractField> keyFields = (dupCheck ? extractFields.Where(x => x.IsSPKey).ToList() : new List<ExtractField>());
                List<ExtractField> uniqueFields = (dupCheck ? extractFields.Where(x => x.IsSPUnique).ToList() : new List<ExtractField>());
                List<ExtractField> updateFields = extractFields.Where(x => x.CanUpdate).Except(keyFields).ToList(); // key field(s) cannot be updated
                // Get unique fields that are NOT updateable
                //List<ExtractField> updUniqueFields = uniqueFields.Intersect(updateFields).ToList();
                List<ExtractField> nonupdUniqueFields = uniqueFields.Except(updateFields).ToList();

                bool allowInsert = true;
                bool allowUpdate = true;
                ListItem existItem = null;
                foreach (DataRow dtRow in dt.Rows)
                {
                    allowInsert = true; // assume we can always insert
                    allowUpdate = updateFields.Count > 0 && keyFields.Count > 0; // can update only if we have key fields telling us what a unique record is AND update fields are specified
                    existItem = null;

                    // Do we need to check for duplicates, or are we allowing updates?
                    if (dupCheck || allowUpdate)
                    {
                        // get key fields and values (transformed) from DB record
                        var keys = new Dictionary<string, object>();
                        string newVal = null;
                        foreach (var k in keyFields)
                        {
                            newVal = ConvertDBValToSharePoint(dt, dtRow, k, transforms);
                            keys.Add(k.KeyName, newVal);
                        }

                        // get unique fields and values (transformed) from DB record
                        var uniqueKeys = new Dictionary<string, object>();
                        newVal = null;
                        foreach (var q in uniqueFields)
                        {
                            newVal = ConvertDBValToSharePoint(dt, dtRow, q, transforms);
                            uniqueKeys.Add(q.KeyName, newVal);
                        }

                        // Try to find a matching SharePoint item first in case this is an update
                        if (allowUpdate)
                        {
                            foreach (var spRecord in allFields)
                            {
                                foreach (var k in keys)
                                {
                                    logTrace.Logger.Debug(String.Format("Item {0} Key {1} DBValue={2} SPValue={3}", spRecord.Key.ToString(), k.Key, k.Value, spRecord.Value[k.Key]?.ToString()));
                                }

                                if (DoSPFieldsMatch(spRecord.Value.FieldValues, keys))
                                {
                                    // All key fields matched - it's an update.
                                    allowInsert = false;
                                    existItem = spRecord.Value;

                                    // Replace the transformed unique keys that cannot be updated with their original values
                                    foreach (var u in nonupdUniqueFields)
                                    {
                                        uniqueKeys[u.KeyName] = existItem[u.KeyName]?.ToString() ?? String.Empty;
                                    }
                                    break;
                                }
                            }
                        }

                        if (dupCheck)
                        {
                            // Check against all existing records in SharePoint
                            foreach (var spRecord in allFields)
                            {
                                if (existItem != null && spRecord.Key == existItem.Id)
                                {
                                    continue;
                                }
                                else if (DoSPFieldsMatch(spRecord.Value.FieldValues, uniqueKeys))
                                {
                                    // Abort this record - duplicate
                                    allowInsert = allowUpdate = false;

                                    // Report duplicate
                                    logTrace.Logger.Debug("Duplicate found! Record ID = " + spRecord.Key);
                                    WriteRecordStatusToDB(dtRow, UploadStatus.Duplicate, existItem, appSettings, connSettings);
                                    dupNum++;
                                    break;
                                }
                            }
                        }
                    } // end dup check or update

                    if (allowUpdate && existItem != null)
                    {
                        // Update the record in SharePoint
                        existItem = UpdateRecordInSharePoint(clientContext, siteList, existItem.Id, updateFields, dt, dtRow, transforms, appSettings, connSettings) ?? existItem;
                        allFields[existItem.Id] = existItem;
                        updateNum++;

                        // Report back to DB as successful update!
                        WriteRecordStatusToDB(dtRow, UploadStatus.Updated, existItem, appSettings, connSettings);
                    }
                    else if (allowInsert)
                    {
                        // Insert record in SharePoint
                        var newItem = InsertRecordInSharePoint(clientContext, siteList, extractFields, dt, dtRow, transforms, appSettings, connSettings);
                        insertNum++;

                        if (dupCheck)
                        {
                            allFields.Add(newItem.Id, newItem);
                        }

                        // Report back to DB as successful insert!
                        WriteRecordStatusToDB(dtRow, UploadStatus.Loaded, newItem, appSettings, connSettings);
                    }
                    else if (!dupCheck)
                    {
                        // Otherwise report unable to update / insert
                        logTrace.Logger.Warn("Record not updated or inserted! Record first column = " + dtRow[0].ToString());
                        WriteRecordStatusToDB(dtRow, UploadStatus.LoadError, existItem, appSettings, connSettings);
                        errorNum++;
                    }
                }

                //logTrace.Logger.Info(String.Format("{0} rows loaded to SharePoint.", rowNum));
            } // end try
            finally
            {
                logTrace.Logger.Info(String.Format("{0} total rows loaded to SharePoint:", (insertNum + updateNum)));
                logTrace.Logger.Info(String.Format("    * New: {0}", insertNum));
                logTrace.Logger.Info(String.Format("    * Updated: {0}", updateNum));
                if (dupCheck)
                {
                    logTrace.Logger.Info(String.Format("    * Ignored as duplicates: {0}", dupNum));
                }
                else
                {
                    logTrace.Logger.Info(String.Format("    * Skipped due to load error: {0}", errorNum));
                }

                if (clientContext != null)
                {
                    clientContext.Dispose();
                }
            }
        }

        /// <summary>
        /// Updates the record in the SharePoint list, trying to report failure back to the database if there is a failure.
        /// </summary>
        /// <param name="clientContext"></param>
        /// <param name="siteList"></param>
        /// <param name="spItemId"></param>
        /// <param name="updateFields"></param>
        /// <param name="dt"></param>
        /// <param name="dtRow"></param>
        /// <param name="transforms"></param>
        /// <param name="appSettings"></param>
        /// <param name="connSettings"></param>
        /// <returns>Updated SharePoint list item, or null if there is a problem</returns>
        private static ListItem UpdateRecordInSharePoint(ClientContext clientContext, List siteList, int spItemId, List<ExtractField> updateFields,
                    DataTable dt, DataRow dtRow, List<ColumnTransform> transforms, IDictionary<string, string> appSettings, IDictionary<string, string> connSettings)
        {
            ListItem existItem = null;
            try
            {
                // Reload the item
                existItem = siteList.GetItemById(spItemId);
                clientContext.Load(existItem);
                clientContext.ExecuteQuery();

                string newVal = null;
                foreach (var u in updateFields)
                {
                    // Ignore any standard SharePoint fields that can't be set
                    if (standardSharePointFields.Contains(u.KeyName)) continue;

                    newVal = ConvertDBValToSharePoint(dt, dtRow, u, transforms);

                    // Cannot update existing value if new value is blank OR if field is specifically flagged to always be updated
                    if (!string.IsNullOrWhiteSpace(newVal) || u.AlwaysUpdate)
                    {
                        existItem[u.KeyName] = newVal;
                    }
                }

                existItem.Update();
                clientContext.ExecuteQuery();
            }
            catch (Exception e)
            {
                // Try to report load failure back to the database
                logTrace.Logger.Error("SharePoint record update failed! Record first column = " + dtRow[0].ToString());
                WriteRecordStatusToDB(dtRow, UploadStatus.LoadError, existItem, appSettings, connSettings);
                throw e;
            }
            return existItem;
        }

        /// <summary>
        /// Inserts the record in the SharePoint list, trying to report failure back to the database if there is a failure.
        /// </summary>
        /// <param name="clientContext"></param>
        /// <param name="siteList"></param>
        /// <param name="extractFields"></param>
        /// <param name="dt"></param>
        /// <param name="dtRow"></param>
        /// <param name="transforms"></param>
        /// <param name="appSettings"></param>
        /// <param name="connSettings"></param>
        /// <returns>New SharePoint list item, or null if there is a problem</returns>
        private static ListItem InsertRecordInSharePoint(ClientContext clientContext, List siteList, List<ExtractField> extractFields,
                    DataTable dt, DataRow dtRow, List<ColumnTransform> transforms, IDictionary<string, string> appSettings, IDictionary<string, string> connSettings)
        {
            ListItem newItem = null;
            try
            {
                ListItemCreationInformation itemCreateInfo = new ListItemCreationInformation();
                newItem = siteList.AddItem(itemCreateInfo);

                string newVal = null;

                // Walk through all extract fields
                foreach (var k in extractFields)
                {
                    // Ignore any standard SharePoint fields that can't be set
                    if (standardSharePointFields.Contains(k.KeyName)) continue;

                    newVal = ConvertDBValToSharePoint(dt, dtRow, k, transforms);
                    newItem[k.KeyName] = newVal;

                    // TODO: Probably need to get a sample of the field types to ensure types match up!
                    // TODO: May need to do conversion to Field Lookup Value or Field User Value!
                    //  Look at EASE SQL Data Extractor and how it matches up types
                }

                newItem.Update();
                clientContext.Load(newItem); // load the newly-created item
                clientContext.ExecuteQuery();
            }
            catch (Exception e)
            {
                logTrace.Logger.Error("SharePoint record insert failed! Record first column = " + dtRow[0].ToString());
                WriteRecordStatusToDB(dtRow, UploadStatus.LoadError, newItem, appSettings, connSettings);
                throw e;
            }
            return newItem;
        }

        /// <summary>
        /// Converts the given database value to a SharePoint record value string for the given extract field.
        /// </summary>
        /// <param name="dt"></param>
        /// <param name="dtRow"></param>
        /// <param name="k"></param>
        /// <param name="transforms"></param>
        /// <returns>n</returns>
        private static string ConvertDBValToSharePoint(DataTable dt, DataRow dtRow, ExtractField k, List<ColumnTransform> transforms)
        {
            string newVal = null;

            if (!dt.Columns.Contains(k.ColumnName))
            {
                throw new Exception(String.Format("The value {0} is not contained in the database record set", k.ColumnName));  //throw exception used for development purposes
            }

            // get a value
            if (k.HasDefault())
            {
                newVal = (dtRow[k.ColumnName] == DBNull.Value ? k.Default : dtRow[k.ColumnName].ToString());
            }
            else
            {
                newVal = (dtRow[k.ColumnName] == DBNull.Value ? null as string : dtRow[k.ColumnName].ToString());
            }

            // run all applicable transformations
            newVal = ColumnTransform.TransformValue(transforms, k.KeyName, newVal);

            // TODO: Future enhancement: May need to get a sample of the field types to ensure types match up.
            // At some point, may need to do a conversion to Field Lookup Value or Field User Value.
            return newVal;
        }

        /// <summary>
        ///  Determines if the given set of fields for a SharePoint record match the values in the provided set of key fields.
        /// </summary>
        /// <param name="spFields">Dictionary of key / value pairs for the SharePoint record</param>
        /// <param name="keys">Dictionary of key / value pairs to match in the record</param>
        /// <returns>True if the record matches the given keys; false otherwise</returns>
        private static bool DoSPFieldsMatch(Dictionary<string,object> spFields, Dictionary<string, object> keys)
        {
            var keyfields = spFields.Where(x => keys.ContainsKey(x.Key) &&
                        (keys[x.Key]?.ToString() ?? String.Empty).Equals(x.Value?.ToString() ?? String.Empty, StringComparison.InvariantCultureIgnoreCase)).ToList();

            return (keyfields.Count == keys.Count);
        }

        /// <summary>
        /// Gets the SharePoint client context based on the desired authentication method.
        /// </summary>
        /// <param name="authMethod"></param>
        /// <param name="siteURL"></param>
        /// <param name="appSettings"></param>
        /// <returns></returns>
        private static Microsoft.SharePoint.Client.ClientContext GetSharePointClientContext(string authMethod, string siteURL,
            IDictionary<string, string> appSettings)
        {
            ClientContext clientContext = null;

            if (authMethod == "clientid")
            {
                // CLIENT ID / SECRET
                //Get the realm for the URL
                var siteUri = new Uri(siteURL);
                string realm = TokenHelper.GetRealmFromTargetUrl(siteUri);

                //Get the access token for the URL.  
                //   Requires this app to be registered with the tenant
                string accessToken = TokenHelper.GetAppOnlyAccessToken(
                    TokenHelper.SharePointPrincipal,
                    siteUri.Authority, realm).AccessToken;

                clientContext = TokenHelper.GetClientContextWithAccessToken(siteUri.ToString(), accessToken);
            }
            else if (authMethod == "windows")
            {
                clientContext = new ClientContext(siteURL);

                // Use default authentication mode
                clientContext.AuthenticationMode = ClientAuthenticationMode.Default;
            }
            else if (authMethod == "userpass") // this is a legacy authentication method
            {
                clientContext = new ClientContext(siteURL);

                // Use default authentication mode
                clientContext.AuthenticationMode = ClientAuthenticationMode.Default;
                var accountName = appSettings["SPOAccount"];
                var securePass = GetSPOSecureStringPassword(appSettings["SPOPassword"]);

                // Specify the credentials for the account that will execute the request
                var creds = new Microsoft.SharePoint.Client.SharePointOnlineCredentials(accountName, securePass);
                clientContext.Credentials = creds;
            }
            else
            {
                throw new NotSupportedException("Unsupported SharePoint authorization method: " + authMethod);
            }
            return clientContext;
        }

        // Returns a secure string for the given plain string password
        private static System.Security.SecureString GetSPOSecureStringPassword(string pwdPlain)
        {
            try
            {
                Console.WriteLine(" - > Entered GetSPOSecureStringPassword()");
                var secureString = new System.Security.SecureString();
                foreach (char c in pwdPlain)
                {
                    secureString.AppendChar(c);
                }
                Console.WriteLine(" - > Constructed the secure password");

                return secureString;
            }
            catch
            {
                throw;
            }
        }

        /// <summary>
        /// Writes the given list of SharePoint records to the given database / path.
        /// Only desired fields listed in the application config will be written.
        /// </summary>
        /// <param name="allFields">List of records to write</param>
        /// <param name="appSettings">List of application settings</param>
        //protected static void WriteRecordsToDB(List<Dictionary<string, object>> allFields, IDictionary<string, string> appSettings, IDictionary<string, string> connectionSettings)
        protected static void WriteRecordsToDB(List<ListItem> allItems, IDictionary<string, string> appSettings, IDictionary<string, string> connectionSettings)
        {
            // db info
            List<Dictionary<string, object>> allFields = allItems.ToList().Select(x => x.FieldValues).ToList();
            var connectionStringKey = appSettings["ConnectionStringKey"];
            var connString = connectionSettings[connectionStringKey];

            // From the config settings, get the column values that need to be transformed and the fields to extract
            var extractFields = Newtonsoft.Json.JsonConvert.DeserializeObject<List<ExtractField>>(appSettings["ExtractFields"]?.Replace('"', '\''));
            var transforms = Newtonsoft.Json.JsonConvert.DeserializeObject<List<ColumnTransform>>(appSettings["ColumnTransforms"]?.Replace('"', '\''));
            var tableType = Helpers.GetTableType(connString, appSettings["TableTypeName"]);

            int rowNum = 0;
            foreach (var spRow in allFields)
            {
                var dbRow = tableType.NewRow();

                //spRow.Keys.ToList().ForEach(spKey =>
                //{
                //    if ((spRow[spKey] ?? String.Empty) is FieldLookupValue) spRow[spKey] = (spRow[spKey] as FieldLookupValue).LookupValue;
                //    if ((spRow[spKey] ?? String.Empty) is FieldUserValue) spRow[spKey] = (spRow[spKey] as FieldUserValue).LookupValue;
                //});

                // Walk through all extract fields
                foreach (var k in extractFields)
                {
                    if (!spRow.Keys.Contains(k.KeyName))
                    {
                        throw new Exception(String.Format("The value {0} is not contained in the SharePoint List", k.KeyName));  //throw exception used for development purposes
                    }

                    // First handle lookup values
                    if ((spRow[k.KeyName] ?? String.Empty) is FieldUserValue) spRow[k.KeyName] = FlattenLookup(spRow[k.KeyName] as FieldUserValue, k);
                    if ((spRow[k.KeyName] ?? String.Empty) is FieldLookupValue) spRow[k.KeyName] = FlattenLookup(spRow[k.KeyName] as FieldLookupValue, k);

                    string newVal = null;

                    // get a value
                    if (k.HasDefault())
                    {
                        newVal = (spRow[k.KeyName] == null ? k.Default : spRow[k.KeyName].ToString());
                    }
                    else
                    {
                        newVal = spRow[k.KeyName]?.ToString();
                    }

                    // run all applicable transformations
                    newVal = ColumnTransform.TransformValue(transforms, k.KeyName, newVal);

                    // verify the table type contains the column
                    if (!tableType.Columns.Contains(k.ColumnName))
                        throw new Exception(String.Format("The value {0} is not contained in the Table Type", k.ColumnName));

                    // convert to the target type and add to the new row, or alternately fail, write debug message and set to null
                    var dbCol = tableType.Columns[k.ColumnName];
                    var tc = TypeDescriptor.GetConverter(dbCol.DataType);
                    try
                    {
                        bool estn = false;
                        if ((newVal == null) ||
                            (dbCol.DataType != typeof(string) && string.IsNullOrEmpty(newVal)) ||
                            (dbCol.DataType == typeof(string) && string.IsNullOrEmpty(newVal) && bool.TryParse(appSettings["ConvertEmptyStringToNull"], out estn) && estn))
                        {
                            dbRow[dbCol] = DBNull.Value;
                        }
                        else
                        {
                            if (dbCol.DataType == typeof(string) && (newVal ?? string.Empty).Length > dbCol.MaxLength)
                            {
                                logTrace.Logger.Warn(String.Format("String value [{0}] on row {1} from SharePoint column [{2}] is longer than max length {3}", (newVal ?? string.Empty), rowNum, k.KeyName, dbCol.MaxLength));
                            }
                            dbRow[dbCol] = tc.ConvertFromInvariantString(newVal);
                        }
                    }
                    catch
                    {
                        logTrace.Logger.Warn(String.Format("Could not convert value {0} into type {1} on row {2} from SharePoint column {3}", newVal != null ? "[" + newVal + "]" : "NULL", dbCol.DataType.Name, rowNum, k.KeyName));
                        dbRow[dbCol] = DBNull.Value;
                    }
                }

                tableType.Rows.Add(dbRow);
                rowNum++;
            } // End walking through all fields

            logTrace.Logger.Info(String.Format("{0} rows loaded from SharePoint.", rowNum));
            logTrace.Logger.Info(String.Format("Saving to database..."));

            using (SqlConnection conn = new SqlConnection(connString))
            {
                Exception sqlException = null;

                conn.FireInfoMessageEventOnUserErrors = true;
                conn.InfoMessage += new SqlInfoMessageEventHandler((o, smea) =>
                {
                    foreach (SqlError e in smea.Errors)
                    {
                        var msg = String.Format("Database Message Line {1} Message {0}", e.Message, e.LineNumber);

                        if (e.Class > 10)
                        {
                            sqlException = new Exception(msg);
                        }
                        else
                        {
                            logTrace.Logger.Debug(msg);
                        }
                    }
                });

                conn.Open();
                var cmd = new SqlCommand(appSettings["ProcedureName"], conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@records", tableType);
                cmd.Parameters.AddWithValue("@list_identifier", appSettings["ProcedureListID"]);
                cmd.Parameters.AddWithValue("@is_truncate", appSettings["ProcedureTruncate"]);

                cmd.ExecuteNonQuery();
                if (sqlException != null)
                {
                    throw sqlException;
                }
            }
        }

        private static object FlattenLookup<T>(T lookup, ExtractField k) where T : FieldLookupValue
        {
            if (k.LookupId)
            {
                return lookup.LookupId;
            }
            else
            {
                return lookup.LookupValue;
            }
        }

        /// <summary>
        /// Writes the given list of SharePoint records to the given database / path.
        /// Only desired fields listed in the application config will be written.
        /// </summary>
        /// <param name="allFields">List of records to write</param>
        /// <param name="appSettings">List of application settings</param>
        protected static DataSet GetRecordsFromDB(IDictionary<string, string> appSettings, IDictionary<string, string> connectionSettings)
        {
            // db info
            var connectionStringKey = appSettings["ConnectionStringKey"];
            var connString = connectionSettings[connectionStringKey];

            var siteURL = appSettings["ShareURL"];
            var siteListName = appSettings["ShareList"];
            logTrace.Logger.Info(String.Format("Retrieving records from database for target SharePoint site {0}, list name \"{1}\"...", siteURL, siteListName));

            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(connString))
            {
                Exception sqlException = null;
                conn.ConfigureErrorMessageEvent(sqlException, logTrace);

                conn.Open();
                var cmd = new SqlCommand(appSettings["ProcedureName"], conn);
                cmd.CommandType = CommandType.StoredProcedure;

                // Get the data
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(ds);

                if (sqlException != null)
                {
                    throw sqlException;
                }

                int rowNum = (ds.Tables.Count < 1 ? 0 : ds.Tables[0].Rows.Count);
                logTrace.Logger.Info(String.Format("{0} records retrieved from the database.", rowNum));
            } // end using

            return ds;
        }

        /// <summary>
        /// Writes the given database row to the given database / path.
        /// </summary>
        /// <param name="dtSourceRow">Source data row to copy</param>
        /// <param name="status">Upload status of the record</param>
        /// <param name="spRecord">SharePoint record</param>
        /// <param name="appSettings">List of application settings</param>
        /// <param name="connectionSettings">List of all connection string settings</param>
        protected static void WriteRecordStatusToDB(DataRow dtSourceRow, UploadStatus status, ListItem spRecord, 
                IDictionary<string, string> appSettings, IDictionary<string, string> connectionSettings)
        {
            // db info
            var connectionStringKey = appSettings["ConnectionStringKey"];
            var connString = connectionSettings[connectionStringKey];

            // From the config settings, get the table type and the field in the type that is the status field
            var rptStatusField = appSettings["Upload.ReportStatusField"];
            var rptIdField = appSettings["Upload.ReportIdField"];
            var rptGuidField = appSettings["Upload.ReportGuidField"];
            var tableType = Helpers.GetTableType(connString, appSettings["TableTypeName"]);

            if (!tableType.Columns.Contains(rptStatusField))
            {
                throw new Exception(String.Format("The status field [{0}] is not contained in the table type [{1}].", rptStatusField, tableType));  //throw exception used for development purposes
            }
            else if (!String.IsNullOrWhiteSpace(rptIdField) && !tableType.Columns.Contains(rptIdField))
            {
                throw new Exception(String.Format("The ID field [{0}] is not contained in the table type [{1}].", rptIdField, tableType));  //throw exception used for development purposes
            }
            else if (!String.IsNullOrWhiteSpace(rptGuidField) && !tableType.Columns.Contains(rptGuidField))
            {
                throw new Exception(String.Format("The GUID field [{0}] is not contained in the table type [{1}].", rptGuidField, tableType));  //throw exception used for development purposes
            }

            var dbRow = tableType.NewRow();

            // Copy over column values
            foreach (DataColumn col in dtSourceRow.Table.Columns)
            {
                // Table type should contain every column coming from the source
                if (!tableType.Columns.Contains(col.ColumnName))
                {
                    throw new Exception(String.Format("The column [{0}] is not contained in the table type [{1}].", col.ColumnName, tableType));  //throw exception used for development purposes
                }

                dbRow[col.ColumnName] = dtSourceRow[col.ColumnName];
            }

            // Set report-back information
            dbRow[rptStatusField] = status.ToDescription();
            if (!String.IsNullOrWhiteSpace(rptIdField)) dbRow[rptIdField] = (object)spRecord?.Id ?? DBNull.Value;
            if (!String.IsNullOrWhiteSpace(rptGuidField)) dbRow[rptGuidField] = spRecord?["GUID"] ?? DBNull.Value;
            tableType.Rows.Add(dbRow);

            logTrace.Logger.Debug(String.Format("Saving record status to database..."));

            using (SqlConnection conn = new SqlConnection(connString))
            {
                Exception sqlException = null;
                conn.ConfigureErrorMessageEvent(sqlException, logTrace);

                conn.Open();
                var cmd = new SqlCommand(appSettings["Upload.ReportProcedureName"], conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@records", tableType);

                cmd.ExecuteNonQuery();
                if (sqlException != null)
                {
                    throw sqlException;
                }
            }
            logTrace.Logger.Debug(String.Format("Record status successfully saved!"));
        }
    } // end class
}
