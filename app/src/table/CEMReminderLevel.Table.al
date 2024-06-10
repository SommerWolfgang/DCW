table 6086318 "CEM Reminder Level"
{
    Caption = 'Expense Reminder Level';
    DataCaptionFields = "Reminder Terms Code";

    fields
    {
        field(1; "Reminder Terms Code"; Code[10])
        {
            Caption = 'Reminder Terms Code';
            NotBlank = true;
            TableRelation = "CEM Reminder Terms";
        }
        field(2; "No."; Integer)
        {
            Caption = 'No.';
            MinValue = 1;
            NotBlank = true;
        }
        field(3; "Grace Period"; DateFormula)
        {
            Caption = 'Grace Period';
        }
        field(10; "Reminder Text"; Text[50])
        {
            Caption = 'Reminder Text';
        }
    }

    keys
    {
        key(Key1; "Reminder Terms Code", "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

