table 6192771 "CDC Continia Client Credential"
{
    Caption = 'Continia Client Credentials';
    DataPerCompany = false;

    fields
    {
        field(1; "Client ID"; Code[20])
        {
            Caption = 'Client ID';
            CharAllowed = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ+-';
            NotBlank = true;
        }
        field(2; "Client Password"; Text[50])
        {
            Caption = 'Client Password';
        }
        field(3; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(4; "Connection Timeout"; Integer)
        {
            Caption = 'Connection Timeout';
        }
    }

    keys
    {
        key(Key1; "Client ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

