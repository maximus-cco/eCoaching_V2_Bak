<%@ page title="" language="vb" autoeventwireup="false" masterpagefile="~/Site3.Master"
    codebehind="review2.aspx.vb" inherits="eCoachingFixed.review2" %>

<%@ register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="asp" %>
<%@ outputcache location="None" varybyparam="None" %>
<asp:content id="Content1" contentplaceholderid="HeadContent" runat="server">
    <!-- Page CSS -->
    <style type="text/css">
        .EMessage {
            display: block;
        }

        .wrapped {
            /* wrap long urls */
            white-space: pre; /* CSS 2.0 */
            white-space: pre-wrap; /* CSS 2.1 */
            white-space: pre-line; /* CSS 3.0 */
            white-space: -pre-wrap; /* Opera 4-6 */
            white-space: -o-pre-wrap; /* Opera 7 */
            white-space: -moz-pre-wrap; /* Mozilla */
            white-space: -hp-pre-wrap; /* HP Printers */
            word-wrap: break-word; /* IE 5+ */ /* specific width */
            width: 470px;
        }

        .wrapped2 {
            /* wrap long urls */
            white-space: pre; /* CSS 2.0 */
            white-space: pre-wrap; /* CSS 2.1 */
            white-space: pre-line; /* CSS 3.0 */
            white-space: -pre-wrap; /* Opera 4-6 */
            white-space: -o-pre-wrap; /* Opera 7 */
            white-space: -moz-pre-wrap; /* Mozilla */
            white-space: -hp-pre-wrap; /* HP Printers */
            word-wrap: break-word; /* IE 5+ */ /* specific width */
            width: 10px;
        }

        body {
            padding: 10px;
        }
    </style>
</asp:content>

<asp:content id="Content4" contentplaceholderid="ContentPlaceHolder3" runat="server">
    <asp:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" AsyncPostBackTimeout="1200"></asp:ToolkitScriptManager>
    <asp:SqlDataSource ID="SqlDataSource14" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
        SelectCommand="EC.sp_Check_AgentRole" SelectCommandType="StoredProcedure" OnSelected="ARC_Selected">
        <SelectParameters>
            <asp:Parameter Name="nvcLanID" Type="String" />
            <asp:Parameter Name="nvcRole" Type="String" />
            <asp:Parameter Direction="ReturnValue" Name="Indirect@return_value" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:GridView ID="GridView1" runat="server" DataSourceID="SqlDataSource14" Visible="true">
    </asp:GridView>

    <asp:Label ID="Label241" runat="server" Text="" Visible="false"></asp:Label>
    
    <asp:SqlDataSource ID="SqlDataSource4" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
        SelectCommand="EC.sp_Check_AgentRole" SelectCommandType="StoredProcedure" OnSelected="SRMGR_Selected">
        <SelectParameters>
            <asp:Parameter Name="nvcLanID" Type="String" />
            <asp:Parameter Name="nvcRole" Type="String" />
            <asp:Parameter Direction="ReturnValue" Name="Indirect@return_value" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:GridView ID="GridView5" runat="server" DataSourceID="SqlDataSource4" Visible="true">
    </asp:GridView>
    
    <asp:Label ID="Label31" runat="server" Text="" Visible="false"></asp:Label>
    
    <asp:DataList ID="DataList1" runat="server" DataSourceID="SqlDataSource6" Visible="False">
        <ItemTemplate>
            <asp:Label ID="Label30" runat="server" Text="strFormStatus:" Visible="false"></asp:Label>
            <asp:Label ID="LabelStatus" runat="server" Text='<%# Eval("strFormStatus") %>' Visible="False" />
        </ItemTemplate>
    </asp:DataList>

    <asp:SqlDataSource ID="SqlDataSource6" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
        SelectCommandType="StoredProcedure" SelectCommand="EC.sp_SelectRecordStatus">
        <SelectParameters>
            <asp:QueryStringParameter Name="strFormID" QueryStringField="id" Type="String" Direction="Input" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="SqlDataSource3" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
        SelectCommand="EC.sp_Whoisthis" SelectCommandType="StoredProcedure">
        <SelectParameters>
            <asp:Parameter Name="strUserin" Type="String" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:GridView ID="GridView2" runat="server" DataSourceID="SqlDataSource3" AutoGenerateColumns="False" EnableModelValidation="True" Visible="false">
        <Columns>
            <asp:TemplateField HeaderText="" ItemStyle-HorizontalAlign="Center">
                <ItemTemplate>
                    <asp:Label ID="Flow" runat="server" Text='<%# Eval("Flow") %>' Visible="false"></asp:Label>
                </ItemTemplate>
                <ItemStyle HorizontalAlign="Center"></ItemStyle>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
    <br />
    <asp:Label ID="Label28" runat="server" Text="Please note that all fields are required. Double-check your work to ensure accuracy." CssClass="sidelabel"></asp:Label>
    <br />
    <br />
    <asp:Label ID="Label29" runat="server" Text="Coaching Reason(s):" CssClass="sidelabel"></asp:Label>
    <br />
     <asp:GridView ID="GridView4" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSource8"
        Width="98%" ShowHeader="False" BackColor="White" BorderColor="White" BorderStyle="none"
        BorderWidth="0px" CellPadding="3" CellSpacing="1" GridLines="None">
        <Columns>
            <asp:BoundField DataField="CoachingReason" ItemStyle-CssClass="review">
                <ItemStyle CssClass="review"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="SubCoachingReason">
                <ItemStyle CssClass="review"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="value">
                <ItemStyle CssClass="review"></ItemStyle>
            </asp:BoundField>
        </Columns>
        <RowStyle BackColor="#DEDFDE" ForeColor="Black" />
    </asp:GridView>
    <asp:SqlDataSource ID="SqlDataSource8" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
        SelectCommand="EC.sp_SelectReviewFrom_Coaching_Log_Reasons" SelectCommandType="StoredProcedure"
        DataSourceMode="DataReader" EnableViewState="True" ViewStateMode="Enabled">
        <SelectParameters>
            <asp:QueryStringParameter DefaultValue="" Name="strFormIDin" QueryStringField="id"
                Type="String" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
        SelectCommand="EC.sp_SelectReviewFrom_Coaching_Log" SelectCommandType="StoredProcedure">
        <SelectParameters>
            <asp:QueryStringParameter DefaultValue="" Name="strFormIDin" QueryStringField="id"
                Type="String" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <asp:ListView ID="ListView2" runat="server" DataSourceID="SqlDataSource2" EnableModelValidation="True" DataKeyNames="numID" Visible="false">
                <EmptyDataTemplate>
                    <span>No data was returned.</span></EmptyDataTemplate>
                <ItemTemplate>
                    <asp:Panel ID="Panel33" runat="server" Visible="false">
                        <asp:Label ID="Label98" runat="server" Text="Details of the behavior being coached:" Font-Names="Calibri" Font-Bold="True" />
                        <br />
                        <asp:Table ID="Table7" CellPadding="0" CellSpacing="0" runat="server" Style="border: 1px solid #cccccc; background-color: #f1f1ec; width: 490px;" class="review">
                            <asp:TableRow>
                                <asp:TableCell CssClass="wrapped">&nbsp;
                                    <asp:Label ID="Label99" runat="server" Text='<%# Eval(server.htmldecode("txtDescription")) %>'></asp:Label>
                                </asp:TableCell>
                            </asp:TableRow>
                        </asp:Table>
                    </asp:Panel>
                    <asp:Label ID="Label43" runat="server" Text="Coaching Opportunity was a confirmed Customer Service Escalation" Font-Bold="True" Visible="false"></asp:Label>
                    <asp:Panel ID="Panel35" runat="server" Visible="false">
                            <asp:Panel ID="Panel36" runat="server" Visible="false">
                                <asp:Label ID="Label102" runat="server" Text="Management Notes:" Font-Names="Calibri" Font-Bold="True"></asp:Label>
                                <br />
                                <asp:Table ID="Table8" CellPadding="0" CellSpacing="0" runat="server" Style="border: 1px solid #cccccc; background-color: #f1f1ec; width: 490px;" class="review">
                                    <asp:TableRow>
                                        <asp:TableCell CssClass="wrapped">&nbsp;
                                            <asp:Label ID="Label103" runat="server" Text='<%# Eval(server.htmldecode("txtMgrNotes")) %>' class="review"></asp:Label>
                                        </asp:TableCell>
                                    </asp:TableRow>
                                </asp:Table>
                            </asp:Panel>
                            <asp:Label ID="Label91" runat="server" Text="Coaching Opportunity was not a confirmed Customer Service Escalation" Font-Bold="True"></asp:Label>
                    </asp:Panel>
                    <asp:Panel ID="Panel23" runat="server" Visible="false">
                        <asp:Label ID="Label71" runat="server" Text="Coaching Notes:" Font-Names="Calibri" Font-Bold="True"></asp:Label>
                        <br />
                        <asp:Table ID="Table9" CellPadding="0" CellSpacing="0" runat="server" Style="border: 1px solid #cccccc; background-color: #f1f1ec; width: 490px;" class="review">
                            <asp:TableRow>
                                <asp:TableCell CssClass="wrapped">&nbsp;
                                    <asp:Label ID="Label72" runat="server" Text='<%# Eval(server.htmldecode("txtCoachingNotes")) %>'></asp:Label>
                                </asp:TableCell>
                            </asp:TableRow>
                        </asp:Table>
                    </asp:Panel>
                    <asp:Label ID="Label80" runat="server" Text="Employee Review Information:" Font-Names="Calibri" Font-Bold="True" />
                    <br />
                    <asp:Label ID="Label97" runat="server" Text='<%# Eval(server.htmldecode("strCSRName")) %>' Font-Names="Calibri" />
                    <br />
                    <asp:Label ID="Label100" runat="server" Text="Reviewed and acknowledged coaching opportunity on" Font-Names="Calibri" Font-Bold="False" />&nbsp;
                    <asp:Label ID="Label101" runat="server" Text='<%# Eval("CSRReviewAutoDate") %>' Font-Names="Calibri" />
                    <br />
                    <asp:Panel ID="Panel41" runat="server" Visible="false" Style="margin-top: 5px;">
                        <asp:Label ID="Label152" runat="server" Text="Supervisor Review Information:" Font-Names="Calibri" Font-Bold="True" />
                        <br />
                        <asp:Label ID="Label153" runat="server" Text='<%# Eval(server.htmldecode("strReviewer")) %>' Font-Names="Calibri" />
                        <br />
                        <asp:Label ID="Label154" runat="server" Text="Reviewed and acknowledged Quality Monitor on" Font-Names="Calibri" Font-Bold="False" />&nbsp;
                        <asp:Label ID="Label155" runat="server" Text='<%# Eval("SupReviewedAutoDate") %>' Font-Names="Calibri" />
                        <br />
                    </asp:Panel>
                    <asp:Panel ID="Panel32" runat="server" Visible="false" Style="margin-top: 5px;">
                        <asp:Label ID="Label94" runat="server" Text="Employee Comments/Feedback:" Font-Names="Calibri" Font-Bold="True"></asp:Label>
                        <br />
                        <asp:Table ID="Table10" CellPadding="0" CellSpacing="0" runat="server" Style="border: 1px solid #cccccc; background-color: #f1f1ec; width: 490px;" class="review">
                            <asp:TableRow>
                                <asp:TableCell CssClass="wrapped">&nbsp;
                                    <asp:Label ID="Label95" runat="server" Text='<%# Eval(server.htmldecode("txtCSRComments")) %>'></asp:Label>
                                </asp:TableCell>
                            </asp:TableRow>
                        </asp:Table>
                    </asp:Panel>
                    <asp:Label ID="Label96" runat="server" Text='<%# Eval("strFormID") %>' Visible="false" />
                    <asp:Label ID="Label50" runat="server" Text='<%# Eval("strFormStatus") %>' Visible="false" />
                    <asp:Label ID="Label51" runat="server" Text='<%# Eval("SubmittedDate") %>' Visible="false" />
                    <asp:Label ID="Label52" runat="server" Text='<%# Eval("CoachingDate") %>' Visible="false" />
                    <asp:Label ID="Label53" runat="server" Text='<%# Eval("strSource") %>' Visible="false" />
                    <asp:Label ID="Label33" runat="server" Text='<%# Eval("isIQS") %>' Visible="false" />
                    <asp:Label ID="Label54" runat="server" Text='<%# Eval("EventDate") %>' Visible="false" />
                    <asp:Label ID="Label55" runat="server" Text='<%# Eval("strCSRSite") %>' Visible="false" />
                    <asp:Label ID="Label56" runat="server" Text='<%# Eval("strVerintID") %>' Visible="false" />
                    <asp:Label ID="Label57" runat="server" Text='<%# Eval("strBehaviorAnalyticsID") %>' Visible="false" />
                    <asp:Label ID="Label58" runat="server" Text='<%# Eval("strNGDActivityID") %>' Visible="false" />
                    <asp:Label ID="Label158" runat="server" Text='<%# Eval("strUCID") %>' Visible="false" />
                    <asp:Label ID="Label159" runat="server" Text='<%# Eval("VerintFormName") %>' Visible="false" />
                    <asp:Label ID="Label59" runat="server" Text='<%# Eval("strCSRName") %>' Visible="false" />
                    <asp:Label ID="Label49" runat="server" Text='<%# Eval("strEmpLanID") %>' Visible="false" />
                    <asp:Label ID="Label60" runat="server" Text='<%# Eval("strCSRSupName") %>' Visible="false" />
                    <asp:Label ID="Label48" runat="server" Text='<%# Eval("strCSRSup") %>' Visible="false" />
                    <asp:Label ID="Label61" runat="server" Text='<%# Eval("strCSRMgrName") %>' Visible="false" />
                    <asp:Label ID="Label47" runat="server" Text='<%# Eval("strCSRMgr") %>' Visible="false" />
                    <asp:Label ID="Label1" runat="server" Text='<%# Eval("strSubmitter") %>' Visible="false" />
                    <asp:Label ID="Label121" runat="server" Text='<%# Eval("strSubmitterName") %>' Visible="false" />
                    <asp:Label ID="Label62" runat="server" Text='<%# Eval("strFormType") %>' Visible="false" />
                    <asp:Label ID="Label67" runat="server" Text='<%# Eval("isVerintMonitor") %>' Visible="false" />
                    <asp:Label ID="Label68" runat="server" Text='<%# Eval("isBehaviorAnalyticsMonitor") %>' Visible="false" />
                    <asp:Label ID="Label69" runat="server" Text='<%# Eval("isNGDActivityID") %>' Visible="false" />
                    <asp:Label ID="Label157" runat="server" Text='<%# Eval("isUCID") %>' Visible="false" />
                    <asp:Label ID="Label45" runat="server" Text='<%# Eval("strCSRSup") %>' Visible="false" />
                    <asp:Label ID="Label75" runat="server" Text='<%# Eval("strCSRMgr") %>' Visible="false" />
                    <asp:Label ID="Label88" runat="server" Text='<%# Eval("strEmpLanID") %>' Visible="false" />
                    <asp:Label ID="Label89" runat="server" Text='<%# Eval("isCSE") %>' Visible="false" />
                    <asp:Label ID="Label90" runat="server" Text='<%# Eval("isCSRAcknowledged") %>' Visible="false" />
                    <asp:Label ID="Label104" runat="server" Text='<%# Eval("CSRReviewAutoDate") %>' Visible="false" />
                    <asp:Label ID="Label105" runat="server" Text='<%# Eval("txtcoachingnotes") %>' Visible="false" />
                    <asp:Label ID="Label106" runat="server" Text='<%# Eval("txtMgrNotes") %>' Visible="false" />
                    <asp:Label ID="Label107" runat="server" Text='<%# Eval("Customer Service Escalation") %>' Visible="false" />
                    <asp:Label ID="Label32" runat="server" Text='<%# Eval("strReviewer") %>' Visible="false" />
                    <%-- The Submitter's employee ID in coaching_log table --%>
                    <asp:Label ID="SubmitterEmployeeID" runat="server" Text='<%# Eval("strSubmitterID") %>' Visible="false" />
                    <%-- The employee's employee ID in coaching_log table--%>
                    <asp:Label ID="EmployeeID" runat="server" Text='<%# Eval("strEmpID") %>' Visible="false" />
                    <%-- The employee's Manager employee ID in employee_hierarchy table. --%>
                    <asp:Label ID="HierarchyMgrEmployeeID" runat="server" Text='<%# Eval("strCSRMgrID")%>' Visible="false" />
                    <%-- The employee's Supervisor employee ID in employee_hierarchy table. --%>
                    <asp:Label ID="HierarchySupEmployeeID" runat="server" Text='<%# Eval("strCSRSupID")%>' Visible="false" />
                    <asp:Label ID="isCTC" runat="server" Text='<%# Eval("Quality / CTC") %>' Visible="false" />
                    <asp:Label ID="MgrReviewAutoDate" runat="server" Text='<%# Eval("MgrReviewAutoDate") %>' Visible="false" />
                </ItemTemplate>
                <LayoutTemplate>
                    <div id="itemPlaceholderContainer" runat="server">
                        <span runat="server" id="itemPlaceholder" />
                    </div>
                </LayoutTemplate>
            </asp:ListView>
            <asp:Panel ID="Panel4a" runat="server" Visible="false" Style="text-align: center;">
                <div style="border: 1px solid #cccccc; width: 99%; text-align: center;">
                    <p style="font-family: Arial; font-size: medium; text-align: center; width: 490px;">
                        <em style="font-weight: 700; text-align: center">This is an invalid Form ID.
                            <br />
                            Please return to the previous page and select a valid Form ID to view. 
                        </em>
                    </p>
                </div>
            </asp:Panel>
            <asp:UpdateProgress ID="UpdateProgress3" runat="server" DynamicLayout="true" DisplayAfter="0">
                <ProgressTemplate>
                    <div style="text-align: center;">
                        loading...
                        <br />
                        <img src="images/ajax-loader5.gif" alt="progress animation gif" />
                    </div>
                </ProgressTemplate>
            </asp:UpdateProgress>
            <br />
            <asp:Label ID="Label116" runat="server" CssClass="EMessage" Visible="true"></asp:Label>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:content>

<asp:content id="Content5" contentplaceholderid="ContentPlaceHolder4" runat="server">
    <asp:Panel ID="Panel31" runat="server" Visible="false">
        <asp:Label ID="Label4" runat="server" Text="Page:" ForeColor="Black" CssClass="sidelabel"></asp:Label>&nbsp;
        <asp:Label ID="Label6" runat="server" Text="Review" CssClass="sidetext"></asp:Label>
        <br />
        <asp:Label ID="Label117" runat="server" Text="FormID:" ForeColor="Black" CssClass="sidelabel"></asp:Label>&nbsp;
        <asp:Label ID="Label118" runat="server" Text="" CssClass="sidetext"></asp:Label>
        <br />
        <asp:Label ID="Label2" runat="server" Text="Status:" ForeColor="Black" CssClass="sidelabel"></asp:Label>&nbsp;
        <asp:Label ID="Label3" runat="server" Text="New" CssClass="sidetext"></asp:Label>
        <br />
        <asp:Label ID="Label8" runat="server" Text="Date Submitted:" ForeColor="Black" CssClass="sidelabel"></asp:Label>&nbsp;
        <asp:Label ID="Label10" runat="server" CssClass="sidetext"></asp:Label>
        <br />
        <asp:Label ID="Label9" runat="server" Text="Type:" ForeColor="Black" CssClass="sidelabel"></asp:Label>&nbsp;
        <asp:Label ID="Label11" runat="server" CssClass="sidetext"></asp:Label>
        <br />
        <asp:Panel ID="Panel16" runat="server">
            <asp:Label ID="Label5" runat="server" Text="Date of Coaching:" ForeColor="Black" CssClass="sidelabel"></asp:Label>&nbsp;
            <asp:Label ID="Label7" runat="server" CssClass="sidetext"></asp:Label>
            <br />
        </asp:Panel>
        <asp:Panel ID="Panel17" runat="server">
            <asp:Label ID="Label12" runat="server" Text="Date of Event:" ForeColor="Black" CssClass="sidelabel"></asp:Label>&nbsp;
            <asp:Label ID="Label13" runat="server" CssClass="sidetext"></asp:Label>
            <br />
        </asp:Panel>
        <asp:Label ID="Label14" runat="server" Text="Source:" ForeColor="Black" CssClass="sidelabel"></asp:Label>&nbsp;
        <asp:Label ID="Label15" runat="server" CssClass="sidetext" Text="Select..."></asp:Label>
        <br />
        <asp:Label ID="Label65" runat="server" Text="Site:" ForeColor="Black" CssClass="sidelabel"></asp:Label>&nbsp;
        <asp:Label ID="Label66" runat="server" CssClass="sidetext"></asp:Label>
        <br />
        <br />
        <asp:Panel ID="Panel18" runat="server">
            <asp:Label ID="Label16" runat="server" Text="Verint ID:" ForeColor="Black" CssClass="sidelabel"></asp:Label>&nbsp;
            <asp:Label ID="Label17" runat="server" CssClass="sidetext"></asp:Label>
            <br />
            <asp:Label ID="Label63" runat="server" Text="Scorecard Name:" ForeColor="Black" CssClass="sidelabel"></asp:Label>&nbsp;
            <asp:Label ID="Label64" runat="server" CssClass="sidetext"></asp:Label>
            <br />
        </asp:Panel>
        <asp:Panel ID="Panel19" runat="server">
            <asp:Label ID="Label18" runat="server" Text="Avoke ID:" ForeColor="Black" CssClass="sidelabel"></asp:Label>&nbsp;
            <asp:Label ID="Label19" runat="server" CssClass="sidetext"></asp:Label>
            <br />
        </asp:Panel>
        <asp:Panel ID="Panel20" runat="server">
            <asp:Label ID="Label20" runat="server" Text="NGD Activity ID:" ForeColor="Black" CssClass="sidelabel"></asp:Label>&nbsp;
            <asp:Label ID="Label21" runat="server" CssClass="sidetext"></asp:Label><br />
        </asp:Panel>
        <asp:Panel ID="Panel14" runat="server">
            <asp:Label ID="Label46" runat="server" Text="Universal Call ID:" ForeColor="Black" CssClass="sidelabel"></asp:Label>&nbsp;
            <asp:Label ID="Label149" runat="server" CssClass="sidetext"></asp:Label><br />
        </asp:Panel>
        <asp:Label ID="Label22" runat="server" Text="Employee:" ForeColor="Black" CssClass="sidelabel"></asp:Label>&nbsp;
        <asp:Label ID="Label23" runat="server" CssClass="sidetext"></asp:Label>
        <br />
        <asp:Label ID="Label24" runat="server" Text="Supervisor:" ForeColor="Black" CssClass="sidelabel"></asp:Label>&nbsp;
        <asp:Label ID="Label25" runat="server" CssClass="sidetext"></asp:Label>
        <br />
        <asp:Label ID="Label26" runat="server" Text="Manager:" ForeColor="Black" CssClass="sidelabel"></asp:Label>&nbsp;
        <asp:Label ID="Label27" runat="server" CssClass="sidetext"></asp:Label>
        <br />
        <asp:Panel ID="Panel34" runat="server" Visible="false">
            <asp:Label ID="Label119" runat="server" Text="Submitter:" ForeColor="Black" CssClass="sidelabel"></asp:Label>&nbsp;
            <asp:Label ID="Label120" runat="server" CssClass="sidetext"></asp:Label><br />
        </asp:Panel>
    </asp:Panel>
</asp:content>
