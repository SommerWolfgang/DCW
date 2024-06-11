table 12032004 "DC - Document Layout Criterion"
{
    // Copyright (Exclusive Rights): COSMO CONSULT Licensing GmbH, Sarnen, Switzerland
    // cc|document configurator (CCDC)

    Caption = 'Document Layout Criterion';

    fields
    {
        field(1; "Layout No."; Code[10])
        {
            Caption = 'Layout No.';
            NotBlank = true;
            TableRelation = "DC - Document Layout"."No.";
        }
        field(2; "Layout Line No."; Integer)
        {
            Caption = 'Layout Line No.';
            NotBlank = true;
            TableRelation = "DC - Document Layout Line"."Line No." WHERE("Layout No." = FIELD("Layout No."));
        }
        field(3; "Layout Field Line No."; Integer)
        {
            Caption = 'Layout Field Line No.';
            TableRelation = "DC - Document Layout Field"."Line No." WHERE("Layout No." = FIELD("Layout No."),
                                                                           "Layout Line No." = FIELD("Layout Line No."));
        }
        field(4; "Layout Variable Line No."; Integer)
        {
            Caption = 'Layout Variable Line No.';
            TableRelation = "DC - Document Layout Variable"."Line No." WHERE("Layout No." = FIELD("Layout No."),
                                                                              "Layout Line No." = FIELD("Layout Line No."));
        }
        field(5; "Layout Codeunit Line No."; Integer)
        {
            Caption = 'Layout Codeunit Line No.';
            TableRelation = "DC - Document Layout Codeunit"."Line No." WHERE("Layout No." = FIELD("Layout No."),
                                                                              "Layout Line No." = FIELD("Layout Line No."));
        }
        field(6; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(7; Decription; Text[50])
        {
            Caption = 'Decription';
        }
        field(8; "Table No."; Integer)
        {
            Caption = 'Table No.';

            trigger OnLookup()
            var
                ConfiguratorDocMng: Codeunit "DC - Management";
                ObjectID: Integer;
            begin
                ObjectID := ConfiguratorDocMng.LookupObject('T');

                if ObjectID <> 0 then
                    Validate("Table No.", ObjectID);
            end;

            trigger OnValidate()
            begin
                CalcFields("Table Name");
            end;
        }
        field(9; "Table Name"; Text[30])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Name" WHERE("Object Type" = CONST(Table),
                                                                        "Object ID" = FIELD("Table No.")));
            Caption = 'Table Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(10; "Validation Type"; Option)
        {
            Caption = 'Validation Type';
            OptionCaption = 'Exist,Not Exist,Count,Sum';
            OptionMembers = Exist,"Not Exist","Count","Sum";
        }
        field(11; "Sum Field No."; Integer)
        {
            Caption = 'Sum Field No.';

            trigger OnLookup()
            var
                ConfiguratorDocMng: Codeunit "DC - Management";
                FieldID: Integer;
            begin
                TestField("Table No.");

                FieldID := ConfiguratorDocMng.LookupField("Table No.");

                if FieldID <> 0 then
                    Validate("Sum Field No.", FieldID);
            end;

            trigger OnValidate()
            begin
                if "Sum Field No." <> 0 then
                    TestField("Validation Type", "Validation Type"::Count);

                CalcFields("Sum Field Name");
            end;
        }
        field(12; "Sum Field Name"; Text[30])
        {
            CalcFormula = Lookup(Field.FieldName WHERE(TableNo = FIELD("Table No."),
                                                        "No." = FIELD("Sum Field No.")));
            Caption = 'Sum Field Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(13; "Min Value"; Integer)
        {
            Caption = 'Min Value';
        }
        field(14; "Max Value"; Integer)
        {
            Caption = 'Max Value';
        }
    }

    keys
    {
        key(Key1; "Layout No.", "Layout Line No.", "Layout Field Line No.", "Layout Variable Line No.", "Layout Codeunit Line No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        DocumentLayoutFilter: Record "DC - Document Layout Filter";
        DocConfMng: Codeunit "DC - Management";
    begin
        DocConfMng.OnDeleteCode("Layout No.");

        DocumentLayoutFilter.SetRange("Layout No.", "Layout No.");
        DocumentLayoutFilter.SetRange("Layout Line No.", "Layout Line No.");
        DocumentLayoutFilter.SetRange("Layout Criteria Line No.", "Line No.");
        DocumentLayoutFilter.SetRange("Layout Field Line No.", "Layout Field Line No.");
        DocumentLayoutFilter.SetRange("Layout Variable Line No.", "Layout Variable Line No.");
        DocumentLayoutFilter.SetRange("Layout Codeunit Line No.", "Layout Codeunit Line No.");
        DocumentLayoutFilter.DeleteAll(true);
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

