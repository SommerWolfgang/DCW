table 6085582 "CDC Template Field Transl."
{
    Caption = 'Field Translation';

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
            TableRelation = "CDC Template Field".Type WHERE ("Template No." = FIELD ("Template No."));
            ValidateTableRelation = false;
        }
        field(3; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
            TableRelation = "CDC Template Field".Code WHERE ("Template No." = FIELD ("Template No."),
                                                             Type = FIELD (Type));
        }
        field(4; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(5; "Translate From"; Text[250])
        {
            Caption = 'Translate From';
        }
        field(6; "Translate To"; Text[250])
        {
            Caption = 'Translate To';
        }
        field(7; "Case-sensitive"; Boolean)
        {
            Caption = 'Case-sensitive';
        }
    }

    keys
    {
        key(Key1; "Template No.", Type, "Code", "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

