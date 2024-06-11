table 6086113 "CDC UPG Posted Appr. Entry"
{
    Caption = 'Posted Approval Entry';

    fields
    {
        field(29; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
        }
        field(6085573; "CDC Amount Incl. VAT"; Decimal)
        {
            Caption = 'Amount Incl. VAT';
        }
        field(6085574; "CDC Amount Incl. VAT (LCY)"; Decimal)
        {
            Caption = 'Amount Incl. VAT (LCY)';
        }
        field(6085575; "CDC Original Approver ID"; Code[50])
        {
            Caption = 'Original Approver ID';
        }
        field(6085578; "CDC Reminder Level"; Integer)
        {
            Caption = 'Reminder Level';
        }
        field(6085579; "CDC Version No."; Integer)
        {
            Caption = 'Version No.';
        }
        field(6085580; "CDC Doc. No. Occurrence"; Integer)
        {
            Caption = 'Doc. No. Occurrence';
        }
        field(6085581; "CDC Approved using Pms. of"; Option)
        {
            Caption = 'Approved using Permissions';
            OptionCaption = 'Own,Owner,Both owner and own';
            OptionMembers = Approver,Owner,"Both Approver and Owner";
        }
        field(6085582; "CDC Owner Approver ID"; Code[50])
        {
            Caption = 'Owner Approver ID';
        }
        field(6085790; "CDC Advanced Approval"; Boolean)
        {
            Caption = 'Advanced Approval';
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

