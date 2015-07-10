<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site3.Master"
    CodeBehind="review3.aspx.vb" Inherits="eCoachingFixed.review3" %>

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
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="ContentPlaceHolder3" runat="server">
    <asp:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" AsyncPostBackTimeout="1200"></asp:ToolkitScriptManager>
    <asp:SqlDataSource ID="SqlDataSource3" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
        SelectCommand="EC.sp_Check_AgentRole" SelectCommandType="StoredProcedure" OnSelected="SRMGR_Selected">
        <SelectParameters>
            <asp:Parameter Name="nvcLanID" Type="String" />
            <asp:Parameter Name="nvcRole" Type="String" />
            <asp:Parameter Direction="ReturnValue" Name="Indirect@return_value" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:GridView ID="GridView2" runat="server" DataSourceID="SqlDataSource3" Visible="true"></asp:GridView>
    <asp:Label ID="Label241" runat="server" Text="" Visible="false"></asp:Label>
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
        SelectCommand="EC.sp_SelectReviewFrom_Warning_Log_Reasons" SelectCommandType="StoredProcedure"
        DataSourceMode="DataReader" EnableViewState="True" ViewStateMode="Enabled">
        <SelectParameters>
            <asp:QueryStringParameter DefaultValue="" Name="strFormIDin" QueryStringField="id" Type="String" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
        SelectCommand="EC.sp_SelectReviewFrom_Warning_Log" SelectCommandType="StoredProcedure">
        <SelectParameters>
            <asp:QueryStringParameter DefaultValue="" Name="strFormIDin" QueryStringField="id" Type="String" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <asp:ListView ID="ListView2" runat="server" DataSourceID="SqlDataSource2" EnableModelValidation="True" DataKeyNames="numID" Visible="false">
                <EmptyDataTemplate>
                    <span>No data was returned.</span>
                </EmptyDataTemplate>

                <ItemTemplate>
                    <asp:Label ID="Label96" runat="server" Text='<%# Eval("strFormID") %>' Visible="false" />
                    <asp:Label ID="Label50" runat="server" Text='<%# Eval("strFormStatus") %>' Visible="false" />
                    <asp:Label ID="Label51" runat="server" Text='<%# Eval("SubmittedDate") %>' Visible="false" />
                    <asp:Label ID="Label52" runat="server" Text='<%# Eval("EventDate") %>' Visible="false" />
                    <asp:Label ID="Label53" runat="server" Text='<%# Eval("strSource") %>' Visible="false" />
                    <asp:Label ID="Label55" runat="server" Text='<%# Eval("strCSRSite") %>' Visible="false" />
                    <asp:Label ID="Label59" runat="server" Text='<%# Eval("strCSRName") %>' Visible="false" />
                    <asp:Label ID="Label49" runat="server" Text='<%# Eval("strEmpLanID") %>' Visible="false" />
                    <asp:Label ID="Label60" runat="server" Text='<%# Eval("strCSRSupName") %>' Visible="false" />
                    <asp:Label ID="Label48" runat="server" Text='<%# Eval("strCSRSup") %>' Visible="false" />
                    <asp:Label ID="Label61" runat="server" Text='<%# Eval("strCSRMgrName") %>' Visible="false" />
                    <asp:Label ID="Label47" runat="server" Text='<%# Eval("strCSRMgr") %>' Visible="false" />
                    <asp:Label ID="Label1" runat="server" Text='<%# Eval("strSubmitter") %>' Visible="false" />
                    <asp:Label ID="Label121" runat="server" Text='<%# Eval("strSubmitterName") %>' Visible="false" />
                    <asp:Label ID="Label62" runat="server" Text='<%# Eval("strFormType") %>' Visible="false" />
                     <asp:Label ID="Label45" runat="server" Text='<%# Eval("strCSRSup") %>' Visible="false" />
                    <asp:Label ID="Label75" runat="server" Text='<%# Eval("strCSRMgr") %>' Visible="false" />
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
</asp:Content>

<asp:Content ID="Content5" ContentPlaceHolderID="ContentPlaceHolder4" runat="server">
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
        <asp:Label ID="Label5" runat="server" Text="Date the warning was issued:" ForeColor="Black" CssClass="sidelabel"></asp:Label>&nbsp;
        <asp:Label ID="Label7" runat="server" CssClass="sidetext"></asp:Label>
        <br />
        <asp:Label ID="Label14" runat="server" Text="Source:" ForeColor="Black" CssClass="sidelabel"></asp:Label>&nbsp;
        <asp:Label ID="Label15" runat="server" CssClass="sidetext" Text="Select..."></asp:Label>
        <br />
        <asp:Label ID="Label65" runat="server" Text="Site:" ForeColor="Black" CssClass="sidelabel"></asp:Label>&nbsp;
        <asp:Label ID="Label66" runat="server" CssClass="sidetext"></asp:Label>
        <br />
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
            <asp:Label ID="Label120" runat="server" CssClass="sidetext"></asp:Label>
            <br />
        </asp:Panel>
    </asp:Panel>
</asp:Content>
