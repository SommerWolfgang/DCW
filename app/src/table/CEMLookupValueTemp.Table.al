table 6086369 "CEM Lookup Value Temp"
{
    Caption = 'Lookup Value';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            Editable = false;
        }
        field(2; Value; Text[50])
        {
            Caption = 'Value';
            Editable = false;
        }
        field(3; Choose; Boolean)
        {
            Caption = 'Choose';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

