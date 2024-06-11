table 6086491 "CEM Per Diem Detail Dest."
{
    Caption = 'Per Diem Detail Destination';

    fields
    {
        field(1; "Per Diem Entry No."; Integer)
        {
            Caption = 'Per Diem Entry No.';
        }
        field(2; "Per Diem Detail Entry No."; Integer)
        {
            Caption = 'Per Diem Detail Entry No.';
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
            CalcFormula = lookup("CEM Country/Region".Name where(Code = field("Destination Country/Region")));
            Caption = 'Destination Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(12; "Arrival Time"; Time)
        {
            Caption = 'Arrival Time';

            trigger OnValidate()
            begin
                if xRec."Arrival Time" <> Rec."Arrival Time" then
                    CheckArrivalDates();
            end;
        }
    }

    keys
    {
        key(Key1; "Per Diem Entry No.", "Per Diem Detail Entry No.", "Entry No.")
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
        PerDiemDestination: Record "CEM Per Diem Detail Dest.";
    begin
        PerDiemDestination.SetRange("Per Diem Entry No.", Rec."Per Diem Entry No.");
        PerDiemDestination.SetRange("Per Diem Detail Entry No.", Rec."Per Diem Detail Entry No.");
        if PerDiemDestination.FindLast() then
            "Entry No." := PerDiemDestination."Entry No." + 1
        else
            "Entry No." := 1;

        CheckDepartureCountry();
        CheckArrivalDates();
    end;

    trigger OnModify()
    begin
        CheckArrivalDates();
    end;

    var
        [InDataSet]
        SkipSendToExpUser: Boolean;
        DestinationAfterTimeErr: Label '%1 cannot be after %2.';
        DestinationBeforeTimeErr: Label '%1 cannot be before %2.';
        SameArrivalTimeErr: Label 'You cannot have different destinations at the same %1.';

    local procedure CheckArrivalDates()
    var
        DetailDest: Record "CEM Per Diem Detail Dest.";
    begin
        if Rec."Entry No." = 0 then
            exit;

        DetailDest.SetRange("Per Diem Entry No.", Rec."Per Diem Entry No.");
        DetailDest.SetRange("Per Diem Detail Entry No.", Rec."Per Diem Detail Entry No.");
        DetailDest.SetFilter("Entry No.", '<>%1', Rec."Entry No.");
        DetailDest.SetRange("Arrival Time", Rec."Arrival Time");
        if not DetailDest.IsEmpty then
            Error(SameArrivalTimeErr, FieldCaption("Arrival Time"));

        DetailDest.SetRange("Per Diem Entry No.", Rec."Per Diem Entry No.");
        DetailDest.SetRange("Per Diem Detail Entry No.", Rec."Per Diem Detail Entry No.");
        DetailDest.SetFilter("Entry No.", '>%1', Rec."Entry No.");
        DetailDest.SetFilter("Arrival Time", '<=%1', Rec."Arrival Time");
        if DetailDest.FindFirst() then
            Error(DestinationBeforeTimeErr, FieldCaption("Arrival Time"), Format(DetailDest."Arrival Time"));

        DetailDest.SetRange("Per Diem Entry No.", Rec."Per Diem Entry No.");
        DetailDest.SetRange("Per Diem Detail Entry No.", Rec."Per Diem Detail Entry No.");
        DetailDest.SetFilter("Entry No.", '<%1', Rec."Entry No.");
        DetailDest.SetFilter("Arrival Time", '>=%1', Rec."Arrival Time");
        if DetailDest.FindFirst() then
            Error(DestinationAfterTimeErr, FieldCaption("Arrival Time"), Format(DetailDest."Arrival Time"));
    end;

    local procedure CheckDepartureCountry()
    var
        PerDiem: Record "CEM Per Diem";
    begin
        if PerDiem.Get(Rec."Per Diem Entry No.") then
            PerDiem.TestField("Departure Country/Region");
    end;
}

