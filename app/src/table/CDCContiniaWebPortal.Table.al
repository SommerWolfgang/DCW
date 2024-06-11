table 6192774 "CDC Continia Web Portal"
{
    Caption = 'Continia Web Portal';
    DataPerCompany = false;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(7; "O365 Webservice URL"; Text[250])
        {
            Caption = 'Office 365  Web Service URL (SOAP)';
        }
        field(8; "Windows Web Service URL"; Text[250])
        {
            Caption = 'Windows Web Service URL (SOAP)';
        }
        field(9; "Database Web Service URL"; Text[250])
        {
            Caption = 'Database Web Service URL (SOAP)';
        }
        field(10; "Local Domain Name"; Code[50])
        {
            Caption = 'Local Domain Name';
        }
        field(12; "Web Service Tenant"; Text[80])
        {
            Caption = 'Web Service Tenant';
        }
        field(14; "Web Site Url"; Text[80])
        {
            Caption = 'Web Site Url';
        }
        field(15; "Default Language Name"; Text[20])
        {
            Caption = 'Default User Language Name';
        }
        field(16; "Default Units Formatting"; Text[20])
        {
            Caption = 'Default Units Formatting';
        }
        field(17; "Default Time Zone"; Text[50])
        {
            Caption = 'Default Time Zone';
        }
        field(21; "Use Continia Online Web Portal"; Boolean)
        {
            Caption = 'Continia Web Portal';
        }
        field(24; "Welcome E-Mails"; Option)
        {
            Caption = 'Welcome Emails';
            OptionCaption = 'Automatically,Manually';
            OptionMembers = "Send automatically","Send manually";
        }
        field(29; "AAD Tenant Id"; Text[36])
        {
            Caption = 'Azure Tenant Id';

            trigger OnValidate()
            var
                TestGuid: Guid;
            begin
                Evaluate(TestGuid, "AAD Tenant Id")
            end;
        }
        field(30; "AAD Application Id"; Text[36])
        {
            Caption = 'Azure Application Id';

            trigger OnValidate()
            var
                TestGuid: Guid;
            begin
                Evaluate(TestGuid, StrSubstNo('%1', "AAD Application Id"));
                "AAD Application Id" := LowerCase("AAD Application Id");
            end;
        }
        field(31; "AAD Application Key"; Text[50])
        {
            Caption = 'Azure Application Key';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }
    procedure InitValues()
    begin
    end;

    procedure GetO365WebserviceURL(): Text[250]
    begin
    end;

    procedure GetAadTenantId(): Text[36]
    begin
    end;
}