table 6085587 "CDC Templ. Field Cap. Suggest."
{
    Caption = 'Field Caption Suggestions';

    fields
    {
        field(1; "Template No."; Code[20])
        {
            Caption = 'Template No.';
            NotBlank = true;
            TableRelation = "CDC Template";
        }
        field(2; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Header,Line';
            OptionMembers = Header,Line;
            TableRelation = "CDC Template Field".Type WHERE("Template No." = FIELD("Template No."));
        }
        field(3; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
            TableRelation = "CDC Template Field".Code WHERE("Template No." = FIELD("Template No."),
                                                             Type = FIELD(Type));
        }
        field(4; "Search Caption"; Code[150])
        {
            Caption = 'Search Caption';
        }
        field(5; Caption; Text[250])
        {
            Caption = 'Caption';
        }
        field(6; "No. of Occurences"; Integer)
        {
            Caption = 'No. of Occurences';
        }
        field(7; Use; Boolean)
        {
            Caption = 'Use';
        }
    }

    keys
    {
        key(Key1; "Template No.", Type, "Code", "Search Caption")
        {
            Clustered = true;
        }
        key(Key2; "Template No.", Type, "Code", "No. of Occurences")
        {
        }
    }

    fieldgroups
    {
    }
}

