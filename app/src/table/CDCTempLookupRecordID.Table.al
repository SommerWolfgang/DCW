table 6085760 "CDC Temp. Lookup Record ID"
{
    Caption = 'Temp. Lookup Record ID';

    fields
    {
        field(1; "Record ID Tree ID"; Integer)
        {
            Caption = 'Record ID Tree ID';
            TableRelation = "CDC Record ID Tree";
        }
        field(2; "Table No."; Integer)
        {
            Caption = 'Table No.';
        }
        field(3; "Lookup Mode"; Option)
        {
            Caption = 'Lookup Mode';
            OptionCaption = ' ,OK,Cancel';
            OptionMembers = " ",OK,Cancel;
        }
        field(4; "Table Filter GUID"; Guid)
        {
            Caption = 'Table Filter GUID';
        }
        field(5; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(6; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
    }

    keys
    {
        key(Key1; "Record ID Tree ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

