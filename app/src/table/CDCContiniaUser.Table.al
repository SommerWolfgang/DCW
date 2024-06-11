table 6086001 "CDC Continia User"
{
    Caption = 'Continia User';
    DataCaptionFields = "User ID", Name;
    DataPerCompany = false;

    fields
    {
        field(1; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = EndUserIdentifiableInformation;
            NotBlank = true;
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
        field(3; Name; Text[50])
        {
            Caption = 'Name';
        }
        field(4; "E-Mail"; Text[250])
        {
            Caption = 'Email';
        }
        field(6; "NAV Login Type"; Option)
        {
            Caption = 'Login Type';
            Editable = false;
            OptionCaption = 'No NAV Login,Windows,Database,Office 365';
            OptionMembers = "No NAV Login",Windows,Database,"Office 365";
        }
        field(7; "O365 Authentication Email"; Text[250])
        {
            Caption = 'Office 365 Authentication Email';
        }
        field(9; "Creation Date"; Date)
        {
            Caption = 'Creation Date';
        }
        field(12; "Send Welcome E-mail"; Boolean)
        {
            Caption = 'Send Welcome Email';
        }
        field(13; "Send Welcome E-mail (EM)"; Boolean)
        {
            Caption = 'Send Welcome Email (EM)';
        }
        field(31; "Activation Link"; Text[250])
        {
            Caption = 'Activation Link';
        }
        field(32; "Activation Link (EM)"; Text[250])
        {
            Caption = 'Activation Link (EM)';
        }
        field(33; "Expense Management User Type"; Option)
        {
            Caption = 'Expense Management User Type';
            OptionCaption = ' ,Pro User,Light User';
            OptionMembers = " ","Pro User","Light User";
        }
    }

    keys
    {
        key(Key1; "User ID")
        {
            Clustered = true;
        }
        key(Key2; "Send Welcome E-mail")
        {
        }
        key(Key3; "Send Welcome E-mail (EM)")
        {
        }
        key(Key4; "Expense Management User Type")
        {
        }
    }

    procedure GetWebDimCaption(WebDimNo: Integer): Text[50]
    begin
    end;

    procedure SuspendContiniaUserSetupDelete(Suspend: Boolean)
    begin
    end;

    procedure ResendWelcomeEmail()
    begin
    end;

    procedure SendWelcomeEmailToSelected(var UserSelection: Record "CDC Continia User")
    begin
    end;

    procedure IsWebApprovalUser(CheckThisCompany: Boolean): Boolean
    begin
    end;

    procedure IsWindowsUser(): Boolean
    begin
    end;

    procedure IsOffice365User(): Boolean
    begin
    end;

    procedure IsEMUser(CheckThisCompany: Boolean): Boolean
    begin
    end;

    procedure InsertContiniaUserSetupInComp(CompName: Text[250])
    begin
    end;

    procedure DeleteContiniaUserSetupInComp(CompName: Text[250])
    begin
    end;

    procedure GetCompaniesWithContUserSetup(var TempCompany: Record Company temporary)
    begin
    end;

    procedure GetNoOfContiniaUserSetups() NoOfContiniaUserSetups: Integer
    begin
    end;

    procedure ShowSetupByCompany()
    begin
    end;

    procedure ValidateApproverClient(ContiniaUserSetup: Record "CDC Continia User Setup"; CurrentCompany: Text[50])
    begin
    end;

    procedure GetUserIDFromName(ApproverName: Text[250]) UserID: Code[50]
    begin
    end;

    procedure GetUserIDFromNameInCompany(ApproverName: Text[250]; CompanyName: Text[250]) UserID: Code[50]
    begin
    end;

    procedure GetSalesPersonCodeFromName(SalesPersonName: Text[250]) SalesPersonCode: Code[50]
    begin
    end;

    procedure GetSaPersCodeFromNameInCompany(SalesPersonName: Text[250]; CompanyName: Text[250]) SalesPersonCode: Code[50]
    begin
    end;
}