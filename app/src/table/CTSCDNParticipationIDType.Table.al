table 6086224 "CTS-CDN Participation ID Type"
{
    Caption = 'Participation Identifier Type';

    fields
    {
        field(1; "System ID"; Integer)
        {
            AutoIncrement = true;
            Caption = 'System ID';
        }
        field(2; "Network Name"; Text[30])
        {
            Caption = 'Network Name';
            TableRelation = "CTS-CDN Network";
        }
        field(3; "Identifier Type ID"; Text[4])
        {
            Caption = 'Identifier Type ID';
        }
        field(4; Description; Text[250])
        {
            Caption = 'Description';
        }
        field(5; "Scheme ID"; Text[50])
        {
            Caption = 'Scheme ID';
        }
        field(10; Default; Boolean)
        {
            Caption = 'Default';
        }
        field(11; "Default in Country"; Code[10])
        {
            Caption = 'Default in Country';
        }
        field(12; "VAT in Country"; Code[10])
        {
            Caption = 'VAT Identification in Country';
        }
        field(13; "ICD Code"; Boolean)
        {
            Caption = 'ICD Code';
        }
        field(14; "Validation Rule"; Text[50])
        {
            Caption = 'Validation Rule';
        }
        field(20; "CDN GUID"; Guid)
        {
            Caption = 'CDN GUID';
        }
    }

    keys
    {
        key(Key1; "System ID")
        {
            Clustered = true;
        }
        key(Key2; "Scheme ID")
        {
        }
        key(Key3; "Default in Country")
        {
        }
        key(Key4; "CDN GUID")
        {
        }
    }

    procedure FindByGUID(CDNGuid: Guid; ShowError: Boolean)
    begin
    end;

    procedure GetGLNType()
    begin
    end;


    procedure GetDefIdTypeForCountry(CountryCode: Code[10]; ShowError: Boolean)
    begin
    end;

    procedure GetVATIdTypeForCountry(CountryCode: Code[10]; ShowError: Boolean)
    begin
    end;

    procedure IsIdValueValid(IdValue: Text[50]): Boolean
    begin
    end;
}