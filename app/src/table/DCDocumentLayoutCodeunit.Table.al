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
            TableRelation = "DC - Document Layout Line"."Line No." where("Layout No." = field("Layout No."));
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; "Codeunit No."; Integer)
        {
            Caption = 'Codeunit No.';
        }
        field(5; "Codeunit Name"; Text[30])
        {
            CalcFormula = lookup(AllObjWithCaption."Object Name" where("Object Type" = const(Codeunit), "Object ID" = field("Codeunit No.")));
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
    procedure Caption(): Text[120]
    begin
    end;
}