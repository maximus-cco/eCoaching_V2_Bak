'------------------------------------------------------------------------------
' <auto-generated>
'     This code was generated by a tool.
'     Runtime Version:4.0.30319.42000
'
'     Changes to this file may cause incorrect behavior and will be lost if
'     the code is regenerated.
' </auto-generated>
'------------------------------------------------------------------------------

Option Strict On
Option Explicit On

Imports System

Namespace Resources
    
    'This class was auto-generated by the StronglyTypedResourceBuilder
    'class via a tool like ResGen or Visual Studio.
    'To add or remove a member, edit your .ResX file then rerun ResGen
    'with the /str option or rebuild the Visual Studio project.
    '''<summary>
    '''  A strongly-typed resource class, for looking up localized strings, etc.
    '''</summary>
    <Global.System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.VisualStudio.Web.Application.StronglyTypedResourceProxyBuilder", "14.0.0.0"),  _
     Global.System.Diagnostics.DebuggerNonUserCodeAttribute(),  _
     Global.System.Runtime.CompilerServices.CompilerGeneratedAttribute()>  _
    Friend Class LocalizedText
        
        Private Shared resourceMan As Global.System.Resources.ResourceManager
        
        Private Shared resourceCulture As Global.System.Globalization.CultureInfo
        
        <Global.System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1811:AvoidUncalledPrivateCode")>  _
        Friend Sub New()
            MyBase.New
        End Sub
        
        '''<summary>
        '''  Returns the cached ResourceManager instance used by this class.
        '''</summary>
        <Global.System.ComponentModel.EditorBrowsableAttribute(Global.System.ComponentModel.EditorBrowsableState.Advanced)>  _
        Friend Shared ReadOnly Property ResourceManager() As Global.System.Resources.ResourceManager
            Get
                If Object.ReferenceEquals(resourceMan, Nothing) Then
                    Dim temp As Global.System.Resources.ResourceManager = New Global.System.Resources.ResourceManager("Resources.LocalizedText", Global.System.Reflection.[Assembly].Load("App_GlobalResources"))
                    resourceMan = temp
                End If
                Return resourceMan
            End Get
        End Property
        
        '''<summary>
        '''  Overrides the current thread's CurrentUICulture property for all
        '''  resource lookups using this strongly typed resource class.
        '''</summary>
        <Global.System.ComponentModel.EditorBrowsableAttribute(Global.System.ComponentModel.EditorBrowsableState.Advanced)>  _
        Friend Shared Property Culture() As Global.System.Globalization.CultureInfo
            Get
                Return resourceCulture
            End Get
            Set
                resourceCulture = value
            End Set
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to An Error Has Occurred:.
        '''</summary>
        Friend Shared ReadOnly Property ErrorMessage() As String
            Get
                Return ResourceManager.GetString("ErrorMessage", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to You are not authorized for this survey..
        '''</summary>
        Friend Shared ReadOnly Property MySurvey_AccessDeniedMsg() As String
            Get
                Return ResourceManager.GetString("MySurvey_AccessDeniedMsg", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to Provide additional comments below..
        '''</summary>
        Friend Shared ReadOnly Property MySurvey_AdditionalComments() As String
            Get
                Return ResourceManager.GetString("MySurvey_AdditionalComments", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to You have already completed this survey..
        '''</summary>
        Friend Shared ReadOnly Property MySurvey_AlreadyCompletedMsg() As String
            Get
                Return ResourceManager.GetString("MySurvey_AlreadyCompletedMsg", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to This survey has expired..
        '''</summary>
        Friend Shared ReadOnly Property MySurvey_ExpiredMsg() As String
            Get
                Return ResourceManager.GetString("MySurvey_ExpiredMsg", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to The CCO Leadership team is asking for your help in providing feedback on your coaching experience. Please take a few minutes to complete this survey. The details from the surveys will be used to improve the effectiveness, content and delivery of discussions regarding your performance. Your comments and feedback will be anonymous and will not be attributed directly to your individual survey..
        '''</summary>
        Friend Shared ReadOnly Property MySurvey_Instruction() As String
            Get
                Return ResourceManager.GetString("MySurvey_Instruction", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to Thank you for your time. Your survey has been saved successfully..
        '''</summary>
        Friend Shared ReadOnly Property MySurvey_SaveSuccessMsg() As String
            Get
                Return ResourceManager.GetString("MySurvey_SaveSuccessMsg", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to This survey is for.
        '''</summary>
        Friend Shared ReadOnly Property MySurvey_Title() As String
            Get
                Return ResourceManager.GetString("MySurvey_Title", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to Submit.
        '''</summary>
        Friend Shared ReadOnly Property Submit() As String
            Get
                Return ResourceManager.GetString("Submit", resourceCulture)
            End Get
        End Property
    End Class
End Namespace
