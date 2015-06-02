<%@ Page Title="" Language="C#" MasterPageFile="~/masterpages/Site2.Master" AutoEventWireup="true" CodeBehind="ViewWarning.aspx.cs" Inherits="eCLDeleteLog.ViewWarning" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="LeftContent" ContentPlaceHolderID="ContentPlaceHolder4" runat="server">
    <asp:Panel ID="LeftContentPanel" runat="server" Visible="false">
        <asp:Label ID="PageLabel" runat="server" Text="Page:" ForeColor="Black" CssClass="sidelabel"></asp:Label>&nbsp;
        <asp:Label ID="PageValueLabel" runat="server" Text="Review" CssClass="sidetext"></asp:Label>
        <br />
        
        <asp:Label ID="FormIDLabel" runat="server" Text="FormID:" ForeColor="Black" CssClass="sidelabel"></asp:Label>&nbsp;
        <asp:Label ID="FormIDValueLabel" runat="server" Text="" CssClass="sidetext"></asp:Label>
        <br />
        
        <asp:Label ID="StatusLabel" runat="server" Text="Status:" ForeColor="Black" CssClass="sidelabel"></asp:Label>&nbsp;
        <asp:Label ID="StatusValueLabel" runat="server" Text="New" CssClass="sidetext"></asp:Label>
        <br />
        
        <asp:Label ID="DateSubmittedLabel" runat="server" Text="Date Submitted:" ForeColor="Black" CssClass="sidelabel"></asp:Label>&nbsp;
        <asp:Label ID="DateSubmittedValueLabel" runat="server" CssClass="sidetext"></asp:Label>
        <br />
        
        <asp:Label ID="TypeLabel" runat="server" Text="Type:" ForeColor="Black" CssClass="sidelabel"></asp:Label>&nbsp;
        <asp:Label ID="TypeValueLabel" runat="server" CssClass="sidetext"></asp:Label>
        <br />
        
        <asp:Label ID="WarningDateLabel" runat="server" Text="Date the warning was issued:" ForeColor="Black" CssClass="sidelabel"></asp:Label>&nbsp;
        <asp:Label ID="WarningDateValueLabel" runat="server" CssClass="sidetext"></asp:Label>
        <br />
        
        <asp:Label ID="SourceLabel" runat="server" Text="Source:" ForeColor="Black" CssClass="sidelabel"></asp:Label>&nbsp;
        <asp:Label ID="SourceValueLabel" runat="server" CssClass="sidetext" Text="Select..."></asp:Label>
        <br />
        
        <asp:Label ID="SiteLabel" runat="server" Text="Site:" ForeColor="Black" CssClass="sidelabel"></asp:Label>&nbsp;
        <asp:Label ID="SiteValueLabel" runat="server" CssClass="sidetext"></asp:Label>
        <br />
        
        <asp:Label ID="Employee" runat="server" Text="Employee:" ForeColor="Black" CssClass="sidelabel"></asp:Label>&nbsp;
        <asp:Label ID="EmployeeValueLabel" runat="server" CssClass="sidetext"></asp:Label>
        <br />
        
        <asp:Label ID="SupervisorLabel" runat="server" Text="Supervisor:" ForeColor="Black" CssClass="sidelabel"></asp:Label>&nbsp;
        <asp:Label ID="SupervisorValueLabel" runat="server" CssClass="sidetext"></asp:Label>
        <br />
        
        <asp:Label ID="ManagerLabel" runat="server" Text="Manager:" ForeColor="Black" CssClass="sidelabel"></asp:Label>&nbsp;
        <asp:Label ID="ManagerValueLabel" runat="server" CssClass="sidetext"></asp:Label>
        <br />
        
        <asp:Label ID="SubmitterLabel" runat="server" Text="Submitter:" ForeColor="Black" CssClass="sidelabel"></asp:Label>&nbsp;
        <asp:Label ID="SubmitterValueLabel" runat="server" CssClass="sidetext"></asp:Label>
        <br />
    </asp:Panel>
</asp:Content>

<asp:Content ID="RightContent" ContentPlaceHolderID="ContentPlaceHolder3" runat="server">
    <asp:Label ID="InstructionLabel" runat="server" Text="Please note that all fields are required. Double-check your work to ensure accuracy." CssClass="sidelabel"></asp:Label>
    <br />
    <br />

    <asp:Label ID="CoachingReasonLabel" runat="server" Text="Coaching Reason(s):" CssClass="sidelabel"></asp:Label>
    <br />

    <asp:GridView ID="CoachingReasonGridView" runat="server" AutoGenerateColumns="True" Width="98%" ShowHeader="False" BackColor="White" BorderColor="White" BorderStyle="none" BorderWidth="0px" CellPadding="3" CellSpacing="1" GridLines="None">
        <RowStyle BackColor="#DEDFDE" ForeColor="Black" />
    </asp:GridView>

    <asp:Panel ID="InvalidFormIDPanel" runat="server" Visible="false" Style="text-align: center;">
        <div style="border: 1px solid #cccccc; width: 99%; text-align: center;">
            <p style="font-family: Arial; font-size: medium; text-align: center; width: 490px;">
                <em style="font-weight: 700; text-align: center">This is an invalid Form ID.
                    <br />
                    Please return to the previous page and select a valid Form ID to view. 
                </em>
            </p>
        </div>
    </asp:Panel>
</asp:Content>
