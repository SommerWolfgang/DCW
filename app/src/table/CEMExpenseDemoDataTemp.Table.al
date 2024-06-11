table 6086358 "CEM Expense Demo Data Temp"
{
    Caption = 'Expense Management Demo Data';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Table No."; Integer)
        {
            Caption = 'Table No.';
        }
        field(3; "Table Name"; Text[250])
        {
            Caption = 'Table Name';
        }
        field(4; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(5; Description; Text[250])
        {
            Caption = 'Description';
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

