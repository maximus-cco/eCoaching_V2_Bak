<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site3.Master"
    CodeBehind="default2.aspx.vb" Inherits="eCoachingFixed.default2" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ OutputCache Location="None" VaryByParam="None" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <!-- Page CSS -->
    <style type="text/css">
        .EMessage
        {
            display: block;
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

        function toggleCallID1(menyou, pnl, callbox, dropbox) {
            var panel;
            var boxcall;

            panel = document.getElementById(pnl);


            if (menyou == '1') {

                panel.style.display = 'inline';
                panel.style.visibility = 'visible';

            }

            else {

                boxcall = document.getElementById(callbox);
                boxcall.value = '';
                document.getElementById(dropbox).selectedIndex = 0;
                panel.style.display = 'none';
                panel.style.visbility = 'hidden';

            }

        }

        function toggle(menyou, pnl) {
            var panel;
            var i;
            var inputElement;
            var inputElementArray
            var panel2x;
            var rlistCSE;
            //       var dcse;

            var boxcall;
            var callmenu;
            var chosen1;


            if (pnl == 'csegroup') {

                panel = document.getElementById('<%= csegroup.ClientID %>');
                panel2x = document.getElementById('<%= nocsegroup.ClientID %>');




                if (menyou == '1') {
                    //hide all the non-cse menus


                    //
                    panel.style.display = 'inline';
                    panel.style.visibility = 'visible';
                    //                 dcse.checked = true;


                    //hide all the non-cse menus

                    //

                    panel2x.style.display = 'none';
                    panel2x.style.visibility = 'hidden';

                }

                else {
                    panel.style.display = 'none';
                    panel.style.visibility = 'hidden';
                    panel2x.style.display = 'inline';
                    panel2x.style.visibility = 'visible';
                    //             dcse.checked = false;

                }

            }




            // for Indirect



            if (pnl == 'csegroup2') {

                panel = document.getElementById('<%= csegroup2.ClientID %>');
                panel2x = document.getElementById('<%= nocsegroup2.ClientID %>');




                if (menyou == '1') {

                    panel.style.display = 'inline';
                    panel.style.visibility = 'visible';
                    //         dcse.checked = true;

                    //hide all the non-cse menus


                    //

                    panel2x.style.display = 'none';
                    panel2x.style.visibility = 'hidden';

                }

                else {

                    panel.style.display = 'none';
                    panel.style.visibility = 'hidden';
                    panel2x.style.display = 'inline';
                    panel2x.style.visibility = 'visible';
                    //     dcse.checked = false;

                }

            }


        }



        function toggle3(menyou, pnl) {

            // 
            var menu1 = document.getElementById("<%= warnlist2.ClientID %>");
            var menu2 = document.getElementById("<%= warnReasons.ClientID %>");
            var dateLabel = document.getElementById("<%= Labe27.ClientID %>");

            // var rbs = gv.getElementsByTagName('input');
            //var div = gv.getElementsByTagName('div');

            //var y = document.getElementById("Label80.ClientID");
            //var z = document.getElementById("Label83.ClientID");

            //  var row = radio.parentNode.parentNode;

            //   for (var i = 0; i < rbs.length; i++) {

            //     if (rbs[i].type == "radio") {
            //     rbs[i].checked = false;
            //   }
            // }

            var panel;
            var panel2;
            var panel3;
            var panel4;

            panel = document.getElementById('<%= warngroup1.ClientID %>');
            panel2 = document.getElementById('<%= nowarn.ClientID %>');
            panel3 = document.getElementById('<%= Panel6.ClientID %>');
            panel4 = document.getElementById('<%= Panel7.ClientID %>');

            //alert(menu1.selectedIndex);
            //alert(menu2.selectedIndex);

            menu1.selectedIndex = 0;
            menu2.selectedIndex = 0;




            if (menyou == '1') {

                // alert("open it");
                panel.style.display = 'inline';
                panel.style.visibility = 'visible';
                // alert("opened");
                panel2.style.display = 'none';
                panel2.style.visibility = 'hidden';
                panel3.style.display = 'none';
                panel3.style.visibility = 'hidden';
                panel4.style.display = 'none';
                panel4.style.visibility = 'hidden';

                //     alert(y.innerHTML.trim());
                //y.innerHTML = '9. ';

                //     alert(z.innerHTML.trim());
                //z.innerHTML = '10. ';

                dateLabel.innerHTML = 'Enter/Select the date the warning was issued:';

            }

            else {
                //alert("close it");


                panel.style.display = 'none';
                panel.style.visibility = 'hidden';
                //alert("closed")
                panel2.style.display = 'inline';
                panel2.style.visibility = 'visible';
                panel3.style.display = 'inline';
                panel3.style.visibility = 'visible';
                panel4.style.display = 'inline';
                panel4.style.visibility = 'visible';


                //    alert(y.innerHTML.trim());
                //y.innerHTML = '11. ';

                //    alert(z.innerHTML.trim());
                //z.innerHTML = '12. ';

                /// for (var j = 0; j < div.length; j++) {
                menu1.selectedIndex = 0;
                menu2.options.length = 0;


                var option = document.createElement("option");

                option.value = 'Select...';
                option.innerHTML = 'Select...';
                menu2.appendChild(option);


                dateLabel.innerHTML = 'Enter/Select the date of coaching:';
                //alert("testing");
                //alert(drop[j].type);
                //if (drop[j].type == "div") {
                //  alert("hello");

                ///  var dust = div[j].childNodes[0].id;
                //div[j].getElementsByTagName('select-multiple');
                //alert(dust);
                /// var drop = document.getElementById(dust);

                //alert(drop.selectedIndex);
                //alert(div[j].innerHTML.trim());
                //alert(div[j].type);
                //alert(div[j].childNodes[0].type); //select-multiple
                //alert(div[j].childNodes[0].innerHTML.trim());

                /// drop.selectedIndex = 0;

                /// div[j].style.display = 'none';
                ///div[j].style.visibility = 'hidden';

                //}

                ///}

            }
        }




        function CustomValidator1_ClientValidate(source, args) {


            if (document.getElementById("<%= RadioButton1.ClientID %>").checked || document.getElementById("<%= RadioButton2.ClientID %>").checked) {
                args.IsValid = true;
            }
            else {
                args.IsValid = false;
            }

        }


        function CustomValidator2_ClientValidate(source, args) {
            if (document.getElementById("<%= RadioButton3.ClientID %>").checked || document.getElementById("<%= RadioButton4.ClientID %>").checked) {
                args.IsValid = true;
            }
            else {
                args.IsValid = false;
            }

        }








        function togglemenu(check, menu, button, dropd) {

            var status = check.checked;
            //alert(status);
            // var rdio;
            var inputElementArray;


            //  alert(button);

            // alert(check.checked);
            if (status == true) {

                menu.style.display = 'inline';
                menu.style.visibility = 'visible';
                //    button.disabled = false;
                //   button.parentElement.disabled = false;
                //  button.removeAttribute('disabled');
                //' alert(valid2);

                //  valid2.style.display = 'inline';
                //valid2.style.visibility = "visible";
                ///   ValidatorEnable(valid1, true);
                ///  valid1.enabled = true;

                ///   ValidatorEnable(valid2, true);

                ///  valid2.enabled = true;

                RecursiveDisable(button);
                // check.checked
            }

            else {

                menu.style.display = 'none';
                menu.style.visibility = 'hidden';
                // valid2;
                // alert(valid2.enable);
                //valid2.isValid = true;

                dropd.selectedIndex = 0;

                /// ValidatorEnable(valid1, false);
                /// valid1.enabled = false;

                /// ValidatorEnable(valid2, false);
                //valid2.style.display = 'none';
                //valid2.style.visibility = 'hidden';
                // valid2.isValid = false;
                //valid2.enabled = false;



                inputElementArray = button.getElementsByTagName('input');

                for (i = 0; i < inputElementArray.length; i++) {
                    inputElement = inputElementArray[i];

                    inputElement.checked = false;
                }
                button.disabled = 'disabled';
                //valid2.enabled = false;

            }


            //alert(menu);

            // alert(status);


        }


        function togglemenu2(radio, grid, panel) {
            // alert("hello");
            // alert(radio);
            // alert(grid);
            // alert(panel);
            // alert(valid1);
            // alert(dropd);

            var gv = document.getElementById(grid.id);
            //alert(gv);
            var rbs = gv.getElementsByTagName('input');
            var div = gv.getElementsByTagName('div');
            //var row = radio.parentNode.parentNode;
            // alert(rbs.length);
            for (var i = 0; i < rbs.length; i++) {
                //alert(rbs[i].type);
                if (rbs[i].type == "radio") {

                    if (rbs[i].checked && rbs[i] != radio) {
                        rbs[i].checked = false;
                        //break;
                    }

                }

            }

            // alert(div.length);
            for (var j = 0; j < div.length; j++) {
                // alert(div[j].id);
                //alert(panel.id);

                var dust = div[j].childNodes[0].id;
                var drop = document.getElementById(dust);

                if (div[j].id != panel.id) {

                    //  alert(drop.selectedIndex);
                    drop.selectedIndex = 0;

                    div[j].style.display = 'none';
                    div[j].style.visibility = 'hidden';
                    //  alert("testing");
                }
                else {
                    // alert(drop.selectedIndex);
                    div[j].style.display = 'inline';
                    div[j].style.visibility = 'visible';
                    // alert("testing");

                }

                //  alert("testing1");
            }
            // alert("testing2");

        }



        function RecursiveDisable(control) { //enables the children of radio buttons
            var children = control.childNodes;
            try { control.removeAttribute('disabled') }
            catch (ex) { }
            for (var j = 0; j < children.length; j++) {
                RecursiveDisable(children[j]);
                //control.attributes['disabled'].value = '';    

            }
        } 
    </script>
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="ContentPlaceHolder3" runat="server">
    <br />
    <br />
    <asp:Label ID="Label150" CssClass="description" runat="server" Text="Welcome to the eCoaching Log. Please note that all fields are required."
        ViewStateMode="Disabled"></asp:Label>
    <br />
    <br />
    <br />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <asp:UpdateProgress ID="UpdateProgress1" runat="server" DynamicLayout="true" DisplayAfter="0">
                <ProgressTemplate>
                    <div style="text-align: center;">
                        loading...<br />
                        <img src="images/ajax-loader5.gif" alt="progress animation gif" style="width: 180px" /></div>
                </ProgressTemplate>
            </asp:UpdateProgress>
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
            <asp:Label ID="Label241" runat="server" Text="" Visible="false" ViewStateMode="Disabled"></asp:Label>
            <asp:SqlDataSource ID="SqlDataSource25" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                SelectCommand="EC.sp_Select_Email_Attributes" SelectCommandType="StoredProcedure"
                DataSourceMode="DataReader">
                <SelectParameters>
                    <asp:Parameter Name="strModulein" Direction="Input" Type="String" />
                    <asp:Parameter Name="intSourceIDin" Direction="Input" Type="Int32" />
                    <asp:Parameter Name="bitisCSEin" Direction="Input" Type="Boolean" />
                </SelectParameters>
            </asp:SqlDataSource>
            <asp:GridView ID="GridView8" runat="server" AutoGenerateColumns="False">
                <Columns>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:Label ID="statusID" runat="server" Text='<%# Eval("StatusID") %>'></asp:Label>
                            <asp:Label ID="statusName" runat="server" Text='<%# Eval("StatusName") %>'></asp:Label>
                            <asp:Label ID="receiver" runat="server" Text='<%# Eval("Receiver") %>'></asp:Label>
                            <asp:Label ID="mailText" runat="server" Text='<%# Eval("EmailText").ToString().Replace(Environment.NewLine,"<br />") %>'></asp:Label>
                            <asp:Label ID="isCC" runat="server" Text='<%# Eval("isCCReceiver") %>'></asp:Label>
                            <asp:Label ID="ccReceiver" runat="server" Text='<%# Eval("CCReceiver") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
            <asp:Panel ID="Panel28" runat="server" Visible="true" HorizontalAlign="Center" Width="100%"
                Style="border-bottom-color: Gray; border-bottom-style: solid; border-bottom-width: 5px;">
                <asp:Table ID="Table2" runat="server">
                    <asp:TableRow>
                        <asp:TableCell HorizontalAlign="Left">
                            <asp:Label ID="Label38" runat="server" Text="Select Coaching Module:" CssClass="question"
                                ViewStateMode="Disabled"></asp:Label>
                            &nbsp;<asp:Label ID="Label40" runat="server" Text="*" CssClass="EMessage" Width="10px"></asp:Label>
                        </asp:TableCell>
                    </asp:TableRow>
                    <asp:TableRow>
                        <asp:TableCell HorizontalAlign="Left">
                            <asp:DropDownList ID="DropDownList3" DataSourceID="SqlDataSource15" DataValueField="BySite"
                                CssClass="TextBox" DataTextField="Module" AutoPostBack="true" AppendDataBoundItems="true"
                                runat="server" OnSelectedIndexChanged="DropDownList3_SelectedIndexChanged" Style="margin-right: 5px;">
                                <asp:ListItem Value="Select..." Selected="True">Select...</asp:ListItem>
                            </asp:DropDownList>
                            <asp:SqlDataSource ID="SqlDataSource15" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                                SelectCommand="EC.sp_Select_Modules_By_Job_Code" SelectCommandType="StoredProcedure"
                                DataSourceMode="DataReader" EnableViewState="False" ViewStateMode="Disabled">
                                <SelectParameters>
                                    <asp:Parameter Name="nvcEmpLanIDin" Type="String" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                        </asp:TableCell>
                    </asp:TableRow>
                </asp:Table>
                <br />
            </asp:Panel>
            <br />
            <asp:Panel ID="Panel0" runat="server" Visible="false">
                <div align="center">
                    <asp:Label ID="Label13" CssClass="description" runat="server" Text="Please do NOT include PII or PHI in the log entry."
                        ViewStateMode="Disabled" ForeColor="Red" Style="font-weight: bold; text-align: center"></asp:Label>
                </div>
                <br />
                <asp:Panel ID="Panel29" runat="server" Visible="false">
                    <asp:Label ID="Label9" runat="server" Text="1. Select Employee Site:" CssClass="question"
                        ViewStateMode="Disabled"></asp:Label>
                    &nbsp;<asp:Label ID="Label175" runat="server" Text="*" CssClass="EMessage" Width="10px"></asp:Label><asp:RequiredFieldValidator
                        ID="RequiredFieldValidator4" runat="server" ControlToValidate="DropDownList1"
                        InitialValue="Select..." ErrorMessage="Select an Employee site option." CssClass="EMessage"
                        Display="Dynamic" Width="200px" EnableClientScript="false">Select an Employee site option.&nbsp;</asp:RequiredFieldValidator>
                    <br />
                    <asp:DropDownList ID="DropDownList1" DataSourceID="SqlDataSource3" runat="server"
                        CssClass="TextBox" DataTextField="City" AppendDataBoundItems="true" DataValueField="SiteID"
                        OnSelectedIndexChanged="DropDownList1_SelectedIndexChanged" AutoPostBack="True">
                        <asp:ListItem Value="Select..." Selected="True">Select...</asp:ListItem>
                    </asp:DropDownList>
                    &nbsp;
                    <br />
                    <asp:SqlDataSource ID="SqlDataSource3" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                        SelectCommand="EC.sp_Display_Sites_For_Module" SelectCommandType="StoredProcedure"
                        DataSourceMode="DataReader" EnableViewState="False" ViewStateMode="Disabled">
                        <SelectParameters>
                            <asp:Parameter Name="strModulein" Type="String" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                    <br />
                </asp:Panel>
                <asp:Label ID="Label41" runat="server" CssClass="question" ViewStateMode="Enabled"></asp:Label>
                <asp:Label ID="Label3" runat="server" Text="Select Employee Name:" CssClass="question"
                    ViewStateMode="Disabled"></asp:Label>
                &nbsp;<asp:Label ID="Label170" runat="server" Text="*" CssClass="EMessage" Width="10px"></asp:Label>
                &nbsp;<asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="ddCSR"
                    InitialValue="Select..." ErrorMessage="Select an employee." CssClass="EMessage"
                    Display="Dynamic" Width="200px">Select an employee.&nbsp;</asp:RequiredFieldValidator>
                <asp:CustomValidator ID="CustomValidator4" runat="server" Display="Dynamic" CssClass="EMessage"
                    Width="350px" ErrorMessage="You may not submit a coaching for yourself. Please select another employee."
                    OnServerValidate="CustomValidator4_ServerValidate"></asp:CustomValidator>
                <br />
                <asp:DropDownList ID="ddCSR" DataTextField="FrontRow1" DataValueField="BackRow1"
                    CssClass="TextBox" DataSourceID="SqlDataSource1" AppendDataBoundItems="true"
                    runat="server" OnSelectedIndexChanged="CSRDropDownList_SelectedIndexChanged2"
                    AutoPostBack="True">
                    <asp:ListItem Value="Select..." Selected="True">Select...</asp:ListItem>
                </asp:DropDownList>
                <br />
                <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_Select_Employees_By_Module" SelectCommandType="StoredProcedure"
                    DataSourceMode="DataReader" EnableViewState="False" ViewStateMode="Disabled">
                    <SelectParameters>
                        <asp:Parameter Name="strModulein" Type="String" />
                        <asp:Parameter Name="strCSRSitein" Type="String" />
                        <asp:Parameter Name="strUserLanin" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <br />
                <asp:Label ID="Label42" runat="server" CssClass="question" ViewStateMode="Enabled"></asp:Label><asp:Label
                    ID="Label5" runat="server" Text="Employee Supervisor:" CssClass="question" ViewStateMode="Disabled"></asp:Label>
                &nbsp;
                <br />
                <asp:Label ID="SupervisorDropDownList" runat="server" Text=""></asp:Label>
                <br />
                <br />
                <asp:Label ID="Label43" runat="server" CssClass="question" ViewStateMode="Enabled"></asp:Label><asp:Label
                    ID="Label7" runat="server" Text="Employee Manager:" CssClass="question" ViewStateMode="Disabled"></asp:Label>
                &nbsp;
                <br />
                <asp:Label ID="MGRDropDownList" runat="server" Text=""></asp:Label>
                <br />
                <asp:Panel ID="Panel8" runat="server" Visible="true">
                    <br />
                    <asp:Label ID="Label61" runat="server" CssClass="question" ViewStateMode="Enabled"></asp:Label><asp:Label
                        ID="Label243" runat="server" Text="Select the appropriate program for this coaching:"
                        CssClass="question" ViewStateMode="Disabled"></asp:Label>
                    &nbsp;<asp:Label ID="Label244" runat="server" Text="*" CssClass="EMessage" Width="10px"></asp:Label>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator22" runat="server" ControlToValidate="programList"
                        InitialValue="Select..." ErrorMessage="Select a program option." CssClass="EMessage"
                        Display="Dynamic" Width="200px" EnableClientScript="false">Select a program option.&nbsp;</asp:RequiredFieldValidator>
                    <br />
                    <asp:DropDownList ID="programList" runat="server" AppendDataBoundItems="true" DataSourceID="SqlDataSource4"
                        CssClass="TextBox" DataTextField="Program" DataValueField="Program" AutoPostBack="True"
                        OnSelectedIndexChanged="ProgramList_SelectedIndexChanged">
                        <asp:ListItem Value="Select...">Select...</asp:ListItem>
                    </asp:DropDownList>
                    &nbsp;
                    <asp:SqlDataSource ID="SqlDataSource4" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                        SelectCommand="EC.sp_Select_Programs" SelectCommandType="StoredProcedure" DataSourceMode="DataReader"
                        EnableViewState="False" ViewStateMode="Disabled">
                        <SelectParameters>
                            <asp:Parameter Name="strModulein" Type="String" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                    <br />
                </asp:Panel>
                <asp:Panel ID="Panel9" runat="server" Visible="false">
                    <br />
                    <asp:Label ID="Label96" runat="server" CssClass="question" ViewStateMode="Enabled"></asp:Label><asp:Label
                        ID="Label97" runat="server" Text="Select the appropriate behavior for this coaching:"
                        CssClass="question" ViewStateMode="Disabled"></asp:Label>
                    &nbsp;<asp:Label ID="Label98" runat="server" Text="*" CssClass="EMessage" Width="10px"></asp:Label>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator10" runat="server" ControlToValidate="behaviorList"
                        InitialValue="Select..." ErrorMessage="Select a behavior option." CssClass="EMessage"
                        Display="Dynamic" Width="200px" EnableClientScript="false" Enabled="false">Select a behavior option.&nbsp;</asp:RequiredFieldValidator>
                    <br />
                    <asp:DropDownList ID="behaviorList" runat="server" AppendDataBoundItems="true" DataSourceID="SqlDataSource28"
                        CssClass="TextBox" DataTextField="Behavior" DataValueField="Behavior" AutoPostBack="True"
                        OnSelectedIndexChanged="BehaviorList_SelectedIndexChanged">
                        <asp:ListItem Value="Select...">Select...</asp:ListItem>
                    </asp:DropDownList>
                    &nbsp;
                    <asp:SqlDataSource ID="SqlDataSource28" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                        SelectCommand="EC.sp_Select_Behaviors" SelectCommandType="StoredProcedure" DataSourceMode="DataReader"
                        EnableViewState="False" ViewStateMode="Disabled">
                        <SelectParameters>
                            <asp:Parameter Name="strModulein" Type="String" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                    <br />
                </asp:Panel>
                <br />
                <asp:Label ID="Label63" runat="server" CssClass="question" ViewStateMode="Enabled"></asp:Label><asp:Label
                    ID="Label11" runat="server" Text="Will you be delivering the coaching session?"
                    CssClass="question"></asp:Label>&nbsp;<asp:Label ID="Label171" runat="server" Text="*"
                        CssClass="EMessage" Width="10px"></asp:Label>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ControlToValidate="RadioButtonList1"
                    ErrorMessage="Select a coaching delivery option." CssClass="EMessage" Display="Dynamic"
                    Width="300px" EnableClientScript="false">Select a coaching delivery option.&nbsp;</asp:RequiredFieldValidator>
                <asp:Table ID="Table3" runat="server">
                    <asp:TableRow>
                        <asp:TableCell RowSpan="2">
                            <asp:RadioButtonList ID="RadioButtonList1" runat="server" OnSelectedIndexChanged="RadioButtonList1_SelectedIndexChanged"
                                AutoPostBack="True">
                                <asp:ListItem Value="Direct" style="border: 2px;" Text=""></asp:ListItem>
                                <asp:ListItem Value="Indirect" style="border: 2px;" Text=""></asp:ListItem>
                            </asp:RadioButtonList>
                        </asp:TableCell><asp:TableCell VerticalAlign="Middle">
                            <asp:Label ID="Label184" runat="server" Text="<strong>Yes</strong>, I will be delivering the coaching session."
                                CssClass="question2" ViewStateMode="Disabled"></asp:Label></asp:TableCell>
                    </asp:TableRow>
                    <asp:TableRow>
                        <asp:TableCell VerticalAlign="Middle">
                            <asp:Label ID="Label185" runat="server" Text="<strong>No</strong>, I will not be delivering the coaching session."
                                CssClass="question2" ViewStateMode="Disabled"></asp:Label></asp:TableCell></asp:TableRow>
                </asp:Table>
                <asp:Label ID="Label230" runat="server" CssClass="EMessage" Visible="True" Text="&nbsp;"></asp:Label>
                <asp:Table ID="Table4" Width="100%" runat="server" Height="60px" Visible="false">
                    <asp:TableRow>
                        <asp:TableCell Width="120px">
                            <asp:Button ID="Next1" runat="server" Text="Next" UseSubmitBehavior="False" Height="40px"
                                Width="115px" Font-Bold="true" Enabled="False" /></asp:TableCell><asp:TableCell HorizontalAlign="Left"
                                    VerticalAlign="Middle">&nbsp;</asp:TableCell></asp:TableRow>
                </asp:Table>
            </asp:Panel>
            <asp:Panel ID="Panel1" runat="server" Visible="false">
                <asp:Label ID="Label1" runat="server" Text="Indirect" Visible="False" ViewStateMode="Disabled"></asp:Label>
                <asp:Label ID="Label66" runat="server" Text="" CssClass="question" ViewStateMode="Enabled"></asp:Label><asp:Label
                    ID="Label14" runat="server" Text="Enter/Select the date of event:" CssClass="question"
                    ViewStateMode="Disabled"></asp:Label>&nbsp;<asp:Label ID="Label218" runat="server"
                        Text="*" CssClass="EMessage" Width="10px"></asp:Label>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator14" runat="server" ControlToValidate="Date1"
                    ErrorMessage="Enter a valid event date." CssClass="EMessage" Display="Dynamic"
                    Width="200px" Enabled="False">Enter a valid event date.</asp:RequiredFieldValidator>
                <asp:CompareValidator ID="CompareValidator1" runat="server" Display="Dynamic" Operator="LessThanEqual"
                    Type="Date" ControlToValidate="Date1" ErrorMessage="Enter today's date or a date in the past. You are not allowed to enter a future date."
                    CssClass="EMessage" Width="490px" Enabled="False">Enter today's date or a date in the past. You are not allowed to enter a future date.</asp:CompareValidator>
                <br />
                <asp:TextBox runat="server" class="qcontrol" ID="Date1" Width="100px" ViewStateMode="Disabled" />&nbsp;
                <asp:Image runat="server" ID="cal1" ImageUrl="images/Calendar_scheduleHS.png" />
                <asp:CalendarExtender ID="CalendarExtender1" runat="server" Enabled="true" TargetControlID="Date1"
                    PopupButtonID="cal1">
                </asp:CalendarExtender>
                <br />
                <br />
                <asp:Panel ID="Panel3" runat="server">
                    <asp:Label ID="Label72" runat="server" Text="" CssClass="question" ViewStateMode="Enabled"></asp:Label><asp:Label
                        ID="Label16" runat="server" Text="Is this a Customer Service Escalation (CSE)?"
                        CssClass="question" ViewStateMode="Disabled"></asp:Label>
                    &nbsp;<asp:Label ID="Label219" runat="server" Text="*" CssClass="EMessage" Width="10px"></asp:Label>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ControlToValidate="cseradio2"
                        ErrorMessage="Indicate whether this is a CSE or not." CssClass="EMessage" Display="Dynamic"
                        Width="400px">Indicate whether this is a CSE or not.&nbsp;</asp:RequiredFieldValidator>
                    <asp:Table ID="Table19" runat="server">
                        <asp:TableRow>
                            <asp:TableCell>
                                <asp:RadioButtonList ID="cseradio2" runat="server" AutoPostBack="true">
                                    <asp:ListItem Value="Yes" Text="Yes" onClick="javascript: toggle('1','csegroup2');"></asp:ListItem>
                                    <asp:ListItem Value="No" Text="No" onClick="javascript: toggle('0','csegroup2');"
                                        Selected="True"></asp:ListItem>
                                </asp:RadioButtonList>
                            </asp:TableCell>
                        </asp:TableRow>
                    </asp:Table>
                    <br />
                </asp:Panel>
                <asp:Label ID="Label73" runat="server" Text="" CssClass="question" ViewStateMode="Enabled"></asp:Label><asp:Label
                    ID="Label18" runat="server" Text="Select the type of coaching from the categories below:"
                    CssClass="question" ViewStateMode="Disabled"></asp:Label>
                &nbsp;
                <br />
                <br />
                <asp:Label ID="Label91" runat="server" Text="Coaching Reasons"></asp:Label>
                <asp:Label ID="lblErrorMsgMaxReasonsIndirect" runat="server" Text="" CssClass="EMessage"></asp:Label>
                <div runat="server" id="csegroup2" style="visibility: visible; display: inline;">
                    <asp:GridView ID="GridView6" runat="server" AutoGenerateColumns="False" GridLines="None"
                        DataSourceID="SqlDataSource21" Width="536px">
                        <Columns>
                            <asp:TemplateField SortExpression="CoachingReason">
                                <ItemTemplate>
                                    <asp:CheckBox ID="check1" runat="server" />
                                    <asp:Label ID="Label1" runat="server" CssClass="description" Text='<%# Bind("CoachingReason") %>'></asp:Label>
                                    <asp:Label ID="Label65" runat="server" Text='<%# Bind("CoachingReasonID") %>' Visible="false"></asp:Label>
                                    <br />
                                    <asp:Panel ID="sub1" runat="server" Style="visibility: hidden; display: none;">
                                        <asp:ListBox ID="SubReasons" runat="server" DataTextField="SubCoachingReason" DataValueField="SubCoachingReasonID"
                                            AppendDataBoundItems="true" SelectionMode="Multiple" class="TextBox">
                                            <asp:ListItem Value="" Selected="True"></asp:ListItem>
                                        </asp:ListBox>
                                        <br />
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="SubReasons"
                                            InitialValue="" ErrorMessage="Please select a coaching sub reason." CssClass="EMessage"
                                            Enabled="false" Display="Dynamic" Width="425px">Please select a coaching sub reason.</asp:RequiredFieldValidator>
                                    </asp:Panel>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <asp:RadioButtonList ID="buttons1" runat="server" Width="306px" RepeatColumns="2"
                                        RepeatDirection="Horizontal" DataTextField="Value" Enabled="false">
                                        <asp:ListItem class="croptions"></asp:ListItem>
                                    </asp:RadioButtonList>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" Enabled="false"
                                        ControlToValidate="buttons1" CssClass="EMessage" Display="Dynamic" ErrorMessage="You must also select Opportunity or Reinforcement">You must also select "Opportunity" or "Reinforcement"</asp:RequiredFieldValidator>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                    <asp:SqlDataSource ID="SqlDataSource21" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                        SelectCommand="EC.sp_Select_CoachingReasons_By_Module" SelectCommandType="StoredProcedure"
                        DataSourceMode="DataReader" EnableViewState="True" ViewStateMode="Enabled">
                        <SelectParameters>
                            <asp:Parameter Name="strModulein" Type="String" />
                            <asp:Parameter Name="strSourcein" Type="String" />
                            <asp:Parameter Name="isSplReason" Type="String" />
                            <asp:Parameter Name="splReasonPrty" Type="Int32" />
                            <asp:Parameter Name="strCSRin" Type="String" />
                            <asp:Parameter Name="strSubmitterin" Type="String" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                    <asp:SqlDataSource ID="SqlDataSource22" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                        SelectCommand="EC.sp_Select_SubCoachingReasons_By_Reason" SelectCommandType="StoredProcedure"
                        DataSourceMode="DataReader" EnableViewState="true" ViewStateMode="Enabled">
                        <SelectParameters>
                            <asp:Parameter Name="strReasonin" Type="String" />
                            <asp:Parameter Name="strModulein" Type="String" />
                            <asp:Parameter Name="strSourcein" Type="String" />
                            <asp:Parameter Name="nvcEmpLanIDin" Type="String" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                    <asp:SqlDataSource ID="SqlDataSource23" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                        SelectCommand="EC.sp_Select_Values_By_Reason" SelectCommandType="StoredProcedure"
                        DataSourceMode="DataReader" EnableViewState="true" ViewStateMode="Enabled">
                        <SelectParameters>
                            <asp:Parameter Name="strReasonin" Type="String" />
                            <asp:Parameter Name="strModulein" Type="String" />
                            <asp:Parameter Name="strSourcein" Type="String" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                </div>
                <br />
                <div runat="server" id="nocsegroup2" style="visibility: visible; display: inline;">
                    <asp:GridView ID="GridView2" runat="server" AutoGenerateColumns="False" GridLines="None"
                        DataSourceID="SqlDataSource10" Width="536px">
                        <Columns>
                            <asp:TemplateField SortExpression="CoachingReason">
                                <ItemTemplate>
                                    <asp:CheckBox ID="check1" runat="server" />
                                    <asp:Label ID="Label1" runat="server" CssClass="description" Text='<%# Bind("CoachingReason") %>'></asp:Label>
                                    <asp:Label ID="Label65" runat="server" Text='<%# Bind("CoachingReasonID") %>' Visible="false"></asp:Label>
                                    <br />
                                    <asp:Panel ID="sub1" runat="server" Style="visibility: hidden; display: none;">
                                        <asp:ListBox ID="SubReasons" runat="server" DataTextField="SubCoachingReason" DataValueField="SubCoachingReasonID"
                                            AppendDataBoundItems="true" SelectionMode="Multiple" class="TextBox">
                                            <asp:ListItem Value="" Selected="True"></asp:ListItem>
                                        </asp:ListBox>
                                        <br />
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="SubReasons"
                                            InitialValue="" ErrorMessage="Please select a coaching sub reason." CssClass="EMessage"
                                            Enabled="false" Display="Dynamic" Width="425px">Please select a coaching sub reason.</asp:RequiredFieldValidator>
                                    </asp:Panel>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <asp:RadioButtonList ID="buttons1" runat="server" Width="306px" RepeatColumns="2"
                                        RepeatDirection="Horizontal" Enabled="false" DataTextField="Value">
                                        <asp:ListItem class="croptions"></asp:ListItem>
                                    </asp:RadioButtonList>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" Enabled="false"
                                        ControlToValidate="buttons1" CssClass="EMessage" Display="Dynamic" ErrorMessage="You must also select Opportunity or Reinforcement">You must also select "Opportunity" or "Reinforcement"</asp:RequiredFieldValidator>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                    <asp:SqlDataSource ID="SqlDataSource10" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                        SelectCommand="EC.sp_Select_CoachingReasons_By_Module" SelectCommandType="StoredProcedure"
                        DataSourceMode="DataReader" EnableViewState="True" ViewStateMode="Enabled">
                        <SelectParameters>
                            <asp:Parameter Name="strModulein" Type="String" />
                            <asp:Parameter Name="strSourcein" Type="String" />
                            <asp:Parameter Name="isSplReason" Type="String" />
                            <asp:Parameter Name="splReasonPrty" Type="Int32" />
                            <asp:Parameter Name="strCSRin" Type="String" />
                            <asp:Parameter Name="strSubmitterin" Type="String" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                    <asp:SqlDataSource ID="SqlDataSource11" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                        SelectCommand="EC.sp_Select_SubCoachingReasons_By_Reason" SelectCommandType="StoredProcedure"
                        DataSourceMode="DataReader" EnableViewState="true" ViewStateMode="Enabled">
                        <SelectParameters>
                            <asp:Parameter Name="strReasonin" Type="String" />
                            <asp:Parameter Name="strModulein" Type="String" />
                            <asp:Parameter Name="strSourcein" Type="String" />
                            <asp:Parameter Name="nvcEmpLanIDin" Type="String" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                    <asp:SqlDataSource ID="SqlDataSource17" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                        SelectCommand="EC.sp_Select_Values_By_Reason" SelectCommandType="StoredProcedure"
                        DataSourceMode="DataReader" EnableViewState="true" ViewStateMode="Enabled">
                        <SelectParameters>
                            <asp:Parameter Name="strReasonin" Type="String" />
                            <asp:Parameter Name="strModulein" Type="String" />
                            <asp:Parameter Name="strSourcein" Type="String" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                </div>
                <asp:TextBox ID="Label239" runat="server" Visible="false" Text="valid"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator7" Enabled="False" ControlToValidate="Label239"
                    CssClass="EMessage" ErrorMessage="At least one coaching reason above must be selected to continue."
                    runat="server" Display="Dynamic" EnableClientScript="false">At least one coaching reason above must be selected to continue.</asp:RequiredFieldValidator>
                <br />
                <asp:Label ID="Label74" runat="server" Text="" CssClass="question" ViewStateMode="Enabled"></asp:Label><asp:Label
                    ID="Label26" runat="server" CssClass="question" Text="Provide details of the behavior to be coached:"
                    ViewStateMode="Disabled"></asp:Label>
                &nbsp;<asp:Label ID="Label235" runat="server" Text="*" CssClass="EMessage" Width="10px"></asp:Label>
                <br />
                <asp:TextBox ID="TextBox5" runat="server" Rows="10" TextMode="MultiLine" CssClass="tboxes"
                    onkeyup="return textboxMultilineMaxNumber(this)" ViewStateMode="Disabled"></asp:TextBox>
                <br />
                <asp:Label ID="Label231" runat="server" Text="[max length: 3,000 chars]"></asp:Label>
                <br />
                <asp:Label ID="Label216" runat="server" Text="Provide as much detail as possible"
                    ViewStateMode="Disabled"></asp:Label>
                <br />
                <br />
                <asp:RequiredFieldValidator ID="RequiredFieldValidator48" ControlToValidate="TextBox5"
                    CssClass="EMessage" ErrorMessage="Please provide details of the behavior to be coached."
                    runat="server" Display="Dynamic" Enabled="false">Please provide details of the behavior to be coached.</asp:RequiredFieldValidator>
                <br />
                <asp:Label ID="Label75" runat="server" Text="" CssClass="question" ViewStateMode="Enabled"></asp:Label><asp:Label
                    ID="Label20" runat="server" Text="How was the coaching opportunity identified?"
                    CssClass="question" ViewStateMode="Disabled"></asp:Label>&nbsp;<asp:Label ID="Label22"
                        runat="server" Text="*" CssClass="EMessage" Width="10px"></asp:Label>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="howid2"
                    InitialValue="Select..." ErrorMessage="Please select how the coaching was identified."
                    CssClass="EMessage" Enabled="false" Display="Dynamic" Width="425px" EnableClientScript="false">Please select how the coaching was identified.</asp:RequiredFieldValidator>
                <br />
                <asp:DropDownList ID="howid2" DataTextField="Source" DataValueField="SourceID" DataSourceID="SqlDataSource5"
                    AppendDataBoundItems="true" CssClass="qcontrol" runat="server" ToolTip="Please select how the coaching was identified.">
                    <asp:ListItem Value="Select..." Selected="True">Select...</asp:ListItem>
                </asp:DropDownList>
                &nbsp;
                <asp:SqlDataSource ID="SqlDataSource5" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_Select_Source_By_Module" SelectCommandType="StoredProcedure"
                    DataSourceMode="DataReader" EnableViewState="False" ViewStateMode="Enabled">
                    <SelectParameters>
                        <asp:Parameter Name="strModulein" Type="String" />
                        <asp:Parameter Name="strSourcein" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <br />
                <br />
                <asp:Label ID="Label76" runat="server" Text="" CssClass="question" ViewStateMode="Enabled"></asp:Label><asp:Label
                    ID="Label25" runat="server" Text="Is there a Call Record associated with this coaching?"
                    CssClass="question" ViewStateMode="Disabled"></asp:Label>&nbsp;<asp:Label ID="Label33"
                        runat="server" Text="*" CssClass="EMessage" Width="10px"></asp:Label>
                <asp:CustomValidator ID="CustomValidator1" runat="server" Display="Dynamic" CssClass="EMessage"
                    Width="350px" ErrorMessage="Indicate if the item has a Call Record or a NGD Activity ID."
                    ClientValidationFunction="CustomValidator2_ClientValidate" OnServerValidate="CustomValidator2_ServerValidate"></asp:CustomValidator>
                <asp:Table ID="Table1" runat="server" Width="75%">
                    <asp:TableRow>
                        <asp:TableCell>
                            <asp:RadioButton ID="RadioButton3" runat="server" GroupName="CallRecord2" Text="Yes" /></asp:TableCell>
                    </asp:TableRow>
                </asp:Table>
                <div runat="server" id="panel2c2" style="visibility: hidden; display: none;">
                    <asp:Table ID="Table33" runat="server" Style="margin-left: 20px">
                        <asp:TableRow>
                            <asp:TableCell>
                                <asp:DropDownList ID="calltype2" AppendDataBoundItems="true" DataSourceID="SqlDataSource8"
                                    CssClass="qcontrol" DataTextField="CallIdType" DataValueField="IdFormat" runat="server"
                                    ToolTip="Please select a call record type for this coaching.">
                                </asp:DropDownList>
                                <asp:TextBox ID="callID2" runat="server" CssClass="qcontrol"></asp:TextBox>&nbsp;
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="callID2"
                                    ErrorMessage="Enter a Call Record number for this coaching." CssClass="EMessage"
                                    Display="Dynamic" Enabled="false"><span>Enter a Call Record number for this coaching.</span></asp:RequiredFieldValidator>
                                <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ControlToValidate="callID2"
                                    ErrorMessage="Call Record IDs must be in the correct format." ValidationExpression="^[a-zA-Z0-9_]{18,26}$"
                                    CssClass="EMessage" Display="Dynamic" Enabled="false"><span>Call Record IDs must be in the correct format.</span></asp:RegularExpressionValidator>
                                <asp:SqlDataSource ID="SqlDataSource8" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                                    SelectCommand="EC.sp_Select_CallID_By_Module" SelectCommandType="StoredProcedure"
                                    DataSourceMode="DataReader" EnableViewState="True" ViewStateMode="Enabled">
                                    <SelectParameters>
                                        <asp:Parameter Name="strModulein" Type="String" />
                                    </SelectParameters>
                                </asp:SqlDataSource>
                            </asp:TableCell>
                        </asp:TableRow>
                    </asp:Table>
                </div>
                <asp:Table ID="Table32" runat="server" Width="75%">
                    <asp:TableRow>
                        <asp:TableCell>
                            <asp:RadioButton ID="RadioButton4" runat="server" GroupName="CallRecord2" Checked="True"
                                Text="No" /></asp:TableCell>
                    </asp:TableRow>
                </asp:Table>
                <br />
                <asp:CheckBox ID="CheckBox1" runat="server" Text="I have verfied that all the information on this form is true and complete to 
        the best of my knowledge." />&nbsp;<asp:Label ID="Label223" runat="server" Text="*"
            CssClass="EMessage" Width="10px"></asp:Label><br />
                <asp:CustomValidator runat="server" ID="CheckBoxRequired" EnableClientScript="true"
                    OnServerValidate="CheckBoxRequired_ServerValidate" ErrorMessage="You must select the verification checkbox to submit this form."
                    CssClass="EMessage" Width="400px" Display="Dynamic" Enabled="false">You must select the verification checkbox to submit this form.</asp:CustomValidator>
                <br />
                <asp:UpdateProgress ID="UpdateProgress4" runat="server" DynamicLayout="true" DisplayAfter="0">
                    <ProgressTemplate>
                        <div style="text-align: center;">
                            Please wait for the eCoaching Log to submit. Do not close this window until you
                            see a new form load<br />
                            <img src="images/ajax-loader5.gif" alt="progress animation gif" /></div>
                    </ProgressTemplate>
                </asp:UpdateProgress>
                <asp:Label ID="Label2" runat="server" CssClass="EMessage" Visible="True"></asp:Label>
                <br />
                <div style="text-align: center">
                    <asp:Button ID="Button3" runat="server" Text="Reset Page" Enabled="True" CausesValidation="False"
                        CssClass="subuttons" />&nbsp;
                    <asp:Button ID="Button2" runat="server" Text="Submit" Enabled="True" Visible="false"
                        CausesValidation="False" CssClass="subuttons" />
                </div>
                <br />
                <asp:AnimationExtender ID="AnimationExtender1" runat="server" TargetControlID="Button2">
                    <Animations>
    <OnClick>
    <Sequence>
    <EnableAction Enabled="false" />
    <Parallel Duration=".2">
    <Resize Height="0" Width="0" Unit="px" />
    <FadeOut />
        </Parallel>
        
        <HideAction />


    </Sequence>
    
    </OnClick>
                    </Animations>
                </asp:AnimationExtender>
            </asp:Panel>
            <asp:Panel ID="Panel2" runat="server" Visible="false">
                <asp:Label ID="Label186" runat="server" Text="Direct" Visible="False" ViewStateMode="Disabled"></asp:Label>
                <asp:Panel ID="warngroup2" runat="server" Visible="false">
                    <asp:Label ID="Label64" runat="server" Text="" CssClass="question" ViewStateMode="Enabled"></asp:Label><asp:Label
                        ID="Label86" runat="server" Text="Do you need to submit a progressive disciplinary coaching (WARNING)?"
                        CssClass="question" ViewStateMode="Disabled"></asp:Label>
                    &nbsp;<asp:Label ID="Label87" runat="server" Text="*" CssClass="EMessage" Width="10px"></asp:Label>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server" ControlToValidate="warnlist"
                        ErrorMessage="Indicate whether this record is a WARNING or not." CssClass="EMessage"
                        Display="Dynamic" Width="400px">Indicate whether this record is a WARNING or not.&nbsp;</asp:RequiredFieldValidator>
                    <br />
                    <asp:RadioButtonList ID="warnlist" runat="server" AutoPostBack="true">
                        <asp:ListItem Value="Yes" Text="Yes" onClick="javascript: toggle3('1','warngroup1');"></asp:ListItem>
                        <asp:ListItem Value="No" Text="No" onClick="javascript: toggle3('0','warngroup1');"
                            Selected="True"></asp:ListItem>
                    </asp:RadioButtonList>
                    <div id="warngroup1" runat="server" style="visibility: hidden; display: none;">
                        <br />
                        <asp:Label ID="Label88" runat="server" Text="Please select type of warning."></asp:Label>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator11" runat="server" ControlToValidate="warnlist2"
                            CssClass="EMessage" Display="Dynamic" Enabled="false" ErrorMessage="Please select a type of warning."
                            InitialValue="Select..." Width="325px">* Please select a type of warning.</asp:RequiredFieldValidator>
                        <br />
                        <asp:DropDownList ID="warnlist2" DataSourceID="SqlDataSource24" runat="server" CssClass="TextBox"
                            AppendDataBoundItems="true" OnSelectedIndexChanged="warnlist2_SelectedIndexChanged"
                            DataTextField="CoachingReason" DataValueField="CoachingReasonID" AutoPostBack="True">
                            <asp:ListItem Value="Select..." Selected="True">Select...</asp:ListItem>
                        </asp:DropDownList>
                        <br />
                        <br />
                        <asp:Label ID="Label89" runat="server" Text="Warning Reasons"></asp:Label>
                        <asp:CustomValidator ID="CustomValidator3" runat="server" CssClass="EMessage" Display="Dynamic"
                            OnServerValidate="CustomValidator3_ServerValidate" Enabled="false" ErrorMessage="Please select one or more warning sub reason(s)."
                            Width="325px">* Please select a warning sub reason.</asp:CustomValidator>
                        <br />
                        <asp:DropDownList ID="warnReasons" runat="server" class="TextBox" AppendDataBoundItems="true"
                            DataTextField="SubCoachingReason" DataValueField="SubCoachingReasonID">
                            <asp:ListItem Value="Select..." Selected="True">Select...</asp:ListItem>
                        </asp:DropDownList>
                        <br />
                        <asp:SqlDataSource ID="SqlDataSource24" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                            SelectCommand="EC.sp_Select_CoachingReasons_By_Module" SelectCommandType="StoredProcedure"
                            DataSourceMode="DataReader" EnableViewState="False" ViewStateMode="Enabled">
                            <SelectParameters>
                                <asp:Parameter Name="strModulein" Type="String" />
                                <asp:Parameter Name="strSourcein" Type="String" />
                                <asp:Parameter Name="isSplReason" Type="String" />
                                <asp:Parameter Name="splReasonPrty" Type="Int32" />
                                <asp:Parameter Name="strCSRin" Type="String" />
                                <asp:Parameter Name="strSubmitterin" Type="String" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                        <asp:SqlDataSource ID="SqlDataSource26" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                            SelectCommand="EC.sp_Select_SubCoachingReasons_By_Reason" SelectCommandType="StoredProcedure"
                            DataSourceMode="DataReader" EnableViewState="true" ViewStateMode="Enabled">
                            <SelectParameters>
                                <asp:Parameter Name="strReasonin" Type="String" />
                                <asp:Parameter Name="strModulein" Type="String" />
                                <asp:Parameter Name="strSourcein" Type="String" />
                                <asp:Parameter Name="nvcEmpLanIDin" Type="String" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </div>
                    <asp:TextBox ID="TextBox2" runat="server" Visible="false" Text="valid"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator9" Enabled="False" ControlToValidate="TextBox1"
                        CssClass="EMessage" runat="server" ErrorMessage="At least one coaching reason above must be selected to continue."
                        Display="Dynamic" EnableClientScript="false">At least one coaching reason above must be selected to continue.</asp:RequiredFieldValidator>
                    <br />
                </asp:Panel>
                <asp:Label ID="Label77" runat="server" Text="" CssClass="question" ViewStateMode="Enabled"></asp:Label><asp:Label
                    ID="Labe27" runat="server" Text="Enter/Select the date of coaching:" CssClass="question"
                    ViewStateMode="Disabled"></asp:Label>&nbsp;<asp:Label ID="Label224" runat="server"
                        Text="*" CssClass="EMessage" Width="10px"></asp:Label>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator18" runat="server" ControlToValidate="Date2"
                    ErrorMessage="Enter a valid coaching date." CssClass="EMessage" Display="Dynamic"
                    Width="200px" Enabled="False">Enter a valid coaching date.</asp:RequiredFieldValidator>
                <asp:CompareValidator ID="CompareValidator2" runat="server" Display="Dynamic" Operator="LessThanEqual"
                    Type="Date" ControlToValidate="Date2" ErrorMessage="Enter today's date or a date in the past. You are not allowed to enter a future date."
                    CssClass="EMessage" Width="510px" Enabled="false">Enter today's date or a date in the past. You are not allowed to enter a future date.</asp:CompareValidator>
                <br />
                <asp:TextBox runat="server" class="qcontrol" ID="Date2" Width="100px" ViewStateMode="Disabled" />&nbsp;
                <asp:Image runat="server" ID="cal2" ImageUrl="images/Calendar_scheduleHS.png" />
                <asp:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="Date2"
                    PopupButtonID="cal2" Enabled="True">
                </asp:CalendarExtender>
                &nbsp;
                <br />
                <br />
                <div runat="server" id="nowarn">
                    <asp:Panel ID="Panel5" runat="server">
                        <asp:Label ID="Label78" runat="server" Text="" CssClass="question" ViewStateMode="Enabled"></asp:Label><asp:Label
                            ID="Label242" runat="server" Text="Is this a Customer Service Escalation (CSE)?"
                            CssClass="question" ViewStateMode="Disabled"></asp:Label>&nbsp;<asp:Label ID="Label246"
                                runat="server" Text="*" CssClass="EMessage" Width="10px"></asp:Label>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator23" runat="server" ControlToValidate="cseradio"
                            ErrorMessage="Indicate whether this is a CSE or not." CssClass="EMessage" Display="Dynamic"
                            Width="300px">Indicate whether this is a CSE or not.&nbsp;</asp:RequiredFieldValidator>
                        <asp:Table ID="Table5" runat="server">
                            <asp:TableRow>
                                <asp:TableCell>
                                    <asp:RadioButtonList ID="cseradio" runat="server" AutoPostBack="true">
                                        <asp:ListItem Value="Yes" Text="Yes" onClick="javascript: toggle('1','csegroup');"></asp:ListItem>
                                        <asp:ListItem Value="No" Text="No" onClick="javascript: toggle('0','csegroup');"
                                            Selected="True"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </asp:TableCell>
                            </asp:TableRow>
                        </asp:Table>
                        <br />
                    </asp:Panel>
                    <asp:Label ID="Label79" runat="server" Text="" CssClass="question" ViewStateMode="Enabled"></asp:Label><asp:Label
                        ID="Label29" runat="server" CssClass="question" Text="Select the Type of Coaching from the Categories Below:"
                        ViewStateMode="Disabled"></asp:Label>&nbsp;<asp:Label ID="Label31" runat="server"
                            Text="*" CssClass="EMessage" Width="10px"></asp:Label>
                    <br />
                    <br />
                    <asp:Label ID="Label90" runat="server" Text="Coaching Reasons"></asp:Label>
                    <asp:Label ID="lblErrorMsgMaxReasons" runat="server" Text="" CssClass="EMessage"></asp:Label>
                    <div runat="server" id="csegroup" style="visibility: hidden; display: none;">
                        <asp:GridView ID="GridView5" runat="server" AutoGenerateColumns="False" GridLines="None"
                            DataSourceID="SqlDataSource18" Width="536px">
                            <Columns>
                                <asp:TemplateField SortExpression="CoachingReason">
                                    <ItemTemplate>
                                        <asp:CheckBox ID="check1" runat="server" />
                                        <asp:Label ID="Label1" runat="server" CssClass="description" Text='<%# Bind("CoachingReason") %>'></asp:Label>
                                        <asp:Label ID="Label65" runat="server" Text='<%# Bind("CoachingReasonID") %>' Visible="false"></asp:Label>
                                        <br />
                                        <asp:Panel ID="sub1" runat="server" Style="visibility: hidden; display: none;">
                                            <asp:ListBox ID="SubReasons" runat="server" DataTextField="SubCoachingReason" DataValueField="SubCoachingReasonID"
                                                AppendDataBoundItems="true" SelectionMode="Multiple" class="TextBox">
                                                <asp:ListItem Value="" Selected="True"></asp:ListItem>
                                            </asp:ListBox>
                                            <br />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="SubReasons"
                                                InitialValue="" ErrorMessage="Please select a coaching sub reason." CssClass="EMessage"
                                                Enabled="false" Display="Dynamic" Width="425px">Please select a coaching sub reason.</asp:RequiredFieldValidator>
                                        </asp:Panel>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <asp:RadioButtonList ID="buttons1" runat="server" Width="306px" RepeatColumns="2"
                                            RepeatDirection="Horizontal" DataTextField="Value" Enabled="false">
                                            <asp:ListItem class="croptions"></asp:ListItem>
                                        </asp:RadioButtonList>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" Enabled="false"
                                            ControlToValidate="buttons1" CssClass="EMessage" Display="Dynamic" ErrorMessage="You must also select Opportunity or Reinforcement">You must also select "Opportunity" or "Reinforcement"</asp:RequiredFieldValidator>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                        <asp:SqlDataSource ID="SqlDataSource18" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                            SelectCommand="EC.sp_Select_CoachingReasons_By_Module" SelectCommandType="StoredProcedure"
                            DataSourceMode="DataReader" EnableViewState="True" ViewStateMode="Enabled">
                            <SelectParameters>
                                <asp:Parameter Name="strModulein" Type="String" />
                                <asp:Parameter Name="strSourcein" Type="String" />
                                <asp:Parameter Name="isSplReason" Type="String" />
                                <asp:Parameter Name="splReasonPrty" Type="Int32" />
                                <asp:Parameter Name="strCSRin" Type="String" />
                                <asp:Parameter Name="strSubmitterin" Type="String" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                        <asp:SqlDataSource ID="SqlDataSource19" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                            SelectCommand="EC.sp_Select_SubCoachingReasons_By_Reason" SelectCommandType="StoredProcedure"
                            DataSourceMode="DataReader" EnableViewState="true" ViewStateMode="Enabled">
                            <SelectParameters>
                                <asp:Parameter Name="strReasonin" Type="String" />
                                <asp:Parameter Name="strModulein" Type="String" />
                                <asp:Parameter Name="strSourcein" Type="String" />
                                <asp:Parameter Name="nvcEmpLanIDin" Type="String" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                        <asp:SqlDataSource ID="SqlDataSource20" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                            SelectCommand="EC.sp_Select_Values_By_Reason" SelectCommandType="StoredProcedure"
                            DataSourceMode="DataReader" EnableViewState="true" ViewStateMode="Enabled">
                            <SelectParameters>
                                <asp:Parameter Name="strReasonin" Type="String" />
                                <asp:Parameter Name="strModulein" Type="String" />
                                <asp:Parameter Name="strSourcein" Type="String" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </div>
                    <br />
                    <div runat="server" id="nocsegroup" style="visibility: visible; display: inline;">
                        <asp:GridView ID="GridView4" runat="server" AutoGenerateColumns="False" GridLines="None"
                            DataSourceID="SqlDataSource12" Width="536px">
                            <Columns>
                                <asp:TemplateField SortExpression="CoachingReason">
                                    <ItemTemplate>
                                        <asp:CheckBox ID="check1" runat="server" />
                                        <asp:Label ID="Label1" runat="server" CssClass="description" Text='<%# Bind("CoachingReason") %>'></asp:Label>
                                        <asp:Label ID="Label65" runat="server" Text='<%# Bind("CoachingReasonID") %>' Visible="false"></asp:Label>
                                        <br />
                                        <asp:Panel ID="sub1" runat="server" Style="visibility: hidden; display: none;">
                                            <asp:ListBox ID="SubReasons" runat="server" DataTextField="SubCoachingReason" DataValueField="SubCoachingReasonID"
                                                AppendDataBoundItems="true" SelectionMode="Multiple" class="TextBox">
                                                <asp:ListItem Value="" Selected="True"></asp:ListItem>
                                            </asp:ListBox>
                                            <br />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="SubReasons"
                                                InitialValue="" ErrorMessage="Please select a coaching sub reason." CssClass="EMessage"
                                                Enabled="false" Display="Dynamic" Width="425px">Please select a coaching sub reason.</asp:RequiredFieldValidator>
                                        </asp:Panel>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <asp:RadioButtonList ID="buttons1" runat="server" Width="306px" RepeatColumns="2"
                                            RepeatDirection="Horizontal" Enabled="false" DataTextField="Value">
                                            <asp:ListItem class="croptions"></asp:ListItem>
                                        </asp:RadioButtonList>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" Enabled="false"
                                            ControlToValidate="buttons1" CssClass="EMessage" Display="Dynamic" ErrorMessage="You must also select Opportunity or Reinforcement">You must also select "Opportunity" or "Reinforcement"</asp:RequiredFieldValidator>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                        <asp:SqlDataSource ID="SqlDataSource12" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                            SelectCommand="EC.sp_Select_CoachingReasons_By_Module" SelectCommandType="StoredProcedure"
                            DataSourceMode="DataReader" EnableViewState="True" ViewStateMode="Enabled">
                            <SelectParameters>
                                <asp:Parameter Name="strModulein" Type="String" />
                                <asp:Parameter Name="strSourcein" Type="String" />
                                <asp:Parameter Name="isSplReason" Type="String" />
                                <asp:Parameter Name="splReasonPrty" Type="Int32" />
                                <asp:Parameter Name="strCSRin" Type="String" />
                                <asp:Parameter Name="strSubmitterin" Type="String" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                        <asp:SqlDataSource ID="SqlDataSource13" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                            SelectCommand="EC.sp_Select_SubCoachingReasons_By_Reason" SelectCommandType="StoredProcedure"
                            DataSourceMode="DataReader" EnableViewState="true" ViewStateMode="Enabled">
                            <SelectParameters>
                                <asp:Parameter Name="strReasonin" Type="String" />
                                <asp:Parameter Name="strModulein" Type="String" />
                                <asp:Parameter Name="strSourcein" Type="String" />
                                <asp:Parameter Name="nvcEmpLanIDin" Type="String" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                        <asp:SqlDataSource ID="SqlDataSource16" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                            SelectCommand="EC.sp_Select_Values_By_Reason" SelectCommandType="StoredProcedure"
                            DataSourceMode="DataReader" EnableViewState="true" ViewStateMode="Enabled">
                            <SelectParameters>
                                <asp:Parameter Name="strReasonin" Type="String" />
                                <asp:Parameter Name="strModulein" Type="String" />
                                <asp:Parameter Name="strSourcein" Type="String" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </div>
                    <asp:TextBox ID="TextBox1" runat="server" Visible="false" Text="valid"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator28" Enabled="False" ControlToValidate="TextBox1"
                        CssClass="EMessage" runat="server" ErrorMessage="At least one coaching reason above must be selected to continue."
                        Display="Dynamic" EnableClientScript="false">At least one coaching reason above must be selected to continue.</asp:RequiredFieldValidator>
                    <br />
                    <asp:Label ID="Label80" runat="server" Text="" CssClass="question" ViewStateMode="Enabled"></asp:Label><asp:Label
                        ID="Label44" runat="server" CssClass="question" Text="Provide details of the behavior to be coached:"
                        ViewStateMode="Disabled"></asp:Label>&nbsp;<asp:Label ID="Label236" runat="server"
                            Text="*" CssClass="EMessage" Width="10px"></asp:Label>
                    <br />
                    <br />
                    <asp:TextBox ID="TextBox11" runat="server" Rows="10" TextMode="MultiLine" CssClass="tboxes"
                        onkeyup="return textboxMultilineMaxNumber(this)" ViewStateMode="Disabled"></asp:TextBox>
                    <br />
                    <asp:Label ID="Label233" runat="server" Text="[max length: 3,000 chars]" ViewStateMode="Disabled"></asp:Label>
                    <br />
                    <asp:Label ID="Label217" runat="server" Text="Provide as much detail as possible
                and include all the items from the coaching category." ViewStateMode="Disabled"></asp:Label>
                    <br />
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator49" CssClass="EMessage" ControlToValidate="TextBox11"
                        runat="server" ErrorMessage="Please provide details of the behavior to be coached."
                        Display="Dynamic" Enabled="false">Please provide details of the behavior to be coached.</asp:RequiredFieldValidator>
                    <br />
                    <asp:Label ID="Label83" runat="server" Text="" CssClass="question" ViewStateMode="Enabled"></asp:Label><asp:Label
                        ID="Label45" runat="server" CssClass="question" Text="Provide the details from the coaching session including action plans developed:"
                        ViewStateMode="Disabled"></asp:Label>&nbsp;<asp:Label ID="Label238" runat="server"
                            Text="*" CssClass="EMessage" Width="10px"></asp:Label>
                    <br />
                    <br />
                    <asp:TextBox ID="TextBox12" runat="server" Rows="10" TextMode="MultiLine" CssClass="tboxes"
                        onkeyup="return textboxMultilineMaxNumber(this)" ViewStateMode="Disabled"></asp:TextBox>
                    <br />
                    <asp:Label ID="Label234" runat="server" Text="[max length: 3,000 chars]" ViewStateMode="Disabled"></asp:Label>
                    <br />
                    <asp:Label ID="Label46" runat="server" Text="Provide as much detail as possible"
                        ViewStateMode="Disabled"></asp:Label>
                    <br />
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator50" CssClass="EMessage" ControlToValidate="TextBox12"
                        runat="server" ErrorMessage="Please provide details from the coaching session including action plans developed."
                        Display="Dynamic" Enabled="false">Please provide details from the coaching session including action plans developed.</asp:RequiredFieldValidator>
                    <br />
                </div>
                <div id="Panel6" runat="server" style="visibility: visible; display: inline;">
                    <asp:Label ID="Label84" runat="server" Text="" CssClass="question" ViewStateMode="Enabled"></asp:Label><asp:Label
                        ID="Label248" runat="server" Text="How was the coaching opportunity identified?"
                        CssClass="question" ViewStateMode="Disabled"></asp:Label>&nbsp;<asp:Label ID="Label249"
                            runat="server" Text="*" CssClass="EMessage" Width="10px"></asp:Label>
                    <br />
                    <asp:DropDownList ID="howid" DataTextField="Source" DataValueField="SourceID" DataSourceID="SqlDataSource7"
                        AppendDataBoundItems="true" CssClass="qcontrol" runat="server" ToolTip="Please select how the coaching was identified.">
                        <asp:ListItem Value="Select..." Selected="True">Select...</asp:ListItem>
                    </asp:DropDownList>
                    <asp:SqlDataSource ID="SqlDataSource7" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                        SelectCommand="EC.sp_Select_Source_By_Module" SelectCommandType="StoredProcedure"
                        DataSourceMode="DataReader" EnableViewState="False" ViewStateMode="Enabled">
                        <SelectParameters>
                            <asp:Parameter Name="strModulein" Type="String" />
                            <asp:Parameter Name="strSourcein" Type="String" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                    <br />
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator24" runat="server" ControlToValidate="howid"
                        InitialValue="Select..." ErrorMessage="Please select how the coaching was identified."
                        CssClass="EMessage" Enabled="false" Display="Dynamic" Width="425px" EnableClientScript="false">Please select how the coaching was identified.</asp:RequiredFieldValidator>
                    <br />
                </div>
                <div id="Panel7" runat="server" style="visibility: visible; display: inline;">
                    <asp:Label ID="Label85" runat="server" Text="" CssClass="question" ViewStateMode="Enabled"></asp:Label><asp:Label
                        ID="Label35" runat="server" Text="Is there a Call Record associated with this coaching?"
                        CssClass="question" ViewStateMode="Disabled"></asp:Label>&nbsp;<asp:Label ID="Label228"
                            runat="server" Text="*" CssClass="EMessage" Width="10px"></asp:Label>
                    <asp:CustomValidator ID="CustomValidator5" runat="server" Display="Dynamic"
                        CssClass="EMessage" Width="350px" ErrorMessage="Indicate if the item has a Call Record or NGD Activity ID."
                        ClientValidationFunction="CustomValidator1_ClientValidate" OnServerValidate="CustomValidator1_ServerValidate"></asp:CustomValidator>
                    <asp:Table ID="Table6" runat="server" Width="75%">
                        <asp:TableRow>
                            <asp:TableCell>
                                <asp:RadioButton ID="RadioButton1" runat="server" GroupName="CallRecord" Text="Yes" /></asp:TableCell>
                        </asp:TableRow>
                    </asp:Table>
                    <div runat="server" id="panel2c" style="visibility: hidden; display: none;">
                        <asp:Table ID="Table34" runat="server" Width="75%" Style="margin-left: 20px">
                            <asp:TableRow>
                                <asp:TableCell>
                                    <asp:DropDownList ID="calltype" DataSourceID="SqlDataSource9" DataTextField="CallIdType"
                                        DataValueField="IdFormat" AppendDataBoundItems="true" CssClass="qcontrol" runat="server"
                                        ToolTip="Please select a call record type for this coaching.">
                                    </asp:DropDownList>
                                    <asp:TextBox ID="callID" runat="server" CssClass="qcontrol"></asp:TextBox>&nbsp;
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator21" runat="server" ControlToValidate="callID"
                                        ErrorMessage="Enter a Call Record number for this coaching." CssClass="EMessage"
                                        Display="Dynamic" Enabled="false"><span>Enter a Call Record number for this coaching.</span></asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="callID"
                                        ErrorMessage="Call Record IDs must be in the correct format." ValidationExpression="^[a-zA-Z0-9_]{18,26}$"
                                        CssClass="EMessage" Display="Dynamic" Enabled="false"><span>Call Record IDs must be in the correct format.</span></asp:RegularExpressionValidator>
                                    <asp:SqlDataSource ID="SqlDataSource9" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                                        SelectCommand="EC.sp_Select_CallID_By_Module" SelectCommandType="StoredProcedure"
                                        DataSourceMode="DataReader" EnableViewState="True" ViewStateMode="Enabled">
                                        <SelectParameters>
                                            <asp:Parameter Name="strModulein" Type="String" />
                                        </SelectParameters>
                                    </asp:SqlDataSource>
                                </asp:TableCell>
                            </asp:TableRow>
                        </asp:Table>
                    </div>
                    <asp:Table ID="Table18" runat="server" Width="75%">
                        <asp:TableRow>
                            <asp:TableCell>
                                <asp:RadioButton ID="RadioButton2" runat="server" GroupName="CallRecord" Checked="True"
                                    Text="No" /></asp:TableCell>
                        </asp:TableRow>
                    </asp:Table>
                    <br />
                    <asp:CheckBox ID="CheckBox2" runat="server" Text="I have verified that all the information on this form is true and complete to 
        the best of my knowledge." />&nbsp;<asp:Label ID="Label229" runat="server" Text="*"
            CssClass="EMessage" Width="10px"></asp:Label>
                    &nbsp;<br />
                    <asp:CustomValidator runat="server" ID="CustomValidator2" EnableClientScript="true"
                        OnServerValidate="CheckBoxRequired2_ServerValidate" ErrorMessage="You must select the verification checkbox to submit this form."
                        CssClass="EMessage" Width="400px" Display="Dynamic" Enabled="false">You must select the verification checkbox to submit this form.</asp:CustomValidator>
                    <br />
                </div>
                <asp:UpdateProgress ID="UpdateProgress3" runat="server" DynamicLayout="true" DisplayAfter="0">
                    <ProgressTemplate>
                        <div style="text-align: center;">
                            Please wait for the eCoaching Log to submit. Do not close this window until you
                            see a new form load<br />
                            <img src="images/ajax-loader5.gif" alt="progress animation gif" /></div>
                    </ProgressTemplate>
                </asp:UpdateProgress>
                <asp:Label ID="Label169" runat="server" CssClass="EMessage" Visible="true" Text="&nbsp;"></asp:Label>
                <br />
                <div style="text-align: center">
                    <asp:Button ID="Button1" runat="server" Text="Reset Page" Enabled="True" CausesValidation="false"
                        CssClass="subuttons" />&nbsp;
                    <asp:Button ID="Button5" runat="server" Text="Submit" Enabled="True" Visible="false"
                        CausesValidation="false" CssClass="subuttons" />
                </div>
                <!-- MaskedEdit Validators -->
                <!-- <ol> -->
                <!--  </ol> -->
                <!-- End Validators -->
                <asp:SqlDataSource ID="SqlDataSource6" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    InsertCommand="EC.sp_InsertInto_Coaching_Log" InsertCommandType="StoredProcedure" OnInserted="Coaching_Inserted"
                    DataSourceMode="DataReader" EnableViewState="False" ViewStateMode="Disabled">
                    <InsertParameters>
                        <asp:Parameter Name="ModuleID" Direction="Input" Type="Int32" />
                        <asp:Parameter Name="nvcFormName" Direction="Input" Type="String" />
                        <asp:Parameter Name="nvcEmplanID" Direction="Input" Type="String" />
                        <asp:Parameter Name="nvcProgramName" Direction="Input" Type="String" />
                        <asp:Parameter Name="Behaviour" Direction="Input" Type="String" />
                        <asp:Parameter Name="intSourceID" Direction="Input" Type="Int32" />
                        <asp:Parameter Name="intStatusID" Direction="Input" Type="Int32" />
                        <asp:Parameter Name="SiteID" Direction="Input" Type="Int32" />
                        <asp:Parameter Name="nvcSubmitter" Direction="Input" Type="String" />
                        <asp:Parameter Name="dtmEventDate" Direction="Input" Type="DateTime" />
                        <asp:Parameter Name="dtmCoachingDate" Direction="Input" Type="DateTime" />
                        <asp:Parameter Name="bitisAvokeID" Direction="Input" Type="Boolean" />
                        <asp:Parameter Name="nvcAvokeID" Direction="Input" Type="String" />
                        <asp:Parameter Name="bitisNGDActivityID" Direction="Input" Type="Boolean" />
                        <asp:Parameter Name="nvcNGDActivityID" Direction="Input" Type="String" />
                        <asp:Parameter Name="bitisUCID" Direction="Input" Type="Boolean" />
                        <asp:Parameter Name="nvcUCID" Direction="Input" Type="String" />
                        <asp:Parameter Name="bitisVerintID" Direction="Input" Type="Boolean" />
                        <asp:Parameter Name="nvcVerintID" Direction="Input" Type="String" />
                        <asp:Parameter Name="intCoachReasonID1" Direction="Input" Type="Int32" />
                        <asp:Parameter Name="nvcSubCoachReasonID1" Direction="Input" Type="String" />
                        <asp:Parameter Name="nvcValue1" Direction="Input" Type="String" />
                        <asp:Parameter Name="intCoachReasonID2" Direction="Input" Type="Int32" />
                        <asp:Parameter Name="nvcSubCoachReasonID2" Direction="Input" Type="String" />
                        <asp:Parameter Name="nvcValue2" Direction="Input" Type="String" />
                        <asp:Parameter Name="intCoachReasonID3" Direction="Input" Type="Int32" />
                        <asp:Parameter Name="nvcSubCoachReasonID3" Direction="Input" Type="String" />
                        <asp:Parameter Name="nvcValue3" Direction="Input" Type="String" />
                        <asp:Parameter Name="intCoachReasonID4" Direction="Input" Type="Int32" />
                        <asp:Parameter Name="nvcSubCoachReasonID4" Direction="Input" Type="String" />
                        <asp:Parameter Name="nvcValue4" Direction="Input" Type="String" />
                        <asp:Parameter Name="intCoachReasonID5" Direction="Input" Type="Int32" />
                        <asp:Parameter Name="nvcSubCoachReasonID5" Direction="Input" Type="String" />
                        <asp:Parameter Name="nvcValue5" Direction="Input" Type="String" />
                        <asp:Parameter Name="intCoachReasonID6" Direction="Input" Type="Int32" />
                        <asp:Parameter Name="nvcSubCoachReasonID6" Direction="Input" Type="String" />
                        <asp:Parameter Name="nvcValue6" Direction="Input" Type="String" />
                        <asp:Parameter Name="intCoachReasonID7" Direction="Input" Type="Int32" />
                        <asp:Parameter Name="nvcSubCoachReasonID7" Direction="Input" Type="String" />
                        <asp:Parameter Name="nvcValue7" Direction="Input" Type="String" />
                        <asp:Parameter Name="intCoachReasonID8" Direction="Input" Type="Int32" />
                        <asp:Parameter Name="nvcSubCoachReasonID8" Direction="Input" Type="String" />
                        <asp:Parameter Name="nvcValue8" Direction="Input" Type="String" />
                        <asp:Parameter Name="intCoachReasonID9" Direction="Input" Type="Int32" />
                        <asp:Parameter Name="nvcSubCoachReasonID9" Direction="Input" Type="String" />
                        <asp:Parameter Name="nvcValue9" Direction="Input" Type="String" />
                        <asp:Parameter Name="intCoachReasonID10" Direction="Input" Type="Int32" />
                        <asp:Parameter Name="nvcSubCoachReasonID10" Direction="Input" Type="String" />
                        <asp:Parameter Name="nvcValue10" Direction="Input" Type="String" />
                        <asp:Parameter Name="intCoachReasonID11" Direction="Input" Type="Int32" />
                        <asp:Parameter Name="nvcSubCoachReasonID11" Direction="Input" Type="String" />
                        <asp:Parameter Name="nvcValue11" Direction="Input" Type="String" />
                        <asp:Parameter Name="intCoachReasonID12" Direction="Input" Type="Int32" />
                        <asp:Parameter Name="nvcSubCoachReasonID12" Direction="Input" Type="String" />
                        <asp:Parameter Name="nvcValue12" Direction="Input" Type="String" />
                        <asp:Parameter Name="nvcDescription" Direction="Input" Type="String" />
                        <asp:Parameter Name="nvcCoachingNotes" Direction="Input" Type="String" />
                        <asp:Parameter Name="bitisVerified" Direction="Input" Type="Boolean" />
                        <asp:Parameter Name="dtmSubmittedDate" Direction="Input" Type="DateTime" />
                        <asp:Parameter Name="dtmStartDate" Direction="Input" Type="DateTime" />
                        <asp:Parameter Name="dtmSupReviewedAutoDate" Direction="Input" Type="DateTime" />
                        <asp:Parameter Name="bitisCSE" Direction="Input" Type="Boolean" />
                        <asp:Parameter Name="dtmMgrReviewManualDate" Direction="Input" Type="DateTime" />
                        <asp:Parameter Name="dtmMgrReviewAutoDate" Direction="Input" Type="DateTime" />
                        <asp:Parameter Name="nvcMgrNotes" Direction="Input" Type="String" />
                        <asp:Parameter Name="bitisCSRAcknowledged" Direction="Input" Type="Boolean" />
                        <asp:Parameter Name="dtmCSRReviewAutoDate" Direction="Input" Type="DateTime" />
                        <asp:Parameter Name="nvcCSRComments" Direction="Input" Type="String" />
                        <asp:Parameter Name="bitEmailSent" Direction="Input" Type="Boolean" />
                        <asp:Parameter Name="nvcNewFormName" Direction="Output" Type="String" Size="50"/>
                    </InsertParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="SqlDataSource27" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    InsertCommand="EC.sp_InsertInto_Warning_Log" InsertCommandType="StoredProcedure"
                    DataSourceMode="DataReader" EnableViewState="False" ViewStateMode="Disabled"
                    OnInserted="Warning_Inserted">
                    <InsertParameters>
                        <asp:Parameter Name="nvcFormName" Direction="Input" Type="String" />
                        <asp:Parameter Name="nvcProgramName" Direction="Input" Type="String" />
                        <asp:Parameter Name="nvcEmplanID" Direction="Input" Type="String" />
                        <asp:Parameter Name="SiteID" Direction="Input" Type="Int32" />
                        <asp:Parameter Name="nvcSubmitter" Direction="Input" Type="String" />
                        <asp:Parameter Name="dtmEventDate" Direction="Input" Type="DateTime" />
                        <asp:Parameter Name="intCoachReasonID1" Direction="Input" Type="Int32" />
                        <asp:Parameter Name="nvcSubCoachReasonID1" Direction="Input" Type="String" />
                        <asp:Parameter Name="dtmSubmittedDate" Direction="Input" Type="DateTime" />
                        <asp:Parameter Name="ModuleID" Direction="Input" Type="Int32" />
                        <asp:Parameter Name="nvcBehavior" Direction="Input" Type="String" />
                        <asp:Parameter Name="isDup" Direction="Output" Type="Int32" />
                        <asp:Parameter Name="nvcNewFormName" Direction="Output" Type="String" Size="50"/>
                    </InsertParameters>
                </asp:SqlDataSource>
                <br />
                <asp:AnimationExtender ID="AnimationExtender2" runat="server" TargetControlID="Button5">
                    <Animations>
    <OnClick>
    <Sequence>
    <EnableAction Enabled="false" />
    <Parallel Duration=".2">
    <Resize Height="0" Width="0" Unit="px" />
    <FadeOut />
        </Parallel>
        
        <HideAction />
    </Sequence>
    
    </OnClick>
                    </Animations>
                </asp:AnimationExtender>
            </asp:Panel>
            <asp:Panel ID="Panel4" runat="server" Visible="false" Style="text-align: center;">
                <div style="border: 1px solid #cccccc; width: 65%; text-align: center; margin-left: 80px;">
                    <p style="font-family: Arial; font-size: medium; text-align: center;">
                        <em style="font-weight: 700; text-align: center">The form has been closed. </em>
                    </p>
                </div>
            </asp:Panel>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder4" runat="server"
    Visible="true">
    <asp:ToolkitScriptManager runat="server" ID="ToolkitScriptManager2" AsyncPostBackTimeout="1200">
    </asp:ToolkitScriptManager>
    <asp:UpdatePanel ID="UpdatePanel2" runat="server" UpdateMode="Always">
        <ContentTemplate>
            <div id="sideCol2" runat="server">
                <div style="border: none; margin-left: .55em; margin-right: .55em; margin-top: .55em;">
                    <asp:Label ID="Label187" runat="server" Text="Page:" ForeColor="Black" CssClass="sidelabel"
                        Visible="false"></asp:Label>
                    <asp:Label ID="Label188" runat="server" Text="Start [1 of 2]" CssClass="sidetext"
                        Visible="false"></asp:Label>
                    <asp:Label ID="Label4" runat="server" Text="Status:" ForeColor="Black" CssClass="sidelabel"></asp:Label>
                    &nbsp;<asp:Label ID="Label6" runat="server" Text="New" CssClass="sidetext"></asp:Label>
                    <br />
                    <asp:Label ID="Label8" runat="server" Text="Date Started:" ForeColor="Black" CssClass="sidelabel"></asp:Label>
                    &nbsp;<asp:Label ID="Label10" runat="server" CssClass="sidetext"></asp:Label>
                </div>
                <asp:Panel ID="Panel0a" runat="server" Visible="false">
                    <div style="border: none; margin-left: .50em; margin-right: .50em; margin-bottom: .50em;">
                        <asp:Label ID="Label48" runat="server" Text="Site:" ForeColor="Black" CssClass="sidelabel"
                            Visible="False"></asp:Label>
                        &nbsp;<asp:Label ID="Label49" runat="server" CssClass="sidetext" Visible="False"></asp:Label>
                        <br />
                        <br />
                        <asp:Label ID="Label21" runat="server" Text="Employee:" ForeColor="Black" CssClass="sidelabel"
                            Visible="False"></asp:Label>
                        &nbsp;<asp:Label ID="Label23" runat="server" CssClass="sidetext" Visible="False"></asp:Label>
                        <br />
                        <asp:Label ID="Label30" runat="server" Text="Supervisor:" ForeColor="Black" CssClass="sidelabel"
                            Visible="False"></asp:Label>
                        &nbsp;<asp:Label ID="Label32" runat="server" CssClass="sidetext" Visible="False"></asp:Label>
                        <br />
                        <asp:Label ID="Label52" runat="server" Text="Manager:" ForeColor="Black" CssClass="sidelabel"
                            Visible="False"></asp:Label>
                        &nbsp;<asp:Label ID="Label53" runat="server" CssClass="sidetext" Visible="False"></asp:Label>
                        <br />
                        <asp:Label ID="Label189" runat="server" Text="Employee Information:" ForeColor="Black"
                            CssClass="sidelabel" Visible="False"></asp:Label>
                        &nbsp
                        <asp:Label ID="Label12" runat="server" Text="Employee:" ForeColor="Black" CssClass="sidelabel"
                            Visible="False"></asp:Label>
                        &nbsp;<asp:Label ID="Label17" runat="server" CssClass="sidetext" Visible="False"></asp:Label>
                        <asp:Label ID="Label15" runat="server" Text="Email:" ForeColor="Black" CssClass="sidelabel"
                            Visible="False"></asp:Label>
                        &nbsp;<asp:Label ID="Label19" runat="server" CssClass="sidetext" Visible="False"></asp:Label>
                        <asp:Label ID="Label27" runat="server" Text="Supervisor:" ForeColor="Black" CssClass="sidelabel"
                            Visible="False"></asp:Label>
                        &nbsp;<asp:Label ID="Label28" runat="server" CssClass="sidetext" Visible="False"></asp:Label>
                        <asp:Label ID="Label34" runat="server" Text="Supervisor Email:" ForeColor="Black"
                            CssClass="sidelabel" Visible="False"></asp:Label>
                        &nbsp;<asp:Label ID="Label36" runat="server" CssClass="sidetext" Visible="False"></asp:Label>
                        <asp:Label ID="Label39" runat="server" Text="Manager:" ForeColor="Black" CssClass="sidelabel"
                            Visible="False"></asp:Label>
                        &nbsp;<asp:Label ID="Label47" runat="server" CssClass="sidetext" Visible="False"></asp:Label>
                        <asp:Label ID="Label54" runat="server" Text="Manager Email:" ForeColor="Black" CssClass="sidelabel"
                            Visible="False"></asp:Label>
                        &nbsp;<asp:Label ID="Label55" runat="server" CssClass="sidetext" Visible="False"></asp:Label>
                        <asp:Label ID="Label50" runat="server" Text="Delivering?:" ForeColor="Black" CssClass="sidelabel"
                            Visible="False"></asp:Label>
                        &nbsp;<asp:Label ID="Label51" runat="server" CssClass="sidetext" Visible="False"></asp:Label>
                        <asp:Label ID="Label56" runat="server" Text="Submitter:" ForeColor="Black" CssClass="sidelabel"
                            Visible="False"></asp:Label>
                        &nbsp;<asp:Label ID="Label57" runat="server" CssClass="sidetext" Visible="False"></asp:Label>
                        <asp:Label ID="Label177" runat="server" Text="Submitter Name:" ForeColor="Black"
                            CssClass="sidelabel" Visible="False"></asp:Label>
                        &nbsp;<asp:Label ID="Label178" runat="server" CssClass="sidetext" Visible="False"></asp:Label>
                        <asp:Label ID="Label179" runat="server" Text="Submitter Email:" ForeColor="Black"
                            CssClass="sidelabel" Visible="False"></asp:Label>
                        &nbsp;<asp:Label ID="Label180" runat="server" CssClass="sidetext" Visible="False"></asp:Label>
                        <asp:Label ID="Label151" runat="server" Text="Count of Records:" ForeColor="Black"
                            CssClass="sidelabel" Visible="False"></asp:Label>
                        <asp:Label ID="Label24" runat="server" Text="Event Date:" ForeColor="Black" CssClass="sidelabel"
                            Visible="False"></asp:Label>
                        &nbsp;<asp:Label ID="Label58" runat="server" CssClass="sidetext" Visible="False"></asp:Label>
                        <asp:Label ID="Label59" runat="server" Text="Coaching Source:" ForeColor="Black"
                            CssClass="sidelabel" Visible="False"></asp:Label>
                        &nbsp;<asp:Label ID="Label60" runat="server" CssClass="sidetext" Visible="False"></asp:Label>
                        &nbsp;<asp:Label ID="Label62" runat="server" CssClass="sidetext" Visible="False"></asp:Label>
                        <asp:Label ID="Label81" runat="server" Text="Quality or PPoM Number:" ForeColor="Black"
                            CssClass="sidelabel" Visible="False"></asp:Label>
                        &nbsp;<asp:Label ID="Label82" runat="server" CssClass="sidetext" Visible="False"></asp:Label>
                        <asp:Label ID="Label67" runat="server" Text="Details:" ForeColor="Black" CssClass="sidelabel"
                            Visible="False"></asp:Label>
                        &nbsp;<asp:Label ID="Label68" runat="server" CssClass="sidetext" Visible="False"></asp:Label>
                        <asp:Label ID="Label159" runat="server" Text="FormID:" ForeColor="Black" CssClass="sidelabel"
                            Visible="False"></asp:Label>
                        &nbsp;<asp:Label ID="Label160" runat="server" CssClass="sidetext" Visible="False"></asp:Label>
                        <asp:Label ID="Label157" runat="server" Text="Form Status:" ForeColor="Black" CssClass="sidelabel"
                            Visible="False"></asp:Label>
                        &nbsp;<asp:Label ID="Label158" runat="server" CssClass="sidetext" Visible="False"></asp:Label>
                        <asp:Label ID="Label155" runat="server" Text="Form Status:" ForeColor="Black" CssClass="sidelabel"
                            Visible="False"></asp:Label>
                        &nbsp;<asp:Label ID="Label156" runat="server" CssClass="sidetext" Visible="False"></asp:Label>
                        <asp:Label ID="Label37" runat="server" Text="Coaching Date:" ForeColor="Black" CssClass="sidelabel"
                            Visible="False"></asp:Label>
                        &nbsp;<asp:Label ID="Label69" runat="server" CssClass="sidetext" Visible="False"></asp:Label>
                        <asp:Label ID="Label70" runat="server" Text="Coaching Source:" ForeColor="Black"
                            CssClass="sidelabel" Visible="False"></asp:Label>
                        &nbsp;<asp:Label ID="Label71" runat="server" CssClass="sidetext" Visible="False"></asp:Label>
                        <asp:Label ID="Label92" runat="server" Text="Details2:" ForeColor="Black" CssClass="sidelabel"
                            Visible="False"></asp:Label>
                        &nbsp;<asp:Label ID="Label93" runat="server" CssClass="sidetext" Visible="False"></asp:Label>
                        <asp:Label ID="Label94" runat="server" Text="Details3:" ForeColor="Black" CssClass="sidelabel"
                            Visible="False"></asp:Label>
                        &nbsp;<asp:Label ID="Label95" runat="server" CssClass="sidetext" Visible="False"></asp:Label>
                        <br />
                        <asp:Label ID="moduleIDlbl" runat="server" Text="Label" Visible="False"></asp:Label>
                    </div>
                </asp:Panel>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
