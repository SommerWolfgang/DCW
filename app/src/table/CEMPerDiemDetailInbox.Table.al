table 6086391 "CEM Per Diem Detail Inbox"
{
    Caption = 'Per Diem Detail Inbox';

    fields
    {
        field(1; "Per Diem Inbox Entry No."; Integer)
        {
            Caption = 'Per Diem Inbox Entry No.';
            TableRelation = "CEM Per Diem";
        }
        field(2; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(3; Date; Date)
        {
            Caption = 'Date';
        }
        field(4; "Accommodation Allowance"; Boolean)
        {
            Caption = 'Accommodation Allowance';
        }
        field(5; Breakfast; Boolean)
        {
            Caption = 'Breakfast';
        }
        field(6; Lunch; Boolean)
        {
            Caption = 'Lunch';
        }
        field(7; Dinner; Boolean)
        {
            Caption = 'Dinner';
        }
        field(8; "Transport Allowance"; Boolean)
        {
            Caption = 'Transport Allowance';
        }
        field(9; "Entertainment Allowance"; Boolean)
        {
            Caption = 'Entertainment Allowance';
        }
        field(10; "Drinks Allowance"; Boolean)
        {
            Caption = 'Drinks Allowance';
        }
        field(12; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(13; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
        }
        field(14; "Admin Comment"; Text[250])
        {
            Caption = 'Admin Comment';
        }
    }

    keys
    {
        key(Key1; "Per Diem Inbox Entry No.", "Entry No.", Date)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Entry No." := GetEntryNo();
    end;


    procedure GetEntryNo(): Integer
    var
        PerDiemDetailsInbox: Record "CEM Per Diem Detail Inbox";
    begin
        Rec.TestField("Per Diem Inbox Entry No.");

        PerDiemDetailsInbox.SetRange("Per Diem Inbox Entry No.", "Per Diem Inbox Entry No.");
        if PerDiemDetailsInbox.FindLast() then
            exit(PerDiemDetailsInbox."Entry No." + 1)
        else
            exit(1);
    end;


    procedure GetDestinationTxt() DestinationTxt: Text[1024]
    var
        PerDiemDestInbox: Record "CEM Per Diem Dest. Inbox";
    begin
        PerDiemDestInbox.SetRange("Per Diem Inbox Entry No.", "Per Diem Inbox Entry No.");
        PerDiemDestInbox.SetRange("Per Diem Inbox Detail No.", "Entry No.");
        if PerDiemDestInbox.IsEmpty then
            exit('');

        PerDiemDestInbox.FindSet();
        repeat
            PerDiemDestInbox.CalcFields("Destination Name");
            if DestinationTxt <> '' then
                DestinationTxt += ',';

            DestinationTxt += PerDiemDestInbox."Destination Name";
        until PerDiemDestInbox.Next() = 0;
    end;


    procedure DrillDownDestinations()
    begin
    end;
}