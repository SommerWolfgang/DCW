table 6085777 "CDC Std. Vend. Amt. Dist. Code"
{
    Caption = 'Standard Vendor Amount Distribution Code';

    fields
    {
        field(1; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            NotBlank = true;
            TableRelation = Vendor;
        }
        field(2; "Amount Distribution Code"; Code[10])
        {
            Caption = 'Amount Distribution Code';
            NotBlank = true;
        }
        field(3; "Vendor Name"; Text[100])
        {
            CalcFormula = Lookup(Vendor.Name WHERE("No." = FIELD("Vendor No.")));
            Caption = 'Vendor Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4; "Amount Distribution Desc."; Text[50])
        {
            CalcFormula = Lookup("CDC Std. Amt Distribution Code".Description WHERE(Code = FIELD("Amount Distribution Code")));
            Caption = 'Amount Distribution Description';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Vendor No.", "Amount Distribution Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

