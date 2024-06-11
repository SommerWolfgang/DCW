table 6085588 "CDC Template Search Text"
{
    Caption = 'Template Search Text';
    
    fields
    {
        field(1; "Template No."; Code[20])
        {
            Caption = 'Template No.';
            NotBlank = true;
            TableRelation = "CDC Template";
        }
        field(2; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(3; "Search Text"; Code[200])
        {
            Caption = 'Search Text';
            NotBlank = true;
        }
    }

    keys
    {
        key(Key1; "Template No.", "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

