table 6086317 "CEM Reminder Terms"
{
    Caption = 'Reminder Code';
    DataCaptionFields = "Code";

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(10; "Max No. of Reminders"; Integer)
        {
            Caption = 'Max No. of Reminders';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        ReminderLevels: Record "CEM Reminder Level";
    begin
        ReminderLevels.SetRange("Reminder Terms Code", Code);
        ReminderLevels.DeleteAll(true);
    end;

    trigger OnRename()
    var
        ContiniaUserSetup: Record "CDC Continia User Setup";
    begin
        ContiniaUserSetup.SetRange("Expense Reminder Code", xRec.Code);
        ContiniaUserSetup.ModifyAll("Expense Reminder Code", Code);
    end;
}

