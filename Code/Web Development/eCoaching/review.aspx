<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site3.Master"
    CodeBehind="review.aspx.vb" Inherits="eCoachingFixed.review" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ OutputCache Location="None" VaryByParam="None" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <!-- Page CSS -->
    <style type="text/css">
        .EMessage
        {
            display: block;
        }
        .wrapped
        {
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
        .wrapped2
        {
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
        body
        {
            padding: 10px;
        }
    </style>
    <script language="javascript" type="text/javascript">

        function textboxMultilineMaxNumber(txt) {
            var maxLen = 3000;
            try {
                if (txt.value.length > (maxLen - 1)) {
                    var cont = txt.value;
                    txt.value = cont.substring(0, (maxLen - 1));
                    event.returnValue = false;
                };
            } catch (e) {
            }
        };

        function toggle(menyou, pnl) {
            var panel1;
            var panel2;
            var i;
            var inputElement;
            var box;
            var box2;
            var box3;
            var box4;
            var lbl;

            if (pnl == 'panel0a') {
                panel1 = document.getElementById('<%= panel0a.ClientID %>');
                box = document.getElementById('<%= TextBox1.ClientID %>');
                //  box.value = 'Enter Text...';

                panel2 = document.getElementById('<%= panel0b.ClientID %>');
                box2 = document.getElementById('<%= AddlNotes.ClientID %>');
                //box2.value = 'Enter Text...';

                if (menyou == '0') {
                    panel1.style.display = 'inline';
                    panel1.style.visibility = 'visible';
                    panel2.style.display = 'none';
                    panel2.style.visibility = 'hidden';
                    box2.value = 'Enter Text...';
                    box.value = '';
                }
                else {
                    panel1.style.display = 'none';
                    panel1.style.visibility = 'hidden';
                    panel2.style.display = 'inline';
                    panel2.style.visibility = 'visible';
                    box.value = 'Enter Text...';
                    box2.value = '';
                }
            }

            if (pnl == 'panel24') {
                panel1 = document.getElementById('<%= panel24.ClientID %>');
                panel2 = document.getElementById('<%= panel27.ClientID %>');

                panel1.style.display = 'inline';
                panel2.style.display = 'none';

                panel1.style.visibility = 'visible';
                panel2.style.visbility = 'hidden';

                box3 = document.getElementById('<%= Date3.ClientID %>');
                box3.value = '<%= DateTime.Now.ToString("d") %>';

                box4 = document.getElementById('<%= Date2.ClientID %>');
                box4.value = '';

                box2 = document.getElementById('<%= TextBox3.ClientID %>');
                box2.value = 'Enter Text...';

                box = document.getElementById('<%= TextBox2.ClientID %>');
                box.value = '';
            }

            if (pnl == 'panel27') {
                panel1 = document.getElementById('<%= Panel27.ClientID %>');
                panel2 = document.getElementById('<%= Panel24.ClientID %>');

                panel1.style.display = 'inline';
                panel2.style.display = 'none';

                panel1.style.visibility = 'visible';
                panel2.style.visbility = 'hidden';

                box3 = document.getElementById('<%= Date2.ClientID %>');
                box3.value = '<%= DateTime.Now.ToString("d") %>';

                box4 = document.getElementById('<%= Date3.ClientID %>');
                box4.value = '';

                box2 = document.getElementById('<%= TextBox2.ClientID %>');
                box2.value = 'Enter Text...';

                box = document.getElementById('<%= TextBox3.ClientID %>');
                box.value = '';
            }
        }

    </script>
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="ContentPlaceHolder3" runat="server">
    <asp:ToolkitScriptManager runat="server" ID="ToolkitScriptManager1" AsyncPostBackTimeout="1200"></asp:ToolkitScriptManager>
    <asp:Label ID="Label150" CssClass="description" runat="server" Text="Please do NOT include PII or PHI in the log entry." ViewStateMode="Disabled" ForeColor="Red" Style="font-weight: bold"></asp:Label>
    <br />
    <asp:SqlDataSource ID="SqlDataSource14" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
        SelectCommand="EC.sp_Check_AgentRole" SelectCommandType="StoredProcedure" OnSelected="ARC_Selected"
        DataSourceMode="DataReader" EnableViewState="False" ViewStateMode="Disabled">
        <SelectParameters>
            <asp:Parameter Name="nvcLanID" Type="String" />
            <asp:Parameter Name="nvcRole" Type="String" />
            <asp:Parameter Direction="ReturnValue" Name="Indirect@return_value" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:GridView ID="GridView1" runat="server" DataSourceID="SqlDataSource14" Visible="true">
    </asp:GridView>
    <asp:Label ID="Label241" runat="server" Text="" Visible="False"></asp:Label>
    <asp:DataList ID="DataList1" runat="server" DataSourceID="SqlDataSource6" Visible="False">
        <ItemTemplate>
            <asp:Label ID="Label30" runat="server" Text="strFormStatus:" Visible="false"></asp:Label>
            <asp:Label ID="LabelStatus" runat="server" Text='<%# Eval("strFormStatus") %>' Visible="False" />
        </ItemTemplate>
    </asp:DataList>
    <asp:SqlDataSource ID="SqlDataSource6" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
        SelectCommandType="StoredProcedure" SelectCommand="EC.sp_SelectRecordStatus"
        DataSourceMode="DataReader" EnableViewState="False" ViewStateMode="Disabled">
        <SelectParameters>
            <asp:QueryStringParameter Name="strFormID" QueryStringField="id" Type="String" Direction="Input" />
        </SelectParameters>
    </asp:SqlDataSource>
    <br />
    <asp:Label ID="Label28" runat="server" Text="Please note that all fields are required. Double-check your work to ensure accuracy." CssClass="sidelabel"></asp:Label>
    <br />
    <br />
    <asp:Label ID="Label29" runat="server" Text="Coaching Reason(s):" CssClass="sidelabel"></asp:Label>
    <br />
    <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
        SelectCommand="EC.sp_SelectReviewFrom_Coaching_Log" SelectCommandType="StoredProcedure"
        DataSourceMode="DataReader" EnableViewState="False" ViewStateMode="Disabled">
        <SelectParameters>
            <asp:QueryStringParameter DefaultValue="" Name="strFormIDin" QueryStringField="id"
                Type="String" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:GridView ID="GridView2" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSource8"
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

    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <asp:ListView ID="ListView1" runat="server" DataSourceID="SqlDataSource2" EnableModelValidation="True" DataKeyNames="numID" Visible="false">
                <EmptyDataTemplate>
                    <span>No data was returned.</span>
                </EmptyDataTemplate>

                <ItemTemplate>
                    <asp:Label ID="Label48" runat="server" Text="Details of the behavior being coached:" Font-Names="Calibri" Font-Bold="True" />
                    <br />
                    <asp:Table ID="Table2" CellPadding="0" CellSpacing="0" runat="server" Style="border: 1px solid #cccccc; background-color: #f1f1ec; width: 490px;" class="review">
                        <asp:TableRow>
                            <asp:TableCell CssClass="wrapped">
                                <asp:Label ID="txtDescriptionLabel" runat="server" Text='<%# Eval(server.htmldecode("txtDescription")) %>'></asp:Label>
                            </asp:TableCell>
                        </asp:TableRow>
                    </asp:Table>
                    <asp:Panel ID="Panel15" runat="server" Visible="false">
                        <asp:Label ID="Label49" runat="server" Text="Notes from Manager:" Font-Names="Calibri" Font-Bold="True"></asp:Label>
                        <br />
                        <asp:Table ID="Table3" CellPadding="0" CellSpacing="0" runat="server" Style="border: 1px solid #cccccc; background-color: #f1f1ec; width: 490px;" class="review">
                            <asp:TableRow>
                                <asp:TableCell CssClass="wrapped">&nbsp;
                                    <asp:Label ID="txtMgrNotesLabel" runat="server" Text='<%# Eval(server.htmldecode("txtMgrNotes")) %>' />
                                </asp:TableCell>
                            </asp:TableRow>
                        </asp:Table>
                    </asp:Panel>
                    <asp:Panel ID="Panel23" runat="server" Visible="false">
                        <asp:Label ID="Label71" runat="server" Text="Coaching Notes:" Font-Names="Calibri" Font-Bold="True"></asp:Label>
                        <br />
                        <asp:Table ID="Table5" CellPadding="0" CellSpacing="0" runat="server" Style="border: 1px solid #cccccc; background-color: #f1f1ec; width: 490px;" class="review">
                            <asp:TableRow>
                                <asp:TableCell CssClass="wrapped">&nbsp;
                                    <asp:Label ID="Label72" runat="server" Text='<%# Eval(server.htmldecode("txtCoachingNotes")) %>'></asp:Label>
                                </asp:TableCell>
                            </asp:TableRow>
                        </asp:Table>
                    </asp:Panel>
                    <asp:Panel ID="Panel28" runat="server" Visible="false">
                        <asp:Panel ID="Panel29" runat="server" Visible="false">
                            <asp:Label ID="Label82" runat="server" Text="Management Notes:" Font-Names="Calibri" Font-Bold="True"></asp:Label>
                            <br />
                            <asp:Table ID="Table1" CellPadding="0" CellSpacing="0" runat="server" Style="border: 1px solid #cccccc; background-color: #f1f1ec; width: 490px;" class="review">
                                <asp:TableRow>
                                    <asp:TableCell CssClass="wrapped">&nbsp;
                                        <asp:Label ID="Label83" runat="server" Text='<%# Eval(server.htmldecode("txtMgrNotes")) %>' />
                                    </asp:TableCell>
                                </asp:TableRow>
                            </asp:Table>
                        </asp:Panel>
                        <asp:Label ID="Label84" runat="server" Text="Coaching Notes:" Font-Names="Calibri" Font-Bold="True" />
                        <br />
                        <asp:Table ID="Table7" CellPadding="0" CellSpacing="0" runat="server" Style="border: 1px solid #cccccc; background-color: #f1f1ec; width: 490px;" class="review">
                            <asp:TableRow>
                                <asp:TableCell CssClass="wrapped">&nbsp;
                                    <asp:Label ID="Label85" runat="server" Text='<%# Eval(server.htmldecode("txtCoachingNotes")) %>'></asp:Label>
                                </asp:TableCell>
                            </asp:TableRow>
                        </asp:Table>
                    </asp:Panel>

                    <asp:Label ID="Label96" runat="server" Text='<%# Eval("strFormID") %>' Visible="false" />
                    <asp:Label ID="CoachingMonitorYesNo" runat="server" Text='<%# Eval("isCoachingMonitor") %>' Visible="false"></asp:Label>
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
                    <asp:Label ID="Label60" runat="server" Text='<%# Eval("strCSRSupName") %>' Visible="false" />
                    <asp:Label ID="Label61" runat="server" Text='<%# Eval("strCSRMgrName") %>' Visible="false" />
                    <asp:Label ID="Label121" runat="server" Text='<%# Eval("strSubmitterName") %>' Visible="false" />
                    <asp:Label ID="Label62" runat="server" Text='<%# Eval("strFormType") %>' Visible="false" />
                    <asp:Label ID="Label67" runat="server" Text='<%# Eval("isVerintMonitor") %>' Visible="false" />
                    <asp:Label ID="Label68" runat="server" Text='<%# Eval("isBehaviorAnalyticsMonitor") %>' Visible="false" />
                    <asp:Label ID="Label69" runat="server" Text='<%# Eval("isNGDActivityID") %>' Visible="false" />
                    <asp:Label ID="Label157" runat="server" Text='<%# Eval("isUCID") %>' Visible="false" />
                    <asp:Label ID="Label45" runat="server" Text='<%# Eval("strCSRSup") %>' Visible="false" />
                    <asp:Label ID="Label75" runat="server" Text='<%# Eval("strCSRMgr") %>' Visible="false" />
                    <asp:Label ID="Label88" runat="server" Text='<%# Eval("strEmpLanID") %>' Visible="false" />
                    <asp:Label ID="Label125" runat="server" Text='<%# Eval("strSubmitter") %>' Visible="false" />
                    <asp:Label ID="Label89" runat="server" Text='<%# Eval("isCSE") %>' Visible="false" />
                    <asp:Label ID="Label90" runat="server" Text='<%# Eval("isCSRAcknowledged") %>' Visible="false" />
                    <asp:Label ID="Label105" runat="server" Text='<%# Eval("txtcoachingnotes") %>' Visible="false" />
                    <asp:Label ID="Label106" runat="server" Text='<%# Eval("txtMgrNotes") %>' Visible="false" />
                    <asp:Label ID="Label107" runat="server" Text='<%# Eval("Customer Service Escalation") %>' Visible="false" />
                    <asp:Label ID="Label133" runat="server" Text='<%# Eval("Current Coaching Initiative") %>' Visible="false" />
                    <asp:Label ID="Label151" runat="server" Text='<%# Eval("OMR / Exceptions") %>' Visible="false" />
                    <asp:Label ID="LabelOmrIae" runat="server" Text='<%# Eval("OMR / IAE") %>' Visible="false" />
                    <asp:Label ID="LabelOmrIat" runat="server" Text='<%# Eval("OMR / IAT") %>' Visible="false" />
                    <asp:Label ID="Label34" runat="server" Text='<%# Eval("ETS / OAE") %>' Visible="false" />
                    <asp:Label ID="Label35" runat="server" Text='<%# Eval("ETS / OAS") %>' Visible="false" />
                    <asp:Label ID="Label36" runat="server" Text='<%# Eval("LCS") %>' Visible="false" />
                    <asp:Label ID="LabelOmrIsq" runat="server" Text='<%# Eval("OMR / ISQ") %>' Visible="false" />
                    <asp:Label ID="LabelShortDurationReport" runat="server" Text='<%# Eval("Training / SDR")%>' Visible="false" />
                    <asp:Label ID="LabelOverDueTraining" runat="server" Text='<%# Eval("Training / ODT")%>' Visible="false" />
                    <asp:Label ID="Label126" runat="server" Text='<%# Eval("isCoachingRequired") %>' Visible="false" />
                    <asp:Label ID="Label107b" runat="server" Text='<%# Eval("MgrReviewManualDate") %>' Visible="false" />
                    <asp:Label ID="Label148" runat="server" Text='<%# Eval("SupReviewedAutoDate") %>' Visible="false" />
                    <asp:Label ID="Label31" runat="server" Text='<%# Eval("Module") %>' Visible="false" />
                    <asp:Label ID="Label32" runat="server" Text='<%# Eval("strReviewer") %>' Visible="false" />
                    <%-- The Submitter's employee ID in coaching_log table --%>
                    <asp:Label ID="SubmitterEmployeeID" runat="server" Text='<%# Eval("strSubmitterID") %>' Visible="false" />
                    <%-- The employee's employee ID in coaching_log table--%>
                    <asp:Label ID="EmployeeID" runat="server" Text='<%# Eval("strEmpID") %>' Visible="false" />
                    <%-- The employee's Manager employee ID in employee_hierarchy table. --%>
                    <asp:Label ID="HierarchyMgrEmployeeID" runat="server" Text='<%# Eval("strCSRMgrID")%>' Visible="false" />
                    <%-- The employee's Supervisor employee ID in employee_hierarchy table. --%>
                    <asp:Label ID="HierarchySupEmployeeID" runat="server" Text='<%# Eval("strCSRSupID")%>' Visible="false" />
                    <asp:Label ID="CLMgrEmployeeID" runat="server" Text='<%# Eval("strCLMgrID")%>' Visible="false" />
                    <%-- The employee ID of the person to whom this log was reassigned.--%>
                    <asp:Label ID="ReassignedToEmployeeID" runat="server" Text='<%# Eval("ReassignedToID")%>' Visible="false" />
                    <%-- The supervisor name to whom the log was reassigned to.--%>
                    <asp:Label ID="ReassignedToSupName" runat="server" Text='<%# Eval("strReassignedSupName")%>' Visible="false" />
                    <%-- The manager name to whom the log was reassigned to.--%>
                    <asp:Label ID="ReassignedToMgrName" runat="server" Text='<%# Eval("strReassignedMgrName")%>' Visible="false" />
                    <asp:Label ID="isCTC" runat="server" Text='<%# Eval("Quality / CTC") %>' Visible="false" />
                    <asp:Label ID="isHigh5Club" runat="server" Text='<%# Eval("Quality / HFC") %>' Visible="false" />
                    <asp:Label ID="isKudo" runat="server" Text='<%# Eval("Quality / KUD") %>' Visible="false" />
                    <asp:Label ID="isAttendance" runat="server" Text='<%# Eval("OTH / SEA") %>' Visible="false" />
                </ItemTemplate>
                <LayoutTemplate>
                    <div id="itemPlaceholderContainer" runat="server">
                        <span runat="server" id="itemPlaceholder" />
                    </div>
                </LayoutTemplate>
            </asp:ListView>

            <!-- Ecl Static Text -->
            <asp:Panel ID="pnlStaticText" runat="server" Visible="false" CssClass="marginbottom">
                <asp:Label ID="lblStaticText" runat="server" />
            </asp:Panel>

            <asp:Panel ID="Panel25" runat="server" Visible="false">
                <asp:Label ID="Label63" runat="server" Text="1. Enter the date of coaching:" CssClass="question"></asp:Label>&nbsp; 
                <asp:Label ID="Label229" runat="server" Text="*" CssClass="EMessage" Width="10px"></asp:Label>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator14" runat="server" ControlToValidate="Date1" ErrorMessage=""
                    CssClass="EMessage" Display="Dynamic" Width="200px">Enter a valid coaching date.</asp:RequiredFieldValidator>
                <asp:CompareValidator ID="CompareValidator1" runat="server" Display="Dynamic" Operator="LessThanEqual"
                    Type="Date" ControlToValidate="Date1" ErrorMessage="" CssClass="EMessage" Width="490px">Enter today's date or a date in the past. You are not allowed to enter a future date.
                </asp:CompareValidator>
                <br />
                <asp:TextBox ID="Date1" runat="server" CssClass="qcontrol" Width="100px"></asp:TextBox>&nbsp; 
                <asp:Image runat="server" ID="cal1" ImageUrl="images/Calendar_scheduleHS.png" />
                <asp:CalendarExtender ID="calendarButtonExtender" runat="server" TargetControlID="Date1" PopupButtonID="cal1" Enabled="True" />
                <br />
                <asp:Label ID="Label70" runat="server" Text="2. Provide the details from the coaching session including action plans developed:" CssClass="question"></asp:Label>&nbsp; 
                <asp:Label ID="Label109" runat="server" Text="*" CssClass="EMessage" Width="10px"></asp:Label>
                <br />
                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage=""
                    ControlToValidate="TextBox5" CssClass="EMessage" Display="Dynamic" Enabled="false">Enter details from the coaching session including action plans developed.
                </asp:RequiredFieldValidator>
                <br />
                <asp:TextBox ID="TextBox5" runat="server" Rows="10" TextMode="MultiLine" CssClass="tboxes" onkeyup="return textboxMultilineMaxNumber(this)"></asp:TextBox>
                <br />
                <br />
                <asp:Label ID="Label231" runat="server" Text="[max length: 3,000 chars]"></asp:Label>
                <br />
                <asp:Label ID="Label1" runat="server" Text="Provide as much detail as possible"></asp:Label>
                <br />
                <asp:Button ID="Button1" runat="server" Text="Submit" CssClass="subuttons" />
            </asp:Panel>
            <!-- Management Acknowledge Reinforcement Logs Panel-->
            <asp:Panel ID="pnlMgtAckReinforceLog" runat="server" Visible="false">
                <asp:Label ID="Label146" runat="server" Text="1. Check the box below to acknowledge the monitor:" CssClass="question"></asp:Label>
                <asp:Label ID="Label147" runat="server" Text="*" CssClass="EMessage" Width="10px"></asp:Label>
                <br />
                <asp:CheckBox ID="CheckBox3" runat="server" Text="I have read and understand all the information provided on this eCoaching Log." />&nbsp; 
                <asp:CustomValidator runat="server" ID="CustomValidator3" EnableClientScript="true"
                    OnServerValidate="CheckBoxRequired3_ServerValidate" ErrorMessage="" CssClass="EMessage"
                    Width="470px" Display="Dynamic">You must select the acknowledgement checkbox to complete this review.
                </asp:CustomValidator>
                <br />
                <br />
                <asp:Button ID="Button7" runat="server" Text="Submit" CssClass="subuttons" />
            </asp:Panel>
            <asp:Panel ID="Panel37" runat="server" Visible="false">
                <asp:Label ID="Label134" runat="server" Text="You are receiving this eCL record because an Employee on your team was identified in an Outlier Management Report (OMR). Please research this item in accordance with the latest "></asp:Label>
                <asp:HyperLink ID="HyperLink1" NavigateUrl="https://cco.gdit.com/Resources/SOP/Contact Center Operations/Forms/AllItems.aspx"
                    Target="_blank" runat="server">Contact Center Operations 46.0 Outlier Management Report (OMR): Outlier Research Process SOP
                </asp:HyperLink>&nbsp; 
                <asp:Label ID="Label132" runat="server" Text=" and provide the details in the record below."></asp:Label>
                <br />
                <br />
                <asp:Panel ID="pnlDate" runat="server">
                    <asp:Label ID="Label140" runat="server" Text="1. Date:" CssClass="question"></asp:Label>&nbsp; 
                    <asp:Label ID="Label130" runat="server" Text="*" CssClass="EMessage" Width="10px"></asp:Label>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator10" runat="server" ControlToValidate="Date4" ErrorMessage=""
                        CssClass="EMessage" Display="Dynamic" Width="200px" Enabled="false">Enter a valid coaching date.
                    </asp:RequiredFieldValidator>
                    <asp:CompareValidator ID="CompareValidator5" runat="server" Display="Dynamic" Operator="LessThanEqual"
                        Type="Date" ControlToValidate="Date4" ErrorMessage="" CssClass="EMessage" Width="490px"
                        Enabled="True">Enter today's date or a date in the past. You are not allowed to enter a future date.
                    </asp:CompareValidator>
                    <br />
                    <asp:TextBox ID="Date4" runat="server" CssClass="qcontrol" Width="100px"></asp:TextBox>&nbsp; 
                    <asp:Image runat="server" ID="cal4" ImageUrl="images/Calendar_scheduleHS.png" />
                    <asp:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="Date4" PopupButtonID="cal4" Enabled="True" />
                </asp:Panel>
                <br />
                <asp:Label ID="Label141" runat="server" Text="2. Based on your research does this record require coaching?" CssClass="question"></asp:Label>
                <br />
                <asp:RadioButtonList ID="RadioButtonList3" runat="server">
                    <asp:ListItem Value="1" class="croptions" onclick="javascript: toggle('1','panel0a');" Selected="True">Yes</asp:ListItem>
                    <asp:ListItem Value="0" class="croptions" onclick="javascript: toggle('0','panel0a');">No</asp:ListItem>
                </asp:RadioButtonList>
                <br />
                <div runat="server" id="panel0a" style="visibility: hidden; display: none;">
                    <asp:Label ID="Label135" runat="server" Text="3. What was the main reason this item was not coachable?" CssClass="question"></asp:Label>&nbsp; 
                    <br />
                    <asp:DropDownList ID="DropDownList2" runat="server" class="TextBox">
                        <asp:ListItem Value="Other" Selected="True">Other</asp:ListItem>
                    </asp:DropDownList>
                    <br />
                    <br />
                    <asp:Label ID="Label136" runat="server" Text="4. Please provide reason / explanation / justification as to why the item was not coachable:" CssClass="question" Style="margin-right: 5px;"></asp:Label>&nbsp; 
                    <asp:Label ID="Label128" runat="server" Text="*" CssClass="EMessage" Width="10px"></asp:Label>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ErrorMessage="" ControlToValidate="TextBox1"
                        Display="Dynamic" CssClass="EMessage" Enabled="false" Style="margin-right: 5px;">Please provide reason / explanation / justification as to why the item was not coachable.
                    </asp:RequiredFieldValidator>
                    <asp:TextBox ID="TextBox1" runat="server" Rows="10" TextMode="MultiLine" CssClass="tboxes" onkeyup="return textboxMultilineMaxNumber(this)"></asp:TextBox>
                    <br />
                    <asp:Label ID="Label127" runat="server" Text="[max length: 3,000 chars]"></asp:Label>&nbsp; 
                    <asp:Label ID="Label137" runat="server" Text="[These notes will only be viewed by Supervisors]"></asp:Label>
                    <br />
                </div>
                <div runat="server" id="panel0b" style="visibility: visible; display: inline;">
                    <asp:Label ID="Label138" runat="server" Text="3. Please provide reason / explanation / justification as to why the item is coachable for the Supervisor:" CssClass="question" Style="margin-right: 5px;"></asp:Label>&nbsp; 
                    <asp:Label ID="Label131" runat="server" Text="*" CssClass="EMessage" Width="10px"></asp:Label>
                    <br />
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator9" runat="server" ErrorMessage=""
                        ControlToValidate="AddlNotes" Display="Dynamic" CssClass="EMessage" Enabled="false"
                        Style="margin-right: 5px;">Please provide reason / explanation / justification as to why the item is coachable for the Supervisor.
                    </asp:RequiredFieldValidator>
                    <asp:TextBox ID="AddlNotes" runat="server" Rows="10" TextMode="MultiLine" CssClass="tboxes" onkeyup="return textboxMultilineMaxNumber(this)"></asp:TextBox>
                    <br />
                    <asp:Label ID="Label139" runat="server" Text="[max length: 3,000 chars]"></asp:Label>&nbsp; 
                    <asp:Label ID="Label129" runat="server" Text="[These notes will only be viewed by Supervisors]"></asp:Label>
                    <br />
                    <br />
                </div>
                <asp:Button ID="Button5" runat="server" Text="Submit" CssClass="subuttons" />
                <br />
            </asp:Panel>
            <asp:Panel ID="Panel26" runat="server" Visible="false">
                <asp:Label ID="Label76" runat="server" Width="490px" Text="Review the submitted coaching opportunity and (1) determine if it is a confirmed Customer Service Escalation (CSE).  If it is a CSE, setup a meeting with the Employee and Supervisor and report your coaching in the box below.  If it not a CSE, enter notes for the Supervisor to use to coach the Employee."></asp:Label>
                <br />
                <br />
                <asp:Label ID="Label77" runat="server" Text="1. Is the coaching opportunity a confirmed Customer Service Escalation (CSE)?" CssClass="question"></asp:Label>&nbsp; 
                <asp:Label ID="Label110" runat="server" Text="*" CssClass="EMessage" Width="10px"></asp:Label>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator7"
                    runat="server" ControlToValidate="RadioButtonList1" ErrorMessage="" CssClass="EMessage"
                    Display="Dynamic" Width="250px" Enabled="false">Indicate if this is a confirmed CSE.
                </asp:RequiredFieldValidator>
                <br />
                <asp:RadioButtonList ID="RadioButtonList1" runat="server">
                    <asp:ListItem Value="1" class="croptions" onclick="javascript: toggle('1','panel24');">Yes, this is a confirmed Customer Service Escalation.</asp:ListItem>
                    <asp:ListItem Value="0" class="croptions" onclick="javascript: toggle('1','panel27');">No, this is not a confirmed Customer Service Escalation.</asp:ListItem>
                </asp:RadioButtonList>
                <br />
                <div id="panel24" runat="server" style="visibility: hidden; display: none;">
                    <asp:Label ID="Label73" runat="server" Text="2. Enter the date coached:" CssClass="question"></asp:Label>&nbsp; 
                    <asp:Label ID="Label111" runat="server" Text="*" CssClass="EMessage" Width="10px"></asp:Label>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="Date2" ErrorMessage=""
                        CssClass="EMessage" Display="Dynamic" Width="200px" Enabled="false">Enter a valid coaching date.
                    </asp:RequiredFieldValidator>
                    <asp:CompareValidator ID="CompareValidator2" runat="server" Display="Dynamic" Operator="LessThanEqual"
                        Type="Date" ControlToValidate="Date2" ErrorMessage="" CssClass="EMessage" Width="490px"
                        Enabled="false">Enter today's date or a date in the past. You are not allowed to enter a future date.
                    </asp:CompareValidator>
                    <br />
                    <asp:TextBox ID="Date2" runat="server" CssClass="qcontrol" Text=""></asp:TextBox>&nbsp; 
                    <asp:Image runat="server" ID="cal2" ImageUrl="images/Calendar_scheduleHS.png" />
                    <asp:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="Date2" PopupButtonID="cal2" Enabled="True" />
                    <br />
                    <asp:Label ID="Label74" runat="server" Text="3. Provide the details from the coaching session including action plans developed:" CssClass="question"></asp:Label>&nbsp; 
                    <asp:Label ID="Label113" runat="server" Text="*" CssClass="EMessage" Width="10px"></asp:Label>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator6"
                        runat="server" ErrorMessage="" ControlToValidate="TextBox2" Display="Dynamic"
                        CssClass="EMessage" Enabled="false" Width="400px">Please provide details of the behavior to be coached.
                    </asp:RequiredFieldValidator>
                    <br />
                    <asp:TextBox ID="TextBox2" runat="server" Rows="10" TextMode="MultiLine" CssClass="tboxes" onkeyup="return textboxMultilineMaxNumber(this)" BorderWidth="1px"></asp:TextBox>
                    <br />
                    <asp:Label ID="Label122" runat="server" Text="[max length: 3,000 chars]"></asp:Label>
                    <br />
                    <asp:Label ID="Label92" runat="server" Text="Provide as much detail as possible"></asp:Label>
                    <br />
                    <br />
                    <asp:Button ID="Button2" runat="server" Text="Submit" CssClass="subuttons" />
                </div>
                <div id="panel27" runat="server" style="visibility: hidden; display: none;">
                    <asp:Label ID="Label78" runat="server" Text="2. Enter the date reviewed:" CssClass="question"></asp:Label>&nbsp; 
                    <asp:Label ID="Label112" runat="server" Text="*" CssClass="EMessage" Width="10px"></asp:Label>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="Date3" ErrorMessage=""
                        CssClass="EMessage" Display="Dynamic" Width="200px" Enabled="false">Enter a valid coaching date.
                    </asp:RequiredFieldValidator>
                    <asp:CompareValidator ID="CompareValidator3" runat="server" Display="Dynamic" Operator="LessThanEqual"
                        Type="Date" ControlToValidate="Date3" ErrorMessage="" CssClass="EMessage" Width="490px"
                        Enabled="false">Enter today's date or a date in the past. You are not allowed to enter a future date.
                    </asp:CompareValidator>
                    <br />
                    <asp:TextBox ID="Date3" runat="server" CssClass="qcontrol"></asp:TextBox>&nbsp; 
                    <asp:Image runat="server" ID="cal3" ImageUrl="images/Calendar_scheduleHS.png" />
                    <asp:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="Date3" PopupButtonID="cal3" Enabled="True" />
                    <br />
                    <asp:Label ID="Label79" runat="server" Text="3. Provide explanation for Employee and Supervisor as to reason why this is not a CSE:" CssClass="question"></asp:Label>&nbsp; 
                    <asp:Label ID="Label114" runat="server" Text="*" CssClass="EMessage" Width="10px"></asp:Label>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator5"
                        runat="server" ErrorMessage="" ControlToValidate="TextBox3" Display="Dynamic"
                        CssClass="EMessage" Enabled="false" Width="400px">Provide reason why this is not a CSE.
                    </asp:RequiredFieldValidator>
                    <asp:TextBox ID="TextBox3" runat="server" Rows="10" TextMode="MultiLine" CssClass="tboxes" onkeyup="return textboxMultilineMaxNumber(this)"></asp:TextBox>
                    <br />
                    <asp:Label ID="Label123" runat="server" Text="[max length: 3,000 chars]"></asp:Label>
                    <br />
                    <asp:Label ID="Label93" runat="server" Text="Provide as much detail as possible"></asp:Label>
                    <br />
                    <br />
                    <asp:Button ID="Button3" runat="server" Text="Submit" CssClass="subuttons" />
                </div>
            </asp:Panel>
            <asp:Panel ID="Panel30" runat="server" Visible="false">
                <asp:Label ID="Label86" runat="server" Text="1. Check the box below to acknowledge the coaching opportunity:" CssClass="question"></asp:Label>
                <asp:Label ID="Label115" runat="server" Text="*" CssClass="EMessage" Width="10px"></asp:Label>
                <br />
                <asp:CheckBox ID="CheckBox2" runat="server" Text="I have read and understand all the information provided on this eCoaching Log." />&nbsp; 
                <asp:CustomValidator runat="server" ID="CustomValidator2" EnableClientScript="true"
                    OnServerValidate="CheckBoxRequired2_ServerValidate" ErrorMessage="" CssClass="EMessage"
                    Width="470px" Display="Dynamic">You must select the acknowledgement checkbox to complete this review.
                </asp:CustomValidator>
                <br />
                <br />
                <asp:Label ID="Label87" runat="server" Text="2. Provide any comments or feedback below:" CssClass="question"></asp:Label>
                <br />
                <asp:TextBox ID="TextBox4" runat="server" Rows="10" TextMode="MultiLine" CssClass="tboxes" onkeyup="return textboxMultilineMaxNumber(this)"></asp:TextBox>
                <br />
                <asp:Label ID="Label124" runat="server" Text="[max length: 3,000 chars]"></asp:Label>
                <br />
                <asp:Label ID="Label108" runat="server" Text="Provide as much detail as possible"></asp:Label>
                <br />
                <br />
                <asp:Button ID="Button4" runat="server" Text="Submit" CssClass="subuttons" />
            </asp:Panel>

            <!-- Employee Acknowledge Reinforcement Logs Panel -->
            <asp:Panel ID="pnlEmpAckReinforceLog" runat="server" Visible="false">
                <asp:Label ID="Label144" runat="server" Text="1. Check the box below to acknowledge the monitor:" CssClass="question"></asp:Label>
                <asp:Label ID="Label145" runat="server" Text="*" CssClass="EMessage" Width="10px"></asp:Label>
                <br />
                <asp:CheckBox ID="CheckBox1" runat="server" Text="I have read and understand all the information provided on this eCoaching Log." />&nbsp; 
                <asp:CustomValidator runat="server" ID="CustomValidator1" EnableClientScript="true"
                    OnServerValidate="CheckBoxRequired1_ServerValidate" ErrorMessage="" CssClass="EMessage"
                    Width="470px" Display="Dynamic">You must select the acknowledgement checkbox to complete this review.
                </asp:CustomValidator>
                <br />
                <br />
                <asp:Label ID="lblAcknowledgeComments" runat="server" Text="2. Provide any comments or feedback below:" CssClass="question"></asp:Label>
                <br />
                <asp:TextBox ID="txtAcknowledgeComments" runat="server" Rows="10" TextMode="MultiLine" CssClass="tboxes" onkeyup="return textboxMultilineMaxNumber(this)"></asp:TextBox>
                <br />
                <asp:Label ID="lblAcknowlegeCommentsMaxLength" runat="server" Text="[max length: 3,000 chars]"></asp:Label>
                <br />
                <asp:Label ID="lblAcknowledgeCommentsInstruction" runat="server" Text="Provide as much detail as possible"></asp:Label>
                <br />
                <br />
                <asp:Button ID="Button6" runat="server" Text="Submit" CssClass="subuttons" />
            </asp:Panel>

            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                UpdateCommand="EC.sp_Update1Review_Coaching_Log" UpdateCommandType="StoredProcedure"
                DataSourceMode="DataReader" EnableViewState="False" ViewStateMode="Disabled">
                <UpdateParameters>
                    <asp:Parameter Name="nvcFormID" Type="String" />
                    <asp:Parameter Name="nvcReviewSupLanID" Type="String" />
                    <asp:Parameter Name="nvcFormStatus" Type="String" />
                    <asp:Parameter Name="dtmSupReviewedAutoDate" Type="DateTime" />
                    <asp:Parameter Name="nvctxtCoachingNotes" Type="String" />
                </UpdateParameters>
            </asp:SqlDataSource>
            <asp:SqlDataSource ID="SqlDataSource3" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                UpdateCommand="EC.sp_Update2Review_Coaching_Log" UpdateCommandType="StoredProcedure"
                DataSourceMode="DataReader" EnableViewState="False" ViewStateMode="Disabled">
                <UpdateParameters>
                    <asp:Parameter Name="nvcFormID" Type="String" />
                    <asp:Parameter Name="nvcFormStatus" Type="String" />
                    <asp:Parameter Name="nvcReviewMgrLanID" Type="String" />
                    <asp:Parameter Name="dtmMgrReviewAutoDate" Type="DateTime" />
                    <asp:Parameter Name="dtmMgrReviewManualDate" Type="DateTime" />
                    <asp:Parameter Name="bitisCSE" Type="Boolean" />
                    <asp:Parameter Name="nvctxtMgrNotes" Type="String" />
                </UpdateParameters>
            </asp:SqlDataSource>
            <asp:SqlDataSource ID="SqlDataSource4" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                UpdateCommand="EC.sp_Update3Review_Coaching_Log" UpdateCommandType="StoredProcedure"
                DataSourceMode="DataReader" EnableViewState="False" ViewStateMode="Disabled">
                <UpdateParameters>
                    <asp:Parameter Name="nvcFormID" Type="String" />
                    <asp:Parameter Name="nvcReviewMgrLanID" Type="String" />
                    <asp:Parameter Name="bitisCSE" Type="Boolean" />
                    <asp:Parameter Name="nvcFormStatus" Type="String" />
                    <asp:Parameter Name="dtmMgrReviewManualDate" Type="DateTime" />
                    <asp:Parameter Name="dtmMgrReviewAutoDate" Type="DateTime" />
                    <asp:Parameter Name="nvcMgrNotes" Type="String" />
                </UpdateParameters>
            </asp:SqlDataSource>
            <asp:SqlDataSource ID="SqlDataSource5" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                UpdateCommand="EC.sp_Update4Review_Coaching_Log" UpdateCommandType="StoredProcedure"
                DataSourceMode="DataReader" EnableViewState="False" ViewStateMode="Disabled">
                <UpdateParameters>
                    <asp:Parameter Name="nvcFormID" Type="String" />
                    <asp:Parameter Name="nvcFormStatus" Type="String" />
                    <asp:Parameter Name="dtmCSRReviewAutoDate" Type="DateTime" />
                    <asp:Parameter Name="nvcCSRComments" Type="String" />
                    <asp:Parameter Name="bitisCSRAcknowledged" Type="Boolean" />
                </UpdateParameters>
            </asp:SqlDataSource>
            <asp:SqlDataSource ID="SqlDataSource9" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                UpdateCommand="EC.sp_Update6Review_Coaching_Log" UpdateCommandType="StoredProcedure"
                DataSourceMode="DataReader" EnableViewState="False" ViewStateMode="Disabled">
                <UpdateParameters>
                    <asp:Parameter Name="nvcFormID" Type="String" />
                    <asp:Parameter Name="nvcFormStatus" Type="String" />
                    <asp:Parameter Name="dtmCSRReviewAutoDate" Type="DateTime" />
                    <asp:Parameter Name="bitisCSRAcknowledged" Type="Boolean" />
                    <asp:Parameter Name="nvcCSRComments" Type="String" />
                </UpdateParameters>
            </asp:SqlDataSource>
            <asp:SqlDataSource ID="SqlDataSource10" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                UpdateCommand="EC.sp_Update7Review_Coaching_Log" UpdateCommandType="StoredProcedure"
                DataSourceMode="DataReader" EnableViewState="False" ViewStateMode="Disabled">
                <UpdateParameters>
                    <asp:Parameter Name="nvcFormID" Type="String" />
                    <asp:Parameter Name="nvcReviewSupLanID" Type="String" />
                    <asp:Parameter Name="nvcFormStatus" Type="String" />
                    <asp:Parameter Name="dtmSUPReviewAutoDate" Type="DateTime" />
                </UpdateParameters>
            </asp:SqlDataSource>
            <asp:SqlDataSource ID="SqlDataSource7" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                UpdateCommand="EC.sp_Update5Review_Coaching_Log" UpdateCommandType="StoredProcedure"
                DataSourceMode="DataReader" EnableViewState="False" ViewStateMode="Disabled">
                <UpdateParameters>
                    <asp:Parameter Name="nvcFormID" Type="String" />
                    <asp:Parameter Name="nvcReviewerLanID" Type="String" />
                    <asp:Parameter Name="bitisCoachingRequired" Type="Boolean" />
                    <asp:Parameter Name="nvcFormStatus" Type="String" />
                    <asp:Parameter Name="nvcstrReasonNotCoachable" Type="String" />
                    <asp:Parameter Name="dtmReviewManualDate" Type="DateTime" />
                    <asp:Parameter Name="dtmReviewAutoDate" Type="DateTime" />
                    <asp:Parameter Name="nvcReviewerNotes" Type="String" />
                    <asp:Parameter Name="nvctxtReasonNotCoachable" Type="String" />
                </UpdateParameters>
            </asp:SqlDataSource>

            <asp:ListView ID="ListView2" runat="server" DataSourceID="SqlDataSource2" EnableModelValidation="True" DataKeyNames="numID" Visible="false">
                <EmptyDataTemplate>
                    <span>No data was returned.</span>
                </EmptyDataTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label98" runat="server" Text="Details of the behavior being coached:" Font-Names="Calibri" Font-Bold="True" />
                    <br />
                    <asp:Table ID="Table7" CellPadding="0" CellSpacing="0" runat="server" Style="border: 1px solid #cccccc; background-color: #f1f1ec; width: 490px;" class="review">
                        <asp:TableRow>
                            <asp:TableCell CssClass="wrapped">
                                <asp:Label ID="Label99" runat="server" Text='<%# Eval(server.htmldecode("txtDescription")) %>'></asp:Label>
                            </asp:TableCell>
                        </asp:TableRow>
                    </asp:Table>
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
                    <asp:Label ID="Label100" runat="server" Text="TBD" Font-Names="Calibri" Font-Bold="False" />&nbsp; 
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
                    <asp:Label ID="CoachingMonitorYesNo" runat="server" Text='<%# Eval("isCoachingMonitor") %>' Visible="false"></asp:Label>
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
                    <asp:Label ID="Label60" runat="server" Text='<%# Eval("strCSRSupName") %>' Visible="false" />
                    <asp:Label ID="Label61" runat="server" Text='<%# Eval("strCSRMgrName") %>' Visible="false" />
                    <asp:Label ID="Label121" runat="server" Text='<%# Eval("strSubmitterName") %>' Visible="false" />
                    <asp:Label ID="Label62" runat="server" Text='<%# Eval("strFormType") %>' Visible="false" />
                    <asp:Label ID="Label67" runat="server" Text='<%# Eval("isVerintMonitor") %>' Visible="false" />
                    <asp:Label ID="Label68" runat="server" Text='<%# Eval("isBehaviorAnalyticsMonitor") %>' Visible="false" />
                    <asp:Label ID="Label69" runat="server" Text='<%# Eval("isNGDActivityID") %>' Visible="false" />
                    <asp:Label ID="Label157" runat="server" Text='<%# Eval("isUCID") %>' Visible="false" />
                    <asp:Label ID="Label45" runat="server" Text='<%# Eval("strCSRSup") %>' Visible="false" />
                    <asp:Label ID="Label75" runat="server" Text='<%# Eval("strCSRMgr") %>' Visible="false" />
                    <asp:Label ID="Label88" runat="server" Text='<%# Eval("strEmpLanID") %>' Visible="false" />
                    <asp:Label ID="Label125" runat="server" Text='<%# Eval("strSubmitter") %>' Visible="false" />
                    <asp:Label ID="Label89" runat="server" Text='<%# Eval("isCSE") %>' Visible="false" />
                    <asp:Label ID="Label90" runat="server" Text='<%# Eval("isCSRAcknowledged") %>' Visible="false" />
                    <asp:Label ID="Label104" runat="server" Text='<%# Eval("CSRReviewAutoDate") %>' Visible="false" />
                    <asp:Label ID="Label105" runat="server" Text='<%# Eval("txtcoachingnotes") %>' Visible="false" />
                    <asp:Label ID="Label106" runat="server" Text='<%# Eval("txtMgrNotes") %>' Visible="false" />
                    <asp:Label ID="Label126" runat="server" Text='<%# Eval("isCoachingRequired") %>' Visible="false" />
                    <asp:Label ID="Label107" runat="server" Text='<%# Eval("Customer Service Escalation") %>' Visible="false" />
                    <asp:Label ID="Label107b" runat="server" Text='<%# Eval("MgrReviewManualDate") %>' Visible="false" />
                    <asp:Label ID="Label148" runat="server" Text='<%# Eval("SupReviewedAutoDate") %>' Visible="false" />
                    <asp:Label ID="Label31" runat="server" Text='<%# Eval("Module") %>' Visible="false" />
                    <asp:Label ID="Label32" runat="server" Text='<%# Eval("strReviewer") %>' Visible="false" />
                    <%-- The Submitter's employee ID in coaching_log table --%>
                    <asp:Label ID="SubmitterEmployeeID" runat="server" Text='<%# Eval("strSubmitterID") %>' Visible="false" />
                    <%-- The employee's employee ID in coaching_log table--%>
                    <asp:Label ID="EmployeeID" runat="server" Text='<%# Eval("strEmpID") %>' Visible="false" />
                    <%-- The employee's Manager employee ID in employee_hierarchy table. --%>
                    <asp:Label ID="HierarchyMgrEmployeeID" runat="server" Text='<%# Eval("strCSRMgrID")%>' Visible="false" />
                    <%-- The employee's Supervisor employee ID in employee_hierarchy table. --%>
                    <asp:Label ID="HierarchySupEmployeeID" runat="server" Text='<%# Eval("strCSRSupID")%>' Visible="false" />
                    <%-- The employee ID of the person to whom this log was reassigned.--%>
                    <asp:Label ID="ReassignedToEmployeeID" runat="server" Text='<%# Eval("ReassignedToID")%>' Visible="false" />
                    <asp:Label ID="ReassignedToSupName" runat="server" Text='<%# Eval("strReassignedSupName")%>' Visible="false" />
                    <%-- The manager name to whom the log was reassigned to.--%>
                    <asp:Label ID="ReassignedToMgrName" runat="server" Text='<%# Eval("strReassignedMgrName")%>' Visible="false" />
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
                            <br />Please return to the previous page and select a valid Form ID to view. 
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
</asp:Content>

<asp:Content ID="Content5" ContentPlaceHolderID="ContentPlaceHolder4" runat="server">
    <asp:Panel ID="Panel31" runat="server" Visible="false">
        <asp:Label ID="Label4" runat="server" Text="Page:" ForeColor="Black" CssClass="sidelabel"></asp:Label>&nbsp;
        <asp:Label ID="Label6" runat="server" Text="Review" CssClass="sidetext"></asp:Label>
        <br />
        <asp:Label ID="Label117" runat="server" Text="FormID:" ForeColor="Black" CssClass="sidelabel"></asp:Label>&nbsp;
        <asp:Label ID="Label118" runat="server" Text="" CssClass="sidetext"></asp:Label>
        <br />
        <asp:Label ID="lblCoachMonitorYesNo" runat="server" Text="Coaching Monitor:" ForeColor="Black" CssClass="sidelabel"></asp:Label>&nbsp;
        <asp:Label ID="txtCoachMonitorYesNo" runat="server" Text="" CssClass="sidetext"></asp:Label>
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
            <asp:Label ID="Label160" runat="server" Text="Scorecard Name:" ForeColor="Black" CssClass="sidelabel"></asp:Label>&nbsp;
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
            <asp:Label ID="Label21" runat="server" CssClass="sidetext"></asp:Label>
            <br />
        </asp:Panel>
        <asp:Panel ID="Panel14" runat="server">
            <asp:Label ID="Label46" runat="server" Text="Universal Call ID:" ForeColor="Black" CssClass="sidelabel"></asp:Label>&nbsp;
            <asp:Label ID="Label149" runat="server" CssClass="sidetext"></asp:Label>
            <br />
        </asp:Panel>
        <asp:Label ID="Label22" runat="server" Text="Employee:" ForeColor="Black" CssClass="sidelabel"></asp:Label>&nbsp;
        <asp:Label ID="Label23" runat="server" CssClass="sidetext"></asp:Label>
        <br />
        <asp:Label ID="Label24" runat="server" Text="Supervisor:" ForeColor="Black" CssClass="sidelabel"></asp:Label>&nbsp;
        <asp:Label ID="Label25" runat="server" CssClass="sidetext"></asp:Label>
        <br />
        <asp:Label ID="ReassignedSupLabel" runat="server" Text="Reassigned Supervisor:" ForeColor="Black" CssClass="sidelabel"></asp:Label>&nbsp;
        <asp:Label ID="ReassignedSupName" runat="server" CssClass="sidetext"></asp:Label>
        <br />
        <asp:Label ID="Label26" runat="server" Text="Manager:" ForeColor="Black" CssClass="sidelabel"></asp:Label>&nbsp;
        <asp:Label ID="Label27" runat="server" CssClass="sidetext"></asp:Label>
        <br />
        <asp:Label ID="ReassignedMgrLabel" runat="server" Text="Reassigned Manager:" ForeColor="Black" CssClass="sidelabel"></asp:Label>&nbsp;
        <asp:Label ID="ReassignedMgrName" runat="server" CssClass="sidetext"></asp:Label>
        <br />
        <asp:Panel ID="Panel34" runat="server" Visible="false">
            <asp:Label ID="Label119" runat="server" Text="Submitter:" ForeColor="Black" CssClass="sidelabel"></asp:Label>&nbsp;
            <asp:Label ID="Label120" runat="server" CssClass="sidetext"></asp:Label>
            <br />
        </asp:Panel>
    </asp:Panel>
</asp:Content>