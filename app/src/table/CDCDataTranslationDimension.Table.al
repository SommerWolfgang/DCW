table 6085586 "CDC Data Translation Dimension"
{
    Caption = 'Data Translation Dimension';

    fields
    {
        field(1; "Template No."; Code[20])
        {
            Caption = 'Template No.';
            NotBlank = true;
        }
        field(2; "Field Type"; Option)
        {
            Caption = 'Field Type';
            OptionCaption = 'Header Field,Line Field';
            OptionMembers = "Header Field","Line Field";
        }
        field(3; "Field Code"; Code[20])
        {
            Caption = 'Field Code';
            NotBlank = true;
            TableRelation = "CDC Template Field".Code WHERE("Template No." = FIELD("Template No."),
                                                             Type = FIELD("Field Type"));
        }
        field(4; "Translate From"; Code[150])
        {
            Caption = 'Translate From';
            TableRelation = "CDC Data Translation"."Translate From" WHERE("Template No." = FIELD("Template No."),
                                                                           Type = FIELD("Field Type"),
                                                                           "Field Code" = FIELD("Field Code"));
        }
        field(5; "Dimension Code"; Code[20])
        {
            Caption = 'Dimension Code';
            NotBlank = true;
            TableRelation = Dimension;
        }
        field(6; "Dimension Value Code"; Code[20])
        {
            Caption = 'Dimension Value Code';
            NotBlank = true;
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = FIELD("Dimension Code"));
        }
    }

    keys
    {
        key(Key1; "Template No.", "Field Type", "Field Code", "Translate From", "Dimension Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

