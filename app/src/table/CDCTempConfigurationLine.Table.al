table 6085612 "CDC Temp. Configuration Line"
{
    Caption = 'Temporary Configuration Line';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Table Name"; Text[50])
        {
            Caption = 'Table';
        }
        field(3; "Record Name"; Text[100])
        {
            Caption = 'Name';
        }
        field(4; Include; Boolean)
        {
            Caption = 'Include';
        }
        field(5; "Source Entry No."; Integer)
        {
            Caption = 'Source Entry No.';
        }
        field(6; Indentation; Integer)
        {
            Caption = 'Indentation';
        }
        field(7; Level; Integer)
        {
            Caption = 'Level';
        }
        field(8; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Has Children,Expanded,No Children';
            OptionMembers = "Has Children",Expanded,"No Children";
        }
        field(9; "Table No"; Integer)
        {
            Caption = 'Table No.';
        }
        field(10; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(11; "Record ID"; RecordID)
        {
            Caption = 'Record ID';
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

