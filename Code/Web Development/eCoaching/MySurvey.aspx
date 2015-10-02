<%@ Page Title="" Language="vb" AutoEventWireup="true" MasterPageFile="~/Site4.Master" CodeBehind="MySurvey.aspx.vb" Inherits="eCoachingFixed.MySurvey" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="MyScriptManager" runat="server"></asp:ScriptManager>

    <asp:UpdateProgress ID="UpdateProgress1" runat="server" DynamicLayout="true" DisplayAfter="0">
        <ProgressTemplate>
            <div class="pleaseWait">
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>

    <div class="mySurvey">
        <asp:UpdatePanel ID="MySurveyUpdatePanel" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <div class="success">
                    <asp:Label ID="SuccessMsgLabel" runat="server"/>
                </div>

                <div class="error">
                    <asp:Label ID="AccessDeniedMsgLabel" runat="server"/>
                </div>

                <asp:Panel ID="QuestionsPanel" runat="server">
                    <asp:Label ID="InstructionLabel" CssClass="description" Text="<%$ Resources:LocalizedText, MySurvey_Instruction %>" runat="server" EnableViewState="false" />
                    <br />
                    <br />
                    <div class="header">
                        <asp:Label ID="TitleLabel" Text="<%$ Resources:LocalizedText, MySurvey_Title %>" runat="server" EnableViewState="false" />&nbsp;
                        <asp:LinkButton ID="MySurveyLogLinkButton" runat="server" Text='' OnClientClick="return displayDetailModal();"></asp:LinkButton>
                    </div>

                    <div class="fail">
                        <asp:Label ID="FailMsgLabel" runat="server" EnableViewState="false" />
                    </div>

                    <%-- Question 1--%>
                    <asp:Label ID="Question1Label" CssClass="question" runat="server" AssociatedControlID="Question1RadioButtonList" />
                    <br />
                    <asp:RadioButtonList ID="Question1RadioButtonList" CssClass="radioButtonList" runat="server">
                    </asp:RadioButtonList>
                    <asp:Label ID="Question1TextBoxLabel" CssClass="subQuestion" runat="server" AssociatedControlID="Question1TextBox" />
                    <br />
                    <asp:TextBox ID="Question1TextBox" Rows="10" TextMode="MultiLine" runat="server" />
                    <br />

                    <%-- Question 2--%>
                    <br />
                    <asp:Label ID="Question2Label" CssClass="question" runat="server" AssociatedControlID="Question2RadioBUttonList" />
                    <br />
                    <asp:RadioButtonList ID="Question2RadioBUttonList" CssClass="radioButtonList" runat="server">
                    </asp:RadioButtonList>
                    <asp:Label ID="Question2TextBoxLabel" CssClass="subQuestion" runat="server" AssociatedControlID="Question2TextBox" />
                    <br />
                    <asp:TextBox ID="Question2TextBox" Rows="5" TextMode="MultiLine" runat="server" />

                    <%-- Question 3--%>
                    <br />
                    <br />
                    <asp:Label ID="Question3Label" CssClass="question" runat="server" AssociatedControlID="Question3RadioButtonList" />
                    <br />
                    <asp:RadioButtonList ID="Question3RadioButtonList" CssClass="radioButtonList" runat="server">
                    </asp:RadioButtonList>
                    <asp:Label ID="Question3TextBoxLabel" CssClass="subQuestion" runat="server" AssociatedControlID="Question3TextBox" />
                    <br />
                    <asp:TextBox ID="Question3TextBox" Rows="5" TextMode="MultiLine" runat="server" />

                    <%-- Question 4--%>
                    <br />
                    <br />
                    <asp:Label ID="Question4Label" CssClass="question" runat="server" AssociatedControlID="Question4RadioButtonList" />
                    <br />
                    <asp:RadioButtonList ID="Question4RadioButtonList" CssClass="radioButtonList" RepeatDirection="Horizontal" runat="server">
                    </asp:RadioButtonList>
                    <asp:Label ID="Question4TextBoxLabel" CssClass="subQuestion" runat="server" AssociatedControlID="Question4TextBox" />
                    <br />
                    <asp:TextBox ID="Question4TextBox" Rows="5" TextMode="MultiLine" runat="server" />

                    <%-- Question 5--%>
                    <br />
                    <br />
                    <asp:Label ID="Question5Label" CssClass="question" runat="server" AssociatedControlID="Question5RadioButtonList" />
                    <br />
                    <asp:RadioButtonList ID="Question5RadioButtonList" CssClass="radioButtonList" RepeatDirection="Horizontal" runat="server">
                    </asp:RadioButtonList>
                    <asp:Label ID="Question5TextBoxLabel" CssClass="subQuestion" runat="server" AssociatedControlID="Question5TextBox" />
                    <br />
                    <asp:TextBox ID="Question5TextBox" Rows="5" TextMode="MultiLine" runat="server" />

                    <%-- Hot Topic--%>
                    <asp:Panel ID="HotTopicPanel" runat="server" Visible="false">
                        <br />
                        <br />
                        <asp:Label ID="Question6Label" CssClass="question" runat="server" AssociatedControlID="Question6RadioButtonList" />
                        <br />
                        <asp:RadioButtonList ID="Question6RadioButtonList" CssClass="radioButtonList" runat="server">
                        </asp:RadioButtonList>
                        <asp:Label ID="Question6TextBoxLabel" CssClass="subQuestion" runat="server" AssociatedControlID="Question6TextBox" />
                        <br />
                        <asp:TextBox ID="Question6TextBox" Rows="5" TextMode="MultiLine" runat="server" />
                    </asp:Panel>

                    <%-- Additional Comments--%>
                    <br />
                    <br />
                    <asp:Label ID="CommentTextBoxLabel" CssClass="question" Text="<%$ Resources:LocalizedText, MySurvey_AdditionalComments %>" runat="server" AssociatedControlID="CommentTextBox" />
                    <br />
                    <asp:TextBox ID="CommentTextBox" Rows="5" TextMode="MultiLine" runat="server" />
                    <br />

                    <%-- Submit--%>
                    <br />
                    <br />
                    <div style="text-align: center">
                        <asp:Button ID="btnSubmit" CssClass="subuttons" Text="<%$ Resources:LocalizedText, Submit %>" runat="server" />
                    </div>
                </asp:Panel>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>

    <div id="LogDetailModal" class="modal fade" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog" >
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Log Detail</h4>
                </div>
                <div class="modal-body" id="detailDiv">
                   <iframe id="DetailFrame" src="MySurveyLogDetailView.aspx" style="border: 0; width: 100%; height: 100%"></iframe>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" data-dismiss="modal">Close</button>
                </div>
            </div><!-- /.modal-content -->
        </div><!-- /.modal-dialog -->
    </div><!-- /.modal -->

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <script>
        $(document).ready(function () {
            $("form").submit(function () {
                $('#<%= btnSubmit.ClientID%>').attr("disabled", "true");
            });

            Sys.WebForms.PageRequestManager.getInstance().add_endRequest(EndRequestHandler);
            function EndRequestHandler(sender, args) {
                scrollTo(0, 0);
            }
        });

        function displayDetailModal() {
            //$('#detailFrame').attr('src', $('#ViewNameHidden').val());
            $('#LogDetailModal').modal('show');
        }
    </script>
</asp:Content>


