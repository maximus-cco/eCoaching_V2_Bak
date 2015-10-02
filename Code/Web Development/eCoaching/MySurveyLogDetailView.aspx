<%@ Page Title="" Language="vb" AutoEventWireup="true" MasterPageFile="~/Site3.Master" CodeBehind="MySurveyLogDetailView.aspx.vb" Inherits="eCoachingFixed.MySurveyLogDetailView" %>
<asp:content id="Content1" contentplaceholderid="HeadContent" runat="server">
</asp:content>

<asp:content id="LeftContent" contentplaceholderid="ContentPlaceHolder4" runat="server">
    <asp:Label ID="PageLabel" runat="server" Text="Page:" ForeColor="Black" CssClass="sidelabel"></asp:Label>&nbsp;
    <asp:Label ID="PageValueLabel" runat="server" Text="Review" CssClass="sidetext"></asp:Label>
    <br />
    
    <asp:Label ID="FormIDLabel" runat="server" Text="FormID:" ForeColor="Black" CssClass="sidelabel"></asp:Label>&nbsp;
    <asp:Label ID="FormIDValueLabel" runat="server" Text="" CssClass="sidetext"></asp:Label>
    <br />

    <asp:Label ID="StatusLabel" runat="server" Text="Status:" ForeColor="Black" CssClass="sidelabel"></asp:Label>&nbsp;
    <asp:Label ID="StatusValueLabel" runat="server" Text="" CssClass="sidetext"></asp:Label>
    <br />
    
    <asp:Label ID="DateSubmittedLabel" runat="server" Text="Date Submitted:" ForeColor="Black" CssClass="sidelabel"></asp:Label>&nbsp;
    <asp:Label ID="DataSubmittedValueLabel" runat="server" CssClass="sidetext"></asp:Label>
    <br />

    <asp:Label ID="TypeLabel" runat="server" Text="Type:" ForeColor="Black" CssClass="sidelabel"></asp:Label>&nbsp;
    <asp:Label ID="TypeValueLabel" runat="server" CssClass="sidetext"></asp:Label>
    <br />

    <asp:Panel ID="CoachingDatePanel" runat="server">
        <asp:Label ID="CoachingDateLabel" runat="server" Text="Date of Coaching:" ForeColor="Black" CssClass="sidelabel"></asp:Label>&nbsp;
        <asp:Label ID="CoachingDateValueLabel" runat="server" CssClass="sidetext"></asp:Label>
        <br />
    </asp:Panel>

    <asp:Panel ID="EventDatePanel" runat="server">
        <asp:Label ID="EventDateLabel" runat="server" Text="Date of Event:" ForeColor="Black" CssClass="sidelabel"></asp:Label>&nbsp;
        <asp:Label ID="EventDateValueLabel" runat="server" CssClass="sidetext"></asp:Label>
        <br />
    </asp:Panel>

    <asp:Label ID="SourceLabel" runat="server" Text="Source:" ForeColor="Black" CssClass="sidelabel"></asp:Label>&nbsp;
    <asp:Label ID="SourceValueLabel" runat="server" CssClass="sidetext" Text="Select..."></asp:Label>
    <br />
    
    <asp:Label ID="SiteLabel" runat="server" Text="Site:" ForeColor="Black" CssClass="sidelabel"></asp:Label>&nbsp;
    <asp:Label ID="SiteValueLabel" runat="server" CssClass="sidetext"></asp:Label>
    <br />
    <br />

    <asp:Panel ID="VerintPanel" runat="server">
        <asp:Label ID="VerintIDLabel" runat="server" Text="Verint ID:" ForeColor="Black" CssClass="sidelabel"></asp:Label>&nbsp;
        <asp:Label ID="VerintIDValueLabel" runat="server" CssClass="sidetext"></asp:Label>
        <br />

        <asp:Label ID="ScoreCardNameLabel" runat="server" Text="Scorecard Name:" ForeColor="Black" CssClass="sidelabel"></asp:Label>&nbsp;
        <asp:Label ID="ScoreCardNameValueLabel" runat="server" CssClass="sidetext"></asp:Label>
        <br />
    </asp:Panel>

    <asp:Panel ID="AvokeIDPanel" runat="server">
        <asp:Label ID="AvokeIDLabel" runat="server" Text="Avoke ID:" ForeColor="Black" CssClass="sidelabel"></asp:Label>&nbsp;
        <asp:Label ID="AvokeIDValueLabel" runat="server" CssClass="sidetext"></asp:Label>
        <br />
    </asp:Panel>

    <asp:Panel ID="NgdActivityIDPanel" runat="server">
        <asp:Label ID="NgdActivityIDLabel" runat="server" Text="NGD Activity ID:" ForeColor="Black" CssClass="sidelabel"></asp:Label>&nbsp;
        <asp:Label ID="NgdActivityIDValueLabel" runat="server" CssClass="sidetext"></asp:Label>
        <br />
    </asp:Panel>

    <asp:Panel ID="UniversalCallIDPanel" runat="server">
        <asp:Label ID="UniversalCallIDLabel" runat="server" Text="Universal Call ID:" ForeColor="Black" CssClass="sidelabel"></asp:Label>&nbsp;
        <asp:Label ID="UniversalCallIDValueLabel" runat="server" CssClass="sidetext"></asp:Label>
        <br />
    </asp:Panel>

    <asp:Label ID="EmployeeLabel" runat="server" Text="Employee:" ForeColor="Black" CssClass="sidelabel"></asp:Label>&nbsp;
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
</asp:content>

<asp:content id="RightContent" contentplaceholderid="ContentPlaceHolder3" runat="server">
    <asp:Label ID="InstructionLabel" runat="server" Text="Please note that all fields are required. Double-check your work to ensure accuracy." CssClass="sidelabel"></asp:Label>
    <br />
    <br />

    <asp:Label ID="CoachingReasonLabel" runat="server" Text="Coaching Reason(s):" CssClass="sidelabel"></asp:Label>
    <br />
    <asp:GridView ID="CoachingReasonGridView" AutoGenerateColumns="True" runat="server" Width="98%" ShowHeader="False" BackColor="White" BorderColor="White" BorderStyle="none" BorderWidth="0px" CellPadding="3" CellSpacing="1" GridLines="None">
        <RowStyle BackColor="#DEDFDE" ForeColor="Black" />
    </asp:GridView>

    <asp:Panel ID="BehaviorDetailsPanel" runat="server">
        <asp:Label ID="BehaviorDetailsLabel" runat="server" Text="Details of the behavior being coached:" Font-Names="Calibri" Font-Bold="True" />
        <br />
        
        <asp:Table ID="BehaviorDetailsTable" CellPadding="0" CellSpacing="0" runat="server" Style="border: 1px solid #cccccc; background-color: #f1f1ec; width: 490px;" class="review">
            <asp:TableRow>
                <asp:TableCell CssClass="wrapped">&nbsp;
                    <asp:Label ID="BehaviorDetailsValueLabel" runat="server"></asp:Label>
                </asp:TableCell></asp:TableRow>
        </asp:Table>
    </asp:Panel>

    <asp:Label ID="CustomerServiceEscalationLabel" runat="server" Text="Coaching Opportunity was a confirmed Customer Service Escalation" Font-Bold="True" Visible="false"></asp:Label>
    <asp:Panel ID="NonCustomerServiceEscalationPanel" runat="server" Visible="false">
        <asp:Panel ID="ManagementNotesPanel" runat="server" Visible="false">
            <asp:Label ID="ManagementNotesLabel" runat="server" Text="Management Notes:" Font-Names="Calibri" Font-Bold="True"></asp:Label><br />
            <asp:Table ID="ManagementNotesTable" CellPadding="0" CellSpacing="0" runat="server" Style="border: 1px solid #cccccc; background-color: #f1f1ec; width: 490px;" class="review">
                <asp:TableRow>
                    <asp:TableCell CssClass="wrapped">&nbsp;
                        <asp:Label ID="ManagementNotesValueLabel" runat="server" class="review"></asp:Label>
                    </asp:TableCell>
                </asp:TableRow>
            </asp:Table>
        </asp:Panel>
        <asp:Label ID="NonCustomerServiceEscalationLabel" runat="server" Text="Coaching Opportunity was not a confirmed Customer Service Escalation" Font-Bold="True"></asp:Label>
    </asp:Panel>

    <asp:Panel ID="CoachingNotesPanel" runat="server">
        <asp:Label ID="CoachingNotesLabel" runat="server" Text="Coaching Notes:" Font-Names="Calibri" Font-Bold="True"></asp:Label>
        <br />
        
        <asp:Table ID="CoachingNotesTabel" CellPadding="0" CellSpacing="0" runat="server" Style="border: 1px solid #cccccc; background-color: #f1f1ec; width: 490px;" class="review">
            <asp:TableRow>
                <asp:TableCell CssClass="wrapped">&nbsp;
                    <asp:Label ID="CoachingNotesValueLabel" runat="server"></asp:Label>
                </asp:TableCell>
            </asp:TableRow>
        </asp:Table>
    </asp:Panel>

    <asp:Label ID="EmployeeReviewInformationLabel" runat="server" Text="Employee Review Information:" Font-Names="Calibri" Font-Bold="True" />
    <br />

    <asp:Label ID="EmployeeNameValueLabel" runat="server" Font-Names="Calibri" />
    <br />

    <asp:Label ID="EmployeeReviewedDateLabel" runat="server" Text="Reviewed and acknowledged coaching opportunity on" Font-Names="Calibri" Font-Bold="False" />&nbsp;
    <asp:Label ID="EmployeeReviewedDateValueLabel" runat="server" Font-Names="Calibri" />
    <br />

    <asp:Panel ID="SupervisorReviewInformationPanel" runat="server" Visible="false" Style="margin-top: 5px;">
        <asp:Label ID="SupervisorReviewInformationLabel" runat="server" Text="Supervisor Review Information:" Font-Names="Calibri" Font-Bold="True" />
        <br />
        
        <asp:Label ID="SupervisorNameValueLabel" runat="server" Font-Names="Calibri" />
        <br />
        
        <asp:Label ID="SupervisorReviewedDateLabel" runat="server" Text="Reviewed and acknowledged Quality Monitor on" Font-Names="Calibri" Font-Bold="False" />&nbsp;
        <asp:Label ID="SupervisorReviewedDateValueLabel" runat="server" Font-Names="Calibri" />
        <br />
    </asp:Panel>

    <asp:Panel ID="EmployeeCommentsFeedbackPanel" runat="server" Visible="false" Style="margin-top: 5px;">
        <asp:Label ID="EmployeeCommentsFeedbackLabel" runat="server" Text="Employee Comments/Feedback:" Font-Names="Calibri" Font-Bold="True"></asp:Label>
        <br />
        
        <asp:Table ID="EmployeeCommentsFeedbackTable" CellPadding="0" CellSpacing="0" runat="server" Style="border: 1px solid #cccccc; background-color: #f1f1ec; width: 490px;" class="review">
            <asp:TableRow>
                <asp:TableCell CssClass="wrapped">&nbsp;
                    <asp:Label ID="EmployeeCommentsFeedbackValueLabel" runat="server"></asp:Label>
                </asp:TableCell>
            </asp:TableRow>
        </asp:Table>
    </asp:Panel>

</asp:content>

