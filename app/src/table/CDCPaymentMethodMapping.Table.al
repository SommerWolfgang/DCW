table 6085716 "CDC Payment Method Mapping"
{
    Caption = 'Payment Method Mapping';

    fields
    {
        field(1; "Card Type"; Code[10])
        {
            Caption = 'Card Type';
            NotBlank = true;
        }
        field(2; "Payment Method Code"; Code[10])
        {
            Caption = 'Payment Method Code';
            NotBlank = true;
            TableRelation = "Payment Method";
        }
    }

    keys
    {
        key(Key1; "Card Type")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

