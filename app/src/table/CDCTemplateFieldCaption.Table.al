table 6085581 "CDC Template Field Caption"
{
    Caption = 'Field Caption';

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
            TableRelation = "CDC Template Field".Type where("Template No." = field("Template No."));
            ValidateTableRelation = false;
        }
        field(3; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
            TableRelation = "CDC Template Field".Code where("Template No." = field("Template No."),
                                                             Type = field(Type));
        }
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(5; Caption; Text[250])
        {
            Caption = 'Caption';

            trigger OnValidate()
            begin
                "Caption Length" := StrLen(Caption);
            end;
        }
        field(6; "Page No."; Integer)
        {
            Caption = 'Page No.';
        }
        field(7; Top; Integer)
        {
            Caption = 'Top';
        }
        field(8; Left; Integer)
        {
            Caption = 'Left';
        }
        field(9; DPI; Integer)
        {
            Caption = 'DPI';
        }
        field(10; "Caption Length"; Integer)
        {
            Caption = 'Caption Length';
        }
    }

    keys
    {
        key(Key1; "Template No.", Type, "Code", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Template No.", Type, "Code", "Caption Length")
        {
        }
    }

    fieldgroups
    {
    }
}

