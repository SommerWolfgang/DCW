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
            TableRelation = "DC - Document Layout Line"."Line No." where("Layout No." = field("Layout No."));
        }
        field(3; "Layout Field Line No."; Integer)
        {
            Caption = 'Layout Field Line No.';
            TableRelation = "DC - Document Layout Field"."Line No." where("Layout No." = field("Layout No."),
                                                                           "Layout Line No." = field("Layout Line No."));
        }
        field(4; "Layout Variable Line No."; Integer)
        {
            Caption = 'Layout Variable Line No.';
            TableRelation = "DC - Document Layout Variable"."Line No." where("Layout No." = field("Layout No."),
                                                                              "Layout Line No." = field("Layout Line No."));
        }
        field(5; "Layout Codeunit Line No."; Integer)
        {
            Caption = 'Layout Codeunit Line No.';
            TableRelation = "DC - Document Layout Codeunit"."Line No." where("Layout No." = field("Layout No."),
                                                                              "Layout Line No." = field("Layout Line No."));
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
        }
        field(9; "Table Name"; Text[30])
        {
            CalcFormula = lookup(AllObjWithCaption."Object Name" where("Object Type" = const(Table), "Object ID" = field("Table No.")));
            Caption = 'Table Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(10; "Validation Type"; Option)
        {
            Caption = 'Validation Type';
            OptionCaption = 'Exist,Not Exist,Count,Sum';
            OptionMembers = _Exist,"Not Exist","Count","Sum";
        }
        field(11; "Sum Field No."; Integer)
        {
            Caption = 'Sum Field No.';
        }
        field(12; "Sum Field Name"; Text[30])
        {
            CalcFormula = lookup(Field.FieldName where(TableNo = field("Table No."), "No." = field("Sum Field No.")));
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
    procedure Caption(): Text[120]
    begin
    end;
}