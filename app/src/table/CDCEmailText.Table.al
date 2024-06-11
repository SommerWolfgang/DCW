table 6085737 "CDC E-mail Text"
{
    Caption = 'Email Text';

    fields
    {
        field(1; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Approval Reminder Email Setup';
            OptionMembers = "Approval Reminder E-Mail Setup";
        }
        field(2; "Reminder Level"; Integer)
        {
            Caption = 'Reminder Level';
            MinValue = 1;
            NotBlank = true;
            TableRelation = if (Type = const("Approval Reminder E-Mail Setup")) "CDC App. Reminder E-Mail Setup";
        }
        field(3; Position; Option)
        {
            Caption = 'Position';
            OptionCaption = 'Beginning,Ending';
            OptionMembers = Beginning,Ending;
        }
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(5; Text; Text[100])
        {
            Caption = 'Text';
        }
        field(6; Bold; Boolean)
        {
            Caption = 'Bold';
        }
    }

    keys
    {
        key(Key1; Type, "Reminder Level", Position, "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

