table 6086238 "CTS-CDN Reg. Comment"
{
    Caption = 'Registration Comments';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
            Editable = false;
        }
        field(2; Comment; Text[250])
        {
            Caption = 'Comment';
        }
        field(3; Created; DateTime)
        {
            Caption = 'Created Date-Time';
        }
        field(10; "Participation GUID"; Guid)
        {
            Caption = 'Participation';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Participation GUID", Created)
        {
        }
    }

    fieldgroups
    {
    }
}

