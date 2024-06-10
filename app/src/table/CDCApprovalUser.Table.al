table 6085746 "CDC Approval User"
{
    Caption = 'Approval User';

    fields
    {
        field(1; "Approval Group Code"; Code[10])
        {
            Caption = 'Approval Group Code';
            NotBlank = true;
        }
        field(2; "User ID"; Code[50])
        {
            Caption = 'User ID';
            NotBlank = true;
        }
        field(3; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(16; "Approval Amount Limit"; Decimal)
        {
            BlankZero = true;
            Caption = 'Approval Amount Limit';
        }
    }

    keys
    {
        key(Key1; "Approval Group Code", "User ID", "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Approval Group Code", "Approval Amount Limit")
        {
        }
        key(Key3; "Approval Group Code", "User ID", "Approval Amount Limit")
        {
        }
    }
}