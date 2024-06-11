table 6085583 "CDC Template Field Rule"
{
    Caption = 'Field Rule';

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
        field(5; Rule; Text[250])
        {
            Caption = 'Rule';
            NotBlank = true;

            trigger OnLookup()
            var
                Template: Record "CDC Template";
                MasterTemplate: Record "CDC Template";
                TemplateFilter: Text[1024];
                FieldRule: Record "CDC Template Field Rule";
            begin
                Template.Get("Template No.");

                MasterTemplate.SetCurrentKey("Category Code", Type);
                MasterTemplate.SetRange("Category Code", Template."Category Code");
                MasterTemplate.SetRange(Type, MasterTemplate.Type::Master);
                MasterTemplate.SetRange("Data Type", Template."Data Type");
                if Template."Data Type" = Template."Data Type"::XML then
                    MasterTemplate.SetRange("XML Ident. Template No.", Template."XML Ident. Template No.");
                if MasterTemplate.FindSet then
                    repeat
                        if TemplateFilter = '' then
                            TemplateFilter := MasterTemplate."No."
                        else
                            TemplateFilter := TemplateFilter + '|' + MasterTemplate."No.";
                    until MasterTemplate.Next = 0;

                FieldRule.SetRange("Template No.", Template."No.");
                FieldRule.SetFilter("Template No.", TemplateFilter);
                FieldRule.SetRange(Type, Type);
                FieldRule.SetRange(Code, Code);

                if PAGE.RunModal(0, FieldRule) = ACTION::LookupOK then begin
                    if ("Template No." <> FieldRule."Template No.") or (Rule = '') then begin
                        Rule := FieldRule.Rule;
                        Description := FieldRule.Description;
                    end;
                end;
            end;
        }
        field(6; Description; Text[200])
        {
            Caption = 'Description';
        }
        field(7; "Created from Master Template"; Boolean)
        {
            Caption = 'Created from Master Template';
        }
        field(8; "Document No."; Code[20])
        {
            Caption = 'Document No.';
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

