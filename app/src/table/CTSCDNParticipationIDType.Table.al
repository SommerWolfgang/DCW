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

    fieldgroups
    {
    }

    var
        ISOCodeMgt: Codeunit "CTS-CDN ISO Code Mgt.";


    procedure FindByGUID(CDNGuid: Guid; ShowError: Boolean)
    begin
        SetRange("CDN GUID", CDNGuid);
        if ShowError then
            FindFirst
        else
            if FindFirst then;
    end;


    procedure GetGLNType()
    begin
        Reset;
        SetRange("Identifier Type ID", '0088');
        SetRange("Scheme ID", 'GLN');
        SetCDNFilter;
        FindFirst;
    end;


    procedure GetDefIdTypeForCountry(CountryCode: Code[10]; ShowError: Boolean)
    begin
        CountryCode := ISOCodeMgt.GetCountryCodeISO31661(CountryCode);

        Reset;
        if CountryCode <> '' then
            SetRange("Default in Country", CountryCode)
        else
            SetRange(Default, true);

        SetCDNFilter;
        if ShowError then
            FindFirst
        else
            if FindFirst then;
    end;


    procedure GetVATIdTypeForCountry(CountryCode: Code[10]; ShowError: Boolean)
    begin
        CountryCode := ISOCodeMgt.GetCountryCodeISO31661(CountryCode);

        if CountryCode = '' then
            exit;

        Reset;
        SetRange("VAT in Country", CountryCode);
        SetCDNFilter;
        if ShowError then
            FindFirst
        else
            if FindFirst then;
    end;


    procedure IsIdValueValid(IdValue: Text[50]): Boolean
    var
        RegExMgt: Codeunit "CTS-CDN RegEx Management";
    begin
        if "Validation Rule" = '' then
            exit(true);

        exit(RegExMgt.IsMatch(IdValue, "Validation Rule"));
    end;

    local procedure SetCDNFilter()
    var
        Core: Codeunit "CSC Core";
        EmptyGUID: Guid;
    begin
        if not Core.IsDemo then
            SetFilter("CDN GUID", '<>%1', EmptyGUID);
    end;
}

