table 6085751 "CDC Approval Group Dimension"
{
    Caption = 'Approval Group Dimension';

    fields
    {
        field(1; "Approval Group Code"; Code[10])
        {
            Caption = 'Approval Group Code';
            NotBlank = true;
            TableRelation = "CDC Approval Group";
        }
        field(2; "Dimension Code"; Code[20])
        {
            Caption = 'Dimension Code';
            NotBlank = true;
            TableRelation = Dimension;
        }
        field(3; Mandatory; Boolean)
        {
            Caption = 'Mandatory';
        }
    }

    keys
    {
        key(Key1; "Approval Group Code", "Dimension Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

