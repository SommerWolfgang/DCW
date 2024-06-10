table 6085747 "CDC Temp. Dtld. App. Sum. Rel."
{
    Caption = 'Temp. Dtld. Approval Sum. Rel.';

    fields
    {
        field(1; "Sum Line Id"; Integer)
        {
            Caption = 'Sum Line ID';
        }
        field(2; "Approval Entry Line No."; Integer)
        {
            Caption = 'Approval Entry Line No.';
        }
    }

    keys
    {
        key(Key1; "Sum Line Id", "Approval Entry Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

