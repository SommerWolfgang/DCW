table 6086114 "CDC UPG Workflow Step Argument"
{
    Caption = 'Workflow Step Argument';

    fields
    {
        field(1; ID; Guid)
        {
            Caption = 'ID';
        }
        field(6085790; "CDC Advanced Approval"; Boolean)
        {
            Caption = 'Advanced Approval';
        }
    }

    keys
    {
        key(Key1; ID)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

