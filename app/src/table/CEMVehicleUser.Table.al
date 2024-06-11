table 6086373 "CEM Vehicle User"
{
    Caption = 'Default Vehicle per User';
    DataCaptionFields = "Vehicle Code";

    fields
    {
        field(1; "Vehicle Code"; Code[20])
        {
            Caption = 'Vehicle Code';
            TableRelation = "CEM Vehicle";
        }
        field(2; "Continia User ID"; Code[50])
        {
            Caption = 'Continia User ID';
            TableRelation = "CDC Continia User Setup";
        }
        field(3; "Continia User Name"; Text[50])
        {
            CalcFormula = Lookup ("CDC Continia User".Name WHERE ("User ID" = FIELD ("Continia User ID")));
            Caption = 'Name';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Vehicle Code", "Continia User ID")
        {
            Clustered = true;
        }
        key(Key2; "Continia User ID")
        {
        }
    }

    fieldgroups
    {
    }
}

