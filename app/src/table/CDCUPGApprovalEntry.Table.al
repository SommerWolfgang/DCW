table 6086112 "CDC UPG Approval Entry"
{
    Caption = 'Approval Entry';

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
        field(6085576; "CDC Temp. Entry Type"; Option)
        {
            Caption = 'Temp. Entry Type';
            OptionCaption = 'Normal,Out of Office Sharing,Normal Sharing';
            OptionMembers = Normal,"Out of Office Sharing","Normal Sharing";
        }
        field(6085577; "CDC Temp. Display Sorting"; Integer)
        {
            Caption = 'Temp. Display Sorting';
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
        field(6085583; "CDC Forced Approval"; Boolean)
        {
            Caption = 'Forced Approval';
            Editable = false;
        }
        field(6085787; "CDC Delegated By User ID"; Code[50])
        {
            Caption = 'Delegated By User ID';
        }
        field(6085788; "CDC Delegated To User ID"; Code[50])
        {
            Caption = 'Delegated To User ID';
        }
        field(6085789; "CDC Remember Approver ID"; Code[50])
        {
            Caption = 'Remember Approver ID';
        }
        field(6085790; "CDC Advanced Approval"; Boolean)
        {
            Caption = 'Advanced Approval';
        }
        field(6085791; "CDC Source Name"; Text[100])
        {
            Caption = 'Source Name';
        }
        field(6085792; "CDC Source No."; Code[20])
        {
            Caption = 'Source No.';
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

