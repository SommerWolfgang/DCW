table 6086492 "CEM Per Diem Dest. Inbox"
{
    Caption = 'Per Diem Detail Destination';

    fields
    {
        field(1; "Per Diem Inbox Entry No."; Integer)
        {
            Caption = 'Per Diem Inbox Entry No.';
        }
        field(2; "Per Diem Inbox Detail No."; Integer)
        {
            Caption = 'Per Diem Inbox Detail No.';
        }
        field(3; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            Editable = false;
        }
        field(10; "Destination Country/Region"; Code[10])
        {
            Caption = 'Destination Country/Region';
            TableRelation = "CEM Country/Region";
        }
        field(11; "Destination Name"; Text[50])
        {
            CalcFormula = Lookup ("CEM Country/Region".Name WHERE (Code = FIELD ("Destination Country/Region")));
            Caption = 'Destination Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(12; "Arrival Time"; Time)
        {
            Caption = 'Arrival Time';
        }
    }

    keys
    {
        key(Key1; "Per Diem Inbox Entry No.", "Per Diem Inbox Detail No.", "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Arrival Time")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        PerDiemDestiInbox: Record "CEM Per Diem Dest. Inbox";
    begin
        PerDiemDestiInbox.SetRange("Per Diem Inbox Entry No.", Rec."Per Diem Inbox Entry No.");
        PerDiemDestiInbox.SetRange("Per Diem Inbox Detail No.", Rec."Per Diem Inbox Detail No.");
        if PerDiemDestiInbox.FindLast then
            "Entry No." := PerDiemDestiInbox."Entry No." + 1
        else
            "Entry No." := 1;
    end;
}

