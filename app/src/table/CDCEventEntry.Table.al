table 6085741 "CDC Event Entry"
{
    Caption = 'Event Entry';
    Permissions = TableData "CDC Event Entry" = rimd;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Information,Warning,Error';
            OptionMembers = Information,Warning,Error;
        }
        field(3; Comment; Text[80])
        {
            CalcFormula = lookup("CDC Event Entry Comment".Comment where("Event Entry No." = field("Entry No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4; "Creation Date"; Date)
        {
            Caption = 'Creation Date';
        }
        field(5; "Creation Time"; Time)
        {
            Caption = 'Creation Time';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; Type)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        EventEntryCmt: Record "CDC Event Entry Comment";
    begin
        EventEntryCmt.SetRange("Event Entry No.", "Entry No.");
        if not EventEntryCmt.IsEmpty then
            EventEntryCmt.DeleteAll(true);
    end;

    trigger OnInsert()
    var
        EventEntry: Record "CDC Event Entry";
    begin
        EventEntry.LockTable();
        if EventEntry.FindLast() then
            "Entry No." := EventEntry."Entry No." + 1
        else
            "Entry No." := 1;

        "Creation Date" := Today;
        "Creation Time" := Time;
    end;
}

