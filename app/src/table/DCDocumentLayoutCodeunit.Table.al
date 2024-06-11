table 12032007 "DC - Document Layout Codeunit"
{
    // Copyright (Exclusive Rights): COSMO CONSULT Licensing GmbH, Sarnen, Switzerland
    // cc|document configurator (CCDC)

    Caption = 'Document Layout Codeunit';

    fields
    {
        field(1; "Layout No."; Code[10])
        {
            Caption = 'Layout No.';
            TableRelation = "DC - Document Layout"."No.";
        }
        field(2; "Layout Line No."; Integer)
        {
            Caption = 'Layout Line No.';
            TableRelation = "DC - Document Layout Line"."Line No." WHERE("Layout No." = FIELD("Layout No."));
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; "Codeunit No."; Integer)
        {
            Caption = 'Codeunit No.';

            trigger OnLookup()
            var
                ConfiguratorDocMng: Codeunit "DC - Management";
                ObjectID: Integer;
            begin
                ObjectID := ConfiguratorDocMng.LookupObject('C');

                if ObjectID <> 0 then
                    Validate("Codeunit No.", ObjectID);
            end;

            trigger OnValidate()
            begin
                CalcFields("Codeunit Name");
            end;
        }
        field(5; "Codeunit Name"; Text[30])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Name" WHERE("Object Type" = CONST(Codeunit),
                                                                        "Object ID" = FIELD("Codeunit No.")));
            Caption = 'Codeunit Name';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Layout No.", "Layout Line No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        DocumentLayoutCriteria: Record "DC - Document Layout Criterion";
        DocumentLayoutFilter: Record "DC - Document Layout Filter";
        DocConfMng: Codeunit "DC - Management";
    begin
        DocConfMng.OnDeleteCode("Layout No.");

        DocumentLayoutFilter.SetRange("Layout No.", "Layout No.");
        DocumentLayoutFilter.SetRange("Layout Line No.", "Layout Line No.");
        DocumentLayoutFilter.SetRange("Layout Field Line No.", 0);
        DocumentLayoutFilter.SetRange("Layout Variable Line No.", 0);
        DocumentLayoutFilter.SetRange("Layout Codeunit Line No.", "Line No.");
        DocumentLayoutFilter.DeleteAll(true);

        DocumentLayoutCriteria.SetRange("Layout No.", "Layout No.");
        DocumentLayoutCriteria.SetRange("Layout Line No.", "Layout Line No.");
        DocumentLayoutCriteria.SetRange("Layout Field Line No.", 0);
        DocumentLayoutCriteria.SetRange("Layout Variable Line No.", 0);
        DocumentLayoutCriteria.SetRange("Layout Codeunit Line No.", "Line No.");
        DocumentLayoutCriteria.DeleteAll(true);
    end;

    trigger OnInsert()
    var
        DocConfMng: Codeunit "DC - Management";
    begin
        DocConfMng.OnInsertCode("Layout No.");
    end;

    trigger OnModify()
    var
        DocConfMng: Codeunit "DC - Management";
    begin
        DocConfMng.OnModifyCode("Layout No.");
    end;


    procedure Caption(): Text[120]
    var
        DocumentLayoutLine: Record "DC - Document Layout Line";
    begin
        if GetFilters = '' then
            exit('');

        if not DocumentLayoutLine.Get("Layout No.", "Layout Line No.") then
            exit('');

        exit(StrSubstNo('%1 %2', "Layout No.", DocumentLayoutLine.Description));
    end;
}

