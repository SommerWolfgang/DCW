table 6086366 "CEM Mileage Rate ID"
{
    Caption = 'Mileage Rate ID';
    DataCaptionFields = "Rate ID";
    LookupPageID = "CEM Mileage Rate ID";

    fields
    {
        field(1; "Rate ID"; Code[10])
        {
            Caption = 'Rate ID';
        }
        field(10; Description; Text[50])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(Key1; "Rate ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        MileageDetails: Record "CEM Mileage Detail";
        MileageRates: Record "CEM Mileage Rate";
    begin
        MileageDetails.SetRange("Rate ID", "Rate ID");
        MileageDetails.SetRange(Posted, true);
        if not MileageDetails.IsEmpty then
            Error(ErrRateUsed);

        MileageRates.SetRange("Rate ID", "Rate ID");
        MileageRates.DeleteAll(true);
    end;

    trigger OnRename()
    var
        MileageDetails: Record "CEM Mileage Detail";
    begin
        MileageDetails.SetRange("Rate ID", xRec."Rate ID");
        MileageDetails.SetRange(Posted, true);
        if not MileageDetails.IsEmpty then
            Error(ErrRateUsed);
    end;

    var
        ErrRateUsed: Label 'The rate cannot be changed because there are one or more mileage entries.';
}

